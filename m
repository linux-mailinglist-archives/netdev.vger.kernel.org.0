Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7789F98D
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 06:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfH1Eri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 00:47:38 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33951 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfH1Erh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 00:47:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id b24so867910pfp.1;
        Tue, 27 Aug 2019 21:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eeic01nLb+jrz6NHBYno03hWLZHX6kDWo8cZ1+tLemM=;
        b=Bv4+aTUiAGlNLcatrrQ2aRogbbmQYmY1kxcFwlyFa4hnLRNwJF+5JG7Zb99SK8ZUVo
         AIli8poTUUdN3GZjUqc2ApgR6WIbjYouZf5kiCUgRZRHto855GXahFq1NBDV397zMKF/
         97nRi3s27eIagsP8b9FCo+elhaQ4nWOm14Q0ipWJ5S4NQR1TAocvjELEOLAwwYPgfa3N
         xpGkDMPwRtlXdOHM7DlpYJWge0gB5Qrj9jlQXjnIny4s2McUPLzjwWTJPBuyfXhfbRHi
         rYsdMpWzrvP2Dv6zEYsrnp4gLGqC0HdY5Hi7CmPYksnDoBJ3oDIaqWpeyP+ACa+Cm54T
         ++Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eeic01nLb+jrz6NHBYno03hWLZHX6kDWo8cZ1+tLemM=;
        b=eysJyp0xiDUapCEpbeEDiNYMDHXF1i7T2dlf6+HCp3pj4zkFpXC13P1iZPd65TlF20
         mHehS2BClBRB1iRES5+vqxbMggqdNcTzqh8VttKqDiwYpC25bck4C/dJaSi4edZOC3fH
         aegtRXeF6hv/ZowZKzdEmVRFA8bwqgnlP5RFEJJp5nZL/gLN/nEDe85UNPes/JljG/pC
         EEL0IQzXZ6+MCFud8Syhkovr4rs/npKDDPLCfNnrKaIIxMSGFso2BihmLeX1tAqQT3N2
         8EWhoTHwczhtkbxgFG2Okj3wZ3aQtjXOtP+9C+nobt13lSvdqiIUXahoR438ksrTSdzr
         7cIw==
X-Gm-Message-State: APjAAAUsYOhtUBxo6Eg0Vn2VJRUX+2w1GqwUWeCxRSdCHJpGTkcm7P3F
        xwqaYjtoWh+BOCFkveJb7SA=
X-Google-Smtp-Source: APXvYqyYNCIcPQnUGzceu7TvcwWaHhQvwGyzlaWrciR4ZSKvWBMxBEwE+ra4vaU4sP9Yj6hkORWYsA==
X-Received: by 2002:a63:2b84:: with SMTP id r126mr1841407pgr.308.1566967656853;
        Tue, 27 Aug 2019 21:47:36 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::86a2])
        by smtp.gmail.com with ESMTPSA id g26sm999188pfi.103.2019.08.27.21.47.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 21:47:36 -0700 (PDT)
Date:   Tue, 27 Aug 2019 21:47:34 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20190828044733.vvudyncwq5nffe4l@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190827192144.3b38b25a@gandalf.local.home>
 <20190828123041.c0c90c15865897461ee819a2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828123041.c0c90c15865897461ee819a2@kernel.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 12:30:41PM +0900, Masami Hiramatsu wrote:
> > kprobes can be created in the tracefs filesystem (which is separate from
> > debugfs, tracefs just gets automatically mounted
> > in /sys/kernel/debug/tracing when debugfs is mounted) from the
> > kprobe_events file. /sys/kernel/tracing is just the tracefs
> > directory without debugfs, and was created specifically to allow
> > tracing to be access without opening up the can of worms in debugfs.
> 
> I like the CAP_TRACING for tracefs. Can we make the tracefs itself
> check the CAP_TRACING and call file_ops? or each tracefs file-ops
> handlers must check it?

Thanks for the feedback.
I'll hack a prototype of CAP_TRACING for perf bits that I understand
and you folks will be able to use it in ftrace when initial support lands.
imo the question above is an implementation detail that you can resolve later.
I see it as a followup to initial CAP_TRACING drop.

