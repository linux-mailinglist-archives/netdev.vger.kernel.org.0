Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48075F33E7
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 18:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiJCQu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 12:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiJCQuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 12:50:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB6019C3F
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 09:50:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D82FC61165
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 16:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC63C433D6;
        Mon,  3 Oct 2022 16:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664815850;
        bh=M6OQU2c9sA9fyD1VlXVE2QN90dkjRfa19tpbQyQrGHM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dQnmfbQ1fFRiNS7UyvYR8IYvkKCNIgTS/Q9KOSUQXEq6nyfPg4Mku5jDxR/3Zx3tY
         cDq1cPiI35BBievrFyDc5WLmHM07J2JReTVJsX0f/qMVaqVv0Q2ePrlVYzMz/46U/f
         gyp/KWN0HTisQoetoa/c3r2Z3Z/hdlzlbtVYYtimIZaI7REIWUvdVhUgySvrPTJuct
         +OfMb86YsjMndx+M+KeWVtJlh55q5J9B2CVZzU/okUTYC1nZTu+yzcMG67au1fiH1K
         /HYlZe+DnnND5VJC+pQXVOjC3qf/n6g0n5Kqvy1pcPCCrlpd6DX/NfOpQY0QC/gfMM
         sHpY4mgyKALIg==
Date:   Mon, 3 Oct 2022 09:50:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH 0/4] net: drop netif_attrmask_next*()
Message-ID: <20221003095048.1a683ba7@kernel.org>
In-Reply-To: <20221002151702.3932770-1-yury.norov@gmail.com>
References: <20221002151702.3932770-1-yury.norov@gmail.com>
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

On Sun,  2 Oct 2022 08:16:58 -0700 Yury Norov wrote:
> netif_attrmask_next_and() generates warnings if CONFIG_DEBUG_PER_CPU_MAPS
> is enabled.

Could you describe the nature of the warning? Is it a false positive 
or a legit warning?

If the former perhaps we should defer until after the next merge window.

> It is used in a single place. netif_attrmask_next() is not
> used at all. With some rework of __netif_set_xps_queue(), we can drop
> both functions, switch the code to well-tested bitmap API and fix the
> warning.

