Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422C839566F
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhEaHoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:44:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38175 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhEaHn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:43:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622446939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dNMKv4iHn4dAF4Hn2qRzZTAcsE05a7bckIbW9ZiGeiQ=;
        b=Vka7xTPFNOD+FVTbpbuhO4SO4hLuRqN0LmJ/EG6f7fKERHtsmaLPl/81/jxJiKMhCqRKzR
        QOZFhvrwv6aAll0eL1u3jefRfJMjzcrd5bJUGip4AejC0ayGyf0PQrIUsTBZGT4OF3Zksk
        iDGuhEDPQ5AbUArP1R0sT9ug9dZB9Ac=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-RDhJ7ddnNpSKbyiT2fifsA-1; Mon, 31 May 2021 03:42:17 -0400
X-MC-Unique: RDhJ7ddnNpSKbyiT2fifsA-1
Received: by mail-lj1-f197.google.com with SMTP id w8-20020a05651c1028b02900f6e4f47184so3131754ljm.5
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:42:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dNMKv4iHn4dAF4Hn2qRzZTAcsE05a7bckIbW9ZiGeiQ=;
        b=q0UfcCgCZlviZivB+ZD/+JoQ40cGxIhuaM4ZRWtKPZkx9DCi93UnuuVsxJR720Yn0e
         2nmDrBlFho7UzRTUsXBXWHqW0kWmhRT1pp+BUpb1kotXdbB7zayLAiBLfZEUd1CnIhfc
         AxKnXBtV9FDqi6HFQ5ToZ7hUUdRm7t9R5D+V+uqNtIFXLhWnhPrtiErPSORYsRXab0zo
         ztwYbghLhZ5QY7FurpgUzIyboL2BS92CEV40cnYFNgLsbnAUg95Rv7UMQ8aQAFnu7pyz
         FIhLjwc43mayLHw5Jjso44RVQ61dnt/V1lMOotPwRNoKrKuC8bmTaNWmWg9xTF/SN8/u
         sHSA==
X-Gm-Message-State: AOAM530qbI3pJgyaSbRKM3hpynGjOSDiDSqY13dq1MHr7ROJRtNwRLFn
        bBzjBQVCGVjhhUnHMxgtQ7xbarcFecvI8mUwV9Z3Ehk0+NQVbFXYvss4TMAXPSkkVK8x9QUQXa8
        ghkL2TTSfzx7zzs/jeNf917KbFE9X5BC6
X-Received: by 2002:a19:8083:: with SMTP id b125mr13619939lfd.204.1622446936152;
        Mon, 31 May 2021 00:42:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqt7RfwNZfOiBT8iIRimwijOG1srChZjyxPkE2aFME4McHTTQyrw5iz8m+1J5rRmzgIXj6U+3VgKv8WzsKJ1U=
X-Received: by 2002:a19:8083:: with SMTP id b125mr13619926lfd.204.1622446935902;
 Mon, 31 May 2021 00:42:15 -0700 (PDT)
MIME-Version: 1.0
References: <ksundara@redhat.com> <20210527103318.801175-1-ksundara@redhat.com>
 <BY5PR12MB43223DDB8011260DD65B9405DC239@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43223DDB8011260DD65B9405DC239@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Karthik Sundaravel <ksundara@redhat.com>
Date:   Mon, 31 May 2021 13:12:04 +0530
Message-ID: <CAPh+B4Jhpwzcv=hyufYRhNfH+=DqqJkMGaJVMWswVAk9iZ_gKw@mail.gmail.com>
Subject: Re: [PATCH 0/1] net-next: Port Mirroring support for SR-IOV
To:     Parav Pandit <parav@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "karthik.sundaravel@gmail.com" <karthik.sundaravel@gmail.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        Veda Barrenkala <vbarrenk@redhat.com>,
        Vijay Chundury <vchundur@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 6:36 PM Parav Pandit <parav@nvidia.com> wrote:
>
>
> > From: Karthik S <ksundara@redhat.com>
> > Sent: Thursday, May 27, 2021 4:03 PM
> >
> > The purpose of this message is to gather feedback from the Netdev
> > community on the addition of SRIOV port mirroring to the iproute2 ip CLI.
>
> > iproute2 was chosen as the desired interface because there is already
> > extensive support for SRIOV configuration built in and many Linux users are
> > familiar with it for configuring Network functionality in the driver thus port
> > mirroring naturally fits into this schema.
> >
> > Port mirroring involves sending a copy of packets entering and/or leaving one
> > port to another port which is usually different from the original destination
> > of the packets being mirrored.Hardware Port Mirroring can provide the
> > following benefits for users:
> > 1) Live debugging of network issues without bringing any interface or
> > connection down
> > 2) No latency addition when port mirroring tap is introduced
> > 3) No extra CPU resources are required to perform this function
> >
> > The prospective implementation would provide three modes of packet
> > mirroring (For Egress or Ingress):
> > 1) PF to VF
> > 2) VF to VF
> > 3) VLAN to VF
> >
> > The suggested iproute2 ip link interface for setting up Port Mirroring is as
> > follows:
>
> ip link vf set commands are for legacy sriov implementation to my knowledge.
> It is not usable for below 4 cases.
> 1. switchdev sriov devices
> 2. pci subfunctions switchdev devices
> 3. smartnic where VFs and eswitch are on different PCI device.
> 4. PCI PF on the smartnic managed via same switchdev cannot be mirrored.
>
> With the rich switchdev framework via PF,VF, SF representors, tc seems to be right approach to me.
>
> Such as,
> $ tc filter add dev vf1_rep_eth0 parent ffff: \
>         protocol ip u32 match ip protocol 1 0xff \
>         action mirred egress mirror dev vf2_rep_eth1
>
> Few advantages of tc I see are:
> 1. It overcomes limitations of all above #4 use cases
>
> 2. tc gives the ability to mirror specific traffic based on match criteria instead of proposed _all_vf_ traffic
> This is useful at high throughput VFs where filter itself helps to mirror specific packets.
> At the same time matchall criteria also works like the proposed API.
>
> I do not know the netdev direction for non switchdev (legacy) sriov nics.

1. While iproute and switchdev may be similar in their actions for
port mirroring, they both have unique use-cases for it, switchdev uses
it for flow replication and iproute uses it for port/device tracking.
2. Also some legacy devices do not support switchdev, and iproute
provides a means of a port mirroring solution that covers a wide range
of Network Interface Controllers out there today.

