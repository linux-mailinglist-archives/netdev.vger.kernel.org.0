Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B25FBE7B63
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbfJ1Vd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:33:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37283 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbfJ1Vd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 17:33:28 -0400
Received: by mail-pg1-f194.google.com with SMTP id p1so7855282pgi.4
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 14:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=jEdPM8+CeSN6YUxMRCSzn6h9zX/2P2PBOeSoWjOyGwU=;
        b=bdl88kZF4sDffbc4FuxXRHGyWjQp7MkgkLicu4ygU8bjQP92Pk0Iz9iWsO9KDkuc4/
         OWXgXpNgDaAyo15UFcQjqsHvBdmND76PEX359b0q8/jMTyJBJMTBx5b8QUaUG4ctQI8O
         G1t8aNCXViLW/M6z74CJRHSjbi/PV17zzIy0jlj1JX1SSHZU8KmU8wohwGeDehZ1VXzE
         /4wqibp0QVsR97msGf8JKGASqC1PIkhD59WPj2JwtDmSBr0kQpdlLO7doLn+B53l+eMZ
         vkcj2cAn+t9m/hIRtyG8OA4RzULPw+QxE6ZpPUuGPRV1Q/7YwPWALUxGCTVUd/Y3woho
         M6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=jEdPM8+CeSN6YUxMRCSzn6h9zX/2P2PBOeSoWjOyGwU=;
        b=K8AdmnYOg3XbNdcmu3RhEtuAGZ1iu1EJg50nwrebU9UrAn3eNMSlKXGxUejct04/ac
         B9wozznqQw+CnYs8eid4LxToo5u0/ReZ0sebQZI/lQEh7tR2YADqRneQ4ba/zehMAtyn
         n/Q2HDuVQdDHsPoql1Mc9dtuMWf8nLKISwaI70Rv9qCUZoOLJyqv6kSnxkkI8e5BEym8
         82+8a+q10gt/ouIF00rIH1/DMMnowAlj3qEDKBz01TrdCzCskfGkAHUyJGzjJv6leFVs
         0jJDLrFSnsz/LZJlkLllmIUMU/6fgf4kHi3jV+CSWak2BHQsI75caaVzdwCSqD2n4BuN
         VlFQ==
X-Gm-Message-State: APjAAAVUAkJI5ZojCNvLDw+yD6LXTPCByXiAHfkrkTjsS+GSTW+aoOay
        YEg0VGCRnE166BYb1cY5NY3N6A==
X-Google-Smtp-Source: APXvYqy9OriwAtFJ734hHSc7dz3dHQ5c1a6LhaFVhJVlRYd1p7+V+rQWXdKlsj5AENvQYC6Tl4P2Gw==
X-Received: by 2002:a17:90a:a882:: with SMTP id h2mr1782558pjq.1.1572298407836;
        Mon, 28 Oct 2019 14:33:27 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b14sm11228415pfi.95.2019.10.28.14.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 14:33:27 -0700 (PDT)
Date:   Mon, 28 Oct 2019 14:33:22 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next, 3/4] hv_netvsc: Add XDP support
Message-ID: <20191028143322.45d81da4@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1572296801-4789-4-git-send-email-haiyangz@microsoft.com>
References: <1572296801-4789-1-git-send-email-haiyangz@microsoft.com>
        <1572296801-4789-4-git-send-email-haiyangz@microsoft.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Oct 2019 21:07:04 +0000, Haiyang Zhang wrote:
> This patch adds support of XDP in native mode for hv_netvsc driver, and
> transparently sets the XDP program on the associated VF NIC as well.
> 
> XDP program cannot run with LRO (RSC) enabled, so you need to disable LRO
> before running XDP:
>         ethtool -K eth0 lro off
> 
> XDP actions not yet supported:
>         XDP_TX, XDP_REDIRECT

I don't think we want to merge support without at least XDP_TX these
days..

And without the ability to prepend headers this may be the least
complete initial XDP implementation we've seen :(

> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index d22a36f..688487b 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -122,8 +122,10 @@ static void free_netvsc_device(struct rcu_head *head)
>  	vfree(nvdev->send_buf);
>  	kfree(nvdev->send_section_map);
>  
> -	for (i = 0; i < VRSS_CHANNEL_MAX; i++)
> +	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
> +		xdp_rxq_info_unreg(&nvdev->chan_table[i].xdp_rxq);
>  		vfree(nvdev->chan_table[i].mrc.slots);
> +	}
>  
>  	kfree(nvdev);
>  }
> @@ -1370,6 +1372,10 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
>  		nvchan->net_device = net_device;
>  		u64_stats_init(&nvchan->tx_stats.syncp);
>  		u64_stats_init(&nvchan->rx_stats.syncp);
> +
> +		xdp_rxq_info_reg(&nvchan->xdp_rxq, ndev, i);
> +		xdp_rxq_info_reg_mem_model(&nvchan->xdp_rxq,
> +					   MEM_TYPE_PAGE_SHARED, NULL);

These can fail.

>  	}
>  
>  	/* Enable NAPI handler before init callbacks */
> diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
> new file mode 100644
> index 0000000..4d235ac
> --- /dev/null
> +++ b/drivers/net/hyperv/netvsc_bpf.c
> @@ -0,0 +1,211 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2019, Microsoft Corporation.
> + *
> + * Author:
> + *   Haiyang Zhang <haiyangz@microsoft.com>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <linux/ethtool.h>
> +#include <linux/bpf.h>
> +#include <linux/bpf_trace.h>
> +#include <linux/kernel.h>
> +#include <net/xdp.h>
> +
> +#include <linux/mutex.h>
> +#include <linux/rtnetlink.h>
> +
> +#include "hyperv_net.h"
> +
> +u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
> +		   void **p_pbuf)
> +{
> +	struct page *page = NULL;
> +	void *data = nvchan->rsc.data[0];
> +	u32 len = nvchan->rsc.len[0];
> +	void *pbuf = data;
> +	struct bpf_prog *prog;
> +	struct xdp_buff xdp;
> +	u32 act = XDP_PASS;
> +
> +	*p_pbuf = NULL;
> +
> +	rcu_read_lock();
> +	prog = rcu_dereference(nvchan->bpf_prog);
> +
> +	if (!prog || nvchan->rsc.cnt > 1)

Can rsc.cnt == 1 not be ensured at setup time? This looks quite
limiting if random frames could be forced to bypass the filter.

> +		goto out;
> +
> +	/* copy to a new page buffer if data are not within a page */
> +	if (virt_to_page(data) != virt_to_page(data + len - 1)) {
> +		page = alloc_page(GFP_ATOMIC);
> +		if (!page)
> +			goto out;

Returning XDP_PASS on allocation failure seems highly questionable.

> +		pbuf = page_address(page);
> +		memcpy(pbuf, nvchan->rsc.data[0], len);
> +
> +		*p_pbuf = pbuf;
> +	}
> +
> +	xdp.data_hard_start = pbuf;
> +	xdp.data = xdp.data_hard_start;

This patch also doesn't add any headroom for XDP to prepend data :(

> +	xdp_set_data_meta_invalid(&xdp);
> +	xdp.data_end = xdp.data + len;
> +	xdp.rxq = &nvchan->xdp_rxq;
> +	xdp.handle = 0;
> +
> +	act = bpf_prog_run_xdp(prog, &xdp);
> +
> +	switch (act) {
> +	case XDP_PASS:
> +		/* Pass to upper layers */
> +		break;
> +
> +	case XDP_ABORTED:
> +		trace_xdp_exception(ndev, prog, act);
> +		break;
> +
> +	case XDP_DROP:
> +		break;
> +
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +	}
> +
> +out:
> +	rcu_read_unlock();
> +
> +	if (page && act != XDP_PASS) {
> +		*p_pbuf = NULL;
> +		__free_page(page);
> +	}
> +
> +	return act;
> +}
> +
> +unsigned int netvsc_xdp_fraglen(unsigned int len)
> +{
> +	return SKB_DATA_ALIGN(len) +
> +	       SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +}
> +
> +struct bpf_prog *netvsc_xdp_get(struct netvsc_device *nvdev)
> +{
> +	return rtnl_dereference(nvdev->chan_table[0].bpf_prog);
> +}
> +
> +int netvsc_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> +		   struct netvsc_device *nvdev)
> +{
> +	struct bpf_prog *old_prog;
> +	int frag_max, i;
> +
> +	old_prog = netvsc_xdp_get(nvdev);
> +
> +	if (!old_prog && !prog)
> +		return 0;

I think this case is now handled by the core.

> +	frag_max = netvsc_xdp_fraglen(dev->mtu + ETH_HLEN);
> +	if (prog && frag_max > PAGE_SIZE) {
> +		netdev_err(dev, "XDP: mtu:%u too large, frag:%u\n",
> +			   dev->mtu, frag_max);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (prog && (dev->features & NETIF_F_LRO)) {
> +		netdev_err(dev, "XDP: not support LRO\n");

Please report this via extack, that way users will see it in the console
in which they're installing the program.

> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (prog) {
> +		prog = bpf_prog_add(prog, nvdev->num_chn);
> +		if (IS_ERR(prog))
> +			return PTR_ERR(prog);
> +	}
> +
> +	for (i = 0; i < nvdev->num_chn; i++)
> +		rcu_assign_pointer(nvdev->chan_table[i].bpf_prog, prog);
> +
> +	if (old_prog)
> +		for (i = 0; i < nvdev->num_chn; i++)
> +			bpf_prog_put(old_prog);
> +
> +	return 0;
> +}
> +
> +int netvsc_vf_setxdp(struct net_device *vf_netdev, struct bpf_prog *prog)
> +{
> +	struct netdev_bpf xdp;
> +	bpf_op_t ndo_bpf;
> +
> +	ASSERT_RTNL();
> +
> +	if (!vf_netdev)
> +		return 0;
> +
> +	ndo_bpf = vf_netdev->netdev_ops->ndo_bpf;
> +	if (!ndo_bpf)
> +		return 0;
> +
> +	memset(&xdp, 0, sizeof(xdp));
> +
> +	xdp.command = XDP_SETUP_PROG;
> +	xdp.prog = prog;
> +
> +	return ndo_bpf(vf_netdev, &xdp);

IMHO the automatic propagation is not a good idea. Especially if the
propagation doesn't make the entire installation fail if VF doesn't
have ndo_bpf.

> +}
