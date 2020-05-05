Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EDF1C631E
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgEEVc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 17:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727785AbgEEVc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 17:32:27 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339E9C061A0F;
        Tue,  5 May 2020 14:32:27 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 23so432896qkf.0;
        Tue, 05 May 2020 14:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hx7riLHvimhfoEd59ZX9g0Tk8VJ0s4FfLnwubf9kYmo=;
        b=s7NdoSCWnvMJVMs6Jqa0+nBABmCD2hGkp6zn1qaW9f5joY7SkfpVZM/lIC1qb9Xa4k
         QxYntQIwQW2Dfy6wUXS15QLZzhVqX1gE5VBcltluv1HFn4NNRshhIbo06cpnOKGomWil
         BPqBd6xCuv+/6HVfe7g/W1QPg9nHrUw1L7UJ+thb9VFvyS+lmsiEqqM/MAGbitfi2v36
         a2Ctn3SKPUBjDmgv6pjWFWwXyH9zvJtCkGbb+u+PNsvjzcuboztRj8ksqWbm7L82hVrQ
         E4ixTMQpUi1vgi4ninuoYX/o6yj7AirWSzwr9uko9N26kXdTKk5i2T2SUsdDxjHCZwb8
         htww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hx7riLHvimhfoEd59ZX9g0Tk8VJ0s4FfLnwubf9kYmo=;
        b=Ac4gF1pDURTLE2C4+qNtjQDFXe/boODS/yW1EXv/LWqYBEaJRbHJOIhUxtMQ3VHZGA
         HZdx8vXAhAthWybixTvGVmmFPanMo611JG23epGRq56GV+X1ewy/fIeGyOxmIDn/KNNe
         GdjwLU9fwROwD444+F5uZYG7su91LtwCHC00i/Hb7hoO+UhtdC3pInRXoR6VEs+O1Anf
         NZb2Lry2Z/6mKz1+LRaCo4u2hemqUZSka/C3bGObWhJhhT5cEFQltGQX94GdVeT2BdUz
         90j3lqfaTi2NsVnGRM6A3BamjgE+rbDuMqAA9ZxIuVSMrrLpnp4O+iotCU6xpJSaswTy
         0WbQ==
X-Gm-Message-State: AGi0PuYM9sFK5imZziFDCLOMaHgxIOwHyFktRIUZNCFnl/bkPtC1M96Z
        n9SE1JzAxNbJIm+ASoK9hQqZVJ+jw+gwbRMgcYp/uA==
X-Google-Smtp-Source: APiQypL/xXFaaC4AQMVpvfEJc98q9jZIdEl75ZH5NkCoiZrTnUld9ybqhu3TkoP+daZ48nUpJLBqBSPhi1Q81BQbOyI=
X-Received: by 2002:ae9:efc1:: with SMTP id d184mr5976840qkg.437.1588714346447;
 Tue, 05 May 2020 14:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062551.2047712-1-yhs@fb.com>
In-Reply-To: <20200504062551.2047712-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 14:32:15 -0700
Message-ID: <CAEf4BzbXr5Y_Zbg8hYcS90njDzdCbg70QQb+edER0L88QHkqXQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 04/20] bpf: support bpf tracing/iter programs
 for BPF_LINK_UPDATE
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> Added BPF_LINK_UPDATE support for tracing/iter programs.
> This way, a file based bpf iterator, which holds a reference
> to the link, can have its bpf program updated without
> creating new files.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Nice and simple!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/bpf_iter.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>

[...]
