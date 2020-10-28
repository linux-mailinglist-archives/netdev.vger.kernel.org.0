Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0FA29E20D
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733086AbgJ2CFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgJ1ViT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:38:19 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76ABC0613CF;
        Wed, 28 Oct 2020 14:38:19 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e7so519124pfn.12;
        Wed, 28 Oct 2020 14:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VgOOpzyNDLf2TBuZoHvqmDzx3RTSmf+nBAfs2uN1EMM=;
        b=m7uFcq0o2FQ/1S8Km6hiX1ZOejBNywpp1SKSDdlGaOqO84JO9ivdbi+GUMPP9NZKSq
         aCZvIJWn6U0oAOKvFw+pzflxwD//aZeAQ+VrGuTnGWc4wPVrojQIeT+Gom1RzrhLu+dV
         7LnVVEnwD+zmfgHrSgQTZBJ+swbyr1BzuhlEW4mCRvf8jRSRZoOloCwtRXA64uunmInh
         6YF8zsPz4ESMskvPAOpmhW4W09PhNmXv4gDEeAl4u5Vj78y04elTMRGG8hE7TSe2zCQS
         0Q64DqhHs+9448ggXsk91Nfy0P/CpWPBYe/1IvzE3DxD3SJq8HocW79H9HjhK9iVq+zS
         yMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VgOOpzyNDLf2TBuZoHvqmDzx3RTSmf+nBAfs2uN1EMM=;
        b=XtpJSApTmeaz9dUGbOYuhoa2OvLEzPTibgUaByPe2MOlgwhQgn3OcS6EWUoxBB9r0b
         x90AB9bC4vTxmsLgDMGcwJd7FQqwcUZcWIll63BmIVZpGQBSBTZSfOnVVks4ga0gl32G
         o5mTYUnXTHI0XflmKVjlyAXZdF98zD544YrjMsyAiFzWBKh9BA3a64ejenZ2vJQOcNS3
         3osE9VeP2YYIxAM2fvV0LhzzTknN5+6EbuOQAF6LtoV921ns4alKmF0Bvnk56KWdFIVX
         ma/+9xJpBfcLwmcLbW0JlaGTzSF7/kLDGj+TJc3ZyzewCSUX5c/yDh8Mq8c7X93+ef+n
         C4JA==
X-Gm-Message-State: AOAM530WRc5d7RC44ygrSjgVXuZx+n1yZPbEZ0FuEqB4d/U1F6FpldwY
        WD4779tnmDg9EUBg8ebzmp3OXXNEyAqbIQ==
X-Google-Smtp-Source: ABdhPJxi0lm57/vBRIU93oZI1ZcPSTD4TUXln8CzIEuA5z3Ssci3M04KJQpWxpxmrxyAGsQfOImpeg==
X-Received: by 2002:a63:9d04:: with SMTP id i4mr1101311pgd.375.1603919710398;
        Wed, 28 Oct 2020 14:15:10 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::4:1c8])
        by smtp.gmail.com with ESMTPSA id n16sm497136pfo.150.2020.10.28.14.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 14:15:09 -0700 (PDT)
Date:   Wed, 28 Oct 2020 14:15:02 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 07/16] kallsyms: Use rb tree for kallsyms name
 search
Message-ID: <20201028211502.ishg56ogvjuj7t4w@ast-mbp.dhcp.thefacebook.com>
References: <20201022082138.2322434-1-jolsa@kernel.org>
 <20201022082138.2322434-8-jolsa@kernel.org>
 <20201028182534.GS2900849@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028182534.GS2900849@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 07:25:34PM +0100, Jiri Olsa wrote:
> On Thu, Oct 22, 2020 at 10:21:29AM +0200, Jiri Olsa wrote:
> > The kallsyms_expand_symbol function showed in several bpf related
> > profiles, because it's doing linear search.
> > 
> > Before:
> > 
> >  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s* \
> >    { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
> > 
> >      2,535,458,767      cycles:k                         ( +-  0.55% )
> >        940,046,382      cycles:u                         ( +-  0.27% )
> > 
> >              33.60 +- 3.27 seconds time elapsed  ( +-  9.73% )
> > 
> > Loading all the vmlinux symbols in rbtree and and switch to rbtree
> > search in kallsyms_lookup_name function to save few cycles and time.
> > 
> > After:
> > 
> >  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s* \
> >    { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
> > 
> >      2,199,433,771      cycles:k                         ( +-  0.55% )
> >        936,105,469      cycles:u                         ( +-  0.37% )
> > 
> >              26.48 +- 3.57 seconds time elapsed  ( +- 13.49% )
> > 
> > Each symbol takes 160 bytes, so for my .config I've got about 18 MBs
> > used for 115285 symbols.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> FYI there's init_kprobes dependency on kallsyms_lookup_name in early
> init call, so this won't work as it is :-\ will address this in v2
> 
> also I'll switch to sorted array and bsearch, because kallsyms is not
> dynamically updated

wait wat? kallsyms are dynamically updated. bpf adds and removes from it.
You even worked on some of those patches :)
