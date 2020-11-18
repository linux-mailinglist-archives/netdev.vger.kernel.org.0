Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C690E2B7357
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728805AbgKRArB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgKRArB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 19:47:01 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535D5C061A48;
        Tue, 17 Nov 2020 16:47:01 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id gi3so144358pjb.3;
        Tue, 17 Nov 2020 16:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=23XPr9jQTa256WABBj9/6DB1oSz4KVTqb97F+PbVl4A=;
        b=nCRBemAEnzA+W3wb3BswDkm0g6CT2ZGDGvhplop8hmCBc50kH+SaZowWmvRHwQhzAM
         EufAxLkgN2YIgtheMo2NfSdjhaHNrpZIMqgCFDop2vFeAh+L9E30/LI2+5arL9tNgKBf
         7ZdBYs2g2A7O6ODvp/ezrz1GtcwnxDwsni8xYqjnqjz5GzpzXW0wAzcyBBCd+hGgO/hW
         WwcveoU+k8K+aCVWSeoL9SOKNksr1pqPJjAtOoP4XqfI7rb+X5q9ssuAlDkB9Wq2vu5s
         emf+p9Vb/jl02XnR+x/Y3LHjk13kL2X+Ag8HLoeNh1/vIiFAeLUNAxRDD/GLSDM/qiaq
         DWhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=23XPr9jQTa256WABBj9/6DB1oSz4KVTqb97F+PbVl4A=;
        b=L+QQHSrE427DhM/IUFrtHmmbYIjxq/xXg0YVOxjP/TDtS8QmHU5JKSVhynhMQo9IFt
         xo3rvxRVPUiBntPR02pLNCXv3SoCtoYdeSCXsicx42q4TWW1havyBL/TOpq8ReyTpaX+
         YS5Jb+X9RfIcttZHc5IDS22tELFtqCOVtvx/wW5eJgtfy2pz6BwXVolZOwXgkempyGdP
         a/BBK/18H95ro5fQoi/UAO3vpaBB+g1k18Sk5hy+CHMZixGsYa4Q/UGLAraDU22HO+GU
         mnT+Vix4DMhyankKKtGw7XIdQGNPLXmzVGjEOo8fv6eff0QXz7KLTQvbLa1D2rFHK3H3
         5pEg==
X-Gm-Message-State: AOAM531neormWFTEhVaU2iEs+fTY9/eXsyIDKUagGgK4//f5/epkoWUD
        hGmCHKxkSJjEnEfcPRZYqeI=
X-Google-Smtp-Source: ABdhPJxvhftUcmQ6smuvkCOfuevxFM7IsuaMvk8q1ymowBcMlik1IcEZtJkt1EadFV3fJ4kGsTA2kg==
X-Received: by 2002:a17:902:b7c2:b029:d9:c8f:e06b with SMTP id v2-20020a170902b7c2b02900d90c8fe06bmr1745134plz.29.1605660420935;
        Tue, 17 Nov 2020 16:47:00 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id w2sm15671784pfb.104.2020.11.17.16.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 16:47:00 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 0/3] add support for sending RFC8335 PROBE 
Date:   Tue, 17 Nov 2020 16:46:58 -0800
Message-Id: <cover.1605659597.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The popular utility ping has several severe limitations such as the
inability to query specific  interfaces on a node and requiring
bidirectional connectivity between the probing and the probed
interfaces. RFC8335 attempts to solve these limitations by creating the
new utility PROBE which is a specialized ICMP message that makes use of
the ICMP Extension Structure outlined in RFC4884.

This patchset adds definitions for the ICMP Extended Echo Request and
Reply (PROBE) types for both IPv4 and IPv6. It also expands the list of
supported ICMP messages to accommodate PROBEs.

Changes since v1:
 - Switch to correct base tree

Changes since v2:
 - Switch to net-next tree 67c70b5eb2bf7d0496fcb62d308dc3096bc11553

Changes since v3:
 - Reorder patches to add defines first

Andreas Roeseler (3):
  icmp: define PROBE message types
  ICMPv6: define PROBE message types
  net: add support for sending RFC8335 PROBE

 include/uapi/linux/icmp.h   | 3 +++
 include/uapi/linux/icmpv6.h | 6 ++++++
 net/ipv4/ping.c             | 4 +++-
 3 files changed, 12 insertions(+), 1 deletion(-)

-- 
2.29.2

