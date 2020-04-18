Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5111AF16B
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 17:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgDRPEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 11:04:02 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:65410 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgDRPEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 11:04:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587222242; x=1618758242;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P9QFx2m+EdJ/Sth2lo4BRux+9U5rJNWn4YuJ3jtIOzo=;
  b=Opwic/DtKR4PaGtUgfDQ4B7TZeNMjVTBYxsiK2PgiFXgKuvHosSiIcN1
   48oxBUmCE7oyqDVRgSOQFOA3c+He6Uj/u2IfVg/Wt7aj72cBO7fDJ2IqI
   jUwf7sbhZZJ5ZIlWomHXegvKT5ujp/noIw04FwBVs6Z8mSmDPDhqLyFGA
   IgwKZGoLTrak1G+S4Z01miN24XXNi27kNUv7aPFv0gltC71F84xMog2h4
   y6LAt/PRzKo3NSoNXjPYxX2Q0kNnU0nznBnhfR7rYKktkFvpix/uydxG8
   9/9X96QB8xeYGEI8/3PRNHPZkcUEV+vId11bk62+j9DIE4T5Sz8FrgyAO
   A==;
IronPort-SDR: m7UcQDlev/MKt25edmp7CE/m0IENiTcZaDPWD8ceyvWol8WUyzRYDRfwZGSvJDCwktDKYlJhdv
 zova4dlOsJ+O0w24fAC3g8ZY5heKnK8FbwEOoEdQDRaof1nLJes/a82bgUqN8wfCLhGckv4bZ2
 e2ezL5uEzWJ17uLjStcDpP27Katm+mLag5egXFW9yGSvIEzR/kAfI134xrSVjdibjiHCstvrkj
 KZ2EdDzT+rAdenqomMynesgheJDMNLkwL/sieSaZwX81nig3xxw1LKDr1VRp9sPMO0/Izd5XS5
 e18=
X-IronPort-AV: E=Sophos;i="5.72,399,1580799600"; 
   d="scan'208";a="70766323"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Apr 2020 08:04:01 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 18 Apr 2020 08:04:06 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sat, 18 Apr 2020 08:04:00 -0700
Date:   Sat, 18 Apr 2020 17:03:59 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     <davem@davemloft.net>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <olteanv@gmail.com>, <andrew@lunn.ch>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v5 0/9] net: bridge: mrp: Add support for Media
 Redundancy Protocol(MRP)
Message-ID: <20200418150359.no4qcgc7oxqunkjp@soft-dev3.microsemi.net>
References: <20200414112618.3644-1-horatiu.vultur@microchip.com>
 <59ccd697-3c97-207e-a89d-f73e594ec7eb@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <59ccd697-3c97-207e-a89d-f73e594ec7eb@cumulusnetworks.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/18/2020 12:01, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 14/04/2020 14:26, Horatiu Vultur wrote:
> > Media Redundancy Protocol is a data network protocol standardized by
> > International Electrotechnical Commission as IEC 62439-2. It allows rings of
> > Ethernet switches to overcome any single failure with recovery time faster than
> > STP. It is primarily used in Industrial Ethernet applications.
> >
> > Based on the previous RFC[1][2][3][4], the MRP state machine and all the timers
> > were moved to userspace, except for the timers used to generate MRP Test frames.
> > In this way the userspace doesn't know and should not know if the HW or the
> > kernel will generate the MRP Test frames. The following changes were added to
> > the bridge to support the MRP:
> > - the existing netlink interface was extended with MRP support,
> > - allow to detect when a MRP frame was received on a MRP ring port
> > - allow MRP instance to forward/terminate MRP frames
> > - generate MRP Test frames in case the HW doesn't have support for this
> >
> > To be able to offload MRP support to HW, the switchdev API  was extend.
> >
> 
> Hi Horatiu,
> The set still has a few blocker issues (bisectability, sysfs error return, use of extack)
> and a few other cleanup tasks as I've noted in my replies to the respective patches.
> I think with those out of the way you can submit it for inclusion.

Hi Nik,

Thanks for the review. I really need to be more careful with the
bisectability. I will update the code based on your comments and then
send the patch series again.

> 
> Cheers,
>  Nik
> 
> 
> 
> 

-- 
/Horatiu
