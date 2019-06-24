Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F40C50A6B
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 14:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfFXMIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 08:08:55 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40138 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfFXMIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 08:08:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id p11so13618551wre.7;
        Mon, 24 Jun 2019 05:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5+aG5bq4j8Ni9WJIPjG3wZ6NCgkPpGLe+UT0IyDMSL8=;
        b=M6E+fHAO/OiuGltg7eEHZPSq39J8E/PaoVFAlIKxs45osAuntq/gRSm5kymGZNCKjf
         0npcBSzhSmXFn/pm+aJh/8Mrl2PNCi+O0nighTE3R6Jx5pmGgpZe/xlQdHegfeVJwU9f
         LxnvuVaac71JQ1h5S8dkbrgOcbzPQeRKz+62HGoegBsEL/DoxuGWZUCpAWrPvCLgpCms
         ExRvVMb/flNXOYKHN0t5U5VSezYhkQ/NdwO4j8R5HOgBG+ZWzF56I/ZQy+v4FPM5YB3L
         8pWT9W11xmozp9lijIY8nP0i28GmsLp5lnjGCgBifpTdNE/a8ytcy9Boa4xgaWmk9Gb3
         g8SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5+aG5bq4j8Ni9WJIPjG3wZ6NCgkPpGLe+UT0IyDMSL8=;
        b=KomqYkiWU97akYgnqx1XK5H36E9u2uBkLLNLaWG5AEI/qO0WH2hkYp2/eEP4+2vopo
         PjROTWF2lfbVV6PexU722SMA6SpSH2ZPsleDh5bAEZAFZQlGgnqwnQ+3foZbdqwrnbvd
         9c453lCtUbGFLDIdy2tVN1fbeIik2DFb8ZomEEdLMKN35QAHuf/9Dyqxw6GUjWBChL4C
         rbEoFUr2ENInORiFMsEu3QuI6juGwisr9Pncs9rolPeQqZuR/hjejuzCI+F6eBUIb3t1
         H9k7X7P3ZKWi7JdRtOxa//ATeMnFPpDDUcL+IjBzgtprqL8/pODkaBuvGK/LSDO3C4ax
         JR8w==
X-Gm-Message-State: APjAAAVpWOjvCNUGk2k1CjChcW7UO7qsamcfe7iKtke3lBDJWu54o3Rb
        fh4A9Cb+yT03wLj6sCk52nE=
X-Google-Smtp-Source: APXvYqzPp23jbUf1aCFuoTjxkcr/57v3+kKSkmgp0cCJV8ep/XXuci3uBEj4W49UP8ozk7T/YuSUGg==
X-Received: by 2002:a5d:554b:: with SMTP id g11mr631289wrw.10.1561378132293;
        Mon, 24 Jun 2019 05:08:52 -0700 (PDT)
Received: from [192.168.8.147] (59.249.23.93.rev.sfr.net. [93.23.249.59])
        by smtp.gmail.com with ESMTPSA id z76sm14489260wmc.16.2019.06.24.05.08.49
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 05:08:51 -0700 (PDT)
Subject: Re: WARNING: ODEBUG bug in netdev_freemem (2)
To:     Dmitry Vyukov <dvyukov@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     syzbot <syzbot+c4521ac872a4ccc3afec@syzkaller.appspotmail.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        amritha.nambiar@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ido Schimmel <idosch@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tyhicks@canonical.com, wanghai26@huawei.com, yuehaibing@huawei.com
References: <000000000000d6a8ba058c0df076@google.com>
 <alpine.DEB.2.21.1906241130100.32342@nanos.tec.linutronix.de>
 <CACT4Y+Y_TadXGE_CVFa4fKqrbpAD4i5WGem9StgoyP_YAVraXw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <da83da44-0088-3056-6bba-d028b6cbb218@gmail.com>
Date:   Mon, 24 Jun 2019 14:08:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CACT4Y+Y_TadXGE_CVFa4fKqrbpAD4i5WGem9StgoyP_YAVraXw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/19 3:54 AM, Dmitry Vyukov wrote:
> On Mon, Jun 24, 2019 at 11:34 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> On Mon, 24 Jun 2019, syzbot wrote:
>>
>>> Hello,
>>>
>>> syzbot found the following crash on:
>>>
>>> HEAD commit:    fd6b99fa Merge branch 'akpm' (patches from Andrew)
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=144de256a00000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=fa9f7e1b6a8bb586
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=c4521ac872a4ccc3afec
>>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>>
>>> Unfortunately, I don't have any reproducer for this crash yet.
>>>
>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>> Reported-by: syzbot+c4521ac872a4ccc3afec@syzkaller.appspotmail.com
>>>
>>> device hsr_slave_0 left promiscuous mode
>>> team0 (unregistering): Port device team_slave_1 removed
>>> team0 (unregistering): Port device team_slave_0 removed
>>> bond0 (unregistering): Releasing backup interface bond_slave_1
>>> bond0 (unregistering): Releasing backup interface bond_slave_0
>>> bond0 (unregistering): Released all slaves
>>> ------------[ cut here ]------------
>>> ODEBUG: free active (active state 0) object type: timer_list hint:
>>> delayed_work_timer_fn+0x0/0x90 arch/x86/include/asm/paravirt.h:767
>>
>> One of the cleaned up devices has left an active timer which belongs to a
>> delayed work. That's all I can decode out of that splat. :(
> 
> Hi Thomas,
> 
> If ODEBUG would memorize full stack traces for object allocation
> (using lib/stackdepot.c), it would make this splat actionable, right?
> I've fixed https://bugzilla.kernel.org/show_bug.cgi?id=203969 for this.
> 

Not sure this would help in this case as some netdev are allocated through a generic helper.

The driver specific portion might not show up in the stack trace.

It would be nice here to get the work queue function pointer,
so that it gives us a clue which driver needs a fix.



