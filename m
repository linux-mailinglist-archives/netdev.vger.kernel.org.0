Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83CE4FCE02
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKNSpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:45:11 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36728 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfKNSpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:45:10 -0500
Received: by mail-pg1-f196.google.com with SMTP id k13so4349975pgh.3
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wDwYkwxW0FxWLyE3I8m+kCLGsDG+n2ImaTBPf/mcEVk=;
        b=GgJV72BuHJJp+UqwsWqxhsCz/9TI9AARKZs0gXDWAnzYYo5Gia6DMl7m8k5Tv8KzSw
         NEMZAwt3LxpBgL7ENtWfg1Xkpnn3hChod84Jdw95rzyIc6cNQFOWALR4+xxTLNgKcfmu
         dro3XzbVjse/GgHlk3GmEltz3/zWdjoHv0ejOVMx3+cpg+ERGao2KL16AAni+zSVhGb+
         oR0pq1Wo7dn4j8rMhQZtfs+wkJBenV5KY3h0NQrkk0VEhnuTJFtMfS0q41SKSn5XvOn6
         f4hvpbMw8vhBN3JAHnxDTC6LwOrAGsjtW3AF6kzRUrlG2sTkVK6LzkQcWM0XzY3STiNu
         c6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wDwYkwxW0FxWLyE3I8m+kCLGsDG+n2ImaTBPf/mcEVk=;
        b=IopNJO/VQQ1E9sVK7s7XqIDU6B5vzNcQhMQu1aPtiCOH6yXQlY6k2ufnXDOjVg0CVE
         5xWYHKOk+C/3XYyD8HE+Yy7dRSrVYvRfFBEWqZiX5tgUq9DZRUsOKImyAqsWeHfJr5F0
         BfM/VbPbQ5Jed97dlVal7tGGMK9Yq/PIYhXfLqCN1AfDSNQXVZ98X+by1w/dKxHIyPYL
         PqziflA/+wRjS4ejuGwAdMNyq4g7icAuiKBrpPK9bn13k8ggoAekpvusFiVnB/3YOtww
         Z6RFt/PeYEp3PAH7oNyhBYKO+bBndVvhk47adv8HK0TJrCz0PMWYgzoBW6X1bLSUlgEf
         Xq6w==
X-Gm-Message-State: APjAAAX5v2oIOcjR9qTcOA8PuzuIGvsw//qQc1LvPjRA+en3C0AZBKPo
        pQUHLY/geoONAPuYpbZmcFA6LuLB
X-Google-Smtp-Source: APXvYqwrUQaGEG3u5iMQy/fmgl1b2cO67i+m2RTiIx5cndf7jM7+Fv2AxcOgtwLPzNdYxDmxMzNKYQ==
X-Received: by 2002:a17:90a:970a:: with SMTP id x10mr933679pjo.39.1573757109680;
        Thu, 14 Nov 2019 10:45:09 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 23sm6819507pgw.8.2019.11.14.10.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:45:08 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org,
        David Miller <davem@davemloft.net>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Christopher Hall <christopher.s.hall@intel.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Stefan Sorensen <stefan.sorensen@spectralink.com>
Subject: [PATCH net 00/13] ptp: Validate the ancillary ioctl flags more carefully.
Date:   Thu, 14 Nov 2019 10:44:54 -0800
Message-Id: <20191114184507.18937-1-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flags passed to the ioctls for periodic output signals and
time stamping of external signals were never checked, and thus formed
a useless ABI inadvertently.  More recently, a version 2 of the ioctls
was introduced in order make the flags meaningful.  This series
tightens up the checks on the new ioctl flags.

- Patch 1 ensures at least one edge flag is set for the new ioctl.
- Patches 2-7 are Jacob's recent checks, picking up the tags.
- Patch 8 introduces a "strict" flag for passing to the drivers when the
  new ioctl is used.
- Patches 9-12 implement the "strict" checking in the drivers.
- Patch 13 extends the test program to exercise combinations of flags.

Jacob Keller (6):
  net: reject PTP periodic output requests with unsupported flags
  mv88e6xxx: reject unsupported external timestamp flags
  dp83640: reject unsupported external timestamp flags
  igb: reject unsupported external timestamp flags
  mlx5: reject unsupported external timestamp flags
  renesas: reject unsupported external timestamp flags

Richard Cochran (7):
  ptp: Validate requests to enable time stamping of external signals.
  ptp: Introduce strict checking of external time stamp options.
  mv88e6xxx: Reject requests to enable time stamping on both edges.
  dp83640: Reject requests to enable time stamping on both edges.
  igb: Reject requests that fail to enable time stamping on both edges.
  mlx5: Reject requests to enable time stamping on both edges.
  ptp: Extend the test program to check the external time stamp flags.

 drivers/net/dsa/mv88e6xxx/ptp.c               | 13 +++++
 drivers/net/ethernet/broadcom/tg3.c           |  4 ++
 drivers/net/ethernet/intel/igb/igb_ptp.c      | 17 ++++++
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 17 ++++++
 drivers/net/ethernet/microchip/lan743x_ptp.c  |  4 ++
 drivers/net/ethernet/renesas/ravb_ptp.c       | 11 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  |  4 ++
 drivers/net/phy/dp83640.c                     | 16 ++++++
 drivers/ptp/ptp_chardev.c                     | 20 +++++--
 include/uapi/linux/ptp_clock.h                |  5 +-
 tools/testing/selftests/ptp/testptp.c         | 53 ++++++++++++++++++-
 11 files changed, 156 insertions(+), 8 deletions(-)

-- 
2.20.1

