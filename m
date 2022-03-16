Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8296C4DB80A
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244970AbiCPSlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235282AbiCPSlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:41:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C212055204
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 11:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 709F7B81CAA
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 18:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC50C340EC;
        Wed, 16 Mar 2022 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647455991;
        bh=k+n9cLXH9OZ4YQOpiyTf6Tu0Eey44zrFuJrOv45GhXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oYHyK3DtsUcwirG0WKinFSjScRLkoPTpEugoprnSFcPH7jKHQNTawRPwo2xOmKAHc
         LS0w8I81njrmNEDgN+LHLrcZ43nDWMgrSJK3dcIZc3CfF8mOp5YGZLIS6mXBKsjuHT
         9MfcJIkyhy0UUe/yOFsGYvIV/syiQo3q0KmmIzHfoK9Dsl3qIZBSCbhsQJn54T1KQe
         d+ravtrHMHLwHCRFiSnMap+V6se/GiTvWh3qjATX7yOpPv2PPbqTxPDAYofFS28JHX
         x5hWdwJ64/4LWC6ZjVMbIva4S3jQmJEiswW+3+LRyxAKhuwGdYkjKY2hBT3Np+qVNI
         xM75gdjO9JUzQ==
Date:   Wed, 16 Mar 2022 20:39:46 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@nvidia.com,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com
Subject: Re: [PATCH net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <YjIu8rf/1hFHuhHE@unreal>
References: <20220315060009.1028519-1-kuba@kernel.org>
 <20220315060009.1028519-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315060009.1028519-2-kuba@kernel.org>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 11:00:04PM -0700, Jakub Kicinski wrote:
> It should be familiar and beneficial to expose devlink instance
> lock to the drivers. This way drivers can block devlink from
> calling them during critical sections without breakneck locking.
> 
> Add port helpers, port splitting callbacks will be the first
> target.
> 
> Use 'devl_' prefix for "explicitly locked" API. Initial RFC used
> '__devlink' but that's too much typing.
> 
> devl_lock_is_held() is not defined without lockdep, which is
> the same behavior as lockdep_is_held() itself.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v1: - add a small section to the docs
>     - redo the lockdep ifdef
> ---
>  Documentation/networking/devlink/index.rst | 16 ++++
>  include/net/devlink.h                      | 11 +++
>  net/core/devlink.c                         | 95 ++++++++++++++++------
>  3 files changed, 98 insertions(+), 24 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
