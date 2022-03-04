Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8655B4CD842
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 16:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240387AbiCDPtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 10:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiCDPtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 10:49:19 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85965DD940
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 07:48:31 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id z15so7930147pfe.7
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 07:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=A8fqKK8Yavm/R1YMyPEVBM8njcul+rKs8qnnR5ZhqY0=;
        b=C+fKrntRPTNO0Xjpzpt5hoR/5mCBwjyboDKS0K7+Nd38pwESBbhwjY238Ofa6BLuL0
         HnCDzl09+zNpnX4Kdrt74EnfYqFyxUDqc6b6XPnrJDfKUGOpdh8xILsEPeLspdpvFzD/
         SDZnxsBAu0BS+Is6+HONe5etA1GQivfTf1OujjL41FOBnbR7FOvd7a+rR7fj18GiaRhm
         8SfD+XnX109F4kK7pe350ny/nCjY7GjAKCfrFPCWLG9rEnCHhSGtlryco3qYpNGVRMBf
         N0yiE2a25zZmal29YVWCboahTLyvpgy2OJJkxKAZeznI3fK6rCZclqukSTALPmcvlXT5
         Jsjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=A8fqKK8Yavm/R1YMyPEVBM8njcul+rKs8qnnR5ZhqY0=;
        b=IwqlZF4UqAnttHm+L6JOo7/0rDoTgMVmd9Cm8gDFs+4PrI3i4esQN5PRq1ihZOHRwE
         gVKhDpG3hmV4ai0H9gYxikTu5t/3MQWIfeEBnvo7e7joqIyuuSH2wpqnCh4ybZMDw4C3
         QEQc0YOktqCRiW4vaJeQqes2GzTU2MtfgIqBcIWCx+k4FqH+ZNQCMs3Oj+VcwI/zscJ9
         883GTABBZKZVM6KyL+ll0x5cdc/7Et42gwlhj2ARuUg2dOwicHNrisMqBOAUDlK9vln2
         WFhI496S+lCd+ZjjnUbHhqcRfQYoF9WEnU9zRtzycjo+OLrhsUhp5lMMgIBTYsMw8P7X
         ZKFg==
X-Gm-Message-State: AOAM531+M+nUb6ItrYKIy21vhVx1Yuq95BCzhDiAHtdgDEsOua3d8Jsz
        9sQF6Ng9ULbhNxfKj0a8otI=
X-Google-Smtp-Source: ABdhPJyJbaYA0RYPsquSeXEbOaXLpmdnVuMdeTS2jT+X0OfRWjJmpbcoyAS1VhK3YRnW0oBAtphizA==
X-Received: by 2002:a05:6a00:2166:b0:4f6:67fe:a336 with SMTP id r6-20020a056a00216600b004f667fea336mr9969816pff.17.1646408910855;
        Fri, 04 Mar 2022 07:48:30 -0800 (PST)
Received: from ?IPv6:2001:470:b:9c3:82ee:73ff:fe41:9a02? ([2001:470:b:9c3:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id 23-20020a17090a0d5700b001bc3c650e01sm11316541pju.1.2022.03.04.07.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 07:48:30 -0800 (PST)
Message-ID: <f478bb059d701b774b3d457eb5934f142a6044e8.camel@gmail.com>
Subject: Re: [PATCH v2 net-next 08/14] ipv6: Add hop-by-hop header to
 jumbograms in ip6_output
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Date:   Fri, 04 Mar 2022 07:48:29 -0800
In-Reply-To: <726720e6-cd28-646c-1ba3-576a258ae02e@kernel.org>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
         <20220303181607.1094358-9-eric.dumazet@gmail.com>
         <726720e6-cd28-646c-1ba3-576a258ae02e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-03-03 at 21:33 -0700, David Ahern wrote:
> On 3/3/22 11:16 AM, Eric Dumazet wrote:
> > From: Coco Li <lixiaoyan@google.com>
> > 
> > Instead of simply forcing a 0 payload_len in IPv6 header,
> > implement RFC 2675 and insert a custom extension header.
> > 
> > Note that only TCP stack is currently potentially generating
> > jumbograms, and that this extension header is purely local,
> > it wont be sent on a physical link.
> > 
> > This is needed so that packet capture (tcpdump and friends)
> > can properly dissect these large packets.
> > 
> 
> 
> I am fairly certain I know how you are going to respond, but I will ask
> this anyways :-) :
> 
> The networking stack as it stands today does not care that skb->len >
> 64kB and nothing stops a driver from setting max gso size to be > 64kB.
> Sure, packet socket apps (tcpdump) get confused but if the h/w supports
> the larger packet size it just works.
> 
> The jumbogram header is getting adding at the L3/IPv6 layer and then
> removed by the drivers before pushing to hardware. So, the only benefit
> of the push and pop of the jumbogram header is for packet sockets and
> tc/ebpf programs - assuming those programs understand the header
> (tcpdump (libpcap?) yes, random packet socket program maybe not). Yes,
> it is a standard header so apps have a chance to understand the larger
> packet size, but what is the likelihood that random apps or even ebpf
> programs will understand it?
> 
> Alternative solutions to the packet socket (ebpf programs have access to
> skb->len) problem would allow IPv4 to join the Big TCP party. I am
> wondering how feasible an alternative solution is to get large packet
> sizes across the board with less overhead and changes.

I agree that the header insertion and removal seems like a lot of extra
overhead for the sake of correctness. In the Microsoft case I am pretty
sure their LSOv2 supported both v4 and v6. I think we could do
something similar, we would just need to make certain the device
supports it and as such maybe it would make sense to implement it as a
gso type flag?

Could we handle the length field like we handle the checksum and place
a value in there that we know is wrong, but could be used to provide
additional data? Perhaps we could even use it to store the MSS in the
form of the length of the first packet so if examined, the packet would
look like the first frame of the flow with a set of trailing data.

