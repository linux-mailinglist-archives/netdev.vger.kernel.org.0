Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0F5175204
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 04:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgCBDHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 22:07:31 -0500
Received: from mail-pg1-f170.google.com ([209.85.215.170]:38732 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgCBDHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 22:07:31 -0500
Received: by mail-pg1-f170.google.com with SMTP id d6so4677267pgn.5
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 19:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=0HOUcUrkVDszp28JeEEofc+9Eb7Eukcff5EEs5fpUcY=;
        b=IrgL2FYHsJlbzUaY7S/UY8CGtBr8wK286DuzQJPUOoVipvlsTZetoYBaxzw2pDIaMM
         ewtKLs391qgu4Axj+CUNXK1HXCKDXKapW8scuoQIUUx7C5PkFDCNG3OJWMJwWfzC0AyX
         4Em08Ykw+Ca/vVlr19CpbgW9L0W7VK8K4IRZ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0HOUcUrkVDszp28JeEEofc+9Eb7Eukcff5EEs5fpUcY=;
        b=rl8ED74t288Jt3gn4a0nnLPKUao25I+QKsyFDeqwyWyXdzKnzxn9Cd572WtAHx9oSY
         RJYKcC9kJyIcHAQtzVjAnVbmF7guV/s30b1MQQWKrccC6888IiZo0fvyqHFGFSphDpXL
         Z4goAU+nVVrFyzKy4eXVDAi5/DdwwnRZMhbi1851CQTyLEmzH5z5gvNCZjCgM4iiX6F1
         YL42rrnVa7H22jQ77IN7lxUhrP4E/wzsp/V88j0Sur6hfGyDvDtKrCfM2IaEvFolB0vp
         xuMtLHP9JSgHCqIqr5nSmxuT+qPxarxs7kYrwhfMlYOnJa9zKFW0H+SC1vQLYTbJhZ5s
         30Fg==
X-Gm-Message-State: APjAAAU0RrqwzVsywITW/jP7rr1alijoawjYSPda9do3o0xoonP1HHs9
        OP+ut0V+ysumppU9XjFk2o/SAt8bUj0=
X-Google-Smtp-Source: APXvYqzK2bbd+wyLIsfhXIrj0pPux0kEX8YHolEjfX85yFdk+MVkJmqE0DA2Dou5K45MjxiVuW9a7A==
X-Received: by 2002:a63:4e4a:: with SMTP id o10mr17694200pgl.212.1583118450186;
        Sun, 01 Mar 2020 19:07:30 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f1sm9809278pjq.31.2020.03.01.19.07.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Mar 2020 19:07:29 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/2] bnxt_en: 2 bug fixes.
Date:   Sun,  1 Mar 2020 22:07:16 -0500
Message-Id: <1583118438-18829-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This first patch fixes a rare but possible crash in pci_disable_msix()
when the MTU is changed.  The 2nd patch fixes a regression in error
code handling when flashing a file to NVRAM.

Please also queue these for -stable.  Thanks.

Edwin Peer (1):
  bnxt_en: fix error handling when flashing from file

Vasundhara Volam (1):
  bnxt_en: reinitialize IRQs when MTU is modified

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 24 +++++++++++------------
 2 files changed, 13 insertions(+), 15 deletions(-)

-- 
2.5.1

