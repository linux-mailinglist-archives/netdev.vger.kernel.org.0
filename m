Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015CC4FEF96
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 08:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbiDMGNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 02:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbiDMGNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 02:13:18 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DFB37A03
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 23:10:47 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id DEBE63200953;
        Wed, 13 Apr 2022 02:10:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 13 Apr 2022 02:10:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1649830244; x=
        1649916644; bh=Jmt+YOtDi3H8U74krhGDbZs40tMLJRCUypvQVKK18Cc=; b=B
        PR+QiDCgYhLQSyNcS8fxik/z9bPZHTzW6fX7H72eFIYe4UkHW4Hipj7lee8E3uvv
        T4Tl2Yjr3ANw0wVlzetqsyHad0pk6P8DTAG7k6c7EZzEkIoiegBKOsTiXMKq0iEV
        ko+ytFLZEMdPBrHWXHuTywifv8evyQ8+UIkR8Jk118NmZkIv0p1sqVBHm7EoSpv8
        Pn+SgTUwHAAaJ12kC1tWLRf0s3hzh74xPxgonqm6qBqtgJ1+iZfboC8xZyTmwlTW
        9+toqA/VDMaaRxYPaxag6julecN/76wAhw1VdV4cf0kpBOzVrhOCLeJvvFDdBnqq
        dxg9C3QVvZVo23MjvYcrw==
X-ME-Sender: <xms:ZGlWYmDaHc6eqyBrMReKZiJejv7ltkHA9AW4Ck7H7-H4JnIw1-7FSw>
    <xme:ZGlWYghXXm1yyFYzfK906d5BpGtbGNTbK8MC4bN8yyiqHYIZexuEsgsXzmSB1jFtW
    gCy0eIG7-fCxOY>
X-ME-Received: <xmr:ZGlWYpmWHHafoIOR5m6bgk3U82rfStpzC2dZGP7XwYWQEdNH4Bq0FS7Jik3OP8lABeNZbEz7wxeNVJr8QORHsNNPbjfvUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekledguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ZGlWYkwBacEGCp8WaRU6j1dTIUgH1Apl2DBumjzawnNZF4v89VCbcw>
    <xmx:ZGlWYrSZMwdb9JXsVPsJM6rP7xd-sG7c1Mtk6jb0Rp30S3TSV5gqdA>
    <xmx:ZGlWYvbF5rfNWy0bifCKb5H4_m0k_iWDCHdHzmAgrqgmKfbqpA4ovQ>
    <xmx:ZGlWYmep7LlovhGt-uCslFRGlfS5R52wOBy6dq6FIFqaEnbXhflCyA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Apr 2022 02:10:43 -0400 (EDT)
Date:   Wed, 13 Apr 2022 09:10:39 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net] rtnetlink: Fix handling of disabled L3 stats in
 RTM_GETSTATS replies
Message-ID: <YlZpX6YdMzqDeZag@shredder>
References: <591b58e7623edc3eb66dd1fcfa8c8f133d090974.1649794741.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <591b58e7623edc3eb66dd1fcfa8c8f133d090974.1649794741.git.petrm@nvidia.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 10:25:06PM +0200, Petr Machata wrote:
> When L3 stats are disabled, rtnl_offload_xstats_get_size_stats() returns
> size of 0, which is supposed to be an indication that the corresponding
> attribute should not be emitted. However, instead, the current code
> reserves a 0-byte attribute.
> 
> The reason this does not show up as a citation on a kasan kernel is that
> netdev_offload_xstats_get(), which is supposed to fill in the data, never
> ends up getting called, because rtnl_offload_xstats_get_stats() notices
> that the stats are not actually used and skips the call.
> 
> Thus a zero-length IFLA_OFFLOAD_XSTATS_L3_STATS attribute ends up in a
> response, confusing the userspace.
> 
> Fix by skipping the L3-stats related block in rtnl_offload_xstats_fill().
> 
> Fixes: 0e7788fd7622 ("net: rtnetlink: Add UAPI for obtaining L3 offload xstats")
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
