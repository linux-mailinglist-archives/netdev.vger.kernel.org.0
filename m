Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E6C457EC3
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 15:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237436AbhKTOxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 09:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhKTOxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 09:53:07 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CCBC061574;
        Sat, 20 Nov 2021 06:50:03 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id f18so57675853lfv.6;
        Sat, 20 Nov 2021 06:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=aKZ+0OYiRnOnNd4aFqwWtkVmyRcu68P7dxg8Zg/14oQ=;
        b=Wl578gfmIq31wrLHuwlEP3AS3M+5jFumfAZ5C/YSC1HEmxILBrE1EzCzYluZEVQTNF
         uLQu3tftOA0yEgkiPVRJBQIFvRCJw/tVlRA5K7U8lyoKc3r4DvtdLDOttoMe7rfluFZC
         DGBoNAbQiftyxZItuwX+Cgh20eWxCImlguqitHx90orqS8Z9qO3bADSzkZrGiUKKBYBb
         x4azkh5rqzhB79Nj5klO/vrewn3LP6LensucO6ENoVRzDwYBbLdR0kg/iHrHphROT8gq
         L6s3KlZ2QO1dYmEnQmS/3ccd3f12fh6aj+D5Iu36paQHq5RDoAUPN/MKxYL1yzRE8OOT
         3jhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aKZ+0OYiRnOnNd4aFqwWtkVmyRcu68P7dxg8Zg/14oQ=;
        b=1PGqhxQMt1qQCANWpLsfYwnoqDDGOlbw+PP95p1f+m0WrSdfwkprsbfkBljFB4ikXQ
         FPskNELRDx6vxo2ARl1C6AQMFMlD4NYEcjsSkt+Fb9mg20TidhGF40qdCtchGu5KyiZD
         9JZsUdcLqhQP2Mxnj0sjI2X9quYHQAxl9gvCrtc/T8G+XF3a3GCCFwvGkHOBNW54hQ74
         gVzlz+2M+CH6irQEjXAeee4eca/OFliEAg74IGh19DfMR4uqeLnuVim1IXnDG2QqVD5B
         qA5tswLX7KrHu+YSvf7xU1zqTqiQbzguwGEyKCSIy53BvrL6rKinK28/iem5BrlZyaHv
         pX1A==
X-Gm-Message-State: AOAM53286R37qIefXCXWyejRwLznL1iGqb5ucW9QFetsjw+29fLk7vKh
        r6/ZmEHorpCe5lsyFfuHGTE=
X-Google-Smtp-Source: ABdhPJyVFMTBU+k6GbmZ7cX2Z0v1tXlI0bSdGO41H6JxjwqV0k6O0/oKpSq/tSWu5BAomtKLofhJoA==
X-Received: by 2002:a05:6512:3c8:: with SMTP id w8mr40005895lfp.531.1637419801852;
        Sat, 20 Nov 2021 06:50:01 -0800 (PST)
Received: from [192.168.1.11] ([217.117.245.63])
        by smtp.gmail.com with ESMTPSA id z23sm239523ljk.136.2021.11.20.06.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Nov 2021 06:50:01 -0800 (PST)
Message-ID: <00588759-589d-3101-cc87-c0c327fb1c41@gmail.com>
Date:   Sat, 20 Nov 2021 17:50:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [syzbot] possible deadlock in smc_switch_to_fallback
Content-Language: en-US
To:     syzbot <syzbot+e979d3597f48262cb4ee@syzkaller.appspotmail.com>,
        davem@davemloft.net, kgraul@linux.ibm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000003c221105d12f69e3@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <0000000000003c221105d12f69e3@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/21 05:47, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9539ba4308ad Merge tag 'riscv-for-linus-5.16-rc2' of git:/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17f79d01b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6d3b8fd1977c1e73
> dashboard link: https://syzkaller.appspot.com/bug?extid=e979d3597f48262cb4ee
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e979d3597f48262cb4ee@syzkaller.appspotmail.com
> 
> ============================================
> WARNING: possible recursive locking detected
> 5.16.0-rc1-syzkaller #0 Not tainted
> --------------------------------------------
> syz-executor.3/1337 is trying to acquire lock:
> ffff88809466ce58 (&ei->socket.wq.wait){..-.}-{2:2}, at: spin_lock include/linux/spinlock.h:349 [inline]
> ffff88809466ce58 (&ei->socket.wq.wait){..-.}-{2:2}, at: smc_switch_to_fallback+0x3d5/0x8c0 net/smc/af_smc.c:588
>  > but task is already holding lock:
> ffff88809466c258 (&ei->socket.wq.wait){..-.}-{2:2}, at: smc_switch_to_fallback+0x3ca/0x8c0 net/smc/af_smc.c:587
>  > other info that might help us debug this:
>   Possible unsafe locking scenario:
> 
>         CPU0
>         ----
>    lock(&ei->socket.wq.wait);
>    lock(&ei->socket.wq.wait);
> 

There is simple code block in net/smc/af_smc.c:

		spin_lock_irqsave(&smc_wait->lock, flags);
		spin_lock(&clc_wait->lock);
		list_splice_init(&smc_wait->head, &clc_wait->head);
		spin_unlock(&clc_wait->lock);
		spin_unlock_irqrestore(&smc_wait->lock, flags);

smc_wait and clc_wait are too different pointers (based on report), but 
these 2 different wait_queue locks registered to lockdep map via 
sock_alloc_inode(), where init_waitqueue_head(&ei->socket.wq.wait); is 
called. So any nested wait_queue_head_t locking will cause lockdep warning.

Have no idea how to handle it, just my thoughts about root case :)





With regards,
Pavel Skripkin
