Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89172A8925
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730891AbfIDPCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:02:37 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43832 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729773AbfIDPCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 11:02:37 -0400
Received: by mail-qk1-f196.google.com with SMTP id m2so19842100qkd.10
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 08:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aWIQlr0z1EDLkRUzCFDPWvY7EfuWtjpEBMTiuGObd7c=;
        b=G2qOnRt3prG5xVqjTPsXF4ifGe3Zl49GtEI4HKzfS7wFQz4WPPvlMP69Fj8X40umej
         IIzFDFg2Yvve7R/MeLizSdI6gpYL69QzXDU7RB59T6gdwnlFghWUa/9ur3weNEFx2PEV
         mae3gGmfOKBiLs30joX9S3fkz6bfmtlUVOM5auA/6BCWxz1xSBLI/CbP1DAbDaNj6bb4
         gWmn2a8MvsJk07oN7gcRAGUuPLw5g6ejUUpNIV0YadRw43u5DKQEIINMJvApNctBB/Gj
         HR+NIiqOPXNtQIUOuy6UqMHU8uuvJfGiUXa1HFjOSJyXkZKGhdyb1IiaolLIQppMmy5e
         8Fyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aWIQlr0z1EDLkRUzCFDPWvY7EfuWtjpEBMTiuGObd7c=;
        b=NB/gABbRAhQYvG6qVDNQuPRsN/5yGzhtpDphIz3lOfB+aUsSmofDiD5h+mDiCj/2pZ
         jJzeIXXeCmhr+whyZIzZMmBadiyIeRLF3rH7fO96OSCfhly4OPQsUDnFRxK0hb+ExBbr
         LWOw14xoD7Nd/GcegGXJ9WJfRU3Fr5I8SDnDci9/LByE/ipyQSkZrTVNsXyWhV5k1Hc3
         +d7I1bUXXnRx7V7bSqtaGyDOivPRPLT5vlzFWozpihHlTie6/AO6FbPtq+3boUm+GEOQ
         Tr/24OWEiLDCdm6qJhXZwJYHygk+CGZw1IEUq99qzoLKRE3tVXBIiQzWoSUL94ea4bZd
         UDmA==
X-Gm-Message-State: APjAAAVNePf6O5LkUmy8euwGNSOhv9fVgOkOk5lHnrCAOZArnWmPJFIy
        LoHyE2sDSHvcSFQ1m7eMpZbvFv2hdVU=
X-Google-Smtp-Source: APXvYqxTdQxszs/DrPW6iGph3N4DiPQOgqjf4AiwdpYMTpUdqweW/KJZJCRrBqh2XcpjBugYo6Z1Eg==
X-Received: by 2002:a37:9544:: with SMTP id x65mr3158097qkd.100.1567609356858;
        Wed, 04 Sep 2019 08:02:36 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:fd80:3904:3263:f338:4c8b])
        by smtp.googlemail.com with ESMTPSA id 10sm6497150qtw.64.2019.09.04.08.02.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 08:02:35 -0700 (PDT)
Subject: Re: [PATCH v3 net] net: Properly update v4 routes with v6 nexthop
To:     Donald Sharp <sharpd@cumulusnetworks.com>, netdev@vger.kernel.org,
        dsahern@kernel.org, sworley@cumulusnetworks.com
References: <20190904141158.17021-1-sharpd@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <239e0cb1-241b-cc5e-66e6-d707d2edcc21@gmail.com>
Date:   Wed, 4 Sep 2019 09:02:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904141158.17021-1-sharpd@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/19 8:11 AM, Donald Sharp wrote:
> When creating a v4 route that uses a v6 nexthop from a nexthop group.
> Allow the kernel to properly send the nexthop as v6 via the RTA_VIA
> attribute.
> 

...

> 
> Fixes: dcb1ecb50edf (“ipv4: Prepare for fib6_nh from a nexthop object”)
> Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
> ---
>  include/net/ip_fib.h     |  4 ++--
>  include/net/nexthop.h    |  5 +++--
>  net/ipv4/fib_semantics.c | 15 ++++++++-------
>  net/ipv6/route.c         | 11 ++++++-----
>  4 files changed, 19 insertions(+), 16 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


