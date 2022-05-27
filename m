Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDDB7535767
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 03:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbiE0Bt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 21:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbiE0Btz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 21:49:55 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE22DE2758;
        Thu, 26 May 2022 18:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653616194; x=1685152194;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kut1lyhhg+8YOva3L1ERzYHZ76rCQIBn6vcFl8mahxg=;
  b=CMShrFktcY0NLyPNxmttBRR/xL8ehJK5Au/otaUsEhJt34VwXKUcY7XQ
   QbjW1KTa2mfHxXx2Fj0OKjyQRQy99LK2y0HxOwrdNkuq5xi0f4OCOFbOr
   +GLiTYL593qQCVl+8dLsMs0kcCGdJwF3gMkzxwGOETKNXBzSetLtuwKZD
   kvkEjDLcpYnGVlBs9xNvv6s3TJlhi/voiiApKirWHm1al0FqXkOrrWjU6
   xYjArUS7ittlou6gYWz3pbFPXHPNTJeenz9hC70qYbzygpUna/+EWmSQ6
   2jX+XiFAurMfrEkyfS1LElxct8PsGNMbiCrwjxC+fi1MRD0lMDS5n6S0R
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="274451648"
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="274451648"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 18:49:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="631230192"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 26 May 2022 18:49:53 -0700
Received: from linux.intel.com (ssid-ilbpg3-teeminta.png.intel.com [10.88.227.74])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 116F7580B54;
        Thu, 26 May 2022 18:49:49 -0700 (PDT)
Date:   Fri, 27 May 2022 09:47:09 +0800
From:   Tan Tee Min <tee.min.tan@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dan Murphy <dmurphy@ti.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Sit Michael Wei Hong <michael.wei.hong.sit@intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: Re: [PATCH net-next v2 1/1] net: phy: dp83867: retrigger SGMII AN
 when link change
Message-ID: <20220527014709.GA26992@linux.intel.com>
References: <20220526090347.128742-1-tee.min.tan@linux.intel.com>
 <Yo9zTmMduwel8XeZ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo9zTmMduwel8XeZ@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 02:32:14PM +0200, Andrew Lunn wrote:
> On Thu, May 26, 2022 at 05:03:47PM +0800, Tan Tee Min wrote:
> > This could cause an issue during power up, when PHY is up prior to MAC.
> > At this condition, once MAC side SGMII is up, MAC side SGMII wouldn`t
> > receive new in-band message from TI PHY with correct link status, speed
> > and duplex info.
> > 
> > As suggested by TI, implemented a SW solution here to retrigger SGMII
> > Auto-Neg whenever there is a link change.
> 
> Is there a bit in the PHY which reports host side link? There is no
> point triggering an AN if there is already link.
> 
>       Andrew

Thanks for your comment.

There is no register bit in TI PHY which reports the SGMII AN link status.
But, there is a bit that only reports the SGMII AN completion status.

In this case, the PHY side SGMII AN has been already completed prior to MAC is up.
So, once MAC side SGMII is up, MAC side SGMII wouldn`t receive any new
in-band message from TI PHY.

Thanks,
Tee Min

