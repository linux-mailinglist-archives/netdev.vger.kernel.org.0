Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB0332F7FA
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 04:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCFDQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 22:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhCFDP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 22:15:59 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5677BC06175F
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 19:15:55 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id 81so4123167iou.11
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 19:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iivR5izrSDnkL0Ulfa/UBOIkuK8EUuHcrp0xeHmrIYo=;
        b=AekiK3cxuipzN7VXe93ymnRxg+4OiU4iBzrp+7Oe5028IzYUMNj9cAFkZZRMhVcD+h
         P7zHl9bpwSRqTJNWuTDVRNZWBtfg5Gjc1/vxrHlWlOotPWUieDtlnAlXXQK1FcXk/gp4
         n4YgXMxpSoAp1PZQE/F6yCTZq1xbzzXI2PiiVCI9fuplUUr98AuxyE7oR1zWskR7a09D
         GZ7jGUCcbPTtDXOksbfV9A/TN0nCgg37y3u28vj1+rHEzg9midwj2PIG+VcqckDdkS9o
         KQZjLh6COotCFFjf38kW/bI+Q/ePzqJV7tWO0QNPCrWgjjrt+h9Xurh526pEErBm3N41
         nZdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iivR5izrSDnkL0Ulfa/UBOIkuK8EUuHcrp0xeHmrIYo=;
        b=Vohcs9gKGnbaBQocO7zXfrhSsBNR8vnneWIPbswyJQAii8CvwKebzvIocPWItCZuPH
         qQEmy6/LCPelZuY7z5LFQ2zI5f3XVMREN8OYx0TQ3KoP6sdqLBlCGYLfcqI0SaM8FD19
         +la6L/DUFXR83n/8LxNtnPogJ+dMlVwZue6DE37fOfITGGSa0oHPK4xUuXF/nOfLDT2d
         i9IkTOAznJ8h1Jg3/qeGv0e1PeExcD6zV9q8u9JX97mnqLka5HtEaDFUUI1UdimPM8CG
         YIH+OdWYdZImAGKlcvEETaYDdtqSC3w/h/ay1pCnHC9YekJBrib73gvadEuXLP4t3HPe
         Z8kg==
X-Gm-Message-State: AOAM532y6kl/w7rSQL8fIWbtsZAKgDTiaY3adpiFuAH5luJlS/l0qVku
        +TDgRF/r4EpFC0S9W2ZRhjKkyg==
X-Google-Smtp-Source: ABdhPJzALqRHwwFZ7deNNT9e12ZamXALE4/1OxBQFtn6fRQlppIEn68J43KF9Va5A2LHG4uRrjnfww==
X-Received: by 2002:a5e:a508:: with SMTP id 8mr10856072iog.135.1615000554634;
        Fri, 05 Mar 2021 19:15:54 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id i67sm2278693ioa.3.2021.03.05.19.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 19:15:54 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/6] net: qualcomm: rmnet: stop using C bit-fields
Date:   Fri,  5 Mar 2021 21:15:44 -0600
Message-Id: <20210306031550.26530-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Version 2 of this series fixes the code in the final patch that
encoded the RMNet checksum offload header inserted for outgoing
packets.  It was erroneously using be16_encode_bits() to generate
the value to be written into the header, where it should have been
using u16_encode_bits().  Bjorn noticed this, as did the Intel
kernel test robot.

This version of these patches has been tested as follows:
  - ICMP (ping) and TCP (wget), and UDP (iperf) packet transfer in
    both directions over an RMNet link (using IPA, with IPv4 only).
    This used QMAPv4, with checksum offload in both directions
    enabled (and aggregation enabled for inbound data).  Inbound
    checksum values were verified good (for TCP and UDP).  I
    presume the TX checksum was acceptable but did nothing special
    to confirm that.  Checksum verification was enabled with:
      ethtool -K rmnet_data0 tx on rx on
  - Format of the new and old structures were compared, bit by bit,
    after assigning various values to the fields using both the
    old and new structure definitions (and access methods).
  - The patches were all run through sparse.  No new errors are
    reported.  (A "no newline at end of file" warning is reported
    for "rmnet_vnd.c"; and ip_fast_csum() defined in ARM64
    "checksum.h" produces a warning.)

I've added Reviewed-by from Bjorn to the first five patches, and
Reported-by from the kernel test robot on the last one

Below is description that was sent with version 1.

					-Alex

This series converts data structures defined in <linux/if_rmnet.h>
so they use integral field values with bitfield masks rather than
rely on C bit-fields.

I first proposed doing something like this long ago when my confusion
about this code (and the memory layout it was supposed to represent)
led me to believe it was erroneous:
  https://lore.kernel.org/netdev/20190520135354.18628-1-elder@linaro.org/

It came up again recently, when Sharath Chandra Vurukala proposed
a new structure in "if_rmnet.h", again using C bit-fields.  I asked
whether the new structure could use field masks, and Jakub requested
that this be done.
  https://lore.kernel.org/netdev/1613079324-20166-1-git-send-email-sharathv@codeaurora.org/
I volunteered to convert the existing RMNet code to use bitfield
masks, and that is what I'm doing here.

The first three patches are more or less preparation work for the
last three.
  - The first marks two fields in an existing structure explicitly
    big endian.  They are unused by current code, so this should
    have no impact.
  - The second simplifies some code that computes the value of a
    field in a header in a somewhat obfuscated way.
  - The third eliminates some trivial accessor macros, open-coding
    them instead.  I believe the accessors actually do more harm
    than good.
  - The last three convert the structures defined in "if_rmnet.h"
    so they are defined only with integral fields, each having
    well-defined byte order.  Where sub-fields are needed, field
    masks are defined so they can be encoded or extracted using
    functions like be16_get_bits() or u8_encode_bits(), defined
    in <linux/bitfield.h>.  The three structures converted are,
    in order:  rmnet_map_header, rmnet_map_dl_csum_trailer, and
    rmnet_map_ul_csum_header.

                                        -Alex

Alex Elder (6):
  net: qualcomm: rmnet: mark trailer field endianness
  net: qualcomm: rmnet: simplify some byte order logic
  net: qualcomm: rmnet: kill RMNET_MAP_GET_*() accessor macros
  net: qualcomm: rmnet: use field masks instead of C bit-fields
  net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum trailer
  net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header

 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  | 11 ++--
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   | 12 ----
 .../qualcomm/rmnet/rmnet_map_command.c        | 11 +++-
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 60 ++++++++---------
 include/linux/if_rmnet.h                      | 65 +++++++++----------
 5 files changed, 70 insertions(+), 89 deletions(-)

-- 
2.27.0

