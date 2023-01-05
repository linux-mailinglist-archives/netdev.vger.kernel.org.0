Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528A765E7B6
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbjAEJY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbjAEJYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:24:53 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA57551C3
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:24:48 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id bn26so16026951wrb.0
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 01:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uARpZZPLzJSJ8nlmy8ORkG8csp6hNbwdNdeCRnJrxrc=;
        b=ytWBvvShj+voVpI0YOBtc6M12KbfS07v6RuofHMhgOY/XQpERi7bxpyWf0uIiVkWO3
         +D94D1jyAKAGIKpLaYCeGVcE11iOuouuua9UU9RtDpG7W6AbyOAvKNw6a4zTi/pS7n3S
         R6Y7YqCb59d3ynPHptIzcdtzSEVcFIu4WKoo0WPLJB9Pj3b6ZEmU0khlbAFPTphMwp+O
         L0gXULyH/sKkTrQi37ifFQw5iit9G2pCah2I219YrUD5Azhdk55hou9Z9t9v3B0jGPB4
         /XjozSOzBY9wILk+nWcl8gGbl/dHAHwa/HSqlnR82AGeoNrOhU+N66ogfsW5ugyGBZOo
         GTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uARpZZPLzJSJ8nlmy8ORkG8csp6hNbwdNdeCRnJrxrc=;
        b=iOaC2KBCvWVKuIHwlbQMZGTxP/HTFPgtP7TepUDAhERHJ1QfsYOAp99TaiSKxaHqAr
         N64FNhpR3PVCdoOqCUYAvkwcdWm7oVvpvhdwZB2j5jTMfWcxAuz0lVc7L0IGoie/Xuz2
         8XDWUOyRs2E4kek4ASeUukUsITLNcRb8zSwjerFyzzE5VcNs8eQPDkaCyro9eA1saK/F
         0oULD5ole1HrC/9wODuRYsEdGHCESjeyf5zLtrBRO9PLzpCNp9qLAFeyN4KHzQ57N30E
         6Jf24hEh3Xj+JkRGAqqpL7pLVZmgF0W6pv9JvBoliF9OxXaICLIsZELob/qI+VZbpjGJ
         CppA==
X-Gm-Message-State: AFqh2komZ3H1x7XlGQ8acRrDQ0aYxbeC25KkPUnOU8ei/4kJLf7qqDIv
        cnLLtcsrCFueSKjP+xuvFwXptg==
X-Google-Smtp-Source: AMrXdXtmAxKHgCtn7UZUc7assIJAoMdfNz5/QIrY9SJ2VKbcH/WquSAiNg7tEHqxaY43KW09GgrAGA==
X-Received: by 2002:a5d:6f0f:0:b0:298:7fc:60ac with SMTP id ay15-20020a5d6f0f000000b0029807fc60acmr10546583wrb.59.1672910686678;
        Thu, 05 Jan 2023 01:24:46 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h7-20020a5d4307000000b002a64e575b4esm3263733wrq.47.2023.01.05.01.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 01:24:46 -0800 (PST)
Date:   Thu, 5 Jan 2023 10:24:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v2 14/15] devlink: add by-instance dump infra
Message-ID: <Y7aXXQUraJl6So2V@nanopsycho>
References: <20230105040531.353563-1-kuba@kernel.org>
 <20230105040531.353563-15-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105040531.353563-15-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 05:05:30AM CET, kuba@kernel.org wrote:
>Most dumpit implementations walk the devlink instances.
>This requires careful lock taking and reference dropping.
>Factor the loop out and provide just a callback to handle
>a single instance dump.
>
>Convert one user as an example, other users converted
>in the next change.
>
>Slightly inspired by ethtool netlink code.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> net/devlink/devl_internal.h | 10 +++++++
> net/devlink/leftover.c      | 55 ++++++++++++++++---------------------
> net/devlink/netlink.c       | 34 +++++++++++++++++++++++
> 3 files changed, 68 insertions(+), 31 deletions(-)
>
>diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
>index 15149b0a68af..734553beccde 100644
>--- a/net/devlink/devl_internal.h
>+++ b/net/devlink/devl_internal.h
>@@ -122,6 +122,11 @@ struct devlink_nl_dump_state {
> 	};
> };
> 
>+struct devlink_gen_cmd {

As I wrote in reply to v1, could this be "genl"?


>+	int (*dump_one)(struct sk_buff *msg, struct devlink *devlink,
>+			struct netlink_callback *cb);
>+};
>+
> /* Iterate over registered devlink instances for devlink dump.
>  * devlink_put() needs to be called for each iterated devlink pointer
>  * in loop body in order to release the reference.

[...]


>@@ -9130,7 +9123,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
> 	{
> 		.cmd = DEVLINK_CMD_RATE_GET,
> 		.doit = devlink_nl_cmd_rate_get_doit,
>-		.dumpit = devlink_nl_cmd_rate_get_dumpit,
>+		.dumpit = devlink_nl_instance_iter_dump,

devlink_nl_instance_iter_dumpit to match ".dumpit".


> 		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
> 		/* can be retrieved by unprivileged users */
> 	},

[...]
