Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE4036B7BE
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbhDZRMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236277AbhDZRMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:12:18 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B92EC061345
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:11:30 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s14so22526359pjl.5
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d15J0sa5YUk2Sb7gPxRPguoH0qzQFMOrXlQ8i+jbG6I=;
        b=IBia8Do/rti98MYDBk+LRztBdVhbuoGpiv52gZkct9l6/aYnJttbSoH4Qqq1HV9HU+
         O28UJBrhDBqy8uftJ6cmjBUOZ6co6CehM6lobNOsbtyM69r+7sL+HFXz5/bdyYLbRD1o
         ni3VIdP9IXopQN1aqdm5UhrJF4IyCWorZNIhciuoHmNgb3YpBM3fDxBA2sehAAI15wAf
         LQph6O1pUsvKbkilNWBSjZyEGGNENn1cK5oHEiLLQuffNrRplWfMj75L26QYC2ZkPgdw
         qK7TwuEQcnLKVs4tiVZ+RpTPBIHmxMY7fYF/9IOwd7UQrilGfvEAowvWnCGtbKpagGIE
         MLHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d15J0sa5YUk2Sb7gPxRPguoH0qzQFMOrXlQ8i+jbG6I=;
        b=E7rAZq58H+5nBRjP5Tf68fvZ45RBdhYbzQT9gBIcN6Bjk3jFjLcz3Mx4jXvqLYuUkQ
         ZmCJYo/QJ9hmrH6dxv2kF5o95TVcAsL/5FBcn5S6290YLfvKqoTLaN/X4He8Bi5YjmoX
         +jVhaTWOcSSIm968BH6CRKi4aJDQJ+MpbtmhC8Jca+cZjPL/DcRqeZoR5MrLtM+aWi1r
         6ok1EMTr6hMg5vhN/PnmYF8U8xKtHPiX1yC2Z24dBrh1Tc9Ura05qNb3kOyFAqHwa3Rq
         HqjTf92Q/p5zxapvXN6c/g/3OogmMj+9EfSqNmKJH2qRV6RzQZsHvfn2Lmwv95rAoNpR
         T6mQ==
X-Gm-Message-State: AOAM532rfiM7Dl03gXzhPXTLGDWs0qbEh0VJSz6rwubIHNlPDGzznhWY
        6i0w33sTyU/bSAltKN/3B1U=
X-Google-Smtp-Source: ABdhPJwas3cd1hh7ybPCa7y/30UBkA0ilSO14p0W8gcikGfD8mINp5vmk8qlwNsOajye17pl4HlUCQ==
X-Received: by 2002:a17:902:e883:b029:ec:f02d:af55 with SMTP id w3-20020a170902e883b02900ecf02daf55mr13661083plg.21.1619457090116;
        Mon, 26 Apr 2021 10:11:30 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ml19sm345166pjb.2.2021.04.26.10.11.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 10:11:29 -0700 (PDT)
Subject: Re: [PATCH net-next] net/sched: act_vlan: Fix vlan modify to allow
 zero priority
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
References: <20210421084404.GA7262@noodle>
 <20210421121241.3dde83bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210425105713.GA12968@builder>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4d0dd5f5-1a54-3462-174f-352cd6440a59@gmail.com>
Date:   Mon, 26 Apr 2021 10:11:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210425105713.GA12968@builder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/21 3:57 AM, Boris Sukholitko wrote:
> Hi Jakub,
> 
> On Wed, Apr 21, 2021 at 12:12:41PM -0700, Jakub Kicinski wrote:
>> On Wed, 21 Apr 2021 11:44:04 +0300 Boris Sukholitko wrote:
>>> This electronic communication and the information and any files transmitted 
>>> with it, or attached to it, are confidential and are intended solely for 
>>> the use of the individual or entity to whom it is addressed and may contain 
>>> information that is confidential, legally privileged, protected by privacy 
>>> laws, or otherwise restricted from disclosure to anyone else. If you are 
>>> not the intended recipient or the person responsible for delivering the 
>>> e-mail to the intended recipient, you are hereby notified that any use, 
>>> copying, distributing, dissemination, forwarding, printing, or copying of 
>>> this e-mail is strictly prohibited. If you received this e-mail in error, 
>>> please return the e-mail to the sender, delete it from your computer, and 
>>> destroy any printed copy of it.
>>
>> Could you please resend without this legal prayer?
> 
> Please accept my apologies. Apparently the "legal prayer" is added
> automatically to all outgoing Broadcom emails and I have no control over its
> existance.

You can request an exemption with Broadcom's IT department in order to
send emails without this legalese footer, I will email you separately on
how to do that.
-- 
Florian
