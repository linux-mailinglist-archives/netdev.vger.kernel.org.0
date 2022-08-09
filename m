Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C5858D16D
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 02:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238490AbiHIAhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 20:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiHIAhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 20:37:48 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0960C12AB3;
        Mon,  8 Aug 2022 17:37:47 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id kb8so19600016ejc.4;
        Mon, 08 Aug 2022 17:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Yd7WSvA1YADITl6HyqX9HkN3pZEKcYoTmTNbGT8mUIw=;
        b=pESTpVCkNcDFn9THb8jv3cMk16A+kSBjkWwwZ6Df4YD9jy7YA2m2OgzNeMpFCBHC6s
         2U/nMxt9+qymQq7uX7+sQ4YmDtGROKfyDTZD1POwujDXOZgxkscAIhEblTPNGnWReiDW
         B6SpBzlGNQKdyVc6ME6FvaUJvV11qjOxvXSBipplrYtn3Uxyv04/yWhOvif7cZeOM5uN
         pjiHdQSw2dd+X6K3HxmG49X3lunIkzQ4bOBz0+e9d2HCgqGrDDrMZLBW8yXW+zUk2pWe
         Zz+Y8utlZtFiTW7PpEdI2u0I6SLzgwYsR+E4SMJVXCIyD511QZYxokSyhtf6FJjiz9R+
         K5Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Yd7WSvA1YADITl6HyqX9HkN3pZEKcYoTmTNbGT8mUIw=;
        b=evZNz/n3QY/Kgg46jSu3mVEqhIDnz3bGEUC3x34a+hDCqpVIIxON2xCgKNQk3YqnC1
         LoeB/3nMH9iEpwCKZLVBPaodgYdnqKl6wmZ/jcMTW56b2QjGeQQ3/1XnXE9+CTs7Uoii
         oMDYhuCxvtiK1dsk6F56UGfi0O/ahDng54gjg0i7ufNiCtcqfXrTK1BrJ5DEIEPRUJTz
         voD2dEd2G+VX7j0lOXty86qx3owS7+5SEH2DAKoH7ND1yL+V/uSboxzD7K+Fu86b8f89
         Y5mPypibpY6Y/eMwPcxaa8KKiUedfTUgoTgknU4nnsKLLtnGbjwB9EGyk0xJPGx2pS0h
         qqqA==
X-Gm-Message-State: ACgBeo3pkwuH+M7RNojtVR9vu3UFOqjcRneN0pg2jOieW5gtN3Qn3Q2j
        nbYUUd8Nzxe/g0cFo4psuwMlsyh7P3b6URa12/o=
X-Google-Smtp-Source: AA6agR4yH+SAMof63qmLkLzR+cSea8kpyU/FFaMFFHznkaAvg0V32KIjXKJrmovk1lWVHjePdDd7t4B9OId7J/Unyq0=
X-Received: by 2002:a17:907:2d12:b0:731:6a4e:ceb0 with SMTP id
 gs18-20020a1709072d1200b007316a4eceb0mr3979574ejc.115.1660005465499; Mon, 08
 Aug 2022 17:37:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220808094623.387348-1-asavkov@redhat.com> <20220808094623.387348-2-asavkov@redhat.com>
 <CAP01T76dELOx8p_iky_Py_VcqDbQtaL-4d=zrFiCbFhMdVEmNA@mail.gmail.com>
 <YvEEXsdo/fCnoEFY@samus.usersys.redhat.com> <CAP01T74kqdAeZbmnVA2uDRiB-8tjuWtdw-q_2V5fL6wQ==rTEA@mail.gmail.com>
In-Reply-To: <CAP01T74kqdAeZbmnVA2uDRiB-8tjuWtdw-q_2V5fL6wQ==rTEA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Aug 2022 17:37:34 -0700
Message-ID: <CAEf4BzaGmBZ7aXuX2ty1eB2jddurHyranxPs2cfKkkPB_hoX9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] bpf: add destructive kfunc flag
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 8, 2022 at 6:33 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> On Mon, 8 Aug 2022 at 14:41, Artem Savkov <asavkov@redhat.com> wrote:
> >
> > On Mon, Aug 08, 2022 at 02:14:33PM +0200, Kumar Kartikeya Dwivedi wrote:
> > > On Mon, 8 Aug 2022 at 11:48, Artem Savkov <asavkov@redhat.com> wrote:
> > > >
> > > > Add KF_DESTRUCTIVE flag for destructive functions. Functions with this
> > > > flag set will require CAP_SYS_BOOT capabilities.
> > > >
> > > > Signed-off-by: Artem Savkov <asavkov@redhat.com>
> > > > ---
> > > >  include/linux/btf.h   | 1 +
> > > >  kernel/bpf/verifier.c | 5 +++++
> > > >  2 files changed, 6 insertions(+)
> > > >
> > > > diff --git a/include/linux/btf.h b/include/linux/btf.h
> > > > index cdb376d53238..51a0961c84e3 100644
> > > > --- a/include/linux/btf.h
> > > > +++ b/include/linux/btf.h
> > > > @@ -49,6 +49,7 @@
> > > >   * for this case.
> > > >   */
> > > >  #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
> > > > +#define KF_DESTRUCTIVE  (1 << 5) /* kfunc performs destructive actions */
> > > >
> > >
> > > Please also document this flag in Documentation/bpf/kfuncs.rst.
> >
> > Ok, will do.
> >
> > > And maybe instead of KF_DESTRUCTIVE, it might be more apt to call this
> > > KF_CAP_SYS_BOOT. While it is true you had a destructive flag for
> > > programs being loaded earlier, so there was a mapping between the two
> > > UAPI and kfunc flags, what it has boiled down to is that this flag
> > > just requires CAP_SYS_BOOT (in addition to other capabilities) during
> > > load. So that name might express the intent a bit better. We might
> > > soon have similar flags encoding requirements of other capabilities on
> > > load.
> > >
> > > The flag rename is just a suggestion, up to you.
> >
> > This makes sense right now, but if going forward we'll add stricter
> > signing requirements or other prerequisites we'll either have to rename
> > the flag back, or add those as separate flags. I guess the decision here
>
> IMO we should do that when the time comes, for now it should reflect
> the current state.

But names should be also semantically meaningful, so KF_DESTRUCTIVE
explains that kfunc can do destructive operations, which is better
than just declaring that kfunc needs CAP_SYS_BOOT, as the latter is
current implementation detail which has no bearing on kfunc definition
itself.

Unless we anticipate we'll have another "destructive" kfunc not using
KF_DESTRUCTIVE and instead we'll add some other
KF_CAP_SYS_WHATEVERELSE?

> To me this helper requiring cap_sys_boot is just like how some
> existing stable helpers are gated behind bpf_capable or
> perfmon_capable.
> When it requires that the program calling it be signed, we can revisit this.
>
> > depends on whether some of non-destructive bpf programs might ever require
> > CAP_SYS_BOOT capabilities or not.
>
> These are just internal kernel flags, so refactoring/renaming is not a
> big deal when it is needed. E.g. we've changed just how kfuncs are
> registered twice since the support was added not long ago :).
>
> >
> > --
> >  Artem
> >
