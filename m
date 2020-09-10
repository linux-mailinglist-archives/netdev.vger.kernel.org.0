Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D279526521E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgIJVIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731061AbgIJOfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:35:19 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EB8C061757;
        Thu, 10 Sep 2020 07:35:09 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id q21so6579413edv.1;
        Thu, 10 Sep 2020 07:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VuITL6ssVJ2JograAwzCT8JrN+4pTWzj/K7rI7rnj+Y=;
        b=oF8f1feBcDoWI0Mx+EWnTen+A/7+i3O81kYJqopMLTyZ3z9pKa6wGCuBSL90hzVbB+
         595QlbNpNJkWybdOcQecZgZkBqntN0ampP0+wgTrpLtkYyBAv4MATvlZrT5r2Cq14bP3
         8g1/V4My35WNgs5VOxWYkz6L9ZZJuQY/tkhKHrSaPJcTi4kLJ8VDh6oXwpfonYG0gdaj
         wx3cVmOH4hFGht4wGmHAOWHNqFqasW/cs4N74mAwy4gVBZinIcF8RvbDVisdZwq2QUHf
         JJFPa14X8cKTQFIfyEs+hEp9i/BkUVt3ynbEoDf2S6mwLEYsh7MTzhSq/iOXR9c/ZQoT
         CVpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VuITL6ssVJ2JograAwzCT8JrN+4pTWzj/K7rI7rnj+Y=;
        b=sO1S/Mwo3qedXNfJw0G2g+kXTdMm0qctbv5laiabgi0k82EsiSpoyabe98l8J8DB1A
         uobu+cz7FZ9yXxpXNdHXC+iuRW2ucClFsJNsUr69G5mwIYmuMGb1ZGgJQZN27ZynarWz
         NO5rI9D3qxT4wb23ryx8sul28+Un1R83jx6NyEjtr83ZgtjbLVu1+oEX9WJm7oHv77fv
         r6B0igDW3IB8zOwed48gRy8xXDzENGSSLMyeahVjKvnGnEabsygaoQDogdGJe01I9817
         PpFjBclNzSi0DGFiEcd2IHKHp5cB+f907Xstsk38ZzcnmoEDNhgKEx+LLYqQdsM/N/FA
         ggBw==
X-Gm-Message-State: AOAM531LzAt18Cq0GFKNzdxB3sUi2n4xDxQVHLuSCrKe2zP8SN3lwOAh
        ItUcwqVTwBBApsJ1uodrvMA=
X-Google-Smtp-Source: ABdhPJxok/n2ml7Rrcym/ZZrGrg8ZdFjvJOgn8pl+rC9iufO433GRXFiFH5UuFTpp75qUASFb0FgbQ==
X-Received: by 2002:a50:ee10:: with SMTP id g16mr10111835eds.258.1599748507839;
        Thu, 10 Sep 2020 07:35:07 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id r8sm7245817edy.87.2020.09.10.07.35.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 07:35:06 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 42F4627C00A0;
        Thu, 10 Sep 2020 10:35:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 10 Sep 2020 10:35:02 -0400
X-ME-Sender: <xms:lTlaX3UHxIonHxYav49X4NIXZyTHGUi9W4WQNqLbDKiYAQg79bh_9g>
    <xme:lTlaX_lm_NHw0r3HLh9ZImkFf-asNzl46fuN_9dMwhTPqcJ05beXYfoqYRTq__w9W
    3XRoy4DJ916BBzXwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehjedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgggfestdek
    redtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgse
    hgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeeiueevjeelheduteefveeflefg
    jeetfeehvdekudekgfegudeghfduhfetveejudenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeehvddrudehhedrudduuddrjedunecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhph
    gvrhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunhdr
    fhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:lTlaXzbm5__xi8H5D0mxniybalMNXdp46InopCxuNcPtPn3nFrvZeQ>
    <xmx:lTlaXyX1PKHnACNV4J3Jw1jkAwbxshvRNO0qobK5MlWoUghWYFjBLA>
    <xmx:lTlaXxljk7uR6iCNR2yk9MCkGLprRXirBRBvNOAeog5ShD0G9FK0dA>
    <xmx:ljlaXzUAowJrUoOj9t9Z2qCuQT6VlvoyhzbNwtzhCUlxfcCn1LYl5eJ7pfM>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8CD33306468B;
        Thu, 10 Sep 2020 10:35:00 -0400 (EDT)
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
Subject: [PATCH v3 00/11] Hyper-V: Support PAGE_SIZE larger than 4K
Date:   Thu, 10 Sep 2020 22:34:44 +0800
Message-Id: <20200910143455.109293-1-boqun.feng@gmail.com>
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
feature). Now as the patchset has been deeply reviewed, I change it from
"RFC" to "PATCH", and also add ARM64 people Cced for broader insights
(although the code is arch-independent).

Previous version:
v1: https://lore.kernel.org/lkml/20200721014135.84140-1-boqun.feng@gmail.com/
v2: https://lore.kernel.org/lkml/20200902030107.33380-1-boqun.feng@gmail.com

Changes since v2:

*	Use a simpler and straight-forwards method to set up the payload
	array for storvsc thanks to the inspiration from Michael Kelley.

*	Some typo fixes as per suggestion from Michael Kelley.

*	Fixes compiler warnings due to the different types of two
	operands for max().


Hyper-V always uses 4K as the page size and expects the same page size
when communicating with guests. That is, all the "pfn"s in the
hypervisor-guest communication protocol are the page numbers in the unit
of HV_HYP_PAGE_SIZE rather than PAGE_SIZE. To support guests with larger
page size, we need to convert between these two page sizes correctly in
the hypervisor-guest communication, which is basically what this
patchset does.

In this conversion, one challenge is how to handle the ringbuffer. A
ringbuffer has two parts: a header and a data part, both of which want
to be PAGE_SIZE aligned in the guest, because we use the "double
mapping" trick to map the data part twice in the guest virtual address
space for faster wrap-around and ease to process data in place. However,
the Hyper-V hypervisor always treats the ringbuffer headers as 4k pages.
To overcome this gap, we enlarge the hv_ring_buffer structure to be
always PAGE_SIZE aligned, and introduce the gpadl type concept to allow
vmbus_establish_gpadl() to handle ringbuffer cases specially. Note that
gpadl type is only meaningful to the guest, there is no such concept in
Hyper-V hypervisor.

This patchset consists of 11 patches:

Patch 1~4: Introduce the types of gpadl, so that we can handle
	   ringbuffer when PAGE_SIZE != HV_HYP_PAGE_SIZE, and also fix
	   a few places where we should use HV_HYP_PAGE_SIZE other than
	   PAGE_SIZE.

Patch 5~6: Add a few helper functions to help calculate the hvpfn (page
	   number in the unit of HV_HYP_PAGE_SIZE) and other related
	   data. So that we can use them in the code of drivers.

Patch 7~11: Use the helpers and change the driver code accordingly to
	    make net/input/util/storage driver work with PAGE_SIZE !=
	    HV_HYP_PAGE_SIZE

I've done some tests with PAGE_SIZE=64k and PAGE_SIZE=16k configurations
on ARM64 guests (with Michael's patchset[1] for ARM64 Hyper-V guest
support), everything worked fine ;-) (I could observe an error caused
by unaligned firmware data, but it's better to have it fixed in the
Hyper-V). I also have done a build and boot test on x86, everything
worked well.

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
  Input: hyperv-keyboard: Make ringbuffer at least take two pages
  HID: hyperv: Make ringbuffer at least take two pages
  Driver: hv: util: Make ringbuffer at least take two pages
  scsi: storvsc: Support PAGE_SIZE larger than 4K

 drivers/hid/hid-hyperv.c              |   4 +-
 drivers/hv/channel.c                  | 461 ++++++++++++++++----------
 drivers/hv/hv.c                       |   4 +-
 drivers/hv/hv_util.c                  |  16 +-
 drivers/input/serio/hyperv-keyboard.c |   4 +-
 drivers/net/hyperv/netvsc.c           |   2 +-
 drivers/net/hyperv/netvsc_drv.c       |  46 +--
 drivers/net/hyperv/rndis_filter.c     |  13 +-
 drivers/scsi/storvsc_drv.c            |  54 ++-
 include/linux/hyperv.h                |  64 +++-
 10 files changed, 441 insertions(+), 227 deletions(-)

-- 
2.28.0

