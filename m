Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C725F652CF1
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 07:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbiLUGhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 01:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbiLUGhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 01:37:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0421A4
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 22:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671604572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wKhkj/21Do8ONbBkblULUJb4FemGB4hgx2UqQZiW/8I=;
        b=U+Cd35RzBKPMsj903+6ICjChqiDXTrtxyYp+YEFE7psptLRKSmCHeovchNtCwhXCIMo3sW
        8dr6YFi/zE2vV4Jk5TbywJq59GdBJjllIFOYOUFP2hi+LWhlO365OpUcPCVAuUuxXmuXSP
        0+fD1wRM82/8dyqfj8J8ivz28S9eanU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-68-aoouVZveN2WCqqVJGxQCCQ-1; Wed, 21 Dec 2022 01:36:11 -0500
X-MC-Unique: aoouVZveN2WCqqVJGxQCCQ-1
Received: by mail-qt1-f200.google.com with SMTP id g12-20020ac870cc000000b003a8112df2e9so6530814qtp.9
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 22:36:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wKhkj/21Do8ONbBkblULUJb4FemGB4hgx2UqQZiW/8I=;
        b=mlY3K/1p6dZ/FO5+/+frRlD0HfWzF3LK93TvvMKzkK2BOaw8PQboiZ3t6hcdQxJdWx
         r6jaUzDLo8hgm4MFbCbMQnfi48qECLb4kF9Qnm2JGpioEY+FV/uTZ2q7mzKOjJIoCrc0
         z3ryLUB/U0TyNq3PDOSbsA61oY5e8ybbXGEHjRJBOhja9XFLMZiBz1u4fWN5LB/j3cJx
         wDsgqwpI9IMsAPp8HmAkUp4wRZYt3W4LHoEfKgcAFO0Y5iu8mnHefASSWD1t+RuD5Rfl
         LlJeZkDBPTtWfO6+kybe/kp0srU1yF4j5zFBLyQ3wV1Rq2vxcoHZEbB4R7i0daSTP21U
         zgrQ==
X-Gm-Message-State: AFqh2ko20VeIg3Yh45ll6O2ptT4LTkjlCyzj3sgUmvlNh34CNEwk3Rq2
        sWjiryj1NUWY9LK6NzcseW9Z/s/hwZ3ex8+KKnY+z2HxqEx7CeqtWjhO+ZDjsNVpphBgSlWFd1j
        M+f0hv4ep6wc0k6cf
X-Received: by 2002:a05:622a:1a24:b0:3a8:a84:7ffa with SMTP id f36-20020a05622a1a2400b003a80a847ffamr954721qtb.57.1671604570878;
        Tue, 20 Dec 2022 22:36:10 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt4se2y/tKSLu1brm/C02VJZsHqaFyvvMvo48H7mgvzgsCusjdcwkKvdjsKyiijpG84W/5vmw==
X-Received: by 2002:a05:622a:1a24:b0:3a8:a84:7ffa with SMTP id f36-20020a05622a1a2400b003a80a847ffamr954700qtb.57.1671604570627;
        Tue, 20 Dec 2022 22:36:10 -0800 (PST)
Received: from redhat.com ([37.19.199.117])
        by smtp.gmail.com with ESMTPSA id d16-20020a05620a241000b006ec62032d3dsm10574761qkn.30.2022.12.20.22.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 22:36:10 -0800 (PST)
Date:   Wed, 21 Dec 2022 01:36:05 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cindy Lu <lulu@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] vhost_vdpa: fix the compile issue in commit 881ac7d2314f
Message-ID: <20221221013535-mutt-send-email-mst@kernel.org>
References: <20221220140205.795115-1-lulu@redhat.com>
 <CACGkMEuJuUrA220XgHDOruK-aHWSfJ6mTaqNVQCAcOsPEwV91A@mail.gmail.com>
 <CACLfguUgsWrE+ZFxJYd-h81AvMQFio0-VU9oE0kpj7t5D2pJvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACLfguUgsWrE+ZFxJYd-h81AvMQFio0-VU9oE0kpj7t5D2pJvg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 01:58:11PM +0800, Cindy Lu wrote:
> On Wed, 21 Dec 2022 at 11:23, Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Tue, Dec 20, 2022 at 10:02 PM Cindy Lu <lulu@redhat.com> wrote:
> > >
> > > The input of  vhost_vdpa_iotlb_unmap() was changed in 881ac7d2314f,
> > > But some function was not changed while calling this function.
> > > Add this change
> > >
> > > Cc: stable@vger.kernel.org
> > > Fixes: 881ac7d2314f ("vhost_vdpa: fix the crash in unmap a large memory")
> >
> > Is this commit merged into Linus tree?
> >
> > Btw, Michael, I'd expect there's a respin of the patch so maybe Cindy
> > can squash the fix into the new version?
> >
> > Thanks
> >
> This is not merged in linus tree, and this compile issue was hit in mst's tree
> should I send a new version squash the patch and the fix?
> 
> Thanks
> Cindy

No I fixed it myself. Pls check my tree now if it's not ok let me know.
Thanks!

> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > > ---
> > >  drivers/vhost/vdpa.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > index 46ce35bea705..ec32f785dfde 100644
> > > --- a/drivers/vhost/vdpa.c
> > > +++ b/drivers/vhost/vdpa.c
> > > @@ -66,8 +66,8 @@ static DEFINE_IDA(vhost_vdpa_ida);
> > >  static dev_t vhost_vdpa_major;
> > >
> > >  static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
> > > -                                  struct vhost_iotlb *iotlb,
> > > -                                  u64 start, u64 last);
> > > +                                  struct vhost_iotlb *iotlb, u64 start,
> > > +                                  u64 last, u32 asid);
> > >
> > >  static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
> > >  {
> > > @@ -139,7 +139,7 @@ static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
> > >                 return -EINVAL;
> > >
> > >         hlist_del(&as->hash_link);
> > > -       vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
> > > +       vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1, asid);
> > >         kfree(as);
> > >
> > >         return 0;
> > > --
> > > 2.34.3
> > >
> >

