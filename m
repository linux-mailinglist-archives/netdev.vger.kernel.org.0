Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9275122711
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 09:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfLQIwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 03:52:18 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27857 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725893AbfLQIwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 03:52:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576572737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2sfzAo5vBd9xBpXpg/m9erufLQX8/hEzWPbggzsXBlI=;
        b=VKxGnrn2+qDzo+YDMV0cVaQQPIiEKaQP0qyMIzUdQYW/mk70xd+8oTXChY34WrBRlZSwas
        ef9jstSpZwuSmmpu6bOWp59DzdjoNMUWwKJ3iuX3X8xNO2TTnqcc6ZcFGfI6GH22EoVlmY
        m5oIT2z6CyD/Drx6/7N2cTPSRAtyA9Y=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345--pXWUwygMsao1O0UKwllbA-1; Tue, 17 Dec 2019 03:52:06 -0500
X-MC-Unique: -pXWUwygMsao1O0UKwllbA-1
Received: by mail-lf1-f70.google.com with SMTP id z3so927773lfq.22
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 00:52:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=2sfzAo5vBd9xBpXpg/m9erufLQX8/hEzWPbggzsXBlI=;
        b=Iqm/DiHqskw0g2xmM7JZv3cwhoVmwHOHLPlDXRYgPmgFakf/X8hW+DUG13Zr+JnPLy
         VAF2JfsWNvfdSYTwW7WFLi/8guQAV3ZtMQ2CyTE+CaA8b/m+G0Orh8fDKB1oD6M3ym+j
         XqduDgUi5xlGqY9TWKkE/Ji5da/eBOB9RgmGv0gmDYrZQXhPkCLz01OSvmhU/tyz4P54
         6j7NEhbSm9AHhjidJO53OgI6YSbap2/wt1fhdyrbVF7A5ZuhWOSdA9A4dsXlTPd/DQU1
         SNrMhoY8ctDow/HeFV8QmujzK9es4Idz0E34eXoatrZpiGBZBfDkK6PJz/sxL02z39bo
         Yspg==
X-Gm-Message-State: APjAAAWCXzoCWARKHcE8GMzXhe9IqymQr+J8vrjrcjR5MYm5RctkJz9/
        Y1F4rZ/Y6bwS7RNJduxGdGtIjsXS16RpHJ4+rCFXfx/VNguL3cf1Pr9RSuDZsWiypioQteIFqV/
        jhTb3SsrL1VuS4NeK
X-Received: by 2002:ac2:4c98:: with SMTP id d24mr2006033lfl.138.1576572724916;
        Tue, 17 Dec 2019 00:52:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqzUTXfP3gC+bSm0puS7McJoc6U2zWJVUpu+u+gPeGHHrQPXQVoIPgkHXF9gVHxdF264lxcjbw==
X-Received: by 2002:ac2:4c98:: with SMTP id d24mr2006024lfl.138.1576572724703;
        Tue, 17 Dec 2019 00:52:04 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i2sm10308240lfl.20.2019.12.17.00.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 00:52:04 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0265C1800B3; Tue, 17 Dec 2019 09:52:02 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?utf-8?B?QmrDtnJu?= =?utf-8?B?IFTDtnBlbA==?= 
        <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [RFC PATCH bpf-next] xdp: Add tracepoint on XDP program return
In-Reply-To: <20191217005944.s3mayy473ldlnldl@ast-mbp.dhcp.thefacebook.com>
References: <20191216152715.711308-1-toke@redhat.com> <CAJ+HfNhYG_hzuFzX5sAH7ReotLtZWTP_9D2jA_iVMg+jUtXXCw@mail.gmail.com> <20191217005944.s3mayy473ldlnldl@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 17 Dec 2019 09:52:02 +0100
Message-ID: <87h81z8hcd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Mon, Dec 16, 2019 at 07:17:59PM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
>> On Mon, 16 Dec 2019 at 16:28, Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>> >
>> > This adds a new tracepoint, xdp_prog_return, which is triggered at eve=
ry
>> > XDP program return. This was first discussed back in August[0] as a wa=
y to
>> > hook XDP into the kernel drop_monitor framework, to have a one-stop pl=
ace
>> > to find all packet drops in the system.
>> >
>> > Because trace/events/xdp.h includes filter.h, some ifdef guarding is n=
eeded
>> > to be able to use the tracepoint from bpf_prog_run_xdp(). If anyone ha=
s any
>> > ideas for how to improve on this, please to speak up. Sending this RFC
>> > because of this issue, and to get some feedback from Ido on whether th=
is
>> > tracepoint has enough data for drop_monitor usage.
>> >
>>=20
>> I get that it would be useful, but can it be solved with BPF tracing
>> (i.e. tracing BPF with BPF)? It would be neat not adding another
>> tracepoint in the fast-path...
>
> That was my question as well.
> Here is an example from Eelco:
> https://lore.kernel.org/bpf/78D7857B-82E4-42BC-85E1-E3D7C97BF840@redhat.c=
om/
> BPF_TRACE_2("fexit/xdp_prog_simple", trace_on_exit,
>              struct xdp_buff*, xdp, int, ret)
> {
>      bpf_debug("fexit: [ifindex =3D %u, queue =3D  %u, ret =3D %d]\n",
>                xdp->rxq->dev->ifindex, xdp->rxq->queue_index, ret);
>
>      return 0;
> }
> 'ret' is return code from xdp program.
> Such approach is per xdp program, but cheaper when not enabled
> and faster when it's triggering comparing to static tracepoint.
> Anything missing there that you'd like to see?

For userspace, sure, the fentry/fexit stuff is fine. The main use case
for this new tracepoint is to hook into the (in-kernel) drop monitor.
Dunno if that can be convinced to hook into the BPF tracing
infrastructure instead of tracepoints. Ido, WDYT?

-Toke

