Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C1E39BE29
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 19:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhFDRMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 13:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhFDRMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 13:12:52 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7897C061766;
        Fri,  4 Jun 2021 10:11:05 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d16so7878949pfn.12;
        Fri, 04 Jun 2021 10:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=A8tbCM6Wzc7qo6yZiGdsvIizSfEsRxnGz4O8sqiJL1E=;
        b=U2sHcJfDvHRybYlqmBWoVOc2kUbloM0Fj22U0ID75V71unSVKnOkV1n7gWwKHuiR3i
         KDyk7b54zI9xQ8FjwgiXk9atJErIuQQb6FKVB7Eb77BJ2+9gBFUHDXHlACorNGyHLRf8
         eJ/qvlujsTM3Uio1PVUQNnHYeP9UOLvPTw82KOcd0zidGop7+os19OrEanYTQy7BRwpG
         m6kQTnOA361m57UZWBsjyNK9T52/5xjGf+Ktw+J/0gh4Z8ncdFaqju0wA9wU++A9YNtx
         h3lH0Oy8rn4NImDq2O7iaOehec7WogPd20Uievoc1/odZFlPOMlHOx0nZNPN3jmsDLYG
         ZKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=A8tbCM6Wzc7qo6yZiGdsvIizSfEsRxnGz4O8sqiJL1E=;
        b=MMfBRrnVhu87/rzWMV5re0aikDmKWjzSPhoiiRfwCsxE00kvM7Z2M1EAgUsF8c2/jJ
         i8e+aOEZZX9nfL6JoObBC9Lc8u8TKGeEboFG848wcVYbfheJp8ATS94awbHoX/41Ea/U
         8zWHokKLhAJvZK84EtPJQM2gQhzJEm50+Dz8KhO8Ssr5mPE0myEheqFq6LD7dWydy+Wd
         Gr2k8AMW5pUwvP1+hlId2JxGSZUSjPwFJwJMoyYWB/IhV7veR81vdhDYwGqJey0Prlrd
         o2DL4pfQJxt6S0oEgRvsJjQfmiR36WdUh7qUjAaNUuEX5IAyYb8Q9mq0nhv5xclcnb7r
         dSdw==
X-Gm-Message-State: AOAM533tDaIRsL7qSYwu+5uKpOepmq3a3r6HWYbltMR3ydzp1MM3sa+b
        hIccAt8nyqUW1u0Ksg1Yy6FOhyABtudzDw==
X-Google-Smtp-Source: ABdhPJxr7r4TPZT2RlU+7Vw9eF/0wjpRiGfvOF4ixcZJKCfj9q7r3PmbqxkPki6kZloqHf03ymw0Vw==
X-Received: by 2002:aa7:8888:0:b029:2ec:763f:4bcc with SMTP id z8-20020aa788880000b02902ec763f4bccmr5473095pfe.35.1622826665260;
        Fri, 04 Jun 2021 10:11:05 -0700 (PDT)
Received: from [192.168.1.41] (096-040-190-174.res.spectrum.com. [96.40.190.174])
        by smtp.gmail.com with ESMTPSA id x15sm2279010pfd.121.2021.06.04.10.11.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 10:11:04 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in hci_chan_del
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000adea7f05abeb19cf@google.com>
 <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com> <YLn24sFxJqGDNBii@kroah.com>
From:   SyzScope <syzscope@gmail.com>
Message-ID: <0f489a64-f080-2f89-6e4a-d066aeaea519@gmail.com>
Date:   Fri, 4 Jun 2021 10:11:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YLn24sFxJqGDNBii@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

> Who is working on and doing this "reseach project"?
We are a group of researchers from University of California, Riverside 
(we introduced ourselves in an earlier email to security@kernel.org if 
you recall).  Please allow us to articulate the goal of our research. 
We'd be happy to hear your feedback and suggestions.

> And what is it
> doing to actually fix the issues that syzbot finds?  Seems like that
> would be a better solution instead of just trying to send emails saying,
> in short "why isn't this reported issue fixed yet?"
 From our limited understanding, we know a key problem with syzbot bugs 
is that there are too many of them - more than what can be handled by 
developers and maintainers. Therefore, it seems some form of 
prioritization on bug fixing would be helpful. The goal of the SyzScope 
project is to *automatically* analyze the security impact of syzbot 
bugs, which helps with prioritizing bug fixes. In other words, when a 
syzbot bug is reported, we aim to attach a corresponding security impact 
"signal" to help developers make an informed decision on which ones to 
fix first.

Currently,  SyzScope is a standalone prototype system that we plan to 
open source. We hope to keep developing it to make it more and more 
useful and have it eventually integrated into syzbot (we are in talks 
with Dmitry).

We are happy to talk more offline (perhaps even in a zoom meeting if you 
would like). Thanks in advance for any feedback and suggestions you may 
have.


On 6/4/2021 2:48 AM, Greg KH wrote:
> On Tue, May 04, 2021 at 02:50:03PM -0700, ETenal wrote:
>> Hi,
>>
>> This is SyzScope, a research project that aims to reveal high-risk
>> primitives from a seemingly low-risk bug (UAF/OOB read, WARNING, BUG, etc.).
> Who is working on and doing this "reseach project"?  And what is it
> doing to actually fix the issues that syzbot finds?  Seems like that
> would be a better solution instead of just trying to send emails saying,
> in short "why isn't this reported issue fixed yet?"
>
> thanks,
>
> greg k-h
>
