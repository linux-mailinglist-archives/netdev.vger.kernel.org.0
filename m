Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE52C522802
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 01:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238930AbiEJX7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 19:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239050AbiEJX7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 19:59:12 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6527F227B4A;
        Tue, 10 May 2022 16:58:46 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id r27so482266iot.1;
        Tue, 10 May 2022 16:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LIfUjAZIEHf1KpjRZvZJrcDVb3Re8H1xsX5MJbeUAFQ=;
        b=DbZhSiXenRB3CYAjj8DHcI3kJDszgmwNu6Cki9CzC+BANO5R/hOz87iyPlo9lVPLoh
         Z8jW++G8gnHoGrpFJc1LK9rlqOyyDe2c5qZqFY5fFv7xKaFxGlKJnCUEVYaWHKPEMLRH
         s0Ge5gA3x8jnJucDEiHFjR2waJgqGglF4cdVi9yLiHsk++SWwhrxWKQ+SU0b1q4RmiSI
         RdXZZf0kjdDZRyf40rXAwtSCXi1Xm2zPpZXcLMDZ8syWtFD/m/KBlKzZ/Oso0fwTrpnu
         UKdhjn8FHSnC7Uk1uD7Dl2mYKDcSzfSQsHGcohgfhuegHjexYizOWI0atSZUtz94lO6B
         qGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LIfUjAZIEHf1KpjRZvZJrcDVb3Re8H1xsX5MJbeUAFQ=;
        b=e9BF3PLSDCXtLba4xLinxQtLkKhrvHxbVUjvviEuw8RD/+3lk7QiPJC+0f9jdYMc5t
         R3L1o0bJh9VjI2aPJopwbE2F5tt9Gg1RP/IG0g/9n3bsgehXCEeCapkGMXT0bV+l19Km
         GopxfvDnsyD0/X9DriXYRGrAObLmM8j9Y8PSF/eVooMSDj4s8NLELg9ctxqi7zwyEerh
         HsT6s6MfWas9gjmVYHS7xSQTNPCelh8hHKaNE4AlBtX3KwBl2FmlXt7AYpAvcK7SsHLH
         h1dyJELnTMgvx/1BPsvxTOB2KBJJuiCfFVJncbZp4reaH4EcJX/Pq8ZusRNuN2txMCuy
         u5RQ==
X-Gm-Message-State: AOAM530nr9KZ0zKixvwilNKv0CEYcRtqaDqmn9R1B0X82MEwy70Z9XVL
        5kY99aZHG1dygR/D23+CnFrZymLaQvgJJUbINXw=
X-Google-Smtp-Source: ABdhPJxhi0mRHy7O3mol15xME9VrLH+gtnYjGV2KknrggjSISwlb6ABLMy7j08qK7u26OQoAOY6XQEKJ4Rz7RizW/7U=
X-Received: by 2002:a05:6602:2acd:b0:65a:9f9d:23dc with SMTP id
 m13-20020a0566022acd00b0065a9f9d23dcmr9636596iov.154.1652227125788; Tue, 10
 May 2022 16:58:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com>
 <20220502211235.142250-7-mathew.j.martineau@linux.intel.com> <e024cde0-70ad-5332-1818-e6af77509a8c@linux.intel.com>
In-Reply-To: <e024cde0-70ad-5332-1818-e6af77509a8c@linux.intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 May 2022 16:58:34 -0700
Message-ID: <CAEf4BzY5GPzdZbFXKKhsCNubsJKp-ROB-iLVHz=9v6FOkt_r0Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 6/8] selftests: bpf: verify token of struct mptcp_sock
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>
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

On Tue, May 10, 2022 at 2:59 PM Mat Martineau
<mathew.j.martineau@linux.intel.com> wrote:
>
> On Mon, 2 May 2022, Mat Martineau wrote:
>
> > From: Geliang Tang <geliang.tang@suse.com>
> >
> > This patch verifies the struct member token of struct mptcp_sock. Add a
> > new function get_msk_token() to parse the msk token from the output of
> > the command 'ip mptcp monitor', and verify it in verify_msk().
> >
> > Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> > Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > ---
> > .../testing/selftests/bpf/bpf_mptcp_helpers.h |  1 +
> > .../testing/selftests/bpf/prog_tests/mptcp.c  | 66 +++++++++++++++++++
> > .../testing/selftests/bpf/progs/mptcp_sock.c  |  5 ++
> > 3 files changed, 72 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/bpf_mptcp_helpers.h b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
> > index 18da4cc65e89..87e15810997d 100644
> > --- a/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
> > +++ b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
> > @@ -9,6 +9,7 @@
> > struct mptcp_sock {
> >       struct inet_connection_sock     sk;
> >
> > +     __u32           token;
> > } __attribute__((preserve_access_index));
> >
> > #endif
> > diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> > index 4b40bbdaf91f..c5d96ba81e04 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> > @@ -8,8 +8,11 @@
> > struct mptcp_storage {
> >       __u32 invoked;
> >       __u32 is_mptcp;
> > +     __u32 token;
> > };
> >
> > +static char monitor_log_path[64];
> > +
> > static int verify_tsk(int map_fd, int client_fd)
> > {
> >       char *msg = "plain TCP socket";
> > @@ -36,11 +39,58 @@ static int verify_tsk(int map_fd, int client_fd)
> >       return err;
> > }
> >
> > +/*
> > + * Parse the token from the output of 'ip mptcp monitor':
> > + *
> > + * [       CREATED] token=3ca933d3 remid=0 locid=0 saddr4=127.0.0.1 ...
> > + * [       CREATED] token=2ab57040 remid=0 locid=0 saddr4=127.0.0.1 ...
> > + */
> > +static __u32 get_msk_token(void)
> > +{
> > +     char *prefix = "[       CREATED] token=";
> > +     char buf[BUFSIZ] = {};
> > +     __u32 token = 0;
> > +     ssize_t len;
> > +     int fd;
> > +
> > +     sync();
> > +
> > +     fd = open(monitor_log_path, O_RDONLY);
> > +     if (CHECK_FAIL(fd < 0)) {
> > +             log_err("Failed to open %s", monitor_log_path);
> > +             return token;
> > +     }
> > +
> > +     len = read(fd, buf, sizeof(buf));
> > +     if (CHECK_FAIL(len < 0)) {
> > +             log_err("Failed to read %s", monitor_log_path);
> > +             goto err;
> > +     }
> > +
> > +     if (strncmp(buf, prefix, strlen(prefix))) {
> > +             log_err("Invalid prefix %s", buf);
> > +             goto err;
> > +     }
> > +
> > +     token = strtol(buf + strlen(prefix), NULL, 16);
> > +
> > +err:
> > +     close(fd);
> > +     return token;
> > +}
> > +
> > static int verify_msk(int map_fd, int client_fd)
> > {
> >       char *msg = "MPTCP subflow socket";
> >       int err = 0, cfd = client_fd;
> >       struct mptcp_storage val;
> > +     __u32 token;
> > +
> > +     token = get_msk_token();
> > +     if (token <= 0) {
> > +             log_err("Unexpected token %x", token);
> > +             return -1;
> > +     }
> >
> >       if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &cfd, &val) < 0)) {
> >               perror("Failed to read socket storage");
> > @@ -59,6 +109,12 @@ static int verify_msk(int map_fd, int client_fd)
> >               err++;
> >       }
> >
> > +     if (val.token != token) {
> > +             log_err("Unexpected mptcp_sock.token %x != %x",
> > +                     val.token, token);
> > +             err++;
> > +     }
> > +
> >       return err;
> > }
> >
> > @@ -124,6 +180,7 @@ static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
> >
> > void test_base(void)
> > {
> > +     char cmd[256], tmp_dir[] = "/tmp/XXXXXX";
> >       int server_fd, cgroup_fd;
> >
> >       cgroup_fd = test__join_cgroup("/mptcp");
> > @@ -141,6 +198,13 @@ void test_base(void)
> >
> > with_mptcp:
> >       /* with MPTCP */
>
> Geliang, could you add a check here that skips this test (instead of
> failing) if the 'ip mptcp monitor' command is not supported?
>
> Checking the exit status of "ip mptcp help 2>&1 | grep monitor" should
> work.
>

Ilya actually already generated updated image, and after [0] it should
be used in CI runs. But we'll know for sure with your next MPTCP
submission.

  [0] https://github.com/libbpf/ci/pull/16

> Thanks,
>
> Mat
>
> > +     if (CHECK_FAIL(!mkdtemp(tmp_dir)))
> > +             goto close_cgroup_fd;
> > +     snprintf(monitor_log_path, sizeof(monitor_log_path),
> > +              "%s/ip_mptcp_monitor", tmp_dir);
> > +     snprintf(cmd, sizeof(cmd), "ip mptcp monitor > %s &", monitor_log_path);
> > +     if (CHECK_FAIL(system(cmd)))
> > +             goto close_cgroup_fd;
> >       server_fd = start_mptcp_server(AF_INET, NULL, 0, 0);
> >       if (CHECK_FAIL(server_fd < 0))
> >               goto close_cgroup_fd;
> > @@ -148,6 +212,8 @@ void test_base(void)
> >       CHECK_FAIL(run_test(cgroup_fd, server_fd, true));
> >
> >       close(server_fd);
> > +     snprintf(cmd, sizeof(cmd), "rm -rf %s", tmp_dir);
> > +     system(cmd);
> >
> > close_cgroup_fd:
> >       close(cgroup_fd);
> > diff --git a/tools/testing/selftests/bpf/progs/mptcp_sock.c b/tools/testing/selftests/bpf/progs/mptcp_sock.c
> > index 7b6a25e37de8..c58c191d8416 100644
> > --- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
> > +++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
> > @@ -12,6 +12,7 @@ extern bool CONFIG_MPTCP __kconfig;
> > struct mptcp_storage {
> >       __u32 invoked;
> >       __u32 is_mptcp;
> > +     __u32 token;
> > };
> >
> > struct {
> > @@ -46,6 +47,8 @@ int _sockops(struct bpf_sock_ops *ctx)
> >                                            BPF_SK_STORAGE_GET_F_CREATE);
> >               if (!storage)
> >                       return 1;
> > +
> > +             storage->token = 0;
> >       } else {
> >               if (!CONFIG_MPTCP)
> >                       return 1;
> > @@ -58,6 +61,8 @@ int _sockops(struct bpf_sock_ops *ctx)
> >                                            BPF_SK_STORAGE_GET_F_CREATE);
> >               if (!storage)
> >                       return 1;
> > +
> > +             storage->token = msk->token;
> >       }
> >       storage->invoked++;
> >       storage->is_mptcp = tcp_sk->is_mptcp;
> > --
> > 2.36.0
> >
> >
>
> --
> Mat Martineau
> Intel
