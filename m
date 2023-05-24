Return-Path: <netdev+bounces-5175-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1F771002A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 23:48:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8DB6281404
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 21:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F04602263A;
	Wed, 24 May 2023 21:48:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E559E22637
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 21:48:13 +0000 (UTC)
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286E695
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:48:12 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-3382449dd00so10007735ab.3
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1684964891; x=1687556891;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NBV5PHTtpbBZe4bbuqXC9Gu8qrI/VNIBP+T4YK4DaUQ=;
        b=ZIpTpkjfjW4wqV3BAD9xEX3ZZayrRvHwjcY2OcvY1Hf9hBMG8xsoY9GNXKPF6wVMcN
         k1CDyU1Ajpu06PxrDcLGgEwQ2zcBFi404c119waM22gjRg5cCRC5mHyfyqcy+ohye8Zz
         fDTV+kMQSQzjdDvg4qLGnqE6ruznnnMs52mps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684964891; x=1687556891;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NBV5PHTtpbBZe4bbuqXC9Gu8qrI/VNIBP+T4YK4DaUQ=;
        b=fyE5+sNT+UL7qU6zja/o+mIB2imyla6dYshh4ShDW1x0Zyp9BvUozpiB2GbdJINNWU
         jDjYqu4WY9pUz8t8xbxQJHAyMASij7RFvhgEjwsznJ6oYUVg1ZoIJJ56BHcH8KU8dimp
         2dItF+Bm/pcPyZZbnBznFXqUGYX3juarULAxe9VGV6w9pTCavzLyzYnrIMa3RBMwHj9W
         yGLHqk6hnmfE6AClbFOZnct3g3R90CIeajcNGqzTbC8GKdxBosmOvqb0KAhlczDFfMus
         fQbzyqEZ8vjrvq7B8cEW7I6CLRa7ijRncakaGXZ5fdDtFF1rJeJ6FewBzVDs6F3HzenY
         /5Mg==
X-Gm-Message-State: AC+VfDw++kBgrAkmfDWdqft2ARUjRSdAQXR+TSXUNipvL3dlmRMFycWp
	mkYyw+8GQrqbISW8m/H+s56fl1lcwOplKE0eAX7KDw==
X-Google-Smtp-Source: ACHHUZ5ctPYAJZ6QGowF+OXltNPo+CJyPnQwXoRgbQo928NOIZ252JWI3NcrlzBICsonTLn7039VejnPvECMNBN4d7w=
X-Received: by 2002:a92:c947:0:b0:338:b798:75b2 with SMTP id
 i7-20020a92c947000000b00338b79875b2mr11792287ilq.26.1684964891401; Wed, 24
 May 2023 14:48:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1684878827-40672-1-git-send-email-justin.chen@broadcom.com>
 <1684878827-40672-3-git-send-email-justin.chen@broadcom.com>
 <20230523-unfailing-twisting-9cb092b14f6f@spud> <CALSSxFYMm5NYw41ERr1Ah-bejDgf9EdJd1dGNL9_sKVVmrpg3g@mail.gmail.com>
 <20230524-scientist-enviable-7bfff99431cc@wendy> <20230524-resample-dingbat-8a9f09ba76a5@wendy>
In-Reply-To: <20230524-resample-dingbat-8a9f09ba76a5@wendy>
From: Justin Chen <justin.chen@broadcom.com>
Date: Wed, 24 May 2023 14:47:59 -0700
Message-ID: <CALSSxFabgO-YTQ-nzki6h+Y=n3SfzgC4giJk8BySgCErK6zrmw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/6] dt-bindings: net: Brcm ASP 2.0 Ethernet controller
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Conor Dooley <conor@kernel.org>, netdev@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	bcm-kernel-feedback-list@broadcom.com, justinpopo6@gmail.com, 
	f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org, 
	krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com, andrew@lunn.ch, 
	hkallweit1@gmail.com, linux@armlinux.org.uk, richardcochran@gmail.com, 
	sumit.semwal@linaro.org, christian.koenig@amd.com, simon.horman@corigine.com, 
	Florian Fainelli <florian.fainelli@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000d3aadf05fc7775bf"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--000000000000d3aadf05fc7775bf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 23, 2023 at 11:56=E2=80=AFPM Conor Dooley
<conor.dooley@microchip.com> wrote:
>
> On Wed, May 24, 2023 at 07:51:07AM +0100, Conor Dooley wrote:
> > Hey Justin,
> > On Tue, May 23, 2023 at 04:27:12PM -0700, Justin Chen wrote:
> > > On Tue, May 23, 2023 at 3:55=E2=80=AFPM Conor Dooley <conor@kernel.or=
g> wrote:
> > > > On Tue, May 23, 2023 at 02:53:43PM -0700, Justin Chen wrote:
> > > >
> > > > > +  compatible:
> > > > > +    enum:
> > > > > +      - brcm,asp-v2.0
> > > > > +      - brcm,bcm72165-asp
> > > > > +      - brcm,asp-v2.1
> > > > > +      - brcm,bcm74165-asp
> > > >
> > > > > +        compatible =3D "brcm,bcm72165-asp", "brcm,asp-v2.0";
> > > >
> > > > You can't do this, as Rob's bot has pointed out. Please test the
> > > > bindings :( You need one of these type of constructs:
> > > >
> > > > compatible:
> > > >   oneOf:
> > > >     - items:
> > > >         - const: brcm,bcm72165-asp
> > > >         - const: brcm,asp-v2.0
> > > >     - items:
> > > >         - const: brcm,bcm74165-asp
> > > >         - const: brcm,asp-v2.1
> > > >
> > > > Although, given either you or Florian said there are likely to be
> > > > multiple parts, going for an enum, rather than const for the brcm,b=
cm..
> > > > entry will prevent some churn. Up to you.
> > > >
> > > Urg so close. Thought it was a trivial change, so didn't bother
> > > retesting the binding. I think I have it right now...
> > >
> > >   compatible:
> > >     oneOf:
> > >       - items:
> > >           - enum:
> > >               - brcm,bcm72165-asp
> > >               - brcm,bcm74165-asp
> > >           - enum:
> > >               - brcm,asp-v2.0
> > >               - brcm,asp-v2.1
> > >
> > > Something like this look good?
> >
> > I am still caffeine-less, but this implies that both of
> > "brcm,bcm72165-asp", "brcm,asp-v2.0"
> > _and_
> > "brcm,bcm72165-asp", "brcm,asp-v2.1"
> > are. I suspect that that is not the case, unless "brcm,asp-v2.0" is a
>
> I a word. s/are/are valid/
>
Gotcha. I got something like this now.

  compatible:
    oneOf:
      - items:
          - enum:
              - brcm,bcm74165-asp
          - const: brcm,asp-v2.1
      - items:
          - enum:
              - brcm,bcm72165-asp
          - const: brcm,asp-v2.0

Apologies, still getting used to this yaml stuff. Starting to make a
bit more sense to me now.

> > valid fallback for "brcm,asp-v2.1"?
> > The oneOf: also becomes redundant since you only have one items:.
> >
> > > Will submit a v5 tomorrow.
> >
> > BTW, when you do, could you use the address listed in MAINTAINERS rathe=
r
> > than the one you used for this version?
> >
I changed the address listed in MAINTAINERS from the previous versions
of this patchset. The current version should match the address that
this patch set was sent from. Looks like I forgot to add a changelog
for that in v4.

Thanks,
Justin

> > Cheers,
> > Conor.

--000000000000d3aadf05fc7775bf
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
NhTY3E+cXCB11wty89QStajwXdhGJTYEvUgvsq1h8CwJj9w/38ldAQf5WjhPmApYeJR2ewFrBMCM
4lHkdRJ6TDc9nXoEkypUfjJkJHe7Eal06tosh6JpAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGGp1c3Rpbi5jaGVuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUIWGeYuaTsnIada5Xx8TR3cheUbgw
DQYJKoZIhvcNAQELBQADggEBAHNQlMqQOFYPYFO71A+8t+qWMmtOdd2iGswSOvpSZ/pmGlfw8ZvY
dRTkl27m37la84AxRkiVMes14JyOZJoMh/g7fbgPlU14eBc6WQWkIA6AmNkduFWTr1pRezkjpeo6
xVmdBLM4VY1TFDYj7S8H2adPuypd62uHMY/MZi+BIUys4uAFA+N3NuUBNjcVZXYPplYxxKEuIFq6
sDL+OV16G+F9CkNMN3txsym8Nnx5WAYZb6+rBUIhMGz70V05xsHQfzvo2s7f0J1tJ5BoRlPPhL0h
VOnWA3h71u9TfSsv+PXVm3P21TfOS2uc1hbzEqyENCP4i5XQ0rv0TmPW42GZ0o4xggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwj8BKLXNpALfemdRAwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEVxd0USbzKCxw0JWT0RfyXJdJROyZoskPKM
zuqIU3fLMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDUyNDIx
NDgxMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQCj1WRGbBY0Z8TEIAsfwNErbFsPcusguDsK/eDcNkwOi4BxZKCjzwzp
u8FA6pXtoxyMENgO1XMyEVyrxc8iOSC1VmyzVya6vBoyLu+ROH2peEMSLqzI2/hHgyAbM4SDPOyl
TZp1ViIGg0ogd6yLlXYO51KUoIRnL5wkxcdx++OO/DOBelZTrPpoo0sV1C4pZ3dKcnyClti+8pzp
8TnHvxGDO1QJuiX5zuAa7Tw/ZiMg05MZmtVP6iddzMpfYnANmSz4sGAbTlVSem5ltVY4M7aCQxQZ
Ifxf++qTA9XIS5MV/OnufhRtFxBLpA/f1oC/rWf/F84h+hrTALZ9nqSerKn4
--000000000000d3aadf05fc7775bf--

