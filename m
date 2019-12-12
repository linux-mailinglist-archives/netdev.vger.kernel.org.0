Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF4111D8CC
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 22:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbfLLVuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 16:50:19 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:39867 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730784AbfLLVuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 16:50:19 -0500
Received: by mail-pj1-f47.google.com with SMTP id v93so100569pjb.6;
        Thu, 12 Dec 2019 13:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0e8+yrmNU2ilxnO5i/8UVA9z4lBtV1y1p59E5YjNd0o=;
        b=DlCOttHbuW59koSaOmEaoa2nTZHNzXjS28Qme7uWYWqPQMKjqzWsI0yfDWEcCL5vm2
         4oDfGC76ZTFOFQC2v4l3g04kZrrPzV29VE5BloBtO0kaQYxqbd6H8N9ZBMFtbMkuAeUz
         NnS5w1F33azPCzDGDP/lvkSIqFhabAg3Odi0fzYx+3uPME6O/i47VWJWM909em5/yKTc
         aktTMrN7Ykhn0Y3jfwknsWLo++A7Xs7go8tyH1QinOlOJh0Ha8ZTW8eaG3RXTrWQRY18
         kO7GHU2Zh8oyuhnSvksYTXGKx3abyoGDNO1wjg4cIhYY9chehpzviAOIo9Wpn0vqfgwB
         VGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0e8+yrmNU2ilxnO5i/8UVA9z4lBtV1y1p59E5YjNd0o=;
        b=s8uoOmab1V2r9DX+egDTIOK5TRdazkQftCnMQo6VbnsXOK7n3RIkG5ifj5Pu6FmTu0
         8Fw4OAT4qFxnzbb4SJ7jYLwQkN2bs+WEjmO6Bdu+vD63Y7zEmBSOZLEmihEH33FN7sIU
         Gkvl0tEvQmn2W0w0qjnTIDaYMfl8VIEf8tS/ndQvgSnf0//6JQccsVqdSQeOYNNbWwpd
         O9rvqkl0kI4tV+Xwyeh/P7JJ50yFsBO5rbN2hhoQJKp5+lN9k4FqbcCEw4PjVEXjPZ1g
         J7zkxzkjK7rzz+FOyp2kXKXWqwdrfNvc0+4xQD1ZyKIio20xaDzdDqJ2LBQE2p0MKkpn
         Syhg==
X-Gm-Message-State: APjAAAWLBbZLN/kZ0QEEESYCqGUTzFWoPtU8qyTk9UGmC8qKgRizhfsJ
        U4llWmk6srhBMf+iaVFr5nxLe/+i
X-Google-Smtp-Source: APXvYqyGmjZtD6YnTUfUQ3ncK8Qfxu8MIUgZphWnssyEUBxzxLVj9sWpHm4GhBnAOgAvftIj+iooPQ==
X-Received: by 2002:a17:902:a712:: with SMTP id w18mr2895295plq.55.1576187417888;
        Thu, 12 Dec 2019 13:50:17 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id a19sm4537676pju.11.2019.12.12.13.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 13:50:17 -0800 (PST)
Subject: Re: debugging TCP stalls on high-speed wifi
To:     Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
 <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
 <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
 <99748db5-7898-534b-d407-ed819f07f939@gmail.com>
 <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ccab4fec-ea10-000c-53ef-0ffdadbabbd5@gmail.com>
Date:   Thu, 12 Dec 2019 13:50:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/19 1:11 PM, Johannes Berg wrote:
> Hi Eric,
> 
> Thanks for looking :)
> 
>>> I'm not sure how to do headers-only, but I guess -s100 will work.
>>>
>>> https://johannes.sipsolutions.net/files/he-tcp.pcap.xz
>>>
>>
>> Lack of GRO on receiver is probably what is killing performance,
>> both for receiver (generating gazillions of acks) and sender
>> (to process all these acks)
> Yes, I'm aware of this, to some extent. And I'm not saying we should see
> even close to 1800 Mbps like we have with UDP...
> 
> Mind you, the biggest thing that kills performance with many ACKs isn't
> the load on the system - the sender system is only moderately loaded at
> ~20-25% of a single core with TSO, and around double that without TSO.
> The thing that kills performance is eating up all the medium time with
> small non-aggregated packets, due to the the half-duplex nature of WiFi.
> I know you know, but in case somebody else is reading along :-)
> 
> But unless somehow you think processing the (many) ACKs on the sender
> will cause it to stop transmitting, or something like that, I don't
> think I should be seeing what I described earlier: we sometimes (have
> to?) reclaim the entire transmit queue before TCP starts pushing data
> again. That's less than 2MB split across at least two TCP streams, I
> don't see why we should have to get to 0 (which takes about 7ms) until
> more packets come in from TCP?
> 
> Or put another way - if I free say 400kB worth of SKBs, what could be
> the reason we don't see more packets be sent out of the TCP stack within
> the few ms or so? I guess I have to correlate this somehow with the ACKs
> so I know how much data is outstanding for ACKs. (*)
> 
> The sk_pacing_shift is set to 7, btw, which should give us 8ms of
> outstanding data. For now in this setup that's enough(**), and indeed
> bumping the limit up (setting sk_pacing_shift to say 5) doesn't change
> anything. So I think this part we actually solved - I get basically the
> same performance and behaviour with two streams (needed due to GBit LAN
> on the other side) as with 20 streams.
> 
> 
>> I had a plan about enabling compressing ACK as I did for SACK
>> in commit 
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5d9f4262b7ea41ca9981cc790e37cca6e37c789e
>>
>> But I have not done it yet.
>> It is a pity because this would tremendously help wifi I am sure.
> 
> Nice :-)
> 
> But that is something the *receiver* would have to do.

Yes, this is the plan. Eventually the receiver gets smarter.

> 
> The dirty secret here is that we're getting close to 1700 Mbps TCP with
> Windows in place of Linux in the setup, with the same receiver on the
> other end (which is actually a single Linux machine with two GBit
> network connections to the AP). So if we had this I'm sure it'd increase
> performance, but it still wouldn't explain why we're so much slower than
> Windows :-)
>

I presume you could hack TCP to no longer care about bufferbloat and you'll
probably match Windows 'performance' on a single flow and a lossless network.

Ie always send ~64KB TSO packets and fill the queues, inflating RTT.

Then, in presence of losses, you get a problem because the retransmit packets
can only be sent _after_ the huge queue that has been put on the sender.

If only TCP could predict the future ;)

