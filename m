Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0866D6AF42C
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 20:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbjCGTOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 14:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbjCGTNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 14:13:52 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFA8A90A2;
        Tue,  7 Mar 2023 10:57:38 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id k10so32545279edk.13;
        Tue, 07 Mar 2023 10:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678215457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yYjEiw3V4RY+zRwaiKqpDGRln/QZvT8Pt5RGg79HYbg=;
        b=Ebnl+Gqts0w6Bjd/h9LpXMSddszxHHTV02Wyk5Bze9jF+H+2jTJSSe592n83W96R13
         PY5zgTuTWpIo1uLqG4+03dqTV03gglGJf8VRI2nQUJzsAyVrkSiTraTW9FSi+bbMXa9z
         iMPNCa1gt3IQ7H5SwfEdLpuQe50aKcMYXbiZhigqJYFmoH8eHARGtnyTob32qibeaYca
         Cer0q+wfOMnThMe8kcahKSsTsEvlG1P/ntQO3KWqfg9W6gMDaWEHzQO4xzL3QyNHAoyH
         EwQuv9/1/q0FZV+W7Z1Zky/LkzF/uq+aKwh/bClaCbu8rvcoQI1WPfVMeoyjTDGmEDQU
         6Tlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678215457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYjEiw3V4RY+zRwaiKqpDGRln/QZvT8Pt5RGg79HYbg=;
        b=XcGLYhAY2DawmigIEayGGD2eo1aP5nmD6HPMrxCUNOYLzMVQm3RHTdTePo/jZRBGVG
         nz0amIOirD6NAcRx0bJfAC08h/LETNeIqPPfNY6SFjBiKFs9HWTa3v+VhhqFOPaa4VBV
         OK90yDSX2Nsqzzl4SAnd2NLGrMP8REWX0A0N6CzlvEj2hvLFHhrmLyegydopM2QiGA70
         3DlX5eJQFQHqg0DcwesooKhUshkR9+BCJ6k9zqByAhM6whMB6puXHMb8nf4J9bnqpbdJ
         yfJXAeN0i+c/8xIa/hFzl7O5mTaj+o2a7dYAXJj9UaT/CUenpjeE5SQrufZIZGYYyEWg
         1pig==
X-Gm-Message-State: AO0yUKUpcsH6cQgPGbAewO4ALHIxI3hSSmGFTiyhrHe2tbhjv65nDc7H
        xuA4MZ6Z5+32m94Up6HgH30=
X-Google-Smtp-Source: AK7set+gMIfe10ZIqyoOcutVTEno3faz2tIkn6S3Zhxk2DmKiIeVkYOQAZPCphPppPBz9/fpSl0N0g==
X-Received: by 2002:a17:906:398a:b0:88d:d700:fe15 with SMTP id h10-20020a170906398a00b0088dd700fe15mr16341878eje.0.1678215457070;
        Tue, 07 Mar 2023 10:57:37 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ca5-20020a170906a3c500b008bc2c2134c5sm6466675ejb.216.2023.03.07.10.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 10:57:36 -0800 (PST)
Date:   Tue, 7 Mar 2023 20:57:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Message-ID: <20230307185734.x2lv4j3ml3fzfzoy@skbuf>
References: <20230306124940.865233-1-o.rempel@pengutronix.de>
 <20230306124940.865233-2-o.rempel@pengutronix.de>
 <20230306140651.kqayqatlrccfky2b@skbuf>
 <20230306163542.GB11936@pengutronix.de>
 <20230307164614.jy2mzxvk3xgc4z7b@skbuf>
 <20230307182732.GA1692@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307182732.GA1692@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 07:27:32PM +0100, Oleksij Rempel wrote:
> > What do you mean tc-mqprio doesn't support strict priority? Strict
> > priority between traffic classes is what it *does* (the "prio" in the name),
> > although without hardware offload, the prioritization isn't enforced anywhere.
> > Perhaps I'm misunderstanding what you mean?
> 
> Huh.. you have right, I overlooked this part of documentation:
> "As one specific example numerous Ethernet cards support the
> 802.1Q link strict priority transmission selection algorithm
> (TSA). MQPRIO enabled hardware in conjunction with the
> classification methods below can provide hardware offloaded
> support for this TSA."
> 
> But other parts of manual confuse me.

Not only you...
Does this discussion help any bit?
https://patchwork.kernel.org/project/netdevbpf/patch/20230220150548.2021-1-peti.antal99@gmail.com/

> May be you can help here:
> - "map - The priority to traffic class map. Maps priorities 0..15 to a
>    specified traffic class"
>    "Priorities" is probably SO_PRIORITY?

yeah
see the netdev_pick_tx() and skb_tx_hash() implementations for TXQ
selection based on skb->priority, it will answer a lot of questions

>    If yes, this option can't be offloaded by the KSZ switch.

because? it can offload the 1:1 prio:tc mapping only; reject anything else

> - "queues - Provide count and offset of queue range for each traffic class..."
>   If I see it correctly, I can map a traffic class to some queue.

s/queue/group of TX queues/

>   But traffic class is not priority? I can create traffic class with high number
>   and map it to a low number queue but actual queue priority is HW specific and
>   there is no way to notify user about it.

no, where did you read that you should do that?
traffic class number *is* the number based on which the NIC should do
egress prioritization. Higher traffic class number => higher priority.
Within the same traffic class, there should be round robin between TXQs.
The TXQ number should have nothing to do with priority. Intel igb/igc
NICs do that, and there was a recent discussion about this fact causing
problems with taprio (which reuses the mqprio concepts).

Since commit d7045f520a74 ("net/sched: mqprio: allow reverse TC:TXQ
mappings") it's possible to describe this kind of inherent TXQ priority
like this:

num_tc 8 map 0 1 2 3 4 5 6 7 queues 1@7 1@6 1@5 1@4 1@3 1@2 1@1 1@0

>    
> KSZ HW is capable of mapping 8 traffic classes separately to any available
> queue. Ok, if I replace words used in manual from "priority" to "traffic class"
> and "traffic class" to "queues". But even in this case the code will be even
> more confusing - i'll have to use qopt->prio_tc_map array which is SO_PRIO to
> TC map, as TC to queue map.

yeah, but with the 1:1 mapping between PRIO and TC, you only have to
concern about TC:TXQ.

> I still have difficulties to understand how priorities of actual queues
> are organized. I see how to map traffic class to a queue, but I can't find

s/a queue/one or more queues/

> any thing in manual about queue priority. For example, if I assign traffic
> class 3 to the Queue0 this traffic will have lowest priority in my HW. Is
> it some how documented or known for users?

This is a missing piece for mqprio's UAPI indeed. If TXQs have inherent
egress scheduling priority attached to them, there is no mechanism
currently which would allow the user to discover that. He would just
have to "know" that it is like that. Perhaps guided by errors emitted by
the driver, plus extack messages saying that lower TXQ numbers cannot
be mapped to a higher traffic class than higher TXQ numbers.

> One more question is, what is actual expected behavior of mqprio if max_rate
> option is used? In my case, if max_rate is set to a queue (even to max value),
> then strict priority TSA will not work:
> queue0---max rate 100Mbit/s---\
>                                |---100Mbit/s---
> queue1---max rate 100Mbit/s---/
> 
> in this example both streams will get 49Mbit/s. My expectation of strict prio
> is that queue1 should get 100Mbit/s and queue 0Mbit/s

I don't understand this. Have you already implemented mqprio offloading
and this is what you observe?

max_rate is an option per traffic class. Are queue0 and queue1 mapped to
the same traffic class in your example, or are they not? Could you show
the full command you ran?

> On other hand tc-ets made perfect sense to me from documentation and code pow.
> TC is mapped to bands. Bands have documented priorities and it fit's to what
> KSZ is supporting. Except of WRR configuration.

I haven't used tc-ets, I was just curious about the differences you saw
between it and mqprio which led to you choosing it.

> > For strict prioritization using multi-queue on the DSA master you should
> > be able to set up a separate Qdisc.
> 
> I'll need to do more testing with FEC later, it didn't worked at first try, but
> as you can see I still have a lot of misunderstandings.

fec doesn't seem to implement ndo_setup_tc() at all, so I'm not sure
what you're going to try exactly. OTOH it has this weird ndo_select_queue()
implementation which (I think) implements multi-queue based on VLAN PCP.

sorry for the quick response, need to go right now
