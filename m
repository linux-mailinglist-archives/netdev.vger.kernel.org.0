Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807533A8E0F
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 03:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhFPBJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 21:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhFPBJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 21:09:57 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5E2C061574;
        Tue, 15 Jun 2021 18:07:51 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id he7so758866ejc.13;
        Tue, 15 Jun 2021 18:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1HOlYl/nj88waekt+TS6sQd7F9SdoKlp9Z+5Xd8jLGk=;
        b=vhFtnnxfMBiq8+kSX5/rbbik6cwNdPeWq1scYDU18TsZMx3m1cD6Sx8Ohu57p6MEB0
         EgQlulLwjWHx8/DADd6mARvKifmTPxt2YCKbDkmT9FQjnpbqasiqkrIoi2FcwSuX5Zn5
         lOouX+i5+8jMwenaVCNJm6AY7NJ9CPICYBNrgn2KBKufvlHP0vEvPKYdqJVK6yiwd2cM
         J9P4nzpUhheu7CzRkYQ4rHXliBAASD8B7rw85O1KYHlNVuqYYw0Ru+f8S6r1/d6OCNY2
         /CeLmmdstoVB+ETOykOxIxR9p8YpyQPbptYy++7lDfZsiQV2McJ/jWkm47cMy3+64Y9R
         344w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1HOlYl/nj88waekt+TS6sQd7F9SdoKlp9Z+5Xd8jLGk=;
        b=Q1ziY378AcLVFN9VQtzIYireO9UMZPk/w3KxyCDzDr7WHiFoc5MIi70ThLdPRYkQdo
         SqTlCrPT7Ps8pE4F7YLrFu8udysIRs52tU7ZPf7ExRXz1CqDNWzt+FxFTHjM2ei3Qadz
         ZJr8lLlij/AnYe5pUhhQNh1hDYKLmiMDHpBJSVS+2V0RGckmhk9VfALqSqZ/EiLqKR/y
         B195+B42+5PFzd6rSDGHHTvB6kYH9KW7xpmHsFPGdJPEg3teEUpg565L5m8lJbUqNSK4
         vHFr9vJKnaf3162bR/fIq90YqaAUVrW5S0/DLedtdSENpoOeagTSvoP//acbbgl1Cp9X
         Bzrw==
X-Gm-Message-State: AOAM5318v1trHak9V4UDOwv4VXpar8pAD/jldMDHb1sJv9e3jDgHpFYw
        5esWxZP1yDLPRuAA4U/5S9Y=
X-Google-Smtp-Source: ABdhPJzInp7a55NqvAmalYWLcUouw+w+CE7kuJXloNdWpUFKH3kAa+YGYL5t2n0KkW5MFMXWkWUhPA==
X-Received: by 2002:a17:906:dc43:: with SMTP id yz3mr2404412ejb.323.1623805669792;
        Tue, 15 Jun 2021 18:07:49 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id z3sm461569edb.58.2021.06.15.18.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 18:07:49 -0700 (PDT)
Date:   Wed, 16 Jun 2021 04:07:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH net-next 2/2] net: marvell: prestera: Add matchall support
Message-ID: <20210616010748.ya44v3ns4zzpazwa@skbuf>
References: <20210615125444.31538-1-vadym.kochan@plvision.eu>
 <20210615125444.31538-3-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615125444.31538-3-vadym.kochan@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 03:54:44PM +0300, Vadym Kochan wrote:
> From: Serhiy Boiko <serhiy.boiko@plvision.eu>
> 
> - Introduce matchall filter support
> - Add SPAN API to configure port mirroring.
> - Add tc mirror action.
> 
> At this moment, only mirror (egress) action is supported.
> 
> Example:
>     tc filter ... action mirred egress mirror dev DEV
> 
> Co-developed-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
> Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
> Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> Signed-off-by: Vadym Kochan <vkochan@marvell.com>
> ---
>  .../net/ethernet/marvell/prestera/Makefile    |   2 +-
>  .../net/ethernet/marvell/prestera/prestera.h  |   2 +
>  .../ethernet/marvell/prestera/prestera_acl.c  |   2 +
>  .../ethernet/marvell/prestera/prestera_acl.h  |   3 +-
>  .../ethernet/marvell/prestera/prestera_flow.c |  19 ++
>  .../ethernet/marvell/prestera/prestera_hw.c   |  69 +++++
>  .../ethernet/marvell/prestera/prestera_hw.h   |   6 +
>  .../ethernet/marvell/prestera/prestera_main.c |   8 +
>  .../ethernet/marvell/prestera/prestera_span.c | 245 ++++++++++++++++++
>  .../ethernet/marvell/prestera/prestera_span.h |  20 ++
>  10 files changed, 374 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_span.c
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_span.h
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
> index 42327c4afdbf..0609df8b913d 100644
> --- a/drivers/net/ethernet/marvell/prestera/Makefile
> +++ b/drivers/net/ethernet/marvell/prestera/Makefile
> @@ -3,6 +3,6 @@ obj-$(CONFIG_PRESTERA)	+= prestera.o
>  prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
>  			   prestera_rxtx.o prestera_devlink.o prestera_ethtool.o \
>  			   prestera_switchdev.o prestera_acl.o prestera_flow.o \
> -			   prestera_flower.o
> +			   prestera_flower.o prestera_span.o
>  
>  obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
> index bbbe780d0886..f18fe664b373 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera.h
> +++ b/drivers/net/ethernet/marvell/prestera/prestera.h
> @@ -172,6 +172,7 @@ struct prestera_event {
>  };
>  
>  struct prestera_switchdev;
> +struct prestera_span;
>  struct prestera_rxtx;
>  struct prestera_trap_data;
>  struct prestera_acl;
> @@ -181,6 +182,7 @@ struct prestera_switch {
>  	struct prestera_switchdev *swdev;
>  	struct prestera_rxtx *rxtx;
>  	struct prestera_acl *acl;
> +	struct prestera_span *span;
>  	struct list_head event_handlers;
>  	struct notifier_block netdev_nb;
>  	struct prestera_trap_data *trap_data;
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
> index 817f78b1e90c..5165ac96a70e 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
> @@ -6,6 +6,7 @@
>  #include "prestera.h"
>  #include "prestera_hw.h"
>  #include "prestera_acl.h"
> +#include "prestera_span.h"
>  
>  struct prestera_acl {
>  	struct prestera_switch *sw;
> @@ -149,6 +150,7 @@ int prestera_acl_block_bind(struct prestera_flow_block *block,
>  	binding = kzalloc(sizeof(*binding), GFP_KERNEL);
>  	if (!binding)
>  		return -ENOMEM;
> +	binding->span_id = PRESTERA_SPAN_INVALID_ID;
>  	binding->port = port;
>  
>  	err = prestera_hw_acl_port_bind(port, block->ruleset->id);
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
> index 935c79a26036..2f129eb55547 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
> @@ -28,14 +28,15 @@ enum prestera_acl_rule_action {
>  	PRESTERA_ACL_RULE_ACTION_TRAP
>  };
>  
> -struct prestera_switch;
>  struct prestera_port;
> +struct prestera_switch;

This doesn't appear to be moved for a good reason.

>  struct prestera_acl_rule;
>  struct prestera_acl_ruleset;
>  
>  struct prestera_flow_block_binding {
>  	struct list_head list;
>  	struct prestera_port *port;
> +	int span_id;
>  };
>  
>  struct prestera_flow_block {
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.c b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
> index b818dd871512..b350082a1815 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_flow.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
> @@ -7,10 +7,25 @@
>  #include "prestera.h"
>  #include "prestera_acl.h"
>  #include "prestera_flow.h"
> +#include "prestera_span.h"
>  #include "prestera_flower.h"
>  
>  static LIST_HEAD(prestera_block_cb_list);
>  
> +static int prestera_flow_block_mall_cb(struct prestera_flow_block *block,
> +				       struct tc_cls_matchall_offload *f)
> +{
> +	switch (f->command) {
> +	case TC_CLSMATCHALL_REPLACE:
> +		return prestera_span_replace(block, f);
> +	case TC_CLSMATCHALL_DESTROY:
> +		prestera_span_destroy(block);
> +		return 0;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>  static int prestera_flow_block_flower_cb(struct prestera_flow_block *block,
>  					 struct flow_cls_offload *f)
>  {
> @@ -41,6 +56,8 @@ static int prestera_flow_block_cb(enum tc_setup_type type,
>  	switch (type) {
>  	case TC_SETUP_CLSFLOWER:
>  		return prestera_flow_block_flower_cb(block, type_data);
> +	case TC_SETUP_CLSMATCHALL:
> +		return prestera_flow_block_mall_cb(block, type_data);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> @@ -163,6 +180,8 @@ static void prestera_setup_flow_block_unbind(struct prestera_port *port,
>  	if (!tc_can_offload(port->dev))
>  		prestera_acl_block_disable_dec(block);
>  
> +	prestera_span_destroy(block);
> +
>  	err = prestera_acl_block_unbind(block, port);
>  	if (err)
>  		goto error;
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> index 42b8d9f56468..c1297859e471 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
> @@ -56,6 +56,11 @@ enum prestera_cmd_type_t {
>  
>  	PRESTERA_CMD_TYPE_STP_PORT_SET = 0x1000,
>  
> +	PRESTERA_CMD_TYPE_SPAN_GET = 0x1100,
> +	PRESTERA_CMD_TYPE_SPAN_BIND = 0x1101,
> +	PRESTERA_CMD_TYPE_SPAN_UNBIND = 0x1102,
> +	PRESTERA_CMD_TYPE_SPAN_RELEASE = 0x1103,
> +
>  	PRESTERA_CMD_TYPE_CPU_CODE_COUNTERS_GET = 0x2000,
>  
>  	PRESTERA_CMD_TYPE_ACK = 0x10000,
> @@ -377,6 +382,18 @@ struct prestera_msg_acl_ruleset_resp {
>  	u16 id;
>  };
>  
> +struct prestera_msg_span_req {
> +	struct prestera_msg_cmd cmd;
> +	u32 port;
> +	u32 dev;
> +	u8 id;
> +} __packed __aligned(4);
> +
> +struct prestera_msg_span_resp {
> +	struct prestera_msg_ret ret;
> +	u8 id;
> +} __packed __aligned(4);
> +
>  struct prestera_msg_stp_req {
>  	struct prestera_msg_cmd cmd;
>  	u32 port;
> @@ -1055,6 +1072,58 @@ int prestera_hw_acl_port_unbind(const struct prestera_port *port,
>  			    &req.cmd, sizeof(req));
>  }
>  
> +int prestera_hw_span_get(const struct prestera_port *port, u8 *span_id)
> +{
> +	struct prestera_msg_span_resp resp;
> +	struct prestera_msg_span_req req = {
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +	};
> +	int err;
> +
> +	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_SPAN_GET,
> +			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
> +	if (err)
> +		return err;
> +
> +	*span_id = resp.id;
> +
> +	return 0;
> +}
> +
> +int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id)
> +{
> +	struct prestera_msg_span_req req = {
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +		.id = span_id,
> +	};
> +
> +	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_SPAN_BIND,
> +			    &req.cmd, sizeof(req));
> +}
> +
> +int prestera_hw_span_unbind(const struct prestera_port *port)
> +{
> +	struct prestera_msg_span_req req = {
> +		.port = port->hw_id,
> +		.dev = port->dev_id,
> +	};
> +
> +	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_SPAN_UNBIND,
> +			    &req.cmd, sizeof(req));
> +}
> +
> +int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id)
> +{
> +	struct prestera_msg_span_req req = {
> +		.id = span_id
> +	};
> +
> +	return prestera_cmd(sw, PRESTERA_CMD_TYPE_SPAN_RELEASE,
> +			    &req.cmd, sizeof(req));
> +}
> +
>  int prestera_hw_port_type_get(const struct prestera_port *port, u8 *type)
>  {
>  	struct prestera_msg_port_attr_req req = {
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> index c01d376574d2..546d5fd8240d 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
> @@ -188,6 +188,12 @@ int prestera_hw_acl_port_bind(const struct prestera_port *port,
>  int prestera_hw_acl_port_unbind(const struct prestera_port *port,
>  				u16 ruleset_id);
>  
> +/* SPAN API */
> +int prestera_hw_span_get(const struct prestera_port *port, u8 *span_id);
> +int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id);
> +int prestera_hw_span_unbind(const struct prestera_port *port);
> +int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id);
> +
>  /* Event handlers */
>  int prestera_hw_event_handler_register(struct prestera_switch *sw,
>  				       enum prestera_event_type type,
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> index ea683b5a8a2e..d2a738da368a 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> @@ -14,6 +14,7 @@
>  #include "prestera_hw.h"
>  #include "prestera_acl.h"
>  #include "prestera_flow.h"
> +#include "prestera_span.h"
>  #include "prestera_rxtx.h"
>  #include "prestera_devlink.h"
>  #include "prestera_ethtool.h"
> @@ -909,6 +910,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
>  	if (err)
>  		goto err_acl_init;
>  
> +	err = prestera_span_init(sw);
> +	if (err)
> +		goto err_span_init;
> +
>  	err = prestera_devlink_register(sw);
>  	if (err)
>  		goto err_dl_register;
> @@ -928,6 +933,8 @@ static int prestera_switch_init(struct prestera_switch *sw)
>  err_lag_init:
>  	prestera_devlink_unregister(sw);
>  err_dl_register:
> +	prestera_span_fini(sw);
> +err_span_init:
>  	prestera_acl_fini(sw);
>  err_acl_init:
>  	prestera_event_handlers_unregister(sw);
> @@ -947,6 +954,7 @@ static void prestera_switch_fini(struct prestera_switch *sw)
>  	prestera_destroy_ports(sw);
>  	prestera_lag_fini(sw);
>  	prestera_devlink_unregister(sw);
> +	prestera_span_fini(sw);
>  	prestera_acl_fini(sw);
>  	prestera_event_handlers_unregister(sw);
>  	prestera_rxtx_switch_fini(sw);
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_span.c b/drivers/net/ethernet/marvell/prestera/prestera_span.c
> new file mode 100644
> index 000000000000..d399e47fb429
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_span.c
> @@ -0,0 +1,245 @@
> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> +/* Copyright (c) 2020 Marvell International Ltd. All rights reserved */
> +
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +
> +#include "prestera.h"
> +#include "prestera_hw.h"
> +#include "prestera_acl.h"
> +#include "prestera_span.h"
> +
> +struct prestera_span_entry {
> +	struct list_head list;
> +	struct prestera_port *port;
> +	refcount_t ref_count;
> +	u8 id;
> +};
> +
> +struct prestera_span {
> +	struct prestera_switch *sw;
> +	struct list_head entries;
> +};
> +
> +static struct prestera_span_entry *
> +prestera_span_entry_create(struct prestera_port *port, u8 span_id)
> +{
> +	struct prestera_span_entry *entry;
> +
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return ERR_PTR(-ENOMEM);
> +
> +	refcount_set(&entry->ref_count, 1);
> +	entry->port = port;
> +	entry->id = span_id;
> +	list_add_tail(&entry->list, &port->sw->span->entries);
> +
> +	return entry;
> +}
> +
> +static void prestera_span_entry_del(struct prestera_span_entry *entry)
> +{
> +	list_del(&entry->list);
> +	kfree(entry);
> +}
> +
> +static struct prestera_span_entry *
> +prestera_span_entry_find_by_id(struct prestera_span *span, u8 span_id)
> +{
> +	struct prestera_span_entry *entry;
> +
> +	list_for_each_entry(entry, &span->entries, list) {
> +		if (entry->id == span_id)
> +			return entry;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct prestera_span_entry *
> +prestera_span_entry_find_by_port(struct prestera_span *span,
> +				 struct prestera_port *port)
> +{
> +	struct prestera_span_entry *entry;
> +
> +	list_for_each_entry(entry, &span->entries, list) {
> +		if (entry->port == port)
> +			return entry;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int prestera_span_get(struct prestera_port *port, u8 *span_id)
> +{
> +	u8 new_span_id;
> +	struct prestera_switch *sw = port->sw;
> +	struct prestera_span_entry *entry;
> +	int err;
> +
> +	entry = prestera_span_entry_find_by_port(sw->span, port);
> +	if (entry) {
> +		refcount_inc(&entry->ref_count);
> +		*span_id = entry->id;
> +		return 0;
> +	}
> +
> +	err = prestera_hw_span_get(port, &new_span_id);
> +	if (err)
> +		return err;
> +
> +	entry = prestera_span_entry_create(port, new_span_id);
> +	if (IS_ERR(entry)) {
> +		prestera_hw_span_release(sw, new_span_id);
> +		return PTR_ERR(entry);
> +	}
> +
> +	*span_id = new_span_id;
> +	return 0;
> +}
> +
> +static int prestera_span_put(struct prestera_switch *sw, u8 span_id)
> +{
> +	struct prestera_span_entry *entry;
> +	int err;
> +
> +	entry = prestera_span_entry_find_by_id(sw->span, span_id);
> +	if (!entry)
> +		return false;
> +
> +	if (!refcount_dec_and_test(&entry->ref_count))
> +		return 0;
> +
> +	err = prestera_hw_span_release(sw, span_id);
> +	if (err)
> +		return err;
> +
> +	prestera_span_entry_del(entry);
> +	return 0;
> +}
> +
> +static int prestera_span_rule_add(struct prestera_flow_block_binding *binding,
> +				  struct prestera_port *to_port)
> +{
> +	int err;
> +	u8 span_id;
> +	struct prestera_switch *sw = binding->port->sw;

Networking coding style is to declare variables in reverse order of line length (similar for prestera_span_get).

> +
> +	if (binding->span_id != PRESTERA_SPAN_INVALID_ID)
> +		/* port already in mirroring */
> +		return -EEXIST;
> +
> +	err = prestera_span_get(to_port, &span_id);
> +	if (err)
> +		return err;
> +
> +	err = prestera_hw_span_bind(binding->port, span_id);
> +	if (err) {
> +		prestera_span_put(sw, span_id);
> +		return err;
> +	}
> +
> +	binding->span_id = span_id;
> +	return 0;
> +}
> +
> +static int prestera_span_rule_del(struct prestera_flow_block_binding *binding)
> +{
> +	int err;
> +
> +	err = prestera_hw_span_unbind(binding->port);
> +	if (err)
> +		return err;
> +
> +	err = prestera_span_put(binding->port->sw, binding->span_id);
> +	if (err)
> +		return err;
> +
> +	binding->span_id = PRESTERA_SPAN_INVALID_ID;
> +	return 0;
> +}
> +
> +int prestera_span_replace(struct prestera_flow_block *block,
> +			  struct tc_cls_matchall_offload *f)
> +{
> +	struct prestera_flow_block_binding *binding;
> +	__be16 protocol = f->common.protocol;
> +	struct flow_action_entry *act;
> +	struct prestera_port *port;
> +	int err;
> +
> +	if (!flow_offload_has_one_action(&f->rule->action)) {
> +		NL_SET_ERR_MSG(f->common.extack,
> +			       "Only singular actions are supported");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (f->common.chain_index) {
> +		NL_SET_ERR_MSG(f->common.extack, "Only chain 0 is supported");
> +		return -EOPNOTSUPP;
> +	}

I wonder if you could just use a single tc_cls_can_offload_and_chain0()
in the TC_SETUP_BLOCK callback?

> +
> +	act = &f->rule->action.entries[0];
> +
> +	if (act->id != FLOW_ACTION_MIRRED)
> +		return -EOPNOTSUPP;
> +
> +	if (protocol != htons(ETH_P_ALL))
> +		return -EOPNOTSUPP;
> +
> +	/* TODO: add prio check */

What prio check?

> +
> +	if (!prestera_netdev_check(act->dev)) {
> +		NL_SET_ERR_MSG(f->common.extack,
> +			       "Only switchdev port is supported");

Actually only a Marvell Prestera port is supported. Switchdev is a much broader category.

> +		return -EINVAL;
> +	}
> +
> +	port = netdev_priv(act->dev);
> +	list_for_each_entry(binding, &block->binding_list, list) {
> +		err = prestera_span_rule_add(binding, port);
> +		if (err)
> +			goto rollback;
> +	}
> +	return 0;
> +
> +rollback:
> +	list_for_each_entry_continue_reverse(binding,
> +					     &block->binding_list, list)
> +		prestera_span_rule_del(binding);
> +	return err;
> +}
> +
> +void prestera_span_destroy(struct prestera_flow_block *block)
> +{
> +	struct prestera_flow_block_binding *binding;
> +
> +	list_for_each_entry(binding, &block->binding_list, list)
> +		prestera_span_rule_del(binding);
> +}
> +
> +int prestera_span_init(struct prestera_switch *sw)
> +{
> +	struct prestera_span *span;
> +
> +	span = kzalloc(sizeof(*span), GFP_KERNEL);
> +	if (!span)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&span->entries);
> +
> +	sw->span = span;
> +	span->sw = sw;
> +
> +	return 0;
> +}
> +
> +void prestera_span_fini(struct prestera_switch *sw)
> +{
> +	struct prestera_span *span = sw->span;
> +
> +	WARN_ON(!list_empty(&span->entries));
> +	kfree(span);
> +}
> +
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_span.h b/drivers/net/ethernet/marvell/prestera/prestera_span.h
> new file mode 100644
> index 000000000000..f0644521f78a
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_span.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
> +/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved. */
> +
> +#ifndef _PRESTERA_SPAN_H_
> +#define _PRESTERA_SPAN_H_
> +
> +#include <net/pkt_cls.h>
> +
> +#define PRESTERA_SPAN_INVALID_ID -1
> +
> +struct prestera_switch;
> +struct prestera_flow_block;
> +
> +int prestera_span_init(struct prestera_switch *sw);
> +void prestera_span_fini(struct prestera_switch *sw);
> +int prestera_span_replace(struct prestera_flow_block *block,
> +			  struct tc_cls_matchall_offload *f);
> +void prestera_span_destroy(struct prestera_flow_block *block);
> +
> +#endif /* _PRESTERA_SPAN_H_ */
> -- 
> 2.17.1
> 

