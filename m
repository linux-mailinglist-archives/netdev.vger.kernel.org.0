Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2BB1C5CB4
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbgEEP5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729317AbgEEP5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 11:57:11 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893E0C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 08:57:11 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id i185so610913vki.12
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 08:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=e56djFu0RE4aDeLIp1hrhlKjb496KH6Uc48yjp4QOU4=;
        b=XVRTuV/Vp08JF+S4hp6fTgB/yBRIMHnWzDPmbml2ZxtL3YTQT/zGO59rHKgD+aza4b
         yDltRDRrDjqgm2VumFcly0jsknPxn0327rX8hdab2iBRKwO/7DaEd36zkE+WdglWZINV
         XzjwF8YCsGB7YO3dDuMKSBkmkMNZXgIHCChUwO3IgYHVzjd6KT+JCTNFX/5APHKdlVBo
         1aeRBfFkngFWu+eZcE4QKCO+7pJ++XT0qed6tE+zNTQ5EogL+l4r6hKKlQtDmtY+Icxu
         iIplBa+gOoFo95357eOggZGou4Ym9jN1b1U47YyaFkXBW2iktqIzwUxzRPGN4Yq33IaH
         GvaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=e56djFu0RE4aDeLIp1hrhlKjb496KH6Uc48yjp4QOU4=;
        b=EhXiJ+Gfs50aeosQ3pQAMbzo/2Wm3QoRlqnskT4ZUZ6gjpLvhNAf2ai04GNRCcUVTI
         VMLFBEk1HAJ8eFguVHZhN2zXmPfYa3qc33VaFZ3b9TuN+qPU2Deosq5cFWkW75st+Elf
         t23KbuvUn5t18zXuwmYelAxC2pLcmjUtpjLvImc2jS3BSvnSE05DPwsUpZcsM4CmzEDr
         HfXyKOoZW4Qg/RiZQHccFIGBT+A/WxjKDUxzOr17s1gr75HCfx3Qo7yKr90hRnKTugIT
         Wyhy1F236x2lF/Qebsgk3AnKd1zw/Gg6T1QaQWcC9xF/EGen5GUquhXQoa2wRWw5HJcm
         qCpw==
X-Gm-Message-State: AGi0PuZdzi2k0kCdCHk+ZNekVTMEClGoPl4KbGwn42QjMHU1pbIpiluC
        0Q7LZGbcQrZhLfxUVxu3DiunOZV8gP7KU6IPNKyTCw==
X-Google-Smtp-Source: APiQypIyaQrV3OLGLbp9spcb3y9PKd+7nN+YUxCKmuGIBit/bjSCIvkf4dbh0/CAfYmotw1DWdRRmQ29OiyANho3c6M=
X-Received: by 2002:a05:6122:12a:: with SMTP id a10mr3157549vko.51.1588694230724;
 Tue, 05 May 2020 08:57:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:768:0:0:0:0:0 with HTTP; Tue, 5 May 2020 08:57:09 -0700 (PDT)
X-Originating-IP: [5.35.46.227]
In-Reply-To: <004201d622e8$2fff5cf0$8ffe16d0$@xen.org>
References: <1588581474-18345-1-git-send-email-kda@linux-powerpc.org>
 <1588581474-18345-2-git-send-email-kda@linux-powerpc.org> <004201d622e8$2fff5cf0$8ffe16d0$@xen.org>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 5 May 2020 18:57:09 +0300
Message-ID: <CAOJe8K3sByKRgecjYBnm35_Kijaqu0TTruQwvddEu1tkF-TEVg@mail.gmail.com>
Subject: Re: [PATCH net-next v7 2/2] xen networking: add XDP offset adjustment
 to xen-netback
To:     paul@xen.org
Cc:     netdev@vger.kernel.org, jgross@suse.com, wei.liu@kernel.org,
        ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/5/20, Paul Durrant <xadimgnik@gmail.com> wrote:
>> -----Original Message-----
>> From: Denis Kirjanov <kda@linux-powerpc.org>
>> Sent: 04 May 2020 09:38
>> To: netdev@vger.kernel.org
>> Cc: jgross@suse.com; wei.liu@kernel.org; paul@xen.org;
>> ilias.apalodimas@linaro.org
>> Subject: [PATCH net-next v7 2/2] xen networking: add XDP offset adjustment
>> to xen-netback
>>
>> the patch basically adds the offset adjustment and netfront
>> state reading to make XDP work on netfront side.
>>
>> Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
>> ---
>>  drivers/net/xen-netback/common.h  |  2 ++
>>  drivers/net/xen-netback/netback.c |  7 +++++++
>>  drivers/net/xen-netback/rx.c      |  7 ++++++-
>>  drivers/net/xen-netback/xenbus.c  | 28 ++++++++++++++++++++++++++++
>>  4 files changed, 43 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/xen-netback/common.h
>> b/drivers/net/xen-netback/common.h
>> index 05847eb..4a148d6 100644
>> --- a/drivers/net/xen-netback/common.h
>> +++ b/drivers/net/xen-netback/common.h
>> @@ -280,6 +280,7 @@ struct xenvif {
>>  	u8 ip_csum:1;
>>  	u8 ipv6_csum:1;
>>  	u8 multicast_control:1;
>> +	u8 xdp_enabled:1;
>>
>>  	/* Is this interface disabled? True when backend discovers
>>  	 * frontend is rogue.
>> @@ -395,6 +396,7 @@ static inline pending_ring_idx_t
>> nr_pending_reqs(struct xenvif_queue *queue)
>>  irqreturn_t xenvif_interrupt(int irq, void *dev_id);
>>
>>  extern bool separate_tx_rx_irq;
>> +extern bool provides_xdp_headroom;
>>
>>  extern unsigned int rx_drain_timeout_msecs;
>>  extern unsigned int rx_stall_timeout_msecs;
>> diff --git a/drivers/net/xen-netback/netback.c
>> b/drivers/net/xen-netback/netback.c
>> index 315dfc6..6dfca72 100644
>> --- a/drivers/net/xen-netback/netback.c
>> +++ b/drivers/net/xen-netback/netback.c
>> @@ -96,6 +96,13 @@
>>  module_param_named(hash_cache_size, xenvif_hash_cache_size, uint, 0644);
>>  MODULE_PARM_DESC(hash_cache_size, "Number of flows in the hash cache");
>>
>> +/* The module parameter tells that we have to put data
>> + * for xen-netfront with the XDP_PACKET_HEADROOM offset
>> + * needed for XDP processing
>> + */
>> +bool provides_xdp_headroom = true;
>> +module_param(provides_xdp_headroom, bool, 0644);
>> +
>>  static void xenvif_idx_release(struct xenvif_queue *queue, u16
>> pending_idx,
>>  			       u8 status);
>>
>> diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
>> index ef58870..1c0cf8a 100644
>> --- a/drivers/net/xen-netback/rx.c
>> +++ b/drivers/net/xen-netback/rx.c
>> @@ -33,6 +33,11 @@
>>  #include <xen/xen.h>
>>  #include <xen/events.h>
>>
>> +static inline int xenvif_rx_xdp_offset(struct xenvif *vif)
>> +{
>> +	return vif->xdp_enabled ? XDP_PACKET_HEADROOM : 0;
>> +}
>> +
>>  static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
>>  {
>>  	RING_IDX prod, cons;
>> @@ -356,7 +361,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue
>> *queue,
>>  				struct xen_netif_rx_request *req,
>>  				struct xen_netif_rx_response *rsp)
>>  {
>> -	unsigned int offset = 0;
>> +	unsigned int offset = xenvif_rx_xdp_offset(queue->vif);
>>  	unsigned int flags;
>>
>>  	do {
>> diff --git a/drivers/net/xen-netback/xenbus.c
>> b/drivers/net/xen-netback/xenbus.c
>> index 286054b..7c0450e 100644
>> --- a/drivers/net/xen-netback/xenbus.c
>> +++ b/drivers/net/xen-netback/xenbus.c
>> @@ -393,6 +393,20 @@ static void set_backend_state(struct backend_info
>> *be,
>>  	}
>>  }
>>
>> +static void read_xenbus_frontend_xdp(struct backend_info *be,
>> +				      struct xenbus_device *dev)
>> +{
>> +	struct xenvif *vif = be->vif;
>> +	unsigned int val;
>> +	int err;
>> +
>> +	err = xenbus_scanf(XBT_NIL, dev->otherend,
>> +			   "feature-xdp", "%u", &val);
>> +	if (err < 0)
>
> xenbus_scanf() returns the number of successfully parsed values so you ought
> to be checking for != 1 here.

right, makes sense.

>
>> +		return;
>> +	vif->xdp_enabled = val;
>> +}
>> +
>>  /**
>>   * Callback received when the frontend's state changes.
>>   */
>> @@ -417,6 +431,11 @@ static void frontend_changed(struct xenbus_device
>> *dev,
>>  		set_backend_state(be, XenbusStateConnected);
>>  		break;
>>
>> +	case XenbusStateReconfiguring:
>> +		read_xenbus_frontend_xdp(be, dev);
>
> Is the frontend always expected to trigger a re-configure, or could
> feature-xdp already be enabled prior to connection?

Yes, feature-xdp is set by the frontend when  xdp code is loaded.

>
>> +		xenbus_switch_state(dev, XenbusStateReconfigured);
>> +		break;
>> +
>>  	case XenbusStateClosing:
>>  		set_backend_state(be, XenbusStateClosing);
>>  		break;
>> @@ -1036,6 +1055,15 @@ static int netback_probe(struct xenbus_device
>> *dev,
>>  			goto abort_transaction;
>>  		}
>>
>> +		/* we can adjust a headroom for netfront XDP processing */
>> +		err = xenbus_printf(xbt, dev->nodename,
>> +				    "feature-xdp-headroom", "%d",
>> +				    !!provides_xdp_headroom);
>
> provides_xdp_headroom is bool so the !! ought to be unnecessary.

Ok, will post the updated version shortly.

Thanks for review!

>
>   Paul
>
>> +		if (err) {
>> +			message = "writing feature-xdp-headroom";
>> +			goto abort_transaction;
>> +		}
>> +
>>  		/* We don't support rx-flip path (except old guests who
>>  		 * don't grok this feature flag).
>>  		 */
>> --
>> 1.8.3.1
>
>
>
