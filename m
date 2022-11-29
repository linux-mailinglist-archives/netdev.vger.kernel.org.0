Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705EA63B79B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 03:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbiK2CBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 21:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234642AbiK2CBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 21:01:40 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C6945ECC
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 18:01:31 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id h33so6693282pgm.9
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 18:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yv++sDehfnw4z57gw+pmXFq+c1ZUrhVQF/PC1pbU5CQ=;
        b=EAT3IDENhlpE9pm2g13/FkIyzjdwgB5pw+xp0acCgzEkHH9WE4GYSVLF/woqbx8Z/+
         opI3jQdcwC7J+Koy3cJLEZyH2/bkIrlYNzcq5lJlW8uhcBdqkwheKhPqfomnB9uNMGyE
         oybOc1mLPXF0zvauJ8R/aqdjfKDzPn1YS34u8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yv++sDehfnw4z57gw+pmXFq+c1ZUrhVQF/PC1pbU5CQ=;
        b=TnxcMzJ7jc/sCkvwXMNV+bwqjy5GJF4ooyOGdjyATrl8zFLI2nzRyM8WKlmNJyu0lN
         XePTVNZ2RjJXW7cgDGxLyvriciBrlVhGoFJ0+vVBkp10I+4ssTulSgZgD8dZ5gNDLtuX
         ikmPK+GClSjwLpuE6ioNNpRixZqHMlkTI7H/t+Pw89bK2KRmA0QN05KDK0WgL6GqocsR
         hX1IUXqsIsahjwIrhbvCVJ3DRCY6iqAddbmuS9jnbIP6JL4NKH+Ggl0rSbJ0Vp0taNQz
         EkD5cJsx9LyGtTweq0cS1RdHXTz4CvqEddvKcRLS50/aVNO14XIYMBg2uIwIqCwTxvqg
         jpeA==
X-Gm-Message-State: ANoB5plYqVFfybubIUH+ByEPr7Qbo6MNJuyHRFINjG1POHg+9qMRIfsh
        A3bEIT0m4bkvuCNie9k9S/EeVPrUP+YcaZD89xFFSw==
X-Google-Smtp-Source: AA0mqf4kHFYuve9GHCpZOYV5jjA8DpsSuzsHzn1ym7iS3vwdz5x85/8i66Or8PzH71ksj5sZFADOkYBR/kz+lbuEI5c=
X-Received: by 2002:a63:703:0:b0:477:cb54:7174 with SMTP id
 3-20020a630703000000b00477cb547174mr21934746pgh.358.1669687291063; Mon, 28
 Nov 2022 18:01:31 -0800 (PST)
MIME-Version: 1.0
References: <20221109184244.7032-1-ajit.khaparde@broadcom.com>
 <Y2zYPOUKgoArq7mM@unreal> <CACZ4nhu_2FoOTmXPuq+amRYAipusq1XcobavytN0cFK=TSE5mQ@mail.gmail.com>
 <Y3Tj/BrskSJPuTFw@unreal> <CACZ4nhsv4zyzANrGh90WGKORz0Su=i7+Jmsk6nWoOq4or7Y0=Q@mail.gmail.com>
 <Y33ErZHAsX76y34Z@unreal>
In-Reply-To: <Y33ErZHAsX76y34Z@unreal>
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
Date:   Mon, 28 Nov 2022 18:01:13 -0800
Message-ID: <CACZ4nhvJV32pmOU7mRfaYYnatN6Ef5T3M=nVTYjuk7mnqcUxtw@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] Add Auxiliary driver support
To:     Leon Romanovsky <leon@kernel.org>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e4d89e05ee925d51"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e4d89e05ee925d51
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 22, 2022 at 10:59 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, Nov 22, 2022 at 07:02:45AM -0800, Ajit Khaparde wrote:
> > On Wed, Nov 16, 2022 at 5:22 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > ::snip::
> > > > > All PCI management logic and interfaces are needed to be inside eth part
> > > > > of your driver and only that part should implement SR-IOV config. Once
> > > > > user enabled SR-IOV, the PCI driver should create auxiliary devices for
> > > > > each VF. These device will have RDMA capabilities and it will trigger RDMA
> > > > > driver to bind to them.
> > > > I agree and once the PF creates the auxiliary devices for the VF, the RoCE
> > > > Vf indeed get probed and created. But the twist in bnxt_en/bnxt_re
> > > > design is that
> > > > the RoCE driver is responsible for making adjustments to the RoCE resources.
> > >
> > > You can still do these adjustments by checking type of function that
> > > called to RDMA .probe. PCI core exposes some functions to help distinguish between
> > > PF and VFs.
> > >
> > > >
> > > > So once the VF's are created and the bnxt_en driver enables SRIOV adjusts the
> > > > NIC resources for the VF,  and such, it tries to call into the bnxt_re
> > > > driver for the
> > > > same purpose.
> > >
> > > If I read code correctly, all these resources are for one PCI function.
> > >
> > > Something like this:
> > >
> > > bnxt_re_probe()
> > > {
> > >   ...
> > >         if (is_virtfn(p))
> > >                  bnxt_re_sriov_config(p);
> > >   ...
> > > }
> > I understand what you are suggesting.
> > But what I want is a way to do this in the context of the PF
> > preferably before the VFs are probed.
>
> I don't understand the last sentence. You call to this sriov_config in
> bnxt_re driver without any protection from VFs being probed,

Let me elaborate -
When a user sets num_vfs to a non-zero number, the PCI driver hook
sriov_configure calls bnxt_sriov_configure(). Once pci_enable_sriov()
succeeds, bnxt_ulp_sriov_cfg() is issued under bnxt_sriov_configure().
All this happens under bnxt_en.
bnxt_ulp_sriov_cfg() ultimately calls into the bnxt_re driver.
Since bnxt_sriov_configure() is called only for PFs, bnxt_ulp_sriov_cfg()
is called for PFs only.

Once bnxt_ulp_sriov_cfg() calls into the bnxt_re via the ulp_ops,
it adjusts the QPs, SRQs, CQs, MRs, GIDs and such.

>
> > So we are trying to call the
> > bnxt_re_sriov_config in the context of handling the PF's
> > sriov_configure implementation.  Having the ulp_ops is allowing us to
> > avoid resource wastage and assumptions in the bnxt_re driver.
>
> To which resource wastage are you referring?
Essentially the PF driver reserves a set of above resources for the PF,
and divides the remaining resources among the VFs.
If the calculation is based on sriov_totalvfs instead of sriov_numvfs,
there can be a difference in the resources provisioned for a VF.
And that is because a user may create a subset of VFs instead of the
total VFs allowed in the PCI SR-IOV capability register.
I was referring to the resource wastage in that deployment scenario.

Thanks
Ajit

>
> There are no differences if same limits will be in bnxt_en driver when
> RDMA bnxt device is created or in bnxt_re which will be called once RDMA
> device is created.
>
> Thanks
>
> >
> > ::snip::
>
>

--000000000000e4d89e05ee925d51
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
pZEyqKnwS1lKCzjX7mV5W955rFsFxChdAKfw0HilwtqdY24mhy62+GeaEkD0gYIj1tCmw9gnQToc
K+0s7xEunfR9pBrzmOwS3OQbcP0nJ8SmQ8R+reroH6LYuFpaqK1rgQIDAQABo4IB2zCCAdcwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAlBgNVHREEHjAcgRphaml0LmtoYXBhcmRlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUbrcTuh0mr2qP
xYdtyDgFeRIiE/gwDQYJKoZIhvcNAQELBQADggEBALrc1TljKrDhXicOaZlzIQyqOEkKAZ324i8X
OwzA0n2EcPGmMZvgARurvanSLD3mLeeuyq1feCcjfGM1CJFh4+EY7EkbFbpVPOIdstSBhbnAJnOl
aC/q0wTndKoC/xXBhXOZB8YL/Zq4ZclQLMUO6xi/fFRyHviI5/IrosdrpniXFJ9ukJoOXtvdrEF+
KlMYg/Deg9xo3wddCqQIsztHSkR4XaANdn+dbLRQpctZ13BY1lim4uz5bYn3M0IxyZWkQ1JuPHCK
aRJv0SfR88PoI4RB7NCEHqFwARTj1KvFPQi8pK/YISFydZYbZrxQdyWDidqm4wSuJfpE6i0cWvCd
u50xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwM2Vrj
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJcgBc1wL34QorfoKfmy
4aaZP8GOd5fUE+Y94mE4Bk+0MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMTEyOTAyMDEzMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBdsskQb6inth5jNCKwfhunvLol1DlURrc0Lumi
x9WA5ThGVpNYXWhCJdPgThTbJCLzYIxHYVD3uiJpNbM0Cwd/sLAJnyn3f0uJ5/k8l+s9/rVKSkgm
dACdHSqe54aV3qjmjX4IycldpZzF1HGA9U7+IiEaajzzx6Y2ohu+1l/9haup+ZMC90H5LIzZ0BEX
smdVwErsSekXV2h7I/zRYJiySLz2zAPYKmsNF+9hFdQzhIqtArwTIzylv5Svo1SgJoq9p19v6ZGT
4Uxinw2lVnrn0mtKWljwwcicaJJOxHLGjQvrzlMW1Ua6RG2F5GwKtss4R/IraEZY2zKDcMpzTiNw
--000000000000e4d89e05ee925d51--
