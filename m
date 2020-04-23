Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E361B5420
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgDWFV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725562AbgDWFV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 01:21:26 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19243C03C1AB
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 22:21:26 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x15so2381330pfa.1
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 22:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=hUAU6L6ngHh/mNnpsdq4hoxqGDjyGz0TDuqqqwy02bs=;
        b=ORLeJ3SNZjCEFdVrk6fDH99ywMGpkCOYR8hFLs+QinPlZZR+oCj/LROsR0ghOd12/N
         AqeKXCESomNeDvm0tx0A5APcpnlGPnZCWuGlZnbFxYxlHfL67DDkKQij5eL02pkWyuIH
         kDuzeTMBvqVhKxrqspqYRWxQZbpkmg5fGLNQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hUAU6L6ngHh/mNnpsdq4hoxqGDjyGz0TDuqqqwy02bs=;
        b=M+jZmRQnUD6GXEd25gmTfxeNnLWbWyBqbeKlnys6qPUQoZ+eyk+jkoj176D9/SkLxF
         4AnrukO/i3AnCyrieroIP15SnYU8eYw7AicDPcOuKX9HKbJA1mw7rs/9y/AMN0rGQLM9
         OrngDJ4bkHErx5dDYf7NRBQdHXwvx9TktjnZRF9vjdkZBw44ol1sTabeP1lJqEF8L+RE
         8JHN3tBwnSBxcHjI3ugspGd1GlnazuAVnlMDRA/1XaO00Ps/d2Zw/Wx8fFYT2KQoUWH6
         hSvEuhkHKXzgo/qfgMq+4W5VRJAjCvaMccM82ZfJFggtF5bd0fbywGvmJLdXAFnqPqF9
         HxXg==
X-Gm-Message-State: AGi0PuYK6MsoFc9id+jd4MiGNZfTCB7tissCsKtrPAOZ2vfyCR+K4AEO
        uZHQLbmFBksYhw1R/Wk5+hcB8A==
X-Google-Smtp-Source: APiQypJXA41VbqhVAIt1uIuRjJ2KfduWSRjTmlwZr+tQG/zqyg5yAnPFfnq4zsvbXWsxVJ4j8vGY/g==
X-Received: by 2002:a63:5657:: with SMTP id g23mr2377534pgm.224.1587619285619;
        Wed, 22 Apr 2020 22:21:25 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id u3sm1279160pfn.217.2020.04.22.22.21.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 22:21:24 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        bpoirier@cumulusnetworks.com
Subject: [PATCH net-next 0/2] nexthop: sysctl to skip route notifications on nexthop changes
Date:   Wed, 22 Apr 2020 22:21:18 -0700
Message-Id: <1587619280-46386-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

Route notifications on nexthop changes exists for backward
compatibility. In systems which have moved to the new
nexthop API, these route update notifications cancel
the performance benefits provided by the new nexthop API.
This patch adds a sysctl to disable these route notifications

We have discussed this before. Maybe its time ? 

Roopa Prabhu (2):
  ipv4: add sysctl to skip route notify on nexthop changes
  ipv6: add sysctl to skip route notify on nexthop changes

 include/net/netns/ipv4.h   |  2 ++
 include/net/netns/ipv6.h   |  1 +
 net/ipv4/af_inet.c         |  1 +
 net/ipv4/nexthop.c         |  3 ++-
 net/ipv4/sysctl_net_ipv4.c |  7 +++++++
 net/ipv6/route.c           | 14 ++++++++++++++
 6 files changed, 27 insertions(+), 1 deletion(-)

-- 
2.1.4

