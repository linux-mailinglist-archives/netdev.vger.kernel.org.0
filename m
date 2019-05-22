Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE976272C4
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfEVXNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:13:09 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:35757 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbfEVXNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:13:09 -0400
Received: by mail-pl1-f170.google.com with SMTP id p1so1789723plo.2
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=dK7yJjdMEYAAO1ll+nlvhvSae5uj0B6n5OOJSg0nGrc=;
        b=R2lkyn89EabBH50ufpRx+CPsapo4XCdGfXi8TQRtYmHAb4pxXjRlErV0TkDJSiSTEw
         uDNwvr0MqpBjlxVtKJCmUgPW4cSnG4+0Wy9qn5Ht3XYNWGVBTHbCzHPDdwk0tcUZ3VRi
         GBufDv5kW97DwKMdJw8+UsVAcQYkjhDoxJTQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dK7yJjdMEYAAO1ll+nlvhvSae5uj0B6n5OOJSg0nGrc=;
        b=R4ns1+Hnsa0yXq72jX7s5xOOYTPOJutZMNgs5mVBF1IYbZhq7Wc2R47UySHEUOSuXg
         4AWIsK4pAiyp2rEOPDqSM/rQD9Ym6GXjA9SvLwFhqRRT+O8ilSRS85St0+SyTxmwHfwj
         P+9j8qh5ZWimZFn894FJQ+NJDRJMtfBBzxLBsz5jYYkM6K6XmBS+XTaUWi8l6dF46Bth
         qAE3PQRGNzHujQ/fCAKSWzhZ7k+EzPJzKxIxHqVRRWOxiOH/qHtSj7ohyjaS02REUV8V
         2vqxoXVZpXIFcgGXyuyfhbqi91+kLWCs6HVAp5Pn3CyOYmp2MOOtNKB4+OPn+AAqCi/f
         nPCQ==
X-Gm-Message-State: APjAAAURdBZ7BBd6sRuebJMMZiV1alsQgvppmnru1hWcXSi+3DXeyQSS
        1z4fZ6p1v098F2CJWhwR9Txfmb1f/Lc=
X-Google-Smtp-Source: APXvYqyLGF3hazXUlBBselUZmYTlpZSzf14/PIJnmn1igVGN3XJeDyYyOB8Sp2UQj3QLL1TCkt3obg==
X-Received: by 2002:a17:902:f208:: with SMTP id gn8mr94221286plb.312.1558566788247;
        Wed, 22 May 2019 16:13:08 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q20sm27750419pgq.66.2019.05.22.16.13.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 16:13:07 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/4] bnxt_en: Bug fixes.
Date:   Wed, 22 May 2019 19:12:53 -0400
Message-Id: <1558566777-23429-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 4 driver fixes in this series:

1. Fix RX buffer leak during OOM condition.
2. Call pci_disable_msix() under correct conditions to prevent hitting BUG.
3. Reduce unneeded mmeory allocation in kdump kernel to prevent OOM.
4. Don't read device serial number on VFs because it is not supported.

Please queue #1, #2, #3 for -stable as well.  Thanks.

Michael Chan (3):
  bnxt_en: Fix aggregation buffer leak under OOM condition.
  bnxt_en: Fix possible BUG() condition when calling pci_disable_msix().
  bnxt_en: Reduce memory usage when running in kdump kernel.

Vasundhara Volam (1):
  bnxt_en: Device serial number is supported only for PFs.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 30 +++++++++++++----------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  6 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c     |  2 +-
 4 files changed, 23 insertions(+), 17 deletions(-)

-- 
2.5.1

