Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97FC69C42E
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 03:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjBTChZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 21:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjBTChX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 21:37:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C239776
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 18:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676860600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+QRTKe9fslXsmMjbWLGC+1jCq193n05lX0twVp21S3I=;
        b=hsGpX6976hdhAd1NgH70VDZh0rG01tRZWoHcrTr3H/+aWtrTKiD15S/nkUTGEVJ3N6+cvo
        oqbg77tBv5eMvPLwey23tOajo+slchKYyv6Dm1KxJkIAiSfjMcQ65hw0h+iKPGfXg24KXO
        Nph51+kvI6djeAp4kWlnHXexl91LPfs=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-642-QBLBKlGwNyWAcN13Zf57hQ-1; Sun, 19 Feb 2023 21:36:39 -0500
X-MC-Unique: QBLBKlGwNyWAcN13Zf57hQ-1
Received: by mail-oi1-f199.google.com with SMTP id o20-20020a05680803d400b0036e1f34427aso301654oie.18
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 18:36:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+QRTKe9fslXsmMjbWLGC+1jCq193n05lX0twVp21S3I=;
        b=eqA937bqovQA+JIDKj0vmRW2Ej1+rKriQiTx4nN0Hgrcb3QyFh5jPWc852/Ggsn6LY
         soS2H3N6KIaqqVNtqvoa1a/srEgp0BzccJ7CgZ9gQVB5wHf7LKJALmV24B/GIsLSX+7N
         pCQVpGl5it2+78BvWUutDzsIA+IHZGn6VbSAYlfQLamqetgoVXROzRkWAn3EnYXZGC/2
         DfN0PgdZEXB7EXmmVJ9c527jwoGv1gv7hQkKv7b+BslYhh/dN63UURg3PqdVyqO7PugN
         LdJd+h8l+n7VNRvb+bng27ACtYlcx+tSPgYLo/UmTWkQru7EzH+S6TTF6nQvZwV+LbLn
         r1jw==
X-Gm-Message-State: AO0yUKWyI+68PQ5BJ84OGtf9RwF4J8W8LW3GjtzBV9YGQ0QHusy2668r
        v7FOLFuzRceXC7WSPcARwu/ubhdH1rlnH3OY63/8Gzjpky0XIu1m9V4Q6zI/xThSq5SmDlyS60W
        vkQw04uJI2TghTbqTAFoGmA5+hDwxwAI+
X-Received: by 2002:a05:6870:610c:b0:171:d1a1:c5cb with SMTP id s12-20020a056870610c00b00171d1a1c5cbmr212596oae.217.1676860598326;
        Sun, 19 Feb 2023 18:36:38 -0800 (PST)
X-Google-Smtp-Source: AK7set+o/PIyYCf/r6enEsMKw/BDh3XyDsV2IO5FKzRCPBc/l0Kkzql2S6nZ1RAhn3rjmZd7RJyHVxQxAPtJc0uZzgY=
X-Received: by 2002:a05:6870:610c:b0:171:d1a1:c5cb with SMTP id
 s12-20020a056870610c00b00171d1a1c5cbmr212592oae.217.1676860598109; Sun, 19
 Feb 2023 18:36:38 -0800 (PST)
MIME-Version: 1.0
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
 <Y+7G+tiBCjKYnxcZ@nvidia.com> <CACGkMEtehykvqNUnfCi0VmHR1xpmhj4sSWdYW1-0oATY=0YhXw@mail.gmail.com>
 <20230217051038-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230217051038-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 20 Feb 2023 10:36:27 +0800
Message-ID: <CACGkMEuDG1NUs0=ry1=Mphfd+TrqAvVS0yeu9hcni2VrPkB8tQ@mail.gmail.com>
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Nanyong Sun <sunnanyong@huawei.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        wangrong68@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 6:11 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Feb 17, 2023 at 01:35:59PM +0800, Jason Wang wrote:
> > On Fri, Feb 17, 2023 at 8:15 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > On Tue, Feb 07, 2023 at 08:08:43PM +0800, Nanyong Sun wrote:
> > > > From: Rong Wang <wangrong68@huawei.com>
> > > >
> > > > Once enable iommu domain for one device, the MSI
> > > > translation tables have to be there for software-managed MSI.
> > > > Otherwise, platform with software-managed MSI without an
> > > > irq bypass function, can not get a correct memory write event
> > > > from pcie, will not get irqs.
> > > > The solution is to obtain the MSI phy base address from
> > > > iommu reserved region, and set it to iommu MSI cookie,
> > > > then translation tables will be created while request irq.
> > >
> > > Probably not what anyone wants to hear, but I would prefer we not add
> > > more uses of this stuff. It looks like we have to get rid of
> > > iommu_get_msi_cookie() :\
> > >
> > > I'd like it if vdpa could move to iommufd not keep copying stuff from
> > > it..
> >
> > Yes, but we probably need a patch for -stable.
>
> Hmm do we? this looks like it's enabling new platforms is not a bugfix...

I think we haven't limited vDPA to any specific arch in the past?

Thanks

>
> > >
> > > Also the iommu_group_has_isolated_msi() check is missing on the vdpa
> > > path, and it is missing the iommu ownership mechanism.
> >
> > Ok.
> >
> > >
> > > Also which in-tree VDPA driver that uses the iommu runs on ARM? Please
> >
> > ifcvf and vp_vpda are two drivers that use platform IOMMU.
> >
> > Thanks
> >
> > > don't propose core changes for unmerged drivers. :(
> > >
> > > Jason
> > >
>

