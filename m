Return-Path: <netdev+bounces-9843-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E6472AE09
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 20:04:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FE3A1C20A96
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 18:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43EF2200B9;
	Sat, 10 Jun 2023 18:04:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3565723C5
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 18:04:26 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515061734;
	Sat, 10 Jun 2023 11:04:21 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id 6835260210;
	Sat, 10 Jun 2023 20:04:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686420253; bh=a7kwb1zfYXMMAdqEu0rSxumVp5Tj+8Ey4XJUCAGXj3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fBqLH6LLHPYfTBFFFB5RlL3Zs3BdIIhtsENnrmbblmiCEBLxjlaOs1sWCPzohkAQp
	 qOwGDQCPe70wKWm+/S2SZMclC7YD63EUIruqZb/hLrV1RYY33bOFOKXJBwF+uoTGvI
	 dm+0q4E/aGb0Ww4Q+rhcw1SEr3/CSMLWCWMP1N62oUh/SuLcPnS8Qu7aVHjs6FveCH
	 MBjfZEAGU+g+Ezxfe2+scRNWiXU2m1pCaPq9zXz5cOoWjaPoBr/hwjildP6a1bBX22
	 HBhoNghVLQawiABSyb/9QsuiUAowVeHHtETEwD9j0ZwoLrvFADpBCmnncOn6ZyDf5+
	 1TMHd433V3Pkg==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hq02M9V8VEoC; Sat, 10 Jun 2023 20:04:10 +0200 (CEST)
Received: from [192.168.1.6] (unknown [77.237.113.62])
	by domac.alu.hr (Postfix) with ESMTPSA id 069F26020C;
	Sat, 10 Jun 2023 20:04:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686420250; bh=a7kwb1zfYXMMAdqEu0rSxumVp5Tj+8Ey4XJUCAGXj3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ixSyeOn1pVjUjZV6EUrabQKc4uhuLgIVgcgmodf+j21Z+6UFBVMYtwxqPbl7dINxM
	 TiVa4plWWAIEFrTcoz1xGX+mXn+u+T+ZwWWrjXnMG4TUryZTFx96o6LAaTxtWnLQDV
	 q/zNyIJ0ZM1OFfX21hAf895JDFosgRPDdvK8oA47EucA389Imi5c6uVQza5cDZARG+
	 /HHoaHa2f9FtcJLtkk+uvi/fkU0Z0UPt6ocsDiJoUMkMP1rvE/4OQ9a00BmGApDiu1
	 GQ6L7uOMo8ZvDq2DjQ7A3+4Qerux53fBhvumQSc0081PYFzk6VbTrGe4gwrxjeeZbe
	 ypnCH9PqWzf9g==
Message-ID: <a74fbb54-2594-fd37-c5fe-3a027d9a5ea3@alu.unizg.hr>
Date: Sat, 10 Jun 2023 20:04:02 +0200
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
To: Guillaume Nault <gnault@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
 <ZHeN3bg28pGFFjJN@debian> <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr>
 <ZH84zGEODT97TEXG@debian> <48cfd903-ad2f-7da7-e5a6-a22392dc8650@alu.unizg.hr>
 <ZH+BhFzvJkWyjBE0@debian> <a3b2891d-d355-dacd-24ec-af9f8aacac57@alu.unizg.hr>
 <ZIC1r6IHOM5nr9QD@debian> <884d9eb7-0e8e-3e59-cf6d-2c6931da35ee@alu.unizg.hr>
 <ZINPuawVp2KKoCjS@debian>
Content-Language: en-US
From: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <ZINPuawVp2KKoCjS@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/9/23 18:13, Guillaume Nault wrote:
> On Thu, Jun 08, 2023 at 07:37:15AM +0200, Mirsad Goran Todorovac wrote:
>> On 6/7/23 18:51, Guillaume Nault wrote:
>>> On Wed, Jun 07, 2023 at 12:04:52AM +0200, Mirsad Goran Todorovac wrote:
>>>> [...]
>>>> TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
>>>> TEST: ping local, VRF bind - VRF IP                                           [FAIL]
>>>> TEST: ping local, VRF bind - loopback                                         [ OK ]
>>>> TEST: ping local, device bind - ns-A IP                                       [FAIL]
>>>> TEST: ping local, device bind - VRF IP                                        [ OK ]
>>>> [...]
>>>> TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
>>>> TEST: ping local, VRF bind - VRF IP                                           [FAIL]
>>>> TEST: ping local, VRF bind - loopback                                         [ OK ]
>>>> TEST: ping local, device bind - ns-A IP                                       [FAIL]
>>>> TEST: ping local, device bind - VRF IP                                        [ OK ]
>>>> [...]
>>>
>>> I have the same failures here. They don't seem to be recent.
>>> I'll take a look.
>>
>> Certainly. I thought it might be something architecture-specific?
>>
>> I have reproduced it also on a Lenovo IdeaPad 3 with Ubuntu 22.10,
>> but on Lenovo desktop with AlmaLinux 8.8 (CentOS fork), the result
>> was "888/888 passed".
> 
> I've taken a deeper look at these failures. That's actually a problem in
> ping. That's probably why you have different results depending on the
> distribution.

Thank you for your work. I feel encouraged by your aim to get to the bottom
of the problem ...
  
> The problem is that, for some versions, 'ping -I netdev ...' doesn't
> bind the socket to 'netdev' if the IPv4 address to ping is set on that
> same device. The VRF tests depend on this socket binding, so they fail
> when ping refuses to bind. That was fixed upstream with commit
> 92ce8ef21393 ("Revert "ping: do not bind to device when destination IP
> is on device"") (https://github.com/iputils/iputils/commit/92ce8ef2139353da3bf55fe2280bd4abd2155c9f).
> 
> Long story short, the tests should pass with the latest upstream ping
> version.
> 
> Alternatively, you can modify the commands run by fcnal-test.sh and
> provide the -I option twice: one for setting the device binding and one
> for setting the source IPv4 address. This way ping should accept to
> bind its socket.
> 
> Something like (not tested):
> 
> -                run_cmd ping -c1 -w1 -I ${VRF} ${a}
> +                run_cmd ping -c1 -w1 -I ${VRF} -I ${a} ${a}
> [...]
> -        run_cmd ping -c1 -w1 -I ${NSA_DEV} ${a}
> +        run_cmd ping -c1 -w1 -I ${NSA_DEV} -I ${a} ${a}

I have tested this and the fix appears to work:

#################################################################
With VRF

SYSCTL: net.ipv4.raw_l3mdev_accept=1

TEST: ping out, VRF bind - ns-B IP                                            [ OK ]
TEST: ping out, device bind - ns-B IP                                         [ OK ]
TEST: ping out, vrf device + dev address bind - ns-B IP                       [ OK ]
TEST: ping out, vrf device + vrf address bind - ns-B IP                       [ OK ]
TEST: ping out, VRF bind - ns-B loopback IP                                   [ OK ]
TEST: ping out, device bind - ns-B loopback IP                                [ OK ]
TEST: ping out, vrf device + dev address bind - ns-B loopback IP              [ OK ]
TEST: ping out, vrf device + vrf address bind - ns-B loopback IP              [ OK ]
TEST: ping in - ns-A IP                                                       [ OK ]
TEST: ping in - VRF IP                                                        [ OK ]
TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
TEST: ping local, VRF bind - VRF IP                                           [ OK ]
TEST: ping local, VRF bind - loopback                                         [ OK ]
TEST: ping local, device bind - ns-A IP                                       [ OK ]
TEST: ping local, device bind - VRF IP                                        [ OK ]
TEST: ping local, device bind - loopback                                      [ OK ]
TEST: ping out, vrf bind, blocked by rule - ns-B loopback IP                  [ OK ]
TEST: ping out, device bind, blocked by rule - ns-B loopback IP               [ OK ]
TEST: ping in, blocked by rule - ns-A loopback IP                             [ OK ]
TEST: ping out, vrf bind, unreachable route - ns-B loopback IP                [ OK ]
TEST: ping out, device bind, unreachable route - ns-B loopback IP             [ OK ]
TEST: ping in, unreachable route - ns-A loopback IP                           [ OK ]
SYSCTL: net.ipv4.ping_group_range=0 2147483647

SYSCTL: net.ipv4.raw_l3mdev_accept=1

TEST: ping out, VRF bind - ns-B IP                                            [ OK ]
TEST: ping out, device bind - ns-B IP                                         [ OK ]
TEST: ping out, vrf device + dev address bind - ns-B IP                       [ OK ]
TEST: ping out, vrf device + vrf address bind - ns-B IP                       [ OK ]
TEST: ping out, VRF bind - ns-B loopback IP                                   [ OK ]
TEST: ping out, device bind - ns-B loopback IP                                [ OK ]
TEST: ping out, vrf device + dev address bind - ns-B loopback IP              [ OK ]
TEST: ping out, vrf device + vrf address bind - ns-B loopback IP              [ OK ]
TEST: ping in - ns-A IP                                                       [ OK ]
TEST: ping in - VRF IP                                                        [ OK ]
TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
TEST: ping local, VRF bind - VRF IP                                           [ OK ]
TEST: ping local, VRF bind - loopback                                         [ OK ]
TEST: ping local, device bind - ns-A IP                                       [ OK ]
TEST: ping local, device bind - VRF IP                                        [ OK ]
TEST: ping local, device bind - loopback                                      [ OK ]
TEST: ping out, vrf bind, blocked by rule - ns-B loopback IP                  [ OK ]
TEST: ping out, device bind, blocked by rule - ns-B loopback IP               [ OK ]
TEST: ping in, blocked by rule - ns-A loopback IP                             [ OK ]
TEST: ping out, vrf bind, unreachable route - ns-B loopback IP                [ OK ]
TEST: ping out, device bind, unreachable route - ns-B loopback IP             [ OK ]
TEST: ping in, unreachable route - ns-A loopback IP                           [ OK ]

###########################################################################

This also works on the Lenovo IdeaPad 3 Ubuntu 22.10 laptop, but on the AlmaLinux 8.8
Lenovo desktop I have a problem:

[root@pc-mtodorov net]# grep FAIL ../fcnal-test-4.log
TEST: ping local, VRF bind - ns-A IP                                          [FAIL]
TEST: ping local, VRF bind - VRF IP                                           [FAIL]
TEST: ping local, device bind - ns-A IP                                       [FAIL]
TEST: ping local, VRF bind - ns-A IP                                          [FAIL]
TEST: ping local, VRF bind - VRF IP                                           [FAIL]
TEST: ping local, device bind - ns-A IP                                       [FAIL]
[root@pc-mtodorov net]#

Kernel is the recent one:

[root@pc-mtodorov net]# uname -rms
Linux 6.4.0-rc5-testnet-00003-g5b23878f7ed9 x86_64
[root@pc-mtodorov net]#

>> However, I have a question:
>>
>> In the ping + "With VRF" section, the tests with net.ipv4.raw_l3mdev_accept=1
>> are repeated twice, while "No VRF" section has the versions:
>>
>> SYSCTL: net.ipv4.raw_l3mdev_accept=0
>>
>> and
>>
>> SYSCTL: net.ipv4.raw_l3mdev_accept=1
>>
>> The same happens with the IPv6 ping tests.
>>
>> In that case, it could be that we have only 2 actual FAIL cases,
>> because the error is reported twice.
>>
>> Is this intentional?
> 
> I don't know why the non-VRF tests are run once with raw_l3mdev_accept=0
> and once with raw_l3mdev_accept=1. Unless I'm missing something, this
> option shouldn't affect non-VRF users. Maybe the objective is to make
> sure that it really doesn't affect them. David certainly knows better.

The problem appears to be that non-VRF tests are being ran with
raw_l3mdev_accept={0|1}, while VRF tests w raw_l3mdev_accept={1|1} ...

I will try to fix that, but I am not sure of the semantics either.

Regards,
Mirsad

