Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC9B26BAE0
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 05:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgIPDsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 23:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgIPDs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 23:48:28 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96677C06174A;
        Tue, 15 Sep 2020 20:48:27 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id n133so6789618qkn.11;
        Tue, 15 Sep 2020 20:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xom8pv8pA5D1wdYSli3646ft73285J8Rq30WVkF+CBQ=;
        b=nxUE6SE1fvzk0PjJBd6cS8bHQOdOaPxPYkADORPwwRlAgnDcnhEpl7zjFiKRbO0Gvh
         0KT5ZywHMAhj6Hpv6vr9/B1wmQ4HOLMRnwt4kga5VzUJ3ukjzJsd6pEtp+gwI+7mkKCe
         7DI8dwAMeYqgyw1M2y5xhL+twpxEV2ejO9C+syGcZKa/cfiYG2rTUweEpkLyzVV6J+iA
         wamaizzgqdFCysoZspVBXPBO/4bG8r/50Fcjql+1qPKXP0kdZYSgGUt6WoXiW32o0krP
         hzHvoNyswpLAsGKz7iqFsrAPOEbCHA5Pk3R7Disk+EMvBwAU6azIrXBVUSFHLW7pUJJ8
         Ii9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xom8pv8pA5D1wdYSli3646ft73285J8Rq30WVkF+CBQ=;
        b=pkwSAWZ6GNANbLKo8zeVvXavMjKLHoUVvtKIcjnXshQ3wbONaI7XVXKKNdU+GAVpX6
         VThnmJDuppzWWTC468E1BhS0PpmsSGc1Hsh0nZqFTfWVG1780+IwdGzOpG1w9XIixTja
         R+GZ6W9Ssr3EbdPeqzXQVItWFldZJ2aWcvJS954xD1soTdgdcZ5s/sPb7YGz56+vqG7L
         zZzQMThSxdwPekW4FZkZlnbtUjPMn7kwm/SoUfCApdMjN9I8ssU+vG8wz1FF5VfWuESe
         pvoU6y6+zKNO33AjGAHTslwb1eQKQ+nVJY/8lK2Q6/vfv6bwuzOQG34D7ZovAa08thAu
         RmUQ==
X-Gm-Message-State: AOAM532+2Evq9tZA6GNOpQhQpa8ULqzeYfZ2D7uLvU6dupiVKuFjl2lH
        9yVMvyxF2nbRM34zqdcaV38=
X-Google-Smtp-Source: ABdhPJwBZj+PJ1pX+JAfEeaBfIE7g8NqzyqPnN82hV+SZaeV9E3sfyqPr9wckUHLsyXMketqOJbmcg==
X-Received: by 2002:a37:4c4:: with SMTP id 187mr21793282qke.40.1600228106823;
        Tue, 15 Sep 2020 20:48:26 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id g12sm18491396qke.90.2020.09.15.20.48.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 20:48:24 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 1919927C0054;
        Tue, 15 Sep 2020 23:48:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 15 Sep 2020 23:48:23 -0400
X-ME-Sender: <xms:BothX0JDGcLcL1kYuwZ2HZIkEoItrXBKUAilTe4S0Bf5aeF18f3LIQ>
    <xme:BothX0IL_dvYRjq5mzJ0zwkGYB7_zUHmxWBOmgyiGlNPTB4GqWXr3mDuFC3dYh3XI
    L246h2drGKDtnXEvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuohhrthgvugftvggtihhpvdculdegtddmnecujfgurhephffvufffkffoggfgsedtkeer
    tdertddtnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesgh
    hmrghilhdrtghomheqnecuggftrfgrthhtvghrnhepieeuveejleehudetfeevfeelgfej
    teefhedvkedukefggedugefhudfhteevjedunecuffhomhgrihhnpehkvghrnhgvlhdroh
    hrghenucfkphephedvrdduheehrdduuddurdejudenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvg
    hrshhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrdhf
    vghngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:BothX0tvE5f5ZC1lbM16lmY7tH-hCjGuTfc-_5_lko2Pff9Rq5ViIg>
    <xmx:BothXxYxS7FL22BQIwb9rooiOsikpAcbK66b2bIZWZDZaAKjd9UGyg>
    <xmx:BothX7ZuqZs-GQ75QHCnJv8y_wRPE3u9Fs5hBvT1TDpsLRoLTPBNgQ>
    <xmx:B4thX4ImC6wMsSoue1e08VHUqYpdBF2taAfN8vhH4lGw6hxTaI6LLH1JJzE>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 91E613064682;
        Tue, 15 Sep 2020 23:48:21 -0400 (EDT)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>, will@kernel.org,
        ardb@kernel.org, arnd@arndb.de, catalin.marinas@arm.com,
        mark.rutland@arm.com, maz@kernel.org,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH v4 00/11] Hyper-V: Support PAGE_SIZE larger than 4K
Date:   Wed, 16 Sep 2020 11:48:06 +0800
Message-Id: <20200916034817.30282-1-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset add the necessary changes to support guests whose page
size is larger than 4K. And the main architecture which we develop this
for is ARM64 (also it's the architecture that I use to test this
feature).

Previous version:
v1: https://lore.kernel.org/lkml/20200721014135.84140-1-boqun.feng@gmail.com/
v2: https://lore.kernel.org/lkml/20200902030107.33380-1-boqun.feng@gmail.com
v3: https://lore.kernel.org/lkml/20200910143455.109293-1-boqun.feng@gmail.com/

Changes since v3:

*	Fix a bug that ringbuffer sizes are not page-aligned when
	PAGE_SIZE = 16k. Drop the Acked-by and Reviewed-by tags for
	those patches accordingly.

*	Code improvement as per suggestion from Michael Kelley.

I've done some tests with PAGE_SIZE=64k and PAGE_SIZE=16k configurations
on ARM64 guests (with Michael's patchset[1] for ARM64 Hyper-V guest
support), everything worked fine ;-)

Looking forwards to comments and suggestions!

Regards,
Boqun

[1]: https://lore.kernel.org/lkml/1598287583-71762-1-git-send-email-mikelley@microsoft.com/

Boqun Feng (11):
  Drivers: hv: vmbus: Always use HV_HYP_PAGE_SIZE for gpadl
  Drivers: hv: vmbus: Move __vmbus_open()
  Drivers: hv: vmbus: Introduce types of GPADL
  Drivers: hv: Use HV_HYP_PAGE in hv_synic_enable_regs()
  Drivers: hv: vmbus: Move virt_to_hvpfn() to hyperv header
  hv: hyperv.h: Introduce some hvpfn helper functions
  hv_netvsc: Use HV_HYP_PAGE_SIZE for Hyper-V communication
  Input: hyperv-keyboard: Use VMBUS_RING_SIZE() for ringbuffer sizes
  HID: hyperv: Use VMBUS_RING_SIZE() for ringbuffer sizes
  Driver: hv: util: Use VMBUS_RING_SIZE() for ringbuffer sizes
  scsi: storvsc: Support PAGE_SIZE larger than 4K

 drivers/hid/hid-hyperv.c              |   4 +-
 drivers/hv/channel.c                  | 461 ++++++++++++++++----------
 drivers/hv/hv.c                       |   4 +-
 drivers/hv/hv_util.c                  |  11 +-
 drivers/input/serio/hyperv-keyboard.c |   4 +-
 drivers/net/hyperv/netvsc.c           |   2 +-
 drivers/net/hyperv/netvsc_drv.c       |  46 +--
 drivers/net/hyperv/rndis_filter.c     |  13 +-
 drivers/scsi/storvsc_drv.c            |  56 +++-
 include/linux/hyperv.h                |  68 +++-
 10 files changed, 442 insertions(+), 227 deletions(-)

-- 
2.28.0

