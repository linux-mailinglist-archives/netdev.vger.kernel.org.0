Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFC6C2C5F6
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfE1L47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:56:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45145 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfE1L47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:56:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id w34so6186805pga.12;
        Tue, 28 May 2019 04:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Y0nU1mnDjk5DEaEAqhn6A+e5w54A9UaAagHSxcoB+rI=;
        b=droyNuncHFCAXk2oz9b91V/DwkejmqPm50x4ZBfqch9PSfHoEpw76fBWY+hcNLkPNG
         cAs+EV160TX6U78yQ58egeBfws+a5Kl9Vi73WP8uPWje0+UdOI6CSy2I3oK4zn9m5OSm
         rp0CnbvZF13HQwXk6gfgGlzeSh0pPuBWAAV3SNBT+5GvDKiWKgcqdt4Hz5LnSSLoyozn
         OW+7OptgTqrxMQwKxrGvbDY3I21Ni6H4sSgK3k/aQj8atL5WEPs2ssJntXR7Dzo+klVf
         Y6u8YfVBM2PbMjmlw19zeQgjjs1qsSUV3vjPyGFZqmt0zX/WNp+EuY+je7xDsFPoAcfc
         1YpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Y0nU1mnDjk5DEaEAqhn6A+e5w54A9UaAagHSxcoB+rI=;
        b=k4erHXWSicV/QX2pyIoZjuFxE3p6932rlB3ec8wGcNfTHSaxnrVB5uk0ddkfcZTM2p
         Q13AAPIQJbA+A7QuoQobsU6pDsdTDnAwenP2XJHh9bIRdNSaKxfd9OLraysiB+VerZrq
         Qw0f+vf+XH/t4J4ofgSKWp4/zgDq4nPsq6MlQtPsKKmKEx/ITOhNVlyPcQtaoSgxS0qd
         5gseQSrN+N4MlmXrC/sJA4bJ97gaFvK9/JDmZ5MO94vJVbhrFkeI4SYNEyI19cWiC1oe
         dGMLc9JH1JoD4BoWkhos7oF+/wvPvUy8eAXlNsemjqP8LHtx9Lxso2y/Pn3wC7n5Dfpn
         zgHQ==
X-Gm-Message-State: APjAAAXqP8bhESgfq74nAbDlgMBY8ddN9hnN1Z69wNAU7DnbrygnB1xs
        hu1M+8CQY93rkuCugpq18UI=
X-Google-Smtp-Source: APXvYqx3Up2B1eZPaaTAWMBFlw4GilIcCB4OB4SrH4CoVtGbovwboWob5c34WdwFXy9KG22xN4xmnw==
X-Received: by 2002:a17:90a:9602:: with SMTP id v2mr5467175pjo.59.1559044618864;
        Tue, 28 May 2019 04:56:58 -0700 (PDT)
Received: from xy-data.openstacklocal (ecs-159-138-22-150.compute.hwclouds-dns.com. [159.138.22.150])
        by smtp.gmail.com with ESMTPSA id r1sm16272313pfg.65.2019.05.28.04.56.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 28 May 2019 04:56:57 -0700 (PDT)
From:   Young Xiao <92siuyang@gmail.com>
To:     jeffrey.t.kirsher@intel.com, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] ixgbevf: fix possible divide by zero in ixgbevf_update_itr
Date:   Tue, 28 May 2019 19:58:02 +0800
Message-Id: <1559044682-23446-1-git-send-email-92siuyang@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The next call to ixgbevf_update_itr will continue to dynamically
update ITR.

Copy from commit bdbeefe8ea8c ("ixgbe: fix possible divide by zero in
ixgbe_update_itr")

Signed-off-by: Young Xiao <92siuyang@gmail.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index d189ed2..d2b41f9 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1423,6 +1423,9 @@ static void ixgbevf_update_itr(struct ixgbevf_q_vector *q_vector,
 	 */
 	/* what was last interrupt timeslice? */
 	timepassed_us = q_vector->itr >> 2;
+	if (timepassed_us == 0)
+		return;
+
 	bytes_perint = bytes / timepassed_us; /* bytes/usec */
 
 	switch (itr_setting) {
-- 
2.7.4

