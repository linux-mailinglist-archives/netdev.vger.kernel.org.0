Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAAE222CA0
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbgGPUTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:19:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43150 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728788AbgGPUTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:19:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594930752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oAKhQEv8kqbTsiiO7GkkYrOtrj4zaX5iatFNWMQEm90=;
        b=fzA2N4E1LSH1A0VivB1168wBgP/m1Hl++TnIZjvkUHxSzijHOxPAEH2d+UXqWPYu1gF9ob
        y3Sa2DK8/nbrWyeyJYpFfpTM3VC3SQXkCxc0WJ6oULgceI+oI16PBMRbpZCy1Shmlm+eWg
        2bLg9YKfhYT4F3XG133/fU9QJKFht+Q=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-8zMbGokYNpSux6hUYS8hTw-1; Thu, 16 Jul 2020 16:19:10 -0400
X-MC-Unique: 8zMbGokYNpSux6hUYS8hTw-1
Received: by mail-pf1-f197.google.com with SMTP id i9so5273399pfu.12
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 13:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=oAKhQEv8kqbTsiiO7GkkYrOtrj4zaX5iatFNWMQEm90=;
        b=q23185mBuxIcsb63J4U/Hgg3yJRs09BK6aHxT+rE28m8h+mNvXtcqBplSPUdLS0i9k
         5b67Ga2FgHG1C+pbTtnzTwcrPWVWf4ePX2s/Rz9MLRpTLvCkd26Re9zkaAmdUNJfY4A/
         bGgYTVegclre2URipfyvqcTrAZcadepK5e/Fa/1HBRPcxqJkkCvH+XVQsOlc8zyQl24W
         D3Xx65YWK6v/sfNoB8rGgzIUeYwdtF3pN9yTI0CVTYo3jpwL23JvgnpJylCsiE6Ev2/n
         3m712C8DzNhw5CwQGeq1IXwhr7uxJ2e/qPy9d4rO0sNCB00q3uKxWoC+qcwFVyVwcunW
         qYIg==
X-Gm-Message-State: AOAM530mf+vgStOdHtsRufSNlJQq97yS6Qx11tqpWxG44FUMe35kcxKa
        Cd7nRpOHMo5h8b175QIzF38e3L/zwWluDjCQnuXLR64nEsPGP13MyWsxtT4wJU/Z2XhzeX9Farx
        kbGCVbDNkwZjeFTve
X-Received: by 2002:a62:7505:: with SMTP id q5mr4749121pfc.262.1594930749911;
        Thu, 16 Jul 2020 13:19:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQJAqwU80lmN2Fr6gcy27CcYUXMipS5Iggux57Bh9ZVxocDdGvGYaJ0/SXRyKkI5o9gsIdhw==
X-Received: by 2002:a62:7505:: with SMTP id q5mr4749096pfc.262.1594930749659;
        Thu, 16 Jul 2020 13:19:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id gn5sm787181pjb.23.2020.07.16.13.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:19:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8F77E181719; Thu, 16 Jul 2020 22:19:03 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Blake Matheny <bmatheny@fb.com>
Subject: Re: BPF logging infrastructure. Was: [PATCH bpf-next 4/6] tools: add new members to bpf_attr.raw_tracepoint in bpf.h
In-Reply-To: <CAEf4BzbiD9Cuqip2=FGHGHLZs-7b8AziS-hJOpX1HuONTM4udQ@mail.gmail.com>
References: <CAEf4BzZ_-vXP_3hSEjuceW10VX_H+EeuXMiV=_meBPZn7izK8A@mail.gmail.com> <87r1tegusj.fsf@toke.dk> <CAEf4Bzbu1wnwWFOWYA3e6KFeSmfg8oANPWD9LsUMRy2E_zrQ0w@mail.gmail.com> <87pn8xg6x7.fsf@toke.dk> <CAEf4BzYAoetyfyofTX45RQjtz3M-c9=YNeH1uRDbYgK4Ae0TwA@mail.gmail.com> <87d04xg2p4.fsf@toke.dk> <20200714231133.ap5qnalf6moptvfk@ast-mbp.dhcp.thefacebook.com> <874kq9ey2j.fsf@toke.dk> <20200715234123.rr7oj74t5hflzmsn@ast-mbp.dhcp.thefacebook.com> <CAEf4BzbodR-+=Q3wRE2UaiouBexvqfwpE-zJGm4Rr1cV2dgZHQ@mail.gmail.com> <20200716054408.so34cuc2g2iqcppr@ast-mbp.dhcp.thefacebook.com> <CAEf4BzbiD9Cuqip2=FGHGHLZs-7b8AziS-hJOpX1HuONTM4udQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 16 Jul 2020 22:19:03 +0200
Message-ID: <87wo33cix4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

>> So myself and Toke are wearing 'bpf user' hat in that context.
>> Both of us indicated that libbpf output is too verbose.
>> Your response "just send a patch" is a sure way to turn away more users.
>>
>
> I can't find any such complaint from Toke in this thread, and can't
> really recall something like that from recent discussions. I'd rather
> have him speak for himself.

I think what I said (not in this thread, way back during some other
discussion) was that I agreed that libbpf was being too verbose by
dumping all the sections and relocations it finds when reading an ELF
file, which causes the useful error messages to get lost. I would like
to see those messages demoted to another log level, or removed
altogether.

I won't have time to look more at this right now, but I do plan to
circle back to it: I agree with you that we need to make this more
friendly. And yes, I also think this should include finding a way to
disambiguate between different conditions leading to the same error from
the kernel. I've run into a lot of the same issues as you when
supporting people who are new to BPF - thank you for the extensive list!

-Toke

