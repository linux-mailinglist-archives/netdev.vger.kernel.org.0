Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84DF1689FF3
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 18:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbjBCRG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 12:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjBCRG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 12:06:58 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2C39D06F;
        Fri,  3 Feb 2023 09:06:57 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 292A65C039C;
        Fri,  3 Feb 2023 12:06:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 03 Feb 2023 12:06:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675444017; x=1675530417; bh=VxXJxYIPXv5W1b2DuSTnG3h266yM
        n84BrwVZXf0OoBE=; b=FF9EwHkwa0Zr/2YgDkYkO260VoVYDFPfdSKIw0xooXry
        POePgsM/c0pJ4275GEWJCj5+R2viqbMMxLWnlJu7PBFfP+p7nqWnlkpI/JyIjgvM
        0BAsN2x3u8KEWhaQamirT/bZGqOUc9Nb+IqdFHay0v1VtPhb9WsAOFzZFHYpVPrm
        ufNgPrK42fo31lVBnNYqODjPWWfxPTXWmqxspIX5OMPa881YYqPx5SwBssMYh/dr
        XEWjfg+V220WXBlFZieLX5wZXmaOuVXePunwWkPm9XjwDVAEM7DaivKJcFH7ZjCG
        y4VHyCoLJu/hMY3gfpYyjmH6ADsgspjUeC/1GampaQ==
X-ME-Sender: <xms:Lz_dY9taAdul_ZgZWNaTYO-qEVnby_sHLAszHSg0iXBGR2nm7Akr7w>
    <xme:Lz_dY2eNDmvUzyk0GXNsDIfmdWhY95FcXjARRvNykL6YYoedPRXAttapptS5ODLlC
    VfQpnQEO-lSMNM>
X-ME-Received: <xmr:Lz_dYwwXkUzytces8t_usahexlD6gvX9QQ4Exhh44r92pdNEMguh4a6bHdllPQED2ZBGR9DaRftVgJgqv8E1k-0vx70>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudegtddgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Lz_dY0MEb-DwR57d-j_Gl-qLoBo2Z2kGUXLpxK3y3eZrGTywkU1aLQ>
    <xmx:Lz_dY9_GIJH5wlD0jcqqs9nty6r4MtnZ0z4h2c9ReT_7obPRqhxGrw>
    <xmx:Lz_dY0WjG3Y2VkkVQbZf0UXtx70DtwKKjWlkjI6FlsMJSQrXRk3YGg>
    <xmx:MT_dY5J8Liv0IRcIZMEe9Y35dJrpbgugWCoCx2bhz1ku66IpEUCVRg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Feb 2023 12:06:54 -0500 (EST)
Date:   Fri, 3 Feb 2023 19:06:51 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 1/5] net: bridge: add dynamic flag to switchdev
 notifier
Message-ID: <Y90/K8BPHijxFZci@shredder>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-2-netdev@kapio-technology.com>
 <Y9qrAup9Xt/ZDEG0@shredder>
 <f27dd18d9d0b7ff8b693af8a58ea8616@kapio-technology.com>
 <Y9vgz4x/O+dIp+0/@shredder>
 <766efaf94fcb6362c5ceb176ad7955f1@kapio-technology.com>
 <Y90y9u+4PxWk4b9E@shredder>
 <4188a35c3c260d8ea2b5f8b2ac0ae6b2@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4188a35c3c260d8ea2b5f8b2ac0ae6b2@kapio-technology.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 05:27:43PM +0100, netdev@kapio-technology.com wrote:
> On 2023-02-03 17:14, Ido Schimmel wrote:
> > 
> > OK, so can't this hunk:
> > 
> > ```
> > 	if (fdb_info->is_dyn)
> > 		fdb_flags |= DSA_FDB_FLAG_DYNAMIC;
> > ```
> > 
> > Become:
> > 
> > ```
> > 	if (fdb_info->is_dyn && !fdb_info->added_by_user)
> > 		fdb_flags |= DSA_FDB_FLAG_DYNAMIC;
> > ```
> > 
> > ?
> > 
> > Then there is no need to fold 'added_by_user' into 'is_dyn' in the
> > bridge driver. I *think* this is the change Vladimir asked you to do.
> 
> I suppose you mean?:
>  	if (fdb_info->is_dyn && fdb_info->added_by_user)
>  		fdb_flags |= DSA_FDB_FLAG_DYNAMIC;

Yes
