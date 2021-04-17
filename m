Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643CA3630B0
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 16:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbhDQOhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 10:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbhDQOhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 10:37:10 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79416C061574;
        Sat, 17 Apr 2021 07:36:43 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id m18so13236058plc.13;
        Sat, 17 Apr 2021 07:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/kw48fkssdZXlVDsx7NGmtleBhQ9NSDPTPGixktiQdM=;
        b=kbn/V9eldSaxbfPMrV2fmifUXxBNjwOIrkfHmU8e+Si9TkkQVQjXI8uYLWaSPAZwRo
         1RTO0k2bd2EFZ9054nI0mXxXUgrWheMEmccd0psExdtKNsdJKew8zkrmnB6M/uK2IFG3
         +8SLG4dURSmO3HR24ZYEQui8OTRDGYgcuxFxO++J4GyiMyUqcMziocMSFpmZuc+DIg+h
         TWESKOwo1eBAcup5AWMBBqa6aFju8xbcSMtSFNDWTnIvxkuqAQNVprqRwA/WV++/P2sO
         FFZc0Vc/plEra/fBCihyjRIWdYg4CBo+2sGOnWArV/6+wzsZDwmTb1TcjiUt31SRhtd8
         x6zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/kw48fkssdZXlVDsx7NGmtleBhQ9NSDPTPGixktiQdM=;
        b=CBjN4vHZfGP/UnxFqCPYwVSQPYNgJ3ZHDGn3yzW9zbSdk0SzduGu4QDEqtyathZASD
         aXHgfoDvPR5UzaVKLvknaUCDpnBfHecgbrIfNTPrazPk9xcvHwqkX7UBuGxbmI5nAUKF
         0C51ZI28ypPn2ejGRZOGEsBqEJVwb0OLluIlE2nLUvFqHik8qeFubn7E4BYNAr3PtBDL
         8pH5cIIy4+JpoPDV7fuq/02vcSjHft2GJN8DEqmvFLPo3Ol5v5oJLzd5rxu9oAZz47OC
         LqLqCyo9J1pth3SyEgSocka6ptkjCorZ1nT6gbeEShNUgXdRHEoZewYS8wM4iE4iLBGg
         7TxQ==
X-Gm-Message-State: AOAM532pd3gPk72oSfWoK42oxsSzSq+XsFNjOPBK6ZkUPFRv0XMMF7Af
        f7QKHgTLwjyLj5l1DaOfYyg=
X-Google-Smtp-Source: ABdhPJw3TYknm+JB6Tat+9RjbPNRYJT+BgAJrEiU3BfxXYpFMyzn8/NTxE6EugqvOB37Wb3ATiVYMg==
X-Received: by 2002:a17:90b:3008:: with SMTP id hg8mr10374604pjb.115.1618670202985;
        Sat, 17 Apr 2021 07:36:42 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:e902])
        by smtp.gmail.com with ESMTPSA id r1sm9236468pjo.26.2021.04.17.07.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 07:36:41 -0700 (PDT)
Date:   Sat, 17 Apr 2021 07:36:39 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/15] bpf: Add bpf_sys_close() helper.
Message-ID: <20210417143639.kq3nafzlsridtbb6@ast-mbp>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
 <20210417033224.8063-12-alexei.starovoitov@gmail.com>
 <YHpZGeOcermVlQVF@zeniv-ca.linux.org.uk>
 <CAADnVQL9tmHtRCue5Og0kBz=dAsUoFyMoOF61JM7yJhPAH8V8Q@mail.gmail.com>
 <YHpeTKV2Y+sjuzbD@zeniv-ca.linux.org.uk>
 <CAADnVQLOZ7QL61_XPCSmxDfZ0OHX_pBOmpEWLjSUwqhLm_10Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLOZ7QL61_XPCSmxDfZ0OHX_pBOmpEWLjSUwqhLm_10Jw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 10:01:43PM -0700, Alexei Starovoitov wrote:
> On Fri, Apr 16, 2021 at 9:04 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > On Fri, Apr 16, 2021 at 08:46:05PM -0700, Alexei Starovoitov wrote:
> > > On Fri, Apr 16, 2021 at 8:42 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > >
> > > > On Fri, Apr 16, 2021 at 08:32:20PM -0700, Alexei Starovoitov wrote:
> > > > > From: Alexei Starovoitov <ast@kernel.org>
> > > > >
> > > > > Add bpf_sys_close() helper to be used by the syscall/loader program to close
> > > > > intermediate FDs and other cleanup.
> > > >
> > > > Conditional NAK.  In a lot of contexts close_fd() is very much unsafe.
> > > > In particular, anything that might call it between fdget() and fdput()
> > > > is Right Fucking Out(tm).
> > > > In which contexts can that thing be executed?
> > >
> > > user context only.
> > > It's not for all of bpf _obviously_.
> >
> > Let me restate the question: what call chains could lead to bpf_sys_close()?
> 
> Already answered. User context only. It's all safe.

Not only sys_close is safe to call. Literally all syscalls are safe to call.
The current allowlist contains two syscalls. It may get extended as use cases come up.

The following two codes are equivalent:
1.
bpf_prog.c:
  SEC("syscall")
  int bpf_prog(struct args *ctx)
  {
    bpf_sys_close(1);
    bpf_sys_close(2);
    bpf_sys_close(3);
    return 0;
  }
main.c:
  int main(int ac, char **av)
  {
    bpf_prog_load_and_run("bpf_prog.o");
  }

2.
main.c:
  int main(int ac, char **av)
  {
    close(1);
    close(2);
    close(3);
  }

The kernel will perform the same work with FDs. The same locks are held
and the same execution conditions are in both cases. The LSM hooks,
fsnotify, etc will be called the same way.
It's no different if new syscall was introduced "sys_foo(int num)" that
would do { return close_fd(num); }.
It would opearate in the same user context.
