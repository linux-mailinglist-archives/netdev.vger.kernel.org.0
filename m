Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB16D23D415
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 01:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgHEXD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 19:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgHEXD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 19:03:56 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EC7C061574
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 16:03:55 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j19so25623654pgm.11
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 16:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:mime-version:subject:from:in-reply-to:cc
         :date:message-id:references:to;
        bh=uLBYUTnw9Z+74Aj4SR5Qjaxb4nMHXf9QCuupJPejSUc=;
        b=g+hrT99ZtYzguhFzzkZ4UR5OiG5nV7TPkFPrKp4hoI45WLAVypnJsCBSaHmqvf3Je+
         SVEcomvCFFdlIbAsb4RIhJv53ZMr6GaL1PBk0f/Jh8vZlfpsYls0J/uufLtAx3Tj1hTB
         VyOwo5m7gALv1CzVeTIvUqt7YTcVWOscyTx6KhJLxJcIHwIfm4AOE3UrqVbsn+e+yvmK
         Tq8geHbroBgMPEy6Uyc2aMzN9CqRieE6LsJBNjzFa2wGT+XKIQTbSyGFir4UVD4/GZum
         hMxJiR4JH+RM235vcBAN21860fGWD5D5N8UXnG3uyPLXMLLIniR17gyoFJodhFgD+Twe
         HUJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:mime-version:subject
         :from:in-reply-to:cc:date:message-id:references:to;
        bh=uLBYUTnw9Z+74Aj4SR5Qjaxb4nMHXf9QCuupJPejSUc=;
        b=sjR/0dHYw/+W5V/ZHPMFfEFJZIprilPiYUVQxpWN0WLyWpxA7w++7qE7JYV8YGpHMa
         yhVLY/rIIMXnYBT8gsLV+b+wKnH1YM1m5u/Xqz6ZIg3SKqj/X0uWWWbrglXPuZ1+N58+
         Xv+vG5fHKeVkQp0skUUFunP4N2veAKE+ZsMQeV1RZJSNmp6QTLWJTJRwP4RPhtHZnzuj
         Dwu3J0bhmGF86HjBG/L0wRAAx1dX+1Z6tj76JDgi9ySPtQwfybr+/mpYgnfM0qmfFKPM
         eivlrRuS3rLd9Rgyco78vuSSvYPmHWdhmeuBEsev9Oi/blw9ctpujaK+M969Koht5Kex
         PI+A==
X-Gm-Message-State: AOAM530no5VHPPELHmX7i1jhNSK6B1GkHJvIQeijyujU1lKmqgMLVHSq
        puYyZtFcec/Nq3LDSQtsp9aS5Q==
X-Google-Smtp-Source: ABdhPJy0cWmM7VcSKZcB6RJLl2odCIeq1tlznOYQIVXKJ/MNA6YEiJdiR6e/aTbUOlh3Q2kjt8TZSg==
X-Received: by 2002:a63:4714:: with SMTP id u20mr4999261pga.104.1596668634635;
        Wed, 05 Aug 2020 16:03:54 -0700 (PDT)
Received: from [192.168.0.248] (c-67-180-165-146.hsd1.ca.comcast.net. [67.180.165.146])
        by smtp.gmail.com with ESMTPSA id e26sm4439271pfj.197.2020.08.05.16.03.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 16:03:53 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (1.0)
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
From:   Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <20200805220550.GA785826@mit.edu>
Cc:     Marc Plumb <lkml.mplumb@gmail.com>, Willy Tarreau <w@1wt.eu>,
        netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
Date:   Wed, 5 Aug 2020 16:03:52 -0700
Message-Id: <4FAC5E1F-870F-47E3-BBE8-6172FDA15738@amacapital.net>
References: <20200805220550.GA785826@mit.edu>
To:     tytso@mit.edu
X-Mailer: iPhone Mail (17G68)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> On Aug 5, 2020, at 3:06 PM, tytso@mit.edu wrote:
>>=20
>> =EF=BB=BFOn Wed, Aug 05, 2020 at 09:06:40AM -0700, Marc Plumb wrote:
>> Isn't get_random_u32 the function you wrote to do that? If this needs to b=
e
>> cryptographically secure, that's an existing option that's safe.
>> The fundamental question is: Why is this attack on net_rand_state problem=
?
>> It's Working as Designed. Why is it a major enough problem to risk harmin=
g
>> cryptographically important functions?
>=20
> I haven't looked at the users of net_rand_state, but historically, the
> networking subsystem has a expressed a (perceived?) need for *very* fast
> mostly-random-but-if-doens't-have-to-be-perfect-numbers-our-benchmarks-
> are-way-more-important numbers.   As in, if there are extra cache line
> misses, our benchmarks would suffer and that's not acceptable.
>=20
> One of the problems here is that it's not sufficient for the average case
> to be fast, but once in every N operations, we need to do something that
> requires Real Crypto, and so that Nth time, there would be an extra lag
> and that would be the end of the world (at least as far as networking
> benchmarks are concerned, anyway).

I respectfully disagree with the supposed network people :). I=E2=80=99m wor=
king, slowly, on a patch set to make this genuinely fast. =20

>  So in other words, it's not enough for
> the average time to run get_random_u32() to be fast, they care about the 9=
5th or
> 99th percentile number of get_random_u32() to be fast as well.
>=20
> An example of this would be for TCP sequence number generation; it's
> not *really* something that needs to be secure, and if we rekey the
> RNG every 5 minutes, so long as the best case attack takes at most,
> say, an hour, if the worst the attacker can do is to be able to carry
> out an man-in-the-middle attack without being physically in between
> the source and the destination --- well, if you *really* cared about
> security the TCP connection would be protected using TLS anyway.  See
> RFC 1948 (later updated by RFC 6528) for an argument along these
> lines.
>=20
>> This whole thing is making the fundamental mistake of all amateur
>> cryptographers of trying to create your own cryptographic primitive. You'=
re
>> trying to invent a secure stream cipher. Either don't try to make
>> net_rand_state secure, or use a known secure primitive.
>=20
> Well, technically it's not supposed to be a secure cryptographic
> primitive.  net_rand_state is used in the call prandom_u32(), so the
> only supposed guarantee is PSEUDO random.
>=20
> That being said, a quick "get grep prandom_u32" shows that there are a
> *huge* number of uses of prandom_u32() and whether they are all
> appropriate uses of prandom_u32(), or kernel developers are using it
> because "I haz a ne3D for spE3d" but in fact it's for a security
> critical application is a pretty terrifying question.  If we start
> seeing CVE's getting filed caused by inappropriate uses of
> prandom_u32, to be honest, it won't surprise me.
>=20
>                       - Ted
