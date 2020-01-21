Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEA3144298
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgAUQ5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:57:47 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35291 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgAUQ5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:57:47 -0500
Received: by mail-wr1-f66.google.com with SMTP id g17so4086593wro.2
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 08:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fiRn9DGKJey+BHTDT52ABAY8ODR+BAkXmTGuHK0xeVI=;
        b=sthT/pQ1MehqIaXdCHqknuRHGIHXTwRZ9wNYJZP8n94qpovVuuDFs6QFIZJ1MFZHLf
         KcgBqVUdznBmTqJVH1tehqJixO2WNzTYmNNoMYa7a2W6mzvsX2ouJZXyyj+v0Cc6FDDw
         SvM1WtpiO22A5hZn19bPqZNWC4mVzJlNAI2uTPB0z8rvbHvGbpa4yMalPu6CWxUp7Whs
         0Ab/sR3e9wFy5o5r31yz8yClbVInwyg/xf+qx4NpTHIRG6BNavyKdb51ZIb0P6EK2Hy2
         8pZcriSnLHRQQiMHxj1bN52DUgiYzcESEYG7D2ftiOUM+MQeSG1LMg7pa6CO89hFet0K
         MFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fiRn9DGKJey+BHTDT52ABAY8ODR+BAkXmTGuHK0xeVI=;
        b=HekCsmElQyc+DreuirINPOiChUYvbAe0U7sqiPL+CUEVNNKYvWCH5epxMbPvG9wrut
         4XJROpHuWXA/8csVIghxvr0jhphIwxkjdF4LSI6mP79yfqums41SQ4D+yJUVtIIHYI9l
         VIUqYFY7QjcuXGhqoEHQ3/DoZEvVQxUN7D6M+MY6TSib6jbodR/HEBVdnJZOwJBm2URt
         Cf86sLn/HJ/zbju+hfUMEVnZklcGP7Ak2onIqKhmT5rrGWeB80jwxePODDDBCUBUWF9V
         hWKkn9ERuWkbMgSbP55hfcvUHIEvns307Cv/i9Eazswf0D/eJPMfvP20a/N2Pu2TengQ
         e9xQ==
X-Gm-Message-State: APjAAAU6J4lKWMjlS5AMaWs8nInh+77hvnM6Bg60LQjW/3tVRsNOoFBm
        c2zUICswZbqQ3ysTev3ilKWvuiOWzV8=
X-Google-Smtp-Source: APXvYqxYdNr/nmwIvPcChuc5ERP9a4jxDI+5XJSJ7F6cSUEzxLnirZP0C3k/UG1vkKURQ154V2Bhpg==
X-Received: by 2002:adf:eb48:: with SMTP id u8mr6081148wrn.283.1579625864813;
        Tue, 21 Jan 2020 08:57:44 -0800 (PST)
Received: from [10.80.2.221] ([193.47.165.251])
        by smtp.googlemail.com with ESMTPSA id p17sm53139462wrx.20.2020.01.21.08.57.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 08:57:44 -0800 (PST)
Subject: Re: [PATCH rdma-next 07/10] RDMA/efa: Allow passing of optional
 access flags for MR registration
To:     Gal Pressman <galpress@amazon.com>
Cc:     Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org,
        jgg@mellanox.com, dledford@redhat.com, saeedm@mellanox.com,
        maorg@mellanox.com, michaelgur@mellanox.com, netdev@vger.kernel.org
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
 <1578506740-22188-8-git-send-email-yishaih@mellanox.com>
 <6df1dbee-f35e-a5ad-019b-1bf572608974@amazon.com>
From:   Yishai Hadas <yishaih@dev.mellanox.co.il>
Message-ID: <89ddb3c3-a386-1aa4-e3e4-a4b0531b0978@dev.mellanox.co.il>
Date:   Tue, 21 Jan 2020 18:57:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <6df1dbee-f35e-a5ad-019b-1bf572608974@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/2020 6:37 PM, Gal Pressman wrote:
> On 08/01/2020 20:05, Yishai Hadas wrote:
>> From: Michael Guralnik <michaelgur@mellanox.com>
>>
>> As part of adding a range of optional access flags that drivers need to
>> be able to accept, mask this range inside efa driver.
>> This will prevent the driver from failing when an access flag from
>> that range is passed.
>>
>> Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
>> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
>> ---
>>   drivers/infiniband/hw/efa/efa_verbs.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
>> index 50c2257..b6b936c 100644
>> --- a/drivers/infiniband/hw/efa/efa_verbs.c
>> +++ b/drivers/infiniband/hw/efa/efa_verbs.c
>> @@ -1370,6 +1370,7 @@ struct ib_mr *efa_reg_mr(struct ib_pd *ibpd, u64 start, u64 length,
>>   		IB_ACCESS_LOCAL_WRITE |
>>   		(is_rdma_read_cap(dev) ? IB_ACCESS_REMOTE_READ : 0);
>>   
>> +	access_flags &= ~IB_UVERBS_ACCESS_OPTIONAL_RANGE;
> 
> Hi Yishai,
> access_flags should be masked with IB_ACCESS_OPTIONAL instead of
> IB_UVERBS_ACCESS_OPTIONAL_RANGE.
> 

You are talking from namespace point of view, right ? both have same value.

If it's important, can you send some patch to replace ?

> Also, could you please make sure to CC me to future EFA patches?
> 

Sure, thanks.
