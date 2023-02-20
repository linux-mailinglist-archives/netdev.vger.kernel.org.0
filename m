Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1454D69C711
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjBTI6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjBTI55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:57:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510DD7EFF;
        Mon, 20 Feb 2023 00:57:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED1E3B80B46;
        Mon, 20 Feb 2023 08:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A14C433D2;
        Mon, 20 Feb 2023 08:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676883473;
        bh=cn2uG6h1Z4V5em3rkbUzwLVNE0WxlJeGFfNh8HPkEw8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=bu2j1/eVWJEWPVWt8awRoRGUNv6v6xk8DtnmKtp2ZF7tPl66VH+mUsJ9paGtOUYs+
         z3t4MnvL9+m41LUoFslSpvlV8q0ayfW8S0lerzI4f/9ITLdJIBmsaXGnzlb/jqKBAy
         m0U7a2X7gBROblOisdQkf9NFnHXfJGFULiQvTFw12Wis2err8Eneagir23+cPKZwVv
         yMK45fbQQvAeXE1K8SwRX93YkcxhUygQnqEs4aerTJiCflc49eU34uKqQMXEg4zrkV
         1qpkXmutpl0w8t4wLGZYZ4e0KqWFNp1n9ASePw5NgOaYMKG8gY98lDNUk0V0s4/W0g
         ItCaL/yb1oixA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: fix SAC bug on peer addition with sta band
 migration
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230209222622.1751-1-ansuelsmth@gmail.com>
References: <20230209222622.1751-1-ansuelsmth@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167688346963.21606.5485334408823363188.kvalo@kernel.org>
Date:   Mon, 20 Feb 2023 08:57:51 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Marangi <ansuelsmth@gmail.com> wrote:

> Fix sleep in atomic context warning detected by Smatch static checker
> analyzer.
> 
> Following the locking pattern for peer_rhash_add lock tbl_mtx_lock mutex
> always even if sta is not transitioning to another band.
> This is peer_add function and a more secure locking should not cause
> performance regression.
> 
> Fixes: d673cb6fe6c0 ("wifi: ath11k: fix peer addition/deletion error on sta band migration")
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

I assume you only compile tested this and I'll add that to the commit log. It's
always good to know how the patch was tested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230209222622.1751-1-ansuelsmth@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

