Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA70627833
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbiKNIz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236615AbiKNIzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:55:21 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC061CB2C
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:55:17 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id v17so16225938edc.8
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KiXHNswY3tTN1rdzNmdcZRSuPYlclGuQoAZU44cgnrA=;
        b=EIw9HLm/6HWfjnScY+4BfFvup+7o68YFvl9Pw3OEFWteGkiydm43Q9eET1R2ihT94q
         jymDiw82ILVjZAH6nvWvtD3GjrBfHCKiDj9MITFD9LL2DhZjOWiezJrdGdu6qIbufS8S
         tqDhZvA16wG9tjURanIKeqrEwDsTrQkJ0Ps2b5CeOZrjf44+wEtGDrJehnmE33Hmv0Uo
         MDKjqDKtCkN9R3U0jL8imDpOIaH6dQwySRYZdqwT6fMA23k3oWJAagV2e5jDmpZmMl3r
         N91rTfHLj7XZXqgZAYckS99tOIKzaOenTte/7Z/3pAOkyzj5uUjw6CwxS6AviWme8l4p
         tExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KiXHNswY3tTN1rdzNmdcZRSuPYlclGuQoAZU44cgnrA=;
        b=JP/5Pa5As0Ipo9Py3gVenkOYCtzio2kzOqZX+tSpKQf8aGxN0tztMlItnx/blmniOF
         xCPug4x/srtWsAKiiShxgPzpIGpgGLNvCX3Bz0ThZJTIMZvmJ2SkmFdxmXR5v1C0r3Lb
         Fh0aWowst0Jr2dfkr2aPR1K5+nlQUZFJedVMAstkm5PeIwQrFXJScUFSn2KK182rEM7t
         R+0VEBj7UbPO2hTioKnz71qz5RztY5xTeJgtSQ/3r2TcfDEa8tw+/h7lRE/K4CnGZGyw
         fzw1VfalNSt9bMFyLkCNeBw2v+RzK7ewAo26YfD2XWxSVZc2U9U+pRrg7EqBeYy29rSH
         tOzA==
X-Gm-Message-State: ANoB5pkiEbAiGxhQKFIVZFjz6j1ADtNDHC0NvP5R3WDioTy5qitwecMf
        RlwiViKvaEkGZU8uqSdQl9WMgnq9MjUMp53PBKffFSccuVJCLg==
X-Google-Smtp-Source: AA0mqf5rgHFPlreOK9i0y5rwAYtFWoj/k1C7DW0qfPMrpiMsWSDuVkpjzZSfUo2HPiEZPynBAtSYXUk/HEW92CrvwTI=
X-Received: by 2002:aa7:cdc1:0:b0:459:41fa:8e07 with SMTP id
 h1-20020aa7cdc1000000b0045941fa8e07mr10192329edw.140.1668416116062; Mon, 14
 Nov 2022 00:55:16 -0800 (PST)
MIME-Version: 1.0
References: <20221109180249.4721-1-dnlplm@gmail.com> <20221109180249.4721-3-dnlplm@gmail.com>
 <20221110173222.3536589-1-alexandr.lobakin@intel.com> <b84e45e0-55e0-a1f5-e1cc-980983946019@quicinc.com>
 <CAGRyCJHEwqg8f-pGuCuboo-mE6gFaViX3e4v26LGCGuWjgAyWA@mail.gmail.com>
In-Reply-To: <CAGRyCJHEwqg8f-pGuCuboo-mE6gFaViX3e4v26LGCGuWjgAyWA@mail.gmail.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Mon, 14 Nov 2022 09:48:56 +0100
Message-ID: <CAGRyCJEkTHpLVsD9zTzSQp8d98SBM24nyqq-HA0jbvHUre+C4g@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets aggregation
To:     "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Subash,

Il giorno ven 11 nov 2022 alle ore 23:00 Daniele Palmas
<dnlplm@gmail.com> ha scritto:
>
> Hello Subash,
>
> Il giorno ven 11 nov 2022 alle ore 02:17 Subash Abhinov
> Kasiviswanathan (KS) <quic_subashab@quicinc.com> ha scritto:
> >
> > On 11/10/2022 10:32 AM, Alexander Lobakin wrote:
> > > From: Daniele Palmas <dnlplm@gmail.com>
> > > Date: Wed,  9 Nov 2022 19:02:48 +0100
> > >
> > >> Bidirectional TCP throughput tests through iperf with low-cat
> > >> Thread-x based modems showed performance issues both in tx
> > >> and rx.
> > >>
> > >> The Windows driver does not show this issue: inspecting USB
> > >> packets revealed that the only notable change is the driver
> > >> enabling tx packets aggregation.
> > >>
> > >> Tx packets aggregation, by default disabled, requires flag
> > >> RMNET_FLAGS_EGRESS_AGGREGATION to be set (e.g. through ip command).
> > >>
> > >> The maximum number of aggregated packets and the maximum aggregated
> > >> size are by default set to reasonably low values in order to support
> > >> the majority of modems.
> > >>
> > >> This implementation is based on patches available in Code Aurora
> > >> repositories (msm kernel) whose main authors are
> > >>
> > >> Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> > >> Sean Tranchetti <stranche@codeaurora.org>
> > >>
> > >> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> > >> ---
> > >>
> > >> +struct rmnet_egress_agg_params {
> > >> +    u16 agg_size;
> > >
> > > skbs can now be way longer than 64 Kb.
> > >
> >
> > rmnet devices generally use a standard MTU (around 1500) size.
> > Would it still be possible for >64kb to be generated as no relevant
> > hw_features is set for large transmit offloads.
> > Alternatively, are you referring to injection of packets explicitly, say
> > via packet sockets.
> >
> > >> +    u16 agg_count;
> > >> +    u64 agg_time_nsec;
> > >> +};
> > >> +
> > > Do I get the whole logics correctly, you allocate a new big skb and
> > > just copy several frames into it, then send as one chunk once its
> > > size reaches the threshold? Plus linearize every skb to be able to
> > > do that... That's too much of overhead I'd say, just handle S/G and
> > > fraglists and make long trains of frags from them without copying
> > > anything? Also BQL/DQL already does some sort of aggregation via
> > > ::xmit_more, doesn't it? Do you have any performance numbers?
> >
> > The difference here is that hardware would use a single descriptor for
> > aggregation vs multiple descriptors for scatter gather.
> >
> > I wonder if this issue is related to pacing though.
> > Daniele, perhaps you can try this hack without enabling EGRESS
> > AGGREGATION and check if you are able to reach the same level of
> > performance for your scenario.
> >
> > --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> > +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> > @@ -236,7 +236,7 @@ void rmnet_egress_handler(struct sk_buff *skb)
> >          struct rmnet_priv *priv;
> >          u8 mux_id;
> >
> > -       sk_pacing_shift_update(skb->sk, 8);
> > +       skb_orphan(skb);
> >
> >          orig_dev = skb->dev;
> >          priv = netdev_priv(orig_dev);
> >
>
> Sure, I'll test that on Monday.
>

Hello Subash,

This change does not have any effect.

Start the tx test alone:

$ sudo iperf3 -c 172.22.1.201 -t 60 -p 5001 -P 3
Connecting to host 172.22.1.201, port 5001
[  5] local 172.22.1.102 port 45902 connected to 172.22.1.201 port 5001
[  7] local 172.22.1.102 port 45908 connected to 172.22.1.201 port 5001
[  9] local 172.22.1.102 port 45910 connected to 172.22.1.201 port 5001
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  1.90 MBytes  15.9 Mbits/sec    0    114 KBytes
[  7]   0.00-1.00   sec  1.07 MBytes  8.94 Mbits/sec    0   71.3 KBytes
[  9]   0.00-1.00   sec  5.02 MBytes  42.1 Mbits/sec    0    344 KBytes
[SUM]   0.00-1.00   sec  7.98 MBytes  66.9 Mbits/sec    0
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]   1.00-2.00   sec  1.30 MBytes  10.9 Mbits/sec    4    104 KBytes
[  7]   1.00-2.00   sec   949 KBytes  7.77 Mbits/sec    6   64.6 KBytes
[  9]   1.00-2.00   sec  3.71 MBytes  31.1 Mbits/sec   20    284 KBytes
[SUM]   1.00-2.00   sec  5.93 MBytes  49.7 Mbits/sec   30
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]   2.00-3.00   sec  1.24 MBytes  10.4 Mbits/sec    0    117 KBytes
[  7]   2.00-3.00   sec   759 KBytes  6.22 Mbits/sec    0   72.7 KBytes
[  9]   2.00-3.00   sec  3.71 MBytes  31.1 Mbits/sec    0    319 KBytes
[SUM]   2.00-3.00   sec  5.68 MBytes  47.7 Mbits/sec    0
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]   3.00-4.00   sec  1.85 MBytes  15.5 Mbits/sec    0    124 KBytes
[  7]   3.00-4.00   sec   949 KBytes  7.77 Mbits/sec    0   76.7 KBytes
[  9]   3.00-4.00   sec  3.09 MBytes  25.9 Mbits/sec    5    246 KBytes
[SUM]   3.00-4.00   sec  5.87 MBytes  49.2 Mbits/sec    5
...

Start the rx test:

$ sudo iperf3 -R -c 172.22.1.201 -t 30 -p 5002
Connecting to host 172.22.1.201, port 5002
Reverse mode, remote host 172.22.1.201 is sending
[  5] local 172.22.1.102 port 46496 connected to 172.22.1.201 port 5002
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  10.4 MBytes  87.4 Mbits/sec
[  5]   1.00-2.00   sec  12.7 MBytes   107 Mbits/sec
[  5]   2.00-3.00   sec  12.6 MBytes   106 Mbits/sec
[  5]   3.00-4.00   sec  12.6 MBytes   105 Mbits/sec
[  5]   4.00-5.00   sec  12.6 MBytes   106 Mbits/sec

Checking the tx path:

[  5]  11.00-12.00  sec   632 KBytes  5.18 Mbits/sec   16   95.5 KBytes
[  7]  11.00-12.00  sec   506 KBytes  4.14 Mbits/sec   16   52.5 KBytes
[  9]  11.00-12.00  sec   759 KBytes  6.21 Mbits/sec   17    143 KBytes
[SUM]  11.00-12.00  sec  1.85 MBytes  15.5 Mbits/sec   49
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]  12.00-13.00  sec   316 KBytes  2.59 Mbits/sec   67   26.9 KBytes
[  7]  12.00-13.00  sec   253 KBytes  2.07 Mbits/sec   44   9.42 KBytes
[  9]  12.00-13.00  sec   759 KBytes  6.22 Mbits/sec   66   94.2 KBytes
[SUM]  12.00-13.00  sec  1.30 MBytes  10.9 Mbits/sec  177
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]  13.00-14.00  sec   316 KBytes  2.59 Mbits/sec   58   10.8 KBytes
[  7]  13.00-14.00  sec   253 KBytes  2.07 Mbits/sec    6   10.8 KBytes
[  9]  13.00-14.00  sec  0.00 Bytes  0.00 bits/sec   91   37.7 KBytes
[SUM]  13.00-14.00  sec   569 KBytes  4.66 Mbits/sec  155
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]  14.00-15.00  sec   316 KBytes  2.59 Mbits/sec    6   8.07 KBytes
[  7]  14.00-15.00  sec   253 KBytes  2.07 Mbits/sec    3   9.42 KBytes
[  9]  14.00-15.00  sec  0.00 Bytes  0.00 bits/sec   53   8.07 KBytes
[SUM]  14.00-15.00  sec   569 KBytes  4.66 Mbits/sec   62

Stop the rx test, the tx becomes again:

[  5]  28.00-29.00  sec  1.85 MBytes  15.5 Mbits/sec    0   96.9 KBytes
[  7]  28.00-29.00  sec  1.98 MBytes  16.6 Mbits/sec    0   96.9 KBytes
[  9]  28.00-29.00  sec  2.22 MBytes  18.7 Mbits/sec    0   96.9 KBytes
[SUM]  28.00-29.00  sec  6.05 MBytes  50.8 Mbits/sec    0
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]  29.00-30.00  sec  2.16 MBytes  18.1 Mbits/sec    0    110 KBytes
[  7]  29.00-30.00  sec  1.98 MBytes  16.6 Mbits/sec    0    110 KBytes
[  9]  29.00-30.00  sec  1.48 MBytes  12.4 Mbits/sec    0    110 KBytes
[SUM]  29.00-30.00  sec  5.62 MBytes  47.1 Mbits/sec    0
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]  30.00-31.00  sec  1.85 MBytes  15.5 Mbits/sec    0    122 KBytes
[  7]  30.00-31.00  sec  1.85 MBytes  15.5 Mbits/sec    0    122 KBytes
[  9]  30.00-31.00  sec  2.22 MBytes  18.7 Mbits/sec    0    122 KBytes
[SUM]  30.00-31.00  sec  5.93 MBytes  49.7 Mbits/sec    0

Just want to highlight also that, if I enable the tx aggregation, not
only the above described behavior does not happen, but also the rx
test alone is capable to reach the maximum throughput of the modem:

$ sudo iperf3 -R -c 172.22.1.201 -t 30 -p 5002
Connecting to host 172.22.1.201, port 5002
Reverse mode, remote host 172.22.1.201 is sending
[  5] local 172.22.1.102 port 51422 connected to 172.22.1.201 port 5002
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  15.1 MBytes   126 Mbits/sec
[  5]   1.00-2.00   sec  17.2 MBytes   144 Mbits/sec
[  5]   2.00-3.00   sec  17.2 MBytes   144 Mbits/sec
[  5]   3.00-4.00   sec  17.2 MBytes   144 Mbits/sec
[  5]   4.00-5.00   sec  17.2 MBytes   144 Mbits/sec
[  5]   5.00-6.00   sec  17.2 MBytes   144 Mbits/sec
[  5]   6.00-7.00   sec  17.2 MBytes   144 Mbits/sec
[  5]   7.00-8.00   sec  17.2 MBytes   144 Mbits/sec
[  5]   8.00-9.00   sec  17.2 MBytes   144 Mbits/sec
[  5]   9.00-10.00  sec  17.2 MBytes   144 Mbits/sec
[  5]  10.00-11.00  sec  17.2 MBytes   144 Mbits/sec
^C[  5]  11.00-11.50  sec  8.67 MBytes   144 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-11.50  sec  0.00 Bytes  0.00 bits/sec                  sender
[  5]   0.00-11.50  sec   195 MBytes   143 Mbits/sec                  receiver
iperf3: interrupt - the client has terminated

Thanks,
Daniele

> > >
> > >> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> > >> index 5e7a1041df3a..09a30e2b29b1 100644
> > >> --- a/include/uapi/linux/if_link.h
> > >> +++ b/include/uapi/linux/if_link.h
> > >> @@ -1351,6 +1351,7 @@ enum {
> > >>   #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
> > >>   #define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
> > >>   #define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 5)
> > >> +#define RMNET_FLAGS_EGRESS_AGGREGATION            (1U << 6)
> > >
> > > But you could rely on the aggregation parameters passed via Ethtool
> > > to decide whether to enable aggregation or not. If any of them is 0,
> > > it means the aggregation needs to be disabled.
> > > Otherwise, to enable it you need to use 2 utilities: the one that
> > > creates RMNet devices at first and Ethtool after, isn't it too
> > > complicated for no reason?
> >
> > Yes, the EGRESS AGGREGATION parameters can be added as part of the rmnet
> > netlink policies.
> >
>
> Ack.
>
> Thanks,
> Daniele
>
> > >
> > >>
> > >>   enum {
> > >>      IFLA_RMNET_UNSPEC,
> > >> --
> > >> 2.37.1
> > >
> > > Thanks,
> > > Olek
