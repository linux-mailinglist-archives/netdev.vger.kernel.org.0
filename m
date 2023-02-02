Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A43688313
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbjBBPvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbjBBPvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:51:19 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F1F10A86;
        Thu,  2 Feb 2023 07:51:00 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 31F625C01FA;
        Thu,  2 Feb 2023 10:43:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 02 Feb 2023 10:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675352614; x=1675439014; bh=JOJYIxLhKlqXLrEBq+v5LlENJBXu
        /0YMWzvW35tuScA=; b=m84jr8rKQV77Hb2CmakvgDV89DA0ahqSC9yuKDL6rjip
        xqThy9a3EDhOe7S1QQXC/FOAlej+sJovhmyCI82ZlkzBXvfb0DKAvIr68wAA0zuT
        lqyMTRCZaPCOfHTJFCDXNq+/G9cOttfUr+M34Ty0V6qCPeARAsRXDJKD7PD7q3Xk
        bDVjhYjpnWTH21BRAtqa4cdgylS7bPRO/pN4REBryibmmeJPZ2Iq582Uhh7z7CfY
        fyUxmXAqFRMj1pvmgaqi9YeXpMOq37zQo5tPy8GaWLs1MEJzdEHMQNJwQb9AYrD9
        ROk/hoKvpk8yF52jkKzvAcLYB4qy1Dhjww3ZrMOMiQ==
X-ME-Sender: <xms:JNrbY1-2B1Jauxz6iGZOPDh_1tGT9yVQ3s2KgkXEtW7DfSfyC0VFmQ>
    <xme:JNrbY5scrKQaLiVv6D_8mJ-I0mWRjpVWOhkdQc5EASB60nIhDMa94q7nVjeru589L
    jFQmbNEyJ8h7dU>
X-ME-Received: <xmr:JNrbYzDIP3-XVCr5kihSOShCyU8ZyFodH-b1PUggVtVh_4JqYg4yMMLfc9lieothdALuf4dLCXL1_DrwOvKehccUe3U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefkedgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepjeekleettddtgfeuvdffieffudegffetgedtteffvefgjeejvefhffehtddv
    ueevnecuffhomhgrihhnpehpohhrthdrshhhnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:JNrbY5fIJu3RkR1-Z8e79Q7xoV9OaVLUEUwi_b44d8SeRnfvpVNsDQ>
    <xmx:JNrbY6PWMusIRYARBSAajbLYQHtybAPmv1lHbV96nnrHdqKmyi-jIA>
    <xmx:JNrbY7lxpopmegWbvsco-sGcH3kOUGGaYqwM6UDLv-IsjOW8EqaH7w>
    <xmx:JtrbY_YdzL_72r4z2IEfXcoob5oPx8XHspmkBS7hMc9LAV-bALXVpg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Feb 2023 10:43:31 -0500 (EST)
Date:   Thu, 2 Feb 2023 17:43:28 +0200
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
Subject: Re: [PATCH net-next 0/5] ATU and FDB synchronization on locked ports
Message-ID: <Y9vaIOefIf/gI0BR@shredder>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <Y9lrIWMnWLqGreZL@shredder>
 <e2535b002be9044958ab0003d8bd6966@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2535b002be9044958ab0003d8bd6966@kapio-technology.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 08:37:08AM +0100, netdev@kapio-technology.com wrote:
> On 2023-01-31 20:25, Ido Schimmel wrote:
> > 
> > Will try to review tomorrow, but it looks like this set is missing
> > selftests. What about extending bridge_locked_port.sh?
> 
> I knew you would take this up. :-)
> But I am not sure that it's so easy to have selftests here as it is timing
> based and it would take the 5+ minutes just waiting to test in the stadard
> case, and there is opnly support for mv88e6xxx driver with this patch set.

The ageing time is configurable: See commit 081197591769 ("selftests:
net: bridge: Parameterize ageing timeout"). Please add test cases in the
next version.
