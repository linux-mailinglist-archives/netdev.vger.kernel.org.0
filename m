Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE413FB91F
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 17:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbhH3Pjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 11:39:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237619AbhH3Pjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 11:39:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630337928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KdkFWUiTMvtMsWJ6cUiIqcTp0RGUHhxr67y9qLSh0yM=;
        b=b/JbEq5lZIQ9ZuAu0pIuz23OjFu91j4AMnWL2PgWugtGSFJKpytLtjGJBFpDbY9d9tz3s8
        erfjpvPWCmM7FCKcvsWFlzEAC57wFUShkyC1JNa9vDdVtLknS59sRTjZwwzxSqBSQ+jEa1
        2spIbojk/6qvLQYf587hG5fJPmcXbyQ=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-9mmdtpKYNaiKgjEAawUmxg-1; Mon, 30 Aug 2021 11:38:47 -0400
X-MC-Unique: 9mmdtpKYNaiKgjEAawUmxg-1
Received: by mail-lj1-f197.google.com with SMTP id s15-20020a2eb8cf000000b001cbf358ed4eso6804867ljp.14
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 08:38:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KdkFWUiTMvtMsWJ6cUiIqcTp0RGUHhxr67y9qLSh0yM=;
        b=l57twFCWCQcQQWTU5nKdALuXq61TK7ZqB6pwLrT8pVTCapf8cIeCVo3c9Fy4PxlVV/
         /2ZDMPAoH8T7kO62w7VRKkAoO6VhZ/3Rr1MBD5uc1cxJgW/Ivn1MbDQTis0qV3bAwwPK
         U6pjs0UH/XVQ76w52xCQix2jVNBluG6zzaQvQXyIXjq9+UN8orHK9N1PPXAAYuuHTc2L
         WOVOIqiLtcDhGABCdaJNe0Y2aVx1AScVh2NUPtb2wIuX94kVVdhYmuwTAWiF9A693F7j
         icqqqhUWx9zP54sxYyE3vjumf+hQXw59wFuxANalWKUq2dmErb2jaGBhBElkUaC4THhC
         JKZQ==
X-Gm-Message-State: AOAM5330yFMkKIcX06OBSEjnOBmy9gzg0O7f/kvUa5C4QTq/teaqesH9
        U6aIeMGYJ/vpHcmzbDaynuEhc08X6MIiu2btuTBriayo/WGf0iKD58Z+4ce9an9SOtlHSBHb5bB
        WkyRgWCax/LZUObZIU0K1nfG9+UiEEcQ9
X-Received: by 2002:a05:6512:21cf:: with SMTP id d15mr17903802lft.548.1630337925483;
        Mon, 30 Aug 2021 08:38:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9UCmwncJUGf9asGfLpNrRUo6X+riRIyjnBb/d3K1U2TWNrP/KHaZL8T3ppdBz1Ul2raBoQYGI5rUOmsEZhUQ=
X-Received: by 2002:a05:6512:21cf:: with SMTP id d15mr17903733lft.548.1630337925258;
 Mon, 30 Aug 2021 08:38:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210720232624.1493424-1-nitesh@redhat.com> <CAFki+LkNzk0ajUeuBnJZ6mp1kxB0+zZf60tw1Vfq+nPy-bvftQ@mail.gmail.com>
 <CAFki+LkyTNeorQ5e_6_Ud==X7dt27G38ZjhEewuhqGLfanjw_A@mail.gmail.com>
In-Reply-To: <CAFki+LkyTNeorQ5e_6_Ud==X7dt27G38ZjhEewuhqGLfanjw_A@mail.gmail.com>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Mon, 30 Aug 2021 11:38:34 -0400
Message-ID: <CAFki+Lmbw=02iaYKs_a0jR1KWLisXQa1B-s0hc-Ej-8F8ryWDQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/14] genirq: Cleanup the abuse of irq_set_affinity_hint()
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        huangguangbin2@huawei.com, huangdaode@huawei.com,
        luobin9@huawei.com
Cc:     linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, jbrandeb@kernel.org,
        Frederic Weisbecker <frederic@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Alex Belits <abelits@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>, rostedt@goodmis.org,
        Peter Zijlstra <peterz@infradead.org>,
        akpm@linuxfoundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, Marc Zyngier <maz@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, pjwaskiewicz@gmail.com,
        Stefan Assmann <sassmann@redhat.com>,
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
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        kabel@kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>, kashyap.desai@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        suganath-prabu.subramani@broadcom.com,
        Thomas Gleixner <tglx@linutronix.de>, ley.foon.tan@intel.com,
        jbrunet@baylibre.com, johannes@sipsolutions.net,
        snelson@pensando.io, lewis.hanly@microchip.com, benve@cisco.com,
        _govind@gmx.com, jassisinghbrar@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 11:50 AM Nitesh Lal <nilal@redhat.com> wrote:
>
> On Mon, Aug 2, 2021 at 11:26 AM Nitesh Lal <nilal@redhat.com> wrote:
> >
> > On Tue, Jul 20, 2021 at 7:26 PM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> > >
> > > The drivers currently rely on irq_set_affinity_hint() to either set the
> > > affinity_hint that is consumed by the userspace and/or to enforce a custom
> > > affinity.
> > >
>

[...]

>
> Any comments on the following patches:
>
>   enic: Use irq_update_affinity_hint
>   be2net: Use irq_update_affinity_hint
>   mailbox: Use irq_update_affinity_hint
>   hinic: Use irq_set_affinity_and_hint
>
> or any other patches?
> Any help in testing will also be very useful.
>

Gentle ping.
Any comments on the following patches:

  be2net: Use irq_update_affinity_hint
  hinic: Use irq_set_affinity_and_hint

or any other patches?

--
Thanks
Nitesh

