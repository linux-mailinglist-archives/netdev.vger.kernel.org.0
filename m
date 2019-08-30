Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31DB7A2B98
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfH3Aqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:46:51 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54206 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfH3Aqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:46:51 -0400
Received: by mail-wm1-f66.google.com with SMTP id 10so5481962wmp.3
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rYAge61knJglqsxDo81XCUmG7KjpcP7+l5QJV175pZM=;
        b=KtdcrVKFwfVfTZkSPwX4S7y2iD0nuIBtVCzHGYcvTtUaMeUCvlnYpzn8q/8oXi0xnz
         nQH3IehoS3bQTc4XjqyDUw323SX05fX1UJsr1LCt2txnqQaNVgVP94Z6US0PsGQSXaIY
         CSr7z5L3anSg6vkRt/WQVBM3FbTX7rTWyBo8Leya3DMPRpgDUb67v0eUXMRcKBKVFiA0
         6VV5pAR1m19+uYfU5D6ce+7BIile0Cey1W02tognkvW1jdMCI+79JW7qxPXCwU0b7DPm
         He0b0XVZObB2dtsFJdQ7YMiok15/5ELYfWGsNO6FJi0lELGVtRV7zo/1uTY14xpapOLK
         pD3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rYAge61knJglqsxDo81XCUmG7KjpcP7+l5QJV175pZM=;
        b=ifyotGwRm/gjy3EWCocOp4mC0GLkxmNnpswQp2nqNy9lkt0kw2zZs3hyLbeelC9N5o
         usqF3JAW16kRc6F+cH4p3yCbeffRNWXOQXGaTKgSjDj9okkENg0EW8jHiwMN8LSiraE3
         0gaOhF0DfJtaL5JC+TV/pLfY86Ozo0+084XWEyEVfsYwcba2fKJoWTqvnIlysd3BBaiI
         ndkiA3hDGTs8YkaPR4m+RljoHrCSj/+U+0kZc9qBtwikUfAiM8ISKGgqVKIBb85d3uHF
         JSddIvHqFvz98Hguk1Cv/pn7YJ6GGsLoeCqLUYCGM1RU5xct/9HZP2hanS8vvkNBsykE
         qD0Q==
X-Gm-Message-State: APjAAAVAf1khVvKprmkl0k0S0ewluxOcIj8/Hq1THypD6rANIHxeCJJL
        vbxDspaItGR2P+o4qqY2/MI=
X-Google-Smtp-Source: APXvYqz/ZQf50uj0WQFNwLGqTpDwkrz9wjK7T3uHOliT4MsHR2a7IA/rTpUQzIpixx5G5OgQRom5dQ==
X-Received: by 2002:a05:600c:144:: with SMTP id w4mr15379150wmm.94.1567126007987;
        Thu, 29 Aug 2019 17:46:47 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id y3sm9298442wmg.2.2019.08.29.17.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:46:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        --to=jhs@mojatatu.com, --to=xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH v2 net-next 00/15] tc-taprio offload for SJA1105 DSA
Date:   Fri, 30 Aug 2019 03:46:20 +0300
Message-Id: <20190830004635.24863-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the v2 of the patchset from July:
https://lists.openwall.net/netdev/2019/07/07/81

Changes:
- Adapted the taprio offload patch to work by specifying "flags 2" to
  the iproute2-next tc. At the moment I don't clearly understand whether
  the full offload and the txtime assist ("flags 1") are mutually
  exclusive or not (i.e. whether a "flags 3" mode should be rejected,
  which it currently isn't).
- Added reference counting to the taprio offload structure. Maybe the
  function names and placement could have been better though. As for the
  other complaint (cycle time calculation) it got fixed in the taprio
  parser in the meantime.
- Converted sja1105 to use the hardware PTP registers, and save/restore
  the PTP time across resets.
- Made the DSA callback for ndo_setup_tc a bit more generic, but I don't
  know whether it fulfills expectations. Drivers still can't do blocking
  operations in its execution context.
- Added a state machine for starting/stopping the scheduler based on the
  last command run on the PTP clock.

For those who want to follow along with the hardware implementation, the
manual is here:
https://www.nxp.com/docs/en/user-guide/UM10944.pdf

Original cover letter:

Using Vinicius Costa Gomes' configuration interface for 802.1Qbv (later
resent by Voon Weifeng for the stmmac driver), I am submitting for
review a draft implementation of this offload for a DSA switch.

I don't want to insist too much on the hardware specifics of SJA1105
which isn't otherwise very compliant to the IEEE spec.

In order to be able to test with Vedang Patel's iproute2 patch for
taprio offload (https://www.spinics.net/lists/netdev/msg573072.html)
I had to actually revert the txtime-assist branch as it had changed the
iproute2 interface.

In terms of impact for DSA drivers, I would like to point out that:

- Maybe somebody should pre-populate qopt->cycle_time in case the user
  does not provide one. Otherwise each driver needs to iterate over the
  GCL once, just to set the cycle time (right now stmmac does as well).

- Configuring the switch over SPI cannot apparently be done from this
  ndo_setup_tc callback because it runs in atomic context. I also have
  some downstream patches to offload tc clsact matchall with mirred
  action, but in that case it looks like the atomic context restriction
  does not apply.

- I had to copy the struct tc_taprio_qopt_offload to driver private
  memory because a static config needs to be constructed every time a
  change takes place, and there are up to 4 switch ports that may take a
  TAS configuration. I have created a private
  tc_taprio_qopt_offload_copy() helper for this - I don't know whether
  it's of any help in the general case.

There is more to be done however. The TAS needs to be integrated with
the PTP driver. This is because with a PTP clock source, the base time
is written dynamically to the PTPSCHTM (PTP schedule time) register and
must be a time in the future. Then the "real" base time of each port's
TAS config can be offset by at most ~50 ms (the DELTA field from the
Schedule Entry Points Table) relative to PTPSCHTM.
Because base times in the past are completely ignored by this hardware,
we need to decide if it's ok behaviorally for a driver to "roll" a past
base time into the immediate future by incrementally adding the cycle
time (so the phase doesn't change). If it is, then decide by how long in
the future it is ok to do so. Or alternatively, is it preferable if the
driver errors out if the user-supplied base time is in the past and the
hardware doesn't like it? But even then, there might be fringe cases
when the base time becomes a past PTP time right as the driver tries to
apply the config.
Also applying a tc-taprio offload to a second SJA1105 switch port will
inevitably need to roll the first port's (now past) base time into an
equivalent future time.
All of this is going to be complicated even further by the fact that
resetting the switch (to apply the tc-taprio offload) makes it reset its
PTP time.

Vinicius Costa Gomes (1):
  taprio: Add support for hardware offloading

Vladimir Oltean (14):
  net: dsa: sja1105: Change the PTP command access pattern
  net: dsa: sja1105: Get rid of global declaration of struct
    ptp_clock_info
  net: dsa: sja1105: Switch to hardware operations for PTP
  net: dsa: sja1105: Implement the .gettimex64 system call for PTP
  net: dsa: sja1105: Restore PTP time after switch reset
  net: dsa: sja1105: Disallow management xmit during switch reset
  net: dsa: sja1105: Move PTP data to its own private structure
  net: dsa: sja1105: Advertise the 8 TX queues
  net: dsa: Pass ndo_setup_tc slave callback to drivers
  net: dsa: sja1105: Add static config tables for scheduling
  net: dsa: sja1105: Configure the Time-Aware Scheduler via tc-taprio
    offload
  net: dsa: sja1105: Make HOSTPRIO a kernel config
  net: dsa: sja1105: Make the PTP command read-write
  net: dsa: sja1105: Implement state machine for TAS with PTP clock
    source

 drivers/net/dsa/sja1105/Kconfig               |  17 +
 drivers/net/dsa/sja1105/Makefile              |   4 +
 drivers/net/dsa/sja1105/sja1105.h             |  36 +-
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |   8 +
 drivers/net/dsa/sja1105/sja1105_main.c        |  94 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c         | 345 ++++---
 drivers/net/dsa/sja1105/sja1105_ptp.h         | 103 ++-
 drivers/net/dsa/sja1105/sja1105_spi.c         |  58 +-
 .../net/dsa/sja1105/sja1105_static_config.c   | 167 ++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  48 +-
 drivers/net/dsa/sja1105/sja1105_tas.c         | 851 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_tas.h         |  74 ++
 include/linux/netdevice.h                     |   1 +
 include/net/dsa.h                             |   3 +
 include/net/pkt_sched.h                       |  33 +
 include/uapi/linux/pkt_sched.h                |   3 +-
 net/dsa/slave.c                               |  12 +-
 net/dsa/tag_sja1105.c                         |   3 +-
 net/sched/sch_taprio.c                        | 246 ++++-
 19 files changed, 1883 insertions(+), 223 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_tas.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_tas.h

-- 
2.17.1

