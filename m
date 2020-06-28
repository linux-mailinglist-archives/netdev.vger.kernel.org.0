Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF8820C9B5
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 20:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgF1Suv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 14:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgF1Suu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 14:50:50 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8579FC03E979;
        Sun, 28 Jun 2020 11:50:50 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u185so4902441pfu.1;
        Sun, 28 Jun 2020 11:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gx2wECjHOxEOzUfN8Q6CXQ91pn7AF8OgVLiYblvY+JM=;
        b=mYtPVH1ydS33aYq6KLc8fdGZFuFRbPxw0XQ5MF4ZPcC8twM8KbN+n72PEggEKmBs1c
         LLyKeT0722rsVKg2XFtc1r9+Ddidu6oFi+Qr/rSeB3m9pbY4fxyG6Aw9N1OTGE6JaZcv
         lldPRzb52clL76/7MYWxDFYtzXjFQTlovAi21YvODOqK6q8uwxMcEZxkEfR3yiJe8GT8
         sgF+pFtX4RPQ8vLb0uL9uN66JUlkBDGPMGxXteqSEkBDskgZGHwcWYNv/qfa3Y6ePEAm
         PBcMTIYDy2oggdrKxQ8sDEP5L/MJjzJ3r1fatYDuKpjRtNCHmz8koPnzZA5P3k67F6tm
         3VlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gx2wECjHOxEOzUfN8Q6CXQ91pn7AF8OgVLiYblvY+JM=;
        b=gkM77+XpkrvjGqVK3FIqmVUMfqz86gWX2E2KwNDUWU3Qk8R+SJhqwabqmFjN0/ZI+b
         mt2J3Qq6etPb2WGtGSeuWZZIK17Uomb7lVlkD6YpNyN3LKihb8EO4GdR31juwXs9KG/B
         O5WyqQMoGHTld7NcqNhPbBEJDPkSuUmsZmIfhsRt5wqpoWyWOXCb4kqRFOFbOofanl0R
         1OIJkC++o2mWNOFJcHcO7MWBNuHQpAd+ZoQJFX/9VCINV5q8i+YD54vBm5BP2Y3nbs7u
         UWSxNJ8XvS/j3Z2+4/+dr4+o35XBaCJJwnBUJj4sv0fn1E8NINEFu2o4GZ/WqKl9vGDv
         yNpQ==
X-Gm-Message-State: AOAM532ac6z7eYyYMflhPVfEXeAKkG0JqsJ0C5WyMipCz3VoH7VnjAJQ
        cgxzh3N/8J3y30OhjgQq2wsnK0v5
X-Google-Smtp-Source: ABdhPJzKWcHOrp0hsF1+G7LI1H2UEiOMmoajmbPrSBmxsHCrumywJPGxRDTzTkuk3vz4j05EpTPQfg==
X-Received: by 2002:a63:6c49:: with SMTP id h70mr7331735pgc.150.1593370249891;
        Sun, 28 Jun 2020 11:50:49 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:616])
        by smtp.gmail.com with ESMTPSA id u20sm32991149pfk.91.2020.06.28.11.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 11:50:49 -0700 (PDT)
Date:   Sun, 28 Jun 2020 11:50:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 bpf-next 05/14] bpf: Remove btf_id helpers resolving
Message-ID: <20200628185046.vryhuc23f6yu5fy4@ast-mbp.dhcp.thefacebook.com>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-6-jolsa@kernel.org>
 <7480f7b2-01f0-f575-7e4f-cf3bde851c3f@fb.com>
 <CAEf4BzYPvNbYNBuqFDY8xCqSGTZ2G8HM=waq9b=qO9UYOUK7+A@mail.gmail.com>
 <b9258020-cd38-b818-e3a9-4f6d9cdf6b88@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9258020-cd38-b818-e3a9-4f6d9cdf6b88@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 04:29:23PM -0700, Yonghong Song wrote:
> > > > 
> > > > -int btf_resolve_helper_id(struct bpf_verifier_log *log,
> > > > -                       const struct bpf_func_proto *fn, int arg)
> > > > -{
> > > > -     int *btf_id = &fn->btf_id[arg];
> > > > -     int ret;
> > > > -
> > > > -     if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
> > > > +     if (!id || id > btf_vmlinux->nr_types)
> > > >                return -EINVAL;
> > > 
> > > id == 0 if btf_id cannot be resolved by resolve_btfids, right?
> > > when id may be greater than btf_vmlinux->nr_types? If resolve_btfids
> > > application did incorrect transformation?
> > > 
> > > Anyway, this is to resolve helper meta btf_id. Even if you
> > > return a btf_id > btf_vmlinux->nr_types, verifier will reject
> > > since it will never be the same as the real parameter btf_id.
> > > I would drop id > btf_vmlinux->nr_types here. This should never
> > > happen for a correct tool. Even if it does, verifier will take
> > > care of it.
> > > 
> > 
> > I'd love to hear Alexei's thoughts about this change as well. Jiri
> > removed not just BTF ID resolution, but also all the sanity checks.
> > This now means more trust in helper definitions to not screw up
> > anything. It's probably OK, but still something to consciously think
> > about.
> 
> The kernel will have to trust the result. 

+1
I think 'if (!id || id > btf_vmlinux->nr_types)' at run-time and
other sanity checks I saw in other patches are unnecessary.
resolve_btfids should do all checks and fail vmlinux linking.
We trust gcc to generate correct assembly code in the first place
and correct dwarf. We trust pahole do correct BTF conversion from
dwarf and dedup. We should trust resolve_btfids.
It's imo the simplest tool comparing to gcc.
btf_parse_vmlinux() is doing basic sanity check of BTF mainly
to populate 'struct btf *btf_vmlinux;' for further use.
I think we can add a scan over resolved btfids to btf_parse_vmlinux()
to make sure that all ids are within the range, but I don't think
it's mandatory for this patch set. Would be a reasonable sanity
check for the future. Of course, checking for sorted set_start/end
is overkill. Basic simplest sanity is ok.
