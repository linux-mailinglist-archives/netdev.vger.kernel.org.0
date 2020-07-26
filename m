Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9683222E1F1
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 20:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgGZSYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 14:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgGZSYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 14:24:04 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1558C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 11:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/U3cjg7u205Ba/RVpuqzwPf4YvWkKNNfC/HfL4BFkfY=; b=sDhcQmpE59uz9Qzc90mc0od0e7
        UxOfENbw14OYbzEi8aZhvHFd0TEAjpjZLrULCD5dgExhbgv9wVGkXNlT7oBdfBVCmyGwRyJZV+Jia
        55LipG4d7uwu8pcaT/0koXluYU/ddqIGAaBQEC2nlcDUjmO/moLhuecJPoyti9+OWfFM=;
Received: from p5b206d80.dip0.t-ipconnect.de ([91.32.109.128] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1jzlJZ-0001l5-0b; Sun, 26 Jul 2020 20:24:01 +0200
Subject: Re: [RFC] net: add support for threaded NAPI polling
To:     Eric Dumazet <erdnetdev@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>
References: <20200726163119.86162-1-nbd@nbd.name>
 <546c2923-ca6e-00e7-8bcb-3a3eb034a58e@gmail.com>
 <daad6ba2-6916-3923-c116-d0470920fe1a@nbd.name>
 <0305d884-0f59-b9c3-5489-b6fd1391d76d@gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <5cbf7d05-8427-9f92-7b79-e3ddcf420b18@nbd.name>
Date:   Sun, 26 Jul 2020 20:24:00 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0305d884-0f59-b9c3-5489-b6fd1391d76d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-26 19:58, Eric Dumazet wrote:
> 
> 
> On 7/26/20 10:19 AM, Felix Fietkau wrote:
>> On 2020-07-26 18:49, Eric Dumazet wrote:
>>> On 7/26/20 9:31 AM, Felix Fietkau wrote:
>>>> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
>>>> poll function does not perform well. Since NAPI poll is bound to the CPU it
>>>> was scheduled from, we can easily end up with a few very busy CPUs spending
>>>> most of their time in softirq/ksoftirqd and some idle ones.
>>>>
>>>> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
>>>> same except for using netif_threaded_napi_add instead of netif_napi_add.
>>>>
>>>> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
>>>> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
>>>> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
>>>> thread.
>>>>
>>>> With threaded NAPI, throughput seems stable and consistent (and higher than
>>>> the best results I got without it).
>>>
>>> Note that even with a threaded NAPI, you will not be able to use more than one cpu
>>> to process the traffic.
>> For a single threaded NAPI user that's correct. The main difference here
>> is that the CPU running the poll function does not have to be the same
>> as the CPU that scheduled it, and it can change based on the load.
>> That makes a huge difference in my tests.
> 
> This really looks like there is a problem in the driver itself.
> 
> Have you first checked that this patch was not hurting your use case ?
> 
> commit 4cd13c21b207e80ddb1144c576500098f2d5f882    softirq: Let ksoftirqd do its job
> 
> If yes, your proposal would again possibly hurt user space threads competing
> with a high priority workqueue, and packets would not be consumed by user applications.
> Having cpus burning 100% of cycles in kernel space is useless.
I already checked that a while back, and this patch is not hurting my
use case. I think it is actually helping, since I'm putting on enough
load to keep most softirq activity in ksoftirqd.

One thing to consider about my use case is that I'm bridging traffic
between an Ethernet interface and an 802.11 interface. Those packets do
not go through user space. If I push enough traffic, the ksoftirqd
instance running NAPI of the 802.11 device keeps the CPU 100% busy. I do
not have any signficant user space activity during my tests.

Since tx and rx NAPI are scheduled from the same IRQ which only fires on
one CPU, they end up in the same ksoftirqd instance.

Considering that one CPU is not enough to handle entire NAPI workload
for the device, threaded NAPI helps by letting other (otherwise mostly
idle) CPUs pick up some of the workload.

> It seems you need two cpus per queue, I guess this might be because
> you use a single NAPI for both tx and rx ?
> 
> Have you simply tried to use two NAPI, as some Ethernet drivers do ?
I'm already doing that.

> Do not get me wrong, but scheduling a thread only to process one packet at a time
> will hurt common cases.
> 
> Really I do not mind if you add a threaded NAPI, but it seems you missed
> a lot of NAPI requirements in the proposed patch.
> 
> For instance, many ->poll() handlers assume BH are disabled.
> 
> Also part of RPS logic depends on net_rx_action() calling net_rps_action_and_irq_enable()
I will look into that, thanks.

- Felix
