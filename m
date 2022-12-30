Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC98F659471
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 04:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbiL3Dox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 22:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiL3Dov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 22:44:51 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4713BF4E;
        Thu, 29 Dec 2022 19:44:49 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id o15so14456433wmr.4;
        Thu, 29 Dec 2022 19:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7SCmKb4wHHEPv7jZefX0x45EikS95iCFOxj9ylY5GQ=;
        b=qkbP+v8Wr3eDhUIwIzxfj6Thg27BrsWR9MnUVJmaKbAQkXlc8eyYQk8z5n+VlAIY+4
         rgVXR8nNs611TYLbiVeFXA8lMnbtjL4osNlvW5Du5dUMYhIqk0wglltjIHuM1s6a6wPH
         6/MYJW0Z14RHPCt+bqgfci/WNCLpR8a8WTkrGa/ruPmTewPkDKmUIuJZq9NO++zxES/3
         CmA+ChXuyTXsyfiUuhcBxuq53IKltMfTNr9j1jM+jDt9FukSn7k65ZgeNR4fWLX8ehkt
         SvKKEaok9EJHCSV5871rgRTM23guNRMpZE38KFVMkeHU397n+G1gqzlSVKwlhiqqc0hJ
         +kwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g7SCmKb4wHHEPv7jZefX0x45EikS95iCFOxj9ylY5GQ=;
        b=kH1N0gX+FAtHZIX4KkcPavhjMn/9eaDHdxF3s0ghewzpn84uWF30eoC6yy3WqU29NY
         RyJPmmKXOQJKafdDr7kTRv65XN2d51luja4mE0dm7v9zCHqKf5YJb1g5tDvfXGoFbRYI
         atpSAeCSV8qoJ8gWOrfoBmg8joX1neQJIQs7qgdag3NxmC1bekfJ/kSNnUzc7omnFUZ1
         qHc+RHKEqMfoLRZoour7LYs5WUfpPpubpp+Dany+UOVh9JAw2AiSp/sTkP4KPo/m8EKz
         SioAxlCNrZ5p/8RcJxYQFZN/3cffIfIg+gvZ2vQvnwCBsNL7K/gAv6AoJDC5Y+ZESoJ1
         rqPg==
X-Gm-Message-State: AFqh2ko8EQxkxbW1+uwwHPh1f6VbxR4VrjW+p8bxezNDzjyx2c7xo9OL
        pIEv7kHvud7NydzJYUzcbCKvhUK0aHmaPBoZzmc=
X-Google-Smtp-Source: AMrXdXtFUt9nEK16pycfL/VTD+3snIKXgDN1OoGLn1Jjz2sRtINOWv9sW+AznG+6syBwc9foQg3ykJR3fStof4wVK60=
X-Received: by 2002:a05:600c:2f17:b0:3cf:a6e8:b59b with SMTP id
 r23-20020a05600c2f1700b003cfa6e8b59bmr2068434wmn.128.1672371887959; Thu, 29
 Dec 2022 19:44:47 -0800 (PST)
MIME-Version: 1.0
References: <20221220075215.1.Ic12e347e0d61a618124b742614e82bbd5d770173@changeid>
 <CAA93jw7Qi1rfBRxaG=5ARshDwepO=b_Qg3BXFi2AHSG7cO44uw@mail.gmail.com>
 <CACTWRwva2ukMkoyztYtC7vNEzbWvfgashF_OhT3T=giyixVUXg@mail.gmail.com>
 <CAA93jw7GCUnVjHNkxCfaP76d3HH8Rqm2EOq0FSY8a0tVXkKrDw@mail.gmail.com> <CAHb6Lvpta1fJef-M1LasR5zzzudJ2+CNyWwrSo3DU9OoeiFfzA@mail.gmail.com>
In-Reply-To: <CAHb6Lvpta1fJef-M1LasR5zzzudJ2+CNyWwrSo3DU9OoeiFfzA@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 29 Dec 2022 19:44:36 -0800
Message-ID: <CAA93jw6F1WLDu=Fq2pDt+gswWkJpygv4CDswD06v=yoCMgHo6A@mail.gmail.com>
Subject: Re: [Make-wifi-fast] [PATCH] ath10k: snoc: enable threaded napi on WCN3990
To:     Bob McMahon <bob.mcmahon@broadcom.com>
Cc:     Abhishek Kumar <kuabhs@chromium.org>, netdev@vger.kernel.org,
        kvalo@kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
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

thx for leaning in bob! (for those of you that don't know, he's the
iperf2 maintainer, and if you haven't updated your distro/os/test
environment to 2.1.8 that came out in august, yet there's all kinds of
nifty new stuff in there: https://sourceforge.net/projects/iperf2 -
too much to list, and the -i 1 -e option is just the start of it....

Iperf2's principal flaw is that people think iperf3 is the successor
to it, and no, they are very different codebases, with very different
features. iperf =3D iperf2, for most, but not all.

On Wed, Dec 28, 2022 at 9:54 PM Bob McMahon <bob.mcmahon@broadcom.com> wrot=
e:
>
> A bit of a tangent but iperf 2's enhanced option provides sampled RTT and=
 CWND in the interval output. I requires -e. It also provide the connect ti=
me, the icwnd, irtt and the mss per the connect.
>
> [rjmcmahon@rjm-nas ~]$ iperf -c 192.168.1.85 -i 1 -e
> ------------------------------------------------------------
> Client connecting to 192.168.1.85, TCP port 5001 with pid 20041 (1 flows)
> Write buffer size: 131072 Byte
> TOS set to 0x0 (Nagle on)
> TCP window size: 16.0 KByte (default)
> ------------------------------------------------------------
> [  1] local 192.168.1.73%eno1 port 38822 connected with 192.168.1.85 port=
 5001 (sock=3D3) (icwnd/mss/irtt=3D14/1448/246) (ct=3D0.32 ms) on 2022-12-2=
8 21:51:13 (PST)
> [ ID] Interval        Transfer    Bandwidth       Write/Err  Rtry     Cwn=
d/RTT(var)        NetPwr
> [  1] 0.00-1.00 sec   114 MBytes   952 Mbits/sec  908/0         3      35=
3K/1901(59) us  62606
> [  1] 1.00-2.00 sec   111 MBytes   932 Mbits/sec  889/0         0      35=
4K/2029(115) us  57429
> [  1] 2.00-3.00 sec   112 MBytes   937 Mbits/sec  894/0         3      35=
4K/2061(84) us  56855
> [  1] 3.00-4.00 sec   112 MBytes   938 Mbits/sec  895/0         3      35=
4K/2027(115) us  57873
> [  1] 4.00-5.00 sec   112 MBytes   938 Mbits/sec  895/0         6      35=
4K/2046(68) us  57336
> [  1] 5.00-6.00 sec   112 MBytes   937 Mbits/sec  894/0         0      37=
4K/2160(109) us  54249
> [  1] 6.00-7.00 sec   111 MBytes   933 Mbits/sec  890/0         2      37=
4K/2155(115) us  54132
> [  1] 7.00-8.00 sec   111 MBytes   934 Mbits/sec  891/0         2      37=
4K/2139(120) us  54598
> [  1] 8.00-9.00 sec   112 MBytes   938 Mbits/sec  895/0         0      37=
4K/2129(126) us  55101
> [  1] 9.00-10.00 sec   112 MBytes   935 Mbits/sec  892/0         1      3=
74K/2200(102) us  53144
> [  1] 0.00-10.03 sec  1.09 GBytes   935 Mbits/sec  8944/0        20      =
374K/4082(4010) us  28632

This is a wonderful new feature, much simpler than relying on packet
captures. However! this test result above is on a decent, ethernet,
network, where on wifi, or anything bufferbloated, you would see the
cwnd and rtt inflate and/or bounce around horribly.


>
>
> Bob
>
> On Wed, Dec 28, 2022 at 4:49 PM Dave Taht via Make-wifi-fast <make-wifi-f=
ast@lists.bufferbloat.net> wrote:
>>
>> On Wed, Dec 28, 2022 at 3:53 PM Abhishek Kumar <kuabhs@chromium.org> wro=
te:
>> >
>> > Apologies for the late reply, Thanks Dave for your comment. My answer =
is inline.
>> >
>> > On Tue, Dec 20, 2022 at 7:10 AM Dave Taht <dave.taht@gmail.com> wrote:
>> > >
>> > > I am always interested in flent.org tcp_nup, tcp_ndown, and rrul_be
>> > > tests on wifi hardware. In AP mode, especially, against a few client=
s
>> > > in rtt_fair on the "ending the anomaly" test suite at the bottom of
>> > > this link: https://www.cs.kau.se/tohojo/airtime-fairness/ . Of these=
,
>> > > it's trying to optimize bandwidth more fairly and keep latencies low
>> > > when 4 or more stations are trying to transmit (in a world with 16 o=
r
>> > > more stations online), that increasingly bothers me the most. I'm
>> > > seeing 5+ seconds on some rtt_fair-like tests nowadays.
>> > I used testing using iperf and conductive setup and fetched the
>> > throughput data(mentioned below).
>> > >
>> > > I was also seeing huge simultaneous upload vs download disparities o=
n
>> > > the latest kernels, on various threads over here:
>> > > https://forum.openwrt.org/t/aql-and-the-ath10k-is-lovely/59002 and
>> > > more recently here:
>> > > https://forum.openwrt.org/t/reducing-multiplexing-latencies-still-fu=
rther-in-wifi/133605
>> > Interesting, thanks for the pointer and probably the Qualcomm team is
>> > aware of it.
>> > >
>> > > I don't understand why napi with the default budget (64) is even
>> > > needed on the ath10k, as a single txop takes a minimum of ~200us, bu=
t
>> > > perhaps your patch will help. Still, measuring the TCP statistics
>> > > in-band would be nice to see. Some new tools are appearing that can =
do
>> > > this, Apple's goresponsiveness, crusader... that are simpler to use
>> > > than flent.
>> > Here are some of the additional raw data with and without threaded nap=
i:
>> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>> > udp_rx(Without threaded NAPI)
>> > 435.98+-5.16 : Channel 44
>> > 439.06+-0.66 : Channel 157
>> >
>> > udp_rx(With threaded NAPI)
>> > 509.73+-41.03 : Channel 44
>> > 549.97+-7.62 : Channel 157
>> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>> > udp_tx(Without threaded NAPI)
>> > 461.31+-0.69  : Channel 44
>> > 461.46+-0.78 : Channel 157
>> >
>> > udp_tx(With threaded NAPI)
>> > 459.20+-0.77 : Channel 44
>> > 459.78+-1.08 : Channel 157
>> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>> > tcp_rx(Without threaded NAPI)
>> > 472.63+-2.35 : Channel 44
>> > 469.29+-6.31 : Channel 157
>> >
>> > tcp_rx(With threaded NAPI)
>> > 498.49+-2.44 : Channel 44
>> > 541.14+-40.65 : Channel 157
>> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>> > tcp_tx(Without threaded NAPI)
>> > 317.34+-2.37 : Channel 44
>> > 317.01+-2.56 : Channel 157
>> >
>> > tcp_tx(With threaded NAPI)
>> > 371.34+-2.36 : Channel 44
>> > 376.95+-9.40 : Channel 157
>>
>> My concern is primarily with the induced tcp latency on this test. A
>> way to check that is to run wireshark on your test client driving the
>> test, capture the iperf traffic, and then plot the "Statistics->TCP
>> stream statistics for both throughput and rtt. Would it be possible
>> for you to do that and put up those plots somewhere?
>>
>> The worst case test is a tcp bidirectional test which I don't know if
>> older iperfs can do. (iperf2 has new bounceback and bidir tests)
>>
>> Ideally stuff going in either direction, would not look as horrible,
>> as it did, back in 2016, documented in this linuxplumbers presentation
>> here: https://blog.linuxplumbersconf.org/2016/ocw/system/presentations/3=
963/original/linuxplumbers_wifi_latency-3Nov.pdf
>> and discussed on lwn, here: https://lwn.net/Articles/705884/
>>
>> I worry about folk achieving slightly better tcp throughput at the
>> expense of clobbering in-tcp-stream latency. Back then we were
>> shooting for no more than 40ms extra latency under load on this chip,
>> down from (unusable) seconds. Presently elsewhere, on other chips,
>> we're getting 8ms with stuff that's not in tree for the ath10k, there
>> is a slight cost in single stream throughput but when multiple streams
>> are in use, on multiple stations, things like web pages fly,
>> irrespective of load.
>>
>>
>> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>> >
>> > >
>> > > On Tue, Dec 20, 2022 at 12:17 AM Abhishek Kumar <kuabhs@chromium.org=
> wrote:
>> > > >
>> > > > NAPI poll can be done in threaded context along with soft irq
>> > > > context. Threaded context can be scheduled efficiently, thus
>> > > > creating less of bottleneck during Rx processing. This patch is
>> > > > to enable threaded NAPI on ath10k driver.
>> > > >
>> > > > Based on testing, it was observed that on WCN3990, the CPU0 reache=
s
>> > > > 100% utilization when napi runs in softirq context. At the same
>> > > > time the other CPUs are at low consumption percentage. This
>> > > > does not allow device to reach its maximum throughput potential.
>> > > > After enabling threaded napi, CPU load is balanced across all CPUs
>> > > > and following improvments were observed:
>> > > > - UDP_RX increase by ~22-25%
>> > > > - TCP_RX increase by ~15%
>> > > >
>> > > > Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
>> > > > Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
>> > > > ---
>> > > >
>> > > >  drivers/net/wireless/ath/ath10k/core.c | 16 ++++++++++++++++
>> > > >  drivers/net/wireless/ath/ath10k/hw.h   |  2 ++
>> > > >  drivers/net/wireless/ath/ath10k/snoc.c |  3 +++
>> > > >  3 files changed, 21 insertions(+)
>> > > >
>> > > > diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/=
wireless/ath/ath10k/core.c
>> > > > index 5eb131ab916fd..ee4b6ba508c81 100644
>> > > > --- a/drivers/net/wireless/ath/ath10k/core.c
>> > > > +++ b/drivers/net/wireless/ath/ath10k/core.c
>> > > > @@ -100,6 +100,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D QCA988X_HW_2_0_VERSION,
>> > > > @@ -140,6 +141,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D QCA9887_HW_1_0_VERSION,
>> > > > @@ -181,6 +183,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D QCA6174_HW_3_2_VERSION,
>> > > > @@ -217,6 +220,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D QCA6174_HW_2_1_VERSION,
>> > > > @@ -257,6 +261,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D QCA6174_HW_2_1_VERSION,
>> > > > @@ -297,6 +302,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D QCA6174_HW_3_0_VERSION,
>> > > > @@ -337,6 +343,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D QCA6174_HW_3_2_VERSION,
>> > > > @@ -381,6 +388,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D QCA99X0_HW_2_0_DEV_VERSION,
>> > > > @@ -427,6 +435,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D QCA9984_HW_1_0_DEV_VERSION,
>> > > > @@ -480,6 +489,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D QCA9888_HW_2_0_DEV_VERSION,
>> > > > @@ -530,6 +540,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D QCA9377_HW_1_0_DEV_VERSION,
>> > > > @@ -570,6 +581,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D QCA9377_HW_1_1_DEV_VERSION,
>> > > > @@ -612,6 +624,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D QCA9377_HW_1_1_DEV_VERSION,
>> > > > @@ -645,6 +658,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D QCA4019_HW_1_0_DEV_VERSION,
>> > > > @@ -692,6 +706,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D false,
>> > > >                 .use_fw_tx_credits =3D true,
>> > > >                 .delay_unmap_buffer =3D false,
>> > > > +               .enable_threaded_napi =3D false,
>> > > >         },
>> > > >         {
>> > > >                 .id =3D WCN3990_HW_1_0_DEV_VERSION,
>> > > > @@ -725,6 +740,7 @@ static const struct ath10k_hw_params ath10k_hw=
_params_list[] =3D {
>> > > >                 .hw_restart_disconnect =3D true,
>> > > >                 .use_fw_tx_credits =3D false,
>> > > >                 .delay_unmap_buffer =3D true,
>> > > > +               .enable_threaded_napi =3D true,
>> > > >         },
>> > > >  };
>> > > >
>> > > > diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wi=
reless/ath/ath10k/hw.h
>> > > > index 9643031a4427a..adf3076b96503 100644
>> > > > --- a/drivers/net/wireless/ath/ath10k/hw.h
>> > > > +++ b/drivers/net/wireless/ath/ath10k/hw.h
>> > > > @@ -639,6 +639,8 @@ struct ath10k_hw_params {
>> > > >         bool use_fw_tx_credits;
>> > > >
>> > > >         bool delay_unmap_buffer;
>> > > > +
>> > > > +       bool enable_threaded_napi;
>> > > >  };
>> > > >
>> > > >  struct htt_resp;
>> > > > diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/=
wireless/ath/ath10k/snoc.c
>> > > > index cfcb759a87dea..b94150fb6ef06 100644
>> > > > --- a/drivers/net/wireless/ath/ath10k/snoc.c
>> > > > +++ b/drivers/net/wireless/ath/ath10k/snoc.c
>> > > > @@ -927,6 +927,9 @@ static int ath10k_snoc_hif_start(struct ath10k=
 *ar)
>> > > >
>> > > >         bitmap_clear(ar_snoc->pending_ce_irqs, 0, CE_COUNT_MAX);
>> > > >
>> > > > +       if (ar->hw_params.enable_threaded_napi)
>> > > > +               dev_set_threaded(&ar->napi_dev, true);
>> > > > +
>> > > >         ath10k_core_napi_enable(ar);
>> > > >         ath10k_snoc_irq_enable(ar);
>> > > >         ath10k_snoc_rx_post(ar);
>> > > > --
>> > > > 2.39.0.314.g84b9a713c41-goog
>> > > >
>> > >
>> > >
>> > > --
>> > > This song goes out to all the folk that thought Stadia would work:
>> > > https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-6981=
366665607352320-FXtz
>> > > Dave T=C3=A4ht CEO, TekLibre, LLC
>>
>>
>>
>> --
>> This song goes out to all the folk that thought Stadia would work:
>> https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666=
65607352320-FXtz
>> Dave T=C3=A4ht CEO, TekLibre, LLC
>> _______________________________________________
>> Make-wifi-fast mailing list
>> Make-wifi-fast@lists.bufferbloat.net
>> https://lists.bufferbloat.net/listinfo/make-wifi-fast
>
>
> This electronic communication and the information and any files transmitt=
ed with it, or attached to it, are confidential and are intended solely for=
 the use of the individual or entity to whom it is addressed and may contai=
n information that is confidential, legally privileged, protected by privac=
y laws, or otherwise restricted from disclosure to anyone else. If you are =
not the intended recipient or the person responsible for delivering the e-m=
ail to the intended recipient, you are hereby notified that any use, copyin=
g, distributing, dissemination, forwarding, printing, or copying of this e-=
mail is strictly prohibited. If you received this e-mail in error, please r=
eturn the e-mail to the sender, delete it from your computer, and destroy a=
ny printed copy of it.



--=20
This song goes out to all the folk that thought Stadia would work:
https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666656=
07352320-FXtz
Dave T=C3=A4ht CEO, TekLibre, LLC
