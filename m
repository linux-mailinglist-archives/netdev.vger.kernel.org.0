Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080B51F5F3A
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 02:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgFKAf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 20:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgFKAf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 20:35:26 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E9FC08C5C1
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 17:35:26 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id b16so1856442pfi.13
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 17:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=F3ke2UNW6Q3pxw7jza6llHxPAz24qVlobH6JnInxFNE=;
        b=ZK5oXqOLdZg9jUMKX0LyACajZiKtZJUxDUFoCBMYKqL2oMGf4zePnnwJfbTdHXnaO8
         gm1jESfmAyynG0OeD+I/ME4TVwdi8U7qR/OMwbuE1xSuhht56szh3fnPKJtxi5WiwAKn
         pjumF4OVurYlZp0jsPqQ8t2zpQtbsSnqm1D/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=F3ke2UNW6Q3pxw7jza6llHxPAz24qVlobH6JnInxFNE=;
        b=khd87JAMlQWW0giY01MXd6WoUhtkdcIzi5S4JgKBGwy6zHPcaxjUdoZS1xZv0Zzm3l
         vChAP1puFNCFAdzKO6eOHmwGt+KXuCI2+mjVb8lTozv6AHu95UDN3txU+jGA3yY0VbHC
         HtFCHBODrjbJQklM6rtoM1wjLY9yZMQOLZYJT2gCRESUfQG7Zkb+4JgcEiFAIlZ1CU6d
         G0wOwSzCF12WBaew8wJt9CAeokuDe3sXmg1jeNB5FHEfS1SHGZim5pxplTa63Hffytz8
         XrZ/podlXIpbBRH2sS63taFyGv85n6T3DMeZB63fwVtgFl44Evh5NANHb99XzliIZXUL
         oWEQ==
X-Gm-Message-State: AOAM532B9emQVNZLnAQ78qaQk2gEFlDdb8p2tshzbo18ueVPckxMU6R4
        qcqKYvTqn7IfIi80ebfDNc+UbQ==
X-Google-Smtp-Source: ABdhPJx0llHpRo75g5fKalaYWlj9OHBFbb76JSIKkHlQZJ7QlcX7twFmnUmQF2Fll6i5DWHnGwm7/A==
X-Received: by 2002:a63:f40f:: with SMTP id g15mr4603507pgi.285.1591835725854;
        Wed, 10 Jun 2020 17:35:25 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id h17sm1034503pfo.168.2020.06.10.17.35.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jun 2020 17:35:25 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        nikolay@cumulusnetworks.com
Subject: [PATCH iproute2 net-next v2 0/2] support for fdb nexthop groups
Date:   Wed, 10 Jun 2020 17:35:19 -0700
Message-Id: <1591835721-39497-1-git-send-email-roopa@cumulusnetworks.com>
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

v2 - address errors pointed out  by David Ahern

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

