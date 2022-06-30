Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C29156246C
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 22:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbiF3Ukm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 16:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiF3Ukl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 16:40:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69B22DB;
        Thu, 30 Jun 2022 13:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656621640; x=1688157640;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dLHwojcIwhnxNiJZmRhvdWkTN7FOsnP5rdFn+0H9dDI=;
  b=VKHeF8RNBqZIcBwicqtq9t42AcBwiu4mh6kuKKXsu8Ssx/KBYBqFi9dc
   phuFJjWHNzTgS0RX7eUgJH3D6rPeJkPxlfayDVHjtWFDOfz6MoGJETzsY
   XnNurJH1j3uNp5ledT8EWNf7opWzkCRr9Q+PRHdG8SZTw5vvsuR6HqdQL
   u4xcNw7WUE0a5XZvivGM0p7uDCmtaFT11BFiyoMM3QszT5Iw+kE368l0n
   76M5dFLW1MebWxd4x7dp4V4LRoDt9i1C7KCcJ1+jg6HswY4fd82DTzPv0
   psrbbbVQfX8TQwV/pzTDmtwK8dKGfrxExAh8IFEgw487z6vbXrkgUZ+1d
   g==;
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="170590192"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 13:40:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 13:40:39 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 30 Jun 2022 13:40:39 -0700
Date:   Thu, 30 Jun 2022 22:44:33 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] net: lan966x: hardcode port count
Message-ID: <20220630204433.hg2a2ws2zk5p73ld@soft-dev3-1.localhost>
References: <20220630140237.692986-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220630140237.692986-1-michael@walle.cc>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 06/30/2022 16:02, Michael Walle wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Don't rely on the device tree to count the number of physical port. Instead
> introduce a new compatible string which the driver can use to select the
> correct port count.
> 
> This also hardcodes the generic compatible string to 8. The rationale is
> that this compatible string was just used for the LAN9668 for now and I'm
> not even sure the current driver would support the LAN9662.

It works also on LAN9662, but I didn't have time to send patches for
DTs. Then when I send patches for LAN9662, do I need to go in all dts
files to change the compatible string for the 'switch' node?

> 
> Michael Walle (4):
>   net: lan966x: hardcode the number of external ports
>   dt-bindings: net: lan966x: add specific compatible string
>   net: lan966x: add new compatible microchip,lan9668-switch
>   ARM: dts: lan966x: use new microchip,lan9668-switch compatible
> 
>  .../net/microchip,lan966x-switch.yaml         |  5 +++-
>  arch/arm/boot/dts/lan966x.dtsi                |  2 +-
>  .../ethernet/microchip/lan966x/lan966x_main.c | 24 +++++++++++++------
>  3 files changed, 22 insertions(+), 9 deletions(-)
> 
> --
> 2.30.2
> 

-- 
/Horatiu
