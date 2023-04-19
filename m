Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2C16E7E2C
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbjDSPYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbjDSPY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:24:27 -0400
Received: from synguard (unknown [212.29.212.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A06665BF;
        Wed, 19 Apr 2023 08:23:48 -0700 (PDT)
Received: from dali.siklu.local (dali.siklu.local [192.168.42.30])
        by synguard (Postfix) with ESMTP id 3CCF14DFC5;
        Wed, 19 Apr 2023 18:14:59 +0300 (IDT)
From:   Shmuel Hazan <shmuel.h@siklu.com>
To:     Russell King <linux@armlinux.org.uk>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Shmuel Hazan <shmuel.h@siklu.com>
Subject: [PATCH v3 0/3] net: mvpp2: tai: add extts support 
Date:   Wed, 19 Apr 2023 18:14:54 +0300
Message-Id: <20230419151457.22411-1-shmuel.h@siklu.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,RDNS_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for PTP event capture on the Aramda
80x0/70x0. This feature is mainly used by tools linux ts2phc(3) in order
to synchronize a timestamping unit (like the mvpp2's TAI) and a system
DPLL on the same PCB. 

The patch series includes 3 patches: the second one implements the
actual extts function.

Changes in v2:
	* Fixed a deadlock in the poll worker.
	* Removed tabs from comments.

Changes in v3:
	* Added more explanation about the change in behavior in mvpp22_tai_start.
	* Explain the reason for choosing 95ms as a polling rate.

Shmuel Hazan (3):
  net: mvpp2: tai: add refcount for ptp worker
  net: mvpp2: tai: add extts support
  dt-bindings: net: marvell,pp2: add extts docs

 .../devicetree/bindings/net/marvell,pp2.yaml  |  18 +
 .../net/ethernet/marvell/mvpp2/mvpp2_tai.c    | 334 ++++++++++++++++--
 2 files changed, 317 insertions(+), 35 deletions(-)


base-commit: 3e7bb4f2461710b70887704af7f175383251088e
-- 
2.40.0

