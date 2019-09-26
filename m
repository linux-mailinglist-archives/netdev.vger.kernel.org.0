Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCBFBFB67
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 00:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfIZWr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 18:47:29 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37338 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfIZWr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 18:47:29 -0400
Received: by mail-qt1-f196.google.com with SMTP id l3so4957558qtr.4
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 15:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=SYDe/o2kLFR5SneKG6UQbh/y8tn28Z982DDnMOJdbek=;
        b=mlrCBvUOrlKqAzldrnB/bm30cDnNznI4nYgb+Kxyk+nhts4qaRjdCIK88d3kK0tks7
         9GmIWZ7zNMf/jpG7cruBS8VC6I4UewCaQEk4Ax7zlSOIYWES2xe5wbAneHuAyHypHh/B
         mBSulXPxoCZzkkEoj+Ve1eSZhJXSJNxh2cRmSOA7v84gbtsO2tr4xYsOMwfuYTX6DeDZ
         ENbytWggHdbVj8eh4QHquj741T9lK1gXsSCievOJuXBAK4pZrIgPkcxueKsgSHfepWxb
         Ez6L2p+lUynes77n7sEd5BImBQsAwmJoj5xYKOupCvr4UM/7ghkhq8N5GLTluxj9ZpJV
         AINA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=SYDe/o2kLFR5SneKG6UQbh/y8tn28Z982DDnMOJdbek=;
        b=FF01Ec+9Qj5gc1Oqi1h5l2LuKNiiX0Ny+vS166dE7Tv0rTuS8khMh2rV2VwSGbIrfr
         YRwdkTpMo4JUhM0pt/Cks1jyoqZ9Li8w4xrAyYJue3Ms6kbj/PgUxjRlZ6Y9Av5VYtRP
         IGsl6exkDVmdTeDssBVNhS76ld3XshjjRFuW3sHJPFe1iH3PtB8vTIQDV4wKT1ZO43pr
         XgY/BkbmE4uU24tIicJy/qbl8wnYTDwwA2NbTTUc6piMjNPfKAsEAdYoNID/j8yNQyUH
         rV+aoOooxthbplhuViC/sLfRYnOrfd999IJgNW6Dd7DwHMLCgBTh9Y32UlDNY2fd4x/y
         vzeA==
X-Gm-Message-State: APjAAAW2xDjKo4XRFTtrTdGozdtOAEQO3owy2Vk1mnEao9M3JxLqs5lh
        0ilJYrRNSG8lW2KN9XNsWZVSiQ==
X-Google-Smtp-Source: APXvYqy1Y/XIttcdtZ3Wy5MYgHOKxq0uC8vN990QVXqdJlgTICSWdAf37n8LWS1SWgE0rxHPiXmPsA==
X-Received: by 2002:a0c:9846:: with SMTP id e6mr5221088qvd.114.1569538048482;
        Thu, 26 Sep 2019 15:47:28 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a11sm322826qkc.123.2019.09.26.15.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 15:47:28 -0700 (PDT)
Date:   Thu, 26 Sep 2019 15:47:21 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Willy Tarreau <w@1wt.eu>, Netdev <netdev@vger.kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Dave Taht <dave.taht@gmail.com>
Subject: Re: chapoly acceleration hardware [Was: Re: [RFC PATCH 00/18]
 crypto: wireguard using the existing crypto API]
Message-ID: <20190926154721.094139b0@cakuba.netronome.com>
In-Reply-To: <CAHmME9r5m7D-oMU6Lv_ZhEyWmrNscMr5HokzdK0wg2Ayzzbeow@mail.gmail.com>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
        <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
        <MN2PR20MB29733663686FB38153BAE7EACA860@MN2PR20MB2973.namprd20.prod.outlook.com>
        <CAHmME9r5m7D-oMU6Lv_ZhEyWmrNscMr5HokzdK0wg2Ayzzbeow@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Sep 2019 13:06:51 +0200, Jason A. Donenfeld wrote:
> On Thu, Sep 26, 2019 at 12:19 PM Pascal Van Leeuwen wrote:
> > Actually, that assumption is factually wrong. I don't know if anything
> > is *publicly* available, but I can assure you the silicon is running in
> > labs already. And something will be publicly available early next year
> > at the latest. Which could nicely coincide with having Wireguard support
> > in the kernel (which I would also like to see happen BTW) ...
> >
> > Not "at some point". It will. Very soon. Maybe not in consumer or server
> > CPUs, but definitely in the embedded (networking) space.
> > And it *will* be much faster than the embedded CPU next to it, so it will
> > be worth using it for something like bulk packet encryption.  
> 
> Super! I was wondering if you could speak a bit more about the
> interface. My biggest questions surround latency. Will it be
> synchronous or asynchronous? If the latter, why? What will its
> latencies be? How deep will its buffers be? The reason I ask is that a
> lot of crypto acceleration hardware of the past has been fast and
> having very deep buffers, but at great expense of latency. In the
> networking context, keeping latency low is pretty important.

FWIW are you familiar with existing kTLS, and IPsec offloads in the
networking stack? They offload the crypto into the NIC, inline, which
helps with the latency, and processing overhead.

There are also NIC silicon which can do some ChaCha/Poly, although 
I'm not familiar enough with WireGuard to know if offload to existing
silicon will be possible.
