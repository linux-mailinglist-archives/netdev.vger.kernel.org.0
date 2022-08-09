Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADEA58D179
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 02:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244751AbiHIAt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 20:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244457AbiHIAt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 20:49:27 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A433C25F7;
        Mon,  8 Aug 2022 17:49:25 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id g18so5794265ilk.4;
        Mon, 08 Aug 2022 17:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=RxAt0vmII6A8aZUqkoL3eMGfHTRmNL+sO4A/bXssgaI=;
        b=f7izXbNbbMPcRpY/Rm0j5riq5OjXFnpyFZNSF9U/jaN1nyuuY3FySKBoivXnZyvtTS
         usTnNcvFi5hW5sg70MzT8CWelhQS451hgUiOh+olYak4sKmdqMLI0YYcWfKNKf23ZoB/
         UGZHqTuzpT35xm50sSai1PPOmAEGw8oA+Yw+kCYlrf+edcqFIAPwI81W18TEUwC+85VY
         drgDm5tvswMULunlbrIi/cFS3sJKyY/CY30SYoTFSBopTj23LYZrBD0rss6gwa/URJ9e
         NQIPMcXYT+beYYK1MXcKjWAWQjA1r7UjxQZQigCGuqoTGe1F2oWXgV9icsQfFBhrw/kE
         ReUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=RxAt0vmII6A8aZUqkoL3eMGfHTRmNL+sO4A/bXssgaI=;
        b=ZaJBcbt5U9PtQnorBu7mD1AIt8ZScqff9mNfqMIiqrzBR0k83YsdNhTU97wfZMXEFK
         UN9QDHfk64EDHfXO9ef0WudWWEWER1zR9y0Ss6BKyzv1S2YZ/w1Zmx9UCmHnW7d9R8Te
         r8pqTASyOORMZKiN3FMRTH/urEN48gXMeHpdRkbasob6rCk8J0rKbPtYGfOq0Au37tFg
         PEn5MIk8u56JpoGoBM8AIzeDLED6zecQKUqszrAtplUES2owxJOo0Tx0EH6Pv5UnjXdi
         wEpYbmeaoO/frHUxjj6GmYWJ4R/c5Ppgbw0GJt9ByMUWVyW/mXOOtgzshNK2e10fTKbN
         k6YQ==
X-Gm-Message-State: ACgBeo2IRDxRvVq20dQs67YY7hV/+BsfrZacRaqkFkNDCtrAFb/jqWpQ
        zMJZBXGAcNA32NQwJova1noxr6Ivg8VWVMalvUQ=
X-Google-Smtp-Source: AA6agR6WuV2IbgbYW7USKqWLiyaAEOChp5xCeJvLHUDADLdy2EZVfhR5qO5VLks29mbWTdapX2MkOOG7+KOQTA0XYF0=
X-Received: by 2002:a05:6e02:198c:b0:2e0:ac33:d22 with SMTP id
 g12-20020a056e02198c00b002e0ac330d22mr5261136ilf.219.1660006165003; Mon, 08
 Aug 2022 17:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220808094623.387348-1-asavkov@redhat.com> <20220808094623.387348-2-asavkov@redhat.com>
 <CAP01T76dELOx8p_iky_Py_VcqDbQtaL-4d=zrFiCbFhMdVEmNA@mail.gmail.com>
 <YvEEXsdo/fCnoEFY@samus.usersys.redhat.com> <CAP01T74kqdAeZbmnVA2uDRiB-8tjuWtdw-q_2V5fL6wQ==rTEA@mail.gmail.com>
 <CAEf4BzaGmBZ7aXuX2ty1eB2jddurHyranxPs2cfKkkPB_hoX9A@mail.gmail.com>
In-Reply-To: <CAEf4BzaGmBZ7aXuX2ty1eB2jddurHyranxPs2cfKkkPB_hoX9A@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Tue, 9 Aug 2022 02:48:49 +0200
Message-ID: <CAP01T75iAq+e023w9vPijnnvMJvTS-XeVwEE6xq0ct+Fc9CeHQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] bpf: add destructive kfunc flag
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Tue, 9 Aug 2022 at 02:37, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Aug 8, 2022 at 6:33 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >
> > On Mon, 8 Aug 2022 at 14:41, Artem Savkov <asavkov@redhat.com> wrote:
> > >
> > > On Mon, Aug 08, 2022 at 02:14:33PM +0200, Kumar Kartikeya Dwivedi wrote:
> > > > On Mon, 8 Aug 2022 at 11:48, Artem Savkov <asavkov@redhat.com> wrote:
> > > > >
> > > > > Add KF_DESTRUCTIVE flag for destructive functions. Functions with this
> > > > > flag set will require CAP_SYS_BOOT capabilities.
> > > > >
> > > > > Signed-off-by: Artem Savkov <asavkov@redhat.com>
> > > > > ---
> > > > >  include/linux/btf.h   | 1 +
> > > > >  kernel/bpf/verifier.c | 5 +++++
> > > > >  2 files changed, 6 insertions(+)
> > > > >
> > > > > diff --git a/include/linux/btf.h b/include/linux/btf.h
> > > > > index cdb376d53238..51a0961c84e3 100644
> > > > > --- a/include/linux/btf.h
> > > > > +++ b/include/linux/btf.h
> > > > > @@ -49,6 +49,7 @@
> > > > >   * for this case.
> > > > >   */
> > > > >  #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
> > > > > +#define KF_DESTRUCTIVE  (1 << 5) /* kfunc performs destructive actions */
> > > > >
> > > >
> > > > Please also document this flag in Documentation/bpf/kfuncs.rst.
> > >
> > > Ok, will do.
> > >
> > > > And maybe instead of KF_DESTRUCTIVE, it might be more apt to call this
> > > > KF_CAP_SYS_BOOT. While it is true you had a destructive flag for
> > > > programs being loaded earlier, so there was a mapping between the two
> > > > UAPI and kfunc flags, what it has boiled down to is that this flag
> > > > just requires CAP_SYS_BOOT (in addition to other capabilities) during
> > > > load. So that name might express the intent a bit better. We might
> > > > soon have similar flags encoding requirements of other capabilities on
> > > > load.
> > > >
> > > > The flag rename is just a suggestion, up to you.
> > >
> > > This makes sense right now, but if going forward we'll add stricter
> > > signing requirements or other prerequisites we'll either have to rename
> > > the flag back, or add those as separate flags. I guess the decision here
> >
> > IMO we should do that when the time comes, for now it should reflect
> > the current state.
>
> But names should be also semantically meaningful, so KF_DESTRUCTIVE
> explains that kfunc can do destructive operations, which is better
> than just declaring that kfunc needs CAP_SYS_BOOT, as the latter is
> current implementation detail which has no bearing on kfunc definition
> itself.
>
> Unless we anticipate we'll have another "destructive" kfunc not using
> KF_DESTRUCTIVE and instead we'll add some other
> KF_CAP_SYS_WHATEVERELSE?
>

I just found it a bit odd that KF_DESTRUCTIVE would require
CAP_SYS_BOOT. When thinking about what one would write in the docs:
just that KF_DESTRUCTIVE kfuncs can do destructive operations? That
doesn't really capture what the flag ends up doing to the kfunc (it
limits use to those who have a certain cap on program load). There can
be several destructive operations (e.g. a frequently mentioned socket
kill helper that may be considered equally destructive for some
workload) but would probably require CAP_NET_ADMIN instead.

But anyway, I didn't really want to bikeshed over this :), we can give
it a better name next time something like this is added, and just go
with KF_DESTRUCTIVE for now.

> > To me this helper requiring cap_sys_boot is just like how some
> > existing stable helpers are gated behind bpf_capable or
> > perfmon_capable.
> > When it requires that the program calling it be signed, we can revisit this.
> >
> > > depends on whether some of non-destructive bpf programs might ever require
> > > CAP_SYS_BOOT capabilities or not.
> >
> > These are just internal kernel flags, so refactoring/renaming is not a
> > big deal when it is needed. E.g. we've changed just how kfuncs are
> > registered twice since the support was added not long ago :).
> >
> > >
> > > --
> > >  Artem
> > >
