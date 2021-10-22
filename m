Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE51437A53
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 17:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhJVPxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 11:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhJVPxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 11:53:16 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE4FC061764;
        Fri, 22 Oct 2021 08:50:58 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id r134so5906095iod.11;
        Fri, 22 Oct 2021 08:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=twCWyKn/uuejyopzmhFlIyMEHdeqJMR+lwKeohJhhD0=;
        b=KbvZVn5Tds2Bhar42foeGUmsVophEgQxbcTLKcvx6/K9krvy8whv714qL72Jssa6bh
         QfMibvtBiq/Vglaeuxgcs8HVOUlj6xyJg65ieKdkJEEcbZUF9FGD41xfcR/fgrrTE28a
         025A2rqjtsMtqyU+NiD1ZwLbbmXEMEIF/qNAcZmNk4KnCoR6ZBkcgfB6dN0+Z517zL7a
         AMH5R7nnyjUNkez/RplYhVfZ1M6MFTa+OEADS87PYzRXKnfyowxiVx4UBFEguPeXP8tU
         /miU3iUtYCGLZsujIM33UIb+Rmv4Tk4HmaIevMpY5JFkbgDQfUwoahcWnNgFiUJCSImg
         AR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=twCWyKn/uuejyopzmhFlIyMEHdeqJMR+lwKeohJhhD0=;
        b=4yAbukxGUalA5fssOH1m8VX8ivnTD9ZiaA4tkthTtQ37nesR6CzB3V2U6rrJQUawiP
         nVmEIt/txKPd6SrJA4OCa9yvhJtc2myC77yNPeSUdLRIPVx3YBQD1TGljEPMr2s7mS1e
         ahaeK7dj+dbE3b2tGASWcQryySoD3suy20ogf8OJgzZz8sdsK6OmHH1QphLKH0sRVJ7z
         jSXue6tQb8gpKfyrctDnjeIxhI1CeGcc+7g0VINZGEQeTWVI6yvUf/N/tUxzE98zjC6B
         w03Zt4kOgad0xjeB+v7cb5y9ekvwoswcOfP70Z3wkzCkxXpaWc3+lIz6m8gFXaxvs1Eu
         /Xaw==
X-Gm-Message-State: AOAM532ZELLXjRiSIlZethO0Wnw9BG9C9BtN7CFqWgSDiY/tlq1l1iVN
        uGX/j/U6xDB6EyZcsyqrW6M=
X-Google-Smtp-Source: ABdhPJw2we6RLfuN8vF/6l6xnZ9CYQqeigaDZDvKKyrd4WikJuV8cq5jx5Ft/spVZnrVqOl0ak3pIg==
X-Received: by 2002:a05:6602:14d2:: with SMTP id b18mr296487iow.72.1634917858180;
        Fri, 22 Oct 2021 08:50:58 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id t10sm4302067ile.29.2021.10.22.08.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 08:50:57 -0700 (PDT)
Date:   Fri, 22 Oct 2021 08:50:48 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Roman Gushchin <guro@fb.com>,
        =?UTF-8?B?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>
Cc:     quanyang.wang@windriver.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <6172ddd8c3f59_82a7f208e4@john-XPS-13-9370.notmuch>
In-Reply-To: <YWRmYk4hHhPf602i@carbon.dhcp.thefacebook.com>
References: <20211007121603.1484881-1-quanyang.wang@windriver.com>
 <20211011162128.GC61605@blackbody.suse.cz>
 <YWRmYk4hHhPf602i@carbon.dhcp.thefacebook.com>
Subject: Re: [PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roman Gushchin wrote:
> On Mon, Oct 11, 2021 at 06:21:28PM +0200, Michal Koutny wrote:
> > Hello.
> > 
> > On Thu, Oct 07, 2021 at 08:16:03PM +0800, quanyang.wang@windriver.com wrote:
> > > This is because that root_cgrp->bpf.refcnt.data is allocated by the
> > > function percpu_ref_init in cgroup_bpf_inherit which is called by
> > > cgroup_setup_root when mounting, but not freed along with root_cgrp
> > > when umounting.
> > 
> > Good catch!
> 
> +1
> 
> > 
> > > Adding cgroup_bpf_offline which calls percpu_ref_kill to
> > > cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in umount path.
> > 
> > That is sensible.
> > 
> > > Fixes: 2b0d3d3e4fcfb ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
> > 
> > Why this Fixes:? Is the leak absent before the percpu_ref refactoring?
> 
> I agree, the "fixes" tag looks dubious to me.
> 
> > I guess the embedded data are free'd together with cgroup. Makes me
> > wonder why struct cgroup_bpf has a separate percpu_ref counter from
> > struct cgroup...
> 
> This is because a cgroup can stay a long time (sometimes effectively forever)
> in a dying state, so we want to release bpf structures earlier.
> 
> Thanks!

Other than whitespace LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
