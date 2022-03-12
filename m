Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C314D6E06
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 11:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiCLK2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 05:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiCLK2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 05:28:22 -0500
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561751E6972;
        Sat, 12 Mar 2022 02:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sADzXucFbvYQxoGycjfde7/Wl6yGzio2SkMVBhdfarY=;
  b=j6QWgrxGryMhxSMA3Gi6JmdMZ2AEEwpWhkicG5GEBsR5gb7tpaRO9MKN
   qxPbbNFJS0mb0JLudfu5b6E/NXBAkB7IARm729wGXywLtuY0+WhQ5PUO4
   UwsVAy58sLeTRSxGNU80+9aDaVFZn9QhCg6B6X2BMu1tuitCTOC6d9UkD
   Y=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,175,1643670000"; 
   d="scan'208";a="25781346"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2022 11:27:11 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     linux-wireless@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, alsa-devel@alsa-project.org,
        samba-technical@lists.samba.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        Andrey Konovalov <andreyknvl@gmail.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH 0/6] use kzalloc
Date:   Sat, 12 Mar 2022 11:26:59 +0100
Message-Id: <20220312102705.71413-1-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kzalloc instead of kmalloc + memset.

---

 drivers/net/ethernet/mellanox/mlx4/en_rx.c |    3 +--
 drivers/net/wireless/zydas/zd1201.c        |    3 +--
 drivers/scsi/lpfc/lpfc_debugfs.c           |    9 ++-------
 drivers/usb/gadget/legacy/raw_gadget.c     |    3 +--
 fs/cifs/transport.c                        |    3 +--
 sound/core/seq/oss/seq_oss_init.c          |    3 +--
 6 files changed, 7 insertions(+), 17 deletions(-)
