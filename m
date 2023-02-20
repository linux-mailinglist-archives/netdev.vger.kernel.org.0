Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4330069C64F
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjBTILS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Feb 2023 03:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjBTILQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:11:16 -0500
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1571206A;
        Mon, 20 Feb 2023 00:11:14 -0800 (PST)
Received: by mail-wr1-f53.google.com with SMTP id o4so163018wrs.4;
        Mon, 20 Feb 2023 00:11:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WDLq+6nQ6gFdWsxQf+By7KyagWm+A3Kp2Sy8RaFfDVs=;
        b=nayinzZ3vAqNXT2Suy7YqwxiPnrz2CZyjK60SThHcBI2lqwIS9enijkdtCqvjbrA8o
         ABm7SMR4zkFwq9i2YJdM/WwQIGnLyvl2jFI5X9hm5nag8PKEQCNBpUep3SNbldeilcdA
         puojTix8eIokfy8XtcTGC8XtFx3/rZK58tyalgiKMcBNuBsOHtSWO2DQ+LwYAdVotSnf
         lW3xXwjJSbMDMAm+3G1td3wo4t3ktsNNe9VuzjhgkI33208c387dnuwHTDnEEuPHE4iR
         RmxcKT2TdQOflL3/WibOgJVLD+qWYKbEPtcDpDGbQ53lsUuDDLzrPFUVebaBM/nEr+HQ
         gicQ==
X-Gm-Message-State: AO0yUKWwWgftfS2XOXf22sLDJ2Wlchj4slAGLr0ZF6YMFFllEaaM6zXx
        m2oDRceYVtjW8qMRDXul7uY=
X-Google-Smtp-Source: AK7set/CGjdtL0cLnAkrvZGZDoymhT6OHeR/2o8bGXSOua2eOCKu6+3vpf4sQ/6KQb9NZINXi+YcaQ==
X-Received: by 2002:adf:ce8c:0:b0:2c5:7eb5:9797 with SMTP id r12-20020adfce8c000000b002c57eb59797mr1838773wrn.8.1676880672630;
        Mon, 20 Feb 2023 00:11:12 -0800 (PST)
Received: from [10.148.80.132] ([195.228.69.10])
        by smtp.gmail.com with ESMTPSA id g11-20020a5d698b000000b002c5a1bd5280sm1985956wru.95.2023.02.20.00.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 00:11:12 -0800 (PST)
Message-ID: <be80cf7b04b60e212dc4733f47e5d1f687a9f551.camel@inf.elte.hu>
Subject: Re: [PATCH net-next 00/12] Add tc-mqprio and tc-taprio support for
 preemptible traffic classes
From:   Ferenc Fejes <fejes@inf.elte.hu>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>
Date:   Mon, 20 Feb 2023 09:11:10 +0100
In-Reply-To: <20230219125820.mw3uchmqr4bvohle@skbuf>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
         <20230218152021.puhz7m26uu2lzved@skbuf>
         <dd782435586a73ada32c099150c274c79e1c3003.camel@inf.elte.hu>
         <20230219125820.mw3uchmqr4bvohle@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir!

Thank you for the update!

On Sun, 2023-02-19 at 14:58 +0200, Vladimir Oltean wrote:
> Hi Ferenc,
> 
> On Sun, Feb 19, 2023 at 10:47:31AM +0100, Ferenc Fejes wrote:
> > Do you have the iproute2 part? Sorry if I missed it, but it would
> > be
> > nice to see how is that UAPI exposed for the config tools. Is there
> > any
> > new parameter for mqprio/taprio?
> 
> I haven't posted the iproute2 part (yet). For those familiar with my
> recent development, FP is a per-traffic-class netlink attribute just
> like queueMaxSDU from tc-taprio. That was exposed in iproute2 as an
> array of values, one per tc.
> 
> What I have in my tree would allow something like this:
> 
> tc qdisc replace dev $swp1 root stab overhead 20 taprio \
>         num_tc 8 \
>         map 0 1 2 3 4 5 6 7 \
>         queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
>         base-time 0 \
>         sched-entry S 0x7e 900000 \
>         sched-entry S 0x82 100000 \
>         max-sdu 0 0 0 0 0 0 0 200 \
>         fp P E E E E E E E \   # this is new (one entry per tc)
>         flags 0x2
> 
> tc qdisc replace dev $swp1 root mqprio \
>         num_tc 8 \
>         map 0 1 2 3 4 5 6 7 \
>         queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
>         fp P E E E E E E E \   # this is new (one entry per tc)
>         hw 1
> 
> of course the exact syntax is a potential matter of debate on its
> own,
> and does not really matter for the purpose of defining the kernel
> UAPI,
> which is why I wanted to keep discussions separate.

Fair enough. What you have right here is pretty straightforward IMO, I
would definitely support something like this.

> 
> For hardware which understands preemptible queues rather than traffic
> classes, how many queues are preemptible, and what are their offsets,
> will be deduced by translating the "queues" argument.
> 
> For hardware which understands preemptible priorities rather than
> traffic classes, which priorities are preemptible will be deduced by
> translating the "map" argument.

Great, that cover both cases with the same UAPI. I love the fact that
this even lets open the possibility to use prio-s (map) instead of
queues for FP.

> 
> The traffic class is the kernel entity which has the preemptible
> priority in my proposed UAPI because this is what my analysis of the
> standard has deduced that the preemptible quality is fundamentally
> attached to.
> 
> Considering that the UAPI for FP is a topic that has been discussed
> to
> death at least since August without any really new input since then,
> I'm
> going to submit v2 later today, and the iproute2 patch set afterwards
> (still need to write man page entries for that).

Best,
Ferenc

