Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B3F40316A
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 01:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240845AbhIGXPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 19:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234094AbhIGXPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 19:15:49 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09CDC061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 16:14:42 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id g14so291594ljk.5
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 16:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qu1CuxnsrjZOSqfDn82IwL4wxf06fWvlZCuvRJG8DNA=;
        b=hzQgvbQopbro6AglKsBmSTDKv6F+qPyX8TeMb058Rd87Lc3krIRE6cpNxBGVVXV5hv
         ow698KDv/VdCJ1d5QUePaIv46jMP9hBRJ4ZESDYDaJSOD+o9ncJwozDx3JIOUMeAqk2X
         js/TMcfWBMGX83+VrnL66WmNMwh8cgbazm+R8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qu1CuxnsrjZOSqfDn82IwL4wxf06fWvlZCuvRJG8DNA=;
        b=RSAUyMxCMklYakRi0OxJpcv8zZllI2yfyY4qhU3UgRME6wvMy2UXCczfviWgMrEcGr
         AJHslKk/UIKjAczbrgCNdnBZbN/qt6ucsGcc3w3UJyHoA+lASFBTsZlmLfYduu42XbVU
         kX5QnBl+GTIC5EDOXOj5gp68xYwtCLCU23uz7AulyJuP36iAUwJ4HmrYBGX/AhcdByRy
         jrzbbDgKTa+lnpuE+vlK/gWv2iKNIdyKr9TsZ00i2id6TsFTvGSX8NGDVa5WSojyVw65
         4U1q5wTmSY978i4ulHvskhB79OQynsgF9hp4F7YbkrDh5WgdxaHwDEZ6ae0Wl0Yqvw8J
         ubwA==
X-Gm-Message-State: AOAM531QP24dJulS5TnoU2A6iQ6sZ/EJ7tykB6x76qGNXGiv+hUOM4/U
        izEdWceHi21xD8KLdjZY14WVap9LRpBe0BtjIdk=
X-Google-Smtp-Source: ABdhPJwQr2hr+8wSs6ZbPOnnLPqva6ncG+Qluv1misXP8SmwDlAEjC0OqAVfIl7uAmWATxHPvR/AxA==
X-Received: by 2002:a2e:586:: with SMTP id 128mr473321ljf.310.1631056481191;
        Tue, 07 Sep 2021 16:14:41 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id q5sm28966lfg.36.2021.09.07.16.14.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 16:14:41 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id i28so282661ljm.7
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 16:14:40 -0700 (PDT)
X-Received: by 2002:a2e:96c7:: with SMTP id d7mr471237ljj.191.1631056480289;
 Tue, 07 Sep 2021 16:14:40 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
In-Reply-To: <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 Sep 2021 16:14:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
Message-ID: <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, Wei Liu <wei.liu@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Added maintainers for various bits and pieces, since I spent the
time trying to look at why those bits and pieces wasted stack-space
and caused problems ]

On Tue, Sep 7, 2021 at 3:16 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> None of these seem to be new.

That said, all but one of them seem to be (a) very much worth fixing
and (b) easy to fix.

The do_tcp_getsockopt() one in tpc.c is a classic case of "lots of
different case statements, many of them with their own struct
allocations on stack, and all of them disjoint".

So the fix for that would be the traditional one of just making helper
functions for the cases that aren't entirely trivial. We've done that
before, and it not only fixes stack usage problems, it results in code
that is easier to read, and generally actually performs better too
(exactly because it avoids sparse stacks and extra D$ use)

The pe_test_uints() one is the same horrendous nasty Kunit pattern
that I fixed in commit 4b93c544e90e ("thunderbolt: test: split up test
cases in tb_test_credit_alloc_all") that had an even worse case.

The KUNIT macros create all these individually reasonably small
initialized structures on stack, and when you have more than a small
handful of them the KUNIT infrastructure just makes the stack space
explode. Sometimes the compiler will be able to re-use the stack
slots, but it seems to be an iffy proposition to depend on it - it
seems to be a combination of luck and various config options.

I detest code that exists for debugging or for testing, and that
violates fundamental rules and causes more problems in the process.

The mac802.11 one seems to be due to 'struct ieee802_11_elems' being
big, and allocated on the stack. I think it's probably made worse
there with inlining, ie

 - ieee80211_sta_rx_queued_mgmt() has one copy

 - ieee80211_rx_mgmt_beacon() is possibly inlined, and has its own copy

but even if it isn't due to that kind of duplication due to inlining,
that code is dangerous. Exactly because it has two nested stack frames
with that big structure, and they are active at the same time in the
callchain whether inlined or not.

And it's *pointlessly* dangerous, because the 'struct ieee802_11_elems
elems' in ieee80211_sta_rx_queued_mgmt() is only used for the
IEEE80211_STYPE_ACTION case, so it is entirely disjoint from the
IEEE80211_STYPE_BEACON case, and those stack allocations simply should
not nest like that in the first place.

Making the IEEE80211_STYPE_ACTION case be its own function - like the
other cases - and moving the struct there should fix it. Possibly a
"noinline" or two necessary to make sure that the compiler doesn't
then undo the "these two cases are disjoint" thing.

The qede_config_rx_mode() has a fairly big 'struct qed_filter_params'
structure on stack (it's mainly just a union of two other structures).
That one is a bit silly, because the very same function *alsu* does a
temporary allocation for the 'uc_macs[]' array, and I think it could
have literally made that allocation just do both the params and the
uc_macs[] array together.

But that "a bit silly" is actually *doubly* silly, because that big
structure allocated for the stack that is actually a union, uses the
QED_FILTER_TYPE_RX_MODE type of the union. Which in turn is literally
*one*single*enum*field*.

So the qede_config_rx_mode() case uses that chunk of kernel stack for
a big union for no good reason.  It really only wants two words, but
the way the code is written, it uses a lot, because the union also has
a 'struct qed_filter_mcast_params' member that has an array of
[64][ETH_ALEN] bytes in it.

So that's about 400 bytes of stack space entirely wasted if I read the
code correctly.

The xhci_reserve_bandwidth() one is because it has an array of 31
'struct xhci_bw_info' on the stack. It's not a huge structure (six
32-bit words), but when you have 31 of those in an array, it's about
750 bytes right there. It should likely just be dynamically allocated
- it doesn't seem to be some super-important critical thing where an
allocation cannot be done.

The do_sys_poll() thing is a bit sad. The code has been tweaked to
basically use 1kB of stack space in one configuration. It overflows it
in a lot of other configs. Using stack space for those kinds of
top-level functions that are guaranteed to have an empty stack is
pretty much the best possible situation, but it's one where we don't
really have a good way to try to have some kind of dynamic feedback
from the compiler for how much other stack space it  is using.

So that do_sys_poll() case is the only one I see where the stack usage
is actually fine and explicitly expected. We *aim* for 1kB of stack,
and then in some - probably quite a few - situations we go over.

There are many more of these cases. I've seen Hyper-V allocate 'struct
cpumask' on the stack, which is once again an absolute no-no that
people have apparently just ignored the warning for. When you have
NR_CPUS being the maximum of 8k, those bits add up, and a single
cpumask is 1kB in size. Which is why you should never do that on
stack, and instead use '

       cpumask_var_t mask;
       alloc_cpumask_var(&mask,..)

which will do a much more reasonable job. But the reason I call out
hyperv is that as far as I know, hyperv itself doesn't actually
support 8192 CPU's. So all that apic noise with 'struct cpumask' that
uses 1kB of data when NR_CPUS is set to 8192 is just wasted. Maybe I'm
wrong. Adding hyperv people to the cc too.

A lot of the stack frame size warnings are hidden by the fact that our
default value for warning about stack usage is 2kB for 64-bit builds.

Probably exactly because people did things like that cpumask thing,
and have these arrays of structures that are often even bigger in the
64-bit world.

                Linus
