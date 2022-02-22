Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F000B4BF270
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 08:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiBVHLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 02:11:49 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiBVHLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 02:11:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22DA4B1511
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 23:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645513882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7FSv/oEcapgvDoGQHzrlqg4yIRZgWGWLxeotDRNQuUU=;
        b=QfYMeUWdbHNfKBqd2cikNJgC6ukjCBCDCH4DoFuZ8YCYw3eXgJEoFLMIz8op/hX9qqcqk6
        aD6WjMYVqPg5hSreHPiFZ/+IbNP/l4j4ShxRgf+Kkc6BF76trHJbU6SIMX2Vh0Ou+nwzeF
        9BGGFr2og7MkCum1ooZZdwraODGB5kM=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-IX1R3HB5NE2bhdQr9nzz0A-1; Tue, 22 Feb 2022 02:11:20 -0500
X-MC-Unique: IX1R3HB5NE2bhdQr9nzz0A-1
Received: by mail-lj1-f197.google.com with SMTP id b16-20020a05651c0b1000b0024647a956a2so1342394ljr.5
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 23:11:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7FSv/oEcapgvDoGQHzrlqg4yIRZgWGWLxeotDRNQuUU=;
        b=RNsho18A78K78JucOzFLVrXto8TG43xB3YA7dFgOoMrTodi8OptK6+PzEjaqAIW8T2
         dHGCIaFXKpNHo1KPctK1l70XkKJX4ENKcmZyTFZ5kx4C7hePdQ8DUm/owdo+UPeNmcfN
         2AGjHoSguZVx+9q/FqoJZE6wyZZoISFRUnEe5bvqRpaWx8GjcAX+BLs4Bk0HeUmRcxQV
         FPa+sVt6hLgII0+WmXoRymKdD0m6C37JNcGwz1XX6D4FNhKHn24g3Cf2PzdtdVzb/27t
         r8DMrLCMB/g0nRiKppKUYXqMkaU3l98bgRDuYVo2QwYw6i2WmwmxYg50lkcyPCpH7fuX
         nfDA==
X-Gm-Message-State: AOAM5310cMxiDNlfzw94cvDazjALxj9/okllAqxrSkX/ZP/PQzaGJv4Q
        DiTjCoCmWHEAQTwR3jDm255k9ZPHivaoIW/U8/QEKXPlCJYzlmbsoqDMmYHHS7+wp+wMwNH+Yg6
        o3No1ilxR6SHRcKKemoAdYSWRd48QzXCi
X-Received: by 2002:ac2:5dc9:0:b0:443:5db1:244c with SMTP id x9-20020ac25dc9000000b004435db1244cmr16719970lfq.84.1645513878929;
        Mon, 21 Feb 2022 23:11:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxbMuAz/ix+dLAdMFMBvTxo0FVkU9ZlLpWgMVrgQgKR6osYaULNGWxhsEVLNufI0L2GR59y4OsFjZ9jVzrG5K8=
X-Received: by 2002:ac2:5dc9:0:b0:443:5db1:244c with SMTP id
 x9-20020ac25dc9000000b004435db1244cmr16719955lfq.84.1645513878661; Mon, 21
 Feb 2022 23:11:18 -0800 (PST)
MIME-Version: 1.0
References: <20220221195303.13560-1-mail@anirudhrb.com> <CACGkMEvLE=kV4PxJLRjdSyKArU+MRx6b_mbLGZHSUgoAAZ+-Fg@mail.gmail.com>
 <YhRtQEWBF0kqWMsI@anirudhrb.com>
In-Reply-To: <YhRtQEWBF0kqWMsI@anirudhrb.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 22 Feb 2022 15:11:07 +0800
Message-ID: <CACGkMEvd7ETC_ANyrOSAVz_i64xqpYYazmm=+39E51=DMRFXdw@mail.gmail.com>
Subject: Re: [PATCH] vhost: validate range size before adding to iotlb
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 12:57 PM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
>
> On Tue, Feb 22, 2022 at 10:50:20AM +0800, Jason Wang wrote:
> > On Tue, Feb 22, 2022 at 3:53 AM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
> > >
> > > In vhost_iotlb_add_range_ctx(), validate the range size is non-zero
> > > before proceeding with adding it to the iotlb.
> > >
> > > Range size can overflow to 0 when start is 0 and last is (2^64 - 1).
> > > One instance where it can happen is when userspace sends an IOTLB
> > > message with iova=size=uaddr=0 (vhost_process_iotlb_msg). So, an
> > > entry with size = 0, start = 0, last = (2^64 - 1) ends up in the
> > > iotlb. Next time a packet is sent, iotlb_access_ok() loops
> > > indefinitely due to that erroneous entry:
> > >
> > >         Call Trace:
> > >          <TASK>
> > >          iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
> > >          vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
> > >          vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
> > >          vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
> > >          kthread+0x2e9/0x3a0 kernel/kthread.c:377
> > >          ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> > >          </TASK>
> > >
> > > Reported by syzbot at:
> > >         https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
> > >
> > > Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > > Tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > > Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> > > ---
> > >  drivers/vhost/iotlb.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> > > index 670d56c879e5..b9de74bd2f9c 100644
> > > --- a/drivers/vhost/iotlb.c
> > > +++ b/drivers/vhost/iotlb.c
> > > @@ -53,8 +53,10 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> > >                               void *opaque)
> > >  {
> > >         struct vhost_iotlb_map *map;
> > > +       u64 size = last - start + 1;
> > >
> > > -       if (last < start)
> > > +       // size can overflow to 0 when start is 0 and last is (2^64 - 1).
> > > +       if (last < start || size == 0)
> > >                 return -EFAULT;
> >
> > I'd move this check to vhost_chr_iter_write(), then for the device who
> > has its own msg handler (e.g vDPA) can benefit from it as well.
>
> Thanks for reviewing!
>
> I kept the check here thinking that all devices would benefit from it
> because they would need to call vhost_iotlb_add_range() to add an entry
> to the iotlb. Isn't that correct?

Correct for now but not for the future, it's not guaranteed that the
per device iotlb message handler will use vhost iotlb.

But I agree that we probably don't need to care about it too much now.

> Do you see any other benefit in moving
> it to vhost_chr_iter_write()?
>
> One concern I have is that if we move it out some future caller to
> vhost_iotlb_add_range() might forget to handle this case.

Yes.

Rethink the whole fix, we're basically rejecting [0, ULONG_MAX] range
which seems a little bit odd. I wonder if it's better to just remove
the map->size. Having a quick glance at the the user, I don't see any
blocker for this.

Thanks

>
> Thanks!
>
>         - Anirudh.
>
> >
> > Thanks
> >
> > >
> > >         if (iotlb->limit &&
> > > @@ -69,7 +71,7 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> > >                 return -ENOMEM;
> > >
> > >         map->start = start;
> > > -       map->size = last - start + 1;
> > > +       map->size = size;
> > >         map->last = last;
> > >         map->addr = addr;
> > >         map->perm = perm;
> > > --
> > > 2.35.1
> > >
> >
>

