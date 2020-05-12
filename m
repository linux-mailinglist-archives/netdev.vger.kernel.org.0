Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818221CF441
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 14:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgELMUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 08:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728283AbgELMUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 08:20:33 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B227BC061A0E
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 05:20:32 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id s19so570417edt.12
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 05:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=dfndLEAFWMHiq8PNDhbKXZ6w0PxFKtDzhdO+tfGbV1I=;
        b=jXk/FUwbyve9z2Vq16vIf5W+44E6SqIdp7NadEZ50vBU79j2LGR5nvSRDsiVJ98diI
         TP5rCdB03nhhF6gm4afBRcWT3Gg4qGpS1DFpNvw8l7CQ1QRQDpX9NWx8lBfACqaKaRLx
         q3xiP2WnUiSnDH68eAU1m9io/SICFFWGVxdMGHLOuffF2IFZg3CUvGM2Aa5Zn9ooTB9X
         v+wj+tet/+NPMtMK5EzaEnJ0EfSFSKqMsiZFWteULacGY/Y7XjfWUlNB66WL/P5l4aCQ
         9ZrMk9uv7IRn/Gf3pSIQHUcCHuqtJMmQwq7W6U/9qjsIqj1clYYiXi0g2USQqoo/PKFq
         pA7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=dfndLEAFWMHiq8PNDhbKXZ6w0PxFKtDzhdO+tfGbV1I=;
        b=bSgx84e4/qE3eJTiU/WcW2TRl518YPdnGGEMr55ptUMWIfXvJb9/jeD8tdgSXttxmn
         YNv8DQE2Zo52mtX2b8nbnwafAp4+50BxUchh13nWclzCHDp2bnC2mBA30CT8IDpopCrs
         QPjVpw5EYPt44pJ87F84PIhT2iGIjnjA2aASW0SeG8MUAZGWumGD/Hpd/LYeZTbMIw4h
         vw5g5ioJl6Ox8MacIQrSs95ciDrXb0opoxDtuJMyg8U3N5tIJkbACXU+vLuLPSJKjeTa
         2C0yf/kmy2fDXOTK8RxO07b/BzB3oCxUSH/hL3UQBPfkTR4mPcxxOOyfi+O9uHWHcdEZ
         518A==
X-Gm-Message-State: AGi0Puaau8kNfgvKP2aLBiO4R5ycrNJ1D0jySJiRITABqqZiatS9zxZg
        MCcy3OJ4JSRoRM0EFJ9S57dlcmE5hu2W3/3B06Be8g==
X-Google-Smtp-Source: APiQypI5M3tIAgW1oeY88MuuQ1jQY7PsOWLzmWcKtrMp8mfWy8c3JUyRAWTXOqefzjLfW/pxecaQgCQ1AvoMt8nlI2M=
X-Received: by 2002:aa7:d342:: with SMTP id m2mr17264432edr.130.1589286031413;
 Tue, 12 May 2020 05:20:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:7497:0:0:0:0:0 with HTTP; Tue, 12 May 2020 05:20:30
 -0700 (PDT)
X-Originating-IP: [5.35.46.227]
In-Reply-To: <002e01d6282e$b94ee390$2becaab0$@xen.org>
References: <1589192541-11686-1-git-send-email-kda@linux-powerpc.org>
 <1589192541-11686-3-git-send-email-kda@linux-powerpc.org> <000c01d62787$f2e59a10$d8b0ce30$@xen.org>
 <CAOJe8K0UqZmc9nDYC2OZRnhvE-LgUjuta_-33Of6=wVVSCDnwg@mail.gmail.com>
 <000e01d6278d$ab04aa50$010dfef0$@xen.org> <CAOJe8K2uoDvD5MJOuhB0wTNL7w4PROQyrifzhrCANkrJ2quY=A@mail.gmail.com>
 <002e01d6282e$b94ee390$2becaab0$@xen.org>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 12 May 2020 15:20:30 +0300
Message-ID: <CAOJe8K0sD8awo+A3YLycJ6P8fNt9Y3XtY9eb7eysu33jej_fBg@mail.gmail.com>
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

On 5/12/20, Paul Durrant <xadimgnik@gmail.com> wrote:
>> -----Original Message-----
>> From: Denis Kirjanov <kda@linux-powerpc.org>
>> Sent: 11 May 2020 18:22
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
>> >> Sent: 11 May 2020 13:12
>> >> To: paul@xen.org
>> >> Cc: netdev@vger.kernel.org; brouer@redhat.com; jgross@suse.com;
>> >> wei.liu@kernel.org;
>> >> ilias.apalodimas@linaro.org
>> >> Subject: Re: [PATCH net-next v9 2/2] xen networking: add XDP offset
>> >> adjustment to xen-netback
>> >>
>> >> On 5/11/20, Paul Durrant <xadimgnik@gmail.com> wrote:
>> >> >> -----Original Message-----
>> >> >> From: Denis Kirjanov <kda@linux-powerpc.org>
>> >> >> Sent: 11 May 2020 11:22
>> >> >> To: netdev@vger.kernel.org
>> >> >> Cc: brouer@redhat.com; jgross@suse.com; wei.liu@kernel.org;
>> >> >> paul@xen.org;
>> >> >> ilias.apalodimas@linaro.org
>> >> >> Subject: [PATCH net-next v9 2/2] xen networking: add XDP offset
>> >> >> adjustment
>> >> >> to xen-netback
>> >> >>
>> >> >> the patch basically adds the offset adjustment and netfront
>> >> >> state reading to make XDP work on netfront side.
>> >> >>
>> >> >> Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
>> >> >> ---
>> >> >>  drivers/net/xen-netback/common.h  |  2 ++
>> >> >>  drivers/net/xen-netback/netback.c |  7 +++++++
>> >> >>  drivers/net/xen-netback/rx.c      |  7 ++++++-
>> >> >>  drivers/net/xen-netback/xenbus.c  | 28
>> >> >> ++++++++++++++++++++++++++++
>> >> >>  4 files changed, 43 insertions(+), 1 deletion(-)
>> >> >>
>> >> >> diff --git a/drivers/net/xen-netback/common.h
>> >> >> b/drivers/net/xen-netback/common.h
>> >> >> index 05847eb..4a148d6 100644
>> >> >> --- a/drivers/net/xen-netback/common.h
>> >> >> +++ b/drivers/net/xen-netback/common.h
>> >> >> @@ -280,6 +280,7 @@ struct xenvif {
>> >> >>  	u8 ip_csum:1;
>> >> >>  	u8 ipv6_csum:1;
>> >> >>  	u8 multicast_control:1;
>> >> >> +	u8 xdp_enabled:1;
>> >> >>
>> >> >>  	/* Is this interface disabled? True when backend discovers
>> >> >>  	 * frontend is rogue.
>> >> >> @@ -395,6 +396,7 @@ static inline pending_ring_idx_t
>> >> >> nr_pending_reqs(struct xenvif_queue *queue)
>> >> >>  irqreturn_t xenvif_interrupt(int irq, void *dev_id);
>> >> >>
>> >> >>  extern bool separate_tx_rx_irq;
>> >> >> +extern bool provides_xdp_headroom;
>> >> >>
>> >> >>  extern unsigned int rx_drain_timeout_msecs;
>> >> >>  extern unsigned int rx_stall_timeout_msecs;
>> >> >> diff --git a/drivers/net/xen-netback/netback.c
>> >> >> b/drivers/net/xen-netback/netback.c
>> >> >> index 315dfc6..6dfca72 100644
>> >> >> --- a/drivers/net/xen-netback/netback.c
>> >> >> +++ b/drivers/net/xen-netback/netback.c
>> >> >> @@ -96,6 +96,13 @@
>> >> >>  module_param_named(hash_cache_size, xenvif_hash_cache_size, uint,
>> >> >> 0644);
>> >> >>  MODULE_PARM_DESC(hash_cache_size, "Number of flows in the hash
>> >> >> cache");
>> >> >>
>> >> >> +/* The module parameter tells that we have to put data
>> >> >> + * for xen-netfront with the XDP_PACKET_HEADROOM offset
>> >> >> + * needed for XDP processing
>> >> >> + */
>> >> >> +bool provides_xdp_headroom = true;
>> >> >> +module_param(provides_xdp_headroom, bool, 0644);
>> >> >> +
>> >> >>  static void xenvif_idx_release(struct xenvif_queue *queue, u16
>> >> >> pending_idx,
>> >> >>  			       u8 status);
>> >> >>
>> >> >> diff --git a/drivers/net/xen-netback/rx.c
>> >> >> b/drivers/net/xen-netback/rx.c
>> >> >> index ef58870..c97c98e 100644
>> >> >> --- a/drivers/net/xen-netback/rx.c
>> >> >> +++ b/drivers/net/xen-netback/rx.c
>> >> >> @@ -33,6 +33,11 @@
>> >> >>  #include <xen/xen.h>
>> >> >>  #include <xen/events.h>
>> >> >>
>> >> >> +static int xenvif_rx_xdp_offset(struct xenvif *vif)
>> >> >> +{
>> >> >> +	return vif->xdp_enabled ? XDP_PACKET_HEADROOM : 0;
>> >> >> +}
>> >> >> +
>> >> >>  static bool xenvif_rx_ring_slots_available(struct xenvif_queue
>> >> >> *queue)
>> >> >>  {
>> >> >>  	RING_IDX prod, cons;
>> >> >> @@ -356,7 +361,7 @@ static void xenvif_rx_data_slot(struct
>> >> >> xenvif_queue
>> >> >> *queue,
>> >> >>  				struct xen_netif_rx_request *req,
>> >> >>  				struct xen_netif_rx_response *rsp)
>> >> >>  {
>> >> >> -	unsigned int offset = 0;
>> >> >> +	unsigned int offset = xenvif_rx_xdp_offset(queue->vif);
>> >> >>  	unsigned int flags;
>> >> >>
>> >> >>  	do {
>> >> >> diff --git a/drivers/net/xen-netback/xenbus.c
>> >> >> b/drivers/net/xen-netback/xenbus.c
>> >> >> index 286054b..d447191 100644
>> >> >> --- a/drivers/net/xen-netback/xenbus.c
>> >> >> +++ b/drivers/net/xen-netback/xenbus.c
>> >> >> @@ -393,6 +393,20 @@ static void set_backend_state(struct
>> >> >> backend_info
>> >> >> *be,
>> >> >>  	}
>> >> >>  }
>> >> >>
>> >> >> +static void read_xenbus_frontend_xdp(struct backend_info *be,
>> >> >> +				     struct xenbus_device *dev)
>> >> >> +{
>> >> >> +	struct xenvif *vif = be->vif;
>> >> >> +	unsigned int val;
>> >> >> +	int err;
>> >> >> +
>> >> >> +	err = xenbus_scanf(XBT_NIL, dev->otherend,
>> >> >> +			   "feature-xdp", "%u", &val);
>> >> >> +	if (err != 1)
>> >> >> +		return;
>> >> >> +	vif->xdp_enabled = val;
>> >> >> +}
>> >> >> +
>> >> >>  /**
>> >> >>   * Callback received when the frontend's state changes.
>> >> >>   */
>> >> >> @@ -417,6 +431,11 @@ static void frontend_changed(struct
>> >> >> xenbus_device
>> >> >> *dev,
>> >> >>  		set_backend_state(be, XenbusStateConnected);
>> >> >>  		break;
>> >> >>
>> >> >> +	case XenbusStateReconfiguring:
>> >> >> +		read_xenbus_frontend_xdp(be, dev);
>> >> >
>> >> > I think this being the only call to read_xenbus_frontend_xdp() is
>> >> > still
>> >> > a
>> >> > problem. What happens if netback is reloaded against a
>> >> > netfront that has already enabled 'feature-xdp'? AFAICT
>> >> > vif->xdp_enabled
>> >> > would remain false after the reload.
>> >>
>> >> in this case xennect_connect() should call talk_to_netback()
>> >> and the function will restore the state from
>> >> info->netfront_xdp_enabled
>> >>
>> >
>> > No. You're assuming the frontend is aware the backend has been reloaded.
>> > It
>> > is not.
>>
>> Hi Paul,
>>
>> I've tried to unbind/bind the device and I can see that the variable
>> is set properly:
>>
>> with enabled XDP:
>> <7>[  622.177935] xen_netback:backend_switch_state: backend/vif/2/0 ->
>> InitWait
>> <7>[  622.179917] xen_netback:frontend_changed:
>> /local/domain/2/device/vif/0 -> Connected
>> <6>[  622.187393] vif vif-2-0 vif2.0: Guest Rx ready
>> <7>[  622.188451] xen_netback:backend_switch_state: backend/vif/2/0 ->
>> Connected
>>
>> localhost:/sys/bus/xen-backend/drivers/vif # xenstore-ls | grep xdp
>>        feature-xdp-headroom = "1"
>>       feature-xdp = "1"
>>
>
> So, that shows me the feature in xenstore. Has netback sampled it and set
> vif->xdp_enabled?

right, what has to be additionally done is:

@@ -947,6 +967,8 @@ static int read_xenbus_vif_flags(struct backend_info *be)
        vif->ipv6_csum = !!xenbus_read_unsigned(dev->otherend,
                                                "feature-ipv6-csum-offload", 0);

+       read_xenbus_frontend_xdp(be, dev);
+
        return 0;
 }

>
>> and with disabled:
>>
>> 7>[  758.216792] xen_netback:frontend_changed:
>> /local/domain/2/device/vif/0 -> Reconfiguring
>
> This I don't understand. What triggered a change of state in the
> frontend...
>
>> <7>[  758.218741] xen_netback:frontend_changed:
>> /local/domain/2/device/vif/0 -> Connected
>
> ...or did these lines occur before you bound netback?
>
>   Paul
>
>> <7>[  784.177247] xen_netback:backend_switch_state: backend/vif/2/0 ->
>> InitWait
>> <7>[  784.180101] xen_netback:frontend_changed:
>> /local/domain/2/device/vif/0 -> Connected
>> <6>[  784.187927] vif vif-2-0 vif2.0: Guest Rx ready
>> <7>[  784.188890] xen_netback:backend_switch_state: backend/vif/2/0 ->
>> Connected
>>
>> localhost:/sys/bus/xen-backend/drivers/vif # xenstore-ls | grep xdp
>>        feature-xdp-headroom = "1"
>>       feature-xdp = "0"
>>
>>
>>
>>
>> >
>> >   Paul
>> >
>> >
>> >
>
>
