Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC29063A54
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 19:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfGIR5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 13:57:01 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46184 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGIR5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 13:57:01 -0400
Received: by mail-qk1-f196.google.com with SMTP id r4so16637040qkm.13;
        Tue, 09 Jul 2019 10:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E/L8dyRZdgr4J86VYlTbItPkYDey956LQuxM0CIv5h8=;
        b=u89gfN7FCCSkhddBaafuXsIgyrYs9UVenEsCGFWd2l3apCSV6VeTYtOjEl0LCPlFa/
         OkYhdqWxcgYUj7xzHGarvKakaeSWd8htqMOO9Bbm9NIjcmSMd6Bvz7npZQPTJW15QG6W
         da7JW1vOeuxevYw3UB5a1o2CfRrRrn9/7UYanNCoHpDZQD3aVGiNRmWV0Eos3YWz3RXW
         D8PZcMmncWtdpFKRq9m1pN8vNEYzSN1+cBNu9qEzGZyNKHB6Z6jO9xQZehmc+0UAhob5
         EnsbMN/bs4vguUt2ZyqXF7aqGd+vxQRceZAUezI9zgnjnJZAcLvewwM8+mVWgCaoFi4L
         j/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E/L8dyRZdgr4J86VYlTbItPkYDey956LQuxM0CIv5h8=;
        b=GedsKA8cNw1V8mmwy8p7DcDyx2xq+R+1ZYix5Czv840IXA/cgYQ/1qaNS0gEIH4Bht
         jPMWc4xOEuwFh+JAg1hT87PdqGGJZdsqP6tGTIozolRw31Mkh/map1YPfIufM/nkbF8P
         hziIQ8G+Uw6fJfdXAG8Nv9U3qACcuT7II89QVPGNQBecy/yp+cDV+0RwGzwGGaPWjAOl
         inA6W1cMMjk+iFAC/t9UyGRtNfhExhLqyetDskblUjpGLaVlFhEN6hncV4nyHkBA2GOo
         Bqd0BK9sfudIhZO2dXAE4C2Eop7BZwIAuUXBdlAZMX+k9RzE/HmFfwGbWbiR5YG/RoHc
         j2/g==
X-Gm-Message-State: APjAAAV5Yf80kzJ7qBOKesXmEC/8BlAaM56cfZO1pXX8kLAmTym3KaoN
        npBFJRh0SUzsNIZwsb9AABIm90uRBVp31P9AhQccYGiT4/90YKl1
X-Google-Smtp-Source: APXvYqyXEZQav1WcxnrW99cwk90uemppcyasxRP8s4pBJ6xhjZOdQUMrMi/HxGavHGiFwKDu/lgez866TIMzcrRuY2E=
X-Received: by 2002:a37:bf42:: with SMTP id p63mr20291884qkf.437.1562695020134;
 Tue, 09 Jul 2019 10:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190709152126.37853-1-iii@linux.ibm.com>
In-Reply-To: <20190709152126.37853-1-iii@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 9 Jul 2019 10:56:49 -0700
Message-ID: <CAEf4BzZswDkvPbhNnovLjWWmmhR2VBWtrCJkpMXM8M_5Ztn4-w@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: fix bpf_target_sparc check
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 9, 2019 at 8:22 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> bpf_helpers.h fails to compile on sparc: the code should be checking
> for defined(bpf_target_sparc), but checks simply for bpf_target_sparc.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  tools/testing/selftests/bpf/bpf_helpers.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 5f6f9e7aba2a..a8fea087aa90 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -443,7 +443,7 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>  #ifdef bpf_target_powerpc

While at it, can you please also fix this one?

>  #define BPF_KPROBE_READ_RET_IP(ip, ctx)                ({ (ip) = (ctx)->link; })
>  #define BPF_KRETPROBE_READ_RET_IP              BPF_KPROBE_READ_RET_IP
> -#elif bpf_target_sparc
> +#elif defined(bpf_target_sparc)
>  #define BPF_KPROBE_READ_RET_IP(ip, ctx)                ({ (ip) = PT_REGS_RET(ctx); })
>  #define BPF_KRETPROBE_READ_RET_IP              BPF_KPROBE_READ_RET_IP
>  #else
> --
> 2.21.0
>
