Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972EC6CD344
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjC2Hd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjC2HdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:33:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E0455AF;
        Wed, 29 Mar 2023 00:30:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41B55B820CE;
        Wed, 29 Mar 2023 07:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42865C433EF;
        Wed, 29 Mar 2023 07:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680075002;
        bh=iT6N+zCmgn0spjn9/Vsnh4EyZ9uBCU0NzjjY9gDxoto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i3UvGSFQc7kks2U+f2KLbiQXAuInjV9SfUzsOe7uCf8rIq7pvVZMnfn+lW0g4Xr5/
         agH8qqxVRc+ZR9ugdETBE6BwXcvUBsULENNSJEYgP7WDm2ltRXGsXbY3oQqEyIk+xb
         8FWo9dmxbyoFR3bxM3tFZ3GUm6P1BSb5trEP481lennYyLAtWwBl1yDEVHnc/RUJgv
         4ystEKchIq1kxD3pa2HAzugZIlls3QjHBDA++gpUtgDtHKHV4zg4WUsOtyOFAu2EhD
         764FYUVtGLw2S7Tgz9DvNi7uW0wvIFz/ap7RSQOoDSCD9/j+9DWwFFBHr3ELVENf7r
         x1uLo1MoLmzfg==
Date:   Wed, 29 Mar 2023 10:29:57 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [EXT] Re: [PATCH net-next v4 6/8] octeon_ep: support
 asynchronous notifications
Message-ID: <20230329072957.GF831478@unreal>
References: <20230322091958.13103-1-vburru@marvell.com>
 <20230322091958.13103-7-vburru@marvell.com>
 <20230323103900.GC36557@unreal>
 <MN2PR18MB2430BA163B1FC69EEB39EE75CC879@MN2PR18MB2430.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR18MB2430BA163B1FC69EEB39EE75CC879@MN2PR18MB2430.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 05:24:55PM +0000, Veerasenareddy Burru wrote:
> 
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Thursday, March 23, 2023 3:39 AM
> > To: Veerasenareddy Burru <vburru@marvell.com>
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Abhijit Ayarekar
> > <aayarekar@marvell.com>; Sathesh B Edara <sedara@marvell.com>;
> > Satananda Burla <sburla@marvell.com>; linux-doc@vger.kernel.org; David S.
> > Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> > Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> > Subject: [EXT] Re: [PATCH net-next v4 6/8] octeon_ep: support
> > asynchronous notifications
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > On Wed, Mar 22, 2023 at 02:19:55AM -0700, Veerasenareddy Burru wrote:
> > > Add asynchronous notification support to the control mailbox.
> > >
> > > Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> > > Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> > > ---
> > > v3 -> v4:
> > >  * 0005-xxx.patch in v3 is 0006-xxx.patch in v4.
> > >  * addressed review comments
> > >    https://urldefense.proofpoint.com/v2/url?u=https-
> > 3A__lore.kernel.org_all_Y-2B0J94sowllCe5Gs-
> > 40boxer_&d=DwIBAg&c=nKjWec2b6R0mOyPaz7xtfQ&r=XkP_75lnbPIeeucsP
> > X36ZgjiMqEKttwZfwNyWMCLjT0&m=5CnsD-
> > SX6ZoW98szwM0k4IXgNC3wY0EwCQHxDKGyNIRUJxdaNe3zorLcOhc9iU6d&s
> > =k73McQSsjbjj87VbCCB8EFFtGWtksMIGhn15RK12XF8&e=
> > >    - fixed rct violation.
> > >    - process_mbox_notify() now returns void.
> > >
> > > v2 -> v3:
> > >  * no change
> > >
> > > v1 -> v2:
> > >  * no change
> > >
> > >  .../marvell/octeon_ep/octep_ctrl_net.c        | 29 +++++++++++++++++++
> > >  1 file changed, 29 insertions(+)
> > >
> > > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> > > b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> > > index cef4bc3b1ec0..465eef2824e3 100644
> > > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> > > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> > > @@ -271,6 +271,33 @@ static void process_mbox_resp(struct
> > octep_device *oct,
> > >  	}
> > >  }
> > >
> > > +static int process_mbox_notify(struct octep_device *oct,
> > > +			       struct octep_ctrl_mbox_msg *msg) {
> > > +	struct net_device *netdev = oct->netdev;
> > > +	struct octep_ctrl_net_f2h_req *req;
> > > +
> > > +	req = (struct octep_ctrl_net_f2h_req *)msg->sg_list[0].msg;
> > > +	switch (req->hdr.s.cmd) {
> > > +	case OCTEP_CTRL_NET_F2H_CMD_LINK_STATUS:
> > > +		if (netif_running(netdev)) {
> > > +			if (req->link.state) {
> > > +				dev_info(&oct->pdev->dev,
> > "netif_carrier_on\n");
> > > +				netif_carrier_on(netdev);
> > > +			} else {
> > > +				dev_info(&oct->pdev->dev,
> > "netif_carrier_off\n");
> > > +				netif_carrier_off(netdev);
> > > +			}
> > 
> > Shouldn't netdev changes be protected by some lock?
> > Is is safe to get event from FW and process it as is?
> > 
> > Thanks
> 
> Thanks for the kind feedback.
> I do not see netif_carrier_on/off require any protection. I referred few other drivers and do not see such protection used for carrier on/off.
> Please suggest if I am missing something here.

I see that Dave already applied your v5. I think that you are missing context in which you
are running FW commands. They run independently from netdev and makes netif_running() check
to be racy.

Thanks

> 
