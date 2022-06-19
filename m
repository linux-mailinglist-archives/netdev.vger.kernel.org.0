Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE21B550D95
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 01:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbiFSXaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 19:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbiFSXaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 19:30:08 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E626C64E8
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 16:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655681407; x=1687217407;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t7AlYIum/a9+GUx51g3WLnVjff9r80BRhL/PotZnZLk=;
  b=a763ugN9I2Ycs6fTwqK8tVSAM6CT+fYNN/22+TPzJbd+HxhGQn8ZI8Kb
   02JQfJYF9wQD+YkMh7xrGsakg1zxm4BV/9xhP2Vox7HE3RymhDu135hmQ
   JCW4aBxmotjrbgPFWqRhrYPsZsXE6r/DK5+5wWs9nZZPg1QMpSya8GIyV
   E=;
X-IronPort-AV: E=Sophos;i="5.92,306,1650931200"; 
   d="scan'208";a="99448265"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-b69ea591.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 19 Jun 2022 23:29:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-b69ea591.us-east-1.amazon.com (Postfix) with ESMTPS id 348EAC0913;
        Sun, 19 Jun 2022 23:29:50 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 19 Jun 2022 23:29:50 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.133) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 19 Jun 2022 23:29:49 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 0/2] raw: Fix nits of RCU conversion series.
Date:   Sun, 19 Jun 2022 16:29:25 -0700
Message-ID: <20220619232927.54259-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.162.133]
X-ClientProxiedBy: EX13D05UWB003.ant.amazon.com (10.43.161.26) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch fixes a build error by commit ba44f8182ec2 ("raw: use
more conventional iterators"), but it does not land in the net tree,
so this series is targeted to net-next.  The second patch replaces some
hlist functions with sk's helper macros.


Kuniyuki Iwashima (2):
  raw: Fix mixed declarations error in raw_icmp_error().
  raw: Use helpers for the hlist_nulls variant.

 net/ipv4/raw.c      | 10 +++++-----
 net/ipv4/raw_diag.c |  4 ++--
 net/ipv6/raw.c      |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.30.2

