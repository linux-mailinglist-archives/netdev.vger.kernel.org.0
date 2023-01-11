Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF928665725
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238441AbjAKJQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjAKJQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:16:34 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F0118B1D
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:13:10 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so1330057pjl.0
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9d8pRYCssiwsyvUCfZsXBqtrO7dbmL3KbeL5Cd/B6d4=;
        b=u5P25GCIR8zKFCUdJQzBCqsCeDqca4Mk2bncgOrOE2Pb1wFZrx9CcnY1PbnJ8xczbs
         oDhiUd2OTh/HEjaL2pBY9eR2anqPXJez1EBpPEemk42Jb1c5x+JNHCAh1+Ou/IMkib2k
         2puET1cSi0qn/CGwVNxjjgG4VzxyyUtur7id7xIDXj2LnUbOW9AeVQNvozBiu42sbUSB
         7uMxJ5qZE15zvx4BM1YoDtvdU15M1VckrXFOWsXdggmcbBGHaky094SqYaaY69TPtt1U
         YE8T6/SqAPdt1iNNcDfmc3W+/UTDlw4KinRiBCjlKebyucab+e6yabt4mSrSPQibuGd6
         8QuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9d8pRYCssiwsyvUCfZsXBqtrO7dbmL3KbeL5Cd/B6d4=;
        b=ODxXG4GOCyZfVMys7AmySAUVf5WbYMUfbAA+5WjLyPs59/rcBU2x9PfqafsLtgKdhS
         4pLhQ6vixwy7KIPOXpAawbEpwnBHcDf5xqVKLuCCBX+6Nniags3A4U94u1K2d4EGWFLu
         6hDs4hERk4u9ncTHaibaFOJEH9ytKT4h8i3J8DbElECwCDQx8A8+zrUe/jlD995K7ytZ
         2GlGtBHg+H+tlB0RjfJvtZ5fCxwH25oT63rCyWJOdi5HCO+CbhtkAmacYkmWW0LrOIwk
         LN28e6UKHZYPI6jt8pvOEcwFRH/Dt4nn3GUYzZMMUn+7VB3e0/EvxAVDfPotfPtW+XOS
         zAsQ==
X-Gm-Message-State: AFqh2krVGdYX//2cpMApNqANlcS/42bVrm2LZHw6AFmMb1+ocK1QgAtL
        eTUu/6Ff8XzM0Kz998Y2GPmlSw==
X-Google-Smtp-Source: AMrXdXubH/BcRf+1WFL40dNd69vDN+U4joh77HWAQZp2yYm2JvpvlnSBiajvPx+DiuJqmzTsi3v+KA==
X-Received: by 2002:a17:90a:470d:b0:219:65b0:9932 with SMTP id h13-20020a17090a470d00b0021965b09932mr71979450pjg.1.1673428390383;
        Wed, 11 Jan 2023 01:13:10 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id z15-20020a17090a608f00b00225d7c0dc14sm10333596pji.28.2023.01.11.01.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 01:13:09 -0800 (PST)
Date:   Wed, 11 Jan 2023 10:13:06 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: Re: [PATCH net] sch_htb: Avoid grafting on htb_destroy_class_offload
 when destroying htb
Message-ID: <Y759ojjda4lh/vQk@nanopsycho>
References: <20230110202003.25452-1-rrameshbabu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110202003.25452-1-rrameshbabu@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 10, 2023 at 09:20:04PM CET, rrameshbabu@nvidia.com wrote:
>Peek at old qdisc and graft only when deleting leaf class in the htb. When
>destroying the htb, the caller may already have grafted a new qdisc that is
>not part of the htb structure being destroyed. htb_destroy_class_offload
>should not peek at the qdisc of the netdev queue since that will either be

You are not telling the codebase what to do. Do it in order to make it
obvious what the patch is doing. That makes the patch description easier
to understand.


>the new qdisc in the case of replacing the htb or simply a noop_qdisc is
>the case of destroying the htb without a replacement qdisc.


Looks to me like 2 fixes, shouldn't this be 2 patches instead?


>
>Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
>Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
>Cc: Eric Dumazet <edumazet@google.com>
>Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
>---
> net/sched/sch_htb.c | 23 +++++++++++++----------
> 1 file changed, 13 insertions(+), 10 deletions(-)
>
>diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
>index 2238edece1a4..360ce8616fd2 100644
>--- a/net/sched/sch_htb.c
>+++ b/net/sched/sch_htb.c
>@@ -1557,14 +1557,13 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
> 
> 	WARN_ON(!q);
> 	dev_queue = htb_offload_get_queue(cl);
>-	old = htb_graft_helper(dev_queue, NULL);
>-	if (destroying)
>-		/* Before HTB is destroyed, the kernel grafts noop_qdisc to
>-		 * all queues.
>+	if (!destroying) {
>+		old = htb_graft_helper(dev_queue, NULL);
>+		/* Last qdisc grafted should be the same as cl->leaf.q when
>+		 * calling htb_destroy
> 		 */
>-		WARN_ON(!(old->flags & TCQ_F_BUILTIN));
>-	else
> 		WARN_ON(old != q);
>+	}
> 
> 	if (cl->parent) {
> 		_bstats_update(&cl->parent->bstats_bias,
>@@ -1581,10 +1580,14 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
> 	};
> 	err = htb_offload(qdisc_dev(sch), &offload_opt);
> 
>-	if (!err || destroying)
>-		qdisc_put(old);
>-	else
>-		htb_graft_helper(dev_queue, old);
>+	/* htb_offload related errors when destroying cannot be handled */
>+	WARN_ON(err && destroying);
>+	if (!destroying) {
>+		if (!err)
>+			qdisc_put(old);
>+		else
>+			htb_graft_helper(dev_queue, old);
>+	}
> 
> 	if (last_child)
> 		return err;
>-- 
>2.36.2
>
