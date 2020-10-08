Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A67328756E
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 15:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbgJHNut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 09:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730396AbgJHNus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 09:50:48 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E63C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 06:50:47 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id md26so8197138ejb.10
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 06:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YxmUOOq9dBLc1oFqoSYbKvUo8gg1Zr5jjxr8KVlfmnM=;
        b=APviLhvFYsfQ0BAz2H5aTnqcEg7n7OcWV2Se6kCv1vhjM2UtMrcYAqJSdTgu++Q0Jp
         c4/a7EBvrZejpCn7ZCQV4Gfze+k1guy+8TnGFgOCYOcSOnQqxBLP0H0rAozk050hu/nH
         bBRbNy5qYOMh43G7brqqHJeXOAfF8qOtD69U6jqn5UxIadg4HGVweywJrcOZM9BSuc8e
         DVu3TQ7Z/F1cPUaTecMR/nu9xsPFrUJOAyrvtTY37MWoP5W2s/Qr3SxVJ2//8kNc/Vpo
         2DoyOTG1G5QBp0ukvHRVRz1yzAtep4aonDaOrJdZcI8Kz0JsmQRU3e5m+jly0GOrzpBP
         eTzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YxmUOOq9dBLc1oFqoSYbKvUo8gg1Zr5jjxr8KVlfmnM=;
        b=rUnByUJY4zy049a0tCgxTSIFHBXfXvzoVUWLe1wotyVbF5xMfUGFuIlAN/gplxTvgz
         brE617yrQMABvBbsm8DY6NHlw8tfeABeOopshCkEY1Ld2MUfNK25QKe99nMDzeA5/dIv
         IonDM/OCS3paA9C1tIBg+wWs+97LTZRtEEq751vrA8efRrwr69jTLB5GxC6d4GXSAAcN
         DSIYKypV61fRbmetxEXtSjDioFJC6gjmdZWpjVt6PrfaRz5wHVlQV7tb5zpHklh5blCy
         s5Mz8mVF3Suotzew5dvZk7yJT7+Ne2KLMcQ1AXKtmHq/XxRbW0DpR1wT/ougk3rVUvht
         tRbw==
X-Gm-Message-State: AOAM530km8NCHW3DfTRYwndneVfz0Lw/Z422jO1ZVtX8G5odTRn4c2rD
        f+HKddsyJI8OLSFeLouVjXLXkWFeEdcTojGp
X-Google-Smtp-Source: ABdhPJwcX2sAffUNFHt330k8My+FHfm6M4duJHwJ47NGG786ib1H095JUDDxWRoIFPzqkYmMVYkEVA==
X-Received: by 2002:a17:906:4941:: with SMTP id f1mr9077405ejt.417.1602165045569;
        Thu, 08 Oct 2020 06:50:45 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id w21sm4169617ejo.70.2020.10.08.06.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 06:50:44 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 0/6] bridge: mdb: add support for IGMPv3/MLDv2 attributes
Date:   Thu,  8 Oct 2020 16:50:18 +0300
Message-Id: <20201008135024.1515468-1-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This set adds support for IGMPv3/MLDv2 attributes, they're mostly
read-only at the moment. The only new "set" option is the source address
for S,G entries. It is added in patch 01 (see the patch commit message for
an example). Patch 02 shows a missing flag (fast_leave) for
completeness, then patch 03 shows the new IGMPv3/MLDv2 flags:
added_by_star_ex and blocked. Patches 04-06 show the new extra
information about the entry's state when IGMPv3/MLDv2 are enabled. That
includes its filter mode (include/exclude), source list with timers and
origin protocol (currently only static/kernel), in order to show the new
information the user must use "-d"/show_details.
Here's the output of a few IGMPv3 entries:
 dev bridge port ens12 grp 239.0.0.1 src 20.21.22.23 temp filter_mode include proto kernel  blocked    0.00
 dev bridge port ens12 grp 239.0.0.1 src 8.9.10.11 temp filter_mode include proto kernel  blocked    0.00
 dev bridge port ens12 grp 239.0.0.1 src 1.2.3.1 temp filter_mode include proto kernel  blocked    0.00
 dev bridge port ens12 grp 239.0.0.1 temp filter_mode exclude source_list 20.21.22.23/0.00,8.9.10.11/0.00,1.2.3.1/0.00 proto kernel    26.65

Thanks,
 Nik

Nikolay Aleksandrov (6):
  bridge: mdb: add support for source address
  bridge: mdb: print fast_leave flag
  bridge: mdb: show igmpv3/mldv2 flags
  bridge: mdb: print filter mode when available
  bridge: mdb: print source list when available
  bridge: mdb: print protocol when available

 bridge/mdb.c      | 123 ++++++++++++++++++++++++++++++++++++++++------
 man/man8/bridge.8 |   8 +++
 2 files changed, 117 insertions(+), 14 deletions(-)

-- 
2.25.4

