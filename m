Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D193380EB
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhCKWwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:52:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:42598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229910AbhCKWv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:51:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E22664F26;
        Thu, 11 Mar 2021 22:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615503115;
        bh=vntZGoqs0CqwH2BmBiZ/QL0YFTZvd8CMaMCrkmzsLCg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=f+BMf0FazeCKv7+xE2a01FZyMKDgIawfrWTDN4xWxAzc2mfB71aO3C0KLvte4kma4
         iROzJRsSfNj8KrEO0bqFAg0E2kwnoFKs3x/7IjXEM5v0xzw7kUI/95m8Xd9+HxkhTd
         9at+Jpa4379HW1DRVl4e83r4Sc7zREp4lwLFYgtvxXJeczUDeL76RbOARydfVdF5Yq
         w1Qr1R3+mHFHjTOXf91syngUVHVI+wHFuUR1edJW8WktKkWC6sZ+Sj0Nebt9C2qyJL
         IALRiMTROT+dxsxol1TdkuLJw3skon/moH0QFZ1xvDs5WfJVBAZzD4GLJUH7HAstbM
         y6gsSKxweYxvg==
Message-ID: <8dff1af3191e65e28615a2a3df5269bdaea18754.camel@kernel.org>
Subject: Re: [PATCH] net: mellanox: mlx5: fix error return code in
 mlx5_fpga_device_start()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     borisp@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 11 Mar 2021 14:51:54 -0800
In-Reply-To: <YESTu9lXAgvYaroG@unreal>
References: <20210304141814.8508-1-baijiaju1990@gmail.com>
         <YESTu9lXAgvYaroG@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-03-07 at 10:50 +0200, Leon Romanovsky wrote:
> On Thu, Mar 04, 2021 at 06:18:14AM -0800, Jia-Ju Bai wrote:
> > When mlx5_is_fpga_lookaside() returns a non-zero value, no error
> > return code is assigned.
> > To fix this bug, err is assigned with -EINVAL as error return code.
> > 
> > Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> > Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Like Heiner said, the current code has correct behavior.
> The mlx5_fpga_device_load_check() has same mlx5_is_fpga_lookaside()
> check and it is not an error if it returns true.
> 
> NAK: Leon Romanovsky <leonro@nvidia.com>
> 
> Thanks

Agreed, apparently this robot is looking for "goto {out|*err*}"
statements and treats all of them as errors, this is very unreliable, 



