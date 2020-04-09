Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06E5D1A3B4A
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 22:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgDIUZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 16:25:28 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43933 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726623AbgDIUZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 16:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586463922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L8axp0M5oMyn2GgLyL35ut9Src771+7B+nC1atGx9hE=;
        b=CtodDgnmq14Flol6VGruMyhaU1bHSCY72jifTfhul+kYGHODaHiyY3/B/HBS+lTwR33Bj9
        QkxqTti1MfRM5Na21hiRn7rdTJlK3HtcaDV5IEz1CnLAxZMEW9xIPjcsxgA+JXtCUeMVmh
        9IakI0XvXCYw1Uc1ixVJsp1w3rfezkE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-kdoOhch0PsSvFSmYWqdq4w-1; Thu, 09 Apr 2020 16:25:21 -0400
X-MC-Unique: kdoOhch0PsSvFSmYWqdq4w-1
Received: by mail-wm1-f69.google.com with SMTP id f8so5834wmh.4
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 13:25:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L8axp0M5oMyn2GgLyL35ut9Src771+7B+nC1atGx9hE=;
        b=j8wawrIOOz4IC6Y/8fQ1s4f/Mcmg4eGfYlcuaM+kKTNkCCd/Lbw2+xQseug42KtdaC
         iN+hL0OrWILXJK4BTIu+QlypAFRLvavi41cOLH+U6gphRZRwL8ZWpT/FGVKSByp8GCJC
         k98Cxz/8hFrDj+bDjKOeXEd2IRjVCOQOQUDeNz0b6zSjzH5n8dY5k4tQ/Z2MOhW5Hh9E
         ZyYQFDwWJr3Qq5vy1dIXvvaLaDMSuoEGBBgP+7cJJgXmXLRbD8raDfdcbo6EVfBC6FLT
         v358vh9FjRqkfIpUpHFkOH+f4X75pmRt2ox+FGB2s2xJ/v4PDG28GAl3kc7+ulSV8AiY
         notw==
X-Gm-Message-State: AGi0PuaaPuxP8nDAKuCwlkqulonitzzfKogzL5dhMD+Fj17Zgk9Uo9zb
        s5Tv2em+5Ha45l98UKYYjNa7GwvpVkmG0rC9O+TITs5qzZbRBWWuPsRLXKd/fOgo+tKz+V7OcOO
        WwLKRVcGHbAbnSSiX
X-Received: by 2002:a5d:5273:: with SMTP id l19mr962750wrc.42.1586463920112;
        Thu, 09 Apr 2020 13:25:20 -0700 (PDT)
X-Google-Smtp-Source: APiQypK9hgUgDJGxmm/80KKJjVxLtENNXunW/R8rpld3/YZUF/cp56xBd16lnX4CPWATeKNdabIvmw==
X-Received: by 2002:a5d:5273:: with SMTP id l19mr962722wrc.42.1586463919863;
        Thu, 09 Apr 2020 13:25:19 -0700 (PDT)
Received: from redhat.com (bzq-109-67-97-76.red.bezeqint.net. [109.67.97.76])
        by smtp.gmail.com with ESMTPSA id s13sm25438882wrw.20.2020.04.09.13.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 13:25:19 -0700 (PDT)
Date:   Thu, 9 Apr 2020 16:25:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jason Wang <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Networking <netdev@vger.kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        Parav Pandit <parav@mellanox.com>, kevin.tian@intel.com,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, aadam@redhat.com,
        Jiri Pirko <jiri@mellanox.com>, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, Bie Tiwei <tiwei.bie@intel.com>
Subject: Re: [PATCH V9 9/9] virtio: Intel IFC VF driver for VDPA
Message-ID: <20200409162427-mutt-send-email-mst@kernel.org>
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-10-jasowang@redhat.com>
 <CAK8P3a1RXUXs5oYjB=Jq5cpvG11eTnmJ+vc18_-0fzgTH6envA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1RXUXs5oYjB=Jq5cpvG11eTnmJ+vc18_-0fzgTH6envA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 09, 2020 at 12:41:13PM +0200, Arnd Bergmann wrote:
> On Thu, Mar 26, 2020 at 3:08 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> > From: Zhu Lingshan <lingshan.zhu@intel.com>
> >
> > This commit introduced two layers to drive IFC VF:
> >
> > (1) ifcvf_base layer, which handles IFC VF NIC hardware operations and
> >     configurations.
> >
> > (2) ifcvf_main layer, which complies to VDPA bus framework,
> >     implemented device operations for VDPA bus, handles device probe,
> >     bus attaching, vring operations, etc.
> >
> > Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> > Signed-off-by: Bie Tiwei <tiwei.bie@intel.com>
> > Signed-off-by: Wang Xiao <xiao.w.wang@intel.com>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> > +
> > +#define IFCVF_QUEUE_ALIGNMENT  PAGE_SIZE
> > +#define IFCVF_QUEUE_MAX                32768
> > +static u16 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
> > +{
> > +       return IFCVF_QUEUE_ALIGNMENT;
> > +}
> 
> This fails to build on arm64 with 64kb page size (found in linux-next):
> 
> /drivers/vdpa/ifcvf/ifcvf_main.c: In function 'ifcvf_vdpa_get_vq_align':
> arch/arm64/include/asm/page-def.h:17:20: error: conversion from 'long
> unsigned int' to 'u16' {aka 'short unsigned int'} changes value from
> '65536' to '0' [-Werror=overflow]
>    17 | #define PAGE_SIZE  (_AC(1, UL) << PAGE_SHIFT)
>       |                    ^
> drivers/vdpa/ifcvf/ifcvf_base.h:37:31: note: in expansion of macro 'PAGE_SIZE'
>    37 | #define IFCVF_QUEUE_ALIGNMENT PAGE_SIZE
>       |                               ^~~~~~~~~
> drivers/vdpa/ifcvf/ifcvf_main.c:231:9: note: in expansion of macro
> 'IFCVF_QUEUE_ALIGNMENT'
>   231 |  return IFCVF_QUEUE_ALIGNMENT;
>       |         ^~~~~~~~~~~~~~~~~~~~~
> 
> It's probably good enough to just not allow the driver to be built in that
> configuration as it's fairly rare but unfortunately there is no simple Kconfig
> symbol for it.
> 
> In a similar driver, we did
> 
> config VMXNET3
>         tristate "VMware VMXNET3 ethernet driver"
>         depends on PCI && INET
>         depends on !(PAGE_SIZE_64KB || ARM64_64K_PAGES || \
>                      IA64_PAGE_SIZE_64KB || MICROBLAZE_64K_PAGES || \
>                      PARISC_PAGE_SIZE_64KB || PPC_64K_PAGES)
> 
> I think we should probably make PAGE_SIZE_64KB a global symbol
> in arch/Kconfig and have it selected by the other symbols so drivers
> like yours can add a dependency for it.
> 
>          Arnd

It's probably easier to make the alignment u32 - I don't really know why it's
u16, all callers seem to assign the result to a u32 value.

