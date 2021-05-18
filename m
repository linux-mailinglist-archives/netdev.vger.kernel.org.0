Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDC0386F85
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 03:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346092AbhERBor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 21:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238761AbhERBoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 21:44:46 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C69C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:43:28 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id n32-20020a9d1ea30000b02902a53d6ad4bdso7300193otn.3
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VFkaL0R4OaBzxpPCC2CrlyfUmpxhDWUNHm1cDh4C2k8=;
        b=DwV0jOf+vIhEnf7+ltSY8HRXMTrzEQjybLLtEJjJE95nhCYqL7GrZYGIoiuNPDcfdv
         7RS4POFgI+S3GbEY7mSDWGSmrAHPxdr5n1reQAfZG5Ub1SLZIMiY9Q85SBNek+f0ZtDm
         Wt0i08wSmqPLoP+/jma5ZSJoGnir7PCbyE/DjZauTdDRStLUEvlOEcC2gVgd8335ALK6
         ud9S5AtnxxiUAjRWyM+tQJSqqrB+qYVPfr0oTWOpL2nflWi8M8CvUyKsOZbEQ1u/vpKj
         NfREQMTScbr3RDVxpkOnfU6VAwrRWaZx7qbkz3TiyH/g2sthzEYRvQ0Mftu4zcmjnsBn
         BZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VFkaL0R4OaBzxpPCC2CrlyfUmpxhDWUNHm1cDh4C2k8=;
        b=TZLax7kg4n3Pb+30pdKqPtVeCvD+6dFfH7FERPdNqyha+9pYoZNnoVKZuAhIGRn3W3
         D+uEgE/tr61q/0t8KyOSokz/enDiezC0AcMKFnVYyKaFs+q8FEDS9OftmWRX3exS/AOd
         022+MXQqByHwmkzNMvYA1Cm/WFRJmrWG+dQqV9AEsh/txLUFf7n2N3chZRSqYP/hvak2
         87mAdMoOvMmeACHaoeX7GLbkj4ndpVrAwqI2FjQFammInt9QzofsPjHHZVwRC8i0pFS9
         vaEIiVnYZVJmMEq/4adAHI5cuCBXaRjsHbN9/9RyHkdQXjW8MAv2ZVo5BsEaZiQew6wL
         YZUw==
X-Gm-Message-State: AOAM533wpRpLtf30NOH9wVEZk/fAfEgqpUxSuE/0nkUm6DsbW+UVFDuR
        fJ/htFSBmqHM0hpKU/yes5U=
X-Google-Smtp-Source: ABdhPJy2fZef3Moe9mcuOAZCRk9lHxHSTaPE0mTHsvn6RrUxMiZYQqY1yIClP4OX5QKclsExzF9Yjw==
X-Received: by 2002:a05:6830:22cc:: with SMTP id q12mr2117658otc.145.1621302208200;
        Mon, 17 May 2021 18:43:28 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id l131sm3104855oia.0.2021.05.17.18.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 18:43:27 -0700 (PDT)
Subject: Re: [PATCH net-next 05/10] ipv6: Calculate multipath hash inside
 switch statement
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com
References: <20210517181526.193786-1-idosch@nvidia.com>
 <20210517181526.193786-6-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f30280b6-f666-ac77-6e5b-d2c99eadca00@gmail.com>
Date:   Mon, 17 May 2021 19:43:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517181526.193786-6-idosch@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/21 12:15 PM, Ido Schimmel wrote:
> A subsequent patch will add another multipath hash policy where the
> multipath hash is calculated directly by the policy specific code and
> not outside of the switch statement.
> 
> Prepare for this change by moving the multipath hash calculation inside
> the switch statement.
> 
> No functional changes intended.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv6/route.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


