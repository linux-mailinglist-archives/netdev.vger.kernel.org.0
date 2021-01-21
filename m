Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5F42FE9C7
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731020AbhAUMRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:17:15 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:54596 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbhAUMQu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 07:16:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E710C201D5;
        Thu, 21 Jan 2021 13:16:02 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MtFDlG-7CUgr; Thu, 21 Jan 2021 13:16:02 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 714EA2026E;
        Thu, 21 Jan 2021 13:16:02 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 21 Jan 2021 13:16:02 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 21 Jan
 2021 13:16:02 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 902C3318255C;
 Thu, 21 Jan 2021 13:16:01 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2021-01-21
Date:   Thu, 21 Jan 2021 13:15:53 +0100
Message-ID: <20210121121558.621339-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix a rare panic on SMP systems when packet reordering
   happens between anti replay check and update.
   From Shmulik Ladkani.

2) Fix disable_xfrm sysctl when used on xfrm interfaces.
   From Eyal Birger.

3) Fix a race in PF_KEY when the availability of crypto
   algorithms is set. From Cong Wang.

4) Fix a return value override in the xfrm policy selftests.
   From Po-Hsu Lin.

5) Fix an integer wraparound in xfrm_policy_addr_delta.
   From Visa Hankala.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 7f376f1917d7461e05b648983e8d2aea9d0712b2:

  Merge tag 'mtd/fixes-for-5.10-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux (2020-12-11 14:29:46 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to da64ae2d35d3673233f0403b035d4c6acbf71965:

  xfrm: Fix wraparound in xfrm_policy_addr_delta() (2021-01-04 10:35:09 +0100)

----------------------------------------------------------------
Cong Wang (1):
      af_key: relax availability checks for skb size calculation

Eyal Birger (1):
      xfrm: fix disable_xfrm sysctl when used on xfrm interfaces

Po-Hsu Lin (1):
      selftests: xfrm: fix test return value override issue in xfrm_policy.sh

Shmulik Ladkani (1):
      xfrm: Fix oops in xfrm_replay_advance_bmp

Visa Hankala (1):
      xfrm: Fix wraparound in xfrm_policy_addr_delta()

 net/key/af_key.c                           |  6 ++--
 net/xfrm/xfrm_input.c                      |  2 +-
 net/xfrm/xfrm_policy.c                     | 30 +++++++++++++-------
 tools/testing/selftests/net/xfrm_policy.sh | 45 +++++++++++++++++++++++++++++-
 4 files changed, 68 insertions(+), 15 deletions(-)
