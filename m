Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846405F0DBA
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiI3OkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiI3OkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70C2B776F
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E6066198C
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7FAC433C1;
        Fri, 30 Sep 2022 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664548817;
        bh=W555OV5c79V04dKJclc+ytcVQBgyKBrd1P+JSgO7yEs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LgVUmsNhdNqPAma5rkA7V6rCllf7c5e/CWPDwtrPFZJesdRHqs30mTciJ/g+h+p9u
         kW8eCf6l0AvvZF/gvRnGJWgyt1vWpydb0Tbi6yWHQaWxFBzbFvxM/J2xutUukrzjl0
         D5iISukkBoe9oB6s+3tjFog/h8lX7IAuPYjkDrMit8Qtnfyi5Wj6aHPaGsItZKsK86
         3rDU++vMI8E0YKRAzejdqLcoRr81TIzs3C4HZl8O6q4vaffsCag67aNeLzNLk6X4Wt
         ZrTwKpdyhaiWgiI+HsL296jkGbDLCdyEal+SY5F8Va3frlZp4DJ6iGnB0jzOVBIHGT
         othsHvoPyu78w==
Date:   Fri, 30 Sep 2022 07:40:16 -0700
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
Message-ID: <20220930074016.295cbfab@kernel.org>
In-Reply-To: <SJ1PR11MB61808A055419C257F6B653CCB8569@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
        <20220927170919.3a1dbcc3@kernel.org>
        <SJ1PR11MB6180CAE122C465AB7CB58B1BB8579@SJ1PR11MB6180.namprd11.prod.outlook.com>
        <20220929065615.0a717655@kernel.org>
        <SJ1PR11MB61808A055419C257F6B653CCB8569@SJ1PR11MB6180.namprd11.prod.outlook.com>
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

On Fri, 30 Sep 2022 08:52:38 +0000 Zulkifli, Muhammad Husaini wrote:
> > > Yes. HW timestamps always can be assume equivalent to PTP quality.
> > > Could you provide additional information regarding SFD crosses the RS  
> > > layer?
> > 
> > I mean true PTP timestamps, rather than captured somewhere in the NIC
> > pipeline or at the DMA engine.  
> 
> When SOF_TIMESTAMPING_TX_HARDWARE is been used, we guaranteed a PTP quality
> Timestamps (timestamp capture when packet leave the wire upon sensing the SFD).
> As of SOF_TIMESTAMPING_TX_HARDWARE_DMA_FETCH, it is not a PTP quality because
> the HW timestamp reported in this case, is a time when the data is
> DMA'ed into the NIC packet buffer.

I understand that _your_ device does it right.
But there are vendors out there who treat SOF_TIMESTAMPING_TX_HARDWARE
as your new SOF_TIMESTAMPING_TX_HARDWARE_DMA_FETCH.

> > > Yes, you're right. Are you suggesting that we add a new tx_type to
> > > specify Only MAC/PHY timestamp ? Ex. HWTSTAMP_TX_PHY/MAC_ON.  
> > 
> > Perhaps we can call them HWTSTAMP_TX_PTP_* ? Was the general time
> > stamping requirement specified in IEEE 1588 or 802.1 (AS?)?
> > 
> > Both MAC and PHY can provide the time stamps IIUC, so picking one of those
> > will not be entirely fortunate. In fact perhaps embedded folks will use this
> > opportunity to disambiguate the two..  
> 
> With the help of SOF_TIMESTAMPING_TX_HARDWARE, we will get the 
> PHY level timestamp(PTP quality) while using SOF_TIMESTAMPING_TX_HARDWARE_DMA_FETCH,
> we will get the timestamp at a point in the NIC pipeline.
> 
> Linuxptp application uses SOF_TIMESTAMPING_TX_HARDWARE for their socket option.
> And this can guarantee a PTP quality timestamp. 
> 
> Can we just use a SOF_TIMESTAMPING to identify which timestamp that we want rather 
> than creating a new tx_type?

Hm, perhaps, yes, we can stick to that.
