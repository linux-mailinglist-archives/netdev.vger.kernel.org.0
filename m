Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5256E8D52
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbjDTIzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbjDTIyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:54:14 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EE940EE;
        Thu, 20 Apr 2023 01:52:22 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 0DB755C015E;
        Thu, 20 Apr 2023 04:52:20 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 20 Apr 2023 04:52:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1681980740; x=1682067140; bh=q5
        mxBDhqof2rSAXuDpt7RtRTf5pystlJ8ajZQHMW6yI=; b=nRmTNulWfXtLThuiCz
        Rm/70Zqjci6zWwWiqnXTOnvsI45xw/aQ5daC63+jt5aS3Rtaftn7zIvrnJzongR6
        LQ2+PCsuMmGEmQJREWQhkK4ZqlhJWruBLATxFk60fy8JDVGnOYwz40u62YgbOXoV
        Skitk3wAuAmcrB4P7rEjaw7rQx77vZH7tiwodhigCif2gz8UlGyCiA1sgbfs24YY
        q7FxV3yPiFbwdeV13+DA2SreM5rrfJ1/QLJSzqATXQggDGvp6XJmOJd81Zmk9zmC
        JMVbVLWiGnsesQRD8ihBvasIRBP3XXQD6VXLz783qdQ0FDw1PAWGAWERwqtrwDgr
        lKjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681980740; x=1682067140; bh=q5mxBDhqof2rS
        AXuDpt7RtRTf5pystlJ8ajZQHMW6yI=; b=J60jxsmJM2OrbfaCfqOlbPUNPMK82
        U/eBAT0eCuaZ2cC2Wn0t9BWWw0dNP83IjyUpwsCMhNT4z1HRF1CyK2/TdcrZnjSJ
        4byybbl25/Df+QJU6hSfPbbrV4VCfkR8XXthoFP8Np8P+MhxB1ZnGBnPYcGZkyLu
        OyI4l+Z72PeUOrd0FXuaNuF+KAwewlrAKmSsU7nn1c20rpDP8VJ3LcCS5NC2BZUe
        1Gp9yap1oST/nYuMIakXx6VQHsDjk9zDwtN26VwWUsrGYPQL9Ms/aQ6XEmkhFExt
        A4DHaCKOKRN9/IkJLvVqaU17JU/9DTkJVuqTmrCWG4JOsbKuOuPEdA7fw==
X-ME-Sender: <xms:Q_1AZKmt-4f5f205DB_xXtbNfNJFBW1ismKZIxbuA4mDXnDmq55Ohw>
    <xme:Q_1AZB3j8PHXnOnSIeT-3RKizcLL9GbIXBzfWu4UPF8kd23vSHj4YqcfQ1o5jlpxK
    NUshHXYhY5-PXxGzpo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedtvddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:Q_1AZIoZueuvwntS_f9RAgDDIPY3R0SKhXQq_-ehmdjefr9gMmR7tQ>
    <xmx:Q_1AZOlH3Sb5CNO-e_5xxDtA4yHZgasujBBDlVeKXPEicGVSeio7Pw>
    <xmx:Q_1AZI244u9QV9m-j6ZC8QJz_8gDo3mVP1C_t3jAiIEw3cKSNZwAHQ>
    <xmx:RP1AZOw0aKt8xWq1d6aJHRUw6BWvYtbbXV1dVuHkG75MUuGqydd_fw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 86365B60086; Thu, 20 Apr 2023 04:52:19 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-372-g43825cb665-fm-20230411.003-g43825cb6
Mime-Version: 1.0
Message-Id: <b1d02aee-17cb-4461-8f02-b5bd513790ae@app.fastmail.com>
In-Reply-To: <9975669b-27bf-6903-f908-184946960c25@gmail.com>
References: <20230418114730.3674657-1-arnd@kernel.org>
 <20230418114730.3674657-2-arnd@kernel.org>
 <9975669b-27bf-6903-f908-184946960c25@gmail.com>
Date:   Thu, 20 Apr 2023 10:51:58 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Tariq Toukan" <ttoukan.linux@gmail.com>,
        "Arnd Bergmann" <arnd@kernel.org>,
        "Yishai Hadas" <yishaih@nvidia.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        "Leon Romanovsky" <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] net/mlx4: avoid overloading user/kernel pointers
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023, at 09:09, Tariq Toukan wrote:
> On 18/04/2023 14:47, Arnd Bergmann wrote:
>
> Now we should maintain the values of the two pointers before any call. 
> I'm not sure this is less error-prune. One can mistakenly update 
> kbuf_addr for example without nullifying ubuf_addr.

That would cause a compiler warning about the uninitialized variable.

> Also, I'm not a big fan of passing two pointers when exactly one of them 
> is effectively used.
> We can think maybe of passing a union of both types, and a boolean 
> indicating which pointer type is to be used.

This is basically what you have today. I've dropped this patch from
my randconfig tree and will ignore the problem.

    Arnd
