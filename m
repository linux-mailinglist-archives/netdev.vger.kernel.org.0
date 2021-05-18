Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450AD386F98
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 03:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346123AbhERBuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 21:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbhERBuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 21:50:00 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD76C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:48:42 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id b25so8364186oic.0
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iGbuVr6U20bHEdsJe7EXYe6aKVNreR7ZIUg/uveItPo=;
        b=QfUfer6K1DFWFNbqhaY7gfycekp+fDGO38pxt/H5+asQ3Kt2rHaV/ND8a+VhPDpWrJ
         N0Vmdsw2IEnOYq92C9tdprdQ0ZenZz6zFtjnwfPXQpvRcAQ0NkDUZMeHBT5bsdjkRX2m
         VYLmJKgHLQRyHyiCGIPn2KRK1GusyIbI8oo3vWejuiSzcp1DmENPgf3md8mPMy5UHTsk
         XeiuDxV5EZdedIOD9QR9moLeIN6+fMoZgeSTYJgmJhQGDG5idisyHE8/efgJe4tDExvc
         22EPw5bF8yjTjs94Z05tGKmOy+Dn00TDTWevcg2lSOUTcVAAjeIfjQaZ5bxXbg9mQycb
         Ii8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iGbuVr6U20bHEdsJe7EXYe6aKVNreR7ZIUg/uveItPo=;
        b=KCRlrwBYPHLlmgU1OH/Pc0ZexHM8R6q24NGA5lGsJuxTFb8I+pIEIxx71+fC+usfDU
         g6Vp1m99xWkiavPbbmQ/DVCIrz5zCQK+VTM4hsUmEcrzdnYlSFn1/Nv0GUsFLLur4s+U
         xDczxaX3D0FShMf4tBodTOGJGP4vGqEr7V0ny8FmqoQGbj/Xu2uDIEJQ64WkgLi6Fs/F
         zaO0CtTC5QFvgocgdHh4MfWyY14yjdKPrTGkOBlNWejYETLScxzBNasvKw5B/KHkITIM
         6Ynn+bh6aRzl5u7OkdgwZVN2jLIhQLdfhzoy0qxWmv/oBOI+64DY426bOAIIKn7Ybrb1
         lOjw==
X-Gm-Message-State: AOAM5331UbmcAAsSbbgVLbfa4NRiSA/IQXv97L2hW5L22WKCMBun5Ptn
        Pcoi/nWht8kiVPXuCIr5sHkYJVxhAo7heg==
X-Google-Smtp-Source: ABdhPJy5iPkUTzBKNSP43fYIpViVM/+Pc1VQh2mQkkZK6fz73K9buL1EBey/QpR+jIIqdFhuayipvQ==
X-Received: by 2002:a05:6808:315:: with SMTP id i21mr1540454oie.119.1621302522381;
        Mon, 17 May 2021 18:48:42 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id e7sm3529618oos.15.2021.05.17.18.48.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 18:48:42 -0700 (PDT)
Subject: Re: [PATCH net-next 08/10] selftests: forwarding: Add test for custom
 multipath hash
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com
References: <20210517181526.193786-1-idosch@nvidia.com>
 <20210517181526.193786-9-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <36d2725d-2859-fd10-5e91-e903465610fb@gmail.com>
Date:   Mon, 17 May 2021 19:48:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517181526.193786-9-idosch@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/21 12:15 PM, Ido Schimmel wrote:
> Test that when the hash policy is set to custom, traffic is distributed
> only according to the outer fields set in the fib_multipath_hash_fields
> sysctl.
> 
> Each time set a different field and make sure traffic is only
> distributed when the field is changed in the packet stream.
> 
> The test only verifies the behavior with non-encapsulated IPv4 and IPv6
> packets. Subsequent patches will add tests for IPv4/IPv6 overlays on top
> of IPv4/IPv6 underlay networks.
> 
...

> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  .../net/forwarding/custom_multipath_hash.sh   | 364 ++++++++++++++++++
>  1 file changed, 364 insertions(+)
>  create mode 100755 tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
