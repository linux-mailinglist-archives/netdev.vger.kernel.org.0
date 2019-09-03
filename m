Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7641CA770D
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfICWaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:30:46 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36909 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbfICWap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:30:45 -0400
Received: by mail-pl1-f193.google.com with SMTP id b10so3501850plr.4
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=67Vm1F1CZhhmiaACMulYV2Zj+QF82Kmr08sCmkU9nP4=;
        b=srlfQ0Qp1/7S5KfkOV44dq9mpTjKafWnF5LFkAZo1lTzzQ124C4FeqPulpIpISr8GS
         L3TFQZihTG8HHOHvg3uUL0n3ylF9OJumJFkqEMJQ1+Cj//nUu+lyMfsI0/L2/PzmhKKE
         rv9ThwqeEztnXa8OD94tlBva6c+t/Ovk56q3K64phEMmo+0RuZLvLx9jxaVIuy06+k0O
         wTrVWRHUruwR9wu3SHA+X0oTPNqrP/xthYsjeZ6m0pGMzlh5dNDIV3WdLB20dhxpp4fQ
         VOx8672bsHhuVexHcjr4OSUUifYMN9Yxt/QiyhyT01S4AY0RCFIxdC/Kszw6hmq342Qq
         3k0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=67Vm1F1CZhhmiaACMulYV2Zj+QF82Kmr08sCmkU9nP4=;
        b=HRERysYqXz99S4CUvjgs1r9A9JsmZcr3pzNdjZ6yH/lQXsAAdtRgBOV9Ux7Pxxng37
         pu5V01JYv7e/9HRg+W/bX2NsQtpYfGacagAypQVKKLzBeZnEK5dat6prGBZ+pOcA9i0V
         SmplR+hIPU3ube8exwhX9F+ZKFpP61LdcyKR395SeCuPjPmXn4/KID7opFSGzSVXtUlz
         aaG1kOHZfvip+LrNQ3xEOtjIz84iyGH/aYBIPgg9ZId2AnmCDbcMb1KlVUaS5q7RLDDq
         HgoO0UqthoLhruiUnsMOoVPDs7+en9JqkOp+2VIMijMns5uRcWLqA15n3hBZA7yfnKDn
         WA0Q==
X-Gm-Message-State: APjAAAVmYHIV0L5RsDwhlcAbvPh3stu+vjc4WjFVzWO2Cil9hQZ/zN9g
        pqlj8X7UVWZsrspwaZYsgehS9A==
X-Google-Smtp-Source: APXvYqwpbYINQaxATyjjlM/Q2Wqx0PWzLMMfNcydNBGcEdVc1OU/3tfSNW2uaJmIFP0gHq+ZKM/40Q==
X-Received: by 2002:a17:902:441:: with SMTP id 59mr38343845ple.62.1567549844592;
        Tue, 03 Sep 2019 15:30:44 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id s186sm24332031pfb.126.2019.09.03.15.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 15:30:44 -0700 (PDT)
Date:   Tue, 3 Sep 2019 15:30:43 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Message-ID: <20190903223043.GC2101@mini-arch>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829113932.5c058194@cakuba.netronome.com>
 <CAMzD94S87BD0HnjjHVmhMPQ3UijS+oNu+H7NtMN8z8EAexgFtg@mail.gmail.com>
 <20190829171513.7699dbf3@cakuba.netronome.com>
 <20190830201513.GA2101@mini-arch>
 <eda3c9e0-8ad6-e684-0aeb-d63b9ed60aa7@fb.com>
 <20190830211809.GB2101@mini-arch>
 <20190903210127.z6mhkryqg6qz62dq@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903210127.z6mhkryqg6qz62dq@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/03, Alexei Starovoitov wrote:
> On Fri, Aug 30, 2019 at 02:18:09PM -0700, Stanislav Fomichev wrote:
> > > > 
> > > > I personally like Jakub's/Quentin's proposal more. So if I get to choose
> > > > between this series and Jakub's filter+dump in BPF, I'd pick filter+dump
> > > > (pending per-cpu issue which we actually care about).
> > > > 
> > > > But if we can have both, I don't have any objections; this patch
> 
> I think we need to have both.
> imo Jakub's and Yonghong's approach are solving slightly different cases.
> 
> filter+dump via program is better suited for LRU map walks where filter prog
> would do some non-trivial logic.
> Whereas plain 'delete all' or 'dump all' is much simpler to use without
> loading yet another prog just to dump it.
> bpf infra today isn't quite ready for this very short lived auxiliary progs.
> At prog load pages get read-only mapping, tlbs across cpus flushed,
> kallsyms populated, FDs allocated, etc.
> Loading the prog is a heavy operation. There was a chatter before to have
> built-in progs. This filter+dump could benefit from builtin 'allow all'
> or 'delete all' progs, but imo that complicates design and asks even
> more questions than it answers. Should this builtin progs show up
> in 'bpftool prog show' ? When do they load/unload? Same safety requirements
> as normal progs? etc.
> imo it's fine to have little bit overlap between apis.
> So I think we should proceed with both batching apis.
We don't need to load filter+dump every time we need a dump, right?
We, internally, want to have this 'batch dump' only for long running daemons
(I think the same applies to bcc), we can load this filter+dump once and
then have a sys_bpf() command to trigger it.

Also, related, if we add this batch dump, it doesn't mean that
everything should switch to it. For example, I feel like we
are perfectly fine if bpftool still uses get_next_key+lookup
since we use it only for debugging.

> Having said that I think both are suffering from the important issue pointed out
> by Brian: when kernel deletes an element get_next_key iterator over hash/lru
> map will produce duplicates.
> The amount of duplicates can be huge. When batched iterator is slow and
> bpf prog is doing a lot of update/delete, there could be 10x worth of duplicates,
> since walk will resume from the beginning.
> User space cannot be tasked to deal with it.
> I think this issue has to be solved in the kernel first and it may require
> different batching api.
> 
> One idea is to use bucket spin_lock and batch process it bucket-at-a-time.
> From api pov the user space will tell kernel:
> - here is the buffer for N element. start dump from the beginning.
> - kernel will return <= N elements and an iterator.
> - user space will pass this opaque iterator back to get another batch
> For well behaved hash/lru map there will be zero or one elements per bucket.
> When there are 2+ the batching logic can process them together.
> If 'lookup' is requested the kernel can check whether user space provided
> enough space for these 2 elements. If not abort the batch earlier.
> get_next_key won't be used. Instead some sort of opaque iterator
> will be returned to user space, so next batch lookup can start from it.
> This iterator could be the index of the last dumped bucket.
> This idea won't work for pathological hash tables though.
> A lot of elements in a single bucket may be more than room for single batch.
> In such case iterator will get stuck, since num_of_elements_in_bucket > batch_buf_size.
> May be special error code can be used to solve that?
This all requires new per-map implementations unfortunately :-(
We were trying to see if we can somehow improve the existing bpf_map_ops
to be more friendly towards batching.

You also bring a valid point with regard to well behaved hash/lru,
we might be optimizing for the wrong case :-)

> I hope we can come up with other ideas to have a stable iterator over hash table.
> Let's use email to describe the ideas and upcoming LPC conference to
> sort out details and finalize the one to use.
