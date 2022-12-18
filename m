Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25AE6505A7
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 00:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiLRX1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 18:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiLRX0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 18:26:46 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51174BE08;
        Sun, 18 Dec 2022 15:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1671405965; x=1702941965;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=edPgBgREkE8Svhov/+WiF86H/DAbwY6ffJXTy+rBTJw=;
  b=CY45NdqqA+UIHv/O45otZhvgy2zV/31Tqyvy9uOuDgn30TDk9WE3/Roh
   FyaW4uEUXm5/PvNtHDLNXKpNrGWE6v7ukx9d4t7kZyEH3pzD/Jq+YLVQV
   18V1IZdI5BzAqyaF4rW5kuUniabGeA45NEbS+eyexJ7SJ5XkklsHkl+Cc
   E=;
X-IronPort-AV: E=Sophos;i="5.96,254,1665446400"; 
   d="scan'208";a="278455253"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d47337e0.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2022 23:26:02 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-d47337e0.us-west-2.amazon.com (Postfix) with ESMTPS id 76C17610BC;
        Sun, 18 Dec 2022 23:26:00 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sun, 18 Dec 2022 23:25:59 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.83) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Sun, 18 Dec 2022 23:25:56 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <jirislaby@kernel.org>
CC:     <davem@davemloft.net>, <joannelkoong@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <edumazet@google.com>, <kuniyu@amazon.com>
Subject: Re: [PULL] Networking for next-6.1
Date:   Mon, 19 Dec 2022 08:25:47 +0900
Message-ID: <20221218232547.44526-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org>
References: <6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.83]
X-ClientProxiedBy: EX13D36UWA001.ant.amazon.com (10.43.160.71) To
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

From:   Jiri Slaby <jirislaby@kernel.org>
Date:   Fri, 16 Dec 2022 11:49:01 +0100
> Hi,
> 
> On 04. 10. 22, 7:20, Jakub Kicinski wrote:
> > Joanne Koong (7):
> 
> >        net: Add a bhash2 table hashed by port and address
> 
> This makes regression tests of python-ephemeral-port-reserve to fail.
> 
> I'm not sure if the issue is in the commit or in the test.

Hi Jiri,

Thanks for reporting the issue.

It seems we forgot to add TIME_WAIT sockets into bhash2 in
inet_twsk_hashdance(), therefore inet_bhash2_conflict() misses
TIME_WAIT sockets when validating bind() requests if the address
is not a wildcard one.

I'll fix it.

Thank you.

> 
> This C reproducer used to fail with 6.0, now it succeeds:
> #include <err.h>
> #include <errno.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> 
> #include <sys/socket.h>
> 
> #include <arpa/inet.h>
> #include <netinet/ip.h>
> 
> int main()
> {
>          int x;
>          int s1 = socket(AF_INET, SOCK_STREAM|SOCK_CLOEXEC, IPPROTO_IP);
>          if (s1 < 0)
>                  err(1, "sock1");
>          x = 1;
>          if (setsockopt(s1, SOL_SOCKET, SO_REUSEADDR, &x, sizeof(x)))
>                  err(1, "setsockopt1");
> 
>          struct sockaddr_in in = {
>                  .sin_family = AF_INET,
>                  .sin_port = INADDR_ANY,
>                  .sin_addr = { htonl(INADDR_LOOPBACK) },
>          };
>          if (bind(s1, (const struct sockaddr *)&in, sizeof(in)) < 0)
>                  err(1, "bind1");
> 
>          if (listen(s1, 1) < 0)
>                  err(1, "listen1");
> 
>          socklen_t inl = sizeof(in);
>          if (getsockname(s1, (struct sockaddr *)&in, &inl) < 0)
>                  err(1, "getsockname1");
> 
>          int s2 = socket(AF_INET, SOCK_STREAM|SOCK_CLOEXEC, IPPROTO_IP);
>          if (s1 < 0)
>                  err(1, "sock2");
> 
>          if (connect(s2, (struct sockaddr *)&in, inl) < 0)
>                  err(1, "conn2");
> 
>          struct sockaddr_in acc;
>          inl = sizeof(acc);
>          int fdX = accept(s1, (struct sockaddr *)&acc, &inl);
>          if (fdX < 0)
>                  err(1, "accept");
> 
>          close(fdX);
>          close(s2);
>          close(s1);
> 
>          int s3 = socket(AF_INET, SOCK_STREAM|SOCK_CLOEXEC, IPPROTO_IP);
>          if (s3 < 0)
>                  err(1, "sock3");
> 
>          if (bind(s3, (struct sockaddr *)&in, sizeof(in)) < 0)
>                  err(1, "bind3");
> 
>          close(s3);
> 
>          return 0;
> }
> 
> 
> 
> thanks,
> -- 
> js
> suse labs
