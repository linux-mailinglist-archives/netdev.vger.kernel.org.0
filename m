Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BA223C5A9
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgHEGSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbgHEGSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 02:18:32 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12A7C06174A;
        Tue,  4 Aug 2020 23:18:31 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id n141so21052183ybf.3;
        Tue, 04 Aug 2020 23:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ER5J6A+rPahxsQWE2+3u6uyPH4BqrnQd6TMiHPIneqQ=;
        b=V/hNyPFZRclfkK0QUTjTIhee755MhI8+FCQum0a+qBIbBlZvOTdCNpq32nvvv5KNzC
         pBMLubl9QX4ykaMTsiHpeIWL7ab21CJ1P0PbhwtGIop2Uil9q5qvUvudeHi8YUXWzYFD
         P/CtvGTU1KPuD7YjJHFbbhz23A6shwwjyZhPAJy0rkSzraVCOR9xGEbC17svI4yhVDkq
         Hvnost/8zcpBBkrsLOkDPtf82igDQUISYhDDT18E+1g8BwyojgDtPJKx77sO9qQp4rn/
         O+wQztzRJ++F378yaT7j8leuEdFBXKx+lCZ9wbWNHo8aR66vbTrYAC9U93V1SD7Ep06K
         bLLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ER5J6A+rPahxsQWE2+3u6uyPH4BqrnQd6TMiHPIneqQ=;
        b=UzEEeBncuM7bUB79L2zgdDDaM16ZJEGFjY96mucntVECfX5uTsR7gTFSRw6UbZYxU8
         tlkao+BD7WVfdPnEO88RXfsFzAZ6835MtbWMVZUvqL96QYS1QFx1n/XEOMyDc1Jd9Lvd
         fKBERLzZ6VdrUH3BmAudmoeZobZTe0TNjHv/AlkcKi1Ciy0SoG1dgVsa6oqM+XvYbN/v
         PTTld4IoRGMZsyfx4G+wjMtECE9sOP8u8H7CE5pPqzZFbm1bjzcJV56Pw07++O5Ogxw/
         xNOkN3V0ggbUcgw+wpIB/5Zy+E4CZ2MZIJHyhDe+/bNeLRFveMMq6X1Cwabj3+sqmLyS
         o4LA==
X-Gm-Message-State: AOAM532TdXLLoO+dU75JGk27Z1lWm5H3qO6HhPTH0Ee+zTcPhw6EHSwf
        2NOJ/wa3GYLvAUMt6exBxFZXYx3r/jCz+l+/b2I=
X-Google-Smtp-Source: ABdhPJx0GG3c/xhQoEPpW2bGNjyS2w6F+XjJCHNjEjFwcuX8thuGeaXRea1eh8R6BalpG3vSq9vqVIyaN62+SFhpxdI=
X-Received: by 2002:a25:d84a:: with SMTP id p71mr2610112ybg.347.1596608311276;
 Tue, 04 Aug 2020 23:18:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200801170322.75218-1-jolsa@kernel.org> <20200801170322.75218-8-jolsa@kernel.org>
In-Reply-To: <20200801170322.75218-8-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Aug 2020 23:18:20 -0700
Message-ID: <CAEf4Bzbk1ivXa=Q_Fvb+jjrWAJaXJccBWhFTAsH4pVsz0V-eLQ@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 07/14] bpf: Factor btf_struct_access function
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 10:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding btf_struct_walk function that walks through the
> struct type + given offset and returns following values:
>
>   enum bpf_struct_walk_result {
>        /* < 0 error */
>        WALK_SCALAR = 0,
>        WALK_PTR,
>        WALK_STRUCT,
>   };
>
> WALK_SCALAR - when SCALAR_VALUE is found
> WALK_PTR    - when pointer value is found, its ID is stored
>               in 'next_btf_id' output param
> WALK_STRUCT - when nested struct object is found, its ID is stored
>               in 'next_btf_id' output param
>
> It will be used in following patches to get all nested
> struct objects for given type and offset.
>
> The btf_struct_access now calls btf_struct_walk function,
> as long as it gets nested structs as return value.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

This turned out to be rather much more succinct and clean than I
imagined when I was originally proposing the struct iteration idea.
Great job at abstracting this!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/btf.c | 75 +++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 65 insertions(+), 10 deletions(-)
>

[...]
