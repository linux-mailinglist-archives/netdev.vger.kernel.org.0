Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1D34EA50E
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 04:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbiC2CSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 22:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiC2CSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 22:18:49 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB4823F3D2
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 19:17:05 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h4so11293079edr.3
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 19:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=OgOwwwPtBqtH2Nfvw1oTQa9WeHu8kROOmi+nT3PQOWs=;
        b=V7+/CQTv/H4n6YyDO8BLudQHcJgZxpoNa9CD/3M3UIY/1jEZXiWxext68upgmuvFwF
         BjngFaVv5dGVhg4VDJI5HYCL6/kzbJXP7GRK754XfWFlOyw4Z9ApV049UlrmyqTyM4Zv
         kkfiZEncbpF3dD3yofGwLrJ9Y8U0zARijB2jtTZx9kBPdoVTNiJhCYOUp+gBvrwQ6lVC
         w2+Dd7W5+5Z9DjOX89fTRhJlos0ncJXGJa1SgdOfIGQ0TgOgDBI0Xqnsy0z+7seCrSQ+
         C8UWfBv35a+04581MsPqEEpXrGQpKxiKZu2MrOwsZUy+uI7Zz9nfoKYBt1qVIsrcp2ph
         dS6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OgOwwwPtBqtH2Nfvw1oTQa9WeHu8kROOmi+nT3PQOWs=;
        b=iFgIXvLj/qJIhCHgkKI43cIfp7gHX6MPcGeezdz31xqyqG/AAJLfMJOGnttMCzxqWB
         Ig7r5TTEkd/GNjjP/hUtSo986xBYsjmRZhwsEbHXHM/mctLdpD/aiCc9a4lMvjIlt43F
         s4CrdRYwgOYFlLJlHyRQfYD6OyVMl/A4g9xM9aLXe4MwCZ0JR0gHjFPY7LcovmnofljK
         6Fc7GqqL8PTEXA7CDg7bfYjoV1vMK4NsW1b/K4OBHMzdPf1dNJ9uy2i+WJ9CsF1cF/Lu
         dsHaHNHKISWOZPT1h4yj6rfNa0fj0nCnjrLGWBEzPGq3EfGRWp5rx8F5ayXi6o8SWr98
         UoGQ==
X-Gm-Message-State: AOAM531oYHveHj3CQwmUaeaEXO0kfSbCFDiwCLZeMJgSxE1tOWpfSQAw
        OnJr6E1v82IDPtJzmwJJ7vLGEsvG+tYA0ZOGXS0=
X-Google-Smtp-Source: ABdhPJyuFLNxU6tDwxqf3G3+4NkWH0WP5fgIDlKCEEToOCDFNckn0o8usGU5L7W468nFbMiVibAYURDgefwZiDNvWq0=
X-Received: by 2002:a50:d592:0:b0:415:e599:4166 with SMTP id
 v18-20020a50d592000000b00415e5994166mr1251977edi.195.1648520224123; Mon, 28
 Mar 2022 19:17:04 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Tue, 29 Mar 2022 03:16:55 +0100
Message-ID: <CAHpNFcMxWJHfjAbAX+5uLsd7LaK1Kfo2DArFMOeSMt1pkeFh2w@mail.gmail.com>
Subject: Dev/Random : 4096-bit LFSR used for entropy collection : Submission 118
To:     torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dev/Random : 4096-bit LFSR used for entropy collection

Basically the HASH is what makes a difference, In respect to BLAKE2
running out of entropy...
An internal backup PKI AES/Blake2 Secondary HASH stored in Kernel...

Bear in mind that the backup seed is worked from quality Random & is
99% unique : "We are The 99%"

This keeps simple Pseudo numbers from being the bearer of predictable
kernel Security behavior,
Nothing wrong with keeping more! & we can for system device pools for example!

For reference core HASH reserve storage can be per type:

Main groups for Secondary hash main leaf HASH:

/Dev
/Memory
/Storage
/Keys
/Con

Rupert S

*RAND OP Ubuntu :
https://manpages.ubuntu.com/manpages/trusty/man1/pollinate.1.html

https://pollinate.n-helix.com

https://science.n-helix.com/2018/12/rng.html

https://science.n-helix.com/2022/02/rdseed.html

https://science.n-helix.com/2017/04/rng-and-random-web.html

https://science.n-helix.com/2022/02/interrupt-entropy.html

https://science.n-helix.com/2021/11/monticarlo-workload-selector.html

https://science.n-helix.com/2022/03/security-aspect-leaf-hash-identifiers.html


Audio, Visual & Bluetooth & Headset & mobile developments only go so far:

https://science.n-helix.com/2022/02/visual-acuity-of-eye-replacements.html

https://science.n-helix.com/2022/03/ice-ssrtp.html

https://science.n-helix.com/2021/11/ihmtes.html

https://science.n-helix.com/2021/10/eccd-vr-3datmos-enhanced-codec.html
https://science.n-helix.com/2021/11/wave-focus-anc.html
https://science.n-helix.com/2021/12/3d-audio-plugin.html

https://aka.ms/win10rng

"https://www.spinics.net/lists/stable/msg543787.html

From: "Jason A. Donenfeld" <Jason@xxxxxxxxx>

[ Upstream commit 6e8ec2552c7d13991148e551e3325a624d73fac6 ]

The current 4096-bit LFSR used for entropy collection had a few
desirable attributes for the context in which it was created. For
example, the state was huge, which meant that /dev/random would be able
to output quite a bit of accumulated entropy before blocking. It was
also, in its time, quite fast at accumulating entropy byte-by-byte,
which matters given the varying contexts in which mix_pool_bytes() is
called. And its diffusion was relatively high, which meant that changes
would ripple across several words of state rather quickly.

However, it also suffers from a few security vulnerabilities. In
particular, inputs learned by an attacker can be undone, but moreover,
if the state of the pool leaks, its contents can be controlled and
entirely zeroed out. I've demonstrated this attack with this SMT2
script, <https://xn--4db.cc/5o9xO8pb>, which Boolector/CaDiCal solves in
a matter of seconds on a single core of my laptop, resulting in little
proof of concept C demonstrators such as <https://xn--4db.cc/jCkvvIaH/c>.

For basically all recent formal models of RNGs, these attacks represent
a significant cryptographic flaw. But how does this manifest
practically? If an attacker has access to the system to such a degree
that he can learn the internal state of the RNG, arguably there are
other lower hanging vulnerabilities -- side-channel, infoleak, or
otherwise -- that might have higher priority. On the other hand, seed
files are frequently used on systems that have a hard time generating
much entropy on their own, and these seed files, being files, often leak
or are duplicated and distributed accidentally, or are even seeded over
the Internet intentionally, where their contents might be recorded or
tampered with. Seen this way, an otherwise quasi-implausible
vulnerability is a bit more practical than initially thought.

Another aspect of the current mix_pool_bytes() function is that, while
its performance was arguably competitive for the time in which it was
created, it's no longer considered so. This patch improves performance
significantly: on a high-end CPU, an i7-11850H, it improves performance
of mix_pool_bytes() by 225%, and on a low-end CPU, a Cortex-A7, it
improves performance by 103%.

This commit replaces the LFSR of mix_pool_bytes() with a straight-
forward cryptographic hash function, BLAKE2s, which is already in use
for pool extraction. Universal hashing with a secret seed was considered
too, something along the lines of <https://eprint.iacr.org/2013/338>,
but the requirement for a secret seed makes for a chicken & egg problem.
Instead we go with a formally proven scheme using a computational hash
function, described in sections 5.1, 6.4, and B.1.8 of
<https://eprint.iacr.org/2019/198>."
