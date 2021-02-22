Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2E2321126
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 08:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhBVHIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 02:08:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229549AbhBVHIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 02:08:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613977644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7yxjabaG87TNMDB9yX/+cMFRonyop4lSGm45nCTp52s=;
        b=MIsN3t8odV8Z0NXwCpkB7MEuj9LGHnYB9b4b9h9ecHH72nYoyRm4eamf3+4J5TV6c/wcuo
        LD8Zt0SS/d+J5oEYpZ2e++BAB5ZYbkkXcuNH8hV7kGyGHTvoxMxPgaLheFOps2XenoMaHa
        qrNJlQga5nKLw/EMyKAKTMB7n72bHjM=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-sEJ6fO_7NPqcXFOENURRGQ-1; Mon, 22 Feb 2021 02:07:22 -0500
X-MC-Unique: sEJ6fO_7NPqcXFOENURRGQ-1
Received: by mail-pf1-f200.google.com with SMTP id f17so6666698pfj.3
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 23:07:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7yxjabaG87TNMDB9yX/+cMFRonyop4lSGm45nCTp52s=;
        b=aUd8cck3ABSGttV7+rweVIZBeiGfmv33STW8V9wBD4eeNDcU7jFuUkbFIOHqJd4rO5
         0FEnGvDZxbFqZg7SZaWLV2lLiICGPaikoR0wohinOPlIvgVjTWMYgj/Mvbz0ralD0hK7
         KgOsJ/kZE9sfcKkS8sdz+ouqEC3+z6yScyzt2V/5/Ao2ZL6EgMzzBuKUaoVQsJmoGY5z
         pEghMRf6R0Cx7BW23pZ/6haKqZlKqLf5/otTxpA3mdKDzrk+BpvVQh/uVg/fknhMsQ3v
         ynA1vK5JcQ2tyGZttoO5pnKvKpjl18PQbqsDyMmu5AGGSADSj+3evbKx4t+Pd/PdGO1f
         wY/g==
X-Gm-Message-State: AOAM531q0O/6UwJjZFSlLRy4NicOkHa4f4GnnquNmV/f/z2A4ogxIpah
        Bx4LzRwyaUByHZ0Ug/3Hjx/8Psd5wOdgAReSa0y68ZoPhFrDJrxzyIDzOCguk8gZlIoz6kN4UpS
        hHDLCpeBv3+z1lvXyyJeQLYPXRh++zEMLZethY3SWdx3n4hp+bm65EC1+tYUHc38=
X-Received: by 2002:a62:1502:0:b029:1ed:81bf:fcce with SMTP id 2-20020a6215020000b02901ed81bffccemr7209890pfv.54.1613977641310;
        Sun, 21 Feb 2021 23:07:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwL+3nsB87Uq5QRjqDtP9xx1F7ZqFj5EAjQrWSQ/oP3ylnWKPkszqnxqJPuuR+lw6cmsphiRA==
X-Received: by 2002:a62:1502:0:b029:1ed:81bf:fcce with SMTP id 2-20020a6215020000b02901ed81bffccemr7209837pfv.54.1613977640821;
        Sun, 21 Feb 2021 23:07:20 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m18sm7131814pfd.206.2021.02.21.23.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 23:07:20 -0800 (PST)
From:   Coiby Xu <coxu@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kexec@lists.infradead.org, intel-wired-lan@lists.osuosl.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools))
Subject: [RFC PATCH 0/4] Reducing memory usage of i40e for kdump
Date:   Mon, 22 Feb 2021 15:06:57 +0800
Message-Id: <20210222070701.16416-1-coxu@redhat.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, i40e consumes lots of memory and causes the failure of kdump.

After reducing the allocation of tx/rx/arg/asq ring buffers to the
minimum, the memory consumption is significantly reduced,
    - x86_64: 85.1MB to 1.2MB 
    - POWER9: 15368.5MB to 20.8MB

i40iw consumes even much more memory. For the above x86_64 machine, it
alone consumes 1513.7MB. So disable registering an i40e client driver
for a kdump kernel.

After applying this patch set, we can still achieve 100MB+/s network
speed which I think is limited by the net link (1000Mb/s) and this is 
sufficient for kdump.

memstrack report for the x86_64 machine
=======================================

After applying this patch set,

    ======== Report format module_summary: ========
    Module i40e using 20.8MB (332 pages), peak allocation 20.9MB (335 pages)
    Module i2c_core using 19.4MB (310 pages), peak allocation 22.8MB (365 pages)
    ======== Report format module_summary END ========
    
    ======== Report format module_top: ========
    Top stack usage of module i40e:
      (null) Pages: 332 (peak: 335)
        system_call_common (0xc00000000000d260) Pages: 267 (peak: 268)
          system_call_exception (0xc000000000034334) Pages: 267 (peak: 268)
            __sys_sendmsg (0xc000000000fd727c) Pages: 267 (peak: 268)
              ___sys_sendmsg (0xc000000000fd22ec) Pages: 267 (peak: 268)
                sock_sendmsg (0xc000000000fd0a90) Pages: 267 (peak: 268)
                  netlink_sendmsg (0xc0000000010dbd4c) Pages: 267 (peak: 268)
                    netlink_unicast (0xc0000000010db948) Pages: 267 (peak: 268)
                      rtnetlink_rcv (0xc000000001033058) Pages: 267 (peak: 268)
                        netlink_rcv_skb (0xc0000000010dc534) Pages: 267 (peak: 268)
                          rtnetlink_rcv_msg (0xc0000000010340fc) Pages: 267 (peak: 268)
                            rtnl_newlink (0xc000000001038290) Pages: 267 (peak: 268)
                              __rtnl_newlink (0xc000000001037d64) Pages: 267 (peak: 268)
                                do_setlink (0xc00000000103626c) Pages: 267 (peak: 268)
                                  dev_change_flags (0xc00000000101e2fc) Pages: 267 (peak: 268)
                                    __dev_change_flags (0xc00000000101e1fc) Pages: 267 (peak: 268)
                                      __dev_open (0xc00000000101dda8) Pages: 267 (peak: 268)
                                        i40e_open i40e (0xc00800000851a238) Pages: 267 (peak: 268)
                                          i40e_vsi_open i40e (0xc008000008519f54) Pages: 252 (peak: 252)
                                            i40e_vsi_configure i40e (0xc0080000085093ac) Pages: 252 (peak: 252)
                                              i40e_configure_rx_ring i40e (0xc0080000085055b0) Pages: 252 (peak: 252)
                                                i40e_alloc_rx_buffers i40e (0xc008000008540d1c) Pages: 252 (peak: 252)
                                                  __alloc_pages_nodemask (0xc0000000004d74e0) Pages: 252 (peak: 252)
                                                    (null) Pages: 252 (peak: 252)
                                                      __traceiter_mm_page_alloc (0xc00000000047c754) Pages: 504 (peak: 504)
    

Before applying this patch set,

    ======== Report format module_summary: ========
    Module i40iw using 1513.7MB (387507 pages), peak allocation 1513.7MB (387507 pages)
    Module i40e using 85.8MB (21977 pages), peak allocation 87.0MB (22276 pages)
    Module xfs using 1.2MB (299 pages), peak allocation 1.2MB (300 pages)
    Module rdma_ucm using 0.8MB (210 pages), peak allocation 0.8MB (211 pages)
    Module ib_uverbs using 0.5MB (131 pages), peak allocation 3.8MB (971 pages)
    Module ib_iser using 0.4MB (109 pages), peak allocation 0.4MB (109 pages)
    Module target_core_mod using 0.4MB (109 pages), peak allocation 0.4MB (111 pages)
    Module rdma_cm using 0.2MB (46 pages), peak allocation 0.2MB (46 pages)
    Module e1000e using 0.2MB (46 pages), peak allocation 0.2MB (46 pages)
    Module ib_core using 0.2MB (45 pages), peak allocation 0.2MB (45 pages)
    Module iw_cm using 0.2MB (44 pages), peak allocation 0.2MB (44 pages)
    Module scsi_transport_iscsi using 0.1MB (20 pages), peak allocation 0.1MB (20 pages)
    Module ib_isert using 0.1MB (19 pages), peak allocation 0.1MB (19 pages)
    Module iscsi_target_mod using 0.1MB (17 pages), peak allocation 0.1MB (17 pages)
    Module libiscsi using 0.1MB (15 pages), peak allocation 0.1MB (15 pages)
    Module ib_cm using 0.1MB (14 pages), peak allocation 0.1MB (14 pages)
    Module ib_srpt using 0.0MB (9 pages), peak allocation 0.0MB (9 pages)
    Module rpcrdma using 0.0MB (0 pages), peak allocation 0.0MB (0 pages)
    ======== Report format module_summary END ========
    
    ======== Report format module_top: ========
    Top stack usage of module i40iw:
      (null) Pages: 387507 (peak: 387507)
        ret_from_fork (0xffffffffb5000255) Pages: 387507 (peak: 387507)
          kthread (0xffffffffb4700696) Pages: 387507 (peak: 387507)
            worker_thread (0xffffffffb46facf0) Pages: 387507 (peak: 387507)
              process_one_work (0xffffffffb46fa627) Pages: 387507 (peak: 387507)
                i40e_service_task i40e (0xffffffffc1146183) Pages: 387507 (peak: 387507)
                  i40e_client_subtask i40e (0xffffffffc1163a34) Pages: 387507 (peak: 387507)
                    i40iw_open.part.14 i40iw (0xffffffffc11b0ea9) Pages: 344064 (peak: 344064)
                      i40iw_sc_create_hmc_obj i40iw (0xffffffffc11ae4c9) Pages: 344064 (peak: 344064)
                        i40iw_add_sd_table_entry i40iw (0xffffffffc11ae079) Pages: 344064 (peak: 344064)
                          i40iw_allocate_dma_mem i40iw (0xffffffffc11b7517) Pages: 344064 (peak: 344064)
                            dma_direct_alloc_pages (0xffffffffb4762035) Pages: 344064 (peak: 344064)
                              __dma_direct_alloc_pages (0xffffffffb4761f04) Pages: 344064 (peak: 344064)
                                __alloc_pages_nodemask (0xffffffffb48b7367) Pages: 344064 (peak: 344064)
                                  __alloc_pages_nodemask (0xffffffffb48b7367) Pages: 688128 (peak: 688128)
                    i40iw_open.part.14 i40iw (0xffffffffc11b1278) Pages: 25883 (peak: 25883)
                      i40iw_puda_create_rsrc i40iw (0xffffffffc11b47da) Pages: 24576 (peak: 24576)
                        i40iw_allocate_dma_mem i40iw (0xffffffffc11b7517) Pages: 24576 (peak: 24576)
                          dma_direct_alloc_pages (0xffffffffb4762035) Pages: 24576 (peak: 24576)
                            __dma_direct_alloc_pages (0xffffffffb4761f04) Pages: 24576 (peak: 24576)
                              __alloc_pages_nodemask (0xffffffffb48b7367) Pages: 24576 (peak: 24576)
                                __alloc_pages_nodemask (0xffffffffb48b7367) Pages: 49152 (peak: 49152)
                      i40iw_puda_create_rsrc i40iw (0xffffffffc11b485a) Pages: 731 (peak: 731)
                        i40iw_allocate_virt_mem i40iw (0xffffffffc11b758d) Pages: 731 (peak: 731)
    



memstrack report for the POWER9 machine
=======================================

After applying this patch set,

    ======== Report format module_summary: ========
    Module i40e using 1.2MB (316 pages), peak allocation 1.4MB (369 pages)
    ======== Report format module_summary END ========
    
    ======== Report format module_top: ========
    Top stack usage of module i40e:
      (null) Pages: 316 (peak: 369)
        i40e_init_interrupt_scheme i40e (0xffffffffc03f85f8) Pages: 79 (peak: 79)
          __pci_enable_msix_range.part.0 (0xffffffff966b9878) Pages: 69 (peak: 69)
            __msi_domain_alloc_irqs (0xffffffff9614c31b) Pages: 69 (peak: 69)
              __irq_domain_alloc_irqs (0xffffffff96149fb5) Pages: 35 (peak: 35)
                irq_domain_alloc_descs.part.0 (0xffffffff961489e5) Pages: 35 (peak: 35)
                  __irq_alloc_descs (0xffffffff96bc0583) Pages: 22 (peak: 22)
                    kobject_add (0xffffffff9666292e) Pages: 22 (peak: 22)
                      kobject_add_internal (0xffffffff966622e2) Pages: 22 (peak: 22)
                        internal_create_groups.part.0 (0xffffffff963d962d) Pages: 22 (peak: 22)
                          internal_create_group (0xffffffff963d8f56) Pages: 22 (peak: 22)
                            sysfs_add_file_mode_ns (0xffffffff963d837e) Pages: 22 (peak: 22)
                              __kernfs_create_file (0xffffffff963d7865) Pages: 22 (peak: 22)
                                kernfs_new_node (0xffffffff963d5ad3) Pages: 22 (peak: 22)
                                  __kernfs_new_node (0xffffffff963d4e4e) Pages: 18 (peak: 18)
                                    kmem_cache_alloc (0xffffffff962e8b04) Pages: 18 (peak: 18)
                                      __slab_alloc (0xffffffff962e891c) Pages: 18 (peak: 18)
                                        ___slab_alloc (0xffffffff962e875c) Pages: 18 (peak: 18)
                                          allocate_slab (0xffffffff962e6223) Pages: 18 (peak: 18)
                                            __alloc_pages_nodemask (0xffffffff962c07f5) Pages: 18 (peak: 18)
                                              __alloc_pages_nodemask (0xffffffff962c07f5) Pages: 36 (peak: 36)
    ======== Report format module_top END ========


Before applying this patch set,


    ======== Report format module_summary: ========
    Module i40e using 15368.5MB (245896 pages), peak allocation 15368.6MB (245897 pages)
    Module bpf using 5.8MB (92 pages), peak allocation 7.4MB (118 pages)
    Module xfs using 0.8MB (12 pages), peak allocation 0.8MB (12 pages)
    ======== Report format module_summary END ========
    
    ======== Report format module_top: ========
    Top stack usage of module i40e:
      (null) Pages: 245896 (peak: 245897)
        system_call_common (0xc00000000000d260) Pages: 243801 (peak: 243801)
          system_call_exception (0xc000000000034254) Pages: 243801 (peak: 243801)
            __sys_sendmsg (0xc000000000fd221c) Pages: 243801 (peak: 243801)
              ___sys_sendmsg (0xc000000000fcd28c) Pages: 243801 (peak: 243801)
                sock_sendmsg (0xc000000000fcba30) Pages: 243801 (peak: 243801)
                  netlink_sendmsg (0xc0000000010d69ac) Pages: 243801 (peak: 243801)
                    netlink_unicast (0xc0000000010d65a8) Pages: 243801 (peak: 243801)
                      rtnetlink_rcv (0xc00000000102de78) Pages: 243801 (peak: 243801)
                        netlink_rcv_skb (0xc0000000010d7194) Pages: 243801 (peak: 243801)
                          rtnetlink_rcv_msg (0xc00000000102ef1c) Pages: 243801 (peak: 243801)
                            rtnl_newlink (0xc0000000010330b0) Pages: 243801 (peak: 243801)
                              __rtnl_newlink (0xc000000001032b84) Pages: 243801 (peak: 243801)
                                do_setlink (0xc00000000103108c) Pages: 243801 (peak: 243801)
                                  dev_change_flags (0xc00000000101917c) Pages: 243801 (peak: 243801)
                                    __dev_change_flags (0xc00000000101907c) Pages: 243801 (peak: 243801)
                                      __dev_open (0xc000000001018c28) Pages: 243801 (peak: 243801)
                                        i40e_open i40e (0xc0080000083be3c8) Pages: 243801 (peak: 243801)
                                          i40e_vsi_open i40e (0xc0080000083be074) Pages: 242655 (peak: 242655)
                                            i40e_vsi_configure i40e (0xc0080000083a8efc) Pages: 242647 (peak: 242647)
                                              i40e_configure_rx_ring i40e (0xc0080000083a6a60) Pages: 242583 (peak: 242583)
                                                i40e_alloc_rx_buffers i40e (0xc0080000083e9280) Pages: 242583 (peak: 242583)
                                                  __alloc_pages_nodemask (0xc0000000004d66c0) Pages: 242583 (peak: 242583)
                                                    (null) Pages: 242583 (peak: 242583)
                                                      __traceiter_mm_page_alloc (0xc00000000047bab4) Pages: 485166 (peak: 485166)
                                              i40e_configure_rx_ring i40e (0xc0080000083a6850) Pages: 64 (peak: 64)
                                                i40e_alloc_rx_bi i40e (0xc0080000083e8cec) Pages: 64 (peak: 64)
                                                  __kmalloc (0xc00000000051cc54) Pages: 64 (peak: 64)
                                                    ___slab_alloc (0xc00000000051c4a0) Pages: 64 (peak: 64)
                                                      allocate_slab (0xc000000000517f94) Pages: 64 (peak: 64)
                                                        alloc_pages_current (0xc0000000005054f0) Pages: 64 (peak: 64)
                                                          __alloc_pages_nodemask (0xc0000000004d66c0) Pages: 64 (peak: 64)
                                                            (null) Pages: 64 (peak: 64)
                                                              __traceiter_mm_page_alloc (0xc00000000047bab4) Pages: 128 (peak: 128)
                                            i40e_vsi_configure i40e (0xc0080000083a8e4c) Pages: 8 (peak: 8)
                                              i40e_configure_tx_ring i40e (0xc0080000083a8b10) Pages: 8 (peak: 8)
                                                netif_set_xps_queue (0xc00000000100d5b4) Pages: 8 (peak: 8)
                                                  __netif_set_xps_queue (0xc00000000100c77c) Pages: 6 (peak: 6)
                                                    __kmalloc (0xc00000000051cc54) Pages: 6 (peak: 6)
                                                      ___slab_alloc (0xc00000000051c4a0) Pages: 6 (peak: 6)
                                                        allocate_slab (0xc000000000517f94) Pages: 6 (peak: 6)
                                                          alloc_pages_current (0xc0000000005054f0) Pages: 6 (peak: 6)
                                                            __alloc_pages_nodemask (0xc0000000004d66c0) Pages: 6 (peak: 6)
                                                              (null) Pages: 6 (peak: 6)
                                                                __traceiter_mm_page_alloc (0xc00000000047bab4) Pages: 12 (peak: 12)
    ...
    ======== Report format module_top END ========

Coiby Xu (4):
  i40e: use minimal tx and rx pairs for kdump
  i40e: use minimal rx and tx ring buffers for kdump
  i40e: use minimal admin queue for kdump
  i40e: don't start i40iw client for kdump

 drivers/net/ethernet/intel/i40e/i40e.h        |  2 ++
 drivers/net/ethernet/intel/i40e/i40e_client.c |  7 ++++++
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 23 +++++++++++++++++--
 3 files changed, 30 insertions(+), 2 deletions(-)

-- 
2.30.0

