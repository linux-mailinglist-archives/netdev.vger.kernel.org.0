Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B4B28FB0B
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 00:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbgJOWMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 18:12:16 -0400
Received: from pipe.dmesg.gr ([185.6.77.131]:55236 "EHLO pipe.dmesg.gr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730355AbgJOWMQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 18:12:16 -0400
Received: from marvin.dmesg.gr (unknown [IPv6:2a03:e40:42:102::97])
        by pipe.dmesg.gr (Postfix) with ESMTPSA id 422ACA76E3;
        Fri, 16 Oct 2020 01:12:13 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=dmesg.gr; s=2013;
        t=1602799933; bh=RmRa8Ww4pzA5Eo1OVwbJP46jVOrwrzFWPYc+q4mxDVM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=t0E6Rdkq0SiKcr+8BAwxZoNhsytDB+bPOE9cBf+l/gLUGTimf4ojiWja4J7ymGs84
         LHjSYXGbHjYgvsPLX4KxugXxsA96lWRKBbYQotHmnJcU6YytOFN/oqYoWzIihDgN/J
         Sm6EWitWKuV2p63PiLaP8CFGOaKVmPGzl9G9Z3SiIqZCYEIA2xfieKIPSHhxe43hpN
         jfqn0jDlwyzeDynZl3olRWFk4m3874mcY1RsE6S3mqVLeTXwTsT72o0yoXAvR7xJ9t
         OPrsgGjoX52jqK1ic4P1br+gs+Yhz1w/eBG624AWRvJHpOvsHbXh0rm93t9umhSOvK
         SYAbJkNsZ4NhA==
Received: by marvin.dmesg.gr (Postfix, from userid 1000)
        id D3F5C222B82; Fri, 16 Oct 2020 01:12:12 +0300 (EEST)
From:   Apollon Oikonomopoulos <apoikos@dmesg.gr>
To:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: TCP sender stuck in persist despite peer advertising non-zero window
In-Reply-To: <CAK6E8=fCwjP47DvSj4YQQ6xn25bVBN_1mFtrBwOJPYU6jXVcgQ@mail.gmail.com>
References: <87eelz4abk.fsf@marvin.dmesg.gr> <CADVnQym6OPVRcJ6PdR3hjN5Krcn0pugshdLZsrnzNQe1c52HXA@mail.gmail.com> <CAK6E8=fCwjP47DvSj4YQQ6xn25bVBN_1mFtrBwOJPYU6jXVcgQ@mail.gmail.com>
Date:   Fri, 16 Oct 2020 01:12:12 +0300
Message-ID: <87blh33zr7.fsf@marvin.dmesg.gr>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yuchung Cheng <ycheng@google.com> writes:

> On Thu, Oct 15, 2020 at 1:22 PM Neal Cardwell <ncardwell@google.com> wrote:
>>
>> On Thu, Oct 15, 2020 at 2:31 PM Apollon Oikonomopoulos <apoikos@dmesg.gr> wrote:
>> >
>> > Hi,
>> >
>> > I'm trying to debug a (possible) TCP issue we have been encountering
>> > sporadically during the past couple of years. Currently we're running
>> > 4.9.144, but we've been observing this since at least 3.16.
>> >
>> > Tl;DR: I believe we are seeing a case where snd_wl1 fails to be properly
>> > updated, leading to inability to recover from a TCP persist state and
>> > would appreciate some help debugging this.
>>
>> Thanks for the detailed report and diagnosis. I think we may need a
>> fix something like the following patch below.

That was fast, thank you!

>>
>> Eric/Yuchung/Soheil, what do you think?
> wow hard to believe how old this bug can be. The patch looks good but
> can Apollon verify this patch fix the issue?

Sure, I can give it a try and let the systems do their thing for a couple of
days, which should be enough to see if it's fixed.

Neal, would it be possible to re-send the patch as an attachment? The
inlined version does not apply cleanly due to linewrapping and
whitespace changes and, although I can re-type it, I would prefer to test
the exact same thing that would be merged.

Regards,
Apollon
