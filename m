Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419D03C9F70
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 15:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237655AbhGON2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 09:28:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37261 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230080AbhGON2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 09:28:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626355550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ah4MbGoLYz8PpeIyy6Wrw1o1Gg/0NPYNIWwDGG2q9MQ=;
        b=Yjhgzq/9+T6TYDTj+dynlj69arM5UrkCmKAk20jjnNhSrYVT8URBEC8oqVsOkxcpTH8Lzm
        NKiP1/RUzrLl++zGnllN90+vhBd6bGAsawFHgHDVW7zvmLWRYnatN+PGuJCNg7QfGUhESt
        5FRyJX2omwilLAkjRexwCtZ0wBSrp2s=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-elQTy-XgM9iIywebhpi0bQ-1; Thu, 15 Jul 2021 09:25:49 -0400
X-MC-Unique: elQTy-XgM9iIywebhpi0bQ-1
Received: by mail-lj1-f198.google.com with SMTP id e15-20020a2ea54f0000b029018e0ca63855so3218505ljn.14
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 06:25:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ah4MbGoLYz8PpeIyy6Wrw1o1Gg/0NPYNIWwDGG2q9MQ=;
        b=uQYbM9qeZdIL1x49K1bk/df1XsWEc8UTwytj1612wsWsdxUDZ8prBHmnKGM4JPXakc
         ufnGLrTn8TrSjPwxKcrdM4c7Ru7rbpkKEwNTOR6+OfROAmGXG4vffyI4YIV/NEfsodwj
         jNpoDoDaRqILxS/JHHbdNLRcSqwUHlEKn3h34bT8HPK+F08i0Gzql3R+GT8pE7fEUrLk
         l8nZQ9+hGtlb7Ceub1Zx/CL+znArnA45y9XjOfJIKNboq80fR7F740dZJ/FvPlV3yo9o
         w4F13No2b0GCeqVkB8VQCS1BCHGcd3ee3RbwzA6stbzqZmxypv1TXnqX29FYmggtZFdZ
         EAjg==
X-Gm-Message-State: AOAM532hVnNKlmcvxYJKzQJPkdAusGwew+bmyQjfYEhRnnGfIlMRLqWL
        uARZJcA94UpJTPcpZDHj2iUGv/HkEU3eloeU4CL60RRJApQ8Nwgg1uUuihN3onZhBwMdorqwYpj
        KmVxxksnAHqsWC9PVweHD1Axyq5v9C7jJ
X-Received: by 2002:a05:6512:3a86:: with SMTP id q6mr3149861lfu.548.1626355548024;
        Thu, 15 Jul 2021 06:25:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4dI6Pl2Y//20EnkEGgAcCVbyTORH0YWaTKsr2JdguYEYFI2ihDlt/NUiNtPNi9bYu/OMUSwAlGGsYWpUxV5M=
X-Received: by 2002:a05:6512:3a86:: with SMTP id q6mr3149783lfu.548.1626355547649;
 Thu, 15 Jul 2021 06:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210713211502.464259-1-nitesh@redhat.com> <20210713211502.464259-7-nitesh@redhat.com>
 <YO7SiFE1dE0dFhkE@unreal> <CAFki+Lm-CpKZai1fV5aMJzEb-x+003m8wLQShSrYpyNh3XC50Q@mail.gmail.com>
 <YO7ggLW78FWE4z+1@unreal>
In-Reply-To: <YO7ggLW78FWE4z+1@unreal>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Thu, 15 Jul 2021 09:25:36 -0400
Message-ID: <CAFki+L=KoVzAv-_tLjAJV91BR+fHTPffMsCs-AgSCNyE0d-0DQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/14] RDMA/irdma: Use irq_set_affinity_and_hint
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pci@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, jbrandeb@kernel.org,
        frederic@kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        Alex Belits <abelits@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>, rostedt@goodmis.org,
        peterz@infradead.org, davem@davemloft.net,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, Marc Zyngier <maz@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, pjwaskiewicz@gmail.com,
        Stefan Assmann <sassmann@redhat.com>,
        Tomas Henzl <thenzl@redhat.com>, kashyap.desai@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        suganath-prabu.subramani@broadcom.com, james.smart@broadcom.com,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Ken Cox <jkc@redhat.com>, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com,
        Alaa Hleihel <ahleihel@redhat.com>,
        Kamal Heib <kheib@redhat.com>, borisp@nvidia.com,
        saeedm@nvidia.com, benve@cisco.com, govind@gmx.com,
        jassisinghbrar@gmail.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        Al Stone <ahs3@redhat.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 9:03 AM Leon Romanovsky <leonro@nvidia.com> wrote:
>
> On Wed, Jul 14, 2021 at 08:56:41AM -0400, Nitesh Lal wrote:
> > On Wed, Jul 14, 2021 at 8:03 AM Leon Romanovsky <leonro@nvidia.com> wrote:
> > >
> > > On Tue, Jul 13, 2021 at 05:14:54PM -0400, Nitesh Narayan Lal wrote:
> > > > The driver uses irq_set_affinity_hint() to update the affinity_hint mask
> > > > that is consumed by the userspace to distribute the interrupts and to apply
> > > > the provided mask as the affinity for its interrupts. However,
> > > > irq_set_affinity_hint() applying the provided cpumask as an affinity for
> > > > the interrupt is an undocumented side effect.
> > > >
> > > > To remove this side effect irq_set_affinity_hint() has been marked
> > > > as deprecated and new interfaces have been introduced. Hence, replace the
> > > > irq_set_affinity_hint() with the new interface irq_set_affinity_and_hint()
> > > > where the provided mask needs to be applied as the affinity and
> > > > affinity_hint pointer needs to be set and replace with
> > > > irq_update_affinity_hint() where only affinity_hint needs to be updated.
> > > >
> > > > Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> > > > ---
> > > >  drivers/infiniband/hw/irdma/hw.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
> > > > index 7afb8a6a0526..7f13a051d4de 100644
> > > > --- a/drivers/infiniband/hw/irdma/hw.c
> > > > +++ b/drivers/infiniband/hw/irdma/hw.c
> > > > @@ -537,7 +537,7 @@ static void irdma_destroy_irq(struct irdma_pci_f *rf,
> > > >       struct irdma_sc_dev *dev = &rf->sc_dev;
> > > >
> > > >       dev->irq_ops->irdma_dis_irq(dev, msix_vec->idx);
> > > > -     irq_set_affinity_hint(msix_vec->irq, NULL);
> > > > +     irq_update_affinity_hint(msix_vec->irq, NULL);
> > > >       free_irq(msix_vec->irq, dev_id);
> > > >  }
> > > >
> > > > @@ -1087,7 +1087,7 @@ irdma_cfg_ceq_vector(struct irdma_pci_f *rf, struct irdma_ceq *iwceq,
> > > >       }
> > > >       cpumask_clear(&msix_vec->mask);
> > > >       cpumask_set_cpu(msix_vec->cpu_affinity, &msix_vec->mask);
> > > > -     irq_set_affinity_hint(msix_vec->irq, &msix_vec->mask);
> > > > +     irq_set_affinity_and_hint(msix_vec->irq, &msix_vec->mask);
> > >
> > > I think that it needs to be irq_update_affinity_hint().
> > >
> >
> > Ah! I got a little confused from our last conversation about mlx5.
> >
> > IIUC mlx5 sub-function use case uses irdma (?) and that's why I thought
> > that perhaps we would also want to define the affinity here from the beginning.
>
> mlx5 is connected to mlx5_ib/mlx5_vdpa e.t.c.
>
> Not sure about that, but I think that only mlx5 implements SIOV model.
>
> >
> > In any case, I will make the change and re-post.
> >

Just FYI, I am hoping to collect more comments in the non-reviewed
patches and address them in v4.
Hence, I will wait for this week if I don't get anything I will just
post another version by making the change in this driver.

-- 
Thanks
Nitesh

