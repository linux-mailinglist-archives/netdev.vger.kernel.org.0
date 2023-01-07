Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C31660DA2
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 11:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjAGKLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 05:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjAGKLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 05:11:19 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A89F7CDD3
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 02:11:17 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id bj3so706041pjb.0
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 02:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zpaY3jwDxMc1GP3kXzYJwlSPIQoyILsRmh4FJiSITbM=;
        b=K+lnYuwuxBbnw0M+8DjT3yHOwm/UCLByHwH7aWsi8kjSVLevU+jDnhqleKxLCZ1ZmA
         HePAHLtJNFqfODbl94HBCti+13W+WQNRO+tnO81JTCG9e9HyGm4cnTNEiveTpNGSjcQd
         k+FKcNKhbZLTu8DcHG9EJtr9CFT8ysDI9CSwscvguKE6kUdYsASO9wsGnah19RVvMbgA
         ORC7m4AZbfBYUg2Iwg6tTMR+SqfmZBwGpxIi7NThykAfo4fxFKv+yqCB4MtGru7Pc+jz
         SshNlHWfgEC+KmRVUkpY0QNLQtfkREVjBEh1U3YC4dRVCVKN35uOMyO6+bDgPx4NV5XU
         78jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zpaY3jwDxMc1GP3kXzYJwlSPIQoyILsRmh4FJiSITbM=;
        b=yqq8cPDjUwSCoICC+jaQ7igb5gRlz040mg3etewbvHPCxvlr0lwrwj1tHo11PZcTOO
         iB4t1imutPUF5zK7YA9YCefOCWN9rl0RKYd28I1pa2QjMLWhZidaepbfvMZivSa2SVd1
         8qlr3qMrcDf2zJfkJ3F9aqnx4QrSKAU9Ff6oetJ/pLtC56YPjz4YLBDezXFAvzK6q+mR
         orlIFgmpPFX0TfYp18fO6aySLxyWFb9nlBiqEABaJtX/bGO/VAqqBRELwYPxcV4R8Brp
         NkSggFJJLCfHj0wY5piB/rJtoX2Ov/NJbol2gBgQycRZdR7Xsg5HVwkhGHqcB9zSbhCC
         6YqQ==
X-Gm-Message-State: AFqh2kqfet2u1Av48ryb3BbA4QqwcK2PrK5fNuOHCQJb7M6YzaPFlOcv
        7WRPaiu3othkMcfWyeSFlK4W3B6WS40wpv0GHLcWfw==
X-Google-Smtp-Source: AMrXdXsboS2CCCqkFPRdAsCRizhXEBTkmC5C0B3sctqAsE1lL44ZKE18DoMrzmNoj8n2Wf+/tUyiww==
X-Received: by 2002:a17:90a:b78b:b0:226:761c:1b10 with SMTP id m11-20020a17090ab78b00b00226761c1b10mr20309726pjr.45.1673086277064;
        Sat, 07 Jan 2023 02:11:17 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id t11-20020a17090a448b00b00226f49eca92sm851685pjg.28.2023.01.07.02.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 02:11:16 -0800 (PST)
Date:   Sat, 7 Jan 2023 11:11:13 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, maximmi@nvidia.com, gal@nvidia.com
Subject: Re: [patch net-next 7/8] devlink: convert reporters dump to
 devlink_nl_instance_iter_dump()
Message-ID: <Y7lFQa6kBN2AQqz3@nanopsycho>
References: <20230107094909.530239-1-jiri@resnulli.us>
 <20230107094909.530239-8-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230107094909.530239-8-jiri@resnulli.us>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jan 07, 2023 at 10:49:08AM CET, jiri@resnulli.us wrote:
>From: Jiri Pirko <jiri@nvidia.com>
>
>Benefit from recently introduced instance iteration and convert
>reporters .dumpit generic netlink callback to use it.
>
>Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>---
> net/devlink/devl_internal.h | 12 +----
> net/devlink/leftover.c      | 87 ++++++++++++++++---------------------
> net/devlink/netlink.c       |  6 ++-
> 3 files changed, 44 insertions(+), 61 deletions(-)
>
>diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
>index 52d958c1c977..2b0e119e7b84 100644
>--- a/net/devlink/devl_internal.h
>+++ b/net/devlink/devl_internal.h
>@@ -121,17 +121,6 @@ struct devlink_gen_cmd {
> 			struct netlink_callback *cb);
> };
> 
>-/* Iterate over registered devlink instances for devlink dump.
>- * devlink_put() needs to be called for each iterated devlink pointer
>- * in loop body in order to release the reference.
>- * Note: this is NOT a generic iterator, it makes assumptions about the use
>- *	 of @state and can only be used once per dumpit implementation.
>- */
>-#define devlink_dump_for_each_instance_get(msg, state, devlink)		\
>-	for (; (devlink = devlinks_xa_find_get(sock_net(msg->sk),	\
>-					       &state->instance));	\
>-	     state->instance++, state->idx = 0)
>-

I'm sorry, I managed to quash this during rebase by mistake. Sending v2.
