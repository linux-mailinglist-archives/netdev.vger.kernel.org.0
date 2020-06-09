Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901171F32B3
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 05:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgFIDqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 23:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgFIDq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 23:46:28 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A9AC03E969
        for <netdev@vger.kernel.org>; Mon,  8 Jun 2020 20:46:28 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id h185so9485369pfg.2
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 20:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=iXUtJSfzChlaFF0+CMDFVMltRhorXfmefmfWmL2fmHA=;
        b=KOIYvbQFzuurEnngkcPR0ifA8OS1cgWPp32xINehzxAzyBg+eoiVDPtgFIXDEmMHke
         eu3TWGXAKcx3pJ6MlojavuMv02s/JUL9i17xjfOmyGBCgaDyZHH0CDFqma3rtohZlstO
         60St3dVm0wJiYu5IE6UfNUL+90dAsIuLNdX0Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iXUtJSfzChlaFF0+CMDFVMltRhorXfmefmfWmL2fmHA=;
        b=ZZaxB1CoQ7nDdG6kOpjuV4XoQH/emK4J2QJ1zqfy9LujyNWvvA86LM/JMY8aEv680+
         NYEHldlHy9GC6vRsV4YbfMSAk2RFwbdhWucH317OhY8mtUiEFAiEP29mjLIJ8fcRkx51
         Xh6KQAudk3WqS6pTG0dKWOXNn7P4bm0nVNCw5cDCK8vpCPAWguxqTSfYe6eJT20dmIbJ
         WvmmfvQpbDwwlkp0SsGSl7HIJiM36xROLsBcx41RRWfPnCRfvGaRC7vE1YjS3WQL4HGD
         tz25vuSrvBReLyp1wRwqtDNoKopqYky6NACtUWOF70aN/L4tN1BJb0YCXB2wXDzIewnV
         E8rw==
X-Gm-Message-State: AOAM532rQj2v6+RpOF/S5pfqhF+tOIml4aAo1MiL+TypSb0E+UYNA14E
        QM1jA+HKDT/6XvSO0lpeHpIBTt4CGFg=
X-Google-Smtp-Source: ABdhPJws24HbP6h4138etJQSlnWm2Y2XwxnBASeT/cKcke6MEslGCkiEEYoqtXsbGeTqrfGEy7wOEA==
X-Received: by 2002:a62:63c1:: with SMTP id x184mr18657222pfb.324.1591674387555;
        Mon, 08 Jun 2020 20:46:27 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id nl11sm1696385pjb.0.2020.06.08.20.46.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jun 2020 20:46:26 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        nikolay@cumulusnetworks.com
Subject: [PATCH iproute2 net-next 0/2] support for fdb nexthop groups
Date:   Mon,  8 Jun 2020 20:46:21 -0700
Message-Id: <1591674383-20545-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This series adds iproute2 support for recently added
kernel fdb nexthop groups

example:
/* create fdb nexthop group */
$ip nexthop add id 12 via 172.16.1.2 fdb
$ip nexthop add id 13 via 172.16.1.3 fdb
$ip nexthop add id 102 group 12/13 fdb
   
/* assign nexthop group to fdb entry */ 
$bridge fdb add 02:02:00:00:00:13 dev vx10 nhid 102 self

Roopa Prabhu (2):
  ipnexthop: support for fdb nexthops
  bridge: support for nexthop id in fdb entries

 bridge/fdb.c                 | 11 +++++++++++
 include/uapi/linux/nexthop.h |  2 ++
 ip/ipnexthop.c               | 17 ++++++++++++++++-
 man/man8/bridge.8            | 13 ++++++++++---
 man/man8/ip-nexthop.8        | 30 +++++++++++++++++++++++++++---
 5 files changed, 66 insertions(+), 7 deletions(-)

-- 
2.1.4

