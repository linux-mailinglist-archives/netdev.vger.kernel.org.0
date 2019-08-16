Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E55190B03
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfHPWdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:33:49 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39291 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727761AbfHPWdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:33:49 -0400
Received: by mail-pf1-f196.google.com with SMTP id f17so3821285pfn.6
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 15:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=QPYILOFs5ohOW11t+QO0qTp5ELoXk0f0kit83RbgVc8=;
        b=L1KJGRPH76rCfNF9UnLQSBo55RIZNUDvH5K5nFO/fgALt1S6R89irC5bsdAcVJLLSZ
         ZQDpke8tDqUEWY0adoc2y3GXOJI/LaXcxAKD7q4u7mW7L1ZYpHI7ZTdkTImq93ZEN34s
         o3V7+0panmloMEmoZujx9qKLBm8DRrIFsf3Qs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QPYILOFs5ohOW11t+QO0qTp5ELoXk0f0kit83RbgVc8=;
        b=gX/a4ZcDqBFPoE1jKcqMPgioD6ZoXX7p43pusLNKTzrh6fzCte5sfwnN0KxP4AXgs0
         S07lCgR/DFoS54Eui072lMW2PZCLh7Ieixg7uzu7Mt/Dblx8jvb1fPTXWM2JqyarEvPA
         0kbsNe2GFI6o5Wv5xLB8wRWRZ+77VHUTRgEv+Kp/UP+AfRZgbuHFY/Z+47ayImuISOh/
         XoQyZ/bThHxC/F4ZnIOjym3OqllYfHWI7E6o6c+pHsZIBUmOavXfNfVx29CPcNH8H3Nd
         yYR/LJ7Gc3jMBPON/+ebgKe1VgUdUn1h41p0b2XUK8PzcwoGrebn4ct0fVmtHz/HzYGQ
         Ojdw==
X-Gm-Message-State: APjAAAUgahR03UgYYjn70EU8AOCooY5N3PYpEeOG91+2iajtCuqxHBEg
        IDxLqTJXFHh9HDaEVKX/PXnJ4g==
X-Google-Smtp-Source: APXvYqx9Gv/xOt68Z+in/L8XUtQXLULUNtzfAp/idQKEjYTgW1zU82r6DQf87opYvLzt8zbXOWyZjw==
X-Received: by 2002:a63:de07:: with SMTP id f7mr9853409pgg.213.1565994828757;
        Fri, 16 Aug 2019 15:33:48 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o35sm5728404pgm.29.2019.08.16.15.33.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 15:33:48 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/6] bnxt_en: Bug fixes.
Date:   Fri, 16 Aug 2019 18:33:31 -0400
Message-Id: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2 Bug fixes related to 57500 shutdown sequence and doorbell sequence,
2 TC Flower bug fixes related to the setting of the flow direction,
1 NVRAM update bug fix, and a minor fix to suppress an unnecessary
error message.  Please queue for -stable as well.  Thanks.

Michael Chan (2):
  bnxt_en: Fix VNIC clearing logic for 57500 chips.
  bnxt_en: Improve RX doorbell sequence.

Somnath Kotur (1):
  bnxt_en: Fix to include flow direction in L2 key

Vasundhara Volam (2):
  bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd fails
  bnxt_en: Suppress HWRM errors for HWRM_NVM_GET_VARIABLE command

Venkat Duvvuru (1):
  bnxt_en: Use correct src_fid to determine direction of the flow

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 36 ++++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  9 ++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 12 ++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c      |  8 ++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h      |  2 +-
 5 files changed, 40 insertions(+), 27 deletions(-)

-- 
2.5.1

