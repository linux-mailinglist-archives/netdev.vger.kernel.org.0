Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4447F556E98
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 00:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239096AbiFVWke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 18:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbiFVWkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 18:40:33 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5082D40A35
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 15:40:32 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id t25so30202093lfg.7
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 15:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QlEprvw4aFBZ/0M7QBlJkcEMr5S8xkrz5se7OcSz/Gg=;
        b=tl75dzYm95mBHoxCv964tfgDzcT5UYODqA1Q3+jc1C5Zcq/CEKHZDfbXfA5qnl0xRy
         weALGqAMb3IfUi56llAyqoK99oH7N9slwJ0zm65I/PhP1oEa7Lw+4kiV+r540SR4Y6V9
         uYYOXmPPnB8cnBXFGJUmRcrGlF9K3w14h4uddUiGFqBEi4dZOO1yMkxZRwAFfqmQ3fmt
         7ebzgKjuM4ZpPgwPS1MvY/3VU4ZhRuZHVmHxoxHBDpRLK+TCH+550Hi/AW3wUXAz7lS0
         T4VxPf//ZX43XVz2XBAyGa8+aIwEF3fyV1Kwctrkw1H//D6ZUDyQnfTPGLFLJwk3OxPD
         3O2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QlEprvw4aFBZ/0M7QBlJkcEMr5S8xkrz5se7OcSz/Gg=;
        b=OOtOov3zf6ejeEVABUANcrzwIoxx+wjtI2zDf9CPOPQnnKY9drWt1MDw4aC5+SUJeX
         8fKgKC+gnr0sn+0JkuNuf8Klswk0zqC3mzmk/AQ4zAvNOYEDEoL3jYi24pTr0rMugfRx
         itind2b0i1AtkUSG+nOCRmECmiuBEcCcljfOdwipojR9BXWhHug7tm5NnLV47RVrSyJC
         3+fjxTlo0IzO/zvUuqkGZjdjPH7tcSEP0LdwGZjYjAvK3FBnwueEwpGFXFS9h2fRmv/a
         osF6ezYIjQo83yCf4qCiQEkSJjr3j2abJxeUHnh9RZYEGsKgyDQddLHXiZc2rJYN3HSy
         p70Q==
X-Gm-Message-State: AJIora8KqTOFNHgZ/PFZMLL7Jo8RKXT0HBmkGHPfjIsgrlYGF8okx55S
        J67kbg/pf6JM4wVRxcZ4IrmBus4qup8++t6d0eeBxg==
X-Google-Smtp-Source: AGRyM1vM6cI4IXaZElAe3+lCF4fcxIgXQNHZoMLn4oiC3MLjqJQgQYtGFUhJJVzvrdrvx3+gN6mm81KRBv5C92WLdF8=
X-Received: by 2002:a05:6512:b8d:b0:47f:74f0:729b with SMTP id
 b13-20020a0565120b8d00b0047f74f0729bmr3407237lfv.403.1655937630290; Wed, 22
 Jun 2022 15:40:30 -0700 (PDT)
MIME-Version: 1.0
References: <YrLtpixBqWDmZT/V@debian> <CAHk-=wiN1ujyVTgyt1GuZiyWAPfpLwwg-FY1V-J56saMyiA1Lg@mail.gmail.com>
 <YrMu5bdhkPzkxv/X@dev-arch.thelio-3990X> <CAHk-=wjTS9OJzggD8=tqtj0DoRCKhjjhpYWoB=bPQAv3QMa+eA@mail.gmail.com>
 <YrNQrPNF/XfriP99@debian> <CAHk-=wjje8UdsQ_mjGVF4Bc_TcjAWRgOps7E_Cytg4xTbXfyig@mail.gmail.com>
In-Reply-To: <CAHk-=wjje8UdsQ_mjGVF4Bc_TcjAWRgOps7E_Cytg4xTbXfyig@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 22 Jun 2022 15:40:18 -0700
Message-ID: <CAKwvOdmQKo4tZRLWxK2tTvd+OEtUmKJM7XiijLAF8JWMeUzFMA@mail.gmail.com>
Subject: Re: mainline build failure due to 281d0c962752 ("fortify: Add Clang support")
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ llvm list, moving net and net-folk to bcc. Follow along on lore if
still interested.

On Wed, Jun 22, 2022 at 10:49 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Jun 22, 2022 at 12:26 PM Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > Tried it after applying your patch. There was no build failure, but some warnings:
>
> So some of those objtool warnings are, I think, because clang does odd
> and crazy things for when it decides "this is not reachable" code.
>
> I don't much like it, and neither does objtool, but it is what it is.
> When clang decides "I'm calling a function that cannot return", it
> will have a "call" instruction and then it will just fall off the face
> of the earth after that.
>
> That includes falling through to the next function, or just to random
> other labels after the function, and then objtool as a result
> complains about a stack state mismatch (when the fallthrough is the
> same function, but now the stack pointer is different in different
> parts), or of the "falls through to next function".
>
> I think it's a clang misfeature in that if something goes wrong, you
> basically execute random code. I'd much rather see clang insert a real
> 'ud' instruction or 'int3' or whatever. But it doesn't.

So adding `-mllvm -trap-unreachable` will turn these
`__builtin_unreachable()`'s into trapping instructions.  I think we
should just do that/enable that in the kernel.  The following patch
eliminates ALL of the fallthrough warnings observed from objtool on
x86_64 defconfig builds.

```
diff --git a/scripts/Makefile.clang b/scripts/Makefile.clang
index 87285b76adb2..1fbf8a8f3751 100644
--- a/scripts/Makefile.clang
+++ b/scripts/Makefile.clang
@@ -36,6 +36,7 @@ endif
 # so they can be implemented or wrapped in cc-option.
 CLANG_FLAGS    += -Werror=unknown-warning-option
 CLANG_FLAGS    += -Werror=ignored-optimization-argument
+CLANG_FLAGS    += -mllvm -trap-unreachable
 KBUILD_CFLAGS  += $(CLANG_FLAGS)
 KBUILD_AFLAGS  += $(CLANG_FLAGS)
 export CLANG_FLAGS
```

There's more I need to do for LTO; `-mllvm` flags need to be passed to
the linker in that case.  Let me do a few more builds, collect
statistics on build size differences (guessing neglidgeable), then
will send out a more formal patch.

>
> I didn't check whether gcc avoids that "don't make assumptions about
> non-return functions" or whether it's just that objtool recognizes
> whatever pattern gcc uses.
>
> So *some* of the warnings are basically code generation disagreements,
> but aren't signs of actual problems per se.
>
> Others may be because objdump knows about gcc foibles in ways it
> doesn't know about some clang foibles. I think the "call to memcpy()
> leaves .noinstr.text section" might be of that type: clang seems to
> sometimes generate out-of-line memcpy calls for absolutely ridiculous
> things (I've seen a 16-byte memcpy done that way - just stupid when
> it's just two load/store pairs, and just the function call overhead is
> much more than that).

IIRC, that was from CONFIG_KASAN.

Looking at the disassembly (llvm-objdump's `--disassemble-symbols=`
flag is handy) of the following from an allmodconfig build:

vmlinux.o: warning: objtool: sync_regs+0x24: call to memcpy() leaves
.noinstr.text section

168B memcpy

vmlinux.o: warning: objtool: vc_switch_off_ist+0xbe: call to memcpy()
leaves .noinstr.text section

168B memcpy

vmlinux.o: warning: objtool: fixup_bad_iret+0x36: call to memset()
leaves .noinstr.text section

168B memset

vmlinux.o: warning: objtool: __sev_get_ghcb+0xa0: call to memcpy()
leaves .noinstr.text section

4096B memcpy

vmlinux.o: warning: objtool: __sev_put_ghcb+0x35: call to memcpy()
leaves .noinstr.text section

4096B memcpy

So it doesn't seem like it's the same issue of "dump memcpy of small
`n` that we'd seen previously).  I suspect that objtool's assumption
that the compiler can't turn assignments into libcalls is...compiler
specific.

Replying to earlier points in the thread now:


On Wed, Jun 22, 2022 at 9:21 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Jun 22, 2022 at 10:02 AM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > Right, we are working on a statically linked and optimized build of LLVM
> > that people can use similar to the GCC builds provided on kernel.org,
> > which should make the compile time problem not as bad as well as making
> > it easier for developers to get access to a recent version of clang with
> > all the fixes and improvements that we have made in upstream LLVM.
>
> So I'm on the road, and will try to see how well I can do that
> allmodconfig build on my poor laptop and see what else goes wrong for
> now.
>
> But I do have to say that it's just a lot better if the regular distro
> compiler build works out of the box. I did build my own clang binary
> for a while, just because I was an early adopter of the whole "ask
> goto with outputs" thing, but I've been *so* much happier now that I
> don't need to do that any more.
>
> So I would prefer not going backwards.

I agree.

> I wish the standard clang build just stopped doing the crazy shared
> library thing. The security arguments for it are just ridiculous, when
> any shared library update for any security reason would mean a full
> clang update _anyway_.

Regarding the "security" argument against the use of shared libraries;
I agree with you.  If the compiler will just crash when given five
open parenthesis as inputs, it never was designed for untrusted input
in the first place.

That said, if I had to host executables and libraries for download,
perhaps it would be a smaller bill to serve a bunch of libraries over
fully statically linked (and thus larger) executables.

I think it's too late and a non-starter to suggest removing the
ability to build libllvm.so or libclang.so to the LLVM community at
this point though.

>
> I realize it's partly distro rules too, but the distros only do that
> "we always build shared libraries" when the project itself makes that
> an option. And it's a really stupid option for the regular C compiler
> case.

Right, in that case our hands are somewhat tied. They're not our
distributions.  Even if we do our own builds/distributions of clang,
you can lead a horse to water...

That said, I think we can can help distros better configure their
builds.  For instance, a sweet spot might be to statically link clang,
but dynamically link all of the GNU-binutils-like substitutes.  Those
are seldom invoked and not the bottleneck in any profile.  LLVM's
cmake doesn't have an option to do that easily though; we should
provide one then recommend distros use it.  Make it easy to do the
right thing.

>
> Side note: I think gcc takes almost exactly the opposite approach, and
> does much better as a result. It doesn't do a shared libary, but what
> it *does* do is make 'gcc' itself a reasonably small binary that just
> does the command line front-end parsing.
>
> The advantage of the gcc model is that it works *really* well for the
> "test compiler options" kind of stage, where you only run that much
> simpler 'gcc' wrapper binary.
>
> We don't actually take full advantage of that, because we do end up
> doing a real "build" of an empty file, so "cc1" does actually get
> executed, but even then it's done fairly efficiently with 'vfork()'.
> That "cc-option" part of the kernel build is actually noticeable
> during configuration etc, and clang is *much* slower because of how it
> is built.
>
> See
>
>     time clang -Werror -c -x c /dev/null
>
> and compare it with gcc. And if you want to see a really *big*
> difference, pick a command line option that causes an error because it
> doesn't exist..

Looking at a profile, there's a lot of stupid stuff we're doing.  We
can probably get faster "at doing nothing." See
https://gist.github.com/nickdesaulniers/81a87ffa784c13d0bf60f60b1d54651b
for the profile and my commentary/initial thoughts.

>
> I really wish clang wasn't so much noticeably slower. It's limiting
> what I do with it, and I've had other developers say the same.

We can do better.  I'll keep pushing on this up my chain of command.
That statement stands in stark contrast to the below:

On Wed, Jun 22, 2022 at 6:47 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I build the kernel I actually _use_ with clang, and make sure it's
> clean in sane configurations, but my full allmodconfig build I do with
> gcc.

A fantastic and motivational endorsement for the hard work we put in,
which is why it would be a travesty if build times and allmodconfig
hygiene caused us to lose your support.

>
> Partly because of that "the clang build hasn't quite gotten there yet"
> and partly because last I tried it was even slower to build (not a big
> issue for my default config, but does matter for the allmodconfig
> build, even on my beefy home machine)
>
> I would love for people to start doing allmodconfig builds with clang
> too, but it would require some initial work to fix it... Hint, hint.

As Nathan notes, we've been working on it. Long tail that's constantly
regressing, but WIP nonetheless.

>
> And in the case of this warning attribute case, the clang error messages are
>
>  (a) verbose
>
>  (b) useless
>
> because they point to where the warning attribute is (I know where it
> is), but don't point to where it's actually triggering (ie where it
> was actually inlined and called from).
>
> The gcc equivalent of that warning actually says exactly where the
> problem is. The clang one is useless, which is probably part of why
> people aren't fixing them, because even if they would want to, they
> just give up.
>
> Nick, Nathan, any chance of getting better error messages out of
> clang? In some cases, they are very good, so it's not like clang does
> bad error messages by default. But in this case, the error message
> really is *entirely* useless.

Yeah, it's definitely not helpful in its current form.  I'll have to
think a bit more about how we can retain and display inlining
decisions, which is what's necessary here to make the diagnostic
actionable.

Building with `KCFLAGS=-Rpass=inline` does provide some hints, but
also a lot of unhelpful noise:

```
$ make LLVM=1 -j72 drivers/net/ethernet/huawei/hinic/hinic_devlink.o
KCFLAGS=-Rpass=inline
...
drivers/net/ethernet/huawei/hinic/hinic_devlink.c:46:3: remark:
'_Z18fortify_memcpy_chkmmmmmPKc' inlined into 'check_image_valid':
always inline attribute at callsite check_image_valid:23:3;
[-Rpass=inline]
                memcpy(&host_image->image_section_info[i],
                ^
...
```
AFAIK, the current architecture of LLVM doesn't retain inlining
decisions made, so clang can point to the definition of a function
that shouldn't have been called (one annotated w/
__attribute__((error(""))) or __attribute__((warning("")))) but it
can't tell you which call site specifically was problematic.  There's
similarly unhelpful diagnostics sometimes with inline asm that feels
vaguely reminiscent I document here:
https://github.com/ClangBuiltLinux/linux/issues/1571#issuecomment-1135199630.

As to _why_ clang isn't getting this object size correct, I wasn't
able to find out today, but will keep digging. Stay tuned.
https://github.com/ClangBuiltLinux/linux/issues/1592
-- 
Thanks,
~Nick Desaulniers
