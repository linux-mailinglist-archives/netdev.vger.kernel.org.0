Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC0D60BC8C
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 23:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiJXVxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 17:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiJXVxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 17:53:35 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E0D2E64BE;
        Mon, 24 Oct 2022 13:07:14 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 350D05C0110;
        Mon, 24 Oct 2022 15:55:54 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Mon, 24 Oct 2022 15:55:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1666641354; x=1666727754; bh=yvZgy+waNc
        ff7yBysOe48rYkSNUahr7uM+2UxFt6Jds=; b=f4Osk4cc2VTIGvDgnG+huMNokj
        v/ZGu2sgLvQ3Z4IQHJDLQdIxYUIR8fLDa7b1xGAzpmwF+ruwmmVsgSQjr5zYfQ4E
        BeFI+rdO2gbAzgIYeAiB0E+Cq4548p3srUv2o0jptxWk4T3EvkvhKp2w7D65lRhv
        1YGXqsPbuAL2IOAhFnCEjuwHIRTf/QWbZTgSYmArEOWsZjZCZCONuuGEPB1sXMcO
        q094EWVweB5KcRxzRZVWk3hs6sIGOazFsa8EYSx+Qi12PHWjfcOX1GpbaVPau/Or
        4gcrtCl4FOH7lKrF+CcWUPAd8ahoEH+FLv+fkis1lfL9Nu3KOypo4ya5p2dA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666641354; x=1666727754; bh=yvZgy+waNcff7yBysOe48rYkSNUa
        hr7uM+2UxFt6Jds=; b=S7taihxHxz2EUQ0dL72kdYybtXC/6+qTCJvHHKKe5oZ3
        w1prI3WpBdkAf+34WmOyO5NH9u+RZcClvBE0ter9dWYffrSvrtaqyR2eAu9adwEX
        0my74u9xtquGR7xyra1s1fYbQpqVuNi6xHNGei+76Efb4/ZqQyREfILrN9c0+n/S
        s/Q5627rFcK1365cdTE7xYKigDhU2qf/yDW0PFmvWsBPzw9Z+5WN0wTTzNlUwHTx
        caA2+tQOtGON9dhcL0CFSi6TIMJraMDAGIiaihFxgqgjM8qMXUFk4oYZmp2Hz+Ot
        t1jtXYmVRmEF+sPsqLXJV/x+vIGomLj7KF814uOLqA==
X-ME-Sender: <xms:yO1WY8MKpDh3CgS3GDY3xy6596feSDDdXidrJf-NWadTzfsBQjIlgA>
    <xme:yO1WYy_jPc0lF-T3lsFam6EQpTOAqJ7lpaH4s9DuSk4pZSvvDMAf3IwygleMXqVnt
    WZ6zEYBgRCUUQPpCzY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgedtgedgudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:ye1WYzRNKiZM83MLr9rc-88a7X8y4AEc2A6rUMEhxjb0K3Z31dGf_A>
    <xmx:ye1WY0sDM8o5pao3_KakHHMdWLZOT2Egqonem2Wji-TNooLHy1mH5A>
    <xmx:ye1WY0eNFTz--jYQjqKiAGU39bUSLdtegu5VAlsj4A0TS6m56eKTEQ>
    <xmx:yu1WY1X_JaE63c9p_TkEWkCezAQERn5P9qrx-IbGBGnRtt2W4L-7zg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id DEFDCB60086; Mon, 24 Oct 2022 15:55:52 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1047-g9e4af4ada4-fm-20221005.001-g9e4af4ad
Mime-Version: 1.0
Message-Id: <d7c9b9b4-4ee8-4754-b32f-e3205daf47b3@app.fastmail.com>
In-Reply-To: <CAMuHMdXBT2cEqfy00u+0VB=cRUAtrgH9LD26gXgavdvmQyN+pQ@mail.gmail.com>
References: <20221019083518.933070-3-yoshihiro.shimoda.uh@renesas.com>
 <202210191806.RZK10y3x-lkp@intel.com>
 <CAMuHMdXBT2cEqfy00u+0VB=cRUAtrgH9LD26gXgavdvmQyN+pQ@mail.gmail.com>
Date:   Mon, 24 Oct 2022 21:55:31 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "kernel test robot" <lkp@intel.com>
Cc:     "Yoshihiro Shimoda" <yoshihiro.shimoda.uh@renesas.com>,
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

On Mon, Oct 24, 2022, at 17:27, Geert Uytterhoeven wrote:
> On Wed, Oct 19, 2022 at 1:17 PM kernel test robot <lkp@intel.com> wrote:

>>    drivers/net/ethernet/renesas/rswitch.c: In function 'rswitch_ext_desc_get_dptr':
>> >> drivers/net/ethernet/renesas/rswitch.c:355:71: warning: left shift count >= width of type [-Wshift-count-overflow]
>>      355 |         return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(desc->dptrh) << 32;
>>          |                                                                       ^~
>>    drivers/net/ethernet/renesas/rswitch.c: In function 'rswitch_ext_ts_desc_get_dptr':
>>    drivers/net/ethernet/renesas/rswitch.c:367:71: warning: left shift count >= width of type [-Wshift-count-overflow]
>>      367 |         return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(desc->dptrh) << 32;
>>          |                                                                       ^~
>>
>>
>> vim +355 drivers/net/ethernet/renesas/rswitch.c
>>
>>    352
>>    353  static dma_addr_t rswitch_ext_desc_get_dptr(struct rswitch_ext_desc *desc)
>>    354  {
>>  > 355          return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(desc->dptrh) << 32;
>
> A simple fix would be to replace the cast to "dma_addr_t" by a cast to "u64".
> A more convoluted fix would be:
>
>     dma_addr_t dma;
>
>     dma = __le32_to_cpu(desc->dptrl);
>     if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
>             dma |= (u64)desc->dptrh << 32;
>     return dma;
>
> Looking at the gcc compiler output, the both cases are optimized to the
> exact same code, for both arm32 and arm64, so I'd go for the simple fix.
>
> BTW, if struct rswitch_ext_desc would just extend struct rswitch_desc,
> you could use rswitch_ext_desc_get_dptr() for both.
>

Regardless of which way this is expressed, it looked like there is
a missing __le32_to_cpu() around the high word.

     Arnd
