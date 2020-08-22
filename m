Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC42324E7D4
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 16:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgHVOWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 10:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728115AbgHVOWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 10:22:32 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B70C061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 07:22:31 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id 88so4473587wrh.3
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 07:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5HFVo2zL2bsI/Q9rxIrK2pe3dbH+0GlhbWJVp1cCskk=;
        b=Wbkz2zA+bdCvXZ3rsLg7F0NkvvbKjFGx0Fwa3Zu06+1hpw2dEm/jvRid8vhtlSNfB+
         aPl3Pdn9/iqjpCH7R5fz7LUKdSff29/ZZ8IO7KLS9eYLANNWtwOapGpYfZCcxcOqhyDn
         jE/LbyZE93/5JI/BDmGC4H+QaqEu4NudgYpbk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5HFVo2zL2bsI/Q9rxIrK2pe3dbH+0GlhbWJVp1cCskk=;
        b=rG+gdEuzUbzPhpjyxLjB0eYgL/H5I/bQUVCY3Hs5Z3GqN77F9aK3VmJC0E3Lmt6XOn
         eFohPtsXFZaLBXuopFRv9BXPp63AshjffAV0Yt4+u8BxUA3HvG9g9NcUcY5quG5vVMbK
         /nHU0rdQdPqVfyjodzc89xH3+tW06msjxmsHNBQDdPLT62g7hZElcgA+i1Xitb7lgZhJ
         xwDwuSYK6RCxhYDXF85npvsG8kOdv1VSSjGZ4/nvOtcam6k3xYW5ms3uWQ3YKzzMnEtd
         IHPs0hmEz6rEWHIpphel9fnN7nVMGwSx53rR4/9qjJldSJP4cZFosPU6B3QIf/xrMYVi
         OH1Q==
X-Gm-Message-State: AOAM530NdKH8cANtroseOU1wCpKVFd/SPm8U4YDuE/GSRevNpDHj0OkK
        Np2m/HEn+A0J4YSHm+qOyN3dK3I9Y8rSEg==
X-Google-Smtp-Source: ABdhPJzJZyqNjdHMGQ/nkBrB4dh3Vqvf0CzIf2KNRQ9WTeuU0RPG+NzYRmOQyJdoAUhibiQ2J5s+Rw==
X-Received: by 2002:adf:e60a:: with SMTP id p10mr5303146wrm.295.1598106149913;
        Sat, 22 Aug 2020 07:22:29 -0700 (PDT)
Received: from [192.168.0.101] ([79.134.173.43])
        by smtp.googlemail.com with ESMTPSA id p17sm13328547wra.81.2020.08.22.07.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2020 07:22:28 -0700 (PDT)
Subject: Re: general protection fault in fib_check_nexthop
To:     syzbot <syzbot+55a3e617aaf04b962a3e@syzkaller.appspotmail.com>,
        davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
References: <00000000000086e96005ad5d17a7@google.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <6d82801a-8704-9198-67d6-12927e21f0fd@cumulusnetworks.com>
Date:   Sat, 22 Aug 2020 17:22:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <00000000000086e96005ad5d17a7@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/20 9:10 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    18445bf4 Merge tag 'spi-fix-v5.9-rc1' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=162cbd7a900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a0437fdd630bee11
> dashboard link: https://syzkaller.appspot.com/bug?extid=55a3e617aaf04b962a3e
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> userspace arch: i386
> 

#syz dup: general protection fault in fib_dump_info (2)

