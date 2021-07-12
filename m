Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6764E3C6572
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 23:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhGLVaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 17:30:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234105AbhGLVaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 17:30:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626125240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=50O7XoIosnaTFvNclTBE2xrsoJwPx7yETNcoEdpke38=;
        b=F9a2vVjJoBp/q7ULwV97nPFogI780NA5wiy4Zsx2/4wfi97ES/UVypkx4FD9fVrdgCKdwX
        W9zFLW2qGLPQQmUPgdlJcFFkBh7tW4+QBIG3spohSPp3Lvvv9KwU3IkK/jZNChFcNA3SvT
        HXlSat2NOnIwOX54vDBtXH97Tpu4AKk=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-Uyof2MLKOz6lnmL15hgWRA-1; Mon, 12 Jul 2021 17:27:19 -0400
X-MC-Unique: Uyof2MLKOz6lnmL15hgWRA-1
Received: by mail-lj1-f198.google.com with SMTP id c20-20020a2ea7940000b029013767626146so7769711ljf.15
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 14:27:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=50O7XoIosnaTFvNclTBE2xrsoJwPx7yETNcoEdpke38=;
        b=lCrR1jBnPN+vP6+UINZxtDQlv+t+AX1iLRx0lPwHb3cEIZi4SEhLkpmy8QTiWyuv2S
         AoDrspLBR0hKUbKGzUfWFaRIKqVYokhA2j+vxG85RfC9uT/XxEcVKpSoLWnEqPUAJjLi
         yk1g1FcpIMHHcN1Ci9YZrSdIEpiaHTnwiweD54pbgHjxRpgSsKso+7iDicDHol4FpCnF
         OzG2OI0OYqH1tMKqtb7I0N75ZqAszAEriYIk0Ua/fySk8d2zKq4T03dFCs9MKfuYkZjk
         G1Vm7G4WTehyYGS7YWGA2dsKbfkuN/EMT1rpPB7humaUv51AXgg8eYrRXkKzUlQadHYb
         MpwQ==
X-Gm-Message-State: AOAM533/yRmM8ODDMbcTvm3fTMtMhRt1jVK5LN8z1MVtwnB1+yOc/5FG
        fZvUSmRX7pcH5bgseOTz3Owv09QEnmaF1xyITXQk4mRkzbKwjm8O1eBGFjN67E7iArASm4lvBXi
        h7avJ4vXOW9Xph1JNtqzkM78XADFgui+9
X-Received: by 2002:a05:6512:33d3:: with SMTP id d19mr632519lfg.114.1626125237473;
        Mon, 12 Jul 2021 14:27:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMir1sZ9GqMa7WvPLCmNlPEblioxslUn0DyeGBQ95oerEYIFyQhf9KJgWR3Td5whCmT13/5lNHXg0IXQuMJlU=
X-Received: by 2002:a05:6512:33d3:: with SMTP id d19mr632454lfg.114.1626125237173;
 Mon, 12 Jul 2021 14:27:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210629152746.2953364-1-nitesh@redhat.com> <CAFki+LnUGiEE-7Uf-x8-TQZYZ+3Migrr=81gGLYszxaK-6A9WQ@mail.gmail.com>
 <YOrWqPYPkZp6nRLS@unreal>
In-Reply-To: <YOrWqPYPkZp6nRLS@unreal>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Mon, 12 Jul 2021 17:27:05 -0400
Message-ID: <CAFki+L=FYOTQ1+-MHWmTuA6ZxTUcZA9t41HRL2URYgv03oFbDg@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] genirq: Cleanup the usage of irq_set_affinity_hint
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
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

Hi Leon,

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

In -rc1 some non-trivial mlx5 changes also went in.  I was going through
these changes and it seems after your patch

e4e3f24b822f: ("net/mlx5: Provide cpumask at EQ creation phase")

we do want to control the affinity for the mlx5 interrupts from the driver.
Is that correct? This would mean that we should use
irq_set_affinity_and_hint() instead
of irq_update_affinity_hint().

-- 
Thanks
Nitesh

