Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBD65BB0F8
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiIPQPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiIPQPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:15:06 -0400
X-Greylist: delayed 324 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Sep 2022 09:15:04 PDT
Received: from simonwunderlich.de (simonwunderlich.de [IPv6:2a01:4f8:c17:e8c0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A8C4DB0A
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 09:15:03 -0700 (PDT)
Received: from kero.packetmixer.de (p200300C5973C57d0711F6270f7F2CD25.dip0.t-ipconnect.de [IPv6:2003:c5:973c:57d0:711f:6270:f7f2:cd25])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 283D3FA2A3;
        Fri, 16 Sep 2022 18:15:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=simonwunderlich.de;
        s=09092022; t=1663344902; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=j8cDjhIxoCzbEq7g/kjPH9w3j4uzP+AuSWHYH63K7oM=;
        b=tBX0Nq/A/D2TfRUM4OZkN+LQoF6XNt0Ple44iPXnkF+1o05NIpwsJB5I7jh4YjPZ1jvwnl
        cPVQG/KjIItkiMMWu+s9qugw2keENnyI0ktY4VZhHrx1QlLWkNBeutqMHy89+cQspYbxBz
        HWt+a/STYkmKmAvhT956dY+figfFD3PN7YkJsp+3zwPYPwdAluYef/52HRsFbrs1pa58m6
        L8X8oHCiuB4+KzoKIpckpOOQ2KvjuD6mzX6WDABEtrlDDbvbRvIqNKNfioW2GO4+vOpBWP
        OPAllBn0emj1NzL75M/hZmFJXb0ekjtlA9RRRlT3iQ+Nnwlfw6TVlPsdmK7zGA==
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/4] pull request for net-next: batman-adv 2022-09-16
Date:   Fri, 16 Sep 2022 18:14:50 +0200
Message-Id: <20220916161454.1413154-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=simonwunderlich.de; s=09092022; t=1663344902;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=j8cDjhIxoCzbEq7g/kjPH9w3j4uzP+AuSWHYH63K7oM=;
        b=P0Jtph5HV6gbDJDxfeNazCXgNkFh3RdTeOfNHQNwhtptsTXmEKCePaNIkFs1+Xq0hm8JC5
        oGJIEcStmZaCRDaughJIQwPW7sWfqm2Gyy+t84D/+P6pCxa7SjQbHeSdbrswF6MRYBjbvD
        pU3ZkEgcPutLGhXBVplIqusN1XUI5tBdBGahqnolTYktHu/Y4xfQOUzaMZVMceDiYsDdQm
        PCtWlKlg/8GbCBDqh4VB/Fos9wWScMw+LEz7KaGmclAVq0C0H95WcaREMbTG9ZWYdGplb2
        kqd2KXMjlWR/ykCCSuYCQf33Vj7ey3i5nS/VpsqS3cW5JUfQcPlH77tZG5ORlA==
ARC-Seal: i=1; s=09092022; d=simonwunderlich.de; t=1663344902; a=rsa-sha256;
        cv=none;
        b=vOvxmNhhlhXTqmnm8TxzNXS8Obw6kz7kMnRqD6B2x1tK0cP8KWF7zBRmSngbUQd4+hztm3adhHpe9Xilun5sSfZ7RTVfoYps1G2Vfp6+udZNMwF1n7zkaICpcP67h3Ad2KZSJ8F5FFfOOBOwc6sC3U9Z3PBqibpHSEadmlay994NKWAuLU9XhOdC/7pTIQCMmbpDiSU1VoCDCE/EvdbWKZtwI1A12qjSyGpFtn2v6h+dL29M9u2fS8+/hL52Ht8NiTZLD8OS0ljtfkMPVzh+rxWvv1JDMFBC9dZJme9QqI0ZFLpPJ+pZ1AUWwjj6EQfW7dKpasb1bkK/i8Th80RieA==
ARC-Authentication-Results: i=1;
        simonwunderlich.de;
        auth=pass smtp.auth=sw@simonwunderlich.de smtp.mailfrom=sw@simonwunderlich.de
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, hi David,

here is a little cleanup pull request of batman-adv to go into net-next.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 568035b01cfb107af8d2e4bd2fb9aea22cf5b868:

  Linux 6.0-rc1 (2022-08-14 15:50:18 -0700)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-pullrequest-20220916

for you to fetch changes up to 76af7483b3c7c42571aae767b553ef7d436305e9:

  batman-adv: remove unused struct definitions (2022-09-15 08:16:05 +0200)

----------------------------------------------------------------
This cleanup patchset includes the following patches:

 - bump version strings, by Simon Wunderlich

 - drop unused headers in trace.h, by Sven Eckelmann

 - drop initialization of flexible ethtool_link_ksettings,
   by Sven Eckelmann

 - remove unused struct definitions, by Marek Lindner

----------------------------------------------------------------
Marek Lindner (1):
      batman-adv: remove unused struct definitions

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Sven Eckelmann (2):
      batman-adv: Drop unused headers in trace.h
      batman-adv: Drop initialization of flexible ethtool_link_ksettings

 net/batman-adv/bat_v_elp.c |  1 -
 net/batman-adv/main.h      |  2 +-
 net/batman-adv/trace.h     |  2 --
 net/batman-adv/types.h     | 39 ---------------------------------------
 4 files changed, 1 insertion(+), 43 deletions(-)
