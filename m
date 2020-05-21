Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE4E1DD937
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgEUVOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUVOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:14:52 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8745CC061A0E;
        Thu, 21 May 2020 14:14:52 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t7so3471556plr.0;
        Thu, 21 May 2020 14:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ojdRX3qZp+MZy5LmVQafkaesJV8j+MVGJ1zs3/CG9ps=;
        b=RqIEZpIWW6wQMMsJlLMYX/UrPUwSfvJa/1f1lD74bLLdNgCbW6p9OnBzJiMCVLh66N
         rGfmWNArObZ/CpcS2ZTnlFyH6POr51/Zt4N/bzP0itDHDhPnDZde+K0W/dYelgoiN0/t
         q+28oaP/iE1eidBoli9M/UivgR1JnWdKX05tQjQ36BPaLAr1R+ULHll03othOUkkgszt
         rKHAJd2Z3b2H4Bv+Vv0L/Wn8r/XajOWa8NS8lyv70AaYKG2GGYj/tu33LtK0QGOHO8/H
         hv9rzjdun/ce16/1XOctscWWpDTUVE60NzyebF09gwcFWYCIvs3Tb4rBNEzni3cc1CMe
         PdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ojdRX3qZp+MZy5LmVQafkaesJV8j+MVGJ1zs3/CG9ps=;
        b=NuP5o7ue7iLGTRlTmaKAZ8/SFcJEt5BaSw1FlAJhTLCQGPLsRlsWOot4aXZJC9QdAd
         PSfJf0vr8OKlGC31ok5VkTpav0a0Ff4onlvMwoGskzM3QlUgN3IaqorTva1f17O1iMjX
         pYkW6pz8CXu9CNFzextpBMTDpIHX8ZdTzvhahbAe+w1efWP4WN8zJLa/Ev8A24CaQp3a
         43B3m7Qj76ipshwjPOKP2x4whaSoXxlXfsKExQtNq9I+k+Dncki/IGjSi2vXIKvR/07s
         dxImvJIcDr92+Wsj0xy9lz8GDvF+H4zgOQa5xdQ83NdjFKhF07DTweXHL4toU6gL4jJx
         lz0A==
X-Gm-Message-State: AOAM530QIb1KFjk24hlm7WMt3H6Vqe54Px64LPjJ8W1vJRbL5CNnoQXi
        /Gcg6Mqtf0pCH13GCFo2v6A=
X-Google-Smtp-Source: ABdhPJwqvTC+zhXH2hem8mbMqcAo9Mx67T9nysflxxQZxlZcUo4QgeuA/gJxd7R0YO4SLKJZ9+jjMg==
X-Received: by 2002:a17:90a:3228:: with SMTP id k37mr549777pjb.118.1590095691621;
        Thu, 21 May 2020 14:14:51 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l4sm4538214pgo.92.2020.05.21.14.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:14:50 -0700 (PDT)
Date:   Thu, 21 May 2020 14:14:43 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan@huawei.com>,
        ast@kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        yangyingliang <yangyingliang@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        huawei.libin@huawei.com, guofan5@huawei.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Message-ID: <5ec6ef43d98e7_3bbf2ab912c625b4eb@john-XPS-13-9370.notmuch>
In-Reply-To: <20200509210214.408e847a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <939566f5-abe3-3526-d4ff-ec6bf8e8c138@huawei.com>
 <2fcd921d-8f42-9d33-951c-899d0bbdd92d@huawei.com>
 <20200508225829.0880cf8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200509210214.408e847a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [PATCH v2] netprio_cgroup: Fix unlimited memory leak of v2
 cgroups
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Fri, 8 May 2020 22:58:29 -0700 Jakub Kicinski wrote:
> > On Sat, 9 May 2020 11:32:10 +0800 Zefan Li wrote:
> > > If systemd is configured to use hybrid mode which enables the use of
> > > both cgroup v1 and v2, systemd will create new cgroup on both the default
> > > root (v2) and netprio_cgroup hierarchy (v1) for a new session and attach
> > > task to the two cgroups. If the task does some network thing then the v2
> > > cgroup can never be freed after the session exited.
> > > 
> > > One of our machines ran into OOM due to this memory leak.
> > > 
> > > In the scenario described above when sk_alloc() is called cgroup_sk_alloc()
> > > thought it's in v2 mode, so it stores the cgroup pointer in sk->sk_cgrp_data
> > > and increments the cgroup refcnt, but then sock_update_netprioidx() thought
> > > it's in v1 mode, so it stores netprioidx value in sk->sk_cgrp_data, so the
> > > cgroup refcnt will never be freed.
> > > 
> > > Currently we do the mode switch when someone writes to the ifpriomap cgroup
> > > control file. The easiest fix is to also do the switch when a task is attached
> > > to a new cgroup.
> > > 
> > > Fixes: bd1060a1d671("sock, cgroup: add sock->sk_cgroup")  
> > 
> >                      ^ space missing here
> > 
> > > Reported-by: Yang Yingliang <yangyingliang@huawei.com>
> > > Tested-by: Yang Yingliang <yangyingliang@huawei.com>
> > > Signed-off-by: Zefan Li <lizefan@huawei.com>
> 
> Fixed up the commit message and applied, thank you.

Hi Zefan, Tejun,

This is causing a regression where previously cgroupv2 bpf sockops programs
could be attached and would run even if netprio_cgroup was enabled as long
as  the netprio cgroup had not been configured. After this the bpf sockops
programs can still be attached but only programs attached to the root cgroup
will be run. For example I hit this when I ran bpf selftests on a box that
also happened to have netprio cgroup enabled, tests started failing after
bumping kernel to rc5.

I'm a bit on the fence here if it needs to be reverted. For my case its just
a test box and easy enough to work around. Also all the production cases I
have already have to be aware of this to avoid the configured error. So it
may be fine but worth noting at least. Added Alexei to see if he has any
opinion and/or uses net_prio+cgroubv2. I only looked it over briefly but
didn't see any simple rc6 worthy fixes that would fix the issue above and
also keep the original behavior.

And then while reviewing I also wonder do we have the same issue described
here in netclasid_cgroup.c with the cgrp_attach()? It would be best to keep
netcls and netprio in sync in this regard imo. At least netcls calls
cgroup_sk_alloc_disable in the write_classid() hook so I suspect it makes
sense to also add that to the attach hook?

Thanks,
John
