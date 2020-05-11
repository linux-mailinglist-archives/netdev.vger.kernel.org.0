Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757521CD971
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgEKMOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725913AbgEKMOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:14:08 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B07C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 05:14:08 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id w19so4188451wmc.1
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 05:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=DswufsGMdS5ZZJB1Bmcj8FTzwUroM4WQMCDHSJ77QUo=;
        b=iGK1FTitDiu0Pw75XJHfocexT9FLRr0UK/evw5zrJN57ZHgNtptGSDoyLrPh3WZ4Nl
         m28Uvj5Yp3ued9VA3hhoLBtdMsMHnLys1NbgTmACOTcRVzIgTqPneKkmV/XjYKUfyJdT
         6Q+gM/k5Q6ooF03mRtAVysnEcFKgsGgqyMSOBAnqw6We/O2l4ybRi964qvZdDMef9cfI
         wNYDN5nf2NDLAljGD0wfqEz7SyLNafv0UL5Tc0zFsr9TXNaCnSNBa92dg8GZCJrGcCEP
         WJ5aD2f/I0OLWauCAC0Tkd5jzI/Vxh8ZjhQvwxHdZ+sYcK8sYZ7R84ThXlWeUyv7CZOC
         2E6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:in-reply-to
         :subject:date:message-id:mime-version:content-transfer-encoding
         :content-language:thread-index;
        bh=DswufsGMdS5ZZJB1Bmcj8FTzwUroM4WQMCDHSJ77QUo=;
        b=SF3OvHT/BbPlSsnqk/UO60flzY2cAWvhdJ/vkbc8db/y2HyDJhvyQW+DzS3HKna21f
         vihj/2OaTf/5YKTl7oLnK1L9o7okra60Vo+Mzem6wM2euRUK9GVGNIZaPBv7QT5q/K3b
         kkeMlRanvmpKbepGBCepW0aApHjRllNrmNR+8l91bAyUkPKDGlxMvonxjmKDxoLFVNnN
         ROWG4N59tFZEyS89/6yZa6F6QANIl+Cr9+57kmT/vx2aalT61HUVxGLZze98CEurhV9g
         MYjA3XjwVrbSE/QfHp2rSMUsKaSw/sOvBkKHtZUWt4WFlwYl5XZQMS/SmgIQDEXD49Z0
         0Y+Q==
X-Gm-Message-State: AGi0PuaGbnNc4GRga+65FVaSGU7/+ywLFgB4SGVxPKz0Q+VOCmWjDzF5
        bNfDWK8EbsCyf1mpRZRR7Gs=
X-Google-Smtp-Source: APiQypLxsckip0ZeEYbN6rE0Xuk3PmLViDrvqPmSPV1R5x542M12megeWFU2NGQtu8PwS5+EGoMZ8A==
X-Received: by 2002:a7b:ca47:: with SMTP id m7mr33077867wml.55.1589199247356;
        Mon, 11 May 2020 05:14:07 -0700 (PDT)
Received: from CBGR90WXYV0 ([54.239.6.188])
        by smtp.gmail.com with ESMTPSA id v8sm17476247wrs.45.2020.05.11.05.14.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 05:14:06 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: "Paul Durrant" <paul@xen.org>
Reply-To: <paul@xen.org>
To:     "'Denis Kirjanov'" <kda@linux-powerpc.org>
Cc:     <netdev@vger.kernel.org>, <brouer@redhat.com>, <jgross@suse.com>,
        <wei.liu@kernel.org>, <ilias.apalodimas@linaro.org>
References: <1589192541-11686-1-git-send-email-kda@linux-powerpc.org> <1589192541-11686-3-git-send-email-kda@linux-powerpc.org> <000c01d62787$f2e59a10$d8b0ce30$@xen.org> <CAOJe8K0UqZmc9nDYC2OZRnhvE-LgUjuta_-33Of6=wVVSCDnwg@mail.gmail.com>
In-Reply-To: <CAOJe8K0UqZmc9nDYC2OZRnhvE-LgUjuta_-33Of6=wVVSCDnwg@mail.gmail.com>
Subject: RE: [PATCH net-next v9 2/2] xen networking: add XDP offset adjustment to xen-netback
Date:   Mon, 11 May 2020 13:14:05 +0100
Message-ID: <000e01d6278d$ab04aa50$010dfef0$@xen.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AQIU9PmTVpNq2fLG8JgzWe5HwULahQDzXzdtAsUqzywBx8zP6af5Llyw
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Denis Kirjanov <kda@linux-powerpc.org>
> Sent: 11 May 2020 13:12
> To: paul@xen.org
> Cc: netdev@vger.kernel.org; brouer@redhat.com; jgross@suse.com; wei.liu@kernel.org;
> ilias.apalodimas@linaro.org
> Subject: Re: [PATCH net-next v9 2/2] xen networking: add XDP offset adjustment to xen-netback
> 
> On 5/11/20, Paul Durrant <xadimgnik@gmail.com> wrote:
> >> -----Original Message-----
> >> From: Denis Kirjanov <kda@linux-powerpc.org>
> >> Sent: 11 May 2020 11:22
> >> To: netdev@vger.kernel.org
> >> Cc: brouer@redhat.com; jgross@suse.com; wei.liu@kernel.org; paul@xen.org;
> >> ilias.apalodimas@linaro.org
> >> Subject: [PATCH net-next v9 2/2] xen networking: add XDP offset adjustment
> >> to xen-netback
> >>
> >> the patch basically adds the offset adjustment and netfront
> >> state reading to make XDP work on netfront side.
> >>
> >> Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
> >> ---
> >>  drivers/net/xen-netback/common.h  |  2 ++
> >>  drivers/net/xen-netback/netback.c |  7 +++++++
> >>  drivers/net/xen-netback/rx.c      |  7 ++++++-
> >>  drivers/net/xen-netback/xenbus.c  | 28 ++++++++++++++++++++++++++++
> >>  4 files changed, 43 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/xen-netback/common.h
> >> b/drivers/net/xen-netback/common.h
> >> index 05847eb..4a148d6 100644
> >> --- a/drivers/net/xen-netback/common.h
> >> +++ b/drivers/net/xen-netback/common.h
> >> @@ -280,6 +280,7 @@ struct xenvif {
> >>  	u8 ip_csum:1;
> >>  	u8 ipv6_csum:1;
> >>  	u8 multicast_control:1;
> >> +	u8 xdp_enabled:1;
> >>
> >>  	/* Is this interface disabled? True when backend discovers
> >>  	 * frontend is rogue.
> >> @@ -395,6 +396,7 @@ static inline pending_ring_idx_t
> >> nr_pending_reqs(struct xenvif_queue *queue)
> >>  irqreturn_t xenvif_interrupt(int irq, void *dev_id);
> >>
> >>  extern bool separate_tx_rx_irq;
> >> +extern bool provides_xdp_headroom;
> >>
> >>  extern unsigned int rx_drain_timeout_msecs;
> >>  extern unsigned int rx_stall_timeout_msecs;
> >> diff --git a/drivers/net/xen-netback/netback.c
> >> b/drivers/net/xen-netback/netback.c
> >> index 315dfc6..6dfca72 100644
> >> --- a/drivers/net/xen-netback/netback.c
> >> +++ b/drivers/net/xen-netback/netback.c
> >> @@ -96,6 +96,13 @@
> >>  module_param_named(hash_cache_size, xenvif_hash_cache_size, uint, 0644);
> >>  MODULE_PARM_DESC(hash_cache_size, "Number of flows in the hash cache");
> >>
> >> +/* The module parameter tells that we have to put data
> >> + * for xen-netfront with the XDP_PACKET_HEADROOM offset
> >> + * needed for XDP processing
> >> + */
> >> +bool provides_xdp_headroom = true;
> >> +module_param(provides_xdp_headroom, bool, 0644);
> >> +
> >>  static void xenvif_idx_release(struct xenvif_queue *queue, u16
> >> pending_idx,
> >>  			       u8 status);
> >>
> >> diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
> >> index ef58870..c97c98e 100644
> >> --- a/drivers/net/xen-netback/rx.c
> >> +++ b/drivers/net/xen-netback/rx.c
> >> @@ -33,6 +33,11 @@
> >>  #include <xen/xen.h>
> >>  #include <xen/events.h>
> >>
> >> +static int xenvif_rx_xdp_offset(struct xenvif *vif)
> >> +{
> >> +	return vif->xdp_enabled ? XDP_PACKET_HEADROOM : 0;
> >> +}
> >> +
> >>  static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
> >>  {
> >>  	RING_IDX prod, cons;
> >> @@ -356,7 +361,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue
> >> *queue,
> >>  				struct xen_netif_rx_request *req,
> >>  				struct xen_netif_rx_response *rsp)
> >>  {
> >> -	unsigned int offset = 0;
> >> +	unsigned int offset = xenvif_rx_xdp_offset(queue->vif);
> >>  	unsigned int flags;
> >>
> >>  	do {
> >> diff --git a/drivers/net/xen-netback/xenbus.c
> >> b/drivers/net/xen-netback/xenbus.c
> >> index 286054b..d447191 100644
> >> --- a/drivers/net/xen-netback/xenbus.c
> >> +++ b/drivers/net/xen-netback/xenbus.c
> >> @@ -393,6 +393,20 @@ static void set_backend_state(struct backend_info
> >> *be,
> >>  	}
> >>  }
> >>
> >> +static void read_xenbus_frontend_xdp(struct backend_info *be,
> >> +				     struct xenbus_device *dev)
> >> +{
> >> +	struct xenvif *vif = be->vif;
> >> +	unsigned int val;
> >> +	int err;
> >> +
> >> +	err = xenbus_scanf(XBT_NIL, dev->otherend,
> >> +			   "feature-xdp", "%u", &val);
> >> +	if (err != 1)
> >> +		return;
> >> +	vif->xdp_enabled = val;
> >> +}
> >> +
> >>  /**
> >>   * Callback received when the frontend's state changes.
> >>   */
> >> @@ -417,6 +431,11 @@ static void frontend_changed(struct xenbus_device
> >> *dev,
> >>  		set_backend_state(be, XenbusStateConnected);
> >>  		break;
> >>
> >> +	case XenbusStateReconfiguring:
> >> +		read_xenbus_frontend_xdp(be, dev);
> >
> > I think this being the only call to read_xenbus_frontend_xdp() is still a
> > problem. What happens if netback is reloaded against a
> > netfront that has already enabled 'feature-xdp'? AFAICT vif->xdp_enabled
> > would remain false after the reload.
> 
> in this case xennect_connect() should call talk_to_netback()
> and the function will restore the state from info->netfront_xdp_enabled
> 

No. You're assuming the frontend is aware the backend has been reloaded. It is not.

  Paul


