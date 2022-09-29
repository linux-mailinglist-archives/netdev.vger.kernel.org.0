Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192A15EF6F8
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 15:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbiI2N41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 09:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbiI2N4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 09:56:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AE711ADDD
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 06:56:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E382DB824A1
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 13:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF16C433D7;
        Thu, 29 Sep 2022 13:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664459777;
        bh=IZWkitAl8YosjSaE9485+Ts9rzl3eqH6rjc4QjpoN4A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G6tA1GhDnbVOPoE6tUOI0ARB6k/YpO9OJ/U1X/nVWM77qvrnhK0sdC5yyv2BUmM08
         gAo95DKwjiiqb+mlBSUciUfi+gG9ZR7lXBfkz2vfAOe3y4hQccERC/mRBvnUy5+vMb
         OrQgy01zJytwjpgVmnCoFzNekZOxsm9U01ZJHsHgYjmW+X3gsGpDwT0mRYQnmA1PSc
         vZraNuEslZisd9JSoW2IBbyUF+AG32znE3oastoA/D/nUfuHt+e2ZzoeqqNSJ7zrHT
         LHvP5wf+a/xvrSb2QLXQfZWqmAhEYs1e8HME1wxGv7Ss2SleaxWTE6io4MCaOapSyh
         mhSUJZbDp0pJA==
Date:   Thu, 29 Sep 2022 06:56:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Cc:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "Ahmad Tarmizi, Noor Azura" <noor.azura.ahmad.tarmizi@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP
 packets
Message-ID: <20220929065615.0a717655@kernel.org>
In-Reply-To: <SJ1PR11MB6180CAE122C465AB7CB58B1BB8579@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
        <20220927170919.3a1dbcc3@kernel.org>
        <SJ1PR11MB6180CAE122C465AB7CB58B1BB8579@SJ1PR11MB6180.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 02:35:29 +0000 Zulkifli, Muhammad Husaini wrote:
> > High level tho, are we assuming that the existing HW timestamps are always
> > PTP-quality, i.e. captured when SFD crosses the RS layer, or whatnot? I'm
> > afraid some NICs already report PCI stamps as the HW ones.  
> 
> Yes. HW timestamps always can be assume equivalent to PTP quality.
> Could you provide additional information regarding SFD crosses the RS layer?

I mean true PTP timestamps, rather than captured somewhere in the NIC
pipeline or at the DMA engine.

> According to what I observed, The HW Timestamps will be requested if the application side 
> specifies tx type = HWTSTAMP TX ON and timestamping flags = SOF TIMESTAMPING TX HARDWARE.
> So it depends on how the application used it.
> 
> > So the existing HW stamps are conceptually of "any" type, if we want to be
> > 100% sure NIC actually stamps at the PHY we'd need another tx_type to
> > express that.  
> 
> Yes, you're right. Are you suggesting that we add a new tx_type to specify
> Only MAC/PHY timestamp ? Ex. HWTSTAMP_TX_PHY/MAC_ON.

Perhaps we can call them HWTSTAMP_TX_PTP_* ? Was the general time
stamping requirement specified in IEEE 1588 or 802.1 (AS?)? 

Both MAC and PHY can provide the time stamps IIUC, so picking one of
those will not be entirely fortunate. In fact perhaps embedded folks
will use this opportunity to disambiguate the two..

> Sorry about the naming here. Just so you know, the DMA timestamp does not
> quite match the PTP's level timestamping. The DMA timestamp will be capture when
> DMA request to fetch the data from the memory. 
> 
> > 
> > Same story on the Rx - what do you plan to do there? We'll need to configure
> > the filters per type, but that's likely to mean two new filters, because the
> > current one gives no guarantee.  
> 
> Current I225 HW only allow to retrieve the dma time for TX packets only. 
> So as of now based on our HW, on RX side we just requesting rx filter to timestamps any incoming packets.
> We always allocating additional bytes in the packet buffer for the receive packets for timestamp. 
> It is a 1588 PTP level kind of timestamping accuracy here.

I see. I think datacenter NICs can provide DMA stamps for Rx as well.
Intel, Mellanox, Broadcom folks, could you confirm if your NIC can do Rx
DMA stamps?
