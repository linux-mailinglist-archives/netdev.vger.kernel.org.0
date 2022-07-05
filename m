Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51037567972
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 23:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbiGEVlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 17:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbiGEVli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 17:41:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF9F18E0C
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 14:41:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBFB061CFB
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 21:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178F6C341C7;
        Tue,  5 Jul 2022 21:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657057297;
        bh=yfsm1HC8VMhn2IL+qhw3mX6993Gt9hQoOmzwiCJRniE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b21QJWFIbcfc16WPkoi2E4ib07Ok0WrXd/YdNrQCz8s518xDktRhdG8P3+2XyLWpj
         fUO3OG4LqqRlwWLmJYyF6wUqb12ppFuGZj/Mj5npouXh8PhEkq5A6+eBJ3V7XFX5VD
         3kvp46LEaIMgFBSnFn1UBXER8ZXaZtEUGO7vlwJW9kDdEJta4UJVQuqe/jQKQ4bOzQ
         +7NDH5G5062CGTw2ybkf5O4uVf4PElFGu9tR8/9brefl1pcFw9z41WkytbIBbd1gF1
         Nffb2i3iCIIvVN+t1DvEAaAf9Exj1jbN70XgxmwE6KNAhm30yVBsPSxM5LIQK3URT2
         9sNIimS0YZXXQ==
Date:   Tue, 5 Jul 2022 14:41:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net] Revert "tls: rx: move counting TlsDecryptErrors for
 sync"
Message-ID: <20220705144135.5685cf7f@kernel.org>
In-Reply-To: <20220705110837.24633-1-gal@nvidia.com>
References: <20220705110837.24633-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jul 2022 14:08:37 +0300 Gal Pressman wrote:
> This reverts commit 284b4d93daee56dff3e10029ddf2e03227f50dbf.
> When using TLS device offload and coming from tls_device_reencrypt()
> flow, -EBADMSG error in tls_do_decryption() should not be counted
> towards the TLSTlsDecryptError counter.
> 
> Move the counter increase back to the decrypt_internal() call site in
> decrypt_skb_update().
> This also fixes an issue where:
> 	if (n_sgin < 1)
> 		return -EBADMSG;
> 
> Errors in decrypt_internal() were not counted after the cited patch.
> 
> Fixes: 284b4d93daee ("tls: rx: move counting TlsDecryptErrors for sync")
> Cc: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Gal Pressman <gal@nvidia.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
