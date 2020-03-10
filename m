Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B154180942
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 21:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgCJUgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 16:36:08 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46502 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgCJUgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 16:36:07 -0400
Received: by mail-pf1-f193.google.com with SMTP id c19so4744072pfo.13;
        Tue, 10 Mar 2020 13:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fV5+RiKGHa+0tysZC6eRzTKR3e7KC+kQ8EcrhIyapM4=;
        b=VQBmIGLVfJEfJVQJSU078Gto/o5LJlmAF9oHI5o4vgeCX2gK3rjNvsQ1G9T2Z1A0fJ
         44UNjuBSDZjCBlp4WNS0wZSWBvvB3xV8Dfwlzruf9cSSohEWhRHmyY6Aw5o+XLtZVKDJ
         4jMU//lqJQSW/Nsb1mwVLk0XWPx5Ev0INwttHJ6yMmjMsLXGdFPussXrjMtIywAvG7ta
         Kfd37IYbD+1pbG4fDXTtblgcm6QfzHcZo9/K4NPBeYkPix8hTzLdlYA/8b3Mu78hlWcQ
         uINtxglfZKNMO0SVDVI0Bg5EO26lf6dqW7I7zA0N7Pu9EwPd/2ipCagrcIMqb45VcXsY
         ZggQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fV5+RiKGHa+0tysZC6eRzTKR3e7KC+kQ8EcrhIyapM4=;
        b=Ib1VEIcWzSfyj6Dix0C8JdVtDkaQOSWfBflGdQSmogfAPw0C+xVxDwjWmKb0hPnFwO
         364DVoOpbBRX5ynZpZ+DiBuAwNgpofdwr0eSeeeupDNq/1yg/arMydS1Fl5OVqrnKBrB
         KP2nNvcRweT4QKZiy/SOpHWyOlkLEueLaGHw8RnrVfoPy0k0AVxqD6/xJ9rCYvCFUj0/
         QRIjcYih01iTYbMHQuCy0nARvWqjWbcXx80YtR47oARIg1EBzeK7Fdzp9qWDh10DTtTk
         UtvsATjOERTytVAdhQI5DFxUsQKqhPclZDx6OqAmkGkxGEFbMNGgg+QZg0LObHupydWz
         nlVQ==
X-Gm-Message-State: ANhLgQ1jrHgL65iU8xcSRZiFDO8H/sl/RqBJkr7JiBnVLCDKEYVZ9M/N
        Q9lm/psUNYGBYahZp4UJq8Y=
X-Google-Smtp-Source: ADFU+vteDYFDTXUuR514tIcr2qrQXOj/kIC1OkMBZwy0pVRATabXWRso4IHATHfKlZU5qbO2kbRpXg==
X-Received: by 2002:a62:760e:: with SMTP id r14mr16229814pfc.51.1583872565275;
        Tue, 10 Mar 2020 13:36:05 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id m128sm49687689pfm.183.2020.03.10.13.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 13:36:04 -0700 (PDT)
Subject: Re: KASAN: invalid-free in tcf_exts_destroy
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <00000000000034513e05a05cfc23@google.com>
 <CAM_iQpVgQ+Mc16CVds-ywp6YHEbwbGtJwqoQXBFbrMTOUZS0YQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <635ab023-d180-7ddf-a280-78080040512c@gmail.com>
Date:   Tue, 10 Mar 2020 13:36:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVgQ+Mc16CVds-ywp6YHEbwbGtJwqoQXBFbrMTOUZS0YQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/20 11:33 AM, Cong Wang wrote:
> On Sun, Mar 8, 2020 at 12:35 PM syzbot
> <syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    c2003765 Merge tag 'io_uring-5.6-2020-03-07' of git://git...
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=10cd2ae3e00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=4527d1e2fb19fd5c
>> dashboard link: https://syzkaller.appspot.com/bug?extid=dcc34d54d68ef7d2d53d
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> userspace arch: i386
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1561b01de00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15aad2f9e00000
>>
>> The bug was bisected to:
>>
>> commit 599be01ee567b61f4471ee8078870847d0a11e8e
>> Author: Cong Wang <xiyou.wangcong@gmail.com>
>> Date:   Mon Feb 3 05:14:35 2020 +0000
>>
>>     net_sched: fix an OOB access in cls_tcindex
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10a275fde00000
>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=12a275fde00000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=14a275fde00000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com
>> Fixes: 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")
>>
>> IPVS: ftp: loaded support on port[0] = 21
>> ==================================================================
>> BUG: KASAN: double-free or invalid-free in tcf_exts_destroy+0x62/0xc0 net/sched/cls_api.c:3002
>>
>> CPU: 1 PID: 9507 Comm: syz-executor467 Not tainted 5.6.0-rc4-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:77 [inline]
>>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>>  print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:374
>>  kasan_report_invalid_free+0x61/0xa0 mm/kasan/report.c:468
>>  __kasan_slab_free+0x129/0x140 mm/kasan/common.c:455
>>  __cache_free mm/slab.c:3426 [inline]
>>  kfree+0x109/0x2b0 mm/slab.c:3757
>>  tcf_exts_destroy+0x62/0xc0 net/sched/cls_api.c:3002
>>  tcf_exts_change+0xf4/0x150 net/sched/cls_api.c:3059
>>  tcindex_set_parms+0xed8/0x1a00 net/sched/cls_tcindex.c:456
> 
> Looks like a consequence of "slab-out-of-bounds Write in tcindex_set_parms".
> 
> Thanks.
> 

I have a dozen more syzbot reports involving net/sched code, do you want
me to release them right now ?

