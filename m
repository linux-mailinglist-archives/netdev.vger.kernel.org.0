Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C150B2CBB
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 21:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbfINTjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 15:39:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731296AbfINTjF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Sep 2019 15:39:05 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 44D4EC08EC02
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 19:39:05 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id k68so37239637qkb.19
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 12:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=vaylEgrlIg+lPjH544xVFYytAlsLACbCpY321J/9g4E=;
        b=blAKIMa4RCF07o20x+MdVVdi9gRplBJbjx9yF42i0b9fiIvzKHXSJiUHCXCt36H5HX
         ecZVqXtqMMtLrQ/3Ob/yIFrJt3Yt1ngaxCfmtmemmQaT99kxQlnih2I8xuWRlqpTFnOg
         x7ADOf8rMwcwKEv19f13pzYBaxlFY2oVrp5MfDVs0Kd/z4bH2rKkrFC8h+hrVkj/m15U
         tYfKickVT5Kh5WQLKeNAMa01xvEi5ljmejTjqrBAGpYDtNBQdTAFoqmfRJlR9G/yOtfR
         xsY0zI0hCJ4/2ufP1Fd0m9LB75w7RMSC6VFECDpRIUyzEOnDYZs+aFiL1UjLFTXU73Qh
         GW0A==
X-Gm-Message-State: APjAAAVG7hR853L4KGd/SUqboIrDU4Ff0zDIJ/Bdg/Edr514o2WT2mnG
        v0fO8komtuk2BK/Jap39CoEgSuK6NaILhRcRa60hnxWdGEezZfnaSI8qaxGAPKb8FLF8zxD0hei
        AcPOSDH383ZTykQQy
X-Received: by 2002:a37:4b97:: with SMTP id y145mr53500323qka.310.1568489944596;
        Sat, 14 Sep 2019 12:39:04 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwD6rz0Xz1EID/JFGdbYv8ZxwisBunlJJE5csAnnPdoREA9Pde8LY2vagubbz6rBIS1caMDgg==
X-Received: by 2002:a37:4b97:: with SMTP id y145mr53500312qka.310.1568489944423;
        Sat, 14 Sep 2019 12:39:04 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id y17sm17211975qtb.82.2019.09.14.12.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 12:39:03 -0700 (PDT)
Date:   Sat, 14 Sep 2019 15:38:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, mst@redhat.com
Subject: [PULL] vhost: a last minute revert
Message-ID: <20190914153859-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So I made a mess of it. Sent a pull before making sure it works on 32
bit too. Hope it's not too late to revert. Will teach me to be way more
careful in the near future.

The following changes since commit 060423bfdee3f8bc6e2c1bac97de24d5415e2bc4:

  vhost: make sure log_num < in_num (2019-09-11 15:15:26 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 0d4a3f2abbef73b9e5bb5f12213c275565473588:

  Revert "vhost: block speculation of translated descriptors" (2019-09-14 15:21:51 -0400)

----------------------------------------------------------------
virtio: a last minute revert

32 bit build got broken by the latest defence in depth patch.
Revert and we'll try again in the next cycle.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (1):
      Revert "vhost: block speculation of translated descriptors"

 drivers/vhost/vhost.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)
