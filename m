Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C388A1CD96B
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbgEKMLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729022AbgEKMLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:11:38 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB89FC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 05:11:37 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id se13so1016249ejb.9
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 05:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=EtiKfKcQ6KqpYMBVweyRxrIXwgzGkKhniIFS9alI98o=;
        b=2O3QaWu9HYWzY+CdWNyY4aq7OsIo0fvkmiDyOq+L+ATOl00oiTddTuKGZ38S0QOa5x
         DR4CKBONQ1EdoBRdT3pcU+Xry/dS/UkDrWPAZTYxizM2lwVtmD8cvyfWXj7XsVQSZztI
         sFYz3MFRB3+aa2iOe+29r/UPGoJ7JXe3Afd8faHWAyxMucAP70yQPCM9CIKEft5lQH71
         Utl1WXt+3C082uXoXDm8XFhlnC5OFN4Q/EIJDUSv8YeqJ4YTE/AbkKIs6M/QIsSE9ABy
         2BFmBNu5YhO6lrhVdunpuEgguWQ2gQhxzRGpURsOYRV1bc0RouiiPCzOQVhH56zipH7z
         OY/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=EtiKfKcQ6KqpYMBVweyRxrIXwgzGkKhniIFS9alI98o=;
        b=B9uN+3T65E0xC4CrQhg9+A0X8HM3Mqa5OuwE4xPqiZaXl2tx7gax+B2tGFrR0+RPHn
         eKH0rENeyU1McknDfADPW6WRm3UppVoRKeReRWLBIRTPVPfXupeKKqZN343yVriZ+3lo
         6rdouncacMMuPQxBB/aM9j62yxF1obOA9g99GrO7CacZ+sKcFPQRNzZLAR7gd8HMUVWr
         8YNqyZixELeK5XMggCPABtK1+AmyTFk1jqlw0Hq+qrEYy1BShn375OS5eP2B3oHgKp3v
         kHkgrBfAse6p/ivtJaJUxxUeqLuJ1zTa1l62HNGrGMmLnIH9UNKYqyZv/DVCY/FBgMXb
         b/KA==
X-Gm-Message-State: AGi0PuahjvAHMtqXm/WkDnmYorOh/Jp1RLNf8QS1CLC+m0+6ttZcPx1A
        3Xh/pfpwA6URB9YQWpzwKQ4x9aLw3T+P3KwjxGnf/A==
X-Google-Smtp-Source: APiQypICgkkBoMX9+LNpg3fUHmHLrigbWglE22JATlpOL9pi9r6Oek4bP4+6Tl396s/KpXvNb4Ujv604YAZWPf010oM=
X-Received: by 2002:a17:906:4c8e:: with SMTP id q14mr13627870eju.208.1589199096618;
 Mon, 11 May 2020 05:11:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:7497:0:0:0:0:0 with HTTP; Mon, 11 May 2020 05:11:36
 -0700 (PDT)
X-Originating-IP: [5.35.46.227]
In-Reply-To: <000c01d62787$f2e59a10$d8b0ce30$@xen.org>
References: <1589192541-11686-1-git-send-email-kda@linux-powerpc.org>
 <1589192541-11686-3-git-send-email-kda@linux-powerpc.org> <000c01d62787$f2e59a10$d8b0ce30$@xen.org>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 11 May 2020 15:11:36 +0300
Message-ID: <CAOJe8K0UqZmc9nDYC2OZRnhvE-LgUjuta_-33Of6=wVVSCDnwg@mail.gmail.com>
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
>> Sent: 11 May 2020 11:22
>> To: netdev@vger.kernel.org
>> Cc: brouer@redhat.com; jgross@suse.com; wei.liu@kernel.org; paul@xen.org;
>> ilias.apalodimas@linaro.org
>> Subject: [PATCH net-next v9 2/2] xen networking: add XDP offset adjustment
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
>> index ef58870..c97c98e 100644
>> --- a/drivers/net/xen-netback/rx.c
>> +++ b/drivers/net/xen-netback/rx.c
>> @@ -33,6 +33,11 @@
>>  #include <xen/xen.h>
>>  #include <xen/events.h>
>>
>> +static int xenvif_rx_xdp_offset(struct xenvif *vif)
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
>> index 286054b..d447191 100644
>> --- a/drivers/net/xen-netback/xenbus.c
>> +++ b/drivers/net/xen-netback/xenbus.c
>> @@ -393,6 +393,20 @@ static void set_backend_state(struct backend_info
>> *be,
>>  	}
>>  }
>>
>> +static void read_xenbus_frontend_xdp(struct backend_info *be,
>> +				     struct xenbus_device *dev)
>> +{
>> +	struct xenvif *vif = be->vif;
>> +	unsigned int val;
>> +	int err;
>> +
>> +	err = xenbus_scanf(XBT_NIL, dev->otherend,
>> +			   "feature-xdp", "%u", &val);
>> +	if (err != 1)
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
> I think this being the only call to read_xenbus_frontend_xdp() is still a
> problem. What happens if netback is reloaded against a
> netfront that has already enabled 'feature-xdp'? AFAICT vif->xdp_enabled
> would remain false after the reload.

in this case xennect_connect() should call talk_to_netback()
and the function will restore the state from info->netfront_xdp_enabled

>
>   Paul
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
>> +				    provides_xdp_headroom);
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
