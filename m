Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE8C1B6A85
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 02:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgDXAxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 20:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728156AbgDXAxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 20:53:13 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C1DC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:53:13 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o15so3804783pgi.1
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=52iYa5OZqOKQXGJSKL8yC0mLtPaw/Btk2u2YvPZaYJc=;
        b=NUzufebjwdkLo3d9SdxS87PffDtnnCbNfmajbSQi+k3tnaJ4U/+ZkigpqQmPlH4YzD
         WWfwCcB/haIB9cXKKoj79TLuYJdLTl6zeZFRDZwwbf1qr/T7r6W76iN3eyhnC4/LhZIt
         txoGs2U065YwSU+rtDifG75blfRnM9hQ8ObTTQurxre7kh5YUj+pCpzt1nOxdj8V3CsW
         Css6LFf6Tv6NpE10D48NRXDjn4Gt00W4x0Lt/1c+XhhWWdS0ulp549voszvQBBb1D0Ej
         Dig067tqy76+kyMoi/HULoITkMWUe9QsCI7INbjy1qC9li6iktIF4STJAVyXfg+I+q9Z
         vDsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=52iYa5OZqOKQXGJSKL8yC0mLtPaw/Btk2u2YvPZaYJc=;
        b=l8ohVpARYuROGuaMXTjnjlv4fxkbBE/xqhMJ55KN2q0eFXlI21HEfYqrX0khDVsV/v
         yfCZ4u9NjUfw++tKovPqowqNzeQ4geGMjKH3+G9y5PlFVXz7fNeoe8bjhuYj4VWSxyl7
         MtywN9HcP0KZX6m/813kiUlVaxO6vMKPfIMzfuRZxy9EC4NPrx4JYl6awEqeeF56Upob
         CJ0eaO6XFvwTajMoP1HEvA0if1UARb0Ns3M/508a4egF2NaN2tPu8ITzAf0zzd1IoGLP
         o7exBK3WFOsSwt/74lRWFIirlJcJfMgwU4wJJ7NNYFTTK3q70c9nZdHQxnGYpbUPRrtA
         Z/IQ==
X-Gm-Message-State: AGi0Pub0XbSxaImwBLI0mp7G6hnR+QsENp9/qKHsDIH/nXnW4NAvZwbg
        d2w+5eeIG5TnCTAZg53qD94=
X-Google-Smtp-Source: APiQypKynwzdScs7TEcCYW1WaAcOgCgb0zIyDaqAO/j55pKUsY1iqbAMGIzHNfLjWdwQq5cfGly95g==
X-Received: by 2002:a63:8ac3:: with SMTP id y186mr6166483pgd.277.1587689592510;
        Thu, 23 Apr 2020 17:53:12 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:ef3c])
        by smtp.gmail.com with ESMTPSA id s199sm3990325pfs.124.2020.04.23.17.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 17:53:11 -0700 (PDT)
Date:   Thu, 23 Apr 2020 17:53:08 -0700
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
Message-ID: <20200424005308.kguqn53qti26uvp6@ast-mbp.dhcp.thefacebook.com>
References: <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com>
 <875zdr8rrx.fsf@toke.dk>
 <783d0842-a83f-c22f-25f2-4a86f3924472@gmail.com>
 <87368v8qnr.fsf@toke.dk>
 <20200423003911.tzuu6cxtg7olvvko@ast-mbp.dhcp.thefacebook.com>
 <878sim6tqj.fsf@toke.dk>
 <CAADnVQ+GDR15oArpEGFFOvZ35WthHyL+b97zQUxjXbz-ec5CGw@mail.gmail.com>
 <874kta6sk9.fsf@toke.dk>
 <20200423224451.rkvfnv5cbnjpepgo@ast-mbp>
 <87lfml69w0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lfml69w0.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 01:49:03AM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Thu, Apr 23, 2020 at 07:05:42PM +0200, Toke Høiland-Jørgensen wrote:
> >> >> >
> >> >> > Looks like there is indeed a bug in prog_type_ext handling code that
> >> >> > is doing
> >> >> > env->ops = bpf_verifier_ops[tgt_prog->type];
> >> >> > I'm not sure whether the verifier can simply add:
> >> >> > prog->expected_attach_type = tgt_prog->expected_attach_type;
> >> >> > and be done with it.
> >> >> > Likely yes, since expected_attach_type must be zero at that point
> >> >> > that is enforced by bpf_prog_load_check_attach().
> >> >> > So I suspect it's a single line fix.
> >> >>
> >> >> Not quite: the check in bpf_tracing_prog_attach() that enforces
> >> >> prog->expected_attach_type==0 also needs to go. So 5 lines :)
> >> >
> >> > prog_ext's expected_attach_type needs to stay zero.
> >> > It needs to be inherited from tgt prog. Hence one line:
> >> > prog->expected_attach_type = tgt_prog->expected_attach_type;
> >> 
> >> Not sure I follow you here? I ended up with the patch below - without
> >> the first hunk I can't attach freplace funcs to an xdp egress prog
> >> (since the expected_attach_type will have been propagated from
> >> verification time), and so that check will fail. Or am I missing
> >> something?
> >> 
> >> -Toke
> >> 
> >> 
> >> 
> >> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> >> index d85f37239540..40c3103c7233 100644
> >> --- a/kernel/bpf/syscall.c
> >> +++ b/kernel/bpf/syscall.c
> >> @@ -2381,10 +2381,6 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
> >>                 }
> >>                 break;
> >>         case BPF_PROG_TYPE_EXT:
> >> -               if (prog->expected_attach_type != 0) {
> >> -                       err = -EINVAL;
> >> -                       goto out_put_prog;
> >> -               }
> >>                 break;
> >
> > ahh. that extra check.
> > I think it's better to keep it for extra safety.
> > Here all expected_attach_type have clear checks depending on prog_type.
> > There is no other place where it's that obvious.
> > The verifier does similar thing earlier, but it's not that clear.
> > I think the better fix would to set expected_attach_type = 0 for PROG_TYPE_EXT
> > at the end of do_check, since we're overriding this field temporarily
> > during verification.
> 
> OK, sure, can do. I do agree it's better to keep the check. I'll send a
> proper patch tomorrow, then.
> 
> As far as a adding a selftest for this, I think the most natural thing
> would be to add it on top of David's tests for xdp_egress, since that's
> what hit this - would you be OK with that? And if so, should I send the
> main patch straight away and hold off on the selftest, or should I split
> them, or hold off on the whole thing?

I think the issue is not related to xdp egress.
Hence I'd like to push the fix along with selftest into bpf tree.
The selftest can be:
void noinline do_bind((struct bpf_sock_addr *ctx)
{
  struct sockaddr_in sa = {};

  bpf_bind(ctx, (struct sockaddr *)&sa, sizeof(sa));
  return 0;
}
SEC("cgroup/connect4")
int connect_v4_prog(struct bpf_sock_addr *ctx)
{
  return do_bind(ctx);
}

and freplace would replace do_bind() with do_new_bind()
that also calls bpf_bind().
I think without the fix freplace will fail to load, because
availability of bpf_bind() depends on correct prog->expected_attach_type.

I haven't looked at the crash you mentioned in the other email related
to xdp egress set. That could be different issue. I hope it's the same thing :)
