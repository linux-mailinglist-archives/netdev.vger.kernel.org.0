Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A9422D233
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 01:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGXX2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 19:28:47 -0400
Received: from trinity.trinnet.net ([96.78.144.185]:1131 "EHLO
        trinity3.trinnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgGXX2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 19:28:47 -0400
X-Greylist: delayed 3797 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jul 2020 19:28:47 EDT
Received: from trinity4.trinnet.net (trinity4.trinnet.net [192.168.0.11])
        by trinity3.trinnet.net (TrinityOS/8.15.2) with ESMTP id 06OMPJee005392;
        Fri, 24 Jul 2020 14:25:19 -0800
Subject: Re: [Linux-kernel-mentees] [PATCH net] AX.25: Prevent out-of-bounds
 read in ax25_sendmsg()
To:     David Miller <davem@davemloft.net>, yepeilin.cs@gmail.com
References: <20200722160512.370802-1-yepeilin.cs@gmail.com>
 <20200722.180723.102622644879670834.davem@davemloft.net>
Cc:     jreuter@yaina.de, ralf@linux-mips.org, gregkh@linuxfoundation.org,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   David Ranch <linux-hams@trinnet.net>
Message-ID: <9ed88432-ef95-f01a-9655-7c60158e3b09@trinnet.net>
Date:   Fri, 24 Jul 2020 15:25:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20200722.180723.102622644879670834.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (trinity3.trinnet.net [192.168.0.1]); Fri, 24 Jul 2020 14:25:20 -0800 (GMT+8)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I need to ask the following question to the Linux kernel community as 
the AX25 amateur radio community is already having to
work around a few broken commits that were committed 4.1.22+:

   Is anyone actually _*testing*_ these proposed changes to make sure 
the AX.25 and related ecosystem still work afterwards?

I've personally tried multiple times to recruit some help to get some of 
these previous commits rolled back from some
recommended kernel people including even some the original authors like 
Alan Cox, etc without any success.  I fear that if
more commits come into the kernel without any testing, the whole AX.25 
stack will become toxic and unusable.

I am not a kernel class developer but I am *personally* willing to help 
out on the testing effort and even help setup regression
topologies (VMs, containers, whatever) if there is some place that they 
can be ideally run in a continuous delivery.

If there is anyone also willing to help fix some of these previous 
commits and get the AX.25 stack kernel back on track,
I do have a bunch of details of the commit details, details on why those 
committers THOUGHT they were a good idea, etc.

--David
KI6ZHD


On 07/22/2020 06:07 PM, David Miller wrote:
> From: Peilin Ye <yepeilin.cs@gmail.com>
> Date: Wed, 22 Jul 2020 12:05:12 -0400
>
>> Checks on `addr_len` and `usax->sax25_ndigis` are insufficient.
>> ax25_sendmsg() can go out of bounds when `usax->sax25_ndigis` equals to 7
>> or 8. Fix it.
>>
>> It is safe to remove `usax->sax25_ndigis > AX25_MAX_DIGIS`, since
>> `addr_len` is guaranteed to be less than or equal to
>> `sizeof(struct full_sockaddr_ax25)`
>>
>> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> Applied.

