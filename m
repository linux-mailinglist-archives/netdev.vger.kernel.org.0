Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6063E67D2F3
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjAZRWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjAZRWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:22:07 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87FE4EC6;
        Thu, 26 Jan 2023 09:22:05 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 3BB6C320025E;
        Thu, 26 Jan 2023 12:22:04 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 26 Jan 2023 12:22:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1674753723; x=1674840123; bh=lchpYIwX9G
        nBz6PZodYl9e/i17PoYPm7G2B03axTOyA=; b=A8uAcpS8Huw2ox4lR6S4KJpkth
        7AUJqUp2zCXIYC5IDZS61ZC7L76qZhdbWNXGL56/TpRMhIXcI92fKQuO2bgf3Wr5
        O+FXQ039sFNm28+7y3uEgUeKXNSSk6KHVvXAHy3n3IpWLf8Vas/Pu1TSpqXy/ygP
        GjjTgUOjJ67tQY5mToGv25u6Niyjo2q9JydQR02+/+8G9/5tn9n1Jcc7YICfssly
        WVs7R+bjMis+M1wl5DVJJyBOps9jpoR0chBfgBRxjAHAr6aZPbUMyIntYGPss2cy
        CrEOyM3C38//egROT0M2+lxrEEa9gWnubfKJiSakdwxjahLn58h2PqohZBig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674753723; x=1674840123; bh=lchpYIwX9GnBz6PZodYl9e/i17Po
        YPm7G2B03axTOyA=; b=MX9TL6igSoEDIg7cFuLOnZqBKdwgifBJEhzh5gDeTJVO
        1+FF1d+uqvJ8RdDwa3Hh8cUYAETskRlVMB/ZuwXuovb8zeIg1LZgAQWiv3SPRmOZ
        FdW4GkmqaFLFARh0EioGcjd17evb2kDrSUXytEYdE68ydZpWP8jE+N0cVCuIDtLl
        FX+/7PdkZNbPTeP328Pw7kIq3fewkFpIoz6LqWLMciNo+tS4SFumvIH6n50K+yr3
        +RqzXsLKSs28cM6CRO6PFihBPWZZVjECBVaHGV5/7OEQAJrpixyZqgmaCwtDCKQY
        ZCVrm/vnn3tinsSZAwYZI9rUBf+j8GhxYHhiCSrMNg==
X-ME-Sender: <xms:urbSY2Ea6lOMQQn_TX4uQJgMNRY-Lc0Y0bUyKo7WxEKlDcQmZ86AXA>
    <xme:urbSY3V9wsUWmxE3jcwvvBFqsdHwBwI9Zem28LC4D3oW_5YBYFsRofZU_QlFOJ6fv
    -mS8BWzSsBMNksjrBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvgedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeevhfffledtgeehfeffhfdtgedvheejtdfgkeeuvefgudffteettdekkeeu
    feehudenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:u7bSYwLhwgWinmZK-tFmtjpAhNSlv9JesjDK1sUGulTvr7QyzjavLw>
    <xmx:u7bSYwEG3fiOLYTlRM_s04Y3VnJsB2L951vYX72KYq_Oc4ClgKzuCA>
    <xmx:u7bSY8U4sCy-k4ODDQb59EmiireUieZyCBeAQ_SSMjZtxHFtGua6AQ>
    <xmx:u7bSY1OG2uLvSOdrxhQtlLLzM6KZEG8vFW4_EzkuJoKj8KFaFjYXDA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 756CEB60086; Thu, 26 Jan 2023 12:22:02 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-85-gd6d859e0cf-fm-20230116.001-gd6d859e0
Mime-Version: 1.0
Message-Id: <30d80e40-eab8-4da3-bbf2-be90ebc8f46d@app.fastmail.com>
In-Reply-To: <20230126164046.4sk5qaqiwgygt2cg@skbuf>
References: <20230126163647.3554883-1-arnd@kernel.org>
 <20230126164046.4sk5qaqiwgygt2cg@skbuf>
Date:   Thu, 26 Jan 2023 18:21:43 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        "Arnd Bergmann" <arnd@kernel.org>
Cc:     "Claudiu Manoil" <claudiu.manoil@nxp.com>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, "Andrew Lunn" <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, Netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mscc: ocelot: add ETHTOOL_NETLINK dependency
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023, at 17:40, Vladimir Oltean wrote:

> Thanks for the patch and sorry for the breakage. This is now fixed by 
> commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=9179f5fe4173

Looks good, thanks!

     Arnd
