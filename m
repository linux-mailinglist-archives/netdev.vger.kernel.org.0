Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EA965BE0F
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 11:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbjACK2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 05:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237294AbjACK2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 05:28:34 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28256FADB;
        Tue,  3 Jan 2023 02:28:27 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 5643F604F0;
        Tue,  3 Jan 2023 11:28:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1672741705; bh=mcsm3HVgNlvKRe0tp2pfP9pVcQV/6pvNR2zOemEzmzM=;
        h=Date:To:Cc:From:Subject:From;
        b=Sl0ubp0FW2YpNZlfOu0MvHin+EEJTNsAelAKq6/IO03P37Ybf1UuMkfmXm9kvJ2PX
         Wj7fKgphHKmDDyy8XBakWNXECSmfk9g7v7YQDiJWDkdVqfSBWci6PV8mFpuY6y1s6S
         lYXsSgi0a+gI60aM5B3LkUiR1gpXJXHY3DECPUlnwdqoHBybxk45folaWadpNOmFUo
         zfXLgnYlIjOMucCXImNFcxOB540dl6yn38eMA3nRAq1T1ZRWYwCYdLbXvWUVKhxlLK
         bwYqAlqh7yuxZe8FQrontKJwmNLDUPC1AJoduvTHTx4sp2OZLjQ/umakn7wgLIWKAc
         8dqBFa6MWudWQ==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id J8G14a8dvJs9; Tue,  3 Jan 2023 11:28:23 +0100 (CET)
Received: from [192.168.0.12] (unknown [188.252.196.35])
        by domac.alu.hr (Postfix) with ESMTPSA id 75940604EE;
        Tue,  3 Jan 2023 11:28:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1672741703; bh=mcsm3HVgNlvKRe0tp2pfP9pVcQV/6pvNR2zOemEzmzM=;
        h=Date:To:Cc:From:Subject:From;
        b=XQEX8JF41e8VN7dxnZuIFYEZRCjg3A3/V4fFW6sb6/9O1tPmkk+ZSRvecjZe87FFB
         tFRN6A3qu2cl9VXXhsZ5ZA4irbylZD418ihvM2c56QGIoSiG2BbXvmRr4ObkRsrb/X
         Tt5zfBYifg411Bm63IcyWCRTI0wRDLq0zLC/eCNB5q2VzZoByOtW9num6qptC3iwsk
         V6gWwrybolD7fl1XZ4Y7Vj+4SdDZOzM4qKkb6V8d9K2PbL9UFOLIMqbGS4mzMhWv8r
         ZsjR/9C+RnrZMcstHxs3j5joaJZ2UfoiyqAJgXsso1Tx0eBH/1gwKnMlvYwPcJLmql
         JuXhhWDd/3YCQ==
Message-ID: <9e809447-bde6-7376-5431-ea200064f957@alu.unizg.hr>
Date:   Tue, 3 Jan 2023 11:28:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     linux-kselftest@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: PATCH [1/1]: Bug with sockaddr size in net/af_unix/test_unix_oob.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

There is a minor issue that prevents self test net/af_unix to run on my platform:

# ./test_unix_oob
Connect failed: No such file or directory
Terminated

Tracing reveals that bind tried to open a shorter AF_UNIX socket address:

# strace -f ./test_unix_oob
.
.
.
socket(AF_UNIX, SOCK_STREAM, 0)         = 3
getpid()                                = 453059
unlink("unix_oob_453059")               = -1 ENOENT (No such file or directory)
bind(3, {sa_family=AF_UNIX, sun_path="unix_oob_453059"}, 110) = 0
pipe2([4, 5], 0)                        = 0
listen(3, 1)                            = 0
clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7fa6a6577a10) = 453060
rt_sigaction(SIGURG, {sa_handler=0x5601e2d014c9, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART|SA_SIGINFO, 
sa_restorer=0x7fa6a623bcf0}, NULL, 8) = 0
write(5, "S", 1)                        = 1
accept(3, strace: Process 453060 attached
  <unfinished ...>
[pid 453060] set_robust_list(0x7fa6a6577a20, 24) = 0
[pid 453060] socket(AF_UNIX, SOCK_STREAM, 0) = 6
[pid 453060] read(4, "S", 5)            = 1
[pid 453060] connect(6, {sa_family=AF_UNIX, sun_path="unix_oob_45305"}, 16) = -1 ENOENT (No such file or directory)
.
.
.

NOTE: bind used UNIX_AF addr "unix_oob_453059", while producer tries to connect to "unix_oob_45305".

When pids were up to 5 digits it probably did not manifest, but logically the size of the
consumer_addr is sizeof(struct sockaddr_un).

Please find the patch attached:

Thanks,
Mirsad

------------------------------------------------------------------------------------------------
diff --git a/tools/testing/selftests/net/af_unix/test_unix_oob.c b/tools/testing/selftests/net/af_unix/test_unix_oob.c
index b57e91e1c3f2..7ea733239cd9 100644
--- a/tools/testing/selftests/net/af_unix/test_unix_oob.c
+++ b/tools/testing/selftests/net/af_unix/test_unix_oob.c
@@ -124,7 +124,7 @@ void producer(struct sockaddr_un *consumer_addr)

  	wait_for_signal(pipefd[0]);
  	if (connect(cfd, (struct sockaddr *)consumer_addr,
-		     sizeof(struct sockaddr)) != 0) {
+		     sizeof(struct sockaddr_un)) != 0) {
  		perror("Connect failed");
  		kill(0, SIGTERM);
  		exit(1);

--
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
-- 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union
