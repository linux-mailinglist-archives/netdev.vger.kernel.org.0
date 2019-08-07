Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEFA8509B
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 18:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388886AbfHGQGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 12:06:25 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45306 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387626AbfHGQGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 12:06:24 -0400
Received: by mail-ot1-f66.google.com with SMTP id x21so13099080otq.12;
        Wed, 07 Aug 2019 09:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AOfNJoVis4tu5FW/x4K5fd3Kb4BI9lC9c+PcHuGbSJI=;
        b=rHZRSP4Mj7U/HkytF9Zva56bn+5Sg4odmEri/N7n+ITRLCyiUj2eMmCJlHy4XlLYsc
         7gJIN/GF3DAsUHa4BH7V0W2QaOPem6U3rgj0srz/w+BOfWwZ+8s7urdEe+Z3nXeAP9o6
         6+oCplvH6V5cloglseO3mDXC06ioD25CV2idliDu8whCh8Py2B8HSijwVJ4l/U3wzT/e
         2PI/Sf1UElctkc8X8QP9CZGa6RbSuvH81uctJMqTFtQhvbRtItLQ5e4wLnXl8N3jSmuI
         E0FWZ/m5t803vlXqBH1l4W/l02psddI0zSf8Vq/2EzBEDcA8/sbkzk7IYRug/6obhO5Q
         MI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AOfNJoVis4tu5FW/x4K5fd3Kb4BI9lC9c+PcHuGbSJI=;
        b=f8r64OV/fk/WlgkfqMqSEgiUXYv3muVCAOZJrjj8H1j1lKbOG6nSlVnOoGe6fp1LD4
         TCacV1ixcT6qwXfynZByFjErAGeO1pxPXk28YKHUT9UOXHsRZu/08G1U2wuplTbsLYlH
         SMtLlM6jEzs3I6mh1nvieO2i1ItKNOyZihAb9nPWMHYH0AjUemAMdrB0bNcCOFjl30sa
         6GMhSgkYnOOeYmIjBOUtnpMtjjwFfWRYFSTTQza7+p4hQYpRPgepweyRpWh/bY4W37aT
         QPmWEfu9T9sm3/dciLpQHVFQFzrDQ7Hz3oRDmKR9i/XmOydaqHHEb4V0jbnReSrMdNBr
         zCAQ==
X-Gm-Message-State: APjAAAU8Y8ae2gFUKJ1k1X/zo7JCWe9Ss0VSPmHbhnbisNhvf0kgEq4i
        NJFDuhyVeRfgNp4O16/7wfEg6ssQIP1H9/q1SLc=
X-Google-Smtp-Source: APXvYqwVvjHIkuTBZZW6ETURsPt3jc50m2JDUoKCPRZ5XBlEz5RskqQ9NfuypJ8JlV4IerpOHeGb3SA1EexymMe2UPE=
X-Received: by 2002:a6b:dd18:: with SMTP id f24mr9312803ioc.97.1565193983972;
 Wed, 07 Aug 2019 09:06:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190807024917.27682-1-firo.yang@suse.com> <85aaefdf-d454-1823-5840-d9e2f71ffb19@oracle.com>
 <20190807083831.GA6811@linux-6qg8> <20190807160853.00001d71@gmail.com>
In-Reply-To: <20190807160853.00001d71@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 7 Aug 2019 09:06:12 -0700
Message-ID: <CAKgT0UfEh8cvTht3yceyXqwReJOQkcpJV8j0vHSJwookTWhn_Q@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH v2 1/1] ixgbe: sync the first fragment unconditionally
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Cc:     Firo Yang <firo.yang@suse.com>, Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Jacob Wen <jian.w.wen@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 7:09 AM Maciej Fijalkowski
<maciejromanfijalkowski@gmail.com> wrote:
>
> On Wed, 7 Aug 2019 08:38:43 +0000
> Firo Yang <firo.yang@suse.com> wrote:
>
> > The 08/07/2019 15:56, Jacob Wen wrote:
> > > I think the description is not correct. Consider using something like below.
> > Thank you for comments.
> >
> > >
> > > In Xen environment, due to memory fragmentation ixgbe may allocate a 'DMA'
> > > buffer with pages that are not physically contiguous.
> > Actually, I didn't look into the reason why ixgbe got a DMA buffer which
> > was mapped to Xen-swiotlb area.
>
> I think that neither of these descriptions are telling us what was truly
> broken. They lack what Alexander wrote on v1 thread of this patch.
>
> ixgbe_dma_sync_frag is called only on case when the current descriptor has EOP
> bit set, skb was already allocated and you'll be adding a current buffer as a
> frag. DMA unmapping for the first frag was intentionally skipped and we will be
> unmapping it here, in ixgbe_dma_sync_frag. As Alex said, we're using the
> DMA_ATTR_SKIP_CPU_SYNC attribute which obliges us to perform a sync manually
> and it was missing.
>
> So IMHO the commit description should include descriptions from both xen and
> ixgbe worlds, the v2 lacks info about ixgbe case.
>
> BTW Alex, what was the initial reason for holding off with unmapping the first
> buffer? Asking because IIRC the i40e and ice behave a bit different here. We
> don't look there for EOP at all when building/constructing skb and not delaying
> the unmap of non-eop buffers.
>
> Thanks,
> Maciej

The reason why we have to hold off on unmapping the first buffer is
because in the case of Receive Side Coalescing (RSC), also known as Large
Receive Offload (LRO), the header of the packet is updated for each
additional frame that is added. As such you can end up with the device
writing data, header, data, header, data, header where each data write
would update a new descriptor, but the header will only ever update the
first descriptor in the chain. As such if we unmapped it earlier it would
result in an IOMMU fault because the device would be rewriting the header
after it had been unmapped.

The devices supported by the ixgbe driver are the only ones that have
RSC/LRO support. As such this behavior is present for ixgbe, but not for
other Intel NIC drivers including igb, igbvf, ixgbevf, i40e, etc.

- Alex
