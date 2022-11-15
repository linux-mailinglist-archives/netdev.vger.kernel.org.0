Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC4D62AEB5
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 23:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiKOW6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 17:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiKOW6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 17:58:08 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A962B27B;
        Tue, 15 Nov 2022 14:58:05 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2AFMvQDL879329;
        Tue, 15 Nov 2022 23:57:26 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2AFMvQDL879329
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1668553046;
        bh=5g2YJty4MpIOetLdEfEoj8bg2mPwJLd4CWGeQR87WdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EfSQsXglNIHFEOdapYkLadlttvUVyjGKpnUupYsC55TN29+cR46vGqKwC0rld4Mqj
         jnWTFVWQwHa9RJ73s+yq2UQLFivo/HTA8ouyllv6ewyuTooBSA0RTyeM9XSdGmUsgs
         ECJfnS20cSE/7IQgq6T3oK78KlSPRjNKDAdlKYRs=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2AFMvPMG879328;
        Tue, 15 Nov 2022 23:57:25 +0100
Date:   Tue, 15 Nov 2022 23:57:25 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mdf@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] net: nixge: fix potential memory leak in
 nixge_start_xmit()
Message-ID: <Y3QZVXCOSjBd4l9P@electric-eye.fr.zoreil.com>
References: <1668525024-38409-1-git-send-email-zhangchangzhong@huawei.com>
 <1668525024-38409-2-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1668525024-38409-2-git-send-email-zhangchangzhong@huawei.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Changzhong <zhangchangzhong@huawei.com> :
> The nixge_start_xmit() returns NETDEV_TX_OK but does not free skb in
> case of dma_map_single() fails, which leads to memory leak.
> 
> Fix it by adding dev_kfree_skb_any() when dma_map_single() fails.
> 
> Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/ni/nixge.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Francois Romieu <romieu@fr.zoreil.com>

-- 
Ueimor
