Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BADD698374
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjBOSgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjBOSfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:35:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2853CE37
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676486034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nHgdN73etI9BOc0dWoP8qk1YXtBXpucFEyaaprchUyY=;
        b=ctSeku2nFj5uKFTj6puGDay1IJQXtKqlgHqm7vWMUe7P8lfMWYe+H2cuE3TllvGjawqphY
        Yar+K+d7yf7LkOXuJ0GQtzBnMSqVn3WCOdd/eI0lWmE89KM17XlDKaL4AFBZ7qjNv4ieXl
        n2xyt9UNvotH57FLEGc2Qy+K0VD8IAo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-6z-rrOZ0PXCmqcf1-fZ4ng-1; Wed, 15 Feb 2023 13:33:51 -0500
X-MC-Unique: 6z-rrOZ0PXCmqcf1-fZ4ng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B7E9101A52E;
        Wed, 15 Feb 2023 18:33:50 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 542F940C1106;
        Wed, 15 Feb 2023 18:33:49 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Shuah Khan <shuah@kernel.org>
Subject: [PATCH net-next 0/2] net: default_rps_mask follow-up
Date:   Wed, 15 Feb 2023 19:33:35 +0100
Message-Id: <cover.1676484775.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch namespacify the setting: once proper isolation
is in place in the main namespace, additional demux in the child
namespaces will be redundant.
The 2nd patch adds more self-tests coverage.

Paolo Abeni (2):
  net: make default_rps_mask a per netns attribute
  self-tests: more rps self tests

 include/linux/netdevice.h                     |  1 -
 include/net/netns/core.h                      |  5 ++
 net/core/net-sysfs.c                          | 23 ++++++---
 net/core/sysctl_net_core.c                    | 50 ++++++++++++++-----
 .../testing/selftests/net/rps_default_mask.sh | 41 ++++++++++-----
 5 files changed, 87 insertions(+), 33 deletions(-)

-- 
2.39.1

