Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5785A26C5
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiHZLWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiHZLWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:22:07 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1386DAED5
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:22:06 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id d21so2574717eje.3
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=CucRIh2PrXJb3DcHrtgbJOyx1jHP2bG91bbSYwOhaC4=;
        b=HvXKS4dcAMneqpLk4BthVcbsID88oOPNSXHv001zzFH6fQ6ZFl489fa3SWx12aDCtA
         kg3oUDxVjGKkRg1khn9wZw1FWeYuZ0sjHdm6zH57pVMynZh44YzxXAwpm2pllZlJ17Y7
         04DrPdQT4/3rBhpnxLnRrb6t5EGsTS89/WL/kRuFreopdYSRa0rJhLYRxGcTH4fDmpOs
         PjnV4Lbfb/h15EQ0BOoXbuw09F5n4075uxoLKxywmbdkBWkOB4gy0Zb8OoION1g/LUrC
         +LwtZIR/gicMna9yYU5SitNTCWefaLXekOXL5A2OJGQ0Sq/s+HVqnIXsEcejaU2a8l1w
         Girg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=CucRIh2PrXJb3DcHrtgbJOyx1jHP2bG91bbSYwOhaC4=;
        b=eCBPClIlnz1Dn2U7eYi95SeiXA7tvvbmgTZXTe/a6ZOPLThIpFklPW2rN1A68AxM1e
         BzyAqAm/F00ylqjupKU88yXo2QKRTsNWBM8FHVLzAEmSYotiwwOkvCcQ19WlOIP/oJ8X
         q3gc4xLUjFhSZwt5izwsfHRb6Y3jJcctq0+hs5HmVCJZhrfu24mtSjomsgKljW9xGuWr
         ZJFCHkUWtYkyeVhERUVYsn8xOY4lxwuBe/P6LKs9qKnh3in+SLMx1KcVXR4V0lQe4ZvP
         gjkLSSw6MucZ/Yr+I7vzh/mP2vhpZ6P8p5o1SIBgIqaJOJknsJ4buJ2xSx6c3w0PmFzi
         RaMw==
X-Gm-Message-State: ACgBeo3acA0m/NV7jI4ufH8EQMxtU6wWeS8QltZUphYWRAJxyEuu07ap
        NvqjKFpOlt8OT8atSssxPgUzKQ==
X-Google-Smtp-Source: AA6agR4zpJPV89k3LUSi4f8kgVgkLFTq1AEIkXh4pwcgeIxcaEXLyY3dk2DWpy3Qapk/zhL5IrAmQQ==
X-Received: by 2002:a17:907:284a:b0:73d:a818:5a2a with SMTP id el10-20020a170907284a00b0073da8185a2amr5033329ejc.159.1661512925326;
        Fri, 26 Aug 2022 04:22:05 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s25-20020aa7cb19000000b004477c582ffdsm1097632edt.80.2022.08.26.04.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 04:22:04 -0700 (PDT)
Date:   Fri, 26 Aug 2022 13:22:04 +0200
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
Message-ID: <Ywis3PYhKiATnzXB@nanopsycho>
References: <20220826110059.119927-1-wojciech.drewek@intel.com>
 <20220826110059.119927-2-wojciech.drewek@intel.com>
 <Ywir0R7xdE7RZIhD@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ywir0R7xdE7RZIhD@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 26, 2022 at 01:17:37PM CEST, jiri@resnulli.us wrote:
>Fri, Aug 26, 2022 at 01:00:55PM CEST, wojciech.drewek@intel.com wrote:
>>IPPROTO_L2TP is currently defined in l2tp.h, but most of
>>ip protocols is defined in in.h file. Move it there in order
>>to keep code clean.
>>
>>Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
>>---
>> include/uapi/linux/in.h   | 2 ++
>> include/uapi/linux/l2tp.h | 2 --
>> 2 files changed, 2 insertions(+), 2 deletions(-)
>>
>>diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
>>index 14168225cecd..5a9454c886b3 100644
>>--- a/include/uapi/linux/in.h
>>+++ b/include/uapi/linux/in.h
>>@@ -68,6 +68,8 @@ enum {
>> #define IPPROTO_PIM		IPPROTO_PIM
>>   IPPROTO_COMP = 108,		/* Compression Header Protocol		*/
>> #define IPPROTO_COMP		IPPROTO_COMP
>>+  IPPROTO_L2TP = 115,		/* Layer 2 Tunnelling Protocol		*/
>>+#define IPPROTO_L2TP		IPPROTO_L2TP
>>   IPPROTO_SCTP = 132,		/* Stream Control Transport Protocol	*/
>> #define IPPROTO_SCTP		IPPROTO_SCTP
>>   IPPROTO_UDPLITE = 136,	/* UDP-Lite (RFC 3828)			*/
>>diff --git a/include/uapi/linux/l2tp.h b/include/uapi/linux/l2tp.h
>>index bab8c9708611..7d81c3e1ec29 100644
>>--- a/include/uapi/linux/l2tp.h
>>+++ b/include/uapi/linux/l2tp.h
>>@@ -13,8 +13,6 @@
>> #include <linux/in.h>
>> #include <linux/in6.h>
>> 
>>-#define IPPROTO_L2TP		115
>
>You most certainly cannot do this, as you would break the user including
>linux/l2tp.h and using this.

Ah wait, you include in.h, I overlooked.


>
>
>>-
>> /**
>>  * struct sockaddr_l2tpip - the sockaddr structure for L2TP-over-IP sockets
>>  * @l2tp_family:  address family number AF_L2TPIP.
>>-- 
>>2.31.1
>>
