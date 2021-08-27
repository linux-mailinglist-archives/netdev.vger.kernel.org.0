Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A81E3F9579
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 09:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244501AbhH0HvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 03:51:11 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41138 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244429AbhH0HvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 03:51:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id BDC68205CB;
        Fri, 27 Aug 2021 09:50:18 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id E4GPogPYmgBy; Fri, 27 Aug 2021 09:50:18 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 492FF20582;
        Fri, 27 Aug 2021 09:50:18 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 43E4080004A;
        Fri, 27 Aug 2021 09:50:18 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 09:50:18 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 27 Aug
 2021 09:50:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A58BE318040A; Fri, 27 Aug 2021 09:50:17 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2021-08-27
Date:   Fri, 27 Aug 2021 09:50:12 +0200
Message-ID: <20210827075015.2584560-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Remove an unneeded extra variable in esp4 esp_ssg_unref.
   From Corey Minyard.

2) Add a configuration option to change the default behaviour
   to block traffic if there is no matching policy.
   Joint work with Christian Langrock and Antony Antony.

3) Fix a shift-out-of-bounce bug reported from syzbot.
   From Pavel Skripkin.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit c18e9405d46aa08bb4b55a35ee9bcc66ef3e89e0:

  Merge branch 's390-next' (2021-07-20 06:23:50 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to 5d8dbb7fb82b8661c16d496644b931c0e2e3a12e:

  net: xfrm: fix shift-out-of-bounce (2021-07-29 08:04:10 +0200)

----------------------------------------------------------------
Corey Minyard (1):
      ipsec: Remove unneeded extra variable in esp4 esp_ssg_unref()

Pavel Skripkin (1):
      net: xfrm: fix shift-out-of-bounce

Steffen Klassert (1):
      xfrm: Add possibility to set the default to block if we have no policy

 include/net/netns/xfrm.h  |  7 ++++++
 include/net/xfrm.h        | 36 +++++++++++++++++++++++++-----
 include/uapi/linux/xfrm.h | 11 +++++++++
 net/ipv4/esp4.c           |  4 +---
 net/xfrm/xfrm_policy.c    | 16 +++++++++++++
 net/xfrm/xfrm_user.c      | 57 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 122 insertions(+), 9 deletions(-)
