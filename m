Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C1F77E99
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 10:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfG1Igs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 04:36:48 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42896 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfG1Igs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 04:36:48 -0400
Received: by mail-io1-f68.google.com with SMTP id e20so83179139iob.9
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 01:36:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JmcimYJf+Bna2bF5oHtnyvYwQab4h3brdRl3y+Yku3w=;
        b=eZ8bHh5/UazBgsw5Mf/4akZsCfwJOl1HgXAE8a8JEE47wFPEjzI/owGPQqsL36uI4X
         yZnrAYlQnIbzfTexZMdKSSDxHQHe9N56y/ix74dXIUooNcKH6zTCMCnqz70DTaDHKssC
         FSWFH/5oyOEpH+47swahBMMRmSO+lutRvISpezo3dgj8TYYKC1c7KSEE1xj5FsWdSEoL
         XStLi9D6tOYSsLE8J+uf0NPfXZ9fXoMkjCkvFFtVJULm9k9QkU4dINGp+Qh6COEQFx6B
         AVpC7v6SPPMn1aNCPjHumpjEcgaJ48OZKcQfTrK9tuGi7FUkMtg8sCiUsfEuyyzPCJwG
         UI6g==
X-Gm-Message-State: APjAAAXd2+5asr9z53GZM+k24SYTvroF6hhl09xqPHRJaUaxAsD5LtsD
        XE7r3idcjYPR2fDot4ebM9uNPM+OyEQ=
X-Google-Smtp-Source: APXvYqyHU6qTV7uMr9tjpRxhhvTuO4lK+5tp+FQOjsGxN+s/1qcSKnN7S1nMevwymEewifIu5iF5Gg==
X-Received: by 2002:a02:b883:: with SMTP id p3mr34245354jam.79.1564303007037;
        Sun, 28 Jul 2019 01:36:47 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id o7sm48957845ioo.81.2019.07.28.01.36.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 01:36:45 -0700 (PDT)
Date:   Sun, 28 Jul 2019 04:36:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+36e93b425cd6eb54fcc1@syzkaller.appspotmail.com>,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.lkml@markovi.net, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        virtualization@lists.linux-foundation.org,
        yamada.masahiro@socionext.com
Subject: Re: INFO: rcu detected stall in vhost_worker
Message-ID: <20190728043619-mutt-send-email-mst@kernel.org>
References: <000000000000b4358f058e924c6d@google.com>
 <000000000000e87d14058e9728d7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000e87d14058e9728d7@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 04:23:23PM +0800, Hillf Danton wrote:
> 
> Fri, 26 Jul 2019 08:26:01 -0700 (PDT)
> > syzbot has bisected this bug to:
> > 
> > commit 0ecfebd2b52404ae0c54a878c872bb93363ada36
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Sun Jul 7 22:41:56 2019 +0000
> > 
> >      Linux 5.2
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=118810bfa00000
> > start commit:   13bf6d6a Add linux-next specific files for 20190725
> > git tree:       linux-next
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=8ae987d803395886
> > dashboard link: https://syzkaller.appspot.com/bug?extid=36e93b425cd6eb54fcc1
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15112f3fa00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131ab578600000
> > 
> > Reported-by: syzbot+36e93b425cd6eb54fcc1@syzkaller.appspotmail.com
> > Fixes: 0ecfebd2b524 ("Linux 5.2")
> > 
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -787,7 +787,6 @@ static void vhost_setup_uaddr(struct vho
> 			      size_t size, bool write)
> {
> 	struct vhost_uaddr *addr = &vq->uaddrs[index];
> -	spin_lock(&vq->mmu_lock);
> 
> 	addr->uaddr = uaddr;
> 	addr->size = size;
> @@ -797,7 +796,10 @@ static void vhost_setup_uaddr(struct vho
> static void vhost_setup_vq_uaddr(struct vhost_virtqueue *vq)
> {
> 	spin_lock(&vq->mmu_lock);
> -
> +	/*
> +	 * deadlock if managing to take mmu_lock again while
> +	 * setting up uaddr
> +	 */
> 	vhost_setup_uaddr(vq, VHOST_ADDR_DESC,
> 			  (unsigned long)vq->desc,
> 			  vhost_get_desc_size(vq, vq->num),
> --

Thanks!
I reverted this whole commit.

-- 
MST
