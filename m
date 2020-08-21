Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0F724D93D
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 18:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgHUQAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 12:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbgHUQA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 12:00:27 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6053C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 09:00:27 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o21so2349318wmc.0
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 09:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fYmJxiZWMdQOy1fXzh3kYSU/yGBTfQ1oXQXK6Nxh6Ew=;
        b=GTU/6q48hox9aJMTAGDunVmGbBpcmsKYjvy/ohusaD0ircSlB/Qf70HJ+lKmUWIzGK
         Jjn/wdPpC6e8BPoA+JG5bKuw90ddkaGfjRtBptts2FuNmju+FsubZY6eerHAYkfNDqGT
         l/7h94yMx/lrBcbUZu6I/0EOG7+W0fC8rkqEI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fYmJxiZWMdQOy1fXzh3kYSU/yGBTfQ1oXQXK6Nxh6Ew=;
        b=Raa3SKGK6qc2zS9fFB2ciysAcq1s6d0cGcICzuskTZpNnggO7ha8KuQvWRe1cbVicM
         RmZ7WSFvUKllMslZ874q6uUiftY4EPQxwqcGGTvdcOQY9ajGn3zKxcalAu0+WEqYgmh/
         ZW2I8EraKhqzGWYgGHQGS/7Bhox3+RfFQfKRLi7KVlaE9C4VHXGvH5VBVlrQvnCGHysL
         eg22BCUHjVLEXPdW6TTmwv/20pDg/WvZCEyMxMiO5NQyALcEbv/i6prsi1rSOwJi5TNu
         dPpQxtIP6i2HEOP1VmDzQokbfc0J9S7JlEt03/auhupCIakpZJaGZy7ZmnW53dfZV/V5
         KZGQ==
X-Gm-Message-State: AOAM530rXXfiHgSsMyL6FKFxEzHs5aKIWXyR5AVSgkrxgd2f09UQKWUW
        dzOzBvPm3c81rie3UqUaGiVULg==
X-Google-Smtp-Source: ABdhPJwmeL0iioIWcnSx7v4VNojtAsBJ7ekWrKO76x/2LqOtlIab3BJzSvj+ODyBZGLFrdihrRU7bg==
X-Received: by 2002:a1c:f605:: with SMTP id w5mr3771327wmc.26.1598025626350;
        Fri, 21 Aug 2020 09:00:26 -0700 (PDT)
Received: from [192.168.0.101] ([79.134.172.106])
        by smtp.googlemail.com with ESMTPSA id 32sm5830132wrh.18.2020.08.21.09.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 09:00:25 -0700 (PDT)
Subject: Re: general protection fault in fib_dump_info (2)
To:     syzbot <syzbot+a61aa19b0c14c8770bd9@syzkaller.appspotmail.com>,
        davem@davemloft.net, dsahern@gmail.com, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
References: <00000000000039b10005ad64df20@google.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <47e92c2b-c9c5-4c74-70c4-103e70e91630@cumulusnetworks.com>
Date:   Fri, 21 Aug 2020 19:00:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <00000000000039b10005ad64df20@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/20 6:27 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    da2968ff Merge tag 'pci-v5.9-fixes-1' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=137316ca900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a0437fdd630bee11
> dashboard link: https://syzkaller.appspot.com/bug?extid=a61aa19b0c14c8770bd9
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12707051900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1150a046900000
> 
> The issue was bisected to:
> 
> commit 0b5e2e39739e861fa5fc84ab27a35dbe62a15330
> Author: David Ahern <dsahern@gmail.com>
> Date:   Tue May 26 18:56:16 2020 +0000
> 
>      nexthop: Expand nexthop_is_multipath in a few places
> 

This seems like a much older bug to me, the code allows to pass 0 groups and
thus we end up without any nh_grp_entry pointers. I reproduced it with a
modified iproute2 that sends an empty NHA_GROUP and then just uses the new
nexthop in any way (e.g. add a route with it). This is the same bug as the
earlier report for: "general protection fault in fib_check_nexthop"

I have a patch but I'll be able to send it tomorrow.

Cheers,
  Nik
