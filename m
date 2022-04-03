Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB5C4F09AF
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344067AbiDCNMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358771AbiDCNMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:12:25 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C8327156;
        Sun,  3 Apr 2022 06:10:25 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 9ECA95C0106;
        Sun,  3 Apr 2022 09:10:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 03 Apr 2022 09:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kadWgdFtb3iFqgErd
        EE2kwIfxrpPk39Vr1ia0EhlfyE=; b=di/51BW7wfwefxfnGxoW7BuOOJPWFu7zm
        UKs5/cSw4MJ1LsZssOZKqmHyiK+H+sxMqcMpN6Hs/+/DtgVj6Pxwc3X1vODjDnzV
        ScI7SxMJk6leN6sZZV7uczNoBd5WXhzZ2mspcqbleD//wkeqUsE/6754SFmqt1tY
        D67GiSXhRwQwTKE0la/V3ysE+EZnAJRpXeSLB8tsEgMxLkpPbPXJUZLjc68upKQ1
        CyX/nWhwft3n/xCb8e/uujSZ/Lxtf5limVKse450ZKWuefeyZeb1IWsyhjqW2HlW
        C6kbq94Og9X2UuenxBODCbsTysVdkNe7s2YQZOSktzm3uHWDiCKOw==
X-ME-Sender: <xms:vpxJYvGdywpLI6TlYgn564YeUYnMIkFPiGkt73uRB2vIWHj1sqgkKw>
    <xme:vpxJYsXhumh2-8d0gtasJs-Me0XWHT9TS8zg-qBerK2b9rsxlDirGBZ2lgpZ-dkJr
    FF9EBKRds5pPdM>
X-ME-Received: <xmr:vpxJYhJ3ZW1rIiG8QVY-wcf4vXPrInW-0dxwK7a75NkzNN7f33-CmuxeBSNx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudejtddgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:vpxJYtFKqWI9pfoRXaOGzQevdurpMiTdm9_KzNxLbSggkvxf5o8l2w>
    <xmx:vpxJYlVlPI4HwQVVqYomxRuFGmNiSR5A5zC_U42mPBBAdGn7ZDl6ug>
    <xmx:vpxJYoMfBHRVphQNuflxl3qiSzDVLrtyP29soNe3sqnLwK9lJ3nphQ>
    <xmx:vpxJYjeTgH54DRtEfAfbcGmWqFMzL5aGLDseC3LAw41QkM9hq3DIwg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 3 Apr 2022 09:10:21 -0400 (EDT)
Date:   Sun, 3 Apr 2022 16:10:19 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Tom Rix <trix@redhat.com>
Cc:     idosch@nvidia.com, petrm@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlxsw: spectrum_router: simplify list unwinding
Message-ID: <Ykmcu5y4Tx8pqhtQ@shredder>
References: <20220402121516.2750284-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220402121516.2750284-1-trix@redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 02, 2022 at 08:15:16AM -0400, Tom Rix wrote:
> The setting of i here
> err_nexthop6_group_get:
> 	i = nrt6;
> Is redundant, i is already nrt6.  So remove
> this statement.
> 
> The for loop for the unwinding
> err_rt6_create:
> 	for (i--; i >= 0; i--) {
> Is equivelent to
> 	for (; i > 0; i--) {
> 
> Two consecutive labels can be reduced to one.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

For net-next:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
