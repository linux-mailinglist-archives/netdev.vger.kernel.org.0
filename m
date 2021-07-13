Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BA33C713C
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 15:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbhGMNcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 09:32:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36702 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236591AbhGMNcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 09:32:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626182991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jdeapieNS3PVuhbaSMCjhCNHL9ow03NjgZ6/hSsB7Qg=;
        b=eVALn4XCl3v0oqQ/4JZZEzt8VcYt0JTODFs+kQHjgovfEcgFuB61tTnNE0ZmOaFGdTsCpO
        au2m6HRIhH8etKICURRj6WBCcr8XWZjB5Eo9wkMbagMuyfbtZePqoxjwDnceR+DwulC503
        +k1NJitUcgIFSrFzWuY6zVi3Il56s3k=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-Ckjl5th3Pnm5dKQCNhgYww-1; Tue, 13 Jul 2021 09:29:50 -0400
X-MC-Unique: Ckjl5th3Pnm5dKQCNhgYww-1
Received: by mail-ej1-f72.google.com with SMTP id t8-20020a1709063e48b0290501cd965554so5070812eji.8
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 06:29:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jdeapieNS3PVuhbaSMCjhCNHL9ow03NjgZ6/hSsB7Qg=;
        b=f+cxcBIlEgnmWLAiZE3sGTQLtD8yaJkW8l58MFzPhUyJvvZ41EjV8zetx+uR9nDxts
         rAwdSo4Ws0SJArsBYO9OQ/led0Hz5mxcx6rtF8c7+0gVsGtirMq5/SCFUIh9kIBsK/Jm
         HwgWYPEGb7Xck5kosiXVkLOyjZus4yy8Q98XmVUrkygE5mWaBIk7Gtb4h8P/QKrV7v0g
         eNbTMVSUm7DZ2+T4iyI9lP2fxe/gTxnFNNE8OMfMqaCXpdXsSy+XPY9dYNLIRnU3+Uts
         8pAI2P9tX8MKr/OfzixKOXfHKlxOpLlWSdNKEm4iC21B2nIM1jQlkrKi8fQQpEjUlRyZ
         DIfQ==
X-Gm-Message-State: AOAM531BQGl+4iQQyp0DaOqVhQZJ1S87eJd0/uzhI0mUasYuMdeWbhVF
        rq7r9IOvEQ8FHB1mXvsrnAUV6qJ/Y5Ic/9/v3PzlVkn3LR9GOnDB91vn+QGk3jes9HO3ma4enME
        ee+ceuhal/w3pwl1zcVWy8c3zwO0Ex7mP
X-Received: by 2002:aa7:dcd2:: with SMTP id w18mr5825657edu.145.1626182988594;
        Tue, 13 Jul 2021 06:29:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5wxQUQPgyLKUdlRZ2gZvYByjQxwh5vHfj9Zl/5/TUt6KM+BkoCgzKzFw3XseQAusiiqmnSZ0tdUwu4kYrB74=
X-Received: by 2002:aa7:dcd2:: with SMTP id w18mr5825614edu.145.1626182988415;
 Tue, 13 Jul 2021 06:29:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210629152746.2953364-1-nitesh@redhat.com> <CAFki+LnUGiEE-7Uf-x8-TQZYZ+3Migrr=81gGLYszxaK-6A9WQ@mail.gmail.com>
 <YOrWqPYPkZp6nRLS@unreal> <CAFki+L=FYOTQ1+-MHWmTuA6ZxTUcZA9t41HRL2URYgv03oFbDg@mail.gmail.com>
 <YO0eKv2GJcADQTHH@unreal>
In-Reply-To: <YO0eKv2GJcADQTHH@unreal>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Tue, 13 Jul 2021 09:29:37 -0400
Message-ID: <CAFki+L=LtHFvL5+h2JtWhKMDdR5=ABzOFnvdXCDcPfGisDb-9A@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] genirq: Cleanup the usage of irq_set_affinity_hint
To:     Leon Romanovsky <leon@kernel.org>
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

On Tue, Jul 13, 2021 at 1:01 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Jul 12, 2021 at 05:27:05PM -0400, Nitesh Lal wrote:
> > Hi Leon,
> >

<snip>

> > > >
> > > > Gentle ping.
> > > > Any comments or suggestions on any of the patches included in this series?
> > >
> > > Please wait for -rc1, rebase and resend.
> > > At least i40iw was deleted during merge window.
> > >
> >
> > In -rc1 some non-trivial mlx5 changes also went in.  I was going through
> > these changes and it seems after your patch
> >
> > e4e3f24b822f: ("net/mlx5: Provide cpumask at EQ creation phase")
> >
> > we do want to control the affinity for the mlx5 interrupts from the driver.
> > Is that correct?
>
> We would like to create devices with correct affinity from the
> beginning. For this, we will introduce extension to devlink to control
> affinity that will be used prior initialization sequence.
>
> Currently, netdev users who don't want irqbalance are digging into
> their procfs, reconfigure affinity on already existing devices and
> hope for the best.
>
> This is even more cumbersome for the SIOV use case, where every physical
> NIC PCI device will/can create thousands of lightweights netdevs that will
> be forwarded to the containers later. These containers are limited to known
> CPU cores, so no reason do not limit netdev device too.
>
> The same goes for other sub-functions of that PCI device, like RDMA,
> vdpa e.t.c.
>
> > This would mean that we should use irq_set_affinity_and_hint() instead
> > of irq_update_affinity_hint().
>
> I think so.
>

Thanks, will make that change in the patch and re-send.
I will also drop your reviewed-by for the mlx5 patch so that you can
have a look at it again, please let me know if you have any
objections.

-- 
Thanks
Nitesh

