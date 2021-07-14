Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375593C84E2
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 14:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239423AbhGNM7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 08:59:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239395AbhGNM7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 08:59:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626267418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=raZzmrSm7aAF93XtBd5NdebdkvP4rzoUtxpQ14Vvgi8=;
        b=CD5zRaSFGVvVRoremA440kzwv4RXCUcwwJuCe09MSmZQ18dytJVZjakoDnGd9f72erUBe3
        vlt6y4SfB+sIYWRZTWRklIKSsvZefeOwk4CO+XrZtBvmFzBIpUJF9e0Q4RMx/8tAtTSk5g
        qHh4ZEGD4WpCYHJbagyfkUq/6vNlPPw=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-zgd1ivFiPpmWJwJrmffQGA-1; Wed, 14 Jul 2021 08:56:54 -0400
X-MC-Unique: zgd1ivFiPpmWJwJrmffQGA-1
Received: by mail-lj1-f199.google.com with SMTP id k21-20020a05651c10b5b029017b0db01e8eso1076004ljn.22
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 05:56:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=raZzmrSm7aAF93XtBd5NdebdkvP4rzoUtxpQ14Vvgi8=;
        b=VSUkTTLxqg+kkt35XJumgS2PYqvGnZCNgKt1Kzg335QOpi31yMnmXdKq+JB85gPWk+
         m9k5Mi6INIpEz6Y9CiZoRyy3QBU1fFRmnLq86dgPaghWA/KWysTeukq0Qf0pi/noLOiy
         XlDzrIB3E0uQ/2REhrWny4sV7ry176EQFbrJfqs5LBawA3bMbMkiD6cUz5D0f5NmLkbw
         XyDY7aeAOG0N0MTpfwVH1V4ybvA1BXAAVW9ufBrRTGhTXpTN44/oY6Um6yta0D+/h0AW
         fxVb0mmDRoNmqW54plJ97xlcyCY1WWGCj4TtfePi7Vx7B+uGBSs/ZFY4tjRu3EVfamnA
         JmFQ==
X-Gm-Message-State: AOAM532HkJyEQb2rjvo+THn54aN5s6tGh/Zd4B6AdVzUgQAopdkSkWTP
        N6g9Vc/YgrUX23xwQNFwAIFSU35wbCpGEzDjTjx/FaK76Vsh8+uECPQnSDLOO0ZGRxVQo6HWeU/
        CL8lfhaXZE3tDmktm9mAY3EmzRXspqOg9
X-Received: by 2002:a19:7d05:: with SMTP id y5mr7890011lfc.159.1626267412682;
        Wed, 14 Jul 2021 05:56:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8jmr/n3HvyYiI0el6kooSvghZovJs9ESz6mJmR0hmZCuQ98JAONelY4P6o0p0ninDERR/o2eRUttWE5gB5mc=
X-Received: by 2002:a19:7d05:: with SMTP id y5mr7889951lfc.159.1626267412400;
 Wed, 14 Jul 2021 05:56:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210713211502.464259-1-nitesh@redhat.com> <20210713211502.464259-7-nitesh@redhat.com>
 <YO7SiFE1dE0dFhkE@unreal>
In-Reply-To: <YO7SiFE1dE0dFhkE@unreal>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Wed, 14 Jul 2021 08:56:41 -0400
Message-ID: <CAFki+Lm-CpKZai1fV5aMJzEb-x+003m8wLQShSrYpyNh3XC50Q@mail.gmail.com>
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
        dick.kennedy@broadcom.com, Ken Cox <jkc@redhat.com>,
        faisal.latif@intel.com, shiraz.saleem@intel.com, tariqt@nvidia.com,
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

On Wed, Jul 14, 2021 at 8:03 AM Leon Romanovsky <leonro@nvidia.com> wrote:
>
> On Tue, Jul 13, 2021 at 05:14:54PM -0400, Nitesh Narayan Lal wrote:
> > The driver uses irq_set_affinity_hint() to update the affinity_hint mask
> > that is consumed by the userspace to distribute the interrupts and to apply
> > the provided mask as the affinity for its interrupts. However,
> > irq_set_affinity_hint() applying the provided cpumask as an affinity for
> > the interrupt is an undocumented side effect.
> >
> > To remove this side effect irq_set_affinity_hint() has been marked
> > as deprecated and new interfaces have been introduced. Hence, replace the
> > irq_set_affinity_hint() with the new interface irq_set_affinity_and_hint()
> > where the provided mask needs to be applied as the affinity and
> > affinity_hint pointer needs to be set and replace with
> > irq_update_affinity_hint() where only affinity_hint needs to be updated.
> >
> > Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> > ---
> >  drivers/infiniband/hw/irdma/hw.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
> > index 7afb8a6a0526..7f13a051d4de 100644
> > --- a/drivers/infiniband/hw/irdma/hw.c
> > +++ b/drivers/infiniband/hw/irdma/hw.c
> > @@ -537,7 +537,7 @@ static void irdma_destroy_irq(struct irdma_pci_f *rf,
> >       struct irdma_sc_dev *dev = &rf->sc_dev;
> >
> >       dev->irq_ops->irdma_dis_irq(dev, msix_vec->idx);
> > -     irq_set_affinity_hint(msix_vec->irq, NULL);
> > +     irq_update_affinity_hint(msix_vec->irq, NULL);
> >       free_irq(msix_vec->irq, dev_id);
> >  }
> >
> > @@ -1087,7 +1087,7 @@ irdma_cfg_ceq_vector(struct irdma_pci_f *rf, struct irdma_ceq *iwceq,
> >       }
> >       cpumask_clear(&msix_vec->mask);
> >       cpumask_set_cpu(msix_vec->cpu_affinity, &msix_vec->mask);
> > -     irq_set_affinity_hint(msix_vec->irq, &msix_vec->mask);
> > +     irq_set_affinity_and_hint(msix_vec->irq, &msix_vec->mask);
>
> I think that it needs to be irq_update_affinity_hint().
>

Ah! I got a little confused from our last conversation about mlx5.

IIUC mlx5 sub-function use case uses irdma (?) and that's why I thought
that perhaps we would also want to define the affinity here from the beginning.

In any case, I will make the change and re-post.

--
Thanks
Nitesh

