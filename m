Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4B02191CD
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgGHUrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:47:45 -0400
Received: from out0-136.mail.aliyun.com ([140.205.0.136]:55593 "EHLO
        out0-136.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgGHUrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 16:47:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594241263; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=huTsWghd64a8HiPHv+UAs97cTwHFGWEtUib+y7AL8kY=;
        b=DmbHVKNMpfe51R6PF12+JvEh38SvbCfYlNtGs1leMWDlX64TFZH58SMkyZjL3fjv4P9Csn8LDUUMn4gEzL5Ag7/lBy9ujS2Tcq74qVVlYp/yeibhbiQnU+BtgzEt27MTxJ/paSzYI68pHfN5qTu6U259Kpkddw+cljcxh8VniyU=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03279;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.I-S8Ee6_1594241260;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I-S8Ee6_1594241260)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Jul 2020 04:47:42 +0800
Subject: Re: [PATCH net-next v2 1/2] irq_work: Export symbol
 "irq_work_queue_on"
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <12188783-aa3c-9a83-1e9f-c92e37485445@alibaba-inc.com>
 <20200708.123750.2177855708364007871.davem@davemloft.net>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <322dd47d-e227-f655-5d4b-8402db457868@alibaba-inc.com>
Date:   Thu, 09 Jul 2020 04:47:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200708.123750.2177855708364007871.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 12:37 PM, David Miller wrote:
> From: "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
> Date: Thu, 09 Jul 2020 00:38:16 +0800
> 
>> @@ -111,7 +111,7 @@ bool irq_work_queue_on(struct irq_work *work, int cpu)
>>  	return true;
>>  #endif /* CONFIG_SMP */
>>  }
>> -
>> +EXPORT_SYMBOL_GPL(irq_work_queue_on);
> 
> You either removed the need for kthreads or you didn't.
> 
> If you are queueing IRQ work like this, you're still using kthreads.
> 
> That's why Eric is asking why you still need this export.
> 
I removed the kthread for bandwidth sharing.

This IRQ is used to notify other CPUs that it's OK to continue transmission after rate limiting. We tried other inter-CPU notifications, only IRQ could achieve a desirable latency.

Thanks,
- Xiangning
