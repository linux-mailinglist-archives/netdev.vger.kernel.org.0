Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCE843CEB6
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239347AbhJ0Q21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:28:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239297AbhJ0Q20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 12:28:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635351960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z/Y6Y4Q6GIPOPylGz9rQN8XoIPlqV9Q9ShHOXlxCR0A=;
        b=DB54l3j71ePXSH9VgMLP2RZ7hUNQyzAaDSssj38h+9Hl/X5X+jni04xr1m9OrII9qsyf+p
        WW9qvF2AFfmZu01Ih/Rc+Xp9jYyjdKxHwzYlyya5RCnfTrfLqHDV/uSur83Duih+XIh9bC
        RnlrUBwmRJVVNs5nuVWKJYKq3sefmUo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-G9qqhkPVPeat-lFMRTiz5A-1; Wed, 27 Oct 2021 12:25:59 -0400
X-MC-Unique: G9qqhkPVPeat-lFMRTiz5A-1
Received: by mail-wm1-f72.google.com with SMTP id y65-20020a1c7d44000000b0032cd2b01225so715724wmc.0
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 09:25:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=z/Y6Y4Q6GIPOPylGz9rQN8XoIPlqV9Q9ShHOXlxCR0A=;
        b=zjHnY2HmJMmXqVuoiJwVMWIQkQdwaSTT3z1MNYnHjQF7iGg1dGzySsGi1JrY/lGD+U
         hYZUvsqv0mXU+arsIGJ50Vx7bxncvtGTa/WK0iVKCvD7qRGEZIElYqZNZE5QpDWMUbvf
         o82oqsnOkIVXsXTgnlK9cTw2i3S/Ix4I0LsPYkmGgU/GERL3FKn0pH6lq5qfQZ1JdL1e
         vqI+bmwoINVuJ1MwPAWHo0L14kMQvhStStGzeS3y6kddnjwqfSRE7ULPJQdLhG03Nx2D
         VU0SYuA4OAcm2HAXSnfYNc+dInkYTibAucjQ3LnZtcAwKzf8KAmUOV9t7tp3keTIM1ax
         OUWQ==
X-Gm-Message-State: AOAM532eGL21H+ocadeCsmMOewjuRNrZdvOEV+A6CS247FeQ6qpflyuD
        cd1+ZGIOIdG6aWx56ZBEfFHFi7zrROtmk7vcaGDP8++oqbrHzh3DnGL5lscMyavIrh1wFy0oqxR
        dSGOs5WnVK1DZC5vF
X-Received: by 2002:a5d:47a3:: with SMTP id 3mr28992993wrb.336.1635351957421;
        Wed, 27 Oct 2021 09:25:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsZpShVS8z4jeZCnUbx0hIbA5QO9JtAw7d4XS7O11tFXTam31Tg6xceWM7upXkhz7c+hDgJg==
X-Received: by 2002:a5d:47a3:: with SMTP id 3mr28992960wrb.336.1635351957172;
        Wed, 27 Oct 2021 09:25:57 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.14.190])
        by smtp.gmail.com with ESMTPSA id n7sm334197wra.37.2021.10.27.09.25.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 09:25:56 -0700 (PDT)
Message-ID: <589f86e0-af0e-c172-7ec6-72148ba7b3b0@redhat.com>
Date:   Wed, 27 Oct 2021 18:25:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in copy_data
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au, jiri@nvidia.com,
        kuba@kernel.org, leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000a4cd2105cf441e76@google.com>
 <eab57f0e-d3c6-7619-97cc-9bc3a7a07219@redhat.com>
 <CACT4Y+amyT9dk-6iVqru-wQnotmwW=bt4VwaysgzjH9=PkxGww@mail.gmail.com>
 <20211027111300-mutt-send-email-mst@kernel.org>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20211027111300-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 17:28, Michael S. Tsirkin wrote:
> On Wed, Oct 27, 2021 at 03:36:19PM +0200, Dmitry Vyukov wrote:
>> On Wed, 27 Oct 2021 at 15:11, Laurent Vivier <lvivier@redhat.com> wrote:
>>>
>>> On 26/10/2021 18:39, syzbot wrote:
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    9ae1fbdeabd3 Add linux-next specific files for 20211025
>>>> git tree:       linux-next
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1331363cb00000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=aeb17e42bc109064
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=b86736b5935e0d25b446
>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116ce954b00000
>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132fcf62b00000
>>>>
>>>> The issue was bisected to:
>>>>
>>>> commit 22849b5ea5952d853547cc5e0651f34a246b2a4f
>>>> Author: Leon Romanovsky <leonro@nvidia.com>
>>>> Date:   Thu Oct 21 14:16:14 2021 +0000
>>>>
>>>>       devlink: Remove not-executed trap policer notifications
>>>>
>>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137d8bfcb00000
>>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10fd8bfcb00000
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=177d8bfcb00000
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com
>>>> Fixes: 22849b5ea595 ("devlink: Remove not-executed trap policer notifications")
>>>>
>>>> ==================================================================
>>>> BUG: KASAN: slab-out-of-bounds in memcpy include/linux/fortify-string.h:225 [inline]
>>>> BUG: KASAN: slab-out-of-bounds in copy_data+0xf3/0x2e0 drivers/char/hw_random/virtio-rng.c:68
>>>> Read of size 64 at addr ffff88801a7a1580 by task syz-executor989/6542
>>>>
>>>
>>> I'm not able to reproduce the problem with next-20211026 and the C reproducer.
>>>
>>> And reviewing the code in copy_data() I don't see any issue.
>>>
>>> Is it possible to know what it the VM configuration used to test it?
>>
>> Hi Laurent,
>>
>> syzbot used e2-standard-2 GCE VM when that happened.
>> You can see some info about these VMs under the "VM info" link on the dashboard.
> 
> Could you pls confirm whether reverting
> caaf2874ba27b92bca6f0298bf88bad94067ec37 addresses this?
> 

I've restarted the syzbot on top of "hwrng: virtio - don't wait on cleanup" [1] and the 
problem has not been triggered.

See https://syzkaller.appspot.com/bug?extid=b86736b5935e0d25b446

Thanks,
Laurent

[1]
d721abbeb145 hwrng: virtio - don't wait on cleanup
bb768beb0a5f hwrng: virtio - add an internal buffer
d25f27432f80 (origin/master, origin/HEAD, master) Merge tag 'arm-soc-fixes-5.15-3' of 
git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc

