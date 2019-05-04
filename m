Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D5913AD4
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 17:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfEDPIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 11:08:17 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:52024 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfEDPIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 11:08:16 -0400
Received: by mail-it1-f195.google.com with SMTP id s3so1703311itk.1
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 08:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EwNSjS073l88e6Z/NPZbYI1Xh1+xWKsAUJWTjKE8ubQ=;
        b=WoBvNTNbBOMfQ0ihpdqeWPUJZKnm6ka523epd3N/LKqdHzxeaEMGGKRiUNCPiDPcyq
         q77NzvgfHJCGSTWpFqfHnNKYseub90IAQ9C2i47o+pAnuDh+0u7VDvPoBB/hgvB8TyI3
         I77ed9zncdyiNwHVc6quYuuP1XeQttbhom/qi706vV1Jm7kl37+//28I2PEJT0FdenLr
         enYAkwldG4YgRRDGUAj8N+Iq78/UUHQd5x/nGAWIdHhMzxBCIvLHYSSaZGpbOrJOMZzU
         giwmnGwLh0iW6W1nWLCW6u5bwUbQd3n0klimj4SkXfQvZSgMM5KMlM2kYzkqcmt+kNDL
         5ngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EwNSjS073l88e6Z/NPZbYI1Xh1+xWKsAUJWTjKE8ubQ=;
        b=AxbeJRBqU2LUBCzvIv7etjV4IKKcuP8oJPur5o7v/bZWkaEITcpCcqVpuhQL2qvU+a
         gacsN+FPJN5MyVQiq30I1ihQJOtQKrO4URrna2VbBN/XlpxL13uO0SLvh3d7PI6zp5mc
         1hIZ85DMwD7tGh6C3c9/PvMUzK3JIjb5rf4uHwSkV0+MDD5hh8gxsqjN5LUWWVfEI7CA
         55NIG0mPJfZ6DtIvGIrS+KxS1GKW8Rbx0/l9EoJ/3uKVHgdbt96j6EPLkVyL80R3hycc
         BHHSQUqOv8YOfl9efB8gzCR764JtURQ3M+BDsdS5vVwi17NoFLy0a3YsqXgSLtW4ulxs
         PzNw==
X-Gm-Message-State: APjAAAWgDLyZqsU0hGY+Og2DASn8g8Blj/dy5u8qSmy4P/Pol297rRbF
        41RvHcdrUgUznOFPh3uL6hXWwYdK
X-Google-Smtp-Source: APXvYqygPoSahcpIghlhYYUGuRsjMmLtnrUay4kQ6UdRu8yRkh0+VIhAcy4jUf1VovonOdAKfiiRwA==
X-Received: by 2002:a05:660c:1cd:: with SMTP id s13mr12766017itk.116.1556982495871;
        Sat, 04 May 2019 08:08:15 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:ad89:69d7:57b3:6a28? ([2601:282:800:fd80:ad89:69d7:57b3:6a28])
        by smtp.googlemail.com with ESMTPSA id z21sm887811ioz.16.2019.05.04.08.08.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 08:08:14 -0700 (PDT)
Subject: Re: [PATCH iproute2 v3] ipnetns: use-after-free problem in
 get_netnsid_from_name func
To:     Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        stephen@networkplumber.org, liuhangbin@gmail.com,
        kuznet@ms2.inr.ac.ru
Cc:     nicolas.dichtel@6wind.com, phil@nwl.cc,
        "wangxiaogang (F)" <wangxiaogang3@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>,
        "Zhoukang (A)" <zhoukang7@huawei.com>, kouhuiying@huawei.com,
        netdev@vger.kernel.org
References: <f6c76a60-d5c4-700f-2fbf-912fc1545a31@huawei.com>
 <815afacc-4cd2-61b4-2181-aabce6582309@huawei.com>
 <1fca256d-fbce-4da9-471f-14573be4ea21@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <afffe3c9-5f08-3cc5-f356-dbb41e94ab75@gmail.com>
Date:   Sat, 4 May 2019 09:08:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1fca256d-fbce-4da9-471f-14573be4ea21@huawei.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/19 1:26 AM, Zhiqiang Liu wrote:
>
> diff --git a/ip/ipnetns.c b/ip/ipnetns.c
> index 430d884..d72be95 100644
> --- a/ip/ipnetns.c
> +++ b/ip/ipnetns.c
> @@ -107,7 +107,7 @@ int get_netnsid_from_name(const char *name)
>  	struct nlmsghdr *answer;
>  	struct rtattr *tb[NETNSA_MAX + 1];
>  	struct rtgenmsg *rthdr;
> -	int len, fd;
> +	int len, fd, ret = -1;
> 
>  	netns_nsid_socket_init();
> 
> @@ -134,8 +134,9 @@ int get_netnsid_from_name(const char *name)
>  	parse_rtattr(tb, NETNSA_MAX, NETNS_RTA(rthdr), len);
> 
>  	if (tb[NETNSA_NSID]) {
> +		ret = rta_getattr_u32(tb[NETNSA_NSID]);
>  		free(answer);
> -		return rta_getattr_u32(tb[NETNSA_NSID]);
> +		return ret;

set ret here, drop the free, let it proceed down to the existing free
and return but now using ret. That way there is 1 exit path and handles
the cleanup.

>  	}
> 
>  err_out:
> 

