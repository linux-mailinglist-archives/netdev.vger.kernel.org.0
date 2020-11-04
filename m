Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76B32A5F42
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 09:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgKDIWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 03:22:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55470 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725812AbgKDIWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 03:22:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604478138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0rRMbD9qVHc0o9yWb4QjRcw9fAM73631vYZJD6kplJY=;
        b=KJKNPRWQ00zXANXJ4I24AknBQfbwWhu6Xh/i4aBwg2486b1P0AS4E1npK3+3HD38/LSpId
        p4IqT1N71AxukbbpwOXR/RrGKrYUZz9qVbNhI5r564I/V2wNmHJWDbOJJmc7oApWcuQ9Tu
        zbZfk2F9oc+rFC8kcfk7AahJu7T60fc=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-Gi6oP3QPPd-M8MkOjsGafw-1; Wed, 04 Nov 2020 03:22:17 -0500
X-MC-Unique: Gi6oP3QPPd-M8MkOjsGafw-1
Received: by mail-pg1-f197.google.com with SMTP id j10so13346887pgc.6
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 00:22:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0rRMbD9qVHc0o9yWb4QjRcw9fAM73631vYZJD6kplJY=;
        b=Ff6pIEbhbjNqgGhWZL5jyVv2zTOmLLhWmBotL+0tqKwBDTPOEpntCefK/kYXeGmt8h
         1BzgUaX/nkUn3JdcUqmMIl/AHl2ucpK/44U2UBd/agAO4LU+g17xRmXdG30cQhW8P+mE
         WXV8OOE0QOBSz4V7zLZqwigX2CGvlDvugaFFT73RsnoYSFL3a62/EyzIDF6WGIqT8d8f
         aS8smoV8mxxBbn/KogxRej+cglRZhEfYDWMBgQZ0t/dDpte98FmmNhnT7UcoXpQ7M3/y
         ALHH8v58KY0SH5QBiqSg18hZBSKJ0oKZN47tzzNdLw0HmtvaurmUYDBIMbQ7517GRsVw
         nlLQ==
X-Gm-Message-State: AOAM530ixH5YwKkFOXB2lNnkgmaOLvkGxdVisAezZRvinmMpV+UuyDa7
        2RAdXgxoUISmUHs6aT4GwcNEBt+v+UOytF6z4LN/q3j6vJISw6kf4aBZStmVBq0HP65tww+3782
        X8Ytd91iE5vBaPqI=
X-Received: by 2002:a17:902:6bc2:b029:d6:e0ba:f2ff with SMTP id m2-20020a1709026bc2b02900d6e0baf2ffmr7475711plt.10.1604478136229;
        Wed, 04 Nov 2020 00:22:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfLh4HROldjTqHGlCJSe2gxrVWFlzxRqzxOsnP/Snxqrs+kwwFE6YqQtzdw8IZqm84UJ84Bw==
X-Received: by 2002:a17:902:6bc2:b029:d6:e0ba:f2ff with SMTP id m2-20020a1709026bc2b02900d6e0baf2ffmr7475690plt.10.1604478135972;
        Wed, 04 Nov 2020 00:22:15 -0800 (PST)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s18sm1389573pgh.60.2020.11.04.00.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 00:22:15 -0800 (PST)
Date:   Wed, 4 Nov 2020 16:22:03 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 3/5] lib: add libbpf support
Message-ID: <20201104082203.GP2408@dhcp-12-153.nay.redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <20201029151146.3810859-4-haliu@redhat.com>
 <db14a227-1d5e-ed3a-9ada-ecf99b526bf6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db14a227-1d5e-ed3a-9ada-ecf99b526bf6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 08:41:09AM -0700, David Ahern wrote:
> On 10/29/20 9:11 AM, Hangbin Liu wrote:
> > diff --git a/ip/ipvrf.c b/ip/ipvrf.c
> > index 33150ac2..afaf1de7 100644
> > --- a/ip/ipvrf.c
> > +++ b/ip/ipvrf.c
> > @@ -28,8 +28,14 @@
> >  #include "rt_names.h"
> >  #include "utils.h"
> >  #include "ip_common.h"
> > +
> >  #include "bpf_util.h"
> >  
> > +#ifdef HAVE_LIBBPF
> > +#include <bpf/bpf.h>
> > +#include <bpf/libbpf.h>
> > +#endif
> > +
> >  #define CGRP_PROC_FILE  "/cgroup.procs"
> >  
> >  static struct link_filter vrf_filter;
> > @@ -256,8 +262,13 @@ static int prog_load(int idx)
> >  		BPF_EXIT_INSN(),
> >  	};
> >  
> > +#ifdef HAVE_LIBBPF
> > +	return bpf_load_program(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
> > +				"GPL", 0, bpf_log_buf, sizeof(bpf_log_buf));
> > +#else
> >  	return bpf_prog_load_buf(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
> >  			         "GPL", bpf_log_buf, sizeof(bpf_log_buf));
> > +#endif
> >  }
> >  
> >  static int vrf_configure_cgroup(const char *path, int ifindex)
> > @@ -288,7 +299,11 @@ static int vrf_configure_cgroup(const char *path, int ifindex)
> >  		goto out;
> >  	}
> >  
> > +#ifdef HAVE_LIBBPF
> > +	if (bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_INET_SOCK_CREATE, 0)) {
> > +#else
> >  	if (bpf_prog_attach_fd(prog_fd, cg_fd, BPF_CGROUP_INET_SOCK_CREATE)) {
> > +#endif
> >  		fprintf(stderr, "Failed to attach prog to cgroup: '%s'\n",
> >  			strerror(errno));
> >  		goto out;
> 
> I would prefer to have these #ifdef .. #endif checks consolidated in the
> lib code. Create a bpf_compat file for these. e.g.,
> 
> int bpf_program_load(enum bpf_prog_type type, const struct bpf_insn *insns,
>                      size_t size_insns, const char *license, char *log,
>                      size_t size_log)
> {
> +#ifdef HAVE_LIBBPF
> +	return bpf_load_program(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
> +				"GPL", 0, bpf_log_buf, sizeof(bpf_log_buf));
> +#else
>  	return bpf_prog_load_buf(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
>  			         "GPL", bpf_log_buf, sizeof(bpf_log_buf));
> +#endif
> }
> 
> Similarly for bpf_program_attach.
> 
> 
> I think even the includes can be done once in bpf_util.h with a single
> +#ifdef HAVE_LIBBPF
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +#endif
> +

Oh, I just found why I didn't include libbpf.h in bpf_legacy.c.
The reason is there are more function conflicts. e.g.
bpf_obj_get, bpf_obj_pin, bpf_prog_attach.

If we move this #ifdef HAVE_LIBBPF to bpf_legacy.c, we need to rename
them all. With current patch, we limit all the legacy functions in bpf_legacy
and doesn't mix them with libbpf.h. What do you think?

Thanks
Hangbin

