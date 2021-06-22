Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738613B0F88
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 23:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhFVVlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 17:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhFVVlU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 17:41:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5767161042;
        Tue, 22 Jun 2021 21:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624397943;
        bh=pptQ00AoHqZUrezNXW2i/eMLGj8TwQiqhCcPQ+pubZw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p6t2lfWg1F4oMbMl9k0/5T2fOBLGI7WaMACmuDE/uvKBsKG1FOARxSWH2xlvrme+2
         2vLEG1BEhXtoJUIcW04e3r99mz8pYqrQXuakIrBeCcUATVTQxtLbNtskU/XbuS5w5/
         rzmXfsyoU9cp07854RYe4ijqwROlrkZ2Cs5+ZA/5NP0hBU4pyAc11n50Gcxa8F5p7r
         e8EMMlUwR9zMHgt4CCYclDueSf9s/+6I5juuc84cZsRLuW9rEtdrC+JCz27+L/z8mE
         Otg2ZKtU9I894kY184+i27dXBFCBNsr+KXnPXBT3QMmbflYELd79ex5/i38qlElmQl
         VbxIy9FXedKiQ==
Message-ID: <d9121e8bf73c5d89f70dbce8e47e0bccff3d0cb8.camel@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: Use cpumask_available() in
 mlx5_eq_create_generic()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Tue, 22 Jun 2021 14:39:02 -0700
In-Reply-To: <20210618000358.2402567-1-nathan@kernel.org>
References: <20210618000358.2402567-1-nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-17 at 17:03 -0700, Nathan Chancellor wrote:
> When CONFIG_CPUMASK_OFFSTACK is unset, cpumask_var_t is not a pointer
> but a single element array, meaning its address in a structure cannot
> be
> NULL as long as it is not the first element, which it is not. This
> results in a clang warning:
> 
> drivers/net/ethernet/mellanox/mlx5/core/eq.c:715:14: warning: address
> of
> array 'param->affinity' will always evaluate to 'true'
> [-Wpointer-bool-conversion]
>         if (!param->affinity)
>             ~~~~~~~~^~~~~~~~
> 1 warning generated.
> 
> The helper cpumask_available was added in commit f7e30f01a9e2
> ("cpumask:
> Add helper cpumask_available()") to handle situations like this so use
> it to keep the meaning of the code the same while resolving the
> warning.
> 
> Fixes: e4e3f24b822f ("net/mlx5: Provide cpumask at EQ creation phase")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1400
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Applied to net-next-mlx5
Thanks!

