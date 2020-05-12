Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8532D1CF98F
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730561AbgELPqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgELPqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:46:50 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3DFC061A0C;
        Tue, 12 May 2020 08:46:50 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y25so6544071pfn.5;
        Tue, 12 May 2020 08:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tNSRPzmWFClYADxe1xlIlfleHzW5u7iF+WTFSYv3NX8=;
        b=bbL8Ikt95mBCHHnYF3umxtLlaV3QpoKK1R3R8/mLHysdhED0kL+/q03uTCyF6YCFAe
         9ibDh/kKIX9ONLWK4rBi5RXlJPxagQNZES7O6F5iuMpabJBXeK1ud76/yjQKrEMnTzFt
         pZpdrlp2TNm80ZP8xAzjaValWJRsjsWF/1RDcKCkpXrjhiu+PSbO9rLRyGNtwOZ3hjwS
         cnkucLziNWtzstvn5IwyXLOfd2XVB96F/mht/LreGA5Hl45zdBX5n0hTgVesNzaosuuT
         Cm0msfXmP7EIHmiT7YRK2NTI0wc868blqtQMrydhGQqgrNJwBTbZkWLp+ydyYB9BysJg
         aqlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tNSRPzmWFClYADxe1xlIlfleHzW5u7iF+WTFSYv3NX8=;
        b=sp3b8/aB7WUcNS0MRqIugYFMu4q/VtJkJTWI4U8PqxYvz5WvqEwDmUpi6OFleFW7sA
         /zdL5k+kUOYp1g+h+5IpqwtdikGcv9+SO2uAIuLB06EbBh+lBpeoG0RefJL59trAw9CZ
         YPLdphyeGQcH1XZJuAFNRRdUjHRi4F/4lyv7kMGd0E/7KR/13qQE8Y5d2O93WwGC1y85
         +1G50CW/vX58eS+jgn2bYIQm3XRXo7NfFDImn2Fi0ihhJIVpDjgTNgssESLBEJ1buzUs
         Ssrz2vSDVSCIO7dIY09NE8GhHVEzV9FO+N6RMzz8c7dupO2+8sRcdCOpDXcGUHZsMmfD
         r9QQ==
X-Gm-Message-State: AOAM533PEPPd6BtRv84b1ofQcJJjDJG5+DNE6D7wPyfAAW0NGLtxn6l3
        q3ZPNZ7RS6FasuTdu1qMqcA=
X-Google-Smtp-Source: ABdhPJzQpiDEYvWK/wW423EPySwX4fbTeuiCmvv4YE1jKSbcdLdtaBQ3V7V0ODDlQbjrjQoEGG518w==
X-Received: by 2002:a63:3114:: with SMTP id x20mr6644562pgx.52.1589298409771;
        Tue, 12 May 2020 08:46:49 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c3f6])
        by smtp.gmail.com with ESMTPSA id m8sm12795650pjz.27.2020.05.12.08.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 08:46:48 -0700 (PDT)
Date:   Tue, 12 May 2020 08:46:45 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jordan Glover <Golden_Miller83@protonmail.ch>
Cc:     "sdf@google.com" <sdf@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "acme@redhat.com" <acme@redhat.com>,
        "jamorris@linux.microsoft.com" <jamorris@linux.microsoft.com>,
        "jannh@google.com" <jannh@google.com>,
        "kpsingh@google.com" <kpsingh@google.com>
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
Message-ID: <20200512154645.rypojoidxtvbvwp4@ast-mbp>
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <20200508215340.41921-3-alexei.starovoitov@gmail.com>
 <20200512001210.GA235661@google.com>
 <20200512023641.jupgmhpliblkli4t@ast-mbp.dhcp.thefacebook.com>
 <ZHW2pvJicBV52gi3gjsDNXDF6t7BteEoHKvEGeVueRPPDrEKGR0OMJjTlulOoOrDNNwcK2c7HE1lNEQw8F2G6SEGCCIAekGoY0T_cnJ-oSc=@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHW2pvJicBV52gi3gjsDNXDF6t7BteEoHKvEGeVueRPPDrEKGR0OMJjTlulOoOrDNNwcK2c7HE1lNEQw8F2G6SEGCCIAekGoY0T_cnJ-oSc=@protonmail.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 12:50:05PM +0000, Jordan Glover wrote:
> On Tuesday, May 12, 2020 2:36 AM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > On Mon, May 11, 2020 at 05:12:10PM -0700, sdf@google.com wrote:
> >
> > > On 05/08, Alexei Starovoitov wrote:
> > >
> > > > From: Alexei Starovoitov ast@kernel.org
> > > > [..]
> > > > @@ -3932,7 +3977,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr
> > > > __user *, uattr, unsigned int, siz
> > > > union bpf_attr attr;
> > > > int err;
> > >
> > > > -   if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
> > > >
> > > > -   if (sysctl_unprivileged_bpf_disabled && !bpf_capable())
> > > >     return -EPERM;
> > > >     This is awesome, thanks for reviving the effort!
> > > >
> > >
> > > One question I have about this particular snippet:
> > > Does it make sense to drop bpf_capable checks for the operations
> > > that work on a provided fd?
> >
> > Above snippet is for the case when sysctl switches unpriv off.
> > It was a big hammer and stays big hammer.
> > I certainly would like to improve the situation, but I suspect
> > the folks who turn that sysctl knob on are simply paranoid about bpf
> > and no amount of reasoning would turn them around.
> >
> 
> Without CAP_BPF, sysctl was the only option to keep you safe from flow
> of bpf vulns. You didn't had to be paranoid about that.

In the year 2020 there were three verifier bugs that could have been exploited
through unpriv. All three were found by new kBdysch fuzzer. In 2019 there was
nothing. Not because people didn't try, but because syzbot fuzzer reached its
limit. This cap_bpf will help fuzzers find a new set of bugs.

The pace of bpf development is accelerating, so there will be more bugs found
and introduced in the verifier. Folks that run the very latest kernel are
taking that risk along with the risk associated with other new kernel features.
Yet other features don't have sysctls to disable them.
