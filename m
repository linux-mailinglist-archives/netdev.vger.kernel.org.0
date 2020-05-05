Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5D11C5D34
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgEEQO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728807AbgEEQO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:14:28 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D75C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 09:14:28 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 23so2901850qkf.0
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 09:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7jayfKDonoj89kH0I50wMpwHcwY+D02wuaSYk5lnZf8=;
        b=XflsIoEx5LvUx5SmzqnNbCBlWKj4l4qJ2Vr8zezS5xJz6Bbzx3o+we+AZjRh2xJEbs
         dFcMN87lbZjBZiHsZ8pZoPYNdcEhxE7chrtECqr2CMbKdO/1eYgNqmOvahNUua3zKrGh
         f3UVN+WUB+fAOAC8TiZgjmvlArP8jxkkMu9YvBpGcFTVNJ5LxwoA2Au3QLQ+14bDu3/H
         yb+Q7qqfRynO4j7U/VmkXuyF7j0cTJICWOIaHU4WSo7GE7lzY60V/4Adv1Qmu6cH+fXU
         cpHjS7lPeW4JjOy9qJx+UQw8AF6KY+iu3UEwgaNKgVEuYSl6gAkuepyV7kS/+yEndjSb
         KnZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7jayfKDonoj89kH0I50wMpwHcwY+D02wuaSYk5lnZf8=;
        b=EIUs603GMOA5HqWjeE31EqIb7TuuBJw/ErnC0qjFFtiOp5OgU08Q71T5UVoL4eQULD
         yzYI06sFYj8mZyp6JaTvqgWI3ebCWNfP4S5sK/vO3/HDIehgwweAk0ukxnPKmCimcb9B
         T9Y7g04SuE15TRuTd4XkSGf74LMB+K5/8hF9niW2Zur5WAj+kvDpMorCXYYYJBnf4t2k
         NtW7AM5tIIV7nENC5KU++3qi7Kzl/tPCNlW900Jk/7hj5JY2MLp2pR30LO4DWzYV9Ul6
         1IL9rDDGH4+QSV9HbVLTuVuMtdIeDzl/48WaD1fj8g/S7TbtCTpA/q0cKwyyk86NJh5y
         Hz7A==
X-Gm-Message-State: AGi0PubrjQmRW295SOYB6u2FUWTUcPH5SDxLWxdhNtQYKDkBe3dpv8tW
        mAdP4u/g6kIyJFwZFTGroVxY9cFP
X-Google-Smtp-Source: APiQypL3F07RBVAIJjwXFNhAOA7Gfk5oOxOpna6ang0K1fT6vX0XIVFNLDBTNTzg2rDUjya1WPYQTA==
X-Received: by 2002:a37:47d4:: with SMTP id u203mr4149294qka.424.1588695267791;
        Tue, 05 May 2020 09:14:27 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c19:a884:3b89:d8b6? ([2601:282:803:7700:c19:a884:3b89:d8b6])
        by smtp.googlemail.com with ESMTPSA id l8sm2233836qtl.86.2020.05.05.09.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 09:14:26 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3] devlink: support kernel-side snapshot id
 allocation
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com
References: <20200430175759.1301789-1-kuba@kernel.org>
 <20200430175759.1301789-5-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <af7fae65-1187-65c5-9c40-0b0703cf4053@gmail.com>
Date:   Tue, 5 May 2020 10:14:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430175759.1301789-5-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/20 11:57 AM, Jakub Kicinski wrote:
> Make ID argument optional and read the snapshot info
> that kernel sends us.
> 
> $ devlink region new netdevsim/netdevsim1/dummy
> netdevsim/netdevsim1/dummy: snapshot 0
> $ devlink -jp region new netdevsim/netdevsim1/dummy
> {
>     "regions": {
>         "netdevsim/netdevsim1/dummy": {
>             "snapshot": [ 1 ]
>         }
>     }
> }
> $ devlink region show netdevsim/netdevsim1/dummy
> netdevsim/netdevsim1/dummy: size 32768 snapshot [0 1]
> 
> v3: back to v1..
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  devlink/devlink.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)

this does not apply to current iproute2-next

