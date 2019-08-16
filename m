Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2E6D8F883
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 03:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfHPBmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 21:42:16 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44053 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfHPBmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 21:42:15 -0400
Received: by mail-pl1-f195.google.com with SMTP id t14so1754428plr.11;
        Thu, 15 Aug 2019 18:42:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k8X5XNXRgSXKmO3VOQ8oPM00/03Zvows7zPdkmU9biA=;
        b=aROk4PAog43KKzSzEdNXIcp3J8XNmSZsboReH69vmjAmvV9iOIUp7gP1HxE0zEDFBc
         tHcMZM34wYun1Ez/tcayTB7kqGGCmscVNLzpgRPy09ilN8azrIUaan5qj+ncswGkvBni
         JJmMSD8HRx+NtdYLnYc4vPWW7gmmiHiUfnaRVQDMi418jr8iRkDNNDYDawwXXFYR0hCe
         9zp/sdJMEQG9LmEJrV3SjKnJFV1EHe2yoA7myFmAEpNcmnaWCgvROmKHWPEcyf/JatoH
         TCJ0edsbGZRlrnLH8tS/mCtiS1oDfdOKfN6trXFLF8p2HV7wLlQfYs23H7X+7Io/thZE
         WCqw==
X-Gm-Message-State: APjAAAWLHwf3nItQwelRITWF1Nn3WRbuAsiLOhmpNV+h01pDy5djfnsF
        UsB1X19pHs2O5fQxPArw/AY=
X-Google-Smtp-Source: APXvYqzdthTsvCneximr2FlTgb2rB0Wx9XSMPGr91Bxg4AsokELbkrzvGS5bsSs9hXPUJYzU3Noc1g==
X-Received: by 2002:a17:902:a586:: with SMTP id az6mr6489841plb.298.1565919734407;
        Thu, 15 Aug 2019 18:42:14 -0700 (PDT)
Received: from asus.site (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id x17sm4211846pff.62.2019.08.15.18.42.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2019 18:42:12 -0700 (PDT)
Subject: Re: WARNING in is_bpf_text_address
To:     Will Deacon <will@kernel.org>,
        syzbot <syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dvyukov@google.com,
        hawk@kernel.org, hdanton@sina.com, jakub.kicinski@netronome.com,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, longman@redhat.com, mingo@kernel.org,
        netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        xdp-newbies@vger.kernel.org, yhs@fb.com
References: <00000000000000ac4f058bd50039@google.com>
 <000000000000e56cb0058fcc6c28@google.com>
 <20190815075142.vuza32plqtiuhixx@willie-the-truck>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <456d0da6-3e16-d3fc-ecf6-7abb410bf689@acm.org>
Date:   Thu, 15 Aug 2019 18:39:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815075142.vuza32plqtiuhixx@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/19 12:51 AM, Will Deacon wrote:
> Hi Bart,
> 
> On Sat, Aug 10, 2019 at 05:24:06PM -0700, syzbot wrote:
>> syzbot has found a reproducer for the following crash on:
>>
>> HEAD commit:    451577f3 Merge tag 'kbuild-fixes-v5.3-3' of git://git.kern..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=120850a6600000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=2031e7d221391b8a
>> dashboard link: https://syzkaller.appspot.com/bug?extid=bd3bba6ff3fcea7a6ec6
>> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
>> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=130ffe4a600000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17137d2c600000
>>
>> The bug was bisected to:
>>
>> commit a0b0fd53e1e67639b303b15939b9c653dbe7a8c4
>> Author: Bart Van Assche <bvanassche@acm.org>
>> Date:   Thu Feb 14 23:00:46 2019 +0000
>>
>>      locking/lockdep: Free lock classes that are no longer in use
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152f6a9da00000
>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=172f6a9da00000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=132f6a9da00000
> 
> I know you don't think much to these reports, but please could you have a
> look (even if it's just to declare it a false positive)?

Hi Will,

Had you already noticed the following message?

https://lore.kernel.org/bpf/d76d7a63-7854-e92d-30cb-52546d333ffe@iogearbox.net/

 From that message: "Hey Bart, don't think it's related in any way to 
your commit. I'll allocate some time on working on this issue today, 
thanks!"

Bart.
