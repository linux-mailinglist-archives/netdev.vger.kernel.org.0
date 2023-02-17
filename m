Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC6869A682
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 09:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjBQIEQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Feb 2023 03:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBQIEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 03:04:15 -0500
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCB036092;
        Fri, 17 Feb 2023 00:03:47 -0800 (PST)
Received: by mail-ed1-f45.google.com with SMTP id co2so695703edb.13;
        Fri, 17 Feb 2023 00:03:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F3zx1CKT9G1U+BaM/F7sj0C1cbL34hzPyh5Iwk18DIg=;
        b=vX2uOPbhe/46umGLw9paRgu6IcmkU49XvzfDaH90XNoG2eLOZcisr+4Vxch743FmRV
         a/gY3WnciNTL+MB9xKQWb6rbHkRNTPguqQoUTQ5gCNWIb15hULOPNTCyzqSWSLLO6BIO
         BCpIM6m3zefj7cojFUp8HfrNHjlA3A4TtTRAfDASXSlRZ03LGPA2AevgYAc2hLHgjJ0R
         ZDQX9eTEtGKGsPpcdyqON/n92/LQwjPP/KS/Da29BX5csVIeB0LGAnRqtcaYEihZwrG/
         awM0stzPB9fcToEZAPKoucxMKXO02LHN7rHUbDUIfkq2vLt85AuAgcxnutC0HEC+OF9l
         J8Dg==
X-Gm-Message-State: AO0yUKUENlCljiSECIXgpirvrmB+lyYESN9SoMiGSXo0JxGW/QOb3h2b
        V4SPuHmmOdg54xhxXpktGk8=
X-Google-Smtp-Source: AK7set/PqXDd37+dBwpRSybJyyrKknqe73AnUTjdSXlpR9rb4OWQq4411RypzgrCoWm3KU85Sok9QQ==
X-Received: by 2002:aa7:d513:0:b0:4aa:a9c7:4224 with SMTP id y19-20020aa7d513000000b004aaa9c74224mr262577edq.30.1676621012154;
        Fri, 17 Feb 2023 00:03:32 -0800 (PST)
Received: from [10.148.80.132] ([195.228.69.10])
        by smtp.gmail.com with ESMTPSA id k25-20020a50ce59000000b0049668426aa6sm1893231edj.24.2023.02.17.00.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 00:03:31 -0800 (PST)
Message-ID: <1284d04958725d772750d6e3908301c8f8a379c1.camel@inf.elte.hu>
Subject: Re: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
From:   Ferenc Fejes <fejes@inf.elte.hu>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     peti.antal99@gmail.com, "andrew@lunn.ch" <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "gerhard@engleder-embedded.com" <gerhard@engleder-embedded.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>, "jiri@nvidia.com" <jiri@nvidia.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Date:   Fri, 17 Feb 2023 09:03:30 +0100
In-Reply-To: <20230216155813.un3icarhi2h6aga2@skbuf>
References: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
         <302dc1fb-18aa-1640-dfc7-6a3a7bc6d834@ericsson.com>
         <20220506120153.yfnnnwplumcilvoj@skbuf>
         <c2730450-1f2b-8cb9-d56c-6bb8a35f0267@ericsson.com>
         <20220526005021.l5motcuqdotkqngm@skbuf>
         <cd0303b16e0052a119392ed021d71980db63e076.camel@ericsson.com>
         <20220526093036.qtsounfawvzwbou2@skbuf>
         <009e968cc984b563c375cb5be1999486b05db626.camel@inf.elte.hu>
         <20230216155813.un3icarhi2h6aga2@skbuf>
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

On Thu, 2023-02-16 at 17:58 +0200, Vladimir Oltean wrote:
> On Thu, Feb 16, 2023 at 02:47:11PM +0100, Ferenc Fejes wrote:
> > > To fix this, we need to keep a current_ipv variable according to
> > > the
> > > gate entry that's currently executed by act_gate, and use this
> > > IPV to
> > > overwrite the skb->priority.
> > > 
> > > In fact, a complication arises due to the following clause from
> > > 802.1Q:
> > > 
> > > > 8.6.6.1 PSFP queuing
> > > > If PSFP is supported (8.6.5.1), and the IPV associated with the
> > > > stream
> > > > filter that passed the frame is anything other than the null
> > > > value, then
> > > > that IPV is used to determine the traffic class of the frame,
> > > > in place
> > > > of the frame's priority, via the Traffic Class Table specified
> > > > in 8.6.6.
> > > > In all other respects, the queuing actions specified in 8.6.6
> > > > are
> > > > unchanged. The IPV is used only to determine the traffic class
> > > > associated with a frame, and hence select an outbound queue;
> > > > for all
> > > > other purposes, the received priority is used.
> > 
> > Interesting. In my understanding this indeed something like "modify
> > the
> > queueing decision while preserve the original PCP value".
> 
> I actually wonder what the interpretation in the spirit of this
> clause is.
> I'm known to over-interpret the text of these IEEE standards and
> finding
> inconsistencies in the process (being able to prove both A and !A).

I agree, it takes time to guess what the intention behind the wording
of the standard in some cases. I have the standard in front of me right
now and its 2163 pages... Even if I grep to IPV, the context is
overwhelmingly dense.

> 
> For example, if we consider the framePreemptionAdminStatus (express
> or
> preemptible). It is expressed per priority. So this means that the
> Internal Priority Value rewritten by PSFP will not affect the
> express/
> preemptible nature of a frame, but it *will* affect the traffic class
> selection?
> 
> This is insane, because it means that to enforce the requirements of
> clause 12.30.1.1.1:
> 
> > Priorities that all map to the same traffic class should be
> > constrained to use the same value of preemption status.
> 
> it is insufficient to check that the prio_tc_map does not make some
> traffic classes both express and preemptible. One has to also check
> the
> tc-gate configuration, because the literal interpretation of the
> standard
> would suggest that a packet is preemptible or express based on skb-
> >priority,
> but is classified to a traffic class based on skb->ipv. So I guess
> IPV
> rewriting can only take place between one preemptible priority and
> another,
> or only between one express priority and another, and that we should
> somehow test this. But PSFP is at ingress, and FP is at egress, so
> we'd
> somehow have to test the FP adminStatus of all the other net devices
> that we can forward to!!!
> 
> I'll try to ask around and see if anyone knows more details about
> what
> is the expected behavior.

I'll try to ask around too, thanks for pointing this out. My best
understanding from the IPV that the standard treat it as skb->priority.
It defines IPV as a 32bit signed value, which clearly imply similar
semantics as skb->priority, which can be much larger than the number of
the queues or traffic classes.

> 
> > Your solution certainly correct and do the differentiation between
> > the
> > cases where we have PSFP at ingress or not. However in my
> > understanding
> > the only purpose of the IPV is the traffic class selection. 
> > 
> > Setting skb->queue_mapping to IPV probably wont work, because of
> > two
> > reasons:
> > 1. it brings inconsistency with the mqprio/taprio queues and the
> > actual
> > hw rings the traffic sent
> > 2. some drivers dont check if skb->queue_mapping is bounded, they
> > expect its smaller than the num_tx_queues.
> > 
> > The 2. might be solvable, but the 1. is more problematic. However
> > with
> > a helper, we might check if skb->queue_mapping is already set and
> > use
> > that as a traffic class. Is that possible? I dont really see any
> > other
> > codepath where that value can be other than zero before the qdisc
> > layer. That way one flag (use_ipv) might be enough which tells that
> > we
> > should use the skb->queue_mapping as is (set by act_gate) and
> > preserve
> > skb->priority.
> > 
> > What do you think? Again, sorry for being late here, but I'm
> > following
> > the list and see that recently you did major mqprio/taprio fixes
> > and
> > refactors, so I hope your cache line is hot.
> 
> I'm afraid it's not so easy to reuse this field for the IPV, because
> skb->queue_mapping is already used between the RX and the TX path for
> "recording the RX queue", see skb_rx_queue_recorded(),
> skb_record_rx_queue(),
> skb_get_rx_queue().

Oh, alright. I continue to think about alternatives over introducing
new members into sk_buff. It would be very nice to have proper act_gate
IPV handling without hardware offload. Its great to see the support of
frame preemption and PSFP support in more and more hardware but on the
other hand it makes the lack of the proper software mode operation more
and more awkward.

Best,
Ferenc

