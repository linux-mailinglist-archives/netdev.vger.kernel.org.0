Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0363E2B5C19
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgKQJrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:47:00 -0500
Received: from s2.neomailbox.net ([5.148.176.60]:34143 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727384AbgKQJrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 04:47:00 -0500
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        wireguard@lists.zx2c4.com,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Antonio Quartulli <antonio@openvpn.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20201117021839.4146-1-a@unstable.cc>
 <CAMj1kXFxk31wtD3H8V0KbMd82UL_babEWpVTSkfqPpNjSqPNLA@mail.gmail.com>
From:   Antonio Quartulli <a@unstable.cc>
Subject: Re: [PATCH cryptodev] crypto: lib/chacha20poly1305 - allow users to
 specify 96bit nonce
Message-ID: <5096882f-2b39-eafb-4901-0899783c5519@unstable.cc>
Date:   Tue, 17 Nov 2020 10:45:52 +0100
MIME-Version: 1.0
In-Reply-To: <CAMj1kXFxk31wtD3H8V0KbMd82UL_babEWpVTSkfqPpNjSqPNLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


On 17/11/2020 09:31, Ard Biesheuvel wrote:
> If you are going back to the drawing board with in-kernel acceleration
> for OpenVPN, I strongly suggest to:
> a) either stick to one implementation, and use the library interface,
> or use dynamic dispatch using the crypto API AEAD abstraction, which
> already implements 96-bit nonces for ChaCha20Poly1305,

What we are implementing is a simple Data Channel Offload, which is
expected to be compatible with the current userspace implementation.
Therefore we don't want to change how encryption is performed.

Using the crypto API AEAD abstraction will be my next move at this point.

I just find it a bit strange that an API of a well defined crypto schema
is implemented in a way that accommodates only some of its use cases.


But I guess it's accepted that we will have to live with two APIs for a bit.


> b) consider using Aegis128 instead of AES-GCM or ChaChaPoly - it is
> one of the winners of the CAESAR competition, and on hardware that
> supports AES instructions, it is extremely efficient, and not
> encumbered by the same issues that make AES-GCM tricky to use.
> 
> We might implement a library interface for Aegis128 if that is preferable.

Thanks for the pointer!
I guess we will consider supporting Aegis128 once it gets standardized
(AFAIK it is not yet).


Best Regards,


-- 
Antonio Quartulli
