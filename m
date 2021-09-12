Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395EC408191
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 22:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbhILUiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 16:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235269AbhILUio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 16:38:44 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42342C061574;
        Sun, 12 Sep 2021 13:37:30 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id k12-20020a056830150c00b0051abe7f680bso10510968otp.1;
        Sun, 12 Sep 2021 13:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sGO52QCbtTKYdjcgj2GabgzNcLXhaoNx+6K218Q6YKM=;
        b=BoFoBk6YCh+SHOSsUgl2enC7/u2I2Bj4b7E3MP/cJEMdjyirzvoalq82dA+5XeNWwl
         /4MX3K/6+Xlj40bcX+GF4RP8Np3PeD5WLjyuCNRAh/yUxFLrsFfGqZHVTX+4voCDXThQ
         NtCPmvzn6p+zmvtMjAf39/fOY68oVD2yl1mYDt0TXnPjWiPfwLnBaXyNVrTevhQVK5pD
         aw64A7C41B/zB54y/F7R6iae8wdcyUP5mhh/68BIQ4hchpPoT6t+dOxtutYlJ8dqp3XS
         yjBSGiq5nQNB+jK0YfSdbGNqMPP3srkCCqL2YC3AJg3enTDIsnt4wkcbYUuMIGJkyi31
         IwEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sGO52QCbtTKYdjcgj2GabgzNcLXhaoNx+6K218Q6YKM=;
        b=paT/axvKVvZ3RLeKhVFOKy2Flcfawc0EuHWAvAdtGgR/elc3hz2YZuYrhNlS4udQ6W
         i8ZLtqD8jEX6jJpi2yLrqnrPLhb41hWUGXdJFoRyf/CAcOA28sYRlOeNwtVI377ypWCz
         8JSI2Tgu+wgFKtxukBNYctYeSiCFaNjRTY7WelXfTLay/TGocCH2u7122z3KholPr+j6
         2S8htr585OzXCRi/1hnV8y64LdzeIWnrixFs5sTA6KIfn5Q0OBtg4NOg6WC1ER/f1ODE
         yVOUCeGbhhh29sMrM7Kp9uerxvPDgErF5GdtBuODmLqcjBUZ66aePkFNWcyc5Bhqiogj
         2CcQ==
X-Gm-Message-State: AOAM532DXDGfpcA5nCnvHEAmXKMBS/zvXsp9+iCcC5707lPf25ejh+Vn
        2OnCLKfi77SdvwKNgI8f6BAVzP+iQxw=
X-Google-Smtp-Source: ABdhPJyr/+V+h4oQD6vwcSYgo9ReR96NTjTaNALCXrvxkaPwBpC+OfD7ikcSEXFhco1iPgTbl+o8QA==
X-Received: by 2002:a05:6830:10:: with SMTP id c16mr6943996otp.63.1631479049479;
        Sun, 12 Sep 2021 13:37:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 33sm1333791otx.19.2021.09.12.13.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 13:37:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
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
Subject: Re: [PATCH 4/4] alpha: Use absolute_pointer for strcmp on fixed
 memory location
Message-ID: <0f36c218-d79c-145f-3368-7456dd39a3f2@roeck-us.net>
Date:   Sun, 12 Sep 2021 13:37:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wi1=8shingNuo1CtfJ7eDByDsmwsz750Nbxq=7q0Gs+zg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
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

COMMAND_LINE is, for whatever reason, defined in
arch/alpha/include/uapi/asm/setup.h, ie in the uapi.

Can I even touch that ?

Guenter
