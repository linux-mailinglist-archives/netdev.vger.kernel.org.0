Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E730850A641
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245620AbiDUQyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiDUQyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:54:35 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CC54888F;
        Thu, 21 Apr 2022 09:51:45 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id q22so5961350iod.2;
        Thu, 21 Apr 2022 09:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=en69GFd9iczJ4gyNRpggGpgmwF2q02BdIIrmygJXxio=;
        b=HqlH9sQg9iF7Rm6lFopsgjkthxqycYLJzmHErBCezKfJFSekJOe2Tubb4y2u1IqTKF
         EMfCRqQ+/69CbaMGV9b9FPVKd2OjUVx0rk7ubWAizit7lrIRRVPF+McZnt5rNwrqg6ew
         eyy3vqHoxcYDAcixdnwKnufrq/LC5rpO0ScyRaahwxhfiiBEpE+ouBlFrORqhyp6cUj/
         tt41TmYc9x2lE0Ep2jui0GP/WX1vErkJPO1sxLDyoortbMnF0KLAaqBOTbD8CODVR7zV
         G5zPg20G+5sqRoVAqUZqxAPIr0hRt6G3xzYtGZmJXPPK/pMWd+EFHWcVM66xm0WokJvx
         NcHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=en69GFd9iczJ4gyNRpggGpgmwF2q02BdIIrmygJXxio=;
        b=bhC86yNzkZJZsCH3U17aTRLyC6JMDPQzgBXdfWMk5BZC0Yl+WbarO8asfB0vgQo8oF
         I8GQMcm7R6ADJZzgqyGS3mPWnufgeRtZZ1BCwU550fTjOcLOrCRVb8ZdHQEGS7gOmXhs
         C5KkmC92dOwmmmSjptmYQ32XKI0k664oQyE1iZ2oKeJa/crcpxC6gSNc2VGcPEoNSIxP
         An0MNXjkUZqFB6Pg5boPj6Uw0doFVAbRDeGTg9fT7JHSggv5juqccfZKMdSZ4MibuWab
         9HowNjWBgh0boyuUuODpj8lFsK82SHHcOeodiskBSdnLm5gsGLcQ3OPoS27AC1rg4LT2
         IIpg==
X-Gm-Message-State: AOAM532E9cMSzUZZ+WqlzSzIu77esogy7Vt8kexcqNRFtaivuQZB4pD5
        C6UQsFIMGgxVjIWSWKrnYNWw6OtS8GBnlQ90Trg=
X-Google-Smtp-Source: ABdhPJwpmIWWGzVxyPuj8LJXLvzvKXD9Nm8KC+3hSQ6rjGbMqDoDrqdDbr2hn1lTmqqQFMQ0QekmRwBzS4cpQviVeUU=
X-Received: by 2002:a5d:9f4e:0:b0:652:2323:2eb8 with SMTP id
 u14-20020a5d9f4e000000b0065223232eb8mr285329iot.79.1650559905250; Thu, 21 Apr
 2022 09:51:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220421132317.1583867-1-asavkov@redhat.com>
In-Reply-To: <20220421132317.1583867-1-asavkov@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 Apr 2022 09:51:34 -0700
Message-ID: <CAEf4Bzanrz2A==nkjV6+irPPKvGzxXQBzkLPS6spL54Sc22JkA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix prog_tests/uprobe_autoattach
 compilation error
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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

On Thu, Apr 21, 2022 at 6:23 AM Artem Savkov <asavkov@redhat.com> wrote:
>
> I am getting the following compilation error for prog_tests/uprobe_autoat=
tach.c
>
> tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c: In function =
=E2=80=98test_uprobe_autoattach=E2=80=99:
> ./test_progs.h:209:26: error: pointer =E2=80=98mem=E2=80=99 may be used a=
fter =E2=80=98free=E2=80=99 [-Werror=3Duse-after-free]
>
> mem variable is now used in one of the asserts so it shouldn't be freed r=
ight
> away. Move free(mem) after the assert block.

The memory is not used, we only compare the value of the pointer
itself, we don't dereference. So the compiler is being paranoid here.
But while initial version relied on free() to happen before all the
ASSERTs, now we don't, so moving free after asserts is fine.

>
> Fixes: 1717e248014c ("selftests/bpf: Uprobe tests should verify param/ret=
urn values")
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c b=
/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> index d6003dc8cc99..35b87c7ba5be 100644
> --- a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> +++ b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> @@ -34,7 +34,6 @@ void test_uprobe_autoattach(void)
>
>         /* trigger & validate shared library u[ret]probes attached by nam=
e */
>         mem =3D malloc(malloc_sz);
> -       free(mem);
>
>         ASSERT_EQ(skel->bss->uprobe_byname_parm1, trigger_val, "check_upr=
obe_byname_parm1");
>         ASSERT_EQ(skel->bss->uprobe_byname_ran, 1, "check_uprobe_byname_r=
an");
> @@ -44,6 +43,8 @@ void test_uprobe_autoattach(void)
>         ASSERT_EQ(skel->bss->uprobe_byname2_ran, 3, "check_uprobe_byname2=
_ran");
>         ASSERT_EQ(skel->bss->uretprobe_byname2_rc, mem, "check_uretprobe_=
byname2_rc");
>         ASSERT_EQ(skel->bss->uretprobe_byname2_ran, 4, "check_uretprobe_b=
yname2_ran");
> +
> +       free(mem);
>  cleanup:
>         test_uprobe_autoattach__destroy(skel);
>  }
> --
> 2.35.1
>
