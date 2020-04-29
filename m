Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56161BD428
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 07:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgD2Fp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 01:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgD2Fpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 01:45:55 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E3DC03C1AC
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 22:45:55 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k1so943520wrx.4
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 22:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YUjIa71ofgR8kDGRI5KIFIVDvBDM//7VupEyLtVq3fg=;
        b=YpJjFqMEFJenE57JhFYWL9ugKKhpi9sigAKILS0j0D+2vurhxN6D3qzDP52rYFJbca
         cjRMczw/JgmP8rFIG61G7wVPdQsU0uT+7LzKcBRGYIA1sUwJxAIdVx5t0bdZMd9LkHNG
         J3cxQx1S8b/+HhxsL/q6HaBf0fdqYMsJJnp5pX1OHU5ERKHsRXsxREqCg6viXeiIadhE
         dC0MlJV+s+fhycm86M6D8q8q3+oMdUtHizeLINCREEMhMjA5Tjk+Ct4qe9q8v2UjHPr3
         T4TcNsHxU3GaZ2D47rxLLowU0FIzXNxn8H1Zi9NDXBQb9gbfxwDjGPP7OwUhQ1LiEkkq
         AurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YUjIa71ofgR8kDGRI5KIFIVDvBDM//7VupEyLtVq3fg=;
        b=hgEbsgIqbdGSIUvbnMPiXeYmrAd9J/QQsUfCGUyLBSlXoiXfKYAtOYx2XFIxZe/Llu
         81Zk2hDAQp3x6h2XUUnp6nTU6STpiBYTlIhEHwI00CWOo/838I9/+nzZGerkXewQsMh/
         gDuwN9cB8XDR8MYdw8raSVA7aQ8F4TXEDHIUcAjn2cN4HFIFZSYpPlRBqKu8/9S2t3O0
         ZR5Mn5G4JwVOALu4kKl6Gs5RS8jGonZehkKYeY6uKAmgd1NeioGeNan1TQ1jjNx+ak8o
         j9tDYxx3qdr5Y/7AUr1QuGpQMwNDpYzr5cw5JZsO634nqK6P2PLTFXyRVLoZHbhbB/uh
         yf3w==
X-Gm-Message-State: AGi0Pua4vgrvslscuaLwqa8gTy6EUQXwESiowd3L6Og5z7KBc/yoFR/q
        5YP+mW3v0J1Z2cC44eOuEUuSYw==
X-Google-Smtp-Source: APiQypJIfhQHpnaZgMadafg3j5wdvp/tcZ0z1ZSkUefyqyONKrgKu7QiKTBLa3RlbI8dMdXI8tjpPA==
X-Received: by 2002:adf:ec09:: with SMTP id x9mr36708527wrn.364.1588139154204;
        Tue, 28 Apr 2020 22:45:54 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w18sm27509483wrn.55.2020.04.28.22.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 22:45:53 -0700 (PDT)
Date:   Wed, 29 Apr 2020 07:45:52 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next] devlink: let kernel allocate region snapshot id
Message-ID: <20200429054552.GB6581@nanopsycho.orion>
References: <20200429014248.893731-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429014248.893731-1-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Apr 29, 2020 at 03:42:48AM CEST, kuba@kernel.org wrote:
>Currently users have to choose a free snapshot id before
>calling DEVLINK_CMD_REGION_NEW. This is potentially racy
>and inconvenient.
>
>Make the DEVLINK_ATTR_REGION_SNAPSHOT_ID optional and try
>to allocate id automatically. Send a message back to the
>caller with the snapshot info.
>
>The message carrying id gets sent immediately, but the
>allocation is only valid if the entire operation succeeded.
>This makes life easier, as sending the notification itself
>may fail.
>
>Example use:
>$ devlink region new netdevsim/netdevsim1/dummy
>netdevsim/netdevsim1/dummy: snapshot 1
>
>$ id=$(devlink -j region new netdevsim/netdevsim1/dummy | \
>       jq '.[][][][]')
>$ devlink region dump netdevsim/netdevsim1/dummy snapshot $id
>[...]
>$ devlink region del netdevsim/netdevsim1/dummy snapshot $id
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
>Jiri, this is what I had in mind of snapshots and the same
>thing will come back for slice allocation.

Okay. Could you please send the userspace patch too in order to see the
full picture?


>
> net/core/devlink.c                            | 84 ++++++++++++++++---
> .../drivers/net/netdevsim/devlink.sh          | 13 +++
> 2 files changed, 84 insertions(+), 13 deletions(-)
>
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 1ec2e9fd8898..dad5d07dd4f8 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -4065,10 +4065,65 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
> 	return 0;
> }
> 
>+static int
>+devlink_nl_alloc_snapshot_id(struct devlink *devlink, struct genl_info *info,
>+			     struct devlink_region *region, u32 *snapshot_id)
>+{
>+	struct sk_buff *msg;
>+	void *hdr;
>+	int err;
>+
>+	err = __devlink_region_snapshot_id_get(devlink, snapshot_id);
>+	if (err) {
>+		NL_SET_ERR_MSG_MOD(info->extack,

No need to wrap here.


>+				   "Failed to allocate a new snapshot id");
>+		return err;
>+	}
>+
>+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>+	if (!msg) {
>+		err = -ENOMEM;
>+		goto err_msg_alloc;
>+	}
>+
>+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
>+			  &devlink_nl_family, 0, DEVLINK_CMD_REGION_NEW);
>+	if (!hdr) {
>+		err = -EMSGSIZE;
>+		goto err_put_failure;
>+	}
>+	err = devlink_nl_put_handle(msg, devlink);
>+	if (err)
>+		goto err_attr_failure;
>+	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME, region->ops->name);
>+	if (err)
>+		goto err_attr_failure;
>+	err = nla_put_u32(msg, DEVLINK_ATTR_REGION_SNAPSHOT_ID, *snapshot_id);
>+	if (err)
>+		goto err_attr_failure;
>+	genlmsg_end(msg, hdr);
>+
>+	err = genlmsg_reply(msg, info);
>+	if (err)
>+		goto err_reply;
>+
>+	return 0;
>+
>+err_attr_failure:
>+	genlmsg_cancel(msg, hdr);
>+err_put_failure:
>+	nlmsg_free(msg);
>+err_msg_alloc:
>+err_reply:
>+	__devlink_snapshot_id_decrement(devlink, *snapshot_id);
>+	return err;
>+}
>+
> static int
> devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
> {
> 	struct devlink *devlink = info->user_ptr[0];
>+	struct nlattr *snapshot_id_attr;
> 	struct devlink_region *region;
> 	const char *region_name;
> 	u32 snapshot_id;
>@@ -4080,11 +4135,6 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
> 		return -EINVAL;
> 	}
> 
>-	if (!info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>-		NL_SET_ERR_MSG_MOD(info->extack, "No snapshot id provided");
>-		return -EINVAL;
>-	}
>-
> 	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
> 	region = devlink_region_get_by_name(devlink, region_name);
> 	if (!region) {
>@@ -4102,16 +4152,24 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
> 		return -ENOSPC;
> 	}
> 
>-	snapshot_id = nla_get_u32(info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
>+	snapshot_id_attr = info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID];
>+	if (snapshot_id_attr) {
>+		snapshot_id = nla_get_u32(snapshot_id_attr);
> 
>-	if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
>-		NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot id is already in use");
>-		return -EEXIST;
>-	}
>+		if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
>+			NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot id is already in use");
>+			return -EEXIST;
>+		}
> 
>-	err = __devlink_snapshot_id_insert(devlink, snapshot_id);
>-	if (err)
>-		return err;
>+		err = __devlink_snapshot_id_insert(devlink, snapshot_id);
>+		if (err)
>+			return err;
>+	} else {
>+		err = devlink_nl_alloc_snapshot_id(devlink, info,
>+						   region, &snapshot_id);
>+		if (err)
>+			return err;
>+	}
> 
> 	err = region->ops->snapshot(devlink, info->extack, &data);

How the output is going to looks like it this or any of the follow-up
calls in this function are going to fail?

I guess it is going to be handled gracefully in the userspace app,
right?



> 	if (err)
>diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>index 9f9741444549..ad539eccddcb 100755
>--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>@@ -151,6 +151,19 @@ regions_test()
> 
> 	check_region_snapshot_count dummy post-second-delete 2
> 
>+	sid=$(devlink -j region new $DL_HANDLE/dummy | jq '.[][][][]')
>+	check_err $? "Failed to create a new snapshot with id allocated by the kernel"
>+
>+	check_region_snapshot_count dummy post-first-request 3
>+
>+	devlink region dump $DL_HANDLE/dummy snapshot $sid >> /dev/null
>+	check_err $? "Failed to dump a snapshot with id allocated by the kernel"
>+
>+	devlink region del $DL_HANDLE/dummy snapshot $sid
>+	check_err $? "Failed to delete snapshot with id allocated by the kernel"
>+
>+	check_region_snapshot_count dummy post-first-request 2
>+
> 	log_test "regions test"
> }
> 
>-- 
>2.25.4
>
