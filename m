Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9D74B9338
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 22:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbiBPVcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 16:32:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiBPVcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 16:32:15 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C762CC9E
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 13:31:59 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9C7765805F0;
        Wed, 16 Feb 2022 16:31:58 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 16 Feb 2022 16:31:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=G+VtQ43LDWL8acMBB
        yhD101gxLEMiQ+BN0bhOkBE2t0=; b=HY8ThYL+0s/mdDoJscVUGDs7km0fe7MMd
        qAXyx67hXZN/1Xdg94HhEK2LWnJ5NVTUzMN6q5TnYbcZke+0JRdc2xCaDxq/zesL
        QHN0BkQmr7ry/qx/sdOU3JIevVgS171XsjMhI/DWm4gwPZjzBdmdW7soB4eh8CIt
        mcwtnwT6gOeJjnO9sFqzTdnp5zy8yDpgcz0HGSOhc0J7ZF+n1zd1tJ0xs1QeXg+z
        HHKKVnBPWVEFvrlN3Eo4cnOk87jZB7P1O8dqYT91jFRWxgqLNScMsLSSPvVdpJ0J
        eKdq5eQn01WQf+C7iobtsVR4Eza2SVM1mIK9gpkAXfogIVcW1cwjA==
X-ME-Sender: <xms:Tm0NYnS1A8lM0Kxl0PajiDl3Lr-Me8XZObT0vqtk5c7WUv771zYExA>
    <xme:Tm0NYoyWgBLB1TAwTPIsRzobKRapHB1wONwaDIpiNvhsqoVehjwPxtwnweu413BXs
    EnNoUxribSkjnw>
X-ME-Received: <xmr:Tm0NYs05cpCVWwlOWI-iv_onVnWNmhikid87JoHIFcdSLoG0-HtPh97DeMLMDWoc-PM5z1UbRdSymjSbpM33xwHrKww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjeeigddugeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Tm0NYnA2cHQZtt4FuYapyDe5164fkUrfhNra2CmmwPmxxZi1mGT8Sg>
    <xmx:Tm0NYgiSM_AoPHcKlone-ZCVLPr14Jav6CAkFvQl2zE20aWVRuqhkw>
    <xmx:Tm0NYrr5bqvSwHSnZgsIuMmkVxSYlVlBIGW6m7kjovqneu2tJbs0FA>
    <xmx:Tm0NYla2QiAjpwTqgBqBfPWPLdba168DBpoaFfDnloG4x6BLeNhVdg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Feb 2022 16:31:57 -0500 (EST)
Date:   Wed, 16 Feb 2022 23:31:55 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] mlxsw: spectrum: remove guards against
 !BRIDGE_VLAN_INFO_BRENTRY
Message-ID: <Yg1tSz3SXcCyJw8U@shredder>
References: <20220216164752.2794456-1-vladimir.oltean@nxp.com>
 <20220216164752.2794456-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216164752.2794456-2-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 06:47:48PM +0200, Vladimir Oltean wrote:
> Since commit 3116ad0696dd ("net: bridge: vlan: don't notify to switchdev
> master VLANs without BRENTRY flag"), the bridge no longer emits
> switchdev notifiers for VLANs that don't have the
> BRIDGE_VLAN_INFO_BRENTRY flag, so these checks are dead code.
> Remove them.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks
