Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3DD69B448
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 21:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjBQU55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 15:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBQU5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 15:57:55 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E22BDC9;
        Fri, 17 Feb 2023 12:57:53 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 174D9320091A;
        Fri, 17 Feb 2023 15:57:52 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 17 Feb 2023 15:57:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1676667471; x=1676753871; bh=5hO9LLR2W0
        xHcy7Yt7iE5SJ4npoURkf3C5/71nQz3bc=; b=b/kou7Kih7Mrd8QRigzir5c4so
        11hwrrJ1V8OhJWqmFqgk8SqPUOVfo4kLIsF55y4yw0kQbHXfgyQJ4qCo3iT/CSqT
        +OeVt8WZnBfKMn5okT9/XqMy/5+l569mXhp5nROvXGss92fNpfVYGTmGsfXoIeF1
        +ChpF7JF1lJyPncIk0UO4Br3DsdAbx00gKjBewVswZSIR8YVZv5WgEjYgwcE/PJo
        FhKRH1IkjXBe0Ys/EUaoflGryH/FQV0bg9FXpcsu4R+/UngsU7qEWjTR5lKxin9G
        OKsx0LZDDeR1d10DiLSZklndD8UtCwd2/USzRDZx2f+ebYNC4MpXkAknk/6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676667471; x=1676753871; bh=5hO9LLR2W0xHcy7Yt7iE5SJ4npoU
        Rkf3C5/71nQz3bc=; b=JAT8MwzYDvXU9FjmWdaNmRa7mdUAB7QJH5SNl8yYwruO
        WyoyPvnaljbt0FNwqRZ2LjUuQI7366GDobSNrAQy3Y0SMBonqDcB2idv37VthcBW
        aMhlJokfqtbKrb0CNrFKIKkZPCkUclFd8fZ3o5qWHd6Vlz3L0O9+DHXeTC/vfPf8
        EVkzBAuajKyxZ8ol/I72d+nV8IYJ3X6353EgjrLp/UtIG8OXoWTJkNqFaXYv2uHZ
        +s13609OSOgbezOT9OBW56VzY3fl47skCTbXoRWwc7vAdmVLn/YFhXq4LrDxs6pv
        qoX3vLCOV6S81n2sbJgk2OrM2sFSEdWfqZ0+YOb7eg==
X-ME-Sender: <xms:T-rvY7sjUBBkzry9XAr_CLnaBFWEc9fM2aNb7iwotOAdgjIMdyxfog>
    <xme:T-rvY8dUk1RmhdQLomHhe9ezA8ktievgofIJRx4UxtZ79zXbZyYFs9fOOliYPnx6e
    Vl1E7LtzxyRIzOaLwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeiledgudegtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:T-rvY-w6uhGkqpLZ7FglygJ5qqPg42HCOQkEnwTJC8mW7OIsI4nkng>
    <xmx:T-rvY6OKrhv-6qxGoCYV0mb-msuGrnuZMkwcAHkWSujbSNkUIrzXdw>
    <xmx:T-rvY789Z_7mmH32bzt0aow5BsWZn3bgdC3PGp1zoyM5CNcILmFjvA>
    <xmx:T-rvY3S2XV_oQelyUuABjTUH6tluwDnklj6bVHHXc2nqQlcZl6aKRQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 46BABB60086; Fri, 17 Feb 2023 15:57:51 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-156-g081acc5ed5-fm-20230206.001-g081acc5e
Mime-Version: 1.0
Message-Id: <5d623706-1458-4bb2-8e70-7e1a7dec1c15@app.fastmail.com>
In-Reply-To: <20230217202301.436895-3-thuth@redhat.com>
References: <20230217202301.436895-1-thuth@redhat.com>
 <20230217202301.436895-3-thuth@redhat.com>
Date:   Fri, 17 Feb 2023 21:57:34 +0100
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
Subject: Re: [PATCH 2/4] Move ep_take_care_of_epollwakeup() to fs/eventpoll.c
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
> From: Palmer Dabbelt <palmer@dabbelt.com>
>
> This doesn't make any sense to expose to userspace, so it's been moved
> to the one user.  This was introduced by commit 95f19f658ce1 ("epoll:
> drop EPOLLWAKEUP if PM_SLEEP is disabled").
>
> Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
> Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
> Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
> Message-Id: <1447119071-19392-7-git-send-email-palmer@dabbelt.com>
> [thuth: Rebased to fix contextual conflicts]
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
