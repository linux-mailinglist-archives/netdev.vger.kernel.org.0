Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C79624B8A
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 21:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiKJURH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 15:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiKJURF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 15:17:05 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4584FF81;
        Thu, 10 Nov 2022 12:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668111423; x=1699647423;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5PLnax8XorRp3Zie4kgXRfWwQFyg+n9E8n1hQRXSQwk=;
  b=1Iglbzheq/lHp0o/cB+aDGpNc61GJ//KOICQj4gxnGJsUGS6jCE6isy6
   OHrDWMcfGYJosZyPibHGrrbDldJojBnVsdsElMsmOsq+VQLA68XfgVQQu
   7I/3RG7SUP/tCW3X9YRAEU8R9vfCJ0WOD/VqY25vzrUn4/ec3fe9hNfPc
   xnItxYDppcJPaVPl1Ge6Saf8OxsTf5Tu3rBXraS2F+W1P7rx348nz58qp
   lmQ44BI0ljPCynkLzuNZKwFLIBkUMy0pv+cstv2f7NaWt6ItgpMjJjuCB
   mrKfjEljAU1pYTXyISYuvYf9fhQF737da7SXppQ+0AFB6aenqDPtALmAN
   g==;
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="186424713"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Nov 2022 13:17:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 10 Nov 2022 13:17:01 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Thu, 10 Nov 2022 13:17:01 -0700
Date:   Thu, 10 Nov 2022 21:21:47 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     Andrew Lunn <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v3 0/4] net: lan966x: Add xdp support
Message-ID: <20221110202147.hkhfvvb55djob43x@soft-dev3-1>
References: <20221109204613.3669905-1-horatiu.vultur@microchip.com>
 <20221110111747.1176760-1-alexandr.lobakin@intel.com>
 <Y20DT2XTTIlU/wbx@lunn.ch>
 <20221110162148.3533816-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221110162148.3533816-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/10/2022 17:21, Alexander Lobakin wrote:

Hi,

> 
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Thu, 10 Nov 2022 14:57:35 +0100
> 
> > > Nice stuff! I hear time to time that XDP is for 10G+ NICs only, but
> > > I'm not a fan of such, and this series proves once again XDP fits
> > > any hardware ^.^
> >
> > The Freescale FEC recently gained XDP support. Many variants of it are
> > Fast Ethernet only.
> >
> > What i found most interesting about that patchset was that the use of
> > the page_ppol API made the driver significantly faster for the general
> > case as well as XDP.
> 
> The driver didn't have any page recycling or page splitting logics,
> while Page Pool recycles even pages from skbs if
> skb_mark_for_recycle() is used, which is the case here. So it
> significantly reduced the number of new page allocations for Rx, if
> there still are any at all.
> Plus, Page Pool allocates pages by bulks (of 16 IIRC), not one by
> one, that reduces CPU overhead as well.

Just to make sure that everything is clear, those results that I have
shown in the cover letter are without any XDP programs on the
interfaces. Because I thought that is the correct comparison of the
results before and after all these changes.

Once I add an XDP program on the interface the performance drops. The
program will look for some ether types and always return XDP_PASS.

These are the results when I have such a XDP program on the interface:
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.01  sec   486 MBytes   408 Mbits/sec    0 sender
[  5]   0.00-10.00  sec   483 MBytes   405 Mbits/sec      receiver

> 
> >
> >      Andrew
> 
> Thanks,
> Olek

-- 
/Horatiu
