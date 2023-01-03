Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E0F65BEC0
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 12:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237358AbjACLN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 06:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbjACLNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 06:13:53 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD15DEE30;
        Tue,  3 Jan 2023 03:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1672744434; x=1704280434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4FlVOPT2jOe6DTC9V9G+KJ+pzd06h+lXYhr82n7bEe0=;
  b=OdbBXkG6dAHtvCbvvH+qfDikCJapTmtXS3r2Re4uKAkvRXDMs8fH4Xc2
   lCaSFMEEE0gfcHioDAZKqrGkeT+fwMu5uIKIJdKxPbFEPpPRPAH7XDZw5
   YUCgZsuhVN1+24cwHs/9rtEoMqx8nXH/pdG2uenZd/OJ7y74krewajxXL
   E=;
X-IronPort-AV: E=Sophos;i="5.96,296,1665446400"; 
   d="scan'208";a="284566807"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 11:13:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com (Postfix) with ESMTPS id 5A5C46110B;
        Tue,  3 Jan 2023 11:13:48 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 3 Jan 2023 11:13:47 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.56) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Tue, 3 Jan 2023 11:13:43 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <mirsad.todorovac@alu.unizg.hr>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>, <kuniyu@amazon.com>
Subject: Re: PATCH [1/1]: Bug with sockaddr size in net/af_unix/test_unix_oob.c
Date:   Tue, 3 Jan 2023 20:13:35 +0900
Message-ID: <20230103111335.81600-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <9e809447-bde6-7376-5431-ea200064f957@alu.unizg.hr>
References: <9e809447-bde6-7376-5431-ea200064f957@alu.unizg.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D32UWA002.ant.amazon.com (10.43.160.230) To
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

From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Date:   Tue, 3 Jan 2023 11:28:19 +0100
> Hi all,
> 
> There is a minor issue that prevents self test net/af_unix to run on my platform:

Hi,

Thanks for the report and fix.

The diff looks good.
Could you post a patch formally following these?

  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/Documentation/process/maintainer-netdev.rst
  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/Documentation/process/submitting-patches.rst

Subject should be like

  [PATCH net v1] af_unix: Correct addr size for connect() in test_unix_oob.c.

and please add this tag just before your Signed-off-by tag.

  Fixes: 314001f0bf92 ("af_unix: Add OOB support")


> 
> # ./test_unix_oob
> Connect failed: No such file or directory
> Terminated
> 
> Tracing reveals that bind tried to open a shorter AF_UNIX socket address:

s/bind/connect/


> 
> # strace -f ./test_unix_oob
> .
> .
> .
> socket(AF_UNIX, SOCK_STREAM, 0)         = 3
> getpid()                                = 453059
> unlink("unix_oob_453059")               = -1 ENOENT (No such file or directory)
> bind(3, {sa_family=AF_UNIX, sun_path="unix_oob_453059"}, 110) = 0
> pipe2([4, 5], 0)                        = 0
> listen(3, 1)                            = 0
> clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7fa6a6577a10) = 453060
> rt_sigaction(SIGURG, {sa_handler=0x5601e2d014c9, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART|SA_SIGINFO, 
> sa_restorer=0x7fa6a623bcf0}, NULL, 8) = 0
> write(5, "S", 1)                        = 1
> accept(3, strace: Process 453060 attached
>   <unfinished ...>
> [pid 453060] set_robust_list(0x7fa6a6577a20, 24) = 0
> [pid 453060] socket(AF_UNIX, SOCK_STREAM, 0) = 6
> [pid 453060] read(4, "S", 5)            = 1
> [pid 453060] connect(6, {sa_family=AF_UNIX, sun_path="unix_oob_45305"}, 16) = -1 ENOENT (No such file or directory)
> .
> .
> .
> 
> NOTE: bind used UNIX_AF addr "unix_oob_453059", while producer tries to connect to "unix_oob_45305".
> 
> When pids were up to 5 digits it probably did not manifest, but logically the size of the
> consumer_addr is sizeof(struct sockaddr_un).
> 
> Please find the patch attached:
> 
> Thanks,
> Mirsad
> 
> ------------------------------------------------------------------------------------------------
> diff --git a/tools/testing/selftests/net/af_unix/test_unix_oob.c b/tools/testing/selftests/net/af_unix/test_unix_oob.c
> index b57e91e1c3f2..7ea733239cd9 100644
> --- a/tools/testing/selftests/net/af_unix/test_unix_oob.c
> +++ b/tools/testing/selftests/net/af_unix/test_unix_oob.c
> @@ -124,7 +124,7 @@ void producer(struct sockaddr_un *consumer_addr)
> 
>   	wait_for_signal(pipefd[0]);
>   	if (connect(cfd, (struct sockaddr *)consumer_addr,
> -		     sizeof(struct sockaddr)) != 0) {
> +		     sizeof(struct sockaddr_un)) != 0) {

While at it, please fix the indent.


>   		perror("Connect failed");
>   		kill(0, SIGTERM);
>   		exit(1);
> 
> --
> Mirsad Goran Todorovac
> Sistem inženjer
> Grafički fakultet | Akademija likovnih umjetnosti
> Sveučilište u Zagrebu
> -- 
> System engineer
> Faculty of Graphic Arts | Academy of Fine Arts
> University of Zagreb, Republic of Croatia
> The European Union
