Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C909F166706
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 20:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgBTTSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 14:18:52 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54564 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbgBTTSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 14:18:52 -0500
Received: by mail-pj1-f66.google.com with SMTP id dw13so1272049pjb.4;
        Thu, 20 Feb 2020 11:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rMhIIEZUgKeNZVyeBrXf1C0vRvoNcRcDaKcwizMaibs=;
        b=Uf0O8u+TCDQjNTfqxcb7pdKzT0RQtcRKal2XfSILe8ZNYBq4r1ipuFOgPMy8NaF6F5
         1ZdM34p4WSfuysS42LplXeiN5JNnzjtnNokeh5Q+sauL9gato/bBSuuxc7tfFQ4kYCRz
         2CA+YhU+hIVmI1RTr3O5nf1iThf4FPGqM+5BQdGF/PfGHk6CfrIomkH0JjFlLJNUXMys
         /HpHbvgMynqUhUbgxiWF3cE9mFDyIE3n2IZYAabaWvkDFl1NM4qLAW4NpigJ0NYgYnEq
         FQPHACl4BJcJ5APXU7bhuYLA/GZMALl90Nz96X2m574RP4t1vXleQlj+V/5Onnr8GFgI
         k/Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rMhIIEZUgKeNZVyeBrXf1C0vRvoNcRcDaKcwizMaibs=;
        b=JD3jEt9+XzIZLFp3AUkjDehLp7gIBmuXzdFBpTP1Kq5qoceWKjEEqM7C60UEjaVsF5
         ifz48qbOn7gGXDvFJ5uzAGJUMS4q4Fufa9tqS1eWRw1tMJCxtYWjZQNwGsSm9sHlZCsY
         RUReeQHEtKJl61xuLhnLIVoa5FlaUmO59dTSRRTl0gMADrtTa16jQsf6K4zy4mfBkSei
         O8san3EJAysZmvRLgrYJzacuP20V02vvQE/eQcTGwpAYyzRyJB46Ws9Rpl0enL+3ZJRb
         VBedFUu6B+fnV574gq9/I054LJpKBViPMT7RxOTWw6+77Bi5A/xZGjcIyaRCSAwdf999
         Oh2g==
X-Gm-Message-State: APjAAAVHUaojVGt0HUpKzt+X8wdLsMu3VE4F/rEhTckUpIziZEVjChQt
        Iss8Uvjc0vvuLDPJdeq08PI=
X-Google-Smtp-Source: APXvYqw5JxeeJ/AWAadkS9nmdRGpCmWdRi47H8MKfTkbp2DWpc/mINUruptzlSs4Bv/cMOf01GMjHA==
X-Received: by 2002:a17:902:348:: with SMTP id 66mr32468100pld.137.1582226329710;
        Thu, 20 Feb 2020 11:18:49 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::5:f03d])
        by smtp.gmail.com with ESMTPSA id j21sm213384pji.13.2020.02.20.11.18.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Feb 2020 11:18:48 -0800 (PST)
Date:   Thu, 20 Feb 2020 11:18:46 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     "Bird, Tim" <Tim.Bird@sony.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        shuah <shuah@kernel.org>,
        Daniel =?utf-8?B?RMOtYXo=?= <daniel.diaz@linaro.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
Message-ID: <20200220191845.u62nhohgzngbrpib@ast-mbp>
References: <20200219192854.6b05b807@carbon>
 <CAEf4BzaRAK6-7aCCVOA6hjTevKuxgvZZnHeVgdj_ZWNn8wibYQ@mail.gmail.com>
 <20200219210609.20a097fb@carbon>
 <CAEUSe79Vn8wr=BOh0RzccYij_snZDY=2XGmHmR494wsQBBoo5Q@mail.gmail.com>
 <20200220002748.kpwvlz5xfmjm5fd5@ast-mbp>
 <4a26e6c6-500e-7b92-1e26-16e1e0233889@kernel.org>
 <20200220173740.7a3f9ad7@carbon>
 <MWHPR13MB0895649219625C5F7380314FFD130@MWHPR13MB0895.namprd13.prod.outlook.com>
 <20200220172612.7aqmiwrnizgsukvm@ast-mbp>
 <MWHPR13MB0895B185BC36759121D6F26AFD130@MWHPR13MB0895.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR13MB0895B185BC36759121D6F26AFD130@MWHPR13MB0895.namprd13.prod.outlook.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 05:41:51PM +0000, Bird, Tim wrote:
> 
> So - do the BPF developers add new instructions to the virtual machine, that then
> have to be added to both the compiler and the executor (VM implementation)?

Right. New instructions are added to the kernel and llvm at the same time. The
kernel and llvm release cadence and process are different which complicates it
for us.

> It sounds like the compiler support and executor support is done in concert, and
> that patches are at least accepted upstream (but possibly are not yet available in
> a compiler release) for the compiler side.  What about the Linux kernel side?  Is the
> support for a new instruction only in non-released kernels (say, in the BPF development
> tree), or could it potentially be included in a released kernel, before the compiler
> with matching support is released?  What would happen if a bug was found, and
> compiler support for the instruction was delayed?  

As with all chicken-and-egg problems the feature has to land in one of the
repos first. That was one of the reasons llvm community switched to mono repo
to avoid clang vs llvm conflicts. The kernel and llvm are not going to be in a
single repo, so we have to orchestrate the landing. Most of the time it's easy,
because we maintain both kernel and llvm components. But in some cases it's
very difficult. For example we've delayed landing kernel and libbpf patches by
about six month, since we couldn't get an agreement on how the feature has to
be implemented in clang.

> I suppose that this would only
> mean that the executor supported an instruction that never appeared in a compiled
> BPF program? Is that right?

The answer is yes. It is the case that the kernel supports certain bpf
instructions, but llvm doesn't know how to emit them. But it has nothing to do
with landing of features and release cadence.
