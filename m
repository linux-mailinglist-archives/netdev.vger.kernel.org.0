Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB146587F5
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 00:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiL1XyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 18:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiL1XyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 18:54:01 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF10313F3B
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 15:53:59 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id u8so9013410ilq.13
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 15:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UhJ3z+B4/9UHL/EtBm+JGiuSvaHOACagrzdZlbSmXZ8=;
        b=ZdHOIgRO6djDFX2B2eHAWSOyAs5cDLHnqtVv6etMZP8qBfDqLPE7aLGixUwFqxQJzE
         tj9wdg1/R/6SwJC7vKruknmmho5XGjn4ATi+42QFvuyaePMRehmNHKFjivtKE9nV5iOe
         kLDj6UguPNYIEE+MYrgBtuAF4EkXK5Ww3WgF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UhJ3z+B4/9UHL/EtBm+JGiuSvaHOACagrzdZlbSmXZ8=;
        b=muAR3mnPa3jA5Pmy7He/GQpTlP0iGJwf3sdHyOWeRez3ObqtoUQ8moL8DLx5r2RXMh
         w/hlYxd2FZB26KpXEshqxTLP7QGc4x/jX/IaP/v1oJyZAAFXVN6ko7SGk7RSztzWJ5I5
         veIF0eXrfvM9WErPYYCMBB4wFnTE/y6Kmjj7M+vbKFGca+7DfE7PJ3dgPsl9cQQRNit4
         ZBAPzxJ1MlDhsDl7RZLys1de81Wda0V/6XGfib11Hhd8o9GfScEN8iekqGBUtXCXHpp8
         Hhokgs8TcrWkNgW1A2aayGY/NS/9/8PTfbFqPkadi0cRX8wfstlUl5c9XXw65NC+/+BT
         EJhg==
X-Gm-Message-State: AFqh2ko1YT1dDR32J4HABhEWnZAGLhT6j/S0PDlHfe0NEcl8JTA0StmO
        2vqLIGUL0AcwdmzP4L8aOckuUwAY8yqljbFK3Zlv/g==
X-Google-Smtp-Source: AMrXdXsUq0XB1vhcZNCE8V9j1ASyiPIUpae+2rlw2oOR18UfcVpJpl2IFQPbHNnpEmm/YjBVzhD+TwPq530GIdgH6Bw=
X-Received: by 2002:a92:4a11:0:b0:30b:b565:2b9e with SMTP id
 m17-20020a924a11000000b0030bb5652b9emr1942690ilf.158.1672271639002; Wed, 28
 Dec 2022 15:53:59 -0800 (PST)
MIME-Version: 1.0
References: <20221220075215.1.Ic12e347e0d61a618124b742614e82bbd5d770173@changeid>
 <CAA93jw7Qi1rfBRxaG=5ARshDwepO=b_Qg3BXFi2AHSG7cO44uw@mail.gmail.com>
In-Reply-To: <CAA93jw7Qi1rfBRxaG=5ARshDwepO=b_Qg3BXFi2AHSG7cO44uw@mail.gmail.com>
From:   Abhishek Kumar <kuabhs@chromium.org>
Date:   Wed, 28 Dec 2022 15:53:48 -0800
Message-ID: <CACTWRwva2ukMkoyztYtC7vNEzbWvfgashF_OhT3T=giyixVUXg@mail.gmail.com>
Subject: Re: [PATCH] ath10k: snoc: enable threaded napi on WCN3990
To:     Dave Taht <dave.taht@gmail.com>
Cc:     kvalo@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apologies for the late reply, Thanks Dave for your comment. My answer is in=
line.

On Tue, Dec 20, 2022 at 7:10 AM Dave Taht <dave.taht@gmail.com> wrote:
>
> I am always interested in flent.org tcp_nup, tcp_ndown, and rrul_be
> tests on wifi hardware. In AP mode, especially, against a few clients
> in rtt_fair on the "ending the anomaly" test suite at the bottom of
> this link: https://www.cs.kau.se/tohojo/airtime-fairness/ . Of these,
> it's trying to optimize bandwidth more fairly and keep latencies low
> when 4 or more stations are trying to transmit (in a world with 16 or
> more stations online), that increasingly bothers me the most. I'm
> seeing 5+ seconds on some rtt_fair-like tests nowadays.
I used testing using iperf and conductive setup and fetched the
throughput data(mentioned below).
>
> I was also seeing huge simultaneous upload vs download disparities on
> the latest kernels, on various threads over here:
> https://forum.openwrt.org/t/aql-and-the-ath10k-is-lovely/59002 and
> more recently here:
> https://forum.openwrt.org/t/reducing-multiplexing-latencies-still-further=
-in-wifi/133605
Interesting, thanks for the pointer and probably the Qualcomm team is
aware of it.
>
> I don't understand why napi with the default budget (64) is even
> needed on the ath10k, as a single txop takes a minimum of ~200us, but
> perhaps your patch will help. Still, measuring the TCP statistics
> in-band would be nice to see. Some new tools are appearing that can do
> this, Apple's goresponsiveness, crusader... that are simpler to use
> than flent.
Here are some of the additional raw data with and without threaded napi:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
udp_rx(Without threaded NAPI)
435.98+-5.16 : Channel 44
439.06+-0.66 : Channel 157

udp_rx(With threaded NAPI)
509.73+-41.03 : Channel 44
549.97+-7.62 : Channel 157
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
udp_tx(Without threaded NAPI)
461.31+-0.69  : Channel 44
461.46+-0.78 : Channel 157

udp_tx(With threaded NAPI)
459.20+-0.77 : Channel 44
459.78+-1.08 : Channel 157
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
tcp_rx(Without threaded NAPI)
472.63+-2.35 : Channel 44
469.29+-6.31 : Channel 157

tcp_rx(With threaded NAPI)
498.49+-2.44 : Channel 44
541.14+-40.65 : Channel 157
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
tcp_tx(Without threaded NAPI)
317.34+-2.37 : Channel 44
317.01+-2.56 : Channel 157

tcp_tx(With threaded NAPI)
371.34+-2.36 : Channel 44
376.95+-9.40 : Channel 157
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D

>
> On Tue, Dec 20, 2022 at 12:17 AM Abhishek Kumar <kuabhs@chromium.org> wro=
te:
> >
> > NAPI poll can be done in threaded context along with soft irq
> > context. Threaded context can be scheduled efficiently, thus
> > creating less of bottleneck during Rx processing. This patch is
> > to enable threaded NAPI on ath10k driver.
> >
> > Based on testing, it was observed that on WCN3990, the CPU0 reaches
> > 100% utilization when napi runs in softirq context. At the same
> > time the other CPUs are at low consumption percentage. This
> > does not allow device to reach its maximum throughput potential.
> > After enabling threaded napi, CPU load is balanced across all CPUs
> > and following improvments were observed:
> > - UDP_RX increase by ~22-25%
> > - TCP_RX increase by ~15%
> >
> > Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
> > Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> > ---
> >
> >  drivers/net/wireless/ath/ath10k/core.c | 16 ++++++++++++++++
> >  drivers/net/wireless/ath/ath10k/hw.h   |  2 ++
> >  drivers/net/wireless/ath/ath10k/snoc.c |  3 +++
> >  3 files changed, 21 insertions(+)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wirel=
ess/ath/ath10k/core.c
> > index 5eb131ab916fd..ee4b6ba508c81 100644
> > --- a/drivers/net/wireless/ath/ath10k/core.c
> > +++ b/drivers/net/wireless/ath/ath10k/core.c
> > @@ -100,6 +100,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D QCA988X_HW_2_0_VERSION,
> > @@ -140,6 +141,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D QCA9887_HW_1_0_VERSION,
> > @@ -181,6 +183,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D QCA6174_HW_3_2_VERSION,
> > @@ -217,6 +220,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D QCA6174_HW_2_1_VERSION,
> > @@ -257,6 +261,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D QCA6174_HW_2_1_VERSION,
> > @@ -297,6 +302,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D QCA6174_HW_3_0_VERSION,
> > @@ -337,6 +343,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D QCA6174_HW_3_2_VERSION,
> > @@ -381,6 +388,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D QCA99X0_HW_2_0_DEV_VERSION,
> > @@ -427,6 +435,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D QCA9984_HW_1_0_DEV_VERSION,
> > @@ -480,6 +489,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D QCA9888_HW_2_0_DEV_VERSION,
> > @@ -530,6 +540,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D QCA9377_HW_1_0_DEV_VERSION,
> > @@ -570,6 +581,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D QCA9377_HW_1_1_DEV_VERSION,
> > @@ -612,6 +624,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D QCA9377_HW_1_1_DEV_VERSION,
> > @@ -645,6 +658,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D QCA4019_HW_1_0_DEV_VERSION,
> > @@ -692,6 +706,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D false,
> >                 .use_fw_tx_credits =3D true,
> >                 .delay_unmap_buffer =3D false,
> > +               .enable_threaded_napi =3D false,
> >         },
> >         {
> >                 .id =3D WCN3990_HW_1_0_DEV_VERSION,
> > @@ -725,6 +740,7 @@ static const struct ath10k_hw_params ath10k_hw_para=
ms_list[] =3D {
> >                 .hw_restart_disconnect =3D true,
> >                 .use_fw_tx_credits =3D false,
> >                 .delay_unmap_buffer =3D true,
> > +               .enable_threaded_napi =3D true,
> >         },
> >  };
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireles=
s/ath/ath10k/hw.h
> > index 9643031a4427a..adf3076b96503 100644
> > --- a/drivers/net/wireless/ath/ath10k/hw.h
> > +++ b/drivers/net/wireless/ath/ath10k/hw.h
> > @@ -639,6 +639,8 @@ struct ath10k_hw_params {
> >         bool use_fw_tx_credits;
> >
> >         bool delay_unmap_buffer;
> > +
> > +       bool enable_threaded_napi;
> >  };
> >
> >  struct htt_resp;
> > diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wirel=
ess/ath/ath10k/snoc.c
> > index cfcb759a87dea..b94150fb6ef06 100644
> > --- a/drivers/net/wireless/ath/ath10k/snoc.c
> > +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> > @@ -927,6 +927,9 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
> >
> >         bitmap_clear(ar_snoc->pending_ce_irqs, 0, CE_COUNT_MAX);
> >
> > +       if (ar->hw_params.enable_threaded_napi)
> > +               dev_set_threaded(&ar->napi_dev, true);
> > +
> >         ath10k_core_napi_enable(ar);
> >         ath10k_snoc_irq_enable(ar);
> >         ath10k_snoc_rx_post(ar);
> > --
> > 2.39.0.314.g84b9a713c41-goog
> >
>
>
> --
> This song goes out to all the folk that thought Stadia would work:
> https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-698136666=
5607352320-FXtz
> Dave T=C3=A4ht CEO, TekLibre, LLC
