Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 449131664B9
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 18:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgBTR0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 12:26:19 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46991 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbgBTR0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 12:26:17 -0500
Received: by mail-pl1-f196.google.com with SMTP id y8so1789999pll.13;
        Thu, 20 Feb 2020 09:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=rd9V9UVot8QU4dxlhd2hiItv4T8JnKu0tmvJU9d76Mc=;
        b=DVJVOjF/NpMyaCti9AT2IcWEgTOh97ItS+8v/GkN/axFHO6cpdKDcNjVaIYzNsuW4d
         pWVzXr8VWbeXYsSazvJEpGEylMBOahWyJ4WkjtDLIB2j7HIy6OgrIKmpVWyWmhsWa/y1
         6UCKir+Oze+XMJ6f94yZ3zOWO86YlzTcvXmwK5CyBXMR4Pt2nNef7jVpLkvk/xLN5FRO
         EiHyf9bVz8GkJ7LlFTTAUxMHwqGZMPls8OY2nXQ9iWn4OUMD145nBXumjibd4qk3sJGK
         UgPkVby+Eqk8+08do88I0FqUrgGwFmu047iGhPxL4qKsTQxYoVkh3PfaTwgGuq3TA/sN
         4Y1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=rd9V9UVot8QU4dxlhd2hiItv4T8JnKu0tmvJU9d76Mc=;
        b=qC9plWDVAz+9o5T2Usn6Bv+YB4TEdvT16ihDnZp3QTTZGTBfy22JBDzWm5DwSO5xmF
         BV2qnhmJxPdFMZW/ZjGavHEBcPMFok07FJ5obn209XJ7MglBFl0UyN2/7kuiMEGXyMu6
         uPkHqOKaXisS37ZqWwtpegUVkJ6RyFbiWDaa4sN96djKFU7jOCKL4jNNXYWJZ9wcTeut
         ZeET4qtoH5GYvs3lMa+brrmQR22hQ5zsMyqgCaMCG2fDkB65uel0W5jJrS+6c78Ugnvd
         Tr2tS+St6eZ9pkDqQ2BU92i042XKqdikYsmQAlTc6+VshdYGVLJWO48zxXafgDsLCpFA
         axGQ==
X-Gm-Message-State: APjAAAVf2+ND9h3krY5n2rdzqZs9QkeWQqlgt5OR4d3oPvHQjCho0lze
        0J4h6f+xkJZ8Uiipl1cwJSM=
X-Google-Smtp-Source: APXvYqzzYrRNU74LyvTtgsiXF8m+qglQOpoFbG3DJDW9Hmj/MkCj/EzGIFcOmbG/UgoZKBG8o9QuvQ==
X-Received: by 2002:a17:902:fe13:: with SMTP id g19mr32897315plj.216.1582219576802;
        Thu, 20 Feb 2020 09:26:16 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::5:f03d])
        by smtp.gmail.com with ESMTPSA id c3sm177528pfj.159.2020.02.20.09.26.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Feb 2020 09:26:15 -0800 (PST)
Date:   Thu, 20 Feb 2020 09:26:13 -0800
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
Message-ID: <20200220172612.7aqmiwrnizgsukvm@ast-mbp>
References: <20200219180348.40393e28@carbon>
 <CAEf4Bza9imKymHfv_LpSFE=kNB5=ZapTS3SCdeZsDdtrUrUGcg@mail.gmail.com>
 <20200219192854.6b05b807@carbon>
 <CAEf4BzaRAK6-7aCCVOA6hjTevKuxgvZZnHeVgdj_ZWNn8wibYQ@mail.gmail.com>
 <20200219210609.20a097fb@carbon>
 <CAEUSe79Vn8wr=BOh0RzccYij_snZDY=2XGmHmR494wsQBBoo5Q@mail.gmail.com>
 <20200220002748.kpwvlz5xfmjm5fd5@ast-mbp>
 <4a26e6c6-500e-7b92-1e26-16e1e0233889@kernel.org>
 <20200220173740.7a3f9ad7@carbon>
 <MWHPR13MB0895649219625C5F7380314FFD130@MWHPR13MB0895.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MWHPR13MB0895649219625C5F7380314FFD130@MWHPR13MB0895.namprd13.prod.outlook.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 05:02:25PM +0000, Bird, Tim wrote:
> 
> 
> > -----Original Message-----
> > From:  Jesper Dangaard Brouer
> > 
> > On Wed, 19 Feb 2020 17:47:23 -0700
> > shuah <shuah@kernel.org> wrote:
> > 
> > > On 2/19/20 5:27 PM, Alexei Starovoitov wrote:
> > > > On Wed, Feb 19, 2020 at 03:59:41PM -0600, Daniel Díaz wrote:
> > > >>>
> > > >>> When I download a specific kernel release, how can I know what LLVM
> > > >>> git-hash or version I need (to use BPF-selftests)?
> > > >
> > > > as discussed we're going to add documentation-like file that will
> > > > list required commits in tools.
> > > > This will be enforced for future llvm/pahole commits.
> > > >
> > > >>> Do you think it is reasonable to require end-users to compile their own
> > > >>> bleeding edge version of LLVM, to use BPF-selftests?
> > > >
> > > > absolutely.
> 
> Is it just the BPF-selftests that require the bleeding edge version of LLVM,
> or do BPF features themselves need the latest LLVM.  If the latter, then this
> is quite worrisome, and I fear the BPF developers are getting ahead of themselves.
> We don't usually have a kernel dependency on the latest compiler version (some
> recent security fixes are an anomaly).  In fact deprecating support for older compiler
> versions has been quite slow and methodical over the years.
> 
> It's quite dangerous to be baking stuff into the kernel that depends on features
> from compilers that haven't even made it to release yet.
> 
> I'm sorry, but I'm coming into the middle of this thread.  Can you please explain
> what the features are in the latest LLVM that are required for BPF-selftests?

Above is correct. bpf kernel features do depend on the latest pahole and llvm
features that did not make it into a release. That was the case for many years
now and still the case. The first commit 8 years ago relied on something that
can generate those instructions. For many years llvm was the only compiler that
could generate them. Right now there is GCC backend as well. New features (like
new instructions) depend on the compiler.

selftests/bpf are not testing kernel's bpf features. They are testing the whole
bpf ecosystem. They test llvm, pahole, libbpf, bpftool, and kernel together.
Hence it's a requirement to install the latest pahole and llvm.

When I'm talking about selftests/bpf I'm talking about all the tests in that
directory combined. There are several unit tests scattered across repos. The
unit tests for llvm bpf backend are inside llvm repo.
selftests/bpf/test_verifier and test_maps are unit tests for the verifier and
for maps. They are llvm independent. They test a combination of kernel and
libbpf only. But majority of the selftests/bpf are done via test_progs which
are the whole ecosystem tests.
