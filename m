Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD7721B1C4
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 10:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgGJIz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 04:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbgGJIz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 04:55:57 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCF1C08C5CE
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 01:55:57 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id c11so2769870lfh.8
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 01:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=QccdIZKRXUqOaE8BtOB8jfCZKEDsRDKoroB6FCGuL50=;
        b=JGtpL0HJhef3NnGqn75JQI2adHAjHJ48cCk8icUZo/9kjmekmPUI/d+5i3BBOLjKB2
         9XoqMqBfllKXh7VjvGobE+pFFUql+ZG2zYh95u0+l0TS/8xa5JUZ3x3YEmOeb0Z0OaTY
         l4rhTR8j5eEYtY+9ul7fZ8ZuTlVJI9N6/Ct7Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=QccdIZKRXUqOaE8BtOB8jfCZKEDsRDKoroB6FCGuL50=;
        b=dngQvWnCTtcemprbLCVgtPVQOfGsjQMIcdDGX05N5DJMQ4+InO4D4eJP3EnSnualln
         fwEVayJuYDh4z/S/tNU2hLvocmw42Wm/hngLbz4pILCyVXJ11K/H9zTPY8CFF+gvS7m3
         wyMN5vNttt8ilIz87ygvoQ7pnszBKatwBXs6YW4U/po5Uq1aqOvaMkF2692wkZiO9NAF
         YKo2n3+mQLWxy5FZ6KTv6yXO7oQOcR9n0IHNRgC4L5El6sEuIxygOe11emZGyEnHB7ZR
         moMadvZPxy4/zW/ulh9ZTQeA4aFcQ/LZJe7qZ3aLfkOWlTM4F7bLHaPC65EWRu7jjbsr
         j1XA==
X-Gm-Message-State: AOAM531GdDGwt+thrx8L90lpqEfigueUdmYc2fEFNpbvs1Kv4S1sFXHb
        0NbhWH22RS6orwUnT85g64O06g==
X-Google-Smtp-Source: ABdhPJwGqa/r8/8mhRGEbPQih2JFWDEZEIcqG8/4L6auWAmXlkYT6pzEudAuSm9BX6KdKsACHdwH5A==
X-Received: by 2002:a05:6512:3153:: with SMTP id s19mr30319594lfi.25.1594371355292;
        Fri, 10 Jul 2020 01:55:55 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id e16sm1698904ljn.12.2020.07.10.01.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 01:55:54 -0700 (PDT)
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-3-jakub@cloudflare.com> <CAEf4BzZ7-0TFD4+NqpK9X=Yuiem89Ug27v90fev=nn+3anCTpA@mail.gmail.com> <87imewakhz.fsf@cloudflare.com> <CAEf4Bza7URA60jnLJsPV__PwmhV8G8+cCihdqqsKDSdQ1CYr_w@mail.gmail.com>
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
Subject: Re: [PATCH bpf-next v3 02/16] bpf: Introduce SK_LOOKUP program type with a dedicated attach point
In-reply-to: <CAEf4Bza7URA60jnLJsPV__PwmhV8G8+cCihdqqsKDSdQ1CYr_w@mail.gmail.com>
Date:   Fri, 10 Jul 2020 10:55:53 +0200
Message-ID: <87blknagva.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 01:09 AM CEST, Andrii Nakryiko wrote:
> On Thu, Jul 9, 2020 at 6:25 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> On Thu, Jul 09, 2020 at 06:08 AM CEST, Andrii Nakryiko wrote:
>> > On Thu, Jul 2, 2020 at 2:25 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>> >>
>> >> Add a new program type BPF_PROG_TYPE_SK_LOOKUP with a dedicated attach type
>> >> BPF_SK_LOOKUP. The new program kind is to be invoked by the transport layer
>> >> when looking up a listening socket for a new connection request for
>> >> connection oriented protocols, or when looking up an unconnected socket for
>> >> a packet for connection-less protocols.
>> >>
>> >> When called, SK_LOOKUP BPF program can select a socket that will receive
>> >> the packet. This serves as a mechanism to overcome the limits of what
>> >> bind() API allows to express. Two use-cases driving this work are:
>> >>
>> >>  (1) steer packets destined to an IP range, on fixed port to a socket
>> >>
>> >>      192.0.2.0/24, port 80 -> NGINX socket
>> >>
>> >>  (2) steer packets destined to an IP address, on any port to a socket
>> >>
>> >>      198.51.100.1, any port -> L7 proxy socket
>> >>
>> >> In its run-time context program receives information about the packet that
>> >> triggered the socket lookup. Namely IP version, L4 protocol identifier, and
>> >> address 4-tuple. Context can be further extended to include ingress
>> >> interface identifier.
>> >>
>> >> To select a socket BPF program fetches it from a map holding socket
>> >> references, like SOCKMAP or SOCKHASH, and calls bpf_sk_assign(ctx, sk, ...)
>> >> helper to record the selection. Transport layer then uses the selected
>> >> socket as a result of socket lookup.
>> >>
>> >> This patch only enables the user to attach an SK_LOOKUP program to a
>> >> network namespace. Subsequent patches hook it up to run on local delivery
>> >> path in ipv4 and ipv6 stacks.
>> >>
>> >> Suggested-by: Marek Majkowski <marek@cloudflare.com>
>> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> >> ---
>> >>
>> >> Notes:
>> >>     v3:
>> >>     - Allow bpf_sk_assign helper to replace previously selected socket only
>> >>       when BPF_SK_LOOKUP_F_REPLACE flag is set, as a precaution for multiple
>> >>       programs running in series to accidentally override each other's verdict.
>> >>     - Let BPF program decide that load-balancing within a reuseport socket group
>> >>       should be skipped for the socket selected with bpf_sk_assign() by passing
>> >>       BPF_SK_LOOKUP_F_NO_REUSEPORT flag. (Martin)
>> >>     - Extend struct bpf_sk_lookup program context with an 'sk' field containing
>> >>       the selected socket with an intention for multiple attached program
>> >>       running in series to see each other's choices. However, currently the
>> >>       verifier doesn't allow checking if pointer is set.
>> >>     - Use bpf-netns infra for link-based multi-program attachment. (Alexei)
>> >>     - Get rid of macros in convert_ctx_access to make it easier to read.
>> >>     - Disallow 1-,2-byte access to context fields containing IP addresses.
>> >>
>> >>     v2:
>> >>     - Make bpf_sk_assign reject sockets that don't use RCU freeing.
>> >>       Update bpf_sk_assign docs accordingly. (Martin)
>> >>     - Change bpf_sk_assign proto to take PTR_TO_SOCKET as argument. (Martin)
>> >>     - Fix broken build when CONFIG_INET is not selected. (Martin)
>> >>     - Rename bpf_sk_lookup{} src_/dst_* fields remote_/local_*. (Martin)
>> >>     - Enforce BPF_SK_LOOKUP attach point on load & attach. (Martin)
>> >>
>> >>  include/linux/bpf-netns.h  |   3 +
>> >>  include/linux/bpf_types.h  |   2 +
>> >>  include/linux/filter.h     |  19 ++++
>> >>  include/uapi/linux/bpf.h   |  74 +++++++++++++++
>> >>  kernel/bpf/net_namespace.c |   5 +
>> >>  kernel/bpf/syscall.c       |   9 ++
>> >>  net/core/filter.c          | 186 +++++++++++++++++++++++++++++++++++++
>> >>  scripts/bpf_helpers_doc.py |   9 +-
>> >>  8 files changed, 306 insertions(+), 1 deletion(-)
>> >>
>>
>> [...]
>>
>> >> +
>> >> +static u32 sk_lookup_convert_ctx_access(enum bpf_access_type type,
>> >> +                                       const struct bpf_insn *si,
>> >> +                                       struct bpf_insn *insn_buf,
>> >> +                                       struct bpf_prog *prog,
>> >> +                                       u32 *target_size)
>> >
>> > Would it be too extreme to rely on BTF and direct memory access
>> > (similar to tp_raw, fentry/fexit, etc) for accessing context fields,
>> > instead of all this assembly rewrites? So instead of having
>> > bpf_sk_lookup and bpf_sk_lookup_kern, it will always be a full variant
>> > (bpf_sk_lookup_kern, or however we'd want to name it then) and
>> > verifier will just ensure that direct memory reads go to the right
>> > field boundaries?
>>
>> Sounds like a decision related to long-term vision. I'd appreciate input
>> from maintainers if this is the direction we want to go in.
>>
>> From implementation PoV - hard for me to say what would be needed to get
>> it working, I'm not familiar how BPF_TRACE_* attach types provide access
>> to context, so I'd need to look around and prototype it
>> first. (Actually, I'm not sure if you're asking if it is doable or you
>> already know?)
>
> I'm pretty sure it's doable with what we have in verifier, but I'm not
> sure about all the details and amount of work. So consider this an
> initiation of a medium-term discussion. I was also curious to hear an
> opinion from Alexei and Daniel whether that's would be the right way
> to do this moving forward (not necessarily with your changes, though).

From my side I can vouch that getting convert_ctx_access is not easy to
get right (at least for me) when backing structure is non-trivial,
e.g. has pointers or unions.

v4 will contain two fixes exactly in this area. I also have a patch for
how verifier handles narrow loads when load size <= target field size <
ctx field size.

That is to say, any alternative approach that "automates" this would be
very welcome.

I've accumulated quite a few changes already since v3, so I was planning
to roll out v4 to keep things moving while we continue the discussion.

>
>>
>> Off the top of my head, I have one concern, I'm exposing the selected
>> socket in the context. This is for the benefit of one program being
>> aware of other program's selection, if multiple programs are attached.
>>
>> I understand that any piece of data reachable from struct sock *, would
>> be readable by SK_LOOKUP prog (writes can be blocked in
>> is_valid_access). And that this is a desired property for tracing. Not
>> sure how to limit it for a network program that doesn't need all that
>> info.
>>
>> >
>> >> +{
>> >> +       struct bpf_insn *insn = insn_buf;
>> >> +#if IS_ENABLED(CONFIG_IPV6)
>> >> +       int off;
>> >> +#endif
>> >> +
>> >
>> > [...]
