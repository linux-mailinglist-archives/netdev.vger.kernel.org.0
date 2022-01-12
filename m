Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4FF48CB48
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356553AbiALSvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:51:08 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47228 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243240AbiALSum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:50:42 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2DF391F3A5;
        Wed, 12 Jan 2022 18:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642013440;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9t4ykiev75tOG14agjjEElmq+NfQnoyJeSZiMYsCQ74=;
        b=GA31Y6uj4RTWFy7ndujKKLV9PobXnA2n8kWf7kTlcAmzPRUztdbpshlGKpBa+n2cydTkOx
        0dAIzM7Tbqs7BME7KNV+Yy0aU7EFerLGZDANOLYuYcWujWuOXxoySYekI8h2CYsB8iYy6m
        D45fgjmKCNnez8Zk2QshZuffFBRdzxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642013440;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9t4ykiev75tOG14agjjEElmq+NfQnoyJeSZiMYsCQ74=;
        b=CGg0jecFB56y0XEaaS0FixyfA/e3oLE8AuXg4Ao+GCZ4SPBjzxM3XX00hwinwA/AAOmJkh
        kh2nH7cd0jwzF0Cw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id B9DC1A3B87;
        Wed, 12 Jan 2022 18:50:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2B768DA799; Wed, 12 Jan 2022 19:50:05 +0100 (CET)
Date:   Wed, 12 Jan 2022 19:50:05 +0100
From:   David Sterba <dsterba@suse.cz>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC v1 0/3] remove remaining users of SHA-1
Message-ID: <20220112185004.GZ14046@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        linux-crypto@vger.kernel.org
References: <20220112131204.800307-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112131204.800307-1-Jason@zx2c4.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 02:12:01PM +0100, Jason A. Donenfeld wrote:
> Hi,
> 
> There are currently two remaining users of SHA-1 left in the kernel: bpf
> tag generation, and ipv6 address calculation. In an effort to reduce
> code size and rid ourselves of insecure primitives, this RFC patchset
> moves to using the more secure BLAKE2s function.

What's the rationale to use 2s and not 2b? Everywhere I can find the 2s
version is said to be for 8bit up to 32bit machines and it's worse than
2b in benchmarks (reading https://bench.cr.yp.to/results-hash.html).

I'd understand you go with 2s because you also chose it for wireguard
but I'd like know why 2s again even if it's not made for 64bit
architectures that are preferred nowadays.
