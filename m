Return-Path: <netdev+bounces-9600-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D379A729FE4
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B4BD2819AC
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D91121F947;
	Fri,  9 Jun 2023 16:17:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD23174E5
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:17:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DBA3A82
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686327464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=4M45gRnQ1u7hqy31r1Lf6wTaxv13BKes8mPSZrcPv2Y=;
	b=fz00utoxd1iEfAGc7vzB25za1QQqSjC/XTj9KQmzDqIaoPKMZfgRkBKw4Btzyb78yWbxgi
	kaukll54MzPY4Eu/vScaq7l9R6hRgIeE/ZQZFMRVhUxkLXnOFdPbnV08hTFm149IXvEEhm
	pdA/N520w+wD7/9OitPTezRO1xVyCEo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-pHqwr9IDOsOHWH5Odv-jUA-1; Fri, 09 Jun 2023 12:17:42 -0400
X-MC-Unique: pHqwr9IDOsOHWH5Odv-jUA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-30793c16c78so2550466f8f.3
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 09:17:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686327460; x=1688919460;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4M45gRnQ1u7hqy31r1Lf6wTaxv13BKes8mPSZrcPv2Y=;
        b=Yh8qvJ9AOxw2Lse8Gv+u/54q+P4PGIKdKwhQ06D/2xqx8f9nmT41VH5Wtleg200LBD
         Urfqo+Kz8OqCdhNBGWxcFA80xpr/VLRd4dsTTW+0U0gm9n+JCsLrlNAsqQcYPXV+ATsz
         /gLPQz72Aw+REqpOSD0Ks0aVGiJIRxz9jeBdUpTgAwdbFXzjB9KJa3bYZUp4oJKl8X9V
         UFkbDCNzBz68smDc3zWI6t/+3dOsUA15Rr7P6OE6wlrQRTPJjDvOL2IBDfOLtZLL6Z3E
         bOKqewoLjXyvDED+AedhSZMNabU4ATTtzNG80yri1WM7rYYkVBWkURyxVtHd6TAsXZh8
         qKPQ==
X-Gm-Message-State: AC+VfDw8NjyXyt+4hOLt8BI4+Dbs1XIRc/Aphi7ZeWtRBNPUUwXbxybF
	CnDfuyHrsWdMJT6VdVFT5ICpl8a9XsNgzLRD+HKOWQE9MjgEwl1KWjKta5uGp7VEff22fJfoHSJ
	4faBVjNtaW0lurYG3fuYLeFoV
X-Received: by 2002:adf:e110:0:b0:307:2d0c:4036 with SMTP id t16-20020adfe110000000b003072d0c4036mr1422041wrz.66.1686327460472;
        Fri, 09 Jun 2023 09:17:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5MwccKZqMZmmQAMpaztP78KxQ/TadfL/ac1dUpnVsjT6zjT2OgsfcKy47axrXbgo+oojXt4w==
X-Received: by 2002:adf:e110:0:b0:307:2d0c:4036 with SMTP id t16-20020adfe110000000b003072d0c4036mr1422026wrz.66.1686327460126;
        Fri, 09 Jun 2023 09:17:40 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7403:2800:22a6:7656:500:4dab])
        by smtp.gmail.com with ESMTPSA id u12-20020a5d6acc000000b003062b6a522bsm4864763wrw.96.2023.06.09.09.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 09:17:39 -0700 (PDT)
Date: Fri, 9 Jun 2023 12:17:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	asmetanin@yandex-team.ru, dtatulea@nvidia.com, jasowang@redhat.com,
	michael.christie@oracle.com, mst@redhat.com,
	prathubaronia2011@gmail.com, rongtao@cestc.cn,
	shannon.nelson@amd.com, sheng.zhao@bytedance.com,
	syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com,
	xieyongji@bytedance.com, zengxianjun@bytedance.com,
	zwisler@chromium.org, zwisler@google.com
Subject: [GIT PULL] virtio,vhost,vdpa: bugfixes
Message-ID: <20230609121737-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The following changes since commit 9561de3a55bed6bdd44a12820ba81ec416e705a7:

  Linux 6.4-rc5 (2023-06-04 14:04:27 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 07496eeab577eef1d4912b3e1b502a2b52002ac3:

  tools/virtio: use canonical ftrace path (2023-06-09 12:08:08 -0400)

----------------------------------------------------------------
virtio,vhost,vdpa: bugfixes

A bunch of fixes all over the place

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Andrey Smetanin (1):
      vhost_net: revert upend_idx only on retriable error

Dragos Tatulea (1):
      vdpa/mlx5: Fix hang when cvq commands are triggered during device unregister

Mike Christie (2):
      vhost: Fix crash during early vhost_transport_send_pkt calls
      vhost: Fix worker hangs due to missed wake up calls

Prathu Baronia (1):
      vhost: use kzalloc() instead of kmalloc() followed by memset()

Rong Tao (2):
      tools/virtio: Fix arm64 ringtest compilation error
      tools/virtio: Add .gitignore for ringtest

Ross Zwisler (1):
      tools/virtio: use canonical ftrace path

Shannon Nelson (3):
      vhost_vdpa: tell vqs about the negotiated
      vhost: support PACKED when setting-getting vring_base
      vhost_vdpa: support PACKED when setting-getting vring_base

Sheng Zhao (1):
      vduse: avoid empty string for dev name

 drivers/vdpa/mlx5/net/mlx5_vnet.c       |  2 +-
 drivers/vdpa/vdpa_user/vduse_dev.c      |  3 ++
 drivers/vhost/net.c                     | 11 +++--
 drivers/vhost/vdpa.c                    | 34 +++++++++++++--
 drivers/vhost/vhost.c                   | 75 +++++++++++++++------------------
 drivers/vhost/vhost.h                   | 10 +++--
 kernel/vhost_task.c                     | 18 ++++----
 tools/virtio/ringtest/.gitignore        |  7 +++
 tools/virtio/ringtest/main.h            | 11 +++++
 tools/virtio/virtio-trace/README        |  2 +-
 tools/virtio/virtio-trace/trace-agent.c | 12 ++++--
 11 files changed, 120 insertions(+), 65 deletions(-)
 create mode 100644 tools/virtio/ringtest/.gitignore


