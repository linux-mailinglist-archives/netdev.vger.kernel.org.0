Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E23751592C
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 01:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381805AbiD2X6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 19:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381673AbiD2X6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 19:58:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FF92B1A9
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 16:55:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67F90B837EE
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 23:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4841C385A4;
        Fri, 29 Apr 2022 23:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651276522;
        bh=PdGbCIcrQATUIiFY6dON1JkLp+6Mvw0lHrxpEYhX974=;
        h=From:To:Cc:Subject:Date:From;
        b=MrYcfr8z9NCO/i7js5QnsAH/LYTzVQ05YRP5wuMfyVtYLAeFbu3U/yWb9pCcNQ5eG
         cYSaGhP77/SEgJmQlnMpZD67rPaoEXUQWIdqC8WsB33nkcZulZsZ/PfDNHHint03ZA
         Te40rseK6DNBiRM/Ughq/QHX5eUzYeURw1dyHkzcgzlC+pqpJvzEmkA/QFz0lkqe7b
         JRjdSx3wHxckyT2HEU6JqdWhEz3zacJKy+0RBxkN2PSawiubCImFu0Xfd+AaFw6Nmw
         WEf8IVojsbSqWTjQDNgUgiFCOmfmPwxmswTAaTGQYW+8dYzLICsU2K9Ea0KVPcn+R5
         MuXetItX3ZCxw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        petrm@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] net: more heap allocation and split of rtnl_newlink()
Date:   Fri, 29 Apr 2022 16:55:05 -0700
Message-Id: <20220429235508.268349-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Small refactoring of rtnl_newlink() to fix a stack usage warning
and make the function shorter.

Jakub Kicinski (3):
  rtnl: allocate more attr tables on the heap
  rtnl: split __rtnl_newlink() into two functions
  rtnl: move rtnl_newlink_create()

 net/core/rtnetlink.c | 200 +++++++++++++++++++++++--------------------
 1 file changed, 109 insertions(+), 91 deletions(-)

-- 
2.34.1

