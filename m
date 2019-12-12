Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 473CA11D515
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730340AbfLLSRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:17:10 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40723 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730178AbfLLSRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:17:09 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so3781263wrn.7
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 10:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=roIXLHN/oZOMUaAh0dlHndgXvCEFwoFYVYJUOHm0UJs=;
        b=vRTuSC9VUqoXX2bgeyED7VU+ZYwYh9paNSw+C31gU32QfXokQxDi9a7h8e7ckSDIKH
         KXbenhWGRsOKcOwcd6VeoI1R2tesAGlNPY3jAsDGrRD2NRmSXzfGDfUI5nXUdVpziPW2
         0lWzHa5wvCb5f51706vdbGFqE4IJ5KeNubtP7VGxuyHzaRDO05O9eGOUheFgZHqCHdrt
         CLLM8FT8NqtsGXF00VlbhW5jKvdkhnEjlYdFl48FOxdoVq07TTRd7MmJn1S2T4LFySw2
         PEpbiwNElkVuRmanuVU+dv0gGWS3ya8zYlQyMdoPo6R+oeAZtL4qHSrl12UMtZhFSzRb
         dgKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=roIXLHN/oZOMUaAh0dlHndgXvCEFwoFYVYJUOHm0UJs=;
        b=oMul93UbSv+TBIPX+kbq5Ken4oKip/YLHFUS3qJbY30pVfEgQkJhBmJKgM7M8Qh7kx
         vCKSK6tzSj37OvNtjVWFxSFWAPX9sVFm8XHsvoFi5dtppU5jcy/dDr0Dtw1px3fM/YOl
         dhGNjUu2ufmROeF00rB3o5xQbqmkP7pvcxFepMTpr+CyMfCOZ/2zmlJLrgdQwu6Ybt1X
         HG8lm8zh+gLKza8UYTpSCb5DB7Dfs7op29Gk1BFXTdwPGh3b4mTFj6COzLzB4dL+zGi8
         wlFBjgVsSl95Zhjl6juOIzPtD2Cgn+Xa2KqpEi4MuhXdVgIPScavEZ+ohNcrGZd4S1RJ
         erxQ==
X-Gm-Message-State: APjAAAWfXcHKPPeHVuUgj9A+AMfxqOTvGr3q0CjDdaZDd35mE1KgyQcV
        8pDdu7P32BemvfTut0zUaQQw3h8sCkmWBOq4AJQduhwNckoLs1PCLtGOe/hhEWu41u5I20q9xo8
        B5ZgTkY3qtxyVWQHGU6Tl4p4EkJVCB9WgGyV9Kd21EUOkax/jurI/WhSU9vLHF49xuNW6Pt/f0g
        ==
X-Google-Smtp-Source: APXvYqxdEtsmjjl7WLUyBeVPqeKChgpgox911G/+csv0kydNkAu6wWDK03jZOfTvv2bbswFKDiuO6Q==
X-Received: by 2002:adf:f091:: with SMTP id n17mr7951312wro.387.1576174627119;
        Thu, 12 Dec 2019 10:17:07 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id j21sm7928736wmj.39.2019.12.12.10.17.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Dec 2019 10:17:06 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 0/9] Add ipv6 tunnel support to NFP
Date:   Thu, 12 Dec 2019 18:16:47 +0000
Message-Id: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patches add support for IPv6 tunnel offload to the NFP
driver.

Patches 1-2 do some code tidy up and prepare existing code for reuse in
IPv6 tunnels.
Patches 3-4 handle IPv6 tunnel decap (match) rules.
Patches 5-8 handle encap (action) rules.
Patch 9 adds IPv6 support to the merge and pre-tunnel rule functions.

John Hurley (9):
  nfp: flower: pass flow rule pointer directly to match functions
  nfp: flower: move udp tunnel key match compilation to helper function
  nfp: flower: compile match for IPv6 tunnels
  nfp: flower: offload list of IPv6 tunnel endpoint addresses
  nfp: flower: modify pre-tunnel and set tunnel action for ipv6
  nfp: flower: handle ipv6 tunnel no neigh request
  nfp: flower: handle notifiers for ipv6 route changes
  nfp: flower: support ipv6 tunnel keep-alive messages from fw
  nfp: flower: update flow merge code to support IPv6 tunnels

 drivers/net/ethernet/netronome/nfp/flower/action.c |  65 ++-
 drivers/net/ethernet/netronome/nfp/flower/cmsg.c   |  11 +-
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   | 106 ++++-
 drivers/net/ethernet/netronome/nfp/flower/main.h   |  38 +-
 drivers/net/ethernet/netronome/nfp/flower/match.c  | 260 +++++++----
 .../net/ethernet/netronome/nfp/flower/offload.c    | 144 ++++--
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    | 497 ++++++++++++++++++---
 7 files changed, 892 insertions(+), 229 deletions(-)

-- 
2.7.4

