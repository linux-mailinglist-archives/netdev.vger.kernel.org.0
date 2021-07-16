Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCB93CB018
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 02:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhGPAkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 20:40:22 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:47147 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbhGPAkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 20:40:21 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id D3274806B5;
        Fri, 16 Jul 2021 12:37:25 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1626395845;
        bh=68gvUVrMgDWcYm5Vk9ECjsxj2GI5s4rQAgjRIsKQKvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Nt1GmSPplfHMvM1UepuAgakcvZr+UHZsNvonK6BZWTxna1DMyaI3bKd/kbfVUbBPy
         QPq1NpP4dDCPftUiRvjKoQIk+/niSv815vSCQMK746fFKchVgFMReeFuoe8u4xtbON
         VxYIRL8QAT+LCUsv3bddifUNA62CWIS+s3nKHBlrlNurq4w0Jf7iHXn+WnV7MnBOK3
         9rZpfxemEpfSc38DnctVMcgkKKO2eMHboExgf6sgQONJh3Hsx84CBPIinQ2UiomvVv
         Zwg3wad9pteuF7Z8Ee8tMn6zPa4bLguKsprmFZkao/p8VPecvBZuXs7Yy224JokRqZ
         iVPNU5CJFia3g==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60f0d4c50000>; Fri, 16 Jul 2021 12:37:25 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id A711113EE58;
        Fri, 16 Jul 2021 12:37:25 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id A1CD22428E7; Fri, 16 Jul 2021 12:37:25 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Subject: [PATCH 0/3] Add RFC-7597 Section 5.1 PSID support
Date:   Fri, 16 Jul 2021 12:27:39 +1200
Message-Id: <20210716002742.31078-1-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210705103959.GG18022@breakpoint.cc>
References: <20210705103959.GG18022@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Sr3uF8G0 c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=e_q4qTt1xDgA:10 a=UaPN0VJYGzK_QuBb5qYA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your time reviewing!

Changes in v4:
- Handle special case of no offset bits (a=3D0 / A=3D2^16).

Cole Dishington (3):
  net: netfilter: Add RFC-7597 Section 5.1 PSID support xtables API
  net: netfilter: Add RFC-7597 Section 5.1 PSID support
  selftests: netfilter: Add RFC-7597 Section 5.1 PSID selftests

 include/uapi/linux/netfilter/nf_nat.h         |   3 +-
 net/netfilter/nf_nat_core.c                   |  39 +++-
 net/netfilter/nf_nat_masquerade.c             |  20 +-
 net/netfilter/xt_MASQUERADE.c                 |  44 ++++-
 .../netfilter/nat_masquerade_psid.sh          | 182 ++++++++++++++++++
 5 files changed, 276 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/nat_masquerade_psid=
.sh

--=20
2.32.0

