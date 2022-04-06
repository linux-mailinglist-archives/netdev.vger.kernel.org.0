Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E454F6CB3
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiDFVbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbiDFVbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:31:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11AE1D788B
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 13:34:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E76A6172D
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 20:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A03BC385A5;
        Wed,  6 Apr 2022 20:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649277290;
        bh=KvFaj+XnKuYJmC5lFPjyLsdC9bEQxWUMv0+3r1bZOsI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TRM/dqbJu/wJwghwh+qRHKeSyYyFM1dzwQ6a4jR/cwA8gsaXWKoTGOI9S7PMllwdC
         U65Lor6VL7mnlhR6a2ngLzN1XyCJz1Us6f6Hit+umO/caouoUR7H+P1yagW9TM90jU
         9IqprWLTDNc219GON6WuUGaiUWwVr6Th1UmFkFDHtVy71WscclNnohvqvJmlw5btOR
         RRnr5f/doT3p23YWbIG5RSCK+TSuvw4DTbkZ5EIZLmU4Y0S2VgmKvKMKqnKrYq1Eyx
         goUMVUpRgTpc7ed2KtfpcAXAVZpOesBapXv0qxy6oTiLBEUAjqiQhznmOkU+fF7vX1
         aHrWFKyZqNcug==
Date:   Wed, 6 Apr 2022 22:34:43 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 5/9] net: dsa: mt7530: only indicate linkmodes
 that can be supported
Message-ID: <20220406223443.193b0ce1@thinkpad>
In-Reply-To: <20220406115250.047570c1@kernel.org>
References: <Yk1iHCy4fqvxsvu0@shell.armlinux.org.uk>
        <E1nc3Dd-004hq7-Co@rmk-PC.armlinux.org.uk>
        <20220406115250.047570c1@kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Apr 2022 11:52:50 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Wed, 06 Apr 2022 11:48:57 +0100 Russell King (Oracle) wrote:
> > -	if (state->interface != PHY_INTERFACE_MODE_MII) {
> > +	if (state->interface != PHY_INTERFACE_MODE_MII &&
> > +	    state->interface != PHY_INTERFACE_MODE_2500BASEX)
> >  		phylink_set(mask, 1000baseT_Full);
> >  		phylink_set(mask, 1000baseX_Full);
> >  	}  
> 
> Missing { here. Dunno if kbuild bot told you already.

Probably not, because next patch removes this code entirely :)
