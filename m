Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C6A5A26BC
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241398AbiHZLRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238911AbiHZLRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:17:40 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11448DAED7
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:17:39 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bq11so1398637wrb.12
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=s5HqRvr7PHDgoWZiabiLCmfMHT6gZC+dy6EsiwT3xbQ=;
        b=7h9g7EK9RqVul2SxQH6CNrg/bVcpzhDCrLUdI6ScWhDU7WNx4ReP5AgoC/a8qWBvS1
         jVvE5cHj0rgJGVhhf/DJjWMVYJAYGk5HqVZOqAY02dQZ+svPBzEAYE9qbgpbvEuy8smC
         qppATxVh+u+btTiaVx1FSOheR+KENUYveqzCzybJQdH6iM/C9tqrqLqc9O5nw/12qiTp
         9K0qVYLbsUfyClH99d5GboIwoku2OvJicFJ73DD2dG681QDpOF3ViGbL+GARN7fKrUkv
         wkzI10UZCVABrX5D75xc7KumSNIn9kyreUd2ohPOtQ8ojq5h+mxqi8BjK5z3tLbG1/PZ
         Rcmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=s5HqRvr7PHDgoWZiabiLCmfMHT6gZC+dy6EsiwT3xbQ=;
        b=sGkvBXGUYEi7kc81UeQBu2sO+d/XmNlPtFYWqU4F9AyvqJmJVge6fUSUlLxnbacBv2
         meHx4lXAhfpTzz4+RwsPkJdjSgNQCv5U823VeIr299OgRVh5GNUSE7aw3ZeWeafuNr4k
         EvosN11byiqERQdQg1XiNXtDIGh7kGsXKrEFkYl/ZfxgOy/G2N7TBh0Bhm7kSci61uQ5
         pMt24+BwiTlY1Z+py7LTeFl90jODs4zfB0ZW1UMqaMJFzIdfdAktg6YmOMglAx2Z0qWi
         VZ1JO6tyBfrdavS3O5RZAtgxNRYGd2uovFYoVJgogAyZbMSLzW9vJEGadXK0E0wqRFM0
         W6Ag==
X-Gm-Message-State: ACgBeo2lNdjVTbZBOke6D+S2WoTP5Igpp1nb9c99+K9f0QYeDLXXqRlY
        E1hhnxP4TbPVkIbNVtDlxQ3oZw==
X-Google-Smtp-Source: AA6agR7O+TmV/Wg7dw7LV0qg1aUoBB0fczi0zDl0Ee3qSOIFltVBL8eS4m8i5QweusGvGcmsr9QSKw==
X-Received: by 2002:a05:6000:15ca:b0:225:4575:746d with SMTP id y10-20020a05600015ca00b002254575746dmr4460103wry.147.1661512658299;
        Fri, 26 Aug 2022 04:17:38 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id by6-20020a056000098600b0021f15514e7fsm2059971wrb.0.2022.08.26.04.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 04:17:37 -0700 (PDT)
Date:   Fri, 26 Aug 2022 13:17:37 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        marcin.szycik@linux.intel.com, michal.swiatkowski@linux.intel.com,
        kurt@linutronix.de, boris.sukholitko@broadcom.com,
        vladbu@nvidia.com, komachi.yoshiki@gmail.com, paulb@nvidia.com,
        baowen.zheng@corigine.com, louis.peens@corigine.com,
        simon.horman@corigine.com, pablo@netfilter.org,
        maksym.glubokiy@plvision.eu, intel-wired-lan@lists.osuosl.org,
        jchapman@katalix.com, gnault@redhat.com
Subject: Re: [RFC PATCH net-next 1/5] uapi: move IPPROTO_L2TP to in.h
Message-ID: <Ywir0R7xdE7RZIhD@nanopsycho>
References: <20220826110059.119927-1-wojciech.drewek@intel.com>
 <20220826110059.119927-2-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826110059.119927-2-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 26, 2022 at 01:00:55PM CEST, wojciech.drewek@intel.com wrote:
>IPPROTO_L2TP is currently defined in l2tp.h, but most of
>ip protocols is defined in in.h file. Move it there in order
>to keep code clean.
>
>Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
>---
> include/uapi/linux/in.h   | 2 ++
> include/uapi/linux/l2tp.h | 2 --
> 2 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
>index 14168225cecd..5a9454c886b3 100644
>--- a/include/uapi/linux/in.h
>+++ b/include/uapi/linux/in.h
>@@ -68,6 +68,8 @@ enum {
> #define IPPROTO_PIM		IPPROTO_PIM
>   IPPROTO_COMP = 108,		/* Compression Header Protocol		*/
> #define IPPROTO_COMP		IPPROTO_COMP
>+  IPPROTO_L2TP = 115,		/* Layer 2 Tunnelling Protocol		*/
>+#define IPPROTO_L2TP		IPPROTO_L2TP
>   IPPROTO_SCTP = 132,		/* Stream Control Transport Protocol	*/
> #define IPPROTO_SCTP		IPPROTO_SCTP
>   IPPROTO_UDPLITE = 136,	/* UDP-Lite (RFC 3828)			*/
>diff --git a/include/uapi/linux/l2tp.h b/include/uapi/linux/l2tp.h
>index bab8c9708611..7d81c3e1ec29 100644
>--- a/include/uapi/linux/l2tp.h
>+++ b/include/uapi/linux/l2tp.h
>@@ -13,8 +13,6 @@
> #include <linux/in.h>
> #include <linux/in6.h>
> 
>-#define IPPROTO_L2TP		115

You most certainly cannot do this, as you would break the user including
linux/l2tp.h and using this.


>-
> /**
>  * struct sockaddr_l2tpip - the sockaddr structure for L2TP-over-IP sockets
>  * @l2tp_family:  address family number AF_L2TPIP.
>-- 
>2.31.1
>
