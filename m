Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A145462147
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 21:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242112AbhK2UDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 15:03:49 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48346 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352616AbhK2UBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 15:01:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7EAECCE13DE
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 19:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21821C53FAD;
        Mon, 29 Nov 2021 19:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638215907;
        bh=bctvTNidKaCjD9cheDo0oLTYboxrl/9Hkt+FM+AZ9AU=;
        h=From:To:Cc:Subject:Date:From;
        b=oF13BB+5qSpVhtt+uCGjsg7zVROfktzJhmp5/0W86THombBzcaxlzb5OZVgu7+/Ea
         vjPJLMzJsKggdaeIzYgHEQaQds1GJstwQnv538ynwyLAMPHx1Xtl0qTvvdX8Wqc/+j
         Rs1r3j+yNrpaK4w1fIjJDjKpVq6x1SywPSzux8HWXMccxaBDvcLUxZPrvApbnvYFg8
         b1DOR+zqgfhHPJ5KJzNnAsA4qDxBiyMFYOY0CtTgr/FFb7atXp6xRYcQ2AQhGrgZwC
         AaVPz11BxpPxfoqB+1aRyGVw+FDlNwLdqrlNj7dd7cIX5DvDx9SAXXzsj5U8sEra19
         dfB9jBcGGLeZQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 0/6] mv88e6xxx fixes (mainly 88E6393X family)
Date:   Mon, 29 Nov 2021 20:58:17 +0100
Message-Id: <20211129195823.11766-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

so I managed to discovered how to fix inband AN for 2500base-x mode on
88E6393x (Amethyst) family.

This series fixes application of erratum 4.8, adds fix for erratum 5.2,
adds support for completely disablign SerDes receiver / transmitter,
fixes inband AN for 2500base-x mode by using 1000base-x mode and simply
changing frequeny to 3.125 GHz, all this for 88E6393X.

The last commit fixes linking when link partner has AN disabled and the
device invokes the AN bypass feature. Currently we fail to link in this
case.

Marek

Marek Behún (6):
  net: dsa: mv88e6xxx: Fix application of erratum 4.8 for 88E6393X
  net: dsa: mv88e6xxx: Drop unnecessary check in
    mv88e6393x_serdes_erratum_4_6()
  net: dsa: mv88e6xxx: Save power by disabling SerDes trasmitter and
    receiver
  net: dsa: mv88e6xxx: Add fix for erratum 5.2 of 88E6393X family
  net: dsa: mv88e6xxx: Fix inband AN for 2500base-x on 88E6393X family
  net: dsa: mv88e6xxx: Link in pcs_get_state() if AN is bypassed

 drivers/net/dsa/mv88e6xxx/serdes.c | 240 +++++++++++++++++++++++++----
 drivers/net/dsa/mv88e6xxx/serdes.h |   4 +
 2 files changed, 213 insertions(+), 31 deletions(-)

-- 
2.32.0

