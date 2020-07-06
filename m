Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094A5215FB7
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgGFT4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:56:17 -0400
Received: from out0-133.mail.aliyun.com ([140.205.0.133]:54680 "EHLO
        out0-133.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgGFT4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594065374; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=bIs2gu1NmzYV3vWuz7GjmXaBQrqM9zw6EIcTOOztRWo=;
        b=B81IdMCuuIl23a2cNQv2+il1hSWyt2qqHg09YMK4ZYx5hDlpeNFFXwQGNy3i1npCYfny1M8gmmOxKu3D3Ihz0O1TAkRUmqLHwFlp39XnTJfdgZyRUUgsfuqGICAzmeN1tGIjvMFAoaanxDvWjn223Lxt0A8arMgjCV68aKri+mY=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03301;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.Hz7G4DS_1594065372;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.Hz7G4DS_1594065372)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Jul 2020 03:56:13 +0800
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB)
 Qdisc
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
 <20200706113738.5a5fdf7d@hermes.lan>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <a949a956-637b-90e1-991a-52991397278b@alibaba-inc.com>
Date:   Tue, 07 Jul 2020 03:56:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200706113738.5a5fdf7d@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/20 11:37 AM, Stephen Hemminger wrote:
> On Tue, 07 Jul 2020 02:08:13 +0800
> "YU, Xiangning" <xiangning.yu@alibaba-inc.com> wrote:
> 
>> +static inline int ltb_drain(struct ltb_class *cl)
>> +{
>> +	typeof(&cl->drain_queue) queue;
>> +	struct sk_buff *skb;
>> +	int npkts, bytes;
>> +	unsigned long now = NOW();
>> +	int cpu;
>> +	struct ltb_sched *ltb = qdisc_priv(cl->root_qdisc);
>> +	struct ltb_pcpu_sched *pcpu_q;
>> +	s64 timestamp;
>> +	bool need_watchdog = false;
>> +	struct cpumask cpumask;
>> +
>> +	npkts = 0;
>> +	bytes = 0;
> 
> It would be safer to use unsigned int for npkts and bytes.
> These should never be negative.
> 

Thank you Stephen. I will make these changes, including those mentioned in your previous email.
 
- Xiangning
