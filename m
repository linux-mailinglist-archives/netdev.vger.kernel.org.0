Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2682586C3
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 06:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgIAEUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 00:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgIAEUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 00:20:41 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA67C0612FE
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 21:20:41 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id i10so5293pgk.1
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 21:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=RjPIw74c8vffPjFSoZ9zLiX/LzmRx2OfAo5bjwn53TA=;
        b=MewO46KOTEgJeJwuNy03lCD1aqI5m4aYSrF9w6ejE2d3iObyLvtvTVwZNruJ1h2IdR
         lxewKGJZHW/gC4UI2UDGhCYaECxOgn/vp270HB6q5/lxIYU6tNiPrbB2rt9QyS6pJ0ko
         fN+rohF8eCI7LSPz84KqamT0DUzeVKTgjAuEeka85n/yykneafFd/5O/8Z/MJInkyGq4
         jWQXU4GyrdAM/TjnLxWjiNttL4RMRgJl9flGF7BIjZFXRHyPeHepd1A+Qc6jxWNYm94/
         ivdv3F+HTgSEXIUdt4bhQz+RIkXMJK+Kn49uaI7Kbij2zCtmZgJfMuwt6LyEE9a8v5lo
         PRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RjPIw74c8vffPjFSoZ9zLiX/LzmRx2OfAo5bjwn53TA=;
        b=sR0yZN1JL8zQjOVJ8UrVqqmSHSc8bypZMPhGHNVlxTpdNWd/p15EYqp+nxVuFaht8j
         LCEj9+iLLJVOrR5EnHC1CF2IH3ziRldqN4EHiF0TOts7ilpuhfuCR3uFBeyeHIC+3rBD
         06AxPm40AVpLSZpO53VcJP9pZWbGoqeEVEC7SKi6+PDtfXj7GL4TtT/9Tpe6oJAA06zD
         MRwk5xwoAHeZj1AzcX5O1dUr2dz1bkHMzMUPu6i87Z20Tr/yaycvSvr0WrOsvIBcsbXi
         uS9XQ3uejTl8OFQUejHf4ULMJLG7nC875gNUvNU19YXXFsvDgsEFgx1GSXLXqQQj8OHO
         kk3g==
X-Gm-Message-State: AOAM531hBqBr3ZAyq6w8bMx1ftL13WMUZAkkzQwCRbrX/xNqaVyX/2cm
        g/ZkTowjotNF5C5KssH5sreCGILjXkF70g==
X-Google-Smtp-Source: ABdhPJzHmtrqoD2xA3wCx2k6FEvdRAreR8jW4dnQsia15IjJpOD6Pl7E8Az5OSYXn0aDZZRhwHtvlg==
X-Received: by 2002:a63:521c:: with SMTP id g28mr4030652pgb.247.1598934041081;
        Mon, 31 Aug 2020 21:20:41 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id fv21sm123026pjb.16.2020.08.31.21.20.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 21:20:40 -0700 (PDT)
Subject: Re: [PATCH net-next 2/5] ionic: smaller coalesce default
To:     David Miller <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org
References: <20200831233558.71417-1-snelson@pensando.io>
 <20200831233558.71417-3-snelson@pensando.io>
 <20200831165054.6d16f0dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200831.171613.1392501036623240615.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <4bd7c866-4b99-bf3c-460e-8edf8fbf1e15@pensando.io>
Date:   Mon, 31 Aug 2020 21:20:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200831.171613.1392501036623240615.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/20 5:16 PM, David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Mon, 31 Aug 2020 16:50:54 -0700
>
>> On Mon, 31 Aug 2020 16:35:55 -0700 Shannon Nelson wrote:
>>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>>> index 9e2ac2b8a082..2b2eb5f2a0e5 100644
>>> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>>> @@ -16,7 +16,7 @@
>>>   #define IONIC_DEF_TXRX_DESC		4096
>>>   #define IONIC_LIFS_MAX			1024
>>>   #define IONIC_WATCHDOG_SECS		5
>>> -#define IONIC_ITR_COAL_USEC_DEFAULT	64
>>> +#define IONIC_ITR_COAL_USEC_DEFAULT	8
>> 8 us interrupt coalescing does not hurt general operations?! No way.
>>
>> It's your customers who'll get hurt here, so your call, but I seriously
>> doubt this. Unless the unit is not usec?
> Agreed, 8usec is really really low.  You won't get much coalescing during
> bulk transfers with a value like that, eliminating the gain from coalescing
> in the first place.

Thanks.  I'll drop this patch and come back to this issue when we get a 
chance to add adaptive coalescing.

sln


