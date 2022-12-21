Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D265652D08
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 07:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbiLUGtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 01:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLUGtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 01:49:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E851EEF1
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 22:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671605334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+/4TAy3lxZDNq7ujOJb9FKrW+iCRhzmTxD7N7cv0eCg=;
        b=H1+aHV40fUsRjsHFHfVc4YSEAeycTMXgliaxQBsxZhtSOgsgTpEJS1qSs8ickmGuqSTUQL
        HSyQgrFVBDIf+3K700Ntc/qSyOPboiUT4weqkDxBs69VSbbZg/SaFxyBQLkYLY2eGKxRyF
        0EvD4EqWInu8GfqYH7BYSfn83rVIA+4=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-441-ujfnMJw-MLGiSa8tLeTrAA-1; Wed, 21 Dec 2022 01:48:51 -0500
X-MC-Unique: ujfnMJw-MLGiSa8tLeTrAA-1
Received: by mail-oo1-f72.google.com with SMTP id v5-20020a056820004500b004a35517bb38so6586800oob.18
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 22:48:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+/4TAy3lxZDNq7ujOJb9FKrW+iCRhzmTxD7N7cv0eCg=;
        b=20Hj97ddBn+0wBKCJpiUAvuQf4qdtf5xIXGr4zYFShiAo3FPM6hBxBYZHuBu2UG0Sa
         qiV4ruo9fxdZ1pGTK72CG/RxgvfOea3zloEiQi8t9fvWUe+uRShHUOiH33gaKKyzJH7s
         ulqahRhT37qagRSoWx+dDwszkkJsCpY/ryD2TrxZcwM7m14T6oXl3daQbG2eXu7Op5fL
         VvOOICAsM+1GHPb4PhkYa0tiLpRKIAGhsjyoRpNnNuYNNGP4GQruJH3t/c/jaG6p1mNC
         RS63lJLJnWyHc8XW5HHCIUqLlmZ94xUKK6DK32xHouuJpV85yhZA/ym6X9L7peAOUKtq
         f5sg==
X-Gm-Message-State: AFqh2korkUfPPMd10acqrN5bkSBy02dvy5bFnOhvzVRgrqXEBA1LDkgu
        Q1XuIaXVwt81cKal/cVQGThBet3CumT5Exu6cD1cjJF5bC5CIOQvI9rPJles8rQEQlQ4htho5X5
        jOuLE7Sn/a1LHtjCqrd2n2aTR03a47pnO
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id u19-20020a056870441300b00144a97b1ae2mr29058oah.35.1671605331286;
        Tue, 20 Dec 2022 22:48:51 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu80udxD6YrnxsV720q5HV+2HR8kMLdfBS0FZI0RkgPvpsYJe396SNLloD8Y2DlUjugZ1aCdXjvrEHubwRFXk0=
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id
 u19-20020a056870441300b00144a97b1ae2mr29055oah.35.1671605331053; Tue, 20 Dec
 2022 22:48:51 -0800 (PST)
MIME-Version: 1.0
References: <20221220140205.795115-1-lulu@redhat.com> <CACGkMEuJuUrA220XgHDOruK-aHWSfJ6mTaqNVQCAcOsPEwV91A@mail.gmail.com>
 <20221221013359-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221221013359-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 21 Dec 2022 14:48:40 +0800
Message-ID: <CACGkMEuXPoR_yp3ZC7XH4TZ8NdL21kWtJaxq22+VU7RQG13f8Q@mail.gmail.com>
Subject: Re: [PATCH] vhost_vdpa: fix the compile issue in commit 881ac7d2314f
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Cindy Lu <lulu@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 2:35 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Dec 21, 2022 at 11:23:09AM +0800, Jason Wang wrote:
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
>
> Thanks, I fixed it myself already. Why do you want a respin?

For some reason I miss v4, so it should be fine.

Thanks

> That will mean trouble as the fixed patch is now being tested.
>
>
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
>

