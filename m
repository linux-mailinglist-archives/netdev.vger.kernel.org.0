Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1379B4B956D
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 02:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiBQBVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 20:21:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiBQBVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 20:21:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8C4B22;
        Wed, 16 Feb 2022 17:21:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12E7F61C61;
        Thu, 17 Feb 2022 01:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E58BC004E1;
        Thu, 17 Feb 2022 01:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645060885;
        bh=C9p5zT8lGRV69Pb2BRsMVMh5nhIv/NQvZ0uULolUcjg=;
        h=From:To:Cc:Subject:Date:From;
        b=cU11hY4ZBh48TjCHaDMtiom8jBzF9B7/pYlWZQKDqBld2UAtqdf5slx89wexAMkvW
         2Mhdlp8SZO6yE/ozZeA6r92H7Kp0IyvRvsZk76Sccy6Gb9skinUaOs6Ahlk9DQnBxa
         9Fclc6q/ngol6YDSDQctuApzgV+/T6NP0EGB1O2j6BQpbY+oN0ezbmOeQLaDLzskca
         72LVUBgAaiS1oJXj0mHViHzZ5j6Ay4mAv2EP24uIwde/RNs6gKj2Oqg4plfUcz3ETh
         aPKvFGHEqYMReD6PG+JH9GY7JEJ5qd27pG+S8Phm4VkIRV81kq0HUtUxv+qWZS9MsN
         cbpUEXwdNKRhw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/5] net: ping6: support setting basic SOL_IPV6 options via cmsg
Date:   Wed, 16 Feb 2022 17:21:15 -0800
Message-Id: <20220217012120.61250-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for IPV6_HOPLIMIT, IPV6_TCLASS, IPV6_DONTFRAG on ICMPv6
sockets and associated tests. I have no immediate plans to
implement IPV6_FLOWINFO and all the extension header stuff.

Jakub Kicinski (5):
  net: ping6: support setting basic SOL_IPV6 options via cmsg
  selftests: net: test IPV6_DONTFRAG
  selftests: net: test IPV6_TCLASS
  selftests: net: test IPV6_HOPLIMIT
  selftests: net: basic test for IPV6_2292*

 net/ipv6/ip6_output.c                     |   1 +
 net/ipv6/ping.c                           |  21 ++-
 tools/testing/selftests/net/cmsg_ipv6.sh  | 156 ++++++++++++++++++++
 tools/testing/selftests/net/cmsg_sender.c | 170 +++++++++++++++++++---
 4 files changed, 320 insertions(+), 28 deletions(-)
 create mode 100755 tools/testing/selftests/net/cmsg_ipv6.sh

-- 
2.34.1

