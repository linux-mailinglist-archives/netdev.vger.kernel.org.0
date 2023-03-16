Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBD36BCB4E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjCPJpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjCPJps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:45:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B40C1353B
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 02:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678959946; x=1710495946;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=93jy34U5TuZc1a5Uypf44JZDiKCAWI+BdGILjHBTsKI=;
  b=NdvmRTZ8VoIPu/+o8R4vHvrIxRslQPyZLWsY+Gpp3uKCFi8SdsoYhhm1
   NueeJepkIzbcxGSDiKgXHhoTitl0dOfjlaA1NCiUBvmg+9vmZlyf929ED
   l81glz9aXPVen096/6Rl+l+tqr/TV9IwXhcHEesg43wf4jxSIfyDKeg57
   eERQOX7w1ZeWBFe05KTiW+tb0TxTJHcGspbYkQ/hnwz6RsrSZ7bZQ4Ii7
   2ner5NKkjv4lGQ85yNsM4VOT8uFVKVUggQ8tF8Jk1vyMld5PJstVcTj4/
   pcgw1017F5Y145zmsf8gPKvU5t5ScQ3OKMPW0Et2RXmhb6HbNcxYfYemp
   A==;
X-IronPort-AV: E=Sophos;i="5.98,265,1673938800"; 
   d="scan'208";a="205709981"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2023 02:45:45 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 02:45:44 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 02:45:41 -0700
Message-ID: <27ba7f8d0d1694b792a917bf5d9d9d8e9047686a.camel@microchip.com>
Subject: Re: [PATCH net-next 2/2] net: pcs: lynx: don't print an_enabled in
 pcs_get_state()
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan McDowell <noodles@earth.li>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
Date:   Thu, 16 Mar 2023 10:45:40 +0100
In-Reply-To: <E1pcSOv-00DiAu-2D@rmk-PC.armlinux.org.uk>
References: <ZBHaQDM+G/o/UW3i@shell.armlinux.org.uk>
         <E1pcSOv-00DiAu-2D@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Wed, 2023-03-15 at 14:46 +0000, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> an_enabled will be going away, and in any case, pcs_get_state() should
> not be updating this member. Remove the print.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/pcs/pcs-lynx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
> index 3903f3baba2b..622c3de3f3a8 100644
> --- a/drivers/net/pcs/pcs-lynx.c
> +++ b/drivers/net/pcs/pcs-lynx.c
> @@ -112,11 +112,11 @@ static void lynx_pcs_get_state(struct phylink_pcs *pcs,
>         }
> 
>         dev_dbg(&lynx->mdio->dev,
> -               "mode=%s/%s/%s link=%u an_enabled=%u an_complete=%u\n",
> +               "mode=%s/%s/%s link=%u an_complete=%u\n",
>                 phy_modes(state->interface),
>                 phy_speed_to_str(state->speed),
>                 phy_duplex_to_str(state->duplex),
> -               state->link, state->an_enabled, state->an_complete);
> +               state->link, state->an_complete);
>  }
> 
>  static int lynx_pcs_config_giga(struct mdio_device *pcs, unsigned int mode,
> --
> 2.30.2
> 

Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>

BR
Steen

