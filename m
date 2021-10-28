Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B8043DABC
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 07:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhJ1FcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 01:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhJ1FcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 01:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47F1260E78;
        Thu, 28 Oct 2021 05:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635398987;
        bh=+uNFoSa6dL/erRiCd93Xr9hihtBPrLwDyPo7XDnmw+Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tJsfSILbfWaVOB9UkWTFXJpR9/oveK8/lnfDMrFrqZSQHJ0Gfu4Yn2f/aGwZABusn
         scg/ozMR5YZVgYUPHcQZ9nAyO7vX0wEeHzLUnYMHoBpkwRNzKPprZbCEt6fYLpnwaI
         zYaIzzQ/EspEBspncZGU5wjod+V2faxDCzdk8AFS4g4uXqI9WXsIp+ItITb0UfZsme
         5/W6SxBkL3eP3bXkTU5TnE3HqvvsW4SUBg0mJNUoaDW1KMXp9g+snmmiQ7jVpEtjn8
         LCJZX3XYGSoMncwsbQA/OTuIOfSMpQAmYTxOSt4pxBVcHxMD27jTBuLKtdVbV1Mspl
         ulYN5jsumOtEg==
Message-ID: <1f893c71400a8193f8e1637b17bc4196c52293cd.camel@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: Add esw assignment back in
 mlx5e_tc_sample_unoffload()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Date:   Wed, 27 Oct 2021 22:29:46 -0700
In-Reply-To: <20211027153122.3224673-1-nathan@kernel.org>
References: <20211027153122.3224673-1-nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-10-27 at 08:31 -0700, Nathan Chancellor wrote:
> Clang warns:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c:635:34: error:
> variable 'esw' is uninitialized when used here [-Werror,-
> Wuninitialized]
>         mlx5_eswitch_del_offloaded_rule(esw, sample_flow->pre_rule,
> sample_flow->pre_attr);
>                                         ^~~
> drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c:626:26: note:
> initialize the variable 'esw' to silence this warning
>         struct mlx5_eswitch *esw;
>                                 ^
>                                  = NULL
> 1 error generated.
> 
> It appears that the assignment should have been shuffled instead of
> removed outright like in mlx5e_tc_sample_offload(). Add it back so
> there
> is no use of esw uninitialized.
> 
> Fixes: a64c5edbd20e ("net/mlx5: Remove unnecessary checks for slow
> path flag")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1494
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Nice catch ! 
applied to net-next-mlx5, 
Thanks !

