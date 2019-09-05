Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D91A98D2
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 05:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbfIEDPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 23:15:24 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39905 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730522AbfIEDPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 23:15:24 -0400
Received: by mail-pl1-f195.google.com with SMTP id bd8so576407plb.6;
        Wed, 04 Sep 2019 20:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M9kK4lnn4QWgK3aVUJHGfBKHMQgkBIahHY2CNTBrC38=;
        b=ps8vcP/NzmSlHSVUktgvOMCdEfBc6LNuqs8/Ua+QBFMrCpZ0RzpkqdlACzMERPvose
         g2WDt/RTbyIbwY0y3Ujuyo4UwRQ1rz1ykFSpX/l9d3AxR8NwjcqWytJN+ajm6wcQGwpx
         5avFfRsm6Ce5Zh6kiAVEG3ewL2AVsrRKd8pJDRhOZQYMR6IwfFcc88A9+htQdGBL13/8
         2X09m1mazkMFiDZnxq6x+bGZG1XnOmdS2MKOIeRz3uKGjrwgYV//l+FsA6nKbOtd2J57
         1jD9QHj53f+4kd/CNpR4/mBtpIy50HDI82bWHdqN9Q/P8NmQKPviVkt7E7j2mngvaB7p
         7EUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M9kK4lnn4QWgK3aVUJHGfBKHMQgkBIahHY2CNTBrC38=;
        b=kiEN+3W+JmUxSDNaQ1iLLIV6m7b/ReQ+at3C6iH3RC0GL/TRYe+7a65WzIcRDurhIb
         MPg3GxHkcbRzkoJ/zgWYc7CxGmMlFU1V/Yrvhh9Tr//ZMYzxHVmCeesnfyLf+DTLX8a0
         Tp793J/CHSoYg/fbSp6/hAqfxnic1iUFo9+kHpJYz2RUKafEdPJ8ooIXa0aPz94pNDrF
         5HxNjhRV3/9WYFpzhjOGPvmlowHtlKw6SDgYAXXPj0sJGNSJuvhDz8WncuhQbTrQ6l4B
         +cQgPRfUY6/+75SwndUvZ1N301HGGjz5VkyIP3uC/4Lw+ISCzyeGClgVligpyvEPVOwr
         gaHw==
X-Gm-Message-State: APjAAAVm1A5f9KW4S7nlTcTlwg4K8OlCRZExdUMLPo2w6eq87ZGoxEcq
        zAWuDeiT1RWAeOpPmP1JY0s=
X-Google-Smtp-Source: APXvYqxD9A+uQyPcPcvllT5lUgOILEJX3q3tGQfTYmDsbChMdOxYNaahmdH50zQ51LQorjZkAV38Rw==
X-Received: by 2002:a17:902:5a1:: with SMTP id f30mr1119434plf.64.1567653323106;
        Wed, 04 Sep 2019 20:15:23 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::af43])
        by smtp.gmail.com with ESMTPSA id g14sm508166pfo.133.2019.09.04.20.15.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 20:15:22 -0700 (PDT)
Date:   Wed, 4 Sep 2019 20:15:20 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 2/3] bpf: implement CAP_BPF
Message-ID: <20190905031518.behyq7olkh6fjsoe@ast-mbp.dhcp.thefacebook.com>
References: <20190904184335.360074-1-ast@kernel.org>
 <20190904184335.360074-2-ast@kernel.org>
 <CE3B644F-D1A5-49F7-96B6-FD663C5F8961@fb.com>
 <20190905013245.wguhhcxvxt5rnc6h@ast-mbp.dhcp.thefacebook.com>
 <E342EC2A-24F6-4581-BFDC-119B5E02B560@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E342EC2A-24F6-4581-BFDC-119B5E02B560@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 05, 2019 at 02:51:51AM +0000, Song Liu wrote:
> 
> 
> > On Sep 4, 2019, at 6:32 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> > On Thu, Sep 05, 2019 at 12:34:36AM +0000, Song Liu wrote:
> >> 
> >> 
> >>> On Sep 4, 2019, at 11:43 AM, Alexei Starovoitov <ast@kernel.org> wrote:
> >>> 
> >>> Implement permissions as stated in uapi/linux/capability.h
> >>> 
> >>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >>> 
> >> 
> >> [...]
> >> 
> >>> @@ -1648,11 +1648,11 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
> >>> 	is_gpl = license_is_gpl_compatible(license);
> >>> 
> >>> 	if (attr->insn_cnt == 0 ||
> >>> -	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
> >>> +	    attr->insn_cnt > (capable_bpf() ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
> >>> 		return -E2BIG;
> >>> 	if (type != BPF_PROG_TYPE_SOCKET_FILTER &&
> >>> 	    type != BPF_PROG_TYPE_CGROUP_SKB &&
> >>> -	    !capable(CAP_SYS_ADMIN))
> >>> +	    !capable_bpf())
> >>> 		return -EPERM;
> >> 
> >> Do we allow load BPF_PROG_TYPE_SOCKET_FILTER and BPF_PROG_TYPE_CGROUP_SKB
> >> without CAP_BPF? If so, maybe highlight in the header?
> > 
> > of course. there is no change in behavior.
> > 'highlight in the header'?
> > you mean in commit log?
> > I think it's a bit weird to describe things in commit that patch
> > is _not_ changing vs things that patch does actually change.
> > This type of comment would be great in a doc though.
> > The doc will be coming separately in the follow up assuming
> > the whole thing lands. I'll remember to note that bit.
> 
> I meant capability.h:
> 
> + * CAP_BPF allows the following BPF operations:
> + * - Loading all types of BPF programs
> 
> But CAP_BPF is not required to load all types of programs. 

yes, but above statement is still correct, right?

And right below it says:
 * CAP_BPF allows the following BPF operations:
 * - Loading all types of BPF programs
 * - Creating all types of BPF maps except:
 *    - stackmap that needs CAP_TRACING
 *    - devmap that needs CAP_NET_ADMIN
 *    - cpumap that needs CAP_SYS_ADMIN
which is also correct, but CAP_BPF is not required
for array, hash, prog_array, percpu, map-in-map ...
except their lru variants...
and except if they contain bpf_spin_lock...
and if they need BTF it currently can be loaded with cap_sys_admin only...

If we say something about socket_filter, cg_skb progs in capability.h
we should clarify maps as well, but then it will become too big for .h
The comments in capability.h already look too long to me.
All that info and a lot more belongs in the doc.

> On a second thought, I am not sure whether we will keep capability.h
> up to date with all features. So this is probably OK.

It's clearly not for cap_sys_admin.
cap_net_admin is not up to date either.
These two are kitchen sink of anything root-like and networking-root like.
Developers didn't bother updating that .h
With CAP_BPF we can enforce through patch acceptance policy that
major new things (like big verifier features) should have a line
in capability.h
Though .h is not a replacement for proper doc which will come as follow up.
Unlike bpf.h that serves as a template for auto-generating man pages
capability.h is not such thing. I won't change often either.
So normal doc is a better way to document all details.

