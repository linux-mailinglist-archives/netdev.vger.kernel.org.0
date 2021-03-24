Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C701934703A
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 04:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhCXDsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 23:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbhCXDrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 23:47:46 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41463C061763
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 20:47:46 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id bt4so11013429pjb.5
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 20:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cooperlees-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=Aiha+uPDJVVxpYttne++lwsS5ixL+zbE1p4J6MfglY4=;
        b=lCjuVpXv+c+QNRWebIMjSkmNhCE6tWqk9BCNSSocC85YPEabqA3SQS/CFRyWl31P/C
         H6ZqipVUK/ElhTCT4zbb8MndcJbQd7kHBPpJpXepLuLUNbFbjrszfSyAQM7Nu8wSJbrx
         I1FmKjKF5PUlCX216z/m5gAhVpOhhl0KFz8L2s1oyN5M73tN8M8ghDMPZn1uFwcE+KcR
         vPAaemFrCFiWLGSIKclvC1xZ1aklvv6t0AOLM/R+yY8bTSFLnnxFVPR+muBDeQivPlW0
         Accb2tcJ+krEk0gSQ6NzycbHKVyWB2zLDSVCqQLUaWakk4GrUdR11s10msqjQmtU0Xf+
         zvNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Aiha+uPDJVVxpYttne++lwsS5ixL+zbE1p4J6MfglY4=;
        b=MVvt9NYxnpZkiL+cwDgDl62wZBC2hIOGsNw4VxvBkYRyLzvI1DgsJ6zNsoWy8yAz02
         W+/LVrGih6HZx8tPD7GQUTvAU6TX7fwXPnP1+vfE92zQi2IQnLqZgL6E63g+cT9fE1In
         fl4ybi6CkLGRxWNy8VRmcUso724xw9CJVSv8mPqYaLUCq29ATMoe8zNZFXaqr5kwd4Yl
         GQMASdbDgzlrpistwQ3K2FzgkyrdiiNknOSJNQi55r3kl8S+3HyDS3u+3kJenY7Z64Rh
         ZAIbr4z/MKXcUX3b5QSnYdXLgNg7W4h9KrVnPdjyRFNXLlbVTz9og5aNJGzFDyjIlZcD
         VX6w==
X-Gm-Message-State: AOAM531TlVyeG6caDzAVdGtqp2CtnTL7Jz29lshH1I8F+vriQ5WaEm5Z
        TeCY2XTslSywgri2FRFLjr9u0LtfQuTqLA==
X-Google-Smtp-Source: ABdhPJzloa87CnpGoK5ySiF/4ezxK116V6TEsLNZKIjzIx30h7+1gC2dCfcZMkmty2BgZ8tAfE181g==
X-Received: by 2002:a17:90a:a63:: with SMTP id o90mr1352084pjo.90.1616557665778;
        Tue, 23 Mar 2021 20:47:45 -0700 (PDT)
Received: from cooper-mbp1.cooperlees.com ([2600:6c4e:2200:71:10a2:8f1f:def4:467a])
        by smtp.gmail.com with ESMTPSA id i13sm597661pgi.3.2021.03.23.20.47.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Mar 2021 20:47:45 -0700 (PDT)
From:   Cooper Ry Lees <me@cooperlees.com>
To:     stephen@networkplumber.org
Cc:     me@cooperlees.com, netdev@vger.kernel.org
Subject: [PATCH] Add Open Routing Protocol ID to `rtnetlink.h`
Date:   Tue, 23 Mar 2021 20:47:38 -0700
Message-Id: <20210324034738.61212-1-me@cooperlees.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cooper Lees <me@cooperlees.com>

- The Open Routing (Open/R) network protocol netlink handler uses ID 99
- Will also add to `/etc/iproute2/rt_protos` once this is accepted
- For more information: https://github.com/facebook/openr
Signed-off-by: From: Cooper Lees <me@cooperlees.com>
---
 include/uapi/linux/rtnetlink.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 91e4ca064..b0b5190e8 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -283,6 +283,7 @@ enum {
 #define RTPROT_MROUTED		17	/* Multicast daemon */
 #define RTPROT_KEEPALIVED	18	/* Keepalived daemon */
 #define RTPROT_BABEL		42	/* Babel daemon */
+#define RTPROT_OPENR		99	/* Open Routing (Open/R) Routes */
 #define RTPROT_BGP		186	/* BGP Routes */
 #define RTPROT_ISIS		187	/* ISIS Routes */
 #define RTPROT_OSPF		188	/* OSPF Routes */
-- 
2.13.5

