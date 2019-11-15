Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C082EFDC84
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 12:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfKOLsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 06:48:55 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]:32834 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfKOLsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 06:48:54 -0500
Received: by mail-oi1-f171.google.com with SMTP id m193so8389769oig.0
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 03:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9GPmR1RHoM5XEidlvhXl8DpCMhSSpVMr2s8LhTaetUo=;
        b=caDlsscO5M4zQIh58q+dXUMxvXiuxQRJuU2wP18uYJ8cxeIS9f1jxwaI4xV8lQoPy4
         xr1nk59+5ZbsSPfLBDb94VzuIXfQ/Udb5UPBWs3SntlUCHhqRHP3vylj2n1J2hgOLZHK
         bSexU1qchwK6fgNCpnQ8dXzOTuQiIPgkMRAas=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9GPmR1RHoM5XEidlvhXl8DpCMhSSpVMr2s8LhTaetUo=;
        b=J1K6YYDk1bf4GbqkBer6UoiVG1dNQWYPOxohyLiHQCVBbPBT/4/MTx4UmpL7avzCNt
         OVtamCZOmvz/zpERJE4LJ3D5N0sf2Hw+y8pi3jxVflCbcrXIpkLxFhvA9k7SHX84HcQa
         7MnY1CUdJi3xh8uT8iuTVCUzl/ifRYP6H0+TxtwhwzZZbQ5nM9sDWzpPpLFc8ZVratg7
         r31PL0ehzzvc/jlPgTgH8pg/ZbxUD63h9xFUx6ZqCrYuu2W1ZiPzOQZ7qDlM7BsO7cqg
         ePtgvKRwbmhOKrzoCaLxMgFDjjoroFqv6j7sXnjLhR9U3XyGcBpE4P8ViopUh9G/xl9w
         MwmA==
X-Gm-Message-State: APjAAAXRBIV8AwisETIEbAqEGSdleNQfdz3YhG7dIuMIurOob5OLBM0i
        Y0azKBFHueRTFj81SFLosag8v2pG7RBvf3krR+qsAw==
X-Google-Smtp-Source: APXvYqwHA7DX4s2fSU4j+a929BjylFpQuxPWMmBxeY+lV5DSTZLISTZYnV77TJnwW4DVSxPIfreJuOgk17CI3BrxZjc=
X-Received: by 2002:aca:d803:: with SMTP id p3mr7623323oig.13.1573818533550;
 Fri, 15 Nov 2019 03:48:53 -0800 (PST)
MIME-Version: 1.0
References: <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com>
 <87v9srijxa.fsf@toke.dk> <5da4ab712043c_25f42addb7c085b83b@john-XPS-13-9370.notmuch>
 <87eezfi2og.fsf@toke.dk> <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com>
 <87r23egdua.fsf@toke.dk> <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk> <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk> <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 15 Nov 2019 11:48:42 +0000
Message-ID: <CACAyw98dcpu1b2nUf7ize2SJGJGd=mhqRK+PYQTx96gSBtbkNQ@mail.gmail.com>
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 at 02:51, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> This is static linking. The existing kernel infrastructure already supports
> such model and I think it's enough for a lot of use cases. In particular fb's
> firewall+katran XDP style will fit right in. But bpf_tail_calls are
> incompatible with bpf2bpf calls that static linking will use and I think
> cloudlfare folks expressed the interest to use them for some reason even within
> single firewall ? so we need to improve the model a bit.

We several components that we'd like to keep (logically) separate. At a high
level, our rootlet would look like this:

  sample_packets(ctx);
  if (ddos_mitigate(ctx) != XDP_PASS) {
     return XDP_DROP;
  }
  return l4lb(ctx);

I think we could statically link ddos_mitigate() together from
multiple separate .o.
It depends on how complicated our rules become. Maybe we'd use dynamic linking,
to reduce the overhead of re-verification.

The rootlet would use dynamic linking, to be able to debug / inspect
sampling, ddos
mitigation and the l4lb separately. Combined with the ability to hook
arbitrary BPF
programs at entry / exit we could probably get rid of our tail_call
use. I don't think
you have to change the model for us to fit into it.

> We can introduce dynamic linking. The second part of 'BPF trampoline' patches
> allows tracing programs to attach to other BPF programs. The idea of dynamic
> linking is to replace a program or subprogram instead of attaching to it.

Reading the rest of the thread, I'm on board with type 2 of dynamic linking
(load time linking?) However, type 1 (run time linking) I'm not so sure about.
Specifically, the callee holding onto the caller instead of vice versa.

Picking up your rootlet and fw1 example: fw1 holds the refcount on rootlet.
This means user space needs to hold the refcount on fw1 to make sure
the override is kept. This in turn means either: hold on to the file descriptor
or pin the program into a bpffs. The former implies a persistent process,
which doesn't work for tc. The latter makes  lifetime management of fw1 hard:
there is no way to have the kernel automatically deallocate it when it no longer
needed, aka when the rootlet refcount reaches zero. It also overloads close()
to automatically detach the replaced / overridden BPF, which is contrary to how
other BPF hook points work.

I'd much prefer if the API didn't require attach_prog_fd and id at
load time, and
rather have an explicit replace_sub_prog(prog_fd, btf_id, sub_prog_fd).

> [...] This rootlet.o
> can be automatically generated by libxdp.so. If in the future we figure out how
> to do two load-balancers libxdp.so will be able to accommodate that new policy.
> This firewall1.o can be developed and tested independently of other xdp
> programs. The key gotcha here is that the verifier needs to allow more than 512
> stack usage for the rootlet.o. I think that's acceptable.

How would the verifier know which programs are allowed to have larger stacks?

Lorenz

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
