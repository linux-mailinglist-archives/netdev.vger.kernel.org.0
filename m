Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5510622AA05
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 09:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgGWHum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 03:50:42 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55918 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgGWHum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 03:50:42 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595490640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zyycNe4ZzkSfaJzBfhJ/Dm0R6COHypmems0qhZm4PMA=;
        b=SOwwHWMApmbvlHnGjg6nML2zwFVc5ltNOsUXip26Ajm9g4RtoKm8WnZyJuBbtUj9NoUodA
        Pl88uQtXbhLZPio6UCnjGf34e8YyeyWjX6ZIxdDwrfnh5x7fxrJZMOd32lmWhPeYdibmI9
        H/MtfyFESG8mcPF11BXyGRU/lrDq3O1J1VAreHOC1yxAhd0SiGU4QoTt2ppODk3GRQJwOB
        xivDt7+Dgs9BgG7zJthbTvsrbJlDRMVR6AyRUVV6V6p3BZgh0V3EtDE0sdlmgIxHc97INP
        E/OhSpKB/cjvnDIz66ThG55pPWDsuIsG42vudPgEibw28cVjYK3Gz1F+WVLXcQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595490640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zyycNe4ZzkSfaJzBfhJ/Dm0R6COHypmems0qhZm4PMA=;
        b=/9imX7FPyn0tqip+yS53yDRFgVBJrasxU/gg89VHaPbBtQZpHGCt0SJBl7zJC6eP0z59vA
        T+edVEumKpFOeeDg==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v1 0/2] ptp: Add generic header parsing function
Date:   Thu, 23 Jul 2020 09:49:44 +0200
Message-Id: <20200723074946.14253-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

in order to reduce code duplication in the ptp code of DSA drivers, move the
header parsing function to ptp_classify. This way the Marvell and the hellcreek
drivers can share the same implementation. And probably more drivers can benefit
from it. Implemented as discussed [1] [2].

@DSA maintainers: Please, have a look the Marvell code. I don't have hardware to
test it. I've tested this series only on the Hirschmann switch.

Thanks,
Kurt

[1] - https://lkml.kernel.org/netdev/20200713140112.GB27934@hoboy/
[2] - https://lkml.kernel.org/netdev/20200720142146.GB16001@hoboy/

Kurt Kanzenbach (2):
  ptp: Add generic ptp v2 header parsing function
  net: dsa: mv88e6xxx: Use generic ptp header parsing function

 drivers/net/dsa/mv88e6xxx/Kconfig    |  1 +
 drivers/net/dsa/mv88e6xxx/hwtstamp.c | 59 ++++++----------------------
 include/linux/ptp_classify.h         | 38 ++++++++++++++++++
 net/core/ptp_classifier.c            | 30 ++++++++++++++
 4 files changed, 82 insertions(+), 46 deletions(-)

-- 
2.20.1

