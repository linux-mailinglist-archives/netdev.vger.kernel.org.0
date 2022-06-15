Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D281654C0E3
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 06:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbiFOEuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 00:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiFOEuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 00:50:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E092C647;
        Tue, 14 Jun 2022 21:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0D33B81BF5;
        Wed, 15 Jun 2022 04:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FBBC34115;
        Wed, 15 Jun 2022 04:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655268608;
        bh=82TOJasF/muXbREfaUDPGBV9l+FQHMiVRx8XVZhvBDU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eN6ClbFvtBOBDoGCEOtQkJJRbyKIdfNmmd7ZNy0V40+srmZ/PPJjKUluwiAPNzx8L
         NKk0NnP+0NqM0jyU6wGUu5PuNqt9qOACssbHNnHL4MvSbpIjOjlSouxY0y/kfjGH+5
         2YFs239k+qSs0aG8xhPtx7XpusSiglzSKwCvaTEmMCJO2DoMMiogFu3i/ExOe/yA2y
         YrrI90rtvNRjkRvzFlYZh0n0aGUC7QHJKA2Q4nspBeEXln0Ims+V3AYc7unDFp9BmU
         9wWXKaNN5MrqFDOMZzn7Ns6IMgKcIup+r5hrAsLDyv6GqIDywiQzozENYf0evz123a
         03STYYhIpuT6g==
Date:   Tue, 14 Jun 2022 21:50:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Cc:     davem@davemloft.com, edumazet@google.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm63xx_enet: reuse skbuff_head
Message-ID: <20220614215006.67893ec1@kernel.org>
In-Reply-To: <20220614021009.696-1-liew.s.piaw@gmail.com>
References: <20220614021009.696-1-liew.s.piaw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jun 2022 10:10:09 +0800 Sieng Piaw Liew wrote:
> Subject: [PATCH] bcm63xx_enet: reuse skbuff_head

Please improve the subject. One verb and one vaguely correct noun 
is not good enough.

> napi_build_skb() reuses NAPI skbuff_head cache in order to save some
> cycles on freeing/allocating skbuff_heads on every new Rx or completed
> Tx.
> Use napi_consume_skb() to feed the cache with skbuff_heads of completed
> Tx so it's never empty.
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>

Please keep Florian's Ack when posting v2.
