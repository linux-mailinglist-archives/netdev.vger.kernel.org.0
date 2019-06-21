Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C21D94E71C
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 13:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfFULas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 07:30:48 -0400
Received: from mout.web.de ([212.227.15.4]:55765 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfFULar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 07:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561116623;
        bh=ohriBF6Qa7tVQ2jjGMp4RJRZn6wx7ZoLrZZ5Ug7zEPQ=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:References:Date:In-Reply-To;
        b=bVn5kQwOil1SMa4VFPYnDQSa2b/R0aDXTLCrDS6EZMRr74WhhqZhhmgNHMtv2mgUn
         /IToy3dXK5PKoJyejjfNCxtsJiLrEYt4TVng7Gcg89VQq904meXQJXhEqxEcqXF7Rb
         Dc3giAowNSVkzxiWJqO0S2Xk16Btr3ygWWVwIDTI=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.43.108] ([89.15.238.141]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LZeou-1iInVD11FE-00lTMR; Fri, 21
 Jun 2019 13:30:23 +0200
From:   Soeren Moch <smoch@web.de>
Subject: Re: [PATCH] rt2x00: fix rx queue hang
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20190617094656.3952-1-smoch@web.de>
 <20190618093431.GA2577@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=smoch@web.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <b6899d78-447c-3cb3-4bec-e4050660ccaa@web.de>
Date:   Fri, 21 Jun 2019 13:30:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190618093431.GA2577@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:ejyXhG/mBQ/WrzMP3Mmx9IX2BSWonozc/bSHWkrHyjsjB8cKFWc
 GfSE67GnuQVjuyDKsGoKPtMKpPYBYOv7kCrtU1gonuFbUetA502CeeMjebsszEZdKV80g0j
 BordgU2APkXKkLYGHIDvSm6vjKBCFeRuRuV/jEzaB4of5xBC1gnJu1u+B1XN6IgvJ8xwloa
 U1lu9JLHy8Xk8hu2klTVA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:pRgjwDXAj78=:RDFFs2kiOmKIpI8TrAZzu9
 /gjuxpS5/K/kg1zVxiZMSM+ZcxF1QmK/qUFcaZGI6bfma1Ddwh0g7y4+mLOJR5g0GiRHM3PQs
 7lr8Y/hgOfHqfOggkChELk0wI6BmKnEUo7g0p2hBth0GVI/v1s4QvEg320GL2WouKmuUVXu0+
 h91Ky9XqHmgXGJ4OCl1OSlsF/e967CeyeBYUZbjaK7Fy0Z4fHQdzZUcl6MVz85N8Z402JRtE6
 mH4G+QCYXBcxJnFAKKn3UkNqecs2kLNM830sIvE5ShWm5nOWFnAP+H78IfCaU1VBqsFawkran
 8YgdRJ6/0PsnXjajRZQx0u3gFFPPKkweDI6xNpkqFo1KBaCzw+gj1GptaBxh9ZpII0MpDjcCa
 HUSaPjHYagx8aJLSiponeAWOwDSX3MG72p2lKMnqMWO9X2l3UarPNYMI1oFGTt4yL+9asDqDY
 AbkB2+9eyewGG97yDXUGEwsW3W3/ff3S390abCAYqY3GLv2bopR2xr6vD1NpDuWJ9Z/vUMqZo
 OCNBxBBjNUbduyRURC2rpOb6C3vTdB6Vd79OmLJGZV8vlug5dnuyy/kAtCVA/DxyVnfTsuwS0
 rdPchZrVeTCzEaFHXDMOicJDOk+iducSX5sJjv7CkB4LwaxKSEDy08ZsSlyn5isZNGj41mqCY
 M8nzlRoWDVT8WZR2n6m/oBbJbBHXJzT4IwjFbI4J7kks30+l3sdT/IU87WoD3Gee31FYFtgBf
 wyFOVGOufT1b/NnBBLyhFzEJhgpnKF9iLiV9c3ce1NIEEF22oCR9ssgrMsfLy7AAy8sRhuEuK
 NrO5R1D7yvnmPMGCmCBjltCDacUHHQ9bFUYLZuRERnvR157+IFWQKJxaQQr64H7VMD5l97t0l
 8FLLmFS4rXSJUuxxOLpPfvJPapvxfL2T+6wyx3ohyJAXPs32bDDzI8w5N/xI2Rqumle0aaVBB
 dVCAKwO9/HFzkKwAbPXUhV8ynLc6xixPYN1gt/3xEkLLcexrpLi2O
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On 18.06.19 11:34, Stanislaw Gruszka wrote:
> Hi
>
> On Mon, Jun 17, 2019 at 11:46:56AM +0200, Soeren Moch wrote:
>> Since commit ed194d136769 ("usb: core: remove local_irq_save() around
>>  ->complete() handler") the handlers rt2x00usb_interrupt_rxdone() and
>> rt2x00usb_interrupt_txdone() are not running with interrupts disabled
>> anymore. So these handlers are not guaranteed to run completely before=

>> workqueue processing starts. So only mark entries ready for workqueue
>> processing after proper accounting in the dma done queue.
> It was always the case on SMP machines that rt2x00usb_interrupt_{tx/rx}=
done
> can run concurrently with rt2x00_work_{rx,tx}done, so I do not
> understand how removing local_irq_save() around complete handler broke
> things.
I think because completion handlers can be interrupted now and scheduled
away
in the middle of processing.
> Have you reverted commit ed194d136769 and the revert does solve the pro=
blem ?
Yes, I already sent a patch for this, see [1]. But this was not considere=
d
an acceptablesolution. Especially RT folks do not like code running with
interrupts disabled,particularly when trying to acquire spinlocks then.

[1] https://lkml.org/lkml/2019/5/31/863
> Between 4.19 and 4.20 we have some quite big changes in rt2x00 driver:
>
> 0240564430c0 rt2800: flush and txstatus rework for rt2800mmio
> adf26a356f13 rt2x00: use different txstatus timeouts when flushing
> 5022efb50f62 rt2x00: do not check for txstatus timeout every time on ta=
sklet
> 0b0d556e0ebb rt2800mmio: use txdone/txstatus routines from lib
> 5c656c71b1bf rt2800: move usb specific txdone/txstatus routines to rt28=
00lib
>
> so I'm a bit afraid that one of those changes is real cause of
> the issue not ed194d136769 .
I tested 4.20 and 5.1 and see the exact same behavior. Reverting this
usb core patchsolves the problem.
4.19.x (before this usb core patch) is running fine.
>> Note that rt2x00usb_work_rxdone() processes all available entries, not=

>> only such for which queue_work() was called.
>>
>> This fixes a regression on a RT5370 based wifi stick in AP mode, which=

>> suddenly stopped data transmission after some period of heavy load. Al=
so
>> stopping the hanging hostapd resulted in the error message "ieee80211
>> phy0: rt2x00queue_flush_queue: Warning - Queue 14 failed to flush".
>> Other operation modes are probably affected as well, this just was
>> the used testcase.
> Do you know what actually make the traffic stop,
> TX queue hung or RX queue hung?
I think RX queue hang, as stated in the patch title. "Queue 14" means QID=
_RX
(rt2x00queue.h, enum data_queue_qid).
I also tried to re-add local_irq_save() in only one of the handlers. Addi=
ng
this tort2x00usb_interrupt_rxdone() alone solved the issue, while doing s=
o
for tx alonedid not.

Note that this doesn't mean there is no problem for tx, that's maybe
just more
difficult to trigger.
>> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/=
net/wireless/ralink/rt2x00/rt2x00dev.c
>> index 1b08b01db27b..9c102a501ee6 100644
>> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
>> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
>> @@ -263,9 +263,9 @@ EXPORT_SYMBOL_GPL(rt2x00lib_dmastart);
>>
>>  void rt2x00lib_dmadone(struct queue_entry *entry)
>>  {
>> -	set_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags);
>>  	clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
>>  	rt2x00queue_index_inc(entry, Q_INDEX_DMA_DONE);
>> +	set_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags);
> Unfortunately I do not understand how this suppose to fix the problem,
> could you elaborate more about this change?
>
Re-adding local_irq_save() around thisrt2x00lib_dmadone()solved
the issue. So I also tried to reverse the order of these calls.
It seems totally plausible to me, that the correct sequence is to
first clear the device assignment, then to set the status to dma_done,
then to trigger the workqueue processing for this entry. When the handler=

is scheduled away in the middle of this sequence, now there is no
strange state where the entry can be processed by the workqueue while
not declared dma_done for it.
With this changed sequence there is no need anymore to disable interrupts=

for solving the hang issue.

Regards,
Soeren


