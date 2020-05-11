Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150121CE190
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 19:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730968AbgEKRVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 13:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730966AbgEKRVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 13:21:51 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A1DC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 10:21:51 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l3so8664444edq.13
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 10:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=yiW9LUPIRYoA9iiJ9jh0xeAV8UJwIxUC4UVVxKfT1qA=;
        b=G73iO8R7SeivZkRdFV87B0IsQCdbGLaj0LXk6bZ/YnSU/wXWcDsuxWRfCkJCPNWOFm
         yfrNp+1iaBmnLLK02WJeXUKRTZ1gAx6s7JgYZq0hBtnhwEw9B7YxAAImRdG6oeuqgakX
         dDshAjNyLRjynq3Nup+577rc6BKH8fJFVAQiok68gYkZhtnNpoe2IgzhXBofpKws5pP4
         Vr12Cz+qk791IBt/8zqOCJw7RnHTuEg2yM6sFmJQRvGMmKP4fnsWPEKm1JXItwy99WGZ
         XMvDb20wZ4F9BFxC6ZSUOEBQ/fb5P27PYilZYALrjJV39mOrEwQ56xYfbU0y/4v95Mee
         96uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=yiW9LUPIRYoA9iiJ9jh0xeAV8UJwIxUC4UVVxKfT1qA=;
        b=WwFMp3gmeCS2xg2c28eXmOY+5YoBW0Wzs1FlE7o4WddvCvv9wjlStONA3NeJMOqjER
         wU7XYIaQxfQ3kXL6h+BFC46XVz9Rqy0jXFJJz/e7zpFQl9KgKMsJqw+UiW2JpQ3Q3x1b
         /pRLNvcQPUkQUt+pjdpwAA9kWTaGvpDJ6LBTl2MQCpvWaMEDektLQEQ5Snjpk5koeA5Q
         UFo/mhZXd7wxelYBi3VTvrb2J3TZ8g7z08osjfnwSQfnXVKX2tZJQiOHW30GotSoxYy4
         cdtmzh9L6fXBt+d6Tt7lElM/BIqtcfS5ElLLz/AV8eJtpNZVg1f9TbfiSuRNOEi7zSxx
         Jgfg==
X-Gm-Message-State: AGi0PuZWyPHue9z3OWxF8LwypIOVLNQ+BRaJYGkEJw733WgAALY4UAjf
        CVSFTT6WKKm8OQB7kciweYtyCf2096FMOAic9BGYabDEwLg=
X-Google-Smtp-Source: APiQypJmdK4KKsaUUz5/9EcLTiSScrdrpuWqpOVEKrtAgPF/4VDq9gCL5OOOxeGdtZPEcVxEhWH7kE19w4+gqHhKTBs=
X-Received: by 2002:aa7:c492:: with SMTP id m18mr14247362edq.346.1589217709932;
 Mon, 11 May 2020 10:21:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:7497:0:0:0:0:0 with HTTP; Mon, 11 May 2020 10:21:49
 -0700 (PDT)
X-Originating-IP: [5.35.46.227]
In-Reply-To: <000e01d6278d$ab04aa50$010dfef0$@xen.org>
References: <1589192541-11686-1-git-send-email-kda@linux-powerpc.org>
 <1589192541-11686-3-git-send-email-kda@linux-powerpc.org> <000c01d62787$f2e59a10$d8b0ce30$@xen.org>
 <CAOJe8K0UqZmc9nDYC2OZRnhvE-LgUjuta_-33Of6=wVVSCDnwg@mail.gmail.com> <000e01d6278d$ab04aa50$010dfef0$@xen.org>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 11 May 2020 20:21:49 +0300
Message-ID: <CAOJe8K2uoDvD5MJOuhB0wTNL7w4PROQyrifzhrCANkrJ2quY=A@mail.gmail.com>
Subject: Re: [PATCH net-next v9 2/2] xen networking: add XDP offset adjustment
 to xen-netback
To:     paul@xen.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, jgross@suse.com,
        wei.liu@kernel.org, ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/11/20, Paul Durrant <xadimgnik@gmail.com> wrote:
>> -----Original Message-----
>> From: Denis Kirjanov <kda@linux-powerpc.org>
>> Sent: 11 May 2020 13:12
>> To: paul@xen.org
>> Cc: netdev@vger.kernel.org; brouer@redhat.com; jgross@suse.com;
>> wei.liu@kernel.org;
>> ilias.apalodimas@linaro.org
>> Subject: Re: [PATCH net-next v9 2/2] xen networking: add XDP offset
>> adjustment to xen-netback
>>
>> On 5/11/20, Paul Durrant <xadimgnik@gmail.com> wrote:
>> >> -----Original Message-----
>> >> From: Denis Kirjanov <kda@linux-powerpc.org>
>> >> Sent: 11 May 2020 11:22
>> >> To: netdev@vger.kernel.org
>> >> Cc: brouer@redhat.com; jgross@suse.com; wei.liu@kernel.org;
>> >> paul@xen.org;
>> >> ilias.apalodimas@linaro.org
>> >> Subject: [PATCH net-next v9 2/2] xen networking: add XDP offset
>> >> adjustment
>> >> to xen-netback
>> >>
>> >> the patch basically adds the offset adjustment and netfront
>> >> state reading to make XDP work on netfront side.
>> >>
>> >> Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
>> >> ---
>> >>  drivers/net/xen-netback/common.h  |  2 ++
>> >>  drivers/net/xen-netback/netback.c |  7 +++++++
>> >>  drivers/net/xen-netback/rx.c      |  7 ++++++-
>> >>  drivers/net/xen-netback/xenbus.c  | 28 ++++++++++++++++++++++++++++
>> >>  4 files changed, 43 insertions(+), 1 deletion(-)
>> >>
>> >> diff --git a/drivers/net/xen-netback/common.h
>> >> b/drivers/net/xen-netback/common.h
>> >> index 05847eb..4a148d6 100644
>> >> --- a/drivers/net/xen-netback/common.h
>> >> +++ b/drivers/net/xen-netback/common.h
>> >> @@ -280,6 +280,7 @@ struct xenvif {
>> >>  	u8 ip_csum:1;
>> >>  	u8 ipv6_csum:1;
>> >>  	u8 multicast_control:1;
>> >> +	u8 xdp_enabled:1;
>> >>
>> >>  	/* Is this interface disabled? True when backend discovers
>> >>  	 * frontend is rogue.
>> >> @@ -395,6 +396,7 @@ static inline pending_ring_idx_t
>> >> nr_pending_reqs(struct xenvif_queue *queue)
>> >>  irqreturn_t xenvif_interrupt(int irq, void *dev_id);
>> >>
>> >>  extern bool separate_tx_rx_irq;
>> >> +extern bool provides_xdp_headroom;
>> >>
>> >>  extern unsigned int rx_drain_timeout_msecs;
>> >>  extern unsigned int rx_stall_timeout_msecs;
>> >> diff --git a/drivers/net/xen-netback/netback.c
>> >> b/drivers/net/xen-netback/netback.c
>> >> index 315dfc6..6dfca72 100644
>> >> --- a/drivers/net/xen-netback/netback.c
>> >> +++ b/drivers/net/xen-netback/netback.c
>> >> @@ -96,6 +96,13 @@
>> >>  module_param_named(hash_cache_size, xenvif_hash_cache_size, uint,
>> >> 0644);
>> >>  MODULE_PARM_DESC(hash_cache_size, "Number of flows in the hash
>> >> cache");
>> >>
>> >> +/* The module parameter tells that we have to put data
>> >> + * for xen-netfront with the XDP_PACKET_HEADROOM offset
>> >> + * needed for XDP processing
>> >> + */
>> >> +bool provides_xdp_headroom = true;
>> >> +module_param(provides_xdp_headroom, bool, 0644);
>> >> +
>> >>  static void xenvif_idx_release(struct xenvif_queue *queue, u16
>> >> pending_idx,
>> >>  			       u8 status);
>> >>
>> >> diff --git a/drivers/net/xen-netback/rx.c
>> >> b/drivers/net/xen-netback/rx.c
>> >> index ef58870..c97c98e 100644
>> >> --- a/drivers/net/xen-netback/rx.c
>> >> +++ b/drivers/net/xen-netback/rx.c
>> >> @@ -33,6 +33,11 @@
>> >>  #include <xen/xen.h>
>> >>  #include <xen/events.h>
>> >>
>> >> +static int xenvif_rx_xdp_offset(struct xenvif *vif)
>> >> +{
>> >> +	return vif->xdp_enabled ? XDP_PACKET_HEADROOM : 0;
>> >> +}
>> >> +
>> >>  static bool xenvif_rx_ring_slots_available(struct xenvif_queue
>> >> *queue)
>> >>  {
>> >>  	RING_IDX prod, cons;
>> >> @@ -356,7 +361,7 @@ static void xenvif_rx_data_slot(struct
>> >> xenvif_queue
>> >> *queue,
>> >>  				struct xen_netif_rx_request *req,
>> >>  				struct xen_netif_rx_response *rsp)
>> >>  {
>> >> -	unsigned int offset = 0;
>> >> +	unsigned int offset = xenvif_rx_xdp_offset(queue->vif);
>> >>  	unsigned int flags;
>> >>
>> >>  	do {
>> >> diff --git a/drivers/net/xen-netback/xenbus.c
>> >> b/drivers/net/xen-netback/xenbus.c
>> >> index 286054b..d447191 100644
>> >> --- a/drivers/net/xen-netback/xenbus.c
>> >> +++ b/drivers/net/xen-netback/xenbus.c
>> >> @@ -393,6 +393,20 @@ static void set_backend_state(struct backend_info
>> >> *be,
>> >>  	}
>> >>  }
>> >>
>> >> +static void read_xenbus_frontend_xdp(struct backend_info *be,
>> >> +				     struct xenbus_device *dev)
>> >> +{
>> >> +	struct xenvif *vif = be->vif;
>> >> +	unsigned int val;
>> >> +	int err;
>> >> +
>> >> +	err = xenbus_scanf(XBT_NIL, dev->otherend,
>> >> +			   "feature-xdp", "%u", &val);
>> >> +	if (err != 1)
>> >> +		return;
>> >> +	vif->xdp_enabled = val;
>> >> +}
>> >> +
>> >>  /**
>> >>   * Callback received when the frontend's state changes.
>> >>   */
>> >> @@ -417,6 +431,11 @@ static void frontend_changed(struct xenbus_device
>> >> *dev,
>> >>  		set_backend_state(be, XenbusStateConnected);
>> >>  		break;
>> >>
>> >> +	case XenbusStateReconfiguring:
>> >> +		read_xenbus_frontend_xdp(be, dev);
>> >
>> > I think this being the only call to read_xenbus_frontend_xdp() is still
>> > a
>> > problem. What happens if netback is reloaded against a
>> > netfront that has already enabled 'feature-xdp'? AFAICT
>> > vif->xdp_enabled
>> > would remain false after the reload.
>>
>> in this case xennect_connect() should call talk_to_netback()
>> and the function will restore the state from info->netfront_xdp_enabled
>>
>
> No. You're assuming the frontend is aware the backend has been reloaded. It
> is not.

Hi Paul,

I've tried to unbind/bind the device and I can see that the variable
is set properly:

with enabled XDP:
<7>[  622.177935] xen_netback:backend_switch_state: backend/vif/2/0 -> InitWait
<7>[  622.179917] xen_netback:frontend_changed:
/local/domain/2/device/vif/0 -> Connected
<6>[  622.187393] vif vif-2-0 vif2.0: Guest Rx ready
<7>[  622.188451] xen_netback:backend_switch_state: backend/vif/2/0 -> Connected

localhost:/sys/bus/xen-backend/drivers/vif # xenstore-ls | grep xdp
       feature-xdp-headroom = "1"
      feature-xdp = "1"

and with disabled:

7>[  758.216792] xen_netback:frontend_changed:
/local/domain/2/device/vif/0 -> Reconfiguring
<7>[  758.218741] xen_netback:frontend_changed:
/local/domain/2/device/vif/0 -> Connected
<7>[  784.177247] xen_netback:backend_switch_state: backend/vif/2/0 -> InitWait
<7>[  784.180101] xen_netback:frontend_changed:
/local/domain/2/device/vif/0 -> Connected
<6>[  784.187927] vif vif-2-0 vif2.0: Guest Rx ready
<7>[  784.188890] xen_netback:backend_switch_state: backend/vif/2/0 -> Connected

localhost:/sys/bus/xen-backend/drivers/vif # xenstore-ls | grep xdp
       feature-xdp-headroom = "1"
      feature-xdp = "0"




>
>   Paul
>
>
>
