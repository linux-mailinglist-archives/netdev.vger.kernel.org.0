Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F34AAB975
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391522AbfIFNlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:41:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16034 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733237AbfIFNlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 09:41:08 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 11C6785A03
        for <netdev@vger.kernel.org>; Fri,  6 Sep 2019 13:41:08 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id o11so2557067wrq.22
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 06:41:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=BOudiuHTDG2nanChju52HFlrYGD+TT2yIrow4eQVhPo=;
        b=IVorMCyFZjHdOsHgXo1GUFk9xZxKTsERSxaVzzEH6eSjbTUX9qCAShi84nptj24Uhe
         bs1FBi21UA0lzY4IGV2kOZirClHWkgTsku9S7hDDJDpqYZyd0oXXbui+gdXi17muyjdU
         RW+kk1qlSH3vQhlgRDtqIA1jl2bjSamGoFkub2jnSlhtnTwUafEwyZGUJcFNW7n8zuUI
         YxLbjsGhUuBlgPuRXU/v8dVQvfr6hzvjiO7pwThUJwGYkEvoyvZoE9qi/CjrFufRnfPW
         3mc4VK5IZOeZ2ixSotfYOiCkVLhQcR1ZML3G/WuttMi3Sl1cj5An1kDShD7IOHIE+Mcs
         55hw==
X-Gm-Message-State: APjAAAUamdDlZh2qyV4Kw+jHquWeJN0NpDim7QBnhm0d3qgLXajw23pt
        S344cGPpn9Lv7ufYvO4dNq9/wjf6XbS72qqqbNpQroLZn1264RcBARoREgM5xKtVbd+dxzhUBvL
        b+6GsMgaGZbT9Ib9W
X-Received: by 2002:a5d:68c9:: with SMTP id p9mr7195677wrw.95.1567777266879;
        Fri, 06 Sep 2019 06:41:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxreY3DmoX89vqmIPvQ3JR7SKig36Ux54jbeXQCW2FgTU0YSZ0FueKQ+54ktkhW991OFZYpRA==
X-Received: by 2002:a5d:68c9:: with SMTP id p9mr7195662wrw.95.1567777266677;
        Fri, 06 Sep 2019 06:41:06 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id r17sm6169766wrt.68.2019.09.06.06.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 06:41:05 -0700 (PDT)
Date:   Fri, 6 Sep 2019 09:41:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, jiangkidd@hotmail.com, linyunsheng@huawei.com,
        mst@redhat.com, namit@vmware.com, tiwei.bie@intel.com
Subject: [PULL] vhost, virtio: last minute fixes
Message-ID: <20190906094103-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hope this can still make it.
I was not sure about virtio-net change but it seems that it prevents
livelocks for some people.

The following changes since commit 089cf7f6ecb266b6a4164919a2e69bd2f938374a:

  Linux 5.3-rc7 (2019-09-02 09:57:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 02fa5d7b17a761f53ef1eedfc254e1f33bd226b0:

  mm/balloon_compaction: suppress allocation warnings (2019-09-04 07:42:01 -0400)

----------------------------------------------------------------
virtio, vhost, balloon: bugfixes

A couple of last minute bugfixes. And a revert of a failed attempt at
metadata access optimization - we'll try again in the next cycle.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
? jiang (1):
      virtio-net: lower min ring num_free for efficiency

Michael S. Tsirkin (1):
      Revert "vhost: access vq metadata through kernel virtual address"

Nadav Amit (1):
      mm/balloon_compaction: suppress allocation warnings

Tiwei Bie (2):
      vhost/test: fix build for vhost test
      vhost/test: fix build for vhost test

Yunsheng Lin (1):
      vhost: Remove unnecessary variable

 drivers/net/virtio_net.c |   2 +-
 drivers/vhost/test.c     |  13 +-
 drivers/vhost/vhost.c    | 520 +----------------------------------------------
 drivers/vhost/vhost.h    |  41 ----
 mm/balloon_compaction.c  |   3 +-
 5 files changed, 17 insertions(+), 562 deletions(-)
