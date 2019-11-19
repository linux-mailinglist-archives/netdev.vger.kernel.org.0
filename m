Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3811017EE
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 07:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbfKSGEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 01:04:43 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43217 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728668AbfKSGEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 01:04:42 -0500
Received: by mail-lj1-f194.google.com with SMTP id y23so21841560ljh.10;
        Mon, 18 Nov 2019 22:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LWwgCpo+ONcCb1xvseKQ8V1GFmEQ8iCPPdkSeh2r6dE=;
        b=Pzo7t/rdLPqs5Nh2p+mkIgQ+P64x4igcfBM1hW/EFhKBXktBcoEdHd4i1xc6go+vDe
         Ki3j3wlgAUso/nWk2wqVzKzEHyoKr/dtEHuCxoUtlQiS/ZyvqlEyCNshAFkDSAGRjNrr
         Q2fONQKrfaS7iMz21SbEZ4lggxI/mu85xksbOwA2t+cwhB8VFVeJE/A4PGH1GqWi+U+E
         IbjnhBKUZ/yDt7iVe45EBNvSus8oPgEHqqBXBbU9B5SsPRb+FmJdI7bxh4ROMD0t175A
         YsWIofbiM8o8V2AyNusI5krU33Z7BdAFg6tCQmqeSJO5pkH75ohFRe9XTUQfCdCVXIbK
         TqMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LWwgCpo+ONcCb1xvseKQ8V1GFmEQ8iCPPdkSeh2r6dE=;
        b=JARsTbbGTzUxRijVlvSZ6PTc9FdHBoGKjiP7wULR3/mL2jEmCNvqU3F8M47gzjtwym
         EEGkwiI7CH72Fl2biL1zYzhdxbiSjUE6PQXLgrphz69gexBM4UPErWuciAjBB0viBrg2
         mDZc+OIQsE/ril4sknuOEFcZbW16lHA8WO5uUWpzcQDa0UcfHleoCiB9zKaWQJa89qMA
         YswXwrQ3Zy6auD7pzbsGefbtvNiVO2ChAIqy0Kye30tnR5ntt528fgPDPloaDBJBNN8M
         OOD9PsLsZXqAKyxBGBkNX1MGkAPbzNIrKCFqoDXoqa+cQUk2PrN5CY+MF9sGxuQrUfkb
         Ov5w==
X-Gm-Message-State: APjAAAU78UhCDeWExt/Mag5Mon6XvmamHqJxnnz8n5LE2q2qdXxRTzhl
        hyeXZCyVh0L/lTSDeH451JEOG1D/zWjD5T2hSuA=
X-Google-Smtp-Source: APXvYqwtBfqqZPW51aleFh11Rq4IMdt72P+yjWQChrFc5L2+g8hcqM9UfSWGDKHEwtgDfjNdefSRYxkwkV8XSN5wPEs=
X-Received: by 2002:a2e:970a:: with SMTP id r10mr2346980lji.142.1574143479689;
 Mon, 18 Nov 2019 22:04:39 -0800 (PST)
MIME-Version: 1.0
References: <20191114194636.811109457@goodmis.org> <20191114194738.938540273@goodmis.org>
 <20191115215125.mbqv7taqnx376yed@ast-mbp.dhcp.thefacebook.com> <20191117171835.35af6c0e@gandalf.local.home>
In-Reply-To: <20191117171835.35af6c0e@gandalf.local.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 18 Nov 2019 22:04:28 -0800
Message-ID: <CAADnVQ+OzTikM9EhrfsC7NFsVYhATW1SVHxK64w3xn9qpk81pg@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] ftrace: Add modify_ftrace_direct()
To:     Steven Rostedt <rostedt@goodmis.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 17, 2019 at 2:18 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 15 Nov 2019 13:51:26 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > Thanks a lot for implementing it.
> > Switching to iterator just to modify the call.. hmm.
> > So "call direct_bpf_A" gets replaced to "call ftrace_stub" to do the iterator
> > only to patch "call direct_bpf_B" later. I'm struggling to see why do that when
> > arch can provide call to call rewrite easily. x86 and others have such ability
> > already. I don't understand why you want to sacrifice simplicity here.
> > Anyway with all 3 apis (register, modify, unreg) it looks complete.
> > I'll start playing with it on Monday.
>
> Now if you take my latest for-next branch, and add the patch below,

I took your for-next without the extra patch and used it from bpf trampoline.
It's looking good so far. Passed basic testing. Will add more stress tests.

Do you mind doing:
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 73eb2e93593f..6ddb203ca550 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -256,16 +256,16 @@ struct ftrace_direct_func
*ftrace_find_direct_func(unsigned long addr);
 # define ftrace_direct_func_count 0
 static inline int register_ftrace_direct(unsigned long ip, unsigned long addr)
 {
-       return -ENODEV;
+       return -ENOTSUPP;
 }
 static inline int unregister_ftrace_direct(unsigned long ip, unsigned
long addr)
 {
-       return -ENODEV;
+       return -ENOTSUPP;
 }
 static inline int modify_ftrace_direct(unsigned long ip,
                                       unsigned long old_addr,
unsigned long new_addr)
 {
-       return -ENODEV;
+       return -ENOTSUPP;
 }

otherwise ENODEV is a valid error when ip is incorrect which is
indistinguishable from ftrace not compiled in.
