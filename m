Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9ECC4BA295
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241731AbiBQOJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:09:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241702AbiBQOJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:09:18 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881BC2B164A
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 06:08:59 -0800 (PST)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220217140857euoutp027dd30fe6308c07e49907dacbe85aa3fe~UmAsU4xrP0408204082euoutp02B
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:08:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220217140857euoutp027dd30fe6308c07e49907dacbe85aa3fe~UmAsU4xrP0408204082euoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1645106937;
        bh=E/jxehB5hKuAgnYIlP+yIxEeXQin5MI6cKssrtv7qY0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=OGMbzBS1Ia8UWULcPYa0pUQDoWi8dDdJ3R02UUTtR/xAas/AgTJRGyuXe9AXKS3LU
         m9nCy31SRcHaOgJcLWHB0k3UWB7nqXKaRuHwhTfqaw/SYomG3d/e3XFkPuZlACyLzR
         2kqtJy5o0POnYRBfO+FpLUF7qrtNDTBWxzsTY94c=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220217140856eucas1p2a25756618c4c6cb157ee994a7f5b90ce~UmArtYROI1639116391eucas1p2N;
        Thu, 17 Feb 2022 14:08:56 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id C7.AA.10260.8F65E026; Thu, 17
        Feb 2022 14:08:56 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220217140856eucas1p2f7f5ac00303c19b5c9a003474dc41478~UmArMDXCM0184001840eucas1p2i;
        Thu, 17 Feb 2022 14:08:56 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220217140856eusmtrp24148a4c1dffac83801b85e102adca7b1~UmArLNG4D3110531105eusmtrp2D;
        Thu, 17 Feb 2022 14:08:56 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-cc-620e56f84fe6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 2F.73.09522.7F65E026; Thu, 17
        Feb 2022 14:08:55 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220217140855eusmtip10e0d549c9b287fce0fa9a878f4901234~UmAqeL2ER3156631566eusmtip1f;
        Thu, 17 Feb 2022 14:08:55 +0000 (GMT)
Message-ID: <c2a64979-73d1-2c22-e048-c275c9f81558@samsung.com>
Date:   Thu, 17 Feb 2022 15:08:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] net: Correct wrong BH disable in
 hard-interrupt.
Content-Language: en-US
From:   Marek Szyprowski <m.szyprowski@samsung.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rg?= =?UTF-8?Q?ensen?= 
        <toke@toke.dk>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgense?= =?UTF-8?Q?n?= 
        <toke@redhat.com>
In-Reply-To: <ce67e9c9-966e-3a08-e571-b7f1dacb3814@samsung.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsWy7djP87o/wviSDBZfl7X48vM2u8W0i5OY
        LT4fOc5msXjhN2aLOedbWCyeHnvEbrGnfTuzRdOOFUwWF7b1sVocWyBmsXnTVGaLS4cfsVhs
        fb+C3YHXY8vKm0weO2fdZfdYsKnUo+vGJWaPTas62TzenTvH7vF+31U2jy2HLrJ5fN4kF8AZ
        xWWTkpqTWZZapG+XwJUxoecSY8EWpYp5c16xNTB+kuli5OSQEDCRWPdyPmMXIxeHkMAKRom7
        M9ewQjhfGCWePJ3CAuF8ZpRYsHc/O0zL+v8v2CESyxklWn8vhar6yChx+/A7VpAqXgE7id+n
        p7KA2CwCqhLvj79lg4gLSpyc+QQozsEhKpAksWibO0hYWCBA4tDMSWAlzALiEreezGcCsdkE
        DCW63naBxUUETCUaLx4C28Us0MkiceHeAbBdnAL2Eps+zmCFaJaXaN46mxmkSEJgOafE6q6F
        bBBnu0h0TlzKCGELS7w6vgXqHRmJ/ztBtoE0NDNKPDy3lh3C6WGUuNw0A6rDWuLOuV9sIGcz
        C2hKrN+lDxF2lPizupkZJCwhwCdx460gxBF8EpO2TYcK80p0tAlBVKtJzDq+Dm7twQuXmCcw
        Ks1CCpZZSP6fheSdWQh7FzCyrGIUTy0tzk1PLTbOSy3XK07MLS7NS9dLzs/dxAhMc6f/Hf+6
        g3HFq496hxiZOBgPMUpwMCuJ8H44yJskxJuSWFmVWpQfX1Sak1p8iFGag0VJnDc5c0OikEB6
        YklqdmpqQWoRTJaJg1OqgclbKmvP+cNTL6YfkPxwkWv/HSNziR+uOys4l7uzeb1beGnu0pld
        MRf33bGrcna52pXTd+qgUq3Z0fWSy/XXbKww0Nk6NzG1Szrui3hHVngib6whB4Nhk/vZlmC+
        yFk/rQ9GiBT8aZzHsmT30ft1HQKnzN8x/Livw1FZWhevkJHB1jBT+ICQ55/yjA8Xly8We/37
        p9IprQds6Rf7bF4xbG/e2fePn59bqMjj282zQqUhZs373v+c7nWVbeU7Ixl5XY6wUgPB0ruH
        7mSm2fVJGSXkv7h858+uKZZ/QwrEnp+KsUryyrKqkq6OnJt436r1qUb+zsYNMWofnJtFRXxl
        XBLt6rTD4tlvrWURC5BXYinOSDTUYi4qTgQAUJXZJ+IDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t/xu7rfw/iSDDaesrH48vM2u8W0i5OY
        LT4fOc5msXjhN2aLOedbWCyeHnvEbrGnfTuzRdOOFUwWF7b1sVocWyBmsXnTVGaLS4cfsVhs
        fb+C3YHXY8vKm0weO2fdZfdYsKnUo+vGJWaPTas62TzenTvH7vF+31U2jy2HLrJ5fN4kF8AZ
        pWdTlF9akqqQkV9cYqsUbWhhpGdoaaFnZGKpZ2hsHmtlZKqkb2eTkpqTWZZapG+XoJcxoecS
        Y8EWpYp5c16xNTB+kuli5OSQEDCRWP//BTuILSSwlFHi6XF5iLiMxMlpDawQtrDEn2tdbF2M
        XEA17xkltr45BJbgFbCT+H16KguIzSKgKvH++Fs2iLigxMmZT8DiogJJEuumz2cGsYUF/CS+
        PT/DCGIzC4hL3HoynwnEZhMwlOh62wXWKyJgKtF48RALyDJmgV4WieZb61ggrtvKKLFoRhWI
        zSlgL7Hp4wxWiEFmEl1bu6CGyks0b53NPIFRaBaSO2Yh2TcLScssJC0LGFlWMYqklhbnpucW
        G+oVJ+YWl+al6yXn525iBEb1tmM/N+9gnPfqo94hRiYOxkOMEhzMSiK8Hw7yJgnxpiRWVqUW
        5ccXleakFh9iNAUGxkRmKdHkfGBaySuJNzQzMDU0MbM0MLU0M1YS5/Us6EgUEkhPLEnNTk0t
        SC2C6WPi4JRqYJp49OiDe3wsm3Jb/Y1C4ueqPW5JPfr4tbSaacY3Ro5JgqU++aYFmpFHL773
        ETr7JJLztNdy/4vXbyYfVZq5a/vfA7wP389sCYxPUjL5+TdNqX3LvIVnzOUPM3HtYln/zeJb
        3yKnxV7B9YXlEb7dDTdsgjfP0SxM/Dt/EUfMCZ8rvz8eTsj7vkp4V/fqcmlJL8YOXfUzLU1e
        xgbn7nzR6Z0hoZu5+c7JiI9ppwL3nTaO0Pl6dUvEshwzZR/5vSZ3snS9T57NPpjhuI5h/xvh
        /c+9dXcsXDchwDYwWjxz/v0qmULpoAnXrS5fz33wPOlEYFQxl/ikNc/5V83PY/DIbnq45MbH
        0gRBM6Nf1duMLyqxFGckGmoxFxUnAgA2VQp+cwMAAA==
X-CMS-MailID: 20220217140856eucas1p2f7f5ac00303c19b5c9a003474dc41478
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08
References: <CGME20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08@eucas1p2.samsung.com>
        <Yg05duINKBqvnxUc@linutronix.de>
        <ce67e9c9-966e-3a08-e571-b7f1dacb3814@samsung.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

On 17.02.2022 07:35, Marek Szyprowski wrote:
> Hi Andrzej,
>
> On 16.02.2022 18:50, Sebastian Andrzej Siewior wrote:
>> I missed the obvious case where netif_ix() is invoked from hard-IRQ
>> context.
>>
>> Disabling bottom halves is only needed in process context. This ensures
>> that the code remains on the current CPU and that the soft-interrupts
>> are processed at local_bh_enable() time.
>> In hard- and soft-interrupt context this is already the case and the
>> soft-interrupts will be processed once the context is left (at irq-exit
>> time).
>>
>> Disable bottom halves if neither hard-interrupts nor soft-interrupts are
>> disabled. Update the kernel-doc, mention that interrupts must be enabled
>> if invoked from process context.
>>
>> Fixes: baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked 
>> in any context.")
>> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> ---
>> Marek, does this work for you?
>
> Yes, this fixed the issue. Thanks!
>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

I've just noticed that there is one more issue left to fix (the $subject 
patch is already applied) - this one comes from threaded irq (if I got 
the stack trace right):

------------[ cut here ]------------
WARNING: CPU: 0 PID: 147 at kernel/softirq.c:363 
__local_bh_enable_ip+0xa8/0x1c0
Modules linked in: cpufreq_powersave cpufreq_conservative brcmfmac 
brcmutil cfg80211 s3fwrn5_i2c s3fwrn5 nci crct10dif_ce exynos_gsc nfc 
s5p_jpeg hci_uart btqca s
5p_mfc v4l2_mem2mem btbcm bluetooth videobuf2_dma_contig 
videobuf2_memops ecdh_generic videobuf2_v4l2 panfrost drm_shmem_helper 
ecc videobuf2_common gpu_sched rfkill videodev mc ip_tables x_tab
les ipv6
CPU: 0 PID: 147 Comm: irq/150-dwc3 Not tainted 5.17.0-rc4-next-20220217+ 
#4557
Hardware name: Samsung TM2E board (DT)
pstate: 400000c5 (nZcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __local_bh_enable_ip+0xa8/0x1c0
lr : netif_rx+0xa4/0x2c0
...

Call trace:
  __local_bh_enable_ip+0xa8/0x1c0
  netif_rx+0xa4/0x2c0
  rx_complete+0x214/0x250
  usb_gadget_giveback_request+0x58/0x170
  dwc3_gadget_giveback+0xe4/0x200
  dwc3_gadget_endpoint_trbs_complete+0x100/0x388
  dwc3_thread_interrupt+0x46c/0xe20
  irq_thread_fn+0x28/0x98
  irq_thread+0x184/0x238
  kthread+0x100/0x120
  ret_from_fork+0x10/0x20
irq event stamp: 645
hardirqs last  enabled at (643): [<ffff8000080c93b8>] 
finish_task_switch+0x98/0x288
hardirqs last disabled at (644): [<ffff8000090a6e34>] 
_raw_spin_lock_irqsave+0xb4/0x148
softirqs last  enabled at (252): [<ffff800008010488>] _stext+0x488/0x5cc
softirqs last disabled at (645): [<ffff800008ed71b0>] netif_rx+0x188/0x2c0
---[ end trace 0000000000000000 ]---


>
>>   net/core/dev.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 909fb38159108..87729491460fc 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -4860,7 +4860,9 @@ EXPORT_SYMBOL(__netif_rx);
>>    *    congestion control or by the protocol layers.
>>    *    The network buffer is passed via the backlog NAPI device. 
>> Modern NIC
>>    *    driver should use NAPI and GRO.
>> - *    This function can used from any context.
>> + *    This function can used from interrupt and from process 
>> context. The
>> + *    caller from process context must not disable interrupts before 
>> invoking
>> + *    this function.
>>    *
>>    *    return values:
>>    *    NET_RX_SUCCESS    (no congestion)
>> @@ -4870,12 +4872,15 @@ EXPORT_SYMBOL(__netif_rx);
>>   int netif_rx(struct sk_buff *skb)
>>   {
>>       int ret;
>> +    bool need_bh_off = !(hardirq_count() | softirq_count());
>>   -    local_bh_disable();
>> +    if (need_bh_off)
>> +        local_bh_disable();
>>       trace_netif_rx_entry(skb);
>>       ret = netif_rx_internal(skb);
>>       trace_netif_rx_exit(ret);
>> -    local_bh_enable();
>> +    if (need_bh_off)
>> +        local_bh_enable();
>>       return ret;
>>   }
>>   EXPORT_SYMBOL(netif_rx);
>
> Best regards

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

