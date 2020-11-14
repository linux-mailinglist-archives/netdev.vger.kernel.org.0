Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60572B2AEF
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 04:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgKNDM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 22:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKNDM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 22:12:26 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C2EC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 19:12:25 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id g15so10254453ilc.9
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 19:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eLvSBlLzWICvYBEvB/pElX5QK0QywSviMUnW3Y+1/QM=;
        b=UL527/z6nerQVw/hT8wzlkMlw8XtG9IktBPKNQfzlyYPI3/cOE0IdXLKN5ObbwGWvX
         39M3ge+T/0n+/pg7JD/8QJfSqKX1AUvh8sZxVWM9AMzpEtVwHQBMuLSLw+A1S5R5x16R
         0V0GMlzH5UZjmUafEPiVErYnMQjpGsB3vI3IYtuCqXkZ5qk+ci4TrSweEQXfwPjzwKfk
         CveT8asWsEN/NcErySyi2pVTZrDvrnZNmnQnhAxkj76PjAg32QcsPTfl9JQHVR0gOdEt
         SQ9Hv+OEr3zr8R0EWLuj6UD2yPip2Gsm4eg1Hh3LqBalX6In1J7Pk/SK2QLt0SodRDNC
         am+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eLvSBlLzWICvYBEvB/pElX5QK0QywSviMUnW3Y+1/QM=;
        b=EwUcilVI5ViHdsyaJ4Qe1Dqra5UAQR2/vW6tTVo/1K/a9BG14r5w8YbnXWkg6x00Xj
         dvteI2Czp2H5WKazqoGyKami3WXjEzYneZcO4K0onMTkzrsAg9WmvCQ3i8yGPcCOsEio
         QMhbUtv8W/czMyjIuRGoQ3HKjU628oQcN8jWWeiillBL0N0XHOlN+y49nSlIQuXZWaAs
         K9zP0PKqMH9Ica9hLj9Tjl5lnJGQSDYs2zEv+4JhAjERnprfIr9Rm41pMbLAAV99IX4B
         rZxWD8q+fXaS1K5wbD26DvI3Nydtm3k1d+iz8xELD+0ZiArcwG/Yu3uNcEzOPjrUd1us
         amXg==
X-Gm-Message-State: AOAM530adonIaIKfi6yim1hHavUMur2kqrpkaCkfHjDDOqDKPwAiFwi4
        vYrdVtvwBXnDLeptTWSsm9o=
X-Google-Smtp-Source: ABdhPJw4AiG/GModYqXHZ5n2vI+5rRZnw1qo/DPS1uVmvbOf0edTLmByOlqeQ0qjIxO29MuOLvttDQ==
X-Received: by 2002:a05:6e02:1062:: with SMTP id q2mr2177170ilj.223.1605323544716;
        Fri, 13 Nov 2020 19:12:24 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:99e7:10e8:ee93:9a3d])
        by smtp.googlemail.com with ESMTPSA id b191sm5287302iof.29.2020.11.13.19.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 19:12:24 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2] tc flower: use right ethertype in
 icmp/arp parsing
To:     Zahari Doychev <zahari.doychev@linux.com>, netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jhs@mojatatu.com, jianbol@mellanox.com
References: <20201110075355.52075-1-zahari.doychev@linux.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c51abdae-6596-54ec-2b96-9b010c27cdb1@gmail.com>
Date:   Fri, 13 Nov 2020 20:12:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201110075355.52075-1-zahari.doychev@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/20 12:53 AM, Zahari Doychev wrote:
> Currently the icmp and arp parsing functions are called with incorrect
> ethtype in case of vlan or cvlan filter options. In this case either
> cvlan_ethtype or vlan_ethtype has to be used. The ethtype is now updated
> each time a vlan ethtype is matched during parsing.
> 
> Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
> ---
>  tc/f_flower.c | 52 +++++++++++++++++++++++----------------------------
>  1 file changed, 23 insertions(+), 29 deletions(-)
> 

Thanks, looks much better.

applied to iproute2-next.

