Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681053E9B0C
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhHKWwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232434AbhHKWwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 18:52:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94FB66101D;
        Wed, 11 Aug 2021 22:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628722298;
        bh=cB2L6MUx8kGMhkeB+uVObZmsb1LoatEv33WXmoBhqWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oxKeI3xsiG3i2PEQN5a89JKIDrhSH0Kige5q/CWaxA1HwhIvResFJv4e/YA4dy12K
         wnjgKNFd6FtQEeSBoLvxPq7IbFtWfv+4D7gxozMhN06LrEcNr/CiZlyUivzYngTn6g
         Am/t7WhAzU8Dw/Iq421PlTCzR/uDDYb4fBb/LlffOQ68aZsUVChSuB5c4kdUbdiREs
         7BM4rRIneWGqAcczjP9GWZ5+DgEt7AokHbW1IUZanS2xHbBHexCiI2t+FyZODFkNet
         DDCNiJEsmF8tnGkKknUwaiJuM35eFUBSAT114TEthkiDd8GNy5N272ZgaD+Swjmc5v
         Z9C7l+E577v4g==
Date:   Wed, 11 Aug 2021 15:51:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shai Malin <smalin@marvell.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <aelior@marvell.com>, <malin1024@gmail.com>
Subject: Re: [PATCH] qed: qed ll2 race condition fixes
Message-ID: <20210811155137.5ec90835@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210811162855.6746-1-smalin@marvell.com>
References: <20210811162855.6746-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 19:28:55 +0300 Shai Malin wrote:
> @@ -1728,6 +1746,8 @@ int qed_ll2_post_rx_buffer(void *cxt,
>  	if (!p_ll2_conn)
>  		return -EINVAL;
>  	p_rx = &p_ll2_conn->rx_queue;
> +	if (p_rx->set_prod_addr == NULL)
> +		return -EIO;

Please use !p_rx->set_prod_addr as suggested by checkpatch
