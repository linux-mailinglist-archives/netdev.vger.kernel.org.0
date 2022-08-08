Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8F758C989
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 15:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242776AbiHHNdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 09:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236127AbiHHNdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 09:33:21 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AF760D0;
        Mon,  8 Aug 2022 06:33:18 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id l24so7061320ion.13;
        Mon, 08 Aug 2022 06:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc;
        bh=gYGa7o0LFb+k6WKzPDuCuY6ek/qRblZnSJwsd7ilTIM=;
        b=o2Dtu4FFj/pojz+rNpvnjks91j8WaiA5Okxru7Md2PSU80mxxJYUYOpAclzj8ddQIz
         5NFVRozDYnUTzrSLT8Bjqddvv/0PRBSImB5zgDxEuA5iyDdEAjab3DFDrTOkK50R+JmG
         iCbtj0QR7p24sE0brxbZhBUOyqkpZP04gqpYVUwbfrUnzmT5UwqU3C77sg8ys5q/+A/r
         F5rFcAheCQnfjxrotV6NgID6yJPG6yGJxmnT7bu7aZQ/ZXdISNA+CTygjSUx4QoFOl4j
         WjqC9iCZM+xMSsqwGVoK3rGOmxZZswYBx92hc891PZslmDOyXL4E+31gneLvC+ejerdy
         Eysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc;
        bh=gYGa7o0LFb+k6WKzPDuCuY6ek/qRblZnSJwsd7ilTIM=;
        b=CE+PLx416LZp9A/K0tdMu+zdyPnSjwqUg5EKY4qnrKCyjHO8zvldTj4OeVWiea6nrB
         wZeWJEZwGIOtBLrDFf+O84XVPT1qZXvKGapFygi4T7rchCN1+vbpoTnfZ0ATB5pLCITl
         yvOxhBORO9xIAV93dvmRP02122eabaDMu1TboM3qG0jtz2s9vfZK5Hp/6NRZH3Ig5qEH
         dvCTouyEbnV83tVeqYVBZRujoiImMMqvswg3sF3pyeQVu1z3Tu9sk52A92qiGQ0QCSI/
         Zr6EbmgUWqfbw9FHGtqn12hrf/6BT4rxTtGBjdiDK5SOg6Moeum3yhABfKM4XTQjjTdK
         FCuw==
X-Gm-Message-State: ACgBeo1WNCPcys7sTcrxkR5pMkm9wUbSjhhYhPKhYyBek7TpeAkpxyJ3
        TkEO/qI4yhAzVQs8rcSpVcSu316kKiqWNAZ9L8Y=
X-Google-Smtp-Source: AA6agR6i6CFJfQodXIHpToqaudMJeJWTrZcXk27S/3V3aW2/9jfnIhdKHvJws1KMvd1aZSx5NfCXVVmYoRYMBndGvHk=
X-Received: by 2002:a05:6638:3822:b0:342:a65d:ade3 with SMTP id
 i34-20020a056638382200b00342a65dade3mr8501595jav.206.1659965598160; Mon, 08
 Aug 2022 06:33:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220808094623.387348-1-asavkov@redhat.com> <20220808094623.387348-2-asavkov@redhat.com>
 <CAP01T76dELOx8p_iky_Py_VcqDbQtaL-4d=zrFiCbFhMdVEmNA@mail.gmail.com> <YvEEXsdo/fCnoEFY@samus.usersys.redhat.com>
In-Reply-To: <YvEEXsdo/fCnoEFY@samus.usersys.redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Mon, 8 Aug 2022 15:32:39 +0200
Message-ID: <CAP01T74kqdAeZbmnVA2uDRiB-8tjuWtdw-q_2V5fL6wQ==rTEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] bpf: add destructive kfunc flag
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
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

On Mon, 8 Aug 2022 at 14:41, Artem Savkov <asavkov@redhat.com> wrote:
>
> On Mon, Aug 08, 2022 at 02:14:33PM +0200, Kumar Kartikeya Dwivedi wrote:
> > On Mon, 8 Aug 2022 at 11:48, Artem Savkov <asavkov@redhat.com> wrote:
> > >
> > > Add KF_DESTRUCTIVE flag for destructive functions. Functions with this
> > > flag set will require CAP_SYS_BOOT capabilities.
> > >
> > > Signed-off-by: Artem Savkov <asavkov@redhat.com>
> > > ---
> > >  include/linux/btf.h   | 1 +
> > >  kernel/bpf/verifier.c | 5 +++++
> > >  2 files changed, 6 insertions(+)
> > >
> > > diff --git a/include/linux/btf.h b/include/linux/btf.h
> > > index cdb376d53238..51a0961c84e3 100644
> > > --- a/include/linux/btf.h
> > > +++ b/include/linux/btf.h
> > > @@ -49,6 +49,7 @@
> > >   * for this case.
> > >   */
> > >  #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
> > > +#define KF_DESTRUCTIVE  (1 << 5) /* kfunc performs destructive actions */
> > >
> >
> > Please also document this flag in Documentation/bpf/kfuncs.rst.
>
> Ok, will do.
>
> > And maybe instead of KF_DESTRUCTIVE, it might be more apt to call this
> > KF_CAP_SYS_BOOT. While it is true you had a destructive flag for
> > programs being loaded earlier, so there was a mapping between the two
> > UAPI and kfunc flags, what it has boiled down to is that this flag
> > just requires CAP_SYS_BOOT (in addition to other capabilities) during
> > load. So that name might express the intent a bit better. We might
> > soon have similar flags encoding requirements of other capabilities on
> > load.
> >
> > The flag rename is just a suggestion, up to you.
>
> This makes sense right now, but if going forward we'll add stricter
> signing requirements or other prerequisites we'll either have to rename
> the flag back, or add those as separate flags. I guess the decision here

IMO we should do that when the time comes, for now it should reflect
the current state.
To me this helper requiring cap_sys_boot is just like how some
existing stable helpers are gated behind bpf_capable or
perfmon_capable.
When it requires that the program calling it be signed, we can revisit this.

> depends on whether some of non-destructive bpf programs might ever require
> CAP_SYS_BOOT capabilities or not.

These are just internal kernel flags, so refactoring/renaming is not a
big deal when it is needed. E.g. we've changed just how kfuncs are
registered twice since the support was added not long ago :).

>
> --
>  Artem
>
