Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC654BFBD3
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 16:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbiBVPDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 10:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbiBVPDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 10:03:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E640E1EC42
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 07:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645542158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rdi/qxR3vXLdPYSOnT7lLR4Cj8YvfdXVSXReKwN9fr0=;
        b=B4RXh2GflujhOpqtaW4gvtYFTe01ObjyiUXlK2//SZwcbGiqE29Np9Gs2HpX+3nyCjnRiv
        ZaISquR01lxzJxsuZRo8ObO9QyTM8MOJAgBgRxuGLmzMdgyg90puA1K44pt4jkBcOHabvz
        IuM1+JMDZsbyTRyx1yX6zCPaiyWtv8A=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-Kys5FrzlPWuzGj95S9Ic9A-1; Tue, 22 Feb 2022 10:02:34 -0500
X-MC-Unique: Kys5FrzlPWuzGj95S9Ic9A-1
Received: by mail-ed1-f72.google.com with SMTP id s7-20020a508dc7000000b0040f29ccd65aso12141011edh.1
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 07:02:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rdi/qxR3vXLdPYSOnT7lLR4Cj8YvfdXVSXReKwN9fr0=;
        b=7F0Wa/h6lLyfbIeyoZXk4xTfF9QYetNEYRoPJMdahe5vLPcs0pd0lDuIW8MmPCBWui
         BZZ88ynIfhbvqvi3ZBbr33IfteK/XXAZAco7F9HEFwkbU8GSaA1htkLcrrrioigTAr0A
         g5ewVsSUvF2cKWvLEN8nNrLbjat4lYBx/UpvxB4rtfOpuYpPlUjaP8Btwn/QMcKOai2T
         bmZX9i/034v9cYdz0ZzCdE2h27Y8HlwVIKzhvmIWAAM6J+k6GBs2dJYiakWiUD9KGPrX
         w/BQvZSsueIcfLcgTNjvChKDbvakJLZ3iBIlE2ZioLPU2t4M9Pfp8u6+t9gvMMgTP/2u
         YzwQ==
X-Gm-Message-State: AOAM531rAN15JsfD18mO4lQ5/kyB4ocOJ2F9jhOB9mNPY3J07ywyskVh
        D2DdxJ/Op1+v5T7vR8THddZw1s6/hEQ8BsmMsb7RNFQlGBqKflsrQSDF5F4M6JJHSKVcO/67nij
        rV7k4xMOAFLz0HKBi
X-Received: by 2002:a17:906:2991:b0:6cf:1fd4:39a3 with SMTP id x17-20020a170906299100b006cf1fd439a3mr19565083eje.21.1645542153504;
        Tue, 22 Feb 2022 07:02:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwfs/vKQLHNEKKWfGdfWtjrGEHBFte8MvKz5Y50OjDrG513NxeN/Cw3t2XJvu4U4AxkMg15eQ==
X-Received: by 2002:a17:906:2991:b0:6cf:1fd4:39a3 with SMTP id x17-20020a170906299100b006cf1fd439a3mr19565062eje.21.1645542153204;
        Tue, 22 Feb 2022 07:02:33 -0800 (PST)
Received: from redhat.com ([2.55.129.240])
        by smtp.gmail.com with ESMTPSA id q16sm5998109ejc.21.2022.02.22.07.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 07:02:32 -0800 (PST)
Date:   Tue, 22 Feb 2022 10:02:29 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vhost: validate range size before adding to iotlb
Message-ID: <20220222090511-mutt-send-email-mst@kernel.org>
References: <20220221195303.13560-1-mail@anirudhrb.com>
 <CACGkMEvLE=kV4PxJLRjdSyKArU+MRx6b_mbLGZHSUgoAAZ+-Fg@mail.gmail.com>
 <YhRtQEWBF0kqWMsI@anirudhrb.com>
 <CACGkMEvd7ETC_ANyrOSAVz_i64xqpYYazmm=+39E51=DMRFXdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEvd7ETC_ANyrOSAVz_i64xqpYYazmm=+39E51=DMRFXdw@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 03:11:07PM +0800, Jason Wang wrote:
> On Tue, Feb 22, 2022 at 12:57 PM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
> >
> > On Tue, Feb 22, 2022 at 10:50:20AM +0800, Jason Wang wrote:
> > > On Tue, Feb 22, 2022 at 3:53 AM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
> > > >
> > > > In vhost_iotlb_add_range_ctx(), validate the range size is non-zero
> > > > before proceeding with adding it to the iotlb.
> > > >
> > > > Range size can overflow to 0 when start is 0 and last is (2^64 - 1).
> > > > One instance where it can happen is when userspace sends an IOTLB
> > > > message with iova=size=uaddr=0 (vhost_process_iotlb_msg). So, an
> > > > entry with size = 0, start = 0, last = (2^64 - 1) ends up in the
> > > > iotlb. Next time a packet is sent, iotlb_access_ok() loops
> > > > indefinitely due to that erroneous entry:
> > > >
> > > >         Call Trace:
> > > >          <TASK>
> > > >          iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
> > > >          vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
> > > >          vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
> > > >          vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
> > > >          kthread+0x2e9/0x3a0 kernel/kthread.c:377
> > > >          ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> > > >          </TASK>
> > > >
> > > > Reported by syzbot at:
> > > >         https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
> > > >
> > > > Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > > > Tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > > > Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> > > > ---
> > > >  drivers/vhost/iotlb.c | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> > > > index 670d56c879e5..b9de74bd2f9c 100644
> > > > --- a/drivers/vhost/iotlb.c
> > > > +++ b/drivers/vhost/iotlb.c
> > > > @@ -53,8 +53,10 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> > > >                               void *opaque)
> > > >  {
> > > >         struct vhost_iotlb_map *map;
> > > > +       u64 size = last - start + 1;
> > > >
> > > > -       if (last < start)
> > > > +       // size can overflow to 0 when start is 0 and last is (2^64 - 1).
> > > > +       if (last < start || size == 0)
> > > >                 return -EFAULT;
> > >
> > > I'd move this check to vhost_chr_iter_write(), then for the device who
> > > has its own msg handler (e.g vDPA) can benefit from it as well.
> >
> > Thanks for reviewing!
> >
> > I kept the check here thinking that all devices would benefit from it
> > because they would need to call vhost_iotlb_add_range() to add an entry
> > to the iotlb. Isn't that correct?
> 
> Correct for now but not for the future, it's not guaranteed that the
> per device iotlb message handler will use vhost iotlb.
> 
> But I agree that we probably don't need to care about it too much now.
> 
> > Do you see any other benefit in moving
> > it to vhost_chr_iter_write()?
> >
> > One concern I have is that if we move it out some future caller to
> > vhost_iotlb_add_range() might forget to handle this case.
> 
> Yes.
> 
> Rethink the whole fix, we're basically rejecting [0, ULONG_MAX] range
> which seems a little bit odd.

Well, I guess ideally we'd split this up as two entries - this kind of
thing is after all one of the reasons we initially used first,last as
the API - as opposed to first,size.

Anirudh, could you do it like this instead of rejecting?


> I wonder if it's better to just remove
> the map->size. Having a quick glance at the the user, I don't see any
> blocker for this.
> 
> Thanks

I think it's possible but won't solve the bug by itself, and we'd need
to review and fix all users - a high chance of introducing
another regression. And I think there's value of fitting under the
stable rule of 100 lines with context.
So sure, but let's fix the bug first.



> >
> > Thanks!
> >
> >         - Anirudh.
> >
> > >
> > > Thanks
> > >
> > > >
> > > >         if (iotlb->limit &&
> > > > @@ -69,7 +71,7 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> > > >                 return -ENOMEM;
> > > >
> > > >         map->start = start;
> > > > -       map->size = last - start + 1;
> > > > +       map->size = size;
> > > >         map->last = last;
> > > >         map->addr = addr;
> > > >         map->perm = perm;
> > > > --
> > > > 2.35.1
> > > >
> > >
> >

