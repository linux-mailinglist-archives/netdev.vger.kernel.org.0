Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52EB130023
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgADCbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:31:17 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46792 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgADCbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 21:31:17 -0500
Received: by mail-pg1-f193.google.com with SMTP id z124so24169555pgb.13;
        Fri, 03 Jan 2020 18:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=blsSbEWGXgUJjQb/qSvAaZJESUCaEn4p3+MDGRU7nN0=;
        b=g60RbmY9rCQX3TAchyPtY6+X0KJQ4VUWpnr9IoNoB2lLLOX9coJyBS3VTLbpdxhrP0
         CiLCU9jqKEc6nmNYT1QTplN9kYk2+45l0pO0ymDZl0ORbVBpgMGnwJ4ebyPEGV+XO5zS
         RdvdQEhTbEGsAmUs22u31eSUzAdNPAaNlzdLLG+808ZqiN2fBse1q3sKI51Vv+AM0UsS
         lDcHstQA8NvXAGkzCshUBUUbr967vukeE6h42hiaGArSdWOgYNrQCArYDWxVYVQ8/80s
         5Oc3Mp5Jx4toOlDpzhH4BfXgbHJAkfHDS52+1lAw8evKIuYOW7vS/s0we7afRJJADUGL
         FfMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=blsSbEWGXgUJjQb/qSvAaZJESUCaEn4p3+MDGRU7nN0=;
        b=Q9z8/nvulpqQ2N73tyhiPFuH+Ks9Sihh6CwbJmNnqVSJNgQ63t+HuUjx4ZU1ntycuC
         VwyheI8aoXV2203oiM/l8WwOe3ByJvvNG0QOtyX93QrjygEq+v2rlcJ/csa3IaEI+W/w
         yRUFB1FGmACCyoJCEI8hhOtWpUXa1RtmazNcO7+Ee9/uqs9s3g1FoEsCdp/XVe+sif9t
         5HNp7S6jLLHlE3SyENBVm3DjHiCEtjOPubonEUhy8O1tm15K+/kBai4Yw51hCUQBurga
         UqRxYJVDX2faCuO/TD9k7jQ9jIWhwkaKwALsQHHnsqeAWcbdrTOUwzXgdVO7EP0XsAXa
         QnUA==
X-Gm-Message-State: APjAAAX0to7VXA3qlkJtLZv4iAhSlZTmzRr2zjoMsPgNW5B/yLOl7/af
        7uvIwIcHxyR9w1Fg52Wiakg=
X-Google-Smtp-Source: APXvYqxI/Qs2haahOyLbbybZRJGb7uQx7j03FqVuyQdMVGDF1qGU0nKlps8LFZ8ORvjJXB34mSWzVw==
X-Received: by 2002:a63:ca4d:: with SMTP id o13mr98415724pgi.360.1578105076338;
        Fri, 03 Jan 2020 18:31:16 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::3:4269])
        by smtp.gmail.com with ESMTPSA id o184sm64463083pgo.62.2020.01.03.18.31.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 18:31:15 -0800 (PST)
Date:   Fri, 3 Jan 2020 18:31:14 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Roman Gushchin <guro@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf: cgroup: prevent out-of-order release of cgroup
 bpf
Message-ID: <20200104023112.6edfdvsff6cgsstn@ast-mbp>
References: <20191227215034.3169624-1-guro@fb.com>
 <20200104003523.rfte5rw6hbnncjes@ast-mbp>
 <20200104011318.GA11376@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200104011318.GA11376@localhost.localdomain>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 04, 2020 at 01:13:24AM +0000, Roman Gushchin wrote:
> On Fri, Jan 03, 2020 at 04:35:25PM -0800, Alexei Starovoitov wrote:
> > On Fri, Dec 27, 2019 at 01:50:34PM -0800, Roman Gushchin wrote:
> > > Before commit 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf
> > > from cgroup itself") cgroup bpf structures were released with
> > > corresponding cgroup structures. It guaranteed the hierarchical order
> > > of destruction: children were always first. It preserved attached
> > > programs from being released before their propagated copies.
> > > 
> > > But with cgroup auto-detachment there are no such guarantees anymore:
> > > cgroup bpf is released as soon as the cgroup is offline and there are
> > > no live associated sockets. It means that an attached program can be
> > > detached and released, while its propagated copy is still living
> > > in the cgroup subtree. This will obviously lead to an use-after-free
> > > bug.
> > ...
> > > @@ -65,6 +65,9 @@ static void cgroup_bpf_release(struct work_struct *work)
> > >  
> > >  	mutex_unlock(&cgroup_mutex);
> > >  
> > > +	for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
> > > +		cgroup_bpf_put(p);
> > > +
> > 
> > The fix makes sense, but is it really safe to walk cgroup hierarchy
> > without holding cgroup_mutex?
> 
> It is, because we're holding a reference to the original cgroup and going
> towards the root. On each level the cgroup is protected by a reference
> from their child cgroup.

cgroup_bpf_put(p) can make bpf.refcnt zero which may call cgroup_bpf_release()
on another cpu which will do cgroup_put() and this cpu p = cgroup_parent(p)
would be use-after-free?
May be not due to the way work_queues are implemented.
But it feels dangerous to have such delicate release logic.
Why not to move the loop under the mutex and make things obvious?
