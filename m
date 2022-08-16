Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7447596507
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237759AbiHPV6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237431AbiHPV6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:58:09 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE5588DE2;
        Tue, 16 Aug 2022 14:58:00 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 27GLvQq12706831;
        Tue, 16 Aug 2022 23:57:26 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 27GLvQq12706831
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1660687046;
        bh=6H8n/CJHMY/1dbaVlTl6Qe9UqLRpU4VI2YY+z9nF3XA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SznzSYA/4B5H02d5CucbwbPrfFwTUunQbGI0MMJNU7eNLKLqFx1rMYo6TvoFSC4GV
         LNJCTj1Aty/au5cKx8+C4s2sX6+JUM1AltzW15VrSE4y6zJnVgltrsxU1MV36lAW2A
         8F6PkE/VGnPN/o/i4O9IM0wwDTjQrPd6lCX3YSp8=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 27GLvO7g2706830;
        Tue, 16 Aug 2022 23:57:24 +0200
Date:   Tue, 16 Aug 2022 23:57:24 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     bernard.f6bvp@gmail.com
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Osterried <thomas@osterried.de>,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        Bernard Pidoux <f6bvp@free.fr>
Subject: Re: [PATCH] rose: check NULL rose_loopback_neigh->loopback
Message-ID: <YvwSxBhoMl0ueJ3z@electric-eye.fr.zoreil.com>
References: <20220816185140.9129-1-bernard.f6bvp@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816185140.9129-1-bernard.f6bvp@gmail.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bernard.f6bvp@gmail.com <bernard.f6bvp@gmail.com> :
> From: Bernard <bernard.f6bvp@gmail.com>
> 
> Since kernel 5.4.83 rose network connections were no more possible.
> Last good rose module was with kernel 5.4.79.
> 
> Francois Romieu <romieu@fr.zoreil.com> pointed the scope of changes to
> the attached commit (3b3fd068c56e3fbea30090859216a368398e39bf
> in mainline, 7f0ddd41e2899349461b578bec18e8bd492e1765 in stable).

The attachment did not follow the references from the original mail. :o/

The paragraph above may be summarized as:

Fixes: 3b3fd068c56e ("rose: Fix Null pointer dereference in rose_send_frame()")

("Suggested-by" would be utter gourmandise)

[...]
> IMHO this patch should be propagated back to LTS 5.4 kernel.

3b3fd068c56e is itself tagged as 'Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")',
i.e. 'problem exists since git epoch back in 2005'. Stable people will
probably apply your fix wherever 3b3fd068c56e has been applied or backported,
namely anything post v5.10, stable v5.4, stable v4.19 and stable v4.14.

> Signed-off-by: Bernard Pidoux <f6bvp@free.fr>
> ---
>  net/rose/rose_loopback.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
> index 11c45c8c6c16..1c673db52636 100644
> --- a/net/rose/rose_loopback.c
> +++ b/net/rose/rose_loopback.c
> @@ -97,8 +97,10 @@ static void rose_loopback_timer(struct timer_list *unused)
> 
> 		if (frametype == ROSE_CALL_REQUEST) {
> 			if (!rose_loopback_neigh->dev) {
> -				kfree_skb(skb);
> -				continue;
> +				if (!rose_loopback_neigh->loopback) {
> +					kfree_skb(skb);
> +					continue;
> +				}

FWIW, avoiding the extra indentation may be marginally more idiomatic:

@@ -96,7 +96,8 @@ static void rose_loopback_timer(struct timer_list *unused)
		}

		if (frametype == ROSE_CALL_REQUEST) {
-			if (!rose_loopback_neigh->dev) {
+			if (!rose_loopback_neigh->dev &&
+			    !rose_loopback_neigh->loopback) {
 				kfree_skb(skb);
 				continue;
			}
Good night.

-- 
Ueimor
