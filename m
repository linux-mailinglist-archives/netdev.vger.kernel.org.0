Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48BC408166
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 22:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbhILUQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 16:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236768AbhILUQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 16:16:49 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2865C061760;
        Sun, 12 Sep 2021 13:15:13 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id r26so11376783oij.2;
        Sun, 12 Sep 2021 13:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3bXRAr8vzVgfue5qLyX/aEE51q1nNWyvUB1vQ8basms=;
        b=MHldca8gHolBBgtSYRPEdDb+GFyr/YOhkHnEp9Z2n4MugP/HGzAFsZU4/8h+u7UQYY
         uw20IDQ/5cI1lT4wjezown2p4wm9yIdDPiydbSzsWkWRj7oRz/5zIeEkGpQV1nBRA3k4
         cCkA9Pt03ctg9gd3ifk8xWeN23sF8b+SSrg7qpqhAYP8WbAw+tlZBhcAWM1IFg2n5lEb
         d5UrvDrh7gcNxUEg6H1aWDAV/L4+yy2NovGu8ldX0IOySuG+bFG9QYhVQrmWSLKTy97p
         YJ08XM1N0G70rISAvjIGBYBjOVM6dpgbGkMSiTA0jjC/+Hjzvdg4l7pRUUbuf+4AJ7v4
         gCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3bXRAr8vzVgfue5qLyX/aEE51q1nNWyvUB1vQ8basms=;
        b=RxRxk5dzFZMPebqnz+CxQyAq19Ltm715dbSlLS/iDi4up0zoL6a9XXpkrZ8zqErnqB
         9esZls5KUxM/0trwAzwCe5UkgbY1ejr3LDcLZxc3nM2BTIv2gC9EDzAq8b8K/Td89RB4
         sbroSXmpFq06ZhhS2iSuhQWndXh+ymSOPsy3ehqBwP2H1aX8kIcUSBNhVRALDZCPonjx
         yujvmvARC7dhg/rbcDpoTnKFrwuoYmr73iN4hXid7GcXLD7zWLy+S6ce/wEA/VTYHLF1
         gY3ywYjE5AJuyd+DfH4fDZdsI0bsdK9AZAxcFDxNrwYl/UBKyhZwNPpU2mKa+C3VhagR
         jLAQ==
X-Gm-Message-State: AOAM5300rEn+67yC5KdNvFSPMeZ1S9W/VLwuqm1+KRbv4Yrx2sYhwYM2
        iNZF+/MgAPBIV66bOMV8Czvst2evfrk=
X-Google-Smtp-Source: ABdhPJz799fGwn8UzweiQm/O+x9gE4pvvOtyczsJ36N0oq/qi2bI5CPOw2l1zzo6A34Vu0h4JwnAGA==
X-Received: by 2002:a05:6808:5:: with SMTP id u5mr5342595oic.35.1631477712974;
        Sun, 12 Sep 2021 13:15:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 4sm1202563oil.38.2021.09.12.13.15.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 13:15:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 4/4] alpha: Use absolute_pointer for strcmp on fixed
 memory location
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
References: <20210912160149.2227137-1-linux@roeck-us.net>
 <20210912160149.2227137-5-linux@roeck-us.net>
 <CAHk-=wi1=8shingNuo1CtfJ7eDByDsmwsz750Nbxq=7q0Gs+zg@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <155e002d-9546-4090-fc62-fab91412aec7@roeck-us.net>
Date:   Sun, 12 Sep 2021 13:15:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wi1=8shingNuo1CtfJ7eDByDsmwsz750Nbxq=7q0Gs+zg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/21 12:13 PM, Linus Torvalds wrote:
> On Sun, Sep 12, 2021 at 9:02 AM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> -       if (strcmp(COMMAND_LINE, "INSTALL") == 0) {
>> +       if (strcmp(absolute_pointer(COMMAND_LINE), "INSTALL") == 0) {
> 
> Again, this feels very much like treating the symptoms, not actually
> fixing the real issue.
> 
> It's COMMAND_LINE itself that should have been fixed up, not that one use of it.
> 
> Because the only reason you didn't get a warning from later uses is
> that 'strcmp()' is doing compiler-specific magic. You're just delaying
> the inevitable warnings about the other uses of that thing.
> 

Makes sense. I'll change the patch accordingly.

Thanks,
Guenter
