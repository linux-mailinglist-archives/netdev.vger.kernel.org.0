Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A2555CA2C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240386AbiF0Tgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239933AbiF0Tgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:36:42 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9196369
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:36:42 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id n15so16346955qvh.12
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XhZZr8S7K+/03WxcdeaI9qeKnRSBGg+MsZ5iPpRFv0k=;
        b=UTb9/mmm0GivXgreZvSApDQgkO2RFnVnlj9wwgEN2ef79RS4ZCze6W9qOZD37VeK9w
         Q7OYA4AOU8OfOsR3nBz+sDsCVFNg12ymxu4ruT9Y/amx+T+rclLJwZeVX6PM3bm7M2UJ
         UR9rQFo3vnVNjbOQfCexZnLS5i9EuXk7h27dXYIXC63rbAaC5eL9Q0nwseuA5NNY2oR3
         /z/AOg/KH2tWwq2lnxQfLOTVqEVWXS0VcF+0woy4GTURic/grmZsTWQjnC8IhvcUWQmA
         ALUHwIw9o+MCJw2uhEkuBmdHSGMlInPRhKKJthYrlCEwYUQDAoI22rid0DEKoQqtHgZl
         TIUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XhZZr8S7K+/03WxcdeaI9qeKnRSBGg+MsZ5iPpRFv0k=;
        b=VwnIm2sGwyZPeJfU3sRcwCmyXyGel6E5O+fp6PaPRhp1Uqw4Z4gTQusH90TWqFceRO
         fwCFw3xj2YjD94fKi9pm/tuLNGRdZf7fe5nO/Rn6n02jrBajfCZfIPgVa0w8LOKYPQ+K
         e9ililSIvq1QDamin2NxbXJnYtYByom76iyL1maJefI1Kg0FN2wNmWZzxX/UtBV9fuFc
         rwcv2XQ72mfEupYmyAfVy8EHDA2UL6tD1MyVNljfciV8BqEZq7Urs0CzU6CWSD8cuG4D
         IhtgASBRd/KnNB/3eBtodbYnzc9fycBQmjK2FtBN9GtJI8Cl8L583P86X2qiUBHCIMIC
         qzBA==
X-Gm-Message-State: AJIora9Fn2K0mWW5zTsBHQy0kYVpolcwSfS7BSy+CkMkfUC/jgwWFkA+
        aVST2j8va0NCzFtZUEEBiQs=
X-Google-Smtp-Source: AGRyM1vgg8aP9uKcEfxRNo3/FJnMI4FcvEtXuqlJcafyggpKLAzG6eagsoVDLyYLx1wC/+8j6+uQ9A==
X-Received: by 2002:ad4:5cab:0:b0:471:28ca:94b9 with SMTP id q11-20020ad45cab000000b0047128ca94b9mr4730743qvh.9.1656358601140;
        Mon, 27 Jun 2022 12:36:41 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:a41f:1e43:3539:7330])
        by smtp.gmail.com with ESMTPSA id g6-20020a05620a40c600b006a6bb044740sm297436qko.66.2022.06.27.12.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 12:36:40 -0700 (PDT)
Date:   Mon, 27 Jun 2022 12:36:39 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        quic_jzenner@quicinc.com, cong.wang@bytedance.com,
        qitao.xu@bytedance.com, bigeasy@linutronix.de, rostedt@goodmis.org,
        mingo@redhat.com, Sean Tranchetti <quic_stranche@quicinc.com>
Subject: Re: [PATCH net-next v2] net: Print hashed skb addresses for all net
 and qdisc events
Message-ID: <YroGx7Wd2BQ28PjA@pop-os.localdomain>
References: <1656106465-26544-1-git-send-email-quic_subashab@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1656106465-26544-1-git-send-email-quic_subashab@quicinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 03:34:25PM -0600, Subash Abhinov Kasiviswanathan wrote:
> The following commits added support for printing the real address-
> 65875073eddd ("net: use %px to print skb address in trace_netif_receive_skb")
> 70713dddf3d2 ("net_sched: introduce tracepoint trace_qdisc_enqueue()")
> 851f36e40962 ("net_sched: use %px to print skb address in trace_qdisc_dequeue()")
> 
> However, tracing the packet traversal shows a mix of hashes and real
> addresses. Pasting a sample trace for reference-
> 
> ping-14249   [002] .....  3424.046612: netif_rx_entry: dev=lo napi_id=0x3 queue_mapping=0
> skbaddr=00000000dcbed83e vlan_tagged=0 vlan_proto=0x0000 vlan_tci=0x0000 protocol=0x0800
> ip_summed=0 hash=0x00000000 l4_hash=0 len=84 data_len=0 truesize=768 mac_header_valid=1
> mac_header=-14 nr_frags=0 gso_size=0 gso_type=0x0
> ping-14249   [002] .....  3424.046615: netif_rx: dev=lo skbaddr=ffffff888e5d1000 len=84
> 
> Switch the trace print formats to %p for all the events to have a
> consistent format of printing the hashed addresses in all cases.
> 

This is obscured...

What exactly is the inconsistency here? Both are apparently hex, from
user's point of view. The only difference is one is an apparently
invalid kernel address, the other is not. This difference only matters
when you try to dereference it, but I don't think you should do it here,
this is not a raw tracepoint at all. You can always use raw tracepoints
to dereference it without even bothering whatever we print.

Thanks.
