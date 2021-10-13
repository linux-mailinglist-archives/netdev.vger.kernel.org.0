Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B3142B8E3
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238302AbhJMHXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234190AbhJMHUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:20:06 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39310C061765
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 00:18:03 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id a25so6048446edx.8
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 00:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ot0YXRr1MYkMN/lp1/Ph3IwBVwPjRVRrGimZdgk3jPw=;
        b=IXWz1b6Gy10RvdasJEE9RUURJDktg9h2/xx+LE0pLl1TRm8dvyejce5t6YH+7ImlVK
         9UsYWbGVAhXVI1j4MPceJQe9nk6aXi4aqnVr7FlbO5UokzbtjI3i1R3rpxW2OW8wWSf6
         8CQOTr/PR76bplkKY/xf9XJ/nW0yYPXMfS9/yVUHUnMQfIJQ5rNf5Mx9yDghuYtWDPnq
         tvqPc2A49h3eXS22DDt5EDi6+ORZfrfo0I5KRXhuRgb+cpUWXgJPxiuYBTW//ntqNt0M
         dXW0qFYy2tnpAiW6MvsBMadU0vP0PBeXMx/U52/42/gw473xFnstM/z3if++Y6Pc5nbt
         xwUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ot0YXRr1MYkMN/lp1/Ph3IwBVwPjRVRrGimZdgk3jPw=;
        b=BCVCcApRP7yqA1d78/dLd6w5HX/vxdf2P0zDupx0cqz1f3BqerdJi+Ipkz5o/zApzw
         YgeDu382EAQTbXYWMb1UjVl88XeW2AXHZhmqona2dh4pqkIE8HwybNEfFSD/mPQ534mB
         sy0nqkEO6JdXATEcCHoeooSrIIkElARWCkrfoaTrKPIw0aTkPdWqr1J553ycWxeYKfpP
         Hbb7YSuCrLyjusfu9/aIovhvD0U2J/pjlLPcgOoDP7uEytJyzDdy1UHpOiQY96aJ1iGr
         TzujnWZ5Kuo1jryKggdVJRI9lCnKEajvBkOGH71L0wvtSNUYktR2LhXYXMyhn7XMCtuG
         1o7g==
X-Gm-Message-State: AOAM531uXYJNEf4azqoq6Da4z1yvmBXMrZKUs+1tp1U3ArzWi+xBlCbD
        aaXusQ2wTrO4WQR3knUpxL0=
X-Google-Smtp-Source: ABdhPJxMpJ7L5jn2SeUckB3/ATIQ7y2xuOfZduQN+SaPkdoKbJ8RGZAPGbAiTlRVMkIfyD2CcpYQ/g==
X-Received: by 2002:a17:907:7fa8:: with SMTP id qk40mr37746912ejc.445.1634109481855;
        Wed, 13 Oct 2021 00:18:01 -0700 (PDT)
Received: from localhost.localdomain (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id f7sm2935886edl.33.2021.10.13.00.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:18:01 -0700 (PDT)
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        Ruud Bos <kernel.hbk@gmail.com>
Subject: [PATCH net-next RESEND 0/4] igb: support PEROUT and EXTTS PTP pin functions on 82580/i354/i350
Date:   Wed, 13 Oct 2021 09:15:27 +0200
Message-Id: <20211013071531.1145-1-kernel.hbk@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The igb driver provides support for PEROUT and EXTTS pin functions that
allow adapter external use of timing signals. At Hottinger Bruel & Kjaer we
are using the PEROUT function to feed a PTP corrected 1pps signal into an
FPGA as cross system synchronized time source.

Support for the PEROUT and EXTTS SDP functions is currently limited to
i210/i211 based adapters. This patch series enables these functions also
for 82580/i354/i350 based ones. Because the time registers of these
adapters do not have the nice split in second rollovers as the i210 has,
the implementation is slightly more complex compared to the i210
implementation.

The PEROUT function has been successfully tested on an i350 based ethernet
adapter. Using the following user space code excerpt, the driver outputs a
PTP corrected 1pps signal on the SDP0 pin of an i350:

    struct ptp_pin_desc desc;
    memset(&desc, 0, sizeof(desc));
    desc.index = 0;
    desc.func = PTP_PF_PEROUT;
    desc.chan = 0;
    if (ioctl(fd, PTP_PIN_SETFUNC, &desc) == 0) {
        struct timespec ts;
        if (clock_gettime(clkid, &ts) == 0) {
            struct ptp_perout_request rq;
            memset(&rq, 0, sizeof(rq));
            rq.index = 0;
            rq.start.sec = ts.tv_sec + 1;
            rq.start.nsec = 500000000;
            rq.period.sec  = 1;
            rq.period.nsec = 0;
            if (ioctl(fd, PTP_PEROUT_REQUEST, &rq) == 0) {
                /* 1pps signal is now available on SDP0 */
            }
        }
    }

The added EXTTS function has not been tested. However, looking at the data
sheets, the layout of the registers involved match the i210 exactly except
for the time registers mentioned before. Hence the almost identical
implementation.

Ruud Bos (4):
  igb: move SDP config initialization to separate function
  igb: move PEROUT and EXTTS isr logic to separate functions
  igb: support PEROUT on 82580/i354/i350
  igb: support EXTTS on 82580/i354/i350

 drivers/net/ethernet/intel/igb/igb_main.c | 141 ++++++++++++-----
 drivers/net/ethernet/intel/igb/igb_ptp.c  | 183 ++++++++++++++++++++--
 2 files changed, 279 insertions(+), 45 deletions(-)

-- 
2.30.2

