Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2C960BE3E
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 01:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiJXXK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 19:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiJXXK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 19:10:29 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637F82920DE;
        Mon, 24 Oct 2022 14:31:37 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 06C895C003F;
        Mon, 24 Oct 2022 16:47:25 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Mon, 24 Oct 2022 16:47:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1666644445; x=1666730845; bh=bssarCcp+y
        bz5Owzby5mbuikPgqNGdz7c6tjuDYrQ3g=; b=NkbkhwyyD8JqPgTF3GX90T1KBu
        yQ9e/V+AO1CLTjIi8zfuuZgeQvpaXwrxX3ya+3+OrAeyAVYdNmr/+ER8a0OZRltT
        gtBshfPPACEOHBCVWScZexae8sa5OK+3kFWDS8K4B3EEWxyjLrxzofvUU7BQDyaT
        L1ttZShK16j3WsJsBjSZzbUUJG8wqDH6bM0lyj4+iVFQRiMIa6GBfQuRbQWuqoPJ
        nACfYzQR+oRqWGthATSqXV6yjH7CyjTWUlSfLIkIq+ZNPPiP/Ofbzgf09p5Krmms
        xvZ7ssFg9cppnaZVin+3puzx5Y5sPAAoR4QKsYXch+L4FQtwwhLtyQmj8Frg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666644445; x=1666730845; bh=bssarCcp+ybz5Owzby5mbuikPgqN
        Gdz7c6tjuDYrQ3g=; b=drKbqYTA/JMvghcg/uGUzDqCxegdFYCtOvrnfLxKVxsL
        YvvCToAcYe+J+FDw6gKgduCxZBDY5aqlsjNCTNyzcMaeVWGdN54Ee2uu5Qc/iINn
        yDAakJpSu0Oabj+beUPP5mzdiWC0ajS7FxsntXwvgMQeuGThdf4JMTGwovs/WHiQ
        y5bDGDQCpDax8fFUnbjaLlNdbAJieVj4WWwSl4s/ja9SFr+ZJ+BdHqv3Qp9A1GOB
        Jg7yGvTECSNyR15ey/fH8E4j4QwcD6JxUrqgEJQoDkTS6ccSrEo9S44zFMC0ODqK
        ixhR6QkVRTNR4rXGh+00xldsi6GUEOikMEeFxPUiVg==
X-ME-Sender: <xms:3PlWY_8dsRmJoEusUvxzYpneAlbj4D0Va88JoH-QpCpEhfzlCcsO1A>
    <xme:3PlWY7v7ZiKOPhXQSUaFWtVcHadM8SdhtRKwyYRZOSR63Jc7OX8Cm4IJFaVcrRHZZ
    uETvbTcx2CRiykDXO8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgedtgedgudegkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:3PlWY9CIx10DAbClCvAaaTKzMKfdX3FYjdeR1Le5MNK-QKmc5-QUEg>
    <xmx:3PlWY7eMg_ctgRs8qmbJdIMKJhJlN5RjEG9erEWUWCIohDToyFvgjA>
    <xmx:3PlWY0MYZzo6cj_FYlLaDQ_d2nFYY3lbeOWhMkX4XADrN03uytQCkw>
    <xmx:3flWY1FBIFFnkCiZjIK7VUixKdIKbF9oyYYYnwyvqR_F1hN2K0ZZhw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id F3B47B60086; Mon, 24 Oct 2022 16:47:23 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1047-g9e4af4ada4-fm-20221005.001-g9e4af4ad
Mime-Version: 1.0
Message-Id: <3df2007f-acd2-4cd1-8f96-8ebd6070770a@app.fastmail.com>
In-Reply-To: <CAMuHMdWbkro70fmyauUnEPyKZYytWD0o4a06=UzDTzCZ9-B6vw@mail.gmail.com>
References: <20221019083518.933070-3-yoshihiro.shimoda.uh@renesas.com>
 <202210191806.RZK10y3x-lkp@intel.com>
 <CAMuHMdXBT2cEqfy00u+0VB=cRUAtrgH9LD26gXgavdvmQyN+pQ@mail.gmail.com>
 <d7c9b9b4-4ee8-4754-b32f-e3205daf47b3@app.fastmail.com>
 <CAMuHMdWbkro70fmyauUnEPyKZYytWD0o4a06=UzDTzCZ9-B6vw@mail.gmail.com>
Date:   Mon, 24 Oct 2022 22:47:02 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Geert Uytterhoeven" <geert@linux-m68k.org>
Cc:     "kernel test robot" <lkp@intel.com>,
        "Yoshihiro Shimoda" <yoshihiro.shimoda.uh@renesas.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        krzysztof.kozlowski+dt@linaro.org, kbuild-all@lists.01.org,
        Netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022, at 22:35, Geert Uytterhoeven wrote:

>>
>> Regardless of which way this is expressed, it looked like there is
>> a missing __le32_to_cpu() around the high word.
>
> I think it's OK, because desc->dptrh is u8:
>
>     struct rswitch_desc {
>             __le16 info_ds; /* Descriptor size */
>             u8 die_dt;      /* Descriptor interrupt enable and type */
>             __u8  dptrh;    /* Descriptor pointer MSB */
>             __le32 dptrl;   /* Descriptor pointer LSW */
>     } __packed;

Right, that makes sense. On a completely unrelated note, you might
want to remove the __packed annotation though, as the compiler
might otherwise use bytewise access to the dptrl field instead of
a word access, which would cause some overhead in case this is
in uncached memory.

       Arnd
