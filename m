Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2406B4F8F3
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 01:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfFVXax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 19:30:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60898 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFVXax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 19:30:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D550F153A9F33;
        Sat, 22 Jun 2019 16:30:51 -0700 (PDT)
Date:   Sat, 22 Jun 2019 16:30:51 -0700 (PDT)
Message-Id: <20190622.163051.864287952863126273.davem@davemloft.net>
To:     ard.biesheuvel@linaro.org
Cc:     netdev@vger.kernel.org, ebiggers@kernel.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jbaron@akamai.com, cpaasch@apple.com, David.Laight@aculab.com,
        ycheng@google.com
Subject: Re: [PATCH v4 1/1] net: fastopen: robustness and endianness fixes
 for SipHash
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190619214628.2960-2-ard.biesheuvel@linaro.org>
References: <20190619214628.2960-1-ard.biesheuvel@linaro.org>
        <20190619214628.2960-2-ard.biesheuvel@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 16:30:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 19 Jun 2019 23:46:28 +0200

> Some changes to the TCP fastopen code to make it more robust
> against future changes in the choice of key/cookie size, etc.
> 
> - Instead of keeping the SipHash key in an untyped u8[] buffer
>   and casting it to the right type upon use, use the correct
>   type directly. This ensures that the key will appear at the
>   correct alignment if we ever change the way these data
>   structures are allocated. (Currently, they are only allocated
>   via kmalloc so they always appear at the correct alignment)
> 
> - Use DIV_ROUND_UP when sizing the u64[] array to hold the
>   cookie, so it is always of sufficient size, even if
>   TCP_FASTOPEN_COOKIE_MAX is no longer a multiple of 8.
> 
> - Drop the 'len' parameter from the tcp_fastopen_reset_cipher()
>   function, which is no longer used.
> 
> - Add endian swabbing when setting the keys and calculating the hash,
>   to ensure that cookie values are the same for a given key and
>   source/destination address pair regardless of the endianness of
>   the server.
> 
> Note that none of these are functional changes wrt the current
> state of the code, with the exception of the swabbing, which only
> affects big endian systems.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Applied, thank you.
