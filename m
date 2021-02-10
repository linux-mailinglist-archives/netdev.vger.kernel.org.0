Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B6C315F1C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 06:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhBJFgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 00:36:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229798AbhBJFgr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 00:36:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17A0864E4B;
        Wed, 10 Feb 2021 05:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612935367;
        bh=nvkAoWycvbbcUGYK6a56kBDCwUmogqBQDgKgZB1qLrc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c5LEIgWSKvHf5DJAWVz/gejil4ucHTRab/Uh4yDnmpKPlmHE2riMkPoXtNVU+Tovi
         9dyFBbuI0N+7o5TlhC547w884dZI5bcBR6wZp9eIorN5rdJM5WyGjo6BzKwhA+mj3o
         mllkLzVTrVbTzDeX/GxMRZ9jx6wPh/dwSxijW0o6AwrAKXpBLgbEDcONdvwqcJmilq
         5X7lsnFJQJFd/taRM5NGoCR7Go3s2T84rZrBsTk0U8ljoNF+J/q+sArI+DyyZW/IDk
         WshnEMlzd/FHLQgn88C/huFfe3ZCaZZx6U7qKdHyRuMsH9Tbr5Tl2LENvXHDIAv3Me
         gIMS4W4LLdCpg==
Message-ID: <eae35802d6fd3b55a8f8238e44462f619645177b.camel@kernel.org>
Subject: Re: mlx5e compilation failure
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org
Date:   Tue, 09 Feb 2021 21:36:06 -0800
In-Reply-To: <20210209194906.vo3ssh3gwzt3k5u2@bsd-mbp.dhcp.thefacebook.com>
References: <20210209194906.vo3ssh3gwzt3k5u2@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-02-09 at 11:49 -0800, Jonathan Lemon wrote:
> On mlx5e fails to compile on the latesst net-next:
> 
>   CC      drivers/net/ethernet/mellanox/mlx5/core/en_main.o
> In file included from
> ../drivers/net/ethernet/mellanox/mlx5/core/en_tc.h:40,
>                  from
> ../drivers/net/ethernet/mellanox/mlx5/core/en_main.c:45:
> ../drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h:24:29: error:
> field ‘match_level’ has incomplete type
>    24 |  enum mlx5_flow_match_level match_level;
>       |                             ^~~~~~~~~~~
> 
> With this .config snippet:
>     CONFIG_MLX5_CORE=y
>     # CONFIG_MLX5_FPGA is not set
>     CONFIG_MLX5_CORE_EN=y
>     # CONFIG_MLX5_EN_ARFS is not set
>     CONFIG_MLX5_EN_RXNFC=y
>     CONFIG_MLX5_MPFS=y
>     # CONFIG_MLX5_ESWITCH is not set
>     CONFIG_MLX5_CORE_EN_DCB=y
>     # CONFIG_MLX5_CORE_IPOIB is not set
>     # CONFIG_MLX5_SF is not set
> 
> Presumably because ESWITCH is not enabled.

Thanks Jonathan for the report,

this patch should fix the issue:
https://patchwork.kernel.org/project/netdevbpf/patch/20210209203722.12387-1-saeed@kernel.org/



