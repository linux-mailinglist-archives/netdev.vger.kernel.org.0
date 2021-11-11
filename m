Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33ADF44DBFB
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 20:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhKKTQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 14:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhKKTQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 14:16:41 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BD1C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 11:13:52 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id r26so13375782oiw.5
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 11:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=E2Plb2TAKsKgQhUrexKyvWoKzIcxCf4mQIZrnYwk42o=;
        b=qQbtUfb0aZnVGUEqoIQPoxZKuP0AnIbF9IT7P+Q8Q1J/HsoArvQWYGG5f3YaWUxg18
         5y0BWmi24YTMdWDryS/osiKfjX+rTR634HgZS+7nWpQd9/BOhJYDzHVERLga1ENCe+Og
         JW7snVT2JQfv1MQqxb7IiDuyUshrFVHbSuSq8RU9dsCCtzUIWi3gLmsnvbdPfCEqP4l6
         3YmJg83ogGW88cqRxYrQh5hxHEbvk8LLRAxf5W4H1TVnGFBcBiScP2HRYnwpTPkKMJ3c
         6Wjf6SIAiF/5aWkfBkvgsME8QfzpILLuGB7aVRvn7xaVaD+Ic28ysaMUlVl6z1/WqaJL
         o2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E2Plb2TAKsKgQhUrexKyvWoKzIcxCf4mQIZrnYwk42o=;
        b=TLLK0ug39dnTLg2TAPMzzwITYduG5jzTn8RoabXh+SOaIGMLelsCWOE1et9T24LMAO
         LnxhxTSmiEH27y5mOjQfjIsEnieIaz702/XAKW7vQ/58PXxMxjTHA+bbsCEoZdmkIMGn
         FKEiAYm3ogGkZdUTilbJG5CjCuou1Gdk8kNgOx8DSLpDIQhYgZNqdCE7PgPn/kHpDB2b
         unBqCfw+aeuU40ndyCDrknmEmZAY/Y1hzvBNfciAsYNYp4+/ofkzKJrwlfOrkWlskRKO
         j4cf0zse8pvmpcslgkaVPhxA6bLHt2MY1IulrK5mtzjQJXjMTzeDgqwqY9f0OfMXZLyT
         iD+w==
X-Gm-Message-State: AOAM531EXL59PS6z2a+36Boqbak86M+Em4/Jj+x3MZG7cHyO49anxD+M
        3y9LoNlkfj10w6gHFdWcbgM=
X-Google-Smtp-Source: ABdhPJzGOdKJ9DcdYStbM2ORHRO6fnSB97Nfp3zcFiKWtWPGv5PVQSWXrEyVuZakGxfM0VAebcEafg==
X-Received: by 2002:a05:6808:1241:: with SMTP id o1mr21724217oiv.55.1636658031610;
        Thu, 11 Nov 2021 11:13:51 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id x9sm310775ota.76.2021.11.11.11.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 11:13:51 -0800 (PST)
Message-ID: <1f4b9028-8dec-0b14-105a-3425898798c9@gmail.com>
Date:   Thu, 11 Nov 2021 12:13:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [RFC PATCH net-next] rtnetlink: add RTNH_F_REJECT_MASK
Content-Language: en-US
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211111160240.739294-2-alexander.mikhalitsyn@virtuozzo.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211111160240.739294-2-alexander.mikhalitsyn@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/21 9:02 AM, Alexander Mikhalitsyn wrote:
> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> index 5888492a5257..c15e591e5d25 100644
> --- a/include/uapi/linux/rtnetlink.h
> +++ b/include/uapi/linux/rtnetlink.h
> @@ -417,6 +417,9 @@ struct rtnexthop {
>  #define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | \
>  				 RTNH_F_OFFLOAD | RTNH_F_TRAP)
>  
> +/* these flags can't be set by the userspace */
> +#define RTNH_F_REJECT_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN)
> +
>  /* Macros to handle hexthops */

Userspace can not set any of the flags in RTNH_COMPARE_MASK.

