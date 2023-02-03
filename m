Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD50689E39
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbjBCP0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbjBCP0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:26:13 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C7525949;
        Fri,  3 Feb 2023 07:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675437949; x=1706973949;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fTglNR/sPCSuqgVuIu5VH2gWWrV0ubKQaV/cNyFzbm8=;
  b=JeqVWnq7jMc6YVYbWTqaHey588cvLh244/ORLf4LtMao/LmF1wSEQ+Bi
   w6O/7o/yM2OeyigpjutsCHUB25+Sb08uqY4/bXW1lWB+ZXErfBcEYxWiP
   z6EecHTYaUFG9YVqKuLPByMYvTmn1Bz2b1ACNAQ9oe7N6q7WDQhNoLLR/
   b4NoTg42WcNcJnEodyRnLQhpkKJ5OYOWpo2IJeT2GGbJSGCLcfLFvm8Ml
   HZyArKmOS4N2tun4GLz+inlmX1TxenJJMmyKUvwwWCDKi0pSK/9QH1/Xt
   FIYA0ZiSI8fqMZi4tBLqtUowkQhrfiPOEjwTOjAXGdYoqvoUZyhOf3aER
   w==;
X-IronPort-AV: E=Sophos;i="5.97,270,1669100400"; 
   d="scan'208";a="199236460"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Feb 2023 08:25:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 08:25:49 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 3 Feb 2023 08:25:49 -0700
Date:   Fri, 3 Feb 2023 16:25:48 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <michael@walle.cc>
Subject: Re: [PATCH net-next v2] net: micrel: Add support for lan8841 PHY
Message-ID: <20230203152548.nqrewntwi2tyx4pz@soft-dev3-1>
References: <20230203122542.436305-1-horatiu.vultur@microchip.com>
 <Y90YrXHeyR6f26Px@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y90YrXHeyR6f26Px@lunn.ch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/03/2023 15:22, Andrew Lunn wrote:

Hi Andrew,

> 
> > +{
> > +     char *rx_data_skews[4] = {"rxd0-skew-psec", "rxd1-skew-psec",
> > +                               "rxd2-skew-psec", "rxd3-skew-psec"};
> > +     char *tx_data_skews[4] = {"txd0-skew-psec", "txd1-skew-psec",
> > +                               "txd2-skew-psec", "txd3-skew-psec"};
> 
> Please take a read of
> Documentation/devicetree/bindings/net/micrel-ksz90x1.txt and then add
> a section which describes what these properties mean for this PHY,
> since nearly every microchip PHY has a different meaning :-(

I had a closer look at the datasheet of this PHY, and these properties
for lan8841 are the same for ksz9131, so actually I can reuse the
function 'ksz9131_config_init', to remove some of the duplicated code.

In this case maybe is enough to add the following change in
'micrel-ksz90x1.txt' not to create a totally new section.

---
diff --git a/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt b/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
index df9e844dd6bc6..2681168777a1e 100644
--- a/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
+++ b/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
@@ -158,6 +158,7 @@ KSZ9031:
         no link will be established.

 KSZ9131:
+LAN8841:

   All skew control options are specified in picoseconds. The increment
   step is 100ps. Unlike KSZ9031, the values represent picoseccond delays.

---

> 
>       Andrew

-- 
/Horatiu
