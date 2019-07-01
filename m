Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674DA5B966
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 12:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbfGAKuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 06:50:14 -0400
Received: from mout.web.de ([212.227.15.14]:44469 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbfGAKuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 06:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561978194;
        bh=A9juv7KEALyG/8d4tzO2tyzoZXceHsI2LTIg1lN/Jvo=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=G3vfoH6xgKX2KypOJvdupNT4PHc5LAa2axFw7sO/zGXfPySyKGApRl/bINaaghNj+
         rS1EZHxkTkX5Bv6mQ1tHkXYLYil3U9ll6F28X2FNVZk0ftOF/kHIHTE8bsS8DrrR/b
         1Zu4+ApAuJploM7+fmaU8bkQaQfdMICg+NP/BhNw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.4] ([77.13.129.177]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MZDga-1hyKo21Ijc-00Kya1; Mon, 01
 Jul 2019 12:49:54 +0200
Subject: Re: [PATCH] rt2x00: fix rx queue hang
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20190617094656.3952-1-smoch@web.de>
 <20190618093431.GA2577@redhat.com>
 <b6899d78-447c-3cb3-4bec-e4050660ccaa@web.de>
 <20190625095734.GA2886@redhat.com>
 <8d7da251-8218-ff4b-2cf3-8ed69c97275e@web.de>
 <20190629085041.GA2854@redhat.com>
From:   Soeren Moch <smoch@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=smoch@web.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <06c55c1d-6da6-76b2-f6e7-c8eeccd5aa35@web.de>
Date:   Mon, 1 Jul 2019 12:49:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190629085041.GA2854@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:SEuWNML7nRz5SrQ51HbvkurnQHsUALLgR2TZ9j4rooAj21nQUN6
 rNgfBruJ5RZEni85NG7YR4i+0rCpilP8++iZ0VYb/wm9xpBdq03f7jfoiN9FaJz2d/kONbc
 ZRJUC7jQiJdqQoeQSqmmYVJOvWjPETsI40gq/I5FylVEAxmWawXa2zoNszGA7WWjlHIYlq1
 88mf3hg75wrgQ/ge7OQBQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:toJL8zBMtZ0=:vCwmx/PEyoEXHmv+XuH8AG
 zn1xFVjanxL+ag7Ji8jn21eGTmSUwG0r5ppAmVg7njSmaZLLko1T3taXhDluHD5O5oEiMOYj2
 Qp+saWCFluOx8DdGZSpARBLpfzsSj8zXGJ9AuF6qD4zVNTC0Yh6Of02q3zSKB4vA1c3aU5Dem
 T630m55Zi/wPhn4HUcszzEfMM8JZRukhtIN58NZGJBGwLI0Qhr4U32MFsx9YIwtD9MLJZDltv
 igqSa/8H4ALJJ89NnQC8fYTn+zKIQ9pigAegslkPM+l9KAXesmHchwg9vjKB27vCqboTalYhZ
 9hPlpnFDq3h4EDV3pel1TaaMyikCDsm4DcYaFYjAZnWgDzIIbholm7Zj/bLxdaG02n+WoRk/C
 dVO7+Ljk7eF14MVHy7+QnlnaKLRpWIVPJo6H3Wj/Lj0c5HOJC31nyJWjTGbUwoGilsjAah2/k
 nde5qutr/aYC8YskTrKsWWaCZDX/BPYC6fCuyhKIPvmG9ZQ7P1wdpV29Ug6FZYODvKfi1KAOS
 Kmqvy6OBGRN4kODTcoQtc8RoAa2tz7MlKnGD3tgGpFyczBFkDh1hSMXYmQLKHvXQyqHy14GNM
 aYbdcmy8OV1WfUUB1XcpNkHhKbHKgH/CWAuuQ7IUepuGik7LXjsI7bKbws0Ee6R0w0yDfT0zO
 OBWd5655F6Njcgt2/TwdKowNnxER2XUCffa9no0w7TdIoF3rSwVmqTv42wyGQlEYaPV1j2EoW
 osCb8c7kHs4A4ODG+Jkv9aTh59TcX59Q3FTAz/fsgGnakD++7yK/EIRlt7s2Lo3zK2Qp7GXkN
 WvdwGbxQf9WN2RTQJQT3ZyOCZPB8aon9IlH5Ha6ibDlK7t4g99ernjyOYUFBMRBpf4Jyptko0
 uLAqYXy3ZeOudJDvhLxSGPiUMYycWbWOCEuPB/KIx26flQT+/a4VM5K1AcZ/Ub8yZqneUJy6t
 QhuR4x2QFYf3i3SO/Bp95kX7YCIOpmxMs//TKr4oWf/BExbS9oThWgUqH5sYQ3XTa8IjXJGXV
 Lxqc4HBQHMiRLerC8Ea0ZezTOzZzM2fF5Fc1Zsd7WvqN+KF1eVTV5/GNvXslj2mlSiwCrb4on
 pwqS26LShY63QE=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 29.06.19 10:50, Stanislaw Gruszka wrote:
> Hello
>
> On Wed, Jun 26, 2019 at 03:28:00PM +0200, Soeren Moch wrote:
>> Hi Stanislaw,
>>
>> the good news is: your patch below also solves the issue for me. But
>> removing the ENTRY_DATA_STATUS_PENDING check in
>> rt2x00usb_kick_rx_entry() alone does not help, while removing this che=
ck
>> in rt2x00usb_work_rxdone() alone does the trick.
>>
>> So the real race seems to be that the flags set in the completion
>> handler are not yet visible on the cpu core running the workqueue. And=

>> because the worker is not rescheduled when aborted, the entry can just=

>> wait forever.
>> Do you think this could make sense?
> Yes.
>
>>> I'm somewhat reluctant to change the order, because TX processing
>>> might relay on it (we first mark we wait for TX status and
>>> then mark entry is no longer owned by hardware).
>> OK, maybe it's just good luck that changing the order solves the rx
>> problem. Or can memory barriers associated with the spinlock in
>> rt2x00lib_dmadone() be responsible for that?
>> (I'm testing on a armv7 system, Cortex-A9 quadcore.)
> I'm not sure, rt2x00queue_index_inc() also disable/enable interrupts,
> so maybe that make race not reproducible.=20
I tested some more, the race is between setting ENTRY_DATA_IO_FAILED (if
needed) and enabling workqueue processing. This enabling was done via
ENTRY_DATA_STATUS_PENDING in my patch. So setting
ENTRY_DATA_STATUS_PENDING behind the spinlock in
rt2x00lib_dmadone()/rt2x00queue_index_inc() moved this very close to
setting of ENTRY_DATA_IO_FAILED (if needed). While still in the wrong
order, this made it very unlikely for the race to show up.
>
>> While looking at it, why we double-clear ENTRY_OWNER_DEVICE_DATA in
>> rt2x00usb_interrupt_rxdone() directly and in rt2x00lib_dmadone() again=
,
> rt2x00lib_dmadone() is called also on other palaces (error paths)
> when we have to clear flags.
Yes, but also clearing ENTRY_OWNER_DEVICE_DATA in
rt2x00usb_interrupt_rxdone() directly is not necessary and can lead to
the wrong processing order.
>>  while not doing the same for tx?=20
> If I remember correctly we have some races on rx (not happened on tx)
> that was solved by using test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA).
I searched in the history, it actually was the other way around. You
changed test_and_clear_bit() to test_bit() in the TX path. I think this
is also the right way to go in RX.
>> Would it make more sense to possibly
>> set ENTRY_DATA_IO_FAILED before clearing ENTRY_OWNER_DEVICE_DATA in
>> rt2x00usb_interrupt_rxdone() as for tx?
> I don't think so, ENTRY_DATA_IO_FAILED should be only set on error
> case.

Yes of course. But if the error occurs, it should be signalled before
enabling the workqueue processing, see the race described above.

After some more testing I'm convinced that this would be the right fix
for this problem. I will send a v2 of this patch accordingly.
>
>>>  However on RX
>>> side ENTRY_DATA_STATUS_PENDING bit make no sense as we do not
>>> wait for status. We should remove ENTRY_DATA_STATUS_PENDING on
>>> RX side and perhaps this also will solve issue you observe.
>> I agree that removing the unnecessary checks is a good idea in any cas=
e.
>>> Could you please check below patch, if it fixes the problem as well?
>> At least I could not trigger the problem within transferring 10GB of
>> data. But maybe the probability for triggering this bug is just lower
>> because ENTRY_OWNER_DEVICE_DATA is cleared some time before
>> ENTRY_DATA_STATUS_PENDING is set?
> Not sure. Anyway, could you post patch removing not needed checks
> with proper description/changelog ?
>
OK, I will do so.

Soeren

