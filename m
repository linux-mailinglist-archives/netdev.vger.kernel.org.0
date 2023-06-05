Return-Path: <netdev+bounces-8240-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A780F7233AC
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 01:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26AAE1C20DBD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16E628C09;
	Mon,  5 Jun 2023 23:30:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0C728C0A;
	Mon,  5 Jun 2023 23:30:45 +0000 (UTC)
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACB8D2;
	Mon,  5 Jun 2023 16:30:43 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b1b6865c7cso44218241fa.3;
        Mon, 05 Jun 2023 16:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686007841; x=1688599841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DlmpFDEmcxHsnSAtrkjHRWbVNt7ra8EBiqAvJ7+G6UM=;
        b=M9aMrRskDsFPhGK6WdTxx38xeN3fozVsmcEN4p+M/mSfcQKDicvDjSlD/Txrui2oPf
         HDnYaCqBswhWa2BctIRcAzcB/zYAKd0NNn+RSl2MZWj1JHxoVSnB8E9GdTH9VPVpwnwI
         XnLyWNEfKB20R+MC2rQeStvaJUQf9gPeFCzxCxUDKcdHHnDLl0mg87AHBG4e+NjtzOrp
         XK9RrkyJUfHA5BI3xZhOoQ3NoHBW3pMjT5m3a4zPblYljagPOGXDpfxt4Zu/qxkyKRjK
         cXyVQLZxTv0ImYIdztULa2AeozuQOXdzh8rkbmtzBWVCQ/8wCjXXUXNSQ/M2Ibgx3yBm
         Tylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686007841; x=1688599841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DlmpFDEmcxHsnSAtrkjHRWbVNt7ra8EBiqAvJ7+G6UM=;
        b=LsrK3UU/zuBgjwrNzBFFy9eJ7XyBaTPuqupAXV7Z/GBGMZPuJPbudQjP2R8RYqoyWQ
         c0Q0KCN6/mq4FywVXlSMbSlHRD9ygUXSXVnxNKu6vkmnSTEevLKUkDVyWRJ+qpThgSCf
         b/GEHeqyMmbqCeDXU4xk8pP6wBOuQSSIRQMPlnGOf/c369mNnHr6H72gt9bPjFdcnBjG
         OjnotwaRVhpZ0Ag79s12w7ryDMF8hvj80wHXnEyNKo3fuAeFfaiUGxdD0FoSFezb9cfl
         5Jyi6sc0Ncn/Eg6dayQPIGwz2/SIQreGe2UO7Nq5rWqERf1UCw6t+jCYPygcSP3zyD7H
         fhfA==
X-Gm-Message-State: AC+VfDzEr1coI+3KyORFYKRqSnZ4isXyt7Aw/anbKYLax5tzsCxE6Kne
	FAvVMyQ6ddKxPEGLDi7CUohIDPGO+f6d1H1mSvI=
X-Google-Smtp-Source: ACHHUZ4sj1ih+CkariNV5M0zDhUe1cFYW5PMBvQD/6OiIGS0ztojmDNTuxZ39lQbKupwhtGzz7S79/zGfzxVm4QiD5w=
X-Received: by 2002:a2e:380b:0:b0:2af:2231:94ba with SMTP id
 f11-20020a2e380b000000b002af223194bamr403224lja.3.1686007841409; Mon, 05 Jun
 2023 16:30:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605164955.GA1977@templeofstupid.com>
In-Reply-To: <20230605164955.GA1977@templeofstupid.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 5 Jun 2023 16:30:29 -0700
Message-ID: <CAADnVQK7PQxj5jjfUu9sO524yLMPqE6vmzcipno1WYoeu0q-Gw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: search_bpf_extables should search subprogram extables
To: Krister Johansen <kjlx@templeofstupid.com>
Cc: bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, 
	LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, 
	clang-built-linux <llvm@lists.linux.dev>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 9:50=E2=80=AFAM Krister Johansen <kjlx@templeofstupi=
d.com> wrote:
>
> JIT'd bpf programs that have subprograms can have a postive value for
> num_extentries but a NULL value for extable.  This is problematic if one =
of
> these bpf programs encounters a fault during its execution.  The fault
> handlers correctly identify that the faulting IP belongs to a bpf program=
.
> However, performing a search_extable call on a NULL extable leads to a
> second fault.
>
> Fix up by refusing to search a NULL extable, and by checking the
> subprograms' extables if the umbrella program has subprograms configured.
>
> Once I realized what was going on, I was able to use the following bpf
> program to get an oops from this failure:
>
>    #include "vmlinux.h"
>    #include <bpf/bpf_helpers.h>
>    #include <bpf/bpf_tracing.h>
>
>    char LICENSE[] SEC("license") =3D "Dual BSD/GPL";
>
>    #define PATH_MAX 4096
>
>    struct callback_ctx {
>            u8 match;
>    };
>
>    struct filter_value {
>            char prefix[PATH_MAX];
>    };
>    struct {
>            __uint(type, BPF_MAP_TYPE_ARRAY);
>            __uint(max_entries, 256);
>            __type(key, int);
>            __type(value, struct filter_value);
>    } test_filter SEC(".maps");
>
>    static __u64 test_filter_cb(struct bpf_map *map, __u32 *key,
>                                struct filter_value *val,
>                                struct callback_ctx *data)
>    {
>        return 1;
>    }
>
>    SEC("fentry/__sys_bind")
>    int BPF_PROG(__sys_bind, int fd, struct sockaddr *umyaddr, int addrlen=
)
>    {
>      pid_t pid;
>
>      struct callback_ctx cx =3D { .match =3D 0 };
>      pid =3D bpf_get_current_pid_tgid() >> 32;
>      bpf_for_each_map_elem(&test_filter, test_filter_cb, &cx, 0);
>      bpf_printk("fentry: pid =3D %d, family =3D %llx\n", pid, umyaddr->sa=
_family);

Instead of printk please do a volatile read of umyaddr->sa_family.

Please convert this commit log to a test in selftest/bpf/
and resubmit as two patches.

Also see bpf_testmod_return_ptr() and
SEC("fexit/bpf_testmod_return_ptr") in progs/test_module_attach.c.

Probably easier to tweak that test for subprogs instead
of adding your own SEC("fentry/__sys_bind") test and triggering bind()
from user space.


>      return 0;
>    }
>
> And then the following code to actually trigger a failure:
>
>   #include <stdio.h>
>   #include <stdlib.h>
>   #include <unistd.h>
>   #include <sys/socket.h>
>   #include <netinet/in.h>
>   #include <netinet/ip.h>
>
>   int
>   main(int argc, char *argv[])
>   {
>     int sfd, rc;
>     struct sockaddr *sockptr =3D (struct sockaddr *)0x900000000000;
>
>     sfd =3D socket(AF_INET, SOCK_STREAM, 0);
>     if (sfd < 0) {
>       perror("socket");
>       exit(EXIT_FAILURE);
>     }
>
>     while (1) {
>       rc =3D bind(sfd, (struct sockaddr *) sockptr, sizeof(struct sockadd=
r_in));
>       if (rc < 0) {
>         perror("bind");
>         sleep(5);
>       } else {
>         break;
>       }
>     }
>
>     return 0;
>   }
>
> I was able to validate that this problem does not occur when subprograms
> are not in use, or when the direct pointer accesses are replaced with
> bpf_probe_read calls.  I further validated that this did not break the
> extable handling in existing bpf programs.  The same program caused no
> failures when subprograms were removed, but the exception was still
> injected.
>
> Cc: stable@vger.kernel.org
> Fixes: 1c2a088a6626 ("bpf: x64: add JIT support for multi-function progra=
ms")
> Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
> ---
>  kernel/bpf/core.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 7421487422d4..0e12238e4340 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -736,15 +736,33 @@ const struct exception_table_entry *search_bpf_exta=
bles(unsigned long addr)
>  {
>         const struct exception_table_entry *e =3D NULL;
>         struct bpf_prog *prog;
> +       struct bpf_prog_aux *aux;
> +       int i;
>
>         rcu_read_lock();
>         prog =3D bpf_prog_ksym_find(addr);
>         if (!prog)
>                 goto out;
> -       if (!prog->aux->num_exentries)
> +       aux =3D prog->aux;
> +       if (!aux->num_exentries)
>                 goto out;
>
> -       e =3D search_extable(prog->aux->extable, prog->aux->num_exentries=
, addr);
> +       /* prog->aux->extable can be NULL if subprograms are in use. In t=
hat
> +        * case, check each sub-function's aux->extables to see if it has=
 a
> +        * matching entry.
> +        */
> +       if (aux->extable !=3D NULL) {
> +               e =3D search_extable(prog->aux->extable,
> +                   prog->aux->num_exentries, addr);
> +       } else {
> +               for (i =3D 0; (i < aux->func_cnt) && (e =3D=3D NULL); i++=
) {

() are redundant.
!e is preferred over e =3D=3D NULL

> +                       if (!aux->func[i]->aux->num_exentries ||
> +                           aux->func[i]->aux->extable =3D=3D NULL)
> +                               continue;
> +                       e =3D search_extable(aux->func[i]->aux->extable,
> +                           aux->func[i]->aux->num_exentries, addr);
> +               }
> +       }

something odd here.
We do bpf_prog_kallsyms_add(func[i]); for each subprog.
So bpf_prog_ksym_find() in search_bpf_extables()
should be finding ksym and extable of the subprog
and not the main prog.
The bug is probably elsewhere.

Once you respin with a selftest we can help debugging.

