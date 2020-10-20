Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3D12941F2
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437318AbgJTSMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437264AbgJTSMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 14:12:36 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1151FC0613CE;
        Tue, 20 Oct 2020 11:12:36 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q25so4941592ioh.4;
        Tue, 20 Oct 2020 11:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a+C5d0bGIHX85gkrqIkUaQ67ByrZKbwENJd7OmVP9u4=;
        b=pwBydvjVaw/MU2TU/vagch1+6O0UOKpE6fSCe0pYh7m0Wc4KZAHqW9A58lxLu9FMGm
         IX6J6FhZoubkkymb7JU5+7H75OEXxN8RojqZ/hQR1GKrdFkEscNbXbSjP0ffE39UC1mj
         8ZK7d99iTGTTAjV5IMq50Fo8Uh4ZTp4GGFFw5lkE2tTSMNvn0sZ9m/p0XhhnH3H/tNIh
         GFnRL0f0vqBfCbFNPCSQjnh64Tl4w7gkXDfTJtnGBLdAret71Ox2fAFgJe2iG6+zgjiL
         P8jNyg6/k2/jqfKRkdDOiCtG5WOtInJEPKGQWfN5IFSGjk3XrcYELvG69XFP6i2MREwI
         H9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a+C5d0bGIHX85gkrqIkUaQ67ByrZKbwENJd7OmVP9u4=;
        b=rM+S/eg6GEtuwqMAnw15uWpJTc4V9QP2hdY74GzwbW6AkcRwMehTYB0TyA0G8Ttt9K
         /jfhiiUbdEQ8e/Jih5KSkqovolMmqT+rk8Gye4CwQgcIQF8T6PO72V2pFF/PisMSi4ZK
         tXXTtrRfhcj4LeMTCIgxTd1Kg22epVmh477QGedf3j2Ayu27LZe0QpRAItKgrvnfhdgQ
         NFSolS1guTrWkzy1UtQkFI20c/meiJoKxZDZHdId/vqqP/VboEmTFkD61z0WPmG6Kg7r
         n0gTkgZWIccbBTBDS3yTL1dLiH1IxjJiGHnUVvX0z6ut4oqPyLOx9BwWHc04xPjjbsqZ
         pX9A==
X-Gm-Message-State: AOAM532tfPOWGnnizLpa4q03jNN0g5pnk3/w4/sMwMtzMXBrklNLQO1n
        buOREXico7uTqm9cgTUiZmPc47RwojU=
X-Google-Smtp-Source: ABdhPJysM9KYgl9mt0bZ8vQWLEzJKR2glZCaLKFo5MQJfOFf8yDZz98d+EWtjdNkUCFy3kF8C1hHsw==
X-Received: by 2002:a6b:f30a:: with SMTP id m10mr3084969ioh.164.1603217555238;
        Tue, 20 Oct 2020 11:12:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:2cd9:64d4:cacf:1e54])
        by smtp.googlemail.com with ESMTPSA id c2sm2251853iot.52.2020.10.20.11.12.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 11:12:34 -0700 (PDT)
Subject: Re: [PATCH bpf v2 1/3] bpf_redirect_neigh: Support supplying the
 nexthop as a helper parameter
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
 <160319106221.15822.2629789706666194966.stgit@toke.dk>
 <20201020093003.6e1c7fdb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5bee9b34-e7ab-28ef-13a7-ef64a7f3b67e@gmail.com>
Date:   Tue, 20 Oct 2020 12:12:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201020093003.6e1c7fdb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/20 10:30 AM, Jakub Kicinski wrote:
> On Tue, 20 Oct 2020 12:51:02 +0200 Toke Høiland-Jørgensen wrote:
>> diff --git a/include/linux/filter.h b/include/linux/filter.h
>> index 20fc24c9779a..ba9de7188cd0 100644
>> --- a/include/linux/filter.h
>> +++ b/include/linux/filter.h
>> @@ -607,12 +607,21 @@ struct bpf_skb_data_end {
>>  	void *data_end;
>>  };
>>  
>> +struct bpf_nh_params {
>> +	u8 nh_family;
>> +	union {
>> +		__u32 ipv4_nh;
>> +		struct in6_addr ipv6_nh;
>> +	};
>> +};
> 
>> @@ -4906,6 +4910,18 @@ struct bpf_fib_lookup {
>>  	__u8	dmac[6];     /* ETH_ALEN */
>>  };
>>  
>> +struct bpf_redir_neigh {
>> +	/* network family for lookup (AF_INET, AF_INET6) */
>> +	__u8 nh_family;
>> +	 /* avoid hole in struct - must be set to 0 */
>> +	__u8 unused[3];
>> +	/* network address of nexthop; skips fib lookup to find gateway */
>> +	union {
>> +		__be32		ipv4_nh;
>> +		__u32		ipv6_nh[4];  /* in6_addr; network order */
>> +	};
>> +};
> 
> Isn't this backward? The hole could be named in the internal structure.
> This is a bit of a gray area, but if you name this hole in uAPI and
> programs start referring to it you will never be able to reuse it.
> So you may as well not require it to be zeroed..
> 

for uapi naming the holes, stating they are unused and requiring a 0
value allows them to be used later if an api change needs to.
