Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACD422225D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 14:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgGPMcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 08:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgGPMcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 08:32:50 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE3DC061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 05:32:49 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id r19so6866552ljn.12
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 05:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=21RA+e4Ong/tEdD67nzo1deHFqPTX09b755P7erQrVw=;
        b=q5JqW/m2Mm0DQZPnCTMK4hceDumfvX36K/sUPOlIJ3Ztu0krN7gT98EVc9kWyZFlgi
         WcRA30uFbFfvJ4keeMcS54Qf7G6rHBEO000FyaVf+9QGPcu+Q6GmsLDHTY3rRVQtqpem
         6NcCwGBjVNgV1I48rk4K+7z5oQRxWXTZU/Swo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=21RA+e4Ong/tEdD67nzo1deHFqPTX09b755P7erQrVw=;
        b=JEJl/LKoJrAI/ZuZGKDi4s0ndjyH07SWoaIY7RmHBFq+gjlYxeKB8BKCC/dQWJVwyr
         Mcwk7AbLlTnZ5v0vxV3j3ZY8nsmKVEJpDuOvJJhkSAKiZfxvDh9ouC4c2OEsBw4bp3gv
         MjEBonS26Pu3hjcr0qca7hSMFu4twyL/FmrU4zI+mlXunNd2RB9WhNCunhS8vphjfKat
         P9ukRs4Y499CUWbKq4sX9Z9GpQ9EYAPl2Er+4VGOZ01dH9oN23WR9ocUtElcYSz/8jrL
         YqUAycihgUnkPNqG3dmCQoa1dugKT3WhXdb36c8w47d4raUNJs+AYdo0DCIdeW0NCBqh
         td7g==
X-Gm-Message-State: AOAM531sr5ewIDjnGdsWaidUmbJ7SUr4eYQ7J1n+KPwcc3B446RD0+FY
        c1cDsziJtV5JyIPP43yrRIwNMA==
X-Google-Smtp-Source: ABdhPJwQVq+YukWG7I51hGixTG2HbtBNWskpJWU/vmOkgH8wJskFdoy3gEPPbm8BLGClETOJ/bWeFQ==
X-Received: by 2002:a2e:9f4d:: with SMTP id v13mr1872162ljk.122.1594902767506;
        Thu, 16 Jul 2020 05:32:47 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id i10sm1017855ljg.80.2020.07.16.05.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 05:32:46 -0700 (PDT)
References: <20200713174654.642628-1-jakub@cloudflare.com> <20200713174654.642628-5-jakub@cloudflare.com> <CAEf4BzY0Gc_FH=KUWY3xz6qG8yk+0U0mjXcAx7+39tWt_kQnGQ@mail.gmail.com>
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
Subject: Re: [PATCH bpf-next v4 04/16] inet: Run SK_LOOKUP BPF program on socket lookup
In-reply-to: <CAEf4BzY0Gc_FH=KUWY3xz6qG8yk+0U0mjXcAx7+39tWt_kQnGQ@mail.gmail.com>
Date:   Thu, 16 Jul 2020 14:32:45 +0200
Message-ID: <875zany70y.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 04:23 AM CEST, Andrii Nakryiko wrote:
> On Mon, Jul 13, 2020 at 10:47 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Run a BPF program before looking up a listening socket on the receive path.
>> Program selects a listening socket to yield as result of socket lookup by
>> calling bpf_sk_assign() helper and returning SK_PASS code. Program can
>> revert its decision by assigning a NULL socket with bpf_sk_assign().
>>
>> Alternatively, BPF program can also fail the lookup by returning with
>> SK_DROP, or let the lookup continue as usual with SK_PASS on return, when
>> no socket has not been selected with bpf_sk_assign(). Other return values
>
> you probably meant "no socket has been selected"?

Yes, a typo. Will fix.

>
>> are treated the same as SK_DROP.
>
>
> Why not enforce it instead? Check check_return_code() in verifier.c,
> it's trivial to do it for SK_LOOKUP.

That's a game changer D-: Thank you. This will simplify the prog
runners.

>
>
>>
>> This lets the user match packets with listening sockets freely at the last
>> possible point on the receive path, where we know that packets are destined
>> for local delivery after undergoing policing, filtering, and routing.
>>
>> With BPF code selecting the socket, directing packets destined to an IP
>> range or to a port range to a single socket becomes possible.
>>
>> In case multiple programs are attached, they are run in series in the order
>> in which they were attached. The end result is determined from return codes
>> of all the programs according to following rules:
>>
>>  1. If any program returned SK_PASS and selected a valid socket, the socket
>>     is used as result of socket lookup.
>>  2. If more than one program returned SK_PASS and selected a socket,
>>     last selection takes effect.
>>  3. If any program returned SK_DROP or an invalid return code, and no
>>     program returned SK_PASS and selected a socket, socket lookup fails
>>     with -ECONNREFUSED.
>>  4. If all programs returned SK_PASS and none of them selected a socket,
>>     socket lookup continues to htable-based lookup.
>>
>> Suggested-by: Marek Majkowski <marek@cloudflare.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>
>> Notes:
>>     v4:
>>     - Reduce BPF sk_lookup prog return codes to SK_PASS/SK_DROP. (Lorenz)
>
> your description above still assumes prog can return something besides
> SK_PASS and SK_DROP?

I should have written 'reduce allowed prog return codes'.

>
>>     - Default to drop & warn on illegal return value from BPF prog. (Lorenz)
>>     - Rename netns_bpf_attach_type_enable/disable to _need/unneed. (Lorenz)
>>     - Export bpf_sk_lookup_enabled symbol for CONFIG_IPV6=m (kernel test robot)
>>     - Invert return value from bpf_sk_lookup_run_v4 to true on skip reuseport.
>>     - Move dedicated prog_array runner close to its callers in filter.h.
>>
>>     v3:
>>     - Use a static_key to minimize the hook overhead when not used. (Alexei)
>>     - Adapt for running an array of attached programs. (Alexei)
>>     - Adapt for optionally skipping reuseport selection. (Martin)
>>
>>  include/linux/filter.h     | 102 +++++++++++++++++++++++++++++++++++++
>>  kernel/bpf/net_namespace.c |  32 +++++++++++-
>>  net/core/filter.c          |   3 ++
>>  net/ipv4/inet_hashtables.c |  31 +++++++++++
>>  4 files changed, 167 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/filter.h b/include/linux/filter.h
>> index 380746f47fa1..b9ad0fdabca5 100644
>> --- a/include/linux/filter.h
>> +++ b/include/linux/filter.h
>> @@ -1295,4 +1295,106 @@ struct bpf_sk_lookup_kern {
>>         bool            no_reuseport;
>>  };
>>
>> +extern struct static_key_false bpf_sk_lookup_enabled;
>> +
>> +/* Runners for BPF_SK_LOOKUP programs to invoke on socket lookup.
>> + *
>> + * Allowed return values for a BPF SK_LOOKUP program are SK_PASS and
>> + * SK_DROP. Any other return value is treated as SK_DROP. Their
>> + * meaning is as follows:
>> + *
>> + *  SK_PASS && ctx.selected_sk != NULL: use selected_sk as lookup result
>> + *  SK_PASS && ctx.selected_sk == NULL: continue to htable-based socket lookup
>> + *  SK_DROP                           : terminate lookup with -ECONNREFUSED
>> + *
>> + * This macro aggregates return values and selected sockets from
>> + * multiple BPF programs according to following rules:
>> + *
>> + *  1. If any program returned SK_PASS and a non-NULL ctx.selected_sk,
>> + *     macro result is SK_PASS and last ctx.selected_sk is used.
>> + *  2. If any program returned non-SK_PASS return value,
>> + *     macro result is the last non-SK_PASS return value.
>> + *  3. Otherwise result is SK_PASS and ctx.selected_sk is NULL.
>> + *
>> + * Caller must ensure that the prog array is non-NULL, and that the
>> + * array as well as the programs it contains remain valid.
>> + */
>> +#define BPF_PROG_SK_LOOKUP_RUN_ARRAY(array, ctx, func)                 \
>> +       ({                                                              \
>> +               struct bpf_sk_lookup_kern *_ctx = &(ctx);               \
>> +               struct bpf_prog_array_item *_item;                      \
>> +               struct sock *_selected_sk;                              \
>> +               struct bpf_prog *_prog;                                 \
>> +               u32 _ret, _last_ret;                                    \
>> +               bool _no_reuseport;                                     \
>> +                                                                       \
>> +               migrate_disable();                                      \
>> +               _last_ret = SK_PASS;                                    \
>> +               _selected_sk = NULL;                                    \
>> +               _no_reuseport = false;                                  \
>
> these three could be moved before migrate_disable(), or even better
> just initialize corresponding variables above?

I was torn between keeping all info needed to read through the loop
close to it and keeping the critical section tight. I can move it up.

>
>
>> +               _item = &(array)->items[0];                             \
>> +               while ((_prog = READ_ONCE(_item->prog))) {              \
>> +                       /* restore most recent selection */             \
>> +                       _ctx->selected_sk = _selected_sk;               \
>> +                       _ctx->no_reuseport = _no_reuseport;             \
>> +                                                                       \
>> +                       _ret = func(_prog, _ctx);                       \
>> +                       if (_ret == SK_PASS) {                          \
>> +                               /* remember last non-NULL socket */     \
>> +                               if (_ctx->selected_sk) {                \
>> +                                       _selected_sk = _ctx->selected_sk;       \
>> +                                       _no_reuseport = _ctx->no_reuseport;     \
>> +                               }                                       \
>> +                       } else {                                        \
>> +                               /* remember last non-PASS ret code */   \
>> +                               _last_ret = _ret;                       \
>> +                       }                                               \
>> +                       _item++;                                        \
>> +               }                                                       \
>> +               _ctx->selected_sk = _selected_sk;                       \
>> +               _ctx->no_reuseport = _no_reuseport;                     \
>> +               migrate_enable();                                       \
>> +               _ctx->selected_sk ? SK_PASS : _last_ret;                \
>> +        })
>> +
>
> [...]
