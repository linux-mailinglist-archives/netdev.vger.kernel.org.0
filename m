Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6A92FE0B1
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbhAUE3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732181AbhAUE2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:28:22 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A13C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:27:42 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id 9so861743oiq.3
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D2adGfz849mvioXW06Xpmmb2tX55lpZ04Va207ucW84=;
        b=ZxeVgWKZr2/IefIGMKAvXrPu3tiIGuwXpy8HxMtMBpHB2cZXf2TOgB3VPHWP0FqV1B
         Zw6tT8tAQneONe+IxhXF2N5n01Wt6ltA+0U99s2Rx+QWKZW+gefOxWl+sugCwOhNBpQV
         aCtp8MEXeeD/pq0l3YI/nqhbLDFLw6jdhcc2YvLD8mn9w0+1Q0ruewf/2hcFnKpIQbQf
         9o9MVGs9iI0UPCRPmnwubIcEhMddT2UAo4soMt2Esrg/D3S9JGZXinGtRCNoFmGJT6a0
         x4ybQrK7MHBKg2AS9s/Ulp+x+2h8p+v5bBsRgRTAKi0U321A5EN1QbVwy+crWcbCGEFn
         00Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D2adGfz849mvioXW06Xpmmb2tX55lpZ04Va207ucW84=;
        b=AAhltr4e6KMjR9OVmoXao5VuUbPIdFqtKbRroEI1JheUiW+9HxMw0LXOye5xEGixtk
         moZnGSQQlsRGExnRYUnR0xmdfWB7rpAq6eSH8qLORhmUvucLA/jEsRKo+yfSyR/grfUj
         kPWVp4+IJYQWCdt05O7oFD/hGrDdRSTs1SAcXznN1yLZM12M2pq1Vc5cwDDtrd4/myQV
         s5K2otS3WSzguhOFUZ5jDVsFkWk1l64OmxdAmoMW/ob97r2SsKdh6cU5Zl4kEO8begxM
         48vnI33F8sqlE8gOTZREn+M7n/be8NSVW7zq5LpzBQKOfyt+S399LP85r16+WSqg9SMi
         Ohsw==
X-Gm-Message-State: AOAM533MyPv8K+Kg1OYaY1ibAUkj2j6de3rrGptEPYQ/hdxNwD1d5PLi
        D70HG/fprhNf3LRQE1C+D6I=
X-Google-Smtp-Source: ABdhPJy+FSy5X0tPpgdv0kkdmltLmVy2yYYsZ+b5X2uYJGxUdR6kvKZFkmba+1DrzX0pa3C6pZzCFw==
X-Received: by 2002:a05:6808:b26:: with SMTP id t6mr5042992oij.169.1611203261675;
        Wed, 20 Jan 2021 20:27:41 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id i197sm859722oib.35.2021.01.20.20.27.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 20:27:41 -0800 (PST)
Subject: Re: [PATCH net-next v2 2/3] nexthop: Use a dedicated policy for
 nh_valid_dump_req()
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611156111.git.petrm@nvidia.com>
 <6d799e1d8d5c4b3e079554b42912842887335092.1611156111.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fa4f9781-9989-db11-41af-79eb2d94e7ba@gmail.com>
Date:   Wed, 20 Jan 2021 21:27:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <6d799e1d8d5c4b3e079554b42912842887335092.1611156111.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/21 8:44 AM, Petr Machata wrote:
> This function uses the global nexthop policy, but only accepts four
> particular attributes. Create a new policy that only includes the four
> supported attributes, and use it. Convert the loop to a series of ifs.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     - Do not specify size of the policy array. Use ARRAY_SIZE instead
>       of NHA_MAX
>     - Convert manual setting of true to nla_get_flag().
> 
>  net/ipv4/nexthop.c | 60 +++++++++++++++++++++-------------------------
>  1 file changed, 27 insertions(+), 33 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


