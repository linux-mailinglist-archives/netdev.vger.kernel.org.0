Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AACC156A70
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbfFZN2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:28:53 -0400
Received: from mout.web.de ([212.227.15.4]:55609 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZN2x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 09:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561555690;
        bh=F2mf4IWIAL0/3qhafAlKcvmEvzPzkPnJ2u8U6qSNHPI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=W2MWf+HElzo8Gw17pB3BBhUrfYI3rKwQlGpqntESlHyRlDM9rDJK2NVRQdNik+Lzu
         1tAY+YbwP+x3gZdGWPWOv48Nm6TgkgAVeCtmx+f512MUnD8u1McyueTLDrPuUbAuIr
         MYzuBScq3N/9GxRgsJsJSqIiwGv5ocRKIBXnzVmE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.43.108] ([89.15.239.56]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LgHau-1iKulR3G6O-00nfjy; Wed, 26
 Jun 2019 15:28:10 +0200
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
From:   Soeren Moch <smoch@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=smoch@web.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <8d7da251-8218-ff4b-2cf3-8ed69c97275e@web.de>
Date:   Wed, 26 Jun 2019 15:28:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625095734.GA2886@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:9lq9T0E+qR/a4zTgRmDqRW1EiAV+h/mVCAeqaKHI97g5VloFyFa
 fgsjxrQMPJXrKsx6Vvsc6roQtn10TqmUNjokV20UyvxM5UB7dpCqHEwSQvYCizkr7BBQleD
 ZGrAd2JP4FNXyIcpC1e1JKAgkEwP8oM1lou65Aipu0OZYD2K3SVaS198CIodaJaxQsz5x0m
 Y7jZl1OBbEz72n15Sv1SA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/lmK+sOy14k=:dN92dasNqwGl5pXQXtUKSn
 TT0zFyiZj3c94y0Rz3ryB8Y/LanjBt4103/3B6mLBDWXgq6auYseLXlEQpOFsvj7vTZh6qJbo
 gXhbXi0ykP95kC5OWnN+r5sVRJzVIaAVXW1gLlmdMog6H2V0eb8gugWr7aj/bxRWimlD3gDQ6
 saw6LLI89Xnl+1aJ6rqLzTM+wXhjbIg02qu3hvpcsNGQg/1XZAw3lHH1jDTSBQ2Jj9tIz95k/
 zvSdUthRew+drPLJBpRSa68iey8F9oxjv4lLQsrliK0kmPhUv/EjdzMF9kXf5f6z/vVehpaZD
 bdc7LvAWB97oGORI+d9+RilwMtqfGxf4EZ5IEb61eW0lgDAb3K51Vs+pHFbbLP+3wG5mGj5I1
 bg1lyYwvD6usrZ42Qddc+oCMKE3MapvDFzdsHEQX+8DqELOq0oAQpR43vgRu36RgP89BljqQj
 uegyYoO5yTvhLG2JheWuPRPmQTCcQ0r/f1bkhwRDABq8Eqh6c5pFZZH8VlZP+ColDKeogF4UU
 8VelBhNcD2YQMFGInaC/puBReUKUqa947yxhveTKxwq1auyy1eZy22wkxK04JwiXb+8D16v37
 qVwbalDuDF2IoTJ+wUtWaFRP97KLMMPltYNucUXTeY3AdGfCfnHrU904dSQBn/5qnqrvdoejY
 1BdMSW72eeVPPUwgU9KsAf5KuW/rum5+CzyM0pSxb4Uaawqu74MY2bNfShKNbwbn6vp1KiYMy
 DPM8RViWTFp1yGiXlZBcSC9Qi+e1FXfyuuCK8oAWn3oyu1OrGb+rEhRXEXdCbsWFQ7p4paL8i
 LezV+n6QS0XcUxAE1S0gfCi7zXDLU9KbHNue9dcrOrXfdhwdF3z0otcCAQKTFFPlwRcpdFlWW
 Tm4desXYAXD+Gi/jk9QnC60JrLvn1EtSNJulfPODWQi7qgd1asIV/Df6TSNY1LE6aRadsrLDa
 0L/8M4ST2vI7Iht85L819xMAFhCU9EAE=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.06.19 11:57, Stanislaw Gruszka wrote:
> Hello
>
> On Fri, Jun 21, 2019 at 01:30:01PM +0200, Soeren Moch wrote:
>> On 18.06.19 11:34, Stanislaw Gruszka wrote:
>>> Hi
>>>
>>> On Mon, Jun 17, 2019 at 11:46:56AM +0200, Soeren Moch wrote:
>>>> Since commit ed194d136769 ("usb: core: remove local_irq_save() aroun=
d
>>>>  ->complete() handler") the handlers rt2x00usb_interrupt_rxdone() an=
d
>>>> rt2x00usb_interrupt_txdone() are not running with interrupts disable=
d
>>>> anymore. So these handlers are not guaranteed to run completely befo=
re
>>>> workqueue processing starts. So only mark entries ready for workqueu=
e
>>>> processing after proper accounting in the dma done queue.
>>> It was always the case on SMP machines that rt2x00usb_interrupt_{tx/r=
x}done
>>> can run concurrently with rt2x00_work_{rx,tx}done, so I do not
>>> understand how removing local_irq_save() around complete handler brok=
e
>>> things.
>> I think because completion handlers can be interrupted now and schedul=
ed
>> away
>> in the middle of processing.
>>> Have you reverted commit ed194d136769 and the revert does solve the p=
roblem ?
>> Yes, I already sent a patch for this, see [1]. But this was not consid=
ered
>> an acceptablesolution. Especially RT folks do not like code running wi=
th
>> interrupts disabled,particularly when trying to acquire spinlocks then=
=2E
>>
>> [1] https://lkml.org/lkml/2019/5/31/863
>>> Between 4.19 and 4.20 we have some quite big changes in rt2x00 driver=
:
>>>
>>> 0240564430c0 rt2800: flush and txstatus rework for rt2800mmio
>>> adf26a356f13 rt2x00: use different txstatus timeouts when flushing
>>> 5022efb50f62 rt2x00: do not check for txstatus timeout every time on =
tasklet
>>> 0b0d556e0ebb rt2800mmio: use txdone/txstatus routines from lib
>>> 5c656c71b1bf rt2800: move usb specific txdone/txstatus routines to rt=
2800lib
>>>
>>> so I'm a bit afraid that one of those changes is real cause of
>>> the issue not ed194d136769 .
>> I tested 4.20 and 5.1 and see the exact same behavior. Reverting this
>> usb core patchsolves the problem.
>> 4.19.x (before this usb core patch) is running fine.
>>>> Note that rt2x00usb_work_rxdone() processes all available entries, n=
ot
>>>> only such for which queue_work() was called.
>>>>
>>>> This fixes a regression on a RT5370 based wifi stick in AP mode, whi=
ch
>>>> suddenly stopped data transmission after some period of heavy load. =
Also
>>>> stopping the hanging hostapd resulted in the error message "ieee8021=
1
>>>> phy0: rt2x00queue_flush_queue: Warning - Queue 14 failed to flush".
>>>> Other operation modes are probably affected as well, this just was
>>>> the used testcase.
>>> Do you know what actually make the traffic stop,
>>> TX queue hung or RX queue hung?
>> I think RX queue hang, as stated in the patch title. "Queue 14" means =
QID_RX
>> (rt2x00queue.h, enum data_queue_qid).
>> I also tried to re-add local_irq_save() in only one of the handlers. A=
dding
>> this tort2x00usb_interrupt_rxdone() alone solved the issue, while doin=
g so
>> for tx alonedid not.
>>
>> Note that this doesn't mean there is no problem for tx, that's maybe
>> just more
>> difficult to trigger.
>>>> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/driver=
s/net/wireless/ralink/rt2x00/rt2x00dev.c
>>>> index 1b08b01db27b..9c102a501ee6 100644
>>>> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
>>>> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
>>>> @@ -263,9 +263,9 @@ EXPORT_SYMBOL_GPL(rt2x00lib_dmastart);
>>>>
>>>>  void rt2x00lib_dmadone(struct queue_entry *entry)
>>>>  {
>>>> -	set_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags);
>>>>  	clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
>>>>  	rt2x00queue_index_inc(entry, Q_INDEX_DMA_DONE);
>>>> +	set_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags);
>>> Unfortunately I do not understand how this suppose to fix the problem=
,
>>> could you elaborate more about this change?
>>>
>> Re-adding local_irq_save() around thisrt2x00lib_dmadone()solved
>> the issue. So I also tried to reverse the order of these calls.
>> It seems totally plausible to me, that the correct sequence is to
>> first clear the device assignment, then to set the status to dma_done,=

>> then to trigger the workqueue processing for this entry. When the hand=
ler
>> is scheduled away in the middle of this sequence, now there is no
>> strange state where the entry can be processed by the workqueue while
>> not declared dma_done for it.
>> With this changed sequence there is no need anymore to disable interru=
pts
>> for solving the hang issue.
> Thanks very much for explanations. However I still do not fully
> understand the issue. Q_INDEX_DMA_DONE index is only checked on TX
> processing (on RX we use only Q_INDEX_DONE and Q_INDEX) and
> ENTRY_OWNER_DEVICE_DATA is already cleared before rt2x00lib_dmadone()
> in rt2x00usb_interrupt_rxdone() .
>
> So I'm not sure how changing the order solve the problem. Looks
> for me that the issue is triggered by some rt2x00lib_dmadone()
> call done on error path (not in rt2x00usb_interrupt_rxdone())
> and it race with this check:
>
>         if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||=

>             test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
>                 return false;
>
> in rt2x00usb_kick_rx_entry() - we return instead of submit urb.
Hi Stanislaw,

the good news is: your patch below also solves the issue for me. But
removing the ENTRY_DATA_STATUS_PENDING check in
rt2x00usb_kick_rx_entry() alone does not help, while removing this check
in rt2x00usb_work_rxdone() alone does the trick.

So the real race seems to be that the flags set in the completion
handler are not yet visible on the cpu core running the workqueue. And
because the worker is not rescheduled when aborted, the entry can just
wait forever.
Do you think this could make sense?
> I'm somewhat reluctant to change the order, because TX processing
> might relay on it (we first mark we wait for TX status and
> then mark entry is no longer owned by hardware).
OK, maybe it's just good luck that changing the order solves the rx
problem. Or can memory barriers associated with the spinlock in
rt2x00lib_dmadone() be responsible for that?
(I'm testing on a armv7 system, Cortex-A9 quadcore.)

While looking at it, why we double-clear ENTRY_OWNER_DEVICE_DATA in
rt2x00usb_interrupt_rxdone() directly and in rt2x00lib_dmadone() again,
while not doing the same for tx? Would it make more sense to possibly
set ENTRY_DATA_IO_FAILED before clearing ENTRY_OWNER_DEVICE_DATA in
rt2x00usb_interrupt_rxdone() as for tx?
>  However on RX
> side ENTRY_DATA_STATUS_PENDING bit make no sense as we do not
> wait for status. We should remove ENTRY_DATA_STATUS_PENDING on
> RX side and perhaps this also will solve issue you observe.
I agree that removing the unnecessary checks is a good idea in any case.
> Could you please check below patch, if it fixes the problem as well?
At least I could not trigger the problem within transferring 10GB of
data. But maybe the probability for triggering this bug is just lower
because ENTRY_OWNER_DEVICE_DATA is cleared some time before
ENTRY_DATA_STATUS_PENDING is set?

Soeren
>
> Stanislaw
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/n=
et/wireless/ralink/rt2x00/rt2x00usb.c
> index b6c1344..731e633 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> @@ -360,8 +360,7 @@ static void rt2x00usb_work_rxdone(struct work_struc=
t *work)
>  	while (!rt2x00queue_empty(rt2x00dev->rx)) {
>  		entry =3D rt2x00queue_get_entry(rt2x00dev->rx, Q_INDEX_DONE);
> =20
> -		if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
> -		    !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
> +		if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
>  			break;
> =20
>  		/*
> @@ -413,8 +412,7 @@ static bool rt2x00usb_kick_rx_entry(struct queue_en=
try *entry, void *data)
>  	struct queue_entry_priv_usb *entry_priv =3D entry->priv_data;
>  	int status;
> =20
> -	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
> -	    test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
> +	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
>  		return false;
> =20
>  	rt2x00lib_dmastart(entry);


