Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28EE25A3B7
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 05:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgIBDDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 23:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgIBDB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 23:01:26 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B65C061244;
        Tue,  1 Sep 2020 20:01:25 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id f2so3104060qkh.3;
        Tue, 01 Sep 2020 20:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LIr+ANeLBExruIfTKVDhNkpaHup9XlWFL3tko87CC+0=;
        b=jXI4jbtiUHhUW0HhdwwXNFbOfYaxnVRAvPr0bA6hsPwwTRUUcqaMhyklihFT4804D+
         OGY3jV/PrqYUp6gAT0VQC04GbSw3aO5WDNeWP+HK1pDhzMy1QGpTSWRTjxTQXVsB8UQO
         8yGTqB6qDa/wQvH7SMQuOB0EB0f5sI+kSBBUcre3UMOt1r4ZOSxgAQhpr+VjUb0nrT++
         oA5zsa/gbepveEQeBSb1cDKrCaRYxePeI+8OuqsvWdqEzCKqWaKNIbdli1kzgv9ts9nB
         a5nuHVIVVY9jnXaddKC3BC965OJXpfhzF75rzCyJBf0Kb7NBT+Ej63tVYCYCcHQXEWdq
         qhxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LIr+ANeLBExruIfTKVDhNkpaHup9XlWFL3tko87CC+0=;
        b=U9F+/tLJe1316z77mQVZerjMMkLjjj3Q3qJt3YQOE91rowi/0A3hT8WGoOKXOSSgBC
         iTD1RR470fj4bDTJuxSx+Ypg7QnOFAv3kq2xZamRP9/NqUQt7eQOKr1qic+6bMfmwGqG
         vfSeJ/rj/hu0/SIbtEABP2r4vN+/QuCfgPPvDlt3MJDr/WHQtDev+PCMIP4AFM9KzRhh
         L8vSVcHH5PJG1Z0ICSO0UpMXmDJoEVTmiWZMRas9xE2XZTqSW4jL6V+VtM6Ex/drP359
         tIY6l880tbLcDssgFJPzM06qzMwaWOmB8rxa7LCca758mMS6aDhNPWOa2k62Q4ZXwPuC
         hQ4g==
X-Gm-Message-State: AOAM531rA1FrMylCOfxjuQVg3bQJNjAS3fWqnZ62AbiXONn5XHiMB2qU
        nPqJQxjn+2tUwSZ45ISTp10=
X-Google-Smtp-Source: ABdhPJxJaYITPRJeX91aHajdZ9SMJLWv8zfnKBTUxgtxM0L7A6vkyvBks9HJRCMos9oKejrf0h5i6A==
X-Received: by 2002:a37:7785:: with SMTP id s127mr46946qkc.386.1599015682842;
        Tue, 01 Sep 2020 20:01:22 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id w36sm3903462qtc.48.2020.09.01.20.01.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 20:01:21 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id BB6E027C005A;
        Tue,  1 Sep 2020 23:01:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 01 Sep 2020 23:01:18 -0400
X-ME-Sender: <xms:_QpPXzVOEb6i-mwbsBV2NpE16lwK5HbXPFIu6EFeTuToMSdUoexabA>
    <xme:_QpPX7kGdNBWKFLFXwVx1bdgoG-EjLf8An32oEV0CF2FJsuKlSaH-P4wLmf4hYPTG
    ZKxbK7h-fT6E642kg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefkedgieeiucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:_QpPX_ZqXZdXzss4cOxCiH9_jHNfRwPE4l9LAGzjrzYzUIcOKA7poQ>
    <xmx:_QpPX-X6ipQNaBaVDewLjWxdx81M1qdIiSEDFQt_jXccQPhpwXQs4A>
    <xmx:_QpPX9lV9jkJBELBNT0UOE9qhV0-lk7O96AySeBBTIu_2jbxr3J3kg>
    <xmx:_gpPX9nObenYbRosadInpc-tLw8vLUWXaMK43PcAycPTfqfuJviss10uoZI>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6A92330600A6;
        Tue,  1 Sep 2020 23:01:17 -0400 (EDT)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
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
        Michael Kelley <mikelley@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [RFC v2 00/11] Hyper-V: Support PAGE_SIZE larger than 4K
Date:   Wed,  2 Sep 2020 11:00:56 +0800
Message-Id: <20200902030107.33380-1-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset add the necessary changes to support guests whose page
size is larger than 4K.

Previous version:
v1: https://lore.kernel.org/lkml/20200721014135.84140-1-boqun.feng@gmail.com/

Changes since v1:

*	Introduce a hv_ring_gpadl_send_offset() to improve the
	readability as per suggestion from Michael.

*	Use max(..., 2 * PAGE_SIZE) instead of hard-coding size for
	inputvsc ringbuffer to align with other ringbuffer settinngs

*	Calculate the exact size of storvsc payload (other than a
	maximum size) to save memory in storvsc_queuecommand() as per
	suggestion from Michael.

*	Use "unsigned int" for loop index inside a page, so that we can
	have the compiler's help for optimization in PAGE_SIZE ==
	HV_HYP_PAGE_SIZE case as per suggestion from Michael.

*	Rebase on to v5.9-rc2 with Michael's latest core support
	patchset[1]


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
support), nothing major breaks yet ;-) (I could observe an error caused
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
 drivers/hv/channel.c                  | 462 ++++++++++++++++----------
 drivers/hv/hv.c                       |   4 +-
 drivers/hv/hv_util.c                  |  16 +-
 drivers/input/serio/hyperv-keyboard.c |   4 +-
 drivers/net/hyperv/netvsc.c           |   2 +-
 drivers/net/hyperv/netvsc_drv.c       |  46 +--
 drivers/net/hyperv/rndis_filter.c     |  12 +-
 drivers/scsi/storvsc_drv.c            |  60 +++-
 include/linux/hyperv.h                |  63 +++-
 10 files changed, 447 insertions(+), 226 deletions(-)

-- 
2.28.0

