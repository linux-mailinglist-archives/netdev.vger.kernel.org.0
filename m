Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C481D1E0B01
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 11:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389646AbgEYJsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 05:48:30 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:54048 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389374AbgEYJsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 05:48:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590400110; x=1621936110;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pzdPx7JJBtptXyJ27Cg1HGCXEq6YG6KTHhH6ZH3PCY0=;
  b=gUae7FOFA1XC9I+yxVz1+qwsJXjlifx03l0WZrAYFw5mLr7H7dpsP58R
   k9jsrzyiwonDezJ465FV1nA6fuvPC12XPy/4f0U4vQB32DhLE8QqmfylO
   Oid81qR1YoaGbJjOIepamM3lM3yu0oR4iH5n/Pgy29KGpMMn0C+5Wh8X8
   PApwOuYyOuGLGVHovOGyOV6SyepLDUqWyqglqMCW19eMQ6DQ4MR39EqJm
   qjQ/D/BoKWInWPRZ5V8iKs63mvJ5T25Lnrps+xHenpxIA2+usALAXXmdW
   LSH02JPS3yp7UDk3OFdlDjVV7Mj5N6LpWSPs+N4EK8cPqhtltDtsh0BoR
   w==;
IronPort-SDR: izbUyP2AtLDrW6QFy3/RCBzlNSwb3grEN3w1QZCgpBLNy3K/Cno44uevHOqUtBtkIIyNOLwGCr
 oywkInRRb7KfB6eW1AjAT5qEos7RmmpQge4Ek3h4w0zbTXxrGr+n0+7J3J9yxOMh1zq71LTvYM
 H5xy/h3aN1HNJs1LsxlPmxgbz9OavGIuQukOODhSxEyZrfq+tCQ1kxErEkIkMr0u1E94tON8MT
 IIzZkQl6C3Kr8sEy/X6XSqYRI/aYTsIuZZZcSQTAF15DPftOSOlC39h9UfNUXzCo45KN+qtKRP
 Htc=
X-IronPort-AV: E=Sophos;i="5.73,433,1583218800"; 
   d="scan'208";a="76964008"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2020 02:48:30 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 25 May 2020 02:48:30 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 25 May 2020 02:48:28 -0700
Date:   Mon, 25 May 2020 11:48:07 +0000
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     <roopa@cumulusnetworks.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: MRP netlink interface
Message-ID: <20200525114807.w7g77ybflb67en3h@soft-dev3.localdomain>
References: <20200525112827.t4nf4lamz6g4g2c5@soft-dev3.localdomain>
 <2176b58f-35f3-36c1-8ba7-d18649eb29f7@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <2176b58f-35f3-36c1-8ba7-d18649eb29f7@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 05/25/2020 12:33, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 25/05/2020 14:28, Horatiu Vultur wrote:
> > Hi,
> >
> > While I was working on adding support for MRA role to MRP, I noticed that I
> > might have some issues with the netlink interface, so it would be great if you
> > can give me an advice on how to continue.
> >
> > First a node with MRA role can behave as a MRM(Manager) or as a
> > MRC(Client). The behaviour is decided by the priority of each node. So
> > to have this functionality I have to extend the MRP netlink interface
> > and this brings me to my issues.
> >
> > My first approach was to extend the 'struct br_mrp_instance' with a field that
> > contains the priority of the node. But this breaks the backwards compatibility,
> > and then every time when I need to change something, I will break the backwards
> > compatibility. Is this a way to go forward?
> >
> > Another approach is to restructure MRP netlink interface. What I was thinking to
> > keep the current attributes (IFLA_BRIDGE_MRP_INSTANCE,
> > IFLA_BRIDGE_MRP_PORT_STATE,...) but they will be nested attributes and each of
> > this attribute to contain the fields of the structures they represents.
> > For example:
> > [IFLA_AF_SPEC] = {
> >     [IFLA_BRIDGE_FLAGS]
> >     [IFLA_BRIDGE_MRP]
> >         [IFLA_BRIDGE_MRP_INSTANCE]
> >             [IFLA_BRIDGE_MRP_INSTANCE_RING_ID]
> >             [IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]
> >             [IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]
> >         [IFLA_BRIDGE_MRP_RING_ROLE]
> >             [IFLA_BRIDGE_MRP_RING_ROLE_RING_ID]
> >             [IFLA_BRIDGE_MRP_RING_ROLE_ROLE]
> >         ...
> > }
> > And then I can parse each field separately and then fill up the structure
> > (br_mrp_instance, br_mrp_port_role, ...) which will be used forward.
> > Then when this needs to be extended with the priority it would have the
> > following format:
> > [IFLA_AF_SPEC] = {
> >     [IFLA_BRIDGE_FLAGS]
> >     [IFLA_BRIDGE_MRP]
> >         [IFLA_BRIDGE_MRP_INSTANCE]
> >             [IFLA_BRIDGE_MRP_INSTANCE_RING_ID]
> >             [IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]
> >             [IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]
> >             [IFLA_BRIDGE_MRP_INSTANCE_PRIO]
> >         [IFLA_BRIDGE_MRP_RING_ROLE]
> >             [IFLA_BRIDGE_MRP_RING_ROLE_RING_ID]
> >             [IFLA_BRIDGE_MRP_RING_ROLE_ROLE]
> >         ...
> > }
> > And also the br_mrp_instance will have a field called prio.
> > So now, if the userspace is not updated to have support for setting the prio
> > then the kernel will use a default value. Then if the userspace contains a field
> > that the kernel doesn't know about, then it would just ignore it.
> > So in this way every time when the netlink interface will be extended it would
> > be backwards compatible.
> >
> > If it is not possible to break the compatibility then the safest way is to
> > just add more attributes under IFLA_BRIDGE_MRP but this would just complicate
> > the kernel and the userspace and it would make it much harder to be extended in
> > the future.
> >
> > My personal choice would be the second approach, even if it breaks the backwards
> > compatibility. Because it is the easier to go forward and there are only 3
> > people who cloned the userspace application
> > (https://github.com/microchip-ung/mrp/graphs/traffic). And two of
> > these unique cloners is me and Allan.
> >
> > So if you have any advice on how to go forward it would be great.
> >
> 
> IIRC this is still in net-next only, right? If so - now would be the time to change it.
> Once it goes into a release, we'll be stuck with workarounds. So I'd go for solution 2).

Yes, this is only in net-next. Then I should ASAP update this with
solution 2.

> 
> I haven't cloned it, but I do sync your user-space mrp repo to check against the patches. :)
> 

-- 
/Horatiu
