Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5985501AE
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 03:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiFRBb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 21:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234451AbiFRBb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 21:31:56 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B1A6B0BA;
        Fri, 17 Jun 2022 18:31:55 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id d6so4036677ilm.4;
        Fri, 17 Jun 2022 18:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=9X+CU1shIcH/tUnfM3RA+7PCrBSjdTTcceJqopaFXWw=;
        b=T3TGHaxsOxhhisw52+UAVl7vsdYClKCfWykvxJQH7oyDLtRkxzpVPcSksDmfpWFP6u
         b7YCvatS2JgH17Lkk4ghYj+8ihnm9WZO6IpW8YnZ08xH1OHkt+cHvZX71u5eywCOSVwa
         N1qsn61QiURCn2t7OqOIAtGZbtmDhGVfu3ifMQxGytcVclk//I+gy/XRNV3hHc6gsxXc
         qvjx5IKvzu+3m3+4BNuSv5wf0XpIoWBoX6+YgebQ+hSISx2x/Kv/JQxPabrOv4KfGe7I
         YI5XL8iyrWPhxL2teZpi4J4BqE/fsLRrIBLIdQ5onKTfjIZrf8GxKLWUsngPj3RIWS8P
         qOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=9X+CU1shIcH/tUnfM3RA+7PCrBSjdTTcceJqopaFXWw=;
        b=ut7nEHmqzwYnsaRS9MDLpa7dJG7utMJFFmgHp7/uxueC4z340jtZkrMwIRrb1wOf59
         JcGvYuEAnVsbq+jbXWG7ld+uYJpXWtEw1PJQYtr0/3nrfnmZ2jyE4JgkpJnzyoi7DfPx
         TQwkavhVncJqpzbrM7GFKOFhU8irSnIxs441ytkm140JSKg5FPAdhsyEQENydySxgUTR
         4qMepVappnTqpE1jIGNv2a4LnQGU0oOrN97B3ist9B5OF/MbGC8j8SLIme9I+VTFQQiw
         d3BY6j0FR9bITuDGKR/ZS91EL45E3QcmTGBSFc9F6roxiGy9XLmNFVY51aCbV0RgQeom
         NT2Q==
X-Gm-Message-State: AJIora8sil4d8KF3uiYLaHWfXqAJe79YXNzCUgb/qD7Va3tUkEEY/sLM
        tZOp0bc/KTr5OE/ZGynwKXWWnt6diETO/Q==
X-Google-Smtp-Source: AGRyM1tK9DBH36i2OHa9mYazCLrgd8iitOgRPumsdVAJ/SJwaW7UcX7YXrK67AbXwjNL3SrRUcLnwA==
X-Received: by 2002:a05:6e02:158a:b0:2d5:12f0:4dce with SMTP id m10-20020a056e02158a00b002d512f04dcemr7145582ilu.159.1655515914953;
        Fri, 17 Jun 2022 18:31:54 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id 10-20020a02110a000000b003316f4b9b26sm2877173jaf.131.2022.06.17.18.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 18:31:54 -0700 (PDT)
Date:   Fri, 17 Jun 2022 18:31:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Message-ID: <62ad2b02627ce_24b342089f@john.notmuch>
In-Reply-To: <20220615162014.89193-1-xiyou.wangcong@gmail.com>
References: <20220615162014.89193-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v4 0/4] sockmap: some performance optimizations
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
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

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This patchset contains two optimizations for sockmap. The first one
> eliminates a skb_clone() and the second one eliminates a memset(). With
> this patchset, the throughput of UDP transmission via sockmap gets
> improved by 61%.
> 
> v4: replace kfree_skb() with consume_skb()
> 
> v3: avoid touching tcp_recv_skb()
> 
> v2: clean up coding style for tcp_read_skb()
>     get rid of some redundant variables
>     add a comment for ->read_skb()
> ---
> Cong Wang (4):
>   tcp: introduce tcp_read_skb()
>   net: introduce a new proto_ops ->read_skb()
>   skmsg: get rid of skb_clone()
>   skmsg: get rid of unncessary memset()
> 
>  include/linux/net.h |  4 ++++
>  include/net/tcp.h   |  1 +
>  include/net/udp.h   |  3 +--
>  net/core/skmsg.c    | 48 +++++++++++++++++----------------------------
>  net/ipv4/af_inet.c  |  3 ++-
>  net/ipv4/tcp.c      | 44 +++++++++++++++++++++++++++++++++++++++++
>  net/ipv4/udp.c      | 11 +++++------
>  net/ipv6/af_inet6.c |  3 ++-
>  net/unix/af_unix.c  | 23 +++++++++-------------
>  9 files changed, 86 insertions(+), 54 deletions(-)
> 
> -- 
> 2.34.1
> 

Thanks Cong, nice set of improvements.

Reviewed-by: John Fastabend <john.fastabend@gmail.com>
