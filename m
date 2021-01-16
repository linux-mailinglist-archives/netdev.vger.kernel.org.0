Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8377E2F8D5D
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 13:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbhAPMuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 07:50:11 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45046 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbhAPMuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 07:50:11 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610801369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vx9AoQvn62Gkzabwau/eg+2bKejzKDeB4GD6k8uqjCg=;
        b=VRa3lm8/NWVhMLFwsso5P2/QvvDYar3Wa5xtAFULcahfNWzvDz6YcJSrDCoFQsjABCMqom
        NRSJxqsXmi1+YIp/8DobZajkw0xQ3yrwwWS0iHJtrDo/8HS7yXio5eXeyadr0VkyAleLOs
        GW7RvmpnvEqW39NlzL+eY3O4Sj1vY/ecP6hQRpg3akdi5TfYbRdqM2rx0DYKQnuo0iOXFh
        WyfdvrSsBUzK1LomOFsZtZ0ldTjEBnvzgWv79k5c1FOKUqRIQhnM+hrH9QsCDTv05lrVqk
        w0X7tRUANFvTTmBKqSU3nvuxZSu/C8wvZZSKBsHOjMUrdFT3YF+TVxgsYLGEXw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610801369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vx9AoQvn62Gkzabwau/eg+2bKejzKDeB4GD6k8uqjCg=;
        b=81pa4BIejklwDHy+zbA84mAE55xvyXTgtauUFKatpe86kG5wAgf2Gw+JmEs1LiQE9l1bTh
        Bcy0l57EXZLW7eAw==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 net-next 0/1] net: dsa: hellcreek: Add TAPRIO offloading
Date:   Sat, 16 Jan 2021 13:49:21 +0100
Message-Id: <20210116124922.32356-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The switch has support for the 802.1Qbv Time Aware Shaper (TAS). Traffic
schedules may be configured individually on each front port. Each port has eight
egress queues. The traffic is mapped to a traffic class respectively via the PCP
field of a VLAN tagged frame.

Previous attempts:

 * https://lkml.kernel.org/netdev/20201121115703.23221-1-kurt@linutronix.de/

Changes since v1:

 * Use taprio data structure
 * Calculate base_time if in past
 * Validate input parameters
 * Minor things

Kurt Kanzenbach (1):
  net: dsa: hellcreek: Add TAPRIO offloading support

 drivers/net/dsa/hirschmann/hellcreek.c | 298 ++++++++++++++++++++++++-
 drivers/net/dsa/hirschmann/hellcreek.h |  11 +-
 2 files changed, 307 insertions(+), 2 deletions(-)

-- 
2.20.1

