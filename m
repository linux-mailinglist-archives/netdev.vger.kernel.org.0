Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DB22C55E1
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390286AbgKZNi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390243AbgKZNi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:38:58 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF86C0617A7
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:38:58 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id s13so2435486wmh.4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eLYy9GrW221tE7bgw0J/86UTqSktvqRhGJxBlLeC3CQ=;
        b=l8uEDUWZzvTPhQEmHkZEDzGn+Iktals9WkH8ixtmNOmOetN+vKndogKyVo59zGXYLz
         XRXvLUk5/+I04WWy7FCL0sLq4G94vw7QdXKfevLaySsnixEVKYZjC38zOVHNwqTkRYLN
         La8EC6Kxt6FBWP9D25iK6dlCY0QSnmFPjI0JmdW+T/tdAWhzrLYaOiJHbt1NLSwEkhEx
         Y5DRG1yTcLpH7SVmPZVFWQDYEG3aMUf+bQ4cF2ARtkMOy6ywbUIdkC/0GkwZWXKV+ZrI
         GJxdb71yq3kNI4ucwGOAP83wwCKHEcGCH1dgmfnG+q6ylSw4bmYBixyYObvyjE2aYJuI
         JqmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eLYy9GrW221tE7bgw0J/86UTqSktvqRhGJxBlLeC3CQ=;
        b=rGcXpEB22538ofdxyeu856w/xiyFBCsC9kRcBH7SPLikESEpEUuz6+uVrCGHV5ARcS
         SYYj6NBoHSdQ3hYMLW3Xygetv1Y9f7jqnOxCEQPITISNW6eKn9s/Er2lpyldZLgnYVc8
         8yZIxJDLKEfTAtK7bTc/mWokm4sWs3rqFAb4qU7FoIpnEtlZPlspUQeJKCpNWB8Yns4k
         X5XsS1JgeSLvYDjSvDR0fWHwXVKhCQUofOGU/5lOLVEDUnA+qGheVCuGW7ta1z5FKpku
         IoHi0DI89BSO7v5iW32+ZygqLybejS4vhqH3qB3qoNTDNZyCaVndtuC5xbM5Gmmp8kWk
         SVdg==
X-Gm-Message-State: AOAM530ki3LY/JSPEg8m76hlFd550PeXYkQsyMwQwmyUR+wA4H+5t4vn
        Ik3/8fwme2pGJVBpF+Qf1F9WqQ==
X-Google-Smtp-Source: ABdhPJyX27kWdIdFacrNhU+B2wpKeoJmDR9OAO7qJiUZ6oA3MPy3XKvt03Krjrfl2kApfFtGjVazXw==
X-Received: by 2002:a1c:dc82:: with SMTP id t124mr3481528wmg.94.1606397937237;
        Thu, 26 Nov 2020 05:38:57 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id s133sm7035825wmf.38.2020.11.26.05.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:38:56 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Dany Madden <drt@linux.ibm.com>,
        Daris A Nevil <dnevil@snmc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Erik Stahlman <erik@vt.edu>,
        Geoff Levand <geoff@infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Allen <jallen@linux.vnet.ibm.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Lijun Pan <ljp@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>, Paul Durrant <paul@xen.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Cammaert <pc@denkart.be>,
        Russell King <rmk@arm.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Santiago Leon <santi_leon@yahoo.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Wei Liu <wei.liu@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH 0/8] Rid W=1 warnings in Net
Date:   Thu, 26 Nov 2020 13:38:45 +0000
Message-Id: <20201126133853.3213268-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resending the stragglers.

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

Lee Jones (8):
  net: ethernet: smsc: smc91x: Demote non-conformant kernel function
    header
  net: xen-netback: xenbus: Demote nonconformant kernel-doc headers
  net: ethernet: ti: am65-cpsw-qos: Demote non-conformant function
    header
  net: ethernet: ti: am65-cpts: Document am65_cpts_rx_enable()'s 'en'
    parameter
  net: ethernet: ibm: ibmvnic: Fix some kernel-doc misdemeanours
  net: ethernet: toshiba: ps3_gelic_net: Fix some kernel-doc
    misdemeanours
  net: ethernet: toshiba: spider_net: Document a whole bunch of function
    parameters
  net: ethernet: ibm: ibmvnic: Fix some kernel-doc issues

 drivers/net/ethernet/ibm/ibmvnic.c           | 27 ++++++++++----------
 drivers/net/ethernet/smsc/smc91x.c           |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-qos.c      |  2 +-
 drivers/net/ethernet/ti/am65-cpts.c          |  2 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c |  9 ++++---
 drivers/net/ethernet/toshiba/spider_net.c    | 18 ++++++++-----
 drivers/net/xen-netback/xenbus.c             |  4 +--
 drivers/net/xen-netfront.c                   |  6 ++---
 8 files changed, 37 insertions(+), 33 deletions(-)

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: bpf@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dany Madden <drt@linux.ibm.com>
Cc: Daris A Nevil <dnevil@snmc.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Erik Stahlman <erik@vt.edu>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Allen <jallen@linux.vnet.ibm.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Kurt Kanzenbach <kurt@linutronix.de>
Cc: Lijun Pan <ljp@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: netdev@vger.kernel.org
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Paul Durrant <paul@xen.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Cammaert <pc@denkart.be>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Santiago Leon <santi_leon@yahoo.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc: Thomas Falcon <tlfalcon@linux.vnet.ibm.com>
Cc: Utz Bacher <utz.bacher@de.ibm.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: xen-devel@lists.xenproject.org
-- 
2.25.1

