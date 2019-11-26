Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 017C8109BF5
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfKZKKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:10:15 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45733 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfKZKKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:10:10 -0500
Received: by mail-pf1-f194.google.com with SMTP id z4so8932293pfn.12;
        Tue, 26 Nov 2019 02:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jdQDv4S8OWRFK8BJ5NYf9HpYfCnOIJYUleYQ7gA4ef8=;
        b=YtApj9X/cp+10E3jJdzMh0RcIPpc4CopknMK247+K9YhmjX7IaHFWp+tcwyfTXgE1K
         gearHC/Oqv3chiy+cx5zxAlKbAL4kS39s+2seSdFMdf1o/FAw+xtkgN6rgtw7LvxFk0x
         dk2nfC7QJRhmLMf8fDIBhaLSjx4piMarDrUDqnoiEKNP03RJxZ5M2xdlytCoR0FUDVM2
         aVW8Sq5kbWBuxjoE05KD0QmF2fcj8PI1zAkB44AVQblaOYQQLK/tT1NFDl65Z6YQgt0D
         GjVP38TtY8UMwsYUVBKZvbhp08TZ25UDZtPXpeY4aupwLgMabEkMR4pwI3m2xdpvx7zE
         merw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jdQDv4S8OWRFK8BJ5NYf9HpYfCnOIJYUleYQ7gA4ef8=;
        b=t5/BlHBEmdjb453m8yWGBQOeCb5SiB6rGrpBZIpfD3pTM0zF3l962aW05Etxfvdf2A
         UrpSLdHos+sB69QSVwT19GoyYTIS85DLjziIVnqh8HP/fH804DgvyyXyZKdrNhP5Z34D
         sxcDosVXVBCsFfYCmlci4upjdqkyemDQyGRehvukb0mQk0BervI7KtCv08vN7bmZVfbP
         wPL/JWpzEPYSdeQ7WvW5sZh5VtclR4zWhNloFXBxHjhJNz9wu2OkcHljsNAg1A8RkrSf
         ni/58GKk4PxbK6kEWY9tLImlTtF9hRMusmiGRlhT8HrdMXpJT4HQiA49h9rhjLTw6BnN
         y0Pg==
X-Gm-Message-State: APjAAAUCIEABvVrB6jSbfGIMKAVlLffGLrIkMBGnvfEhGkzp50FenqOb
        Ayq9iuI0sLb4LrNgRHDm2S0=
X-Google-Smtp-Source: APXvYqyG5wYFvtz/3LCmlX/xi0PtGiVDiGiK1KoXwfOJBmKbLfebzWsYO5JtfxZWx6PW1f5qA8Ftsw==
X-Received: by 2002:a65:4346:: with SMTP id k6mr33984016pgq.349.1574763009508;
        Tue, 26 Nov 2019 02:10:09 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id h9sm12059065pgk.84.2019.11.26.02.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:10:08 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [RFC 0/3] Qemu: virtio-net XDP offload
Date:   Tue, 26 Nov 2019 19:09:11 +0900
Message-Id: <20191126100914.5150-1-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Note: This RFC has been sent to netdev as well as qemu-devel lists

This patchset implements XDP offload feature in qemu. The successful
operation of this feature depends on availability of XDP offload
feature in guest, qemu and host. When this feature isn't available in
qemu or host, the request from guest to offload an XDP program should
fail.

Patch 1/3 adds support for libbpf in configure script.
Patch 2/2 enables offloading of ebpf program.
Patch 3/3 enabled offloading of ebpf map.

Points for improvement (TODO):
- In future virtio can have feature bit for offloading capability

- TUNGETFEATURES should have a flag to notify about offloading
  capability

- Submit virtio spec patch to describe XDP offloading feature

- DoS: Offloaded map uses host's memory which is other than what has
  been allocated for the guest. Offloading many maps of large size can
  be one of the DoS strategy. Hence qemu should have parameter to
  limit how many maps guest can offload or how much memory offloaded
  maps use.

Note:
This set directly modifies virtio_net.h header instead of
importing it from existing kernel headers because relevant changes
aren't present in kernel repository yet. Hence changes to virtio_net.h
are for RFC purpose only.


Jason Wang (2):
  virtio-net: add support for offloading XDP program
  virtio-net: add support for offloading an ebpf map

Prashant Bhole (1):
  configure: add libbpf support

 configure                                   |  23 +++
 hw/net/Makefile.objs                        |   2 +
 hw/net/virtio-net.c                         | 157 ++++++++++++++++++++
 include/net/tap.h                           |   2 +
 include/standard-headers/linux/virtio_net.h |  50 +++++++
 net/Makefile.objs                           |   1 +
 net/tap-bsd.c                               |   5 +
 net/tap-linux.c                             |  48 ++++++
 net/tap-linux.h                             |   1 +
 net/tap-solaris.c                           |   5 +
 net/tap-stub.c                              |   5 +
 net/tap.c                                   |   7 +
 net/tap_int.h                               |   1 +
 13 files changed, 307 insertions(+)

-- 
2.20.1

