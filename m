Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD676EE9C0
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbjDYVfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236259AbjDYVft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:35:49 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA6F1707
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:35:49 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 9630E5C00D8;
        Tue, 25 Apr 2023 17:35:48 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 25 Apr 2023 17:35:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1682458548; x=1682544948; bh=H5
        8xI9+uNY+E6+RvUMeuSlc4v6NW+SUeaEIGGMQj6Ag=; b=c6YBBN9iFcrZHC+0+D
        FtKIt9ZAd98p5o0wmWhg2kX4u4FBfXn4Q1oXK2+AAwFh8SF8BIuEH2o2bgFDOoPM
        XvpuODEkzNWewCTMIfkh5zI2k6MHGWbh3hnofkmDwawWjNG4UHLYw/SK8tAQ48pt
        R4Fhx1dCP/+TnJ6QKclFdAhFt5fm7V8Vl0QtlbPZkEzHnTJwcytQwP1UsFfhh40T
        fG7lGEG1UfQtnMJ3OGsw3d3o9rm6jUgy5qP5OzR8sa5xNSiOghImXhmtgGUyatsb
        JbiCgpMspO+wBi4msmC/RFwljMQ6+xBK3pF7ldCUojgNL4ByMzllpmPaS9dAyJUr
        isJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682458548; x=1682544948; bh=H58xI9+uNY+E6
        +RvUMeuSlc4v6NW+SUeaEIGGMQj6Ag=; b=EgAuCXXH1d8Rscx8kXtXqXRiL8WMc
        UP3qUeC579TpQZTIY/ip1uCVBX4NhlpAODhJY09h9klRKLaftoleOYVaUPPcU2gk
        EhyLtL5BPdUzcL4CsEVjPCNxkdM5oldbrFJJyZMqX9B6r/WuvjDr58CXNT1awbQ3
        lKW4t3Lv82Mcsy8OItJfQnzr+c7Bk3lW2U4sD5oCZoD103gf35uNiUhkoAXM+oU8
        i44QMvXHkYsUGdTdl888PUZtfKLdZ9P9/Q6xNYcdGGUn8GyCMA5kw3956t1X6Qwb
        pSp+nE2JHK1R/EeEA+VEwRxRHw/OCQGmLtOxr6K+QUfjtOUmOw3w2RX3g==
X-ME-Sender: <xms:tEdIZAaEDbJAdzqfD1LSGdb8vd2xGf152wf2TNEIcVAsF60b-1l2yg>
    <xme:tEdIZLa23CVkI1ka_Osnb8_OIDnZgTO0mwfuDZ8tqYAOsVcs_PT-Auw1tPvDTU6A_
    _AvTaaNN2fs1xKNB2k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedufecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedtkeetffen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggv
X-ME-Proxy: <xmx:tEdIZK-nSaYaessN4ULaAGcRPwmxbrlmIGGjf9azS72rTYtSS0W10A>
    <xmx:tEdIZKoLO5bR2n32B5ccSWrWpOygtW_VoUdchPvfOIKcREr2cob5yg>
    <xmx:tEdIZLp3mmxxFROZ3cL0y2M9IBtsEi8rEyWNtDfwFVwliIlPmdkpkg>
    <xmx:tEdIZMDMjnEwuZPz3hBNx5fEuu18W7ZYV4X0B0sMVldoJHyrwf_Ozg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 0B21FB60089; Tue, 25 Apr 2023 17:35:48 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-374-g72c94f7a42-fm-20230417.001-g72c94f7a
Mime-Version: 1.0
Message-Id: <dfb47650-549e-4e58-9177-fec6ab95b27c@app.fastmail.com>
In-Reply-To: <c783f6b8d8cc08100b13ce50a1330913dd95dbce.1682457539.git.pabeni@redhat.com>
References: <c783f6b8d8cc08100b13ce50a1330913dd95dbce.1682457539.git.pabeni@redhat.com>
Date:   Tue, 25 Apr 2023 22:35:46 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Paolo Abeni" <pabeni@redhat.com>, Netdev <netdev@vger.kernel.org>
Cc:     "Andrew Lunn" <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "Russell King" <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: drop PHYLIB_LEDS knob
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023, at 22:19, Paolo Abeni wrote:
> ---
> @Andrew, @Arnd: the rationale here is to avoid the new config knob=y,
> which caused in the past a few complains from Linus. In this case I
> think the raised exception is not valid, for the reason mentioned above.
>
> If you have different preferences or better solutions to address that,
> please voice them :)

I think using IS_REACHABLE() is generally much worse than having another
explicit option, because it makes it harder for users to figure out why
something does not work as they had expected it to.

Note that I'm the one who introduced IS_REACHABLE() to start with,
but the intention at the time was really to replace open-coded
logic doing the same thing, not to have it as a generic way to
hide broken dependencies.

       Arnmd
