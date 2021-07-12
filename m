Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600323C5E15
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 16:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhGLOQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 10:16:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234254AbhGLOQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 10:16:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626099234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=afUNjuJXnPmwCmF5+FQfjA8ufj+e69/ivLf91qDfwSM=;
        b=TbZxTk65cPuUu0PsJHuvtTv9FKg9xurhx2dLBUbOpZD47o0581fIAEnJ9GPb6iC8Q9ZOdu
        RfID2cPFe5oL93LD/sgZfnBOLT9qLMh/h834LwBK4fs57YlWQL2p9c/O9D4MUHJNT8Kxxm
        A81L7MlVXl7duWPBUqGc9qPEgnGmxBc=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-cbBVv9ScOiak6sXVJ4HYJA-1; Mon, 12 Jul 2021 10:13:53 -0400
X-MC-Unique: cbBVv9ScOiak6sXVJ4HYJA-1
Received: by mail-lf1-f71.google.com with SMTP id i13-20020a196d0d0000b029034f05dc854aso6479446lfc.1
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 07:13:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=afUNjuJXnPmwCmF5+FQfjA8ufj+e69/ivLf91qDfwSM=;
        b=I+9hqkJqqTH/wSJfqfitpTzWw6NWFA0/cPryUHkNlrvOIkfTwAnxj+YLzQJqdTu8Ki
         NHWSHtdxkHGPVXvDXSL99Tb689/AqM54tytjOCm85fM07gXM2f/O+z9Icceg/+wple9p
         SDpjL4de6JWwLB9TJrOtDs+5Ud5Qkjhx+jtHJ9fNFN6gxNK5lb8OQCNMus2+dFEoplA7
         DjzbeT3gabMCcsAYkxXKjzZdowXei4EWVjoo88wQRP0ldfuZbGdTy1D/0/pJl8WZU4Os
         NDitu6d4wTGMZtsff8NkUBaSSxxkdimOfSZSO0EYvt4YJjUj8xuiSDfswQoVPBkli7m7
         NTqg==
X-Gm-Message-State: AOAM530SOvAjQnXehZrhs5YFLiv2mQEFYD+eOAC9vSw/uy6qiJUGg71T
        Otomps4ShZHTRIbZ0Y5zLQovfMHLjnxZ0cwrgeb0EsxUspU6nKZb102GWlSk8QfpmBg3gJslH6M
        DnvKdXCcBVWTFfTgMCKUoAmhxk5MenIJy
X-Received: by 2002:a05:6512:33d3:: with SMTP id d19mr16315930lfg.114.1626099231941;
        Mon, 12 Jul 2021 07:13:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbVotmura6ZuXfGUNMWJgcOo2t2QFX2iHzhetzzTWpDB1SmKe/MGcsinyZmILKUBXZAM4S3H2xTgXGvDKvNv8=
X-Received: by 2002:a05:6512:33d3:: with SMTP id d19mr16315896lfg.114.1626099231489;
 Mon, 12 Jul 2021 07:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210629152746.2953364-1-nitesh@redhat.com> <CAFki+LnUGiEE-7Uf-x8-TQZYZ+3Migrr=81gGLYszxaK-6A9WQ@mail.gmail.com>
 <YOrWqPYPkZp6nRLS@unreal>
In-Reply-To: <YOrWqPYPkZp6nRLS@unreal>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Mon, 12 Jul 2021 10:13:40 -0400
Message-ID: <CAFki+LnZnq2T9WjDn76wKR9=kk6Zf93zrWbGrnnhgRUiehQ-RA@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] genirq: Cleanup the usage of irq_set_affinity_hint
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, linux-api@vger.kernel.org,
        linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
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
        Al Stone <ahs3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 11, 2021 at 7:32 AM Leon Romanovsky <leonro@nvidia.com> wrote:
>
> On Thu, Jul 08, 2021 at 03:24:20PM -0400, Nitesh Lal wrote:
> > On Tue, Jun 29, 2021 at 11:28 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
> <...>
>
> > >
> > >  drivers/infiniband/hw/i40iw/i40iw_main.c      |  4 +-
> > >  drivers/mailbox/bcm-flexrm-mailbox.c          |  4 +-
> > >  drivers/net/ethernet/cisco/enic/enic_main.c   |  8 +--
> > >  drivers/net/ethernet/emulex/benet/be_main.c   |  4 +-
> > >  drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  4 +-
> > >  drivers/net/ethernet/intel/i40e/i40e_main.c   |  8 +--
> > >  drivers/net/ethernet/intel/iavf/iavf_main.c   |  8 +--
> > >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 10 ++--
> > >  drivers/net/ethernet/mellanox/mlx4/eq.c       |  8 ++-
> > >  .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  6 +--
> > >  drivers/scsi/lpfc/lpfc_init.c                 |  4 +-
> > >  drivers/scsi/megaraid/megaraid_sas_base.c     | 27 +++++-----
> > >  drivers/scsi/mpt3sas/mpt3sas_base.c           | 21 ++++----
> > >  include/linux/interrupt.h                     | 53 ++++++++++++++++++-
> > >  kernel/irq/manage.c                           |  8 +--
> > >  15 files changed, 113 insertions(+), 64 deletions(-)
> > >
> > > --
> > >
> > >
> >
> > Gentle ping.
> > Any comments or suggestions on any of the patches included in this series?
>
> Please wait for -rc1, rebase and resend.
> At least i40iw was deleted during merge window.
>

Right, will rebase on top of 5.14-rc1 and resend.

-- 
Thanks
Nitesh

