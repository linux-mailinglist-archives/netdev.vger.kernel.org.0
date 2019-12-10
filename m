Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C530119BB9
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfLJWLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:11:05 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37697 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728217AbfLJWLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 17:11:04 -0500
Received: by mail-ot1-f65.google.com with SMTP id k14so17003881otn.4
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 14:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jSKHjYgVXPlCtWKcNtNTh1vGxe8+YnF4aFxtCgHQkqI=;
        b=H6mwJP3szbcrHV0L5CCnmkWCAoaddD0zQE1e/J1v2E8TO1Xq67ygQDZE6pEjP3j762
         Qve11GKLwOMxQOKTrO0xVM+pI9CKkl/N6E0YRtkgH6mL+zByb0WURtxXTMcWlwvh9ZjZ
         dqDfkvmxnNukVuIlBdlHurgCdj7jFCU7wEyFOrK8UyY6X5+Zu9F22DTWLRDKWSIYdkJ7
         ahKrFJ7bkhLvfRXYZY86Ko6/OBPFhEo/zgpN4Wk/LrpmtOihqDs/HqAQdP0KeyAO3xCv
         vIn3ugrDALs/rHuA2Kq4CNzYtQGGwqYb3uRUHAXIii7cx89V4DARWheEwMmXky+ejX+w
         XKgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jSKHjYgVXPlCtWKcNtNTh1vGxe8+YnF4aFxtCgHQkqI=;
        b=NgajgHhVCOkomThmaAjr54f8x3IHwWB7VPqcbGIz+6iUn45T58FUb4v0bwgpy4LLQR
         yIN3cbUHONW/BynPj1PUzsDpQ+TQG95s8HZBoyRflf9gnUKwwMF/FiGn7O5zCA/EfNOs
         v+a3gOWyBLAsfoBFfPYoz5i13k51Yi/np6xCkTam1sJ5AWn48rze5W67yejQD4DDUM2Z
         MfsFLN1dbX8No8Lfj3GcbhykIhGQMiuCduwSXJAxhf0qz4q2nmxcXFRebnCXfm9jZrGg
         pdV+EJZPhkxAp+pdEfCz7kAQeJRu/zyhmfDxNyMwJJqnNei3WRftk6O3Y2C8v/y4eDTw
         43yQ==
X-Gm-Message-State: APjAAAU7CbPX6NmRsjJyOVDVsffQMy7+DhZHsSbfIiFpxq5isQnBWyso
        WWEn749LV3Gq+GkjjRz+d39NXA==
X-Google-Smtp-Source: APXvYqx3dsMqGrQ9+KOyqrcwDpDXDa7GifVMgMbRs2EWOTfWSKiuA9uSWVcTGCCbC0kx2MHZI9ytcg==
X-Received: by 2002:a9d:6a4c:: with SMTP id h12mr22065otn.81.1576015863860;
        Tue, 10 Dec 2019 14:11:03 -0800 (PST)
Received: from ziepe.ca ([217.140.111.136])
        by smtp.gmail.com with ESMTPSA id t7sm64608otk.6.2019.12.10.14.11.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 Dec 2019 14:11:03 -0800 (PST)
Received: from jgg by LT-JGG-7470.mtl.com with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1ienif-00002g-QL; Tue, 10 Dec 2019 18:11:01 -0400
Date:   Tue, 10 Dec 2019 18:11:01 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     syzbot <syzbot+68dce7caebd8543121de@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, ast@kernel.org, boqun.feng@gmail.com,
        byungchul.park@lge.com, daniel@iogearbox.net, davem@davemloft.net,
        dledford@redhat.com, kernel-team@lge.com, kirill@shutemov.name,
        kuznet@ms2.inr.ac.ru, leon@kernel.org, leonro@mellanox.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, mingo@kernel.org,
        netdev@vger.kernel.org, npiggin@gmail.com, parav@mellanox.com,
        peterz@infradead.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        walken@google.com, willy@infradead.org, yoshfuji@linux-ipv6.org
Subject: Re: KASAN: slab-out-of-bounds Read in ip6_tnl_parse_tlv_enc_lim
Message-ID: <20191210221101.GA147@ziepe.ca>
References: <0000000000005175bf057617c71d@google.com>
 <000000000000e22b3c059960bebd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000e22b3c059960bebd@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 02:08:01PM -0800, syzbot wrote:
> syzbot suspects this bug was fixed by commit:
> 
> commit 30471d4b20335d9bd9ae9b2382a1e1e97d18d86d
> Author: Leon Romanovsky <leonro@mellanox.com>
> Date:   Sun Feb 3 12:55:50 2019 +0000
> 
>     RDMA/core: Share driver structure size with core
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16b7bb7ae00000
> start commit:   3a5af36b Merge tag '4.19-rc3-smb3-cifs' of git://git.samba..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9c4a80625153107e
> dashboard link: https://syzkaller.appspot.com/bug?extid=68dce7caebd8543121de
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1068a44e400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=146386c6400000
> 
> If the result looks correct, please mark the bug fixed by replying with:
> 
> #syz fix: RDMA/core: Share driver structure size with core
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Seems pretty unlikely

Jason
