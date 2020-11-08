Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEC22AA9F4
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 08:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgKHH2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 02:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgKHH2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 02:28:39 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21524C0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Nov 2020 23:28:39 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id l1so1080840wrb.9
        for <netdev@vger.kernel.org>; Sat, 07 Nov 2020 23:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=LF8+xdOvr6XY27NLXGIrhH9dQ/W4uX2IFzyOsBPTrJU=;
        b=X7ZFF6MM5Q+UGnYq4zHa7fwjRKtEaBI1ihQ7Yf3lcgIl0idDe4JEydau9CpyV4A+Vk
         K/QCJ3BLeF1xO6+RN/+A7s8+4bfhEmvhUpiHHQFuoygMqN4l+cdph/mJp7WSL3VsDjh9
         Cft3Ef/8d4IjSSrvS+UBDaElRMDKL9YD5vfwn0BPWUBOeF3YaZyZcC56FpdYMVZCIrPy
         tLMKkdMJPzMyrYn3mOrmtuUVXi00mKgvp2kVzg9yi80B4CUYLyQ1vdxm58oX2UnuHMeI
         05al8bWy4LzdaGGsQITTc+0RXVXWQIjZGntYwWq1Xu2qV9uofsgii7zqdsNXaKjnPBzs
         pFoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=LF8+xdOvr6XY27NLXGIrhH9dQ/W4uX2IFzyOsBPTrJU=;
        b=IShzybtyqjhNYyPDhZj6fslWrtxiW1XxNuBVHmoJKWzR1aZs1B++NPxxOjcGqPZRzo
         686cb72XHAvcJGONLPnH1QWjN8dXOQqMNNW0w28jbYaKN/T+1307CueBQx34v+Zzppsk
         YHn0tcrp0bG+F51yQEjY3B/QeSOlI74dyg0rXHrH9WBSrUpbgKNQ3CN7WrV1cG6Xt8+c
         77QXwBlh6WG0LQbbHpgohEVJDmviVv2eJZv73jTOJRBwSHA8osxKdLcAuVMqXmzS+pAU
         oC++yav8Ot80c7BaEU8VWXdov6kET5IvYcIk6zz71GZc/UiOUJ+ORpcCwgZHtUNpeXTn
         i7TQ==
X-Gm-Message-State: AOAM532F6FxqH1b3n+bxjk+h0FsQV7MOt15EdttiR/GlMOFJbIkvuCUK
        WLdnfd370nyQigRJ6OeRrzg=
X-Google-Smtp-Source: ABdhPJxyzVaXtjY3y/amwyu0+AcZfR3L/uD7hKjMITwUKi1Vwi2FVIKiPCBWwondvFqnews3UENOKQ==
X-Received: by 2002:adf:e40e:: with SMTP id g14mr10617928wrm.285.1604820517766;
        Sat, 07 Nov 2020 23:28:37 -0800 (PST)
Received: from [192.168.1.11] ([213.57.108.142])
        by smtp.gmail.com with ESMTPSA id n10sm9079013wrx.9.2020.11.07.23.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 23:28:36 -0800 (PST)
Subject: Re: [PATCH net-next RFC v1 07/10] nvme-tcp : Recalculate crc in the
 end of the capsule
To:     Shai Malin <smalin@marvell.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Boris Pismenny <borisp@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "edumazet@google.com" <edumazet@google.com>
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        "boris.pismenny@gmail.com" <boris.pismenny@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-8-borisp@mellanox.com>
 <a17cf1ca-4183-8f6c-8470-9d45febb755b@grimberg.me>
 <PH0PR18MB3845764B48FD24C87FA34304CCED0@PH0PR18MB3845.namprd18.prod.outlook.com>
 <PH0PR18MB38458FD325BD77983D2623D4CCEB0@PH0PR18MB3845.namprd18.prod.outlook.com>
 <PH0PR18MB3845FDA1C8E6063A03ECCE14CCEB0@PH0PR18MB3845.namprd18.prod.outlook.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <5dcbb7b1-f1e2-f436-f211-8f4ef6712e52@gmail.com>
Date:   Sun, 8 Nov 2020 09:28:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <PH0PR18MB3845FDA1C8E6063A03ECCE14CCEB0@PH0PR18MB3845.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08/11/2020 8:59, Shai Malin wrote:
> On 09/10/2020 1:44, Sagi Grimberg wrote:
>> On 9/30/20 7:20 PM, Boris Pismenny wrote:
>>
>>> crc offload of the nvme capsule. Check if all the skb bits are on, 
>>> and if not recalculate the crc in SW and check it.
>> Can you clarify in the patch description that this is only for pdu 
>> data digest and not header digest?
>>
> Not a security expert, but according to my understanding, the NVMeTCP data digest is a layer 5 CRC,  and as such it is expected to be end-to-end, meaning it is computed by layer 5 on the transmitter and verified on layer 5 on the receiver.
> Any data corruption which happens in any of the lower layers, including their software processing, should be protected by this CRC. For example, if the IP or TCP stack has a bug that corrupts the NVMeTCP payload data, the CRC should protect against it. It seems that may not be the case with this offload.

If the TCP/IP stack corrupts packet data, then likely many TCP/IP consumers will be effected, and it will be fixed promptly.
Unlike with TOE, these bugs can be easily fixed/hotpatched by the community.

>
>>> This patch reworks the receive-side crc calculation to always run at 
>>> the end, so as to keep a single flow for both offload and non-offload.
>>> This change simplifies the code, but it may degrade performance for 
>>> non-offload crc calculation.
>> ??
>>
>>  From my scan it doeesn't look like you do that.. Am I missing something?
>> Can you explain?
>>
>>> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
>>> Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
>>> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
>>> Signed-off-by: Yoray Zack <yorayz@mellanox.com>
>>> ---
>>>   drivers/nvme/host/tcp.c | 66
>> ++++++++++++++++++++++++++++++++++++-----
>>>   1 file changed, 58 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c index
>>> 7bd97f856677..9a620d1dacb4 100644
>>> --- a/drivers/nvme/host/tcp.c
>>> +++ b/drivers/nvme/host/tcp.c
>>> @@ -94,6 +94,7 @@ struct nvme_tcp_queue {
>>>   	size_t			data_remaining;
>>>   	size_t			ddgst_remaining;
>>>   	unsigned int		nr_cqe;
>>> +	bool			crc_valid;
> I suggest to rename it to ddgst_valid.
>
Sure
