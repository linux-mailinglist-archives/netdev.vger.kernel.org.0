Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E934B940E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 23:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbiBPWwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 17:52:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237651AbiBPWwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 17:52:13 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF401EAC6;
        Wed, 16 Feb 2022 14:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1645051918; x=1676587918;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=V7ZqWbyYqyuczw0xodihuLxrHIcrC6vrsTOE4s2Gfs4=;
  b=DFwmOntrBRiNwVpAO/wjlOwEg8JX0JzDf3rdJ/2P75b0CT4echzMT8Sz
   hKtsK6zOMG5vo4hscqvWNFX9A3EjmbEqR4WsBfbHhtzpE8jhKGMlpgphm
   s0kzfjT3EXC9E0j6bG64cJELkB/6WCBnuFI619M6xHUG7mGagIYYAjs/B
   J7FOUD8ZuJ86BF62E7xvdkRGknWWaw30FLb+lveEm6Pxc1cVddJtcaU7S
   A9NgWsG98jlnhN2PoBiFtorrkp1rI0MfsoXT4UkhuvPnF3Vbq4tG/dehZ
   pe0DqUPLEI3Q7xKzYagaGKVbmrGHPR13f1Cx3QPq0w4e2JZnshJ/2jkHW
   A==;
IronPort-SDR: e955Di8nOuIcxBszk9/hrdrDZX6jWu3/SGpc47PPQihQa38yD/XFv/YNDTO8zxIt5WUrjpYEpy
 ePwTrgytnVdretnjhtT1IOt9oqWTGVMjRCBUz5fBsFzNOWyfnz67TlWoZO2H8MgkRE0MZAVWuu
 1rxCGOSLeInr6JKm8bs/1PC1sgfJGHEyikOnMw5KwMIgCpzpNNxr2nnJFypl6gQU+YwdqpgJ9N
 3o+n/McOaVEax/MShx1dX+ni58+CWljK9pfs93k1XpK9IocGjWlXJfe2TK0OjbgcjK204FtbHv
 Gf0OXGOrzAcX/a2GiOALjSbV
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="153345042"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2022 15:51:56 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 16 Feb 2022 15:51:56 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 16 Feb 2022 15:51:56 -0700
Date:   Wed, 16 Feb 2022 23:54:34 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        <UNGLinuxDriver@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH net-next 2/5] net: lan966x: remove guards against
 !BRIDGE_VLAN_INFO_BRENTRY
Message-ID: <20220216225434.zxljgfuvjmamooi7@soft-dev3-1.localhost>
References: <20220216164752.2794456-1-vladimir.oltean@nxp.com>
 <20220216164752.2794456-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220216164752.2794456-3-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/16/2022 18:47, Vladimir Oltean wrote:
> 
> Since commit 3116ad0696dd ("net: bridge: vlan: don't notify to switchdev
> master VLANs without BRENTRY flag"), the bridge no longer emits
> switchdev notifiers for VLANs that don't have the
> BRIDGE_VLAN_INFO_BRENTRY flag, so these checks are dead code.
> Remove them.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> ---
>  .../ethernet/microchip/lan966x/lan966x_switchdev.c   | 12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> index 9fce865287e7..85099a51d4c7 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> @@ -463,18 +463,6 @@ static int lan966x_handle_port_vlan_add(struct lan966x_port *port,
>         const struct switchdev_obj_port_vlan *v = SWITCHDEV_OBJ_PORT_VLAN(obj);
>         struct lan966x *lan966x = port->lan966x;
> 
> -       /* When adding a port to a vlan, we get a callback for the port but
> -        * also for the bridge. When get the callback for the bridge just bail
> -        * out. Then when the bridge is added to the vlan, then we get a
> -        * callback here but in this case the flags has set:
> -        * BRIDGE_VLAN_INFO_BRENTRY. In this case it means that the CPU
> -        * port is added to the vlan, so the broadcast frames and unicast frames
> -        * with dmac of the bridge should be foward to CPU.
> -        */
> -       if (netif_is_bridge_master(obj->orig_dev) &&
> -           !(v->flags & BRIDGE_VLAN_INFO_BRENTRY))
> -               return 0;
> -
>         if (!netif_is_bridge_master(obj->orig_dev))
>                 lan966x_vlan_port_add_vlan(port, v->vid,
>                                            v->flags & BRIDGE_VLAN_INFO_PVID,
> --
> 2.25.1
> 

-- 
/Horatiu
