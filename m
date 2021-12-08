Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD3946CD71
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 07:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237138AbhLHGJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 01:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhLHGJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 01:09:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA532C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 22:05:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D81BB81F81
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 06:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B818C00446;
        Wed,  8 Dec 2021 06:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638943533;
        bh=zzfwDRv9y1IRu9C9oWpTZWP2EwA8zxn89iIkHye7Qzc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cyudHH20XqfxEKNdLlI00fAZmimK1/dsQvinfoQhwnNu2FYUnpWrJupczxi+xqecf
         NZXRGgJJyDssb3DXRv2mBsuEkXTIFuxT1uEplFGfU5nORx/ECzaYO6Jb1qPgZCVlwB
         Ul87GfucwAWbpO4UHX6hDK8axyd07li2IoQEStNlCQmM7Cls9U0+uSPLhRtQnhYVxt
         MkEOWGVX+NvtgbYRNW2OpITtl0x0matVFf9pr6OuecyHYv+5sKHrPJNtMg9rpwAuAv
         pG2cHy367MrrY9aH3QP8CpaVrtYqrx8M7t1Ssn+XLiOWeme6acqewMo+fCfGpv+pOI
         7lIRNtR9piX4w==
Date:   Tue, 7 Dec 2021 22:05:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] sock: Use sock_owned_by_user_nocheck() instead
 of sk_lock.owned.
Message-ID: <20211207220531.48a78cc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208053924.51254-1-kuniyu@amazon.co.jp>
References: <20211208053924.51254-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 14:39:24 +0900 Kuniyuki Iwashima wrote:
>  static inline void sock_release_ownership(struct sock *sk)
>  {
> -	if (sk->sk_lock.owned) {
> +	if (sock_owned_by_user_nocheck(sk) {

ENOTBUILT
