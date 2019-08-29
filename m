Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2BDA2990
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 00:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbfH2WTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 18:19:02 -0400
Received: from server.dnsblock1.com ([85.13.236.178]:51322 "EHLO
        server.dnsblock1.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbfH2WTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 18:19:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bobbriscoe.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=a5y89oFqcqjD8K/8XhfL0RZLvQb+BW7KI5B6TlDthRU=; b=krbbBjcb9nyl37yC9owhMQkO0k
        i+PJCGKk3klXrS4lfqHpAG81YVu0o4wKX0T+O6GorNCjVtnwRrgt1x6c1U5Cf8KwSGS/mhnJQBPT5
        lIgZnfkn3bsgTsGURggRyB9nO+8OE7e2COGo9+hdhkjz3VB9fvfS8jfnPSV6MHawRZqS+aj2bQWHX
        EEkJAkqZVZbif+fa6kQI0LlUmklyzSl2A4kfDmhyk3q/PGLZBY7uU/WNp1YHqVRqyg9hJ9VTVPvzR
        q2fFel38yj8Y479rMx75pgZ/jAZoU72hgD7u2vnJC8J4Hryv+6OLC5QvM+ZCUBPUu6CuIJGBmeXgS
        89xoLahw==;
Received: from [31.185.128.31] (port=33096 helo=[192.168.0.7])
        by server.dnsblock1.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <research@bobbriscoe.net>)
        id 1i3Skq-0000ql-47; Thu, 29 Aug 2019 23:18:56 +0100
Subject: Re: [PATCH net-next v5] sched: Add dualpi2 qdisc
To:     Dave Taht <dave.taht@gmail.com>
Cc:     "Tilmans, Olivier (Nokia - BE/Antwerp)" 
        <olivier.tilmans@nokia-bell-labs.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Olga Albisser <olga@albisser.org>,
        "De Schepper, Koen (Nokia - BE/Antwerp)" 
        <koen.de_schepper@nokia-bell-labs.com>,
        Henrik Steen <henrist@henrist.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190822080045.27609-1-olivier.tilmans@nokia-bell-labs.com>
 <CAA93jw5_LN_-zhHh=zZA8r6Zvv1CvA_AikT_rCgWyT8ytQM_rg@mail.gmail.com>
 <20190823125130.4y3kcg6ghewghbxg@nokia-bell-labs.com>
 <bded966b-5176-69c8-4ac3-70d81d344c22@bobbriscoe.net>
 <CAA93jw5R2QWSngdKX5RSvGR5NEvFTH-Sp5__k+EroxkkQkfzcw@mail.gmail.com>
From:   Bob Briscoe <research@bobbriscoe.net>
Message-ID: <523cb76f-fddb-7ba9-1f5d-bf76bc3517be@bobbriscoe.net>
Date:   Thu, 29 Aug 2019 23:18:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAA93jw5R2QWSngdKX5RSvGR5NEvFTH-Sp5__k+EroxkkQkfzcw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server.dnsblock1.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - bobbriscoe.net
X-Get-Message-Sender-Via: server.dnsblock1.com: authenticated_id: in@bobbriscoe.net
X-Authenticated-Sender: server.dnsblock1.com: in@bobbriscoe.net
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave,

On 28/08/2019 17:55, Dave Taht wrote:
> On Wed, Aug 28, 2019 at 7:00 AM Bob Briscoe <research@bobbriscoe.net> wrote:
>> Olivier, Dave,
>>
>> On 23/08/2019 13:59, Tilmans, Olivier (Nokia - BE/Antwerp) wrote:
>>
>> as best as I can
>> tell (but could be wrong) the NQB idea wants to put something into the
>> l4s fast queue? Or is NQB supposed to
>> be a third queue?
>>
>> NQB is not supported in this release of the code. But FYI, it's not for a third queue.
> At the time of my code review of dualpi I had not gone back to review
> the NQB draft fully.
>
>> We can add support for NQB in the future, by expanding the
>> dualpi2_skb_classify() function. This is however out of scope at the
>> moment as NQB is not yet adopted by the TSV WG. I'd guess we may want more
>> than just the NQB DSCP codepoint in the L queue, which then warrant
>> another way to classify traffic, e.g., using tc filter hints.
> Yes, you'll find find folk are fans of being able to put tc (and ebpf)
> filters in front of various qdiscs for classification, logging, and/or
> dropping behavior.
>
> A fairly typical stanza is here:
> https://github.com/torvalds/linux/blob/master/net/sched/sch_sfq.c#L171
> to line 193.
Yes, I got a student to add hooks for the Linux classification 
architecture (either adding more, or overriding the defaults) a couple 
of years ago, along with creating a classful structure. But his 
unfinished branch got left dangling once he graduated and is now way out 
of date. it's still our intention to take that direction tho.

>
>> The IETF adopted the NQB draft at the meeting just passed in July, but the draft has not yet been updated to reflect that: https://tools.ietf.org/html/draft-white-tsvwg-nqb-02
> Hmmm... no. I think oliver's statement was correct.
>
> NQB was put into the "call for adoption into tsvwg" state (
> https://mailarchive.ietf.org/arch/msg/tsvwg/fjyYQgU9xQCNalwPO7v9-al6mGk
> ) in the tsvwg aug 21st, which
> doesn't mean "adopted by the ietf", either.
You're right.

I've been away from all this for a while. In the tsvwg meeting there 
were perhaps a couple of dozen folks stating support and no-one against, 
so I had (wrongly) extrapolated from that - I should have checked the 
status of the ML discussion first.

> In response to that call
> several folk did put in (rather pithy),
> comments on the current state of the NQB idea and internet draft, starting here:
>
> https://mailarchive.ietf.org/arch/msg/tsvwg/hZGjm899t87YZl9JJUOWQq4KBsk

> While using up ECT1 in the L4S code as an identifier and not as a
> congestion indicator is very controversial for me (
> https://lwn.net/Articles/783673/ ), AND I'd rather it not be baked
> into the linux api for dualpi should this identifier not be chosen by
> the wg (thus my suggestion of a mask or lookup table)...
That ship has sailed. You can consider it controversial if you want, but 
the tsvwg decided to use ECT(1) as an identifier for L4S after long 
discussions back in 2016. Years of a large number of people's work was 
predicated on that decision. So the dualpi2 code reflects the way the 
IETF is approaching this.


>
> ... I also dearly would like both sides of this code - dualpi and tcp
> prague - in a simultaneously testable and high quality state. Without
> that, many core ideas in dualpi cannot be tested, nor objectively
> evaluated against other tcps and qdiscs using rfc3168 behavior along
> the path. Multiple experimental ideas in RFC8311 (such as those in
> section 4.3) have also not been re-evaluated in any context.
We're working on that - top priority now.
>
> Is the known to work reference codebase for "tcp prague" still 3.19 based?
It is, but Olivier recently found the elusive cause of the problem that 
made later versions bursty. So we're getting close.




Bob
>> Bob
>>
>> --
>> ________________________________________________________________
>> Bob Briscoe                               http://bobbriscoe.net/
>
>
> --
>
> Dave Täht
> CTO, TekLibre, LLC
> http://www.teklibre.com
> Tel: 1-831-205-9740

-- 
________________________________________________________________
Bob Briscoe                               http://bobbriscoe.net/

