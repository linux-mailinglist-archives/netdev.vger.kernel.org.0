Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCB6401710
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 09:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240175AbhIFHgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 03:36:48 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:58529 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240166AbhIFHgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 03:36:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 3984632003F4;
        Mon,  6 Sep 2021 03:35:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 06 Sep 2021 03:35:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=A6q0W/
        gxnFX8lyexBH1w45KB8VDWlOQTimwAx/HnyCk=; b=q2de48AaOh5GeDKg/PCGH1
        x4YpJcCLTmP9sPHWKlBlh1sbpJi2lU4mhtLqpwVnqIFExVmPTLNbp+cbNaJl6UIV
        K00OGK5r4nOwDz5AC35A8o4lkIrB3flxG+biyz3tZyp7LZuxHoBHyMLgRcHZKUEz
        tVEu/q5X06ZR1N1lVEEaM75eBgTRibn12vEZsBg182C/RKc1CmcqK+kHqQNi/Ugv
        YBfGLKP9zgRzGu6EwXJESSj3xilh0UjIdbQtQ+x/IFgNLl2Ivle3Ignowv5XwqWl
        sDDFZ+LEMEr4K9or17wisWPYW48TbQ3+p/mx902JiwzE4NrKB4QMsr1BRKlMpdlQ
        ==
X-ME-Sender: <xms:zcQ1YTvQEMOBur7HDbkWvSYhRPAHbika5DqaISJ3nWU18Jjb3GMkCw>
    <xme:zcQ1YUfHl5FM4cD_LCnSZjFgGQIihqpxWCOB8_RWD9Zy84NRuarfINAcmAUkPANyP
    S5t82qBjRvw_as>
X-ME-Received: <xmr:zcQ1YWz7fZmN3GBKUXeG0uMdeLJfwG5MkYz4E5ngrm9mlqYmwy3ApQJJ6uaxuI3ST_dSVYeAklp5H5xS1pvZDSf36T-d8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudefvddgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfg
    keevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:zcQ1YSOB-j4iS-QqdBB5Mme73TniMT9r2NmMVB0yz4geJrZgzJEh5A>
    <xmx:zcQ1YT8yNoOi9HAsF81hx5vMckGpwdv98ED-vYxCEHUZXhEmvIh7dw>
    <xmx:zcQ1YSWbMgTHnG-6Kcq8wPHwfDge6Ya_fwiAtFY-N8oKE3ke8Lqx9Q>
    <xmx:zcQ1YfZOBzXo3z7ElXLiVsyhGw7ZM1QFkMTmP1CZx_OTasPhe_E2Uw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Sep 2021 03:35:40 -0400 (EDT)
Date:   Mon, 6 Sep 2021 10:35:36 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        chouhan.shreyansh630@gmail.com,
        Willem de Bruijn <willemb@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net] ip_gre: validate csum_start only on pull
Message-ID: <YTXEyPf3Pkh5TyuE@shredder>
References: <20210905152109.1805619-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210905152109.1805619-1-willemdebruijn.kernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 05, 2021 at 11:21:09AM -0400, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> The GRE tunnel device can pull existing outer headers in ipge_xmit.
> This is a rare path, apparently unique to this device. The below
> commit ensured that pulling does not move skb->data beyond csum_start.
> 
> But it has a false positive if ip_summed is not CHECKSUM_PARTIAL and
> thus csum_start is irrelevant.
> 
> Refine to exclude this. At the same time simplify and strengthen the
> test.
> 
> Simplify, by moving the check next to the offending pull, making it
> more self documenting and removing an unnecessary branch from other
> code paths.
> 
> Strengthen, by also ensuring that the transport header is correct and
> therefore the inner headers will be after skb_reset_inner_headers.
> The transport header is set to csum_start in skb_partial_csum_set.
> 
> Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
> Fixes: 1d011c4803c7 ("ip_gre: add validation for csum_start")
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

FTR:

Tested-by: Ido Schimmel <idosch@nvidia.com>

Thanks
