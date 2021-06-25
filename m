Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4353B4653
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 17:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhFYPIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 11:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhFYPIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 11:08:45 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05979C061767
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 08:06:24 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id c84so6461494wme.5
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 08:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AFFwYFTP3Uiktk5LoVFc2lRWhraIysj4KMrrrDOrInc=;
        b=P1s3LcZ35xxohi3PKxblm3ZXKDXGGzDkcnlPU5geHtyQ4hXcPoOeiYDJZMJgTteGob
         mVAGgmCZP6Wb8GEe8O/G7+XQf1cbopGoMqS/27hrsWVxzdfVLNBc0mxDIp7JXQZTpDNF
         T7pPuiZ2NI2ghkry1y3AsLmeAwLBRsXMxOHn3uJawHZebQkdrTJfwmE/S9rDN8cLnuIx
         sy5slRGXoyfa4dmI+TNj+qzPUNvKl1hhDzZZYi1qGbjuMJ1hBd2mzRynEOrKwg9RrG7N
         atTcCICJY7+sThyXF3Vn+gFZMieJjXIUHUs7LBI5m87cmmRHYq4emCcx4Chgwm2lrpNO
         sgUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AFFwYFTP3Uiktk5LoVFc2lRWhraIysj4KMrrrDOrInc=;
        b=J6tCxbEVhX5DTrimZHOXxu7zNfb0OLFzmNXw4lj6w9m7p53lrF656hUJ8fuLwOK+rx
         +vtw9uPaCB682h4Zjd/PBL3miI+su7/IWBE34iEuntvkPRud8HAqrXxq4yoYMjHtXfln
         SwSrP+Y7Eo72JI7tl3PG3lLIUcHGaL39KQEh70AJH7G7OnRE4RMltEdhi5zkjWCnlTHb
         t9iZZ5QXubkqU6gcTw4kHukWLCrpUrLLnZeeVZnpHZhxnzwZ0qAdD5ysnfLLBv2ncxbq
         CmbGyqwue9DAgDDxT1Avw/pxBMfpMpNa0XdSZ/4tM4/pE5MMcoUlVbdmT0D4NpwQZ6xC
         RDVQ==
X-Gm-Message-State: AOAM53311b/2eHhsicclDH4RqHX79hIzabQ//py1Q+Qf1vF3FPletY0f
        /zjnNvkYtFUGiJXnAIJ8S/+RWQ==
X-Google-Smtp-Source: ABdhPJyayEd0vyYgrtjzwe7ivwYNTBU+ScQy+7S2q6GsOLNEiG5RX3U5GBNRY02yeoLqhve0W/iudw==
X-Received: by 2002:a7b:cc99:: with SMTP id p25mr11192117wma.19.1624633582544;
        Fri, 25 Jun 2021 08:06:22 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:78f3:e334:978:3783? ([2a01:e0a:410:bb00:78f3:e334:978:3783])
        by smtp.gmail.com with ESMTPSA id o2sm6326711wrp.53.2021.06.25.08.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 08:06:22 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: Issues during assigning addresses on point to point interfaces
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Phil Sutter <phil@nwl.cc>
References: <20210606151008.7dwx5ukrlvxt4t3k@pali>
 <20210624124545.2b170258@dellmb>
 <d3995a21-d9fe-9393-a10e-8eddccec2f47@6wind.com>
 <20210625084031.c33yovvximtabmf4@pali>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <d3dd210c-bf0f-7b48-6562-23e87c2ad55a@6wind.com>
Date:   Fri, 25 Jun 2021 17:06:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625084031.c33yovvximtabmf4@pali>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 25/06/2021 à 10:40, Pali Rohár a écrit :
> On Thursday 24 June 2021 14:57:41 Nicolas Dichtel wrote:
>> Le 24/06/2021 à 12:45, Marek Behún a écrit :
>>> On Sun, 6 Jun 2021 17:10:08 +0200
>>> Pali Rohár <pali@kernel.org> wrote:
>>>
>>>> Hello!
>>>>
>>>> Seems that there is a bug during assigning IP addresses on point to
>>>> point interfaces.
>>>>
>>>> Assigning just one local address works fine:
>>>>
>>>>     ip address add fe80::6 dev ppp1 --> inet6 fe80::6/128 scope link
>>>>
>>>> Assigning both local and remote peer address also works fine:
>>>>
>>>>     ip address add fe80::7 peer fe80::8 dev ppp1 ---> inet6 fe80::7
>>>> peer fe80::8/128 scope link
>>>>
>>>> But trying to assign just remote peer address does not work. Moreover
>>>> "ip address" call does not fail, it returns zero but instead of
>>>> setting remote peer address, it sets local address:
>>>>
>>>>     ip address add peer fe80::5 dev ppp1 --> inet6 fe80::5/128 scope
>>>> link
>>>>
>>>
>>> Adding some other people to Cc in order to get their opinions.
>>>
>>> It seems this bug is there from the beginning, from commit
>>> caeaba79009c2 ("ipv6: add support of peer address")
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=caeaba79009c2
>>>
>>> Maybe some older user-space utilities use IFA_ADDRESS instead of
>>> IFA_LOCAL, and this was done in order to be compatible with them?
>> If I remember well, there was an issue in the uAPI.
>> IFA_LOCAL is supposed to be the address of the interface and IFA_ADDRESS is
>> supposed to be the endpoint of a point-to-point interface.
>> However, in case of IPv6, it was not the case. In netlink messages generated by
>> the kernel, IFA_ADDRESS was used instead of IFA_LOCAL.
>> The patch tried to keep the backward compatibility and the symmetry between msg
>> from userland and notification from the kernel.
> 
> Hello Nicolas!
> 
> See my original email where I put also rtnetlink packets (how strace see
> them). Seems that there is a bug in handling them (or bug in iproute2)
> as setting just peer (remote) IPv6 address is ignored:
> https://lore.kernel.org/netdev/20210606151008.7dwx5ukrlvxt4t3k@pali/
> 
> Do you have any idea if this is affected by that "issue in the uAPI"?
> And what is the way how to fix it?
What about forcing IFA_LOCAL address to :: in your case?
