Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6889E3DD52D
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 14:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhHBMHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 08:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbhHBMHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 08:07:40 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E66C0613D5
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 05:07:30 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so2262803pjr.1
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 05:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=6Ci3MJOYWtp8I7DMEMYGZ0ShrfufkYpfXau/va6RBlw=;
        b=d2g62sZ6bKRBqUShGhvqaFo/yWDSn2l5QpORjhk9iiaMY8mXCNDVUoAyU51pVoT61/
         oVDTxizR03zjL9lQ2SvyPUWKPpIDyAsd/Qxg0dqzEWFv6l9Xcxgs5CP3Yy2PSqTf9mAb
         YC9REanj9AkG4qyzxZ1+NOveYYPm38LYAmcgvQOBuO6zNUSB/lcbIObeBalmt2R2oeRT
         RfFJ49QVVTkCsY+Q5HVCeU44lCSzG9VJxzJVmBQX/voicCEZFB9BlaJAz9keURwUgvjc
         W7wphx85DYCsBe22Ls/zKL3+Ugr2WMqmJkn/M//5qIGYXZVOFyUkmA/CbCViAEw3phla
         EqSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6Ci3MJOYWtp8I7DMEMYGZ0ShrfufkYpfXau/va6RBlw=;
        b=uMwtItq6rRxipddofIXM8T8S7az4OmI5/QyRMcBVL/gQ9BKaMvDbNsALx+ChSbNsZI
         c5gNGpLNVXP5cyGPHrjVw2QsREmMsgqqdnKQ5pN5NgLXy6upOVkMf3LJChFr+icazEP6
         sq8OHnfNXi52/YQXNggt8C9dhX3hRUgVuH08PYtJPPg0clf8yIj+ypy+dWPCPOoKi7j3
         bXQsde4ULq8wOo69bhf8G99u3aYdG3zRqcoNEJCY2SGrtzcELQyUeNo+OAjUTIjNkZYE
         mIvfBfWwwqkuhOJlxVy+YmhNj7jbvIUkCpMPy+YNhOaMlEXszDWYR5s8okf+yXcYUqgn
         LAaQ==
X-Gm-Message-State: AOAM532QtgS6FqhBIjlkGZYGKRBuLNzBlvBUjxk3XCB58C7KUF3HOaHu
        xSGtfrGdHFdBlLzz89FYbTlq7Q==
X-Google-Smtp-Source: ABdhPJyIl3MGD9idbh3iYXVqwWDXdPgSxBuh6rd7uDtMlze2KT1EzWV4BKYWDgI3dFRxODxlms0FRw==
X-Received: by 2002:a63:1b51:: with SMTP id b17mr13811452pgm.22.1627906050481;
        Mon, 02 Aug 2021 05:07:30 -0700 (PDT)
Received: from n248-175-059.byted.org. ([121.30.179.62])
        by smtp.googlemail.com with ESMTPSA id f30sm12874867pgl.48.2021.08.02.05.07.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Aug 2021 05:07:29 -0700 (PDT)
From:   fuguancheng <fuguancheng@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, davem@davemloft.net, kuba@kernel.org,
        arseny.krasnov@kaspersky.com, andraprs@amazon.com,
        colin.king@canonical.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        fuguancheng <fuguancheng@bytedance.com>
Subject: [PATCH 0/4] Add multi-cid support for vsock driver
Date:   Mon,  2 Aug 2021 20:07:16 +0800
Message-Id: <20210802120720.547894-1-fuguancheng@bytedance.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset enables the user to specify additional CIDS for host and
guest when booting up the guest machine. The guest's additional CIDS cannot
be repeated, and can be used to communicate with the host. The user can
also choose to specify a set of additional host cids, which can be
used to communicate with the guest who specify them. The original
CID(VHOST_DEFAULT_CID) is still available for host. The guest cid field is
deleted.

To ensure that multiple guest CID maps to the same vhost_vsock struct,
a struct called vhost_vsock_ref is added.  The function of vhost_vsock_ref
is simply used to allow multiple guest CIDS map to the
same vhost_vsock struct.

If not specified, the host and guest will now use the first CID specified
in the array for connect operation. If the host or guest wants to use
one specific CID, the bind operation can be performed before the connect
operation so that the vsock_auto_bind operation can be avoided.

Hypervisors such as qemu needs to be modified to use this feature. The
required changes including at least the following:
1. Invoke the modified ioctl call with the request code
VHOST_VSOCK_SET_GUEST_CID. Also see struct multi_cid_message for
arguments used in this ioctl call.
2. Write new arguments to the emulated device config space.
3. Modify the layout of the data written to the device config space.
See struct virtio_vsock_config for reference.

I have tested this setup with iperf3.  The communication between host
and guest using original CID or additional CIDS worked normally.
Not tested in extreme conditions where memory is insufficient.

Linux kernel newbies here, any suggestions are welcomed.
Thanks in advance!

fuguancheng (4):
  VSOCK DRIVER: Add multi-cid support for guest
  VSOCK DRIVER: support communication using additional guest cid
  VSOCK DRIVER: support specifying additional cids for host
  VSOCK DRIVER: support communication using host additional cids

 drivers/vhost/vsock.c                   | 338 ++++++++++++++++++++++++++++----
 include/net/af_vsock.h                  |   5 +
 include/uapi/linux/vhost.h              |   9 +
 include/uapi/linux/virtio_vsock.h       |   8 +-
 net/vmw_vsock/af_vsock.c                |  28 ++-
 net/vmw_vsock/virtio_transport.c        | 129 +++++++++++-
 net/vmw_vsock/virtio_transport_common.c |   5 +-
 net/vmw_vsock/vsock_loopback.c          |   8 +
 8 files changed, 471 insertions(+), 59 deletions(-)

-- 
2.11.0

