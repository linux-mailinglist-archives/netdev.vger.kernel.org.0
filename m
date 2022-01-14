Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0567048ECF0
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 16:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243021AbiANPSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 10:18:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234014AbiANPST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 10:18:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642173498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mq7Qsa4OmDK/Jlw1qDgigFZECUU5BuQWP0ItOaVJNWo=;
        b=ZeucIdIgmkF3cWpS9V0GN147mip9/F55mgfksqSQlqfGm4e5vdzVdhsoMyd1XlQIBfkRKd
        uoAeLztpyC7Kc6UK7GnhEIM3tY2t7CyMbgceFavhgOMhPAD2XUECKwNRruuQMKkVG4BLb0
        +r48shTFmoQpcTe++Nbg3ZJa8Ln/Xk0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-d999mul6NGiSZiG4vo9uqw-1; Fri, 14 Jan 2022 10:18:17 -0500
X-MC-Unique: d999mul6NGiSZiG4vo9uqw-1
Received: by mail-wm1-f70.google.com with SMTP id i81-20020a1c3b54000000b003467c58cbddso8170384wma.5
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 07:18:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mq7Qsa4OmDK/Jlw1qDgigFZECUU5BuQWP0ItOaVJNWo=;
        b=eX8hzsApTOjklomJgWf7gUvz/VIF737Rs+u/GwwEylzaxy2oyTi0qZQ4Q1m0KOBNSf
         3kaeOlD1y9JoApJvSrltE6KxMerk5Mk/Eof3x99cDZjNP02ouszeT82oik6Nh1SnXTDm
         oD7y5RNApnHvn86EQBGpaaTqE2oKwluHO7pMR8c0qSvK+BIexK4kHIdABUHB0ykqeR9i
         t9QBEjgbsRJoR9ttVq40Q4FuQ9pkBgk0hIOFv/46W3PjYWBEzBdtJlK4sySSgbcDogjF
         w3UjpPbOyG6gPHbJgnkFlk/hWjBx+I0tU9EgLpGmYJs6Z2DBJHE0zN6QfyKY4NGlVWOK
         4yVw==
X-Gm-Message-State: AOAM533J6N2XnlyHM0uBSe3K6VfEGduNbPep72t7TplId1DpHfaqoZ25
        B5jHNiGszCD6H2XIZdWnYOKXZNwUw5ZxxCUfg1DtwHY7ewgKAFBAMsA/8Zp+BgqaEIww2L0DD+d
        dTm/JoP4tJFb95OJl
X-Received: by 2002:a50:a6ce:: with SMTP id f14mr9121091edc.105.1642173495967;
        Fri, 14 Jan 2022 07:18:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjr7yvapJIW0T2i5iOaYEHpkb6rYZHAjzU2WPIV4ZnLbIP4s8FBNjhllvcQ2T9V9ot8o/TdQ==
X-Received: by 2002:a50:a6ce:: with SMTP id f14mr9121072edc.105.1642173495809;
        Fri, 14 Jan 2022 07:18:15 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id u1sm2488013edp.19.2022.01.14.07.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 07:18:15 -0800 (PST)
Date:   Fri, 14 Jan 2022 16:18:13 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v2 3/8] rethook: Add a generic return hook
Message-ID: <YeGUNRH9MiF7dgVs@krava>
References: <164199616622.1247129.783024987490980883.stgit@devnote2>
 <164199620208.1247129.13021391608719523669.stgit@devnote2>
 <YeAaUN8aUip3MUn8@krava>
 <20220113221532.c48abf7f56d29ba95dcb0dc6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113221532.c48abf7f56d29ba95dcb0dc6@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 10:15:32PM +0900, Masami Hiramatsu wrote:
> On Thu, 13 Jan 2022 13:25:52 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > On Wed, Jan 12, 2022 at 11:03:22PM +0900, Masami Hiramatsu wrote:
> > > Add a return hook framework which hooks the function
> > > return. Most of the idea came from the kretprobe, but
> > > this is independent from kretprobe.
> > > Note that this is expected to be used with other
> > > function entry hooking feature, like ftrace, fprobe,
> > > adn kprobes. Eventually this will replace the
> > > kretprobe (e.g. kprobe + rethook = kretprobe), but
> > > at this moment, this is just a additional hook.
> > 
> > this looks similar to the code kretprobe is using now
> 
> Yes, I've mostly re-typed the code :)
> 
> > would it make sense to incrementaly change current code to provide
> > this rethook interface? instead of big switch of current kretprobe
> > to kprobe + new rethook interface in future?
> 
> Would you mean modifying the kretprobe instance code to provide
> similar one, and rename it at some point?
> My original idea is to keep the current kretprobe code and build
> up the similar one, and switch to it at some point. Actually,
> I don't want to change the current kretprobe interface itself,
> but the backend will be changed. For example, current kretprobe
> has below interface.
> 
> struct kretprobe {
>         struct kprobe kp;
>         kretprobe_handler_t handler;
>         kretprobe_handler_t entry_handler;
>         int maxactive;
>         int nmissed;
>         size_t data_size;
>         struct freelist_head freelist;
>         struct kretprobe_holder *rph;
> };
> 
> My idea is switching it to below.
> 
> struct kretprobe {
>         struct kprobe kp;
>         kretprobe_handler_t handler;
>         kretprobe_handler_t entry_handler;
>         int maxactive;
>         int nmissed;
>         size_t data_size;
>         struct rethook *rethook;
> };

looks good, will this be a lot of changes?
could you include it in the patchset?

thanks,
jirka

> 
> Of course 'kretprobe_instance' may need to be changed...
> 
> struct kretprobe_instance {
> 	struct rethook_node;
> 	char data[];
> };
> 
> But even though, since there is 'get_kretprobe(ri)' wrapper, user
> will be able to access the 'struct kretprobe' from kretprobe_instance
> transparently.
> 
> Thank you,
> 
> 
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>
> 

