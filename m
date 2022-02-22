Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC954BF1B4
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 06:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiBVFoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 00:44:04 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiBVFoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 00:44:02 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A229ADEA9
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 21:43:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645505868; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=h0xPrwJ5xGaQ7hS8AtO3/fYL0N55YKxhd/jXerhoKjn3RngVKcJegU23fFugjn1UH8BpOWBFc5nUFdGYC40Kc4RbEs016Tw1UgKJOi2FlzlGUoX8QiCkpPCHolRBLoAZWzgc3GXN9xE06e0/MBr8WRtdkpQwC8EhocN8eOR1GaU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1645505868; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=/UkmmgY62YSyoybGQMVGKnMB0V73rrqLXwcLwXohdrE=; 
        b=kYZTgbEAgUrQLWj81hitkI22wm9QRkAiIQFETNvereHyAu4zZ4I9f4PmgoiX3XAsWmiDX7XzBaoIGDYOdyFDjbRJcuylseav/4KCeS0RztWsc5VOEEFURAoN+kEIfhvjN8nRUf8D0SHJ5uqmJUqUR/+HuxpDV3L51uAiprOF+Lw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645505868;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=/UkmmgY62YSyoybGQMVGKnMB0V73rrqLXwcLwXohdrE=;
        b=DAL4UQbqhqYw/lUDKJshckOaV4YzQjaPqIyk1j7FJkZXEalmunG2DDMx7RPN4/lB
        V5zcrEdZTscUbzSHDt5R2xdWmJvAO834PlW+fNVJAFj7W8+PEud/cErIJk9+MNVObTW
        8xIgrctPAzzo8I9vrfTu2Z+BI2szWm98PX46O3Yg=
Received: from anirudhrb.com (49.207.226.61 [49.207.226.61]) by mx.zohomail.com
        with SMTPS id 1645505864771584.2630304556701; Mon, 21 Feb 2022 20:57:44 -0800 (PST)
Date:   Tue, 22 Feb 2022 10:27:36 +0530
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vhost: validate range size before adding to iotlb
Message-ID: <YhRtQEWBF0kqWMsI@anirudhrb.com>
References: <20220221195303.13560-1-mail@anirudhrb.com>
 <CACGkMEvLE=kV4PxJLRjdSyKArU+MRx6b_mbLGZHSUgoAAZ+-Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEvLE=kV4PxJLRjdSyKArU+MRx6b_mbLGZHSUgoAAZ+-Fg@mail.gmail.com>
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 10:50:20AM +0800, Jason Wang wrote:
> On Tue, Feb 22, 2022 at 3:53 AM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
> >
> > In vhost_iotlb_add_range_ctx(), validate the range size is non-zero
> > before proceeding with adding it to the iotlb.
> >
> > Range size can overflow to 0 when start is 0 and last is (2^64 - 1).
> > One instance where it can happen is when userspace sends an IOTLB
> > message with iova=size=uaddr=0 (vhost_process_iotlb_msg). So, an
> > entry with size = 0, start = 0, last = (2^64 - 1) ends up in the
> > iotlb. Next time a packet is sent, iotlb_access_ok() loops
> > indefinitely due to that erroneous entry:
> >
> >         Call Trace:
> >          <TASK>
> >          iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
> >          vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
> >          vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
> >          vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
> >          kthread+0x2e9/0x3a0 kernel/kthread.c:377
> >          ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> >          </TASK>
> >
> > Reported by syzbot at:
> >         https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
> >
> > Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > Tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> > ---
> >  drivers/vhost/iotlb.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> > index 670d56c879e5..b9de74bd2f9c 100644
> > --- a/drivers/vhost/iotlb.c
> > +++ b/drivers/vhost/iotlb.c
> > @@ -53,8 +53,10 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> >                               void *opaque)
> >  {
> >         struct vhost_iotlb_map *map;
> > +       u64 size = last - start + 1;
> >
> > -       if (last < start)
> > +       // size can overflow to 0 when start is 0 and last is (2^64 - 1).
> > +       if (last < start || size == 0)
> >                 return -EFAULT;
> 
> I'd move this check to vhost_chr_iter_write(), then for the device who
> has its own msg handler (e.g vDPA) can benefit from it as well.

Thanks for reviewing!

I kept the check here thinking that all devices would benefit from it
because they would need to call vhost_iotlb_add_range() to add an entry
to the iotlb. Isn't that correct? Do you see any other benefit in moving
it to vhost_chr_iter_write()?

One concern I have is that if we move it out some future caller to
vhost_iotlb_add_range() might forget to handle this case.

Thanks!

	- Anirudh.

> 
> Thanks
> 
> >
> >         if (iotlb->limit &&
> > @@ -69,7 +71,7 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> >                 return -ENOMEM;
> >
> >         map->start = start;
> > -       map->size = last - start + 1;
> > +       map->size = size;
> >         map->last = last;
> >         map->addr = addr;
> >         map->perm = perm;
> > --
> > 2.35.1
> >
> 
