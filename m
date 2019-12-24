Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34FE812A34E
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 18:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfLXRDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 12:03:03 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33811 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfLXRDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 12:03:02 -0500
Received: by mail-io1-f65.google.com with SMTP id z193so19594288iof.1
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 09:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hkb3svCMSVHPMegCNwQHTj7PNdgwoCY1f7xKFYe7H98=;
        b=ecxJUOpF/KJbq2qS/ElGhPuWv5JccFDtGX+uMZw4wrdCP2hSPVnDSCZ/Lp9LpKNnTr
         CikzbgbwhH/qxlvFzNTWF3gSmZk3BR6XPq5VNYNRL+a3feXecQgXs3LEImxkdhdWIjll
         gWmMrS2DByY1D1/4b7+Fhcc4+FDtdd+Nx9+2AEiBwSuooqtmL8HuUV2+ov8jmLn/Lr3a
         FT0QXH8AHXuF5xvfhJABU9PSO8eiBwOe9gMAReAgMJwZk7QFDO2opMtBKSp7HJEUDITv
         vkxO78TwsQfD1OPis2LFYg/3iV7I49bnBatxtzGtfQ04o0u5VfEQBDQUfRUN3Z+gv2Yn
         ylcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hkb3svCMSVHPMegCNwQHTj7PNdgwoCY1f7xKFYe7H98=;
        b=MKpIHRxBH9kLG8siv4zn3ryr19BvqOov3UN/9WKZcR75MHHNeoadEww37IJbfYHi0i
         yYxHtCPFQ6VOt4SHcEh7IHjTzZhOmUN5srKqe1ERKOo6XyH+IwEAdmv2w0SEgtLnHTNu
         PeX/8BKQ6e677po8BXdFgU0URj+pgeJMEp0ea0K5J1bHvy5He4Ms2RRKsunRqw4Gztp7
         CZEowEZWyGB03sL5d289lQTY1L8bvQMPKRownzLtUv0V5wE8ucVkNOSFfRmjP/Qe142M
         h+2AhHR+vnyTSL2woOM6UFd8W+gGm36eVGGg1w4/N7Ixfwc5Ic+Zkkmo8eoG/R7MnBWH
         TdzQ==
X-Gm-Message-State: APjAAAUoSr7+huGusLZtqC/2JuF5jxUkDeXOKvbzPwftDn4aDkDqKDFX
        lGIaF9UoBZeBdxduT9OSuTyxTVcu
X-Google-Smtp-Source: APXvYqz8H5RM9q7tAF+S2SgaoOZQf3y5Qy+wh8PM/BzY1SQmeFj2CbMU8upjjABX6LI2m+tPNsACGw==
X-Received: by 2002:a02:864b:: with SMTP id e69mr28281416jai.83.1577206982158;
        Tue, 24 Dec 2019 09:03:02 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:859d:710a:f117:8322? ([2601:284:8202:10b0:859d:710a:f117:8322])
        by smtp.googlemail.com with ESMTPSA id s88sm10335720ilk.79.2019.12.24.09.03.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2019 09:03:01 -0800 (PST)
Subject: Re: [PATCH net-next 6/9] ipv6: Handle route deletion notification
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20191223132820.888247-1-idosch@idosch.org>
 <20191223132820.888247-7-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fb38d55d-95d8-fbdd-ebc4-8b0520045bf7@gmail.com>
Date:   Tue, 24 Dec 2019 10:03:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191223132820.888247-7-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/23/19 6:28 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> For the purpose of route offload, when a single route is deleted, it is
> only of interest if it is the first route in the node or if it is
> sibling to such a route.
> 
> In the first case, distinguish between several possibilities:
> 
> 1. Route is the last route in the node. Emit a delete notification
> 
> 2. Route is followed by a non-multipath route. Emit a replace
> notification for the non-multipath route.
> 
> 3. Route is followed by a multipath route. Emit a replace notification
> for the multipath route.
> 
> In the second case, only emit a delete notification to ensure the route
> is no longer used as a valid nexthop.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/net/ip6_fib.h |  1 +
>  net/ipv6/ip6_fib.c    | 44 ++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 44 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


