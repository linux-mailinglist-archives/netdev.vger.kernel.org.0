Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8C74BD821
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 09:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbiBUIMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 03:12:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiBUIMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 03:12:31 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4574B1C91C;
        Mon, 21 Feb 2022 00:12:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645431120; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=RX00O3K3NSZmsWuMM5gNQK9i3XAHcNO7A9jghB3aeN5jjAOC5/uuUqZ1DEywPJ0cpvRDY5aUoyjfPABSnik+ifJKsP12avSb/cKGxJ8Okj4zcV1qoStnEp+3zK+13fHkQ9Dvob8iiJ7Ra3GYhoG6fj1NxsvhY3FCJtAovUqso0Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1645431120; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=3J3YmOc2Ej0ZGjP2mlL4Xj/8qOzy+gisb98q0ifhKVY=; 
        b=f027pZNwyQ8PlROwzGytXme+A7/NtY9mJk2p+YDPUQKeDnkQ27Q5VHxJGgbHL+f0TE7bfNz33joZ18zPgdKUDjSptfmpAk/ftc51kmMjmwxJEMsMhmVTbeToKmCo/0494Vf1zkbG89x6NlQZmyMXC2HAk/4Cj1+zFoZPTEHrobg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645431120;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=3J3YmOc2Ej0ZGjP2mlL4Xj/8qOzy+gisb98q0ifhKVY=;
        b=fhlyLQ/RF7YRxdW2otl34Yg50JM2AzZb7sAjA1AYyh8DxifVuIkKDl2ntUWJJBoT
        QofaQv9YNkLuY/NDoF5HiKE7+JXOHXPz7iGTlRTeGlm+gkwu8qy+tN/W+T7p7QBop6d
        hic/snVg/K7+ugpavoaBCtBGyIZHGWqMp0roKBT0=
Received: from anirudhrb.com (49.207.203.0 [49.207.203.0]) by mx.zohomail.com
        with SMTPS id 16454311055061013.5738597345428; Mon, 21 Feb 2022 00:11:45 -0800 (PST)
Date:   Mon, 21 Feb 2022 13:41:34 +0530
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, mail@anirudhrb.com
Subject: Re: [PATCH] vhost: handle zero regions in vhost_set_memory
Message-ID: <YhNJNh8N1GW6UZGo@anirudhrb.com>
References: <20220221072852.31820-1-mail@anirudhrb.com>
 <CACGkMEs6HLM3ok29rm4u=Tq2preno_60Z6cvKw2T7=nak2yzkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEs6HLM3ok29rm4u=Tq2preno_60Z6cvKw2T7=nak2yzkQ@mail.gmail.com>
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 03:56:29PM +0800, Jason Wang wrote:
> On Mon, Feb 21, 2022 at 3:45 PM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
> >
> > Return early when userspace sends zero regions in the VHOST_SET_MEM_TABLE
> > ioctl.
> >
> > Otherwise, this causes an erroneous entry to be added to the iotlb. This
> > entry has a range size of 0 (due to u64 overflow). This then causes
> > iotlb_access_ok() to loop indefinitely resulting in a hung thread.
> > Syzbot has reported this here:
> 
> Interesting, I think iotlb_access_ok() won't be called for memory
> table entries, or anything I missed?

Yeah, vhost_set_memory() doesn't call iotlb_access_ok(). The issue
appears when it is called later in a different code path. Here's the
trace for iotlb_access_ok():

NMI backtrace for cpu 1
CPU: 1 PID: 3633 Comm: vhost-3632 Not tainted 5.17.0-rc3-syzkaller-00029-ge6251ab4551f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:check_kcov_mode kernel/kcov.c:166 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0xd/0x60 kernel/kcov.c:200
Code: 00 00 e9 c6 41 66 02 66 0f 1f 44 00 00 48 8b be b0 01 00 00 e8 b4 ff ff ff 31 c0 c3 90 65 8b 05 29 f7 89 7e 89 c1 48 8b 34 24 <81> e1 00 01 00 00 65 48 8b 14 25 00 70 02 00 a9 00 01 ff 00 74 0e
RSP: 0018:ffffc90000cd7c78 EFLAGS: 00000246
RAX: 0000000080000000 RBX: ffff888079ca8a80 RCX: 0000000080000000
RDX: 0000000000000000 RSI: ffffffff86d3f8fb RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffc90000cd7c77
R10: ffffffff86d3f8ed R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffdf716a3b8 CR3: 00000000235b6000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
 vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
 vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
 vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
----------------

Thanks,

	- Anirudh
> 
> (If this is not true, we need a kernel patch as well).
> 
> Thanks
> 
> >
> > https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
> >
> > Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> > ---
> >  drivers/vhost/vhost.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 59edb5a1ffe2..821aba60eac2 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -1428,6 +1428,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
> >                 return -EFAULT;
> >         if (mem.padding)
> >                 return -EOPNOTSUPP;
> > +       if (mem.nregions == 0)
> > +               return 0;
> >         if (mem.nregions > max_mem_regions)
> >                 return -E2BIG;
> >         newmem = kvzalloc(struct_size(newmem, regions, mem.nregions),
> > --
> > 2.35.1
> >
> 
