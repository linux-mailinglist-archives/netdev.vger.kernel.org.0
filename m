Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27EE200AD7
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 16:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgFSOCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 10:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbgFSOCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 10:02:01 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CE2C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 07:02:00 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b6so9791755wrs.11
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 07:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lKLQl3JZpg46VIY4TJI1u7ehlZXJjQjC+XBzk60BSVg=;
        b=WSBC87kXriues3X0mMexfvO9OFRgojK2pZgNksn9j49lt4N+YdDuRip2i+26VazDwh
         UKCIYsYHQHou/SS7DyYMIOzRWMhh/yg673yNRNdzAZV5VtNenj96c7ZRHAk7UJkScQCe
         alXnufpJJkj4ZXk2svUcFCbGvgGVhDI5bI9ndYegVULYZkmwDfAK+KWMnf0aFT8XEsR2
         jm53hky1KdIKcEnyCuQGe2zHyqigTvrOcTgBa2SalUM8LpB0mpVrfpIWC12tVSspAKn/
         4mxoz52hPP/HrAkc9nLBj6wOzVoT7dX18L9hNFY092UhPdgeh6i9f6XaMbsgy+ZXaAfW
         7WXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lKLQl3JZpg46VIY4TJI1u7ehlZXJjQjC+XBzk60BSVg=;
        b=GkflBuSYFRrCZDp/6W67PL8eSArsE1JxMHRY06VKNnVRFoqOMZuxR+2Vgq3uvzy/Zk
         M1L3qZ+JCMiiwxHTo0hQ5FHP8kUABbQpVeo+UBxGqAgy+rCVJNED55awoveRKE8oWt9l
         Jwfl0hHyHPV7Wy08ll8yod2m6aDyu+Uq4LNkI+YxpF/LScE2ypmc/mwCU58D9WynMFZ4
         fuQw4QbpITYP8oUUlCR5uGDWGT0iuD1WHacQ6/F8rQBnxSrJysUiONXveQzcTRcUESqy
         x/rcgQH4W+gXtgdK3p7jGmiSSHuTnj6Qwl927otxfsUpB11R1ulPZ4b04Uqgo6DNZ4eX
         bbaQ==
X-Gm-Message-State: AOAM5330D88/4wfjqzZYPQLsbp7GZEkAd3n5zwfPPtPlE/dg9lmSwMmZ
        4OGpBDT981P5XSgl9QBdv2m3hfz/Qrg=
X-Google-Smtp-Source: ABdhPJxNguJSnra2c4I6BqtvweR7het0rdLHuvvRLYaeQ4vpqSoOJZnlpKrr6D8v61vN8coqSyXUow==
X-Received: by 2002:adf:f812:: with SMTP id s18mr4094166wrp.28.1592575319458;
        Fri, 19 Jun 2020 07:01:59 -0700 (PDT)
Received: from localhost (ip-94-113-156-94.net.upcbroadband.cz. [94.113.156.94])
        by smtp.gmail.com with ESMTPSA id u4sm7694266wmb.48.2020.06.19.07.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 07:01:58 -0700 (PDT)
Date:   Fri, 19 Jun 2020 16:01:57 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     dsatish <satish.d@oneconvergence.com>
Cc:     davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        simon.horman@netronome.com, kesavac@gmail.com,
        prathibha.nagooru@oneconvergence.com,
        intiyaz.basha@oneconvergence.com, jai.rana@oneconvergence.com
Subject: Re: [PATCH net-next 3/3] cls_flower: Allow flow offloading though
 masked key exist.
Message-ID: <20200619140157.GB2182@nanopsycho>
References: <20200619094156.31184-1-satish.d@oneconvergence.com>
 <20200619094156.31184-4-satish.d@oneconvergence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619094156.31184-4-satish.d@oneconvergence.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jun 19, 2020 at 11:41:56AM CEST, satish.d@oneconvergence.com wrote:
>A packet reaches OVS user space, only if, either there is no rule in
>datapath/hardware or there is race condition that the flow is added
>to hardware but before it is processed another packet arrives.
>
>It is possible hardware as part of its limitations/optimizations
>remove certain flows. To handle such cases where the hardware lost
>the flows, tc can offload to hardware if it receives a flow for which
>there exists an entry in its flow table. To handle such cases TC when
>it returns EEXIST error, also programs the flow in hardware, if
>hardware offload is enabled.
>
>Signed-off-by: Chandra Kesava <kesavac@gmail.com>
>Signed-off-by: Prathibha Nagooru <prathibha.nagooru@oneconvergence.com>
>Signed-off-by: Satish Dhote <satish.d@oneconvergence.com>
>---
> net/sched/cls_flower.c | 23 +++++++++++++++++++----
> 1 file changed, 19 insertions(+), 4 deletions(-)
>
>diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
>index f1a5352cbb04..d718233cd5b9 100644
>--- a/net/sched/cls_flower.c
>+++ b/net/sched/cls_flower.c
>@@ -431,7 +431,8 @@ static void fl_hw_destroy_filter(struct tcf_proto *tp, struct cls_fl_filter *f,
> 
> static int fl_hw_replace_filter(struct tcf_proto *tp,
> 				struct cls_fl_filter *f, bool rtnl_held,
>-				struct netlink_ext_ack *extack)
>+				struct netlink_ext_ack *extack,
>+				unsigned long cookie)
> {
> 	struct tcf_block *block = tp->chain->block;
> 	struct flow_cls_offload cls_flower = {};
>@@ -444,7 +445,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
> 
> 	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
> 	cls_flower.command = FLOW_CLS_REPLACE;
>-	cls_flower.cookie = (unsigned long) f;
>+	cls_flower.cookie = cookie;
> 	cls_flower.rule->match.dissector = &f->mask->dissector;
> 	cls_flower.rule->match.mask = &f->mask->key;
> 	cls_flower.rule->match.key = &f->mkey;
>@@ -2024,11 +2025,25 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
> 	fl_init_unmasked_key_dissector(&fnew->unmasked_key_dissector);
> 
> 	err = fl_ht_insert_unique(fnew, fold, &in_ht);
>-	if (err)
>+	if (err) {
>+		/* It is possible Hardware lost the flow even though TC has it,
>+		 * and flow miss in hardware causes controller to offload flow again.

What? Seems that you have a buggy HW what should be fixed...

What is "controller"?


>+		 */
>+		if (err == -EEXIST && !tc_skip_hw(fnew->flags)) {
>+			struct cls_fl_filter *f =
>+				__fl_lookup(fnew->mask, &fnew->mkey);
>+
>+			if (f)
>+				fl_hw_replace_filter(tp, fnew, rtnl_held,
>+						     extack,
>+						     (unsigned long)(f));
>+		}
> 		goto errout_mask;
>+	}
> 
> 	if (!tc_skip_hw(fnew->flags)) {
>-		err = fl_hw_replace_filter(tp, fnew, rtnl_held, extack);
>+		err = fl_hw_replace_filter(tp, fnew, rtnl_held, extack,
>+					   (unsigned long)fnew);
> 		if (err)
> 			goto errout_ht;
> 	}
>-- 
>2.17.1
>
