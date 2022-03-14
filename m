Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092314D893F
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbiCNQew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiCNQev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:34:51 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB4B2726
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:33:39 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8FA7E5C0211;
        Mon, 14 Mar 2022 12:33:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 14 Mar 2022 12:33:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SRDLDi0fWXO5GjYqp
        Qx7AGMDsqNXq+TdiUTIY48TFj0=; b=gEN8S+Ebvm7x6BRrotsgrH7YXGRqw/7UC
        N50ChiPq1ZVajqH4P+7dBKerXJZCySPgHzF7Z7CHnI6OU56n4lBuI8t+eGeP8ai7
        vqiumM9fIRY0frr5CNVjTjrNxFUGcTUg4AuporDoNqhu2UBYEgufXgS5orwpbKEk
        d0W3JGuqOFEUsbt6/2+OB0igveJ0jSF9N9HoMzj/zW2wdXhtJrmRzqV32e26hdZw
        vZAPdRFsT0G4OIyN8P1HD2rK14xunWclEvssQfVY07ce3em2/JNhCT7pG1NVZsoi
        DwgP/tanl50AYVUAqL0vVQMmWZsVANHi1BVzeVARXl8O9G4v7CZ7g==
X-ME-Sender: <xms:X24vYlnUY4aafCynWixUiP6pndkihgStQp_N_iNrwtIOjmXQhFx08A>
    <xme:X24vYg18SyHanJpHKnAeweDoYc6522ANZMMyrJJuFLs73z-afnAkIo2ibqCO0wqz3
    a7NS0MBQmO03nI>
X-ME-Received: <xmr:X24vYrrX85dmEWZF6DlyPgWM-kBOAS3SMfrEiGLqmXa-IQNYn82aXyZ2OfZL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvkedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgvefgveeuudeuffeiffehieffgfejleevtdetueetueffkeevgffgtddugfek
    veenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:X24vYlli_zY6HpTLsg6eUzjcNsfnjeC7zw7U2cEAACNfV50bk1m4sA>
    <xmx:X24vYj2aaPEIxWT6RhMYxDVY-m82_YEuf0LoFrsmIeDEbNFc3SRwAQ>
    <xmx:X24vYksWP1uWCa-dMRFf5ZNuzmQpo04lC1BO7QVNVMtRYzuUZxhpgA>
    <xmx:YG4vYtoBwyrqP_hqf4GV5sm4Eb2oEzOJevtGgEJ6s8XPgiLQq_YxQA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Mar 2022 12:33:34 -0400 (EDT)
Date:   Mon, 14 Mar 2022 18:33:32 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     mattias.forsblad+netdev@gmail.com
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH 1/3] net: bridge: Implement bridge flag local_receive
Message-ID: <Yi9uXGnrrOT13kiI@shredder>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <20220301123104.226731-2-mattias.forsblad+netdev@gmail.com>
 <Yh5NL1SY7+3rLW5O@shredder>
 <EE0F5EE3-C6EA-4618-BBA2-3527C7DB88B4@blackwall.org>
 <96845833-8c17-04ab-2586-5005d27e1077@gmail.com>
 <Yi9tgOQ32q2l2TxD@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yi9tgOQ32q2l2TxD@shredder>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 06:29:58PM +0200, Ido Schimmel wrote:
> On Wed, Mar 02, 2022 at 07:27:25AM +0100, Mattias Forsblad wrote:
> > On 2022-03-01 23:36, Nikolay Aleksandrov wrote:
> > > On 1 March 2022 17:43:27 CET, Ido Schimmel <idosch@idosch.org> wrote:
> > >> On Tue, Mar 01, 2022 at 01:31:02PM +0100, Mattias Forsblad wrote:
> > >>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> > >>> index e0c13fcc50ed..5864b61157d3 100644
> > >>> --- a/net/bridge/br_input.c
> > >>> +++ b/net/bridge/br_input.c
> > >>> @@ -163,6 +163,9 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
> > >>>  		break;
> > >>>  	}
> > >>>  
> > >>> +	if (local_rcv && !br_opt_get(br, BROPT_LOCAL_RECEIVE))
> > >>> +		local_rcv = false;
> > >>> +
> > >>
> > >> I don't think the description in the commit message is accurate:
> > >> "packets received on bridge ports will not be forwarded up". From the
> > >> code it seems that if packets hit a local FDB entry, then they will be
> > >> "forwarded up". Instead, it seems that packets will not be flooded
> > >> towards the bridge. In which case, why not maintain the same granularity
> > >> we have for the rest of the ports and split this into unicast /
> > >> multicast / broadcast?
> > >>
> > > 
> > > Exactly my first thought - why not implement the same control for the bridge?
> > > Also try to minimize the fast-path hit, you can keep the needed changes 
> > > localized only to the cases where they are needed.
> > > I'll send a few more comments in a reply to the patch.
> > > 
> > 
> > Soo, if I understand you correctly, you want to have three different options?
> > local_receive_unicast
> > local_receive_multicast
> > local_receive_broadcast
> 
> My understanding of the feature is that you want to prevent flooding
> towards the bridge. In which case, it makes sense to keep the same
> granularity as for regular bridge ports and also name the options
> similarly. We already have several options that are applicable to both
> the bridge and bridge ports (e.g., 'mcast_router').
> 
> I suggest:
> 
> $ ip link help bridge
> Usage: ... bridge [ fdb_flush ]
>                   ...
>                   [ flood {on | off} ]
>                   [ mcast_flood {on | off} ]
>                   [ bcast_flood {on | off} ]
> 
> This is consistent with "bridge_slave".

And please add a selftest. See this commit for reference:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=b2b681a412517bf477238de62b1d227361fa04fe

It should allow you to test both the software data path (using veth
pairs) and the hardware data path (using physical loopbacks).
