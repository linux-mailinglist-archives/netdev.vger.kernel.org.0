Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFF355C14C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239047AbiF0QM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 12:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239135AbiF0QMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 12:12:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248E918B34
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 09:12:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 901CD616B3
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 16:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20DFC3411D;
        Mon, 27 Jun 2022 16:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656346339;
        bh=dvUot3jPE6VUd++G36Mpj5e2UFmY5faQjGnofHGtGi0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ei/OP0+PF9LM5Ej19gWS7HBYEs2kV05WweWGd+DLtKrMj0jXRbTKmjAb0gY2vPLKD
         0ujf1ehpBdTG0plJ0/JkGb+9hqA3Q4lCkHnV6MrPIoeYyutugPLcHdwRYR+egZUWRe
         WG2U0fwjh1AR2OHkdSURxqVUaBnhccSrsrKTQK6pkSLIZQCZCx3QuAtzr0Sj310Io9
         lH5XQSBqJIZQJ0HiTlRmOjm7F4JwVBU7TzHeruRYd4yqktGOTphNHfaZwlyyysoknJ
         7RKjGtKfXGz8n5rAXA7zNa6lmwN4zO1SVXOkU8Vp7VVR+yNyeqi9BGqRRg4tztyK3n
         cHkNrT4V9U1gQ==
Date:   Mon, 27 Jun 2022 09:12:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        boon.leong.ong@intel.com, andrew@lunn.ch, hkallweit1@gmail.com,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH net-next] net: pcs: pcs-xpcs: hide xpcs Kconfig option
 from the user
Message-ID: <20220627091209.4262b1d8@kernel.org>
In-Reply-To: <20220624101758.565822-1-ioana.ciornei@nxp.com>
References: <20220624101758.565822-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jun 2022 13:17:58 +0300 Ioana Ciornei wrote:
> Hide the xpcs Kconfig option from the user so that we do not end up in
> a scenario where the xpcs is enabled as a module but phylink is not
> enabled at all.
> 
> ERROR: modpost: "phylink_mii_c22_pcs_encode_advertisement" [drivers/net/pcs/pcs_xpcs.ko] undefined!
> ERROR: modpost: "phylink_mii_c22_pcs_decode_state" [drivers/net/pcs/pcs_xpcs.ko] undefined!
> 
> All the user drivers (stmmac and sja1105) of the xpcs module already
> select both PCS_XPCS and PHYLINK, so the dependency is resolved at that
> level.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: b47aec885bcd ("net: pcs: xpcs: add CL37 1000BASE-X AN support")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Oh, somehow I missed this patch on Friday, I applied my own
commit ebeae54d3a77 ("net: pcs: xpcs: depends on PHYLINK in Kconfig")
