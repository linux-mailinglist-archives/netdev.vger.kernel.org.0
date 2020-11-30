Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299E62C804A
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 09:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgK3Iwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 03:52:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbgK3Iwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 03:52:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606726266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=IfhR367gJyQi+IqH9Qg+155OiV0npyw4vEgjmNlOLaQ=;
        b=gcqlZ+LAN1WK3Q8gnl26Vs/KfOep0onXhUnrMsQdEVjEOI2H9uAG65nN6ir5arYUVkGQ+n
        8WFlns0bA0zR6ZwHMZRF2dMBcNbs20qaofpudeGu+Daaujs++9IW9InfwmEz2Ufdls7Z01
        2AecIBMPS6OCdfYlYOzvcDbKljBd48w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-Vn8HxFMPN4-etOimB2cliQ-1; Mon, 30 Nov 2020 03:50:14 -0500
X-MC-Unique: Vn8HxFMPN4-etOimB2cliQ-1
Received: by mail-wm1-f69.google.com with SMTP id a130so6664313wmf.0
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 00:50:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=IfhR367gJyQi+IqH9Qg+155OiV0npyw4vEgjmNlOLaQ=;
        b=qHBf0086g58bdQYdB0Yf5DLusWN0gKBwxp2L+Fxh09dyZBsRK7HBFFFWhbo/lT+QcP
         /O9QM+CU3roBEcQDAs3CZTouhtuZ8IodlstcxVG+WolDfhZC5uaneYGcvkWL9EwsSrUC
         iEZQq49PhUZaPrFsw7P/iWG7gFlgoepBBdGy4ggfcSSEpWP6UH8/uyAIY4NrKyJYYi1Q
         z48//xsEXK8QTwxVgvliMIoSJ3wpQeJ9XbA2gs0/A2/8HpSrs3lq1I4DjlW/zQhJUMy0
         GqUsR640GJjoBbnZYFgcCLeRs22KLankoXJgG5wnlYQpM5kmI1JoLHBolb6hzvg49rj4
         AlKQ==
X-Gm-Message-State: AOAM532bMXFhC0a5BuzHEsXh/QT+QP8awjJNmpLvgYNL0V7ooc+mpa5a
        x0mdpY/vYUI41OFU6KDjooT1Bj2VSmWNYS31XkHcaWBluFfl6lLfS3C+n5JcnuOIEMaJErCklGg
        EhC7hXyeJZiQ66dPz
X-Received: by 2002:a1c:9a4d:: with SMTP id c74mr15059098wme.5.1606726213696;
        Mon, 30 Nov 2020 00:50:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0lcq9LYEeQweeQ1PUtnvowfMkCnfs7A6y+pZ1luBu47l3TNrIhMMTxE9tXFN2kqV6KXqSzQ==
X-Received: by 2002:a1c:9a4d:: with SMTP id c74mr15059071wme.5.1606726213486;
        Mon, 30 Nov 2020 00:50:13 -0800 (PST)
Received: from redhat.com (bzq-79-176-44-197.red.bezeqint.net. [79.176.44.197])
        by smtp.gmail.com with ESMTPSA id 21sm12930310wme.0.2020.11.30.00.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 00:50:12 -0800 (PST)
Date:   Mon, 30 Nov 2020 03:50:10 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, michael.christie@oracle.com, mst@redhat.com,
        sgarzare@redhat.com, si-wei.liu@oracle.com, stefanha@redhat.com
Subject: [GIT PULL] vhost,vdpa: bugfixes
Message-ID: <20201130035010-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 418baf2c28f3473039f2f7377760bd8f6897ae18:

  Linux 5.10-rc5 (2020-11-22 15:36:08 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to ad89653f79f1882d55d9df76c9b2b94f008c4e27:

  vhost-vdpa: fix page pinning leakage in error path (rework) (2020-11-25 04:29:07 -0500)

----------------------------------------------------------------
vhost,vdpa: fixes

A couple of minor fixes.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Mike Christie (1):
      vhost scsi: fix lun reset completion handling

Si-Wei Liu (1):
      vhost-vdpa: fix page pinning leakage in error path (rework)

Stefano Garzarella (1):
      vringh: fix vringh_iov_push_*() documentation

 drivers/vhost/scsi.c   |  4 ++-
 drivers/vhost/vdpa.c   | 80 ++++++++++++++++++++++++++++++++++++++------------
 drivers/vhost/vringh.c |  6 ++--
 3 files changed, 68 insertions(+), 22 deletions(-)

