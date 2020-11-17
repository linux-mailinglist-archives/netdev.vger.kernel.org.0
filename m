Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB712B56C6
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgKQCiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgKQCiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:38:01 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E2CC0613CF;
        Mon, 16 Nov 2020 18:38:01 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id v21so2273781pgi.2;
        Mon, 16 Nov 2020 18:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G0DEGjjDiDmPveVipYJGdwwZdGpe8MZoy5sy/lp+AYk=;
        b=Q3jbUvXt1o/TZioJ69dwSqSViemWYwalrjEtjq6V00Ll26CxTS6m52rM4Ud11Yo45G
         F+nzur6SC5HVqkGE725YisV4bO6rwKNF19YrFAJRJguoFvpxL8fuQ3DmM1s6x8reJzzV
         QJ7wCPXdTvA6gVodrnZ21cAgj4EMCKtTt5DszsHMdlEVflFaSQQV5aqjypmKiJRaiKdI
         6AI87YfYVV/35A4ym+iSY0ZR7NZNKoYz70VCWXUVdXFP/WjTFxDkoZ8xllclbZMO0+K6
         aC/Ayq8N9xieycNoekjKiYZ5I/QS/jD9hp+U9iG3ubk14SnmLiLOSrM20CyNjYFwqgGa
         w7jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G0DEGjjDiDmPveVipYJGdwwZdGpe8MZoy5sy/lp+AYk=;
        b=asVxN81LyMw7fvns9AW8AmikSfkUamhRjiYwFy6+lUrM0rw6YwyPwN/y7iiLb9tuQf
         0J6/P+nHKxqEqzRpkEtL9pSqFmSQDZ3c2lSh3GcVPXVTEBB/8w8d++gvzImGO3OhK+D2
         /BZbbM7yt5g58OSIsd3PDUNO0uot9A5yIfdC1LT0OHPsgorqqG8OWweVl4v/7aa7ke2p
         6A76MC5qQm+kQVAkhHX7OzHYl6ozkYoqd2OsSPptNfCyaHUpmD7gw4cHtVPPuuGIo4Pl
         Q8z8SpJdDee5P5QBc4kCnq9IzJTzOzUUDc5vyIvQbCRoVGFJMsIv73RhTEmRdBc9KZpg
         oZyw==
X-Gm-Message-State: AOAM530XDIU/A85/vR7CDnUiaJghpT3siZtSPI+GsLp9nWjHHKM/0ofF
        M3vubUU5ArdLXbGZ0tgOQ9w=
X-Google-Smtp-Source: ABdhPJyIYstmthDQGzz23HPHktLu38SuvuyNa/62CpdWKhmjf0KY5VMgs5V6HGmjJYekZhriYlywcg==
X-Received: by 2002:a63:5a62:: with SMTP id k34mr1769169pgm.391.1605580681003;
        Mon, 16 Nov 2020 18:38:01 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:65f6])
        by smtp.gmail.com with ESMTPSA id 64sm8798532pfe.0.2020.11.16.18.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 18:37:59 -0800 (PST)
Date:   Mon, 16 Nov 2020 18:37:57 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiri Benc <jbenc@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv5 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201117023757.qypmhucuws3sajyb@ast-mbp>
References: <20201109070802.3638167-1-haliu@redhat.com>
 <20201116065305.1010651-1-haliu@redhat.com>
 <CAADnVQ+LNBYq5fdTSRUPy2ZexTdCcB6ErNH_T=r9bJ807UT=pQ@mail.gmail.com>
 <20201116155446.16fe46cf@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116155446.16fe46cf@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 03:54:46PM +0100, Jesper Dangaard Brouer wrote:
> 
> Thus, IMHO we MUST move forward and get started with converting
> iproute2 to libbpf, and start on the work to deprecate the build in
> BPF-ELF-loader.  I would prefer ripping out the BPF-ELF-loader and
> replace it with libbpf that handle the older binary elf-map layout, but
> I do understand if you want to keep this around. (at least for the next
> couple of releases).

I don't understand why legacy code has to be around.
Having the legacy code and an option to build tc without libbpf creates
backward compatibility risk to tc users:
Newer tc may not load bpf progs that older tc did.

> I actually fear that it will be a bad user experience, when we start to
> have multiple userspace tools that load BPF, but each is compiled and
> statically linked with it own version of libbpf (with git submodule an
> increasing number of tools will have more variations!).

So far people either freeze bpftool that they use to load progs
or they use libbpf directly in their applications.
Any other way means that the application behavior will be unpredictable.
If a company built a bpf-based product and wants to distibute such
product as a package it needs a way to specify this dependency in pkg config.
'tc -V' is not something that can be put in a spec.
The main iproute2 version can be used as a dependency, but it's meaningless
when presence of libbpf and its version is not strictly derived from
iproute2 spec.
The users should be able to write in their spec:
BuildRequires: iproute-tc >= 5.10
and be confident that tc will load the prog they've developed and tested.

> I actually thinks it makes sense to have iproute2 require a specific
> libbpf version, and also to move this version requirement forward, as
> the kernel evolves features that gets added into libbpf. 

+1
