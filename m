Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20EFB63BBEB
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiK2Inx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiK2Ins (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:43:48 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A8F25E8B
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:43:47 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id z192so16588199yba.0
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vIWarlLCPqKfPV2PeVRmT2O24TfuYMhomBPjhVYECJU=;
        b=VtTcTpLY7aQhXabuOjgWzAoZqeSKVVf0qlljI1FSLgZuXO+H0HVAvA5WE2Rm4+PyrM
         A0u9oxDRPZobKBxM9fBFIArqH7epWxCa59z7HWV2x1Y8DSlJCb1gRcTqUS1AIwPGXH3/
         /STH+SyZjb7SaRWwUBxhrINsaHHgVjzEQlw1E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vIWarlLCPqKfPV2PeVRmT2O24TfuYMhomBPjhVYECJU=;
        b=J4AS30z34KMEG5tYwUF1T8tjuFiD+qnrzn+rFgm01V9FIZB+iF0ODbxYxsAjHAQ87s
         cjikrFuofIvyQN06/Ws/WdonNxYt+abgIX+ixCeWmjxJcD6qve3iiAS3mRcrmiZGjh4W
         pwSIfZG1XDB/XuQsxkczYrvcmsK/HAV4cF3YIh9sGxw8usyOzrVuaf5axpFRiKyN/oql
         vzeez0d3WJg4BlRZZdOJr9l2C310d75oFmqYPAerPIekRJJFOh9KjpcB3N5sqhHW3/UQ
         e4RVHcnxL/WHjnXIShG4JTnJ9kAdndV0nIZ7WG8/mb1mjns/FmYCIBSfX81kwIBL2zuU
         x05A==
X-Gm-Message-State: ANoB5pn6C+C7wEQ1npMWht1Xr4ulpF4FxieQ7B9Fl5sXEGxslXsiZTR2
        fxv7/rz8vYKkf3AUrV2JbofXGrrMdpOGXwGxujebww==
X-Google-Smtp-Source: AA0mqf5kKQuDV/bhiQwA2kIpWKSWs9acHkIjDcyDRxK9EO+v9Sjtwuiup588wtZhKqj5b9fWzBbfStZyc6x0z1RaqFE=
X-Received: by 2002:a25:cf55:0:b0:6f6:f5d0:aa62 with SMTP id
 f82-20020a25cf55000000b006f6f5d0aa62mr8129607ybg.81.1669711426420; Tue, 29
 Nov 2022 00:43:46 -0800 (PST)
MIME-Version: 1.0
References: <20221128103227.23171-1-arun.ramadoss@microchip.com> <20221128103227.23171-5-arun.ramadoss@microchip.com>
In-Reply-To: <20221128103227.23171-5-arun.ramadoss@microchip.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Tue, 29 Nov 2022 14:13:35 +0530
Message-ID: <CALs4sv0x04ODvWv-av56-FtnnpsC_8Sudp8T0U0buNRt+hq9bA@mail.gmail.com>
Subject: Re: [Patch net-next v1 04/12] net: dsa: microchip: ptp: Manipulating
 absolute time using ptp hw clock
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007950dd05ee97fc5f"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000007950dd05ee97fc5f
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 28, 2022 at 4:04 PM Arun Ramadoss
<arun.ramadoss@microchip.com> wrote:
> +/*  Function is pointer to the do_aux_work in the ptp_clock capability */
> +static long ksz_ptp_do_aux_work(struct ptp_clock_info *ptp)
> +{
> +       struct ksz_ptp_data *ptp_data = ptp_caps_to_data(ptp);
> +       struct ksz_device *dev = ptp_data_to_ksz_dev(ptp_data);
> +       struct timespec64 ts;
> +
> +       mutex_lock(&ptp_data->lock);
> +       _ksz_ptp_gettime(dev, &ts);
> +       mutex_unlock(&ptp_data->lock);
> +
> +       spin_lock_bh(&ptp_data->clock_lock);
> +       ptp_data->clock_time = ts;
> +       spin_unlock_bh(&ptp_data->clock_lock);

If I understand this correctly, the software clock is updated with
full 64b every 1s. However only 32b timestamp registers are read while
processing packets and higher bits from this clock are used.
How do you ensure these higher order bits are in sync with the higher
order bits in the HW? IOW, what if lower 32b have wrapped around and
you are required to stamp a packet but you still don't have aux worker
updated.

> +
> +       return HZ;  /* reschedule in 1 second */
> +}
> +
>  static int ksz_ptp_start_clock(struct ksz_device *dev)
>  {
> -       return ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_CLK_ENABLE, PTP_CLK_ENABLE);
> +       struct ksz_ptp_data *ptp_data = &dev->ptp_data;
> +       int ret;
> +
> +       ret = ksz_rmw16(dev, REG_PTP_CLK_CTRL, PTP_CLK_ENABLE, PTP_CLK_ENABLE);
> +       if (ret)
> +               return ret;
> +
> +       spin_lock_bh(&ptp_data->clock_lock);
> +       ptp_data->clock_time.tv_sec = 0;
> +       ptp_data->clock_time.tv_nsec = 0;
> +       spin_unlock_bh(&ptp_data->clock_lock);
> +
> +       return 0;
>  }
>
>  static const struct ptp_clock_info ksz_ptp_caps = {
> @@ -305,6 +357,7 @@ static const struct ptp_clock_info ksz_ptp_caps = {
>         .settime64      = ksz_ptp_settime,
>         .adjfine        = ksz_ptp_adjfine,
>         .adjtime        = ksz_ptp_adjtime,
> +       .do_aux_work    = ksz_ptp_do_aux_work,
>  };
>
>  int ksz_ptp_clock_register(struct dsa_switch *ds)
> @@ -315,6 +368,7 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
>
>         ptp_data = &dev->ptp_data;
>         mutex_init(&ptp_data->lock);
> +       spin_lock_init(&ptp_data->clock_lock);
>
>         ptp_data->caps = ksz_ptp_caps;
>
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
> index 17f455c3b2c5..81fa2e8b9cf4 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.h
> +++ b/drivers/net/dsa/microchip/ksz_ptp.h
> @@ -15,6 +15,9 @@ struct ksz_ptp_data {
>         struct ptp_clock *clock;
>         /* Serializes all operations on the PTP hardware clock */
>         struct mutex lock;
> +       /* lock for accessing the clock_time */
> +       spinlock_t clock_lock;
> +       struct timespec64 clock_time;
>  };
>
>  int ksz_ptp_clock_register(struct dsa_switch *ds);
> --
> 2.36.1
>

--0000000000007950dd05ee97fc5f
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINAuC3Bc/Udwn9vC8fDHu29gP1Aao3Oq
Zy5F/2ZHH3W4MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTEy
OTA4NDM0NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCPlCEbWGIyHvtkGnexn0SKGHAT5F8IyZEbHqHU34SQcAbBJ/6M
TC4eCHXyJyUbppuD/t5JnyUvTbeexSVIbdOEuX1kwIhDL5cEpPuU5bnBPpDoMVKm7NeaKYjxUBWq
CP9hsVgYcOI6yjPG5kbsZYabqCsLs2BibAovnE1e0HhjO6whZVDPbS3tiflkfydBlbSMVLiNXq9n
qsek6gA8/sfi6+waWvpMCTLFVROD515C1m9i/sB0dxRj12T6CoJ6E8MshVvhHIXV0UD3HLm49Ri5
4s8jakRzXxsnEpodbC0fhhYYQEw9Z+FYm8WopiYDlve9av5ycEF78q+V7Fp02FJb
--0000000000007950dd05ee97fc5f--
