Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBE2481CFE
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 15:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239952AbhL3OUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 09:20:01 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:58793 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239922AbhL3OUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 09:20:01 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7F3105802B1;
        Thu, 30 Dec 2021 09:20:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 30 Dec 2021 09:20:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9fsKoI
        XbIQHTST4uJdUqXema5zN4b8N7TbCUbvdZtCg=; b=OoVeVh43QH+TDtsh95HteL
        PaX0Vbwa7eQzpHTeU3W2TQsHnQMKiVrxCGrDvRrI29KATRy8t8E/CV8mME/eatWB
        XP83F58ouqysCkdGaZsF4f/H1/bZlhisYoKysDdP+XhV1POwdZygZZCrVva/vat+
        XyyAnTwjvWDkxolmIera5xRF+JLzKrk36rTiYOaoGzG4R3GjGiH3zPFvc2YcA2Ro
        Vua2ZmWPVsMXGeUPXvCc4U6Tr+HbIQbEC1yn8uI4yHTLxb4owCzwnwQri/4CgkjN
        CrI2tdw0ovUBFFm0BsAG2RCePHBBKgi6PfZMSjfdynMK8Hvy2ZG80YkFvyatZhQA
        ==
X-ME-Sender: <xms:D8DNYd2qgbUsG4CdUgufZw0lkRaOzmHP2qxB6iIfiFBsP9-BKTAD8w>
    <xme:D8DNYUFqajmsHlawjoJaWGgcUxgJYxZBFGH7sqyC3ozILnmAzJfLlUd2H92YILBAq
    AiF9cWzTuSqn-s>
X-ME-Received: <xmr:D8DNYd77EVcDXfC8sgsJfuSJ8nBjOQu1O-JudWlTvg8xwOZZdkMAWNhYzVdCSgwK_Kz2orGgW3yVNLpS6p7RDiiz4eAjJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddvfedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:D8DNYa0dfTQrKSiFXl5T7dpDfFIpoh1KhFRk_kXKyD8S63TG3OT_yA>
    <xmx:D8DNYQHVrl89beZXgIIKU1d2IG3cq7_NU9StHJtu5ijA6U4Df94S2Q>
    <xmx:D8DNYb8zoowbF8q_dR0oq_ZN6IjtePj7rVMAcMj_CRlzNRjUwPdvfw>
    <xmx:EMDNYY-p6B0WIp_JYJPIOkFn3Okgk1dsp6fkxRRedwmZrr0Unebbow>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Dec 2021 09:19:59 -0500 (EST)
Date:   Thu, 30 Dec 2021 16:19:54 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/6] net: marvell: prestera: add hardware
 router objects accounting
Message-ID: <Yc3ACoIa0dyb4hJk@shredder>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
 <20211227215233.31220-5-yevhen.orlov@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227215233.31220-5-yevhen.orlov@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 11:52:29PM +0200, Yevhen Orlov wrote:
> Add prestera_router_hw.c. This file contains functions, which track HW
> objects relations and links. This include implicity creation of objects,
> that needed by requested one and implicity removing of objects, which
> reference counter is became zero.
> 
> We need this layer, because kernel callbacks not always mapped to
> creation of single HW object. So let it be two different layers - one
> for subscribing and parsing kernel structures, and another
> (prestera_router_hw.c) for HW objects relations tracking.
> 
> There is two types of objects on router_hw layer:
>  - Explicit objects (rif_entry) : created by higher layer.
>  - Implicit objects (vr) : created on demand by explicit objects.
> 
> Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
> Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
> Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> ---
> v1-->v2
> * No changes
> ---
>  .../net/ethernet/marvell/prestera/Makefile    |   2 +-
>  .../marvell/prestera/prestera_router.c        |  10 +
>  .../marvell/prestera/prestera_router_hw.c     | 209 ++++++++++++++++++
>  .../marvell/prestera/prestera_router_hw.h     |  36 +++
>  4 files changed, 256 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
>  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
> index ec69fc564a9f..d395f4131648 100644
> --- a/drivers/net/ethernet/marvell/prestera/Makefile
> +++ b/drivers/net/ethernet/marvell/prestera/Makefile
> @@ -4,6 +4,6 @@ prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
>  			   prestera_rxtx.o prestera_devlink.o prestera_ethtool.o \
>  			   prestera_switchdev.o prestera_acl.o prestera_flow.o \
>  			   prestera_flower.o prestera_span.o prestera_counter.o \
> -			   prestera_router.o
> +			   prestera_router.o prestera_router_hw.o
>  
>  obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
> index f3980d10eb29..2a32831df40f 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
> @@ -5,10 +5,12 @@
>  #include <linux/types.h>
>  
>  #include "prestera.h"
> +#include "prestera_router_hw.h"
>  
>  int prestera_router_init(struct prestera_switch *sw)
>  {
>  	struct prestera_router *router;
> +	int err;
>  
>  	router = kzalloc(sizeof(*sw->router), GFP_KERNEL);
>  	if (!router)
> @@ -17,7 +19,15 @@ int prestera_router_init(struct prestera_switch *sw)
>  	sw->router = router;
>  	router->sw = sw;
>  
> +	err = prestera_router_hw_init(sw);
> +	if (err)
> +		goto err_router_lib_init;
> +
>  	return 0;
> +
> +err_router_lib_init:
> +	kfree(sw->router);
> +	return err;
>  }
>  
>  void prestera_router_fini(struct prestera_switch *sw)

Looks suspicious that you don't call prestera_router_hw_fini() here. You
can at least verify that the two lists you initialize in
prestera_router_hw_init() are indeed empty.

> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
> new file mode 100644
> index 000000000000..4f66fb21a299
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
> @@ -0,0 +1,209 @@
> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> +/* Copyright (c) 2019-2021 Marvell International Ltd. All rights reserved */
> +
> +#include <linux/rhashtable.h>
> +
> +#include "prestera.h"
> +#include "prestera_hw.h"
> +#include "prestera_router_hw.h"
> +#include "prestera_acl.h"
> +
> +/*            +--+
> + *   +------->|vr|
> + *   |        +--+
> + *   |
> + * +-+-------+
> + * |rif_entry|
> + * +---------+
> + *  Rif is
> + *  used as
> + *  entry point
> + *  for vr in hw
> + */
> +
> +int prestera_router_hw_init(struct prestera_switch *sw)
> +{
> +	INIT_LIST_HEAD(&sw->router->vr_list);
> +	INIT_LIST_HEAD(&sw->router->rif_entry_list);
> +
> +	return 0;
> +}
> +
> +static struct prestera_vr *__prestera_vr_find(struct prestera_switch *sw,
> +					      u32 tb_id)
> +{
> +	struct prestera_vr *vr;
> +
> +	list_for_each_entry(vr, &sw->router->vr_list, router_node) {

Probably better to store VRs in something like IDR instead of a linked
list

> +		if (vr->tb_id == tb_id)
> +			return vr;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct prestera_vr *__prestera_vr_create(struct prestera_switch *sw,
> +						u32 tb_id,
> +						struct netlink_ext_ack *extack)
> +{
> +	struct prestera_vr *vr;
> +	u16 hw_vr_id;
> +	int err;
> +
> +	err = prestera_hw_vr_create(sw, &hw_vr_id);
> +	if (err)
> +		return ERR_PTR(-ENOMEM);
> +
> +	vr = kzalloc(sizeof(*vr), GFP_KERNEL);
> +	if (!vr) {
> +		err = -ENOMEM;
> +		goto err_alloc_vr;
> +	}
> +
> +	vr->tb_id = tb_id;
> +	vr->hw_vr_id = hw_vr_id;
> +
> +	list_add(&vr->router_node, &sw->router->vr_list);
> +
> +	return vr;
> +
> +err_alloc_vr:
> +	prestera_hw_vr_delete(sw, hw_vr_id);
> +	kfree(vr);

You failed to allocate it, so no need to free it

> +	return ERR_PTR(err);
> +}
> +
> +static void __prestera_vr_destroy(struct prestera_switch *sw,
> +				  struct prestera_vr *vr)
> +{
> +	prestera_hw_vr_delete(sw, vr->hw_vr_id);
> +	list_del(&vr->router_node);

Not symmetric with __prestera_vr_create()

> +	kfree(vr);
> +}
> +
> +static struct prestera_vr *prestera_vr_get(struct prestera_switch *sw, u32 tb_id,
> +					   struct netlink_ext_ack *extack)
> +{
> +	struct prestera_vr *vr;
> +
> +	vr = __prestera_vr_find(sw, tb_id);
> +	if (!vr)
> +		vr = __prestera_vr_create(sw, tb_id, extack);
> +	if (IS_ERR(vr))
> +		return ERR_CAST(vr);
> +
> +	return vr;
> +}
> +
> +static void prestera_vr_put(struct prestera_switch *sw, struct prestera_vr *vr)
> +{
> +	if (!vr->ref_cnt)
> +		__prestera_vr_destroy(sw, vr);
> +}

These two functions should increase/decrease the reference count of the
VR

> +
> +/* iface is overhead struct. vr_id also can be removed. */

Unclear

> +static int
> +__prestera_rif_entry_key_copy(const struct prestera_rif_entry_key *in,
> +			      struct prestera_rif_entry_key *out)
> +{
> +	memset(out, 0, sizeof(*out));
> +
> +	switch (in->iface.type) {
> +	case PRESTERA_IF_PORT_E:
> +		out->iface.dev_port.hw_dev_num = in->iface.dev_port.hw_dev_num;
> +		out->iface.dev_port.port_num = in->iface.dev_port.port_num;
> +		break;
> +	case PRESTERA_IF_LAG_E:
> +		out->iface.lag_id = in->iface.lag_id;
> +		break;
> +	case PRESTERA_IF_VID_E:
> +		out->iface.vlan_id = in->iface.vlan_id;
> +		break;
> +	default:
> +		pr_err("Unsupported iface type");

If this should never happen, then consider using WARN_ON(1)

> +		return -EINVAL;
> +	}
> +
> +	out->iface.type = in->iface.type;
> +	return 0;
> +}
> +
> +struct prestera_rif_entry *
> +prestera_rif_entry_find(const struct prestera_switch *sw,
> +			const struct prestera_rif_entry_key *k)
> +{
> +	struct prestera_rif_entry *rif_entry;
> +	struct prestera_rif_entry_key lk; /* lookup key */
> +
> +	if (__prestera_rif_entry_key_copy(k, &lk))
> +		return NULL;
> +
> +	list_for_each_entry(rif_entry, &sw->router->rif_entry_list,
> +			    router_node) {
> +		if (!memcmp(k, &rif_entry->key, sizeof(*k)))
> +			return rif_entry;

Looks like rhashtable is a better option than a linked list

> +	}
> +
> +	return NULL;
> +}
> +
> +void prestera_rif_entry_destroy(struct prestera_switch *sw,
> +				struct prestera_rif_entry *e)

It's easier to maintain/review code that follows a pattern of create()
followed by destroy(). You can see if the error path is the same as what
you have in destroy()

> +{
> +	struct prestera_iface iface;
> +
> +	list_del(&e->router_node);
> +
> +	memcpy(&iface, &e->key.iface, sizeof(iface));
> +	iface.vr_id = e->vr->hw_vr_id;
> +	prestera_hw_rif_delete(sw, e->hw_id, &iface);
> +
> +	e->vr->ref_cnt--;
> +	prestera_vr_put(sw, e->vr);
> +	kfree(e);
> +}
> +
> +struct prestera_rif_entry *
> +prestera_rif_entry_create(struct prestera_switch *sw,
> +			  struct prestera_rif_entry_key *k,
> +			  u32 tb_id, const unsigned char *addr)
> +{
> +	int err;
> +	struct prestera_rif_entry *e;
> +	struct prestera_iface iface;
> +
> +	e = kzalloc(sizeof(*e), GFP_KERNEL);
> +	if (!e)
> +		goto err_kzalloc;
> +
> +	if (__prestera_rif_entry_key_copy(k, &e->key))
> +		goto err_key_copy;
> +
> +	e->vr = prestera_vr_get(sw, tb_id, NULL);
> +	if (IS_ERR(e->vr))
> +		goto err_vr_get;
> +
> +	e->vr->ref_cnt++;
> +	memcpy(&e->addr, addr, sizeof(e->addr));
> +
> +	/* HW */
> +	memcpy(&iface, &e->key.iface, sizeof(iface));
> +	iface.vr_id = e->vr->hw_vr_id;
> +	err = prestera_hw_rif_create(sw, &iface, e->addr, &e->hw_id);
> +	if (err)
> +		goto err_hw_create;
> +
> +	list_add(&e->router_node, &sw->router->rif_entry_list);
> +
> +	return e;
> +
> +err_hw_create:
> +	e->vr->ref_cnt--;
> +	prestera_vr_put(sw, e->vr);
> +err_vr_get:
> +err_key_copy:
> +	kfree(e);
> +err_kzalloc:
> +	return NULL;
> +}
> +
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
> new file mode 100644
> index 000000000000..fed53595f7bb
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
> +/* Copyright (c) 2019-2021 Marvell International Ltd. All rights reserved. */
> +
> +#ifndef _PRESTERA_ROUTER_HW_H_
> +#define _PRESTERA_ROUTER_HW_H_
> +
> +struct prestera_vr {
> +	struct list_head router_node;
> +	unsigned int ref_cnt;

Use refcount_t

> +	u32 tb_id;			/* key (kernel fib table id) */
> +	u16 hw_vr_id;			/* virtual router ID */
> +	u8 __pad[2];
> +};
> +
> +struct prestera_rif_entry {
> +	struct prestera_rif_entry_key {
> +		struct prestera_iface iface;
> +	} key;
> +	struct prestera_vr *vr;
> +	unsigned char addr[ETH_ALEN];
> +	u16 hw_id; /* rif_id */
> +	struct list_head router_node; /* ht */
> +};
> +
> +struct prestera_rif_entry *
> +prestera_rif_entry_find(const struct prestera_switch *sw,
> +			const struct prestera_rif_entry_key *k);
> +void prestera_rif_entry_destroy(struct prestera_switch *sw,
> +				struct prestera_rif_entry *e);
> +struct prestera_rif_entry *
> +prestera_rif_entry_create(struct prestera_switch *sw,
> +			  struct prestera_rif_entry_key *k,
> +			  u32 tb_id, const unsigned char *addr);
> +int prestera_router_hw_init(struct prestera_switch *sw);
> +
> +#endif /* _PRESTERA_ROUTER_HW_H_ */
> -- 
> 2.17.1
> 
