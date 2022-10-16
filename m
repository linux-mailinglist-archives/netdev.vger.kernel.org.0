Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAD75FFD39
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 06:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiJPELl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 00:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiJPELj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 00:11:39 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5912F64F
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 21:11:38 -0700 (PDT)
Received: from fsav412.sakura.ne.jp (fsav412.sakura.ne.jp [133.242.250.111])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 29G4AJdC027641;
        Sun, 16 Oct 2022 13:10:19 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav412.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp);
 Sun, 16 Oct 2022 13:10:19 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 29G4AIH2027636
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 16 Oct 2022 13:10:18 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <80a12dd3-dae4-ccc7-e277-b2fd2cba78e2@I-love.SAKURA.ne.jp>
Date:   Sun, 16 Oct 2022 13:10:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [syzbot] WARNING in c_start
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        syzbot <syzbot+d0fd2bf0dd6da72496dd@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com,
        Andrew Jones <ajones@ventanamicro.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com, linux-kernel@vger.kernel.org
References: <0000000000007647ec05eb05249c@google.com>
 <Y0nTd9HSnnt/KDap@zn.tnic>
 <2eaf1386-8ab0-bd65-acee-e29f1c5a6623@I-love.SAKURA.ne.jp>
 <Y0qfLyhSoTodAdxu@zn.tnic> <Y0sbwpRcipI564yp@yury-laptop>
 <23488f06-c4b4-8bd8-b0bc-85914ba4d1c6@I-love.SAKURA.ne.jp>
 <Y0tafD7qI2x5xzTc@yury-laptop>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <Y0tafD7qI2x5xzTc@yury-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/10/16 10:12, Yury Norov wrote:
> On Sun, Oct 16, 2022 at 09:24:57AM +0900, Tetsuo Handa wrote:
>> I'm asking you not to use BUG_ON()/WARN_ON() etc. which breaks syzkaller.
> 
> It's not me who added WARN_ON() in the cpumask_check(). You're asking
> a wrong person. 

Because you broke the kernel testing. It was obvious that passing "cpu + 1"
instead of "cpu" will trivially hit cpu == nr_cpumask_bits condition.
If your patch were reviewed and tested, we would not have done this discussion.

> 
> What for do we have WARN_ON(), if we can't use it?

WARN_ON() could be used which should not happen.
But cpu == nr_cpumask_bits condition shall happen in your patch.

RCs are not for fixing bugs that causes boot failures. Such bugs
should have been tested and fixed before patches are sent to linux.git .

> 
>> Just printing messages (without "BUG:"/"WARNING:" string which also breaks
>> syzkaller) like below diff is sufficient for people to realize that they're
>> doing something wrong.
>>
>> Again, please do revert "cpumask: fix checking valid cpu range" immediately.
> 
> The revert is already in Jakub's batch for -rc2, AFAIK.

OK.

