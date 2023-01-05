Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B2565E4DF
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjAEEw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjAEEws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:52:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CC751310;
        Wed,  4 Jan 2023 20:52:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D477E6149B;
        Thu,  5 Jan 2023 04:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62A4C433EF;
        Thu,  5 Jan 2023 04:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672894358;
        bh=h+Zt8kl9f/QMFlD2IOoAtcRssR1q5VE8RGSwXgCHpvw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r0ZQFVETsdq8x0PXZDJRzaw1GDfX1BSMEt8kqexXOy2fqKnc5s+2Qldytn41UjZQ2
         +DYH7Xw/2trq76T5X6gXuSGtxZYk0jNBmsVXgrjaVGj8fUi21CqMWiPVZZJhHFoyNS
         pMyP3ruZ914D5nEB6MeGNKFY3I9WgmsfFBZpuZw/mi6EuAO28foz2oGkp8ldH0EzBl
         ZqHzjsy8CgQ2MGLmyk4rAFzvwGZCXk93+nFoUdZG72TREra3m5sS4Vml9Tg6scM8tl
         uzNOAzCzVWgzhiqGuCN27teaWTQZDwUc1CUZoWeOAtPfrcu5IY6NrtgCOiTZSSU+gj
         tcOs88ATVhDmA==
Date:   Wed, 4 Jan 2023 20:52:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] ezchip: Remove some redundant clean-up
 functions
Message-ID: <20230104205236.3c0f90de@kernel.org>
In-Reply-To: <43e9d047a036cd8a84aad8e9fffdfdcb17a1cf2a.1672865629.git.christophe.jaillet@wanadoo.fr>
References: <cover.1672865629.git.christophe.jaillet@wanadoo.fr>
        <43e9d047a036cd8a84aad8e9fffdfdcb17a1cf2a.1672865629.git.christophe.jaillet@wanadoo.fr>
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

On Wed,  4 Jan 2023 22:05:32 +0100 Christophe JAILLET wrote:
> @@ -640,7 +639,6 @@ static s32 nps_enet_remove(struct platform_device *pdev)
>  	struct nps_enet_priv *priv = netdev_priv(ndev);
>  
>  	unregister_netdev(ndev);
> -	netif_napi_del(&priv->napi);
>  	free_netdev(ndev);

This adds an unused variable warning, which is fixed by the next patch.
Could you remove the @priv variable here already?
