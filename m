Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28632DDA3B
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 21:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbgLQUlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 15:41:07 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:38688 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728197AbgLQUlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 15:41:07 -0500
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id B5BE613C2B0;
        Thu, 17 Dec 2020 12:40:26 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com B5BE613C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1608237626;
        bh=DQ29MJIWPRFRaFdDkmlWt+wzjarZXVV3DjkZzL3Zaz8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=mWc/ODm+ORusqK5IzbZubjjunIJgBfX5xEQm+wZpLix6jbTmrv06/GFZgeJhcj9tB
         I1E05oanhAZhgAz0Uwg7sTc0/Kl0l1q0isOHMhip96H/vgyTwWIWVa30lemOCCI4Hb
         c6yJ7jPONMBGz5GMxIEG4cPr2HGH9c9VsQryGu9c=
Subject: Re: net: tso: add UDP segmentation support: adds regression for ax200
 upload
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
 <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com>
 <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
 <adbee2ec-c6ba-7a17-eb98-1c53365fa911@candelatech.com>
 <CANn89iJQnSVZFp2XDgREN1QMtU4exOsnJq=5VzJ6tqTCJ7MH-g@mail.gmail.com>
 <c4bcee7d-b2eb-759c-c659-d65f3e7daec9@candelatech.com>
 <CANn89i++Kgkj57ms70a5GDOQ-Cpewx3NQkzP3EmZmLYQ4eHzww@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <5d89fd24-f00a-7e70-00ce-83529f13b05e@candelatech.com>
Date:   Thu, 17 Dec 2020 12:40:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89i++Kgkj57ms70a5GDOQ-Cpewx3NQkzP3EmZmLYQ4eHzww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/20 10:20 AM, Eric Dumazet wrote:
> On Thu, Dec 17, 2020 at 7:13 PM Ben Greear <greearb@candelatech.com> wrote:
>>
> 
>>
>> It is the iwlwifi/mvm logic that supports ax200.
> 
> Let me ask again :
> 
> I see two different potential call points :
> 
> drivers/net/wireless/intel/iwlwifi/pcie/tx.c:1529:
> tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);
> drivers/net/wireless/intel/iwlwifi/queue/tx.c:427:
> tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);
> 
> To the best of your knowledge, which one would be used in your case ?
> 
> Both are horribly complex, I do not want to spend time studying two
> implementations.

It is the queue/tx.c code that executes on my system, verified with
printk.

Thanks,
Ben

> 
> Thanks.
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
