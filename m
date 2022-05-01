Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3AB516291
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 10:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241918AbiEAIJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 04:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244302AbiEAIJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 04:09:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E8D643D
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 01:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E15B9B80CE9
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 08:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B0CC385B2;
        Sun,  1 May 2022 08:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651392333;
        bh=5ltq3K+P9jttTQr8PqVVIOO9aUiF/nl3+OaPFMiEOgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kyj00enV1ZE7imK2PUfV+P6xoxjdVhcu+3d5TkpXJ3Hrq2w8ugtaD2mDyp4UNcBaS
         1AX845GCtbPJY0/lFPNGQ6iObLRIOrs+BH7LWKJsv5flgO5JVWJLxKPHtRxHmD1wW1
         9hryj/DEKdQlsH7BBVJ1g73XnMtjJZkUz5njeU24wa8UMihWxJL4oDwyPXhllSMUCt
         m5ta73GnLxZNB8gbrDNmj+WTU2+8otm7eVtctObiM+glqK+oNc6Ko3NUogwDyV/x6n
         ZdH+aMfV/yziT/8wv9N5hZUuNBmjCmP0+On9ayfsu2KdswEkgkurWoiLfrWInybzev
         ctzOZSY4+P7Sw==
Date:   Sun, 1 May 2022 11:05:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net-next v1 15/17] net/mlx5: Cleanup XFRM attributes
 struct
Message-ID: <Ym4/SM8XDIwEyiRB@unreal>
References: <cover.1650363043.git.leonro@nvidia.com>
 <5910e1bca2a5d34b8669b8ddc6c62943435e566f.1650363043.git.leonro@nvidia.com>
 <20220422224502.jfvrffw73f4qq2k4@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422224502.jfvrffw73f4qq2k4@sx1>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 03:45:02PM -0700, Saeed Mahameed wrote:
> On 19 Apr 13:13, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Remove everything that is not used or from mlx5_accel_esp_xfrm_attrs,
> > together with change type of spi to store proper type from the beginning.
> > 
> > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > .../mellanox/mlx5/core/en_accel/ipsec.c       | 10 ++-------
> > .../mellanox/mlx5/core/en_accel/ipsec.h       | 21 ++-----------------
> > .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  4 ++--
> > .../mlx5/core/en_accel/ipsec_offload.c        |  4 ++--
> > 4 files changed, 8 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > index be7650d2cfd3..35e2bb301c26 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > @@ -137,7 +137,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
> > 				   struct mlx5_accel_esp_xfrm_attrs *attrs)
> > {
> > 	struct xfrm_state *x = sa_entry->x;
> > -	struct aes_gcm_keymat *aes_gcm = &attrs->keymat.aes_gcm;
> > +	struct aes_gcm_keymat *aes_gcm = &attrs->aes_gcm;
> > 	struct aead_geniv_ctx *geniv_ctx;
> > 	struct crypto_aead *aead;
> > 	unsigned int crypto_data_len, key_len;
> > @@ -171,12 +171,6 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
> > 			attrs->flags |= MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP;
> > 	}
> > 
> > -	/* rx handle */
> > -	attrs->sa_handle = sa_entry->handle;
> > -
> > -	/* algo type */
> > -	attrs->keymat_type = MLX5_ACCEL_ESP_KEYMAT_AES_GCM;
> > -
> > 	/* action */
> > 	attrs->action = (!(x->xso.flags & XFRM_OFFLOAD_INBOUND)) ?
> > 			MLX5_ACCEL_ESP_ACTION_ENCRYPT :
> > @@ -187,7 +181,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
> > 			MLX5_ACCEL_ESP_FLAGS_TUNNEL;
> > 
> > 	/* spi */
> > -	attrs->spi = x->id.spi;
> > +	attrs->spi = be32_to_cpu(x->id.spi);
> > 
> > 	/* source , destination ips */
> > 	memcpy(&attrs->saddr, x->props.saddr.a6, sizeof(attrs->saddr));
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > index 97c55620089d..16bcceec16c4 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > @@ -55,11 +55,6 @@ enum mlx5_accel_esp_action {
> > 	MLX5_ACCEL_ESP_ACTION_ENCRYPT,
> > };
> > 
> > -enum mlx5_accel_esp_keymats {
> > -	MLX5_ACCEL_ESP_KEYMAT_AES_NONE,
> > -	MLX5_ACCEL_ESP_KEYMAT_AES_GCM,
> > -};
> > -
> > struct aes_gcm_keymat {
> > 	u64   seq_iv;
> > 
> > @@ -73,21 +68,9 @@ struct aes_gcm_keymat {
> > struct mlx5_accel_esp_xfrm_attrs {
> > 	enum mlx5_accel_esp_action action;
> > 	u32   esn;
> > -	__be32 spi;
> > -	u32   seq;
> > -	u32   tfc_pad;
> > +	u32   spi;
> > 	u32   flags;
> > -	u32   sa_handle;
> > -	union {
> > -		struct {
> > -			u32 size;
> > -
> > -		} bmp;
> > -	} replay;
> > -	enum mlx5_accel_esp_keymats keymat_type;
> > -	union {
> > -		struct aes_gcm_keymat aes_gcm;
> > -	} keymat;
> 
> Why do we have so many unused fields ? are these leftovers from FPGA ipsec ?

It is combination of leftovers and extra layering.

Thanks
