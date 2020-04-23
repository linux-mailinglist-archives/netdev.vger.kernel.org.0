Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9981B66FB
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 00:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgDWWo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 18:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgDWWo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 18:44:56 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAFDC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 15:44:55 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 18so3759633pfx.6
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 15:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=t4eWHyzfHRryGoSoN3WDHcX6J6Bt8KCPKt50MoGFjpw=;
        b=SDyBZp/GvsCiLR2+JV5qyAxzukiQvcetbVIRrKqTgkIjqp9x/zCxaP64nN9nzwqlAz
         HE5AQdESWlpedhefKyDFKFydrCoSDZx5JzBoyeBzq7jK80RZEAmQlHJeVSUgkPw7p4zt
         R3Kwi0wo+BewJVL9C2/YB7pZfpdOmbt5EaFyxMVGFFDkywWoUprhxvxN8ku5ZAP0w2WF
         CoDdLCJWNi/7y/tPnncBpx4UTNH+d6yVXOm2ll/KmtLRRcsNRNjOTF0C1WaFDNLGAva6
         7BxoqD/DHBHa3vwBjnYZFAqu4FZdApu8uJHaVujGbd/G9LlQpFKqKKAEuOdxdLzn21RU
         ixcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=t4eWHyzfHRryGoSoN3WDHcX6J6Bt8KCPKt50MoGFjpw=;
        b=FO0W0ecRbSMOFEtxWJ7Unkz8y3NACRxqpGawYHIZJo0EWa/MLOEPqCyz+HWaxDMBU9
         XzZkmzxXQDPikFlnWaHJivl+WXKTwf88ujxU7hOcTeLjI+bFS7zdGNxVMT4TgNpSMhhv
         oqGH79PKupZK9RFftGxwkUBL++fzVlOy4yk5ZsgAmv4uALhsY00R0415cIzy40rfDyCN
         gccUQUQVIPI1T2ie10z/6EujOYdPPkOWb+kAwJb/jwXpo61sUwRRmRM6/2U5U7wJi2OS
         Yk+Ul2sd6DbOp/4RLoztcWFFxzYt7AdVOUYGqa4NT/ceXSCUhrvY09phF1Cr//jU3tuM
         28DA==
X-Gm-Message-State: AGi0Puaiw7R24oFGSvunMSR8QtK5zOMLc7JqGfL+aw//iYDJoxgyy/NC
        TmVSR9+K3BG2ij+iNWiks60aOqh8
X-Google-Smtp-Source: APiQypLAMKJf20XUKYJrWz5vC8pk54S6U0G3MyKUHWLkPg22thUg9gXM6VNoO6Cx1a8fFCBLByHt/Q==
X-Received: by 2002:a63:f50a:: with SMTP id w10mr5837912pgh.181.1587681895438;
        Thu, 23 Apr 2020 15:44:55 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:ce4])
        by smtp.gmail.com with ESMTPSA id 1sm3623541pff.151.2020.04.23.15.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 15:44:54 -0700 (PDT)
Date:   Thu, 23 Apr 2020 15:44:51 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 04/16] net: Add BPF_XDP_EGRESS as a
 bpf_attach_type
Message-ID: <20200423224451.rkvfnv5cbnjpepgo@ast-mbp>
References: <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com>
 <87k1277om2.fsf@toke.dk>
 <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com>
 <875zdr8rrx.fsf@toke.dk>
 <783d0842-a83f-c22f-25f2-4a86f3924472@gmail.com>
 <87368v8qnr.fsf@toke.dk>
 <20200423003911.tzuu6cxtg7olvvko@ast-mbp.dhcp.thefacebook.com>
 <878sim6tqj.fsf@toke.dk>
 <CAADnVQ+GDR15oArpEGFFOvZ35WthHyL+b97zQUxjXbz-ec5CGw@mail.gmail.com>
 <874kta6sk9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874kta6sk9.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 07:05:42PM +0200, Toke Høiland-Jørgensen wrote:
> >> >
> >> > Looks like there is indeed a bug in prog_type_ext handling code that
> >> > is doing
> >> > env->ops = bpf_verifier_ops[tgt_prog->type];
> >> > I'm not sure whether the verifier can simply add:
> >> > prog->expected_attach_type = tgt_prog->expected_attach_type;
> >> > and be done with it.
> >> > Likely yes, since expected_attach_type must be zero at that point
> >> > that is enforced by bpf_prog_load_check_attach().
> >> > So I suspect it's a single line fix.
> >>
> >> Not quite: the check in bpf_tracing_prog_attach() that enforces
> >> prog->expected_attach_type==0 also needs to go. So 5 lines :)
> >
> > prog_ext's expected_attach_type needs to stay zero.
> > It needs to be inherited from tgt prog. Hence one line:
> > prog->expected_attach_type = tgt_prog->expected_attach_type;
> 
> Not sure I follow you here? I ended up with the patch below - without
> the first hunk I can't attach freplace funcs to an xdp egress prog
> (since the expected_attach_type will have been propagated from
> verification time), and so that check will fail. Or am I missing
> something?
> 
> -Toke
> 
> 
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index d85f37239540..40c3103c7233 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2381,10 +2381,6 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
>                 }
>                 break;
>         case BPF_PROG_TYPE_EXT:
> -               if (prog->expected_attach_type != 0) {
> -                       err = -EINVAL;
> -                       goto out_put_prog;
> -               }
>                 break;

ahh. that extra check.
I think it's better to keep it for extra safety.
Here all expected_attach_type have clear checks depending on prog_type.
There is no other place where it's that obvious.
The verifier does similar thing earlier, but it's not that clear.
I think the better fix would to set expected_attach_type = 0 for PROG_TYPE_EXT
at the end of do_check, since we're overriding this field temporarily
during verification.

>         case BPF_PROG_TYPE_LSM:
>                 if (prog->expected_attach_type != BPF_LSM_MAC) {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 513d9c545176..41c31773a3c4 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -10485,6 +10485,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>                                 return -EINVAL;
>                         }
>                         env->ops = bpf_verifier_ops[tgt_prog->type];
> +                       prog->expected_attach_type = tgt_prog->expected_attach_type;

In that sense it's like 'env->expected_attach_type'.
