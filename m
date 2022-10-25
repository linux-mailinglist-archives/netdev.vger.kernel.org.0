Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A29360C4CF
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiJYHQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiJYHQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:16:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A743E1CB1D
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 00:16:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5F3DB81ACB
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A516C433D7;
        Tue, 25 Oct 2022 07:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666682161;
        bh=KzUhi0zCB6lAslcWzbGspOlS8kcrcKk5VfWd1GQkrxY=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=d/dVSLf6hjMufKt23gtQZ9ldqmtaObFtOP/XhROM8OoM73NNzG+MFcdsrYSjPle+F
         K3MG5ogGz4MWETuBNdkJbCp5EHKcBGqNe9Q9NL+/vM1eqsS8+KjShVE3NISINkLvz1
         Iz/hL10hJ9Etn0N0iSLNs8v5qwFsl9p1A1BLkL7Wvsb40rji6oPaIzieKnQasB3YrD
         hawsXAEXChV5bahmQW05oXKayZxDy8NwIL0LucQGTPBZwPO6thhMuex/0xmB0LrwZw
         lOwOv2SH1gfG+Tk+xRjUnVqmUgeplAt07oAe9c3PQW/1gcfY35cHYhn6z3VjmrYlz/
         oyCojIzSjhGLQ==
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id BF67127C0054;
        Tue, 25 Oct 2022 03:15:59 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Tue, 25 Oct 2022 03:15:59 -0400
X-ME-Sender: <xms:L41XY5_L8y7eTuM08xClW3GCKYpybgkeb3CMZqvR5a53Jbr9FHrvkg>
    <xme:L41XY9uoSOeA7Qqqg5fOAE6hhN9sbMK-Eu-JIujXDJBvO-ZaaGs4uhPGPQsa5WgTA
    K8p13jhkYukjycQzbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgedthedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugeskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpeelvefgudeiheefledttedthfffgfekudegkeelffdtiedvgfevieet
    teekheffveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhguodhmvghsmhhtphgruhht
    hhhpvghrshhonhgrlhhithihqdduvdekhedujedtvdegqddvkeejtddtvdeigedqrghrnh
    gupeepkhgvrhhnvghlrdhorhhgsegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:L41XY3D_6Eyx0r0V8givRZCAYZtkLz6NG8BpAkf4P4qkeemZA3hJTg>
    <xmx:L41XY9fO1vTZXPdAotX4Ti_XyaKsl9NzE6kSjjMyJ36YexN1jieNmA>
    <xmx:L41XY-P_wpmlUKxTroX6KgS9Plcxvy9kXrYwdEsjASZJorUb3uVHaA>
    <xmx:L41XY7pTpkAMZdkrZJHKkCsd3Drih-ISqLIfG8FlXByizIFxhZRU-g>
Feedback-ID: i36794607:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 4CB5EB60086; Tue, 25 Oct 2022 03:15:59 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1047-g9e4af4ada4-fm-20221005.001-g9e4af4ad
Mime-Version: 1.0
Message-Id: <e490dd0c-a65d-4acf-89c6-c06cb48ec880@app.fastmail.com>
In-Reply-To: <20221024145048.2b679a59@kernel.org>
References: <20221024144753.479152-1-windhl@126.com>
 <CANn89iL==crwYiOpcgx=zVG1porMpMt23RCp=_JGpQmxOwK04w@mail.gmail.com>
 <20221024145048.2b679a59@kernel.org>
Date:   Tue, 25 Oct 2022 09:15:39 +0200
From:   "Arnd Bergmann" <arnd@kernel.org>
To:     "Jakub Kicinski" <kuba@kernel.org>,
        "Eric Dumazet" <edumazet@google.com>
Cc:     "Liang He" <windhl@126.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Paolo Abeni" <pabeni@redhat.com>, Netdev <netdev@vger.kernel.org>,
        "Doug Brown" <doug@schmorgal.com>
Subject: Re: [PATCH] appletalk: Fix potential refcount leak
Content-Type: text/plain
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022, at 23:50, Jakub Kicinski wrote:
> On Mon, 24 Oct 2022 08:36:13 -0700 Eric Dumazet wrote:
>> IMO appletalk is probably completely broken.
>> 
>> atalk_routes_lock is not held while other threads might use rt->dev
>> and would not expect rt->dev to be changed under them
>> (atalk_route_packet() )
>> 
>> I would vote to remove it completely, unless someone is willing to
>> test any change in it.
>
> +1 for killing all of appletalk.
>
> Arnd, I think you suggested the removal in the past as well, or were
> you just saying to remove localtalk ?

As far as I can tell, there were no objections to removing localtalk,
and definite upsides to removing the last such driver (CONFIG_COPS).
Similarly, it seems that IPDDP (IP tunneled through appletalk) can
probably go, even though it does not depend on specific hardware.

According to Doug Brown, only ethertalk is used in practice, but
there are definitely users of that. See [1] for the thread from
when this came up last.

     Arnd

[1] https://lore.kernel.org/netdev/9cac4fbd-9557-b0b8-54fa-93f0290a6fb8@schmorgal.com/
