Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B893EDCEA
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 20:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhHPSMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 14:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhHPSMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 14:12:30 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50899C061764;
        Mon, 16 Aug 2021 11:11:58 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id a15so5587798iot.2;
        Mon, 16 Aug 2021 11:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OgXtNKQVWNS/t9DnTxT4k+sKuavXVHdSyozmTrDmIzs=;
        b=VQMcJfqDIF28JPMngb0oQ/7fJS4RV/h/jGqHDfDcji1nnRVIW5va2razqqgzHvBHOS
         TGfaCQjdn1vsY7Aam4D1pRST+6Ff/b4jXbQdLkSUS/jeJp2FMDX4bx1t2rZgASQVXNPn
         WOJw/pN70skdHEW9+0y1qly5biPDnQ+jn9qcKqMzwA6DZEksN2oYTuSgCkTJlXiMqKBz
         Et09bRVTahG0zDEiaW3HwGOd6dqWseR7SEYxBZQ4cNJ2DaOZuDpgFczJoNGB3XsmyVO1
         YQZzJ7c0yfYdDp8kx9lkckpUCjm21/JIkZG4vjROEk/KkAooM4GdibKsTu5Il6ecpfmq
         277w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OgXtNKQVWNS/t9DnTxT4k+sKuavXVHdSyozmTrDmIzs=;
        b=dBmopis+IxKL3SfqvUk3TepQgG2G+tsn/g5hw4Y2elP/wPmhe2iWLMNXAGYtv+qCA3
         n8LuFk6wTwCNFIlNQhpU4DEsblNDre1awaeeKwoz0d7peXIYZi4AGeDBmW8nkG+lXMjm
         q8my3wGuUSG90o1p44hFPPKXecHZfP8a3M2mVDrwoXVR8ADPEEfQ5O/IPYSiONRiHFUK
         Qzi3hZuisZjb8lw2cCSdnsGPobJpoT2sKzk7JDC7MOyh0uYs5pmXF1raY/jq4uGVx1R7
         HQ3JDPbeF+ZIGwex5HIKNtOndK/ivmqqPtD7AXSpTESzSWex/b5MRJGipVLUPXF7qeBL
         nMQA==
X-Gm-Message-State: AOAM530KUO7xM7Nf3dy+6ibNmmvJjJc3fyUkW+mJAexzGku/k7VJhjFC
        /adnouicA0Uqtv95R2mrBVw5PdgCg2yPBnDQk3Y=
X-Google-Smtp-Source: ABdhPJxe4xcrw0U4Dd1whvty55tfoYVW3p2Pw16+UKKJO6nXVsQXetYWVAQeXSpRs8A+FqzmkFphq0Q/eIfOk9SMXqI=
X-Received: by 2002:a5d:9eda:: with SMTP id a26mr150414ioe.166.1629137517690;
 Mon, 16 Aug 2021 11:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210720232624.1493424-1-nitesh@redhat.com> <20210720232624.1493424-11-nitesh@redhat.com>
In-Reply-To: <20210720232624.1493424-11-nitesh@redhat.com>
From:   Jassi Brar <jassisinghbrar@gmail.com>
Date:   Mon, 16 Aug 2021 13:11:47 -0500
Message-ID: <CABb+yY3Wz57dYZ8pa5zHatGRu1RFmyRK+UvN+B8txCcOUTPQzw@mail.gmail.com>
Subject: Re: [PATCH v5 10/14] mailbox: Use irq_update_affinity_hint
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        linux-api@vger.kernel.org, linux-pci@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        jesse.brandeburg@intel.com, Robin Murphy <robin.murphy@arm.com>,
        mtosatti@redhat.com, mingo@kernel.org, jbrandeb@kernel.org,
        frederic@kernel.org, juri.lelli@redhat.com, abelits@marvell.com,
        Bjorn Helgaas <bhelgaas@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, peterz@infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, Marc Zyngier <maz@kernel.org>,
        nhorman@tuxdriver.com, pjwaskiewicz@gmail.com, sassmann@redhat.com,
        thenzl@redhat.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jkc@redhat.com, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com, ahleihel@redhat.com,
        kheib@redhat.com, borisp@nvidia.com, saeedm@nvidia.com,
        benve@cisco.com, govind@gmx.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        nilal@redhat.com, tatyana.e.nikolova@intel.com,
        mustafa.ismail@intel.com, ahs3@redhat.com, leonro@nvidia.com,
        chandrakanth.patil@broadcom.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Yongqiang Niu <yongqiang.niu@mediatek.com>,
        Baolin Wang <baolin.wang7@gmail.com>, poros@redhat.com,
        minlei@redhat.com, emilne@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, _govind@gmx.com, kabel@kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Tushar Khandelwal <Tushar.Khandelwal@arm.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 6:27 PM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
> The driver uses irq_set_affinity_hint() to:
>
> - Set the affinity_hint which is consumed by the userspace for
>   distributing the interrupts
>
> - Enforce affinity
>
> As per commit 6ac17fe8c14a ("mailbox: bcm-flexrm-mailbox: Set IRQ affinity
> hint for FlexRM ring IRQs") the latter is done to ensure that the FlexRM
> ring interrupts are evenly spread across all available CPUs. However, since
> commit a0c9259dc4e1 ("irq/matrix: Spread interrupts on allocation") the
> spreading of interrupts is dynamically performed at the time of allocation.
> Hence, there is no need for the drivers to enforce their own affinity for
> the spreading of interrupts.
>
> Also, irq_set_affinity_hint() applying the provided cpumask as an affinity
> for the interrupt is an undocumented side effect. To remove this side
> effect irq_set_affinity_hint() has been marked as deprecated and new
> interfaces have been introduced. Hence, replace the irq_set_affinity_hint()
> with the new interface irq_update_affinity_hint() that only sets the
> affinity_hint pointer.
>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  drivers/mailbox/bcm-flexrm-mailbox.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mailbox/bcm-flexrm-mailbox.c b/drivers/mailbox/bcm-flexrm-mailbox.c
> index 78073ad1f2f1..16982c13d323 100644
> --- a/drivers/mailbox/bcm-flexrm-mailbox.c
> +++ b/drivers/mailbox/bcm-flexrm-mailbox.c
> @@ -1298,7 +1298,7 @@ static int flexrm_startup(struct mbox_chan *chan)
>         val = (num_online_cpus() < val) ? val / num_online_cpus() : 1;
>         cpumask_set_cpu((ring->num / val) % num_online_cpus(),
>                         &ring->irq_aff_hint);
> -       ret = irq_set_affinity_hint(ring->irq, &ring->irq_aff_hint);
> +       ret = irq_update_affinity_hint(ring->irq, &ring->irq_aff_hint);
>         if (ret) {
>                 dev_err(ring->mbox->dev,
>                         "failed to set IRQ affinity hint for ring%d\n",
> @@ -1425,7 +1425,7 @@ static void flexrm_shutdown(struct mbox_chan *chan)
>
>         /* Release IRQ */
>         if (ring->irq_requested) {
> -               irq_set_affinity_hint(ring->irq, NULL);
> +               irq_update_affinity_hint(ring->irq, NULL);
>                 free_irq(ring->irq, ring);
>                 ring->irq_requested = false;
>         }
>
Seems ok to me. But I don't have the h/w to test.

Acked-by: Jassi Brar <jaswinder.singh@linaro.org>

cheers.
