Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD5A67149A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjARHDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjARHAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:00:48 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5E465EE3
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 22:33:05 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id c26so20966003pfp.10
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 22:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CJdigO93biYzNenQI4Ryj5PyZS1M2gJ5KBT08XS94JI=;
        b=evGiyYm5mfOsqBNerrVUX4+xKXHyAUBhOSgXAYqYBCPiPM9UbNseiaBWjABmePlh+f
         /XOelFPwIkW8JPGYJg/h+Jdp2TkeYlxp2YPYRktwva9xqfgND8ct06ojjoijr6ihOpYY
         +slNBKzUdieehH7d/lPpoNlYpL2n/DRfGSDyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CJdigO93biYzNenQI4Ryj5PyZS1M2gJ5KBT08XS94JI=;
        b=lrbrUr1a9WfB/+b2SY42LJ/yaNoR22LNPD4rhzrDh8SOz5sOpCpUcIHOGeG50Ohass
         AER94O1LI45gVe8Yf7iflk2hyZ0fZlY1iuBL0PvEMlZrCCvfO0Ma8giJxHaJYJtMVWnf
         hptzX6mX4r3HFQqB8YYW3lVPF7hj9JeLHI5lQ2V/6UAPBvFecGK/VLa9hVLZ0/REKkLq
         4ya5gM24wCKWLB+Txeq6RcAWNJhu4SLhZKSUUkBLrEpPFFHY4z+GNac4pFVaKz3a9sC4
         I3P37tXyhDnR41FX0R/jiSZKYJtV8DdHVmTkI4qxSYe6DnqLw49obNxoEDofHNXpFKHD
         xIFQ==
X-Gm-Message-State: AFqh2kow7GfYnQkcXJYD/3EynkK2nc/+TXNGuwuN3Jqggy2y78AkH6Jw
        y5vMdcHhylXNRa3cR+rzonFggJ4xQXy7etCXRmBy9Q==
X-Google-Smtp-Source: AMrXdXvwd/vXI3oVt7N2/H+zgXnOvfjce0HMDh9mZhUoz/QU03Jl/Up0DJFkmpZWkkm8RNKl2tX7NWURmpIKcb8K0Rg=
X-Received: by 2002:a63:2003:0:b0:48e:bdef:b6fb with SMTP id
 g3-20020a632003000000b0048ebdefb6fbmr355777pgg.457.1674023554993; Tue, 17 Jan
 2023 22:32:34 -0800 (PST)
MIME-Version: 1.0
References: <20230112202939.19562-1-ajit.khaparde@broadcom.com>
 <20230112202939.19562-2-ajit.khaparde@broadcom.com> <20230113221042.5d24bdde@kernel.org>
 <CACZ4nhuKo-h_dcSGuzAm4vJJuuxmnVo8jYO2scCxfqtktbCjfw@mail.gmail.com>
 <20230116205625.394596cc@kernel.org> <Y8aVBTAVFQPPx47H@unreal>
In-Reply-To: <Y8aVBTAVFQPPx47H@unreal>
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
Date:   Tue, 17 Jan 2023 22:32:18 -0800
Message-ID: <CACZ4nhuLuJbaaEHCqNgFn3tX5D38c=cWSgzz_iq1xwWJ9sKH3A@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/8] bnxt_en: Add auxiliary driver support
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, andrew.gospodarek@broadcom.com,
        davem@davemloft.net, edumazet@google.com, jgg@ziepe.ca,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000005df4f905f283fbe8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000005df4f905f283fbe8
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
Ok. But..
bnxt_aux_dev_free() is actually freeing up the private memory allocated
for holding the pointer returned by my_aux_dev_alloc(xxx);
The aux device is freed via the auxiliary_device_uninit only.

>
> BTW, line 325 from below shouldn't exist too.
ACK

>
>   312 void bnxt_rdma_aux_device_uninit(struct bnxt *bp)
>   313 {
> ...
>   325         if (bnxt_adev->id >= 0)
>   326                 ida_free(&bnxt_aux_dev_ids, bnxt_adev->id);
>
> And one line bnxt_aux_dev_alloc() needs to be deleted too.
To avoid confusion, I will refactor and rename the code handling
auxiliary_device alloc, cleanup and the alloc, cleanup of priv
pointers used for bookkeeping.

I hope the new patchset will address the concerns raised.

>
> Thanks

--0000000000005df4f905f283fbe8
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
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILIKjvIUpUdCwGjZE8ki
QLqSNrhSrG7xJT31qjc0ylfyMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIzMDExODA2MzIzNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCSdmVixznIsWl6USvwPDvIAkoP8gxiPL5FZoTQ
aeqcuoGivwa0Zc7xGFwvoL03hWJlds1MxFPNkNUcnHFRzYR7mJOYdBW+PhSpPDX72qIfgduFZdfc
mDN6qqipua02Xo6ogRje78ZvU6QuR52kxvE0EupvnffaYDmhC5e+7ubW2XKSIfU7gLEKIz6paTET
M5vIVKpw+zvoOcYGYLEFTVQPNeZerKM4k9/PXKK3C5tsoF9piiA7iQ0Exey5mkGOS97h0zSEgltn
FPSFoXJn23nngZlF7A7wptW8se4jCdIUHhIwhi58pQt1FlN1dUlcgK4iAu7XvZro9iWtP1K+Ys3a
--0000000000005df4f905f283fbe8--
