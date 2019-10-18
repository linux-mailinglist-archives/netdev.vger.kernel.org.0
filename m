Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 279A0DC77F
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393897AbfJROhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:37:43 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45071 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389378AbfJROhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:37:42 -0400
Received: by mail-pg1-f195.google.com with SMTP id r1so3476478pgj.12
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 07:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FZFKjNas5im/hGi/Vyul2YDjZ3cKsj+DpRyrRQrG0vA=;
        b=v3xOPITZ2m2R8/MWnfbG3rNxc/E1SXrHPaKvr9n42g0eVHn9aqEdJnKCDi9UJ+WI5u
         OxWRdcAOW4wLMIq9yENn6RYgMHWdf+AkcOXcvCU/ytJJBTjyUXR5HUMjh2765HOQUzMr
         hyN6reqhdxbFeXqFSrFza59xzzFYA7qQ/CEceffK3GZwNW/iO3ATQL4Yg0E9Y01tPW60
         qsI06tzRe+OCzHvsq66iScY8CZvZurxACiYi0XGpvhYG3vbh0hecw32XgU0o01S7yxZh
         PNCc5XgHubOLlL4XqB0ZFcJkanLMidDaSNx/aYLEhzL1BNExQWZCqrke5s6De02AiyU0
         sh4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FZFKjNas5im/hGi/Vyul2YDjZ3cKsj+DpRyrRQrG0vA=;
        b=c1QNtMCpPkrqbGPR3tPZoyRqK39XAKpF9uLwSU90/ZTGFGOIry8QtwQJXaOUcE7ypx
         fge4mbSAfVXI3g4GxMMsq9ze/PmTmTojB2MyUt0cBmuDhk49SaTyuQD0pStMbq5S0YZz
         oBrVxei6KSM6jRtzArI9JXPt6I6pqpgT3+ZkL43uL4AV9oHDkcbeIXJjseqkodcjLgyA
         8H/bichB/zGjLh4U0BFudLs/aaAYu62k/JD9nByA4c/l9B9x5NAxGeawUpuniuDxSk7V
         l8XlYaH/071b/GwIWGqMYX2O8LPXhaGFI+1QUAc0EUfpu2qS8X+LqDyLILB5cKr6f/4U
         /u+Q==
X-Gm-Message-State: APjAAAW4D2vSmkusd+Fz1pRekrkXOv+E9ZVWdkjP3dK8k8wiC20ybUY8
        tuCykKtGlUVzFTtvLOLOHMeXz2miSQTSEg==
X-Google-Smtp-Source: APXvYqwVxFQed8WDQwPsmyP5UChFG2awvfIYonA90kgYQMb14rR68QUhw87fih9E/STg/OisMJXeEg==
X-Received: by 2002:a62:b419:: with SMTP id h25mr6544pfn.52.1571409461652;
        Fri, 18 Oct 2019 07:37:41 -0700 (PDT)
Received: from ?IPv6:2620:10d:c081:1131::1120? ([2620:10d:c090:180::e16a])
        by smtp.gmail.com with ESMTPSA id m4sm6009462pjs.8.2019.10.18.07.37.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 07:37:40 -0700 (PDT)
Subject: Re: [PATCH 1/3] io_uring: add support for async work inheriting files
 table
To:     Jann Horn <jannh@google.com>
Cc:     linux-block@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20191017212858.13230-1-axboe@kernel.dk>
 <20191017212858.13230-2-axboe@kernel.dk>
 <CAG48ez0G2y0JS9=S2KmePO3xq-5DuzgovrLFiX4TJL-G897LCA@mail.gmail.com>
 <0fb9d9a0-6251-c4bd-71b0-6e34c6a1aab8@kernel.dk>
 <CAG48ez181=JoYudXee0KbU0vDZ=EbxmgB7q0mmjaA0gyp6MFBQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a54329d5-a128-3ccd-7a12-f6cadaa20dbf@kernel.dk>
Date:   Fri, 18 Oct 2019 08:37:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez181=JoYudXee0KbU0vDZ=EbxmgB7q0mmjaA0gyp6MFBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/19 8:34 AM, Jann Horn wrote:
> On Fri, Oct 18, 2019 at 4:01 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/17/19 8:41 PM, Jann Horn wrote:
>>> On Fri, Oct 18, 2019 at 4:01 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>> This is in preparation for adding opcodes that need to modify files
>>>> in a process file table, either adding new ones or closing old ones.
> [...]
>> Updated patch1:
>>
>> http://git.kernel.dk/cgit/linux-block/commit/?h=for-5.5/io_uring-test&id=df6caac708dae8ee9a74c9016e479b02ad78d436
> 
> I don't understand what you're doing with old_files in there. In the
> "s->files && !old_files" branch, "current->files = s->files" happens
> without holding task_lock(), but current->files and s->files are also
> the same already at that point anyway. And what's the intent behind
> assigning stuff to old_files inside the loop? Isn't that going to
> cause the workqueue to keep a modified current->files beyond the
> runtime of the work?

I simply forgot to remove the old block, it should only have this one:

if (s->files && s->files != cur_files) {                        
        task_lock(current);                                     
        current->files = s->files;                              
        task_unlock(current);                                   
        if (cur_files)                                          
                put_files_struct(cur_files);                    
        cur_files = s->files;                                   
}

-- 
Jens Axboe

