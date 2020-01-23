Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E87D147322
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 22:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgAWV25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 16:28:57 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:38943 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgAWV25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 16:28:57 -0500
Received: by mail-ua1-f67.google.com with SMTP id 73so42904uac.6;
        Thu, 23 Jan 2020 13:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YSbU1uqjZPOEO1Y+Gw50u5Z+ggq+k7efj1RntkA3E9U=;
        b=oPAt2jQlapEzqqZVJrKArIR0wSaVYzkP6sejlZbngsxvYIPYyDxnAQpP7+80ejkcjB
         NQQ6Vze/aeClkDRc/5difGCA92dclJVwbmwr30eJ1i/xxEe+0zUn2fOApOulJRecJRjM
         mZbmbA3s2XDKCHWV2qjv4J1nHMvGH0pl09dTFtBMUbJiIYs82Z1gR2r3M+xjz2kdEgNt
         Sak9EB6jELEBFm+Xat7qdGrhzEdnbAxpwbSwoWsVFtT3vezMRn2BNJUL4REgvCDveC8S
         lOrEqONEgloVs5rrpyVO8klYyypX01Q1M8MgIzqeZoUtom+Lc7waBhR8+sAQYA81zSYy
         ythQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YSbU1uqjZPOEO1Y+Gw50u5Z+ggq+k7efj1RntkA3E9U=;
        b=sijKP5MqIl7cIWeFlkKuQFGH8SzwsbHGapcRYkoX488ENQCXwaQ+s3nTpvXedJNe4+
         yze2pCTw/GXeYZkR4C6QEkmEqvz+7uQufdPowepDgdtQXB2wbQ2/NAr5KfJEB4oZLFCE
         zNF6CsEzlWcgOpUvrYdTqEec+vkFJK/KmyIJe8d5w0zuHxmJ2SyNGzvg+uXoyLo39WRE
         fSoYYtnJq+4RKFBYOyoi3hBIsheaikkDy+I9b0KRRFQG01TDeVLUMl/bXCdzky2DIx/N
         +LM339gSd3a1BOUJ4hKeiXCowGkzZYgvp6f353DigGgvNI8wpbvecJlwohlh31LGMryy
         sGfw==
X-Gm-Message-State: APjAAAVyUuQnw+XatPUIozefx+mZAjJT92KTLDO31CDKkbNbT65/18xG
        LgPWnS3jw59gYPeDP413fdWr5JrsGFPb43mO54Y=
X-Google-Smtp-Source: APXvYqwVZEiV2fpYrSjwSbTZs5ZwPqLIdvGiJS5S9P+hVVKDiZVc8XR0t8L+g9NhdkwSkiUOIr0hwkAGiQ+sIH7XIxY=
X-Received: by 2002:ab0:40a3:: with SMTP id i32mr11123232uad.131.1579814935885;
 Thu, 23 Jan 2020 13:28:55 -0800 (PST)
MIME-Version: 1.0
References: <20200118000128.15746-1-matthew.cover@stackpath.com>
 <5e23c773d7a67_13602b2359ea05b824@john-XPS-13-9370.notmuch>
 <CAGyo_hrUXWzui9FNiZpNGXjsphSreLEYYm4K7xkp+H+de=QKSA@mail.gmail.com>
 <CAGyo_hpcO-f9uxQFDfKZNz=1t6Yux+LzxN1qLHKf6PXMAtWQ-w@mail.gmail.com> <360a11cd-2c41-159e-b92a-c7c1ec42767f@iogearbox.net>
In-Reply-To: <360a11cd-2c41-159e-b92a-c7c1ec42767f@iogearbox.net>
From:   Matt Cover <werekraken@gmail.com>
Date:   Thu, 23 Jan 2020 14:28:43 -0700
Message-ID: <CAGyo_hotjxvaWjL1VV4VMSviZcLMSmO8UQcVJFW_nV8=RTGNsQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add bpf_ct_lookup_{tcp,udp}() helpers
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Matthew Cover <matthew.cover@stackpath.com>,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jiong Wang <jiong.wang@netronome.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 2:11 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/20/20 9:10 PM, Matt Cover wrote:
> > On Mon, Jan 20, 2020 at 11:11 AM Matt Cover <werekraken@gmail.com> wrote:
> >> On Sat, Jan 18, 2020 at 8:05 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >>> Matthew Cover wrote:
> >>>> Allow looking up an nf_conn. This allows eBPF programs to leverage
> >>>> nf_conntrack state for similar purposes to socket state use cases,
> >>>> as provided by the socket lookup helpers. This is particularly
> >>>> useful when nf_conntrack state is locally available, but socket
> >>>> state is not.
> >>>>
> >>>> Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
> >>>> ---
> >>>
> >>> Couple coding comments below. Also looks like a couple build errors
> >>> so fix those up. I'm still thinking over this though.
> >>
> >> Thank you for taking the time to look this over. I will be looking
> >> into the build issues.
> >
> > Looks like I missed static inline on a couple functions when
> > nf_conntrack isn't builtin. I'll include the fix in v2.
>
> One of the big issues I'd see with this integration is that literally no-one
> will be able to use it unless they manually recompile their distro kernel with
> ct as builtin instead of module .. Have you considered writing a tcp/udp ct in
> plain bpf? Perhaps would make sense to have some sort of tools/lib/bpf/util/
> with bpf prog library code that can be included.

Daniel, sorry, I missed addressing your second point in my previous
response. I agree that plain bpf ct is of interest. However, I still
see value in these helpers, particularly when nf_conntrack is
already in use. Reuse of info already in nf_conntrack avoids the
memory cost of another ct table.
