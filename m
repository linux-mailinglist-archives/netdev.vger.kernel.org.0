Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF916361E1
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237753AbiKWObQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235433AbiKWOad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:30:33 -0500
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39671570F
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:29:40 -0800 (PST)
Received: from [192.168.16.157] (helo=fisk.sw.ru)
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <nikolay.borisov@virtuozzo.com>)
        id 1oxqjg-001EZF-7o;
        Wed, 23 Nov 2022 15:28:24 +0100
From:   Nikolay Borisov <nikolay.borisov@virtuozzo.com>
To:     nhorman@tuxdriver.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, kernel@virtuozzo.com,
        Nikolay Borisov <nikolay.borisov@virtuozzo.com>
Subject: [PATCH net-next v2 0/3] Add support for netnamespace filtering in drop monitor
Date:   Wed, 23 Nov 2022 16:28:14 +0200
Message-Id: <20221123142817.2094993-1-nikolay.borisov@virtuozzo.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for conveying as well as filtering based on the the
id of the net namespace where a particular event originated. This is especially
useful when dealing with systems hosting 10s or 100s of containers.

Currently software as well as devlink-originated drops are supported. The output
would look like the following:

11 drops at location 0xffffffffad8cd0c3 [software] [ns: 4026532485]
11 drops at location 0xffffffffad8cd0c3 [software] [ns: 4026532513]

Changes in v2:
 * Fixed the inadvertent uapi breakage by appending the newly added netlink
 attributes. All tests are now passing.


Nikolay Borisov (3):
  drop_monitor: Implement namespace filtering/reporting for software
    drops
  drop_monitor: Add namespace filtering/reporting for hardware drops
  selftests: net: Add drop monitor tests for namespace filtering
    functionality

 include/uapi/linux/net_dropmon.h              |   3 +
 net/core/drop_monitor.c                       |  64 ++++++++-
 .../selftests/net/drop_monitor_tests.sh       | 127 +++++++++++++++---
 3 files changed, 171 insertions(+), 23 deletions(-)

--
2.34.1

