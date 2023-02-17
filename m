Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39AE69B460
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 22:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjBQVId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 16:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQVIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 16:08:32 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9EA5D3EB;
        Fri, 17 Feb 2023 13:08:31 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 46023320092A;
        Fri, 17 Feb 2023 16:08:30 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 17 Feb 2023 16:08:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1676668109; x=1676754509; bh=L9El2sxbaC
        WCW3Lig4zqm2bK9gkIhgH3AqWexE4Nu1A=; b=OhHZP6H94nplNqrgOyRcOsUifA
        IKHL5qUC8Bo9/bKZni5L3lX4msLofXyLic1enYepG3TwJbjmc3Ia/f8qg3Lq56y+
        Wj5gIo96E2vurjbDm2kn2Qxl+Vzb2IoMi2r0U5JYKWFiyz91wqi1vHMm3QSvvfFf
        KcSMMmALkOy+9x7FdDQY/O5eLpactS4/AhxB/kK9Ku94fHeQwfRg0dB/J3BQePlT
        Kczi34Oy2f5NZR5JD9T5VLkn+YhFEO0TgIORn1pupDbcgjnsaEvKW+M8qXrr6mhh
        PxvPDnfW3XdU/rJV9H562t6VGKV16dkTMFVO4EbpbJ+W8zxqQL3/npvGJ1iQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676668109; x=1676754509; bh=L9El2sxbaCWCW3Lig4zqm2bK9gkI
        hgH3AqWexE4Nu1A=; b=UEiYELPsDIoE/s4vQD8P4qg7XQv9sJVr0a042s0CV7Mv
        EXnZeUj6sd00dyDXviJuXF3tjuUD5jldaCd2BrKLdkdd41+B1S1tWV1t0CElchpV
        xnWjqWPGIYcvt9LoS9cxw5B4ntk4SE9S07qjyvrl6hFQb56kOK1t5Ep485Q4E9HD
        mM769K7DjTXIxx/jhXmtqGV/12erGku/AmShPIa17gZjJyIIrXwgdf+1tW5qBi2a
        1nlH5XCQwuUjXX+MVAx6QnONH7p0hs0GT8aCnB81DrKGJLhgwzhXwMeeWjtVRZRT
        Tj97duWdSQjvp6EJGeq2NjwxEpETfHLwh73qLsAwvw==
X-ME-Sender: <xms:zezvY-v7eDZQdGBBEXQ6jN3gvfknhuPl8zX100rex8seK8Nbj6LaLw>
    <xme:zezvYzeBcjLvxBoY8NyoKjnsQ3qJNMgFXvqx2hEHB_xCfhauK0PZlWXyV0f6KMH3B
    bDfhdcddxkriIUYo3E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeiledgudegvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:zezvY5zG7CKMTd4LC61QHuxYD1nBr3S2OnB2_GGvdmbCJyQSEEh4wg>
    <xmx:zezvY5Mk9D2PFf9UKc-PV57yjjWmxyMACLG7dlw7r2pGtECn-rxNzw>
    <xmx:zezvY-9olycDBqZxCKCBIbpC4cjHxYC14yDYddIUvRtnyeG7Pd3gZw>
    <xmx:zezvYySOCm40Mra5ZxFRpIcpR5pAzbjK0_Mb5wxzm6_MDody9bp0Lw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id B5CC0B60086; Fri, 17 Feb 2023 16:08:29 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-156-g081acc5ed5-fm-20230206.001-g081acc5e
Mime-Version: 1.0
Message-Id: <157c5ae1-b294-4587-8d39-5c5f8b1512e0@app.fastmail.com>
In-Reply-To: <20230217202301.436895-5-thuth@redhat.com>
References: <20230217202301.436895-1-thuth@redhat.com>
 <20230217202301.436895-5-thuth@redhat.com>
Date:   Fri, 17 Feb 2023 22:08:11 +0100
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
Subject: Re: [PATCH 4/4] Move USE_WCACHING to drivers/block/pktcdvd.c
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
> I don't think this was ever intended to be exposed to userspace, but
> it did require an "#ifdef CONFIG_*".  Since the name is kind of
> generic and was only used in one place, I've moved the definition to
> the one user.
>
> Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
> Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
> Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
> Message-Id: <1447119071-19392-11-git-send-email-palmer@dabbelt.com>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  drivers/block/pktcdvd.c      | 11 +++++++++++
>  include/uapi/linux/pktcdvd.h | 11 -----------
>  2 files changed, 11 insertions(+), 11 deletions(-)

I'm fairly sure there are more bits in uapi/linux/pktcdvd.h that should
be in drivers/block/pktcdvd.c instead, along with all of
include/linux/pktcdvd.h, but this change is obvious and safe by itself,
so 

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
