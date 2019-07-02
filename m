Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11E9F5D980
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfGCApn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:45:43 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:40411 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfGCApn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:45:43 -0400
Received: by mail-wm1-f54.google.com with SMTP id v19so401769wmj.5
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 17:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q0vmPs4YL5Qmtfli/VH/0lsB9Ep4mMtKja2fne3rfaU=;
        b=MG3FrL/FgWs5TvynBgMPAd22w9AtseB35xsSWEJnQKPPk8fKjmtNqWsvvhY5BT7Yq4
         vkLN/LFSucg6WH9FgCiW1BiG3hnVsXmKd7skuOU+XFKHD9NcdcR8z8KhjQVr46ikOeI0
         YT71D12uDYKff6IXppzYwU2aMGfs3FVhm/diA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q0vmPs4YL5Qmtfli/VH/0lsB9Ep4mMtKja2fne3rfaU=;
        b=SlsoR6JhnFL8IHoNKQtpr9xuktU1UG3gq8A6ldR7Hijsg/MiNFKIBigprQn6rGBcmp
         4RUxprwvdjiifHjgbu3EyB6sUcGZVJP6Jc89NlTHmUT0jQ3MhMVB4ck6sHZgrulhFH7s
         7WXHBjdFhiakllUoej0S0AEe80XGBSnDMotdSNuL/ijzZAVr76axgYnjzIvkWUgIm3km
         nsCqSI9uPEjuxpqYChUNg8zeVFcXMswG/K8qCHa9R11iAZ/0jEd2xDGl3MDPT+d7i2H1
         A016smLFsEAhIgG5X5cxndooap/bHY+TLBGaVaxHShXThJ1ry906yF+5jmnb/0ghBYWv
         lGFg==
X-Gm-Message-State: APjAAAU3c+nNbHuws+rN2pM4GpB7bvlPRGShFlORE3DpdaHTBGHCQetu
        hnfjVHTLkEziWscn5isTjl0awSA64hw=
X-Google-Smtp-Source: APXvYqyKB/bsI1NDRSJTeUQYxjbstts/oBxF2rERAXuTJdf7qmbiJKooS8yiX6MNOZPs0O18UkHRvA==
X-Received: by 2002:a1c:6c08:: with SMTP id h8mr4897795wmc.62.1562102467600;
        Tue, 02 Jul 2019 14:21:07 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id c1sm159717wrh.1.2019.07.02.14.21.06
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 14:21:07 -0700 (PDT)
Subject: Re: Validation of forward_delay seems wrong...
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org, netdev <netdev@vger.kernel.org>
References: <20190702204705.GC28471@lunn.ch>
 <55f24bfb-4239-dda8-24f8-26b6b2fa9f9e@cumulusnetworks.com>
Message-ID: <4a015cbf-41bc-8ba0-94b5-ec2702e51c33@cumulusnetworks.com>
Date:   Wed, 3 Jul 2019 00:21:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <55f24bfb-4239-dda8-24f8-26b6b2fa9f9e@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/07/2019 00:19, Nikolay Aleksandrov wrote:
> On 02/07/2019 23:47, Andrew Lunn wrote:
>> Hi Nikolay
>>
>> The man page says that the bridge forward_delay is in units of
>> seconds, and should be between 2 and 30.
>>
>> I've tested on a couple of different kernel versions, and this appears
>> to be not working correctly:
>>
>> ip link set br0 type bridge forward_delay 2
>> RTNETLINK answers: Numerical result out of range
>>
>> ip link set br0 type bridge forward_delay 199
>> RTNETLINK answers: Numerical result out of range
>>
>> ip link set br0 type bridge forward_delay 200
>> # 
>>
>> ip link set br0 type bridge forward_delay 3000
>> #
>>
>> ip link set br0 type bridge forward_delay 3001
>> RTNETLINK answers: Numerical result out of range
>>
>> I've not checked what delay is actually being used here, but clearly
>> something is mixed up.
>>
>> grep HZ .config 
>> CONFIG_HZ_PERIODIC=y
>> # CONFIG_NO_HZ_IDLE is not set
>> # CONFIG_NO_HZ_FULL is not set
>> # CONFIG_NO_HZ is not set
>> CONFIG_HZ_FIXED=0
>> CONFIG_HZ_100=y
>> # CONFIG_HZ_200 is not set
>> # CONFIG_HZ_250 is not set
>> # CONFIG_HZ_300 is not set
>> # CONFIG_HZ_500 is not set
>> # CONFIG_HZ_1000 is not set
>> CONFIG_HZ=100
>>
>> Thanks
>> 	Andrew
>>
> 
> Hi Andrew,
> The man page is wrong, these have been in USER_HZ scaled clock_t format from the beginning.
> TBH a lot of the time/delay bridge config options are messed up like that.
> We've been discussing adding special _ms versions in iproute2 to make them
> more user-friendly and understandable. Will cook a patch for the man page.
> 
> Cheers,
>  Nik
> 
> 

Err, I meant it is seconds just scaled, if it wasn't clear.


