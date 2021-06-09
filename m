Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35C43A0DD3
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 09:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhFIHjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 03:39:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230233AbhFIHjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 03:39:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623224269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dKHLpYCGx0g7EoGipPcjgNbmX1MLZSaTZNKvZi1Yge0=;
        b=BanBmrlkWiESpeBlPJUeA7gBEPRBbrNZ8f8svdOhUDKSjJMyYtFyIrkW3QjAbI4ua8VbNo
        ceikR63Qiby7QAnQdrfaebr4fpctVrX5tRB4qj3thEG30m/jsEEP0LmXs/HNhvPQuiq7TF
        mwvOAlvhJun4HdOonNRzkg4fZsFaNQA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-92_3efykO7K_GP0hrYtFYw-1; Wed, 09 Jun 2021 03:34:36 -0400
X-MC-Unique: 92_3efykO7K_GP0hrYtFYw-1
Received: by mail-qt1-f198.google.com with SMTP id a5-20020ac84d850000b029024998e61d00so2028397qtw.14
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 00:34:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dKHLpYCGx0g7EoGipPcjgNbmX1MLZSaTZNKvZi1Yge0=;
        b=GjdIMaBro2sNnYPVK3TdFo8oIEmr/eflMeeTJMKN2J7xK/dNl3rg2yyAk2NM8rahBx
         Slq0R167qKW3iEQL3iwZuJua39mtmK7GPV/cdxf5AuJlfj/KhYLejEvaXzWzttbbZZvu
         yLv/hX4vAnM8TkU1GW38g/UCyplZza4NMRwlgJQwX4y39w0mSAseqy8EWuqEhmeGTkVi
         bA5tAjocOfH5+5XOWQn3GWE8FkGOYmYrb6ubHY+gTR/CqAysOIYw7RqgO8BomZVDcs+R
         9vTb8fXE+yi4JqM9q+s72ntmMQQs/MEEIy8foRhMB2UwB3wUwacndLa6s5Hr9QW3RgU9
         0i+A==
X-Gm-Message-State: AOAM530SsS6U5nK95WggaTl0j1FoJd6SoHAwuN5DRrxiGTGJWpwt8b72
        PFlDKons3oXTmJw8j+8kg6zBreLfSOCnj/ohm48yP7Y8Vef70x3z+PTm9i6TvfWjJqVhWzszr1q
        4fHv/c92BBjU4ckTw
X-Received: by 2002:a05:620a:1253:: with SMTP id a19mr11372148qkl.365.1623224076136;
        Wed, 09 Jun 2021 00:34:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyeQ3vZwJD5V9+1RCCrE3JekeNNLTpi7d82jJPwWzCuGoj9yPBCBVWCXy2YNny96QDa4zPseQ==
X-Received: by 2002:a05:620a:1253:: with SMTP id a19mr11372138qkl.365.1623224075940;
        Wed, 09 Jun 2021 00:34:35 -0700 (PDT)
Received: from [192.168.0.106] ([24.225.235.43])
        by smtp.gmail.com with ESMTPSA id g19sm6014609qto.49.2021.06.09.00.34.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 00:34:35 -0700 (PDT)
Subject: Re: [PATCH net-next] net: tipc: fix FB_MTU eat two pages
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     ying.xue@windriver.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20210604074419.53956-1-dong.menglong@zte.com.cn>
 <e997a058-9f6e-86a0-8591-56b0b89441aa@redhat.com>
 <CADxym3ZostCAY0GwUpTxEHcOPyOj5Lmv4F7xP-Q4=AEAVaEAxw@mail.gmail.com>
 <998cce2c-b18d-59c1-df64-fc62856c63a1@redhat.com> <20210607125120.GA4262@www>
 <46d2a694-6a85-0f8e-4156-9bb1c4dbdb69@redhat.com>
 <20210609025412.GA58348@www>
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <927af5e7-6194-d94e-1497-6b3dce26c583@redhat.com>
Date:   Wed, 9 Jun 2021 03:34:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609025412.GA58348@www>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/8/21 10:54 PM, Menglong Dong wrote:
> On Tue, Jun 08, 2021 at 06:37:38PM -0400, Jon Maloy wrote:
>>
> [...]
>> I spent a little more time looking into this. I think the best we can do is
>> to keep FB_MTU internal to msg.c, and then add an outline function to msg.c
>> that can be used by bcast.c. The way it is used is never time critical.
>>
>> I also see that we could need a little cleanup around this. There is a
>> redundant align() function that should be removed and replaced with the
>> global ALIGN() macro.
>> Even tipc_buf_acquire() should use this macro instead of the explicit method
>> that is used now.
>> In general, I stongly dislike conditional code, and it is not necessary in
>> this function. If we redefine the non-crypto BUF_TAILROOM to 0 instead of 16
>> (it is not used anywhere else) we could get rid of this too.
>>
>> But I leave that to you. If you only fix the FB_MTU macro I am content.
>>
> Yeah, I think I can handle it, just leave it to me.
>
> (finger heart :/)
> Menglong DongI
It seems like I have been misleading you. It turns out that these 
messages *will* be sent out over the nework in some cases, i.e. at 
multicast/broadcast over an UDP bearer.
So, what we need is two macros, one with the conditional crypto 
head/tailroom defined as you first suggested, and one that only use the 
non-crypto head/tailroom as we have been discussing now.
The first one can be defined inside bcast.c, the latter  inside msg.c.
It might also be a good idea to give the macros more descriptive names, 
such as ONEPAGE_MTU in the broadcast version, and ONEPAGE_SKB in the 
node local
version.

Does that make sense?

///jon


>

