Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97D669B46B
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 22:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjBQVL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 16:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBQVL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 16:11:28 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491A65D3EB;
        Fri, 17 Feb 2023 13:11:27 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id AAC053200344;
        Fri, 17 Feb 2023 16:11:23 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 17 Feb 2023 16:11:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1676668283; x=1676754683; bh=xKH+pAHFPl
        yQWF07l8E7yddR5YbNLQQn3Nc34RH83Qc=; b=Qvbyes9+qymWyQzlx86e9HLgJQ
        4FxbaekFsyUNzLbiETVKwfjrcK6Hguf3dWEbiMc5jMPD1gyOLDuFV9HAdXzcxrjE
        dvlXnBDmLGv/e/MSLl13N+7pBK1x6K6ZKQRye2w5cM4RtTt0bEqNhwKgPrpf8taV
        4adGtD0kxxVrhHhyRv5FM5IlmcMaXab7wOCsiS/aer/DffMiceCM+e3Jer+gSma4
        SdvMtKaCXygCuCw5Qe/6vnRoYrhVAZphGM4KUWyjYS0FCdBKgNSRkQ2IIOfW/w7I
        Hnhaa1B1Dwu0FJH0GakCFg+Qt/U3vAYleMbnW1QOzgbvMs9FdA5rothWooeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676668283; x=1676754683; bh=xKH+pAHFPlyQWF07l8E7yddR5YbN
        LQQn3Nc34RH83Qc=; b=ArZ7RyCnPn5t02SIO/I41ASuPXVAxi/gwG9arhN3x9ch
        pRC4Aj6LMFvKP9Qgp5HSLT1hvuo1vFNXIpyIrBrgYBIfQD7x5o28rTXxXlyxqXUi
        rHqqpfSY6heqUY5I3ZuuoN6BoFAN46nt7f/QRSZyn/aQZGYiJZKcMkIJgaYPhugQ
        S/ZDqdEEivXpxPfirsxUZHA++gMgxTzut8gL2gcgEJURtr2yMbJcTsTvb828yBH6
        YQyhtb/XzMo+BLPhrzZvtXb079iu/s+Zb0p47r7YvTakhCxvMGXJB0eHV6COGVxF
        LMRc6DhBSbvbV3pfNHpywJVx6pARAnlV9tUxXq1IIw==
X-ME-Sender: <xms:e-3vYy6tOZrI7NoLl-XkU2D5z1Rpt11wmOQUf4pRvuEDEz6HjLFFlA>
    <xme:e-3vY74shE6m3Nil1OoZF2o50VO7oUSH1R4lRs0rJ2jNl1u6JhZCfc2LD10YwzxJa
    2u_HGHwXSSEW7kvsPE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeiledgudegfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:e-3vYxcZAimwWNEkBCahbGZmO1Kibl42vr6WJkzfb6KHgVrVf-lKeA>
    <xmx:e-3vY_LEhrC5bOwWRJVGss49qIzODBEhMeiGc9RvZVTqs-8aCTmVdA>
    <xmx:e-3vY2ILr-XmoGD1x-EotK_uaYmSaCQoJUkCAJQ3sOF9WNnYPVjzig>
    <xmx:e-3vY--5RAC9Mv9EexwoEs7rH9wZwFdONmft4Dgld4uUXZj76S-l4A>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 13F90B60086; Fri, 17 Feb 2023 16:11:22 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-156-g081acc5ed5-fm-20230206.001-g081acc5e
Mime-Version: 1.0
Message-Id: <345b62ec-dbdf-4b07-8909-4e5b23b7d8fc@app.fastmail.com>
In-Reply-To: <20230217202301.436895-1-thuth@redhat.com>
References: <20230217202301.436895-1-thuth@redhat.com>
Date:   Fri, 17 Feb 2023 22:11:04 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Thomas Huth" <thuth@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Linux-Arch <linux-arch@vger.kernel.org>,
        "Chas Williams" <3chas3@gmail.com>,
        "Palmer Dabbelt" <palmer@dabbelt.com>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/4] Remove #ifdef CONFIG_* from uapi headers (2023 edition)
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023, at 21:22, Thomas Huth wrote:
> uapi headers should not use the kernel-internal CONFIG switches.
> Palmer Dabbelt sent some patches to clean this up a couple of years
> ago, but unfortunately some of those patches never got merged.
> So here's a rebased version of those patches - since they are rather
> trivial, I hope it's OK for everybody if they could go through Arnd's
> "generic include/asm header files" branch?

I just sent the pull request for the merge window an will be out
of office for most of next week. The patches all look good and
I provided a Reviewed-by: tag in case someone else wants to pick
up some or all of them. Otherwise I can apply them when I get
back.

    Arnd
