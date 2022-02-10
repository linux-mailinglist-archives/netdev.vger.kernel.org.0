Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E50F4B18F5
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 00:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345359AbiBJXA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 18:00:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344698AbiBJXA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 18:00:57 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1909E2715;
        Thu, 10 Feb 2022 15:00:57 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id EA8C96019D;
        Fri, 11 Feb 2022 00:00:39 +0100 (CET)
Date:   Fri, 11 Feb 2022 00:00:53 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Yi Chen <yiche@redhat.com>
Subject: Re: [PATCHv2 nf] selftests: netfilter: disable rp_filter on router
Message-ID: <YgWZJfIEDYy4Q0aG@salvia>
References: <20220210095056.961984-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220210095056.961984-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 05:50:56PM +0800, Hangbin Liu wrote:
> Some distros may enalbe rp_filter by default. After ns1 change addr to
> 10.0.2.99 and set default router to 10.0.2.1, while the connected router
> address is still 10.0.1.1. The router will not reply the arp request
> from ns1. Fix it by setting the router's veth0 rp_filter to 0.
> 
> Before the fix:
>   # ./nft_fib.sh
>   PASS: fib expression did not cause unwanted packet drops
>   Netns nsrouter-HQkDORO2 fib counter doesn't match expected packet count of 1 for 1.1.1.1
>   table inet filter {
>           chain prerouting {
>                   type filter hook prerouting priority filter; policy accept;
>                   ip daddr 1.1.1.1 fib saddr . iif oif missing counter packets 0 bytes 0 drop
>                   ip6 daddr 1c3::c01d fib saddr . iif oif missing counter packets 0 bytes 0 drop
>           }
>   }
> 
> After the fix:
>   # ./nft_fib.sh
>   PASS: fib expression did not cause unwanted packet drops
>   PASS: fib expression did drop packets for 1.1.1.1
>   PASS: fib expression did drop packets for 1c3::c01d

Applied, thanks
