Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020F247C845
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 21:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhLUUd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 15:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbhLUUd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 15:33:28 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B7BC061574;
        Tue, 21 Dec 2021 12:33:28 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id k27so230996ljc.4;
        Tue, 21 Dec 2021 12:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=iokYFGKFWpGgvc/wPLQmXmpqVjhnO7U9sL1ZKTvaFWI=;
        b=HHZ/X/6O5lQgivi5y0CrwYhM5dQubJ5BQSrmiy6NJUD8xZx1P/YSTwrE3ygXNF8EbZ
         hbdfpd707EIZ+3sIlslMdaHrCy/E4Fztji7wtwF38MXLykunX5VzB27FI6A8WVA+oUvZ
         p4F/DYhif6avS0jv2Etjtx68TVAYOM5S/lp6JufuM7+KGrM3B4wopKIskhu6c+uMrjwW
         iEFOIow7QwdG73WGPOth87Gx0g0uDyEtCotQq35eQ1p7NaQEbv4+1+ZA1plVfyY/xphv
         RJdTY8IbLwVsGPIKhDWtI95RgI1kB1FCoilwnzDvyxYMsjlemV2pzn+o3nJAQZpGSVWd
         Qe8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iokYFGKFWpGgvc/wPLQmXmpqVjhnO7U9sL1ZKTvaFWI=;
        b=Ucy8Xk6cfOFuC+PupsAOtGK8eHeGv5pn7w/nTCPQ8/bwOOe71dXI611JJHYTo0itYC
         5DEaElH2pIOoSsNImfk92+7yoN2LQBejrD5ab217KTsRpmAPOlj2rpGgfjPs9LiP9MC9
         Eigq8BY+K/HIzmZmWCZvZB/s0GV3O+WYCC7zkkqLG+63NHEBUNhUjtoL8McipdSa7mhD
         /Ti5wxBVkYBM11ffZyovXx64zid+kja1f8aqmCftIPF2vjt/RY5L2lEvk1ylZQT2xa+r
         KKf242VOYC6CD/2wf25Q26ZdW3fOy58yCp+R1x32kgVMKuCWv0ObaMb+18oYjFWsUU85
         6PCQ==
X-Gm-Message-State: AOAM532CTuLRmXSAheGep4NKBlBLX5JZwLE5isb7rRjRSG20XL/KLSs/
        i95eOpf8lkU+ZGPAF0CXpTQ=
X-Google-Smtp-Source: ABdhPJwlMXRHHrTmQaGpPimrm3/zWiEoy5ytXUE9y6iAn8EcmEZasQz63goneksz/qe5hO0hMYYauA==
X-Received: by 2002:a2e:b177:: with SMTP id a23mr78834ljm.2.1640118806149;
        Tue, 21 Dec 2021 12:33:26 -0800 (PST)
Received: from [192.168.1.11] ([94.103.235.97])
        by smtp.gmail.com with ESMTPSA id y36sm4373lfa.75.2021.12.21.12.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 12:33:25 -0800 (PST)
Message-ID: <24253b93-66f0-15b7-a3b1-f1ffacb86116@gmail.com>
Date:   Tue, 21 Dec 2021 23:33:24 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [syzbot] KMSAN: kernel-infoleak in move_addr_to_user (6)
Content-Language: en-US
To:     syzbot <syzbot+cdbd40e0c3ca02cae3b7@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, glider@google.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <000000000000a8a64205d39672b8@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <000000000000a8a64205d39672b8@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/21 19:33, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b0a8b5053e8b kmsan: core: add dependency on DEBUG_KERNEL
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=14a45071b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=46a956fc7a887c60
> dashboard link: https://syzkaller.appspot.com/bug?extid=cdbd40e0c3ca02cae3b7
> compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1343f443b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16efa493b00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cdbd40e0c3ca02cae3b7@syzkaller.appspotmail.com
> 

Looks like missing memset(0). tipc_nametbl_lookup_anycast() may return 
before initializing sk.ref

>  * On exit:
>  *
>  * - If lookup is deferred to another node, leave 'sk->node' unchanged and
>  *   return 'true'.

And then sk.ref is passed to msg_set_destport().

There is also one more place with similar possible uninit-value in 
tipc_msg_lookup_dest().



With regards,
Pavel Skripkin
