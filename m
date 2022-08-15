Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A27594E90
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241954AbiHPCQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241940AbiHPCQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:16:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F64249F90;
        Mon, 15 Aug 2022 15:25:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2DA060F6A;
        Mon, 15 Aug 2022 22:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C6EC433C1;
        Mon, 15 Aug 2022 22:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660602309;
        bh=2U9j3+t8CKpN+3YSA0BOYiGbosL+S3tcdDnhHVz8qP0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=g9A9ADcWHr0yoVw+6Gfvt1A1TOUPLvxpJQBanydJZhRFGlJd+0Nk+Ujt3EvrzdKes
         OGgKU9sPjIGr4Lh/sxnNxAQxyjASHulVQ6Bg8ZHmSvjWA61tA+XJ9mtAyZCABB/uWa
         W0UJDUj0794FWYKmI229udbVSngaSWmMWkS4r+nI06zBhinlsHn/5Yqhna9CPn63B9
         ZeaRDpJzL/dQv6va70YSrik5HqhoU/HQLx5HTZTWiKkWxeT3+iKzOsJiZx1CTQ7Lbu
         gVgJ1D1zTojPmaqU1+rJUiqO0r0KDdL/tnDJ42Rc2EFmD/8afJzDyr1gQ9AprdVTxy
         AdK93xlK+7cFA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 659D450ED2C; Tue, 16 Aug 2022 00:25:06 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Daniel Xu <dxu@dxuuu.xyz>, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/3] bpf: Add support for writing to nf_conn:mark
In-Reply-To: <f850bb7e20950736d9175c61d7e0691098e06182.1660592020.git.dxu@dxuuu.xyz>
References: <cover.1660592020.git.dxu@dxuuu.xyz>
 <f850bb7e20950736d9175c61d7e0691098e06182.1660592020.git.dxu@dxuuu.xyz>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 16 Aug 2022 00:25:06 +0200
Message-ID: <871qth87r1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Xu <dxu@dxuuu.xyz> writes:

> Support direct writes to nf_conn:mark from TC and XDP prog types. This
> is useful when applications want to store per-connection metadata. This
> is also particularly useful for applications that run both bpf and
> iptables/nftables because the latter can trivially access this metadata.
>
> One example use case would be if a bpf prog is responsible for advanced
> packet classification and iptables/nftables is later used for routing
> due to pre-existing/legacy code.
>
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>

Didn't we agree the last time around that all field access should be
using helper kfuncs instead of allowing direct writes to struct nf_conn?

-Toke
