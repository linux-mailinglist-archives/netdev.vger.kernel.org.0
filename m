Return-Path: <netdev+bounces-8609-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57C9F724CE6
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:17:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0589A281083
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F10422E52;
	Tue,  6 Jun 2023 19:17:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24643125CC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 19:17:31 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA00101;
	Tue,  6 Jun 2023 12:17:30 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id 02CA560226;
	Tue,  6 Jun 2023 21:17:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686079047; bh=jNSA09J/c7o0xmn9ZYlEHNwBrSX+r+EnE4ht4ZumTKE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sUJ5PjueDmmtfj+rBKb8C4JO07gAonT/bPqcUKrih7mmMknR02QVsPGQu2fwZjIaK
	 ovKpWvldMK7i9u4bHWJSbiFuhPmH9M498dEAflggiIeD1rnfYCBWAsORGdHm7h2aI0
	 9b5gB1zYFjXsZHI714m2DeMrq6e3I03YTFICUbcIQlKpJjRhbji3c6bCi97u6g/uI2
	 DHzotZ7pdyzZHilI7fe6lKMN6gIZSQI33h14/u9bsanrGxTaweWmbKb/26QphM1sUv
	 kJe/DQAB611BDFFcwnShbLlZjgXgQ8UFqqbhPeMbb5Kx13Jl/IOSEWldheBu9TP+jL
	 lsksNbP5tvywA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mb78sT88mhyA; Tue,  6 Jun 2023 21:17:24 +0200 (CEST)
Received: from [192.168.1.6] (unknown [77.237.113.62])
	by domac.alu.hr (Postfix) with ESMTPSA id 5151D60225;
	Tue,  6 Jun 2023 21:17:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1686079044; bh=jNSA09J/c7o0xmn9ZYlEHNwBrSX+r+EnE4ht4ZumTKE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lyAN4IZvHAqsUelelIvW9bA4vbgZi7KGpgp3TeZ2oOCxly3MLo4L0s9r8iiFyASNF
	 1l5/PeWrUdVZYz1Q/TgaAgU1wLuB7nxA90v4REJc0QBh/ZkTTte0EpTMnlntXFu42T
	 IKBa2v55GWkRNDDni4IJPyL219r/AFBHMXpaiF+gJsPKsrls8d2B8w5s8D0ieuRYje
	 Q8rn/3tDfrPSra121bTGScDVoxtDPugv+H3ePHZ/YvalL3NRChSY18phx4rmDnh5hf
	 HfqDCiWPsHS0SzmioS2R5uvHrW8D4M/ITr1Z6BCxnjmTKYi0lOczvX6qHmvYMubLmF
	 HH8d5nAfXsNOA==
Message-ID: <174c6928-3498-8fb0-9f83-b01fa346a221@alu.unizg.hr>
Date: Tue, 6 Jun 2023 21:17:24 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: POSSIBLE BUG: selftests/net/fcnal-test.sh: [FAIL] in vrf "bind -
 ns-B IPv6 LLA" test
Content-Language: en-US
To: Guillaume Nault <gnault@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr>
 <ZHeN3bg28pGFFjJN@debian> <a379796a-5cd6-caa7-d11d-5ffa7419b90e@alu.unizg.hr>
 <ZH84zGEODT97TEXG@debian> <60f78eaa-ace7-c27d-8e45-4777ecf3faa2@alu.unizg.hr>
 <ZH8+jLjottBw2zuD@debian> <12c34bed-0885-3bb3-257f-3b2438ba206f@alu.unizg.hr>
 <ZH+ADF0OOcmtUPw9@debian>
From: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <ZH+ADF0OOcmtUPw9@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/6/23 20:50, Guillaume Nault wrote:
> On Tue, Jun 06, 2023 at 04:28:02PM +0200, Mirsad Todorovac wrote:
>> On 6/6/23 16:11, Guillaume Nault wrote:
>>> On Tue, Jun 06, 2023 at 03:57:35PM +0200, Mirsad Todorovac wrote:
>>>> +       if (oif) {
>>>> +               rcu_read_lock();
>>>> +               dev = dev_get_by_index_rcu(net, oif);
>>>> +               rcu_read_unlock();
>>>
>>> You can't assume '*dev' is still valid after rcu_read_unlock() unless
>>> you hold a reference on it.
>>>
>>>> +               rtnl_lock();
>>>> +               mdev = netdev_master_upper_dev_get(dev);
>>>> +               rtnl_unlock();
>>>
>>> Because of that, 'dev' might have already disappeared at the time
>>> netdev_master_upper_dev_get() is called. So it may dereference an
>>> invalid pointer here.
>>
>> Good point, thanks. I didn't expect those to change.
>>
>> This can be fixed, provided that RCU and RTNL locks can be nested:
> 
> Well, yes and no. You can call rcu_read_{lock,unlock}() while under the
> rtnl protection, but not the other way around.
> 
>>          rcu_read_lock();
>>          if (oif) {
>>                  dev = dev_get_by_index_rcu(net, oif);
>>                  rtnl_lock();
>>                  mdev = netdev_master_upper_dev_get(dev);
>>                  rtnl_unlock();
>>          }
> 
> This is invalid: rtnl_lock() uses a mutex, so it can sleep and that's
> forbidden inside an RCU critical section.

Obviously, that's bad. Mea culpa.

>>          if (sk->sk_bound_dev_if) {
>>                  bdev = dev_get_by_index_rcu(net, sk->sk_bound_dev_if);
>>          }
>>
>>          addr_type = ipv6_addr_type(daddr);
>>          if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
>>              (addr_type & IPV6_ADDR_MAPPED) ||
>>              (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
>>                      !(mdev && sk->sk_bound_dev_if && bdev && mdev == bdev))) {
>>                  rcu_read_unlock();
>>                  return -EINVAL;
>> 	}
>>          rcu_read_unlock();
>>
>> But again this is still probably not race-free (bdev might also disappear before
>> the mdev == bdev test), even if it passed fcnal-test.sh, there is much duplication
>> of code, so your one-line solution is obviously by far better. :-)
> 
> The real problem is choosing the right function for getting the master
> device. In particular netdev_master_upper_dev_get() was a bad choice.
> It forces you to take the rtnl, which is unnatural here and obliges you
> to add extra code, while all this shouldn't be necessary in the first
> place.

Thank you for the additional insight. I had poor luck with Googling on
these.

I made a blunder after blunder. But it was insightful and brainstorming.
Good exercise for my little grey cells.

However, learning without making any errors appears to be simply a lot
of blunt memorising. :-/

It's good to be in an environment when one can learn from errors.

:-)

Regards,
Mirsad

