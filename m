Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D1263EADB
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 09:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiLAILc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 03:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiLAILb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 03:11:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BF920344;
        Thu,  1 Dec 2022 00:11:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44231B81D96;
        Thu,  1 Dec 2022 08:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D76C433D6;
        Thu,  1 Dec 2022 08:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669882281;
        bh=pacK4oSuE/b5c5EwaJOqh3ES+VasIVXQPJNvmrtoSaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VVqPCIb+KVG0NsfqtbHx1i9X6A/HAYRu2TVGd4K8nnnkh5JXoDPdeicaeF7kueP0y
         MphPck1WjvB/FpPEGutDzpBjpSN5yJbud5qvScnwqtHk3Yjkk1RuocH8muw4Y35Tq/
         cy4tkSeYG13jSX8z7wuthkCNY2MCpdpv7pFEn7iC5AxC7eyJMN39dxxkleSCTCW+tG
         +5RMNG3i68kNRnTkKoy9pKn2d1HQrptZkSuPqNML5zT4F7otlyTgCTsBBMMwiwnKUG
         Vw5pBwbvi4jHYIAlRA2Lg7h1FarJjRHiQmJACfs7QrfEg5LNXhMaiFlx4+1hSFZ+ik
         eoBLw76Ch/nzw==
Date:   Thu, 1 Dec 2022 10:11:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liron Himi <lironh@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
 messages
Message-ID: <Y4hhpFVsENaM45Ho@unreal>
References: <20221129130933.25231-1-vburru@marvell.com>
 <20221129130933.25231-3-vburru@marvell.com>
 <Y4cirWdJipOxmNaT@unreal>
 <BYAPR18MB242397C352B0086140106A46CC159@BYAPR18MB2423.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR18MB242397C352B0086140106A46CC159@BYAPR18MB2423.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 03:44:30PM +0000, Veerasenareddy Burru wrote:
> 
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Wednesday, November 30, 2022 1:30 AM
> > To: Veerasenareddy Burru <vburru@marvell.com>
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Liron Himi
> > <lironh@marvell.com>; Abhijit Ayarekar <aayarekar@marvell.com>; Sathesh
> > B Edara <sedara@marvell.com>; Satananda Burla <sburla@marvell.com>;
> > linux-doc@vger.kernel.org; David S. Miller <davem@davemloft.net>; Eric
> > Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> > Paolo Abeni <pabeni@redhat.com>
> > Subject: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
> > messages
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > On Tue, Nov 29, 2022 at 05:09:25AM -0800, Veerasenareddy Burru wrote:
> > > Poll for control messages until interrupts are enabled.
> > > All the interrupts are enabled in ndo_open().
> > 
> > So what are you saying if I have your device and didn't enable network
> > device, you will poll forever?
> Yes, Leon. It will poll periodically until network interface is enabled.

I don't know if it is acceptable behaviour in netdev, but it doesn't
sound right to me. What type of control messages will be sent by FW,
which PF should listen to them?

> > 
> > > Add ability to listen for notifications from firmware before ndo_open().
> > > Once interrupts are enabled, this polling is disabled and all the
> > > messages are processed by bottom half of interrupt handler.
> > >
> > > Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> > > Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> > > ---
> > > v1 -> v2:
> > >  * removed device status oct->status, as it is not required with the
> > >    modified implementation in 0001-xxxx.patch
> > >
> > >  .../marvell/octeon_ep/octep_cn9k_pf.c         | 49 +++++++++----------
> > >  .../ethernet/marvell/octeon_ep/octep_main.c   | 35 +++++++++++++
> > >  .../ethernet/marvell/octeon_ep/octep_main.h   | 11 ++++-
> > >  .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  4 ++
> > >  4 files changed, 71 insertions(+), 28 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > > b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > > index 6ad88d0fe43f..ace2dfd1e918 100644
> > > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > > @@ -352,27 +352,36 @@ static void
> > octep_setup_mbox_regs_cn93_pf(struct octep_device *oct, int q_no)
> > >  	mbox->mbox_read_reg = oct->mmio[0].hw_addr +
> > > CN93_SDP_R_MBOX_VF_PF_DATA(q_no);  }
> > >
> > > -/* Mailbox Interrupt handler */
> > > -static void cn93_handle_pf_mbox_intr(struct octep_device *oct)
> > > +/* Process non-ioq interrupts required to keep pf interface running.
> > > + * OEI_RINT is needed for control mailbox  */ static int
> > > +octep_poll_non_ioq_interrupts_cn93_pf(struct octep_device *oct)
> > >  {
> > > -	u64 mbox_int_val = 0ULL, val = 0ULL, qno = 0ULL;
> > > +	u64 reg0;
> > > +	int handled = 0;
> > 
> > Reversed Christmas tree.
> Thanks for the feedback. Will revise the patch.

It is applicable to all patches.

And please fix your email client to properly add blank lines between
replies.

Thanks

> > 
> > Thanks
