Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72351D11CD
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 13:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbgEMLwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 07:52:10 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60179 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725982AbgEMLwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 07:52:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6686F5C00ED;
        Wed, 13 May 2020 07:52:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 13 May 2020 07:52:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0XLue2
        QfJVQ/nueqNbe0kJXKe3qXzDhHzmczgkr+YNM=; b=vIcUolvzGcdag0UocMiV/l
        hWNm0Y6LDrlGPLOvDFuUKNwQEbzfxLNVDtMzzhToAgd4oO52d+f2/6eHbdHIr1Qd
        HmIYKM+Vh4e7dYqy7I+FHGk+ee2Tg1jULF+KHGlDtDhc4iqHWp9f7Tjbx10PMM7r
        nlEI3qa/FEvdbrVGkIvW1qcTs+iNe0iw9aQIaw5YvOio06L+r10E+/jL+5ajXqNm
        HxHz7rlpc6F+Z7i3vRno8J9DVQi9zDYSm/MIVZ2PJXszbHgKkcrNQh3/8LDduOPr
        ob2TxHe3F2sr6Wady1zapgMZKgCkyuNbWBhyAjVDIPPusFpjq/35LM8+XqrtR2Wg
        ==
X-ME-Sender: <xms:ad-7XrEu6ZTKPiXkW7xpNOJG8qRdQMUhZy1MFpVFKy0rCpkG3w0k1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrleeggdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeejledrudejiedrvdegrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ad-7XoUDXrgJgqa6H8-PThP8PaoiexbDOzTDAq8S2E0g5Sgn9SFeOg>
    <xmx:ad-7XtJVLYOtjkqUcj2w3F8Q-Ipz59R-h4QSqhh_OzYuQ1mfNFlnxQ>
    <xmx:ad-7XpGi4xNo5T70nlREqhz8j1QMULGsQlPczyS3FuMv0d12SWZz7Q>
    <xmx:ad-7Xphe9EATpM5BKEF1sLQwv5k3WB3MRwGOgh5vVvvNyghbpWj0ZA>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A75D83066310;
        Wed, 13 May 2020 07:52:08 -0400 (EDT)
Date:   Wed, 13 May 2020 14:52:06 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ignore sock_from_file errors in __scm_install_fd
Message-ID: <20200513115206.GA601862@splinter>
References: <20200513110759.2362955-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513110759.2362955-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 01:07:59PM +0200, Christoph Hellwig wrote:
> The code had historically been ignoring these errors, and my recent
> refactoring changed that, which broke ssh in some setups.
> 
> Fixes: 2618d530dd8b ("net/scm: cleanup scm_detach_fds")
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Tested-by: Ido Schimmel <idosch@mellanox.com>

Thanks, Christoph.
