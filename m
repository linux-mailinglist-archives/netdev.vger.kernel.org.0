Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1CE1000CE
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfKRI46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:56:58 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40558 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfKRI46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 03:56:58 -0500
Received: by mail-pf1-f193.google.com with SMTP id r4so10058145pfl.7
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 00:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=/OAa2XIphWJAWmfBP8BbdFxgIsQTIQIFb1f/FfWq8cg=;
        b=SxGs4CEeqrwU3+6P/VSVUGfINbyriv5QrdHsaTGTpkFpvYUocGDstHXSntVeMssywC
         4YC0qpGeYntB98aLWI0UJC++R+x4xNI3/ieHYFRBxpVB7eFZOj8SHn2SM85iY16lmn+i
         h2Hcj/xr1ZCLKx2SBLH/NY6cVCZDOa5+p1FQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/OAa2XIphWJAWmfBP8BbdFxgIsQTIQIFb1f/FfWq8cg=;
        b=M4QFCcRs7/BMPjDwGz9qgeUOrhbZ0aFGg18NBwoqptNXZRsKPbOj/W02Eii6uQATjD
         J7rcGftizjbr5z/cvXcMVJvSnlQyNXOL7kNHZtji9F3uJh+SUNawLzTt56OZM+Q7PAEF
         vVOl1fQJH4pja5o2qmPxbkQhfyszAdZ1UidG177HCNduMMIFFYZ+Qy0eiw4REbKiAZlu
         Nw8/A7NK7c8B+IQWe9VLjCkywB7G59SCGhmq577Lg+EPEi6hj2thG3FPlbpM1smP0IF0
         JADfa6q5pcd9Dz+F6YEKe07CYqo+5Amt8o/WljZjHQg72hAj21oNC3V2DAUytvYLsr6/
         iAmQ==
X-Gm-Message-State: APjAAAUo8pkwLm45Xno2F5J4a2huy52MyhqA+v59g2On9OpeIMSiA4ZG
        /HZww1tLPVpkvAMn7XyRvBb2KWKQO4U=
X-Google-Smtp-Source: APXvYqxlf3mSodI0ZY2Bw0sz2IuZMDltrpHcaRn2PZNA8ZtkjdpYf/Try39jzoR62cxKZfP1/WWkPw==
X-Received: by 2002:a62:ed16:: with SMTP id u22mr28401084pfh.28.1574067416563;
        Mon, 18 Nov 2019 00:56:56 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q41sm19120230pja.20.2019.11.18.00.56.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 00:56:56 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/9] bnxt_en: Updates.
Date:   Mon, 18 Nov 2019 03:56:34 -0500
Message-Id: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series has the firmware interface update that changes the aRFS/ntuple
interface on 57500 chips.  The 2nd patch adds a counter and improves
the hardware buffer error handling on the 57500 chips.  The rest of the
series is mainly enhancements on error recovery and firmware reset.

Michael Chan (2):
  bnxt_en: Update firmware interface spec to 1.10.1.12.
  bnxt_en: Improve RX buffer error handling.

Pavan Chebbi (1):
  bnxt_en: Abort waiting for firmware response if there is no heartbeat.

Vasundhara Volam (6):
  bnxt_en: Increase firmware response timeout for coredump commands.
  bnxt_en: Extend ETHTOOL_RESET to hot reset driver.
  bnxt_en: Set MASTER flag during driver registration.
  bnxt_en: Report health status update after reset is done
  bnxt_en: Return proper error code for non-existent NVM variable
  bnxt_en: Add a warning message for driver initiated reset

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 47 +++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  9 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 30 ++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 14 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h     | 95 +++++++++++++++--------
 6 files changed, 145 insertions(+), 51 deletions(-)

-- 
2.5.1

