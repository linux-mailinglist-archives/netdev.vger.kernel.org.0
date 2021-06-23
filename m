Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C733B1F82
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 19:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhFWRdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 13:33:24 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:53895 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229726AbhFWRdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 13:33:23 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 43D69580661;
        Wed, 23 Jun 2021 13:31:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 23 Jun 2021 13:31:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=xsm/iuKc+04iGIrtanquxcEfKGm
        0/iHMtOF7c6r7Jqk=; b=nrg5Vic+q3fYGWO54Ohj8Ja8nFHGwEHL15bQRUdaZQo
        UGdGD0d6oILejJ9507k2qhfYXJDztCBWHuNOWkMs2S/0AgNoK6dnZDc4IeI7quPo
        Tfd9m+lYAEbt6yVey5delOudOe0Mi7PhH5s23sbJ7UFCY42UqWttU8CyP4vUluH5
        K8bohS21hlYfN4McqQZoiAeoi2UGiuoYJtXhDZT0KfQqxH8Z7hhm5GmYiCBYZJyw
        jpe8mrSiHV82GZjTBXb4GcIpOCu89hmzrJTZIONMwtEtz0vprOwy2IrgaeZEmsYi
        SWW3hSco8qNmVOSke6zdY0nXIEUZHIINVTcPdmobTTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xsm/iu
        Kc+04iGIrtanquxcEfKGm0/iHMtOF7c6r7Jqk=; b=Fo9q8bpZzDgc7kErb09oXI
        L/ZU9KO7XyIILfJqtg43JCGiEPfeTMoiDq32drvTljvHqFARtCsnvYoiWGp7igI5
        felWcOf7B2vZmkTjnY7VyvesdAiX2t95Wm7zHwze4zFwswr34gtzusL+toPXeOf0
        t7TwQjj0LLa7KIe+9Cfrol6QOOh4GBlx+k0gvW7PgSDhrfg1/hNwv1540UMt8dLK
        bpQxCvYuOXCAEp3mQXe3xZfzoMeiqIwaQMwXvnLPCrVu9PgOCD+ygtHbohasvpZ5
        x/3XQZUPhPGgULtcje2D1jym3agHl+NjR00sPd6ubpYToDt0aUvq8vTu+nkms4cQ
        ==
X-ME-Sender: <xms:2G_TYMqLE7RSTgdCni3wFOh1kR67hgZfqVtYPBtC4RPT2QTZsWDSmA>
    <xme:2G_TYCodGI49uGnzTMBkzy0o46HTwnGDndcYwqgq8-6uIvWzPMzhv7lETNqqvvwIc
    RAGJQBaTLH53Q>
X-ME-Received: <xmr:2G_TYBN_kHARcMAiOFf6bWJsZHPd0gHvgC78azWNqyPCnpQhEL-ngn8-AbCPmSVGWBrp6XwzM3GIrV-WU_qedwgZ2zhNPv5r>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegfedgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:2G_TYD6ZGKR0p7X6ceaaEhq8wJb4NRANNBy-wxHWGZYCi125R5I9nw>
    <xmx:2G_TYL63kj2TDy7ru6hSzII_Dv3XSAQTSJuZCQyLe_DJCfjQYIReiA>
    <xmx:2G_TYDiMm7BDOwCejppN4LaCcmr7CAzZ5Q_S73TP-gj2VrSrab352w>
    <xmx:2W_TYGOBXx-GP0OhlAjQKn9hFIcn2wdVc4nuUdGTGHMgpzqy7B2taQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Jun 2021 13:31:03 -0400 (EDT)
Date:   Wed, 23 Jun 2021 19:31:00 +0200
From:   Greg KH <greg@kroah.com>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, bpf@vger.kernel.org,
        wsd_upstream@mediatek.com, chao.song@mediatek.com,
        zhuoliang.zhang@mediatek.com, kuohong.wang@mediatek.com
Subject: Re: [PATCH 4/4] drivers: net: mediatek: initial implementation of
 ccmni
Message-ID: <YNNv1AxDNBdPcQ1U@kroah.com>
References: <20210623113452.5671-1-rocco.yue@mediatek.com>
 <20210623113452.5671-4-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623113452.5671-4-rocco.yue@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 07:34:52PM +0800, Rocco Yue wrote:
> +static int ccmni_open(struct net_device *ccmni_dev)
> +{
> +	struct ccmni_inst *ccmni = netdev_priv(ccmni_dev);
> +
> +	netif_tx_start_all_queues(ccmni_dev);
> +	netif_carrier_on(ccmni_dev);
> +
> +	if (atomic_inc_return(&ccmni->usage) > 1) {
> +		atomic_dec(&ccmni->usage);
> +		netdev_err(ccmni_dev, "dev already open\n");
> +		return -EINVAL;

You only check this _AFTER_ starting up?  If so, why even check a count
at all?  Why does it matter as it's not keeping anything from working
here.



> +	}
> +
> +	return 0;
> +}
> +
> +static int ccmni_close(struct net_device *ccmni_dev)
> +{
> +	struct ccmni_inst *ccmni = netdev_priv(ccmni_dev);
> +
> +	atomic_dec(&ccmni->usage);
> +	netif_tx_disable(ccmni_dev);
> +
> +	return 0;
> +}
> +
> +static netdev_tx_t
> +ccmni_start_xmit(struct sk_buff *skb, struct net_device *ccmni_dev)
> +{
> +	struct ccmni_inst *ccmni = NULL;
> +
> +	if (unlikely(!ccmni_hook_ready))
> +		goto tx_ok;
> +
> +	if (!skb || !ccmni_dev)
> +		goto tx_ok;
> +
> +	ccmni = netdev_priv(ccmni_dev);
> +
> +	/* some process can modify ccmni_dev->mtu */
> +	if (skb->len > ccmni_dev->mtu) {
> +		netdev_err(ccmni_dev, "xmit fail: len(0x%x) > MTU(0x%x, 0x%x)",
> +			   skb->len, CCMNI_MTU, ccmni_dev->mtu);
> +		goto tx_ok;
> +	}
> +
> +	/* hardware driver send packet will return a negative value
> +	 * ask the Linux netdevice to stop the tx queue
> +	 */
> +	if ((s_ccmni_ctlb->xmit_pkt(ccmni->index, skb, 0)) < 0)
> +		return NETDEV_TX_BUSY;
> +
> +	return NETDEV_TX_OK;
> +tx_ok:
> +	dev_kfree_skb(skb);
> +	ccmni_dev->stats.tx_dropped++;
> +	return NETDEV_TX_OK;
> +}
> +
> +static int ccmni_change_mtu(struct net_device *ccmni_dev, int new_mtu)
> +{
> +	if (new_mtu < 0 || new_mtu > CCMNI_MTU)
> +		return -EINVAL;
> +
> +	if (unlikely(!ccmni_dev))
> +		return -EINVAL;
> +
> +	ccmni_dev->mtu = new_mtu;
> +	return 0;
> +}
> +
> +static void ccmni_tx_timeout(struct net_device *ccmni_dev, unsigned int txqueue)
> +{
> +	struct ccmni_inst *ccmni = netdev_priv(ccmni_dev);
> +
> +	ccmni_dev->stats.tx_errors++;
> +	if (atomic_read(&ccmni->usage) > 0)
> +		netif_tx_wake_all_queues(ccmni_dev);

Why does it matter what the reference count is?  What happens if it
drops _RIGHT_ after testing for it?

Anytime you do an atomic_read() call, it's almost always a sign that the
logic is not correct.

Again, why have this reference count at all?  What is it protecting?

> +/* exposed API
> + * receive incoming datagrams from the Modem and push them to the
> + * kernel networking system
> + */
> +int ccmni_rx_push(unsigned int ccmni_idx, struct sk_buff *skb)

Ah, so this driver doesn't really do anything on its own, as there is no
modem driver for it.

So without a modem driver, it will never be used?  Please submit the
modem driver at the same time, otherwise it's impossible to review this
correctly.

thanks,

greg k-h
