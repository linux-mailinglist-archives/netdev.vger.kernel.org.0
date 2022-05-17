Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E315529910
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 07:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbiEQFai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 01:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiEQFag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 01:30:36 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39B12E0A9;
        Mon, 16 May 2022 22:30:35 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 137so16022942pgb.5;
        Mon, 16 May 2022 22:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=obywfqk9oJja4pcyG2JCoT8f80P7RWNK9ejKqX7Reh4=;
        b=n6QQQ+olQLaA+fOpu8+My/p5+D9AwV9UsZd3J3nrPT+eKzxycWcS7yMUb/I8KmTfPz
         49qdTres2/LX5D8uPcVh53fl+Noa3lq8x/6mA4FNdpd2lvya4xpuoOEiJAw9fUHKYTt+
         M1H9MUeJyRNUoJF60EecbiOHLTdetJDInwzxaRln+jNHO3CjKw64IOtRm9Bmn0Y/l/8N
         HVt9QIvl00qBmGs8QJN7wAOAcFxqubMNQkorgvOimwjSqVWwHZyTWRgxAbBEwlOe8F+I
         pAyc3TVg0ZdwIH7emSSiSNKqNpBESMn5991cwX5Fl4T2jjhPaI1B+nmZKziibu4868Tf
         MTTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=obywfqk9oJja4pcyG2JCoT8f80P7RWNK9ejKqX7Reh4=;
        b=kJzdN0xKCSEsOM273siI6HTGvsYoz8UeqiAmrwEXQejrU3VsRlE9Bq2PbqB87GWvBr
         P0pctHw8kv9sEPD9HCBqU5HUQtZg/Qs81YDdIHF+bQOWy0vf4/+66oVSF1cBQUISibxE
         FoGV0yw8qb7u15S1NkHKlQQV+V6CdTCnX2MqbVkEHNNZx1u0rUVhM6mKGTG/2jlcXDoT
         9kyy5BB1Uezlz6GX5WOMNmMb5TCDyXWWLrLmbQkN53R2tcmc6fFWX5I7Q2gDyHLbRyRx
         e2vUqN4jgl3US/jTHA/LI1jVeQBM5l9BBa9Vlo5hPEx0m2mxVz1fwAeZBybwZ08GyNvM
         Y02A==
X-Gm-Message-State: AOAM5304+kIfhmjfiKpcIlGT5aZAEV50IHrrMH/WDuJTQwlC0KsvMhjT
        69OAvKi99Fs9zcxVkaaQwKxkOipKf4VXMaPhyTs=
X-Google-Smtp-Source: ABdhPJwma/IiU4cj7MYZyl6cozA+54IXwpn0lzxVulzpwWintiZd/xZ+IMG5BPOm/9aktHuVuw2NYV0IpQ0HzVBpy6Q=
X-Received: by 2002:a05:6a00:1946:b0:4fe:309f:d612 with SMTP id
 s6-20020a056a00194600b004fe309fd612mr20859751pfk.10.1652765435372; Mon, 16
 May 2022 22:30:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
 <20220513224827.662254-4-mathew.j.martineau@linux.intel.com> <CAEf4Bzbn8DSwxt7WdWhNmfAP_NU8gmnJmFzSzO2kt=ZNSt1gUQ@mail.gmail.com>
In-Reply-To: <CAEf4Bzbn8DSwxt7WdWhNmfAP_NU8gmnJmFzSzO2kt=ZNSt1gUQ@mail.gmail.com>
From:   Geliang Tang <geliangtang@gmail.com>
Date:   Tue, 17 May 2022 13:30:37 +0800
Message-ID: <CA+WQbwvUcPVWxd8YB_NgEHjfBYr92fD_AkOPGwiG+_uL9cAjCQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/7] selftests/bpf: add MPTCP test base
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Geliang Tang <geliang.tang@suse.com>
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

Andrii Nakryiko <andrii.nakryiko@gmail.com> =E4=BA=8E2022=E5=B9=B45=E6=9C=
=8817=E6=97=A5=E5=91=A8=E4=BA=8C 06:43=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, May 13, 2022 at 3:48 PM Mat Martineau
> <mathew.j.martineau@linux.intel.com> wrote:
> >
> > From: Nicolas Rybowski <nicolas.rybowski@tessares.net>
> >
> > This patch adds a base for MPTCP specific tests.
> >
> > It is currently limited to the is_mptcp field in case of plain TCP
> > connection because there is no easy way to get the subflow sk from a ms=
k
> > in userspace. This implies that we cannot lookup the sk_storage attache=
d
> > to the subflow sk in the sockops program.
> >
> > v4:
> >  - add copyright 2022 (Andrii)
> >  - use ASSERT_* instead of CHECK_FAIL (Andrii)
> >  - drop SEC("version") (Andrii)
> >  - use is_mptcp in tcp_sock, instead of bpf_tcp_sock (Martin & Andrii)
> >
> > Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > Co-developed-by: Geliang Tang <geliang.tang@suse.com>
> > Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> > Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
> > Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > ---
> >  MAINTAINERS                                   |   1 +
> >  tools/testing/selftests/bpf/bpf_tcp_helpers.h |   1 +
> >  tools/testing/selftests/bpf/config            |   1 +
> >  tools/testing/selftests/bpf/network_helpers.c |  43 ++++--
> >  tools/testing/selftests/bpf/network_helpers.h |   4 +
> >  .../testing/selftests/bpf/prog_tests/mptcp.c  | 136 ++++++++++++++++++
> >  .../testing/selftests/bpf/progs/mptcp_sock.c  |  53 +++++++
> >  7 files changed, 231 insertions(+), 8 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/mptcp_sock.c
> >
>
> Seems like bpf_core_field_exists() works fine for your use case and CI
> is green. See some selftest-specific issues below, though.
>
> [...]
>
> > +static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
> > +{
> > +       int client_fd, prog_fd, map_fd, err;
> > +       struct bpf_program *prog;
> > +       struct bpf_object *obj;
> > +       struct bpf_map *map;
> > +
> > +       obj =3D bpf_object__open("./mptcp_sock.o");
> > +       if (libbpf_get_error(obj))
> > +               return -EIO;
> > +
> > +       err =3D bpf_object__load(obj);
> > +       if (!ASSERT_OK(err, "bpf_object__load"))
> > +               goto out;
> > +
> > +       prog =3D bpf_object__find_program_by_name(obj, "_sockops");
>
> can you please use BPF skeleton instead of doing these lookups by
> name? See other tests that are including .skel.h headers for example

Sure, I will update this in v5.

>
> > +       if (!ASSERT_OK_PTR(prog, "bpf_object__find_program_by_name")) {
> > +               err =3D -EIO;
> > +               goto out;
> > +       }
> > +
>
> [...]
>
> > +void test_base(void)
> > +{
> > +       int server_fd, cgroup_fd;
> > +
> > +       cgroup_fd =3D test__join_cgroup("/mptcp");
> > +       if (CHECK_FAIL(cgroup_fd < 0))
> > +               return;
> > +
> > +       /* without MPTCP */
> > +       server_fd =3D start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
> > +       if (CHECK_FAIL(server_fd < 0))
> > +               goto with_mptcp;
> > +
> > +       CHECK_FAIL(run_test(cgroup_fd, server_fd, false));
>
> please don't add new uses of CHECK_FAIL()
>
> > +
> > +       close(server_fd);
> > +
>
> [...]
>
