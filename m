Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F68243E3E8
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhJ1OkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhJ1OkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 10:40:23 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD507C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:37:56 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 5so25085986edw.7
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VZDbXMmyolFmx1o5WGp4p2BAx1Dz6AsqqfsWYE0TppQ=;
        b=kZef92Jp6vMjPikNnLW7QZ9IY91377awUFQ3/w4y6iNHnSh6W38Bui6n83a3p8DRro
         wMblVTzfyozToEn4kDTqbxPqqadNE3hXZ4bjwAWJqYJkUF+79f3MEzJJ0TiNcZEGWIGi
         NTLo2ilvBG5ei0jdqeS0BGQpV5tNoJzsP61Wfi/VuOJif5YBxZhYID/YdlkUoISKzpFc
         ZH1jsy8rHVrqQ+qIpzab16XB8MAghx/gKuoxrpEjVtQImQPbPfUTLt5LyhH4x56jeDKV
         ase6hLjvPPf9LzVclT9tUNQX9IOLiB0mSG9+mYf6wwUSr1ZQiGZl/UlDxhQ1KeS/TNiM
         t2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VZDbXMmyolFmx1o5WGp4p2BAx1Dz6AsqqfsWYE0TppQ=;
        b=HK0NHuGpLFl5zDsUZ4DvUMZ1o8CM5IyeF1e0V8Gamr64PX+zLVZOKHArh4NyR89Rer
         8upJJlDc5R5vrbJI6bgxLJFwxVl5tOWtgJ9oW8uPUZEUr18ZtqHt8Fo8eqXpj+a+oq9L
         JoYgzUWZ/VHSy41LiNLTC/ntrHFGaeGa+mVR6oz4PCG1tniqMU3UbuHMVMt8wIjUIu7F
         qe9c7ceeiG8CpHFysxFsnFvwNY+w2s3S0Y5mx8D7/wlIIXNP7x1mtyVICxi1hweW+jyV
         zCrY8121uSKwxVhoazP66+ALyHQaZMiTJHwhENhRFLAEGTItmt3NAuz4ryeOEEvRaQxB
         8D3Q==
X-Gm-Message-State: AOAM532+mUsaYesmcm6o3X82AABmU7d/h9zj9tUE8BBSuztpyTEJ3Xxk
        SYLS/IgE/rd0H9DqlNsF99c=
X-Google-Smtp-Source: ABdhPJw6s7NgADO8J9iL6+a/Vai8mcCLEdkMmOPeTWO9r4+K6Y8GtqlfGHQwmAsL2miJBHcoCKiF4w==
X-Received: by 2002:a05:6402:50c7:: with SMTP id h7mr6651903edb.191.1635431875234;
        Thu, 28 Oct 2021 07:37:55 -0700 (PDT)
Received: from localhost.localdomain (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id di12sm1514501ejc.3.2021.10.28.07.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 07:37:54 -0700 (PDT)
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        Ruud Bos <kernel.hbk@gmail.com>
Subject: [PATCH net-next v2 0/4] igb: support PEROUT and EXTTS PTP pin functions on 82580/i354/i350
Date:   Thu, 28 Oct 2021 16:34:55 +0200
Message-Id: <20211028143459.903439-1-kernel.hbk@gmail.com>
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

v2:
 - fix PEROUT on SDP2/SDP3
 - rename incorrectly named sdp function argument to tsintr_tt
 - fix white space issue

Ruud Bos (4):
  igb: move SDP config initialization to separate function
  igb: move PEROUT and EXTTS isr logic to separate functions
  igb: support PEROUT on 82580/i354/i350
  igb: support EXTTS on 82580/i354/i350

 drivers/net/ethernet/intel/igb/igb_main.c | 148 +++++++++++++----
 drivers/net/ethernet/intel/igb/igb_ptp.c  | 188 ++++++++++++++++++++--
 2 files changed, 291 insertions(+), 45 deletions(-)


base-commit: 911e3a46fb38669560021537e00222591231f456
-- 
2.30.2

