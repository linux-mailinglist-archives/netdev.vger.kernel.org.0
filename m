Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E529B3DDC62
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbhHBP1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:27:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229710AbhHBP1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 11:27:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627918013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZDhUhOE7wVvhlT6fRTts0o1L7ni+IAaP4sO+YA1/LPs=;
        b=JkMVuMMwf8wW3Szfi2Eq3lOa7og66x5Tgtp9ar0NOGPTRyN2ELz6Mtcj0C6clz6E8Tfm7B
        IGg0TtgeMiWc8+1+QBu6Ou2AMnhlEmdN/zHu8Z52SxQzgbx02tbBt8VYwNAIiYYs9rARt3
        /ccuYWUSXjFp6i1Xx17+ch9Gx4TlKA4=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-W9jMWuX7NxuXS31-Er7WWA-1; Mon, 02 Aug 2021 11:26:52 -0400
X-MC-Unique: W9jMWuX7NxuXS31-Er7WWA-1
Received: by mail-lj1-f200.google.com with SMTP id u16-20020a2e84500000b029019c1f8941d1so3295086ljh.9
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 08:26:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZDhUhOE7wVvhlT6fRTts0o1L7ni+IAaP4sO+YA1/LPs=;
        b=oKCvbRJZbZsTJeuE0TJG5QipWLHjrBx20Z7m4wwZzl3GhkFOklwWJxq3QXdLJrSNOY
         mFdByAZZIDoAw4bVa4hLLJfkOFGUUXA5tLfDzdJr/J6CRfIxK3q2Owjt7mg+S24kY8jJ
         TeDptcZKETDiXi4el4Fr8S+kOfCsqOrXm01NeMzPikAKqsm99PAGXbB3Pkf27frY2a+q
         iGYIFjSmi5LP/7vkqzgHF4AHKWH+i1/xMs7UxdR5Wdawmxp+KRj2NkRoxjhDQDFKBHjG
         sZhvZNmZ1a5bJBUpt7d0YERQeKAPp102V4uhHEZ1kzzXZQiG+Y+LfvWjP5JOWH8AVzQr
         77fg==
X-Gm-Message-State: AOAM531n9C1H8NM7oO0kS2LCHWcY9MWpteC15blLMFbL+UYA7hll3IH5
        4oXBaw7+c2F3AX7Puf3gOaLYiUIAvYS8jlc8jX7QMh7rrhisZpsdz5urs1+iIsv0vK/18bK4hZO
        RnCWDGqw8P8qYUcMXxqXQ1Neabwo84Y93
X-Received: by 2002:a05:6512:2189:: with SMTP id b9mr7974384lft.159.1627918010523;
        Mon, 02 Aug 2021 08:26:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxJTM6knPaot69WHjAFEXmr/LkoWJIS6PDNnEfEDimuXafoRs+es8u51ckxQOEF4QZT1655o4pRGDQ381sdSI=
X-Received: by 2002:a05:6512:2189:: with SMTP id b9mr7974367lft.159.1627918010313;
 Mon, 02 Aug 2021 08:26:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210720232624.1493424-1-nitesh@redhat.com>
In-Reply-To: <20210720232624.1493424-1-nitesh@redhat.com>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Mon, 2 Aug 2021 11:26:39 -0400
Message-ID: <CAFki+LkNzk0ajUeuBnJZ6mp1kxB0+zZf60tw1Vfq+nPy-bvftQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/14] genirq: Cleanup the abuse of irq_set_affinity_hint()
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, jassisinghbrar@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Tushar.Khandelwal@arm.com, manivannan.sadhasivam@linaro.org,
        lewis.hanly@microchip.com, ley.foon.tan@intel.com,
        kabel@kernel.org, huangguangbin2@huawei.com, davem@davemloft.net,
        benve@cisco.com, govind@gmx.com, kashyap.desai@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        suganath-prabu.subramani@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, Marc Zyngier <maz@kernel.org>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, jbrandeb@kernel.org,
        Frederic Weisbecker <frederic@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Alex Belits <abelits@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        akpm@linuxfoundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, Neil Horman <nhorman@tuxdriver.com>,
        pjwaskiewicz@gmail.com, Stefan Assmann <sassmann@redhat.com>,
        Tomas Henzl <thenzl@redhat.com>, james.smart@broadcom.com,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Ken Cox <jkc@redhat.com>, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com,
        Alaa Hleihel <ahleihel@redhat.com>,
        Kamal Heib <kheib@redhat.com>, borisp@nvidia.com,
        saeedm@nvidia.com, Nitesh Lal <nilal@redhat.com>,
        "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        Al Stone <ahs3@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        bjorn.andersson@linaro.org, chunkuang.hu@kernel.org,
        yongqiang.niu@mediatek.com, baolin.wang7@gmail.com,
        Petr Oros <poros@redhat.com>, Ming Lei <minlei@redhat.com>,
        Ewan Milne <emilne@redhat.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 7:26 PM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
> The drivers currently rely on irq_set_affinity_hint() to either set the
> affinity_hint that is consumed by the userspace and/or to enforce a custom
> affinity.
>
> irq_set_affinity_hint() as the name suggests is originally introduced to
> only set the affinity_hint to help the userspace in guiding the interrupts
> and not the affinity itself. However, since the commit
>
>         e2e64a932556 "genirq: Set initial affinity in irq_set_affinity_hint()"
>

[...]

>  drivers/infiniband/hw/irdma/hw.c              |  4 +-
>  drivers/mailbox/bcm-flexrm-mailbox.c          |  4 +-
>  drivers/net/ethernet/cisco/enic/enic_main.c   |  8 +--
>  drivers/net/ethernet/emulex/benet/be_main.c   |  4 +-
>  drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  4 +-
>  drivers/net/ethernet/intel/i40e/i40e_main.c   |  8 +--
>  drivers/net/ethernet/intel/iavf/iavf_main.c   |  8 +--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 10 ++--
>  drivers/net/ethernet/mellanox/mlx4/eq.c       |  8 ++-
>  .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  8 +--
>  drivers/scsi/lpfc/lpfc_init.c                 |  4 +-
>  drivers/scsi/megaraid/megaraid_sas_base.c     | 27 +++++-----
>  drivers/scsi/mpt3sas/mpt3sas_base.c           | 21 ++++----
>  include/linux/interrupt.h                     | 53 ++++++++++++++++++-
>  kernel/irq/manage.c                           |  8 +--
>  15 files changed, 114 insertions(+), 65 deletions(-)
>
> --
>
>

Gentle ping.
Any comments on the following patches:

  genirq: Provide new interfaces for affinity hints
  scsi: megaraid_sas: Use irq_set_affinity_and_hint
  scsi: mpt3sas: Use irq_set_affinity_and_hint
  enic: Use irq_update_affinity_hint
  be2net: Use irq_update_affinity_hint
  mailbox: Use irq_update_affinity_hint
  hinic: Use irq_set_affinity_and_hint

or any other patches?

-- 
Thanks
Nitesh

