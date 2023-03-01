Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C356A70CB
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 17:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjCAQXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 11:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjCAQXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 11:23:48 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85D1C130;
        Wed,  1 Mar 2023 08:23:47 -0800 (PST)
Date:   Wed, 1 Mar 2023 17:23:43 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH nf] selftests: nft_nat: ensuring the listening side is up
 before starting the client
Message-ID: <Y/98D2kGsPYW5/X4@salvia>
References: <20230227093646.1066666-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230227093646.1066666-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 05:36:46PM +0800, Hangbin Liu wrote:
> The test_local_dnat_portonly() function initiates the client-side as
> soon as it sets the listening side to the background. This could lead to
> a race condition where the server may not be ready to listen. To ensure
> that the server-side is up and running before initiating the
> client-side, a delay is introduced to the test_local_dnat_portonly()
> function.
> 
> Before the fix:
>   # ./nft_nat.sh
>   PASS: netns routing/connectivity: ns0-rthlYrBU can reach ns1-rthlYrBU and ns2-rthlYrBU
>   PASS: ping to ns1-rthlYrBU was ip NATted to ns2-rthlYrBU
>   PASS: ping to ns1-rthlYrBU OK after ip nat output chain flush
>   PASS: ipv6 ping to ns1-rthlYrBU was ip6 NATted to ns2-rthlYrBU
>   2023/02/27 04:11:03 socat[6055] E connect(5, AF=2 10.0.1.99:2000, 16): Connection refused
>   ERROR: inet port rewrite
> 
> After the fix:
>   # ./nft_nat.sh
>   PASS: netns routing/connectivity: ns0-9sPJV6JJ can reach ns1-9sPJV6JJ and ns2-9sPJV6JJ
>   PASS: ping to ns1-9sPJV6JJ was ip NATted to ns2-9sPJV6JJ
>   PASS: ping to ns1-9sPJV6JJ OK after ip nat output chain flush
>   PASS: ipv6 ping to ns1-9sPJV6JJ was ip6 NATted to ns2-9sPJV6JJ
>   PASS: inet port rewrite without l3 address

Applied, thanks
