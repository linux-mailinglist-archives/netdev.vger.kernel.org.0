Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB17963CF1C
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 07:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbiK3GL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 01:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiK3GLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 01:11:54 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332645BD6A
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 22:11:53 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-3b5d9050e48so158636927b3.2
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 22:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/RvJPTz5dH1xsBGOFXSZm5mcogaRqq8F/IdQeGZ5oE=;
        b=LLNqPlfpyAIxBgGJG16uwZ4kBCF7ownGddYUVsAzEWAgvayXpc6r6zYwhvTgTrtLP6
         Sjg/zv9pbaw+dZ9mef8DYGhBQFNEAckGFEvK68Pc8pO3mCrLnXCHcRD/bVpGEyX88HHU
         8K8mtzXXGNGyff2JlAhi1femw11lZCq/+cVW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z/RvJPTz5dH1xsBGOFXSZm5mcogaRqq8F/IdQeGZ5oE=;
        b=3easyXCkkIZMOYfTnoRExrex4D76tsFO83Iurr33MaXdhLX4H2hUH8g4gk+/wTyXdu
         OehrGkJzchqg0wSjRBLA4NvOdUqvwO9exjUcJ+SlScNqq7VPo08tCbYzfacJCyE8DR9a
         tfitOYShQtcr9u+pfTd1bHRGTgski/0xI3h0xhHNbsV6kIxRR1//qtPRASs3Ok4UQpI4
         bfLvtRFzQ9UJuXYFl1diJI8hs4blLKROqIgS9LVpVGMJ7o4bOciZQ1Jt4gRZHRsnZ3Td
         jdM/0cFtWU32UtRIF+nl9a8EOwcsVBeLtfhUY7hPCIcFTEyXlKA9KED6E2vgvco6QJ4l
         OzVw==
X-Gm-Message-State: ANoB5plenzQLf7j+BoMXoYN8U3FQE0DwaY5qSyjUc8qQ1YaUaZJ96Vil
        IxXP6T9rQH15HTG1McTDBndQilQGSKnLBWyGcUo3dA==
X-Google-Smtp-Source: AA0mqf4UoXVpVATcVA5NwVy81XEr1TuTMP2VY6b5eyr+ocLsmvaZqYAvkkcHUGgbOXbJ7OQ2lBPVJkkVfG49sy+9SDI=
X-Received: by 2002:a05:690c:b81:b0:36a:1c12:b60f with SMTP id
 ck1-20020a05690c0b8100b0036a1c12b60fmr41776220ywb.45.1669788712276; Tue, 29
 Nov 2022 22:11:52 -0800 (PST)
MIME-Version: 1.0
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
 <20221128103227.23171-5-arun.ramadoss@microchip.com> <CALs4sv0x04ODvWv-av56-FtnnpsC_8Sudp8T0U0buNRt+hq9bA@mail.gmail.com>
 <743a908be8dcb9a6492a2adeee5f2f9de3eff5a8.camel@microchip.com>
In-Reply-To: <743a908be8dcb9a6492a2adeee5f2f9de3eff5a8.camel@microchip.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Wed, 30 Nov 2022 11:41:41 +0530
Message-ID: <CALs4sv3DAZmXDYaGnKTtX+sG5NrcmKQ0o35qBMF_SmADmh8U1w@mail.gmail.com>
Subject: Re: [Patch net-next v1 04/12] net: dsa: microchip: ptp: Manipulating
 absolute time using ptp hw clock
To:     Arun.Ramadoss@microchip.com
Cc:     andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, linux@armlinux.org.uk, ceggers@arri.de,
        Tristram.Ha@microchip.com, f.fainelli@gmail.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Woojung.Huh@microchip.com,
        davem@davemloft.net
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000010dfc605eea9fbf6"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000010dfc605eea9fbf6
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 30, 2022 at 9:52 AM <Arun.Ramadoss@microchip.com> wrote:
>
> Hi Pavan,
> Thanks for the review comment.
>
> On Tue, 2022-11-29 at 14:13 +0530, Pavan Chebbi wrote:
> > On Mon, Nov 28, 2022 at 4:04 PM Arun Ramadoss
> > <arun.ramadoss@microchip.com> wrote:
> > > +/*  Function is pointer to the do_aux_work in the ptp_clock
> > > capability */
> > > +static long ksz_ptp_do_aux_work(struct ptp_clock_info *ptp)
> > > +{
> > > +       struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
> > > +       struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
> > > +       struct timespec64 ts;
> > > +
> > > +       mutex_lock(&ptp_data->lock);
> > > +       _ksz_ptp_gettime(dev, &ts);
> > > +       mutex_unlock(&ptp_data->lock);
> > > +
> > > +       spin_lock_bh(&ptp_data->clock_lock);
> > > +       ptp_data->clock_time = ts;
> > > +       spin_unlock_bh(&ptp_data->clock_lock);
> >
> > If I understand this correctly, the software clock is updated with
> > full 64b every 1s. However only 32b timestamp registers are read
> > while
> > processing packets and higher bits from this clock are used.
> > How do you ensure these higher order bits are in sync with the higher
> > order bits in the HW? IOW, what if lower 32b have wrapped around and
> > you are required to stamp a packet but you still don't have aux
> > worker
> > updated.
>
> The Ptp Hardware Clock (PHC) seconds register is 32 bit wide. To have
> register overflow it takes 4,294,967,296 seconds which is approximately
> around 136 Years. So, it is bigger value and assume that we don't need
> to care of PHC second register overflow.
> For the packet timestamping, value is read from 32 bit register. This
> register is splited into 2 bits seconds + 30 bits nanoseconds register.
> In the ksz_tstamp_reconstruct function, lower 2 bits in the ptp_data-
> >clock_time is cleared and 2 bits from the timestamp register are
> added.
>
>  spin_lock_bh(&ptp_data->clock_lock);
>  ptp_clock_time = ptp_data->clock_time;
>  spin_unlock_bh(&ptp_data->clock_lock);
>
> /* calculate full time from partial time stamp */
>  ts.tv_sec = (ptp_clock_time.tv_sec & ~3) | ts.tv_sec;
>
OK thanks. Looks like nano sec and seconds are not being stitched, if
that had happened the rollover would be very frequent. But stitching
the seconds with higher bits still has this problem.
But it should be OK since the window is so large.

> >
> > > +
> > > +       return HZ;  /* reschedule in 1 second */
> > > +}
> > > +
> > >  static int ksz_ptp_start_clock(struct ksz_device *dev)
> > >  {
> > > -       return ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_CLK_ENABLE,
> > > PTP_CLK_ENABLE);
> > > +       struct ksz_ptp_data *ptp_data = &dev->ptp_data;
> > > +       int ret;
> > > +
> > > +       ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_CLK_ENABLE,
> > > PTP_CLK_ENABLE);
> > > +       if (ret)
> > > +               return ret;
> > > +
> > > +       spin_lock_bh(&ptp_data->clock_lock);
> > > +       ptp_data->clock_time.tv_sec = 0;
> > > +       ptp_data->clock_time.tv_nsec = 0;
> > > +       spin_unlock_bh(&ptp_data->clock_lock);
> > > +
> > > +       return 0;
> > >  }
> > >
> > >
> > > --
> > > 2.36.1
> > >

--00000000000010dfc605eea9fbf6
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OltyqaGBuzv+bJTUL+bmV7E4QBLIqGt4jVr1R9hJdH6KxXwJdyfHZ9C6qXmoe2NQhiFUyBOJ0wgk
dB9Z1IU7nCwvNKYg2JMoJs93tIgbhPJg/D7pqW8gabkCAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcGF2YW4uY2hlYmJpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUEV6y/89alKPoFbKUaJXsvWu5
fdowDQYJKoZIhvcNAQELBQADggEBAEHSIB6g652wVb+r2YCmfHW47Jo+5TuCBD99Hla8PYhaWGkd
9HIyD3NPhb6Vb6vtMWJW4MFGQF42xYRrAS4LZj072DuMotr79rI09pbOiWg0FlRRFt6R9vgUgebu
pWSH7kmwVXcPtY94XSMMak4b7RSKig2mKbHDpD4bC7eGlwl5RxzYkgrHtMNRmHmQor5Nvqe52cFJ
25Azqtwvjt5nbrEd81iBmboNTEnLaKuxbbCtLaMEP8xKeDjAKnNOqHUMps0AsQT8c0EGq39YHpjp
Wn1l67VU0rMShbEFsiUf9WYgE677oinpdm0t2mdCjxr35tryxptoTZXKHDxr/Yy6l6ExggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwV/XkICjVscn4SNZMw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFtUCDXLh7K2hEdPnQ3zdvW30I21QmYz
Vq12WKuP3M00MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTEz
MDA2MTE1MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAfMFEDVSofNjMh+G0Z2zzSGPhy0MOfN0obcHDFwbwhW8y+0db9
iweIXWcwE1EFj1/uVSnq5kfiBN1M7TdlOzY0MRcBn5YeVFExMbcEsrWsNE76Es+28VxR6//CYxwF
w812rjAgAHh7abPF6d3UpBSrxPRQ1KgKkS89ENAU8XGeMeFBbw0+13CNf2vVQfknXukxa7bCBeyp
oNppzxq8Sb92oZ1QaAgZV0nSEqo4WEi47WViHjtm8FygEF7BJc9DfbvDaARnfcqRNIBAXZpbnBmu
TliCwfJVVLTPhs818dITC6IVcXllfTmIdFsgZBpg8VjltBj2sw1R4TuSoCt7sKVO
--00000000000010dfc605eea9fbf6--
