Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76853526F55
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiENByJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 21:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiENByH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 21:54:07 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA5A3E9044;
        Fri, 13 May 2022 16:56:19 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id p12so9039639pfn.0;
        Fri, 13 May 2022 16:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rNVk9YDEQR+xtvNydQUUbuQjMkViiEzhXCU73eGldY8=;
        b=GtOgBYsHjz8fWeluuBd2/RbUxS13aaMfZAKmP2jjQWF1BobR2tuD8CykQgf6CCsQFl
         ExoJdEHODDUYD27rjr1m2JNEPyvf3wMSys3MgPHy98rSAshIJEXaYYki8vByR+95LKsi
         hT1oP7r0HXKGEX0y1h1KbR3x/NUksQk8kzAsbviF6jhzoJt8/soHFJkrZA0ehg2vNGiw
         lTTKv6KlMbbUAYDklf0K+BwKNSMe7+I5JhSJEp3dy7KXNanWk/1dbiBJjXXNQaxf1BgH
         tDyyAxgZNc5pXX43xF/xGjIiL0HLZqzm90oHG92G/XEjr5ODGjNtVJm8+BU2b9xxK8Zh
         RIzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rNVk9YDEQR+xtvNydQUUbuQjMkViiEzhXCU73eGldY8=;
        b=MPc5yDvlA5F8x8aRxQMi0Rc9tr2kBo2/kbdqEAGlS+8lMbAv/L9tBMCs0+VcKTDWhO
         BLeRbLBoC1o13u8tYITUoetl0eQec/USg9MBtF5gl9wpEicAlqy7vVHDNovRkFwtmoXZ
         62wtIMsuC75ma3aykLFRBj/gxOb5fhCwGOHrgm8myUX+p8fqp6MH5ZWmf5mWxz6t+e1E
         NT1fCv0NKzabFHou8fy1eG34Vzc/kQsFgoZnY3oYSUqu7JfgPzSExH770uJDgrM8zb7D
         VhrNbE2sDr6iJlXWHgRmnAbEoZTUhKbTEULxcPsnXznMU/fFch6DwkhigVN7b9HmSbqZ
         h+Mw==
X-Gm-Message-State: AOAM532P80JiyhdoF85toqz3djRDY/dwEYBhze1UU+WyzegvbCeNrEEe
        GMOwa6DTCtsjkE1vtjCRKY/17yv/pB2wIjn4Jjc=
X-Google-Smtp-Source: ABdhPJw6HF52OEgBlLp4vI9wJpNliFr+bRP1D9H7WO1lYtvQm28N5CilvEWQlUI8wsNSnYDxNTyWYmq32wFlUh/dAss=
X-Received: by 2002:a05:6a00:1a08:b0:510:a1db:1a91 with SMTP id
 g8-20020a056a001a0800b00510a1db1a91mr6616285pfv.69.1652486018354; Fri, 13 May
 2022 16:53:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com> <20220513224827.662254-5-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220513224827.662254-5-mathew.j.martineau@linux.intel.com>
From:   Geliang Tang <geliangtang@gmail.com>
Date:   Sat, 14 May 2022 07:53:36 +0800
Message-ID: <CA+WQbwtN6KS0KzNKVp-7gioDR+DJ6Ks_kC-TB5viUb60HqHwuQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/7] selftests/bpf: test bpf_skc_to_mptcp_sock
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mat Martineau <mathew.j.martineau@linux.intel.com> =E4=BA=8E2022=E5=B9=B45=
=E6=9C=8814=E6=97=A5=E5=91=A8=E5=85=AD 06:48=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Geliang Tang <geliang.tang@suse.com>
>
> This patch extends the MPTCP test base, to test the new helper
> bpf_skc_to_mptcp_sock().
>
> Define struct mptcp_sock in bpf_tcp_helpers.h, use bpf_skc_to_mptcp_sock
> to get the msk socket in progs/mptcp_sock.c and store the infos in
> socket_storage_map.
>
> Get the infos from socket_storage_map in prog_tests/mptcp.c. Add a new
> function verify_msk() to verify the infos of MPTCP socket, and rename
> verify_sk() to verify_tsk() to verify TCP socket only.
>
> v2: Add CONFIG_MPTCP check for clearer error messages
> v4:
>  - use ASSERT_* instead of CHECK_FAIL (Andrii)
>  - drop bpf_mptcp_helpers.h (Andrii)
>
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  tools/testing/selftests/bpf/bpf_tcp_helpers.h |  5 +++
>  .../testing/selftests/bpf/prog_tests/mptcp.c  | 45 ++++++++++++++-----
>  .../testing/selftests/bpf/progs/mptcp_sock.c  | 23 ++++++++--
>  3 files changed, 58 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testin=
g/selftests/bpf/bpf_tcp_helpers.h
> index 22e0c8849a17..90fecafc493d 100644
> --- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> @@ -226,4 +226,9 @@ static __always_inline bool tcp_cc_eq(const char *a, =
const char *b)
>  extern __u32 tcp_slow_start(struct tcp_sock *tp, __u32 acked) __ksym;
>  extern void tcp_cong_avoid_ai(struct tcp_sock *tp, __u32 w, __u32 acked)=
 __ksym;
>
> +struct mptcp_sock {
> +       struct inet_connection_sock     sk;
> +
> +} __attribute__((preserve_access_index));
> +
>  #endif
> diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testi=
ng/selftests/bpf/prog_tests/mptcp.c
> index cb0389ca8690..02e7fd8918e6 100644
> --- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
> +++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> @@ -11,14 +11,12 @@ struct mptcp_storage {
>         __u32 is_mptcp;
>  };
>
> -static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 i=
s_mptcp)
> +static int verify_tsk(int map_fd, int client_fd)
>  {
> +       char *msg =3D "plain TCP socket";
>         int err, cfd =3D client_fd;
>         struct mptcp_storage val;
>
> -       if (is_mptcp =3D=3D 1)
> -               return 0;
> -
>         err =3D bpf_map_lookup_elem(map_fd, &cfd, &val);
>         if (!ASSERT_OK(err, "bpf_map_lookup_elem"))
>                 return err;
> @@ -38,6 +36,31 @@ static int verify_sk(int map_fd, int client_fd, const =
char *msg, __u32 is_mptcp)
>         return err;
>  }
>
> +static int verify_msk(int map_fd, int client_fd)
> +{
> +       char *msg =3D "MPTCP subflow socket";
> +       int err, cfd =3D client_fd;
> +       struct mptcp_storage val;
> +
> +       err =3D bpf_map_lookup_elem(map_fd, &cfd, &val);
> +       if (!ASSERT_OK(err, "bpf_map_lookup_elem"))
> +               return err;
> +
> +       if (val.invoked !=3D 1) {
> +               log_err("%s: unexpected invoked count %d !=3D 1",
> +                       msg, val.invoked);
> +               err++;
> +       }
> +
> +       if (val.is_mptcp !=3D 1) {
> +               log_err("%s: unexpected bpf_tcp_sock.is_mptcp %d !=3D 1",
> +                       msg, val.is_mptcp);
> +               err++;
> +       }
> +
> +       return err;
> +}
> +
>  static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
>  {
>         int client_fd, prog_fd, map_fd, err;
> @@ -88,8 +111,8 @@ static int run_test(int cgroup_fd, int server_fd, bool=
 is_mptcp)
>                 goto out;
>         }
>
> -       err +=3D is_mptcp ? verify_sk(map_fd, client_fd, "MPTCP subflow s=
ocket", 1) :
> -                         verify_sk(map_fd, client_fd, "plain TCP socket"=
, 0);
> +       err +=3D is_mptcp ? verify_msk(map_fd, client_fd) :
> +                         verify_tsk(map_fd, client_fd);
>
>         close(client_fd);
>


''''
> @@ -103,25 +126,25 @@ void test_base(void)
>         int server_fd, cgroup_fd;
>
>         cgroup_fd =3D test__join_cgroup("/mptcp");
> -       if (CHECK_FAIL(cgroup_fd < 0))
> +       if (!ASSERT_GE(cgroup_fd, 0, "test__join_cgroup"))
>                 return;
>
>         /* without MPTCP */
>         server_fd =3D start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
> -       if (CHECK_FAIL(server_fd < 0))
> +       if (!ASSERT_GE(server_fd, 0, "start_server"))
>                 goto with_mptcp;
>
> -       CHECK_FAIL(run_test(cgroup_fd, server_fd, false));
> +       ASSERT_OK(run_test(cgroup_fd, server_fd, false), "run_test tcp");
>
>         close(server_fd);
>
>  with_mptcp:
>         /* with MPTCP */
>         server_fd =3D start_mptcp_server(AF_INET, NULL, 0, 0);
> -       if (CHECK_FAIL(server_fd < 0))
> +       if (!ASSERT_GE(server_fd, 0, "start_mptcp_server"))
>                 goto close_cgroup_fd;
>
> -       CHECK_FAIL(run_test(cgroup_fd, server_fd, true));
> +       ASSERT_OK(run_test(cgroup_fd, server_fd, true), "run_test mptcp")=
;
'''

Sorry Mat, this code using ASSERT_* instead of CHECK_FAIL should be
squash into patch #3, it shouldn't in this patch. I'll send a v5 to
MPTCP ML to fix this.

Thanks,
-Geliang

>
>         close(server_fd);
>
> diff --git a/tools/testing/selftests/bpf/progs/mptcp_sock.c b/tools/testi=
ng/selftests/bpf/progs/mptcp_sock.c
> index bc09dba0b078..3feb7ff578e2 100644
> --- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
> +++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
> @@ -7,6 +7,7 @@
>  #include "bpf_tcp_helpers.h"
>
>  char _license[] SEC("license") =3D "GPL";
> +extern bool CONFIG_MPTCP __kconfig;
>
>  struct mptcp_storage {
>         __u32 invoked;
> @@ -24,6 +25,7 @@ SEC("sockops")
>  int _sockops(struct bpf_sock_ops *ctx)
>  {
>         struct mptcp_storage *storage;
> +       struct mptcp_sock *msk;
>         int op =3D (int)ctx->op;
>         struct tcp_sock *tsk;
>         struct bpf_sock *sk;
> @@ -41,11 +43,24 @@ int _sockops(struct bpf_sock_ops *ctx)
>                 return 1;
>
>         is_mptcp =3D bpf_core_field_exists(tsk->is_mptcp) ? tsk->is_mptcp=
 : 0;
> -       storage =3D bpf_sk_storage_get(&socket_storage_map, sk, 0,
> -                                    BPF_SK_STORAGE_GET_F_CREATE);
> -       if (!storage)
> -               return 1;
> +       if (!is_mptcp) {
> +               storage =3D bpf_sk_storage_get(&socket_storage_map, sk, 0=
,
> +                                            BPF_SK_STORAGE_GET_F_CREATE)=
;
> +               if (!storage)
> +                       return 1;
> +       } else {
> +               if (!CONFIG_MPTCP)
> +                       return 1;
> +
> +               msk =3D bpf_skc_to_mptcp_sock(sk);
> +               if (!msk)
> +                       return 1;
>
> +               storage =3D bpf_sk_storage_get(&socket_storage_map, msk, =
0,
> +                                            BPF_SK_STORAGE_GET_F_CREATE)=
;
> +               if (!storage)
> +                       return 1;
> +       }
>         storage->invoked++;
>         storage->is_mptcp =3D is_mptcp;
>
> --
> 2.36.1
>
>
