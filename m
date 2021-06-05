Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686F839CA72
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 20:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhFESOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 14:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhFESOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 14:14:53 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BFCC061767;
        Sat,  5 Jun 2021 11:12:51 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c13so6351011plz.0;
        Sat, 05 Jun 2021 11:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=7RuxFrwI0fR4HmwKUjLBtcCaqaqm8oYbHbCCIngl9Xw=;
        b=tZtmNwAxLlwTzPvd/yKQK02yf2QDLz/WcngWOA3MdqjI1ElLDTR79IoruwRaL+uGRX
         dYejUAnW3tqxoghOuBfT/8a5Pj5HoK2mkWMrR9ANRJbBHJlp9cd9jCqJbCMNcMrer2Xm
         tSFNdQLh7+R86yuUrBuRQ5syzXtppyVgtftzObMWJBk9CUCKTGK6S7fUNEgWEAYRy8oy
         POWlNu4H9SsPnuttz1fIS+yOVLopYVTWy8ESFiNXGq0Mxcyzipo5vJ1mVWzYB6ZTEs8v
         ctcceq0XswnhzJ1zEjlhgn3DeOrJMpK/r3QANpTm4v2gFYmGKGwu519A23QMuleVcFLy
         znkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7RuxFrwI0fR4HmwKUjLBtcCaqaqm8oYbHbCCIngl9Xw=;
        b=bu2QJqzcQlJ9ZBN8IpEc78Qb6Da30OY4JvMmWtrUn1Om/t3NROqNwHDc4irRyq5F0m
         rCOsx6+OVhEsO99lRoj3DpUPMEuHvobngtGwEsZ5wxJdy78rQJ99zzPDhvxjh7AKqjXI
         Axn2XqocJ3NhEATp8YXqm5sb5yv60E/DiUKFPVODdDG9/hvUM1jVLlrBesSjIVQer9h/
         1O2Gt+x9RVHW4GXy0ucR+/InJJgTwHx4OlcF3dC0QCgXC+Mm8aAG1558kSxqVWDDgxnk
         XDQ3ID0sucCfUxd5L+1YE4reSxkMBktaJQtzXHO1KcZHV8L+RbEXjV6HcVZ79ZK2qa/J
         P9nA==
X-Gm-Message-State: AOAM533mJtC4hKyHIXH9M2Fy6WWNMVMJQ7pLN8GnwqdZVVExIyQ61mrf
        1/ik8qtpJX7s6jdMaoouiSg=
X-Google-Smtp-Source: ABdhPJz3hDsFVzoaZY9HMbEXgKwJau1AmxoHZ6/GjNgW/3+UUhTEPMiDWxHwOJxeXXFShv9xvr7mZQ==
X-Received: by 2002:a17:902:b683:b029:ee:f0e3:7a50 with SMTP id c3-20020a170902b683b02900eef0e37a50mr10009278pls.7.1622916770474;
        Sat, 05 Jun 2021 11:12:50 -0700 (PDT)
Received: from [192.168.1.14] (096-040-190-174.res.spectrum.com. [96.40.190.174])
        by smtp.gmail.com with ESMTPSA id r92sm8225780pja.6.2021.06.05.11.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Jun 2021 11:12:50 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in hci_chan_del
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000adea7f05abeb19cf@google.com>
 <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com> <YLn24sFxJqGDNBii@kroah.com>
 <0f489a64-f080-2f89-6e4a-d066aeaea519@gmail.com> <YLsrLz7otkQAkIN7@kroah.com>
From:   SyzScope <syzscope@gmail.com>
Message-ID: <d37fecad-eed3-5eb8-e30a-ebb912e3a073@gmail.com>
Date:   Sat, 5 Jun 2021 11:12:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YLsrLz7otkQAkIN7@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

> I do not recall that, sorry, when was that?
We sent an email to security@kernel.org from xzou017@ucr.edu account on 
May 20, the title is "KASAN: use-after-free Read in hci_chan_del has 
dangerous security impact".
> Is that really the reason why syzbot-reported problems are not being
> fixed?  Just because we don't know which ones are more "important"?
>
> As someone who has been managing many interns for a year or so working
> on these, I do not think that is the problem, but hey, what do I know...

Perhaps we misunderstood the problem of syzbot-generated bugs. Our 
understanding is that if a syzbot-generated bug is exploited in the wild 
and/or the exploit code is made publicly available somehow, then the bug 
will be fixed in a prioritized fashion. If our understanding is correct, 
wouldn't it be nice if we, as good guys, can figure out which bugs are 
security-critical and patch them before the bad guys exploit them.

On 05/06/2021 00:43, Greg KH wrote:
> On Fri, Jun 04, 2021 at 10:11:03AM -0700, SyzScope wrote:
>> Hi Greg,
>>
>>> Who is working on and doing this "reseach project"?
>> We are a group of researchers from University of California, Riverside (we
>> introduced ourselves in an earlier email to security@kernel.org if you
>> recall).
> I do not recall that, sorry, when was that?
>
>>   Please allow us to articulate the goal of our research. We'd be
>> happy to hear your feedback and suggestions.
>>
>>> And what is it
>>> doing to actually fix the issues that syzbot finds?  Seems like that
>>> would be a better solution instead of just trying to send emails saying,
>>> in short "why isn't this reported issue fixed yet?"
>>  From our limited understanding, we know a key problem with syzbot bugs is
>> that there are too many of them - more than what can be handled by
>> developers and maintainers. Therefore, it seems some form of prioritization
>> on bug fixing would be helpful. The goal of the SyzScope project is to
>> *automatically* analyze the security impact of syzbot bugs, which helps with
>> prioritizing bug fixes. In other words, when a syzbot bug is reported, we
>> aim to attach a corresponding security impact "signal" to help developers
>> make an informed decision on which ones to fix first.
> Is that really the reason why syzbot-reported problems are not being
> fixed?  Just because we don't know which ones are more "important"?
>
> As someone who has been managing many interns for a year or so working
> on these, I do not think that is the problem, but hey, what do I know...
>
>> Currently,  SyzScope is a standalone prototype system that we plan to open
>> source. We hope to keep developing it to make it more and more useful and
>> have it eventually integrated into syzbot (we are in talks with Dmitry).
>>
>> We are happy to talk more offline (perhaps even in a zoom meeting if you
>> would like). Thanks in advance for any feedback and suggestions you may
>> have.
> Meetings are not really how kernel development works, sorry.
>
> At the moment, these emails really do not seem all that useful, trying
> to tell other people what to do does not get you very far when dealing
> with people who you have no "authority" over...
>
> Technical solutions to human issues almost never work, however writing a
> procmail filter to keep me from having to see these will work quite well :)
>
> good luck!
>
> greg k-h
