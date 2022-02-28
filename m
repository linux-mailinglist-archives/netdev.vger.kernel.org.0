Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1024C64B8
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 09:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbiB1ISe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 03:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbiB1ISc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 03:18:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 178D54133D
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 00:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646036271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kcQX81TKsBPgI6ZQdBTCH95O8eyfaOBAupOXuKZxV+I=;
        b=hwdP3CX+E8+PDqRJve48BmU6oSMRymqxdgZa5UUb/Bl2+JlWIlfKESUGzaUOfKa7wp+2/q
        SEyXfoVG1n37vgJzdlvcw9YBCi5w1Tl9OEVb3lZZGZhoECcH4g6H4oHRKGy1xCW7cVWcvw
        jnSGxPpqFlWYyB48nC1wYanvwbgQYvs=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-guCOhJ1EOYakV85Ls4PsnA-1; Mon, 28 Feb 2022 03:17:50 -0500
X-MC-Unique: guCOhJ1EOYakV85Ls4PsnA-1
Received: by mail-pl1-f200.google.com with SMTP id j1-20020a170903028100b0014b1f9e0068so4386331plr.8
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 00:17:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kcQX81TKsBPgI6ZQdBTCH95O8eyfaOBAupOXuKZxV+I=;
        b=SWDSXIkK3L5NYJ7ubkmSuekUwvQ4VO9Vf4jb0rwobJ50QWgR0n4SZnScFOBiu1GdnK
         MD32pvZ/CiHXLq1NIaYi6x87t5e5RfvXrScyAsl/iiwWb4rjfWI5olwgLVXpivRUhtkA
         cjC7dw5eTOIE6Bx5l+A7Vptj3pWxwDBfStbhn9wlxjT3oM385Z3tTKcCK0c4oYVVVGT/
         tgX1cfV6ayM+3Kk2WbpwuiyGuYxQkgPFWKdyl/07WG00DGeMLLSYzXKtWk9Gr94Y116K
         Dq8/I9w+QJJEUgZLaXEuU2tsPY5A9gTvRv7/VUUFaBlMZ6JhVwATnIPZTQfvrC8oMQeN
         LR7Q==
X-Gm-Message-State: AOAM532e+ZV2Q3QNc1yQ9vCx++RMyvix0zhnZexY78Q0eO/kF8jMHbiA
        Ytr0KcyzTGfRfm4z3OQjq5tsZAUYbzaVFAbE4AiL9YKIVxKwadiFqXaSEKi7+/hiRrRwcWsoesT
        vgXCUG7r/i5Op13tw
X-Received: by 2002:a17:90b:34e:b0:1bd:16db:980e with SMTP id fh14-20020a17090b034e00b001bd16db980emr9907429pjb.132.1646036269290;
        Mon, 28 Feb 2022 00:17:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJySJlNX76ptc/rztyRChRUymNl0t+JDOxQTq6TMo3C0MeY0mFWzNbxlCiWBmIMbFPUWWLxVIw==
X-Received: by 2002:a17:90b:34e:b0:1bd:16db:980e with SMTP id fh14-20020a17090b034e00b001bd16db980emr9907392pjb.132.1646036268999;
        Mon, 28 Feb 2022 00:17:48 -0800 (PST)
Received: from [10.72.13.215] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id nn10-20020a17090b38ca00b001bc3a60b324sm9451560pjb.46.2022.02.28.00.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 00:17:48 -0800 (PST)
Message-ID: <19843d2b-dfe9-5e2d-4d3d-ca55456947dc@redhat.com>
Date:   Mon, 28 Feb 2022 16:17:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v2 00/19] Control VQ support in vDPA
Content-Language: en-US
To:     Gautam Dawar <gautam.dawar@xilinx.com>
Cc:     gdawar@xilinx.com, martinh@xilinx.com, hanand@xilinx.com,
        tanujk@xilinx.com, eperezma@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/2/25 上午5:22, Gautam Dawar 写道:
> Hi All:
>
> This series tries to add the support for control virtqueue in vDPA.
>
> Control virtqueue is used by networking device for accepting various
> commands from the driver. It's a must to support multiqueue and other
> configurations.
>
> When used by vhost-vDPA bus driver for VM, the control virtqueue
> should be shadowed via userspace VMM (Qemu) instead of being assigned
> directly to Guest. This is because Qemu needs to know the device state
> in order to start and stop device correctly (e.g for Live Migration).
>
> This requies to isolate the memory mapping for control virtqueue
> presented by vhost-vDPA to prevent guest from accessing it directly.
>
> To achieve this, vDPA introduce two new abstractions:
>
> - address space: identified through address space id (ASID) and a set
>                   of memory mapping in maintained
> - virtqueue group: the minimal set of virtqueues that must share an
>                   address space
>
> Device needs to advertise the following attributes to vDPA:
>
> - the number of address spaces supported in the device
> - the number of virtqueue groups supported in the device
> - the mappings from a specific virtqueue to its virtqueue groups
>
> The mappings from virtqueue to virtqueue groups is fixed and defined
> by vDPA device driver. E.g:
>
> - For the device that has hardware ASID support, it can simply
>    advertise a per virtqueue virtqueue group.
> - For the device that does not have hardware ASID support, it can
>    simply advertise a single virtqueue group that contains all
>    virtqueues. Or if it wants a software emulated control virtqueue, it
>    can advertise two virtqueue groups, one is for cvq, another is for
>    the rest virtqueues.
>
> vDPA also allow to change the association between virtqueue group and
> address space. So in the case of control virtqueue, userspace
> VMM(Qemu) may use a dedicated address space for the control virtqueue
> group to isolate the memory mapping.
>
> The vhost/vhost-vDPA is also extend for the userspace to:
>
> - query the number of virtqueue groups and address spaces supported by
>    the device
> - query the virtqueue group for a specific virtqueue
> - assocaite a virtqueue group with an address space
> - send ASID based IOTLB commands
>
> This will help userspace VMM(Qemu) to detect whether the control vq
> could be supported and isolate memory mappings of control virtqueue
> from the others.
>
> To demonstrate the usage, vDPA simulator is extended to support
> setting MAC address via a emulated control virtqueue.
>
> Please review.
>
> Changes since v1:
>
> - Rebased the v1 patch series on vhost branch of MST vhost git repo
>    git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost
> - Updates to accommodate vdpa_sim changes from monolithic module in
>    kernel used v1 patch series to current modularized class (net, block)
>    based approach.
> - Added new attributes (ngroups and nas) to "vdpasim_dev_attr" and
>    propagated them from vdpa_sim_net to vdpa_sim
> - Widened the data-type for "asid" member of vhost_msg_v2 to __u32
>    to accommodate PASID


This is great. Then the semantic matches exactly the PASID proposal here[1].


> - Fixed the buildbot warnings
> - Resolved all checkpatch.pl errors and warnings
> - Tested both control and datapath with Xilinx Smartnic SN1000 series
>    device using QEMU implementing the Shadow virtqueue and support for
>    VQ groups and ASID available at:
>    github.com/eugpermar/qemu/releases/tag/vdpa_sw_live_migration.d%2F
>    asid_groups-v1.d%2F00


On top, we may extend the netlink protocol to report the mapping between 
virtqueue to its groups.


Thanks

[1] 
https://www.mail-archive.com/virtio-dev@lists.oasis-open.org/msg08077.html


>
> Changes since RFC:
>
> - tweak vhost uAPI documentation
> - switch to use device specific IOTLB really in patch 4
> - tweak the commit log
> - fix that ASID in vhost is claimed to be 32 actually but 16bit
>    actually
> - fix use after free when using ASID with IOTLB batching requests
> - switch to use Stefano's patch for having separated iov
> - remove unused "used_as" variable
> - fix the iotlb/asid checking in vhost_vdpa_unmap()
>
> Thanks
>
> Gautam Dawar (19):
>    vhost: move the backend feature bits to vhost_types.h
>    virtio-vdpa: don't set callback if virtio doesn't need it
>    vhost-vdpa: passing iotlb to IOMMU mapping helpers
>    vhost-vdpa: switch to use vhost-vdpa specific IOTLB
>    vdpa: introduce virtqueue groups
>    vdpa: multiple address spaces support
>    vdpa: introduce config operations for associating ASID to a virtqueue
>      group
>    vhost_iotlb: split out IOTLB initialization
>    vhost: support ASID in IOTLB API
>    vhost-vdpa: introduce asid based IOTLB
>    vhost-vdpa: introduce uAPI to get the number of virtqueue groups
>    vhost-vdpa: introduce uAPI to get the number of address spaces
>    vhost-vdpa: uAPI to get virtqueue group id
>    vhost-vdpa: introduce uAPI to set group ASID
>    vhost-vdpa: support ASID based IOTLB API
>    vdpa_sim: advertise VIRTIO_NET_F_MTU
>    vdpa_sim: factor out buffer completion logic
>    vdpa_sim: filter destination mac address
>    vdpasim: control virtqueue support
>
>   drivers/vdpa/ifcvf/ifcvf_main.c      |   8 +-
>   drivers/vdpa/mlx5/net/mlx5_vnet.c    |  11 +-
>   drivers/vdpa/vdpa.c                  |   5 +
>   drivers/vdpa/vdpa_sim/vdpa_sim.c     | 100 ++++++++--
>   drivers/vdpa/vdpa_sim/vdpa_sim.h     |   3 +
>   drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 169 +++++++++++++----
>   drivers/vhost/iotlb.c                |  23 ++-
>   drivers/vhost/vdpa.c                 | 272 +++++++++++++++++++++------
>   drivers/vhost/vhost.c                |  23 ++-
>   drivers/vhost/vhost.h                |   4 +-
>   drivers/virtio/virtio_vdpa.c         |   2 +-
>   include/linux/vdpa.h                 |  46 ++++-
>   include/linux/vhost_iotlb.h          |   2 +
>   include/uapi/linux/vhost.h           |  25 ++-
>   include/uapi/linux/vhost_types.h     |  11 +-
>   15 files changed, 566 insertions(+), 138 deletions(-)
>

