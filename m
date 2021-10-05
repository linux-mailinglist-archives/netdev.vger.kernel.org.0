Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48D3422B7A
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbhJEOvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbhJEOvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 10:51:11 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64156C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 07:49:21 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id v10so2336806oic.12
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 07:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m4AcBIZFF8jLrkAWke5xLiuOfsbZRGFbl/bgJhpq7h4=;
        b=BgrgOh4pnQcrx1H7zfH0rkJDRB1N2o2NKpM8x0Cwk/jQtVsjVy+5C1NiJIF5Yxd06H
         f1NZ8//b5AaNCSa+RDrx2o+fPp4J+6GPYn+zWcha7C7+dXOUCIBOwn8zLgX5Ctq2T2gw
         sEFF91N4gRsC9Cfh6Lyki7YjlDaVS5bUVTESEaRtya2aIfSTcHfcFdI+hp2nb7xIE8wH
         R55STnu33sJE/UGiOSz35xHQIfGo4huYCN5bWng8E26JgOZcU9KZjdsVI+9/iUWm/qsB
         NnvzWpZJatE61YTOE0gEfVXUL2VEL4Ke9ywRbE3kpdyZaLM6CqqrXHQRSk63qS9gWRPT
         usxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m4AcBIZFF8jLrkAWke5xLiuOfsbZRGFbl/bgJhpq7h4=;
        b=zdfU24SfSe38004t1sVezX7UY3LjyQCOFHXvV7aUniAhJCqhsLSTZdqvl5Cli6LYrs
         Y0xrqwi6XejBhXIEYe2dWsum/avR0ERO+2ypNIk/SY0CqE3fVxC7BaYiG5nwHbTGhmWD
         5jqtSthUbWjZWAStgTW6ps49yg3qf94htGBxCACDA26ggvlQltAN4pkhAMX52ZHuVliV
         vMQ4E4xavgV7gyc4WWXW5vSx7Y//5tlLGhdSh894rcA/c5o29osWLE5XmDDtt2e2wma2
         8lzCdSsKEHlNxXNSdglM/Ce/N6VHK+ogvRbX6Uv/h5Bdx2vgSfOkXiSYMDavnFB560k8
         DgYA==
X-Gm-Message-State: AOAM533wzFSLDcuN5y6ym1uqf22+JSKqYyG3/1wTHGFTVNYAjJU68/w9
        0RKswQbLuzQdxomahRW+S2I=
X-Google-Smtp-Source: ABdhPJziJyzobQhoM1H7V090D4TKZs5erQwmOlrn3TUiPgeoGSsWSl8XcpBjb07a2IlV0PRL7g0nsg==
X-Received: by 2002:aca:f283:: with SMTP id q125mr2785123oih.172.1633445360575;
        Tue, 05 Oct 2021 07:49:20 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id n73sm3362901oig.20.2021.10.05.07.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 07:49:19 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 1/2] Add support for IOAM encap modes
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        stephen@networkplumber.org
References: <20211004130651.13571-1-justin.iurman@uliege.be>
 <20211004130651.13571-2-justin.iurman@uliege.be>
 <a80c8fba-bf66-93ef-c54e-6648b3522e28@gmail.com>
 <181201748.114494759.1633445114212.JavaMail.zimbra@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <86e6a547-0d9d-9720-15bc-81fb40e6cd84@gmail.com>
Date:   Tue, 5 Oct 2021 08:49:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <181201748.114494759.1633445114212.JavaMail.zimbra@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/21 8:45 AM, Justin Iurman wrote:
>>> +static const char *ioam6_mode_types[] = {
>>
>> I think you want to declare this of size IOAM6_IPTUNNEL_MODE_MAX + 1
> 
> This is automatically the case, see below explanation.
> 
>>> +	[IOAM6_IPTUNNEL_MODE_INLINE]	= "inline",
>>> +	[IOAM6_IPTUNNEL_MODE_ENCAP]	= "encap",
>>> +	[IOAM6_IPTUNNEL_MODE_AUTO]	= "auto",
>>> +};
>>> +
>>> +static const char *format_ioam6mode_type(int mode)
>>> +{
>>> +	if (mode < IOAM6_IPTUNNEL_MODE_MIN ||
>>> +	    mode > IOAM6_IPTUNNEL_MODE_MAX ||
>>> +	    !ioam6_mode_types[mode])
>>
>> otherwise this check is not sufficient.
> 
> Are you sure? I mean, both IOAM6_IPTUNNEL_MODE_MIN and IOAM6_IPTUNNEL_MODE_MAX respectively point to IOAM6_IPTUNNEL_MODE_INLINE and IOAM6_IPTUNNEL_MODE_AUTO. So, either the input mode is out of bound, or not defined in the array above (this one is not mandatory, but it ensures that the above array is updated accordingly with the uapi). So, what we have right now is:
> 
> __IOAM6_IPTUNNEL_MODE_MIN = 0
> IOAM6_IPTUNNEL_MODE_INLINE = 1
> IOAM6_IPTUNNEL_MODE_ENCAP = 2
> IOAM6_IPTUNNEL_MODE_AUTO = 3
> __IOAM6_IPTUNNEL_MODE_MAX = 4
> 
> IOAM6_IPTUNNEL_MODE_MIN = 1
> IOAM6_IPTUNNEL_MODE_MAX = 3
> 
> ioam6_mode_types = {
>   [0] (null)
>   [1] "inline"
>   [2] "encap"
>   [3] "auto"
> }
> 
> where its size is automatically/implicitly 4 (IOAM6_IPTUNNEL_MODE_MAX + 1).
> 

today yes, but tomorrow no. ie,. a new feature is added to the header
file. Header file is updated in iproute2 as part of a header file sync
but the ioam6 code is not updated to expand ioam6_mode_types. Command is
then run on a system with the new feature so

    mode > IOAM6_IPTUNNEL_MODE_MAX

will pass but then

     !ioam6_mode_types[mode])

accesses an entry beyond the size of ioam6_mode_types.
