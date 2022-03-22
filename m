Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50C14E4259
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbiCVOxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiCVOxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:53:53 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB80C8594C
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 07:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647960745; x=1679496745;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E4lTbTYxaUcLrwRBmY6ERH+4+8AypZzFzJF2UrK53+s=;
  b=Di913srvDJDIsIRcC7CEq/9xyKGpH7HtcAT/HCvuwzvJzf2vVau4F+Va
   0peVQhBCqZABUZuDAXKja8Jk6mtvuSkuSRfUWSJMY1rBOQRSwnCoojPjg
   InPfVatdnGGLU4VEbG4y4ectl23ZNxFAA+rMyeCfQm42+mEinRKdfp1FL
   7VO0Qv4fagrro/JuiD9LRvNy98urtdLvA021mPYLooUqjhMLpmHHpaP1q
   UFEVnA5SORqdjIDtav/W5pR9pmoTbGeh754S4cqrFKDShAsXSwPGVTzpv
   sYLRvuNEhm0T96ZSrz+ZC1ZWJgUJZ2Mc5Z4wqVf8g4cLYmbsbM571j8LQ
   A==;
X-IronPort-AV: E=Sophos;i="5.90,201,1643698800"; 
   d="scan'208";a="152835916"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Mar 2022 07:52:25 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 22 Mar 2022 07:52:25 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 22 Mar 2022 07:52:24 -0700
Message-ID: <ac37852d1fd2715209ad7679fa4d705083322b23.camel@microchip.com>
Subject: Re: [PATCH net-next 2/2] net: sparx5: Add mdb handlers
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>
CC:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Date:   Tue, 22 Mar 2022 15:51:02 +0100
In-Reply-To: <20220322095920.hptmgkby3tfxwmw4@wse-c0155>
References: <20220321101446.2372093-1-casper.casan@gmail.com>
         <20220321101446.2372093-3-casper.casan@gmail.com>
         <23c07e81392bd5ae8f44a5270f91c6ca696baa31.camel@microchip.com>
         <20220322095920.hptmgkby3tfxwmw4@wse-c0155>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Casper

On Tue, 2022-03-22 at 10:59 +0100, Casper Andersson wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> So this was already merged, but I have some comments on the feedback for
> the follow up patch.
> 
> > > +static int sparx5_handle_port_mdb_add(struct net_device *dev,
> > > +                                     struct notifier_block *nb,
> > > +                                     const struct switchdev_obj_port_mdb *v)
> > > +{
> > > +       struct sparx5_port *port = netdev_priv(dev);
> > > +       struct sparx5 *spx5 = port->sparx5;
> > > +       u16 pgid_idx, vid;
> > > +       u32 mact_entry;
> > > +       int res, err;
> > > +
> > > +       /* When VLAN unaware the vlan value is not parsed and we receive vid 0.
> > > +        * Fall back to bridge vid 1.
> > > +        */
> > > +       if (!br_vlan_enabled(spx5->hw_bridge_dev))
> > > +               vid = 1;
> > > +       else
> > > +               vid = v->vid;
> > > +
> > > +       res = sparx5_mact_find(spx5, v->addr, vid, &mact_entry);
> > > +
> > > +       if (res) {
> > > +               pgid_idx = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(mact_entry);
> > > +
> > > +               /* MC_IDX has an offset of 65 in the PGID table. */
> > > +               pgid_idx += PGID_MCAST_START;
> > 
> > This will overlap some of the first ports with the flood masks according to:
> > 
> > https://microchip-ung.github.io/sparx-5_reginfo/reginfo_sparx-5.html?select=ana_ac,pgid
> > 
> > You should use the custom area (PGID_BASE + 8 and onwards) for this new feature.
> 
> I'm aware of the overlap, hence why the PGID table has those fields
> marked as reserved. But your datasheet says that the multicast index
> has an offset of 65 (ie. MC_IDX = 0 is at PGID = 65). This is already
> taken into account in the mact_learn function. I could set the
> allocation to start at PGID_BASE + 8, but the offset still needs to
> be 65, right?

As I understand the PGID table functionality, you will need to start your custom table at PGID_BASE
+ 8 as the bitmasks at offset 65 to 70 are used as flood masks, so their purpose are already
defined.

BR
Steen

> 
> BR
> Casper

