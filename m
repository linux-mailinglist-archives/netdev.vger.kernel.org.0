Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F0B4FAF44
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 19:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241873AbiDJRWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 13:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiDJRWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 13:22:04 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559623B281;
        Sun, 10 Apr 2022 10:19:53 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 46CF13201DB0;
        Sun, 10 Apr 2022 13:19:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 10 Apr 2022 13:19:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=cuyUckZywUZIygZ8ZXPDDXCDGhQWLlczqmeYcUsJb
        28=; b=Y2sjtjMKmcZN+iFCh6tUH9R8b1YIFSMf47MxY2GFUEI/LzkJm4YgQ7xRW
        8Cz7sAaGDTn/I+kaN8xJae6Zqz0402CY/Y4AYqxdrQDOD+eYKMF8dNfbkLdq3h3C
        w5b/qnHKtUOMmpykk/SsUXHiJ5VD1/K5x9vWzDvjGpnpyvIBu2/M76F3qaXMgVKc
        wNkj9SVI8LbQMsS/Ucn43FOzmkE7JAOr9ZctrwysezMQAryXu7SnGAzcsmjkR+u6
        avT5xcQ87Pvh0E3MRRg/jX5DCjz702OeF70yA1NCuVhPs9bUEA3UByXOrrk/cCXU
        S/fP1Yq79etHPpSGyAaxoo3hDa+wQ==
X-ME-Sender: <xms:txFTYlOdJcMHhK9qCpvHaR0uLC4iFVVtaxnsB6vN1LXAVnpi9mLMBA>
    <xme:txFTYn-q1ixuadHZWK7xbJI6Mof3HYLeC0LDIOADJzaRbkt2Ku-4Pd7cB3v6K2XHd
    nLE_9vcRV7H2XU>
X-ME-Received: <xmr:txFTYkQKCTvlMnDcZOGXFeieE4LEl8S-_3qEKEe8AVgCRnsXmvp_TJJ5dp3Z>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekgedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpeeugfejfeeviedvkedtgfeghfegvedugeevgfetudfgteevveeutdfghfek
    gfeggfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:txFTYhvjpfUyMCWA_iDroIimEHx3YmyOhV4DQnMAkABhc5hFywB_MA>
    <xmx:txFTYte406Q9vQBtdatJAOuQQN-KG68-E3yHi2XdZJP1v-iAH-T_qw>
    <xmx:txFTYt15Ub969jQ5FyOFMplYTLhgK_XMA7xtC67-USbci_ML0tFFwQ>
    <xmx:txFTYnvSy-Px09zQyzzasUP0oH6QKvHfikuRvD8bB8K9_6mQjfoWAQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Apr 2022 13:19:50 -0400 (EDT)
Date:   Sun, 10 Apr 2022 20:19:48 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: bridge: offload BR_HAIRPIN_MODE,
 BR_ISOLATED, BR_MULTICAST_TO_UNICAST
Message-ID: <YlMRtBR3+b4dKjC/@shredder>
References: <20220410134227.18810-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220410134227.18810-1-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 04:42:27PM +0300, Arınç ÜNAL wrote:
> Add BR_HAIRPIN_MODE, BR_ISOLATED and BR_MULTICAST_TO_UNICAST port flags to
> BR_PORT_FLAGS_HW_OFFLOAD so that switchdev drivers which have an offloaded
> data plane have a chance to reject these bridge port flags if they don't
> support them yet.
> 
> It makes the code path go through the
> SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS driver handlers, which return
> -EINVAL for everything they don't recognize.
> 
> For drivers that don't catch SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS at
> all, switchdev will return -EOPNOTSUPP for those which is then ignored, but
> those are in the minority.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

> ---
> Let me know if this is netdev/net material instead.

I prefer net-next
