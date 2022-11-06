Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372FE61E56C
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 20:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiKFTAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 14:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiKFTAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 14:00:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F862FCEA
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 11:00:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E19360D24
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 19:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEA3C433C1;
        Sun,  6 Nov 2022 19:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667761204;
        bh=EsmKcdYf/wnxOGxIH5rpUGHKyJI21vqGSgY8jy5NG9E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oXV2D7XfIjaYDyLTVDu+pmHWg24C2Oqjin5dwo9OmjYfa6plL2TMDfrFXo8iD7os4
         z4vJwjGgG0HaPdAEUSQwEQS6AbUvmo4RYe/Rt211lIblBCgk3RrnnmtUJvlndMZYmV
         KFwDImQfSjO6EfVo6iyfhBaRkrlvOUWGIvwQQHps8EJIXkxT0a4wsQDs1ySULZWLS0
         2wPxL39l1mjWoY4QM9GBrj3VXwMNHYoJMlpbBAMihq97mS3lWfYBWj6j+leFOAsPRc
         TnO8B+qCF9ysd6Ray9eVRn2htbpnNSZFpleNkoYlcERS35OpUPFBgH6cz6BjQ9ZNiH
         NAiZddwiQ8NuA==
Date:   Sun, 6 Nov 2022 21:00:00 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com, bjking1@linux.ibm.com,
        ricklind@us.ibm.com, dave.taht@gmail.com
Subject: Re: [PATCH net] ibmveth: Reduce maximum tx queues to 8
Message-ID: <Y2gEMKaeL18bFi5t@unreal>
References: <20221102153040.149244-1-nnac123@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102153040.149244-1-nnac123@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 02, 2022 at 10:30:40AM -0500, Nick Child wrote:
> Previously, the maximum number of transmit queues
> allowed was 16. Due to resource concerns, limit
> to 8 queues instead.
> 
> Since the driver is virtualized away from the
> physical NIC, the purpose of multiple queues is
> purely to allow for parallel calls to the
> hypervisor. Therefore, there is no noticeable
> effect on performance by reducing queue count to 8.

Very odd typography of this commit message. You have upto 80 chars in
one line, use them.

> 
> Reported-by: Reported-by: Dave Taht <dave.taht@gmail.com>

Double Reported-by.

> Signed-off-by: Nick Child <nnac123@linux.ibm.com>

And missing Fixes line for "net".

> ---
> Relevant links:
>  - Introduce multiple tx queues (accepted in v6.1):
>    https://lore.kernel.org/netdev/20220928214350.29795-2-nnac123@linux.ibm.com/
>  - Resource concerns with 16 queues:
>    https://lore.kernel.org/netdev/CAA93jw5reJmaOvt9vw15C1fo1AN7q5jVKzUocbAoNDC-cpi=KQ@mail.gmail.com/
> 
>  drivers/net/ethernet/ibm/ibmveth.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
> index 4f8357187292..6b5faf1feb0b 100644
> --- a/drivers/net/ethernet/ibm/ibmveth.h
> +++ b/drivers/net/ethernet/ibm/ibmveth.h
> @@ -99,7 +99,7 @@ static inline long h_illan_attributes(unsigned long unit_address,
>  #define IBMVETH_FILT_LIST_SIZE 4096
>  #define IBMVETH_MAX_BUF_SIZE (1024 * 128)
>  #define IBMVETH_MAX_TX_BUF_SIZE (1024 * 64)
> -#define IBMVETH_MAX_QUEUES 16U
> +#define IBMVETH_MAX_QUEUES 8U
>  
>  static int pool_size[] = { 512, 1024 * 2, 1024 * 16, 1024 * 32, 1024 * 64 };
>  static int pool_count[] = { 256, 512, 256, 256, 256 };
> -- 
> 2.31.1
> 
