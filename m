Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C459613390
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiJaK1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiJaK1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:27:00 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D67DF83
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:26:59 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id y16so15257749wrt.12
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/eby2TPvHgfwvv5gnn4zzGtt7mcZ82zHCRqNJqgRr7s=;
        b=OvaZTHYleFDo5wx/ql2CiOCFSNm5uRoV8tOxfedgU4unbhF9G7AeOAEWR0wXhQy/cD
         BEgK69v4BQtXqV3RSolo3PNTNVpjS7gC8Qer1/G9yRQMCh6XgWm6K1sAu/FXWDkZgYdM
         G6b/p7kQ6ogmjwFsmV3ZzweuVXqKPm7lrIHT85KpKr8afXUB6zY/CvwmGIuztq7B5/jS
         hFDZ9kANzZt++fpss9eXCBH3m0/4wI+fgVWOH+W+SO3/6rvMPjc3CFuzN05dQRsh6p4U
         68LgQU7+yLe2SyVz8Y+FVZpl/eYGy52tItTE1sR1mS1hW4hWnxHPjs+3NGDADNwu7LYA
         zp2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/eby2TPvHgfwvv5gnn4zzGtt7mcZ82zHCRqNJqgRr7s=;
        b=Nc4OInRI5GdM3no4JUr+camrAahYtQR2D7OIW9O7UGQ+ryQj6GufMs2ECOPojixUIq
         WdRhgAxt0UdGvxFaA8zjJaUj0muzV2rcqz4ClyZkEk2kfh3w9PbVYIBY8UtXds3p/aHH
         ka/UqKyUavhmxpq64y2F92OYto7AW6FIqPcHsmNbOurrM6MREt9R5yZvPsr99wS+cohK
         hOSB4EWOZiB1OLsrp9SphrpQYPE5ZTqsQLTymTO33t3/YlVQOD5aw/8jWzjiUTaKuh9t
         i22y0cegULW0gwHMs/+NpZQ3Lp86Pana8w4FJtzBg7EeCTpksc8rTkxPv2bPB9kbEv6+
         r1Zg==
X-Gm-Message-State: ACrzQf3Kyifk8Nx7x5lHsj+S/LE57Jc1iyMd48kaQyQ/PPVgQlEemLu+
        BwLpbGDmlyfPIZ1Hxb4T7csByA==
X-Google-Smtp-Source: AMsMyM7HuZ2iKCIyy0m3tZGvO4R1Iuxy/U7lHWnxodHHtJVRtdUv7gBErkhgVGN8E713LQiRd91SJw==
X-Received: by 2002:adf:e804:0:b0:236:657e:756e with SMTP id o4-20020adfe804000000b00236657e756emr7625592wrm.452.1667212017719;
        Mon, 31 Oct 2022 03:26:57 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id j6-20020a05600c42c600b003c6deb5c1edsm7322689wme.45.2022.10.31.03.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 03:26:57 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:26:56 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v8 5/9] devlink: Allow to set up parent in
 devl_rate_leaf_create()
Message-ID: <Y1+i8LjMJuIsAhqH@nanopsycho>
References: <20221028105143.3517280-1-michal.wilczynski@intel.com>
 <20221028105143.3517280-6-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028105143.3517280-6-michal.wilczynski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 28, 2022 at 12:51:39PM CEST, michal.wilczynski@intel.com wrote:
>Currently the driver is able to create leaf nodes for the devlink-rate,
>but is unable to set parent for them. This wasn't as issue, before the
>possibility to export hierarchy from the driver. After adding the export
>feature, in order for the driver to supply correct hierarchy, it's
>necessary for it to be able to supply a parent name to
>devl_rate_leaf_create().
>
>Introduce a new parameter 'parent_name' in devl_rate_leaf_create().
>
>Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
>---
> .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |  4 ++--
> drivers/net/netdevsim/dev.c                        |  2 +-
> include/net/devlink.h                              |  2 +-
> net/core/devlink.c                                 | 14 +++++++++++++-
> 4 files changed, 17 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
>index 9bc7be95db54..084a910bb4e7 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
>@@ -91,7 +91,7 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_
> 	if (err)
> 		goto reg_err;
> 
>-	err = devl_rate_leaf_create(dl_port, vport);
>+	err = devl_rate_leaf_create(dl_port, vport, NULL);
> 	if (err)
> 		goto rate_err;
> 
>@@ -160,7 +160,7 @@ int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_p
> 	if (err)
> 		return err;
> 
>-	err = devl_rate_leaf_create(dl_port, vport);
>+	err = devl_rate_leaf_create(dl_port, vport, NULL);
> 	if (err)
> 		goto rate_err;
> 
>diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>index 794fc0cc73b8..10e5c4de6b02 100644
>--- a/drivers/net/netdevsim/dev.c
>+++ b/drivers/net/netdevsim/dev.c
>@@ -1392,7 +1392,7 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
> 
> 	if (nsim_dev_port_is_vf(nsim_dev_port)) {
> 		err = devl_rate_leaf_create(&nsim_dev_port->devlink_port,
>-					    nsim_dev_port);
>+					    nsim_dev_port, NULL);
> 		if (err)
> 			goto err_nsim_destroy;
> 	}
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 9d0a424712fd..2ccb69606d23 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -1602,7 +1602,7 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
> void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
> 				   u32 controller, u16 pf, u32 sf,
> 				   bool external);
>-int devl_rate_leaf_create(struct devlink_port *port, void *priv);
>+int devl_rate_leaf_create(struct devlink_port *port, void *priv, char *parent_name);
> int devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
> 			  char *parent_name);
> void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 9bdbc158c36a..140336c09bd5 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -10325,13 +10325,15 @@ EXPORT_SYMBOL_GPL(devl_rate_node_create);
>  * devl_rate_leaf_create - create devlink rate leaf
>  * @devlink_port: devlink port object to create rate object on
>  * @priv: driver private data
>+ * @parent_name: name of the parent node
>  *
>  * Create devlink rate object of type leaf on provided @devlink_port.
>  */
>-int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
>+int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv, char *parent_name)

Again, don't refer to parent object by string, but rather pointer to the
struct.


> {
> 	struct devlink *devlink = devlink_port->devlink;
> 	struct devlink_rate *devlink_rate;
>+	struct devlink_rate *parent;
> 
> 	devl_assert_locked(devlink_port->devlink);
> 
>@@ -10342,6 +10344,16 @@ int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
> 	if (!devlink_rate)
> 		return -ENOMEM;
> 
>+	if (parent_name) {
>+		parent = devlink_rate_node_get_by_name(devlink, parent_name);
>+		if (IS_ERR(parent)) {
>+			kfree(devlink_rate);
>+			return -ENODEV;
>+		}
>+		devlink_rate->parent = parent;
>+		refcount_inc(&devlink_rate->parent->refcnt);
>+	}
>+
> 	devlink_rate->type = DEVLINK_RATE_TYPE_LEAF;
> 	devlink_rate->devlink = devlink;
> 	devlink_rate->devlink_port = devlink_port;
>-- 
>2.37.2
>
