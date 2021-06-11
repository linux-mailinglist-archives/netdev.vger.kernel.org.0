Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FA83A437C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 15:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhFKN5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 09:57:12 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:40913 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbhFKN46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 09:56:58 -0400
Received: by mail-pj1-f43.google.com with SMTP id mp5-20020a17090b1905b029016dd057935fso5872037pjb.5;
        Fri, 11 Jun 2021 06:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3zURn0UPPN9V50/Gx7hW/OjynHzyy+hIqEJ1Y6Xj4DQ=;
        b=VPQOq5OjYH29Xl5bqY/833Y5XFKbg9z75HMXxIg8KGavJTIEtjtD3u3s0BaLvLChGM
         Qt2TBf37DPkTWA6xscwui3Tp8UpwOXqn7eVv6bw8ptJhJ54puHAPSZttRcEcLIJrdsmr
         8CHYfb267FTpS7plEIz7RwGclMdlllbJtDc4APd9aeR0/mKfeYsaoEVh2KQ9eKLODBr8
         8HntPF/tG6EbQVIPRq6sAn1frMZTIZFXUeD/GGeMl9cjHKAvYQMtKgeuW4jAj112S1r5
         xRkVuh9YuCxpC3FfipXymb9Sx8XKNSgrY6Eg4Q0nzMy2+JLxjRyF6eYtjMyR+4HOAsE8
         6FbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3zURn0UPPN9V50/Gx7hW/OjynHzyy+hIqEJ1Y6Xj4DQ=;
        b=EeC9e9c7j0FACyTsXQd7ebmeVVJdy9C+dSBr9JwhF866TEbskre+6G4PYbMGZs5Puh
         puPcs3wDJRDX7zMSynbkTG2A89RW1vDcZF4u8MsXky4uB/fL/kpdKkOno+wAi93nWR2s
         exnd/XgVbzFNvFKrVSBGrXv7UyIJPI3+eGC0r6qKAUzTYCR/yHzinv/jpU1Lj/+WzSRx
         LsMjxK4pC8FoQa7fEh5gP+JGlYUYxFj31UM0d/r+cksajQX778dFX6lu8sEuIwqtw1vl
         0es+pKfCAEy3vVrF6dCjHhYiuay4ikhesatgRsHHwiTXgmIMM0fYytEi4ZMvxQwSxXMj
         7VjQ==
X-Gm-Message-State: AOAM5316O/7OcwWTonFv1Ei7Og3To5Y4nic/o7c+OGhLCjFvRF2okKiw
        j77i0QIp/BxdfjzyzlaDhbI=
X-Google-Smtp-Source: ABdhPJxKFUrUoRT9n4B6GhAYNbHuTUlQJE7HqIghV3Z73QIWMVkVSlMS1wu7EtP1Qu3zF3WXXunRUQ==
X-Received: by 2002:a17:90b:d95:: with SMTP id bg21mr4549059pjb.115.1623419640566;
        Fri, 11 Jun 2021 06:54:00 -0700 (PDT)
Received: from mail.google.com ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id e2sm6721682pjc.37.2021.06.11.06.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 06:54:00 -0700 (PDT)
Date:   Fri, 11 Jun 2021 21:53:50 +0800
From:   Changbin Du <changbin.du@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Changbin Du <changbin.du@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v3] net: make get_net_ns return error if NET_NS is
 disabled
Message-ID: <20210611135350.ba2rsbggb3zmunqg@mail.google.com>
References: <20210610153941.118945-1-changbin.du@gmail.com>
 <20210610105112.787a0d5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610105112.787a0d5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 10:51:12AM -0700, Jakub Kicinski wrote:
> On Thu, 10 Jun 2021 23:39:41 +0800 Changbin Du wrote:
> > There is a panic in socket ioctl cmd SIOCGSKNS when NET_NS is not enabled.
> > The reason is that nsfs tries to access ns->ops but the proc_ns_operations
> > is not implemented in this case.
> > 
> > [7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
> > [7.670268] pgd = 32b54000
> > [7.670544] [00000010] *pgd=00000000
> > [7.671861] Internal error: Oops: 5 [#1] SMP ARM
> > [7.672315] Modules linked in:
> > [7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
> > [7.673309] Hardware name: Generic DT based system
> > [7.673642] PC is at nsfs_evict+0x24/0x30
> > [7.674486] LR is at clear_inode+0x20/0x9c
> > 
> > The same to tun SIOCGSKNS command.
> > 
> > To fix this problem, we make get_net_ns() return -EINVAL when NET_NS is
> > disabled. Meanwhile move it to right place net/core/net_namespace.c.
> 
> I'm assuming you went from EOPNOTSUPP to EINVAL to follow what the
> existing helpers in the header do?
>
yes, make them behaviour in the same manner.

> Acked-by: Jakub Kicinski <kuba@kernel.org>
> 
> Thanks!

-- 
Cheers,
Changbin Du
