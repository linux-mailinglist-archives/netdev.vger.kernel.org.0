Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C299749B930
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1584614AbiAYQun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:50:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1586012AbiAYQqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:46:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643129172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a7zU+HQutEO/qQ6hrk2sWMOj/1/xvFwsw5cfqIUqTFg=;
        b=YXrLkOqQp00vD3xY5HGVg5e3UoHk1GahXyyxKgAcMSt3+3YLwBHuvpMooY7pnkgMAa+p3o
        wFj3ugFNbmmgZqzPSOeY/n3IzZdhqLUM24+NenDLZ07lAys9Q5bCKIRvpW3uxja3iLVwdY
        Rb6B0atUerd7QdR1G/k+BmVgAHRi87s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-shYOkPJRO1WGLblpn93l-Q-1; Tue, 25 Jan 2022 11:46:11 -0500
X-MC-Unique: shYOkPJRO1WGLblpn93l-Q-1
Received: by mail-wm1-f72.google.com with SMTP id f7-20020a1cc907000000b0034b63f314ccso1746809wmb.6
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:46:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a7zU+HQutEO/qQ6hrk2sWMOj/1/xvFwsw5cfqIUqTFg=;
        b=L6gOcHWwQTVazQX7avgdGBgB9rQOklgAjhcO7A4hR2/h3lH2Wr8D/DyIDD0uyJwWjA
         f37XeXM04R5oHF75H+ra+ccuXYGEdMLhwQ0EhSI4X9LKwE7RQsXmZLBRqDifrl27dn61
         UzzrVcoiv3LX79XQ017l1faTX6XtwAI7ZgFW8itJ36UmeWtejjl/v+YgUSBw7RWP/0Ez
         wobfzsbt1KBA3ndqKP9j9k7SH8J9WEhfLydX6KVC1tbNjwENiDbj5Lc7ccrl9N8NmAQN
         HBXbGyuDT3QnZFBAnHAXOdXujdHxhST5UpMQ4pOhzHm99fL184Quh7C59Rdy7u5YrU4m
         +uzA==
X-Gm-Message-State: AOAM530Eq64H7RYUhWvAnABTGyGHqaq7BJeajkHxgEWBQ3G09Q0U4pXY
        bgNcpSTQfN6Fj2wlzDhdHXQc5ZUVpz2L+/GLM1cwsToGxPT+bwr2uw0o1y4nWUObea4YIfNe13e
        mfwyir3v1lxCZjEqV
X-Received: by 2002:a05:600c:3583:: with SMTP id p3mr2201519wmq.172.1643129170049;
        Tue, 25 Jan 2022 08:46:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwIqCv/3FYPOntW4ojvotT2V0jZL/2g+sZaZcGFbPNk+L/RtU0NW5/Vdzdeumf5jW5EHMfqMA==
X-Received: by 2002:a05:600c:3583:: with SMTP id p3mr2201493wmq.172.1643129169747;
        Tue, 25 Jan 2022 08:46:09 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id 8sm21412748wrz.57.2022.01.25.08.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 08:46:09 -0800 (PST)
Date:   Tue, 25 Jan 2022 17:46:07 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5 1/9] ftrace: Add ftrace_set_filter_ips function
Message-ID: <YfApT8uAoCODPAGu@krava>
References: <164311269435.1933078.6963769885544050138.stgit@devnote2>
 <164311270629.1933078.4596694198103138848.stgit@devnote2>
 <20220125110659.2cc8df29@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125110659.2cc8df29@gandalf.local.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 11:06:59AM -0500, Steven Rostedt wrote:

SNIP

> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index be5f6b32a012..39350aa38649 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -4958,7 +4958,7 @@ ftrace_notrace_write(struct file *file, const char __user *ubuf,
> >  }
> >  
> >  static int
> > -ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
> > +__ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
> >  {
> >  	struct ftrace_func_entry *entry;
> >  
> > @@ -4976,9 +4976,25 @@ ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
> >  	return add_hash_entry(hash, ip);
> >  }
> >  
> > +static int
> > +ftrace_match_addr(struct ftrace_hash *hash, unsigned long *ips,
> > +		  unsigned int cnt, int remove)
> > +{
> > +	unsigned int i;
> > +	int err;
> > +
> > +	for (i = 0; i < cnt; i++) {
> > +		err = __ftrace_match_addr(hash, ips[i], remove);
> > +		if (err)
> > +			return err;
> 
> On error should we revert what was done?
> 
> 			goto err;
> > +	}
> > +	return 0;
> 
> err:
> 	for (i--; i >= 0; i--)
> 		__ftrace_match_addr(hash, ips[i], !remove);
> 	return err;
> 
> Although it may not matter as it looks like it is only used on a temporary
> hash. But either it should be commented that is the case, or we do the above
> just to be more robust.

yes, that's the case.. it populates just the hash at this point
and if __ftrace_match_addr fails, the thehash is relased after
jumping to out_regex_unlock

> 
> > +}
> > +
> >  static int
> >  ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
> > -		unsigned long ip, int remove, int reset, int enable)
> > +		unsigned long *ips, unsigned int cnt,
> > +		int remove, int reset, int enable)
> >  {
> >  	struct ftrace_hash **orig_hash;
> >  	struct ftrace_hash *hash;
> > @@ -5008,8 +5024,8 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
> >  		ret = -EINVAL;
> >  		goto out_regex_unlock;
> >  	}
> > -	if (ip) {
> > -		ret = ftrace_match_addr(hash, ip, remove);
> > +	if (ips) {
> > +		ret = ftrace_match_addr(hash, ips, cnt, remove);
> >  		if (ret < 0)
> >  			goto out_regex_unlock;
> >  	}
> > @@ -5026,10 +5042,10 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
> >  }
> >  
> >  static int
> > -ftrace_set_addr(struct ftrace_ops *ops, unsigned long ip, int remove,
> > -		int reset, int enable)
> > +ftrace_set_addr(struct ftrace_ops *ops, unsigned long *ips, unsigned int cnt,
> > +		int remove, int reset, int enable)
> >  {
> > -	return ftrace_set_hash(ops, NULL, 0, ip, remove, reset, enable);
> > +	return ftrace_set_hash(ops, NULL, 0, ips, cnt, remove, reset, enable);
> >  }
> >  
> >  #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> > @@ -5634,10 +5650,29 @@ int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
> >  			 int remove, int reset)
> >  {
> >  	ftrace_ops_init(ops);
> > -	return ftrace_set_addr(ops, ip, remove, reset, 1);
> > +	return ftrace_set_addr(ops, &ip, 1, remove, reset, 1);
> >  }
> >  EXPORT_SYMBOL_GPL(ftrace_set_filter_ip);
> >  
> > +/**
> > + * ftrace_set_filter_ips - set a functions to filter on in ftrace by addresses
> 
> 		- set functions to filter on ...

will fix,

thanks,
jirka

