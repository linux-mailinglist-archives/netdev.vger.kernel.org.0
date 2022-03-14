Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438024D8918
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238510AbiCNQbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238700AbiCNQbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:31:09 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B3F12AB8
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:29:58 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 4E53C3200583;
        Mon, 14 Mar 2022 12:29:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 14 Mar 2022 12:29:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=oVuQTGIk8eT84uFaw
        Eqa7lIMjuB8TJbSYatiJloUe3k=; b=dq7Uq3ODCs8rhFOBJXf7uSo8RkdGRe7Sc
        QznzU/FjGmKNmNB4Q7qMg5bfKmCJqSn2uRff2/bBy2ygm03jAn130g8VZKzTqDML
        u9V2FnWKfU7ifg00brTEFL+wUxkKp3Kn5sPhFEN5LOxVVegKDt8u05VZQJb9+XOB
        l6mtR9p7NbNJnKKwOiPcPNhmK7xkMl4nwnpIEGnWgQOocbwNCKYw1K90A36gDjrC
        oiWc7RMl9kDvC7onOFQvASJsaQVAE8twmsnRob77DWobNje66piJT1GZxdfXArhH
        ZSRZIcoTZVpuwgV89Cnw2Xu3OsMy+ZJIQu27531adjdhmrCI4Q9jQ==
X-ME-Sender: <xms:hG0vYqJLgIPuBhDsIoBxf-W_NByqYS4Z0KqXD4xDSrnFjkX38E3LmA>
    <xme:hG0vYiLc4b48yNZztjieKfSI9t4hlHG8A0wUNLSDyVQCpf7h-QLvf8yfi1hX-szAE
    LKAuWs78f4HgoA>
X-ME-Received: <xmr:hG0vYqueqZT2dOIaL8uJ1_N32z5TlYku2YUylXE4wWZMZx3lQ3bqRucEOvIU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvkedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:hG0vYvacTYWcxERz-zFDDM-SRr-Z9dZ5AcnDmstLrG6j00b2gQBPfg>
    <xmx:hG0vYhadHMBu2t-C9pFNoqvuIIWsN9f-X0jXd1WuGDLcUGoce81mJQ>
    <xmx:hG0vYrBCf-b3bIxzoqka506wRA0cy4IJido_GBWA0QXjH87fQS0_CA>
    <xmx:hG0vYmPd_xQQD2FS5hrra1bDu0YEEqaQVA58BZZtglWILRSNDDgX4w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Mar 2022 12:29:55 -0400 (EDT)
Date:   Mon, 14 Mar 2022 18:29:52 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     mattias.forsblad+netdev@gmail.com
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH 1/3] net: bridge: Implement bridge flag local_receive
Message-ID: <Yi9tgOQ32q2l2TxD@shredder>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <20220301123104.226731-2-mattias.forsblad+netdev@gmail.com>
 <Yh5NL1SY7+3rLW5O@shredder>
 <EE0F5EE3-C6EA-4618-BBA2-3527C7DB88B4@blackwall.org>
 <96845833-8c17-04ab-2586-5005d27e1077@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96845833-8c17-04ab-2586-5005d27e1077@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 07:27:25AM +0100, Mattias Forsblad wrote:
> On 2022-03-01 23:36, Nikolay Aleksandrov wrote:
> > On 1 March 2022 17:43:27 CET, Ido Schimmel <idosch@idosch.org> wrote:
> >> On Tue, Mar 01, 2022 at 01:31:02PM +0100, Mattias Forsblad wrote:
> >>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> >>> index e0c13fcc50ed..5864b61157d3 100644
> >>> --- a/net/bridge/br_input.c
> >>> +++ b/net/bridge/br_input.c
> >>> @@ -163,6 +163,9 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
> >>>  		break;
> >>>  	}
> >>>  
> >>> +	if (local_rcv && !br_opt_get(br, BROPT_LOCAL_RECEIVE))
> >>> +		local_rcv = false;
> >>> +
> >>
> >> I don't think the description in the commit message is accurate:
> >> "packets received on bridge ports will not be forwarded up". From the
> >> code it seems that if packets hit a local FDB entry, then they will be
> >> "forwarded up". Instead, it seems that packets will not be flooded
> >> towards the bridge. In which case, why not maintain the same granularity
> >> we have for the rest of the ports and split this into unicast /
> >> multicast / broadcast?
> >>
> > 
> > Exactly my first thought - why not implement the same control for the bridge?
> > Also try to minimize the fast-path hit, you can keep the needed changes 
> > localized only to the cases where they are needed.
> > I'll send a few more comments in a reply to the patch.
> > 
> 
> Soo, if I understand you correctly, you want to have three different options?
> local_receive_unicast
> local_receive_multicast
> local_receive_broadcast

My understanding of the feature is that you want to prevent flooding
towards the bridge. In which case, it makes sense to keep the same
granularity as for regular bridge ports and also name the options
similarly. We already have several options that are applicable to both
the bridge and bridge ports (e.g., 'mcast_router').

I suggest:

$ ip link help bridge
Usage: ... bridge [ fdb_flush ]
                  ...
                  [ flood {on | off} ]
                  [ mcast_flood {on | off} ]
                  [ bcast_flood {on | off} ]

This is consistent with "bridge_slave".
