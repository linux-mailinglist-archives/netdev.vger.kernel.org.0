Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A503BC38AF
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 17:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389504AbfJAPOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 11:14:32 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38646 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389129AbfJAPOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 11:14:31 -0400
Received: by mail-pg1-f194.google.com with SMTP id x10so9871519pgi.5
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 08:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UnPv2O7N4EaUej8rJCHH2nt2PZ/bYVBuABh5fmVMU04=;
        b=MW1g3XvL9DZjCDnwlEF/udJ173jZDNtutS1Yd/nba8+kZ6Ekfhsh05FhBcP7nDawE4
         e+FFQnZsjBA7wjYj4xamPlFPSZROnQw9x3Rs+wZPWv6XNrpygoMzq1ycFDIlEuJsX9d3
         2YwelLETy1LhmA5hT9BwKWaEg0UlrkrSHL7AVmoLIpD2x1y++F4bC5nOQlq1j/CHzbkg
         ywMSpg8oweooX1LYLJXf94n9iUfzmn26UlzssYgoHO+oEt/dgoNpnjamCrQk9uYfWawB
         PYJPEl6/M9dQlq/j7nUniEz8VYV8tyAI6zGkGDS8pCtWaT9Z9FiF7Uy5NaO6FrnM/IFn
         w9rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UnPv2O7N4EaUej8rJCHH2nt2PZ/bYVBuABh5fmVMU04=;
        b=DwueQG6Dy/wh/lATRYfH6Y/rpZ6ZXnpRtlWcpedkfhI2aO5/E9JciAjS1p3H8cqXB1
         rot+Gr9GFf3kqK2GHgyHBKIzx6odWzNBHoZ2SThHkMVOpzuc4Mkg7idNK60EcvwEnKDS
         u1pm6H3btSOwjtn00nBB/0MYfBjadD/XjkJeny5H/+dQLANlRg5VXJX4tcd+WTipYiXq
         OT8rBzXCUPE6ff7zVkWdrNuq08oPYqAvNAa6rpMkfRyok70mrnk4rShVVlYzNSheHsXl
         5OwZldjNAE+oVtq+/S2SycCALmUTSCAUIkIrX/xOY0PYJNNlAFsMztqYR3GqEkVhGeWB
         APig==
X-Gm-Message-State: APjAAAUi0yTSDw2DFD5aFShdPv2VSHCyU6la8/hGNLtUmcJvny2IYp1m
        xF+1hxw+VdXA0zsjumHP8Hg=
X-Google-Smtp-Source: APXvYqyrsYCAGJ+xm6idaVbuZ53lqIhwAQaG5v9lC+VPna7XxQKg76kQjDmNWvPBLnaSPuP9oPYU2A==
X-Received: by 2002:a62:64ca:: with SMTP id y193mr28348411pfb.164.1569942871201;
        Tue, 01 Oct 2019 08:14:31 -0700 (PDT)
Received: from [172.27.227.153] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id z22sm17522516pgf.10.2019.10.01.08.14.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 08:14:30 -0700 (PDT)
Subject: Re: [PATCH iproute2(-next) v2 1/1] ip: fix ip route show json output
 for multipath nexthops
To:     Julien Fortin <julien@cumulusnetworks.com>, netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com
References: <20190926152934.9121-1-julien@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ba5f6b14-1740-b9ba-c100-5272765fbef4@gmail.com>
Date:   Tue, 1 Oct 2019 09:14:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190926152934.9121-1-julien@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/26/19 9:29 AM, Julien Fortin wrote:
> From: Julien Fortin <julien@cumulusnetworks.com>
> 
> print_rta_multipath doesn't support JSON output:
> 
> {
>     "dst":"27.0.0.13",
>     "protocol":"bgp",
>     "metric":20,
>     "flags":[],
>     "gateway":"169.254.0.1"dev uplink-1 weight 1 ,
>     "flags":["onlink"],
>     "gateway":"169.254.0.1"dev uplink-2 weight 1 ,
>     "flags":["onlink"]
> },
> 
> since RTA_MULTIPATH has nested objects we should print them
> in a json array.
> 
> With the path we have the following output:
> 
> {
>     "flags": [],
>     "dst": "36.0.0.13",
>     "protocol": "bgp",
>     "metric": 20,
>     "nexthops": [
>         {
>             "weight": 1,
>             "flags": [
>                 "onlink"
>             ],
>             "gateway": "169.254.0.1",
>             "dev": "uplink-1"
>         },
>         {
>             "weight": 1,
>             "flags": [
>                 "onlink"
>             ],
>             "gateway": "169.254.0.1",
>             "dev": "uplink-2"
>         }
>     ]
> }
> 
> Fixes: 663c3cb23103f4 ("iproute: implement JSON and color output")
> 
> Signed-off-by: Julien Fortin <julien@cumulusnetworks.com>
> ---
>  ip/iproute.c | 46 ++++++++++++++++++++++++++++------------------
>  1 file changed, 28 insertions(+), 18 deletions(-)
> 

applied to iproute2-next. Thanks

Stephen: I see only 1 place (mdb) that prints devices with color, so
that can be done across all of the commands by a follow up.

