Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787A149BB02
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbiAYSMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:12:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22510 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233950AbiAYSL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 13:11:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643134318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZYZFcKeTPsQCFaSsqNlB8G3oqmreXQCJIoK82/wxEkU=;
        b=XEI8APwOLMstwDfrWdiGxohk0Tj8iYSCVRKmV+JMtqSXFTuhnopJyp3loDxYaHHf8o6WO3
        zXkPX9jUNBdvt/mZ5qSie953p3xwpFT67vrMTvNMTWIr8HrCqg8yCIjR4ZExKqYfBDjcK3
        WoGPRhqRNFS9hfmvU8oHnW67UDy54qE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-hy8-s6oYNAqIZcskIGp_RQ-1; Tue, 25 Jan 2022 13:11:56 -0500
X-MC-Unique: hy8-s6oYNAqIZcskIGp_RQ-1
Received: by mail-ej1-f69.google.com with SMTP id m21-20020a1709061ed500b006b3003ec50dso3778941ejj.17
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 10:11:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZYZFcKeTPsQCFaSsqNlB8G3oqmreXQCJIoK82/wxEkU=;
        b=SGcMh/z2PnbZ9+cNvh8nh/YM85yhQ6eYQBB4LYSpzxZWcypiU2pAfJzLf6YBTjDH1G
         o9RY0iLVr0CRt1V9dc74AU23tPk9A34xm4vY9T7xN4v1pcDV8WkJDytV8hAq3IXV3VOu
         U/i/ebMoQaHjv1kbea1xUCvJSdh7D73xKIEcP20/qWMgfBrKWSDbf83gdAYuiHVI6F8u
         SZn3vkIu30+VJiiFTo/QUF9KMZLkdHXQ/U2mgGBh6JxBwZGIOD+EmUsW21c7cTLuuaT+
         QVFKfC3KjArYt/E875zkYDDkn3XlYNG68h8Cd+FEaxt+3H3gb/fpARvvRLRTmwwBF9yU
         lo6g==
X-Gm-Message-State: AOAM530RgG5hcXSm3tTtAEjFMdWKSWVzzCrCF3Z07JPKbIFxK1SGcS97
        dy/sTW+ldAhvNNWEv+j24C9EPrss3djFUCa1OGDrMAvtUNWHKEwWcqNsseB9iebpDu3dHgdCr99
        jMKDA9WLbvKrPJ8vZ
X-Received: by 2002:a17:907:9605:: with SMTP id gb5mr17348661ejc.685.1643134315388;
        Tue, 25 Jan 2022 10:11:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyoPAYB5FVJEoP403NezL+MUS0Tv2jX6/UgHpSL8/pKp8IUbV8+JT6INoyPbobrfnoWYRryPQ==
X-Received: by 2002:a17:907:9605:: with SMTP id gb5mr17348639ejc.685.1643134315151;
        Tue, 25 Jan 2022 10:11:55 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id k7sm6425341ejp.182.2022.01.25.10.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 10:11:54 -0800 (PST)
Date:   Tue, 25 Jan 2022 19:11:52 +0100
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
Subject: Re: [PATCH v5 2/9] fprobe: Add ftrace based probe APIs
Message-ID: <YfA9aC5quQNc89Hc@krava>
References: <164311269435.1933078.6963769885544050138.stgit@devnote2>
 <164311271777.1933078.9066058105807126444.stgit@devnote2>
 <YfAoMW6i4gqw2Na0@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfAoMW6i4gqw2Na0@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 05:41:24PM +0100, Jiri Olsa wrote:
> On Tue, Jan 25, 2022 at 09:11:57PM +0900, Masami Hiramatsu wrote:
> 
> SNIP
> 
> > +
> > +/* Convert ftrace location address from symbols */
> > +static int convert_func_addresses(struct fprobe *fp)
> > +{
> > +	unsigned long addr, size;
> > +	unsigned int i;
> > +
> > +	/* Convert symbols to symbol address */
> > +	if (fp->syms) {
> > +		fp->addrs = kcalloc(fp->nentry, sizeof(*fp->addrs), GFP_KERNEL);
> > +		if (!fp->addrs)
> > +			return -ENOMEM;
> > +
> > +		for (i = 0; i < fp->nentry; i++) {
> > +			fp->addrs[i] = kallsyms_lookup_name(fp->syms[i]);
> > +			if (!fp->addrs[i])	/* Maybe wrong symbol */
> > +				goto error;
> > +		}
> > +	}
> > +
> > +	/* Convert symbol address to ftrace location. */
> > +	for (i = 0; i < fp->nentry; i++) {
> > +		if (!kallsyms_lookup_size_offset(fp->addrs[i], &size, NULL))
> > +			size = MCOUNT_INSN_SIZE;
> > +		addr = ftrace_location_range(fp->addrs[i], fp->addrs[i] + size);
> 
> you need to substract 1 from 'end' in here, as explained in
> __within_notrace_func comment:
> 
>         /*
>          * Since ftrace_location_range() does inclusive range check, we need
>          * to subtract 1 byte from the end address.
>          */
> 
> like in the patch below
> 
> also this convert is for archs where address from kallsyms does not match
> the real attach addresss, like for arm you mentioned earlier, right?
> 
> could we have that arch specific, so we don't have extra heavy search
> loop for archs that do not need it?

one more question..

I'm adding support for user to pass function symbols to bpf fprobe link
and I thought I'd pass symbols array to register_fprobe, but I'd need to
copy the whole array of strings from user space first, which could take
lot of memory considering attachment of 10k+ functions

so I'm thinking better way is to resolve symbols already in bpf fprobe
link code and pass just addresses to register_fprobe

I assume you want to keep symbol interface, right? could we have some
flag ensuring the conversion code is skipped, so we don't go through
it twice?

in any case I need addresses before I call register_fprobe, because
of the bpf cookies setup

thanks,
jirka

