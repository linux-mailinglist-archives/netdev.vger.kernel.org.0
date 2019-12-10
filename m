Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E66119FA3
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 00:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfLJXtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 18:49:36 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38947 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJXtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 18:49:36 -0500
Received: by mail-pl1-f193.google.com with SMTP id o9so575825plk.6;
        Tue, 10 Dec 2019 15:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vICYye3tdePYTTGDAiNlHrcNRiN/+ceEAJjsRWgsiY8=;
        b=Lg4ewDcAN9eaJgPzGiZpmflTlK6seE44y/ECS63krQTQByFUABg0V6ApzjB3bk3MMB
         GwLbHlQmk8QXxUg6xzwkz+EbgB0L84rvygHi7Mg/qQZMkYqsSnSpAEQEAm7qTtF+KOCr
         5L7eCjG53INQgppthCJIK9zEXpRQW7rgEz5zFyrUDEuPCvHabky76yCRS/lP9NNENWcM
         B5FdD6X+0+/inTFYqthlTAi+9GJk+UjH3yB+G/xvDWX1xE7AOHz9Vsn1laoGSmTCdxIt
         nK2NJNguFa8ZsXADDGiFXhJa4q/HHdACVf0WUIA5uWlCnq+V8H1FB1DTQzkYKk1JAr2c
         JFag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vICYye3tdePYTTGDAiNlHrcNRiN/+ceEAJjsRWgsiY8=;
        b=LHZxlyrXMLiS4sjg6eovFmArP+ROb4WvT7cK1fIQ0ehaNQ+HT2VOt2tix8r9rTk05L
         FCPkNyI2p7TR2cNSaAUH+Ffd5Of0qgSf8wFJgoGuiJb4PRzKm0QeRV/hNhO1IER4Z6o3
         9IH1WScmkRZX/3rjOaFekyaNoScyxrz0ZrnygUgaDOL6c4mKxDcQrOuO6pHwbqpGCgvK
         KRfw0/XrSRNLCNJIXSEq3sQCy54FB3S/kFt2nebVsyfddbkPsFINHjCsHiO3NAQo4aQO
         cPiRNu2q8Itxcil5YfR5RW5RtbT52a+DLycvrOsa3Znrj3clx7XeyW9fokiDteNQbz9K
         DacA==
X-Gm-Message-State: APjAAAXjwpOlxuz5+cRF87nVabN/3kl8+Kmiyv3dMw0CKEjd3ijcRTQf
        1Ryb6KTPk1ihxrXxEm4Sxwg5+Vxv
X-Google-Smtp-Source: APXvYqytWoyXWAD8mfoF/ucHzIgL3t2WMN+Cjbh3sdabKRznsCSvOlxKHN0I3j4nCVBK3CGV8Vnskw==
X-Received: by 2002:a17:90a:778a:: with SMTP id v10mr154105pjk.26.1576021775034;
        Tue, 10 Dec 2019 15:49:35 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:a25c])
        by smtp.gmail.com with ESMTPSA id t65sm139064pfd.178.2019.12.10.15.49.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Dec 2019 15:49:34 -0800 (PST)
Date:   Tue, 10 Dec 2019 15:49:33 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, x86@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf 1/3] ftrace: Fix function_graph tracer interaction
 with BPF trampoline
Message-ID: <20191210234931.mfaklfs7s4i4fsxo@ast-mbp.dhcp.thefacebook.com>
References: <20191209000114.1876138-1-ast@kernel.org>
 <20191209000114.1876138-2-ast@kernel.org>
 <20191210183519.41772e0f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210183519.41772e0f@gandalf.local.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 06:35:19PM -0500, Steven Rostedt wrote:
> On Sun, 8 Dec 2019 16:01:12 -0800
> Alexei Starovoitov <ast@kernel.org> wrote:
> 
> >  #ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> > diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
> > index 67e0c462b059..a2659735db73 100644
> > --- a/kernel/trace/fgraph.c
> > +++ b/kernel/trace/fgraph.c
> > @@ -101,6 +101,15 @@ int function_graph_enter(unsigned long ret, unsigned long func,
> >  {
> >  	struct ftrace_graph_ent trace;
> >  
> > +	/*
> > +	 * Skip graph tracing if the return location is served by direct trampoline,
> > +	 * since call sequence and return addresses is unpredicatable anymore.
> > +	 * Ex: BPF trampoline may call original function and may skip frame
> > +	 * depending on type of BPF programs attached.
> > +	 */
> > +	if (ftrace_direct_func_count &&
> > +	    ftrace_find_rec_direct(ret - MCOUNT_INSN_SIZE))
> 
> My only worry is that this may not work for all archs that implement
> it. But I figure we can cross that bridge when we get to it.

Right. Since bpf trampoline is going to be the only user in short term
it's not an issue, since trampoline is x86-64 only so far.

> > +		return -EBUSY;
> >  	trace.func = func;
> >  	trace.depth = ++current->curr_ret_depth;
> >  
> 
> I added this patch to my queue and it's about 70% done going through my
> test suite (takes around 10 - 13 hours).
> 
> As I'm about to send a pull request to Linus tomorrow, I could include
> this patch (as it will be fully tested), and then you could apply the
> other two when it hits Linus's tree.
> 
> Would that work for you?

Awesome. Much appreciate additional testing. I can certainly wait another day.
I was hoping to get patch 2 all the way to Linus's tree before rc2 to make sure
register_ftrace_direct() API is used for real in this kernel cycle. When
everything will land I'll backport to our production kernel and then the actual
stress testing begins :)

