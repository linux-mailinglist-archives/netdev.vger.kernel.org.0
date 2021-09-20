Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FE4410E8F
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 05:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhITDKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 23:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhITDKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 23:10:00 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6FDC061574;
        Sun, 19 Sep 2021 20:08:34 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id c13-20020a17090a558d00b00198e6497a4fso14143959pji.4;
        Sun, 19 Sep 2021 20:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rO+ZOlTwEBd/AcnBDdDoiaM1CRFNKUyFZNyT5m5yUgE=;
        b=IBUb1XKhsWtsS6Y9qBHqFe2dBA9Uhbob5oSNQ1TAwxq41t+TqnSVy9dZHFfms18ErD
         PmpQIIVjbySYtuPFsZyx8SLs+BnwGwJsdGqE57HeMrk8M23QcBytOBjdspJZJm65BLc9
         TE632PJ3YGo3Gf3goXNshs0vowJPiIQDlTgfZ4ToMuqAopN161Op5RFbyJp71yhg4Yhl
         pS5RtaFiD4UmY0QjQzD5coXO8FM1Jk9u5qEoiogm4W3HNmXOD8sE6uxEgVGsr1kavYcF
         50poIY4ADhslFLrLpZApZP2uFgZhOEa3dRueHlJC27e4Gu+k7NddlBfqd+ZdxNwARDAA
         OxDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rO+ZOlTwEBd/AcnBDdDoiaM1CRFNKUyFZNyT5m5yUgE=;
        b=Hq2SdFGRv+hA34OzTsjC0rhAXrs7myIXFMY7KqQpTKvbD6pKbiOVqh4dGgdfm9U8Tv
         zvWwPxTD7nra+3JjAV6iq9xGMNWq6tLCIbb9u/x9r5/voTCoUYjnfiHIgJIBoLXoQKGR
         ElvCEVGuItjtfT8YQ7Qt4MpQaeHm8DGZY5ZQy/qZiSPLBQlM3ADMYwQsPKAsHFXcDU8f
         eFyg6b9XNFlxEr6VAE70S92bvP/m9NxrdyhcND6p3JZRUSXp/SbFMSIdmwPWgHNga3JH
         n7RvK3L6gpgMy6qbNSbBSn5evAZp9Tp48+r3TvpvahPe7XKkzGC+2yxZJsu0YqInuyDW
         yJ9Q==
X-Gm-Message-State: AOAM531bP09u8A/IoZzQGLgnzsCVxUMNc46uoGTjcGzwzHEYivbcr+PM
        BjmMGuUtaQGFqhWxZSQbqhAeZErC6DOY+7OE
X-Google-Smtp-Source: ABdhPJyiXoJbPvsEsClfPBzFv2uhMkZZbBlp3eYS6N+Xjyv3hVOj4rPW5tNkA9Sscdob1ekxriN62w==
X-Received: by 2002:a17:90b:150:: with SMTP id em16mr34893167pjb.63.1632107313461;
        Sun, 19 Sep 2021 20:08:33 -0700 (PDT)
Received: from skynet-linux.local ([106.201.127.154])
        by smtp.googlemail.com with ESMTPSA id l11sm16295065pjg.22.2021.09.19.20.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 20:08:33 -0700 (PDT)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Sireesh Kodali <sireeshkodali1@gmail.com>
Subject: [RFC PATCH 00/17] net: ipa: Add support for IPA v2.x
Date:   Mon, 20 Sep 2021 08:37:54 +0530
Message-Id: <20210920030811.57273-1-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This RFC patch series adds support for IPA v2, v2.5 and v2.6L
(collectively referred to as IPA v2.x).

Basic description:
IPA v2.x is the older version of the IPA hardware found on Qualcomm
SoCs. The biggest differences between v2.x and later versions are:
- 32 bit hardware (the IPA microcontroler is 32 bit)
- BAM (as opposed to GSI as a DMA transport)
- Changes to the QMI init sequence (described in the commit message)

The fact that IPA v2.x are 32 bit only affects us directly in the table
init code. However, its impact is felt in other parts of the code, as it
changes the size of fields of various structs (e.g. in the commands that
can be sent).

BAM support is already present in the mainline kernel, however it lacks
two things:
- Support for DMA metadata, to pass the size of the transaction from the
  hardware to the dma client
- Support for immediate commands, which are needed to pass commands from
  the driver to the microcontroller

Separate patch series have been created to deal with these (linked in
the end)

This patch series adds support for BAM as a transport by refactoring the
current GSI code to create an abstract uniform API on top. This API
allows the rest of the driver to handle DMA without worrying about the
IPA version.

The final thing that hasn't been touched by this patch series is the IPA
resource manager. On the downstream CAF kernel, the driver seems to
share the resource code between IPA v2.x and IPA v3.x, which should mean
all it would take to add support for resources on IPA v2.x would be to
add the definitions in the ipa_data.

Testing:
This patch series was tested on kernel version 5.13 on a phone with
SDM625 (IPA v2.6L), and a phone with MSM8996 (IPA v2.5). The phone with
IPA v2.5 was able to get an IP address using modem-manager, although
sending/receiving packets was not tested. The phone with IPA v2.6L was
able to get an IP, but was unable to send/receive packets. Its modem
also relies on IPA v2.6l's compression/decompression support, and
without this patch series, the modem simply crashes and restarts,
waiting for the IPA block to come up.

This patch series is based on code from the downstream CAF kernel v4.9

There are some things in this patch series that would obviously not get
accepted in their current form:
- All IPA 2.x data is in a single file
- Some stray printks might still be around
- Some values have been hardcoded (e.g. the filter_map)
Please excuse these

Lastly, this patch series depends upon the following patches for BAM:
[0]: https://lkml.org/lkml/2021/9/19/126
[1]: https://lkml.org/lkml/2021/9/19/135

Regards,
Sireesh Kodali

Sireesh Kodali (10):
  net: ipa: Add IPA v2.x register definitions
  net: ipa: Add support for using BAM as a DMA transport
  net: ipa: Add support for IPA v2.x commands and table init
  net: ipa: Add support for IPA v2.x endpoints
  net: ipa: Add support for IPA v2.x memory map
  net: ipa: Add support for IPA v2.x in the driver's QMI interface
  net: ipa: Add support for IPA v2 microcontroller
  net: ipa: Add IPA v2.6L initialization sequence support
  net: ipa: Add hw config describing IPA v2.x hardware
  dt-bindings: net: qcom,ipa: Add support for MSM8953 and MSM8996 IPA

Vladimir Lypak (7):
  net: ipa: Correct ipa_status_opcode enumeration
  net: ipa: revert to IPA_TABLE_ENTRY_SIZE for 32-bit IPA support
  net: ipa: Refactor GSI code
  net: ipa: Establish ipa_dma interface
  net: ipa: Check interrupts for availability
  net: ipa: Add timeout for ipa_cmd_pipeline_clear_wait
  net: ipa: Add support for IPA v2.x interrupts

 .../devicetree/bindings/net/qcom,ipa.yaml     |   2 +
 drivers/net/ipa/Makefile                      |  11 +-
 drivers/net/ipa/bam.c                         | 525 ++++++++++++++++++
 drivers/net/ipa/gsi.c                         | 322 ++++++-----
 drivers/net/ipa/ipa.h                         |   8 +-
 drivers/net/ipa/ipa_cmd.c                     | 244 +++++---
 drivers/net/ipa/ipa_cmd.h                     |  20 +-
 drivers/net/ipa/ipa_data-v2.c                 | 369 ++++++++++++
 drivers/net/ipa/ipa_data-v3.1.c               |   2 +-
 drivers/net/ipa/ipa_data-v3.5.1.c             |   2 +-
 drivers/net/ipa/ipa_data-v4.11.c              |   2 +-
 drivers/net/ipa/ipa_data-v4.2.c               |   2 +-
 drivers/net/ipa/ipa_data-v4.5.c               |   2 +-
 drivers/net/ipa/ipa_data-v4.9.c               |   2 +-
 drivers/net/ipa/ipa_data.h                    |   4 +
 drivers/net/ipa/{gsi.h => ipa_dma.h}          | 179 +++---
 .../ipa/{gsi_private.h => ipa_dma_private.h}  |  46 +-
 drivers/net/ipa/ipa_endpoint.c                | 188 ++++---
 drivers/net/ipa/ipa_endpoint.h                |   6 +-
 drivers/net/ipa/ipa_gsi.c                     |  18 +-
 drivers/net/ipa/ipa_gsi.h                     |  12 +-
 drivers/net/ipa/ipa_interrupt.c               |  36 +-
 drivers/net/ipa/ipa_main.c                    |  82 ++-
 drivers/net/ipa/ipa_mem.c                     |  55 +-
 drivers/net/ipa/ipa_mem.h                     |   5 +-
 drivers/net/ipa/ipa_power.c                   |   4 +-
 drivers/net/ipa/ipa_qmi.c                     |  37 +-
 drivers/net/ipa/ipa_qmi.h                     |  10 +
 drivers/net/ipa/ipa_reg.h                     | 184 +++++-
 drivers/net/ipa/ipa_resource.c                |   3 +
 drivers/net/ipa/ipa_smp2p.c                   |  11 +-
 drivers/net/ipa/ipa_sysfs.c                   |   6 +
 drivers/net/ipa/ipa_table.c                   |  86 +--
 drivers/net/ipa/ipa_table.h                   |   6 +-
 drivers/net/ipa/{gsi_trans.c => ipa_trans.c}  | 182 +++---
 drivers/net/ipa/{gsi_trans.h => ipa_trans.h}  |  78 +--
 drivers/net/ipa/ipa_uc.c                      |  96 ++--
 drivers/net/ipa/ipa_version.h                 |  12 +
 38 files changed, 2133 insertions(+), 726 deletions(-)
 create mode 100644 drivers/net/ipa/bam.c
 create mode 100644 drivers/net/ipa/ipa_data-v2.c
 rename drivers/net/ipa/{gsi.h => ipa_dma.h} (57%)
 rename drivers/net/ipa/{gsi_private.h => ipa_dma_private.h} (66%)
 rename drivers/net/ipa/{gsi_trans.c => ipa_trans.c} (80%)
 rename drivers/net/ipa/{gsi_trans.h => ipa_trans.h} (71%)

-- 
2.33.0

