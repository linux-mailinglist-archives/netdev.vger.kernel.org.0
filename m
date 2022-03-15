Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FABF4D99D2
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 12:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347736AbiCOLBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 07:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347734AbiCOLBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 07:01:33 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566953CFC5;
        Tue, 15 Mar 2022 04:00:22 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id D99753201F82;
        Tue, 15 Mar 2022 07:00:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 15 Mar 2022 07:00:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=NExbxl+i2kuO3Pvzdgbe/Iig/umuCg0Aqp3WMWOTS
        DA=; b=bASI2gJC467wslZAh/G66t63jB1zY0shNB3Wuma/AJ/qKyNks5ywiEv9L
        TjeFFh+XXl3Xba8pswlacUlwKsgv6XjO4tuUavk/8KW8tuiClxHPA2BzZajqfTYu
        I/uZjMvH74mB/42xUXfqjI554e/RudCwZgpyiDh8kDwbjypE18L2y6YKTQmqJzjL
        7mTcc53No0wnYWnN+33WTsR38tuTr69ke7QiYaGaF7iFoR6rqY7RJTwLnaMFAzEU
        wbls6j+7Dt8oirYqY1Dbh6XhryFblkYZRiWcbtVCbeyEXYZsCO5bDI/c5Hr0/QTQ
        zcvbWWTTfSjlrGpd4XCbuUKtKKfRg==
X-ME-Sender: <xms:wHEwYhgcubcKtlyOpo7K_B0uun3VxRqKxmlunBgvA68gC2moawlKPA>
    <xme:wHEwYmCiJIf315nEu7BpADDUVukfgf_NxMFYJRaqsvYGZT5EGvJkD-puNcBQY19W0
    h0lFb_6ICuEujc>
X-ME-Received: <xmr:wHEwYhG7W1ysFc7OfnA3ifivYxnV0YXZaUQMzYoqYvFWRtgU72_pi8NKZHK3p-KHPQaLThhl3M1-tCNJYVScMOWXhDs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeftddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdffveekfeeiieeuieetudefkeevkeeuhfeuieduudetkeegleefvdegheej
    hefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:wHEwYmRYrzN_v3mGacJ4vuIAqMZVJ9Ssevhx1O329QV0o1bOlTijUQ>
    <xmx:wHEwYuw-hvty131IEgbXViDinbwbv6yqrqT6ZCBYi20V2w4V7oFboA>
    <xmx:wHEwYs5uJ987OkhhWOdCaxr-GgSNX_HwXgSsI1sjBCprMFf2yRMhXQ>
    <xmx:wnEwYigrT9dPwh32_Vq4kNc4l-3wK6s2gVqtjVJsaGGjywalncunYw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Mar 2022 07:00:15 -0400 (EDT)
Date:   Tue, 15 Mar 2022 13:00:12 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 1/3] net: bridge: add fdb flag to extent locked
 port feature
Message-ID: <YjBxvM+rYSMP8UNy@shredder>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-2-schultz.hans+netdev@gmail.com>
 <Yi9fqkQ9wH3Duqhg@shredder>
 <86h77zha8b.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86h77zha8b.fsf@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 09:48:52AM +0100, Hans Schultz wrote:
> On mån, mar 14, 2022 at 17:30, Ido Schimmel <idosch@idosch.org> wrote:
> > On Thu, Mar 10, 2022 at 03:23:18PM +0100, Hans Schultz wrote:
> >> @@ -94,8 +95,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
> >>  			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
> >>  
> >>  		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
> >> -		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
> >> +		    test_bit(BR_FDB_LOCAL, &fdb_src->flags)) {
> >> +			if (!fdb_src) {
> >> +				set_bit(BR_FDB_ENTRY_LOCKED, &flags);
> >
> > This flag is read-only for user space, right? That is, the kernel needs
> > to reject it during netlink policy validation.
> >
> 
> Yes, the flag is only readable from user space, unless there is a wish
> to change that.

OK, so please spell it out in the commit message so that it is clear the
flag can only be set by the kernel.
