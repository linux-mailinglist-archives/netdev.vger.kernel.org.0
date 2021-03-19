Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C32A341199
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 01:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbhCSAtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 20:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbhCSAst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 20:48:49 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0210C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:48 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so4010655pjv.1
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=UgAG7v2l83IJ37i0D5nD7+8M8bro+UO5f13PwlM98p4=;
        b=kJRjuBjYdJEo+Fg1G7acXirNtc0FX9+81njD7gI1oIOFyDEoeRl/E03cUF2vUwhjgU
         KfFuvua3TudhP+/Tfx8f0c0TzbsbixfCivz3acxKMFSCwOagaUNj0dhKLd+abiNwUa7L
         uOvSCyv9fllk3djZH1OJ114F/X5MOzvnFwykEye/GybhU+wInlbpxaY5umR5nBF7rFVS
         RSxfNbHFM0DpC0E62tfeGlfdvDctMg3notFJPaV6DErvmw8QY4XYzP8RRdGUtqebXhfq
         CadF4N5k0aajMYEL5JtlHZex18LKvNQI3qBEH7YN+1gqonscGwtE8kh2texu1nrNlVMe
         KaOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UgAG7v2l83IJ37i0D5nD7+8M8bro+UO5f13PwlM98p4=;
        b=sgByyc9rLZJ944GOMDhpjd6OyMs5ob/yubpo5JFKxnEc2lK8Ltq1jKufDXKVgcNkUN
         gu5h/WMsngiLhZO43RvXzvYwhBrG7emQbUNVrX+C+VOLcBr1B1Tpv1jxFbRj4U2Wvj5x
         iY01RueskWf6SWroek/9McvG6In1o0OmilGlWu0RXg8S6GrJpCnG3hjmExNl2Looj98k
         y5HNKtLghQXPuj/ZpxiaGJhRcQ0/4+RP8L0C+E6UEujx0Xr02kztE1rtzD8TuV1O3iMI
         eBkWb+J51cEBSgK3zYClUgl/35ix+9YmuT/sIKPbzcIo5LrSwEkiHEnGWdTdyq4p12AB
         Ui6w==
X-Gm-Message-State: AOAM530waPydrRKBXEQmR/8T3E+Duy6ij8JXrWaLPWdIzEjmih50Zrep
        bM2qvcrNPaZbl63zP2PomCLcnlBJSUColQ==
X-Google-Smtp-Source: ABdhPJz19g7ea00ooMHHQhKNG5P/QrcpIRatnr5rZyeafhvL+zyrlApS+VgPBgkRtoEAC44vdT5pTA==
X-Received: by 2002:a17:90a:fe05:: with SMTP id ck5mr7350728pjb.19.1616114928237;
        Thu, 18 Mar 2021 17:48:48 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i7sm3592949pfq.184.2021.03.18.17.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 17:48:47 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/7] ionic fixes
Date:   Thu, 18 Mar 2021 17:48:03 -0700
Message-Id: <20210319004810.4825-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few little fixes and cleanups found while working
on other features and more testing.

Shannon Nelson (7):
  ionic: code cleanup details
  ionic: simplify the intr_index use in txq_init
  ionic: fix unchecked reference
  ionic: update ethtool support bits for BASET
  ionic: block actions during fw reset
  ionic: stop watchdog when in broken state
  ionic: protect adminq from early destroy

 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  4 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  8 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 16 ++--
 .../net/ethernet/pensando/ionic/ionic_if.h    | 28 +++----
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 77 +++++++++++++------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  1 +
 .../net/ethernet/pensando/ionic/ionic_main.c  | 22 ++++--
 7 files changed, 105 insertions(+), 51 deletions(-)

-- 
2.17.1

