Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D787C6783D2
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 18:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbjAWR7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 12:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbjAWR7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 12:59:21 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA81323D88;
        Mon, 23 Jan 2023 09:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1674496761; x=1706032761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aRUhNZ1PtjPVr9/xhqe2b6LeA819tujJz2Eu6VPZCHE=;
  b=ZKx1NkvdD9m+Gxb3F4HsJA4JtrXKjxTxFl0DUOCb5lTcFMRAEN06y6ba
   7nyXaVBTU07WyhJCoTFSxbOQjgNF4yis3zNOmRUGJRZ3ympiKHJdQJFoE
   n5KjsQZbumarL9X8A2vG1E22Jcyr7Y3rwuNw7uX2oxEPlASrdTpfwqzjp
   o=;
X-IronPort-AV: E=Sophos;i="5.97,240,1669075200"; 
   d="scan'208";a="174101634"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 17:59:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com (Postfix) with ESMTPS id 8015086770;
        Mon, 23 Jan 2023 17:59:06 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 23 Jan 2023 17:59:04 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.120) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Mon, 23 Jan 2023 17:59:01 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <jakub@cloudflare.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <eparis@parisplace.org>, <kernel-team@cloudflare.com>,
        <kuba@kernel.org>, <kuniyu@amazon.com>, <marek@cloudflare.com>,
        <ncardwell@google.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <paul@paul-moore.com>,
        <selinux@vger.kernel.org>, <stephen.smalley.work@gmail.com>
Subject: Re: [PATCH net-next v4 2/2] selftests/net: Cover the IP_LOCAL_PORT_RANGE socket option
Date:   Mon, 23 Jan 2023 09:58:52 -0800
Message-ID: <20230123175852.59621-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221221-sockopt-port-range-v4-2-d7d2f2561238@cloudflare.com>
References: <20221221-sockopt-port-range-v4-2-d7d2f2561238@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D43UWA003.ant.amazon.com (10.43.160.9) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Sitnicki <jakub@cloudflare.com>
Date:   Mon, 23 Jan 2023 15:44:40 +0100
> Exercise IP_LOCAL_PORT_RANGE socket option in various scenarios:
> 
> 1. pass invalid values to setsockopt
> 2. pass a range outside of the per-netns port range
> 3. configure a single-port range
> 4. exhaust a configured multi-port range
> 5. check interaction with late-bind (IP_BIND_ADDRESS_NO_PORT)
> 6. set then get the per-socket port range
> 
> v2 -> v3:
>  * Switch from CPP-based templates to FIXTURE_VARIANT. (Kuniyuki)
>  * Cover SOCK_STREAM/IPPROTO_SCTP where possible.
> 
> v1 -> v2:
>  * selftests: Instead of iterating over socket families (ip4, ip6) and types
>    (tcp, udp), generate tests for each combo from a template. This keeps the
>    code indentation level down and makes tests more granular.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
