Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856465FA973
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 02:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiJKAos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 20:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJKAoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 20:44:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BAFDF37
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 17:44:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98F4C60FB7
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 00:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D710AC433C1;
        Tue, 11 Oct 2022 00:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665449085;
        bh=X4z7/jDbLKcE1fa7M1865xjpwEL8Mhj9+dZKawbtLK4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZnmcVCN45TFfYB6gaU0YPHq8PsKWWWb6ejuKIEgRyGeyrpEXiv95hXuTqfBtDxS6q
         afs+2Lmh76Algp1oC1zg2fo/vANCyHkxCkAQ6ZqFsoiJdSuaSmwXHJmN5EnfVSqZfA
         7hwrM2AJADUT+FUvrCJkPCWSlwiiNbJkqePVWHzkNJ8/7brx9c3ORS74DQXC9T+YCC
         eCKQrYcTif3pVTRyhfLu7Dk0fHhNZAJslyFhMF9VYQX6/bgGcY5+X1RDMmLFP2GZZj
         fCP3zxnr4PE7tFM4mj5odZJJYixcNr39LiiPX1ds9DGKyR/QO+b/0Ss59akDalb+JV
         XX4jj6mi4ONEQ==
Date:   Mon, 10 Oct 2022 17:44:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next] net: ngbe: Variables need to be initialized
Message-ID: <20221010174443.563b6cd8@kernel.org>
In-Reply-To: <20221009070912.55353-1-mengyuanlou@net-swift.com>
References: <20221009070912.55353-1-mengyuanlou@net-swift.com>
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

On Sun,  9 Oct 2022 15:09:12 +0800 Mengyuan Lou wrote:
> Variables need to be initialized in ngbe_shutdown()
> Fix: commit <e79e40c83b9f> ("net: ngbe: Add build support for ngbe")

Please look at the git history to find out what the correct form is for
the Fixes tag.

> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> ---
>  drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> index 7674cb6e5700..f754e53eb852 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> @@ -46,7 +46,7 @@ static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
>  
>  static void ngbe_shutdown(struct pci_dev *pdev)
>  {
> -	bool wake;
> +	bool wake = false;
>  
>  	ngbe_dev_shutdown(pdev, &wake);

The callee should make sure to always write to the variable, caller
init is a worse fix.
