Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E813712DAA4
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 18:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfLaRgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 12:36:25 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36072 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbfLaRgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 12:36:25 -0500
Received: by mail-pg1-f196.google.com with SMTP id k3so19780480pgc.3
        for <netdev@vger.kernel.org>; Tue, 31 Dec 2019 09:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rxfaHkXKX3dW0j+TLga3KkTDceUMiNP8v7GomX4HCNo=;
        b=uwK0PzaiDkiF8uFWPr0xQhQYYUiVGwbjESLDO7Yj5GeEqwVppZ51P3Yduyw8BPX3sv
         7dKyUO4wGTbv/ozSNGyTvu3kkVM5xqwxQgY0+G30BvBy3kXW+FlxyJZiVpoAYGG8EgjH
         xNYJlRvPazZzxmKWkPhvcIPPZl20QdoRPe8iEeBWXdpHCH121uK0TXTdmnXtKQXVXbQV
         G2G+QqBZfEYD8r6Fun55cfnY3uugk/PggyKnJr9D4JSfujfV8vXad73mVgY2W6XsYMiU
         KtZbUucMbA6R5XvXYnrDSrlrtylO84C24K5kWYjzROZ8VytKfqCEJFf4tjAk1tsZeOfI
         V3DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rxfaHkXKX3dW0j+TLga3KkTDceUMiNP8v7GomX4HCNo=;
        b=KWvtcihtWJ0ViMXkOetwQYYNyK0uCnASNPGiGTVquJ4lKBEahcxm6rSXSVCfaQUbyT
         WZb7nCGslGn4O+Ti9Knduxw4cV2LaiwfjjcMmuWCO+R5POCXJ7QOznKTqsuUiaxVRWWd
         I/0bZ+zHhMftkBEQUt8u89Wv8gmZJnilsthjRZTkwsikIVguCdASRd2xJ9oaH465Md8j
         9u1QDlFHT13Boi6uEowx+KfsGWHUwd63ryokFD1XrBpc2UhX4jUmqOomeJ77tgkYR8HP
         YfD6iD8/osPl/4CqKhmpOtHtdUkpeZgqno4PWgZI3+xzownvSS2dWiCuGuYjVPiW6uZ/
         X28Q==
X-Gm-Message-State: APjAAAXSMhNYHkARokTF27JuPgdbhLucAl31Jlbynqqz7bNjJesBaUGk
        gJv4xN/F2J7qfDyKGOwHpFzwnA==
X-Google-Smtp-Source: APXvYqxwQsX9X2MBIsz19PQbLZJM9i986pmHP6YiVPSl71d1NGiH8Y8pwJ+8gTEaLdxOwpzhUS4efw==
X-Received: by 2002:aa7:9f47:: with SMTP id h7mr75938899pfr.13.1577813784362;
        Tue, 31 Dec 2019 09:36:24 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a9sm29370162pfn.38.2019.12.31.09.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Dec 2019 09:36:24 -0800 (PST)
Date:   Tue, 31 Dec 2019 09:36:14 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Roman Kagan <rkagan@virtuozzo.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
 offer sequence and use async probe
Message-ID: <20191231093614.75da9bea@hermes.lan>
In-Reply-To: <MN2PR21MB1375D41039A8A68A2117DDFCCA260@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
        <1577736814-21112-4-git-send-email-haiyangz@microsoft.com>
        <20191231113440.GA380228@rkaganb.sw.ru>
        <MN2PR21MB1375D41039A8A68A2117DDFCCA260@MN2PR21MB1375.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Dec 2019 16:12:36 +0000
Haiyang Zhang <haiyangz@microsoft.com> wrote:

> > -----Original Message-----
> > From: Roman Kagan <rkagan@virtuozzo.com>
> > Sent: Tuesday, December 31, 2019 6:35 AM
> > To: Haiyang Zhang <haiyangz@microsoft.com>
> > Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org; netdev@vger.kernel.org;
> > KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> > <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> > <vkuznets@redhat.com>; davem@davemloft.net; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
> > offer sequence and use async probe
> > 
> > On Mon, Dec 30, 2019 at 12:13:34PM -0800, Haiyang Zhang wrote:  
> > > The dev_num field in vmbus channel structure is assigned to the first
> > > available number when the channel is offered. So netvsc driver uses it
> > > for NIC naming based on channel offer sequence. Now re-enable the
> > > async probing mode for faster probing.
> > >
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > ---
> > >  drivers/net/hyperv/netvsc_drv.c | 18 +++++++++++++++---
> > >  1 file changed, 15 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/hyperv/netvsc_drv.c
> > > b/drivers/net/hyperv/netvsc_drv.c index f3f9eb8..39c412f 100644
> > > --- a/drivers/net/hyperv/netvsc_drv.c
> > > +++ b/drivers/net/hyperv/netvsc_drv.c
> > > @@ -2267,10 +2267,14 @@ static int netvsc_probe(struct hv_device *dev,
> > >  	struct net_device_context *net_device_ctx;
> > >  	struct netvsc_device_info *device_info = NULL;
> > >  	struct netvsc_device *nvdev;
> > > +	char name[IFNAMSIZ];
> > >  	int ret = -ENOMEM;
> > >
> > > -	net = alloc_etherdev_mq(sizeof(struct net_device_context),
> > > -				VRSS_CHANNEL_MAX);
> > > +	snprintf(name, IFNAMSIZ, "eth%d", dev->channel->dev_num);  
> > 
> > How is this supposed to work when there are other ethernet device types on the
> > system, which may claim the same device names?
> >   
> > > +	net = alloc_netdev_mqs(sizeof(struct net_device_context), name,
> > > +			       NET_NAME_ENUM, ether_setup,
> > > +			       VRSS_CHANNEL_MAX, VRSS_CHANNEL_MAX);
> > > +
> > >  	if (!net)
> > >  		goto no_net;
> > >
> > > @@ -2355,6 +2359,14 @@ static int netvsc_probe(struct hv_device *dev,
> > >  		net->max_mtu = ETH_DATA_LEN;
> > >
> > >  	ret = register_netdevice(net);
> > > +
> > > +	if (ret == -EEXIST) {
> > > +		pr_info("NIC name %s exists, request another name.\n",
> > > +			net->name);
> > > +		strlcpy(net->name, "eth%d", IFNAMSIZ);
> > > +		ret = register_netdevice(net);
> > > +	}  
> > 
> > IOW you want the device naming to be predictable, but don't guarantee this?
> > 
> > I think the problem this patchset is trying to solve is much better solved with a
> > udev rule, similar to how it's done for PCI net devices.
> > And IMO the primary channel number, being a device's "hardware"
> > property, is more suited to be used in the device name, than this completely
> > ephemeral device number.  
> 
> The vmbus number can be affected by other types of devices and/or subchannel
> offerings. They are not stable either. That's why this patch set keeps track of the 
> offering sequence within the same device type in a new variable "dev_num".
> 
> As in my earlier email, to avoid impact by other types of NICs, we should put them
> into different naming formats, like "vf*", "enP*", etc. And yes, these can be done in
> udev.
> 
> But for netvsc (synthetic) NICs, we still want the default naming format "eth*". And
> the variable "dev_num" gives them the basis for stable naming with Async probing.
> 
> Thanks,
> - Haiyang
> 

The primary requirements for network naming are:
  1. Network names must be repeatable on each boot. This was the original problem
     that PCI devices discovered back years ago when parallel probing was enabled.
  2. Network names must be predictable. If new VM is created, the names should
     match a similar VM config.
  3. Names must be persistent. If a NIC is added or deleted, the existing names
     must not change.

The other things which are important (and this proposal breaks):
  1. Don't break it principle: an existing VM should not suddenly get interfaces
     renamed if kernel is upgraded. A corrallary is that a lot of current userspace
     code expects eth0. It doesn't look like first interface would be guaranteed
     to be eth0.

  2. No snowflakes principle: a device driver should follow the current practice
     of other devices. For netvsc, this means VMBus should act like PCI as much
     as possible. Is there another driver doing this already?

  3. Userspace policy principle: Every distribution has its own policy by now.
     The solution must make netvsc work reliably on Redhat (udev), Ubuntu (netplan), SuSE (Yast)
     doing something in the kernel violates #2.

My recommendation would be to take a multi-phase approach:
  1. Expose persistent value in sysfs now.
  2. Work with udev/netplan/... to use that value. 
  3. Make parallel VMBus probing an option. So that when distributions have picked up
     the udev changes they can enable parallel probe. Some will be quick to adopt
     and the enterprise laggards can get to it when they feel the heat.

Long term wish list (requires host side changes):
   1. The interface index could be a host side property; the host networking
       already has the virtual device table and it is persistent.
   2. The Azure NIC name should be visible as a property in guest. 
      Then userspace could do rename based on that property.
      Having multiple disconnected names is leads to confusion.
