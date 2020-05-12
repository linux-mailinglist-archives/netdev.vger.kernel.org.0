Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946D11CEE04
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 09:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgELH1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 03:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgELH1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 03:27:01 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E80C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 00:27:01 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id re23so10153870ejb.4
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 00:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=pRA3u0Irev4GvPYlpAYUpUkZZJHBQ+GajOmfbO4uGOc=;
        b=T9XZ2rT8osz0vgNoGaL0hKWyhVuvI6xu5f0zqopt7tDgL5BMoA+QmOplBPJUmgkCD4
         4UfiM09b9jBJFmeM9V1IAvPwCAlPEhmunzmAUyrtKb0WKRUpaWxdfkFWyl3RP5crxFLf
         1+EG7/b1gLMGVj7+MSBa5U/hRcbzAmaGrUPL4OrPiQ3t3hA39shNbFqkRcGL+IMsO3OE
         FdA+SI4BrV4dshF8MU15yYwXoiidP+mTL5mdHVMastmctgibzDU2hc2o4rP8mTIe6rzR
         U1o6DHBqk7pyIl+6D9qiKgcOpdJNos8b3uEQZuw/UXgRm6xlMp0QCCEwbtWRRVMfc5Er
         ie3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:in-reply-to
         :subject:date:message-id:mime-version:content-transfer-encoding
         :content-language:thread-index;
        bh=pRA3u0Irev4GvPYlpAYUpUkZZJHBQ+GajOmfbO4uGOc=;
        b=Dfsk3p8rsDXBCp2oxRH5ai3qPCTraA6a+cS1HZ09scRdO4lEhleJTscSrbTbolqofi
         NBzaWGqSQ0UNi12zJwI9kLBaJmHrcuZtHGjznrVLh4gY56zzEuh2dKN9Qe6Fq18qi9Q6
         XL42Y1cgX8/4v2+8iOZX9apkbsW7tDgCKQHmLaC3KuxTkH4l4LNICWy3syCHzKHMKeYC
         uVcr/PWACM6BGPNpjvUAM3NnnJBdW85M8oA4hFPVyyUlgDy6C5MZ6SaovIUh9nE3rJnU
         K2tOGGzD/zwxk2ZcKOIp53CHOetI35LLI4C6kP9KHcrExIVhxA4BCgK96s5U2ZEU3xPH
         VVNg==
X-Gm-Message-State: AOAM532zFq6VvMiZOxnyyRYX9S45u+QlUrZtqbDBOI3VgrsNTMWzi+Xm
        hpDOJt0Xw11+3oEV8IxhgUY=
X-Google-Smtp-Source: ABdhPJzK9YgfUiKw43iBbBIrV9Z19CHw8xmyxWS6pHlTGmRXomrY5VGat2VtTm1TZwiHK159NkHX/w==
X-Received: by 2002:a17:907:43c2:: with SMTP id i2mr2705348ejs.185.1589268420114;
        Tue, 12 May 2020 00:27:00 -0700 (PDT)
Received: from CBGR90WXYV0 ([54.239.6.185])
        by smtp.gmail.com with ESMTPSA id l29sm218352edj.74.2020.05.12.00.26.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 00:26:59 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: "Paul Durrant" <paul@xen.org>
Reply-To: <paul@xen.org>
To:     "'Denis Kirjanov'" <kda@linux-powerpc.org>
Cc:     <netdev@vger.kernel.org>, <brouer@redhat.com>, <jgross@suse.com>,
        <wei.liu@kernel.org>, <ilias.apalodimas@linaro.org>
References: <1589192541-11686-1-git-send-email-kda@linux-powerpc.org> <1589192541-11686-3-git-send-email-kda@linux-powerpc.org> <000c01d62787$f2e59a10$d8b0ce30$@xen.org> <CAOJe8K0UqZmc9nDYC2OZRnhvE-LgUjuta_-33Of6=wVVSCDnwg@mail.gmail.com> <000e01d6278d$ab04aa50$010dfef0$@xen.org> <CAOJe8K2uoDvD5MJOuhB0wTNL7w4PROQyrifzhrCANkrJ2quY=A@mail.gmail.com>
In-Reply-To: <CAOJe8K2uoDvD5MJOuhB0wTNL7w4PROQyrifzhrCANkrJ2quY=A@mail.gmail.com>
Subject: RE: [PATCH net-next v9 2/2] xen networking: add XDP offset adjustment to xen-netback
Date:   Tue, 12 May 2020 08:26:58 +0100
Message-ID: <002e01d6282e$b94ee390$2becaab0$@xen.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AQIU9PmTVpNq2fLG8JgzWe5HwULahQDzXzdtAsUqzywBx8zP6QEYUqNoAbb/ypGn4/NacA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Denis Kirjanov <kda@linux-powerpc.org>
> Sent: 11 May 2020 18:22
> To: paul@xen.org
> Cc: netdev@vger.kernel.org; brouer@redhat.com; jgross@suse.com; wei.liu@kernel.org;
> ilias.apalodimas@linaro.org
> Subject: Re: [PATCH net-next v9 2/2] xen networking: add XDP offset adjustment to xen-netback
> 
> On 5/11/20, Paul Durrant <xadimgnik@gmail.com> wrote:
> >> -----Original Message-----
> >> From: Denis Kirjanov <kda@linux-powerpc.org>
> >> Sent: 11 May 2020 13:12
> >> To: paul@xen.org
> >> Cc: netdev@vger.kernel.org; brouer@redhat.com; jgross@suse.com;
> >> wei.liu@kernel.org;
> >> ilias.apalodimas@linaro.org
> >> Subject: Re: [PATCH net-next v9 2/2] xen networking: add XDP offset
> >> adjustment to xen-netback
> >>
> >> On 5/11/20, Paul Durrant <xadimgnik@gmail.com> wrote:
> >> >> -----Original Message-----
> >> >> From: Denis Kirjanov <kda@linux-powerpc.org>
> >> >> Sent: 11 May 2020 11:22
> >> >> To: netdev@vger.kernel.org
> >> >> Cc: brouer@redhat.com; jgross@suse.com; wei.liu@kernel.org;
> >> >> paul@xen.org;
> >> >> ilias.apalodimas@linaro.org
> >> >> Subject: [PATCH net-next v9 2/2] xen networking: add XDP offset
> >> >> adjustment
> >> >> to xen-netback
> >> >>
> >> >> the patch basically adds the offset adjustment and netfront
> >> >> state reading to make XDP work on netfront side.
> >> >>
> >> >> Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
> >> >> ---
> >> >>  drivers/net/xen-netback/common.h  |  2 ++
> >> >>  drivers/net/xen-netback/netback.c |  7 +++++++
> >> >>  drivers/net/xen-netback/rx.c      |  7 ++++++-
> >> >>  drivers/net/xen-netback/xenbus.c  | 28 ++++++++++++++++++++++++++++
> >> >>  4 files changed, 43 insertions(+), 1 deletion(-)
> >> >>
> >> >> diff --git a/drivers/net/xen-netback/common.h
> >> >> b/drivers/net/xen-netback/common.h
> >> >> index 05847eb..4a148d6 100644
> >> >> --- a/drivers/net/xen-netback/common.h
> >> >> +++ b/drivers/net/xen-netback/common.h
> >> >> @@ -280,6 +280,7 @@ struct xenvif {
> >> >>  	u8 ip_csum:1;
> >> >>  	u8 ipv6_csum:1;
> >> >>  	u8 multicast_control:1;
> >> >> +	u8 xdp_enabled:1;
> >> >>
> >> >>  	/* Is this interface disabled? True when backend discovers
> >> >>  	 * frontend is rogue.
> >> >> @@ -395,6 +396,7 @@ static inline pending_ring_idx_t
> >> >> nr_pending_reqs(struct xenvif_queue *queue)
> >> >>  irqreturn_t xenvif_interrupt(int irq, void *dev_id);
> >> >>
> >> >>  extern bool separate_tx_rx_irq;
> >> >> +extern bool provides_xdp_headroom;
> >> >>
> >> >>  extern unsigned int rx_drain_timeout_msecs;
> >> >>  extern unsigned int rx_stall_timeout_msecs;
> >> >> diff --git a/drivers/net/xen-netback/netback.c
> >> >> b/drivers/net/xen-netback/netback.c
> >> >> index 315dfc6..6dfca72 100644
> >> >> --- a/drivers/net/xen-netback/netback.c
> >> >> +++ b/drivers/net/xen-netback/netback.c
> >> >> @@ -96,6 +96,13 @@
> >> >>  module_param_named(hash_cache_size, xenvif_hash_cache_size, uint,
> >> >> 0644);
> >> >>  MODULE_PARM_DESC(hash_cache_size, "Number of flows in the hash
> >> >> cache");
> >> >>
> >> >> +/* The module parameter tells that we have to put data
> >> >> + * for xen-netfront with the XDP_PACKET_HEADROOM offset
> >> >> + * needed for XDP processing
> >> >> + */
> >> >> +bool provides_xdp_headroom = true;
> >> >> +module_param(provides_xdp_headroom, bool, 0644);
> >> >> +
> >> >>  static void xenvif_idx_release(struct xenvif_queue *queue, u16
> >> >> pending_idx,
> >> >>  			       u8 status);
> >> >>
> >> >> diff --git a/drivers/net/xen-netback/rx.c
> >> >> b/drivers/net/xen-netback/rx.c
> >> >> index ef58870..c97c98e 100644
> >> >> --- a/drivers/net/xen-netback/rx.c
> >> >> +++ b/drivers/net/xen-netback/rx.c
> >> >> @@ -33,6 +33,11 @@
> >> >>  #include <xen/xen.h>
> >> >>  #include <xen/events.h>
> >> >>
> >> >> +static int xenvif_rx_xdp_offset(struct xenvif *vif)
> >> >> +{
> >> >> +	return vif->xdp_enabled ? XDP_PACKET_HEADROOM : 0;
> >> >> +}
> >> >> +
> >> >>  static bool xenvif_rx_ring_slots_available(struct xenvif_queue
> >> >> *queue)
> >> >>  {
> >> >>  	RING_IDX prod, cons;
> >> >> @@ -356,7 +361,7 @@ static void xenvif_rx_data_slot(struct
> >> >> xenvif_queue
> >> >> *queue,
> >> >>  				struct xen_netif_rx_request *req,
> >> >>  				struct xen_netif_rx_response *rsp)
> >> >>  {
> >> >> -	unsigned int offset = 0;
> >> >> +	unsigned int offset = xenvif_rx_xdp_offset(queue->vif);
> >> >>  	unsigned int flags;
> >> >>
> >> >>  	do {
> >> >> diff --git a/drivers/net/xen-netback/xenbus.c
> >> >> b/drivers/net/xen-netback/xenbus.c
> >> >> index 286054b..d447191 100644
> >> >> --- a/drivers/net/xen-netback/xenbus.c
> >> >> +++ b/drivers/net/xen-netback/xenbus.c
> >> >> @@ -393,6 +393,20 @@ static void set_backend_state(struct backend_info
> >> >> *be,
> >> >>  	}
> >> >>  }
> >> >>
> >> >> +static void read_xenbus_frontend_xdp(struct backend_info *be,
> >> >> +				     struct xenbus_device *dev)
> >> >> +{
> >> >> +	struct xenvif *vif = be->vif;
> >> >> +	unsigned int val;
> >> >> +	int err;
> >> >> +
> >> >> +	err = xenbus_scanf(XBT_NIL, dev->otherend,
> >> >> +			   "feature-xdp", "%u", &val);
> >> >> +	if (err != 1)
> >> >> +		return;
> >> >> +	vif->xdp_enabled = val;
> >> >> +}
> >> >> +
> >> >>  /**
> >> >>   * Callback received when the frontend's state changes.
> >> >>   */
> >> >> @@ -417,6 +431,11 @@ static void frontend_changed(struct xenbus_device
> >> >> *dev,
> >> >>  		set_backend_state(be, XenbusStateConnected);
> >> >>  		break;
> >> >>
> >> >> +	case XenbusStateReconfiguring:
> >> >> +		read_xenbus_frontend_xdp(be, dev);
> >> >
> >> > I think this being the only call to read_xenbus_frontend_xdp() is still
> >> > a
> >> > problem. What happens if netback is reloaded against a
> >> > netfront that has already enabled 'feature-xdp'? AFAICT
> >> > vif->xdp_enabled
> >> > would remain false after the reload.
> >>
> >> in this case xennect_connect() should call talk_to_netback()
> >> and the function will restore the state from info->netfront_xdp_enabled
> >>
> >
> > No. You're assuming the frontend is aware the backend has been reloaded. It
> > is not.
> 
> Hi Paul,
> 
> I've tried to unbind/bind the device and I can see that the variable
> is set properly:
> 
> with enabled XDP:
> <7>[  622.177935] xen_netback:backend_switch_state: backend/vif/2/0 -> InitWait
> <7>[  622.179917] xen_netback:frontend_changed:
> /local/domain/2/device/vif/0 -> Connected
> <6>[  622.187393] vif vif-2-0 vif2.0: Guest Rx ready
> <7>[  622.188451] xen_netback:backend_switch_state: backend/vif/2/0 -> Connected
> 
> localhost:/sys/bus/xen-backend/drivers/vif # xenstore-ls | grep xdp
>        feature-xdp-headroom = "1"
>       feature-xdp = "1"
> 

So, that shows me the feature in xenstore. Has netback sampled it and set vif->xdp_enabled?

> and with disabled:
> 
> 7>[  758.216792] xen_netback:frontend_changed:
> /local/domain/2/device/vif/0 -> Reconfiguring

This I don't understand. What triggered a change of state in the frontend...

> <7>[  758.218741] xen_netback:frontend_changed:
> /local/domain/2/device/vif/0 -> Connected

...or did these lines occur before you bound netback?

  Paul

> <7>[  784.177247] xen_netback:backend_switch_state: backend/vif/2/0 -> InitWait
> <7>[  784.180101] xen_netback:frontend_changed:
> /local/domain/2/device/vif/0 -> Connected
> <6>[  784.187927] vif vif-2-0 vif2.0: Guest Rx ready
> <7>[  784.188890] xen_netback:backend_switch_state: backend/vif/2/0 -> Connected
> 
> localhost:/sys/bus/xen-backend/drivers/vif # xenstore-ls | grep xdp
>        feature-xdp-headroom = "1"
>       feature-xdp = "0"
> 
> 
> 
> 
> >
> >   Paul
> >
> >
> >

