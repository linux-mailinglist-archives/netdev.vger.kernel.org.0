Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52A33EFFA7
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhHRI4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 04:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbhHRIz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 04:55:59 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14241C061764;
        Wed, 18 Aug 2021 01:55:23 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id x7so3708667ljn.10;
        Wed, 18 Aug 2021 01:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PyuHTiYtcp7PenUOgX16JRdXO479FYx66sP5cfTDtJ8=;
        b=bFhAKTFYhRq6nSBU53V7nBfYhXxkjiAhCqJps2SBtRGMCJIXp+7lU6McxX8loQ6meE
         fSG/FM3TmRbrP/b8JPftQvirvT0vqmE8IBifTejnoi6fVmyDgoVZJi0A2nL7TEJ5ep6U
         o2VSz0DNti8zycJniW8NTFPj0oSHwn9/KbdCQon5p3dgkjGpfZjfSf9d8VaQbCgzW7AF
         xcA2d+ms1Dm0JAK5Ztk4Qxii2GLc9+YyZSyRDLbM8q8GIfUWYUD2PlJCGYGdRSa9U/SY
         wlL63UXYJiyw80MiPemF3cVUtFHjQpfvfBbn2auULEHwWpm/C6cbpNM1CHQtc6q3bxgN
         f9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PyuHTiYtcp7PenUOgX16JRdXO479FYx66sP5cfTDtJ8=;
        b=BlTUqSkQpk/9Fc47ea6C798OCLe1seYD/jZuiUYoaIcewbU9eVq+YKfq8kf29xRcNE
         JphiwLv128X5VInOYG/JrVTe10GQI4cTRpAYCJrmV+5k1pq138UDMOcg13YiufutSwOA
         1Q0GyJVa7ZFRf8SL7xFbYVTE6STzm3iAwb7/1d7MW6PpxMisiViO9xOubqbjmmjsGs6L
         oOudwkfap5IAyMvJPpevV7J8S+M+z/B/bUZEcmOSrDTX8lS/IoruXQRGCg7wNtS4wIeK
         3OfjpnB/SqFODHYvHJ3D6sKqDmMlc3bgYQ6qy757FW1qJs/FLyoQhP47p1o88C9w2tA+
         6XFg==
X-Gm-Message-State: AOAM532llg9xnFPxgXrmwrkGueuvVGythGXIiMGeW7xcPGt2ghsBjfly
        Iuu5pqG0kN2Qxo0SqjYdM6g=
X-Google-Smtp-Source: ABdhPJzBpe3DARPr+h0Pu2Yu7QwdF+94FYfIVaP5pXL2ykMkVckZmxUEm9OoslOsTrhEkgEvNsI3Fg==
X-Received: by 2002:a2e:b611:: with SMTP id r17mr7101788ljn.10.1629276921412;
        Wed, 18 Aug 2021 01:55:21 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id g5sm432730lfe.174.2021.08.18.01.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 01:55:20 -0700 (PDT)
Subject: Re: [syzbot] KFENCE: use-after-free in kvm_fastop_exception
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        syzbot <syzbot+7b938780d5deeaaf938f@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, mathew.j.martineau@linux.intel.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <00000000000012030e05c9c8bc85@google.com>
 <58cef9e0-69de-efdb-4035-7c1ed3d23132@tessares.net>
 <6736a510-20a1-9fb5-caf4-86334cabbbb6@gmail.com>
 <32aeb66e-d4f0-26b5-a140-4477bb87067f@tessares.net>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <3a8dd8db-61d6-603e-b270-5faf1be02c6b@gmail.com>
Date:   Wed, 18 Aug 2021 11:55:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <32aeb66e-d4f0-26b5-a140-4477bb87067f@tessares.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/21 11:21 AM, Matthieu Baerts wrote:
> Hi Pavel,
> 
[snip]
>>>
>>> I'm pretty sure the commit c4512c63b119 ("mptcp: fix 'masking a bool'
>>> warning") doesn't introduce the reported bug. This minor fix is specific
>>> to MPTCP which doesn't seem to be used here.
>>>
>>> I'm not sure how I can tell syzbot this is a false positive.
>>>
>> 
>> 
>> looks like it's fs/namei bug. Similar reports:
>> 
>> https://syzkaller.appspot.com/bug?id=517fa734b92b7db404c409b924cf5c997640e324
>> 
>> 
>> https://syzkaller.appspot.com/bug?id=484483daf3652b40dae18531923aa9175d392a4d
> 
> Thank you for having checked!
> Should we mark them as "#syz dup" if you think they have the same root
> cause?
> 

I think, yes, but I want to receive feedback from fs people about this 
bug. There were huge updates last month, and, maybe, I am missing some 
details. Alloc/free calltrace is the same, but anyway, I want some 
confirmation to not close different bugs by mistake :)

If these bugs really have same root case I will close them manually 
after fix posted.

>> It's not false positive. I've suggested the fix here:
>> https://groups.google.com/g/syzkaller-bugs/c/HE3c2fP5nic/m/1Yk17GBeAwAJ
>> I am waiting for author comments about the fix :)
>> 
>> But, yes, syzbot bisection is often wrong, so don't rely on it much :)
> 
> Yes sorry, I wanted to say the bisection picked a wrong commit :)
> 
> All good then if syzbot often blames the wrong modification :)
> 
With regards,
Pavel Skripkin
