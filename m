Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8609D3707A5
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 17:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhEAPPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 11:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhEAPPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 11:15:01 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EFCC06174A
        for <netdev@vger.kernel.org>; Sat,  1 May 2021 08:14:10 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id d25so1147222oij.5
        for <netdev@vger.kernel.org>; Sat, 01 May 2021 08:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kp7nWn5Dxctnsf0KQuBlxqeSl/DC/mqgRcuLP/PyRb0=;
        b=uQVA8B8qpJZl5oC3BUNti5uMJ//S1rA9YV4LSfNLshK69HpdcHhmE0x+fhI28h0MRh
         E71MJEZUhAXCdiEI9b/NkwYvmSTLzcliFUb2iQ0EkvcbDC3gksl99IelkUZA/CzzirDs
         uDcivaETLLJ9YlK+qm1PRmFPDmLvbG1oZnKT2qiWyn8lU7wB9PUlU5zWqWi4yaTfq5yY
         V9X/eRqulkRlrFZt5w8TuY5+sgID9I6N97h9fGRxImBidOsVZBwlpJv284liW5qwfwYB
         duPKA4PG8XCfjq7nynXBdBolj2DcPLMWZfVd76bFM+TvpqaoDOkjeIjG8wda8E/eRHCP
         nvZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kp7nWn5Dxctnsf0KQuBlxqeSl/DC/mqgRcuLP/PyRb0=;
        b=KlIWrGMUyvCaz+zM2kUheHHLYFnpxgU/LKlJ+jB9UDGmcQCyqhmuq+Oy1Oh01ktQ2I
         KoEsogmT6yIJWa2p+IQslYcUHQWg5LtuNkb+CPwljXLZ+eQltHuMttvdTwyakUerChW4
         pdubemwhfpTfztBNZ3gGK0p7mvvm7OLj4D9rxyXwE7XAiFfPRghjRjiOwKK07U/jfvcr
         cj/rSWngbARLZay5ZRk+FN61wbmJhmtCZ36+kib3bGwqx8mUPMDtNDNaoMUk2kH/MGc6
         V8acYxdmmlovrm7aMJnSlWjuEbxZTbGWWJxMSfdyuUJcVxeDG/mYWUeFuW0tqdWSagzF
         L9Aw==
X-Gm-Message-State: AOAM5300iNzpHB0JV7ulbqVAdf4F6gdCmN4In4dvXlgFNmbuKHsWY33y
        lp+fV2iWjofxQbp15t1Qln0=
X-Google-Smtp-Source: ABdhPJxmrKpXmgD4Zi0bJT/clsK3ozoxMgWO1uK2p40jNSu/VKTJfEmsellaG4aiyh8OD3MHZGRloQ==
X-Received: by 2002:aca:1e07:: with SMTP id m7mr15338476oic.107.1619882050445;
        Sat, 01 May 2021 08:14:10 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id k7sm1042680ood.36.2021.05.01.08.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 May 2021 08:14:09 -0700 (PDT)
Subject: Re: [iproute2-next] seg6: add counters support for SRv6 Behaviors
To:     Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
References: <20210427155543.32268-1-paolo.lungaroni@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <44091450-1b0d-664f-07e6-7eff48ca92c7@gmail.com>
Date:   Sat, 1 May 2021 09:14:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210427155543.32268-1-paolo.lungaroni@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/21 9:55 AM, Paolo Lungaroni wrote:
> @@ -932,6 +997,11 @@ static int parse_encap_seg6local(struct rtattr *rta, size_t len, int *argcp,
>  			if (!oif)
>  				exit(nodev(*argv));
>  			ret = rta_addattr32(rta, len, SEG6_LOCAL_OIF, oif);
> +		} else if (strcmp(*argv, "count") == 0) {
> +			if (counters_ok++)
> +				duparg2("count", *argv);
> +			ret = seg6local_fill_counters(rta, len,
> +						      SEG6_LOCAL_COUNTERS);
>  		} else if (strcmp(*argv, "srh") == 0) {
>  			NEXT_ARG();
>  			if (srh_ok++)
> 

change looks fine. Can you send a v2 with the help and route.8 man page
updates? Thanks,
