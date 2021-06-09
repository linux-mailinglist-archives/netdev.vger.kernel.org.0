Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330663A1C69
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 19:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhFISBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:01:15 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54499 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231745AbhFISBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:01:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C8BA65C0081;
        Wed,  9 Jun 2021 13:59:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 09 Jun 2021 13:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OyS7nl
        xq1SYrw+WUKc0O0Z4A8OI01bK+rJe/uwjy9aU=; b=kOdPYrnJnJtiC+tiydMCSp
        HzwLN/J9FhhiCEYehQQ4qh9YySLYQrYZNTz99iF187MD1Y6eGuWkkx7HYoOEDiMn
        uT3596NupWYC47HZ8gez3ofVUnitMxMe+LH2yIaixuwCYyW7SdeNSxtWxHYWfNzZ
        IWSReWtD6FuwoThv5XI/Yyuo6ynNoJwFyYUlEmhC7Lzzx9JvEk0uaLZaR7SvYQjO
        bMY/ugpE1Jgwc77WxTMx21InlfXOCk6i2NkJTupGi+8VemmQPk47xchMCSBksTQM
        xnN8z224OSJrtSGgDHErn4gpeH2ZAC6Xm4W3rqVFaHZt+gDwFatinT4Em1RAtLwg
        ==
X-ME-Sender: <xms:dwHBYLKpVeWZrpnfoXXyY7kdMAuSdYEsyCDbtQQw5O10oGLQ4MUM6g>
    <xme:dwHBYPJI_a8h2ZkmPL_HKoqLEMwc_BvmHTTsdC43nZFi0x9_lYsBFkM1JSCWkyTQM
    tq2qWMrG0pb4FA>
X-ME-Received: <xmr:dwHBYDvT2ZDWffPb3sx9NBJ_XbbvIVzEriXrx_69qZ0Q32oSrllcUsWAsp_ivtZtD8nl5JVeNgUSDairCGgSoBYJwkDHow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeduuddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:dwHBYEZezYnsZ9KH-HlQMKsU-zMAn6HS6wF95-PISlKHhfug6oDFwA>
    <xmx:dwHBYCbM7wchiB2AvbMWM8R8gjor26LyRD3fa8-dHE3fM2djn7MZKg>
    <xmx:dwHBYICscnqwA0hckbaLFvodjAL1mv31wJCc_q4P4CmE9KHpZwVxRA>
    <xmx:dwHBYK7z8mnI1gXWoCXdu_LZjKMPY6gNM7QsZQcsroz3908eY21now>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Jun 2021 13:59:18 -0400 (EDT)
Date:   Wed, 9 Jun 2021 20:59:14 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     jiri@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikolay@nvidia.com, roopa@nvidia.com
Subject: Re: [PATCH net-next 10/11] net: marvell: prestera: add storm control
 (rate limiter) implementation
Message-ID: <YMEBcqqY5PopjRKq@shredder>
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
 <20210609151602.29004-11-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609151602.29004-11-oleksandr.mazur@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 06:16:00PM +0300, Oleksandr Mazur wrote:
> Storm control (BUM) provides a mechanism to limit rate of ingress
> port traffic (matched by type). Devlink port parameter API is used:
> driver registers a set of per-port parameters that can be accessed to both
> get/set per-port per-type rate limit.
> Add new FW command - RATE_LIMIT_MODE_SET.

This should be properly modeled in the bridge driver and offloaded to
capable drivers via switchdev. Modeling it as a driver-specific devlink
parameter is wrong.
