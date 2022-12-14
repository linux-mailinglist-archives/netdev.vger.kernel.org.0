Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81E164CE8D
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 18:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239203AbiLNRBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 12:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239016AbiLNRB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 12:01:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873EA20F5A
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 09:01:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20176619E8
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 17:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317CEC433D2;
        Wed, 14 Dec 2022 17:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671037285;
        bh=r1ct7J6TbrO1WlYeXgGBKzVerBcfG5CkNgMl1gQ/q3A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SorzPDN1yNbmE6RIJ0i6l38mxoKt2sPVMiHSPZpG4hWzCOnLKyEAiBYPFXV/+H9bD
         lPs8SO8QP0i2czCkazU7IIryj+K2V8oaKULTjLJnbNa/shZS/EjxpYMY2Sq3wdYgVR
         BtPO3yilP4Vl9M0MRQ7OOxHOCRQfOVpVvqzAHpPDlPWXvmOvGD0ErtQtukLxfmiv2n
         ZefZiuI4cfkA4ILjoVJx7d8UL38+eSytYt4HctzhZA3hlwxOZYcAIocZPqC+zFU1VY
         6PvS6sXKXKH76diV+46nG9P948PuWjgq46MFDy1C+//Yz905cb9N3VOqp5kmqjFOKp
         0RBQHvuMrATMg==
Date:   Wed, 14 Dec 2022 09:01:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Alexandra Kossovsky <Alexandra.Kossovsky@oktetlabs.ru>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: parameter to disable symmetric hash
Message-ID: <20221214090124.4c01a360@kernel.org>
In-Reply-To: <Y5nfPjloqVqmWPyn@gondor.oktetlabs.ru>
References: <Y5nfPjloqVqmWPyn@gondor.oktetlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Dec 2022 17:35:42 +0300 Alexandra Kossovsky wrote:
> Some AF_XDP applications assume standard Topelitz hash when spreading
> traffic accross queues via RSS.  MLX5 driver always set "symmetric"
> bit, which results in unexpected queues for any particular connection.
> 
> With this patch is is possible to disable that symmetric bit via
> use_symmetric_hash module parameter, and use the standard Toeplitz hash
> with well-known predictable result, same as for other NICs.

This module param, OTOH, not okay..

[ https://lore.kernel.org/all/20221214085106.42a88df1@kernel.org/ ]
