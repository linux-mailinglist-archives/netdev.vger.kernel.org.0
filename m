Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70C5277B68
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgIXWAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:00:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726205AbgIXWAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 18:00:02 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600984801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=36zI2byukpSXMDYkFOd0oKqSvwDoA1ZB+u3FjofG804=;
        b=fSDyI7Z2vusCnKbbzzNqVU6hqg7W4MgT2OwO1H1yVQZOZd5Xlo7XKE07t+k+DaTh+y/CNU
        fR1B6/8rOp/NELGOy2I16lSDQG2gJBgv8iFlxF8lQNvdUlZ615aBP09Hcjupla23kIzYZa
        Osg/ZYWUF5eT0fYCoQQEqeK+CBPpCcQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-P3EqgR-YNP6MUTW5RF_mGg-1; Thu, 24 Sep 2020 17:59:59 -0400
X-MC-Unique: P3EqgR-YNP6MUTW5RF_mGg-1
Received: by mail-wm1-f69.google.com with SMTP id a7so282980wmc.2
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 14:59:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=36zI2byukpSXMDYkFOd0oKqSvwDoA1ZB+u3FjofG804=;
        b=BF8JfRaadcOHNuIpJhM3xCA/gzIkDv6CvnMMe3dBaQIDWcH/67y2no3F00j4XX75is
         8TSxkXR1hMkHFwU1XNDJqjRqf1uuXr+QXNzWrwK439jWQruN/8ZJ4zTKcrU/PwUf4KCb
         3i6iSAkbWo56BlDqxXrKJ/MPye1Y8z+6qxx5dwQ3z7YALzMYWTavogjeaS0+FKtATlYk
         I+DYvnGkXrKY1cgP5/uRzJBlIyqJxhnLwo8FnnBrggXUribujbGI/KyNYG9Q000YkhhX
         7qb0TkCL1W9DNR/PgzXhnH6ZELg0VvdKPcUaB8aEP835WfO91OUvEOuezoMyu2sl2ntZ
         lJ0g==
X-Gm-Message-State: AOAM532BbSDNAuMwfitf7txB0F2rJS4fqzWgwSJ4tK35HRKeycMs2lTl
        S1guzWJwAYjZaKpjG64NfzGeKLXQVFCEKfBy0l3cRQEjOCuhkMmsWyvEqfgG34AfcXG48qbHkbD
        rF0MKmkbgnvJmKzCb
X-Received: by 2002:a5d:4151:: with SMTP id c17mr1095547wrq.302.1600984797808;
        Thu, 24 Sep 2020 14:59:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRxHBT/T1ldQFZCYI9k6mrIBdKcHO68fkQLx+ycqy/MViuJPziFQCQhOVgQoi23t8JTNzzCw==
X-Received: by 2002:a5d:4151:: with SMTP id c17mr1095524wrq.302.1600984797623;
        Thu, 24 Sep 2020 14:59:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n4sm568785wmc.48.2020.09.24.14.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 14:59:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A2306183A90; Thu, 24 Sep 2020 23:59:55 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v8 04/11] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
In-Reply-To: <20200924001439.qitbu5tmzz55ck4z@ast-mbp.dhcp.thefacebook.com>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079991808.8301.6462172487971110332.stgit@toke.dk>
 <20200924001439.qitbu5tmzz55ck4z@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 24 Sep 2020 23:59:55 +0200
Message-ID: <87tuvmbztw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

>> +	struct mutex tgt_mutex; /* protects tgt_* pointers below, *after* prog becomes visible */
>> +	struct bpf_prog *tgt_prog;
>> +	struct bpf_trampoline *tgt_trampoline;
>>  	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
>>  	bool offload_requested;
>>  	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
> ...
>>  struct bpf_tracing_link {
>>  	struct bpf_link link;
>>  	enum bpf_attach_type attach_type;
>> +	struct bpf_trampoline *trampoline;
>> +	struct bpf_prog *tgt_prog;
>
> imo it's confusing to have 'tgt_prog' to mean two different things.
> In prog->aux->tgt_prog it means target prog to attach to in the future.
> Whereas here it means the existing prog that was used to attached to.
> They kinda both 'target progs' but would be good to disambiguate.
> May be keep it as 'tgt_prog' here and
> rename to 'dest_prog' and 'dest_trampoline' in prog->aux ?

I started changing this as you suggested, but I think it actually makes
the code weirder. We'll end up with a lot of 'tgt_prog =
prog->aux->dest_prog' assignments in the verifier, unless we also rename
all of the local variables, which I think is just code churn for very
little gain (the existing 'target' meaning is quite clear, I think).

I also think it's quite natural that the target moves; I mean, it's
literally the same pointer being re-assigned from prog->aux to the link.
We could rename the link member to 'attached_tgt_prog' or something like
that, but I'm not sure it helps (and I don't see much of a problem in
the first place).

WDYT?

-Toke

