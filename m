Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FF83A4937
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhFKTH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbhFKTHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:07:43 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1791EC061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:05:35 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id a6so32330298ioe.0
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N+tVqfQ16sHs6hcBXgSKw7cRtddpjzguPgrfy5xsGbk=;
        b=dxPORo3bj03THwqL7XEW8W4hJrxN26ypHYdVHqsBAFwy5agIvkZyFBlOD/Fyiib96B
         eEmKEy7GSJE3seDK1T12qWtJIBfT2p5h8XsPNa9HRbvwPnIyGfIJ909kCmm0JRVE2tvN
         8sxaHhMSw2JEmNZVplQOK2xeuUuAi8WkaQXihhja+Qlbfp8DF+UKZHUdHWmiKPzdQ/zx
         NLUIm5wI9TgCH1WnMfgLNnZbmr7yfWE+skRZiRrtAgu91HzHngcWerOexsCPP9msf32C
         qaZwu5eH5DuoOoSjio8KkU1iJBAsYnu6cNyukt4y/1iSIgAjN8JpqxoAOKgbZBRg5Cfh
         aEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N+tVqfQ16sHs6hcBXgSKw7cRtddpjzguPgrfy5xsGbk=;
        b=FZYk0Wf081jpIElr1ZYLAHqAYJ1RWfzYV37B8jCk8lkS8xYPD0nnmG2LPtqF3nPeR+
         UGSXWD9+e8rEqJYXJe0prNP14pemrmK380EhmJpe66KSAeB1XNSrdwDnN2DN6nVNPAAQ
         BArQay5Bph/SL4WXSt4AhM15YuLTTJbB6lOoSLfvz7AJL/62lzPuLBw3UC5kyjJTI2BK
         FJyhGJfBCdf3g+y/yMDVPewBo/EEp1cywaW5lsjkWYA7DRQi0fOEOQWnJp7ZbPmYjti/
         D5TRtQltuRIBM5iJn5ZEA2XKr844gNBIguqh18dRQAb/EOKqGsajlnejBmynOjWgVmJl
         IZWw==
X-Gm-Message-State: AOAM532iBiDm2AGY7wYyLyDn6QfdZBHZhb1TjYrIThE/Wg4qkDoVJfoY
        /gidHiA8F0+nR+UnrPvPQX21IA==
X-Google-Smtp-Source: ABdhPJyv3+3KHXE+Z67evHLpOrvfclKvfnHSVlMYDRPO4bSKEPc8K/Vd9YYgPhnHHA1Ow62vScgj6w==
X-Received: by 2002:a05:6638:2725:: with SMTP id m37mr5352337jav.121.1623438334546;
        Fri, 11 Jun 2021 12:05:34 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p9sm3936566ilc.63.2021.06.11.12.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:05:34 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/8] net: qualcomm: rmnet: MAPv4 download checksum cleanup, part 1
Date:   Fri, 11 Jun 2021 14:05:21 -0500
Message-Id: <20210611190529.3085813-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm posting a large series an two smaller parts; this is part 1.

The RMNet driver handles MAP (or QMAP) protocol traffic.  There are
several versions of this protocol.  Version 1 supports multiplexing,
as well as aggregation of packets in a single buffer.  Version 4
adds the ability to perform checksum offload.  And version 5
implements checksum offload in a different way from version 4.

This series involves only MAPv4 protocol checksum offload, and only
in the download (RX) direction.  It affects handling of checksums
computed by hardware for UDP datagrams and TCP segments, carried
over both IPv4 and IPv6.

MAP packets arriving on an RMNet port implementing MAPv4 checksum
offload are passed to rmnet_map_checksum_downlink_packet() for
handling.

The packet is then passed to rmnet_map_ipv4_dl_csum_trailer() or
rmnet_map_ipv6_dl_csum_trailer(), depending contents of the MAP
payload.  These two functions interpret checksum metadata to
determine whether the checksum in the received packet matches that
calculated by the hardware.

It is these two functions that are the subject of this series (parts
1 and 2).  The bulk of these functions are transformed--in a lot of
small steps--from an extremely difficult-to-follow block of checksum
processing code into a fairly simple, heavily commented equivalent.

					-Alex

Alex Elder (8):
  net: qualcomm: rmnet: use ip_is_fragment()
  net: qualcomm: rmnet: eliminate some ifdefs
  net: qualcomm: rmnet: get rid of some local variables
  net: qualcomm: rmnet: simplify rmnet_map_get_csum_field()
  net: qualcomm: rmnet: IPv4 header has zero checksum
  net: qualcomm: rmnet: clarify a bit of code
  net: qualcomm: rmnet: avoid unnecessary byte-swapping
  net: qualcomm: rmnet: avoid unnecessary IPv6 byte-swapping

 .../ethernet/qualcomm/rmnet/rmnet_config.h    |   1 +
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 179 +++++++++---------
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |   1 +
 3 files changed, 92 insertions(+), 89 deletions(-)

-- 
2.27.0

