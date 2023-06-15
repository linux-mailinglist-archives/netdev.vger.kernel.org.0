Return-Path: <netdev+bounces-11226-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C847320A7
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:11:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 785501C20F0B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 20:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B6B9EAFE;
	Thu, 15 Jun 2023 20:11:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAB8EAF8
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 20:11:03 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020D31BC;
	Thu, 15 Jun 2023 13:10:59 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id 8D1FF60304;
	Thu, 15 Jun 2023 22:10:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686859845; bh=uukwmcuMYyFo0+uF/3NGwM7VYyyngg3AIaPUOReXkV8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HH2qoWkoKpWC5a5ltWnDz8kJiFKyq0nBa6RF7kKfZtDw8N3lDZKUnURqquNsKebg3
	 AqqxW4gYuMYvZjp1ELlumQNpV0bp28x1cObTAhW4/zISJ61GQFsG4DKqwBAEMJBHod
	 SNYyI37EMYIRJNVMUJuOgwj/iQOrkgIROJZzY5m3qS+bbhJTLE72+54eCnwMNqU0kB
	 cnBp/uBdKR7kSe9DngY5ubXuYUchQ13wxYBGnlFgYaGiT1QuOwnCNrAoAiUgFTN1Xj
	 0DjTrOvwe/isXOJZQgR3iNxdjnOjCXEb+EP9+FxpMua8oVtEjbRhXdhTdbq1C0iQZE
	 6P9qbtVA+4PRA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z5yJhetaoLVu; Thu, 15 Jun 2023 22:10:43 +0200 (CEST)
Received: from [192.168.1.6] (unknown [94.250.191.183])
	by domac.alu.hr (Postfix) with ESMTPSA id BAF1260303;
	Thu, 15 Jun 2023 22:10:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686859843; bh=uukwmcuMYyFo0+uF/3NGwM7VYyyngg3AIaPUOReXkV8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UaDmI+vN/XSjRDZc4BsRC2qXr8H50gp48GJoXxMUcyeTqwj0Ze8Q0kIgoKfNTPgs9
	 e9nbpmZt6bXatFGlIhvsC4JPRxZB342NRIZ5aJ+5gmp0VJSMiIGHFzwk66ARmBd4zu
	 vutqwmIXwzTgS/O4zQ7919zeFAuONOjM5f/7tUvLnd61m0pqwm2HNq+PgO9aJJTtsB
	 5KfwcQVS2hGkkySw+/2ka2/I8r8xBz/GDRL1b+6rkdudq9m0Uk2FRK5Tor8+yk4JA3
	 lsSr0TmXkyBbezM/A4JSwg3CQwY2kms//onp8gPENGF8iLh+V3pV+jOrk3HpQ6zk5z
	 ZNq2Lhvc3M8vQ==
Message-ID: <2d129924-d8c7-0aab-2766-950042b7a801@alu.unizg.hr>
Date: Thu, 15 Jun 2023 22:10:42 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: POSSIBLE BUG: selftests/net/fcnal-test.sh: [FAIL][FIX TESTED] in
 vrf "bind - ns-B IPv6 LLA" test
Content-Language: en-US
To: Guillaume Nault <gnault@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <ZHeN3bg28pGFFjJN@debian>
 <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr> <ZH84zGEODT97TEXG@debian>
 <48cfd903-ad2f-7da7-e5a6-a22392dc8650@alu.unizg.hr> <ZH+BhFzvJkWyjBE0@debian>
 <a3b2891d-d355-dacd-24ec-af9f8aacac57@alu.unizg.hr> <ZIC1r6IHOM5nr9QD@debian>
 <884d9eb7-0e8e-3e59-cf6d-2c6931da35ee@alu.unizg.hr> <ZINPuawVp2KKoCjS@debian>
 <a74fbb54-2594-fd37-c5fe-3a027d9a5ea3@alu.unizg.hr> <ZIl+k8zJ7A0vFKpB@debian>
From: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <ZIl+k8zJ7A0vFKpB@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/14/23 10:47, Guillaume Nault wrote:
> On Sat, Jun 10, 2023 at 08:04:02PM +0200, Mirsad Goran Todorovac wrote:
>> This also works on the Lenovo IdeaPad 3 Ubuntu 22.10 laptop, but on the AlmaLinux 8.8
>> Lenovo desktop I have a problem:
>>
>> [root@pc-mtodorov net]# grep FAIL ../fcnal-test-4.log
>> TEST: ping local, VRF bind - ns-A IP                                          [FAIL]
>> TEST: ping local, VRF bind - VRF IP                                           [FAIL]
>> TEST: ping local, device bind - ns-A IP                                       [FAIL]
>> TEST: ping local, VRF bind - ns-A IP                                          [FAIL]
>> TEST: ping local, VRF bind - VRF IP                                           [FAIL]
>> TEST: ping local, device bind - ns-A IP                                       [FAIL]
>> [root@pc-mtodorov net]#
>>
>> Kernel is the recent one:
>>
>> [root@pc-mtodorov net]# uname -rms
>> Linux 6.4.0-rc5-testnet-00003-g5b23878f7ed9 x86_64
>> [root@pc-mtodorov net]#
> 
> Maybe a problem with the ping version used by the distribution.
> You can try "./fcnal-test.sh -t ipv4_ping -p -v" to view the commands
> run and make the script stop when there's a test failure (so that you
> can see the ping output and try your own commands in the testing
> environment).

Thank you for taking the time for the reply. And thanks for the hint.
But I am sort of on ebb tide on this.

It would be good to have the test run on both versions of Linux to test
the actual kernel faults. Maybe pack a version of ping command w the test?
But I cannot deploy too much time in this.

I hope then the upgrade AlmaLinux 8.8 -> 9.x (or CentOS clones in general)
would solve the issue, but it is not guaranteed, and I would lose bisect
to the old kernels. Which is why I do not upgrade to the latest releases
in the first place. :-/

If it is just the AlmaLinux ping, then it is just an exotic distro, but it
is a CentOS clone, so the issue might exist in the more popular Rocky, too.

I am not sure what is the right way to do in this case or I would already
have done it. Presumptuous maybe, but true.

>>>> However, I have a question:
>>>>
>>>> In the ping + "With VRF" section, the tests with net.ipv4.raw_l3mdev_accept=1
>>>> are repeated twice, while "No VRF" section has the versions:
>>>>
>>>> SYSCTL: net.ipv4.raw_l3mdev_accept=0
>>>>
>>>> and
>>>>
>>>> SYSCTL: net.ipv4.raw_l3mdev_accept=1
>>>>
>>>> The same happens with the IPv6 ping tests.
>>>>
>>>> In that case, it could be that we have only 2 actual FAIL cases,
>>>> because the error is reported twice.
>>>>
>>>> Is this intentional?
>>>
>>> I don't know why the non-VRF tests are run once with raw_l3mdev_accept=0
>>> and once with raw_l3mdev_accept=1. Unless I'm missing something, this
>>> option shouldn't affect non-VRF users. Maybe the objective is to make
>>> sure that it really doesn't affect them. David certainly knows better.
>>
>> The problem appears to be that non-VRF tests are being ran with
>> raw_l3mdev_accept={0|1}, while VRF tests w raw_l3mdev_accept={1|1} ...
> 
> The reason the VRF tests run twice is to test both raw and ping sockets
> (using the "net.ipv4.ping_group_range" sysctl). It doesn't seem anyone
> ever intended to run the VRF tests with raw_l3mdev_accept=0.
> 
> Only the non-VRF tests were intended to be tested with
> raw_l3mdev_accept=0 (see commit c032dd8cc7e2 ("selftests: Add ipv4 ping
> tests to fcnal-test")). But I have no idea why.

Well, you are not to blame if it is not documented.

This thing doesn't come out of the testsuite save by prayer and fasting,
I'm afraid ;-)

Best regards,
Mirsad

