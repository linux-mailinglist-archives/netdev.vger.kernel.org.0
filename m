Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553C84E30D3
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 20:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352704AbiCUTfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 15:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237280AbiCUTfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 15:35:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578AB201B0;
        Mon, 21 Mar 2022 12:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647891250; x=1679427250;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w7a5ayX4fO/yYsd6UzC9sc+2sok0Wa5i+Fi3ge1HonM=;
  b=2fPH9FSYUI49grJJKduBVpDwYoxiEPPcVv83VFPtI5uiac/lxcYYe7q/
   98pDkm0/wJlsSeYU38uZXw6QwBqcKktmdE5ofMnyGH8d/3KRNdzfzw+Kn
   BgeavC0ppAsIMPP8oqT/j5BOeC2kECZkslhZjbZypQTdBXWa2IirKhaQT
   JilEojTmJV0rFEPPCG49b42mjdZrQLio0ykVMUuGAxw38cYaBkBKQe0MR
   ZuGKGYJRdwuCvPFd/2/xHVGq2t15a5SC0i2JBdl9fxN4K52ME3XKopCnk
   WOVnKP+TZgJnWaDPRGTXJAhuBDao+NaJG5kSdMhAg1opr4boFsSt6a00Z
   g==;
X-IronPort-AV: E=Sophos;i="5.90,199,1643698800"; 
   d="scan'208";a="152734289"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Mar 2022 12:34:08 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 21 Mar 2022 12:34:08 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 21 Mar 2022 12:34:01 -0700
Message-ID: <fd60a58c729d3bd6e8c12ba37610fd7e53d2ea05.camel@microchip.com>
Subject: Re: [PATCH v9 net-next 08/11] net: dsa: microchip: add support for
 ethtool port counters
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <woojung.huh@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Tue, 22 Mar 2022 01:03:58 +0530
In-Reply-To: <YjaCz0gqm846RAk5@lunn.ch>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
         <20220318085540.281721-9-prasanna.vengateshan@microchip.com>
         <YjaCz0gqm846RAk5@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-03-20 at 02:26 +0100, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On Fri, Mar 18, 2022 at 02:25:37PM +0530, Prasanna Vengateshan wrote:
> > Added support for get_eth_**_stats() (phy/mac/ctrl) and
> > get_stats64()
> > 
> > Reused the KSZ common APIs for get_ethtool_stats() & get_sset_count()
> > along with relevant lan937x hooks for KSZ common layer and added
> > support for get_strings()
> 
> 
> > +static void lan937x_get_stats64(struct dsa_switch *ds, int port,
> > +                             struct rtnl_link_stats64 *s)
> > +{
> > +     struct ksz_device *dev = ds->priv;
> > +     struct ksz_port_mib *mib = &dev->ports[port].mib;
> > +     u64 *ctr = mib->counters;
> > +
> > +     mutex_lock(&mib->cnt_mutex);
> 
> I think for stats64 you are not allowed to block.
> 
> https://lore.kernel.org/netdev/20220218104330.g3vfbpdqltdkp4sr@skbuf/T/
> 
> There was talk of changing this. but i don't think it ever happened.
> 
>       Andrew

Looks like it has been changed from mutex_lock() to spin_lock() since
ndo_get_stats64 runs in atomic context. I will adopt the same. Thanks for the
feedback.

Prasanna V

