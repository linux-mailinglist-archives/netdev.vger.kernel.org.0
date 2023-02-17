Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8678869B456
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 22:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjBQVBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 16:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBQVBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 16:01:48 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3053B659;
        Fri, 17 Feb 2023 13:01:47 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 9AD4932003C0;
        Fri, 17 Feb 2023 16:01:46 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 17 Feb 2023 16:01:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1676667706; x=1676754106; bh=DFgKMC/SX2
        GHEv/K1zSNb50CZY81Bm7Tski0B3YhSjA=; b=c0+G8UEtbiX/7kN5amNNnRLD1K
        0RItuR0X9mJe9yNAYgVJN0g7vzH6FFPs2IQLiX6XGuarxryDJKS8w70dLlF27iWa
        b7ZRPFNPA309arLGH9oe5l1LClscUjDsxpfJE6FE3eZh0cqxOHlh3LZGT8eNB+56
        IF5lEZTP8G3V58WXFjnlA9bwQQZxvjrmuQ0RKl9JFSNk81pH9jxEWbn2LpxTjz6z
        5Of5+RXsuu/OTqDjOu0mRxUNNsXXrEr0M69HFK95ZhooEBjPeq1tUCk74Mak9A9F
        Dhq3+TLnGU8TXyLcM2u9+cbxIR4xs78jgxsNkgs01fQ+IsbmE5l3ht4ohzPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676667706; x=1676754106; bh=DFgKMC/SX2GHEv/K1zSNb50CZY81
        Bm7Tski0B3YhSjA=; b=lXCavbrXc/HI3IwjB9kY3IbUjA4Z7h/TAeDg13K1+3zX
        b96nkCDQZ083YRygMuWIOHq+epFW7jXsf/tuWm1CQ9x2Fw4+Yp8IzU7DMGNncN8P
        l6TWvMTU0fvBR1sXYzquK+Tkb1yam6Ubu22sWHYIcX78FO1ICMUqK34WsxfS260Y
        QK8frgJeHqYjIkBVtk8etOB1ECCegOurbAl45bRLoODw/FUgwjLwP9lkeW8EJrry
        RL0Wf/KDj3HN7lrKyYTtoyF0tYfb+psTAlOwtN1Z9q3rI4ZUtPi74Um45U+uOkrG
        zluo/4xD2O+KE478exZWQGFFSARbs8kO8KNNnOkZ8w==
X-ME-Sender: <xms:OevvYysHe4a7PcbWaxKUFui2xJYV6tWWX85m5_LMyGW_SqaTRbSV1Q>
    <xme:OevvY3fLbPj0Gict8RER3N9WMvZOM6J_YcIhFuwHyoihlKpPjVgDBnxsZyC6_l8H4
    HJ7e3cZmO8bmavPqqc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeiledgudegudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:OevvY9zjM0CbkHFmZFFuTbjuuwW_5DlDLNZVsBaEv6djmwF0Sead5Q>
    <xmx:OevvY9MYgxD7VHqa5SDwYsTfGu24fls26o_3D5PDY55nM5PwQgTNuA>
    <xmx:OevvYy_o5uijJTRVqFOfuVHcLc9ORPCvqvRLFpxl87z3M5piKHHfwA>
    <xmx:OuvvY2R7U6yorCIhs7S9Tk8XgvuZMBsVHucPKBGtCOncfWHWaEF7Ww>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id C3A6AB60086; Fri, 17 Feb 2023 16:01:45 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-156-g081acc5ed5-fm-20230206.001-g081acc5e
Mime-Version: 1.0
Message-Id: <f11e73fc-4698-40d1-b331-0858b0888df1@app.fastmail.com>
In-Reply-To: <20230217202301.436895-4-thuth@redhat.com>
References: <20230217202301.436895-1-thuth@redhat.com>
 <20230217202301.436895-4-thuth@redhat.com>
Date:   Fri, 17 Feb 2023 22:01:28 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Thomas Huth" <thuth@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Linux-Arch <linux-arch@vger.kernel.org>,
        "Chas Williams" <3chas3@gmail.com>,
        "Palmer Dabbelt" <palmer@dabbelt.com>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net,
        Netdev <netdev@vger.kernel.org>,
        "Andrew Waterman" <waterman@eecs.berkeley.edu>,
        "Albert Ou" <aou@eecs.berkeley.edu>
Subject: Re: [PATCH 3/4] Move bp_type_idx to include/linux/hw_breakpoint.h
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023, at 21:23, Thomas Huth wrote:
> From: Palmer Dabbelt <palmer@dabbelt.com>
>
> This has a "#ifdef CONFIG_*" that used to be exposed to userspace.
>
> The names in here are so generic that I don't think it's a good idea
> to expose them to userspace (or even the rest of the kernel).  There are
> multiple in-kernel users, so it's been moved to a kernel header file.
>
> Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
> Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
> Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
> Message-Id: <1447119071-19392-10-git-send-email-palmer@dabbelt.com>
> [thuth: Remove it also from tools/include/uapi/linux/hw_breakpoint.h]
> Signed-off-by: Thomas Huth <thuth@redhat.com>

It took me a while to understand this code enough to be confident this
is the right solution. Note that CONFIG_HAVE_MIXED_BREAKPOINTS_REGS is
purely dependent on the architecture and could be replaced with something
that checks for x86||sh but it should be safe to assume that the
enum should never have been part of the uapi header.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

      Arnd
