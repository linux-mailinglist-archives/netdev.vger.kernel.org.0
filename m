Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3543F63BC08
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiK2It5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiK2Itq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:49:46 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B2845EF3
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:49:28 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-3876f88d320so131739017b3.6
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xJwMgPLbiQanSfJ9HFXMf1xZBPDpr1MdW20wvu3MqMg=;
        b=BxgwEGFXuRPcSxwi/ccFMlXZeYKi4bRZ9xcLfzrztaRg5l6RWnqX65qhFeFysOBxZy
         2ypO8R33a3pIeWNsJoczEDZX5GiiPfu+ZOJ2sMyu8whKP4F6L8FCfcDF8PnYuDI2Um+k
         koC0G8D/yze8Rw/28tpg9YyntWNz5D+NRo1gw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xJwMgPLbiQanSfJ9HFXMf1xZBPDpr1MdW20wvu3MqMg=;
        b=Be3sUUyUaxRpzVPiq13SAnaQq3sEPOYtym8x++JXhkUYfYC5tbbaHAh+q7s65ebGd1
         QYJRaXJHMHh/+VupfQgWgcuU8Hg8dMVWRQHDmxNj9lZWo4U61DKszt+G/K9jyz04xO/X
         M8qUIIrgW9oAZaKY/phHOkq0M1gybtVOZrVY0/A/Tu/Y4pC8zTaHU5UWTmUvLbE+Rdw+
         NtpKPYk7hnnaWB0BisKP6u2+0ugPVPvoVHQJcmfwYmgD4+xuqAC13O+rQrvWTEu8Q9Ki
         oq32gRjdc8GJb28RodZ2dMsi/KjQ6rEVRMbplVww7vxpUEYkYm6atwldb58PWJ1qe6Wj
         i2EA==
X-Gm-Message-State: ANoB5pngKBd+DqSUTxSbh0443opGrmuH2ibWHa345iLj8lokwHJWHwEG
        noF2apqPoUbtMfugLAlIMA10NV6WOk0o37Vh/TqCjQ==
X-Google-Smtp-Source: AA0mqf5m1pUcv/RJi7L9fjvBYcsrOM7kHLWmSE57dMgGYI35OOg+jNMalF8tTgoFRh9z4m2Nw71P+2fhuZRk42T/WCk=
X-Received: by 2002:a81:9a49:0:b0:3c3:29d2:9c7c with SMTP id
 r70-20020a819a49000000b003c329d29c7cmr11926310ywg.195.1669711767979; Tue, 29
 Nov 2022 00:49:27 -0800 (PST)
MIME-Version: 1.0
References: <20221128103227.23171-1-arun.ramadoss@microchip.com> <20221128103227.23171-3-arun.ramadoss@microchip.com>
In-Reply-To: <20221128103227.23171-3-arun.ramadoss@microchip.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Tue, 29 Nov 2022 14:19:17 +0530
Message-ID: <CALs4sv3nqNxMXwtdOdXuoS7xTKwXCrba=+s2e=Gq6cdEFNmttg@mail.gmail.com>
Subject: Re: [Patch net-next v1 02/12] net: dsa: microchip: ptp: Initial
 hardware time stamping support
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d4726f05ee9810d1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000d4726f05ee9810d1
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 28, 2022 at 4:03 PM Arun Ramadoss
<arun.ramadoss@microchip.com> wrote:
>
> From: Christian Eggers <ceggers@arri.de>
>
> This patch adds the routine for get_ts_info, hwstamp_get, set. This enables
> the PTP support towards userspace applications such as linuxptp.
> Tx timestamping can be enabled per port and Rx timestamping enabled
> globally.
>
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
>
> ---
> RFC v2 -> Patch v1
> - moved tagger set and get function to separate patch
> - Removed unnecessary comments
> ---
>  drivers/net/dsa/microchip/ksz_common.c |  2 +
>  drivers/net/dsa/microchip/ksz_common.h |  4 ++
>  drivers/net/dsa/microchip/ksz_ptp.c    | 77 +++++++++++++++++++++++++-
>  drivers/net/dsa/microchip/ksz_ptp.h    | 14 +++++
>  4 files changed, 95 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 2d09cd141db6..7b85b258270c 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -2873,6 +2873,8 @@ static const struct dsa_switch_ops ksz_switch_ops = {
>         .port_change_mtu        = ksz_change_mtu,
>         .port_max_mtu           = ksz_max_mtu,
>         .get_ts_info            = ksz_get_ts_info,
> +       .port_hwtstamp_get      = ksz_hwtstamp_get,
> +       .port_hwtstamp_set      = ksz_hwtstamp_set,
>  };
>
>  struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 5a6bfd42c6f9..cd20f39a565f 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -103,6 +103,10 @@ struct ksz_port {
>         struct ksz_device *ksz_dev;
>         struct ksz_irq pirq;
>         u8 num;
> +#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_PTP)
> +       u8 hwts_tx_en;
> +       bool hwts_rx_en;

I see that the hwts_rx_en gets removed in the later patch. Instead you
could add rx filters support only later when you have the final code
in place.

> +#endif
>  };
>
>  struct ksz_device {
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
> index c737635ca266..a41418c6adf6 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.c
> +++ b/drivers/net/dsa/microchip/ksz_ptp.c
> @@ -36,15 +36,88 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
>                               SOF_TIMESTAMPING_RX_HARDWARE |
>                               SOF_TIMESTAMPING_RAW_HARDWARE;
>
> -       ts->tx_types = BIT(HWTSTAMP_TX_OFF);
> +       ts->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ONESTEP_P2P);
>
> -       ts->rx_filters = BIT(HWTSTAMP_FILTER_NONE);
> +       ts->rx_filters = BIT(HWTSTAMP_FILTER_NONE) | BIT(HWTSTAMP_FILTER_ALL);
>
>         ts->phc_index = ptp_clock_index(ptp_data->clock);
>
>         return 0;
>  }
>
> +int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
> +{
> +       struct ksz_device *dev = ds->priv;
> +       struct hwtstamp_config config;
> +
> +       config.flags = 0;
> +
> +       config.tx_type = dev->ports[port].hwts_tx_en;
> +
> +       if (dev->ports[port].hwts_rx_en)
> +               config.rx_filter = HWTSTAMP_FILTER_ALL;
> +       else
> +               config.rx_filter = HWTSTAMP_FILTER_NONE;
> +
> +       return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
> +               -EFAULT : 0;
> +}
> +
> +static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
> +                                  struct hwtstamp_config *config)
> +{
> +       struct ksz_port *prt = &dev->ports[port];
> +
> +       if (config->flags)
> +               return -EINVAL;
> +
> +       switch (config->tx_type) {
> +       case HWTSTAMP_TX_OFF:
> +       case HWTSTAMP_TX_ONESTEP_P2P:
> +               prt->hwts_tx_en = config->tx_type;
> +               break;
> +       default:
> +               return -ERANGE;
> +       }
> +
> +       switch (config->rx_filter) {
> +       case HWTSTAMP_FILTER_NONE:
> +               prt->hwts_rx_en = false;
> +               break;
> +       default:
> +               prt->hwts_rx_en = true;
> +               break;
> +       }
> +
> +       return 0;
> +}
> +
> +int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
> +{
> +       struct ksz_device *dev = ds->priv;
> +       struct ksz_ptp_data *ptp_data;
> +       struct hwtstamp_config config;
> +       int ret;
> +
> +       ptp_data = &dev->ptp_data;
> +
> +       mutex_lock(&ptp_data->lock);
> +
> +       ret = copy_from_user(&config, ifr->ifr_data, sizeof(config));
> +       if (ret)
> +               goto error_return;
> +
> +       ret = ksz_set_hwtstamp_config(dev, port, &config);
> +       if (ret)
> +               goto error_return;
> +
> +       ret = copy_to_user(ifr->ifr_data, &config, sizeof(config));
> +
> +error_return:
> +       mutex_unlock(&ptp_data->lock);
> +       return ret;
> +}
> +
>  static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts)
>  {
>         u32 nanoseconds;
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
> index ea9fa46caa01..17f455c3b2c5 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.h
> +++ b/drivers/net/dsa/microchip/ksz_ptp.h
> @@ -23,6 +23,8 @@ void ksz_ptp_clock_unregister(struct dsa_switch *ds);
>
>  int ksz_get_ts_info(struct dsa_switch *ds, int port,
>                     struct ethtool_ts_info *ts);
> +int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
> +int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
>
>  #else
>
> @@ -40,6 +42,18 @@ static inline void ksz_ptp_clock_unregister(struct dsa_switch *ds) { }
>
>  #define ksz_get_ts_info NULL
>
> +static inline int ksz_hwtstamp_get(struct dsa_switch *ds, int port,
> +                                  struct ifreq *ifr)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static inline int ksz_hwtstamp_set(struct dsa_switch *ds, int port,
> +                                  struct ifreq *ifr)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
>  #endif /* End of CONFIG_NET_DSA_MICROCHIP_KSZ_PTP */
>
>  #endif
> --
> 2.36.1
>

--000000000000d4726f05ee9810d1
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPmfsH7p4SO4OuuGMJcvFgmbuCcIP2bd
0GjWTdkwOhETMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTEy
OTA4NDkyOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBEPtq6r8IgGggN/TBjsDFvkrN4iC59UfdkkcOn7UpOxDNdBU5m
k7xMs55ETeM/vLPxaWVZGmPDwzOyBEnG+1nC1LJsTzY/7+GJodRrOQOy4ul8nCW1k/Aojf6X0kDi
s5jBbOeKLNW3QwfkEL/FKqR2C7TmheT7bRoCDbAA3NVasHL1KT2FrsklSKyO+xO4KFbF1Lw9eYsK
HGImoHvDKwLgwMTOv+f2R9vAKZ034PRbY4664iW9Zm4rex6wlB3KfuPddr8rQkVYJm49ls6knSNe
+BOIFFpEjwAsykej5L6IIELr0Y+0WGoF6mkjvs7H/2Vhup8fQBgA0nZLcuSZ2jMX
--000000000000d4726f05ee9810d1--
