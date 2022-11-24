Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2657A637216
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 06:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiKXF5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 00:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiKXF5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 00:57:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D2FC6884
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 21:57:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67D7561F36
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 05:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771FCC43153;
        Thu, 24 Nov 2022 05:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669269431;
        bh=eN25dPj9eU+u89VpM9+duuPRL9u6yQNUzBh11iQJM50=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=IHYqBvq27yC0DGVpvQhKJ+LL+W8KlgFVM/Ue9Hz2m+RbVyfbqax2o87TgNvfTy8OD
         D3lgHI+SEoMLFGeOB7U3pWPusxqlv/8UJ/OAbgO8TdTdjcD+Kv3GGsXvzkRTykfrBS
         FQtXU8wemJppjYLughNRHDOYDu7IaEg2wdeeZsc/tTisFe38Cp2ezPBIhZ6pFBsZPR
         ITS5gA+djKxDwYSMoZ2wms8ktqDGeFIZ3P5+IxcmFuHb+ggss/WS91C+SgPPMcqoJ/
         SzR388MEW5QZ6N//m3NDJXWZa4jnXlJH2R4Q9SCEo4xFvORERHSqeDizNUOl1FmjFi
         rbAZEHXdFTUpw==
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 4EF9827C0054;
        Thu, 24 Nov 2022 00:57:10 -0500 (EST)
Received: from imap50 ([10.202.2.100])
  by compute2.internal (MEProxy); Thu, 24 Nov 2022 00:57:10 -0500
X-ME-Sender: <xms:tQd_Yyq2dR1uBHx9D_vsAdw1kEyTNhSE8dIYCIJ6kYfR9JfvNhMvWg>
    <xme:tQd_Ywpodu-mEZBS-6UVmv3j2K14YzAfyugtdKXmTKRh2nSOv-ANB3H88DjYkHk2k
    oTmHTAIp-W4MT1DbVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedriedvgdekiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdfnvgho
    nhcutfhomhgrnhhovhhskhihfdcuoehlvghonheskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpeegjeevleeijefhffejgedvhfeufedvtddvvddvhfelteejteelgeei
    fedvgfevgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehlvghonhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidquddvfedtheef
    leekgedqvdejjeeljeejvdekqdhlvghonheppehkvghrnhgvlhdrohhrgheslhgvohhnrd
    hnuh
X-ME-Proxy: <xmx:tQd_Y3Oge-N10A6hZnenR4fjlwC3_JWvgSToU6dfBcV2fUx2wDcL9w>
    <xmx:tQd_Yx4PstYXT1cEiHSXQ5QuSt0JtOTXMXWdnnXQDXivx8KLST93ug>
    <xmx:tQd_Yx4oUZMS_zlyG8IQR8PvCdVEtfKHKymLCcgiw8a3Qi_ObwivvQ>
    <xmx:tgd_Y_S1hJwMhD7p8ycAGixbLRprIlwz1C7YyNnBFlLPXuNKFAvW3Q>
Feedback-ID: i927946fb:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A5B5D1700090; Thu, 24 Nov 2022 00:57:09 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <09c5c383-cd98-4044-9155-cbbd7ab41e85@app.fastmail.com>
In-Reply-To: <20221123181800.1e41e8c8@kernel.org>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
 <Y3zdaX1I0Y8rdSLn@unreal> <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
 <Y30dPRzO045Od2FA@unreal> <20221122122740.4b10d67d@kernel.org>
 <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com> <Y33OpMvLcAcnJ1oj@unreal>
 <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com> <Y35x9oawn/i+nuV3@shredder>
 <20221123181800.1e41e8c8@kernel.org>
Date:   Thu, 24 Nov 2022 07:56:51 +0200
From:   "Leon Romanovsky" <leon@kernel.org>
To:     "Jakub Kicinski" <kuba@kernel.org>,
        "Ido Schimmel" <idosch@idosch.org>
Cc:     "Yang Yingliang" <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, jiri@nvidia.com,
        "David Miller" <davem@davemloft.net>, edumazet@google.com,
        "Paolo Abeni" <pabeni@redhat.com>
Subject: Re: [PATCH net] net: devlink: fix UAF in devlink_compat_running_version()
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Thu, Nov 24, 2022, at 04:18, Jakub Kicinski wrote:
> On Wed, 23 Nov 2022 21:18:14 +0200 Ido Schimmel wrote:
>> > I used the fix code proposed by Jakub, but it didn't work correctly, so
>> > I tried to correct and improve it, and need some devlink helper.
>> > 
>> > Anyway, it is a nsim problem, if we want fix this without touch devlink,
>> > I think we can add a 'registered' field in struct nsim_dev, and it can be
>> > checked in nsim_get_devlink_port() like this:  
>> 
>> I read the discussion and it's not clear to me why this is a netdevsim
>> specific problem. The fundamental problem seems to be that it is
>> possible to hold a reference on a devlink instance before it's
>> registered and that devlink_free() will free the instance regardless of
>> its current reference count because it expects devlink_unregister() to
>> block. In this case, the instance was never registered, so
>> devlink_unregister() is not called.
>> 
>> ethtool was able to get a reference on the devlink instance before it
>> was registered because netdevsim registers its netdevs before
>> registering its devlink instance. However, netdevsim is not the only one
>> doing this: funeth, ice, prestera, mlx4, mlxsw, nfp and potentially
>> others do the same thing.
>> 
>> When you think about it, it's strange that it's even possible for
>> ethtool to reach the driver when the netdev used in the request is long
>> gone, but it's not holding a reference on the netdev (it's holding a
>> reference on the devlink instance instead) and
>> devlink_compat_running_version() is called without RTNL.
>
> Indeed. We did a bit of a flip-flop with the devlink locking rules
> and the fact that the instance is reachable before it is registered 
> is a leftover from a previous restructuring :(
>
> Hence my preference to get rid of the ordering at the driver level 
> than to try to patch it up in the code. Dunno if that's convincing.

Before you are doing that, let's remind why we do ordering:
1. It was in happy times when some commands were locked and some not. It caused to very exciting things like controlled uaf, e.t.c.
2. We wanted to provide an access from user space after everything devlink related is initialized. 
3. Allow sane debuggability as some drivers called to devlink_register and unregister in random places.

The locking (item 1) was fixed.

Sent from mobile.

