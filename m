Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8A169A699
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 09:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBQIJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 03:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQIJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 03:09:02 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B701350F;
        Fri, 17 Feb 2023 00:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676621342; x=1708157342;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TTPr7XV9B2s3mcWJ6UyTbFd7ceHV50RJq6KYArk2dkM=;
  b=ffguOWxX8Jd/l4iTudmT2bmjpaw0xm7xT/J0ovgxKlXWrb3yn6+yzW0k
   lFRqOeHQZsJ9cchqf3+7+ooJEQQB3WXG0wH7ntfETEZNCRqr/sN67SRnG
   MYuzWSov2Q89Q1TF/LiPOm9EXNPTnsFd3Estsil/5ffwICYCGV8Hz7E5V
   +KxSE8kuucw7rLzGZAuDeppO8AV3gFyeqVQplA/GZsmg/wD9X7LV0Hgjf
   t/ZiFhHP3xyU/xFW76Uq8vKP3dABFZBKNPgygX6fOGGAQJEp578N+dc6/
   p+tFQ1ectd6SdYltgzU3OfL6tMGqF2ci6sjoB0UrTpd5sYLFEBNWISOGP
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,304,1669100400"; 
   d="scan'208";a="201417142"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2023 01:09:01 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 01:09:00 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 17 Feb 2023 01:08:59 -0700
Date:   Fri, 17 Feb 2023 09:08:59 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Larysa Zaremba <larysa.zaremba@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v2] net: lan966x: Use automatic selection of
 VCAP rule actionset
Message-ID: <20230217080859.fdsxr7ytfzw4vhdp@soft-dev3-1>
References: <20230216122907.2207291-1-horatiu.vultur@microchip.com>
 <Y+41fTUfz8Kx6ujH@lincoln>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y+41fTUfz8Kx6ujH@lincoln>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/16/2023 14:54, Larysa Zaremba wrote:

Hi Larysa,

> 
> On Thu, Feb 16, 2023 at 01:29:07PM +0100, Horatiu Vultur wrote:
> > Since commit 81e164c4aec5 ("net: microchip: sparx5: Add automatic
> > selection of VCAP rule actionset") the VCAP API has the capability to
> > select automatically the actionset based on the actions that are attached
> > to the rule. So it is not needed anymore to hardcore the actionset in the
> 
> I am sure, you've meant 'hardcode'

Yes, I will change this in the next version.

> 
> > driver, therefore it is OK to remove this.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> > v1->v2:
> > - improve the commit message by mentioning the commit which allows
> >   to make this change
> > ---
> >  drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> > index bd10a71897418..f960727ecaeec 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> > @@ -261,8 +261,6 @@ static int lan966x_tc_flower_add(struct lan966x_port *port,
> >                                                       0);
> >                       err |= vcap_rule_add_action_u32(vrule, VCAP_AF_MASK_MODE,
> >                                                       LAN966X_PMM_REPLACE);
> > -                     err |= vcap_set_rule_set_actionset(vrule,
> > -                                                        VCAP_AFS_BASE_TYPE);
> 
> Is this the only location, where this can be done? I'm not very familiar with
> this driver, would it maybe make sense to check out lan966x_ptp_add_trap() too?

Good catch! Also in lan966x_ptp_add_trap, the function
vcap_set_rule_set_actionset can be removed.

> 
> >                       if (err)
> >                               goto out;
> >
> > --
> > 2.38.0
> >

-- 
/Horatiu
