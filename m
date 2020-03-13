Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA811843F2
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 10:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgCMJm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 05:42:58 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36627 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgCMJm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 05:42:58 -0400
Received: by mail-pl1-f193.google.com with SMTP id g2so1486774plo.3
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 02:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=T8AP5q33K1ZSF/K7IUaq4eatlpKLkez73iEUeFTHM40=;
        b=sLMJzJ/q0OChz63Yf4mVwQhSf8kGUXE4dxwdFEF3zaPy0podfaJOJYD7APv/abWREI
         pX+kpSsgFhM54LEa++h0zPPn9bx6H9W5DDHS+7AW3TVrAJi6ru40xItaOw+UxKk9kdtr
         MXrqkDbyE/tSPSb28Y3VWgWcGNPziNo8vGeF6dA72ddkjKXejw84u31tovv2S5TYkiyw
         OinLc8OkCCu3WK8VCtrFwPX57ywxXs0iKnlV881itk/nMltce9otA9cd4bt6vLQSZfJi
         Pp4733ESYavGGYvAtDMKG0ERaTnEEOlCnGtsA+15RtQ/vB8ylg+DXPjPClQutqTD4cyu
         TKHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=T8AP5q33K1ZSF/K7IUaq4eatlpKLkez73iEUeFTHM40=;
        b=LmK++7g0+NJ5Fb2fJsUz90lAkCMmcIODcXHe91HVbf0kRmCgFwkovJnqaQeFGueDWC
         FWyAV0wnh3jLJhtVGVJppLpwfqe2VxB6RCZP5W9M0IC7eEXP8YSnHVTUnyZgt3EwEdoU
         v7tqdprWFxBK8M100Rb+0Vn9kK+dGMxYuKWKwkjfseLgNWRSt7C17W5eJVOLod3nwlqI
         e+TnapNehIbc20rsv6g+6CvPoayaWHsFITCyDs4YkwcFjDeF8MBoPix4Wf7zJKjFPBaC
         u+kETnd7MrpwPW9hAm1JwI+csyPpZRwvOT+M29tSlOlzWdm8320399yyoVOk2GLmCelJ
         dYcg==
X-Gm-Message-State: ANhLgQ3tp6nwRysyvCcmj1oF3v2Ylm/Ljc1s2xdyMcNWTBO8i4BGwxol
        0nkTR8UJ4X2hSbI9+empUAZv33cuGVU=
X-Google-Smtp-Source: ADFU+vu2likb+YcmLcnAYIn3KoalBAbIn5XY0fPxNpuullyhlOywijjUPUapQlT+MNVu2cHzh4XlSw==
X-Received: by 2002:a17:902:a40e:: with SMTP id p14mr12482296plq.295.1584092574772;
        Fri, 13 Mar 2020 02:42:54 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v67sm13896386pfc.120.2020.03.13.02.42.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 13 Mar 2020 02:42:54 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 net-next 0/7] octeontx2-vf: Add network driver for virtual function
Date:   Fri, 13 Mar 2020 15:12:39 +0530
Message-Id: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This patch series adds  network driver for the virtual functions of
OcteonTX2 SOC's resource virtualization unit (RVU).

Changes from v1:
   * Removed driver version and fixed authorship
   * Removed driver version and fixed authorship in the already
     upstreamed AF, PF drivers.
   * Removed unnecessary checks in sriov_enable and xmit fn()s.
   * Removed WQ_MEM_RECLAIM flag while creating workqueue.
   * Added lock in tx_timeout task.
   * Added 'supported_coalesce_params' in ethtool ops.
   * Minor other cleanups.
	- Sugested by Jakub Kicinski

Geetha sowjanya (2):
  octeontx2-pf: Handle VF function level reset
  octeontx2-pf: Cleanup all receive buffers in SG descriptor

Sunil Goutham (2):
  octeontx2-pf: Enable SRIOV and added VF mbox handling
  octeontx2-af: Remove driver version and fix authorship

Tomasz Duszynski (3):
  octeontx2-vf: Virtual function driver support
  octeontx2-vf: Ethtool support
  octeontx2-vf: Link event notification support

 drivers/net/ethernet/marvell/octeontx2/Kconfig     |   6 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   4 +-
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   2 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  23 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  27 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 133 +++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 774 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  13 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  35 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   | 663 ++++++++++++++++++
 10 files changed, 1662 insertions(+), 18 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c

-- 
2.7.4

