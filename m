Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9D04D0489
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 17:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244323AbiCGQvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 11:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiCGQvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 11:51:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A183673D2
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 08:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646671814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EbsyEl6PHp674FFG0npXsdWRxi6uVtTOAXfXCaC0Sv4=;
        b=DnDddZttzKnt9IbTCNva3Lwp+7hHMsehe9aWjm9EiiEpnRRBW0ssXFyTn1HbKrnbViGaIN
        WRsLBHwC2al6h4GbJ3sRGiSrzNNWiIt1QUW3hgRahvP5GRykiSCCG+7mX++7Kxq3q56QOe
        O8SIateqh6fZoSunzUqBGCBMSphNYqk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-GcZpzDuMNTWHKABoEQf5sA-1; Mon, 07 Mar 2022 11:50:13 -0500
X-MC-Unique: GcZpzDuMNTWHKABoEQf5sA-1
Received: by mail-ej1-f69.google.com with SMTP id go11-20020a1709070d8b00b006cf0d933739so7252937ejc.5
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 08:50:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=EbsyEl6PHp674FFG0npXsdWRxi6uVtTOAXfXCaC0Sv4=;
        b=U68NvTqRoj5rKAJqB/6qUcGyqTkWrNxDa9dvfheK0xTaVUzg62WLeTTaYdtGy2rjSc
         eBygWW5AqfnYL9yVrs6Q1jlcGqPMSaUBEVpvOLqwnIX0QsbAY+f/GPYmNow6WZXFst3k
         tSM3S/dS/EDJ0L4przk+AEMmbjZ42H2VhQ/ok+RkvqqcxBE7x0Q+CLNvzD7XbT22Tx9l
         E1VNIFooJ5v7w3rmaiAR/z74R6xm3DUBwD1+i0+SXkJCFEJ55mYkyW+3yyiZ2yzOmfEq
         yu6yV0pfmnmPIHW/w065VsyPuNaGR0MBbGYNskY2pMJdR/OfL+ktD141mBjaWzDAcAWM
         KxCQ==
X-Gm-Message-State: AOAM530Cg1NSI1Q4TyzBqGbsXJYzuAYLGkjJeFxPMZPLO/KKkqN0uXTd
        d231iDnQncFOR/8M73eqgf1dK+j8KDJjQfRpcbYC8kEboVTYvzwJhPmPc+wFwu0KUWJ0wfm+2/T
        3YRYkQAbA3UEyBL/3
X-Received: by 2002:a17:907:7704:b0:6cf:48ac:b4a8 with SMTP id kw4-20020a170907770400b006cf48acb4a8mr9394658ejc.305.1646671808522;
        Mon, 07 Mar 2022 08:50:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyBYjGhJuNWfFMrVCJmXoiLvZjLrfkSaOTGLSJRle2RsvQ7Tac3yv1H6uEdAYU1VZsGu7yyrA==
X-Received: by 2002:a17:907:7704:b0:6cf:48ac:b4a8 with SMTP id kw4-20020a170907770400b006cf48acb4a8mr9394518ejc.305.1646671806046;
        Mon, 07 Mar 2022 08:50:06 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z21-20020a1709063a1500b006da6436819dsm4958795eje.173.2022.03.07.08.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 08:50:05 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6A861131FC4; Mon,  7 Mar 2022 17:50:04 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH net] xdp: xdp_mem_allocator can be NULL in
 trace_mem_connect().
In-Reply-To: <YiDM0WRlWuM2jjNJ@linutronix.de>
References: <YiC0BwndXiwxGDNz@linutronix.de> <875yovdtm4.fsf@toke.dk>
 <YiDM0WRlWuM2jjNJ@linutronix.de>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 07 Mar 2022 17:50:04 +0100
Message-ID: <87y21l7lmr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:

> On 2022-03-03 14:59:47 [+0100], Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:
>>=20
>> > Since the commit mentioned below __xdp_reg_mem_model() can return a NU=
LL
>> > pointer. This pointer is dereferenced in trace_mem_connect() which lea=
ds
>> > to segfault. It can be reproduced with enabled trace events during ifu=
p.
>> >
>> > Only assign the arguments in the trace-event macro if `xa' is set.
>> > Otherwise set the parameters to 0.
>> >
>> > Fixes: 4a48ef70b93b8 ("xdp: Allow registering memory model without rxq=
 reference")
>> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>>=20
>> Hmm, so before the commit you mention, the tracepoint wasn't triggered
>> at all in the code path that now sets xdp_alloc is NULL. So I'm
>> wondering if we should just do the same here? Is the trace event useful
>> in all cases?
>
> Correct. It says:
> |              ip-1230    [003] .....     3.053473: mem_connect: mem_id=
=3D0 mem_type=3DPAGE_SHARED allocator=3D0000000000000000 ifindex=3D2
>
>> Alternatively, if we keep it, I think the mem.id and mem.type should be
>> available from rxq->mem, right?
>
> Yes, if these are the same things. In my case they are also 0:
>
> |              ip-1245    [000] .....     3.045684: mem_connect: mem_id=
=3D0 mem_type=3DPAGE_SHARED allocator=3D0000000000000000 ifindex=3D2
> |        ifconfig-1332    [003] .....    21.030879: mem_connect: mem_id=
=3D0 mem_type=3DPAGE_SHARED allocator=3D0000000000000000 ifindex=3D3
>
> So depends on what makes sense that tp can be skipped for xa =3D=3D NULL =
or
> remain with
>                __entry->mem_id         =3D rxq->mem.id;
>                __entry->mem_type       =3D rxq->mem.type;
> 	       __entry->allocator      =3D xa ? xa->allocator : NULL;
>
> if it makes sense.

Right, looking at the code again, the id is only assigned in the path
that doesn't return NULL from __xdp_reg_mem_model().

Given that the trace points were put in specifically to be able to pair
connect/disconnect using the IDs, I don't think there's any use to
creating the events if there's no ID, so I think we should fix it by
skipping the trace event entirely if xdp_alloc is NULL.

-Toke

