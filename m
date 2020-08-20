Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C6C24AD2B
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 05:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgHTDGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 23:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgHTDGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 23:06:03 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CADC061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 20:06:03 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id 93so366800otx.2
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 20:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=+egxxcJiPqSVkOhyq5gsQhHcKdtATRbg281zMBXYnow=;
        b=qVGa/f9wzClhXQhWgF69VyeDYCI8We8kW69lttlkSXsJnO+i8YP8/ljtFq/qUy8vNn
         CIuscpQyY8VBQpdCezbxajVk4RqOb01R6wARfzdZzNsqP3LXqr1lWWCOML7I93Xm3Pkt
         E3YDtttg7WKFKNDuM+c3dNrtcwYsA7SGSpZWfHmB1cfQc7jAL6vbt5BlvwXseAjQZ9+o
         hd6tnRzm9dnBwMXaDX+1auiaLjwE13kjjqbtSDmMA/6gt/fNuLpbioHW+LVgbU88+dcX
         c9pj9hmKlMSmNZwXYRx+ELbjTkg4cJTGAmlN+2osIVsm/p0KaI245VuPwG9hrh6gn/Pl
         ytJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=+egxxcJiPqSVkOhyq5gsQhHcKdtATRbg281zMBXYnow=;
        b=lS7DHXZYqZ+pLWSlcsTbE7YkQ0ncqOzxxqYNbbVGUlb5F3EGyC9otcIchoG80GbVOX
         Yqqol5SMuJp/zak4nbLUMVdV0kqyuDf1og+PpYW18TyKkY+eUHeypCI1k9ff6Br/wVoY
         EzQbl+u9M0B/90B9n9bhlcTrxzSRtRDUN/bMRKd5+TSd4OIRL4pTW7ePsXnnf/Gycqki
         j35p8icZUtX39AmrS37oEqM5YOmEyEuS6oTen6Bm8DThYEjTT3SkqyFqh+6rERBhjltT
         PxXXZkd2A5oR5UcD4YoIu35WWX7gmY7TC/k2l5Oh24vZfiiUFSWfHGV7dXSUp1Xr+o++
         YiOg==
X-Gm-Message-State: AOAM532UJbBGvVN/KYJki80V064QzI2/wpSYZqmkU5OZBQ5Ab/cGyq5K
        +aSNMjTebjmDDdLBjnH5I/2GwcIFHxt8RxWl6go=
X-Google-Smtp-Source: ABdhPJwvrfopRTeooVnKd4gk8oXAhgKhnc1cQuC02Mcl+Fsu7/9POUDgsj/z2V8wnfxt/84/LcZWC6j//6Zgl+D75iM=
X-Received: by 2002:a9d:7656:: with SMTP id o22mr644104otl.109.1597892761363;
 Wed, 19 Aug 2020 20:06:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200811054328.GD9456@1wt.eu> <20200811062814.GI25124@SDF.ORG>
 <20200811074538.GA9523@1wt.eu> <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
 <20200812032139.GA10119@1wt.eu> <CA+icZUXS2OPFuEkDC2oHDd344efkbAoq_oP0agqrvWD5FHDXGA@mail.gmail.com>
 <20200813080646.GB10907@1wt.eu> <CA+icZUW8oD6BLnyFUzXHS8fFciLaLQAZnus7GgUdCuSZcMg+MQ@mail.gmail.com>
 <20200814160551.GA11657@1wt.eu> <CA+icZUUVv9DYJHr79FnDcd57QCtXKmzEkt1cYvQ1DT8j1G19Ng@mail.gmail.com>
 <20200816150133.GA17475@1wt.eu> <CA+icZUW9+iEd8wssWmt9M5bhuLyRDMvTGSmJxvJ4qeQ8o78bPQ@mail.gmail.com>
In-Reply-To: <CA+icZUW9+iEd8wssWmt9M5bhuLyRDMvTGSmJxvJ4qeQ8o78bPQ@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 20 Aug 2020 05:05:49 +0200
Message-ID: <CA+icZUUSQGTbfMCUo9JyAZ_FZzvF98v06pRgH+6iMqgVUYijdQ@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     Eric Dumazet <edumazet@google.com>, George Spelvin <lkml@sdf.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Amit Klein <aksecurity@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 6:48 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Sun, Aug 16, 2020 at 5:01 PM Willy Tarreau <w@1wt.eu> wrote:
> >
> > Hi,
> >
> > so as I mentioned, I could run several test on our lab with variations
> > around the various proposals and come to quite positive conclusions.
> >
> > Synthetic observations: the connection rate and the SYN cookie rate do not
> > seem to be affected the same way by the prandom changes. One explanation
> > is that the connection rates are less stable across reboots. Another
> > possible explanation is that the larger state update is more sensitive
> > to cache misses that increase when calling userland. I noticed that the
> > compiler didn't inline siprand_u32() for me, resulting in one extra
> > function call and noticeable register clobbering that mostly vanish
> > once siprand_u32() is inlined, getting back to the original performance.
> >
> > The noise generation was placed as discussed in the xmit calls, however
> > the extra function call and state update had a negative effect on
> > performance and the noise function alone appeared for up to 0.23% of the
> > CPU usage. Simplifying the mix of data by keeping only one long for
> > the noise and using one siphash round on 4 input words to keep only
> > the last word allowed to use very few instructions and to inline them,
> > making the noise collection imperceptible in microbenchmarks. The noise
> > is now collected this way (I verified that all inputs are used), this
> > performs 3 xor, 2 add and 2 rol, which is way sufficient and already
> > better than my initial attempt with a bare add :
> >
> >   static inline
> >   void prandom_u32_add_noise(unsigned long a, unsigned long b,
> >                              unsigned long c, unsigned long d)
> >   {
> >         /*
> >          * This is not used cryptographically; it's just
> >          * a convenient 4-word hash function. (3 xor, 2 add, 2 rol)
> >          */
> >         a ^= __this_cpu_read(net_rand_noise);
> >         PRND_SIPROUND(a, b, c, d);
> >         __this_cpu_write(net_rand_noise, d);
> >   }
> >
> > My tests were run on a 6-core 12-thread Core i7-8700k equipped with a 40G
> > NIC (i40e). I've mainly run two types of tests:
> >
> >   - connections per second: the machine runs a server which accepts and
> >     closes incoming connections. The load generators aim at it and the
> >     connection rate is measured once it's stabilized.
> >
> >   - SYN cookie rate: the load generators flood the machine with enough
> >     SYNs to saturate the CPU and the rate of response SYN-ACK is measured.
> >
> > Both correspond to real world use cases (DDoS protection against SYN flood
> > and connection flood).
> >
> > The base kernel was fc80c51f + Eric's patch to add a tracepoint in
> > prandom_u32(). Another test was made by adding George's changes to use
> > siphash. Then another test was made with the siprand_u32() function
> > inlined and with noise stored as a full siphash state. Then one test
> > was run with the noise reduced to a single long. And a final test was
> > run with the noise function inlined.
> >
> >           connections    SYN cookies   Notes
> >           per second     emitted/s
> >
> >   base:     556k          5.38M
> >
> >   siphash:  535k          5.33M
> >
> >   siphash inlined
> >   +noise:   548k          5.40M    add_noise=0.23%
> >
> >   siphash + single-word
> >    noise    555k          5.45M    add_noise=0.10%
> >
> >   siphash + single-word&inlined
> >    noise    559k          5.38M
> >
> > Actually the last one is better than the previous one because it also
> > swallows more packets. There were 10.9M pps in and 5.38M pps out versus
> > 10.77M in and 5.45M out for the previous one. I didn't report the incoming
> > traffic for the other ones as it was mostly irrelevant and always within
> > these bounds.
> >
> > Finally I've added Eric's patch to reuse the skb hash when known in
> > tcp_conn_request(), and was happy to see the SYN cookies reach 5.45 Mpps
> > again and the connection rate remain unaffected. A perf record during
> > the SYN flood showed almost no call to prandom_u32() anymore (just a few
> > in tcp_rtx_synack()) so this looks like a desirable optimization.
> >
> > At the moment the code is ugly, in experimental state (I've pushed all of
> > it at https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/prandom.git/).
> >
> > My impression on this is that given that it's possible to maintain the
> > same level of performance as we currently have while making the PRNG much
> > better, there's no more reason for not doing it.
> >
> > If there's enough interest at this point, I'm OK with restarting from
> > George's patches and doing the adjustments there. There's still this
> > prandom_seed() which looks very close to prandom_reseed() and that we
> > might possibly better remerge, but I'd vote for not changing everything
> > at once, it's ugly enough already. Also I suspect we can have an infinite
> > loop in prandom_seed() if entropy is 0 and the state is zero as well.
> > We'd be unlucky but I'd just make sure entropy is not all zeroes. And
> > running tests on 32-bit would be desirable as well.
> >
> > Finally one can wonder whether it makes sense to keep Tausworthe for
> > other cases (basic statistical sampling) or drop it. We could definitely
> > drop it and simplify everything given that we now have the same level of
> > performance. But if we do it, what should we do with the test patterns ?
> > I personally don't think that testing a PRNG against a known sequence
> > brings any value by definition, and that the more random we make it the
> > less relevant this is.
> >
>
> Hi Willy,
>
> Thanks for the new patchset and offering it via public available Git.
>
> Thanks for the numbers.
>
> As said I tested here against Linux v5.8.1 - with your previous patchset.
>
> I cannot promise I will test the new one.
>
> First, I have to see how things work with Linux v5.9-rc1 - which will
> hopefully be released within a few hours.
> My primary focus is to make it work with my GNU and LLVM toolchains.
>

I had some time to play with your new patchset.

I tried on top of Linux v5.9-rc1.

Unfortunately, some drivers from the staging area needed to be
disabled due to build failures.

I changed from kernel-modules to disabled:

scripts/config -d RTL8723BS
scripts/config -d R8712U
scripts/config -d R8188EU

See below for the error and [
drivers/staging/rtl8723bs/include/rtw_security.h ] and git grep for
#define K0 | #define K1.

Then I saw some modpost errors:

mkdir -p ./arch/x86_64/boot
ln -fsn ../../x86/boot/bzImage ./arch/x86_64/boot/bzImage
ERROR: modpost: "net_rand_noise" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: modpost: "net_rand_noise" [lib/test_bpf.ko] undefined!
make[4]: *** [scripts/Makefile.modpost:111: Module.symvers] Error 1
make[4]: *** Deleting file 'Module.symvers'

Where I changed from kernel-modules to disabled:

scripts/config -d TEST_BPF
scripts/config -d LIBFCOE

- Sedat -

[ CONFIG_R8188EU=m and CONFIG_88EU_AP_MODE=y ]

$ grep "Error 1" build-log_5.9.0-rc1-5-amd64-llvm11-ias.txt
make[6]: *** [scripts/Makefile.build:283:
drivers/staging/rtl8188eu/core/rtw_ap.o] Error 1

[ CONFIG_RTL8723BS=m ]

In file included from drivers/staging/rtl8723bs/core/rtw_btcoex.c:7:
In file included from ./drivers/staging/rtl8723bs/include/drv_types.h:42:
./drivers/staging/rtl8723bs/include/rtw_security.h:275:7: error:
expected member name or ';' after declaration specifiers
        u32  K0, K1;         /*  Key */
        ~~~  ^
./include/linux/prandom.h:35:13: note: expanded from macro 'K0'
#define K0 (0x736f6d6570736575 ^ 0x6c7967656e657261 )
            ^
In file included from drivers/staging/rtl8723bs/core/rtw_btcoex.c:7:
In file included from ./drivers/staging/rtl8723bs/include/drv_types.h:42:
./drivers/staging/rtl8723bs/include/rtw_security.h:275:7: error: expected ')'
./include/linux/prandom.h:35:13: note: expanded from macro 'K0'
#define K0 (0x736f6d6570736575 ^ 0x6c7967656e657261 )
            ^
./drivers/staging/rtl8723bs/include/rtw_security.h:275:7: note: to
match this '('
./include/linux/prandom.h:35:12: note: expanded from macro 'K0'
#define K0 (0x736f6d6570736575 ^ 0x6c7967656e657261 )
           ^
In file included from drivers/staging/rtl8723bs/core/rtw_btcoex.c:7:
In file included from ./drivers/staging/rtl8723bs/include/drv_types.h:42:
./drivers/staging/rtl8723bs/include/rtw_security.h:275:11: error:
expected member name or ';' after declaration specifiers
        u32  K0, K1;         /*  Key */
        ~~~      ^
./include/linux/prandom.h:36:13: note: expanded from macro 'K1'
#define K1 (0x646f72616e646f6d ^ 0x7465646279746573 )
            ^
In file included from drivers/staging/rtl8723bs/core/rtw_btcoex.c:7:
In file included from ./drivers/staging/rtl8723bs/include/drv_types.h:42:
./drivers/staging/rtl8723bs/include/rtw_security.h:275:11: error: expected ')'
./include/linux/prandom.h:36:13: note: expanded from macro 'K1'
#define K1 (0x646f72616e646f6d ^ 0x7465646279746573 )
            ^
./drivers/staging/rtl8723bs/include/rtw_security.h:275:11: note: to
match this '('
./include/linux/prandom.h:36:12: note: expanded from macro 'K1'
#define K1 (0x646f72616e646f6d ^ 0x7465646279746573 )
           ^
4 errors generated.
make[6]: *** [scripts/Makefile.build:283:
drivers/staging/rtl8723bs/core/rtw_btcoex.o] Error 1

[ drivers/staging/rtl8723bs/include/rtw_security.h ]

struct mic_data {
    u32  K0, K1;         /*  Key */
    u32  L, R;           /*  Current state */
    u32  M;              /*  Message accumulator (single word) */
    u32     nBytesInM;      /*  # bytes in M */
}

$ git grep -E 'K0 |K1 ' drivers/staging/ | grep -i key
drivers/staging/rtl8188eu/core/rtw_security.c:  pmicdata->K0 =
secmicgetuint32(key);
drivers/staging/rtl8188eu/core/rtw_security.c:  pmicdata->K1 =
secmicgetuint32(key + 4);
drivers/staging/rtl8712/rtl871x_security.c:     pmicdata->K0 =
secmicgetuint32(key);
drivers/staging/rtl8712/rtl871x_security.c:     pmicdata->K1 =
secmicgetuint32(key + 4);
drivers/staging/rtl8723bs/core/rtw_security.c:  pmicdata->K0 =
secmicgetuint32(key);
drivers/staging/rtl8723bs/core/rtw_security.c:  pmicdata->K1 =
secmicgetuint32(key + 4);

$ git grep -E '\#define K0 |\#define K1 '
arch/arm/crypto/sha1-armv7-neon.S:#define K1  0x5A827999
arch/x86/crypto/sha1_avx2_x86_64_asm.S:#define K1 0x5a827999
crypto/rmd128.c:#define K1  RMD_K1
crypto/rmd160.c:#define K1  RMD_K1
crypto/rmd256.c:#define K1  RMD_K1
crypto/rmd320.c:#define K1  RMD_K1
fs/ext4/hash.c:#define K1 0
include/linux/prandom.h:#define K0 (0x736f6d6570736575 ^ 0x6c7967656e657261 )
include/linux/prandom.h:#define K1 (0x646f72616e646f6d ^ 0x7465646279746573 )
include/linux/prandom.h:#define K0 0x6c796765
include/linux/prandom.h:#define K1 0x74656462
lib/random32.c:#define K0 (0x736f6d6570736575 ^ 0x6c7967656e657261 )
lib/random32.c:#define K1 (0x646f72616e646f6d ^ 0x7465646279746573 )
lib/random32.c:#define K0 0x6c796765
lib/random32.c:#define K1 0x74656462

We have the same defines for K0 and K1 in include/linux/prandom.h and
lib/random32.c?
More room for simplifications?

- EOT -
