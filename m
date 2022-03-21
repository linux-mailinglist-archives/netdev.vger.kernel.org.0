Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811DA4E31AC
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 21:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353289AbiCUUYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 16:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353114AbiCUUYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 16:24:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4558C2A736;
        Mon, 21 Mar 2022 13:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647894194; x=1679430194;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2XKSa393AJ/u/J5kUeoinz3LLqVWqafJGXbziCYPgUk=;
  b=BBKYcwjsETXEsv0qSZWDe6YRk8wFOU9P1kxq5IRDug/vPew8MaDyERcq
   B+eTUO8zat1m/QPsvxLF87J5hjb41VBxrEtvVwuqtq5yU7nyOjULnZLEs
   Wbh0A7YCVAcC0TBNAUHAGyHn6N86VnD3uTgfCkQq18wQv/YvThZRiXevH
   2rUT7r+fpzZe/M9vGNDv627Jku9fO3Dz9jIOayXM7nM4U5tjUSjBcJaEt
   KkzaaPthFRWKyENDevzC7Bs6QKrj4Y4B2MMZpSjsdM07A3Uj21ZIPCO2V
   gEWklXpsqR1aAeTD6tydFG/wvLCwfbRu2woTFVRpF6Dt8byHaizsWCz4p
   g==;
X-IronPort-AV: E=Sophos;i="5.90,199,1643698800"; 
   d="scan'208";a="152737954"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Mar 2022 13:23:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 21 Mar 2022 13:23:13 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 21 Mar 2022 13:23:02 -0700
Message-ID: <661489ea4ba5646d695d55242808f1fb4ae35cfb.camel@microchip.com>
Subject: Re: [PATCH v9 net-next 09/11] net: dsa: microchip: add support for
 port mirror operations
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Tue, 22 Mar 2022 01:52:59 +0530
In-Reply-To: <20220318110033.nuwvrok6ywsagxwf@skbuf>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
         <20220318085540.281721-10-prasanna.vengateshan@microchip.com>
         <20220318110033.nuwvrok6ywsagxwf@skbuf>
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

On Fri, 2022-03-18 at 13:00 +0200, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On Fri, Mar 18, 2022 at 02:25:38PM +0530, Prasanna Vengateshan wrote:
> > Added support for port_mirror_add() and port_mirror_del operations
> > 
> > Sniffing is limited to one port & alert the user if any new
> > sniffing port is selected
> > 
> > Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> > Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > ---
> >  drivers/net/dsa/microchip/lan937x_main.c | 84 ++++++++++++++++++++++++
> >  1 file changed, 84 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/microchip/lan937x_main.c
> > b/drivers/net/dsa/microchip/lan937x_main.c
> > index c54aba6a05b5..5a57a2ce8992 100644
> > --- a/drivers/net/dsa/microchip/lan937x_main.c
> > +++ b/drivers/net/dsa/microchip/lan937x_main.c
> > @@ -98,6 +98,88 @@ static void lan937x_port_stp_state_set(struct dsa_switch
> > *ds, int port,
> >       ksz_update_port_member(dev, port);
> >  }
> > 
> > +static int lan937x_port_mirror_add(struct dsa_switch *ds, int port,
> > +                                struct dsa_mall_mirror_tc_entry *mirror,
> > +                                bool ingress)
> 
> This function gained a new extack argument yesterday => your patch
> doesn't compile. Maybe you could even use the extack to propagate the
> "existing sniffer port" error.
> 
> 

Sure, will use the extack for existing errors.

Prasanna V

