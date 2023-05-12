Return-Path: <netdev+bounces-2065-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2828970027E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2375281974
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC8789456;
	Fri, 12 May 2023 08:28:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B8A259A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:28:52 +0000 (UTC)
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E511154A;
	Fri, 12 May 2023 01:28:41 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2ac770a99e2so103589141fa.3;
        Fri, 12 May 2023 01:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683880119; x=1686472119;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h0STyvDKOt/jPA6CkWmo5ah+D/XtsYoBFrU3Alj5ZsU=;
        b=EFXVT/a30g4w+NUlOkvBYSmMYZuq+2UkSXSY7L5VI9FXK9h6p9sebFV1ZG1n9iAdRo
         TE2TV5vJYHPQv601eshefRx655Pm8ALANm+hIPOzlm/A4ndvayojYfATi8NRrY2f+FSH
         GqoGt18ApNwKW/Wf7YMBhyBFe5+Fe1mIFLoD3TyqDJPdRPjcuF5YAbpvI/sXWv1iEYjI
         tZdfRX7ArJcMrNr3rqZ3OFOlaB8HvZqJEa4Sw53nwwSTBiVQIe43Bh1SIp2IMzaZBHQO
         LeoJ/qvyOspp90dSrlC67d5gCtDbvEFFwR8TfNVNaGDb39JV5w5Jj48XPk1XEnlBmiX8
         YQ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683880119; x=1686472119;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h0STyvDKOt/jPA6CkWmo5ah+D/XtsYoBFrU3Alj5ZsU=;
        b=gzmKGew0M0+tt54OkODf7pfniomrLzNj4JSvZ5/vGJL4t4I7MQDHnJlAbdTTGoEha8
         re5sXuPXl+fIXRI8wym4wN2DoxHKS7a85HR8qNZauUnzW/hZgGSoTvQbGGTFMgnh9n86
         1U4/q/FJMrWPNGsBWmOhlfxrFxvCTxkIxoARWQFE3lJ12Of/iIubTxoGueOFFeB+cxKo
         DQUdsOnu2zHatC8f7yrz/Jzaq9MxmcoEJ/6IXLf1prhhTy+inMxaYpsWBhtDcP6rQfq0
         UEm5ulMswOW00mQDE+Fi9OL+tRGYsJtV0tUs09giPdh0vAth6Mo8VevGZLKlGqnXKCFd
         mD/A==
X-Gm-Message-State: AC+VfDzJRYENvB+NdHQ4eziMx5oz2X2UM+PlgDu1eIo1ozC0S46y2xMs
	qhvUHF6QhhdllmhgSxOG7H0=
X-Google-Smtp-Source: ACHHUZ6vsL+DKF6BXISXrfmfcFw38us7u5JV3h9YJmohdhzUI31GzrrgI9YuuOkIONqSb4FxiCgvFw==
X-Received: by 2002:a2e:9942:0:b0:2ad:8f4a:4ed5 with SMTP id r2-20020a2e9942000000b002ad8f4a4ed5mr3646719ljj.37.1683880119229;
        Fri, 12 May 2023 01:28:39 -0700 (PDT)
Received: from [100.119.7.139] (95-31-186-77.broadband.corbina.ru. [95.31.186.77])
        by smtp.gmail.com with ESMTPSA id y23-20020a05651c021700b002a8b9570403sm2720044ljn.31.2023.05.12.01.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 01:28:38 -0700 (PDT)
Message-ID: <be85bef7e144ebe08f422bf53bb81b59a130cb29.camel@gmail.com>
Subject: Re: [PATCH v2 3/5] dt-bindings: net: add mac-address-increment
 option
From: Ivan Mikhaylov <fr0st61te@gmail.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Samuel
 Mendoza-Jonas <sam@mendozajonas.com>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rob Herring
 <robh+dt@kernel.org>, Krzysztof Kozlowski
 <krzysztof.kozlowski+dt@linaro.org>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org, Paul Fertser
	 <fercerpav@gmail.com>
Date: Fri, 12 May 2023 11:28:37 +0000
In-Reply-To: <8de01e81-43dc-71af-f56f-4fba957b0b0b@linaro.org>
References: <20230509143504.30382-1-fr0st61te@gmail.com>
	 <20230509143504.30382-4-fr0st61te@gmail.com>
	 <6b5be71e-141e-c02a-8cba-a528264b26c2@linaro.org>
	 <fc3dae42f2dfdf046664d964bae560ff6bb32f69.camel@gmail.com>
	 <8de01e81-43dc-71af-f56f-4fba957b0b0b@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 2023-05-12 at 08:22 +0200, Krzysztof Kozlowski wrote:
> On 11/05/2023 01:31, Ivan Mikhaylov wrote:
> > On Wed, 2023-05-10 at 16:48 +0200, Krzysztof Kozlowski wrote:
> > > On 09/05/2023 16:35, Ivan Mikhaylov wrote:
> > > > Add the mac-address-increment option for specify MAC address
> > > > taken
> > > > by
> > > > any other sources.
> > > >=20
> > > > Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> > > > Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
> > > > ---
> > > > =C2=A0.../devicetree/bindings/net/ethernet-controller.yaml=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 8
> > > > ++++++++
> > > > =C2=A01 file changed, 8 insertions(+)
> > > >=20
> > > > diff --git a/Documentation/devicetree/bindings/net/ethernet-
> > > > controller.yaml
> > > > b/Documentation/devicetree/bindings/net/ethernet-
> > > > controller.yaml
> > > > index 00be387984ac..6900098c5105 100644
> > > > --- a/Documentation/devicetree/bindings/net/ethernet-
> > > > controller.yaml
> > > > +++ b/Documentation/devicetree/bindings/net/ethernet-
> > > > controller.yaml
> > > > @@ -34,6 +34,14 @@ properties:
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 minItems: 6
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 maxItems: 6
> > > > =C2=A0
> > > > +=C2=A0 mac-address-increment:
> > > > +=C2=A0=C2=A0=C2=A0 $ref: /schemas/types.yaml#/definitions/int32
> > > > +=C2=A0=C2=A0=C2=A0 description:
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Specifies the MAC address increment=
 to be added to the
> > > > MAC
> > > > address.
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Should be used in cases when there =
is a need to use MAC
> > > > address
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 different from one obtained by any =
other level, like u-
> > > > boot
> > > > or the
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 NC-SI stack.
> > >=20
> > > We don't store MAC addresses in DT, but provide simple
> > > placeholder
> > > for
> > > firmware or bootloader. Why shall we store static "increment"
> > > part of
> > > MAC address? Can't the firmware give you proper MAC address?
> > >=20
> > > Best regards,
> > > Krzysztof
> > >=20
> >=20
> > Krzysztof, maybe that's a point to make commit message with better
> > explanation from my side. At current time there is at least two
> > cases
> > where I see it's possible to be used:
> >=20
> > 1. NC-SI
> > 2. embedded
> >=20
> > At NC-SI level there is Get Mac Address command which provides to
> > BMC
> > mac address from the host which is same as host mac address, it
> > happens
> > at runtime and overrides old one.
> >=20
> > Also, this part was also to be discussed 2 years ago in this
> > thread:
> > https://lore.kernel.org/all/OF8E108F72.39D22E89-ON00258765.001E46EB-002=
58765.00251157@ibm.com/
>=20
> Which was not sent to Rob though...
>=20
>=20
> >=20
> > Where Milton provided this information:
> >=20
> > DTMF spec DSP0222 NC-SI (network controller sideband interface)
> > is a method to provide a BMC (Baseboard management controller)
> > shared
> > access to an external ethernet port for comunication to the
> > management
> > network in the outside world.=C2=A0 The protocol describes ethernet
> > packets=20
> > that control selective bridging implemented in a host network
> > controller
> > to share its phy.=C2=A0 Various NIC OEMs have added a query to find out
> > the=20
> > address the host is using, and some vendors have added code to
> > query
> > host
> > nic and set the BMC mac to a fixed offset (current hard coded +1
> > from
> > the host value).=C2=A0 If this is compiled in the kernel, the NIC OEM i=
s
> > recognised and the BMC doesn't miss the NIC response the address is
> > set
> > once each time the NCSI stack reinitializes.=C2=A0 This mechanism
> > overrides
> > any mac-address or local-mac-address or other assignment.
> >=20
> > DSP0222
> > https://www.dmtf.org/documents/pmci/network-controller-sideband-interfa=
ce-nc-si-specification-110
> >=20
> >=20
> > In embedded case, sometimes you have different multiple ethernet
> > interfaces which using one mac address which increments or
> > decrements
> > for particular interface, just for better explanation, there is
> > patch
> > with explanation which providing them such way of work:
> > https://github.com/openwrt/openwrt/blob/master/target/linux/generic/pen=
ding-5.15/682-of_net-add-mac-address-increment-support.patch
> >=20
> > In their rep a lot of dts using such option.
>=20
> None of these explain why this is property of the hardware. I
> understand
> that this is something you want Linux to do, but DT is not for that
> purpose. Do not encode system policies into DT and what above commit
> says is a policy.
>=20

Krzysztof, okay then to which DT subsystem it should belong? To
ftgmac100 after conversion?

Thanks.

