Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B9722E19C
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 19:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgGZRTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 13:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgGZRTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 13:19:06 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA55EC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 10:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Q+r5WejeZ4S+ow0CvB9UpVQtbE3qgcSkoXQgcBgbnqI=; b=bo2A7HsvS0Kj5NacIqMONYvnBS
        A8Cws5hhnm88RzS3pp2ckFhcqpQ1WHPslST8Pyh9NYkhhNXnlFa6H1xmAYYVy6pUvsJQB4OcXxmM7
        4zJvVRV2gdiKtTo9CwnGdw5n6er0ADjmMWyh2ij6TX4mnz1RZQNx80kOk0O/4xOjxqG8=;
Received: from p5b206d80.dip0.t-ipconnect.de ([91.32.109.128] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1jzkIi-0006Fn-C7; Sun, 26 Jul 2020 19:19:04 +0200
Subject: Re: [RFC] net: add support for threaded NAPI polling
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>
References: <20200726163119.86162-1-nbd@nbd.name>
 <546c2923-ca6e-00e7-8bcb-3a3eb034a58e@gmail.com>
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
Message-ID: <daad6ba2-6916-3923-c116-d0470920fe1a@nbd.name>
Date:   Sun, 26 Jul 2020 19:19:03 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <546c2923-ca6e-00e7-8bcb-3a3eb034a58e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-26 18:49, Eric Dumazet wrote:
> On 7/26/20 9:31 AM, Felix Fietkau wrote:
>> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
>> poll function does not perform well. Since NAPI poll is bound to the CPU it
>> was scheduled from, we can easily end up with a few very busy CPUs spending
>> most of their time in softirq/ksoftirqd and some idle ones.
>> 
>> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
>> same except for using netif_threaded_napi_add instead of netif_napi_add.
>> 
>> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
>> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
>> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
>> thread.
>> 
>> With threaded NAPI, throughput seems stable and consistent (and higher than
>> the best results I got without it).
> 
> Note that even with a threaded NAPI, you will not be able to use more than one cpu
> to process the traffic.
For a single threaded NAPI user that's correct. The main difference here
is that the CPU running the poll function does not have to be the same
as the CPU that scheduled it, and it can change based on the load.
That makes a huge difference in my tests.

> Also I wonder how this will scale to more than one device using this ?
The workqueue creates multiple workers that pick up poll work, so it
should scale nicely.

> Say we need 4 NAPI, how the different work queues will mix together ?
> 
> We invented years ago RPS and RFS, to be able to spread incoming traffic
> to more cpus, for devices having one hardware queue.
Unfortunately that does not work well at all for my use case (802.11
drivers). A really large chunk of the work (e.g. 802.11 -> 802.3 header
conversion, state checks, etc.) is being done inside the poll function,
before it even goes anywhere near the network stack and RPS/RFS.

I did a lot of experiments trying to parallelize the work by tuning RFS,
IRQ affinity, etc. on MT7621. I didn't get anything close to the
consistent performance I get by adding threaded NAPI to mt76 along with
moving some other CPU intensive work from tasklets to threads.

- Felix
