Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C3146E8B8
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 13:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbhLINDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 08:03:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20779 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234197AbhLINC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 08:02:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639054762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZRfiHdpAROaj5RZxNmVEP8L4rsUyor5ZtzX0PkgT3DA=;
        b=a3s3y7uqlaXJnCOWjhK55qsK3w+CK1dtj5CTmNP3udxny3YVq9trao0Z/EJJoEzxd6dk1i
        070Yexq3wYGIX2XK57qkDQ5dchvt8hfZ9gvbQe10XFy0tdXK5H2f30bU2XtEOoHlenZSf8
        bKqwWIC8QX8xCnAfO9y0W+KKDkXMkmI=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-FizhuXTqPIKVW3Te_0NAJQ-1; Thu, 09 Dec 2021 07:59:21 -0500
X-MC-Unique: FizhuXTqPIKVW3Te_0NAJQ-1
Received: by mail-pl1-f199.google.com with SMTP id i3-20020a170902c94300b0014287dc7dcbso2285928pla.16
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 04:59:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZRfiHdpAROaj5RZxNmVEP8L4rsUyor5ZtzX0PkgT3DA=;
        b=Z6Is7eqw6sjVLXBNEowb9K+N+RgSSvKZ9Mr+FXJdjPEcMPQf3YL9SIsJeb+0hJsETG
         m4jyWrja1hgtElCjLO/Mp5Fa6gBIszDSOHft2spl3Rp6KLOaLd63BsV25GiQg4YcYP6B
         MuU/YJbYdjD+nh+UKHzJNysUy8Y7Vniic9W5ozdV+4dlRGTrNbkDqzm+Qdpu1l53BMFF
         1rp7eAMeItQBiyNR/kA6HB9k9GqxPSLbwLa7IENNNu83IxzmBgRj99ujg6KXWvYndVXG
         2jmQybA2cc5oOuMutLFDIh6d5E372pJa4u0EOrirt0D0RndiWF+Lgh9H3IPgSUkElQi7
         Fl4A==
X-Gm-Message-State: AOAM532To2iGiazia64xPj5X4Sa4PHEVwHeIOpxNVI4+lsUeN/JNgFZi
        PMcNH/mQ2c84CL1r7bw1zpLzOrzjCMvkN8Mr8w0rNapc4TRw1kAnDsK7ccfIUp0mSGV7DvgxhuB
        ABkjGnxfWg6NIdURI
X-Received: by 2002:a17:90b:3e81:: with SMTP id rj1mr15297723pjb.111.1639054760492;
        Thu, 09 Dec 2021 04:59:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJ4Hn9dcG5VJSl/PiX30c3D5c2KWNXaO2aZVXFVR1STmmnlkS5rxxe0hdeRex2Zh70wRB8aQ==
X-Received: by 2002:a17:90b:3e81:: with SMTP id rj1mr15297690pjb.111.1639054760288;
        Thu, 09 Dec 2021 04:59:20 -0800 (PST)
Received: from [10.72.12.129] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x1sm5631088pgh.1.2021.12.09.04.59.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 04:59:19 -0800 (PST)
Subject: Re: [PATCH] libceph, ceph: potential dereference of null pointer
To:     Jeff Layton <jlayton@kernel.org>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>, idryomov@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211209025038.2028112-1-jiasheng@iscas.ac.cn>
 <2a79206d3472b279079fbef5c9507f8805061c47.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b01fa648-b0fe-c493-f45a-4ea23ae0f06e@redhat.com>
Date:   Thu, 9 Dec 2021 20:59:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2a79206d3472b279079fbef5c9507f8805061c47.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/9/21 7:20 PM, Jeff Layton wrote:
> On Thu, 2021-12-09 at 10:50 +0800, Jiasheng Jiang wrote:
>> The return value of kzalloc() needs to be checked.
>> To avoid use of null pointer in case of the failure of alloc.
>>
>> Fixes: 3d14c5d2b6e1 ("ceph: factor out libceph from Ceph file system")
>> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>> ---
>>   net/ceph/osd_client.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index ff8624a7c964..3203e8a34370 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -1234,6 +1234,8 @@ static struct ceph_osd *create_osd(struct ceph_osd_client *osdc, int onum)
>>   	WARN_ON(onum == CEPH_HOMELESS_OSD);
>>   
>>   	osd = kzalloc(sizeof(*osd), GFP_NOIO | __GFP_NOFAIL);
>> +	if (!osd)
>> +		return NULL;
>>   	osd_init(osd);
>>   	osd->o_osdc = osdc;
>>   	osd->o_osd = onum;
> __GFP_NOFAIL should ensure that it never returns NULL, right?

Yeah, from the comment, it make no sense to test for failure here:


204  * %__GFP_NOFAIL: The VM implementation _must_ retry infinitely: the 
caller
205  * cannot handle allocation failures. The allocation could block
206  * indefinitely but will never return with failure. Testing for
207  * failure is pointless.
208  * New users should be evaluated carefully (and the flag should be
209  * used only when there is no reasonable failure policy) but it is
210  * definitely preferable to use the flag rather than opencode endless
211  * loop around allocator.
212  * Using this flag for costly allocations is _highly_ discouraged.
213  */



> Also, if you're going to fix this up to handle that error then you
> probably also need to fix lookup_create_osd to handle a NULL return from
> create_osd as well.

