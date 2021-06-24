Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E323B2DD7
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 13:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbhFXLaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 07:30:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232274AbhFXLaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 07:30:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624534071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nF0UhK3Tr0u38x+8i/4+COM0eyWxjXZTlIH47kl0kH4=;
        b=IkOiiLYHdJ926NxhcdHBdNGj0Vm6ugNoKZIA6h52fVQ8uVwQvrfIDCoWP9LRtruPCasEpV
        jOaul/L9MQh7i9atDO2Nq/86Tf3po/g3q8BlgjHlvyDuc3XcIbYWxnTDYdI6QBqnLSfrHB
        kLF+c4C2S0XujG0RLkhUTI3t5x4YQJo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-UWkc9ZePN-yG1MJ8v02TkQ-1; Thu, 24 Jun 2021 07:27:50 -0400
X-MC-Unique: UWkc9ZePN-yG1MJ8v02TkQ-1
Received: by mail-ed1-f72.google.com with SMTP id h11-20020a50ed8b0000b02903947b9ca1f3so3187138edr.7
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:27:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=nF0UhK3Tr0u38x+8i/4+COM0eyWxjXZTlIH47kl0kH4=;
        b=ARyycvXRt0NsjEa1waaR6Y4kIZc+rlE6f2ZFzCgh+YbK1BQQroKElBubB9rzCfbT1F
         DOXNbEVV+6SBZwwKfwftt4ttu3S4DI/VgPQlYvbDQlJ2zmB27hACxLL2AV1HgjzF/CWd
         2yV5y5c8oGPtZyEJopp5SMa7zsn1IYiYXR5Ao1xZzQbl1qLEmjjNOSlwqsdr79GyiGgy
         RqSWf+H+2IX9/q/2RKLKMjYrWrl1QIpVJpVuBqWkYa8qHnEtTiuyAzSe65XXiHr50moD
         MZh2EgzkOSIPMo2rStKmRGNgxGpvmCCS1nbF9yntIHWL/cZ4/2VRVZ3lXwFdpaRPf3gA
         jXdw==
X-Gm-Message-State: AOAM531FzO8ULlynDMvt8/EVd+ch3oyTd9hCgz0WWpo2nXyyfiM5xth4
        NV2Sp6iHCa+3h4+vdWUtQ6Zyg8IW/NFQ6NIjWiZyRZ45zVUDWILMPbGzHzDrn0AsX4xuEww70jM
        XOY9zGaZZwN/tewZB
X-Received: by 2002:a17:906:ece7:: with SMTP id qt7mr4739840ejb.194.1624534068545;
        Thu, 24 Jun 2021 04:27:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiLkvv03dVbfxeXKIcI4MYuF7i/8ki5PwPd50/nXmW14AjctDZNd1qFBIZiijPXQNi2b5oWA==
X-Received: by 2002:a17:906:ece7:: with SMTP id qt7mr4739802ejb.194.1624534067984;
        Thu, 24 Jun 2021 04:27:47 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id cn10sm1789326edb.38.2021.06.24.04.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 04:27:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C90EB180731; Thu, 24 Jun 2021 13:27:46 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 0/8] bpf: Introduce BPF timers.
In-Reply-To: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 24 Jun 2021 13:27:46 +0200
Message-ID: <87sg17mril.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> From: Alexei Starovoitov <ast@kernel.org>
>
> The first request to support timers in bpf was made in 2013 before sys_bp=
f syscall
> was added. That use case was periodic sampling. It was address with attac=
hing
> bpf programs to perf_events. Then during XDP development the timers were =
requested
> to do garbage collection and health checks. They were worked around by im=
plementing
> timers in user space and triggering progs with BPF_PROG_RUN command.
> The user space timers and perf_event+bpf timers are not armed by the bpf =
program.
> They're done asynchronously vs program execution. The XDP program cannot =
send a
> packet and arm the timer at the same time. The tracing prog cannot record=
 an
> event and arm the timer right away. This large class of use cases remained
> unaddressed. The jiffy based and hrtimer based timers are essential part =
of the
> kernel development and with this patch set the hrtimer based timers will =
be
> available to bpf programs.
>
> TLDR: bpf timers is a wrapper of hrtimers with all the extra safety added
> to make sure bpf progs cannot crash the kernel.
>
> v2->v3:
> The v2 approach attempted to bump bpf_prog refcnt when bpf_timer_start is
> called to make sure callback code doesn't disappear when timer is active =
and
> drop refcnt when timer cb is done. That led to a ton of race conditions b=
etween
> callback running and concurrent bpf_timer_init/start/cancel on another cp=
u,
> and concurrent bpf_map_update/delete_elem, and map destroy.
>
> Then v2.5 approach skipped prog refcnt altogether. Instead it remembered =
all
> timers that bpf prog armed in a link list and canceled them when prog ref=
cnt
> went to zero. The race conditions disappeared, but timers in map-in-map c=
ould
> not be supported cleanly, since timers in inner maps have inner map's lif=
e time
> and don't match prog's life time.
>
> This v3 approach makes timers to be owned by maps. It allows timers in in=
ner
> maps to be supported from the start. This apporach relies on "user refcnt"
> scheme used in prog_array that stores bpf programs for bpf_tail_call. The
> bpf_timer_start() increments prog refcnt, but unlike 1st approach the tim=
er
> callback does decrement the refcnt. The ops->map_release_uref is
> responsible for cancelling the timers and dropping prog refcnt when user =
space
> reference to a map is dropped. That addressed all the races and simplified
> locking.

Great to see this! I missed v2, but the "owned by map + uref" approach
makes sense.

For the series:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

