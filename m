Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24254E6FA4
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 09:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355827AbiCYIvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 04:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354281AbiCYIvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 04:51:53 -0400
X-Greylist: delayed 299 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Mar 2022 01:50:18 PDT
Received: from fx601.security-mail.net (smtpout140.security-mail.net [85.31.212.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE0C9968B
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 01:50:17 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by fx601.security-mail.net (Postfix) with ESMTP id E5E793ACECA
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 09:45:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalrayinc.com;
        s=sec-sig-email; t=1648197917;
        bh=tN9asl+E3cLQ7JQxZvwnMPHKh3rjEp35HSuJdfimZPE=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject;
        b=MF+3qRI7mBK994X4b4cexCyukH58ys+0mR7jkPKS6DsS5xA301izbmnFqi/6AWNLm
         02kAszve47ptSU8/fQBjbpXQwQBTuS8IVZyC2fXJz6JQfbTqdiDLlZb4UFWA2fbUO8
         /le82hHbmN1mpU0tLLNZ3aACWTahlgFnct84zeX4=
Received: from fx601 (localhost [127.0.0.1]) by fx601.security-mail.net
 (Postfix) with ESMTP id 018683ACEFD; Fri, 25 Mar 2022 09:45:16 +0100 (CET)
Received: from zimbra2.kalray.eu (unknown [217.181.231.53]) by
 fx601.security-mail.net (Postfix) with ESMTPS id 4B2433ACC46; Fri, 25 Mar
 2022 09:45:15 +0100 (CET)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTPS id 2AEC627E044D; Fri, 25 Mar 2022
 09:45:15 +0100 (CET)
Received: from localhost (localhost [127.0.0.1]) by zimbra2.kalray.eu
 (Postfix) with ESMTP id 121BB27E0448; Fri, 25 Mar 2022 09:45:15 +0100 (CET)
Received: from zimbra2.kalray.eu ([127.0.0.1]) by localhost
 (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026) with ESMTP id
 p9BIoIDTN7O6; Fri, 25 Mar 2022 09:45:15 +0100 (CET)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTP id F1A6D27E0302; Fri, 25 Mar 2022
 09:45:14 +0100 (CET)
X-Virus-Scanned: E-securemail, by Secumail
Secumail-id: <1916.623d811b.49b7f.0>
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu 121BB27E0448
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalrayinc.com;
 s=4F334102-7B72-11EB-A74E-42D0B9747555; t=1648197915;
 bh=ospxB1H4mbAC6a+/TwlDuYCws2CgiAncRZ7UPdyK1LY=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=WGpy65MhzaxJNPlXEolzDLY/j1JLP4EXStfCpvM/BI9PFkZ35EbdXmxuWOooJQUf+
 nF07lhB0Nzeir3YP7KEWJKfsJ3OEomonF/Gzk2AOSpN6RrmRgzkEbyIQTwhVkzMdR+
 Rf9IWan2GEi6B3qE7Euau77R7ULUBb8dlktPgXM3Na1BPaXYX7UUm1kc9BStgndOQg
 STbOF+YJgFQX6ctHS5qpacsbzGUuqjd2DIUwnnQp2HFaFV/kgEk+xFDbqg51H3lBgN
 XmpC8fwKvt2Gv+vsq83GBuKi2Su0BtnjhC1k4sATDmgrB9fVzhkCAEqAvmGK/3k2PK
 yzvTQBPml1D0Q==
Date:   Fri, 25 Mar 2022 09:45:14 +0100 (CET)
From:   Vincent Ray <vray@kalrayinc.com>
To:     linyunsheng <linyunsheng@huawei.com>
Cc:     vladimir oltean <vladimir.oltean@nxp.com>, kuba <kuba@kernel.org>,
        davem <davem@davemloft.net>, Samuel Jones <sjones@kalrayinc.com>,
        netdev <netdev@vger.kernel.org>,
        =?utf-8?b?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>
Message-ID: <969086798.7658413.1648197914959.JavaMail.zimbra@kalray.eu>
In-Reply-To: <0d6e8178-953a-82c9-329c-241bd311dbf9@huawei.com>
References: <1862202329.1457162.1643113633513.JavaMail.zimbra@kalray.eu>
 <698739062.1462023.1643115337201.JavaMail.zimbra@kalray.eu>
 <1c53c5c0-4e77-723b-4260-de83e8f8e40c@huawei.com>
 <0d6e8178-953a-82c9-329c-241bd311dbf9@huawei.com>
Subject: Re: packet stuck in qdisc
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.40.202]
X-Mailer: Zimbra 9.0.0_GA_4126 (ZimbraWebClient - FF98
 (Linux)/9.0.0_GA_4126)
Thread-Topic: packet stuck in qdisc
Thread-Index: DcZRcSeliYiQfqvuboiF+EvMd0YX2Q==
X-ALTERMIMEV2_out: done
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OK I'll try that, thank you LinYun.

(I'm sorry for the delay in my answers, I haven't been able to try your debug patch yet because I've had other problems with my setup, preventing me from reproducing the issue in the first place, but it should be ok soon)

----- Original Message -----
From: "linyunsheng" <linyunsheng@huawei.com>
To: "Vincent Ray" <vray@kalrayinc.com>, "vladimir oltean" <vladimir.oltean@nxp.com>, "kuba" <kuba@kernel.org>, "davem" <davem@davemloft.net>
Cc: "Samuel Jones" <sjones@kalrayinc.com>, "netdev" <netdev@vger.kernel.org>, "方国炬" <guoju.fgj@alibaba-inc.com>
Sent: Friday, March 25, 2022 7:16:02 AM
Subject: Re: packet stuck in qdisc

On 2022/1/28 10:36, Yunsheng Lin wrote:
> On 2022/1/25 20:55, Vincent Ray wrote:
>> Dear kernel maintainers / developers,
>>
>> I work at Kalray where we are developping an NVME-over-TCP target controller board.
>> My setup is as such :
>> - a development workstation running Linux 5.x.y (the host)
>> - sending NVME-TCP traffic to our board, to which it is connected through a Mellanox NIC (Connect-X-5) and a 100G ETH cable
>>
>> While doing performance tests, using simple fio scenarios running over the regular kernel nvme-tcp driver on the host, we noticed important performance variations.
>> After some digging (using tcpdump on the host), we found that there were big "holes" in the tcp traffic sent by the host.
>> The scenario we observed is the following :
>> 1) a TCP segment gets lost (not sent by the host) on a particular TCP connection, leading to a gap in the seq numbers received by the board
>> 2) the board sends dup-acks and/or sacks (if configured) to signal this loss
>> 3) then, sometimes, the host stops emitting on that TCP connection for several seconds (as much as 14s observed)
>> 4) finally the host resumes emission, sending the missing packet
>> 5) then the TCP connection continues correctly with the appropriate throughput
>>
>> Such a scenario can be observed in the attached tcpdump (+ comments).
> 
> Hi,
>     Thanks for reporting the problem.

Hi,
   It seems guoju from alibaba has a similar problem as above.
   And they fixed it by adding a smp_mb() barrier between spin_unlock()
and test_bit() in qdisc_run_end(), please see if it fixes your problem.

> 
>>



To declare a filtering error, please use the following link : https://www.security-mail.net/reporter.php?mid=5ef9.623d5e27.9b9df.0&r=vray%40kalrayinc.com&s=linyunsheng%40huawei.com&o=Re%3A+packet+stuck+in+qdisc&verdict=C&c=7b4f9607053f62d4edea3c79310a8bd5d5e63628




