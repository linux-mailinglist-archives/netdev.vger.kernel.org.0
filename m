Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F279764D84F
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 10:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiLOJLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 04:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLOJLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 04:11:12 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0751F9C0
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:11:08 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id h16so2310762wrz.12
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KZAEoxLib+frj+uv7j6MpVcnCrk2tSCoND8juKVSPXg=;
        b=v0EocZ+oKmb2EkjJ4UY4Me/kUvifHNm5KLiohtUjdRR4A5uoLdlYGU7N6bQ4nJp4eY
         pVwlBK9MIgQaocZbmQgu/Hmx/Q+HAaIUl7z/I5X1LQAZZN408mKpwLHz+MD0X3SyPRQC
         SSNgEShL2kJujNl3LXQ5pViqW4YIEH7UkPaAkCP+UcbY+FuwBEa+jeOedRFIjufdcsWi
         e9INCDh109PC5dPHpem+nzTNwI5bSF5DknupG+ja6RX22kdVSTfOlcs/kfn+0P+NB9VI
         7fU2Q6A6+OT+euCHQ99JIMbS+B9HEW34K+7hdlUHGGJUv34e/ouiKb6oAsWLtWgeYLDB
         Bozw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZAEoxLib+frj+uv7j6MpVcnCrk2tSCoND8juKVSPXg=;
        b=ZrXbL0JcQacOtXtjGdaNxqWnYuJewKDxklX7GzXkuQ4kQtKjcSCAsillkcfa+4hcb4
         FxzrlWXcM5brlwrKOevJG7kMQPOuLgtWZ7LpcT7HAkzWql/nJ20Keya5oy3U1X5fG3ul
         I0YIpvho6EncfEVRmTG61PMR1ocS+FsP4i6LcRXvmeHVC/imvwHMgJbFkfp+pociGa/D
         1ahm7fGDyizBEAjVg2XcDYTQI8GldF+IoGKE2MKVr4Vm5Jm2lCLEbxij5sZiHMTAedJ5
         cKfdD+Tj2nVQGd5j92gKY26eBkzGv2YFNJkSgVjZVUdB6Cfsdq8JfrD6BPtrSaTQ2xxK
         wxaA==
X-Gm-Message-State: ANoB5pkH18d84rVsPMEuDthRB4NCU8/W4K7j8PnZdGXFtnaTUBHuK6sB
        rdsXeY/wR1Vuda0J4EJwgM61ew==
X-Google-Smtp-Source: AA0mqf7T9S7ypVi6vvFU2tq406kNAyKiWrJgdlkabgA0NR7oQEbDS7VEcesjZRtAsYWIw625fVp/nQ==
X-Received: by 2002:adf:e991:0:b0:24a:acbe:4105 with SMTP id h17-20020adfe991000000b0024aacbe4105mr15405758wrm.53.1671095467384;
        Thu, 15 Dec 2022 01:11:07 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id w2-20020a5d4042000000b002421db5f279sm5484856wrp.78.2022.12.15.01.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 01:11:04 -0800 (PST)
Date:   Thu, 15 Dec 2022 10:11:03 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, leon@kernel.org
Subject: Re: [RFC net-next 14/15] devlink: add by-instance dump infra
Message-ID: <Y5rkpxKm/TdGlJHf@nanopsycho>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-15-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215020155.1619839-15-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 15, 2022 at 03:01:54AM CET, kuba@kernel.org wrote:
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
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> net/devlink/basic.c         | 55 ++++++++++++++++---------------------
> net/devlink/devl_internal.h | 10 +++++++
> net/devlink/netlink.c       | 33 ++++++++++++++++++++++
> 3 files changed, 67 insertions(+), 31 deletions(-)
>
>diff --git a/net/devlink/basic.c b/net/devlink/basic.c
>index c6ad8133fc23..f18d8dcf9751 100644
>--- a/net/devlink/basic.c
>+++ b/net/devlink/basic.c
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
> 		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
> 		/* can be retrieved by unprivileged users */
> 	},
>diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
>index 5adac38454fd..e49b82dd77cd 100644
>--- a/net/devlink/devl_internal.h
>+++ b/net/devlink/devl_internal.h
>@@ -122,6 +122,11 @@ struct devlink_nl_dump_state {
> 	};
> };
> 
>+struct devlink_gen_cmd {
>+	int (*dump_one)(struct sk_buff *msg, struct devlink *devlink,
>+			struct netlink_callback *cb);
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
>+
> struct devlink_rate *
> devlink_rate_get_from_info(struct devlink *devlink, struct genl_info *info);
> struct devlink_rate *
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
>+};

Instead of having this extra list of ops struct, woudn't it make sence
to rather implement this dumpit_one infra directly as a part of generic
netlink code? Something like:

 	{
 		.cmd = DEVLINK_CMD_RATE_GET,
 		.doit = devlink_nl_cmd_rate_get_doit,
		.dumpit_one = devlink_nl_cmd_rate_get_dumpit_one,
		.dumpit_one_walk = devlink_nl_dumpit_one_walk,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
 		/* can be retrieved by unprivileged users */
 	},

Where devlink_nl_dumpit_one_walk would be basically your
devlink_instance_iter_dump(), it would get an extra arg dumpit_one
function pointer from generic netlink code to call per item:

int devlink_nl_dumpit_one_walk(struct sk_buff *msg, struct netlink_callback *cb,
			       int (*dumpit_one)(struct sk_buff *msg,
						 struct netlink_callback *cb,
						 void *priv));
{
	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
	struct devlink *devlink;
	int err = 0;

	devlink_dump_for_each_instance_get(msg, dump, devlink) {
		devl_lock(devlink);
		err = dumpit_one(msg, cb, devlink);
		devl_unlock(devlink);
		devlink_put(devlink);

		if (err)
			break;

		/* restart sub-object walk for the next instance */
		dump->idx = 0;
	}

	if (err != -EMSGSIZE)
		return err;
	return msg->len;
}



Or we can avoid .dumpit_one_walk() and just have classic .dumpit() which
would get the dumpit_one() pointer cb->dumpit_one (obtainable by
a helper doing a proper check-warn_on on null).


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
