Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C05EA152
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 17:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbfJ3QBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 12:01:09 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39719 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbfJ3Pyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 11:54:47 -0400
Received: by mail-qt1-f195.google.com with SMTP id t8so3876087qtc.6;
        Wed, 30 Oct 2019 08:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=XRfFDBLo3b+7Jix/rVYd4DPxmBTVVlhffQMhrh75uRM=;
        b=NYTB+7xlC2vEB9n73s3dHhQYIdib40WEvSkkOn90vdB848MLyePNydOhv9Fa7WErAF
         r+I5O2KbTdHrfRQCE+SFpZPHAmL0tCv9qWvZAdwTzK+uW4a93SUJDh+DIMkglnyrb/p9
         spz4FsaO/CQB+pXaeJpeNyEE/4n6Mv/LESjZkWbTrJTEk+zDkwh4RoHPG3Q3hz6iQ+7N
         Gm1ydygLZwebvyBlp/qpeQtlMekRpBGOM06/i3gzrrUH0jLs28wNmPlOGQ+Qm1DYlpl+
         ehORJ1ei4Mi1hhfr9uUgAfdAyRPpkQcXkuiiGv0F3Wsd5j7jrZgU/poy/jUTvEmdK8X1
         xtrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=XRfFDBLo3b+7Jix/rVYd4DPxmBTVVlhffQMhrh75uRM=;
        b=mV+c4RANCPS56YqxzLwSsDeHAE4tOjSmgDE3N6BBesIZUzUdS1pb5ElZEVehXGccny
         v7aJcpAyqd+uotL9EouniMQb+HHuzaW8qfq3PnkNGcEAXzQ+IrVkOouo1mNjeixmqPYO
         H5oXmdSW8mEQcVT7QxM+OMbun+ABQOe7c3fCjLu6aLrzFHGc2zXTYGDTTk8CDpDbLXUW
         35sr8oUgvxkc8WDb9x4bjIGTa4D7zyO+BhXPYCrRWP8SR83QaJMNAfPdkn82UCeZAaze
         LQ/Q8pObVdiSkL+n7k/GPxdnQHvnABb1TWozt29bUI/iQIbklK+XbWs3EZiBP4hImGtP
         iQIw==
X-Gm-Message-State: APjAAAUcefb0tTspr2M5dsUx/8YY27dxLc8Wfq0DpPgzFYVf9HdV0TbA
        pJS5cl/m+2x/7oN+QJC1VLDIqC/VKpOZgLygC2U=
X-Google-Smtp-Source: APXvYqxAeT3rxjjBtdZs6bR+Eo4Iz2uo6t7xVkDCXigNHcCdKx2PEhYZ4SyiaQ0yjIsEB6MTLNizb1jFOC/g0OV+YwY=
X-Received: by 2002:aed:3f57:: with SMTP id q23mr829268qtf.116.1572450886323;
 Wed, 30 Oct 2019 08:54:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ad4:54a5:0:0:0:0:0 with HTTP; Wed, 30 Oct 2019 08:54:45
 -0700 (PDT)
In-Reply-To: <20191030132420.GG4326@localhost.localdomain>
References: <1572451637-14085-1-git-send-email-wallyzhao@gmail.com> <20191030132420.GG4326@localhost.localdomain>
From:   Wei Zhao <wallyzhao@gmail.com>
Date:   Wed, 30 Oct 2019 23:54:45 +0800
Message-ID: <CAFRmqq42HqX5KctcNjwyZJ4jdknLSZ1EyBqHnJQQJx211mWopw@mail.gmail.com>
Subject: Re: [PATCH] sctp: set ooo_okay properly for Transmit Packet Steering
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wally.zhao@nokia-sbell.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/19, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Wed, Oct 30, 2019 at 12:07:17PM -0400, Wally Zhao wrote:
>> Unlike tcp_transmit_skb,
>> sctp_packet_transmit does not set ooo_okay explicitly,
>> causing unwanted Tx queue switching when multiqueue is in use;
>
> It is initialized to 0 by __alloc_skb() via:
>         memset(skb, 0, offsetof(struct sk_buff, tail));
> and never set to 1 by anyone for SCTP.
>
> The patch description seems off. I don't see how the unwanted Tx queue
> switching can happen. IOW, it's not fixing it OOO packets, but
> improving it by allowing switching on the first packet. Am I missing
> something?

Thanks for pointing this out. You are right. This ooo_okay is default to false.

I was observing some Tx queue switching before when testing with
iperf3 (modified to be able to set window size, for higher throughput
with long RTT), so I thought ooo_okay was set to true somewhere else
after allocation. Just now I did the test again, it turns out that
iperf3 made a re-connect silently which caused the Tx queue change.

As for the improving purpose of this patch, that is not that critical
from my side, and the patch description is not correct for this
purpose. So I will give up this patch attempt. Thank you again for
your time on this.

>
>> Tx queue switching may cause out-of-order packets.
>> Change sctp_packet_transmit to allow Tx queue switching only for
>> the first in flight packet, to avoid unwanted Tx queue switching.
>>
>> Signed-off-by: Wally Zhao <wallyzhao@gmail.com>
>> ---
>>  net/sctp/output.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/net/sctp/output.c b/net/sctp/output.c
>> index dbda7e7..5ff75cc 100644
>> --- a/net/sctp/output.c
>> +++ b/net/sctp/output.c
>> @@ -626,6 +626,10 @@ int sctp_packet_transmit(struct sctp_packet *packet,
>> gfp_t gfp)
>>  	/* neighbour should be confirmed on successful transmission or
>>  	 * positive error
>>  	 */
>> +
>> +	/* allow switch tx queue only for the first in flight pkt */
>> +	head->ooo_okay = asoc->outqueue.outstanding_bytes == 0;
>
> Considering we are talking about NIC queues here, we would have a
> better result with tp->flight_size instead. As in, we can switch
> queues if, for this transport, the queue is empty.
>
>> +
>>  	if (tp->af_specific->sctp_xmit(head, tp) >= 0 &&
>>  	    tp->dst_pending_confirm)
>>  		tp->dst_pending_confirm = 0;
>> --
>> 1.8.3.1
>>
>
