Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CC029A2DC
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 03:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409880AbgJ0C7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 22:59:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42620 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409718AbgJ0C7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 22:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603767540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j/zuX56M6lwTf/n0BJ4lchxCW07b2NAAyGDnkjNpYxM=;
        b=IWkIy03HF9ksSJ8iPxhJf1/I/685vp2kvz/lSTyzVMoLZ6rnsLb3KrFaV/3peM9MrRqP1+
        rnKreHwauecBymbjfuUMNbkRLFKoAC6UK8aLXQg7DNhRwhBenbtKSdGkNegojtcXm+iz5c
        z0iDFFkdV6v+lAGAJivqtJkN+C1rwJ0=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-MP8BUHYiPPOlLFzGrfi3ig-1; Mon, 26 Oct 2020 22:58:59 -0400
X-MC-Unique: MP8BUHYiPPOlLFzGrfi3ig-1
Received: by mail-pl1-f199.google.com with SMTP id q4so78559plr.11
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 19:58:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j/zuX56M6lwTf/n0BJ4lchxCW07b2NAAyGDnkjNpYxM=;
        b=fhlrktHAaF4N6dXWY+c7vL23k00LNUMraBnpkjEghDmQx9HnsOTLnHk8Nf11y+TGo9
         fIOzeZvAwtCfJve+DfQIiweE7XNcpzM7Db6LrRDWKqtlJae1xOAmrA+oiIIowOz4I++o
         afu7AqhS8vTxx2/lDLFeoYPOQIGaIR6hyY5yOj43QS7QMJ72Rmn2h9TP79oq1mUnV2A4
         VS56uPnw9FaWMunqBi+K9YJ3q1vZyetFQwT7rE/oF8f2RIOKm7t8eNutaFHer5uYDjvI
         /cwNUIckgE5QrWLmhgFeu89F3kAIP/+i2p6fWPAKBaQYLxehP05VeqvywrwklkKiRJFv
         rD8Q==
X-Gm-Message-State: AOAM533dc8BINRml4K5ciSXMHEmh6J9NRv89Tm1TnD/D+qw+jxTEgm2x
        aP2msQA67bNXE7+9Kz4Evx4xaOkxuNhn9r7sN6bJY1bkZKDftDLY39VBHGT88MVq3h8tGrDYift
        t2Ztw0sh15jORx30=
X-Received: by 2002:a17:90a:6901:: with SMTP id r1mr47450pjj.178.1603767537591;
        Mon, 26 Oct 2020 19:58:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqkkb3uDiz8D374HN4hGt0a9woJy07RNjW4K1LFkKLNyKAPot3CcJXpRwYzK2UXxCAW6QC0A==
X-Received: by 2002:a17:90a:6901:: with SMTP id r1mr47418pjj.178.1603767537264;
        Mon, 26 Oct 2020 19:58:57 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s38sm3910898pgm.62.2020.10.26.19.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 19:58:56 -0700 (PDT)
Date:   Tue, 27 Oct 2020 10:58:45 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH iproute2-next 3/5] lib: add libbpf support
Message-ID: <20201027025845.GI2408@dhcp-12-153.nay.redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201023033855.3894509-4-haliu@redhat.com>
 <29c13bd0-d2f6-b914-775c-2d90270f86d4@gmail.com>
 <87eelm5ofg.fsf@toke.dk>
 <91aed9d1-d550-cf6c-d8bb-e6737d0740e0@gmail.com>
 <20201026085610.GE2408@dhcp-12-153.nay.redhat.com>
 <063cb81c-a1b7-3893-792e-280adb6a0f33@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063cb81c-a1b7-3893-792e-280adb6a0f33@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 09:15:00AM -0600, David Ahern wrote:
> >> actually, it already does: bpf_load_program
> > 
> > Thanks for this info. Do you want to convert ipvrf.c to:
> > 
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
> > 
> 
> works for me. The rename in patch 2 can be dropped as well correct?
> 

No, the BPF_MOV64_* micros are not defined in uapi, so we still need include
"bpf_util.h", which will got bpf_prog_load() conflicts.

Thanks
Hangbin

