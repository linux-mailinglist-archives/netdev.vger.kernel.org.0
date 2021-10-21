Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E5E436C9B
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 23:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhJUVZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 17:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhJUVZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 17:25:19 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E903C061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 14:23:03 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e12so750075wra.4
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 14:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QTzBsF0uPhtTetxf452rXfr2CifhV3tj5ZpB28I4wNY=;
        b=KgsThTaO6rk2gxEMoyosDfhlWkZ7x+S+Vl7L7+0t5gBwwzaGwscZeBrOl3hxMjhxud
         fzxOBHQpOmTnPxwwV0TUWC0jCkdQMllAOlXa4r3dnQ94yLMpfW2Alibrbf80LP/SP/47
         CT+BrDh8F46ChWA48tMZiWhZG7zLROxkWze/E/3p6rQXHe/rPT/rSoDeYX7urTxYMN0v
         tyPP50KD1MtvDLyIv1uKBk809cjWcbvai7ToUWZcZ5DPMK2l+GczLYnKT8Hg4M59a0e0
         htLB8ju2jDpFqg0OVewXqoWoxqsO7P8R0mCuna9+w6ZQSoDH09VZEhrn0/567FVZ8ZvA
         QY6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=QTzBsF0uPhtTetxf452rXfr2CifhV3tj5ZpB28I4wNY=;
        b=qKTqYcVSOQCkfK5XFBXLyEh0K8BQcIaY+GiqQL7PHJm7hQtC8WqYV/hiPSzJPKucZm
         r03CSLzTRjdogibMw2m6VhhVAb9SvSCidDlMyEHd/IAMk3CLoP8guQ3/9zzqUz6uFUzD
         gL3AbFVOpoSYvu/0bOf6waRUI1m4vSjglAesIKS6npV56eccxe5hfXnCnl+b1zM12r+Q
         wQPuxzBCD4F7fEDDtSuJ6hvj9KyhvpRzhS6JXC/D1ZPfGFR2Ni8tBH9CfQingBNmcNBw
         093TwMgMhhgpGjpJU1NOINxSzQ0qM5QSOKAjtwKNhVW2RSJHfQGlA39goaBSpm+Un6OF
         ugkA==
X-Gm-Message-State: AOAM532xeVhMJJayNilvqI1boSXGvdMDwonXGA7z6OxL3JRZs4LGlKfg
        zFMPBRMsUPFzmY2oWZyj3TCZ4A==
X-Google-Smtp-Source: ABdhPJwQa9HBJoaXcEX1jfAveedIZDO3de2BFCPCxJ+xyV/F1/cqDLVguiFKPL9R5hZsOFw8XKNU3Q==
X-Received: by 2002:a05:6000:186a:: with SMTP id d10mr10636346wri.279.1634851381963;
        Thu, 21 Oct 2021 14:23:01 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:d823:ddbd:7cb9:1a2a? ([2a01:e0a:410:bb00:d823:ddbd:7cb9:1a2a])
        by smtp.gmail.com with ESMTPSA id o16sm5921844wrn.29.2021.10.21.14.23.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 14:23:01 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH iproute2 v2] xfrm: enable to manage default policies
To:     David Ahern <dsahern@gmail.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, antony.antony@secunet.com,
        steffen.klassert@secunet.com
References: <20210923061342.8522-1-nicolas.dichtel@6wind.com>
 <20211018083045.27406-1-nicolas.dichtel@6wind.com>
 <1ee8e8ec-734b-eec7-1826-340c0d48f26e@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <9acfb0e5-872d-e527-9feb-6e9f5cf2f447@6wind.com>
Date:   Thu, 21 Oct 2021 23:23:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1ee8e8ec-734b-eec7-1826-340c0d48f26e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 21/10/2021 à 16:55, David Ahern a écrit :
> On 10/18/21 2:30 AM, Nicolas Dichtel wrote:
>> diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
>> index ecd06396eb16..378b4092f26a 100644
>> --- a/include/uapi/linux/xfrm.h
>> +++ b/include/uapi/linux/xfrm.h
>> @@ -213,13 +213,13 @@ enum {
>>  	XFRM_MSG_GETSPDINFO,
>>  #define XFRM_MSG_GETSPDINFO XFRM_MSG_GETSPDINFO
>>  
>> +	XFRM_MSG_MAPPING,
>> +#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
>> +
>>  	XFRM_MSG_SETDEFAULT,
>>  #define XFRM_MSG_SETDEFAULT XFRM_MSG_SETDEFAULT
>>  	XFRM_MSG_GETDEFAULT,
>>  #define XFRM_MSG_GETDEFAULT XFRM_MSG_GETDEFAULT
>> -
>> -	XFRM_MSG_MAPPING,
>> -#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
>>  	__XFRM_MSG_MAX
>>  };
>>  #define XFRM_MSG_MAX (__XFRM_MSG_MAX - 1)
>> @@ -514,9 +514,12 @@ struct xfrm_user_offload {
>>  #define XFRM_OFFLOAD_INBOUND	2
>>  
>>  struct xfrm_userpolicy_default {
>> -#define XFRM_USERPOLICY_DIRMASK_MAX	(sizeof(__u8) * 8)
>> -	__u8				dirmask;
>> -	__u8				action;
>> +#define XFRM_USERPOLICY_UNSPEC	0
>> +#define XFRM_USERPOLICY_BLOCK	1
>> +#define XFRM_USERPOLICY_ACCEPT	2
>> +	__u8				in;
>> +	__u8				fwd;
>> +	__u8				out;
>>  };
>>  
>>  /* backwards compatibility for userspace */
> 
> that is already updated in iproute2-next.
But this is needed for the iproute2 also. These will be in the linux v5.15 release.

[snip]

> 
> create xfrm_str_to_policy and xfrm_policy_to_str helpers for the
> conversions between "block" and "accept" to XFRM_USERPOLICY_BLOCK and
> XFRM_USERPOLICY_ACCEPT and back.
Ok.
