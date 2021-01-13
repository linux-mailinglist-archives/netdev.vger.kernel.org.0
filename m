Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6037F2F502E
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 17:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbhAMQmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 11:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727527AbhAMQmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 11:42:09 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE3CC061786
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:41:29 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id r3so2833623wrt.2
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VH2FQtV9QAPgHDpG8J2TH6UYciFbrGSHFdOWafzf8L0=;
        b=mgWrFTRdLTo53CvivpWWpGvsnBy/sDUJBspvULY4feH6SbFZS7E8cSPYam9a5jpklb
         kqxz5+5Hc26gNe3UcOqgusUkt7Ziejsa7lie23otmOkvPtir46B1POMr13XSd0a8IEW7
         tFqivez7ig+l/Yu5jKTarybJkbTcy3RgaqCPmtjRg2u0TqPP5qmgVy1b3ErpV0pBVHmI
         5TtapSlZlEosS6jB5aYIPr45RihABmY9w53n2+ZOI6kXcfhjxDFk0/jx0MSjQWIaWGxJ
         kfUHXACCiKmAWR/WOIPTsUaSGUcx1Tvs4u5jbxrAqqHl3wPj/+iimviABCXYtr63aizN
         y4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VH2FQtV9QAPgHDpG8J2TH6UYciFbrGSHFdOWafzf8L0=;
        b=pWV6YBeOe3OKIed47vKwUcmSNcx7twFrlLuHpq6K2k8/7HYh8gjQUo5teXGbhpXbss
         gTv0T5KZ0uFs/ylszbd9TQf59xV4vVVx5L81VQRxif3k/CRcrCRqwLG8jmEnvxK16Qz1
         qW+6N/za6ZPbBoy2yioZKdHTGmDT4KQEw29C/kFevLP/LHW/Oa7IBda77CoX3XF2/mwl
         hUrYi8fm7iXyo6oKu0iTCu6Y4RYCQjth1PFVpQ1BpBhUTiKDOI3OC2FWvvsG+039CMd8
         /8uLJmXrPq2vZl1Jr2yj9rWS2hucOyYzkVEeFuXs5Qp1xUuRRt+gB4d5E0V9Vtm64Dqs
         5E7g==
X-Gm-Message-State: AOAM531XOsuZvYNnTwyR+8/sGfvzhACi09pXJk6KpB+Yl6i9CHS7rleO
        MhRyIXIcbSnIJLc+9+W8b0d9mg==
X-Google-Smtp-Source: ABdhPJxhdh6nQ0ZeDfEEeSe5MD+NUFjp0Ab5CLvQ9W4maua5nayIueG0xrQYYgqoBCc5WqlU293mGw==
X-Received: by 2002:adf:82c8:: with SMTP id 66mr3473402wrc.420.1610556087746;
        Wed, 13 Jan 2021 08:41:27 -0800 (PST)
Received: from dell.default ([91.110.221.229])
        by smtp.gmail.com with ESMTPSA id t16sm3836510wmi.3.2021.01.13.08.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 08:41:26 -0800 (PST)
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
Subject: [PATCH v2 0/7] Rid W=1 warnings in Ethernet 
Date:   Wed, 13 Jan 2021 16:41:16 +0000
Message-Id: <20210113164123.1334116-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resending the stragglers again.                                                                                  

This set is part of a larger effort attempting to clean-up W=1                                                   
kernel builds, which are currently overwhelmingly riddled with                                                   
niggly little warnings.                                                                                          
                                                                                                                 
v2:                                                                                                              
 - Squashed IBM patches                                                                                      
 - Fixed real issue in SMSC
 - Added Andrew's Reviewed-by tags on remainder

Lee Jones (7):
  net: ethernet: smsc: smc91x: Fix function name in kernel-doc header
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

 drivers/net/ethernet/ibm/ibmvnic.c           | 27 ++++++++++----------
 drivers/net/ethernet/smsc/smc91x.c           |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-qos.c      |  2 +-
 drivers/net/ethernet/ti/am65-cpts.c          |  2 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c |  8 +++---
 drivers/net/ethernet/toshiba/spider_net.c    | 18 ++++++++-----
 drivers/net/xen-netback/xenbus.c             |  4 +--
 drivers/net/xen-netfront.c                   |  6 ++---
 8 files changed, 37 insertions(+), 32 deletions(-)

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

