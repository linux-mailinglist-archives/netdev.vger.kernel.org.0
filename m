Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8991262D7B9
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 11:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239323AbiKQKJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 05:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239258AbiKQKJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:09:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F9324095;
        Thu, 17 Nov 2022 02:09:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A005B81FBA;
        Thu, 17 Nov 2022 10:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FABBC433C1;
        Thu, 17 Nov 2022 10:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668679753;
        bh=AQp3ax81OIaIcWop0MXmzEdt+muss9qfG8ekEK6EqgU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DQvIA7TnfcdGjJo7IHJkIE+jXUVntEodjBXGkqW/Qg7GtkNh0paIFOz6E6JZ7cYIg
         EdE86dAe6G+f4miRTIGvijNxCzoQBl7ss2NSIYXbNQKwu5NLxQAch3x7vWKAxI8Fss
         Fp1Kv+hx2RIHla7oDqM0LwuhRu1by1LZhblikJN6jdNPyi6aBt5GJ8c6G21MDd8sv1
         f6+avYmZTixzim1tTTAL6vxJzLSSSvwKKuhtchdLQIavG4TMBb/ozESEcDFoCtwEOc
         MC0cgCQpjV3wRa7gVLCnXscIwTi3EIwrfAWexPw0Uz6t4rbQaFsvdRBPxNeXSbdoo4
         pymlZpzgns4cw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless] brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()
References: <1668657281-28480-1-git-send-email-zhangchangzhong@huawei.com>
Date:   Thu, 17 Nov 2022 12:09:05 +0200
In-Reply-To: <1668657281-28480-1-git-send-email-zhangchangzhong@huawei.com>
        (Zhang Changzhong's message of "Thu, 17 Nov 2022 11:54:40 +0800")
Message-ID: <87bkp5sxj2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Changzhong <zhangchangzhong@huawei.com> writes:

> The brcmf_netdev_start_xmit() returns NETDEV_TX_OK without freeing skb
> in case of pskb_expand_head() fails, add dev_kfree_skb() to fix it.
>
> Fixes: 270a6c1f65fe ("brcmfmac: rework headroom check in .start_xmit()")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

I assume you have not tested this on a real device? Then it would be
really important to add "Compile tested only" to the commit log so that
we know it's untested.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
