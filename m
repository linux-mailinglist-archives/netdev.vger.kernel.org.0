Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB03165DF1
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 13:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgBTM6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 07:58:03 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:12341 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgBTM6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 07:58:03 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: DQl9fXxlcrwCXqm1XMZdzYAl4AupcDPWhlGkyTIyUTBdmL40P1e82GDoCa9p4Y3iOnECXnWDK2
 2Ea+n/UoAkChLpjhxiFbLfvv0YwCsKXt5etWoFNnxqbiJ0Pj7kONAyexWtcbwhEcBe7m6q0+qn
 /8irrb26zOaYzFUxj3U7xbxl/PSbwPccw/f6m/EOvF6M5LvidZJIJDTX6m0RxSZ+mGaVQgLrRS
 faEqBnLs+Mgic7v0wFMiLn0RtnTwCseoK882Pn4l0vnqGLDlSZxIXlQoM0S8dx7S8pqvWuj03f
 2sY=
X-IronPort-AV: E=Sophos;i="5.70,464,1574146800"; 
   d="scan'208";a="66147402"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Feb 2020 05:58:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 20 Feb 2020 05:58:09 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 20 Feb 2020 05:58:01 -0700
Date:   Thu, 20 Feb 2020 13:58:00 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <anirudh.venkataramanan@intel.com>,
        <olteanv@gmail.com>, <andrew@lunn.ch>,
        <jeffrey.t.kirsher@intel.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 00/10] net: bridge: mrp: Add support for Media
 Redundancy Protocol (MRP)
Message-ID: <20200220125800.c3qyc4wxtdt6hv4b@lx-anielsen.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200218121811.xo3o6zzrhl5p3j2s@lx-anielsen.microsemi.net>
 <3afba55f-f953-7aaa-8425-14777db1b27d@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <3afba55f-f953-7aaa-8425-14777db1b27d@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nik,

On 20.02.2020 12:48, Nikolay Aleksandrov wrote:
> In light of all the discussions and details that were explained, and as you've
> noted above, I think more code should be put in kernel space at the very least
> the performance/latency critical parts would benefit from being executed in the
> kernel (kind of control/data-plane separation). It seems from the switchdev calls there's
> a minimal state working set which define the behaviour and can be used to make
> decisions (similar to STP) in the kernel, but the complex logic how to set them can be
> executed in user-space meaning that maybe these hw-offload calls can have a simple SW
> fallback logic based on their current values. I think it is worth considering if this can
> be achieved before going to full in-kernel implementation of the state machine.
> Since you intend to hw-offload it then putting in some SW fallback logic would be good
> when the HW can't offload everything, what you suggest above also sounds good to me and
> I think you'll have to extend mdb and the multicast code to do it, but IIRC you already
> have code to do that based on previous discussions.
Sounds good. We will continue working on defining a good control/data-plane separation
and only keep the data-plane in the kernel. Also it seems that we agree that the SW fallback
of the data-plane should stay in the kernel - we will do that.

> As was already suggested you can put the MRP options in the bridge's options and
> process them from the bridge netlink code, that should simplify your code.
I'm okay with this.

The main argument I see for creating a seperate MRP netlink interface
instead of extending the bridge, is that MRP is properly not the last
bridge protocol we will want to work on.

To complete the MRP-2018 implementation, we will also need some CFM
support (defined in 802.1Qag or the latest version of 802.1Q). And
furhter out we will properly want to implement the full CFM protocol.

DLR may also be relevant at some point, and there may be other.

My main point is, that at some point we will properly want to do
seperate NETLINK interfaces for this. Not sure if that is now or later.

> You could also make the port's "mrp_aware" bool into an internal port
> flag (use net_bridge_port's flags field) so it can be quickly tested
> and in a hot cache line.
Good point, we will do that.

/Allan
