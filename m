Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E300E2274B6
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgGUBly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUBlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:41:53 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1CEC061794;
        Mon, 20 Jul 2020 18:41:53 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id l23so10009636qkk.0;
        Mon, 20 Jul 2020 18:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8bstVRUrGPJ0lCiCnj7LHZc0J9SM5E5yFAiOW2I9qf8=;
        b=QW6TtArHN2b50+YGhcQawK9YMJ9h6vXyUvupD27jRcbudQoah6JkLugiKJL7UaO3B5
         rG3iEb4J5vZU9iH5srS+NuGdeXAokciX/0Pl9g8lt+LGrN6KgCaorqcaW7X7+9KMQPLx
         jgV6RI/pNnhfu5VeTHMAwzXZkq3FvJwEgUVEoCCRrxV9bu/kpXB/JMZo/584oR2mscCN
         GR40RYZiRerP/ahrSQ20coooLo5SXrTELDpPT6uD3vvjXgFuLZiPV1Q63noLwETwu7JV
         zGvKiKxP+BG3DqK3sX6xCkn1PxTE5JbXm2SzzFLPZflUtCrW40GPdpL8czkQ/3KMb30b
         bwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8bstVRUrGPJ0lCiCnj7LHZc0J9SM5E5yFAiOW2I9qf8=;
        b=Yh+w2vFbtjg77BfmGW+OoNOWuP8aKx2JumgcM9ZhxnDqtUloZjS1lggiyLMErx/GH4
         aueM1WJLzxDR/vIhRvALU445I6p0SSMym9NRgjsAIIF8welROLuvYYt7oj98nie6gVHy
         QrWWiAEI627oa6KYih8E8coLCAVrux02sJt3opVcWGcy0nayxM3Ej4cT3ruhRT9LOtou
         xgB0cv8ocGxBjou1rsG/QeHnEtR/I0jktGwnF3vo9jYMvIuZlXE2LhtABQ5oMUoYM5cB
         jONxZP8vgP+EiZ96GuE651uy4Wk+nyxYJJcl4hSubnuBDJnKdR9rSvDTmuCwNVAjAdYm
         FlNQ==
X-Gm-Message-State: AOAM533tsrhi2JVEKQ3MAqIAlkVREmGP7lsyq2PTdBnR0ixapqS3/SOH
        alfO2uxktDIhm7X+yZfmin0=
X-Google-Smtp-Source: ABdhPJyKw3SIVq8WkVYsXJsIEQhxcFrAgeMCPTKXbdHpcU93on/N8Mve+8Zu/INbE+P0yfVMwaiGfA==
X-Received: by 2002:a37:b6c6:: with SMTP id g189mr25421630qkf.206.1595295712682;
        Mon, 20 Jul 2020 18:41:52 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id 16sm1181454qkv.48.2020.07.20.18.41.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 18:41:51 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id A3DAD27C0054;
        Mon, 20 Jul 2020 21:41:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 20 Jul 2020 21:41:50 -0400
X-ME-Sender: <xms:3UcWX3RBGlHgUEoWbF9fx31vQxvRe7UdAKnCGhE8fZbe3acSzutEtg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeehgdegjecutefuodetggdotefrodftvf
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
X-ME-Proxy: <xmx:3UcWX4wy4lXSDfaY7sWLIi8rEuqept9YGmudQw2AP9GayArbaWbbAA>
    <xmx:3UcWX82lKcOf_ckSM3VoK2PSmH6oggIZoxF6vWflfA5I7fvX0JUjsw>
    <xmx:3UcWX3AykWf7oB-XhhbRFyF6ZRW0hg5RhnxSSFehYyB1CrubaxAyVg>
    <xmx:3kcWXw61CfiF_ug0TJeAz1OjNhDoUibLgiCy7E3FQxi6h-XztBHPelNnBv4>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5B1B0306005F;
        Mon, 20 Jul 2020 21:41:49 -0400 (EDT)
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
Subject: [RFC 00/11] Hyper-V: Support PAGE_SIZE larger than 4K
Date:   Tue, 21 Jul 2020 09:41:24 +0800
Message-Id: <20200721014135.84140-1-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset add the necessary changes to support guests whose page
size is larger than 4K.

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
Hyper-V).

Looking forwards to comments and suggestions!

Regards,
Boqun

[1]: https://lore.kernel.org/lkml/1584200119-18594-1-git-send-email-mikelley@microsoft.com/

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
 drivers/hv/channel.c                  | 452 +++++++++++++++-----------
 drivers/hv/hv.c                       |   4 +-
 drivers/hv/hv_util.c                  |  16 +-
 drivers/input/serio/hyperv-keyboard.c |   4 +-
 drivers/net/hyperv/netvsc.c           |   2 +-
 drivers/net/hyperv/netvsc_drv.c       |  46 +--
 drivers/net/hyperv/rndis_filter.c     |  12 +-
 drivers/scsi/storvsc_drv.c            |  27 +-
 include/linux/hyperv.h                |  63 +++-
 10 files changed, 400 insertions(+), 230 deletions(-)

-- 
2.27.0

