Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7643D65237A
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 16:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiLTPKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 10:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbiLTPKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 10:10:40 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D30D301;
        Tue, 20 Dec 2022 07:10:38 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id y16so12049829wrm.2;
        Tue, 20 Dec 2022 07:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lr9AVfm10LzRAZpy4+5D7cvTFDu/zEzjOWE+1rGSMUA=;
        b=Ow34D0WtZ8vf/7IKCPWxmRhNMt3UuVJO5F6Ie0EItmu7v+ur/NiICu0PKTiwhrNvD0
         iBne+gG1O6884DWGz5nAwBqzR4Sbzb0qbNEuIQrzCfaTFTs8d+ljvi04YAbVNVrfXqDx
         4yP6aObGVc/uNRKSSm/HRiC2cBtDii/wegvUx/rxa2K5ogoDXM0vcjBshp/P24iVdhPc
         EeEbUOel4WQ6Qr2KsqXQ0Fir1fMLfu29G7hQ+18Z16tEc+eeZEcqAGKCWMV/YDK0iLo1
         L97xLbN6RTD8FpRfeU5vB/mhj6tOMSeagQ3FjpSunUIScXHfyZiB8WB7vcYLE8uHlDdA
         CXaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lr9AVfm10LzRAZpy4+5D7cvTFDu/zEzjOWE+1rGSMUA=;
        b=VB5ZxPSizFQ2X2fVJD2s2zCL0Bd2YeksUgeiGiPURy5sspj49LuaU2Pl1FZdmHke+A
         n9veyxGMf9SvLphIAq7Xhc4m5tyTFzXvsfQ2IJGazcJV6vCmyvt/JK9+VV8dTB1pNNF+
         qYqTePgcFau6l+OOYDm01pQXX4YdtqoZB68Qudrvbar86vlpE74NYHIhnVEc1b8Zn65r
         8MNtUEaMEe6o7Ah/JdEiV2C+QRbyxgjZVnr4/GeCt9Fi7EKsfH2uPFohfxCQiUwRBmSJ
         XCwvkDHFtJt7Q/zjwE95F/4M6wy3t8noFt4YfQuzofLcIMijXhH31l7KnQtF6USRaRE4
         PEtg==
X-Gm-Message-State: ANoB5pmWAwrOVJ43CaYTK/NAYkHSu6zVx9QPjOSmMiQq3UrIZvXrHSr1
        e+Tz3A+f6qOosvcpKQUlOT/K+vrUUGshI+jp1TA=
X-Google-Smtp-Source: AA0mqf4z0IYN8h/my+4Y2tn+vHBA2ekOyKsR6wg27aNTif4lxwhgHiVs6vHWxbqzkPdBBa5Uci5Z7iz1p0z9skBBIp4=
X-Received: by 2002:a5d:510c:0:b0:242:82f5:fe65 with SMTP id
 s12-20020a5d510c000000b0024282f5fe65mr4799109wrt.688.1671549036567; Tue, 20
 Dec 2022 07:10:36 -0800 (PST)
MIME-Version: 1.0
References: <20221220075215.1.Ic12e347e0d61a618124b742614e82bbd5d770173@changeid>
In-Reply-To: <20221220075215.1.Ic12e347e0d61a618124b742614e82bbd5d770173@changeid>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 20 Dec 2022 07:10:23 -0800
Message-ID: <CAA93jw7Qi1rfBRxaG=5ARshDwepO=b_Qg3BXFi2AHSG7cO44uw@mail.gmail.com>
Subject: Re: [PATCH] ath10k: snoc: enable threaded napi on WCN3990
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     kvalo@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am always interested in flent.org tcp_nup, tcp_ndown, and rrul_be
tests on wifi hardware. In AP mode, especially, against a few clients
in rtt_fair on the "ending the anomaly" test suite at the bottom of
this link: https://www.cs.kau.se/tohojo/airtime-fairness/ . Of these,
it's trying to optimize bandwidth more fairly and keep latencies low
when 4 or more stations are trying to transmit (in a world with 16 or
more stations online), that increasingly bothers me the most. I'm
seeing 5+ seconds on some rtt_fair-like tests nowadays.

I was also seeing huge simultaneous upload vs download disparities on
the latest kernels, on various threads over here:
https://forum.openwrt.org/t/aql-and-the-ath10k-is-lovely/59002 and
more recently here:
https://forum.openwrt.org/t/reducing-multiplexing-latencies-still-further-i=
n-wifi/133605

I don't understand why napi with the default budget (64) is even
needed on the ath10k, as a single txop takes a minimum of ~200us, but
perhaps your patch will help. Still, measuring the TCP statistics
in-band would be nice to see. Some new tools are appearing that can do
this, Apple's goresponsiveness, crusader... that are simpler to use
than flent.

On Tue, Dec 20, 2022 at 12:17 AM Abhishek Kumar <kuabhs@chromium.org> wrote=
:
>
> NAPI poll can be done in threaded context along with soft irq
> context. Threaded context can be scheduled efficiently, thus
> creating less of bottleneck during Rx processing. This patch is
> to enable threaded NAPI on ath10k driver.
>
> Based on testing, it was observed that on WCN3990, the CPU0 reaches
> 100% utilization when napi runs in softirq context. At the same
> time the other CPUs are at low consumption percentage. This
> does not allow device to reach its maximum throughput potential.
> After enabling threaded napi, CPU load is balanced across all CPUs
> and following improvments were observed:
> - UDP_RX increase by ~22-25%
> - TCP_RX increase by ~15%
>
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> ---
>
>  drivers/net/wireless/ath/ath10k/core.c | 16 ++++++++++++++++
>  drivers/net/wireless/ath/ath10k/hw.h   |  2 ++
>  drivers/net/wireless/ath/ath10k/snoc.c |  3 +++
>  3 files changed, 21 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireles=
s/ath/ath10k/core.c
> index 5eb131ab916fd..ee4b6ba508c81 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -100,6 +100,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D QCA988X_HW_2_0_VERSION,
> @@ -140,6 +141,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D QCA9887_HW_1_0_VERSION,
> @@ -181,6 +183,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D QCA6174_HW_3_2_VERSION,
> @@ -217,6 +220,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D QCA6174_HW_2_1_VERSION,
> @@ -257,6 +261,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D QCA6174_HW_2_1_VERSION,
> @@ -297,6 +302,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D QCA6174_HW_3_0_VERSION,
> @@ -337,6 +343,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D QCA6174_HW_3_2_VERSION,
> @@ -381,6 +388,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D QCA99X0_HW_2_0_DEV_VERSION,
> @@ -427,6 +435,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D QCA9984_HW_1_0_DEV_VERSION,
> @@ -480,6 +489,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D QCA9888_HW_2_0_DEV_VERSION,
> @@ -530,6 +540,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D QCA9377_HW_1_0_DEV_VERSION,
> @@ -570,6 +581,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D QCA9377_HW_1_1_DEV_VERSION,
> @@ -612,6 +624,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D QCA9377_HW_1_1_DEV_VERSION,
> @@ -645,6 +658,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D QCA4019_HW_1_0_DEV_VERSION,
> @@ -692,6 +706,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D false,
>                 .use_fw_tx_credits =3D true,
>                 .delay_unmap_buffer =3D false,
> +               .enable_threaded_napi =3D false,
>         },
>         {
>                 .id =3D WCN3990_HW_1_0_DEV_VERSION,
> @@ -725,6 +740,7 @@ static const struct ath10k_hw_params ath10k_hw_params=
_list[] =3D {
>                 .hw_restart_disconnect =3D true,
>                 .use_fw_tx_credits =3D false,
>                 .delay_unmap_buffer =3D true,
> +               .enable_threaded_napi =3D true,
>         },
>  };
>
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/=
ath/ath10k/hw.h
> index 9643031a4427a..adf3076b96503 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -639,6 +639,8 @@ struct ath10k_hw_params {
>         bool use_fw_tx_credits;
>
>         bool delay_unmap_buffer;
> +
> +       bool enable_threaded_napi;
>  };
>
>  struct htt_resp;
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireles=
s/ath/ath10k/snoc.c
> index cfcb759a87dea..b94150fb6ef06 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -927,6 +927,9 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
>
>         bitmap_clear(ar_snoc->pending_ce_irqs, 0, CE_COUNT_MAX);
>
> +       if (ar->hw_params.enable_threaded_napi)
> +               dev_set_threaded(&ar->napi_dev, true);
> +
>         ath10k_core_napi_enable(ar);
>         ath10k_snoc_irq_enable(ar);
>         ath10k_snoc_rx_post(ar);
> --
> 2.39.0.314.g84b9a713c41-goog
>


--=20
This song goes out to all the folk that thought Stadia would work:
https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666656=
07352320-FXtz
Dave T=C3=A4ht CEO, TekLibre, LLC
