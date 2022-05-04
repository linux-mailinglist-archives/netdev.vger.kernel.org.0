Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E2A51AB13
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 19:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356820AbiEDRly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 13:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356819AbiEDRkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 13:40:18 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4E648E40
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 10:06:55 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id C0772320084E;
        Wed,  4 May 2022 13:06:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 May 2022 13:06:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1651684011; x=
        1651770411; bh=1uR1zchg6tb3lTxKDFINJYTqVlT5+21Q5ImJABRuxsA=; b=i
        MJ4/VOF+8SF4hg87e9SV6Q/0kO9otfwUlLhyhtpBCbDBx/6YAJP4gljfrBgBlIFo
        reDBmq/XrDotX72l/bbGPBIMV08bqfnBnR3WqupKlpifOPa/ttvqO0faonUU6r9E
        TYjvxKSRGW8aGATwjz4KZzxCNehM9ZdSWbMa8sQ/Qf5AEXStCXAk+FpUCfmXJKcs
        Jca+IBwoI/EpEcNtMEOiybGcQ+dWDDIJLwajkapVBPhtu6Uf2VN5jP5n4omDvPxK
        07YBanqjcrRNWMgw9h5xCCVe+DjkxqbMj00LiBmS5kLjCxGrQDmlkRg8tlmUKUTO
        FgblNZTjtFuXg0DMjN5lA==
X-ME-Sender: <xms:qrJyYv_HRpGf2yc7DDlfwuw5U0iac9xuxPmZgwB-WVTlJP3Ru_GmzA>
    <xme:qrJyYrtd3DufwUV_UWW5qMSVkFduCb9MJO7yq_QYuAaV9uf1fw3MlUImpGjyxi889
    KTREPplZvdJHwI>
X-ME-Received: <xmr:qrJyYtBCzgLqWlOev6H5-F3n5MIO68UXs7EFqWOkLUYsjyviusBTxWDSilHcpKdzIk0nGvWv3Y5pIJ6kOEAe7Hvqvgs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdelgddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeehhfdtjedviefffeduuddvffegte
    eiieeguefgudffvdfftdefheeijedthfejkeenucffohhmrghinhepkhgvrhhnvghlrdho
    rhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:qrJyYre-fL5S_BbUicWlMj1dJ0Bjbnn0Ls-WtYssKCNn_bk9QhIvEw>
    <xmx:qrJyYkNibe1FGdLrA2-vCYcAUZQDXjEoq7AENWfZuaoCYTpYL9wYmg>
    <xmx:qrJyYtmkhY77Cs64EzIUo_ZhJOVQR2hDXvA3dWDR7Fnd3rqxRee-Yg>
    <xmx:q7JyYgArgluuWN8glna3zw9InigQW4VXJDOQuGK96P0xEIUoTnWW6A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 May 2022 13:06:49 -0400 (EDT)
Date:   Wed, 4 May 2022 20:06:46 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, idosch@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com
Subject: Re: [PATCH net-next] Revert "Merge branch 'mlxsw-line-card-model'"
Message-ID: <YnKyptCf6Ztnk4Uv@shredder>
References: <20220504154037.539442-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504154037.539442-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 08:40:37AM -0700, Jakub Kicinski wrote:
> This reverts commit 5e927a9f4b9f29d78a7c7d66ea717bb5c8bbad8e, reversing
> changes made to cfc1d91a7d78cf9de25b043d81efcc16966d55b3.
> 
> The discussion is still ongoing so let's remove the uAPI
> until the discussion settles.
> 
> Link: https://lore.kernel.org/all/20220425090021.32e9a98f@kernel.org/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
