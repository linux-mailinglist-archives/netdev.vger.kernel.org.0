Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F030750A66A
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389619AbiDURAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 13:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbiDURAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 13:00:31 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B1449CA3;
        Thu, 21 Apr 2022 09:57:40 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id f5so3433064ilj.13;
        Thu, 21 Apr 2022 09:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JOWG99CezT9lByIP5QyzIlz0ytuTThPln72bC4jEuqQ=;
        b=LdSOVOjYpqZZ7kql6UX/EFKoFk95WADsdCGCV8z4YJRTwEpcRLUrYcXIrunkDDhDKA
         l1aI8R9Va8PtUj26rWEyrLaPYRx+A0XhZNxi/MR0UDwg0rp4S3uRALguzRxGNm/lPrfH
         hmGVkeNiZoYPEJCiNCkQjyg6Omewj5P3bxrv/rlYxeXZzUa15mmB2VrT7wgsTmitk4lH
         Atuer9/68NRqZEgTiSDm7AuXA6pgrrfs6cU812oMs8IyaR6CKHz4bJQqPjeOUl0C+PGS
         0GoZ9EcVuvy55r0n51mvgq38nuXTlXdNzalNEQ+Op6ZOr6m1FSdVWotFphjL4EU0iT0o
         tlRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JOWG99CezT9lByIP5QyzIlz0ytuTThPln72bC4jEuqQ=;
        b=ZbqF1ivtnr8tGJWyH5T5rNSWg6LzV5bt9NpBIQBVQBaXsaOSmcW1cbD3F+Z7KucuVn
         hUqtmZXGEeJlRVQ1MKwL3y2dS0SC+QmucLK7dD35DDSC62aGd5iWtAVaVMoW1BWHPKlz
         OF2bwK90nAyV+lv+veJfvGyJpe6wYrpBcQ7L2Mr9ExPdYO4njNqqpfg0KXUmJmFN+irX
         WjRD0yYVDuU5hE014kDOM8CTGo4OSLfUOzmUTr+UuZgrrVBekjqiwy+gf5D0rPO/fKCm
         wKTHDrgoZsEn2uCQtmMvKYCW86NvF/8Rj47RbLRgV7z8ZplCNJbUTtpyW4h2eMEn9mZ9
         +DnQ==
X-Gm-Message-State: AOAM53033wKWd9CB5MGSTwcZkr65wQj6thhuOwQhoiB8+tSmjQ6OQAH8
        ok6iNlorHd7LYWjbmWoMZZw9l/30zV6DLzhpTZk=
X-Google-Smtp-Source: ABdhPJxsm1BwRT6hy515TdizAQQOua4mPXWGXy4+7UpEYv1iH2vkhNU9N6ad1G66PqSmvEwzcuabdnaEmnjsRhNezsU=
X-Received: by 2002:a92:c247:0:b0:2cc:1798:74fe with SMTP id
 k7-20020a92c247000000b002cc179874femr284940ilo.239.1650560260212; Thu, 21 Apr
 2022 09:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220421132317.1583867-1-asavkov@redhat.com> <e5919342-0697-65f0-063f-4941e74fe1ca@iogearbox.net>
In-Reply-To: <e5919342-0697-65f0-063f-4941e74fe1ca@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 Apr 2022 09:57:29 -0700
Message-ID: <CAEf4BzZPStrod9Yj7nrDmXeZ0g_ThnaxVum9nEAcwAwAj=8iNg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix prog_tests/uprobe_autoattach
 compilation error
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Artem Savkov <asavkov@redhat.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 9:53 AM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 4/21/22 3:23 PM, Artem Savkov wrote:
> > I am getting the following compilation error for prog_tests/uprobe_auto=
attach.c
> >
> > tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c: In function=
 =E2=80=98test_uprobe_autoattach=E2=80=99:
> > ./test_progs.h:209:26: error: pointer =E2=80=98mem=E2=80=99 may be used=
 after =E2=80=98free=E2=80=99 [-Werror=3Duse-after-free]
> >
> > mem variable is now used in one of the asserts so it shouldn't be freed=
 right
> > away. Move free(mem) after the assert block.
>
> Looks good, but I rephrased this a bit to avoid confusion. It's false pos=
itive given we
> only compare the addresses but don't deref mem, which the compiler might =
not be able to
> follow in this case.
>

Great, thanks Daniel!

> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?=
id=3D6a12b8e20d7e72386594a9dbe7bf2d7fae3b3aa6
>
> Thanks,
> Daniel
>
> > Fixes: 1717e248014c ("selftests/bpf: Uprobe tests should verify param/r=
eturn values")
> > Signed-off-by: Artem Savkov <asavkov@redhat.com>
> > ---
> >   tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c=
 b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> > index d6003dc8cc99..35b87c7ba5be 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> > @@ -34,7 +34,6 @@ void test_uprobe_autoattach(void)
> >
> >       /* trigger & validate shared library u[ret]probes attached by nam=
e */
> >       mem =3D malloc(malloc_sz);
> > -     free(mem);
> >
> >       ASSERT_EQ(skel->bss->uprobe_byname_parm1, trigger_val, "check_upr=
obe_byname_parm1");
> >       ASSERT_EQ(skel->bss->uprobe_byname_ran, 1, "check_uprobe_byname_r=
an");
> > @@ -44,6 +43,8 @@ void test_uprobe_autoattach(void)
> >       ASSERT_EQ(skel->bss->uprobe_byname2_ran, 3, "check_uprobe_byname2=
_ran");
> >       ASSERT_EQ(skel->bss->uretprobe_byname2_rc, mem, "check_uretprobe_=
byname2_rc");
> >       ASSERT_EQ(skel->bss->uretprobe_byname2_ran, 4, "check_uretprobe_b=
yname2_ran");
> > +
> > +     free(mem);
> >   cleanup:
> >       test_uprobe_autoattach__destroy(skel);
> >   }
> >
>
