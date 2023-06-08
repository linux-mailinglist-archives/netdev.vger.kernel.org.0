Return-Path: <netdev+bounces-9136-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3CCD7276C5
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:37:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60B12281654
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 05:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 509094C87;
	Thu,  8 Jun 2023 05:37:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C26E628
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 05:37:24 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74121268F;
	Wed,  7 Jun 2023 22:37:22 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id 33B7F601B6;
	Thu,  8 Jun 2023 07:37:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686202639; bh=uTDCBRGWFZj2rXUOSuVG33tAlkl9SSqaEVboHArCRX0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DIB525C5/mnLgvTfiMOV8ndRKKSw3U8kOxi3esDwqNFfDJ8Rji5NXK9N6UaX250Z0
	 Drpa+Q+O2Blc3HzmU4IbqyyxzjFhJ8HAR2k4g4lzmTgv/7XILzJtrcJl1kPuM+/Gah
	 gthOtpN5ciw0dJoRM/XOJ9R0cHhRC8bT80Z1x240MLZgsO/ZR1+9rr7x2IBi55XpMQ
	 PeMgJlDZLK+drXIa7So1bv21m/DwCMnsQfCUuPP6K7AWhnbPhI9MkM4kEP4fcy3iBC
	 AH+oGP69X0K+4dFuO6t5BgV0DJfMK2gyR0F7byOS+hVbpAeC2VmWH0EV94/BpDVia/
	 E7JBUrbQ8oOwg==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iL6RA8KfVPru; Thu,  8 Jun 2023 07:37:16 +0200 (CEST)
Received: from [192.168.1.6] (unknown [77.237.113.62])
	by domac.alu.hr (Postfix) with ESMTPSA id 21D3B601B5;
	Thu,  8 Jun 2023 07:37:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686202636; bh=uTDCBRGWFZj2rXUOSuVG33tAlkl9SSqaEVboHArCRX0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oy2IoqRo6QUb0OcyiqlYcMy+CEUdhR+sAs2IXEdF7ab+yDvgCRF3lPL0vEtPEBsGD
	 0kZWE4EP9ezZEBkzAsfe79tVhRiKgQPp7+muGz8aS5b2LGCGHMrN/g9v0G57tIhsHq
	 1NWePiXsacwZfLZo30Xew358qnGF7CUmXZR+Uv53BgAgTdxxhMX/q5Ai84MS2XGNBi
	 wy8RNusufUdRdb8hLeVFEhy7L3Y908AsnNf1vvA4kIhrIYwWFoknIbPWg40F5ck/nr
	 fz5+UmZeyGEiVaqJYoqKKUwpdq4NWAFV1m5Ob7Phxj/ZsPrzOhP5bHFGLuHYcLHmUM
	 NeO4mugU2ieJg==
Message-ID: <884d9eb7-0e8e-3e59-cf6d-2c6931da35ee@alu.unizg.hr>
Date: Thu, 8 Jun 2023 07:37:15 +0200
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
References: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
 <ZHeN3bg28pGFFjJN@debian> <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr>
 <ZH84zGEODT97TEXG@debian> <48cfd903-ad2f-7da7-e5a6-a22392dc8650@alu.unizg.hr>
 <ZH+BhFzvJkWyjBE0@debian> <a3b2891d-d355-dacd-24ec-af9f8aacac57@alu.unizg.hr>
 <ZIC1r6IHOM5nr9QD@debian>
From: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <ZIC1r6IHOM5nr9QD@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/7/23 18:51, Guillaume Nault wrote:
> On Wed, Jun 07, 2023 at 12:04:52AM +0200, Mirsad Goran Todorovac wrote:
>> I cannot tell if those are new for the architecture (Ubuntu 22.04 + AMD Ryzen)
>>
>> However, Ubuntu's unsigned 6.3.1 generic mainline kernel is also affected.
>> So, it might seem like an old problem.
>>
>> (If you could isolate the exact tests, I could try a bisect.)
>>
>> [...]
>> TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
>> TEST: ping local, VRF bind - VRF IP                                           [FAIL]
>> TEST: ping local, VRF bind - loopback                                         [ OK ]
>> TEST: ping local, device bind - ns-A IP                                       [FAIL]
>> TEST: ping local, device bind - VRF IP                                        [ OK ]
>> [...]
>>
>> SYSCTL: net.ipv4.raw_l3mdev_accept=1
>>
>> [...]
>> TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
>> TEST: ping local, VRF bind - VRF IP                                           [FAIL]
>> TEST: ping local, VRF bind - loopback                                         [ OK ]
>> TEST: ping local, device bind - ns-A IP                                       [FAIL]
>> TEST: ping local, device bind - VRF IP                                        [ OK ]
>> [...]
>>
>> Yes, just tested, w commit 42510dffd0e2 these are still present
>> in fcnal-test.sh output:
>>
>> [...]
>> TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
>> TEST: ping local, VRF bind - VRF IP                                           [FAIL]
>> TEST: ping local, VRF bind - loopback                                         [ OK ]
>> TEST: ping local, device bind - ns-A IP                                       [FAIL]
>> TEST: ping local, device bind - VRF IP                                        [ OK ]
>> [...]
>> TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
>> TEST: ping local, VRF bind - VRF IP                                           [FAIL]
>> TEST: ping local, VRF bind - loopback                                         [ OK ]
>> TEST: ping local, device bind - ns-A IP                                       [FAIL]
>> TEST: ping local, device bind - VRF IP                                        [ OK ]
>> [...]
> 
> I have the same failures here. They don't seem to be recent.
> I'll take a look.

Certainly. I thought it might be something architecture-specific?

I have reproduced it also on a Lenovo IdeaPad 3 with Ubuntu 22.10,
but on Lenovo desktop with AlmaLinux 8.8 (CentOS fork), the result
was "888/888 passed".

However, I have a question:

In the ping + "With VRF" section, the tests with net.ipv4.raw_l3mdev_accept=1
are repeated twice, while "No VRF" section has the versions:

SYSCTL: net.ipv4.raw_l3mdev_accept=0

and

SYSCTL: net.ipv4.raw_l3mdev_accept=1

The same happens with the IPv6 ping tests.

In that case, it could be that we have only 2 actual FAIL cases,
because the error is reported twice.

Is this intentional?

Thanks,
Mirsad

   74 #################################################################
   75 With VRF
   76
   77 SYSCTL: net.ipv4.raw_l3mdev_accept=1
   78
   79 TEST: ping out, VRF bind - ns-B IP                                            [ OK ]
   80 TEST: ping out, device bind - ns-B IP                                         [ OK ]
   81 TEST: ping out, vrf device + dev address bind - ns-B IP                       [ OK ]
   82 TEST: ping out, vrf device + vrf address bind - ns-B IP                       [ OK ]
   83 TEST: ping out, VRF bind - ns-B loopback IP                                   [ OK ]
   84 TEST: ping out, device bind - ns-B loopback IP                                [ OK ]
   85 TEST: ping out, vrf device + dev address bind - ns-B loopback IP              [ OK ]
   86 TEST: ping out, vrf device + vrf address bind - ns-B loopback IP              [ OK ]
   87 TEST: ping in - ns-A IP                                                       [ OK ]
   88 TEST: ping in - VRF IP                                                        [ OK ]
   89 TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
   90 TEST: ping local, VRF bind - VRF IP                                           [FAIL]
   91 TEST: ping local, VRF bind - loopback                                         [ OK ]
   92 TEST: ping local, device bind - ns-A IP                                       [FAIL]
   93 TEST: ping local, device bind - VRF IP                                        [ OK ]
   94 TEST: ping local, device bind - loopback                                      [ OK ]
   95 TEST: ping out, vrf bind, blocked by rule - ns-B loopback IP                  [ OK ]
   96 TEST: ping out, device bind, blocked by rule - ns-B loopback IP               [ OK ]
   97 TEST: ping in, blocked by rule - ns-A loopback IP                             [ OK ]
   98 TEST: ping out, vrf bind, unreachable route - ns-B loopback IP                [ OK ]
   99 TEST: ping out, device bind, unreachable route - ns-B loopback IP             [ OK ]
  100 TEST: ping in, unreachable route - ns-A loopback IP                           [ OK ]
  101 SYSCTL: net.ipv4.ping_group_range=0 2147483647
  102
  103 SYSCTL: net.ipv4.raw_l3mdev_accept=1
  104
  105 TEST: ping out, VRF bind - ns-B IP                                            [ OK ]
  106 TEST: ping out, device bind - ns-B IP                                         [ OK ]
  107 TEST: ping out, vrf device + dev address bind - ns-B IP                       [ OK ]
  108 TEST: ping out, vrf device + vrf address bind - ns-B IP                       [ OK ]
  109 TEST: ping out, VRF bind - ns-B loopback IP                                   [ OK ]
  110 TEST: ping out, device bind - ns-B loopback IP                                [ OK ]
  111 TEST: ping out, vrf device + dev address bind - ns-B loopback IP              [ OK ]
  112 TEST: ping out, vrf device + vrf address bind - ns-B loopback IP              [ OK ]
  113 TEST: ping in - ns-A IP                                                       [ OK ]
  114 TEST: ping in - VRF IP                                                        [ OK ]
  115 TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
  116 TEST: ping local, VRF bind - VRF IP                                           [FAIL]
  117 TEST: ping local, VRF bind - loopback                                         [ OK ]
  118 TEST: ping local, device bind - ns-A IP                                       [FAIL]
  119 TEST: ping local, device bind - VRF IP                                        [ OK ]
  

