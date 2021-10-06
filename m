Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987AA423E55
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 15:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238545AbhJFNCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 09:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhJFNCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 09:02:41 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB36C061749
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 06:00:48 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id f9so9682560edx.4
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 06:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2ClepyIX0uc6lK4OwsOVCx3BBBolFMCVyxjiSpioOsY=;
        b=XL+Rk2tUF6MKEBsyhFifPyOvnL9nvM7zDazYGtAm5wNOCWoojWrml5uXey6s4tzuUs
         9XSVhJRzQOjVpVt8arg0O7H1EwEmi0q/TC4w6kgZzzbFGgSy6e9MukoLkdL0jS+3/m9x
         eE9VYZDiRjK3kC6WRVJnumFdN6RKm+PGa9WEEmxG5Bno0fCBUv3yMz1tQBIlFmehm4+g
         nXriGaEiIOibAVSOMSBxW+4Ef+CruFPWciYG/KTVe+ll3DM28PBLsrZorMWakI3U7xt9
         9IW5mlTVqwRJi9iovReaGdKIUfevgLdY/1GLsyAQPGUSvZGhajejnt/l8D4Eu8eSQCj4
         IilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2ClepyIX0uc6lK4OwsOVCx3BBBolFMCVyxjiSpioOsY=;
        b=WjsbuY17DcM0mbO5OOTJL0NS8Er742hTOwIMR9wPpUlHFG3Q7eEM+8wwI6KQazJtbY
         uoXJP7VeEGl4VFw7ul5LmQghR4qZjWsOb5OwE8/XD66lp8GuZxlqT00Jj6msmgvtsl3W
         nhgNjHYP3+JYjQW9kM7xqYkLMU2VzZDNnN/IAkX3elf5k15OGAVL6fHIRFwmng3vz2Sl
         52J3FSm6bvOItg+Ylal0R3ln8Dz9LSBKvzvALTyXPTnGzBZVl2vjcx5XpdYFovKHfKPo
         LWB0gZRqLvqKesZHvJ0CIKzBOk4W0dGL9XJ4j1nHuqPDRn/pf0WkJ+7Twbbj4d/QYFC1
         n+Yg==
X-Gm-Message-State: AOAM532gU//WI72MFU33H876Gys33o8Yc8/w2W/mw21jRmdsAzBoJKXI
        Rt1zm+6noeoRF6qnOYSZlLzYwKNeIEo=
X-Google-Smtp-Source: ABdhPJyeL+ZGJ+SF8I5S3KXG0lScP660cI0APVrGyek+H8OBFLO9APVYEWv20RoLdkJhteNQws5M+A==
X-Received: by 2002:a17:906:3891:: with SMTP id q17mr32564170ejd.220.1633525237842;
        Wed, 06 Oct 2021 06:00:37 -0700 (PDT)
Received: from localhost.localdomain (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id y16sm194122eds.70.2021.10.06.06.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 06:00:37 -0700 (PDT)
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        Ruud Bos <kernel.hbk@gmail.com>
Subject: [PATCH net-next 0/4] igb: support PEROUT and EXTTS PTP pin functions on 82580/i354/i350
Date:   Wed,  6 Oct 2021 14:58:21 +0200
Message-Id: <20211006125825.1383-1-kernel.hbk@gmail.com>
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
  support EXTTS on 82580/i354/i350

 drivers/net/ethernet/intel/igb/igb_main.c | 141 ++++++++++++-----
 drivers/net/ethernet/intel/igb/igb_ptp.c  | 183 ++++++++++++++++++++--
 2 files changed, 279 insertions(+), 45 deletions(-)

-- 
2.30.2

