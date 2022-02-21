Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1452A4BD800
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 09:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241411AbiBUIAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 03:00:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346752AbiBUIAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 03:00:04 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292E221E17
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 23:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1645430373; x=1676966373;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PeOlSQbQ1ET7yVOysE8srzRcRM3KZGDNmlKwQQLp2As=;
  b=HApIptfCbdw3twILVlnNGrugz1woYH3yCBQG6cpTt9n2yGrHz9kprF26
   S5cI5kof86y53bj42n3OqrfJfkUPZKyI8gJK/vZys8AWs5Uqxu3I6eohe
   qLxs00rlDINRrcnJQe883qaycJiq4jte1ZzA9Ape3xZkvUCIxKNoPoNkb
   6W/N+3WTHS1IdatpYFufy9W6ei6TLSQIjAbTVTBWhS3OSd4RqWnyDMQGK
   E9cVk+2AnzpU1P12tfZVMu8YlVrDbpsmT2RCSjc6iLB5Z5PTuGl8tq25/
   wm3yHKlhvkrBIMLjlrarObseZEjI/p4fcFy6Mt9lpZZqOduHRn2W4Exhq
   w==;
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="162966754"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Feb 2022 00:59:33 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 21 Feb 2022 00:59:33 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 21 Feb 2022 00:59:31 -0700
Message-ID: <8ec4fb94e694396ce6bdffab514ab1b47bec1a60.camel@microchip.com>
Subject: Re: [PATCH net-next] net: sparx5: Support offloading of bridge port
 flooding flags
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Casper Andersson <casper@casan.se>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <Horatiu.Vultur@microchip.com>
CC:     <netdev@vger.kernel.org>
Date:   Mon, 21 Feb 2022 08:59:30 +0100
In-Reply-To: <20220217144534.sqntzdjltzvxslqo@wse-c0155>
References: <20220217144534.sqntzdjltzvxslqo@wse-c0155>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-02-17 at 14:45 +0000, Casper Andersson wrote:
> [Some people who received this message don't often get email from casper@casan.se. Learn why this
> is important at http://aka.ms/LearnAboutSenderIdentification.]
> 
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Though the SparX-5i can control IPv4/6 multicasts separately from non-IP
> multicasts, these are all muxed onto the bridge's BR_MCAST_FLOOD flag.
> 
> Signed-off-by: Casper Andersson <casper@casan.se>
> ---
>  drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> index 649ca609884a..27a9eed38316 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> @@ -22,8 +22,15 @@ struct sparx5_switchdev_event_work {
>  static void sparx5_port_attr_bridge_flags(struct sparx5_port *port,
>                                           struct switchdev_brport_flags flags)
>  {
> +       int pgid;
> +
>         if (flags.mask & BR_MCAST_FLOOD)
> -               sparx5_pgid_update_mask(port, PGID_MC_FLOOD, true);
> +               for (pgid = PGID_MC_FLOOD; pgid <= PGID_IPV6_MC_CTRL; pgid++)
> +                       sparx5_pgid_update_mask(port, pgid, !!(flags.val & BR_MCAST_FLOOD));
> +       if (flags.mask & BR_FLOOD)
> +               sparx5_pgid_update_mask(port, PGID_UC_FLOOD, !!(flags.val & BR_FLOOD));
> +       if (flags.mask & BR_BCAST_FLOOD)
> +               sparx5_pgid_update_mask(port, PGID_BCAST, !!(flags.val & BR_BCAST_FLOOD));
>  }
> 
>  static void sparx5_attr_stp_state_set(struct sparx5_port *port,
> --
> 2.30.2
> 
> 

Reviewed-by: Steen Hegelund <steen.hegelund@microchip.com>

BR
Steen

