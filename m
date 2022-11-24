Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F12D63745F
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiKXIrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiKXIrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:47:45 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136111742E
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:47:42 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id b12so1450382wrn.2
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AYphvriqzGDAQRkoPX932CbC48mcff0Ad7eriwVH0f0=;
        b=rt3ZRuHF7B7wwdB+G7YNR3MvyKIE9r0jIzB95JdC1jCd8W5p9xgiumL+Nkk8quo0aH
         Z9s62wwF8HgMdA9K+o+uqfgh8bhWpuOpRe8aetA4mEZ1402GESinXMhBkYBqkBJSV36D
         N3B20pLI6jA0d0miTSPogOKNcJlUlVInKqR2VFuYrpJ1gi7/l+At+N40Aq906+zQapm4
         ER+jNCQSrVz0vaxmlufhIXlzgjFkR8WFji5c39pL+hmcpESdM1tuBiZydUN5+Ya6JkoW
         zZNGBtaXeWIuz9PE1jZJbowPK4H+NBIUB68AYtHGAJuU/pBWLIG0TEVz1fRAje4quThT
         KsDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AYphvriqzGDAQRkoPX932CbC48mcff0Ad7eriwVH0f0=;
        b=OsHMG03u+VEZ33jKjSkpDcNDBYs5VA70/kv/pI+Mn9vhhJVKBOaQS6JvdE/KibqIjf
         27GaBmHBrATvvNYW239IN8rX8y8MQMvigmNgW1bjJ9/kXegsJpTNZaMb3AjMMvWvAyda
         7SYfQnfG46UwMorlJCaZ6tSJ21LXWnnZbM6oBVxcHHi0U0YI1iaE9QxgFBj5HALuu7nE
         eBs3KZ3p5Fi8qJZp4XFiJlwULC9gH3+qAtO8v0N3Dz4MnOKPzvGs5B0FJsK5/7uzamgw
         Ws4HIZVX3GMr5DkhMGbT86Bwn335ZYjp7hkYFAGHK0ErM8beaSPg7Bt25C1BjAU87ORu
         XOhg==
X-Gm-Message-State: ANoB5pkLXoCrOx1k2Keqst8hM/2JjpBQronorIf8Gd2oaNhVDzIUQoNl
        s/6MRLQtDMvY4M2w9feI0BNx2xOiL+twEVis
X-Google-Smtp-Source: AA0mqf5hs95ANsQI9EunetYxxczbOfbG6lQEkmiGWFyHF7FkadyOzBVoBLhy2IeIy4hnNCii7PUDlA==
X-Received: by 2002:a5d:6886:0:b0:238:8896:7876 with SMTP id h6-20020a5d6886000000b0023888967876mr12313008wru.645.1669279660917;
        Thu, 24 Nov 2022 00:47:40 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w13-20020adfec4d000000b00241dd5de644sm697419wrn.97.2022.11.24.00.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 00:47:40 -0800 (PST)
Date:   Thu, 24 Nov 2022 09:47:37 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 3/9] devlink: find snapshot in
 devlink_nl_cmd_region_read_dumpit
Message-ID: <Y38vqeX/3WRj7SxJ@nanopsycho>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
 <20221123203834.738606-4-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123203834.738606-4-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 23, 2022 at 09:38:28PM CET, jacob.e.keller@intel.com wrote:
>The snapshot pointer is obtained inside of the function
>devlink_nl_region_read_snapshot_fill. Simplify this function by locating
>the snapshot upfront in devlink_nl_cmd_region_read_dumpit instead. This
>aligns with how other netlink attributes are handled, and allows us to
>exit slightly earlier if an invalid snapshot ID is provided.
>
>It also allows us to pass the snapshot pointer directly to the
>devlink_nl_region_read_snapshot_fill, and remove the now unused attrs
>parameter.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

With the msg uppercase start nit below.
Reviewed-by: Jiri Pirko <jiri@nvidia.com>



>---
>Changes since v1
>* Moved to 3/9 of series
>* Use snapshot_attr and NL_SET_ERR_MSG_ATTR to report extended error
>
> net/core/devlink.c | 25 ++++++++++++++-----------
> 1 file changed, 14 insertions(+), 11 deletions(-)
>
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index b5b317661f9a..825c52a71df1 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -6463,24 +6463,16 @@ static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
> 
> static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
> 						struct devlink *devlink,
>-						struct devlink_region *region,
>-						struct nlattr **attrs,
>+						struct devlink_snapshot *snapshot,
> 						u64 start_offset,
> 						u64 end_offset,
> 						u64 *new_offset)
> {
>-	struct devlink_snapshot *snapshot;
> 	u64 curr_offset = start_offset;
>-	u32 snapshot_id;
> 	int err = 0;
> 
> 	*new_offset = start_offset;
> 
>-	snapshot_id = nla_get_u32(attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
>-	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
>-	if (!snapshot)
>-		return -EINVAL;
>-
> 	while (curr_offset < end_offset) {
> 		u32 data_size;
> 		u8 *data;
>@@ -6506,14 +6498,16 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 					     struct netlink_callback *cb)
> {
> 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
>+	struct nlattr *chunks_attr, *region_attr, *snapshot_attr;
> 	u64 ret_offset, start_offset, end_offset = U64_MAX;
>-	struct nlattr *chunks_attr, *region_attr;
> 	struct nlattr **attrs = info->attrs;
> 	struct devlink_port *port = NULL;
>+	struct devlink_snapshot *snapshot;
> 	struct devlink_region *region;
> 	const char *region_name;
> 	struct devlink *devlink;
> 	unsigned int index;
>+	u32 snapshot_id;
> 	void *hdr;
> 	int err;
> 
>@@ -6561,6 +6555,15 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 		goto out_unlock;
> 	}
> 
>+	snapshot_attr = attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID];
>+	snapshot_id = nla_get_u32(snapshot_attr);
>+	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
>+	if (!snapshot) {
>+		NL_SET_ERR_MSG_ATTR(cb->extack, snapshot_attr, "requested snapshot does not exist");

Why not to start with "R"?


>+		err = -EINVAL;
>+		goto out_unlock;
>+	}
>+
> 	if (attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR] &&
> 	    attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]) {
> 		if (!start_offset)
>@@ -6610,7 +6613,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 	}
> 
> 	err = devlink_nl_region_read_snapshot_fill(skb, devlink,
>-						   region, attrs,
>+						   snapshot,
> 						   start_offset,
> 						   end_offset, &ret_offset);
> 
>-- 
>2.38.1.420.g319605f8f00e
>
