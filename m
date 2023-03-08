Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B0A6AFB2A
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 01:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCHAcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 19:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjCHAcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 19:32:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5147B1B2DA;
        Tue,  7 Mar 2023 16:32:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01B1BB81B31;
        Wed,  8 Mar 2023 00:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBA9C433EF;
        Wed,  8 Mar 2023 00:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678235531;
        bh=blFf7LM1kVUSU/7NmqU8jAZjIzm4UPa2CbkA7jd2VGI=;
        h=From:To:Cc:Subject:Date:From;
        b=pZGqHldpzsd71XIj1a4ozHNnrlUHWIpE/yhZ33xRGMuUGcwAwbgNCGw04eb0+KBgP
         udny2unld7CHIgnCCZWESD2jiiAHpF9aOPwtgsHRO42M4UenWLVy7TkRAzHa3aGmEQ
         kbuAt2QGZr6jli+FaZuqms+p5l47wOTxJAaxNL7kIx+V7lm6leiyzFE/42kJwbMI23
         M7hGIpi/+5dCrnazkQvzEOJ4Ixl8NSk8QPBYRqNS1i/PQVa1uTF68zK5RoT+JSmMi2
         ZkDZhEaBLRtf635gi93w1TVLc4lbhueSRKSO4eU0T16G5VkhF5R3ryN4fzMlCkc3j4
         eXbA4z3RwEDAQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next 0/3] net: skbuff: skb bitfield compaction - bpf
Date:   Tue,  7 Mar 2023 16:31:56 -0800
Message-Id: <20230308003159.441580-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm trying to make more of the sk_buff bits optional.
Move the BPF-accessed bits a little - because they must
be at coding-time-constant offsets they must precede any
optional bit. While at it clean up the naming a bit.

Jakub Kicinski (3):
  net: skbuff: rename __pkt_vlan_present_offset to __mono_tc_offset
  net: skbuff: reorder bytes 2 and 3 of the bitfield
  net: skbuff: move the fields BPF cares about directly next to the
    offset marker

 include/linux/skbuff.h                        | 36 +++++++++----------
 net/core/filter.c                             |  8 ++---
 .../selftests/bpf/prog_tests/ctx_rewrite.c    |  6 ++--
 3 files changed, 25 insertions(+), 25 deletions(-)

-- 
2.39.2

