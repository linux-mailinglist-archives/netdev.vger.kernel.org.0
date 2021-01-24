Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29DE4301E45
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 19:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbhAXS5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 13:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbhAXS5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 13:57:46 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECBEC061573
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 10:57:06 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id n42so10619107ota.12
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 10:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4fz4sQukfz4NId75OyAqoEvc3KacpPmciQyggbOiqDs=;
        b=ZiK9dQUbkJvRpHifRAtKlxuajTCoQEdgPueOTQI1lXA4lb5qUXJ4/rHmoJf9I59+ML
         Z5JUx6WL3sCzkyQmlJqnpM5wQPYEdPgtPsa049VjSGoX2DnaEIYrtU4RzSgLZtxRK7Dm
         zzMMQF2cNzJP3v4855RIVxiaUUc2x37LNNJnipSqZpxRUiAcOQEPFAISszT2kvnH5Hw4
         5BBh75sb4wk+4itFZWgyusPXApoi0jWm6fz2s7IGe02o1hYwDNttEYj2QlqAxvrliR2B
         e6S6JtY70QcqmWMKFII5LN1qK2m3xOSW1Xab8W6bU7lL600hFB5pPhrZ80cQgyt4Qya9
         pIHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4fz4sQukfz4NId75OyAqoEvc3KacpPmciQyggbOiqDs=;
        b=L8qP1aEARA/mF1D6UwCBmkW0s+ZEWM3Ke4MsWx4HjZFZ5SIDVMvblqJOidEl9d3sBk
         i0KjLvbi/OjSl4cLnfVlIvhLskOil6UbzBC0kwQsfTiHDbFbsmWo4cxa1Uw5JkMUYUCo
         pwLJceXCdpxp9IGS6zqYUcYwCsDpT37sZMZB2CGnG7Zlmcfr7EEdNg1NPkE21PH8NI00
         EZ6YCY9vMZMcXQrDPM5xRJxTU8cggcFt9zTtJe1mlWV3FHW7Iv8VGx0DQOZTzdD/zUd6
         VP8uAJaWypUyiRaon1/oSufHq1CMX8a0yY9/a5PhJjpojmyXNEUaTOxRq7+M3U2ooBGD
         ifng==
X-Gm-Message-State: AOAM533QQTwbHXnoXK362zmvehIwaxeQquSedMZazF/kLXIL5QMECWOg
        7RLr3lkhh4W7zgj1G07pfbc=
X-Google-Smtp-Source: ABdhPJzGCNUnQaUgrLC6u4s1IToA68jFW+/iS752ulHlYIu6/74wVcCYi8PFk+MlTRcSCr3r+PSIxA==
X-Received: by 2002:a05:6830:1257:: with SMTP id s23mr709987otp.69.1611514625653;
        Sun, 24 Jan 2021 10:57:05 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id k198sm1467011oih.33.2021.01.24.10.57.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 10:57:05 -0800 (PST)
Subject: Re: [PATCH net 1/1] uapi: fix big endian definition of
 ipv6_rpl_sr_hdr
To:     Justin Iurman <justin.iurman@uliege.be>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        alex aring <alex.aring@gmail.com>
References: <20210121220044.22361-1-justin.iurman@uliege.be>
 <20210121220044.22361-2-justin.iurman@uliege.be>
 <20210123205444.5e1df187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <55663307.1072450.1611482265804.JavaMail.zimbra@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fd7957e7-ab5c-d2c2-9338-76879563460e@gmail.com>
Date:   Sun, 24 Jan 2021 11:57:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <55663307.1072450.1611482265804.JavaMail.zimbra@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/21 2:57 AM, Justin Iurman wrote:
>> De: "Jakub Kicinski" <kuba@kernel.org>
>> À: "Justin Iurman" <justin.iurman@uliege.be>
>> Cc: netdev@vger.kernel.org, davem@davemloft.net, "alex aring" <alex.aring@gmail.com>
>> Envoyé: Dimanche 24 Janvier 2021 05:54:44
>> Objet: Re: [PATCH net 1/1] uapi: fix big endian definition of ipv6_rpl_sr_hdr
> 
>> On Thu, 21 Jan 2021 23:00:44 +0100 Justin Iurman wrote:
>>> Following RFC 6554 [1], the current order of fields is wrong for big
>>> endian definition. Indeed, here is how the header looks like:
>>>
>>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>> |  Next Header  |  Hdr Ext Len  | Routing Type  | Segments Left |
>>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>> | CmprI | CmprE |  Pad  |               Reserved                |
>>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>>
>>> This patch reorders fields so that big endian definition is now correct.
>>>
>>>   [1] https://tools.ietf.org/html/rfc6554#section-3
>>>
>>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
>>
>> Are you sure? This looks right to me.
> 
> AFAIK, yes. Did you mean the old (current) one looks right, or the new one? If you meant the old/current one, well, I don't understand why the big endian definition would look like this:
> 
> #elif defined(__BIG_ENDIAN_BITFIELD)
> 	__u32	reserved:20,
> 		pad:4,
> 		cmpri:4,
> 		cmpre:4;
> 
> When the RFC defines the header as follows:
> 
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | CmprI | CmprE |  Pad  |               Reserved                |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> 
> The little endian definition looks fine. But, when it comes to big endian, you define fields as you see them on the wire with the same order, right? So the current big endian definition makes no sense. It looks like it was a wrong mix with the little endian conversion.
> 
>>> diff --git a/include/uapi/linux/rpl.h b/include/uapi/linux/rpl.h
>>> index 1dccb55cf8c6..708adddf9f13 100644
>>> --- a/include/uapi/linux/rpl.h
>>> +++ b/include/uapi/linux/rpl.h
>>> @@ -28,10 +28,10 @@ struct ipv6_rpl_sr_hdr {
>>>  		pad:4,
>>>  		reserved1:16;
>>>  #elif defined(__BIG_ENDIAN_BITFIELD)
>>> -	__u32	reserved:20,
>>> +	__u32	cmpri:4,
>>> +		cmpre:4,
>>>  		pad:4,
>>> -		cmpri:4,
>>> -		cmpre:4;
>>> +		reserved:20;
>>>  #else
>>>  #error  "Please fix <asm/byteorder.h>"
>>>  #endif

cross-checking with other headers - tcp and vxlan-gpe - this patch looks
correct.
