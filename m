Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C86C5397D4
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347690AbiEaULb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 16:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243826AbiEaUL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 16:11:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFEF972B8;
        Tue, 31 May 2022 13:11:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78CDFB8111E;
        Tue, 31 May 2022 20:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093D2C385A9;
        Tue, 31 May 2022 20:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654027886;
        bh=2N/iTJa4yCu3/X/KB4jxWiI5AlQoGuTQzhdhOt7AjcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PFnHo1cIYta5xWwHjDlXAmN8viaYVedI7Ef8pLgqiJpRigV1GDgQGhd6tk1ncAWn8
         FzESMjainTKtk0+1VBOyF+3/WEL1fNYRXsLiC5P3woTS88E6MABJ81RC0jL54r/cqq
         isfkv9UXKB0N3AxXjI+ux8yijRUzJrpttTcyBuT/woAxnZxXuI651K2evWN0uDJImx
         U4ilRRWP02bLqSmlzdUhQi6+yVMHUs8iaUupSfwzaFX2rtNoDYTe0sh5oMC81iMLnO
         jlzbZB7p4LtvAxw4OgkTn7HZVcHeJHi7IusmH/owzFdADICyyDUCprkE7CQVMwdZRX
         cK8MwJ8xywUjQ==
Date:   Tue, 31 May 2022 13:11:25 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH (mellanox tree)] net/mlx5: delete dead code in
 mlx5_esw_unlock()
Message-ID: <20220531201125.46ecnnnzrqsqtejr@sx1>
References: <YpStOhUL4j7KBSqt@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YpStOhUL4j7KBSqt@kili>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30 May 14:40, Dan Carpenter wrote:

You can use [PATCH net-mlx5] for fixes and [PATCH net-next-mlx5] for
none-critical commits.

>Smatch complains about this function:
>
>    drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:2000 mlx5_esw_unlock()
>    warn: inconsistent returns '&esw->mode_lock'.
>
>Before commit ec2fa47d7b98 ("net/mlx5: Lag, use lag lock") there
>used to be a matching mlx5_esw_lock() function and the lock and
>unlock functions were symmetric.  But now we take the long
                                                        ^ lock ? 
>unconditionally and must unlock unconditionally as well.
>
>As near as I can tell this is dead code and can just be deleted.
>
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Fixed up the typo and applied to net-next-mlx5.

Thanks,
Saeed.

