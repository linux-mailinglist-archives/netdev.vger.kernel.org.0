Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 646AB1BB14
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbfEMQiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:38:07 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38892 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730291AbfEMQiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:38:07 -0400
Received: by mail-qt1-f196.google.com with SMTP id d13so8367335qth.5;
        Mon, 13 May 2019 09:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=56vRLTzvZTIBE0DHrKbgg4l2fKaqg8x2Im8jrdqEqk4=;
        b=GubGc/ttaGQLTT/3BnxCGkl02dXlozYuqPI+xf8qTfmxU3bimt85b9dmoaFRVkoplm
         hrE2UPKULNfGhVi3QIpZYRZVzL54soU2CcbuoJevy8k8Aq1F+jsWc3X+C7tcFL3NG6nj
         kCNEyB3+8+1jtAIJfzF/15m/mNSjhRLE8eKeISR6bVfe3Xp3eyiQtSAOPTDByM6Nnqq1
         ZEKgAotnOfP6hgvX0znTNEgBs+9s65pDlxdpoVuyG6E6MSAlf7Q78B9wbnVOj6VlEMDo
         jFt8QPnZfds0JAmZBFfOm3YF2RFIZw3nLMpvZ60h8gJDMRSW7KUt19nJAD8b4TvchuTS
         A4Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=56vRLTzvZTIBE0DHrKbgg4l2fKaqg8x2Im8jrdqEqk4=;
        b=i4KI1KXK/jj63mHj8VDhs0Ijstgy4UZsUjYsFJbSevUulYc119tZVVTZ5kGp+UIRBW
         9TNvKYLmu94YG1flf4E2Ip3fgg7vv39bpmHWCW8/1mH68IgMcw7RpvDbw7WWDhWtbJ0V
         /eywGD2lDLEDBFDm+hY5Hg7SfQiYz2hp4o2/71j6RhQxp/iBDvBHzv5mAxVopNnnjnoL
         f6HuVJ4kajIMwp17cTL8+0ORF9bVgLZvSZcoyExErb1muNYmgVEXsONsvkCIzbhn4i4p
         ACvC8Y7xHzDisX67w2YXDg+odSkwVlnD+9VFqb+Jn+MtD+KSZDJabXJ88JmmYK6zhGfH
         jnrg==
X-Gm-Message-State: APjAAAXV3aq5e5zphJZjdGQYDHC2LH1TTGm9mAxeyoXToeuajYBdxOHK
        VSr4GasjNGpJoK5huK0GjgXYUy3SRVohahuB87k=
X-Google-Smtp-Source: APXvYqwqG5u9XRHy7vV5DfITF/QFU1BbGpFby05EJy6gVqJQQZYGajXauAaewQHulgj4cAclzc5HYAMPuqsAptr0ksM=
X-Received: by 2002:a0c:946c:: with SMTP id i41mr23498931qvi.11.1557765485964;
 Mon, 13 May 2019 09:38:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190510211315.2086535-1-andriin@fb.com> <20190510213600.GI1247@mini-arch>
 <CAEf4BzZD1=S0hcg7wj0_LqggcVn_6SDWzy3ZqS=rGbf0Q_s5+Q@mail.gmail.com>
 <20190510220023.GJ1247@mini-arch> <CAEf4BzZRA=3w9EnG+xHM74YmW9SiQOwgQfgRzVg838v4qUyb6g@mail.gmail.com>
 <20190512010937.GK1247@mini-arch> <c3916827-79de-4ddf-9861-c7fe0b4b2ae8@iogearbox.net>
In-Reply-To: <c3916827-79de-4ddf-9861-c7fe0b4b2ae8@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 May 2019 09:37:54 -0700
Message-ID: <CAEf4BzYehSRm+cnOGAw0Mg6Asj2LGhXUopnQJviV_wQZL8spqQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf] libbpf: detect supported kernel BTF features and
 sanitize BTF
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 12, 2019 at 4:52 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 05/12/2019 03:09 AM, Stanislav Fomichev wrote:
> > On 05/11, Andrii Nakryiko wrote:
> >> On Fri, May 10, 2019 at 3:00 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >>> On 05/10, Andrii Nakryiko wrote:
> >>>> On Fri, May 10, 2019 at 2:36 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >>>>> On 05/10, Andrii Nakryiko wrote:
> >>>>>> Depending on used versions of libbpf, Clang, and kernel, it's possible to
> >>>>>> have valid BPF object files with valid BTF information, that still won't
> >>>>>> load successfully due to Clang emitting newer BTF features (e.g.,
> >>>>>> BTF_KIND_FUNC, .BTF.ext's line_info/func_info, BTF_KIND_DATASEC, etc), that
> >>>>>> are not yet supported by older kernel.
> >>>>>>
> >>>>>> This patch adds detection of BTF features and sanitizes BPF object's BTF
> >>>>>> by substituting various supported BTF kinds, which have compatible layout:
> >>>>>>   - BTF_KIND_FUNC -> BTF_KIND_TYPEDEF
> >>>>>>   - BTF_KIND_FUNC_PROTO -> BTF_KIND_ENUM
> >>>>>>   - BTF_KIND_VAR -> BTF_KIND_INT
> >>>>>>   - BTF_KIND_DATASEC -> BTF_KIND_STRUCT
> >>>>>>
> >>>>>> Replacement is done in such a way as to preserve as much information as
> >>>>>> possible (names, sizes, etc) where possible without violating kernel's
> >>>>>> validation rules.
> >>>>>>
> >>>>>> v2->v3:
> >>>>>>   - remove duplicate #defines from libbpf_util.h
> >>>>>>
> >>>>>> v1->v2:
> >>>>>>   - add internal libbpf_internal.h w/ common stuff
> >>>>> How is libbpf_internal.h different from libbpf_util.h? libbpf_util.h
> >>>>> looks pretty "internal" to me. Maybe use that one instead?
> >>>>
> >>>> It's not anymore. It's included from xsk.h, which is not internal, so
> >>>> libbpf_util.h was recently exposed as public as well.
> >>> But I still don't see any LIBBPF_API exported functions in libbpf_util.h.
> >>> It looks like the usage is still mostly (only?) internal. The barrier
> >>> stuff is for internal usage as well.
> >>
> >> libbpf_util.h is installed along xsk.h, bpf.h, etc, so it is becoming
> >> part of public API, even if it's not exposing any LIBBPF_API calls.
> >> Those barrier calls are intended for internal usage, but we can't
> >> enforce that. With libbpf_internal.h we can (as we don't install it).
> >> We should probably move libbpf_print and related #defines out of
> >> libbpf_util.h, which I can do in separate patch, if we agree on that.
> > We could move libbpf_print into libbpf_internal.h, but the barrier defines
> > are used in xsk.h. If we do that, libbpf_util.h should probably
> > be renamed to libbpf_barrier.h :-/
>
> Agree on the libbpf_print move into libbpf_internal.h (Andrii or Stanislav, could
> you send a patch? Thx). But calling the remainder libbpf_barrier.h is imho too

I can do that, it's still technically a fix, as libbpf_print shouldn't
have been exposed in the first place. I'll send a patch against bpf
tree.

> specific and thus a bit overkill. Given we can control what is being exposed and
> installed as header, we should only place helpers in there that are used in the
> other installed helpers.
>
> >>> Also, why do think your new probe helper should be internal? I guess
> >>> that at some point bpftool might use it to probe and dump BTF features
> >>> as well.
> >>
> >> I don't think it's a proper level of abstraction to be exposed as
> >> public API. In it's current form, that thing takes raw arrays of
> >> bytes, constructs BTF out of it and tries to load it without logging
> >> any errors. There seems to be little of use for external application
> >> in it and I don't think those applications should construct BTF out of
> >> raw integers (see below).
> > SGTM, we can export it if/when needed.
> >
> >>>
> >>> I also see us copying around all the BTF_XXX macros, I brought this up for
> >>> some selftest patches and now we have a single place for BTX_XXX macros
> >>> in selftests (tools/testing/selftests/test_bpf.h).
> >>> Maybe they should belong to libbpf instead?
> >>
> >> I think, ideally, we should get rid of those BTF_XXX macros in favor
> >> of some kind of BTF writer/builder, e.g.:
> >>
> >> struct btf_builder *b = btf_bldr__new();
> >> struct btf *btf;
> >> char buf[256];
> >> int i=0;
> >>
> >> btf_bldr__add_enum(b, "some_enum");
> >> for (i = 0; i < 5; i++) {
> >>         sprintf(buf, "enum_val_%d", i);
> >>         btf_bldr__add_enum_value(b, buf, i);
> >> }
> >> /* ... and so on ... */
> >>
> >> btf = btf_bldr__create_btf();
> >>
> >> So I don't mind moving those macros to libbpf_internal.h for now, I
> >> think in the longer-term they should be gone, though. But I'd like to
> >> keep the scope of this patch smaller and not do too much refactoring
> >> of tests.
>
> Such BTF writer would be nice actually.

I'll try to add that as time allows.

>
> > Do you think that libbpf probes can/will be converted to this API?
> > It looks like test_btf.c will always use defines, so if we use them in libbpf

Yeah, I don't see why not. It will change the way tests are written,
though, as now you won't be able to define BTF statically, you'll need
to write corresponding BTF-generating callbacks, so it might not make
sense to migrate all the tests immediately.

> > as well (internally), it probably makes sense just to move test_btf.h
> > into libbpf and rename it to something like raw_btf.h (and keep it
> > internal, don't install it).
>
> Kind of agree with Stanislav that avoiding duplication here would be
> nice. Maybe they could be a libbpf internal header, but selftests would
> include them directly as it's the only other place where the raw form is
> currently used ... and given both are in tree.

Yeah, sure, we can consolidate macros in libbpf_internal.h. It feels
like calling those macros as BTF_RAW_XXX would be explicit about what
they are and distinguishing from other macros very clearly, I'll work
on a patch against bpf-next for that.

>
> Anyway, as all this is kind of separate follow-up to the current patch,
> I've applied the fix to bpf to unblock users, thanks.

Thanks!
