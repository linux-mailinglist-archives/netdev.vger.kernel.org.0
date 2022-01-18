Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765CD49261C
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 13:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240750AbiARMvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 07:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240692AbiARMvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 07:51:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009BCC06173F;
        Tue, 18 Jan 2022 04:51:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDD1EB816AC;
        Tue, 18 Jan 2022 12:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378DCC340E4;
        Tue, 18 Jan 2022 12:51:08 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="eYC5MTOk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642510265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aSiR7YEHvJaKHTnMIILFzOkcmwUIlMPzXsxw9ZnBI3Y=;
        b=eYC5MTOkijSIrXgJ+k9o+9KWJ3k4ZYH2b1OIOqxYemd/Sd4xXrqQDKVRW33Ae06nJH4FCT
        cCOSIY3yudO5RQFcm8ks3iuV4NAKzzceXEV9o61UZZPsYi6N9KD5ZpfdGusTScaPUL57Cm
        dtff/SjvdeOrA9qjq4Wyv6a+4uv4Els=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 75393e86 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 18 Jan 2022 12:51:04 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id g12so3212236ybh.4;
        Tue, 18 Jan 2022 04:51:03 -0800 (PST)
X-Gm-Message-State: AOAM533c6wfarhsTHIhsocIjftHjXlZGIkZzUV32SpgwndER8UmKc0ai
        x+oXX1JBwjsN6enQ5TU7kYJIaoKuDZI8C5EHpb8=
X-Google-Smtp-Source: ABdhPJwY2ELAn5kS+mwPaaHBQswuJ3oE0RiWfmcengPaj3auGPdAvQB2OXUdKUyLLnqvr41yhKrLp/xzPpJ5HkesbqY=
X-Received: by 2002:a25:bc52:: with SMTP id d18mr3401186ybk.255.1642510262147;
 Tue, 18 Jan 2022 04:51:02 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9rxdksVZkN4DF_GabsEPrSDrKbo1cVQs77B_s-e2jZ64A@mail.gmail.com>
 <YeZhVGczxcBl0sI9@gondor.apana.org.au> <CAHmME9ogAW0o2PReNtsD+fFgwp28q2kP7WADtbd8kA7GsnKBpg@mail.gmail.com>
 <ad862f5ad048404ab452e25bba074824@AcuMS.aculab.com>
In-Reply-To: <ad862f5ad048404ab452e25bba074824@AcuMS.aculab.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 18 Jan 2022 13:50:51 +0100
X-Gmail-Original-Message-ID: <CAHmME9qqqz80hd4er8eAqYpo1gzLSPVyDub0sfmY0YBEqLeiHw@mail.gmail.com>
Message-ID: <CAHmME9qqqz80hd4er8eAqYpo1gzLSPVyDub0sfmY0YBEqLeiHw@mail.gmail.com>
Subject: Re: [PATCH crypto v3 0/2] reduce code size from blake2s on m68k and
 other small platforms
To:     David Laight <David.Laight@aculab.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wireguard@lists.zx2c4.com" <wireguard@lists.zx2c4.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jeanphilippe.aumasson@gmail.com" <jeanphilippe.aumasson@gmail.com>,
        "ardb@kernel.org" <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 1:45 PM David Laight <David.Laight@aculab.com> wrote:
> I've rammed the code through godbolt... https://godbolt.org/z/Wv64z9zG8
>
> Some things I've noticed;

It seems like you've done a lot of work here but...

>    But I've not got time to test the code.

But you're not going to take it all the way. So it unfortunately
amounts to mailing list armchair optimization. That's too bad because
it really seems like you might be onto something worth seeing through.
As I've mentioned a few times now, I've dropped the blake2s
optimization patch, and I won't be developing that further. But it
appears as though you've really been captured by it, so I urge you:
please send a real patch with benchmarks on various platforms! (And CC
me on the patch.) Faster reference code would really be terrific.

Jason
