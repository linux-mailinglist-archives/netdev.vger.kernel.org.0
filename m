Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A203666E89D
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 22:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjAQVj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 16:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjAQViT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 16:38:19 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA1D2CFE4;
        Tue, 17 Jan 2023 12:01:25 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 108925C00E9;
        Tue, 17 Jan 2023 15:01:24 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 17 Jan 2023 15:01:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1673985684; x=1674072084; bh=tMyHBVcYNG
        0ERO4S5Q8/K/ngC+15RRvO4SZa46EllSw=; b=e/I7Bu6JmmSGgy3u4WX+iD+QMX
        i2eQ5+cEbaTu38BxSpYEjKFtGNT7PSo4U7WFgF4ABTLwLQ7Xh+N5CCqUebDEkUiX
        aYahBdbKsHZu43my0QuBJ5Uclm6GNOp/2XmtY1lCkijJdiOeZGWidyeT0pI0OEeb
        wJf2cmmrFYDhXztF2bQ5jLjW+FIdZ8Fc2YDIC3R8THV7H10UAW1WCJTpGR5lz/s5
        97JI1LDDjqyYs684EKx673zOjv5kmJbEq81LOYrawAaz6XIpZdS7CVuHnuPp5Atb
        s8p547yb1vivVMq6SaW6n7fZChEjkoYVlGkFBa4GjtxVPE+VGxQ/EGYEvnoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1673985684; x=1674072084; bh=tMyHBVcYNG0ERO4S5Q8/K/ngC+15
        RRvO4SZa46EllSw=; b=r0/igWbp96bDczPUdGiDuVQOZk8DlgxsYWPQXTZq9fJ4
        cbF2zV+baxa3Ca9K/3BAxQEYq/FOgnP/kKebLY6L5cyR6v5a2VWUJjMwWPBW/wg9
        ohKcrpd4OdmuVIrhfXUQyRzghFXJ4Ra45NcS3FAOlfSxxsSnbTYuS86CpEMzPU8V
        ypWiQgVmg/llOUBdFWRQfDCnqp7mpBYaEV0xYBNJcA+G27Ba2vreV1jP3AKu0Lp3
        SmkaMFnDLx3BggpIa8EdbDx/QmqXf6yLAOGZdB3YD34+5tkODhp2VII4p5hE4fLJ
        1NVEz9GnMx1Hz4KMtAwZz8F/ur/YZdhmbpLH+eGQqA==
X-ME-Sender: <xms:k_7GY8LW8h2_wNKJSUM2TFzFq56zfzh_EiHL4v4e57MQuLmniUnaUA>
    <xme:k_7GY8LYJWyfAJs1_c_mWNnr4ZJDz46ELzc_HWIcTPzheWUirzILxNR5Iw5sslUUw
    tQGWFi3q7cdnAMrfko>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddtiedgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:k_7GY8vuExMOsyJ81lxn_vgndy1Y-xDoEhpmxcsvofAiP-ITIAPkfA>
    <xmx:k_7GY5Z6Dnp88oXouzKtLwyKb1DWtOu9uC4pnL_E9WIQsHuz7OxO2g>
    <xmx:k_7GYza62EwHI5CUM1-hB40biML0yder_VcCrH57XwRSnAkME6WnDQ>
    <xmx:lP7GY5sqpwy3X9FiXGNCey3fbbDJTBqnXvKJjiXMrRfogFAbcVEsUw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 69C92B60086; Tue, 17 Jan 2023 15:01:23 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1187-g678636ba0d-fm-20230113.001-g678636ba
Mime-Version: 1.0
Message-Id: <4c4478d3-5b11-450a-9b6d-9e30e52b8f6d@app.fastmail.com>
In-Reply-To: <98636010-fb0b-1771-e81f-cce90740d358@gmail.com>
References: <20230117172825.3170190-1-arnd@kernel.org>
 <98636010-fb0b-1771-e81f-cce90740d358@gmail.com>
Date:   Tue, 17 Jan 2023 21:01:03 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Tariq Toukan" <ttoukan.linux@gmail.com>,
        "Arnd Bergmann" <arnd@kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        "Leon Romanovsky" <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Nathan Chancellor" <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        "Tom Rix" <trix@redhat.com>, "Tariq Toukan" <tariqt@nvidia.com>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>,
        "Gal Pressman" <gal@nvidia.com>, "Lama Kayal" <lkayal@nvidia.com>,
        "Moshe Tal" <moshet@nvidia.com>, Netdev <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] mlx5: reduce stack usage in mlx5_setup_tc
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

On Tue, Jan 17, 2023, at 18:46, Tariq Toukan wrote:
> On 17/01/2023 19:28, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>> 
>> Clang warns about excessive stack usage on 32-bit targets:
>> 
>> drivers/net/ethernet/mellanox/mlx5/core/en_main.c:3597:12: error: stack frame size (1184) exceeds limit (1024) in 'mlx5e_setup_tc' [-Werror,-Wframe-larger-than]
>> static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
>> 
>> It turns out that both the mlx5e_setup_tc_mqprio_dcb() function and
>> the mlx5e_safe_switch_params() function it calls have a copy of
>> 'struct mlx5e_params' on the stack, and this structure is fairly
>> large.
>> 
>> Use dynamic allocation for both.
>> 

>>   
>> -	err = mlx5e_safe_switch_params(priv, &new_params,
>> +	err = mlx5e_safe_switch_params(priv, new_params,
>>   				       mlx5e_num_channels_changed_ctx, NULL, true);
>>   
>
> Is this change really required, even after new_chs are dynamically 
> allocated?
> As this code pattern of static local new_params repeats in all callers 
> of mlx5e_safe_switch_params, let's not change this one alone if not 
> necessary.

I'm not sure any more now, I actually did the patch a few weeks ago
and only now came across it while going through my backlog.

Generally speaking, the 'new_params' structure on the stack is
too large, but I no longer see warnings after my patch.

> Same for the noinline_for_stack. Are they really needed even after using 
> dynamic allocation for new_chs?

I've reverted both of those hunks now, let me try reproducing the
original randconfig reports and see what still happens.

   Arnd
