Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DDA52F5D5
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240760AbiETWqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiETWqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:46:34 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D5DAF303;
        Fri, 20 May 2022 15:46:33 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id 68so2149500vse.11;
        Fri, 20 May 2022 15:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5pQeUb7i2aQrMCTFP4sfEtDtoSYxOjDxSh8e8T9nS1E=;
        b=L3x6/NW1KmjyeV38jecoTyoSPtHQaXXxld5nI5ziNWGeMDmOuzG8gyeiR5OidJyR3r
         8HpYxb/QGZAC6BHmf8HtkBI3YA6VWOoxBvg0LzNDtqgxaSCQ63mlnoJSMXlhVCP/O30k
         1xyQ4xMW74V2jTNALUiqUtfcsAeE6tjaFnDgsiw1JkLLA7t6+00Hg4RDEkfmHsKGC2/V
         q7MZTNjmnGdc7t+qtUdI04hJ5JIOCqBhrORl5bOMJ5OzUwlaL0K0Wcp9vtYav4hhLnms
         xHnHZ/v6pFwI+bI0gRcpPniT2l9Ixnfiji1lstMTybByURvjkhasLrUpuoLM0DW02sBg
         +1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5pQeUb7i2aQrMCTFP4sfEtDtoSYxOjDxSh8e8T9nS1E=;
        b=L8MsLzypo1vH1Z0b8IlbsoOTQyAvD/EVzLrndUmvYWidAbhflFwIxyf7fu0FUT0LwK
         atHLjSVH8LYu+ZVPnQc2WiPdjE31dPl2Vs1qo8IoWh6zX7qLsf0WZXGVf7RWotwJPRbH
         jk0waaH+biXqXZp0YUZKG6qkX7YAQrbR7N2BaFvxBueQP2UEvD3hue/9J0eg7rA0Vaht
         IWzLtccrWKyzpjRDhj4krEx1HHzR1Ah/u+S97KSUVbL1GI5lA9NRvBx51K5aOKQre4qh
         01DlomBZTAXqIo5F3KnGZ+2i+MqYrANVhesEUBIaEpingRQ+S0xjpAP3Hqg4dPBb/Gj0
         JMSQ==
X-Gm-Message-State: AOAM5337WpJwCZ+H1X6xGtt9lslF7Zq5KRwNUDw/RplwUC4hY8Ee0n1b
        ciRUZfLCyVwHjuAWsCZqTVz7bGdkaR8v3q6x2uk=
X-Google-Smtp-Source: ABdhPJyiaAtAdaUBzDp9yFdA6kuTy81xzJn/Z4v7Wfuy50rIkY0QXBW8+d0+xYs7kmFR1Mu1NCsSmgdujwsvLus5sTo=
X-Received: by 2002:a05:6102:370a:b0:333:c0e7:77e8 with SMTP id
 s10-20020a056102370a00b00333c0e777e8mr5497192vst.54.1653086792033; Fri, 20
 May 2022 15:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220519233016.105670-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220519233016.105670-1-mathew.j.martineau@linux.intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 May 2022 15:46:21 -0700
Message-ID: <CAEf4BzaZ07_VRN_z6xPogcx-YQuPQR8FCkC=K621r5oo1vBViQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/7] bpf: mptcp: Support for mptcp_sock
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>, mptcp@lists.linux.dev
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

On Thu, May 19, 2022 at 4:30 PM Mat Martineau
<mathew.j.martineau@linux.intel.com> wrote:
>
> This patch set adds BPF access to mptcp_sock structures, along with
> associated self tests. You may recognize some of the code from earlier
> (https://lore.kernel.org/bpf/20200918121046.190240-6-nicolas.rybowski@tessares.net/)
> but it has been reworked quite a bit.
>
>
> v1 -> v2: Emit BTF type, add func_id checks in verifier.c and bpf_trace.c,
> remove build check for CONFIG_BPF_JIT, add selftest check for CONFIG_MPTCP,
> and add a patch to include CONFIG_IKCONFIG/CONFIG_IKCONFIG_PROC for the
> BPF self tests.
>
> v2 -> v3: Access sysctl through the filesystem to work around CI use of
> the more limited busybox sysctl command.
>
> v3 -> v4: Dropped special case kernel code for tcp_sock is_mptcp, use
> existing bpf_tcp_helpers.h, and add check for 'ip mptcp monitor' support.
>
> v4 -> v5: Use BPF test skeleton, more consistent use of ASSERT macros,
> drop some unnecessary parameters / checks, and use tracing to acquire
> MPTCP token.
>
> Geliang Tang (6):
>   bpf: add bpf_skc_to_mptcp_sock_proto
>   selftests/bpf: Enable CONFIG_IKCONFIG_PROC in config
>   selftests/bpf: test bpf_skc_to_mptcp_sock
>   selftests/bpf: verify token of struct mptcp_sock
>   selftests/bpf: verify ca_name of struct mptcp_sock
>   selftests/bpf: verify first of struct mptcp_sock
>
> Nicolas Rybowski (1):
>   selftests/bpf: add MPTCP test base
>
>  MAINTAINERS                                   |   1 +
>  include/linux/bpf.h                           |   1 +
>  include/linux/btf_ids.h                       |   3 +-
>  include/net/mptcp.h                           |   6 +
>  include/uapi/linux/bpf.h                      |   7 +
>  kernel/bpf/verifier.c                         |   1 +
>  kernel/trace/bpf_trace.c                      |   2 +
>  net/core/filter.c                             |  18 ++
>  net/mptcp/Makefile                            |   2 +
>  net/mptcp/bpf.c                               |  21 +++
>  scripts/bpf_doc.py                            |   2 +
>  tools/include/uapi/linux/bpf.h                |   7 +
>  tools/testing/selftests/bpf/bpf_tcp_helpers.h |  13 ++
>  tools/testing/selftests/bpf/config            |   3 +
>  tools/testing/selftests/bpf/network_helpers.c |  40 +++-
>  tools/testing/selftests/bpf/network_helpers.h |   2 +
>  .../testing/selftests/bpf/prog_tests/mptcp.c  | 174 ++++++++++++++++++
>  .../testing/selftests/bpf/progs/mptcp_sock.c  |  89 +++++++++
>  18 files changed, 382 insertions(+), 10 deletions(-)
>  create mode 100644 net/mptcp/bpf.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
>  create mode 100644 tools/testing/selftests/bpf/progs/mptcp_sock.c
>
>
> base-commit: 834650b50ed283d9d34a32b425d668256bf2e487
> --
> 2.36.1
>

I've added missing static for test_base and some other helper and
replaced bzero and memcpy in BPF-side code with __builtin_memset and
__builtin_memcpy (and dropped string.h include, it's not supposed to
be used from BPF-side code). Applied to bpf-next, thanks.
