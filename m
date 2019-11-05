Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D67F01D1
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 16:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389764AbfKEPrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 10:47:14 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42834 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389399AbfKEPrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 10:47:14 -0500
Received: by mail-pg1-f193.google.com with SMTP id s23so11122697pgo.9;
        Tue, 05 Nov 2019 07:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c+SKUavQ/UUT2pvxlsKyWAGVl/eUZ1sFiKjSUHD7OWM=;
        b=tTDRl7p0Eya+1H2H5SbkUKoE0XWcF71PfZ2sZ81JCKF8hcpj0PvtpfgwEJcIb5A2rt
         BXkKQOC7EIvE95H3Mu0hYRN7voHY1q2g27U4GPdQrAXqrB4p+fTgYAUwADrl9ahl2ezb
         uYUmbvCNGf+qzWbO0cY7zqcuZXjuj47chwEXtkGy7UiRP3LBtr3I/Cn7DG30F8dCY2CZ
         czRjJ2C9Ff2HJ1umguLQgkoDaCIFmlMuKv7uVAIAsFDo834KqRNURk45Uzrh2gC0rw5x
         dyRVpMEGAXd8YfKUZQjhd15wIffmcUPD5l4pU7AByoUIlN3U+1Si/u4MZeh/WpIxZHEv
         J/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c+SKUavQ/UUT2pvxlsKyWAGVl/eUZ1sFiKjSUHD7OWM=;
        b=HtbKsCKvaF1fncW57rWbhN40tgYBEpyjfL4gKkHa0vIwbankC9dXD3dr6dwhWYsTIZ
         7pg1ZDuzBTp43X+evTWNS3UM6Z64qex5ZPiXun7IM8sg88bBkZ7BHgLFnH1437LFbiyk
         qJYQdLPTSzxQA/wYkLPjMi4KiyxGB7oLzR+V3P/uZpbxmawEvrP4YWiREPoqXBHof2lw
         xEDYOUsKX0pxl+6kcXT/D3QTMszwajfQCRopy9qDK+iAixCuP7decGQGhgMos6UQ1dmd
         xHxDS0X/T3+yYoY8Ou8IRhSfh4LkMwImB3xNAMRtbfnvdcPkP6zLUvIjHMPq4OqlqqHS
         4lbQ==
X-Gm-Message-State: APjAAAVXs308D9cYz5afrF3ws1SYm5HDAa11Q/TUQW8OPt12bLZ4Y+s0
        TJSS00iuj7mobbatirVECNM=
X-Google-Smtp-Source: APXvYqzd9skRKsgAN0zqoHd1Us8MuQbRfbt9bE2FPxQNkUxx8ibqeUOlV7InWx/0LqGJSDW2uB40kg==
X-Received: by 2002:a17:90a:d351:: with SMTP id i17mr7515469pjx.36.1572968833804;
        Tue, 05 Nov 2019 07:47:13 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:47d0])
        by smtp.gmail.com with ESMTPSA id b17sm22620435pfr.17.2019.11.05.07.47.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 07:47:13 -0800 (PST)
Date:   Tue, 5 Nov 2019 07:47:11 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, peterz@infradead.org, x86@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH bpf-next 0/7] Introduce BPF trampoline
Message-ID: <20191105154709.utmzm6qvtlux4hww@ast-mbp.dhcp.thefacebook.com>
References: <20191102220025.2475981-1-ast@kernel.org>
 <20191105143154.umojkotnvcx4yeuq@ast-mbp.dhcp.thefacebook.com>
 <20191105104024.4e99a630@grimm.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105104024.4e99a630@grimm.local.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 10:40:24AM -0500, Steven Rostedt wrote:
> On Tue, 5 Nov 2019 06:31:56 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > Steven,
> > look slike your branch hasn't been updated in 13 days.
> > Are you still planning to fix the bugs and send it in for the merge window?
> > I cannot afford to wait a full release, since I have my own follow for
> > XDP/networking based on this and other folks are building their stuff on top of
> > BPF trampoline too. So I'm thinking for v2 I will switch to using text_poke()
> > and add appropriate guard checks, so it will be safe out of the box without
> > ftrace dependency. If register_ftrace_direct() indeed comes in soon I'll
> > switch to that and will make bpf trampoline to co-operate with ftrace.
> > text_poke approach will make it such that what ever comes first to trace the
> > fentry (either bpf trampoline or ftrace) will grab the nop and the other system
> > will not be able to attach. That's safe and correct, but certainly not nice
> > long term. So the fix will be needed. The key point that switching to text_poke
> > will remove the register_ftrace_direct() dependency, unblock bpf developers and
> > will give you time to land your stuff at your pace.
> 
> Alexei,
> 
> I am still working on it, and if it seems stable enough I will submit
> it for this merge window, but there's no guarantees. It's ready when
> it's ready. I gave 5 talks last week (4 in Lyon, and one is Sofia,
> Bulgaria), thus I did not have time to work on it then. I'm currently
> in the Sofia office, and I got a version working that seems to be
> stable. But I still have to break it up into a patch series, and run it
> through more stress tests.
> 
> If you have to wait you may need to wait. The Linux kernel isn't
> something that is suppose to put in temporary hacks, just to satisfy
> someone's deadline.

Ok. I will switch to text_poke and will make it hack free.
ftrace mechanisms are being replaced by text_poke anyway.

