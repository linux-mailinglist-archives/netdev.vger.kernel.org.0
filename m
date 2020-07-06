Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4521621564B
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 13:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgGFLZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 07:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728738AbgGFLZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 07:25:04 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D35C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 04:25:03 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id q4so9094583lji.2
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 04:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=uvjy6TQw4BzmhpYm8sKke8+oa4SeXvV80srNJ1pxzBM=;
        b=wE4ZoJI0Wa20MnwOtb4Mb97jm90seDCaqKaJWq5waebC75dAHt0mW+CJ3qrY2XZobm
         jdeIRJnSJlbj0b9ub87VirYe0xU/P7VsquePEYHeTgefv1id4GihqoSirDZteVa6g1r1
         SWBWyQF0JJM9ZAOD1hfB33oDNJvatVM7xf4jU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=uvjy6TQw4BzmhpYm8sKke8+oa4SeXvV80srNJ1pxzBM=;
        b=k1wAKLu//OF0HavjfRIoUK0+B2mUnH3x/BDJLnAvBn7oKo1aV5X//vfiicMF9MG6/1
         cS3j2Tm4AvDz6+/5GamrtSgCMKiz//L6pK4T9Wk69ImHbE2UaComy6+7pH3lk6E6cGhe
         pW9Iq0lDU+LSGHQXlZac/90zx29V9uKqN6iCDQrdfz1o8Md4wurilOM5QTJSErWr9gYE
         maE3DfI1ioxTexwLvvPZQADJXkA/thkL7ue8/TlZmSfEfYDJ+M5uaEA2+uxL06g4GrLK
         x09MSyiarcbHpgQW9vBmDc9bvxvsQRjlwv1InQnDZMt5ZBeZpxNeaRIaYKLgh1mfpcU6
         E+lw==
X-Gm-Message-State: AOAM532OJLABO1uxtyDxPs3r6KheNcZLQZDx9blGuMEupaCS7r9dUcF2
        c9/zaV4tvYy4n1zAQbgpQahVYg==
X-Google-Smtp-Source: ABdhPJwr+j4Vg2Avgd+1vx/ZdU7eaZPJNeYx9LviwOJHQRjWclCi0PlzWGiAw3fJiMrxlhrL+XfmnQ==
X-Received: by 2002:a2e:984e:: with SMTP id e14mr14411490ljj.169.1594034702088;
        Mon, 06 Jul 2020 04:25:02 -0700 (PDT)
Received: from cloudflare.com (apn-31-0-46-84.dynamic.gprs.plus.pl. [31.0.46.84])
        by smtp.gmail.com with ESMTPSA id d6sm7789132lja.77.2020.07.06.04.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 04:25:01 -0700 (PDT)
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-5-jakub@cloudflare.com> <CACAyw9-6OCPqg3eoPOPeKYy=kBNVJT8-qbLh6QOo=8aEV6pWjw@mail.gmail.com> <87mu4inky6.fsf@cloudflare.com> <CACAyw98MsdcVkFPpXatr3F6j6F79KuTqcpwpB6TNpLBVuGKJTQ@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 04/16] inet: Run SK_LOOKUP BPF program on socket lookup
In-reply-to: <CACAyw98MsdcVkFPpXatr3F6j6F79KuTqcpwpB6TNpLBVuGKJTQ@mail.gmail.com>
Date:   Mon, 06 Jul 2020 13:24:59 +0200
Message-ID: <87k0zgj378.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 03:19 PM CEST, Lorenz Bauer wrote:
> On Thu, 2 Jul 2020 at 13:46, Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> On Thu, Jul 02, 2020 at 12:27 PM CEST, Lorenz Bauer wrote:
>> > On Thu, 2 Jul 2020 at 10:24, Jakub Sitnicki <jakub@cloudflare.com> wrote:
>> >>
>> >> Run a BPF program before looking up a listening socket on the receive path.
>> >> Program selects a listening socket to yield as result of socket lookup by
>> >> calling bpf_sk_assign() helper and returning BPF_REDIRECT (7) code.
>> >>
>> >> Alternatively, program can also fail the lookup by returning with
>> >> BPF_DROP (1), or let the lookup continue as usual with BPF_OK (0) on
>> >> return. Other return values are treated the same as BPF_OK.
>> >
>> > I'd prefer if other values were treated as BPF_DROP, with other semantics
>> > unchanged. Otherwise we won't be able to introduce new semantics
>> > without potentially breaking user code.
>>
>> That might be surprising or even risky. If you attach a badly written
>> program that say returns a negative value, it will drop all TCP SYNs and
>> UDP traffic.
>
> I think if you do that all bets are off anyways. No use in trying to stagger on.
> Being stricter here will actually make it easier to for a developer to ensure
> that their program is doing the right thing.
>
> My point about future extensions also still stands.

We've chatted with Lorenz off-list about pros & cons of defaulting to
drop on illegal return code from a BPF program.

On the upside, it is consistent with XDP, SK_REUSEPORT, and SK_SKB
(sockmap) program types.

TC BPF ignores illegal return values, unspecified action means no
action, so no drop. While CGROUP_INET_INGRESS and SOCKET_FILTER look
only at the lowest bit ("ret & 1"), so it is a roulette.

Then there is also the extensibility argument. If we allow traffic to
pass to regular socket lookup on illegal return code from BPF, and users
start to rely on that, then it will be hard or impossible to repurpose
an illegal return value for something else.

Downside of defaulting to drop is that you can accidentally lock
yourself out, e.g. lose SSH access, by attaching a buggy program.


Being consistent with other existing program types is what convinces me
most to set default to drop, so I'll make the change in v4 unless there
are objections.

[...]
