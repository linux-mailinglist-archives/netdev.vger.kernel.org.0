Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9931365DAC7
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 17:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240025AbjADQzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 11:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240000AbjADQys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 11:54:48 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18C047307
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 08:50:59 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id az7so9236665wrb.5
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 08:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0LhG11KzMVM4PF1p0zhiRKykl+q+G5/E9un36dnx83E=;
        b=Qf9vhAKliDlRT/2wlcKXPZGPgNz1u+9JsLASHPBwu9jBf/KRfXJDQa7CeX4pW4sXEH
         V+u4JlfsAne5G3Q0HqcrbPsPPGl/xJ0c/Nm+ocatb7zxHYuF+qN0HmAEoeg6oMXFEiFt
         6HIIell3Z2gT4z0I9ENE15DXkHRW3psF0tU/1xvDN1Ru/siG5XND0ZlORqLlcq+b/nZM
         e3Jxr7FgcH+J632Vdj5XYw3Bfg55ip+RWJLxtSlHMzLNqY6WAfd4HbJoc94G+cKnDe8l
         36fWyox3QkpaJRbO3o7jKm2OY0uDLo5LBu3XcssZwX2b7vNUTwWfc/loayFbhRLkQB4L
         CC/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0LhG11KzMVM4PF1p0zhiRKykl+q+G5/E9un36dnx83E=;
        b=VtvBJ6CeNkLxxZxkv9jnEUn2z2Cy9pRP2Ie/yqeSXi3P8SZn46eNZDkjacQTbfojak
         BC5ILq9gNseVcVsuWSZ4zsbJGTNlaLzPuGUJ1+UdvvPquR9BWe4eJ0rG1SnbbAErFZcB
         b38WqRLxeGY6/8RalrQ/jxAr/6Yuq9J0q2aOdfaRN13JYehQkNS/s7xDtU1mbzB85LPA
         SaeDg3ksLaV6LFGWu9Sk5uE58MqmmVNHz77OdEON+IzaDCmo31LYF28UAiWdPkqej/0Q
         tXa73Neol+DCDbR5d61V0MvUhdWt/BEzmUrICiOzXeawtOTUkZJLso9zu+ypiD/5FeHw
         POHQ==
X-Gm-Message-State: AFqh2kpc4Zzl9T2R8GQMsxUVClmtJSprWclN/EuHMzr/0R1GRWr9is0K
        JhPB8labzaOcmXjmf/q4oP8UuA==
X-Google-Smtp-Source: AMrXdXuwyDN6AIRRysPzxOZ9fdV6oirC9F78/3IcQna6L5AmH2JQ0SyzR06TaCv6fJN5i7ygZMin8g==
X-Received: by 2002:a05:6000:102:b0:2a4:a315:dfc5 with SMTP id o2-20020a056000010200b002a4a315dfc5mr1459453wrx.28.1672851034802;
        Wed, 04 Jan 2023 08:50:34 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id d11-20020adffd8b000000b00236545edc91sm34137293wrr.76.2023.01.04.08.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 08:50:33 -0800 (PST)
Date:   Wed, 4 Jan 2023 17:50:33 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 13/14] devlink: add by-instance dump infra
Message-ID: <Y7WuWd2jfifQ3E8A@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-14-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104041636.226398-14-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 04, 2023 at 05:16:35AM CET, kuba@kernel.org wrote:
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
> net/devlink/netlink.c       | 33 ++++++++++++++++++++++
> 3 files changed, 67 insertions(+), 31 deletions(-)
>
>diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
>index 5adac38454fd..e49b82dd77cd 100644
>--- a/net/devlink/devl_internal.h
>+++ b/net/devlink/devl_internal.h
>@@ -122,6 +122,11 @@ struct devlink_nl_dump_state {
> 	};
> };
> 
>+struct devlink_gen_cmd {

What is "gen"? Generic netlink? Not sure why perhaps "nl" would be fine
to be consistent with the rest of the code?
Why "cmd"? That looks a bit odd to me.



>+	int (*dump_one)(struct sk_buff *msg, struct devlink *devlink,
>+			struct netlink_callback *cb);

Do you plan to have more callbacks here? If no, wouldn't it be better
to just have typedef and assign the pointer to the dump_one in devl_gen_cmds
array?


>+};
>+
> /* Iterate over devlink pointers which were possible to get reference to.
>  * devlink_put() needs to be called for each iterated devlink pointer
>  * in loop body in order to release the reference.
>@@ -138,6 +143,9 @@ struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs);
> void devlink_notify_unregister(struct devlink *devlink);
> void devlink_notify_register(struct devlink *devlink);
> 
>+int devlink_instance_iter_dump(struct sk_buff *msg,
>+			       struct netlink_callback *cb);
>+
> static inline struct devlink_nl_dump_state *
> devl_dump_state(struct netlink_callback *cb)
> {
>@@ -173,6 +181,8 @@ devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info);
> void devlink_linecard_put(struct devlink_linecard *linecard);
> 
> /* Rates */
>+extern const struct devlink_gen_cmd devl_gen_rate_get;

The struct name is *_cmd, not sure why the variable name is *_get
Shouldn't it be rather devl_gen_cmd_rate?

Still sounds a bit odd.


>+
> struct devlink_rate *
> devlink_rate_get_from_info(struct devlink *devlink, struct genl_info *info);
> struct devlink_rate *
>diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
>index c6ad8133fc23..f18d8dcf9751 100644
>--- a/net/devlink/leftover.c
>+++ b/net/devlink/leftover.c
>@@ -1219,47 +1219,40 @@ static void devlink_rate_notify(struct devlink_rate *devlink_rate,
> 				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
> }
> 
>-static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
>-					  struct netlink_callback *cb)
>+static int
>+devlink_nl_cmd_rate_get_dumpinst(struct sk_buff *msg, struct devlink *devlink,
>+				 struct netlink_callback *cb)
> {
> 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
>-	struct devlink *devlink;
>+	struct devlink_rate *devlink_rate;
>+	int idx = 0;
> 	int err = 0;
> 
>-	devlink_dump_for_each_instance_get(msg, dump, devlink) {
>-		struct devlink_rate *devlink_rate;
>-		int idx = 0;
>-
>-		devl_lock(devlink);
>-		list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
>-			enum devlink_command cmd = DEVLINK_CMD_RATE_NEW;
>-			u32 id = NETLINK_CB(cb->skb).portid;
>+	list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
>+		enum devlink_command cmd = DEVLINK_CMD_RATE_NEW;
>+		u32 id = NETLINK_CB(cb->skb).portid;
> 
>-			if (idx < dump->idx) {
>-				idx++;
>-				continue;
>-			}
>-			err = devlink_nl_rate_fill(msg, devlink_rate, cmd, id,
>-						   cb->nlh->nlmsg_seq,
>-						   NLM_F_MULTI, NULL);
>-			if (err) {
>-				devl_unlock(devlink);
>-				devlink_put(devlink);
>-				dump->idx = idx;
>-				goto out;
>-			}
>+		if (idx < dump->idx) {
> 			idx++;
>+			continue;
> 		}
>-		devl_unlock(devlink);
>-		devlink_put(devlink);
>+		err = devlink_nl_rate_fill(msg, devlink_rate, cmd, id,
>+					   cb->nlh->nlmsg_seq,
>+					   NLM_F_MULTI, NULL);
>+		if (err) {
>+			dump->idx = idx;
>+			break;
>+		}
>+		idx++;
> 	}
>-out:
>-	if (err != -EMSGSIZE)
>-		return err;
> 
>-	return msg->len;
>+	return err;
> }
> 
>+const struct devlink_gen_cmd devl_gen_rate_get = {
>+	.dump_one		= devlink_nl_cmd_rate_get_dumpinst,

dump_one/dumpinst inconsistency in names


>+};
>+
> static int devlink_nl_cmd_rate_get_doit(struct sk_buff *skb,
> 					struct genl_info *info)
> {
>@@ -9130,7 +9123,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
> 	{
> 		.cmd = DEVLINK_CMD_RATE_GET,
> 		.doit = devlink_nl_cmd_rate_get_doit,
>-		.dumpit = devlink_nl_cmd_rate_get_dumpit,
>+		.dumpit = devlink_instance_iter_dump,

again, inconsistency:
devlink_instance_iter_dumpit


> 		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
> 		/* can be retrieved by unprivileged users */

Unrelated to this patch, I wonder, why you didn't move devlink_nl_ops
along with the rest of the netlink code to netlink.c?


> 	},
>diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
>index ce1a7d674d14..fcf10c288480 100644
>--- a/net/devlink/netlink.c
>+++ b/net/devlink/netlink.c
>@@ -5,6 +5,7 @@
>  */
> 
> #include <net/genetlink.h>
>+#include <net/sock.h>
> 
> #include "devl_internal.h"
> 
>@@ -177,6 +178,38 @@ static void devlink_nl_post_doit(const struct genl_split_ops *ops,
> 	devlink_put(devlink);
> }
> 
>+static const struct devlink_gen_cmd *devl_gen_cmds[] = {
>+	[DEVLINK_CMD_RATE_GET]		= &devl_gen_rate_get,

static const devlink_nl_dump_one_t *devlink_nl_dump_one[] = {
	[DEVLINK_CMD_RATE_GET]	= &devl_nl_rate_dump_one,
}
Maybe? (not sure how the devlink/devl should be used here though)



>+};
>+
>+int devlink_instance_iter_dump(struct sk_buff *msg, struct netlink_callback *cb)
>+{
>+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
>+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
>+	const struct devlink_gen_cmd *cmd;
>+	struct devlink *devlink;
>+	int err = 0;
>+
>+	cmd = devl_gen_cmds[info->op.cmd];
>+
>+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
>+		devl_lock(devlink);
>+		err = cmd->dump_one(msg, devlink, cb);
>+		devl_unlock(devlink);
>+		devlink_put(devlink);
>+
>+		if (err)
>+			break;
>+
>+		/* restart sub-object walk for the next instance */
>+		dump->idx = 0;
>+	}
>+
>+	if (err != -EMSGSIZE)
>+		return err;
>+	return msg->len;
>+}
>+
> struct genl_family devlink_nl_family __ro_after_init = {
> 	.name		= DEVLINK_GENL_NAME,
> 	.version	= DEVLINK_GENL_VERSION,
>-- 
>2.38.1
>
