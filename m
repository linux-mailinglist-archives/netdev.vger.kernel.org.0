Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891794F6071
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbiDFNsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233646AbiDFNsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:48:45 -0400
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D37546D1B48;
        Wed,  6 Apr 2022 04:11:42 -0700 (PDT)
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1nc3ZY-00031I-01; Wed, 06 Apr 2022 13:11:36 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 9C281C4E9D; Wed,  6 Apr 2022 13:11:25 +0200 (CEST)
Date:   Wed, 6 Apr 2022 13:11:25 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        arnd@kernel.org, myxie@debian.org, Jesper Juhl <jj@chaosbits.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        linux-mips@vger.kernel.org, p.zabel@pengutronix.de
Subject: Re: [PATCH net-next] net: atm: remove the ambassador driver
Message-ID: <20220406111125.GB19718@alpha.franken.de>
References: <20220406041627.643617-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406041627.643617-1-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 09:16:27PM -0700, Jakub Kicinski wrote:
> The driver for ATM Ambassador devices spews build warnings on
> microblaze. The virt_to_bus() calls discard the volatile keyword.
> The right thing to do would be to migrate this driver to a modern
> DMA API but it seems unlikely anyone is actually using it.
> There had been no fixes or functional changes here since
> the git era begun.
> 
> In fact it sounds like the FW loading was broken from 2008
> 'til 2012 - see commit fcdc90b025e6 ("atm: forever loop loading
> ambassador firmware").
> 
> Let's remove this driver, there isn't much changing in the APIs,
> if users come forward we can apologize and revert.
> 
> Link: https://lore.kernel.org/all/20220321144013.440d7fc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: myxie@debian.org,gprocida@madge.com
> CC: Jesper Juhl <jj@chaosbits.net>
> CC: Dan Carpenter <dan.carpenter@oracle.com>
> CC: Chas Williams <3chas3@gmail.com> # ATM
> CC: linux-atm-general@lists.sourceforge.net
> CC: tsbogend@alpha.franken.de # MIPS
> CC: linux-mips@vger.kernel.org
> CC: p.zabel@pengutronix.de # dunno why, get_maintainer
> ---
>  arch/mips/configs/gpr_defconfig  |    1 -
>  arch/mips/configs/mtx1_defconfig |    1 -
>  drivers/atm/Kconfig              |   25 -
>  drivers/atm/Makefile             |    1 -
>  drivers/atm/ambassador.c         | 2400 ------------------------------
>  drivers/atm/ambassador.h         |  648 --------
>  6 files changed, 3076 deletions(-)
>  delete mode 100644 drivers/atm/ambassador.c
>  delete mode 100644 drivers/atm/ambassador.h

Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
