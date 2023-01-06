Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945BC660891
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 21:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236226AbjAFU6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 15:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235962AbjAFU61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 15:58:27 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE8C73E21;
        Fri,  6 Jan 2023 12:58:26 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 14E165C00FF;
        Fri,  6 Jan 2023 15:58:24 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 06 Jan 2023 15:58:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1673038704; x=1673125104; bh=asiYST5Ghw
        xvQTVw1LJKwe5e2Vz+ZHE03cHN4ukynt4=; b=bCw5+cCEaGZbkn79Md3n/s+2JR
        jZSktKXnrbP2k2QNO/DtQ+6Gwf7M8V79PgGXQ+Uwi501+VljT1lAVzngKKcyIG3c
        bukY+sByr4LYTrNSDqdhs03LmiHl5eN4inMKMUx2/yGRVNZY0evvjduiUhiDQyPL
        JWHZ/BZ+5JQK6ed9tW3dB0bYDix1HiVroiWIxmiC+FdGfgiBwSxVJPCVT0EkV5Ya
        Fb7NokNkpLusu2g64Yk1srsbGnGg69FufTmb88LYJ3KL+berWdwKNp/MJGf7OLuU
        vjGOg+RBLYY5rYX1oMefRdBdBQBs9c3kA7pSjb943evbq46atF9D/+VeW6yg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1673038704; x=1673125104; bh=asiYST5GhwxvQTVw1LJKwe5e2Vz+
        ZHE03cHN4ukynt4=; b=DG00yeM+19g/2hGS1FyWu9dJSrr4+kDzcyS9goTqNyiB
        fq3BuSyZWkU6RsJVlcw3ae1qIdwneyYM46Ttbr+siDwR3iuEk20Cl0X9F8kQIzFs
        epbxucBryVCmcZLmsCbAufiSDVsVQsb+kyicsbJC40Ssgrn65M/rW0haGlgv3gFt
        st5GHDonyN0lv05B0KDO6gA5KDA1Sujd7WGD//8mHNJOvxIVF0avSXO3bclr8hId
        +2oe33Xh6i2y0N9k3i8CsJNK5GUzgWUfQmHXhHkMfg8I6QIgP44l78J70514LA8w
        6vhvykNk8r/xVQ7Mml83ROqOC4wb6QanXcqSQOtuBA==
X-ME-Sender: <xms:bou4Y1Cbo-Wq1Ukal6g9tFmIV9Hhu8vHeaXqlJEYryVYDLGYODQB0A>
    <xme:bou4Yzgd6Zlp4ugKYU9VMX2XVqBm21jrloQiB1vGsig5aZqvc09i_ouBza77Z35Dv
    um6Jrqxrry8inBuvTQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrkedtgddugeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepvefhffeltdegheeffffhtdegvdehjedtgfekueevgfduffettedtkeekueef
    hedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:bou4YwkZgm-tBVfTgr0hD7-8hM3Eiau_tTSUat8Dz3XFTJhuWwI_VA>
    <xmx:bou4Y_wqEoTDKxKfOBIAsq_2o5uFybmlL66MCnGcfJZT6PQjdVfyQg>
    <xmx:bou4Y6R57vIL8B-eJIH1WWnCGA9BrjQ05cVx-xPijQWYDPaqDB_VOQ>
    <xmx:cIu4Y0DFZvH3dukMWRmM8x1xBocb0kNNJ8zfbZCAS24Xl65d9Fr6kA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 58F17B60086; Fri,  6 Jan 2023 15:58:22 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1185-g841157300a-fm-20221208.002-g84115730
Mime-Version: 1.0
Message-Id: <d60047d0-5b0c-4c1e-b656-b7cbc236b23c@app.fastmail.com>
In-Reply-To: <202301061209.4EA0C177@keescook>
References: <20230106042844.give.885-kees@kernel.org>
 <CAG48ez0Jg9Eeh=RWpYh=sKhzukE3Sza2RKMmNs8o0FrHU0dj9w@mail.gmail.com>
 <CAMZ6RqJXnUBxqyCFRaLxELjnvGzn9NoiePV2RVwBzAZRGH_Qmg@mail.gmail.com>
 <202301061209.4EA0C177@keescook>
Date:   Fri, 06 Jan 2023 21:58:02 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Kees Cook" <keescook@chromium.org>,
        "Vincent MAILHOL" <mailhol.vincent@wanadoo.fr>
Cc:     "Jann Horn" <jannh@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, "Andrew Lunn" <andrew@lunn.ch>,
        "kernel test robot" <lkp@intel.com>,
        "Oleksij Rempel" <linux@rempel-privat.de>,
        "Sean Anderson" <sean.anderson@seco.com>,
        "Alexandru Tachici" <alexandru.tachici@analog.com>,
        "Amit Cohen" <amcohen@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Linux API" <linux-api@vger.kernel.org>
Subject: Re: minimum compiler for Linux UAPI (was Re: [PATCH v3] ethtool: Replace
 0-length array with flexible array)
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

On Fri, Jan 6, 2023, at 21:13, Kees Cook wrote:
> On Fri, Jan 06, 2023 at 11:25:14PM +0900, Vincent MAILHOL wrote:
>> On Fri. 6 Jan 2023 at 22:19, Jann Horn <jannh@google.com> wrote:
>> 
>>   What are the minimum compiler requirements to build a program using
>> the Linux UAPI?
>
> You're right -- we haven't explicitly documented this. C99 seems like
> the defacto minimum, though.
>
>> And, after research, I could not find the answer. The requirements to
>> build the kernel are well documented:
>> 
>>   https://docs.kernel.org/process/changes.html#changes
>> 
>> But no clue for the uapi. I guess that at one point in 2006, people
>> decided that it was time to set the minimum requirement to C99. Maybe
>> this matches the end of life of the latest pre-C99 GCC version? The
>> detailed answer must be hidden somewhere on lkml.
>
> I would make the argument that the requirements for building Linux UAPI
> should match that of building the kernel...

I think it's a bit more nuanced than that: glibc does not require
C99 but does include some kernel headers from generic library
headers, so I would not make the assumption that it's always
safe to use C99 features. On the other hand, Linux specific
device drivers whose header is only really used from one
application are free to make assumptions about the toolchain.

      Arnd
