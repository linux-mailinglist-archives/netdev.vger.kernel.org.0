Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBFC6546CD
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 20:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbiLVToj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 14:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiLVToi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 14:44:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA1413FAD
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 11:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671738232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Jqg4l9ppU4/LoATwhQrDYp/3VHTevvJa8cFjxg3vEVw=;
        b=FpUxj0mP4u0jZM1D1rxiX4cch0ZrRjvjS1Sm8/2DL5RQrIypkCjH5dLJjFB6ULy1cHPML+
        Y3AmiskEGMMF8DM4mZqpKAPGaInc/niJx7npz2k6fahzmdKkHcqgO+3wAk+ggVKPosPw3U
        luHBTU7Sz4HrUnOpTypa5qc+EWw8yg8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-632-s9nGsnvXP3SQbhx56Am1sQ-1; Thu, 22 Dec 2022 14:43:51 -0500
X-MC-Unique: s9nGsnvXP3SQbhx56Am1sQ-1
Received: by mail-ej1-f71.google.com with SMTP id qk40-20020a1709077fa800b007eeb94ecdb5so2050493ejc.12
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 11:43:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jqg4l9ppU4/LoATwhQrDYp/3VHTevvJa8cFjxg3vEVw=;
        b=5bYt2FNDh4GS3twDaxyzE7rSbuwnqv2krsIoOWadcIZHWlHcNGpWjsTUJnb53oX0O/
         K7PBch8be0ZPWdakKvcYsU8Aar6FgGObVzRB2PaPEG1NRs6tHLvUq0KLH9P0miAJwTvy
         W4ZkFd5Mula6QQE2GuuBIPCMZh6AGu4nrb246zGvz1Wcc9lWvPh9VansC4AWIUPfevyU
         LNnV3wyzcHQ3+RlExTab+xPBJ0UV5Q9g2pTa5hEK8dDuO8YnKB4wYXPn8FcZoGdt5fRV
         NP8V+iB3GPosgWx8/t7f03NnAabE2M8eoV9dGwP/SqGRYab4hTDmj0OfT31WxE4HdaNY
         F8yw==
X-Gm-Message-State: AFqh2kovvjqyp97qhlxvrmJyUnHgB2Rr+pC7tzrTzHeokbMBSZirt8Fy
        Z8Y9m1NwbDR3P0vTrft6Al1whMHxxNrp7HAYwV9w4FZ/QdpQZlnPfqVRE5X7F/2jLw66pBJqDla
        OnELv+sY72cLWnvd7
X-Received: by 2002:a17:907:6d0c:b0:7c1:652:d109 with SMTP id sa12-20020a1709076d0c00b007c10652d109mr6520510ejc.35.1671738230445;
        Thu, 22 Dec 2022 11:43:50 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvLlDzf2yxva+GWIB8SmxNohbeD3HjmEQmM7Dh7TSaob2mNG9+TQ7FtyP3KjZNNoenU+30zOA==
X-Received: by 2002:a17:907:6d0c:b0:7c1:652:d109 with SMTP id sa12-20020a1709076d0c00b007c10652d109mr6520497ejc.35.1671738230166;
        Thu, 22 Dec 2022 11:43:50 -0800 (PST)
Received: from redhat.com ([2.55.175.215])
        by smtp.gmail.com with ESMTPSA id v1-20020a170906292100b0073c10031dc9sm566202ejd.80.2022.12.22.11.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 11:43:49 -0800 (PST)
Date:   Thu, 22 Dec 2022 14:43:43 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        almasrymina@google.com, alvaro.karsz@solid-run.com,
        anders.roxell@linaro.org, angus.chen@jaguarmicro.com,
        bobby.eshleman@bytedance.com, colin.i.king@gmail.com,
        dave@stgolabs.net, dengshaomin@cdjrlc.com, dmitry.fomichev@wdc.com,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        harshit.m.mogalapalli@oracle.com, jasowang@redhat.com,
        leiyang@redhat.com, lingshan.zhu@intel.com, lkft@linaro.org,
        lulu@redhat.com, mst@redhat.com, m.szyprowski@samsung.com,
        nathan@kernel.org, pabeni@redhat.com, pizhenwei@bytedance.com,
        rafaelmendsr@gmail.com, ricardo.canuelo@collabora.com,
        ruanjinjie@huawei.com, sammler@google.com, set_pte_at@outlook.com,
        sfr@canb.auug.org.au, sgarzare@redhat.com, shaoqin.huang@intel.com,
        si-wei.liu@oracle.com, stable@vger.kernel.org, stefanha@gmail.com,
        sunnanyong@huawei.com, wangjianli@cdjrlc.com,
        wangrong68@huawei.com, weiyongjun1@huawei.com,
        xuanzhuo@linux.alibaba.com, yuancan@huawei.com
Subject: [GIT PULL] virtio,vhost,vdpa: features, fixes, cleanups
Message-ID: <20221222144343-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 830b3c68c1fb1e9176028d02ef86f3cf76aa2476:

  Linux 6.1 (2022-12-11 14:15:18 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 98dd6b2ef50d6f7876606a86c8d8a767c9fef6f5:

  virtio_blk: mark all zone fields LE (2022-12-22 14:32:36 -0500)


Note: merging this upstream results in a conflict
between commit:

  de4eda9de2d9 ("use less confusing names for iov_iter direction initializers")

from Linus' tree and commit:

  ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")

from this tree.

This resolution below fixes it up, due to Stephen Rothwell

diff --cc drivers/vhost/vsock.c
index cd6f7776013a,830bc823addc..000000000000
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@@ -165,8 -157,9 +157,9 @@@ vhost_transport_do_send_pkt(struct vhos
  			break;
  		}
  
 -		iov_iter_init(&iov_iter, READ, &vq->iov[out], in, iov_len);
 +		iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[out], in, iov_len);
- 		payload_len = pkt->len - pkt->off;
+ 		payload_len = skb->len;
+ 		hdr = virtio_vsock_hdr(skb);
  
  		/* If the packet is greater than the space available in the
  		 * buffer, we split it using multiple buffers.
@@@ -366,18 -340,21 +340,22 @@@ vhost_vsock_alloc_skb(struct vhost_virt
  		return NULL;
  	}
  
- 	pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
- 	if (!pkt)
+ 	len = iov_length(vq->iov, out);
+ 
+ 	/* len contains both payload and hdr */
+ 	skb = virtio_vsock_alloc_skb(len, GFP_KERNEL);
+ 	if (!skb)
  		return NULL;
  
 -	iov_iter_init(&iov_iter, WRITE, vq->iov, out, len);
 +	len = iov_length(vq->iov, out);
 +	iov_iter_init(&iov_iter, ITER_SOURCE, vq->iov, out, len);
  
- 	nbytes = copy_from_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
- 	if (nbytes != sizeof(pkt->hdr)) {
+ 	hdr = virtio_vsock_hdr(skb);
+ 	nbytes = copy_from_iter(hdr, sizeof(*hdr), &iov_iter);
+ 	if (nbytes != sizeof(*hdr)) {
  		vq_err(vq, "Expected %zu bytes for pkt->hdr, got %zu bytes\n",
- 		       sizeof(pkt->hdr), nbytes);
- 		kfree(pkt);
+ 		       sizeof(*hdr), nbytes);
+ 		kfree_skb(skb);
  		return NULL;
  	}
  

It can also be found in linux-next, see next-20221220.


----------------------------------------------------------------
virtio,vhost,vdpa: features, fixes, cleanups

zoned block device support
lifetime stats support (for virtio devices backed by memory supporting that)
vsock rework to use skbuffs
ifcvf features provisioning
new SolidNET DPU driver

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Alvaro Karsz (5):
      Add SolidRun vendor id
      New PCI quirk for SolidRun SNET DPU.
      virtio: vdpa: new SolidNET DPU driver.
      virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
      virtio: vdpa: fix snprintf size argument in snet_vdpa driver

Angus Chen (2):
      virtio_pci: modify ENOENT to EINVAL
      virtio_blk: use UINT_MAX instead of -1U

Bobby Eshleman (1):
      virtio/vsock: replace virtio_vsock_pkt with sk_buff

Cindy Lu (2):
      vhost_vdpa: fix the crash in unmap a large memory
      vdpa_sim_net: should not drop the multicast/broadcast packet

Colin Ian King (1):
      RDMA/mlx5: remove variable i

Davidlohr Bueso (2):
      tools/virtio: remove stray characters
      tools/virtio: remove smp_read_barrier_depends()

Dawei Li (1):
      virtio: Implementing attribute show with sysfs_emit

Dmitry Fomichev (2):
      virtio-blk: use a helper to handle request queuing errors
      virtio-blk: add support for zoned block devices

Eli Cohen (8):
      vdpa/mlx5: Fix rule forwarding VLAN to TIR
      vdpa/mlx5: Return error on vlan ctrl commands if not supported
      vdpa/mlx5: Fix wrong mac address deletion
      vdpa/mlx5: Avoid using reslock in event_handler
      vdpa/mlx5: Avoid overwriting CVQ iotlb
      vdpa/mlx5: Move some definitions to a new header file
      vdpa/mlx5: Add debugfs subtree
      vdpa/mlx5: Add RX counters to debugfs

Eugenio Pérez (1):
      vdpa_sim_net: Offer VIRTIO_NET_F_STATUS

Harshit Mogalapalli (1):
      vduse: Validate vq_num in vduse_validate_config()

Jason Wang (2):
      vdpa: conditionally fill max max queue pair for stats
      vdpasim: fix memory leak when freeing IOTLBs

Michael S. Tsirkin (3):
      virtio_blk: temporary variable type tweak
      virtio_blk: zone append in header type tweak
      virtio_blk: mark all zone fields LE

Michael Sammler (1):
      virtio_pmem: populate numa information

Rafael Mendonca (1):
      virtio_blk: Fix signedness bug in virtblk_prep_rq()

Ricardo Cañuelo (2):
      tools/virtio: initialize spinlocks in vring_test.c
      docs: driver-api: virtio: virtio on Linux

Rong Wang (1):
      vdpa/vp_vdpa: fix kfree a wrong pointer in vp_vdpa_remove

Shaomin Deng (1):
      tools: Delete the unneeded semicolon after curly braces

Shaoqin Huang (2):
      virtio_pci: use helper function is_power_of_2()
      virtio_ring: use helper function is_power_of_2()

Si-Wei Liu (1):
      vdpa: merge functionally duplicated dev_features attributes

Stefano Garzarella (4):
      vringh: fix range used in iotlb_translate()
      vhost: fix range used in translate_desc()
      vhost-vdpa: fix an iotlb memory leak
      vdpa_sim: fix vringh initialization in vdpasim_queue_ready()

Wei Yongjun (1):
      virtio-crypto: fix memory leak in virtio_crypto_alg_skcipher_close_session()

Yuan Can (1):
      vhost/vsock: Fix error handling in vhost_vsock_init()

Zhu Lingshan (12):
      vDPA/ifcvf: decouple hw features manipulators from the adapter
      vDPA/ifcvf: decouple config space ops from the adapter
      vDPA/ifcvf: alloc the mgmt_dev before the adapter
      vDPA/ifcvf: decouple vq IRQ releasers from the adapter
      vDPA/ifcvf: decouple config IRQ releaser from the adapter
      vDPA/ifcvf: decouple vq irq requester from the adapter
      vDPA/ifcvf: decouple config/dev IRQ requester and vectors allocator from the adapter
      vDPA/ifcvf: ifcvf_request_irq works on ifcvf_hw
      vDPA/ifcvf: manage ifcvf_hw in the mgmt_dev
      vDPA/ifcvf: allocate the adapter in dev_add()
      vDPA/ifcvf: retire ifcvf_private_to_vf
      vDPA/ifcvf: implement features provisioning

ruanjinjie (1):
      vdpa_sim: fix possible memory leak in vdpasim_net_init() and vdpasim_blk_init()

wangjianli (1):
      tools/virtio: Variable type completion

 Documentation/driver-api/index.rst                 |    1 +
 Documentation/driver-api/virtio/index.rst          |   11 +
 Documentation/driver-api/virtio/virtio.rst         |  144 +++
 .../driver-api/virtio/writing_virtio_drivers.rst   |  197 ++++
 MAINTAINERS                                        |    6 +
 drivers/block/virtio_blk.c                         |  522 ++++++++-
 .../crypto/virtio/virtio_crypto_skcipher_algs.c    |    3 +-
 drivers/nvdimm/virtio_pmem.c                       |   11 +-
 drivers/pci/quirks.c                               |    8 +
 drivers/vdpa/Kconfig                               |   22 +
 drivers/vdpa/Makefile                              |    1 +
 drivers/vdpa/ifcvf/ifcvf_base.c                    |   32 +-
 drivers/vdpa/ifcvf/ifcvf_base.h                    |   10 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    |  162 ++-
 drivers/vdpa/mlx5/Makefile                         |    2 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |    5 +-
 drivers/vdpa/mlx5/core/mr.c                        |   46 +-
 drivers/vdpa/mlx5/net/debug.c                      |  152 +++
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  252 +++--
 drivers/vdpa/mlx5/net/mlx5_vnet.h                  |   94 ++
 drivers/vdpa/solidrun/Makefile                     |    6 +
 drivers/vdpa/solidrun/snet_hwmon.c                 |  188 ++++
 drivers/vdpa/solidrun/snet_main.c                  | 1111 ++++++++++++++++++++
 drivers/vdpa/solidrun/snet_vdpa.h                  |  196 ++++
 drivers/vdpa/vdpa.c                                |   11 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |    7 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               |    4 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c               |    8 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |    3 +
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |    2 +-
 drivers/vhost/vdpa.c                               |   52 +-
 drivers/vhost/vhost.c                              |    4 +-
 drivers/vhost/vringh.c                             |    5 +-
 drivers/vhost/vsock.c                              |  224 ++--
 drivers/virtio/virtio.c                            |   12 +-
 drivers/virtio/virtio_pci_modern.c                 |    4 +-
 drivers/virtio/virtio_ring.c                       |    2 +-
 include/linux/pci_ids.h                            |    2 +
 include/linux/virtio_config.h                      |    8 +-
 include/linux/virtio_vsock.h                       |  126 ++-
 include/uapi/linux/vdpa.h                          |    4 +-
 include/uapi/linux/virtio_blk.h                    |  133 +++
 include/uapi/linux/virtio_blk_ioctl.h              |   44 +
 net/vmw_vsock/virtio_transport.c                   |  149 +--
 net/vmw_vsock/virtio_transport_common.c            |  420 ++++----
 net/vmw_vsock/vsock_loopback.c                     |   51 +-
 tools/virtio/ringtest/main.h                       |   37 +-
 tools/virtio/virtio-trace/trace-agent-ctl.c        |    2 +-
 tools/virtio/virtio_test.c                         |    2 +-
 tools/virtio/vringh_test.c                         |    2 +
 50 files changed, 3661 insertions(+), 839 deletions(-)
 create mode 100644 Documentation/driver-api/virtio/index.rst
 create mode 100644 Documentation/driver-api/virtio/virtio.rst
 create mode 100644 Documentation/driver-api/virtio/writing_virtio_drivers.rst
 create mode 100644 drivers/vdpa/mlx5/net/debug.c
 create mode 100644 drivers/vdpa/mlx5/net/mlx5_vnet.h
 create mode 100644 drivers/vdpa/solidrun/Makefile
 create mode 100644 drivers/vdpa/solidrun/snet_hwmon.c
 create mode 100644 drivers/vdpa/solidrun/snet_main.c
 create mode 100644 drivers/vdpa/solidrun/snet_vdpa.h
 create mode 100644 include/uapi/linux/virtio_blk_ioctl.h

