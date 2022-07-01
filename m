Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C2D563359
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 14:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbiGAMPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 08:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbiGAMPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 08:15:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B542A2AE06
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 05:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656677743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kXVJiRtFfJn6rh84gZrCOWxnfgdtYxOFdD9FLOoWGEw=;
        b=SAUfXHtW0FZbb8PLwo1+yp8k+xCHrOOhE8cMaskJfjYQF9rsAed2ec5rETAomtqzk71FZG
        EWubhqyPPkQBIHK/CnCB8mfhNtVDly2uM8PdAq/phfG+B8Ji+aG5EbeEfpxmzdgMvMVmUa
        vGpBVrmwYtVOCEQ32/QQqNhSrzTytIE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434--uLLMm4gN62XNkDuDaugRQ-1; Fri, 01 Jul 2022 08:15:40 -0400
X-MC-Unique: -uLLMm4gN62XNkDuDaugRQ-1
Received: by mail-ej1-f69.google.com with SMTP id sd14-20020a1709076e0e00b0072a7c5a08f4so706934ejc.21
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 05:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kXVJiRtFfJn6rh84gZrCOWxnfgdtYxOFdD9FLOoWGEw=;
        b=LMkIpaRiYQ3Xh1PyjVaNidmByf5XJaJzG1KPhrBMYHUFF/P9BbcggVf1wADt+wKNJX
         t3Io5n2J+/xcwrBBj4MuEAbwBz9nSaShLOQ8Sa7WY+3hJueljd2pSqkQ21+9YVdvHTf+
         vaZG/g8pYujAtcW+6yPUqSxjWUucBHrsB3z7Cs29DTscvhhtcMaA9MXnzNgjzSgFERy7
         9/Gu039LxHooXc0JRNA68PNdCjeWNhd7jPTNoCdvw0jcl9wECn4r3JnLH4ZbUDZKBVRN
         eetxdCjYBzWzqafpZN8DVDng+KFTszq1FJPacyyKa0vuCW4pXnLnwW5M30CuWE6yO6GU
         5+yA==
X-Gm-Message-State: AJIora8NJC8j3E0+RPuKsWzux0QA30caYQQo3qTabmfWum0vtU0Z8FC4
        VbNUo7wm6pXC0RxgrPOK8Y5JhIRj7cvQbO/IDgL4I3nHTXhS5TDR9JJN0pvtUuYjDYI2fNhdIw2
        5xYyMUcw3GMUMuyAs
X-Received: by 2002:a17:907:72d5:b0:722:def3:9160 with SMTP id du21-20020a17090772d500b00722def39160mr14329339ejc.164.1656677739607;
        Fri, 01 Jul 2022 05:15:39 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t1xn2nDy0YXkC88rGzuj1nPm04QabZVmJUkVsww5nrBeY1p+QzyqU4ddheR83zbCFd7l5C6g==
X-Received: by 2002:a17:907:72d5:b0:722:def3:9160 with SMTP id du21-20020a17090772d500b00722def39160mr14329317ejc.164.1656677739301;
        Fri, 01 Jul 2022 05:15:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id oz20-20020a170906cd1400b006f3ef214dc7sm10301583ejb.45.2022.07.01.05.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 05:15:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D8DB547749E; Fri,  1 Jul 2022 14:15:37 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFQ=?= =?utf-8?B?w7ZwZWw=?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>
Subject: Re: [PATCH bpf-next] selftests, bpf: remove AF_XDP samples
In-Reply-To: <CAJ8uoz2KmpVf7nkJXUsHhmOtS2Td+rMOX8-PRqzz9QxJB-tZ3g@mail.gmail.com>
References: <20220630093717.8664-1-magnus.karlsson@gmail.com>
 <fa929729-6122-195f-aa4b-e5d3fedb1887@redhat.com>
 <CAJ8uoz2KmpVf7nkJXUsHhmOtS2Td+rMOX8-PRqzz9QxJB-tZ3g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 01 Jul 2022 14:15:37 +0200
Message-ID: <87v8sh81w6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson <magnus.karlsson@gmail.com> writes:

> On Thu, Jun 30, 2022 at 3:44 PM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>>
>>
>> On 30/06/2022 11.37, Magnus Karlsson wrote:
>> > From: Magnus Karlsson <magnus.karlsson@intel.com>
>> >
>> > Remove the AF_XDP samples from samples/bpf as they are dependent on
>> > the AF_XDP support in libbpf. This support has now been removed in the
>> > 1.0 release, so these samples cannot be compiled anymore. Please start
>> > to use libxdp instead. It is backwards compatible with the AF_XDP
>> > support that was offered in libbpf. New samples can be found in the
>> > various xdp-project repositories connected to libxdp and by googling.
>> >
>> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>>
>> Will you (or Maciej) be submitting these samples to XDP-tools[1] which
>> is the current home for libxdp or maybe BPF-examples[2] ?
>>
>>   [1] https://github.com/xdp-project/xdp-tools
>>   [2] https://github.com/xdp-project/bpf-examples
>>
>> I know Toke is ready to take over maintaining these, but we will
>> appreciate someone to open a PR with this code...
>>
>> > ---
>> >   MAINTAINERS                     |    2 -
>> >   samples/bpf/Makefile            |    9 -
>> >   samples/bpf/xdpsock.h           |   19 -
>> >   samples/bpf/xdpsock_ctrl_proc.c |  190 ---
>> >   samples/bpf/xdpsock_kern.c      |   24 -
>> >   samples/bpf/xdpsock_user.c      | 2019 -------------------------------
>> >   samples/bpf/xsk_fwd.c           | 1085 -----------------
>>
>> The code in samples/bpf/xsk_fwd.c is interesting, because it contains a
>> buffer memory manager, something I've seen people struggle with getting
>> right and performant (at the same time).
>
> I can push xsk_fwd to BPF-examples. Though I do think that xdpsock has
> become way too big to serve as a sample. It slowly turned into a catch
> all demonstrating every single feature of AF_XDP. We need a minimal
> example and then likely other samples for other features that should
> be demoed. So I suggest that xdpsock dies here and we start over with
> something minimal and use xsk_fwd for the forwarding and mempool
> example.
>
> Toke, I think you told me at Recipes in Paris that someone from RedHat
> was working on an example. Did I remember correctly?

I think I was probably referring to
https://github.com/xdp-project/xdp-tools/pull/158 ? Which has sadly
stalled :(

-Toke

