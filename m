Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9064043CD7B
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237712AbhJ0PbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:31:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236313AbhJ0PbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 11:31:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635348537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+eOillqFEGpQrQ9kkKK0BfuXxzIsa8E5TGrBm3ktydM=;
        b=LkDE2JqaHSuSSyHNl+0zw+FpXozocE3bBc6VfZ7aEfapIbTVtc5HBnMCq6yQZk15M14wWS
        pj5E8q0DAN+pmvs5Uc1eAuOpTYoTezCKkRciAm0Hw8QkSGqwELRlJDAKJ+wI/SHfKyXmCe
        5XnLZu+68vHxi4CNfM6Q2e1X7Z82Y4g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-uGSWm2vpPR6xyxjMKqBMsA-1; Wed, 27 Oct 2021 11:28:56 -0400
X-MC-Unique: uGSWm2vpPR6xyxjMKqBMsA-1
Received: by mail-wm1-f70.google.com with SMTP id v18-20020a7bcb52000000b00322fea1d5b7so1311021wmj.9
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 08:28:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+eOillqFEGpQrQ9kkKK0BfuXxzIsa8E5TGrBm3ktydM=;
        b=WkfmrTRWadk4q1G3auLVzk5m7N6HmJBu6klYtzbFkRdICDjyDQwSmmWlByEU8zFffb
         SD7AEIsBM/0usaidUoMYLNPk+HDxXEnYZcQT4DzlMPGKilhDnQMMjGPK13xhJ/T3GIPW
         eQSw9c9bx0IZuNlB/84lfAJvD/Bmvs8Fmve6iSwhosq2WU+Mzj74VpsLiC8ALCUF9vHQ
         CNuWQkiTVgt1ioyZVetdtNXoo28VgieVadPc2MYFBpd7aeAJ2IcVIeqyn3/+EuGRto1E
         +NxPGWvSyoo1t0Meiv9/uhXMJ3r39NvN1Jpo8fZbQWWnGwlh2C/1o0Luw41OQrIPPRqe
         cCuw==
X-Gm-Message-State: AOAM53393dFJqt4zvZu8WkIxPgiMLul0jeHmn/ce4N7ppQgc/UASF/Zo
        vdPc4ntn2m1r7KVve8qUI1idEt+H/Jt35uRwWAH0Ry0W4lq59Z/ogIXlZ50wkwHFjk0GTwwqLm8
        iqhvGiIm57AwrLbPJ
X-Received: by 2002:a1c:f614:: with SMTP id w20mr6399593wmc.71.1635348534961;
        Wed, 27 Oct 2021 08:28:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx48Ekpj4clqe1b4A9LimmYmVc0qkpR7dH4dZiC/yCaw0YSOKIQftxe1BzKC6UMOGCBceazlw==
X-Received: by 2002:a1c:f614:: with SMTP id w20mr6399567wmc.71.1635348534771;
        Wed, 27 Oct 2021 08:28:54 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:207e:a543:72f:c4d1:8911:6346])
        by smtp.gmail.com with ESMTPSA id o10sm173398wrx.64.2021.10.27.08.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 08:28:54 -0700 (PDT)
Date:   Wed, 27 Oct 2021 11:28:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        syzbot <syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au, jiri@nvidia.com,
        kuba@kernel.org, leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in copy_data
Message-ID: <20211027111300-mutt-send-email-mst@kernel.org>
References: <000000000000a4cd2105cf441e76@google.com>
 <eab57f0e-d3c6-7619-97cc-9bc3a7a07219@redhat.com>
 <CACT4Y+amyT9dk-6iVqru-wQnotmwW=bt4VwaysgzjH9=PkxGww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+amyT9dk-6iVqru-wQnotmwW=bt4VwaysgzjH9=PkxGww@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 03:36:19PM +0200, Dmitry Vyukov wrote:
> On Wed, 27 Oct 2021 at 15:11, Laurent Vivier <lvivier@redhat.com> wrote:
> >
> > On 26/10/2021 18:39, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    9ae1fbdeabd3 Add linux-next specific files for 20211025
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=1331363cb00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=aeb17e42bc109064
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=b86736b5935e0d25b446
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116ce954b00000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132fcf62b00000
> > >
> > > The issue was bisected to:
> > >
> > > commit 22849b5ea5952d853547cc5e0651f34a246b2a4f
> > > Author: Leon Romanovsky <leonro@nvidia.com>
> > > Date:   Thu Oct 21 14:16:14 2021 +0000
> > >
> > >      devlink: Remove not-executed trap policer notifications
> > >
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137d8bfcb00000
> > > final oops:     https://syzkaller.appspot.com/x/report.txt?x=10fd8bfcb00000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=177d8bfcb00000
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com
> > > Fixes: 22849b5ea595 ("devlink: Remove not-executed trap policer notifications")
> > >
> > > ==================================================================
> > > BUG: KASAN: slab-out-of-bounds in memcpy include/linux/fortify-string.h:225 [inline]
> > > BUG: KASAN: slab-out-of-bounds in copy_data+0xf3/0x2e0 drivers/char/hw_random/virtio-rng.c:68
> > > Read of size 64 at addr ffff88801a7a1580 by task syz-executor989/6542
> > >
> >
> > I'm not able to reproduce the problem with next-20211026 and the C reproducer.
> >
> > And reviewing the code in copy_data() I don't see any issue.
> >
> > Is it possible to know what it the VM configuration used to test it?
> 
> Hi Laurent,
> 
> syzbot used e2-standard-2 GCE VM when that happened.
> You can see some info about these VMs under the "VM info" link on the dashboard.

Could you pls confirm whether reverting
caaf2874ba27b92bca6f0298bf88bad94067ec37 addresses this?

