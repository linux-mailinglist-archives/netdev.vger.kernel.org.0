Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1C2434A56
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhJTLpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbhJTLpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 07:45:06 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDA3C06174E;
        Wed, 20 Oct 2021 04:42:52 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id g39so14155776wmp.3;
        Wed, 20 Oct 2021 04:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nT0vvr2O+8IIwQyISUa6v1lK5uZqlveAWGKvgf9ibMc=;
        b=klVjV/H/kosME/WZRRAMQmZMdeZuHz/DfrclkSVfKQ8iIvEMgvtt5IFPTQFzlbBVeE
         5YDNviYuRq8foBz69ULrZkl/+9yb4fFT+n2cNDi/HYlelUNdliv1b6basDsLVlCsk+Q0
         S/TKZuXlgLkR1aRPED7VoANFXZCwW4yW7UgwOAAMf6IuOAuBekMLzyPcuYceXwGN1uSp
         cNnlvAJesZ86S9EtiyYjcurRtbcTNJWcse8F0paEixsOObs+UpCoec+4VR5CCBZ6DlYH
         S0wh97ZlMeiHfSh884S3LTWh9/C5lD884TibjNZlo4L1N/S7ukf8orQiZIqyRAr6eM3f
         nFhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nT0vvr2O+8IIwQyISUa6v1lK5uZqlveAWGKvgf9ibMc=;
        b=3XWG/dGM67e/MvuZMPgUUWNEjFRwrCAL9Kgtyooe1C+dJAhUb7VJjUmsxa0WQnWHGS
         q5A9/syn6dMgHVsagiNK+kfIR72QLeTCZYoX1ywK89MZypWeWNyhZjn8PFLaAH6tXQ6q
         kjh5HqiwnfisJDP2rKNR70pnl35Mxa6jGfZO5NRpv+10lK+Uz142J/F6ejzlCQU876lN
         K+08gRy/1kX1GmQVetpPX3kpAxYZUwilGWm80X3wu9H7sc8alQO7jHt/6QxIWS7YqTau
         5argmjg6egXshsvxs/YahyKd7BWvsJBgqGMfseehZ6y/KzRgUcs0VQzCJhlDHDkcXE7x
         ARig==
X-Gm-Message-State: AOAM533BnH7249GVKpkOJauCWj9P2Ox6zpKstzs7nh5vZjxwbDy54OuL
        JstU1ohvdEhNChrJ8Ib0jh+rRTZ6FaY/bw==
X-Google-Smtp-Source: ABdhPJwySwly7O0/GRSj3cdHL56vnSobjtAs393cDl6x+HRvyvMcPWGGEZ3DhHIyPCNV1mtFDcH9ww==
X-Received: by 2002:adf:a1cc:: with SMTP id v12mr52354744wrv.48.1634730170848;
        Wed, 20 Oct 2021 04:42:50 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 186sm4988989wmc.20.2021.10.20.04.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 04:42:50 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        michael.tuexen@lurchi.franken.de
Subject: [PATCH net 0/7] sctp: enhancements for the verification tag
Date:   Wed, 20 Oct 2021 07:42:40 -0400
Message-Id: <cover.1634730082.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to address CVE-2021-3772:

  A flaw was found in the Linux SCTP stack. A blind attacker may be able to
  kill an existing SCTP association through invalid chunks if the attacker
  knows the IP-addresses and port numbers being used and the attacker can
  send packets with spoofed IP addresses.

This is caused by the missing VTAG verification for the received chunks
and the incorrect vtag for the ABORT used to reply to these invalid
chunks.

This patchset is to go over all processing functions for the received
chunks and do:

1. Make sure sctp_vtag_verify() is called firstly to verify the vtag from
   the received chunk and discard this chunk if it fails. With some
   exceptions:

   a. sctp_sf_do_5_1B_init()/5_2_2_dupinit()/9_2_reshutack(), processing
      INIT chunk, as sctphdr vtag is always 0 in INIT chunk.

   b. sctp_sf_do_5_2_4_dupcook(), processing dupicate COOKIE_ECHO chunk,
      as the vtag verification will be done by sctp_tietags_compare() and
      then it takes right actions according to the return.

   c. sctp_sf_shut_8_4_5(), processing SHUTDOWN_ACK chunk for cookie_wait
      and cookie_echoed state, as RFC demand sending a SHUTDOWN_COMPLETE
      even if the vtag verification failed.

   d. sctp_sf_ootb(), called in many types of chunks for closed state or
      no asoc, as the same reason to c.

2. Always use the vtag from the received INIT chunk to make the response
   ABORT in sctp_ootb_pkt_new().

3. Fix the order for some checks and add some missing checks for the
   received chunk.

This patch series has been tested with SCTP TAHI testing to make sure no
regression caused on protocol conformance.

Xin Long (7):
  sctp: use init_tag from inithdr for ABORT chunk
  sctp: fix the processing for INIT chunk
  sctp: fix the processing for INIT_ACK chunk
  sctp: fix the processing for COOKIE_ECHO chunk
  sctp: add vtag check in sctp_sf_violation
  sctp: add vtag check in sctp_sf_do_8_5_1_E_sa
  sctp: add vtag check in sctp_sf_ootb

 net/sctp/sm_statefuns.c | 139 ++++++++++++++++++++++++----------------
 1 file changed, 85 insertions(+), 54 deletions(-)

-- 
2.27.0

