Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995846C1119
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 12:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjCTLqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 07:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjCTLp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 07:45:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6461557D
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 04:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679312710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=INF4O3g/252+V0l5EH2kOmgTnmLXGTRQexWdCjqcGG4=;
        b=f1IzgTvKJwUy591SQohNrQ+3Ce4aNfwM2KE5hqnpm78UCtLMAkTt25L/fsy4FRQdBT1b77
        0NyAygLWHNGBvBTZ2CMx4ktI4JfIsX+814JcT999cyGTrdyoNxgsU43RGv8UKXSvlBsy1d
        sruEG/VMWhCjfrCLofuyGWuWOOdz9zI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-SxijK-EAPa-sH_BlX3M5SQ-1; Mon, 20 Mar 2023 07:45:07 -0400
X-MC-Unique: SxijK-EAPa-sH_BlX3M5SQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7816185A78F;
        Mon, 20 Mar 2023 11:45:06 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.45.226.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C77C8C15BA0;
        Mon, 20 Mar 2023 11:45:05 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] net/sched: act_tunnel_key: add support for TUNNEL_DONT_FRAGMENT
Date:   Mon, 20 Mar 2023 12:44:53 +0100
Message-Id: <cover.1679312049.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- patch 1 extends tdc to skip tests when iproute2 support is missing
- patch 2 extends TC tunnel_key action to add support for TUNNEL_DONT_FRAGMENT 

Davide Caratti (2):
  selftest: tc-testing: extend the "skip" property
  net/sched: act_tunnel_key: add support for "don't fragment"

 include/uapi/linux/tc_act/tc_tunnel_key.h     |   1 +
 net/sched/act_tunnel_key.c                    |   6 +
 .../selftests/net/forwarding/tc_tunnel_key.sh | 161 ++++++++++++++++++
 .../creating-testcases/AddingTestCases.txt    |   4 +-
 .../tc-tests/actions/tunnel_key.json          |  25 +++
 tools/testing/selftests/tc-testing/tdc.py     |  21 ++-
 6 files changed, 211 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_tunnel_key.sh

-- 
2.39.2

