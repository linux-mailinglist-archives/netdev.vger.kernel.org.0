Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35AA5BB0FD
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiIPQPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiIPQPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:15:43 -0400
Received: from simonwunderlich.de (simonwunderlich.de [IPv6:2a01:4f8:c17:e8c0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D199882D09
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 09:15:42 -0700 (PDT)
Received: from kero.packetmixer.de (p200300C5973C57d0711f6270f7F2cD25.dip0.t-ipconnect.de [IPv6:2003:c5:973c:57d0:711f:6270:f7f2:cd25])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id B1AE0FA29E;
        Fri, 16 Sep 2022 18:09:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=simonwunderlich.de;
        s=09092022; t=1663344575; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=/JlKBLlvtqbz3uK4w9fmhVHjkatHR5ELc2la42chLkg=;
        b=kzZgvGrCwJnz16Ns4RmHA5WIzxdWHO9LdIaxOkQ75URRJ9cJI8xS7iphylkvzXcT7cnKMv
        6GutZFdbBl4739YH6U1gZPCPP9/pF61l6X5puIFMAuA38cifnafQSbHngIn4fsoHHN7/ID
        hDxY6Jig1T7UdpOt4XelOIF/yEB9V9PEzGERBsylLPPQNZQper8GoXFbDDhHlqCFFHqagS
        xiapi0Z7YdZCpTozbKw4eWkBmo3jhA8Z5fW5wY41OKWbWpF1LfQiey/Lmey8yZSJzfm9+b
        mpMA1uJ2i3Fi5pHI5DR+MmLIdZpEeBvZpS8/e+nuZQ9Oy6JQJAcoVSjzAvUiZg==
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/1] pull request for net: batman-adv 2022-09-16
Date:   Fri, 16 Sep 2022 18:09:30 +0200
Message-Id: <20220916160931.1412407-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=simonwunderlich.de; s=09092022; t=1663344575;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=/JlKBLlvtqbz3uK4w9fmhVHjkatHR5ELc2la42chLkg=;
        b=dtSAsixbXtlzpk3Fz1sQa+GVyIEsB9DUyt9MFGtCjcaCbAI+/uZUHBkWW/092z36dAzhYB
        BnFFk9zA+z3iHSwTeoZ+0KUGI7YX7U/Xd+gh6JNzLQ0Gmap9cmWooGekDqN4Y1kzYjGGFD
        w7uDpVyuFw22WNriqT0oLphSpzTG9ayXw9gKLOOEpUDo9LcNYOFQ3KTX3jc6PmaHkiAOD+
        PpEFlfS1ebJ6T+FLhoIX6ZdII8DSKYDbQ/VRKQY23oFzXtd4osOaN3SU62rs9mY4YUf6Mt
        VSx42wERtjuUwgHLOEs7VGFe5FSA+lSx3lhgy9+KESwF4ymtnZAWlERUoEqlZA==
ARC-Seal: i=1; s=09092022; d=simonwunderlich.de; t=1663344575; a=rsa-sha256;
        cv=none;
        b=uxV3B8BWgbKjM/IbHWzG0FfnwLmmOjEuutbJyRrpGjs7OAqMJQN6C1kixfdgFiAuMf0K0EDRbJv7kMQumInGdbohIz3pQupw3ZyTurD5Kbub+iy9TRbWt3ZJYrUML5A9SbUbepB0Htedj7fvMFTCZl/+wuIB50j+Q9CRVoAXbSG6LBVtgFzgLCUNgwK5sjsvuwsaTEbX6mZfW71spl5edT8vPMDk6lxiMUi8+H3h3o6/ErNaUL5ENszpKMSVmGCXYwWYb5h2MIxgWjbBuYFOcgAsqZqbIpIkshLmXMdbBV5VJm5qmK25t0t9qSx4o/tA7SIGz6dJWwpVPVe5Tf0cGQ==
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

Hi David, hi Jakub,

here is a bugfix for batman-adv which we would like to have integrated into net.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 568035b01cfb107af8d2e4bd2fb9aea22cf5b868:

  Linux 6.0-rc1 (2022-08-14 15:50:18 -0700)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-pullrequest-20220916

for you to fetch changes up to b1cb8a71f1eaec4eb77051590f7f561f25b15e32:

  batman-adv: Fix hang up with small MTU hard-interface (2022-08-20 14:17:45 +0200)

----------------------------------------------------------------
Here is a batman-adv bugfix:

 - Fix hang up with small MTU hard-interface, by Shigeru Yoshida

----------------------------------------------------------------
Shigeru Yoshida (1):
      batman-adv: Fix hang up with small MTU hard-interface

 net/batman-adv/hard-interface.c | 4 ++++
 1 file changed, 4 insertions(+)
