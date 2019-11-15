Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69869FE755
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 22:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKOV6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 16:58:37 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36485 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfKOV6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 16:58:37 -0500
Received: by mail-pl1-f195.google.com with SMTP id d7so5578769pls.3;
        Fri, 15 Nov 2019 13:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=A5OMK1zeB/qrhQEAwF7SBf2BmH5OmZtE2PhBz5VZyxg=;
        b=PqVUfHsoe8xIfrMR7yUvqzsdE1wwdJaq+qDHtH01+UtMc2LnJEJ0QVH6O0mMC/ipht
         hzOEvarh7WR7syGk3t31Kg3vECRyEr2eSIONzPuKSA+TfPf2Blk1K8ZjiGIhlZBAKSQQ
         GCMQl9dEw3zz8u1OFCJfgO136Yzh1xlOkK98IDWra7XJWYBHbvh64AuNu+UE37Syrpcg
         HH/bD3S5CyMPogySqmAj6dS8070q2ysrIVOOsFlLtLW+btuejP6vwAlBtNSWJw2xZm/B
         YEDjqgv4TFFPZ477Ho/9SZgUBoSOAMArSh35lB8wv+/PCYm3PitjJCgy3rPf03sjn0Nr
         8x2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=A5OMK1zeB/qrhQEAwF7SBf2BmH5OmZtE2PhBz5VZyxg=;
        b=TujJ/uB8nIlDOE/fDaCC+yQ5IoCA6WjxqjZ2FUuYccyD24dopgqvYLpD5eteOR6UcK
         PPZCSC4leWvur2yRRDNpZVncf9JfErx3TJD3K7TNpsHSbVXvzmZUR4YbW7fGaAsuUViK
         BNP8waTyn4x3eProeFWCu1pQnyq/K6R0HkLHVadKR0u3JYnaObIruZQWZff4FPNKuSI7
         eP0EYwe6ZuZCaptqABsJOAqIL0oVxWEAMEqN1+lXanNETdaK2iP7iPaUisP6IueSvdR6
         3CUioYGNhH1vtXHYGx7TYNFnY9u3G9T9juHJct7A+UmKCsp0xVeeFqS5Q9ZRYplD5EJA
         2vtg==
X-Gm-Message-State: APjAAAWMQvZt1IHQzDVqJMBc+CW0oUyMfyJ+8RRFvi88FdQgW0AojWUt
        +6fJFj5nhdNyfqzJo/79FD0=
X-Google-Smtp-Source: APXvYqwzPUlhhlguwASfYzxeugSOePJhJ3BL+6xDjNvDCDbSrT+2a3/kI5WSrqubw3eZD/3UDznGNg==
X-Received: by 2002:a17:902:bf08:: with SMTP id bi8mr9884659plb.75.1573855116491;
        Fri, 15 Nov 2019 13:58:36 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::8ac1])
        by smtp.gmail.com with ESMTPSA id r28sm12270472pfl.37.2019.11.15.13.58.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 13:58:35 -0800 (PST)
Date:   Fri, 15 Nov 2019 13:58:34 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Edward Cree <ecree@solarflare.com>
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
Message-ID: <20191115215832.6d3npfegpp5vhq6u@ast-mbp.dhcp.thefacebook.com>
References: <20191113204737.31623-1-bjorn.topel@gmail.com>
 <20191113204737.31623-3-bjorn.topel@gmail.com>
 <20191115003024.h7eg2kbve23jmzqn@ast-mbp.dhcp.thefacebook.com>
 <CAJ+HfNhKWND35Jnwe=99=8rWt81fhy9pRpXCVRYTu=C=aj13KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNhKWND35Jnwe=99=8rWt81fhy9pRpXCVRYTu=C=aj13KQ@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 08:56:59AM +0100, Björn Töpel wrote:
> On Fri, 15 Nov 2019 at 01:30, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> [...]
> >
> > Could you try optimizing emit_mov_imm64() to recognize s32 ?
> > iirc there was a single x86 insns that could move and sign extend.
> > That should cut down on bytecode size and probably make things a bit faster?
> > Another alternative is compare lower 32-bit only, since on x86-64 upper 32
> > should be ~0 anyway for bpf prog pointers.
> 
> Good ideas, thanks! I'll do the optimization, extend it to >4 entries
> (as Toke suggested), and do a non-RFC respin.
> 
> > Looking at bookkeeping code, I think I should be able to generalize bpf
> > trampoline a bit and share the code for bpf dispatch.
> 
> Ok, good!
> 
> > Could you also try aligning jmp target a bit by inserting nops?
> > Some x86 cpus are sensitive to jmp target alignment. Even without considering
> > JCC bug it could be helpful. Especially since we're talking about XDP/AF_XDP
> > here that will be pushing millions of calls through bpf dispatch.
> >
> 
> Yeah, I need to address the Jcc bug anyway, so that makes sense.
> 
> Another thought; I'm using the fentry nop as patch point, so it wont
> play nice with other users of fentry atm -- but the plan is to move to
> Steve's *_ftrace_direct work at some point, correct?

Yes. I'll start playing with reg/mod/unreg_ftrace_direct on Monday.
Steven has a bunch more in his tree for merging, so I cannot just pull
all of ftrace api features into bpf-next. So "be nice to other fentry users"
would have to be done during merge window or shortly after in bpf-next tree
after window closes. I think it's fine. In bpf dispatch case it's really
one dummy function we're talking about. If it was marked 'notrace'
from get go no one would blink. It's a dummy function not interesting
for ftrac-ing and not interesting from live patching pov.

