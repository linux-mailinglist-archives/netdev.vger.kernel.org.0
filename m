Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7CA25FFEF
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731035AbgIGQlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730610AbgIGQlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:41:03 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36750C061574
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 09:41:03 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t10so16475119wrv.1
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 09:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6HzmAVHlN6inWuhNR/qi7K/O/N8qBgMh/gLHImP3oLI=;
        b=Rhl6gyeocRUMRqArAntovDuFoSik3QlgtAtzFotLuXqcpSRMRkqtNsIv5Gcb9Fnw0e
         N/C/m4yQ5ky/du94q5SXnkioiql9UDJriC3NLtyFKxqOjpCS6j6HsXlJU+KoORAAK054
         5t4BCXfaclazE189avFgwVgxqYI0mokQOcsUErfyVofMTwu5z/kxWSugjP7H8Ic89MCN
         Yr2LriQYIN1sgWopbfmKeM1rhyMgk6hHOwOVM/TW8uCwOLJ9wPgV3wuJDZDTt3lcpt+n
         XqyjICws/7JQsA0tlT5s/wKwXFpkcMKeZETFvzg9ltUJnKqljlYh+9QbrE0QKEdgi9R0
         WHrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6HzmAVHlN6inWuhNR/qi7K/O/N8qBgMh/gLHImP3oLI=;
        b=l15O0bso88iwQoyusJ6oYaotyj6i3IQSJ33cr/qEWlykbZ8jTiGc7yWvIbANOz8YU0
         XYs1x3IDO06jBbT3dfjhZShQYbxqonNjAuTl/tGJq4E9zEdAxzm5hCP+Zz98k/z/FBeH
         RgdcPVJY6sCm0BATwmJBQKiWuWbI5CuSFpNt6WlJMXk+ug0HAEpFVItYBIfW7KSBuIu6
         y6vJKXDZNc+X63PdrnxjJEeveK66PQMkxNtkhUTy5kU6F2le9xBiJbDWJA1pgXiU1Csv
         +Y2lPjfTerO+xD7Pg08SaL/EHXDbY/j/Ub/uaGx3Bzg+TfRUNmDz/h+bgWzc59OvdfYs
         HaYA==
X-Gm-Message-State: AOAM530tK9WOeG56oCU1vEm8N2hxg3R9bWfAomPKLLGCya+N9GT/KERE
        GTXW9951qIPTgDdw9JP2SZdfk392VvR3vid6
X-Google-Smtp-Source: ABdhPJwwFuqsNpeKNr2Xcj0G7bwyHTIOXQSxqV9C4cdGzfqKQXz/HEY2/yNVuuYEC8tByhO7f/FTTA==
X-Received: by 2002:adf:f082:: with SMTP id n2mr16879077wro.35.1599496861873;
        Mon, 07 Sep 2020 09:41:01 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id i1sm34957035wrc.49.2020.09.07.09.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 09:41:01 -0700 (PDT)
Subject: Re: [PATCH v2 3/6] netlink/compat: Append NLMSG_DONE/extack to
 frag_list
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netdev@vger.kernel.org
References: <20200826014949.644441-1-dima@arista.com>
 <20200826014949.644441-4-dima@arista.com>
 <f579efc1375e46d9c2ff999ada1bcfed40ec2a8f.camel@sipsolutions.net>
From:   Dmitry Safonov <dima@arista.com>
Message-ID: <ff2e3bfb-f97b-6982-05d8-5448193225ab@arista.com>
Date:   Mon, 7 Sep 2020 17:41:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <f579efc1375e46d9c2ff999ada1bcfed40ec2a8f.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 8:19 AM, Johannes Berg wrote:
> On Wed, 2020-08-26 at 02:49 +0100, Dmitry Safonov wrote:
[..]
>> +	nl_dump_check_consistent(cb, nlh);
>> +	memcpy(nlmsg_data(nlh), &nlk->dump_done_errno,
>> +			sizeof(nlk->dump_done_errno));
> 
> nit: indentation here looks odd.
> 
> Other than that, looks reasonable to me.
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Thank you for the review!

-- 
          Dmitry
