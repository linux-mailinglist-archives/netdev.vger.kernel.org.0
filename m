Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6116374C1
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiKXJF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiKXJFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:05:45 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA697114BB2
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:05:42 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id kt23so2705312ejc.7
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j+WIrFpfQ785pwXJN//3IACiCkMs9PBbhvmAMv/obiE=;
        b=YZ18LPFS0FHtB3eZNs/XdMA5vj7SrWAPoilZB23LCchPGS1wFUmS3cCmyT7r6yPH7T
         ubyUQ2RgVqeYLe2Hi3jnqrI0dsQ1xmYR+wOFFa5cCfO6S8MAwDSagzY/39J59juIFbDC
         paiM9X17qG0o+2oCzVkE89GmKbGJU0QH8771xMqcbD0YCYjdYcNBJlWp+N9OyA3HWkQg
         HqPezgVTKm0xIzoJc3imctODMmxrNb/Mkx+jASXKLv+cZnyBv2nPrbvnUYU02Jktm07E
         ZBkZH69HgrrAPyf5S+TezfNl9U+2xEDYQYxRRQvJsrtp+5SGkkdCWmDTqWpYM7pLdRqn
         J2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j+WIrFpfQ785pwXJN//3IACiCkMs9PBbhvmAMv/obiE=;
        b=LlV5cVpAwnh0/pXqCeAzj1VMZEyrTKNNNxK/gELiN2YydviPnWSzh24gfo3HQJNyz5
         eZTCJG/DPTxuCf9wst3Uu2gFOi+nptqiK8ccW6H4KEPDnH9HyyRZK/uL1aTdURHyF8zg
         iFCyhliWx2e576OxCTVmjL8qNdZw/+47XKL+YSOQg1fzwXnvQxs+IhWyXnsWJtEKW+ZS
         QHg15kDPldR4eJ3v5VYLWEBH9mp1GSuLBbvmS2gLeufjojwrW1Ac23/hAr/X0nt5qmk5
         axhDSbp4jJi2cW+hC55myBh2NqctOZmgFn3TUCVQ6XNgUsdQ+TUCC90oQoSdSEY6oh5X
         53LQ==
X-Gm-Message-State: ANoB5pn0Jf+aTk8PnQwqkfbry0/U2X8c9rH0Y6MQRyqUiRdTdL5Ff+9T
        NbIIyoav/WVB5VToEefIvh3L3q6VdBjfN7qn
X-Google-Smtp-Source: AA0mqf4X28XdASgoLnxYcxlDXMq4klDUE2zKF5sN20ANUeFF44K5a/0TGwwGvTKp+1B0DHKcsUZnvg==
X-Received: by 2002:a17:906:2342:b0:78d:9e77:1f8c with SMTP id m2-20020a170906234200b0078d9e771f8cmr18552690eja.236.1669280741419;
        Thu, 24 Nov 2022 01:05:41 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 24-20020a508e18000000b00461bacee867sm282940edw.25.2022.11.24.01.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 01:05:40 -0800 (PST)
Date:   Thu, 24 Nov 2022 10:05:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 6/9] devlink: support directly reading from
 region memory
Message-ID: <Y38z418/Uv8ExF1V@nanopsycho>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
 <20221123203834.738606-7-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123203834.738606-7-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 23, 2022 at 09:38:31PM CET, jacob.e.keller@intel.com wrote:
>To read from a region, user space must currently request a new snapshot of
>the region and then read from that snapshot. This can sometimes be overkill
>if user space only reads a tiny portion. They first create the snapshot,
>then request a read, then destroy the snapshot.
>
>For regions which have a single underlying "contents", it makes sense to
>allow supporting direct reading of the region data.
>
>Extend the DEVLINK_CMD_REGION_READ to allow direct reading from a region if
>supported. Instead of reporting a missing snapshot id as invalid, check if
>the region supports direct read and if so switch to the direct access
>method for reading the region data.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
>Changes since v1:
>* Update documentation to explain that direct reads are not atomic
>
> .../networking/devlink/devlink-region.rst     | 11 ++++
> include/net/devlink.h                         | 16 +++++
> net/core/devlink.c                            | 66 ++++++++++++++-----
> 3 files changed, 76 insertions(+), 17 deletions(-)
>
>diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
>index f06dca9a1eb6..6525a9120a4e 100644
>--- a/Documentation/networking/devlink/devlink-region.rst
>+++ b/Documentation/networking/devlink/devlink-region.rst
>@@ -31,6 +31,13 @@ in its ``devlink_region_ops`` structure. If snapshot id is not set in
> the ``DEVLINK_CMD_REGION_NEW`` request kernel will allocate one and send
> the snapshot information to user space.
> 
>+Regions may optionally allow directly reading from their contents without a
>+snapshot. Direct read requests are not atomic. In particular a read request
>+of size 256 bytes or larger will be split into multiple chunks. If atomic
>+access is required, use a snapshot. A driver wishing to enable this for a
>+region should implement the ``.read`` callback in the ``devlink_region_ops``
>+structure.
>+
> example usage
> -------------
> 
>@@ -65,6 +72,10 @@ example usage
>     $ devlink region read pci/0000:00:05.0/fw-health snapshot 1 address 0 length 16
>     0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
> 
>+    # Read from the region without a snapshot
>+    $ devlink region read pci/0000:00:05.0/fw-health address 16 length 16
>+    0000000000000010 0000 0000 ffff ff04 0029 8c00 0028 8cc8
>+
> As regions are likely very device or driver specific, no generic regions are
> defined. See the driver-specific documentation files for information on the
> specific regions a driver supports.
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 074a79b8933f..02528f736f65 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -650,6 +650,10 @@ struct devlink_info_req;
>  *            the data variable must be updated to point to the snapshot data.
>  *            The function will be called while the devlink instance lock is
>  *            held.
>+ * @read: callback to directly read a portion of the region. On success,
>+ *        the data pointer will be updated with the contents of the
>+ *        requested portion of the region. The function will be called
>+ *        while the devlink instance lock is held.
>  * @priv: Pointer to driver private data for the region operation
>  */
> struct devlink_region_ops {
>@@ -659,6 +663,10 @@ struct devlink_region_ops {
> 			const struct devlink_region_ops *ops,
> 			struct netlink_ext_ack *extack,
> 			u8 **data);
>+	int (*read)(struct devlink *devlink,
>+		    const struct devlink_region_ops *ops,
>+		    struct netlink_ext_ack *extack,
>+		    u64 offset, u32 size, u8 *data);
> 	void *priv;
> };
> 
>@@ -670,6 +678,10 @@ struct devlink_region_ops {
>  *            the data variable must be updated to point to the snapshot data.
>  *            The function will be called while the devlink instance lock is
>  *            held.
>+ * @read: callback to directly read a portion of the region. On success,
>+ *        the data pointer will be updated with the contents of the
>+ *        requested portion of the region. The function will be called
>+ *        while the devlink instance lock is held.
>  * @priv: Pointer to driver private data for the region operation
>  */
> struct devlink_port_region_ops {
>@@ -679,6 +691,10 @@ struct devlink_port_region_ops {
> 			const struct devlink_port_region_ops *ops,
> 			struct netlink_ext_ack *extack,
> 			u8 **data);
>+	int (*read)(struct devlink_port *port,
>+		    const struct devlink_port_region_ops *ops,
>+		    struct netlink_ext_ack *extack,
>+		    u64 offset, u32 size, u8 *data);
> 	void *priv;
> };
> 
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 729e2162a4db..f249b5b57677 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -6515,6 +6515,26 @@ devlink_region_snapshot_fill(void *cb_priv, u8 *chunk, u32 chunk_size,
> 	return 0;
> }
> 
>+static int
>+devlink_region_port_direct_fill(void *cb_priv, u8 *chunk, u32 chunk_size,
>+				u64 curr_offset, struct netlink_ext_ack *extack)
>+{
>+	struct devlink_region *region = cb_priv;
>+
>+	return region->port_ops->read(region->port, region->port_ops, extack,
>+				      curr_offset, chunk_size, chunk);
>+}
>+
>+static int
>+devlink_region_direct_fill(void *cb_priv, u8 *chunk, u32 chunk_size,
>+			   u64 curr_offset, struct netlink_ext_ack *extack)
>+{
>+	struct devlink_region *region = cb_priv;
>+
>+	return region->ops->read(region->devlink, region->ops, extack,
>+				 curr_offset, chunk_size, chunk);
>+}
>+
> static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 					     struct netlink_callback *cb)
> {
>@@ -6523,12 +6543,12 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 	u64 ret_offset, start_offset, end_offset = U64_MAX;
> 	struct nlattr **attrs = info->attrs;
> 	struct devlink_port *port = NULL;
>-	struct devlink_snapshot *snapshot;
>+	devlink_chunk_fill_t *region_cb;
> 	struct devlink_region *region;
> 	const char *region_name;
> 	struct devlink *devlink;
> 	unsigned int index;
>-	u32 snapshot_id;
>+	void *region_cb_priv;
> 	void *hdr;
> 	int err;
> 
>@@ -6546,12 +6566,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 		goto out_unlock;
> 	}
> 
>-	if (!attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>-		NL_SET_ERR_MSG(cb->extack, "No snapshot id provided");
>-		err = -EINVAL;
>-		goto out_unlock;
>-	}
>-
> 	if (info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
> 		index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
> 
>@@ -6577,12 +6591,30 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 	}
> 
> 	snapshot_attr = attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID];
>-	snapshot_id = nla_get_u32(snapshot_attr);
>-	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
>-	if (!snapshot) {
>-		NL_SET_ERR_MSG_ATTR(cb->extack, snapshot_attr, "requested snapshot does not exist");
>-		err = -EINVAL;
>-		goto out_unlock;
>+	if (!snapshot_attr) {

Hmm. Being pedantic here, it changes userspace expectations:
current - message without snapshotid is errored out
new - message without snapshotid is happily processed

I can imagine some obscure userspace app depending on this behaviour,
in theory.

Safe would be to add new NLA_FLAG attr DEVLINK_ATTR_REGION_DIRECT or
something that would indicate userspace is interested in direct read.
Also, the userspace would know right away it this new functionality
is supported or not by the kernel.



>+		if (!region->ops->read) {
>+			NL_SET_ERR_MSG(cb->extack, "requested region does not support direct read");
>+			err = -EOPNOTSUPP;
>+			goto out_unlock;
>+		}
>+		if (port)
>+			region_cb = &devlink_region_port_direct_fill;
>+		else
>+			region_cb = &devlink_region_direct_fill;
>+		region_cb_priv = region;
>+	} else {
>+		struct devlink_snapshot *snapshot;
>+		u32 snapshot_id;
>+
>+		snapshot_id = nla_get_u32(snapshot_attr);
>+		snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
>+		if (!snapshot) {
>+			NL_SET_ERR_MSG_ATTR(cb->extack, snapshot_attr, "requested snapshot does not exist");
>+			err = -EINVAL;
>+			goto out_unlock;
>+		}
>+		region_cb = &devlink_region_snapshot_fill;
>+		region_cb_priv = snapshot;
> 	}
> 
> 	if (attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR] &&
>@@ -6633,9 +6665,9 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 		goto nla_put_failure;
> 	}
> 
>-	err = devlink_nl_region_read_fill(skb, &devlink_region_snapshot_fill,
>-					  snapshot, start_offset, end_offset,
>-					  &ret_offset, cb->extack);
>+	err = devlink_nl_region_read_fill(skb, region_cb, region_cb_priv,
>+					  start_offset, end_offset, &ret_offset,
>+					  cb->extack);
> 
> 	if (err && err != -EMSGSIZE)
> 		goto nla_put_failure;
>-- 
>2.38.1.420.g319605f8f00e
>
