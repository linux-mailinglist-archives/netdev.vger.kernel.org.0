Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF8D5F6CA
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 12:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfGDKn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 06:43:57 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:44985 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727385AbfGDKn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 06:43:56 -0400
Received: by mail-ed1-f53.google.com with SMTP id k8so4965294edr.11
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 03:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=4ofw2FIl5QoNB/0eRNrrBlKwXN68NmrFtclAc0VH8Ag=;
        b=ZqCyhHKT6tzVfewJDzArRYM9qGvYIm/Yei+7I4xb53wFriNKV3pZfuZqWZQcdemlZI
         tv8av7N7C+k23RcIfFT1OkDOTRUIRBxUGPFx0mTe2dcZA+ItV3nQWVARM/sQnPjoTBe0
         UFLOAznpn8YtsOw7FsJh5H8rCqKHE7CmcT6MRyJJciI0eRPXki4xB6xEak/czyQXXFFK
         WCfy9jxrsnyotRe7p6j0+51cRa1Nd4q4yYwB5CKFB/E7oKKHJf/D4Xt642oTNFekMaTI
         AShTGHLVlTIsyZifkqM8D/Ixq8KLN84AITNB8Ji18TEzmtsiRz7EgON6CdZfUXTwfjEI
         h5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4ofw2FIl5QoNB/0eRNrrBlKwXN68NmrFtclAc0VH8Ag=;
        b=RTBwLT4C9UL9lnfY+ezMP2IiW2SMNHeKACzl3rX/Cb5YvLiWerk+iYKUAJpSu3zV/n
         PSVTo4CDjI43JJozg4lQU2T3ODpPyQnPsrub9qfk2gEgx847OHh5iAMj326PymWZrCaT
         WqhNoUvTlAjPEVrCkKiNt57bvy1+HMWiYYSxOp+N+iKP2nDVPd0HtPRCMJv84poycgIb
         uJTC+dSHkhcSVShH/8SMJyBxBEhDDCF4wH4C0ZKucLCmfNAlKnBZ6rAEyFVZlfmznQvP
         avHe+cXVNEggI/M3P0hMh1KReeefiTTPF2kwjljm6GsSpbaHHU/Jw3rwI/YAOEueB9+l
         Um1w==
X-Gm-Message-State: APjAAAX1kV9UL6kPE4TL5K0vaj50AUYGO2i4o47wDyamN3eMW7F2F43i
        qfNib/JuToxC4gGkPGcIehxj65EZ
X-Google-Smtp-Source: APXvYqw98/IWIZKGbMHJn9aGD7kIVJfBNgZp9nLPMy1eARJwskfjLlJUdtiqVPJRbRAINhnJBrgkzA==
X-Received: by 2002:a05:6402:1459:: with SMTP id d25mr47413412edx.235.1562237034376;
        Thu, 04 Jul 2019 03:43:54 -0700 (PDT)
Received: from win95.local (D96447CA.static.ziggozakelijk.nl. [217.100.71.202])
        by smtp.gmail.com with ESMTPSA id j17sm1674875ede.60.2019.07.04.03.43.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 03:43:53 -0700 (PDT)
Subject: Re: bug: tpacket_snd can cause data corruption
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Network Development <netdev@vger.kernel.org>
References: <1562152028-2693-1-git-send-email-debrabander@gmail.com>
 <CAF=yD-+wHzfP6QWJzc=num_VaFvN3RYXV-c3+-VY8EjS87WEiA@mail.gmail.com>
From:   Frank de Brabander <debrabander@gmail.com>
Message-ID: <d32bc4b8-b547-1d78-e245-2ec51df19c77@gmail.com>
Date:   Thu, 4 Jul 2019 12:43:51 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAF=yD-+wHzfP6QWJzc=num_VaFvN3RYXV-c3+-VY8EjS87WEiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03-07-19 18:07, Willem de Bruijn wrote:

> On Wed, Jul 3, 2019 at 7:08 AM Frank de Brabander <debrabander@gmail.com> wrote:
>> In commit 5cd8d46e a fix was applied for data corruption in
>> tpacket_snd. A selftest was added in commit 358be656 which
>> validates this fix.
>>
>> Unfortunately this bug still persists, although since this fix less
>> likely to trigger. This bug was initially observed using a PACKET_MMAP
>> application, but can also be seen by tweaking the kernel selftest.
>>
>> By tweaking the selftest txring_overwrite.c to run
>> as an infinite loop, the data corruption will still trigger. It
>> seems to occur faster by generating interrupts (e.g. by plugging
>> in USB devices). Tested with kernel version 5.2-RC7.
>>
>> Cause for this bug is still unclear.
> The cause of the original bug is well understood.
>
> The issue you report I expect is due to background traffic. And more
> about the test than the kernel implementation.
>
> Can you reproduce the issue when running the modified test in a
> network namespace (./in_netns.sh ./txring_overwrite)?
>
> I observe the issue report outside that, but not inside. That implies
> that what we're observing is random background traffic. The modified
> test then drops the unexpected packet because it mismatches on length.
> As a result the next read (the test always sends two packets, then
> reads both) will report a data mismatch. Because it is reading the
> first test packet, but expecting the second. Output with a bit more
> data:
>
> count: 200
> count: 300
> count: 400
> count: 500
>   read: 90B != 100B
> wrong pattern: 0x61 != 0x62
> count: 600
> count: 700
> count: 800
>   read: 90B != 100B
> wrong pattern: 0x61 != 0x62
> count: 900
>   read: 90B != 100B
> wrong pattern: 0x61 != 0x62
>
> Notice the clear pattern.
>
> This does not trigger inside a network namespace, which is how
> kselftest invokes txring_override (from run_afpackettests).
I'm also able to reproduce the issue inside a network namespace.

I've added the extra logging, as seen in your output, for
mismatches on length. Running the test without ./in_netns.sh
is indeed as you describe:

read error: 66 != 100
wrong pattern: 0x61 != 0x62
read error: 66 != 100
wrong pattern: 0x61 != 0x62
read error: 74 != 100
read error: 66 != 100
wrong pattern: 0x53 != 0x61
wrong pattern: 0x53 != 0x62
read error: 66 != 100
read error: 66 != 100
read error: 66 != 100
wrong pattern: 0x61 != 0x62
read error: 95 != 100
read error: 95 != 100
wrong pattern: 0xffffffbe != 0x61
wrong pattern: 0x61 != 0x62
read error: 66 != 100

But even when running the test with ./in_netns.sh it shows
"wrong pattern", this time without length mismatches:

wrong pattern: 0x62 != 0x61
wrong pattern: 0x62 != 0x61
wrong pattern: 0x62 != 0x61
wrong pattern: 0x62 != 0x61
wrong pattern: 0x62 != 0x61
wrong pattern: 0x62 != 0x61
wrong pattern: 0x62 != 0x61
wrong pattern: 0x62 != 0x61
wrong pattern: 0x62 != 0x61
wrong pattern: 0x62 != 0x61

As already mentioned, it seems to trigger mainly (only ?) when
an USB device is connected. The PC I'm testing this on has an
USB hub with many ports and connected devices. When connecting
this USB hub, the amount of "wrong pattern" errors that are
shown seems to correlate to the amount of new devices
that the kernel should detect. Connecting in a single USB device
also triggers the error, but not on every attempt.

Unfortunately have not found any other way to force the
error to trigger. E.g. running stress-ng to generate CPU load or
timer interrupts does not seem to have any impact.
