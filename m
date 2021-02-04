Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E7630ED3E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 08:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhBDHWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 02:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbhBDHWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 02:22:53 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EF8C0613D6;
        Wed,  3 Feb 2021 23:22:13 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id p15so1670525ilq.8;
        Wed, 03 Feb 2021 23:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=J0Hhokg7bb4w32rTwE6DeGStp3ax7fi3VK+om+D8gps=;
        b=vMbwPTWjoKKn4UtoCX2tY5RiZb8B7vThyDlUBBZW7TE26y4IOifKk7KPkgxvbmOHO0
         6KVYtzuqS5f9z6GpXiY8YOl4ZaIAegheScHkXqduRs1pZGUOuzPljUxOlDkx02Uf44WK
         HB6eqZPFkS5u7kveVWMZQWdgXOnOdxLw835vb/fgHoP4AJKZ8adYhcHOoqa5YCPvChIM
         eXYUUNnNs4QxbES6nKSm3fCRYDzT3CptnNPL7wzUrIVi+q2jabNksuyTiIo0AHz+O55i
         9/v/OIqQJ6H1fTlBqtgRm8VrEzAHrniGZZxOrISnXsMbjNgS4JWc1upqYaxdYYtRGmzL
         hJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=J0Hhokg7bb4w32rTwE6DeGStp3ax7fi3VK+om+D8gps=;
        b=AXUFLnMxrKlt/rKe65v6rMVdEMnTYQcpIsNziuFxgaLWFlB9JyYpMbBA8iyJfs50le
         1Z+eEK8W7pDTOdcyXWqqW+tp20ss/iP7xqwsGWojHJ4FHLsbeT7r2NSMc6G0Vfj7fZFd
         38h0pSulshTpAcdOsOLPoCTcvv8EuowcmjaGvaymMflseVzCi4Mpb53kz6be5wo6FGOm
         hSnLCwCf8WplFD6gBNU6x9Ve1HtLXB6V4nCYZ6usfqExfpXe/ecvhuFghPWBw9qCxU/u
         DWhOb5MteAhIkhuUYL2OhMO9FByaOzYPqJOuASXP525enJsoqkWYxTJ2oY+Dbae0C1+W
         1kqw==
X-Gm-Message-State: AOAM533OIoXMA0gN26wR351LE9snfyS+XTVeOMEO8t6AR0y05HrdxkP/
        NP87JBbS9Jj6SGQ1B+jPUwAHdtJFbT4Y3q0q+nU=
X-Google-Smtp-Source: ABdhPJy/vmxig/W9Nw0gIHMoujn1aKGJuGQ4ghVxjXftdO9e/CK0p+9mzgPsiVHUi0Ph+DK34s+6mm6T4lDcs7oFmng=
X-Received: by 2002:a92:444e:: with SMTP id a14mr5831856ilm.215.1612423333162;
 Wed, 03 Feb 2021 23:22:13 -0800 (PST)
MIME-Version: 1.0
References: <20210111180609.713998-1-natechancellor@gmail.com>
 <CAK7LNAQ=38BUi-EG5v2UiuAF-BOsVe5BTd-=jVYHHHPD7ikS5A@mail.gmail.com>
 <20210111193400.GA1343746@ubuntu-m3-large-x86> <CAK7LNASZuWp=aPOCKo6QkdHwM5KG6MUv8305v3x-2yR7cKEX-w@mail.gmail.com>
 <20210111200010.GA3635011@ubuntu-m3-large-x86> <CAEf4BzaL18a2+j3EYaD7jcnbJzqwG2MuBxXR2iRZ3KV9Jwrj6w@mail.gmail.com>
 <CAEf4Bzbv6nrJNxbZAvFx4Djvf1zbWnrV_i90vPGHtV-W7Tz=bQ@mail.gmail.com> <20210113230739.GA22747@Ryzen-9-3900X.localdomain>
In-Reply-To: <20210113230739.GA22747@Ryzen-9-3900X.localdomain>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 4 Feb 2021 08:22:01 +0100
Message-ID: <CA+icZUVfznOpAQK=6GWoF6XmzHyXjdUgNG5HeoQw3Dwb4wW9uA@mail.gmail.com>
Subject: Re: [PATCH] bpf: Hoise pahole version checks into Kconfig
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 12:07 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Wed, Jan 13, 2021 at 02:38:27PM -0800, Andrii Nakryiko wrote:
> > Hm.. Just saw Linus proposing using $(error-if) in Kconfig for an
> > unrelated issue ([0]). If we can make this work, then it would catch
> > such issue early on, yet won't have any downsides of hiding
> > CONFIG_DEBUG_INFO_BTF if pahole is too old. WDYT?
> >
> >   [0] https://lore.kernel.org/lkml/CAHk-=wh-+TMHPTFo1qs-MYyK7tZh-OQovA=pP3=e06aCVp6_kA@mail.gmail.com/
>
> Yes, I think that would be exactly what we want because DEBUG_INFO_BTF
> could cause the build to error if PAHOLE_VERSION is not >= 116. I will
> try to keep an eye on that thread to see how it goes then respin this
> based on anything that comes from it.
>

For BPF/pahole testing (see [1]) with CONFIG_DEBUG_INFO_DWARF5=y I did:

$ git diff
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b0840d192e95..f15b37143165 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -272,7 +272,7 @@ config DEBUG_INFO_DWARF5
       bool "Generate DWARF Version 5 debuginfo"
       depends on GCC_VERSION >= 50000 || CC_IS_CLANG
       depends on CC_IS_GCC ||
$(success,$(srctree)/scripts/test_dwarf5_support.sh $(CC)
$(CLANG_FLAGS))
-       depends on !DEBUG_INFO_BTF
+       depends on !DEBUG_INFO_BTF || (DEBUG_INFO_BTF && PAHOLE_VERSION >= 120)
       help
         Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc
         5.0+ accepts the -gdwarf-5 flag but only had partial support for some

Thanks again for that patch.

- Sedat -

[1] https://git.kernel.org/pub/scm/devel/pahole/pahole.git/log/?h=tmp.1.20
