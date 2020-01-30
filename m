Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91F5014E525
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 22:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgA3Vxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 16:53:37 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:37995 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgA3Vxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 16:53:36 -0500
Received: by mail-pj1-f68.google.com with SMTP id j17so1918672pjz.3;
        Thu, 30 Jan 2020 13:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9+c98/oxOHNUyGzccjUUkoAPacv6RdIiORztEtMrVFg=;
        b=JPzkUj15fmdkrIov+SnkTmU2zB7E7+Hbp7Nl5dtXaMGB0Yx8nxkoEcGhP/y2C2SXV/
         GETslDWAycWZatUHi2bPosvtIUwNEtuF+w9YluWht43vyvCR8Vt/HL51//R5yLWyoLmY
         y0ljRO3wJ2DHUA5H8uW0f2bQQa9KY3Mn9zVZ2J2uuvOIpBpuPogle0yUig96qY27QcKe
         dc3sr9mUAaiWIG8QRj1YSStKqwnd5InhveK/r6/a3cA+i16tsWsxeTUxUjlkxizCvS07
         hL0e5QpNbGlDN5CK4UKeaoEdx5bYJb5RAIVP/j/4uaS51rIdsQwDUNKZo40ENCDXXFTS
         SEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9+c98/oxOHNUyGzccjUUkoAPacv6RdIiORztEtMrVFg=;
        b=mOFPxaejzeNxZAGACRvDDBBG0kc6frEn0Yp/mJ+IS2aYDBiwdQ2t6QuUcpwRBQB4eH
         be9pi2Mag7d3ZW9MQbK5rLa54eDlKHbnRSle2zEpITzy+z4NERM0vxulIrzyVCdxJw+7
         kO++jQiKTqJlqXAsRGjVu6RaBjdwS+0q6d3boZSPjji/Nfs/vsgbYuf8XU9SLfKo6SnY
         2sb/Mkuw8zs0/udfqc72GUyQeR8JJpgFUjFwnCr9suU/7kcSeBQ6gX00XEcXOhgpVWNq
         m702iFrNi49P3/5UM0nzG3/LOe4ndmuRWlwqn7nJ25hj2DRFf9+4FKYEMudrQkwXAbcv
         ANOw==
X-Gm-Message-State: APjAAAV3J6zm/wUm+SsG+7I4nvvTP61maG9ZPwzzCKasFcXJKqAOSIyz
        FDmmEzXn9vzaBOcJvwaNkEQ=
X-Google-Smtp-Source: APXvYqy33u2/xNEqTgqNLZvCqe3TzkhXp2Z2m50hMoQoqOkZTn/ou8M8jOaf688IUyPSssG0OwPFqA==
X-Received: by 2002:a17:90b:30c9:: with SMTP id hi9mr7143094pjb.81.1580421214217;
        Thu, 30 Jan 2020 13:53:34 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::2:f7d])
        by smtp.gmail.com with ESMTPSA id f127sm7694372pfa.112.2020.01.30.13.53.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2020 13:53:32 -0800 (PST)
Date:   Thu, 30 Jan 2020 13:53:31 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Matt Cover <werekraken@gmail.com>
Cc:     daniel@iogearbox.net, davem@davemloft.net,
        Matthew Cover <matthew.cover@stackpath.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: unstable bpf helpers proposal. Was: [PATCH bpf-next v2 1/2] bpf: add
 bpf_ct_lookup_{tcp,udp}() helpers
Message-ID: <20200130215330.f3unziderf5rlipf@ast-mbp>
References: <20200118000128.15746-1-matthew.cover@stackpath.com>
 <20200121202038.26490-1-matthew.cover@stackpath.com>
 <CAGyo_hpVm7q3ghW+je23xs3ja_COP_BMZoE_=phwGRzjSTih8w@mail.gmail.com>
 <CAOftzPi74gg=g8VK-43KmA7qqpiSYnJVoYUFDtPDwum10KHc2Q@mail.gmail.com>
 <CAGyo_hprQRLLUUnt9G4SJnbgLSdN=HTDDGFBsPYMDC5bGmTPYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGyo_hprQRLLUUnt9G4SJnbgLSdN=HTDDGFBsPYMDC5bGmTPYA@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 02:46:30PM -0700, Matt Cover wrote:
> 
> In addition to the nf_conntrack helpers, I'm hoping to add helpers for
> lookups to the ipvs connection table via ip_vs_conn_in_get(). From my
> perspective, this is again similar. 

...

> Writing to an existing nf_conn could be added to this helper in the
> future. Then, as an example, an XDP program could populate ct->mark
> and a restore mark rule could be used to apply the mark to the skb.
> This is conceptually similar to the XDP/tc interaction example.

...

> I'm planning to add a bpf_tcp_nf_conn() helper which gives access to
> members of ip_ct_tcp. This is similar to bpf_tcp_sock() in my mind.

...

> I touched on create and update above. Delete, like create, would
> almost certainly be a separate helper. This submission is not
> intended to put us on that track. I do not believe it hinders an
> effort such as that either. Are you worried that adding nf_conn to
> bpf is a slippery slope?

Looks like there is a need to access quite a bit of ct, ipvs internal states.
I bet neigh, route and other kernel internal tables will be next. The
lookup/update/delete to these tables is necessary. If somebody wants to do a
fast bridge in XDP they may want to reuse icmp_send(). I've seen folks
reimplementing it purely on BPF side, but kernel's icmp_send() is clearly
superior, so exposing it as a helper will be useful too. And so on and so
forth. There are lots of kernel bits that BPF progs want to interact with.

If we expose all of that via existing bpf helper mechanism we will freeze a
large chunk of networking stack. I agree that accessing these data structures
from BPF side is useful, but I don't think we can risk hardening the kernel so
much. We need new helper mechanism that will be unstable api. It needs to be
obviously unstable to both kernel developers and bpf users. Yet such mechanim
should allow bpf progs accessing all these things without sacrificing safety.

I think such new mechanism can be modeled similar to kernel modules and
EXPORT_SYMBOL[_GPL] convention. The kernel has established policy that
these function do change and in-tree kernel modules get updated along the way
while out-of-tree gets broken periodically. I propose to do the same for BPF.
Certain kernel functions can be marked as EXPORT_SYMBOL_BPF and they will be
eligible to be called from BPF program. The verifier will do safety checks and
type matching based on BTF. The same way it already does for tracing progs.
For example the ct lookup can be:
struct nf_conn *
bpf_ct_lookup(struct __sk_buff *skb, struct nf_conntrack_tuple *tuple, u32 len,
              u8 proto, u64 netns_id, u64 flags)
{
}
EXPORT_SYMBOL_BPF(bpf_ct_lookup);
The first argument 'skb' has stable api and type. It's __sk_buff and it's
context for all skb-based progs, so any program that got __sk_buff from
somewhere can pass it into this helper.
The second argument is 'struct nf_conntrack_tuple *'. It's unstable and
kernel internal. Currently the verifier recognizes it as PTR_TO_BTF_ID
for tracing progs and can do the same for networking. It cannot recognize
it on stack though. Like:
int bpf_prog(struct __sk_buff *skb)
{
  struct nf_conntrack_tuple my_tupple = { ...};
  bpf_ct_lookup(skb, &my_tupple, ...);
}
won't work yet. The verifier needs to be taught to deal with PTR_TO_BTF_ID
where it points to the stack.
The last three arguments are scalars and already recognized as SCALAR_VALUE by
the verifier. So with minor extensions the verifier will be able to prove the
safety of argument passing.

The return value is trickier. It can be solved with appropriate type
annotations like:
struct nf_conn *
bpf_ct_lookup(struct __sk_buff *skb, struct nf_conntrack_tuple *tuple, u32 len,
             u8 proto, u64 netns_id, u64 flags)
{ ...
}
EXPORT_SYMBOL_BPF__acquires(bpf_ct_lookup);
int bpf_ct_release(struct nf_conn * ct)
{ ...
}
EXPORT_SYMBOL_BPF__releases(bpf_ct_release);
By convention the return value is acquired and the first argument is released.
Then the verifier will be able to pair them the same way it does
bpf_sk_lookup()/bpf_sk_release(), but in declarative way. So the verifier code
doesn't need to be touched for every such function pair in the future.

Note struct nf_conn and struct nf_conntrack_tuple stay kernel internal.
BPF program can define fields it wants to access as:
struct nf_conn {
  u32 timeout;
  u64 status;
  u32 mark;
} __attribute__((preserve_access_index));
int bpf_prog()
{
  struct nf_conn *ct = bpf_ct_lookup(...);
  if (ct) {
       ct->timeout;
  }
}
and CO-RE logic will deal with kernel specific relocations.
The same way it does for tracing progs that access all kernel data.

I think it's plenty obvious that such bpf helpers are unstable api. The
networking programs will have access to all kernel data structures, receive
them from white listed set of EXPORT_SYMBOL_BPF() functions and pass them into
those functions back. Just like tracing progs that have access to everything.
They can read all fields of kernel internal struct sk_buff and pass it into
bpf_skb_output().
The same way kernel modules can access all kernel data structures and call
white listed set of EXPORT_SYMBOL() helpers.
