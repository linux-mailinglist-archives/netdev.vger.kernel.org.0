Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4518C52B000
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbiERBl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbiERBlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:41:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008D1369DE;
        Tue, 17 May 2022 18:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 924CB61636;
        Wed, 18 May 2022 01:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F34C34116;
        Wed, 18 May 2022 01:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652838084;
        bh=rB1qtfEoe/0j2qEt3MLBrL8NpZIg7aZNCzRuOninDXk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kNazYk02Pz7xkmTef8YxMujGrh3rwSMmr6O7Eee2Q5tvpupO8dSHvJLhYMfFfH95y
         HVZBXQEXdvQmusH02l+IeFM8qw1Tshh9PaR1N8t6h7UjG+HzBUEoQqKZfbVVXnSt2c
         3POlSJAFojvg01ImeVwgaIcsLDMQz+Lmz6WMLlxnXwjFd+SXMetCbULukVKzgmRDjA
         k9M0Os3EnfklZImmRY/DxzhqBNEEKfNpRSYFaia7yYIbCyaAMADBLXTCCcazFZvYkp
         ilkLs667fraIxrR/u3L+MK3jFxJ4bRcC/bi+/ylFt3gMsQxsl1P/A8VyiukSjjcaj1
         G0OnBsRMFzd5w==
Date:   Tue, 17 May 2022 18:41:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next 11/15] net: ethernet: mtk_eth_soc: introduce
 device register map
Message-ID: <20220517184122.522ed708@kernel.org>
In-Reply-To: <78e8c6ed230130b75aae77e6d05a9b35e298860a.1652716741.git.lorenzo@kernel.org>
References: <cover.1652716741.git.lorenzo@kernel.org>
        <78e8c6ed230130b75aae77e6d05a9b35e298860a.1652716741.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 18:06:38 +0200 Lorenzo Bianconi wrote:
>  /* PDMA RX Base Pointer Register */
> -#define MTK_PRX_BASE_PTR0	0x900
> +#define MTK_PRX_BASE_PTR0	(eth->soc->reg_map[MTK_PDMA_BASE] + 0x100)
>  #define MTK_PRX_BASE_PTR_CFG(x)	(MTK_PRX_BASE_PTR0 + (x * 0x10))

Implicit macro arguments are really unpleasant for people doing
tree-wide changes or otherwise unfamiliar with the driver.

Nothing we can do to avoid this?
