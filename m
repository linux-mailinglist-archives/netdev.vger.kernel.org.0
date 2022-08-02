Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D702587E84
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 17:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237336AbiHBPDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 11:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbiHBPDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 11:03:49 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26909B1E3;
        Tue,  2 Aug 2022 08:03:47 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id tl27so8604289ejc.1;
        Tue, 02 Aug 2022 08:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YuKYTlYXsUuQmYJM1Cz/Cc34PkMLTAIIVUlnlbWHYeA=;
        b=a8oo6jmlGaQ0vrWzMjLk34GqxgBH1AGiIl4FaktqAl774G8G4tbc/hyXjQll6s9LKP
         C3Rwqu1qqg5WcXIoWPfUZ39SQpYQYX+5lvD6HoVHmEichLwYVjgIyu1ArnHL7sYLSZ5g
         TPyAb39bKiVictNexZ044GV4X598gJQ6+42dWfMdEzYyE/v7yzoHQdj3M2XhlHu+zI+N
         K/Kc7uDHv8UN1R+hhM/Rw6fRwIPlt+CkYiEo65+7AoU2w+0NjIIvNMFWmr/JVEK345Ik
         kO4nrvlmRD3peBDEx5a6ghyrUdzx+XeCKQeHA/mxldjqyk7Cj6Z3ycHofoQzXcOK35xR
         24QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YuKYTlYXsUuQmYJM1Cz/Cc34PkMLTAIIVUlnlbWHYeA=;
        b=Cj/PKNF1D3AKpqgd66FXATyL9owB0JJ+iYBw5YTYG5F+0nXl0PQT22bExnSoiSg0KR
         OMXmB/KyfkyJwGdBYg2zCYv/P3XY8js2Dqa9Bu6I8BG00gXywFdqs2EVB4sLM3qvvCJL
         LqeU7bn30nzN/ikXLMnW4Y3M0DphwUQ3D7glwwfYUEM1Hz0AHdUXszcH4f8ox6UohjLQ
         jwjuJvlmy/oOUCFG/LgKMdfnWSOOYZ7xSu36xvPKxMzHjH28g2SStUHtb5rcOOGTuogi
         e/QQy0WfoNRVyWC/6NEvuunEaQd0doXxrtdDUSEt4N6+7O5Nb66FHibPcpiYHvriZwsX
         jsvw==
X-Gm-Message-State: AJIora9oYX0Nn5ZaeyvTnvfH4V8svcFS6Q5osamE1MrxRs/qCvMenFgI
        reYoNepvDHliTOUzUY4bMrDWE0i7MT8+Did+5ik=
X-Google-Smtp-Source: AGRyM1uvx5S+DZkNnWCdQBUPLDXXG9hpJvt9yRykl0DSJ+DEawmimHUfaN3fxzaZrC6ioZaroXc7EXT9cH00EUXoiCM=
X-Received: by 2002:a17:906:a089:b0:72f:826b:e084 with SMTP id
 q9-20020a170906a08900b0072f826be084mr17038947ejy.708.1659452625587; Tue, 02
 Aug 2022 08:03:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220606103734.92423-1-kurt@linutronix.de> <CAADnVQJ--oj+iZYXOwB1Rs9Qiy6Ph9HNha9pJyumVom0tiOFgg@mail.gmail.com>
 <875ylc6djv.ffs@tglx> <c166aa47-e404-e6ee-0ec5-0ead1923f412@redhat.com>
 <CAADnVQKqo1XfrPO8OYA1VpArKHZotuDjGNtxM0AftUj_R+vU7g@mail.gmail.com> <87pmhj15vf.fsf@kurt>
In-Reply-To: <87pmhj15vf.fsf@kurt>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 2 Aug 2022 08:03:34 -0700
Message-ID: <CAADnVQ+aDn9ku8p0M2yaPQb_Qi3CxkcyhHbcKTq8y2hrDP5A8Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add BPF-helper for accessing CLOCK_TAI
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 2, 2022 at 12:06 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
> Hi Alexei,
>
> On Tue Jun 07 2022, Alexei Starovoitov wrote:
> > Anyway I guess new helper bpf_ktime_get_tai_ns() is ok, since
> > it's so trivial, but selftest is necessary.
>
> So, I did write a selftest [1] for testing bpf_ktime_get_tai_ns() and
> verifying that the access to the clock works. It uses AF_XDP sockets and
> timestamps the incoming packets. The timestamps are then validated in
> user space.
>
> Since AF_XDP related code is migrating from libbpf to libxdp, I'm
> wondering if that sample fits into the kernel's selftests or not. What
> kind of selftest are you looking for?

Please use selftests/bpf framework.
There are plenty of networking tests in there.
bpf_ktime_get_tai_ns() doesn't have to rely on af_xdp.
It can be skb based.
