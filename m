Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE25765E73E
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjAEJDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjAEJDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:03:05 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD1B5017A
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:02:57 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id b24-20020a05600c4a9800b003d21efdd61dso793417wmp.3
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 01:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QIxhNFEpJSeoW5tEfsYMBSageuvzdoo8gLn5tMGDLCM=;
        b=VhndDYVpxX78KhH3Ecsd33/DSZZZ+p+INxy6Eanm6Lw1mBJLP6jKjQJahX4ye6/cA4
         Ply4tvl9OEHyF6Kf2OprIUUjM1AqrQYKuGaEeu3v/937c43OP0RWJtLK3BGOnKPDgHIT
         k6F+C7dUk6lrTytlHciuEMvJcYAlxxlh+2l6Ra3zTwO/8U9zURX71dan0taYlKHOHvG4
         h5uioas1mpixZFZTCRW6/KW8Qu42ykm2N0ZcbL2kw1etYdVQlUtWonXM7QnaabsJHta2
         PZ3LjpeteLzcHcDfGXhEa04wNXTsy9d4WhNgp9wdymywgJifr/9uZI4aM3BImCfXhEyU
         hh1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QIxhNFEpJSeoW5tEfsYMBSageuvzdoo8gLn5tMGDLCM=;
        b=jZqNS6a+lLZ8LyWarUpivg1rj42TW3y9+4PT0faOYtNmKiH03tbhs+e+pVzFjd3SIi
         tKLNXOf3Jg73DcFg8w9fpIOZDyJu75SXju6FDrRxByHKu6eZ7hyGySJhPZETnEKYe8B9
         NpSfEvZR0cGo4BH1jbAU4Yhb1jTYHmKdcEpVaBvYn51ZTYxLCaAMuk2zS581IQPgc53s
         o+b6iQTyWxXz0jsAtxY1CG8ajCUGbUTKE0H3V6paGDq/tUgli2txi0R+ehAONeu7W1TE
         a7sbfF/fp55pYoX9DvgalC4eUwjty6p4/sk7UH41t/wXHhftyrfeRZwEMx81CdmyAxd4
         oQHQ==
X-Gm-Message-State: AFqh2kqbYjWX61W9J13h4ToNaQnf+u75oN4MrP44wy9633jaLUNml/h/
        oi8oZVlLJhKJso+1wnX6UQ2PPD+PP1qsF3fVOiM=
X-Google-Smtp-Source: AMrXdXu7prASnI0BJz/5vCAzPhxTdCegR+4+EopaiTnhhr2d9ePzD6A0gT9fFY0idSnUNEgPeLVyGg==
X-Received: by 2002:a05:600c:5014:b0:3d3:446a:b46a with SMTP id n20-20020a05600c501400b003d3446ab46amr38742794wmr.38.1672909375732;
        Thu, 05 Jan 2023 01:02:55 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id j1-20020a05600c1c0100b003cfaae07f68sm1814820wms.17.2023.01.05.01.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 01:02:54 -0800 (PST)
Date:   Thu, 5 Jan 2023 10:02:54 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 13/14] devlink: add by-instance dump infra
Message-ID: <Y7aSPuRPQxxQKQGN@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-14-kuba@kernel.org>
 <Y7WuWd2jfifQ3E8A@nanopsycho>
 <20230104194604.545646c5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104194604.545646c5@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 04:46:04AM CET, kuba@kernel.org wrote:
>On Wed, 4 Jan 2023 17:50:33 +0100 Jiri Pirko wrote:
>> Wed, Jan 04, 2023 at 05:16:35AM CET, kuba@kernel.org wrote:
>> >Most dumpit implementations walk the devlink instances.
>> >This requires careful lock taking and reference dropping.
>> >Factor the loop out and provide just a callback to handle
>> >a single instance dump.
>> >
>> >Convert one user as an example, other users converted
>> >in the next change.
>> >
>> >Slightly inspired by ethtool netlink code.
>
>> >diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
>> >index 5adac38454fd..e49b82dd77cd 100644
>> >--- a/net/devlink/devl_internal.h
>> >+++ b/net/devlink/devl_internal.h
>> >@@ -122,6 +122,11 @@ struct devlink_nl_dump_state {
>> > 	};
>> > };
>> > 
>> >+struct devlink_gen_cmd {  
>> 
>> What is "gen"? Generic netlink?
>
>Generic devlink command. In other words the implementation 
>is straightforward enough to factor out the common parts.

Could it be "genl" then?


>
>> Not sure why perhaps "nl" would be fine to be consistent with the
>> rest of the code? Why "cmd"? That looks a bit odd to me.
>> 
>> >+	int (*dump_one)(struct sk_buff *msg, struct devlink
>> >*devlink,
>> >+			struct netlink_callback *cb);  
>> 
>> Do you plan to have more callbacks here? If no, wouldn't it be better
>> to just have typedef and assign the pointer to the dump_one in
>> devl_gen_cmds array?
>
>If I find the time - yes, more refactoring is possible.

Could you elaborate a bit more about that?


>
>> >+};
>> >+
>> > /* Iterate over devlink pointers which were possible to get
>> > reference to.
>> >  * devlink_put() needs to be called for each iterated devlink
>> > pointer
>> >  * in loop body in order to release the reference.
>> >@@ -138,6 +143,9 @@ struct devlink *devlink_get_from_attrs(struct
>> >net *net, struct nlattr **attrs);
>> > void devlink_notify_unregister(struct devlink *devlink);
>> > void devlink_notify_register(struct devlink *devlink);
>> > 
>> >+int devlink_instance_iter_dump(struct sk_buff *msg,
>> >+			       struct netlink_callback *cb);
>> >+
>> > static inline struct devlink_nl_dump_state *
>> > devl_dump_state(struct netlink_callback *cb)
>> > {
>> >@@ -173,6 +181,8 @@ devlink_linecard_get_from_info(struct devlink
>> >*devlink, struct genl_info *info);
>> > void devlink_linecard_put(struct devlink_linecard *linecard);
>> > 
>> > /* Rates */
>> >+extern const struct devlink_gen_cmd devl_gen_rate_get;  
>> 
>> The struct name is *_cmd, not sure why the variable name is *_get
>> Shouldn't it be rather devl_gen_cmd_rate?
>
>It is the implementation of get.. there's also a set command.. 
>which would be under a different index...

I see.


>
>> >+			dump->idx = idx;
>> >+			break;
>> >+		}
>> >+		idx++;
>> > 	}
>> >-out:
>> >-	if (err != -EMSGSIZE)
>> >-		return err;
>> > 
>> >-	return msg->len;
>> >+	return err;
>> > }
>> > 
>> >+const struct devlink_gen_cmd devl_gen_rate_get = {
>> >+	.dump_one		=
>> >devlink_nl_cmd_rate_get_dumpinst,  
>> 
>> dump_one/dumpinst inconsistency in names
>
>Sure...
>
>> >+};
>> >+
>> > static int devlink_nl_cmd_rate_get_doit(struct sk_buff *skb,
>> > 					struct genl_info *info)
>> > {
>> >@@ -9130,7 +9123,7 @@ const struct genl_small_ops devlink_nl_ops[56]
>> >= {
>> > 	{
>> > 		.cmd = DEVLINK_CMD_RATE_GET,
>> > 		.doit = devlink_nl_cmd_rate_get_doit,
>> >-		.dumpit = devlink_nl_cmd_rate_get_dumpit,
>> >+		.dumpit = devlink_instance_iter_dump,  
>> 
>> again, inconsistency:
>> devlink_instance_iter_dumpit
>
>You mean it doesn't have nl, cmd, dump_one in the name?
>Could you *please* at least say what you want the names to be if you're
>sending all those subjective nit picks? :/

Well, I provided a suggested name, not sure why that was not clear.
The point was s/dump/dumpit/ to match the op name.

I'm sorry you find this a subjective nitpick. I believe it is important
to maintain some naming consistency in order to make code readable.
Nothing subjective about it.


>
>I'll call it devlink_nl_instance_iter_dump

devlink_nl_instance_iter_dumpit please.


>
>> > 		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
>> > 		/* can be retrieved by unprivileged users */  
>> 
>> Unrelated to this patch, I wonder, why you didn't move devlink_nl_ops
>> along with the rest of the netlink code to netlink.c?
>
>It's explained in the commit message for patch 3 :/

I missed that, sorry.


>
>> > 	},
>> >diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
>> >index ce1a7d674d14..fcf10c288480 100644
>> >--- a/net/devlink/netlink.c
>> >+++ b/net/devlink/netlink.c
>> >@@ -5,6 +5,7 @@
>> >  */
>> > 
>> > #include <net/genetlink.h>
>> >+#include <net/sock.h>
>> > 
>> > #include "devl_internal.h"
>> > 
>> >@@ -177,6 +178,38 @@ static void devlink_nl_post_doit(const struct
>> >genl_split_ops *ops,
>> > 	devlink_put(devlink);
>> > }
>> > 
>> >+static const struct devlink_gen_cmd *devl_gen_cmds[] = {
>> >+	[DEVLINK_CMD_RATE_GET]		= &devl_gen_rate_get,
>> > 
>> 
>> static const devlink_nl_dump_one_t *devlink_nl_dump_one[] = {
>> 	[DEVLINK_CMD_RATE_GET]	= &devl_nl_rate_dump_one,
>> }
>> Maybe? (not sure how the devlink/devl should be used here though)
>
>Nope.

Awesome.

