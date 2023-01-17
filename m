Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FAC66E82E
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 22:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjAQVKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 16:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjAQVJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 16:09:17 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359486B9AA
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:34:16 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z3so89984pfb.2
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kua83Qg35UptXdcmrzwSvS0adi/I583x5+ix8fireok=;
        b=ENtWHTq8VbGNpEq3Q3KmrCQg+HmOhWpnKfMu5m/qQKXC1PmSWWt4xrhoikXKi1mhZI
         o5y2QuDzjRcaixiArYRFDEEe1hGMKRjdHBU2+s4ffx8ji4VXMuITjwbNBefW5MdI8cuK
         WtYEEHVVLQdrujL3vrswMMOeee00W/XyaRZiA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kua83Qg35UptXdcmrzwSvS0adi/I583x5+ix8fireok=;
        b=29bFqUz3Ucz8s1rmHiWGlvIBMrz4qVNZDv7nsJDyzySzNL+/KKQUyJ38cClfUPWAwR
         go8c2tLOfswDOkk2loT4ANhbNjXt/jRiXpZWPe/26fyfpwADKXAmrDrzvZAMy+fwrfe0
         VNnHHoAZIAkp8pTL+3BYNjBHTglNHP6HEW3+plzFMiMkSrWcOfRS07D5jQbwST2JJ/TH
         oDtZXhFYZ4p/dWJkJg7HfEpfS4IzAJOEZqJ70Fu3wQHaQThgwWKme5hnO2IVmNHpic6f
         rWkS3a0XvBB5iHFrJrGzwWA7TwYkBWwnNbHgC6FyPocq+vHsq/m/hQfsGZJTiMFONo4g
         ZPmA==
X-Gm-Message-State: AFqh2kqR7rXqHq6Ksg2qAvJz53epIq9dValNIatRb36vRrTaB6E9ELLX
        8QEQcfQQwPEmRiiilOTEnwwbrP5bhIxMylci7mey5A==
X-Google-Smtp-Source: AMrXdXvlTmimXfV0x9tQMwPdwveKdePj9HGDlKqHRqPoxbx8noZTyFH/vd4a+1H7jzg39ux06e0EIGcuJ8JnP8/n2gc=
X-Received: by 2002:aa7:97b8:0:b0:580:f2b8:2131 with SMTP id
 d24-20020aa797b8000000b00580f2b82131mr395030pfq.50.1673984055571; Tue, 17 Jan
 2023 11:34:15 -0800 (PST)
MIME-Version: 1.0
References: <20230112202939.19562-1-ajit.khaparde@broadcom.com>
 <20230112202939.19562-2-ajit.khaparde@broadcom.com> <20230113221042.5d24bdde@kernel.org>
 <CACZ4nhuKo-h_dcSGuzAm4vJJuuxmnVo8jYO2scCxfqtktbCjfw@mail.gmail.com>
 <20230116205625.394596cc@kernel.org> <Y8aVBTAVFQPPx47H@unreal>
In-Reply-To: <Y8aVBTAVFQPPx47H@unreal>
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
Date:   Tue, 17 Jan 2023 11:33:58 -0800
Message-ID: <CACZ4nht6aJ2e9=nOkDWi74kDdAVMXPgiyRRyh8X9mO_uCLFnjQ@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/8] bnxt_en: Add auxiliary driver support
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, andrew.gospodarek@broadcom.com,
        davem@davemloft.net, edumazet@google.com, jgg@ziepe.ca,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000003881e05f27ac9a0"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000003881e05f27ac9a0
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 17, 2023 at 4:31 AM Leon Romanovsky <leonro@nvidia.com> wrote:
>
> On Mon, Jan 16, 2023 at 08:56:25PM -0800, Jakub Kicinski wrote:
> > On Sat, 14 Jan 2023 12:39:09 -0800 Ajit Khaparde wrote:
> > > > > +static void bnxt_aux_dev_release(struct device *dev)
> > > > > +{
> > > > > +     struct bnxt_aux_dev *bnxt_adev =
> > > > > +             container_of(dev, struct bnxt_aux_dev, aux_dev.dev);
> > > > > +     struct bnxt *bp = netdev_priv(bnxt_adev->edev->net);
> > > > > +
> > > > > +     bnxt_adev->edev->en_ops = NULL;
> > > > > +     kfree(bnxt_adev->edev);
> > > >
> > > > And yet the reference counted "release" function accesses the bp->adev
> > > > like it must exist.
> > > >
> > > > This seems odd to me - why do we need refcounting on devices at all
> > > > if we can free them synchronously? To be clear - I'm not sure this is
> > > > wrong, just seems odd.
> > > I followed the existing implementations in that regard. Thanks
> >
> > Leon, could you take a look? Is there no problem in assuming bnxt_adev
> > is still around in the release function?
>
> You caught a real bug. The auxdev idea is very simple - it needs to
> behave like driver core, but in the driver itself.
>
> As such, bnxt_aux_dev_free() shouldn't be called after bnxt_rdma_aux_device_uninit().
> Device will be released through auxiliary_device_uninit();
>
> BTW, line 325 from below shouldn't exist too.
>
>   312 void bnxt_rdma_aux_device_uninit(struct bnxt *bp)
>   313 {
> ...
>   325         if (bnxt_adev->id >= 0)
>   326                 ida_free(&bnxt_aux_dev_ids, bnxt_adev->id);
>
> And one line bnxt_aux_dev_alloc() needs to be deleted too.
>
> Thanks
Thanks.
We are reviewing the comments and will have an update soon.

--00000000000003881e05f27ac9a0
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
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJIIv7w6u7W0wZGGak7P
z++jiTdKLPNcHMDa4GFlVjtpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIzMDExNzE5MzQxNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQB7sBGrJMQhSgoWcFF9g6Qc4hfJCnVZWQTX/wGb
Gqh4VWE8UsBwkr5jf+Up3myOQh+yObcvbnmCzTsOhB94nTjpnyEuEHQYaVNgxwQ7H8yz5RGCYVKp
ilc7Z3kTwTlMcIJhJbvDZVUI+iQzIVYXN6hRx2kgrNqG4PR9dNADWeqG7Vqew+Yj09QCWOrNpXsx
ooFJiOpOY6pTKowI33M+m3ff4np+5bJDjC8cBgp+0HorPpmaGAL2KTyb9MyFaP1fEhvPR3Cj4I6H
yOs2JxzYGU6cVpdgxF9t4xvWEB8OLPjsCBdf6k5x/UPK8CwP2Rcwtj1f4wQLjAldFMRlVuj9qhlr
--00000000000003881e05f27ac9a0--
