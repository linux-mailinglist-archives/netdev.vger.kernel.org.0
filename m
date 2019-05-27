Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1422BA22
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 20:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfE0S3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 14:29:32 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33055 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfE0S3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 14:29:31 -0400
Received: by mail-lj1-f196.google.com with SMTP id w1so15440845ljw.0
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 11:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CmpzWGArOJzCbtUDsEj3iOJkLX3jRRsxfmP2+PwxFOw=;
        b=Oxr5AXuI4+EPpurShT2LXwgIb0yVyjwfYRwcfroe2YHT3bNq6xV/cgj5yiSQZPMeTc
         MJbS0gPkNEYNEtjzem0ej4lG9y09lq1zoLSH+muFqOvuh/whPAUq5D55FJi5aIopu3h6
         G5C5eM4ARj27GqlDhZFDfjJP3+hnb0lMEgGTU5LR8muG9iqYtnevtQPUaqlm2lY66GlL
         NBQHo/QZWudT14B2u2oppFMQv3GbZzcMndHKxjxRy+SUjNujyS42qAwGuOX42+1c6Xv6
         bTdl9ryStQ7NQ7uTLskPmpyos9JWUc9JQaZoy4zJMzv5hvP0WXh8idNwKZ+khNCl/Yh0
         WJRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=CmpzWGArOJzCbtUDsEj3iOJkLX3jRRsxfmP2+PwxFOw=;
        b=HjnBCu7fOuC+wxJ5I/7Q5WnWYSUw3qwLBPxnvxPLXITQHGKXxvfPUfhX4LLsAJcD2i
         08C9UoTw6Ko3sM0q31ThwjnxnTdpvgbcfvMRv73r0TiBq+r+4dpArXOUjlG35+SoxqCR
         fpz/6ixD0YKxMX21w03gKA73HYlE50KgfIFKKKQZ7jqQaSlqbyF7WPlgXB2ibMGlH8Or
         QdE3c3405kbH+68xkcKIQUhql3jTSUYeG2Ny0oXNRl6pzlU62ZH03wYPjy1jI6Q875hL
         VMzrBZC/eiuE/R/zUZFdk6+x+TezZauvAcKyZdzL6e3Hs4GyRD+cViDtVT8ReQp8Cck1
         anYg==
X-Gm-Message-State: APjAAAVojWmRXusAof+lBt/jc2KJZ7jWXH1QuBzXegeUyU4yOMsMdtNh
        i0tEqiU2yPcuNl0N/aTvdj5XtdajSUo=
X-Google-Smtp-Source: APXvYqysfZOwyQZXIVEJCqO1y539z7o+NHfuVL6GfyHjftA36GY7GAdfP+ejD0p5VnRUBnISGTybwg==
X-Received: by 2002:a2e:121d:: with SMTP id t29mr52023166lje.29.1558981768615;
        Mon, 27 May 2019 11:29:28 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id y25sm2437089lfy.59.2019.05.27.11.29.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 11:29:28 -0700 (PDT)
Date:   Mon, 27 May 2019 21:29:25 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii <grygorii.strashko@ti.com>
Cc:     hawk@kernel.org, davem@davemloft.net, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190527182924.GC4246@khorivan>
Mail-Followup-To: grygorii <grygorii.strashko@ti.com>, hawk@kernel.org,
        davem@davemloft.net, ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
References: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
 <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
 <6a88616b-9a49-77c3-577e-40670f62f953@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6a88616b-9a49-77c3-577e-40670f62f953@ti.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 08:49:38PM +0300, grygorii wrote:
>Hi Ivan,
>
>On 23/05/2019 21:20, Ivan Khoronzhuk wrote:
>>Add XDP support based on rx page_pool allocator, one frame per page.
>>Page pool allocator is used with assumption that only one rx_handler
>>is running simultaneously. DMA map/unmap is reused from page pool
>>despite there is no need to map whole page.
>>
>>Due to specific of cpsw, the same TX/RX handler can be used by 2
>>network devices, so special fields in buffer are added to identify
>>an interface the frame is destined to. Thus XDP works for both
>>interfaces, that allows to test xdp redirect between two interfaces
>>easily.
>>
>>XDP prog is common for all channels till appropriate changes are added
>>in XDP infrastructure.
>>
>>Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>>---
>>  drivers/net/ethernet/ti/Kconfig        |   1 +
>>  drivers/net/ethernet/ti/cpsw.c         | 555 ++++++++++++++++++++++---
>>  drivers/net/ethernet/ti/cpsw_ethtool.c |  53 +++
>>  drivers/net/ethernet/ti/cpsw_priv.h    |   7 +
>>  4 files changed, 554 insertions(+), 62 deletions(-)
>>
>>diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
>>index bd05a977ee7e..3cb8c5214835 100644
>>--- a/drivers/net/ethernet/ti/Kconfig
>>+++ b/drivers/net/ethernet/ti/Kconfig
>>@@ -50,6 +50,7 @@ config TI_CPSW
>>  	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
>>  	select TI_DAVINCI_MDIO
>>  	select MFD_SYSCON
>>+	select PAGE_POOL
>>  	select REGMAP
>>  	---help---
>>  	  This driver supports TI's CPSW Ethernet Switch.
>>diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
>>index 87a600aeee4a..274e6b64ea9e 100644
>>--- a/drivers/net/ethernet/ti/cpsw.c
>>+++ b/drivers/net/ethernet/ti/cpsw.c
>>@@ -31,6 +31,10 @@
>>  #include <linux/if_vlan.h>
>>  #include <linux/kmemleak.h>
>>  #include <linux/sys_soc.h>
>>+#include <net/page_pool.h>
>>+#include <linux/bpf.h>
>>+#include <linux/bpf_trace.h>
>>+#include <linux/filter.h>
>>  #include <linux/pinctrl/consumer.h>
>>  #include <net/pkt_cls.h>
>>@@ -60,6 +64,10 @@ static int descs_pool_size = CPSW_CPDMA_DESCS_POOL_SIZE_DEFAULT;
>>  module_param(descs_pool_size, int, 0444);
>>  MODULE_PARM_DESC(descs_pool_size, "Number of CPDMA CPPI descriptors in pool");
>>+/* The buf includes headroom compatible with both skb and xdpf */
>>+#define CPSW_HEADROOM_NA (max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + NET_IP_ALIGN)
>>+#define CPSW_HEADROOM  ALIGN(CPSW_HEADROOM_NA, sizeof(long))
>>+
>>  #define for_each_slave(priv, func, arg...)				\
>>  	do {								\
>>  		struct cpsw_slave *slave;				\
>>@@ -74,6 +82,8 @@ MODULE_PARM_DESC(descs_pool_size, "Number of CPDMA CPPI descriptors in pool");
>>  				(func)(slave++, ##arg);			\
>>  	} while (0)
>>+#define CPSW_XMETA_OFFSET	ALIGN(sizeof(struct xdp_frame), sizeof(long))
>>+
>>  static int cpsw_ndo_vlan_rx_add_vid(struct net_device *ndev,
>>  				    __be16 proto, u16 vid);
>>@@ -337,24 +347,58 @@ void cpsw_intr_disable(struct cpsw_common *cpsw)
>>  	return;
>>  }
>
>[..]
>
>>+static int cpsw_xdp_tx_frame_mapped(struct cpsw_priv *priv,
>>+				    struct xdp_frame *xdpf, struct page *page)
>>+{
>>+	struct cpsw_common *cpsw = priv->cpsw;
>>+	struct cpsw_meta_xdp *xmeta;
>>+	struct netdev_queue *txq;
>>+	struct cpdma_chan *txch;
>>+	dma_addr_t dma;
>>+	int ret;
>>+
>>+	xmeta = (void *)xdpf + CPSW_XMETA_OFFSET;
>>+	xmeta->ch = 0;
>>+
>>+	txch = cpsw->txv[0].ch;
>>+	dma = (xdpf->data - (void *)xdpf) + page->dma_addr;
>>+	ret = cpdma_chan_submit_mapped(txch, cpsw_xdpf_to_handle(xdpf), dma,
>>+				       xdpf->len,
>>+				       priv->emac_port + cpsw->data.dual_emac);
>>+	if (ret) {
>>+		xdp_return_frame_rx_napi(xdpf);
>>+		goto stop;
>>+	}
>>+
>>+	/* no tx desc - stop sending us tx frames */
>>+	if (unlikely(!cpdma_check_free_tx_desc(txch)))
>>+		goto stop;
>>+
>>+	return ret;
>>+stop:
>>+	txq = netdev_get_tx_queue(priv->ndev, 0);
>>+	netif_tx_stop_queue(txq);
>>+
>>+	/* Barrier, so that stop_queue visible to other cpus */
>>+	smp_mb__after_atomic();
>>+
>>+	if (cpdma_check_free_tx_desc(txch))
>>+		netif_tx_wake_queue(txq);
>>+
>>+	return ret;
>>+}
>>+
>>+static int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf)
>>+{
>>+	struct cpsw_common *cpsw = priv->cpsw;
>>+	struct cpsw_meta_xdp *xmeta;
>>+	struct netdev_queue *txq;
>>+	struct cpdma_chan *txch;
>>+	int ret;
>>+
>>+	xmeta = (void *)xdpf + CPSW_XMETA_OFFSET;
>>+	if (sizeof(*xmeta) > xdpf->headroom)
>>+		return -EINVAL;
>>+
>>+	xmeta->ndev = priv->ndev;
>>+	xmeta->ch = 0;
>>+
>>+	txch = cpsw->txv[0].ch;
>>+	ret = cpdma_chan_submit(txch, cpsw_xdpf_to_handle(xdpf), xdpf->data,
>>+				xdpf->len,
>>+				priv->emac_port + cpsw->data.dual_emac);
>>+	if (ret) {
>>+		xdp_return_frame_rx_napi(xdpf);
>>+		goto stop;
>>+	}
>>+
>>+	/* no tx desc - stop sending us tx frames */
>>+	if (unlikely(!cpdma_check_free_tx_desc(txch)))
>>+		goto stop;
>>+
>>+	return ret;
>>+stop:
>>+	txq = netdev_get_tx_queue(priv->ndev, 0);
>>+	netif_tx_stop_queue(txq);
>>+
>>+	/* Barrier, so that stop_queue visible to other cpus */
>>+	smp_mb__after_atomic();
>>+
>>+	if (cpdma_check_free_tx_desc(txch))
>>+		netif_tx_wake_queue(txq);
>>+
>>+	return ret;
>>+}
>
>Above 2 functions are mostly identical - could you do smth. with it?
... I know it should be, but i hadn't found better way for combining them ....

>
>>+
>>+static int cpsw_run_xdp(struct cpsw_priv *priv, struct cpsw_vector *rxv,
>>+			struct xdp_buff *xdp, struct page *page)
>>+{
>>+	struct net_device *ndev = priv->ndev;
>>+	struct xdp_frame *xdpf;
>>+	struct bpf_prog *prog;
>>+	int ret = 1;
>>+	u32 act;
>>+
>>+	rcu_read_lock();
>>+
>>+	prog = READ_ONCE(priv->xdp_prog);
>>+	if (!prog) {
>>+		ret = 0;
>>+		goto out;
>>+	}
>>+
>>+	act = bpf_prog_run_xdp(prog, xdp);
>>+	switch (act) {
>>+	case XDP_PASS:
>>+		ret = 0;
>>+		break;
>>+	case XDP_TX:
>>+		xdpf = convert_to_xdp_frame(xdp);
>>+		if (unlikely(!xdpf))
>>+			xdp_return_buff(xdp);
>>+		else
>>+			cpsw_xdp_tx_frame_mapped(priv, xdpf, page);
>>+		break;
>>+	case XDP_REDIRECT:
>>+		if (xdp_do_redirect(ndev, xdp, prog))
>>+			xdp_return_buff(xdp);
>>+		else
>>+			ret = 2;
>
>could we avoid using consts as return values?
>may be some informative defines/enum?
Ok, for all "const" cases.

-- 
Regards,
Ivan Khoronzhuk
