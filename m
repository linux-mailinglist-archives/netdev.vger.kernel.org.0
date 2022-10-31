Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AC361336C
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiJaKTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiJaKTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:19:30 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C835DEC5
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:19:28 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id k8so15295810wrh.1
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4Ys1YTnKxyqJxK08MPzRR8FGt7x4LFCVO4z8GOGwoqQ=;
        b=oKfYueSBkQJRXWItP5O7WojJ3vtIo+VJmg01i8k0uA34MmdMd47dmOMkj1fKlBXIx4
         6AKiZwf3J1M3q4E1jPIUFefnG0zsQez/2FLDPWXdsgrS4hfCA1R1XN48j+QoS7+Xxf21
         1MZjQvtBBYjUpeQF6IcnSdB7YWLGgcn55rFh5IUYX5giokVYmyRK0lHZNddzlQbOtMBd
         uiexK/8h3jveQiHFtXjMn6IMpQ9Ih7nEyRtK5aNX4Hg+AjJrrB5sWwCHSIpWnsT76Nz1
         VVm/ppWADrzufng3cFEzrI9tDaYKU1tOg0EMx9C28qH82HUy6p+TJCfZxSBi/JQ+cPl5
         oKeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Ys1YTnKxyqJxK08MPzRR8FGt7x4LFCVO4z8GOGwoqQ=;
        b=FVyLuYXCq1P5wHIZL8H0y59U0K+3GI51IVV8I0xLMLNgcepy9ForkaB/gdSSRZpDi5
         0k94BsTKrEr7Wc/k+Q/lvPjemG65cGl9TJumZxn6s0TfPqCbhrTLtyhzmcZ4dndFpzLo
         fA6X2MHR/M6ucm9MtqwBsSGmgO0dNG4kI7iFWnbiQhOtRY/JQwHtyX1Uh8XZxWPuBOf+
         wDsCdsIg6pzbSbvEog0VLTg+3zkIh3pyf4bdZy9TQUV8RZSR2tIMmgTw5zCUXNC/t+5+
         83CL/2xuaNkuQA/XmnCKnnKCZbk+IDt9h1Qf8EfBVy78+iwnJvH+azOCJYtu/0ldzAyU
         Vgqw==
X-Gm-Message-State: ACrzQf3ywd0PalA8F2B1h3gf+vBipeCttVyXmX4tCdG2IhFvyAodmD9q
        42Q0FyP/FLmnrgtCB+dSPpsOTA==
X-Google-Smtp-Source: AMsMyM7u6MbfZss+VHy3fQfiqymPSeE0klN8xs55dHAyMhC+ZrLE7S2PfyD5xmcwRGFZWcgxboOa1g==
X-Received: by 2002:adf:d226:0:b0:235:d9ae:1de9 with SMTP id k6-20020adfd226000000b00235d9ae1de9mr7708550wrh.599.1667211566584;
        Mon, 31 Oct 2022 03:19:26 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h17-20020adfe991000000b0023657e1b980sm6606941wrm.53.2022.10.31.03.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 03:19:25 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:19:25 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v8 3/9] devlink: Enable creation of the
 devlink-rate nodes from the driver
Message-ID: <Y1+hLUPkXn3YWIlA@nanopsycho>
References: <20221028105143.3517280-1-michal.wilczynski@intel.com>
 <20221028105143.3517280-4-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028105143.3517280-4-michal.wilczynski@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 28, 2022 at 12:51:37PM CEST, michal.wilczynski@intel.com wrote:
>Intel 100G card internal firmware hierarchy for Hierarchicial QoS is very
>rigid and can't be easily removed. This requires an ability to export
>default hierarchy to allow user to modify it. Currently the driver is
>only able to create the 'leaf' nodes, which usually represent the vport.
>This is not enough for HQoS implemented in Intel hardware.
>
>Introduce new function devl_rate_node_create() that allows for creation
>of the devlink-rate nodes from the driver.
>
>Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
>---
> include/net/devlink.h |  4 ++++
> net/core/devlink.c    | 49 +++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 53 insertions(+)
>
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 929cb72ef412..9d0a424712fd 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -98,6 +98,8 @@ struct devlink_port_attrs {
> 	};
> };
> 
>+#define DEVLINK_RATE_NAME_MAX_LEN 30
>+
> struct devlink_rate {
> 	struct list_head list;
> 	enum devlink_rate_type type;
>@@ -1601,6 +1603,8 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
> 				   u32 controller, u16 pf, u32 sf,
> 				   bool external);
> int devl_rate_leaf_create(struct devlink_port *port, void *priv);
>+int devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
>+			  char *parent_name);
> void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
> void devl_rate_nodes_destroy(struct devlink *devlink);
> void devlink_port_linecard_set(struct devlink_port *devlink_port,
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index b97c077cf66e..08f1bbd54c43 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -10270,6 +10270,55 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
> }
> EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
> 
>+/**
>+ * devl_rate_node_create - create devlink rate node
>+ * @devlink: devlink instance
>+ * @priv: driver private data
>+ * @node_name: name of the resulting node
>+ * @parent_name: name of the parent node
>+ *
>+ * Create devlink rate object of type node
>+ */
>+int devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name, char *parent_name)

Nope, this is certainly incorrect. Do not refer to kernel object by
string. You also don't have internal kernel api based on ifname to refer
to struct net_device instance.

Please have "struct devlink_rate *parent" to refer to parent node and
make this function return "struct devlink_rate *".


>+{
>+	struct devlink_rate *rate_node;
>+	struct devlink_rate *parent;
>+
>+	rate_node = devlink_rate_node_get_by_name(devlink, node_name);
>+	if (!IS_ERR(rate_node))
>+		return -EEXIST;
>+
>+	rate_node = kzalloc(sizeof(*rate_node), GFP_KERNEL);
>+	if (!rate_node)
>+		return -ENOMEM;
>+
>+	if (parent_name) {
>+		parent = devlink_rate_node_get_by_name(devlink, parent_name);
>+		if (IS_ERR(parent)) {
>+			kfree(rate_node);
>+			return -ENODEV;
>+		}
>+		rate_node->parent = parent;
>+		refcount_inc(&rate_node->parent->refcnt);
>+	}
>+
>+	rate_node->type = DEVLINK_RATE_TYPE_NODE;
>+	rate_node->devlink = devlink;
>+	rate_node->priv = priv;
>+
>+	rate_node->name = kstrndup(node_name, DEVLINK_RATE_NAME_MAX_LEN, GFP_KERNEL);

Why do you limit the name length? We don't limit the length passed from
user, I see no reason to do it for driver.


>+	if (!rate_node->name) {
>+		kfree(rate_node);
>+		return -ENOMEM;
>+	}
>+
>+	refcount_set(&rate_node->refcnt, 1);
>+	list_add(&rate_node->list, &devlink->rate_list);
>+	devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_NEW);
>+	return 0;
>+}
>+EXPORT_SYMBOL_GPL(devl_rate_node_create);
>+
> /**
>  * devl_rate_leaf_create - create devlink rate leaf
>  * @devlink_port: devlink port object to create rate object on
>-- 
>2.37.2
>
