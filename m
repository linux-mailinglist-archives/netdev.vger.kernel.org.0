Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB5A2AD9A8
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbgKJPF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgKJPF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 10:05:26 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE24C0613CF
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 07:05:24 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id n129so14412415iod.5
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 07:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QiO5/DXNXtpuh6pt0YMU0h8raRvXdoQZZ/8S74SQK5U=;
        b=BZCydrXf9hLOcbb77GecIA58sJemggzTVT7YlAVAyA+PH+ZkQAoQTFhxrXNs5pBRT+
         +rwncrPFvXp7kXQhIU6rHfEorzXyq/LwUsOW62p2HKkAOke2RdMlOJT4LtiqYC8IfYi5
         23LJosOIb4wefYL33u60plGhYhN7rhLXHa85aNjzoNiLGQCQsY8RVCACy41iEGwgwsld
         FbacxKTxK2i6ojX+bX9p9igLjIlrEIyXDxS9fiU9EkrskCYVn4jYZcIlJDQtMnPIB6Eq
         iYtWbJaI/zx6MP3eg6FXNYa6cjOD7hSLzgtbrjpVWSIrbht/QEiPbgx4kEYMkJZP1Cme
         eagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QiO5/DXNXtpuh6pt0YMU0h8raRvXdoQZZ/8S74SQK5U=;
        b=QNktH49PskdRKQujKGIQg3ARXCWkGJQRaqsck6Qzf5HqrQKVrxnV76D0+uxlxxbMRQ
         qhd4EnK7gndzM+875v4KBIDPkNjYo93sB/f0kI97Lv8UEFklFNSOWL1FkPw4f+oRcH3Z
         gqTgXy4VsDjlOIC80V7akalSBPxGAXzJQb4032qkibBRrNfiz98K/Ws0P6fts2IiU51P
         8aaEoaBPU5ZgU9gyzq2pOqxDrtD3JYPATo4dhHflTOrUeJjiW/UqfJ3ix+U05Buj98th
         4TtZ72rYa7FquiND1OZzbzizr49GWJ5eHKXBKXg950a2zuH0nfqBgt9N8rggZutdRMj7
         MEIw==
X-Gm-Message-State: AOAM530iH1ZbOHR8LYZ8phfgakcD/d9odZ7FYYDiV/iegK7iPSklMWa0
        84g5irjfEHqm5NzTPVkAvFA=
X-Google-Smtp-Source: ABdhPJzF6QKQttQyi5+HfJLBUL2VgqYXQI/zH1kmJb0E6IeY4k4MFWYI45jjaxzPYYBF2AJH5pRxeA==
X-Received: by 2002:a02:408a:: with SMTP id n132mr9150482jaa.66.1605020723847;
        Tue, 10 Nov 2020 07:05:23 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:7980:a277:20c7:aa44])
        by smtp.googlemail.com with ESMTPSA id s26sm5381900ioe.2.2020.11.10.07.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 07:05:23 -0800 (PST)
Subject: Re: [PATCH net V2] Exempt multicast addresses from five-second
 neighbor lifetime
To:     Jeff Dike <jdike@akamai.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20201109025052.23280-1-jdike@akamai.com>
 <20201109114733.0ee71b82@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <aaf62231-75d2-6b2f-9982-3d24ca4e4e80@akamai.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5210487b-fde2-c6f1-a065-ad25103acaed@gmail.com>
Date:   Tue, 10 Nov 2020 08:05:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <aaf62231-75d2-6b2f-9982-3d24ca4e4e80@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/20 7:21 AM, Jeff Dike wrote:
> Hi Jakub,
> 
> On 11/9/20 2:47 PM, Jakub Kicinski wrote:
>> This makes sense because mcast L2 addr is calculated, not discovered,
>> and therefore can be recreated at a very low cost, correct?
> 
> Yes.
> 
>> Perhaps it would make sense to widen the API to any "computed" address
>> rather than implicitly depending on this behavior for mcast?
> 
> I'm happy to do that, but I don't know of any other types of addresses which are computed and end up in the neighbors table.
> 
>> I'm not an expert tho, maybe others disagree.
>>
>>> +static int arp_is_multicast(const void *pkey)
>>> +{
>>> +	return IN_MULTICAST(htonl(*((u32 *)pkey)));
>>> +}
>>
>> net/ipv4/arp.c:935:16: warning: cast from restricted __be32
>>
>> s/u32/__be32/
>> s/htonl/ntohl/
> 
> Thanks, I ran sparse, but must have missed that somehow.
> 

I missed this yesterday -- ipv4_is_multicast() is more appropriate and
the norm for IPv4 addresses.
