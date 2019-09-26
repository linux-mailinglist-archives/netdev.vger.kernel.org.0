Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B36BFB90
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 00:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbfIZWwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 18:52:33 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33701 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbfIZWwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 18:52:33 -0400
Received: by mail-pl1-f196.google.com with SMTP id d22so267972pls.0
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 15:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mJ2Y/xqT3QijZlcvXzcn2MrjQdezEdi4Y2cZC7NA26c=;
        b=eZzCRzKgaRT6nneCc5zFWIHIaxWQBtP5CDMcxIDvwjrGaWXHQr/oDbiT3/7/xtsWLI
         DLT5R7N/cIu2UrvtPNM4B6yXy+vU1883iujfMm8fBqIyaXLAY+vgruQwsdSHvcLZfC5B
         QeEWGDMdnflh5PYpLPdNJNUiUCzfkrHl0EqCOA77WJFhU4maUU24Ze2Bqdngynlw91f/
         CkygP/fMtYpmWR0B7aewJHlxs4rVF/NiQbqScsm078ofTHqLMMyCA6riVfCkoLrvQCSR
         sGnlwfn8rAhhM/a51uL84lwLYY1w/hB1BiudOh1s1wnLX6GvH6kZhfUr7rDKH1ooSkmy
         3vrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mJ2Y/xqT3QijZlcvXzcn2MrjQdezEdi4Y2cZC7NA26c=;
        b=l9xdPyq1J+H95vzsJXcNlXoVdPpnzYZ1gB+uCQGYAl/c9CUEhEpQ7fFG9LXF8KyF6U
         wG5AjRvsDv9d2wzYgTAaYasSNSq1TQO2DNJ3abfRro+VtVMa2OC93moXRNi9Yi5MyOUk
         orKSs+vpEINwqw7MQCvpb8qP5xAs+U65N1ldw0SbrHaJAlg03I0uSAN8SH1cJ9hPhccZ
         BjxkUAa4Cuhh1AcwiZlGqXRXhUekfZae4yXKHCg5HlV+cCrpm8LAlCYzda5nP10wIbR3
         IIMEH+uJOS2fB7RTr0lcsWRVa0GWOhRw2Bn5ochVOksV2Sxo/sn0Q1DScpZwAs9IC7SO
         1WTg==
X-Gm-Message-State: APjAAAXrDlVC9KUZ9I/BIFKh0tAVHsFTWXKJ3RX4HSe/yKh6jOJ2IVmH
        7rv4BhDpq65OYBeGxu4CUt4UcnX6
X-Google-Smtp-Source: APXvYqwO5fCzeFenmeGZyisloQ3SFOTfRQ+73JZyhNv6yf9eImhLBI7lkC2Fci1OCEDyS9pRZpSXUQ==
X-Received: by 2002:a17:902:654a:: with SMTP id d10mr1057964pln.199.1569538352269;
        Thu, 26 Sep 2019 15:52:32 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id b20sm306334pff.158.2019.09.26.15.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 15:52:31 -0700 (PDT)
Subject: Re: [PATCH] net: use unlikely for dql_avail case
To:     Daniel Borkmann <daniel@iogearbox.net>,
        xiaolinkui <xiaolinkui@kylinos.cn>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20190925024043.31030-1-xiaolinkui@kylinos.cn>
 <20190925122501.GA27720@pc-66.home>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d5225e3a-717e-c836-f94c-6df4f29e43ca@gmail.com>
Date:   Thu, 26 Sep 2019 15:52:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925122501.GA27720@pc-66.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/19 5:25 AM, Daniel Borkmann wrote:
> On Wed, Sep 25, 2019 at 10:40:43AM +0800, xiaolinkui wrote:
>> This is an unlikely case, use unlikely() on it seems logical.
>>
>> Signed-off-by: xiaolinkui <xiaolinkui@kylinos.cn>
> 
> It's already here [0], but should probably rather get reverted instead
> due to lack of a more elaborate reasoning on why it needs to be done
> this way instead of letting compiler do it's job in this case. "Seems
> logical" is never a good technical explanation. Do you have any better
> analysis you performed prior to submitting the patch (twice by now)?
>

Yes, we need more details here.

We could probably save more cpu cycles checking if we can move
the smb_mb() after the dql_avail() check :)


 
> Thanks,
> Daniel
> 
>   [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f3acd33d840d3ea3e1233d234605c85cbbf26054
> 
>> ---
>>  include/linux/netdevice.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 88292953aa6f..005f3da1b13d 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -3270,7 +3270,7 @@ static inline void netdev_tx_completed_queue(struct netdev_queue *dev_queue,
>>  	 */
>>  	smp_mb();
>>  
>> -	if (dql_avail(&dev_queue->dql) < 0)
>> +	if (unlikely(dql_avail(&dev_queue->dql) < 0))
>>  		return;
>>  
>>  	if (test_and_clear_bit(__QUEUE_STATE_STACK_XOFF, &dev_queue->state))
>> -- 
>> 2.17.1
>>
>>
>>
