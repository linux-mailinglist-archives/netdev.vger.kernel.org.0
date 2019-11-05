Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA11BF02AA
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390163AbfKEQ2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:28:05 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38542 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389760AbfKEQ2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:28:05 -0500
Received: by mail-pl1-f194.google.com with SMTP id w8so9703232plq.5;
        Tue, 05 Nov 2019 08:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B2IFqWxwKFOtDSg8bQpR44pQOxg7g5OY8D9rmjCxQ2Q=;
        b=PCxnlTVXd7J7Lirh4zxddJLFB2elYNVL6D8z+Z+glZ2zG4vGB5rZAax5cjhnVc7vOV
         mRjCFcocm8gC8GBuFG3UZjkF3tcqq1No+VaEaviwWA5O36quHAWalwi9n41qeqLD4YvM
         zH1rVYNJi4NmWzx8keNFwCzNGBuXHlPdC1eKoHlhPSQWpunXDy1muJaoUOhYJsSwA/rA
         +jTsqfzJ7P9nLnwcB7FwpLGIOiMtB4a499YzmYNH83w1BUm/kEM2fiYMTZAL/Lq0pE5g
         /vb5iC0KDEJ+c2IGHTYLWnpC6KmonLGmiW7BwgvA4AlbaJOSqyWZtpMIOiUryiOz2JAa
         dS8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B2IFqWxwKFOtDSg8bQpR44pQOxg7g5OY8D9rmjCxQ2Q=;
        b=Aqn48I4Uxxb05DEjrQzvHpt6kTogE5C2HWoTQFzRLaNb5k/Y0AMTPFqlxcXHDgExwK
         Hhr08P/Xsiv/B4K0TjOr2FPKo8W566gpSLdzQnT7H7DmxrWka7Zh2hNogetb0fbLvtMV
         FelRkDqpuWdniptQGVs5BlmeuyEStWtIqVaN/2+YAifLXfEEFVQDP90uGTcuyqCg8kMS
         y3OQ7/NuKEUe7vPoELWz/zlKeJX+IFLEv1HQ+dspM8doRYv1CQlnoiEYjUZPRJPjOLBE
         7DviTuN+RLHt4SZsWfxtzqevXQzWJ3lier92tOSfS2jpr0ZBC4KDX7tx5ZlgTha0oeJt
         yAaA==
X-Gm-Message-State: APjAAAX1Lt4/1lBT4G7RHbugrGHQUp/7bF2bJusv238gPb2KcDD+CQbv
        bn8yJWeNXcb6pCrOxCJFQBI=
X-Google-Smtp-Source: APXvYqxCb+54Vf7gn4Uag6RqfPgUJtq5JH3Zsz8R5xHTjxE53G0u8/P4xR467Aj8DUs8y2A4lgLOvQ==
X-Received: by 2002:a17:902:f:: with SMTP id 15mr34802330pla.324.1572971284566;
        Tue, 05 Nov 2019 08:28:04 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:47d0])
        by smtp.gmail.com with ESMTPSA id f2sm17780441pfg.48.2019.11.05.08.28.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 08:28:03 -0800 (PST)
Date:   Tue, 5 Nov 2019 08:28:02 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, peterz@infradead.org, x86@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH bpf-next 0/7] Introduce BPF trampoline
Message-ID: <20191105162801.sffoqe2yedrrplnn@ast-mbp.dhcp.thefacebook.com>
References: <20191102220025.2475981-1-ast@kernel.org>
 <20191105143154.umojkotnvcx4yeuq@ast-mbp.dhcp.thefacebook.com>
 <20191105104024.4e99a630@grimm.local.home>
 <20191105154709.utmzm6qvtlux4hww@ast-mbp.dhcp.thefacebook.com>
 <20191105110028.7775192f@grimm.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105110028.7775192f@grimm.local.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 11:00:28AM -0500, Steven Rostedt wrote:
> On Tue, 5 Nov 2019 07:47:11 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > > If you have to wait you may need to wait. The Linux kernel isn't
> > > something that is suppose to put in temporary hacks, just to satisfy
> > > someone's deadline.  
> > 
> > Ok. I will switch to text_poke and will make it hack free.
> > ftrace mechanisms are being replaced by text_poke anyway.
> 
> I see that Facebook now owns Linux.

huh?

> Peter's text poke patches most likely not be ready for the next
> merge window either. Don't you require them?

nope.
But I strongly support them. ftrace->text_poke + static_call + nop2
are all great improvements.
I'd really like to see them landing in this merge window.

> The database of function nops are part of the ftrace mechanisms which
> are not part of text poke, and there's strong accounting associated to
> them which allows the user to see how their kernel is modified. 

I guess the part that wasn't obvious from commit log of bpf trampoline patches
is that they don't care about nops and ftrace recording of nops. bpf trampoline
will work even if there are no nops in front of the function. It will work when
CONFIG_HAVE_FENTRY is off.

