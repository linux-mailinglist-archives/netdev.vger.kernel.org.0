Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1592A30102D
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbhAVWkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:40:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60902 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729824AbhAVTpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 14:45:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611344656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3uNDwmhw+dypTTbDZcFNMsEkHC7AyteHqMNOLnBYuX8=;
        b=BexdxCgNjEkWUvtEhMElTGVg8x/eNQrofQ9PD9UwyGxEmwLYXFD8sniF5Wd87+sNjoaghY
        Fu81kzz+aIyljrVsrNLcqwBSlz3B6GDPqbE/fw2qeT2kdBPnjA4wXJzGN9SH+GPnXUd2DC
        pR4iO/c8tjefJk4twvkCIYKcsOBhKAM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-6Moqto5vNm-wdKRKKGs8Bw-1; Fri, 22 Jan 2021 14:44:12 -0500
X-MC-Unique: 6Moqto5vNm-wdKRKKGs8Bw-1
Received: by mail-qv1-f70.google.com with SMTP id x19so4616324qvv.16
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 11:44:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3uNDwmhw+dypTTbDZcFNMsEkHC7AyteHqMNOLnBYuX8=;
        b=DXdRDFhZHlNnZSJtPSrVKUjq0OTNQwGHN4qVhhbhM0rED8PpJ3qELtffRWAl8vi2Kh
         ATuqVJ0nHjgNlRhHNBI4ok+NIyno3anVp4uL3T2go2pRmpM0Yibn7zm3eJK2uzo9C7/5
         n60OEyr3hHK6FAQvJ2poxnY7+m0EcKEOfrHVLy2rixliLtjLX+vGWpGrWgNY9R8x+xXO
         GOgAkNtrGVwrNk3Jxdx0VzM80CTvD1kA08M17PMQsmtvNyG60iJrtCESMMc78B+9qj6p
         56xXLd9TOz9XTbcfGhSvwx1QV6t4tloSgFx3v/pXyh0qwsKXwxhf7sfem+FQaYK1fgYn
         iM1g==
X-Gm-Message-State: AOAM532uN3gAFKCOjImmj0OM1XiHcJherSR25YnVLUA9Up5cXu19B4ib
        6NPWl/B358hRWi/4nz4pCelA5NwgEV6qYl1rFjUC9pRfpXJYr4Cle8GIPXePrESAn4JNKedUvBi
        L0eYbuNLaCAKaIo4rVGVd0jfnDfLWnVEv
X-Received: by 2002:a05:620a:12d5:: with SMTP id e21mr3438617qkl.131.1611344651589;
        Fri, 22 Jan 2021 11:44:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6cFebtmiIS8knjYgLudy4UeqwjmnsOMneaVMKnv2KT/lJTSR4ttPMGlPsJYpw37S7QqTD713vRrO6GSoAsz8=
X-Received: by 2002:a05:620a:12d5:: with SMTP id e21mr3438585qkl.131.1611344651277;
 Fri, 22 Jan 2021 11:44:11 -0800 (PST)
MIME-Version: 1.0
References: <20201216064818.48239-1-jasowang@redhat.com> <20201216064818.48239-22-jasowang@redhat.com>
 <20210111122601.GA172492@mtl-vdi-166.wap.labs.mlnx> <da50981b-6bbc-ee61-b5b1-a57a09da8e93@redhat.com>
In-Reply-To: <da50981b-6bbc-ee61-b5b1-a57a09da8e93@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 22 Jan 2021 20:43:34 +0100
Message-ID: <CAJaqyWcRirQgz+n63rU2nYVH2RKqjQfwHGFLzOG=H46qRWuTog@mail.gmail.com>
Subject: Re: [PATCH 21/21] vdpasim: control virtqueue support
To:     Jason Wang <jasowang@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>, Michael Tsirkin <mst@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cindy Lu <lulu@redhat.com>,
        Eli Cohen <eli@mellanox.com>, lingshan.zhu@intel.com,
        Rob Miller <rob.miller@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 4:12 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/11 =E4=B8=8B=E5=8D=888:26, Eli Cohen wrote:
> > On Wed, Dec 16, 2020 at 02:48:18PM +0800, Jason Wang wrote:
> >> This patch introduces the control virtqueue support for vDPA
> >> simulator. This is a requirement for supporting advanced features like
> >> multiqueue.
> >>
> >> A requirement for control virtqueue is to isolate its memory access
> >> from the rx/tx virtqueues. This is because when using vDPA device
> >> for VM, the control virqueue is not directly assigned to VM. Userspace
> >> (Qemu) will present a shadow control virtqueue to control for
> >> recording the device states.
> >>
> >> The isolation is done via the virtqueue groups and ASID support in
> >> vDPA through vhost-vdpa. The simulator is extended to have:
> >>
> >> 1) three virtqueues: RXVQ, TXVQ and CVQ (control virtqueue)
> >> 2) two virtqueue groups: group 0 contains RXVQ and TXVQ; group 1
> >>     contains CVQ
> >> 3) two address spaces and the simulator simply implements the address
> >>     spaces by mapping it 1:1 to IOTLB.
> >>
> >> For the VM use cases, userspace(Qemu) may set AS 0 to group 0 and AS 1
> >> to group 1. So we have:
> >>
> >> 1) The IOTLB for virtqueue group 0 contains the mappings of guest, so
> >>     RX and TX can be assigned to guest directly.
> >> 2) The IOTLB for virtqueue group 1 contains the mappings of CVQ which
> >>     is the buffers that allocated and managed by VMM only. So CVQ of
> >>     vhost-vdpa is visible to VMM only. And Guest can not access the CV=
Q
> >>     of vhost-vdpa.
> >>
> >> For the other use cases, since AS 0 is associated to all virtqueue
> >> groups by default. All virtqueues share the same mapping by default.
> >>
> >> To demonstrate the function, VIRITO_NET_F_CTRL_MACADDR is
> >> implemented in the simulator for the driver to set mac address.
> >>
> > Hi Jason,
> >
> > is there any version of qemu/libvirt available that I can see the
> > control virtqueue working in action?
>
>
> Not yet, the qemu part depends on the shadow virtqueue work of Eugenio.
> But it will work as:
>
> 1) qemu will use a separated address space for the control virtqueue
> (shadow) exposed through vhost-vDPA
> 2) the commands sent through control virtqueue by guest driver will
> intercept by qemu
> 3) Qemu will send those commands to the shadow control virtqueue
>
> Eugenio, any ETA for the new version of shadow virtqueue support in Qemu?
>

Hi Jason. Sorry for the late response.

For the notification part I have addressed all the issues of the RFC
[1], except the potential race conditions Stefan pointed, and tested
with vdpa devices. You can find at
https://github.com/eugpermar/qemu/tree/vdpa_sw_live_migration.d/notificatio=
ns.rfc
. Since the shadow path is activated only through QMP and does not
interfere with regular operation, I could post to the qemu list if you
prefer. The series will be smaller if merged in steps.

Adding the buffer forwarding on top should not take long.

[1] https://lkml.org/lkml/2020/9/23/1243

Thanks!

