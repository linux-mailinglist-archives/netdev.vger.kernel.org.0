Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE23107D47
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 07:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfKWGSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 01:18:11 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38889 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfKWGSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 01:18:10 -0500
Received: by mail-pg1-f195.google.com with SMTP id t3so4047952pgl.5;
        Fri, 22 Nov 2019 22:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7tw8oroQd2gfUzMBdvLC7B67ai1AkBmJ/VV6wf40F28=;
        b=PIot3RBakNIYCV+2+O9HMNblrbqzlEkB8kbE30lI48HqzkOrbMYyFbVnyxfseNBU2k
         uIckG9SdVc1xBblVJ7MaD260ReMNmH2FjSJ8HmfZiZRrwRpdwnwBu4uK6qYXCq+l0+I3
         +LZalSKfJWVpsf4rK0EMjkyuSxdrt+1lTq0HDpfTuPpFaw1u9KYlAsVtssF3Sziz8c09
         MP6GmUIBCCGiYrLAmSpNvik276Eu6I9JUBwJ/v8KwFpgxfgp3ggQSmawroJmkvbgsoMx
         mIEHEOLm9/ACIDuOCV2cMI7mOm7yhfmaZBqr2M4gt3iYWZrrHhrPxAoTYRyglUTvC1Lr
         9gLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7tw8oroQd2gfUzMBdvLC7B67ai1AkBmJ/VV6wf40F28=;
        b=c55tMAOpib1OaDRf0qgeA83eN5xvC1SXMlxL1hC5iaJHuJjp/FEuQQIVNg1/WmEXdG
         Y0pu6TElHv8vIzaOprEdcRf/wMOqrYlmLIhINFHbWp1Tfy+lwj69VOiMDYWGpjqYP1x3
         ftFchyPzzu+ROFOFYqk51P/TDrxcpolfHozhRUkQSO/YGwV83fEj8iiYEdCCgjsns+kS
         /IHAVMo2PvBdOU7Gm8NRaEzi7eklFMFCL119a7xiZnG0aAuOeZPEQbKAHXO3Wv/iI2wJ
         Zs8xYhXTWonF06UZ/0vV7NSGlTpW04ALcaH9a7fWKQwek2I5dOoWaR/Ah7qRNAaOJ1l3
         61HA==
X-Gm-Message-State: APjAAAXRqR6adI+CG4x1OQ4TKoUgFqM2yqwEiuGh9Q7GcH9CTJPl44tx
        ov//1C6FcYMLO59/7BXlrFY=
X-Google-Smtp-Source: APXvYqz8YFdx85VX/5gV9dY8jQ5pIpotMWs4UfBQNpLQsih4umFHt/fmPdGRTjfZ0RftGNmVHtgHpQ==
X-Received: by 2002:a62:528d:: with SMTP id g135mr22266929pfb.172.1574489890003;
        Fri, 22 Nov 2019 22:18:10 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::2490])
        by smtp.gmail.com with ESMTPSA id z10sm582182pgc.5.2019.11.22.22.18.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Nov 2019 22:18:09 -0800 (PST)
Date:   Fri, 22 Nov 2019 22:18:07 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 7/8] bpf, x86: emit patchable direct jump as
 tail call
Message-ID: <20191123061805.grankibnqpae4tnd@ast-mbp.dhcp.thefacebook.com>
References: <cover.1574452833.git.daniel@iogearbox.net>
 <6ada4c1c9d35eeb5f4ecfab94593dafa6b5c4b09.1574452833.git.daniel@iogearbox.net>
 <CAEf4BzaWhYJAdjs+8-nHHjuKfs6yBB7yx5NH-qNv2tcjiVCVhw@mail.gmail.com>
 <ba52688c-49bf-7897-4ba2-f62f30d501a9@iogearbox.net>
 <CAADnVQJqYE5TAdJ=o8nHSF1mXoXpsVNXcJtWSPQJDn7wUvxR=Q@mail.gmail.com>
 <CAEf4BzZS-yAfYXruzG5+_Wh0Ob4-ChPMPuhcDx4zDoGwUQygcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZS-yAfYXruzG5+_Wh0Ob4-ChPMPuhcDx4zDoGwUQygcA@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 09:00:35PM -0800, Andrii Nakryiko wrote:
> On Fri, Nov 22, 2019 at 6:28 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Nov 22, 2019 at 3:25 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > >> +       case BPF_MOD_CALL_TO_NOP:
> > > >> +       case BPF_MOD_JUMP_TO_NOP:
> > > >> +               if (old_addr && !new_addr) {
> > > >> +                       memcpy(new_insn, nop_insn, X86_PATCH_SIZE);
> > > >> +
> > > >> +                       prog = old_insn;
> > > >> +                       ret = emit_patch_fn(&prog, old_addr, ip);
> > > >> +                       if (ret)
> > > >> +                               return ret;
> > > >> +                       break;
> > > >> +               }
> > > >> +               return -ENXIO;
> > > >> +       default:
> > > >
> > > > There is this redundancy between BPF_MOD_xxx enums and
> > > > old_addr+new_addr (both encode what kind of transition it is), which
> > > > leads to this cumbersome logic. Would it be simpler to have
> > > > old_addr/new_addr determine whether it's X-to-NOP, NOP-to-Y, or X-to-Y
> > > > transition, while separate bool or simple BPF_MOD_CALL/BPF_MOD_JUMP
> > > > enum determining whether it's a call or a jump that we want to update.
> > > > Seems like that should be a simpler interface overall and cleaner
> > > > implementation?
> > >
> > > Right we can probably simplify it further, I kept preserving the original
> > > switch from Alexei's code where my assumption was that having the transition
> > > explicitly spelled out was preferred in here and then based on that doing
> > > the sanity checks to make sure we don't get bad input from any call-site
> > > since we're modifying kernel text, e.g. in the bpf_trampoline_update() as
> > > one example the BPF_MOD_* is a fixed constant input there.
> >
> > I guess we can try adding one more argument
> > bpf_arch_text_poke(ip, BPF_MOD_NOP, old_addr, BPF_MOD_INTO_CALL, new_addr);
> 
> I was thinking along the lines of:
> 
> bpf_arch_text_poke(ip, BPF_MOD_CALL (or BPF_MOD_JMP), old_addr, new_addr);
> 
> old_addr/new_addr being possibly NULL determine NOP/not-a-NOP.

I see. Something like:
if (BPF_MOD_CALL) {
   if (old_addr)
       memcmp(ip, old_call_insn);
   else
       memcmp(ip, nop_insn);
} else if (BPF_MOD_JMP) {
   if (old_addr)
       memcmp(ip, old_jmp_insn);
   else
       memcmp(ip, nop_insn);
}
I guess that can work.

