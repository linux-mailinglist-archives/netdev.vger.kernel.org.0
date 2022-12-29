Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1295065882E
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 01:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbiL2Atj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 19:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiL2Ath (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 19:49:37 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C2312AFC;
        Wed, 28 Dec 2022 16:49:35 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id m3so3331712wmq.0;
        Wed, 28 Dec 2022 16:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h0aKzK2WcOLHlj2zf74NduzI7ZCJ04r9Hox6CkO9JYY=;
        b=RdLkcOLl+Tq7dUUdBDfwfao6ut/jpYAqcPYHMygHVqdzirWAi/r3BNFZiSdL//m2BL
         GkA/UL6J+2a5pwBhb9cioWtS1/ci97t1/5FWa9IxxdMQelHwKbAGQeyfyRjpxw38wW0v
         naOgE3UOqf/n1AJwQF2AO8HivsOcpWtqc5Ql5OwIRdzEN1BFNQ8RLoUG9zdl23T432rQ
         xoNrC/C1M6GQ2G7uNDfhOCnnlsx5ZD0ndVknSZSqSFI96ZV+I2vkU/Dgr7XQ/mj9vTkR
         1E3AoDGMTGtrEVEVOh0qmlhvvpRCnfBU98Zn5j8BSsJ0e8OOOZCPx9gDTXiqNV3EMe44
         BcKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h0aKzK2WcOLHlj2zf74NduzI7ZCJ04r9Hox6CkO9JYY=;
        b=4NTah9LNaMNJR++JpKH8xArTso6cMpKM+AkSpvqJwWYET02QxzoNYp75sdfGcDnC5e
         kiraQN1br8Iybb+vhCPjXqTsxRIoPkHGep39bCLUf3ZXlOqwppuykcE7zGWQIffXvWhy
         vf37cMyePcPFSMJ7OjqwEfreNfO/tGNlfPswaOeb5PWBqfYuRW9w1UkVJ6eALCBlszll
         g1/4KdRx6QQuip6VJgLGY5/EerStZoBjLrMqh/WjYc6epLkIDRMXBtILYG4W2XuOpxiX
         LIl/ld1UBOwC0ishnhRBQRHnqwok3HCEeUKoNpQ0lG+04q91WdpV85bCpMmoVMt/9Klk
         2kJA==
X-Gm-Message-State: AFqh2ko+6mwwSQZfSFHhcudM++gDfTdijcBQZFHhaxBNhcRIhzl6SgrI
        lenWUaDoR4pUMoGHVv9QWzwVg1On2Z5Ag8Dsf2c=
X-Google-Smtp-Source: AMrXdXtCaQ3iWI0lP2FrFTLt83vR/p6Uh2QNpr8rCoV9AvIDHb3XrYiWjTRG8v+bRwkHszks5nJU4hV/gPIBTCSt+K0=
X-Received: by 2002:a7b:c7cb:0:b0:3cf:a511:3217 with SMTP id
 z11-20020a7bc7cb000000b003cfa5113217mr1299316wmk.205.1672274974203; Wed, 28
 Dec 2022 16:49:34 -0800 (PST)
MIME-Version: 1.0
References: <20221220075215.1.Ic12e347e0d61a618124b742614e82bbd5d770173@changeid>
 <CAA93jw7Qi1rfBRxaG=5ARshDwepO=b_Qg3BXFi2AHSG7cO44uw@mail.gmail.com> <CACTWRwva2ukMkoyztYtC7vNEzbWvfgashF_OhT3T=giyixVUXg@mail.gmail.com>
In-Reply-To: <CACTWRwva2ukMkoyztYtC7vNEzbWvfgashF_OhT3T=giyixVUXg@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 28 Dec 2022 16:49:22 -0800
Message-ID: <CAA93jw7GCUnVjHNkxCfaP76d3HH8Rqm2EOq0FSY8a0tVXkKrDw@mail.gmail.com>
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

On Wed, Dec 28, 2022 at 3:53 PM Abhishek Kumar <kuabhs@chromium.org> wrote:
>
> Apologies for the late reply, Thanks Dave for your comment. My answer is =
inline.
>
> On Tue, Dec 20, 2022 at 7:10 AM Dave Taht <dave.taht@gmail.com> wrote:
> >
> > I am always interested in flent.org tcp_nup, tcp_ndown, and rrul_be
> > tests on wifi hardware. In AP mode, especially, against a few clients
> > in rtt_fair on the "ending the anomaly" test suite at the bottom of
> > this link: https://www.cs.kau.se/tohojo/airtime-fairness/ . Of these,
> > it's trying to optimize bandwidth more fairly and keep latencies low
> > when 4 or more stations are trying to transmit (in a world with 16 or
> > more stations online), that increasingly bothers me the most. I'm
> > seeing 5+ seconds on some rtt_fair-like tests nowadays.
> I used testing using iperf and conductive setup and fetched the
> throughput data(mentioned below).
> >
> > I was also seeing huge simultaneous upload vs download disparities on
> > the latest kernels, on various threads over here:
> > https://forum.openwrt.org/t/aql-and-the-ath10k-is-lovely/59002 and
> > more recently here:
> > https://forum.openwrt.org/t/reducing-multiplexing-latencies-still-furth=
er-in-wifi/133605
> Interesting, thanks for the pointer and probably the Qualcomm team is
> aware of it.
> >
> > I don't understand why napi with the default budget (64) is even
> > needed on the ath10k, as a single txop takes a minimum of ~200us, but
> > perhaps your patch will help. Still, measuring the TCP statistics
> > in-band would be nice to see. Some new tools are appearing that can do
> > this, Apple's goresponsiveness, crusader... that are simpler to use
> > than flent.
> Here are some of the additional raw data with and without threaded napi:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> udp_rx(Without threaded NAPI)
> 435.98+-5.16 : Channel 44
> 439.06+-0.66 : Channel 157
>
> udp_rx(With threaded NAPI)
> 509.73+-41.03 : Channel 44
> 549.97+-7.62 : Channel 157
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> udp_tx(Without threaded NAPI)
> 461.31+-0.69  : Channel 44
> 461.46+-0.78 : Channel 157
>
> udp_tx(With threaded NAPI)
> 459.20+-0.77 : Channel 44
> 459.78+-1.08 : Channel 157
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> tcp_rx(Without threaded NAPI)
> 472.63+-2.35 : Channel 44
> 469.29+-6.31 : Channel 157
>
> tcp_rx(With threaded NAPI)
> 498.49+-2.44 : Channel 44
> 541.14+-40.65 : Channel 157
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> tcp_tx(Without threaded NAPI)
> 317.34+-2.37 : Channel 44
> 317.01+-2.56 : Channel 157
>
> tcp_tx(With threaded NAPI)
> 371.34+-2.36 : Channel 44
> 376.95+-9.40 : Channel 157

My concern is primarily with the induced tcp latency on this test. A
way to check that is to run wireshark on your test client driving the
test, capture the iperf traffic, and then plot the "Statistics->TCP
stream statistics for both throughput and rtt. Would it be possible
for you to do that and put up those plots somewhere?

The worst case test is a tcp bidirectional test which I don't know if
older iperfs can do. (iperf2 has new bounceback and bidir tests)

Ideally stuff going in either direction, would not look as horrible,
as it did, back in 2016, documented in this linuxplumbers presentation
here: https://blog.linuxplumbersconf.org/2016/ocw/system/presentations/3963=
/original/linuxplumbers_wifi_latency-3Nov.pdf
and discussed on lwn, here: https://lwn.net/Articles/705884/

I worry about folk achieving slightly better tcp throughput at the
expense of clobbering in-tcp-stream latency. Back then we were
shooting for no more than 40ms extra latency under load on this chip,
down from (unusable) seconds. Presently elsewhere, on other chips,
we're getting 8ms with stuff that's not in tree for the ath10k, there
is a slight cost in single stream throughput but when multiple streams
are in use, on multiple stations, things like web pages fly,
irrespective of load.


> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>
> >
> > On Tue, Dec 20, 2022 at 12:17 AM Abhishek Kumar <kuabhs@chromium.org> w=
rote:
> > >
> > > NAPI poll can be done in threaded context along with soft irq
> > > context. Threaded context can be scheduled efficiently, thus
> > > creating less of bottleneck during Rx processing. This patch is
> > > to enable threaded NAPI on ath10k driver.
> > >
> > > Based on testing, it was observed that on WCN3990, the CPU0 reaches
> > > 100% utilization when napi runs in softirq context. At the same
> > > time the other CPUs are at low consumption percentage. This
> > > does not allow device to reach its maximum throughput potential.
> > > After enabling threaded napi, CPU load is balanced across all CPUs
> > > and following improvments were observed:
> > > - UDP_RX increase by ~22-25%
> > > - TCP_RX increase by ~15%
> > >
> > > Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
> > > Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> > > ---
> > >
> > >  drivers/net/wireless/ath/ath10k/core.c | 16 ++++++++++++++++
> > >  drivers/net/wireless/ath/ath10k/hw.h   |  2 ++
> > >  drivers/net/wireless/ath/ath10k/snoc.c |  3 +++
> > >  3 files changed, 21 insertions(+)
> > >
> > > diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wir=
eless/ath/ath10k/core.c
> > > index 5eb131ab916fd..ee4b6ba508c81 100644
> > > --- a/drivers/net/wireless/ath/ath10k/core.c
> > > +++ b/drivers/net/wireless/ath/ath10k/core.c
> > > @@ -100,6 +100,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D QCA988X_HW_2_0_VERSION,
> > > @@ -140,6 +141,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D QCA9887_HW_1_0_VERSION,
> > > @@ -181,6 +183,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D QCA6174_HW_3_2_VERSION,
> > > @@ -217,6 +220,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D QCA6174_HW_2_1_VERSION,
> > > @@ -257,6 +261,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D QCA6174_HW_2_1_VERSION,
> > > @@ -297,6 +302,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D QCA6174_HW_3_0_VERSION,
> > > @@ -337,6 +343,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D QCA6174_HW_3_2_VERSION,
> > > @@ -381,6 +388,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D QCA99X0_HW_2_0_DEV_VERSION,
> > > @@ -427,6 +435,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D QCA9984_HW_1_0_DEV_VERSION,
> > > @@ -480,6 +489,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D QCA9888_HW_2_0_DEV_VERSION,
> > > @@ -530,6 +540,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D QCA9377_HW_1_0_DEV_VERSION,
> > > @@ -570,6 +581,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D QCA9377_HW_1_1_DEV_VERSION,
> > > @@ -612,6 +624,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D QCA9377_HW_1_1_DEV_VERSION,
> > > @@ -645,6 +658,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D QCA4019_HW_1_0_DEV_VERSION,
> > > @@ -692,6 +706,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D false,
> > >                 .use_fw_tx_credits =3D true,
> > >                 .delay_unmap_buffer =3D false,
> > > +               .enable_threaded_napi =3D false,
> > >         },
> > >         {
> > >                 .id =3D WCN3990_HW_1_0_DEV_VERSION,
> > > @@ -725,6 +740,7 @@ static const struct ath10k_hw_params ath10k_hw_pa=
rams_list[] =3D {
> > >                 .hw_restart_disconnect =3D true,
> > >                 .use_fw_tx_credits =3D false,
> > >                 .delay_unmap_buffer =3D true,
> > > +               .enable_threaded_napi =3D true,
> > >         },
> > >  };
> > >
> > > diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wirel=
ess/ath/ath10k/hw.h
> > > index 9643031a4427a..adf3076b96503 100644
> > > --- a/drivers/net/wireless/ath/ath10k/hw.h
> > > +++ b/drivers/net/wireless/ath/ath10k/hw.h
> > > @@ -639,6 +639,8 @@ struct ath10k_hw_params {
> > >         bool use_fw_tx_credits;
> > >
> > >         bool delay_unmap_buffer;
> > > +
> > > +       bool enable_threaded_napi;
> > >  };
> > >
> > >  struct htt_resp;
> > > diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wir=
eless/ath/ath10k/snoc.c
> > > index cfcb759a87dea..b94150fb6ef06 100644
> > > --- a/drivers/net/wireless/ath/ath10k/snoc.c
> > > +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> > > @@ -927,6 +927,9 @@ static int ath10k_snoc_hif_start(struct ath10k *a=
r)
> > >
> > >         bitmap_clear(ar_snoc->pending_ce_irqs, 0, CE_COUNT_MAX);
> > >
> > > +       if (ar->hw_params.enable_threaded_napi)
> > > +               dev_set_threaded(&ar->napi_dev, true);
> > > +
> > >         ath10k_core_napi_enable(ar);
> > >         ath10k_snoc_irq_enable(ar);
> > >         ath10k_snoc_rx_post(ar);
> > > --
> > > 2.39.0.314.g84b9a713c41-goog
> > >
> >
> >
> > --
> > This song goes out to all the folk that thought Stadia would work:
> > https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-6981366=
665607352320-FXtz
> > Dave T=C3=A4ht CEO, TekLibre, LLC



--=20
This song goes out to all the folk that thought Stadia would work:
https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666656=
07352320-FXtz
Dave T=C3=A4ht CEO, TekLibre, LLC
