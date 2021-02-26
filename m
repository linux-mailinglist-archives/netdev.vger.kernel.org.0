Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5973267A6
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 21:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhBZUEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 15:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhBZUEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 15:04:36 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FA8C061574;
        Fri, 26 Feb 2021 12:03:56 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id u4so11974911ljh.6;
        Fri, 26 Feb 2021 12:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zx4wWUTPjkEoZMfdFukEwwHYmqNG3sfw0pU4Ec9E4uA=;
        b=Snr+kyjMGdVKvorvrl0RwG7Nhs3MxTXrcura/wtnx1BwuxyXMo5IK1koqPR7pSOwCk
         5pP70wsFngb2ETVZdl4VV+yzc5DdeGM9MehmDwiz3Pd5JcUnpbhkEZ948vHA51sLWIJ0
         QIg1Pen6Y56W2bjImPYNhDC5cQtoq6aKWrD/AzO9b5aoGXMO3u7xO0TCr54qTao1oIcV
         RAzdWDuS6X92B/P3ao2Lbc1FbuCRU5KQRsvqg8Ja8G3QnpXZ3mjoAoPGo8jp18V9gfwr
         PWTSoqBQpgZDLBOIwnW9DaSkC9H1NJJEk6z2ijtCunw264kG+UKTW2CLHor1aXHdi0Ru
         oxrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zx4wWUTPjkEoZMfdFukEwwHYmqNG3sfw0pU4Ec9E4uA=;
        b=pR7Kp8V7pPv4NAFyN68Fd9xWScx7mObyXUp1EF1MwBfDhuiL/VhE6wU0XM3KJ3X2HH
         n2AiT0QpOPVuSh6YVJ90glBBSpdn59RDF9NbYfftjEi+2VnnsMYFCUvlJI7xEcuRBrdO
         oSpJghzlgT/pMVlHW7DeRZ8aKDI0uhxYOxCrs8UbSyBp4sAodneQvmFzPKaSahxQNCVf
         xwUCVvAD+faOGZHpci0FLKmdGNALWsyogB0oqFjSu8e5cI3h4V7HES6zITDeP3Jsotbp
         Hd84vaE4Z9z8XY7+5oX+PrO8n5cJ3tlX9IS14wn/F3H4HyI/k2AdWDeozrvfIFpacNyO
         pO/g==
X-Gm-Message-State: AOAM530pNNX2Mv/TOUpTKGisCiok/kDJz+IaAnPb5xGtvQOSbauF44/z
        KxReKb/HA3V8uycS242qW3kPEeBcai0TNc3acAjyIoGU
X-Google-Smtp-Source: ABdhPJwTMTg2ATqmr33jGu88YKPjfTzN5Dz5HF5o6G0ONsYfB4ZNpVAgifgx1ZOqc/qfL1bg1FZX0ugdTqMAdG3nNDA=
X-Received: by 2002:a2e:964e:: with SMTP id z14mr2629715ljh.204.1614369834704;
 Fri, 26 Feb 2021 12:03:54 -0800 (PST)
MIME-Version: 1.0
References: <20210225234319.336131-1-songliubraving@fb.com> <20210226000344.a6aud7aaimrc6wzt@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210226000344.a6aud7aaimrc6wzt@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 26 Feb 2021 12:03:43 -0800
Message-ID: <CAADnVQKofEPSABz-+WQ65XTcOEQPke08Nity2Mo7-bD2gopVpg@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 0/6] bpf: enable task local storage for
 tracing programs
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 4:04 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Feb 25, 2021 at 03:43:13PM -0800, Song Liu wrote:
> > This set enables task local storage for non-BPF_LSM programs.
> >
> > It is common for tracing BPF program to access per-task data. Currently,
> > these data are stored in hash tables with pid as the key. In
> > bcc/libbpftools [1], 9 out of 23 tools use such hash tables. However,
> > hash table is not ideal for many use case. Task local storage provides
> > better usability and performance for BPF programs. Please refer to 6/6 for
> > some performance comparison of task local storage vs. hash table.
> Thanks for the patches.
>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied. Thanks.

9 out of 23 libbpf-tools will significantly reduce the tracing overhead. Hooray!
