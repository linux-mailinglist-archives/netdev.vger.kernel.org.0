Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE4C22223E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 14:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgGPMRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 08:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgGPMRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 08:17:38 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72218C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 05:17:38 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id s9so6849302ljm.11
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 05:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=tscWjFcr/AdRUQgnIH2j5TMqV/ph1Tniwa7qjpNU7zU=;
        b=yW3vYZAvEURuyXC+7AoFhhYT8ibwcm5EmWW9YQW0IIzF9V9RCC06cY4p8l5oVCI3J6
         rV54te2CZsxX0GcqSmtZi30tbp2g38+FaRrMrs9Us5bnOdNzQObPEnPFTNlYZnsaxV+b
         UVC8fWrzXZ5VSMSWy5+Ww6wdHdlHSmsS/3i1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=tscWjFcr/AdRUQgnIH2j5TMqV/ph1Tniwa7qjpNU7zU=;
        b=JRTDfXI1raymDWgh8zJqyVqmb+UId3JHfcAjeoxojPvRRb5lMinytiU6Vt5fzfd95G
         ZweAePUuZzArFWK5TRfuEJKRyU2KNl2MZKAvsp1Bv5fVZXSNgRtuSptQ2BzbJ2piiPtS
         oYIgVsuy0B09BzfSKxuB6elqEFxB0glPy+/YBAqC0vX3ZhB9KccOrYw4KOgH8Ih0S6pg
         FwxUfqqkcYGAa1AZ3GM+f2zNmcKZjq0vqLlw+iTkxmJNWQldU04YSDDHuQYu5ObW5lmH
         BJ4pOzFsUmyk1xYEZTc18z/gHNrLKTyttj+Vx9atY1wmRCB+lM+Ym/0GCw28vSen6ivZ
         5jAQ==
X-Gm-Message-State: AOAM530HrO6X38I8Sd2k4WjXwl5AInc57j7ztLpxGZNqOgAJTWjQOCk0
        G2WQrNQVly70BnunJyO+ezaHbQ==
X-Google-Smtp-Source: ABdhPJxqWgGyQoj+nCEkyDTqOzwSP09fMuf9WwjDRBm3afE6PoJaTuGhPMHsGh3o0//OnnSg7UOhzw==
X-Received: by 2002:a2e:780e:: with SMTP id t14mr2000146ljc.444.1594901856795;
        Thu, 16 Jul 2020 05:17:36 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id y26sm1017207ljk.26.2020.07.16.05.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 05:17:36 -0700 (PDT)
References: <20200713174654.642628-1-jakub@cloudflare.com> <20200713174654.642628-3-jakub@cloudflare.com> <CAEf4BzZd30RmiZaGvDju9X0jybkcdhgOk71fbcdySeJdPzmrAQ@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH bpf-next v4 02/16] bpf: Introduce SK_LOOKUP program type with a dedicated attach point
In-reply-to: <CAEf4BzZd30RmiZaGvDju9X0jybkcdhgOk71fbcdySeJdPzmrAQ@mail.gmail.com>
Date:   Thu, 16 Jul 2020 14:17:35 +0200
Message-ID: <877dv3y7q8.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 03:41 AM CEST, Andrii Nakryiko wrote:
> On Mon, Jul 13, 2020 at 10:47 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Add a new program type BPF_PROG_TYPE_SK_LOOKUP with a dedicated attach type
>> BPF_SK_LOOKUP. The new program kind is to be invoked by the transport layer
>> when looking up a listening socket for a new connection request for
>> connection oriented protocols, or when looking up an unconnected socket for
>> a packet for connection-less protocols.
>>
>> When called, SK_LOOKUP BPF program can select a socket that will receive
>> the packet. This serves as a mechanism to overcome the limits of what
>> bind() API allows to express. Two use-cases driving this work are:
>>
>>  (1) steer packets destined to an IP range, on fixed port to a socket
>>
>>      192.0.2.0/24, port 80 -> NGINX socket
>>
>>  (2) steer packets destined to an IP address, on any port to a socket
>>
>>      198.51.100.1, any port -> L7 proxy socket
>>
>> In its run-time context program receives information about the packet that
>> triggered the socket lookup. Namely IP version, L4 protocol identifier, and
>> address 4-tuple. Context can be further extended to include ingress
>> interface identifier.
>>
>> To select a socket BPF program fetches it from a map holding socket
>> references, like SOCKMAP or SOCKHASH, and calls bpf_sk_assign(ctx, sk, ...)
>> helper to record the selection. Transport layer then uses the selected
>> socket as a result of socket lookup.
>>
>> This patch only enables the user to attach an SK_LOOKUP program to a
>> network namespace. Subsequent patches hook it up to run on local delivery
>> path in ipv4 and ipv6 stacks.
>>
>> Suggested-by: Marek Majkowski <marek@cloudflare.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>
>> Notes:
>>     v4:
>>     - Reintroduce narrow load support for most BPF context fields. (Yonghong)
>>     - Fix null-ptr-deref in BPF context access when IPv6 address not set.
>>     - Unpack v4/v6 IP address union in bpf_sk_lookup context type.
>>     - Add verifier support for ARG_PTR_TO_SOCKET_OR_NULL.
>>     - Allow resetting socket selection with bpf_sk_assign(ctx, NULL).
>>     - Document that bpf_sk_assign accepts a NULL socket.
>>
>>     v3:
>>     - Allow bpf_sk_assign helper to replace previously selected socket only
>>       when BPF_SK_LOOKUP_F_REPLACE flag is set, as a precaution for multiple
>>       programs running in series to accidentally override each other's verdict.
>>     - Let BPF program decide that load-balancing within a reuseport socket group
>>       should be skipped for the socket selected with bpf_sk_assign() by passing
>>       BPF_SK_LOOKUP_F_NO_REUSEPORT flag. (Martin)
>>     - Extend struct bpf_sk_lookup program context with an 'sk' field containing
>>       the selected socket with an intention for multiple attached program
>>       running in series to see each other's choices. However, currently the
>>       verifier doesn't allow checking if pointer is set.
>>     - Use bpf-netns infra for link-based multi-program attachment. (Alexei)
>>     - Get rid of macros in convert_ctx_access to make it easier to read.
>>     - Disallow 1-,2-byte access to context fields containing IP addresses.
>>
>>     v2:
>>     - Make bpf_sk_assign reject sockets that don't use RCU freeing.
>>       Update bpf_sk_assign docs accordingly. (Martin)
>>     - Change bpf_sk_assign proto to take PTR_TO_SOCKET as argument. (Martin)
>>     - Fix broken build when CONFIG_INET is not selected. (Martin)
>>     - Rename bpf_sk_lookup{} src_/dst_* fields remote_/local_*. (Martin)
>>     - Enforce BPF_SK_LOOKUP attach point on load & attach. (Martin)
>>
>>  include/linux/bpf-netns.h  |   3 +
>>  include/linux/bpf.h        |   1 +
>>  include/linux/bpf_types.h  |   2 +
>>  include/linux/filter.h     |  17 ++++
>>  include/uapi/linux/bpf.h   |  77 ++++++++++++++++
>>  kernel/bpf/net_namespace.c |   5 ++
>>  kernel/bpf/syscall.c       |   9 ++
>>  kernel/bpf/verifier.c      |  10 ++-
>>  net/core/filter.c          | 179 +++++++++++++++++++++++++++++++++++++
>>  scripts/bpf_helpers_doc.py |   9 +-
>>  10 files changed, 308 insertions(+), 4 deletions(-)
>>
>
> Looks good, two suggestions below.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> [...]
>
>> +
>> +static const struct bpf_func_proto *
>> +sk_lookup_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>> +{
>> +       switch (func_id) {
>> +       case BPF_FUNC_sk_assign:
>> +               return &bpf_sk_lookup_assign_proto;
>> +       case BPF_FUNC_sk_release:
>> +               return &bpf_sk_release_proto;
>> +       default:
>
> Wouldn't it be useful to have functions like
> get_current_comm/get_current_pid_tgid/perf_event_output as well?
> Similarly how they were added to a bunch of other socket-related BPF
> program types recently?

I can certainly see value in perf_event_output as a way to log/trace
prog decisions. Less so for helpers that provide access to current task,
as the prog usually will be called in softirq context.

bpf_get_socket_cookie and bpf_get_netns_cookie have been on my mind, but
first they need to be taught to accept ARG_PTR_TO_SOCKET.

That is to say, I expected the list of allowed helpers to grow.

>
>
>> +               return bpf_base_func_proto(func_id);
>> +       }
>> +}
>> +
>
> [...]
>
>> +       case offsetof(struct bpf_sk_lookup, local_ip4):
>> +               *insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
>> +                                     bpf_target_off(struct bpf_sk_lookup_kern,
>> +                                                    v4.daddr, 4, target_size));
>> +               break;
>> +
>> +       case bpf_ctx_range_till(struct bpf_sk_lookup,
>> +                               remote_ip6[0], remote_ip6[3]):
>> +#if IS_ENABLED(CONFIG_IPV6)
>
> nit: if you added {} to this case block, you could have combined the
> above `int off` section with this one.

Nifty. Thanks.

>
>> +               off = si->off;
>> +               off -= offsetof(struct bpf_sk_lookup, remote_ip6[0]);
>> +               off += bpf_target_off(struct in6_addr, s6_addr32[0], 4, target_size);
>> +               *insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg, si->src_reg,
>> +                                     offsetof(struct bpf_sk_lookup_kern, v6.saddr));
>> +               *insn++ = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 1);
>> +               *insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg, off);
>> +#else
>> +               *insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
>> +#endif
>> +               break;
>> +
>
> [...]
