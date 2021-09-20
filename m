Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B74E410E69
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 04:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbhITCkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 22:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbhITCkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 22:40:39 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB78DC061760
        for <netdev@vger.kernel.org>; Sun, 19 Sep 2021 19:39:13 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 36C9483651;
        Mon, 20 Sep 2021 14:39:10 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1632105550;
        bh=2tBCxU7JOtj953QJ0/jqjqh9rtygww4o1cyb5ZL3qK0=;
        h=From:To:Cc:Subject:Date;
        b=xa6kqeMrDkEo1xW71Q9MTnfBJDKuHzMwIwd2eEuwr5G0SK9jgFqJs1cr/vUAEfaC4
         vwMOsEfM7Cxyi7Sddh8tFhEiLvmYfkpXOnYsgcVtttxnHktEY3tMiUL4EMs5bGfjdm
         EG5gg7hqDA/UE2939XW+nqmZ10J4VweNNx+HhQxoAZJrmNfMf2ZAq181Lnk1MXilHc
         7ePEbt9XqfXkhy4x2vY4TH8WTvO1LvxxLUTCJ67an+3rXAjxDkOqdRygB4I9pBM6oj
         s89B5nRMRc10pEhVjRmOqAIqAMLJjQaK4UhdIkYUI6cDRo4TQwuYYab+OunNN8JoD0
         AFHjTSCdA0UCg==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6147f44e0000>; Mon, 20 Sep 2021 14:39:10 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id DB2E613EE3F;
        Mon, 20 Sep 2021 14:39:09 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id D3C1D24285E; Mon, 20 Sep 2021 14:39:09 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org
Cc:     linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Subject: [RESEND PATCH net-next v7 0/3] Add RFC-7597 Section 5.1 PSID support
Date:   Mon, 20 Sep 2021 14:38:03 +1200
Message-Id: <20210920023806.19954-1-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=FtN7AFjq c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=7QKq2e-ADPsA:10 a=iXia_AmJyaINQBOU7VYA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resend to add v7 to subject to detect cover letter in patchwork.

Cole Dishington (3):
  net: netfilter: Add RFC-7597 Section 5.1 PSID support xtables API
  net: netfilter: Add RFC-7597 Section 5.1 PSID support
  selftests: netfilter: Add RFC-7597 Section 5.1 PSID selftests

 include/uapi/linux/netfilter/nf_nat.h         |   3 +-
 net/netfilter/nf_nat_core.c                   |  39 +++-
 net/netfilter/nf_nat_masquerade.c             |  27 ++-
 net/netfilter/xt_MASQUERADE.c                 |  44 ++++-
 .../netfilter/nat_masquerade_psid.sh          | 182 ++++++++++++++++++
 5 files changed, 283 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/nat_masquerade_psid=
.sh

--=20
2.33.0

