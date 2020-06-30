Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D7920EAF4
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgF3Bas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgF3Bar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 21:30:47 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FC0C061755;
        Mon, 29 Jun 2020 18:30:47 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id e12so14410764qtr.9;
        Mon, 29 Jun 2020 18:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dOGR8hfE5pfDKep9Mqg3hepFuNgQ9D1wxskAbD0pMtc=;
        b=E7xI3aw7cJccxN5XFRiaCO7lXcjhNLvl5eakHBk+yyxfyciob/mojWg2VW5PFiGSR3
         CSev9VeVLW2sKePbf+wJuEL7PZ15OYeBiILorTSu2W9SGn+vfulWIvNA5BshUoeHrr6n
         iU4/huKvqawvredIaenoR+lV36ZdCcWVk7DlGuH1iIGBfJMtd+jzvO1AyAE2F1CRoHLp
         A5WVlk0mI+wQIcg3ye4rb7i4hxutl0+sePix6BUrhArFjdYUlQS5oXWjzUS1DcXtwR/d
         qIB9eghwNp+x7M2dw+ZicP0XTFppFEU74ot9K/DZbdnbKpUZAGPPGzbYmGVTOXQeDc4v
         fohQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dOGR8hfE5pfDKep9Mqg3hepFuNgQ9D1wxskAbD0pMtc=;
        b=T3pIvLOAaKFRTWpa/7cfiW8QfXpoO9/YHaAoad9LiHv4IXqfdpiyPnnLRbn1GHBQjI
         1TLTHSuQqffGAbClDM5zGfBgse+E2MHiZs2/F2/Md6nlkyfB6CXztrki0Hkfw27XnIEW
         fAc8wdXz4+rnttG8nGEuJdHNdLsFwGh/bSFmI3WUEKwcvPJm3VqV8T91qPX+SRZ6onTM
         F0qg5llI7L7p0/uDEbDULm1GAVi7r7rh0elc0uOEp6QSxAq7WtOkXA9GRuo7ONpoV/ei
         mx0C+RVwTMPR2zsooiuYLXH0sZS+CB5JD4VrMREUoNefwkV9Uyyh2bheAJ7OSq3Hxrp4
         6nkA==
X-Gm-Message-State: AOAM532+xWBL13fXKjK6QEi/Z/zrFStYJlvW27XmIQLUlCHp9Hh+T71/
        NI3M/6HZajaJRwybcZ77ndcccO4GU7K1UFL+1as=
X-Google-Smtp-Source: ABdhPJzKK3ONmicq5i6xgBpJhETJk59U6cml8/uywYVQ9f4X2J67eBA6ynDTDJbpUVBZGUlySXibB0DxxFlOam/S5vs=
X-Received: by 2002:ac8:4714:: with SMTP id f20mr18488045qtp.141.1593480646786;
 Mon, 29 Jun 2020 18:30:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-13-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-13-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jun 2020 18:30:35 -0700
Message-ID: <CAEf4BzbywtRY_u8wyEZMaFNCY88Axip91VUkDCX94pPYKS-HrA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 12/14] selftests/bpf: Add verifier test for
 d_path helper
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 4:48 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding verifier test for attaching tracing program and
> calling d_path helper from within and testing that it's
> allowed for dentry_open function and denied for 'd_path'
> function with appropriate error.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/test_verifier.c   | 19 +++++++++-
>  tools/testing/selftests/bpf/verifier/d_path.c | 37 +++++++++++++++++++
>  2 files changed, 55 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/d_path.c
>

[...]
