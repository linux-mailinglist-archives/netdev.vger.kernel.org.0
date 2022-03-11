Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1884C4D5950
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 04:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346056AbiCKDzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 22:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238284AbiCKDzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 22:55:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE81218FAEB;
        Thu, 10 Mar 2022 19:54:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5824FB827DB;
        Fri, 11 Mar 2022 03:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF23C340EC;
        Fri, 11 Mar 2022 03:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646970872;
        bh=T+/Lld+hq4lV5n+RrrbXPXhhkwm8I168aObglERBuwE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OpfkPI2msYKkkC5nZeH8IsoDx+YzlKIEfI7skQRpiXnE1fNld2q6/YAaAzwH0ca9r
         0zGObTOwzvHCl53JWLqCpeZjSj+az0KeFK4KxTxcqeeadS91X9ZhZwnsv3f54fGc4H
         Sj9fRhMZlztib/eHZsd5TKIioVs8TI4QgA4QZK/StDYrBiD5HC4JTV5aiwpt8/Frz1
         AvP7ZrU7PV31xMrlPTYJYhsOfUMVzJF6h+lpu1hsrkNgvqjW7Ht5OccT4RruxfdZYt
         ZlgilyAsU7QYDnW4KZVMIadiqy2IBE67Mmb2EuRPlnI7QLRMeBbGabvNmzydO9IdTw
         WB0KVYpW1FxpA==
Date:   Thu, 10 Mar 2022 19:54:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     dsahern@kernel.org, nhorman@tuxdriver.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, davem@davemloft.net, imagedong@tencent.com,
        edumazet@google.com, talalahmad@google.com, keescook@chromium.org,
        alobakin@pm.me, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Mengen Sun <mengensun@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: Re: [PATCH] net: skb: move enum skb_drop_reason to uapi
Message-ID: <20220310195429.4ba93edf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220311032828.702392-1-imagedong@tencent.com>
References: <20220311032828.702392-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 11:28:28 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Move the definition of 'enum skb_drop_reason' in 'skbuff.h' to the uapi
> header 'net_dropmon.h', therefore some users, such as eBPF program, can
> make use of it.

BPF does not need an enum definition to be part of the uAPI to make use
of it. BTF should encode the values, and CO-RE can protect from them
changing, AFAIU. I think we need a better example user / justification.
