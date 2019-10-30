Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 661BCE9776
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 08:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfJ3H5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 03:57:55 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40165 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbfJ3H5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 03:57:54 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0B17721E29;
        Wed, 30 Oct 2019 03:57:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 30 Oct 2019 03:57:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zwmbOo
        F8lGRb87tz4O0tktV7ashz9GOB9jTITmMDfT0=; b=n4AwKVNd4aZyyb2YVQz29P
        6gt2jGyqbCx/odGK+k5fAxmk/UVd2/ESUmtTsS75qLudp5RzQgX2LLUIum6VjVgm
        ni0Z2SmxeoE+pwTXGmmSE5EfV/813l6MTtpLvZsfMwPuMC1TlERmkUdV9MSE8etj
        UsNI+zHs+iwagFbyTJC48X2iC5YlCFzDkcTRSV1KTDqsNEQa6ERSMTUEMKcpMZp6
        yUXwOkSPWlZk+x28rTDkwlb+kELdk//NsgugKs7UxbG104iLUQ0LwD9jYiyiVabo
        uQJn7bnvkWGZTJFr4SbqIDXrkxX6gNd24feIRayzKwJLH+TnZ/GX1CIsAjOyA6WA
        ==
X-ME-Sender: <xms:gUK5XVs3IMlnmMySn1yQhD90rDeb6F7UepQkKOidua1hST06AON5tA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtvddgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:gUK5XYQup9QpE_ww_6FnKnb_q0VkxXskebpIEhrjkyQeAR3jpQA7zw>
    <xmx:gUK5XUNjbOwIA37NuhjRqHDCj96Fwvy2JIv0um8bBoxJ5Ct2CykZYg>
    <xmx:gUK5XYkAzsPNm9dl2F_uwI8jbKjaflSfWyzo_ko712kMhffhQQCY9A>
    <xmx:gUK5XWyiXjDgqaRmqimAH2vv997_wCH4u4wtS0jRGojWhM2pvp7Ddw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 48184306005B;
        Wed, 30 Oct 2019 03:57:53 -0400 (EDT)
Date:   Wed, 30 Oct 2019 09:57:51 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 2/2] mlxsw: spectrum_buffers: Calculate the size
 of the main pool
Message-ID: <20191030075751.GA16499@splinter>
References: <20191023060500.19709-1-idosch@idosch.org>
 <20191023060500.19709-3-idosch@idosch.org>
 <20191030033154.GA43266@ubuntu-m2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030033154.GA43266@ubuntu-m2-xlarge-x86>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 08:31:54PM -0700, Nathan Chancellor wrote:
> On Wed, Oct 23, 2019 at 09:05:00AM +0300, Ido Schimmel wrote:
> >  static int mlxsw_sp_sb_prs_init(struct mlxsw_sp *mlxsw_sp,
> >  				const struct mlxsw_sp_sb_pr *prs,
> > +				const struct mlxsw_sp_sb_pool_des *pool_dess,
> >  				size_t prs_len)
> >  {
> > +	/* Round down, unlike mlxsw_sp_bytes_cells(). */
> > +	u32 sb_cells = mlxsw_sp->sb->sb_size / mlxsw_sp->sb->cell_size;
> 
> This causes a link time error on arm32. It can be simply reproduced with
> the following configs + multi_v7_defconfig:
> 
> CONFIG_MLXSW_CORE=y
> CONFIG_MLXSW_PCI=y
> CONFIG_NET_SWITCHDEV=y
> CONFIG_VLAN_8021Q=y
> CONFIG_MLXSW_SPECTRUM=y
> 
> arm-linux-gnueabi-ld: drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.o: in function `mlxsw_sp_buffers_init':
> spectrum_buffers.c:(.text+0x1c88): undefined reference to `__aeabi_uldivmod'
> 
> It can be solved by something like this but I am not sure if that is
> proper or not since div_u64 returns a u64, which would implicitly get
> converted to u32. I can submit it as a formal patch if needed but I
> figured I would reach out first in case you want to go in a different
> direction.

Yes, this looks fine to me. The value can fit in a u32. Tested on my
system without issues.

Thanks for reaching out

> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
> index 33a978af80d6..968f0902e4fe 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
> @@ -470,7 +470,7 @@ static int mlxsw_sp_sb_prs_init(struct mlxsw_sp *mlxsw_sp,
>  				size_t prs_len)
>  {
>  	/* Round down, unlike mlxsw_sp_bytes_cells(). */
> -	u32 sb_cells = mlxsw_sp->sb->sb_size / mlxsw_sp->sb->cell_size;
> +	u32 sb_cells = div_u64(mlxsw_sp->sb->sb_size, mlxsw_sp->sb->cell_size);
>  	u32 rest_cells[2] = {sb_cells, sb_cells};
>  	int i;
>  	int err;
