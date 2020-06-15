Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08E31F9172
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 10:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgFOIaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 04:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgFOIaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 04:30:21 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A234C061A0E;
        Mon, 15 Jun 2020 01:30:21 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a127so7490343pfa.12;
        Mon, 15 Jun 2020 01:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QrrUn5+Gf7HpeX6QtMRabVxvycCPLzCk0Kce3pATFQM=;
        b=FUjNEnxDnyHI995KGCYFBk+iX6kOs8APyTJm9khR7xwE35B3wB5itDPk9BKGmdbhHP
         CRL/ZRMgvXGTPHpJEmgubr2nMLj0xoKUGw7PDW60SxL4mGJcAtNZBIopUD8KmPBaV46b
         orzTuoGDQ4iBOcRQrR0W/vl6C/EowxJuOmlIZph7Hpr7NA+tPXs1t2+2MvhMEF6/Hqji
         A8cc2rDhDy5S1vVz9EK21TH4GdK2BAS+egCycaL9Kp1PXEMzgGhpiRLVSKSljX50Tgfy
         ICWs2FBzFk5M8dlI2nI0GScQjblHxkDef3VSA3ZxlfPWPQu/HOMHQC+dsGhNvUUiHrQp
         wbbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QrrUn5+Gf7HpeX6QtMRabVxvycCPLzCk0Kce3pATFQM=;
        b=evBeXfpMuZkCKPVBUmub2LBgRT/YRPjkY3Ihj4ESEoRtgvG1VBm7QxG0iaE2sTodsP
         coq1qRqlgbzoHWfhAb6iyuJZ2WUxBoUG1y4TkACd3z3Xs8HcmggDKOogf4kBOUj5xBiI
         Nbxxm+1yvj7hd9C2PIZ8PBE9ozHhG5EQxkt0GAlvbD8De4lr0iY0MY4mhI1O9dx5nvzU
         O9pxp9MS3eW811E8fm6xXFdiu0PxA70BnCBW47++sak7YuIeqqAQtTTN4aF2XNONf+fv
         +3rA53QkF19WeswuF9D15zUuidS+S7K5A6mMpIoatw+4rWL59RpZ/DWeK7xdsZlTE6He
         M13w==
X-Gm-Message-State: AOAM532TVb5Y7rtG7VS/Yi5mNJphs1OgzutLYznBX2BuphLgywqtmevw
        sZhGLmRDnDdPWrhRNyxEKT0=
X-Google-Smtp-Source: ABdhPJw8nnWYSo+77SbvcAgaUOgZmUrJRdkwyX7atpEyIPUCpOge2I37z9l5wVx8pVXPB8nwCf31pg==
X-Received: by 2002:a63:580c:: with SMTP id m12mr6763476pgb.446.1592209820561;
        Mon, 15 Jun 2020 01:30:20 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id b19sm12927570pft.74.2020.06.15.01.30.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2020 01:30:19 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] mptcp: drop MPTCP_PM_MAX_ADDR
Date:   Mon, 15 Jun 2020 16:28:03 +0800
Message-Id: <8d8984e8f73e37c87e69459fdef12fe9bab80949.1592209282.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have defined MPTCP_PM_ADDR_MAX in pm_netlink.c, so drop this duplicate macro.

Fixes: 1b1c7a0ef7f3 ("mptcp: Add path manager interface")
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 Changes in v2:
  - change Subject from "mptcp: unify MPTCP_PM_MAX_ADDR and MPTCP_PM_ADDR_MAX"
---
 net/mptcp/protocol.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 809687d3f410..70ed698bd206 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -135,8 +135,6 @@ static inline __be32 mptcp_option(u8 subopt, u8 len, u8 nib, u8 field)
 		     ((nib & 0xF) << 8) | field);
 }
 
-#define MPTCP_PM_MAX_ADDR	4
-
 struct mptcp_addr_info {
 	sa_family_t		family;
 	__be16			port;
-- 
2.17.1

