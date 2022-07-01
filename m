Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0730E562D50
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 10:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235837AbiGAH6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 03:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbiGAH6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 03:58:51 -0400
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6CA5A2F8
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 00:58:49 -0700 (PDT)
Received: from [2a02:169:59c5:1:7d5c:5092:64f9:9cbc] (helo=areia)
        by eidolon.nox.tf with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1o7BY5-00F8pB-Pv; Fri, 01 Jul 2022 09:58:46 +0200
Received: from equinox by areia with local (Exim 4.96)
        (envelope-from <equinox@diac24.net>)
        id 1o7BXi-000HAP-1y;
        Fri, 01 Jul 2022 09:58:22 +0200
From:   David Lamparter <equinox@diac24.net>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Lamparter <equinox@diac24.net>
Subject: [PATCH resend net-next 0/2] ip6mr: implement RTM_GETROUTE for single entry
Date:   Fri,  1 Jul 2022 09:58:03 +0200
Message-Id: <20220701075805.65978-1-equinox@diac24.net>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630202706.33555ad2@kernel.org>
References: <20220630202706.33555ad2@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[resend with a slightly random pick of Cc:s - apologies if I ended up
choosing poorly]

The IPv6 multicast routing code implements RTM_GETROUTE, but only for a
dump request.  Retrieving a single MFC entry is not currently possible
via netlink.

While most of the data here can also be retrieved with SIOCGETSGCNT_IN6,
the lastused / RTA_EXPIRES is not included in the ioctl result (and we
need it in FRR.)

=> Implement single-entry RTM_GETROUTE by copying and adapting the IPv4
code.

Tested against FRRouting's (work-in-progress) IPv6 PIM implementation.

Cheers,


-David
