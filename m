Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B9841D39C
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348362AbhI3GzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347826AbhI3GzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 02:55:13 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51E7C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 23:53:30 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g7so18009500edv.1
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 23:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dd6OwnIvPJ5t7wHzhUq0tJHh/UGUFCt4FY2OzT6HwgU=;
        b=lzxR7/Bv6RE0Mym9twPAPkAbfZek7uz8Lyw9gb2ICNuplp1UWoBNQlccJUywFCPqS+
         8cqDwQXXlXHe9SloJHw5wzzDlVMGS399x0adUZ1YMpCgM2HQtbcBgt+wFW9+YnRc9C9X
         uGopzn3VnF/vMHJfd07yhajpqwB9uj904Qv9jaTdjxCDT5LEvUEyHLniuP6UaKuITDg+
         UQjSUH9UXf0iE+9sxKIn9cpdSPExBwxxSwRmWmV8320RZs33t0kkB6o3E92vYSxrDXzX
         UQXlRf66cJIG+MDmTOaLXzaJdAv9vQX2P1rXwGf3zIoJsSRBpIKOxGatlpczG6BQfo/L
         /hdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dd6OwnIvPJ5t7wHzhUq0tJHh/UGUFCt4FY2OzT6HwgU=;
        b=Zr4WLsnYtm/CbgAgRt6senUszkckHEgLaik2uCgTGLzEwobakUtaqrd/UrPJbhHj2X
         QOrDHJ1AKut7CJ6+Hsyl1+VCE8GX4ku8lw8EgwMfP5P0xqZjQUl5iRorgt6iw9rQ5wzY
         lQPJTeSX/6a6k3uTj6rGUoU9YCnnwa0HDkIWMA9RBHCXOYpIXnxOkKKBHE8mWIVXybdF
         FYEw37IaHw+alRn4/c/Bzcuf4tyZ9kE5zdIG8bgfcDXDmyCm+PfAn3ANiiOZ4IEZuq4m
         L2hnMKRSCegdx6mvWZxJG7urgVlXx15b+LiWtqAbtFK2nOALijZVnxx0L5j4fmzt7b2W
         TIpA==
X-Gm-Message-State: AOAM531X4h3fhxE6EE4DMDU6wXGmvsZMfbRtHyaFzyY+sLTPZ8qeppLP
        K0r9UsJmgxOjpa9XxdSvVuA86czscJfk144q
X-Google-Smtp-Source: ABdhPJwbtTiNqbU8dhQzMk8AREQZweUEGENSHC22bqVwl4UVGX9MP+7/7nCbQ5mwCJzTxlb7Zb0RpA==
X-Received: by 2002:a17:906:fcc4:: with SMTP id qx4mr4738623ejb.364.1632984809254;
        Wed, 29 Sep 2021 23:53:29 -0700 (PDT)
Received: from [192.168.0.111] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id c10sm929046eje.37.2021.09.29.23.53.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 23:53:28 -0700 (PDT)
Subject: Re: [RFC iproute2-next 07/11] ip: nexthop: add cache helpers
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, idosch@idosch.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210929152848.1710552-1-razor@blackwall.org>
 <20210929152848.1710552-8-razor@blackwall.org>
 <401cdb30-1448-d63c-fa1a-f29b3a14094f@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
Message-ID: <a84630b6-7776-623e-9a95-e483efec5cfa@blackwall.org>
Date:   Thu, 30 Sep 2021 09:53:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <401cdb30-1448-d63c-fa1a-f29b3a14094f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/09/2021 06:39, David Ahern wrote:
> On 9/29/21 9:28 AM, Nikolay Aleksandrov wrote:
>> @@ -372,7 +409,7 @@ static int ipnh_parse_nhmsg(FILE *fp, const struct nhmsg *nhm, int len,
>>  		if (RTA_PAYLOAD(tb[NHA_GATEWAY]) > sizeof(nhe->nh_gateway)) {
>>  			fprintf(fp, "<nexthop id %u invalid gateway length %lu>\n",
>>  				nhe->nh_id, RTA_PAYLOAD(tb[NHA_GATEWAY]));
>> -			err = EINVAL;
>> +			err = -EINVAL;
>>  			goto out_err;
>>  		}
>>  		nhe->nh_gateway_len = RTA_PAYLOAD(tb[NHA_GATEWAY]);
>> @@ -383,7 +420,7 @@ static int ipnh_parse_nhmsg(FILE *fp, const struct nhmsg *nhm, int len,
>>  	if (tb[NHA_ENCAP]) {
>>  		nhe->nh_encap = malloc(RTA_LENGTH(RTA_PAYLOAD(tb[NHA_ENCAP])));
>>  		if (!nhe->nh_encap) {
>> -			err = ENOMEM;
>> +			err = -ENOMEM;
>>  			goto out_err;
>>  		}
>>  		memcpy(nhe->nh_encap, tb[NHA_ENCAP],
>> @@ -396,13 +433,13 @@ static int ipnh_parse_nhmsg(FILE *fp, const struct nhmsg *nhm, int len,
>>  		if (!__valid_nh_group_attr(tb[NHA_GROUP])) {
>>  			fprintf(fp, "<nexthop id %u invalid nexthop group>",
>>  				nhe->nh_id);
>> -			err = EINVAL;
>> +			err = -EINVAL;
>>  			goto out_err;
>>  		}
>>  
>>  		nhe->nh_groups = malloc(RTA_PAYLOAD(tb[NHA_GROUP]));
>>  		if (!nhe->nh_groups) {
>> -			err = ENOMEM;
>> +			err = -ENOMEM;
>>  			goto out_err;
>>  		}
>>  		nhe->nh_groups_cnt = RTA_PAYLOAD(tb[NHA_GROUP]) /
> 
> those should go with previous patches.
> 

Oops, this one was a last minute change, I didn't notice I've done it in the wrong patch.
Of course I'll fix it for the non-rfc submission.

Thanks
