Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D781E95B0
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgEaEsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 00:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgEaEsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:48:46 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C719BC05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:48:46 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id k22so2911025pls.10
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=dtm467eVGcU6vMV0pzbowlencFLVoPqQ9KbdJphKaHs=;
        b=Tdp/pjR257y6MyfKdhPBAM2c6ijQbS/wLYbY+D6YErMSv8HLdBFit9uK/N27zxsOXN
         B8dHncVpI9GDiZridKvETcKzDgGtt5Fmc4TkPO+YiptsN7ABYo2G5A2DFOpN9aqrq//4
         ewhgT+oyArDeytBvwxG3FfLqu4p/YpWkxf21s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dtm467eVGcU6vMV0pzbowlencFLVoPqQ9KbdJphKaHs=;
        b=E7MpR4mh8QSWHxldK/jqtHh4XNxDwJw4WGB+562a3tF0bBwXnMsltcZVyzHpalTWkj
         VAs9Yi65yCplf1DaZzdu/5bPa85FD8TRQ1Ii5m7ErQLtBhmJkJxa1PkcJ5wupkahw3BU
         BzyIxA8qEl/3p14Uveu6DXnrlVVYKaORkX4Yq1EmRgr1P0MCUr7Oh6MHCVY0qnyyUr8m
         B+xjfHM44H2V9dO7DNNJWcGjqbURJPFPfMNDBa3rqJK3RU6D57Qi7Vb5UAnUvsFj+TGS
         WiZfGrCByF0iZsP4iLcE8qFR9Nf5ObHITnFZSTpbNirA4fX1v5q0/luk+P85avqXAiMJ
         XyFw==
X-Gm-Message-State: AOAM532smedLqgkO1CSShhvjGFz19/j+Hiinr4YFibmXVT2QG2vR04WC
        cu/V4bbefhpTXMfsn9DBESWMag==
X-Google-Smtp-Source: ABdhPJwj8WDmLQx34qybk19EPEOVMTVQopkEWPPqtocW6RqhygZVSJwkr7NXbWGrkbagv3azy1vhwg==
X-Received: by 2002:a17:90a:17e9:: with SMTP id q96mr17233386pja.56.1590900526118;
        Sat, 30 May 2020 21:48:46 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id m2sm3584312pjk.52.2020.05.30.21.48.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 30 May 2020 21:48:45 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next v2 0/3] vxlan fdb nexthop misc fixes
Date:   Sat, 30 May 2020 21:48:38 -0700
Message-Id: <1590900521-14647-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

Roopa Prabhu (3):
  vxlan: add check to prevent use of remote ip attributes with NDA_NH_ID
  vxlan: few locking fixes in nexthop event handler
  vxlan: fix dereference of nexthop group in nexthop update path

 drivers/net/vxlan.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

-- 
2.1.4

