Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E4341B57
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 06:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbfFLEql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 00:46:41 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33032 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730017AbfFLEql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 00:46:41 -0400
Received: by mail-qt1-f195.google.com with SMTP id x2so16371690qtr.0;
        Tue, 11 Jun 2019 21:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LD/bgDk9FBXT2IkNnf0RVYUWZB6VQ8JqqO6m09bkqUc=;
        b=FGiPA+k4K8l0qyWJx2opz5qT4dCY7jbX+w5sI5Y0cj+EvU4InGxBsVXv7o5v38ePGx
         e8sQneJhaJ/f79O3GCvQ6iotEPHGm7aICWICP67yilLk0TiWlts6NosnIGOWJBVmL68+
         K8v9aipQiweHJ3qjAhoweM49naynWaGtGwNvpzgG4Ik47TLF9UMj7HZiMKZJ8YUgMi67
         UnkZgQbZDynqzztR/DOUWInufko8LIMeKvDnAaoyJ7NZaPz/q4xHdKE9mzTM5Gm/+inB
         Ys7Frej+4vcgYSmiPrtSo3Z3GeSIe1qFj1wVkOgoe3XxSbN3myg5zFMYwKoFoof844lD
         /prw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LD/bgDk9FBXT2IkNnf0RVYUWZB6VQ8JqqO6m09bkqUc=;
        b=dYkpxN2j5eW57hdOT8T/bjtrFvvQA49p/NRdSc1NDJwe8yOCpML8iNHldEncd4fNbT
         J++yl/PMbFM6DWOX62arGQ+5aeNA4c0nuiq7pMGnO559QKFUEL8iErQOdTUluWSXH+IY
         ca/fTS/+mHp+C+t+i7LmN6MoCdcTc8n7opR31dT/H99UeHILpwkg4F7BGJpXKQDiJRRB
         /tId3FenxJ96DBRKfw003NiuqO/wwlGRHHPjfah+EHykz/Bf9GAGRpBZym7v6BPAsBxK
         zOHVqnu3VqRZsztfviz5r4uMaXblbn6c+kURLwPSjlEdMXTkU788ooywIeBlP01qHHk6
         wCNQ==
X-Gm-Message-State: APjAAAVye60eFHRUILQahqPvVwDWysIURxEzICXBWn8gOsuD7qWF9Z9r
        bx6TBY1wbUFCx+ov1fNCUzAMXRfcjPn7q4nulMKAlNxcUZ4=
X-Google-Smtp-Source: APXvYqxcBXzce/qTrPnTVs60KV32mhx1EOnnzxYq8VbAKA/CnA0e4Q/9dCJCdGG8lXwYTSxZ7OM2sijh4gNt58v5A9s=
X-Received: by 2002:ac8:2a63:: with SMTP id l32mr48132933qtl.117.1560314799927;
 Tue, 11 Jun 2019 21:46:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190611214557.2700117-1-kafai@fb.com>
In-Reply-To: <20190611214557.2700117-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 11 Jun 2019 21:46:28 -0700
Message-ID: <CAEf4BzYSX15mWHZ3JQGqtSM3UiDFdz+PAAGCFx=p8zxGC7Jf1w@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: net: Set sk_bpf_storage back to NULL for cloned sk
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 8:33 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The cloned sk should not carry its parent-listener's sk_bpf_storage.
> This patch fixes it by setting it back to NULL.

Makes sense.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  net/core/sock.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 2b3701958486..d90fd04622e5 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1850,6 +1850,9 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
>                         goto out;
>                 }
>                 RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
> +#ifdef CONFIG_BPF_SYSCALL
> +               RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
> +#endif
>
>                 newsk->sk_err      = 0;
>                 newsk->sk_err_soft = 0;
> --
> 2.17.1
>
