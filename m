Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2AA47F30E
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 12:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhLYLQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 06:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbhLYLQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Dec 2021 06:16:02 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A680EC061401;
        Sat, 25 Dec 2021 03:16:01 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id x21so24025426lfa.5;
        Sat, 25 Dec 2021 03:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=jD3Ho49ZXVfN6HlbKxzdGSI6sz6nWNyLf9zcGh6i8pk=;
        b=bvQ1dMcEqw0yfAIAJZhBI4hSQrXQDRvrQdCHqD1vyeg/pceL0cduJSPLXOwW7MDAOx
         IUIt6P1SmR9bBsd0sDlno33k5NMM/ohOOd6sEnBFldx+lzb5pAItCz/cnlz7FJCUek/o
         /p12JJStViW5vfzuS1qXXof0SShP1I70C2rGFXJIlM3t52A0nnOs5sTRhBJBlUTbA9f/
         ms1KuDX+I8v2FUkBH6KgwppAbeg5SysCfzbQiFRmVfRXKUuJl2vei+lVebl5+7tqTj43
         YxDPoQ9ZUfXcm3g4K0H7Lpv++J+bRM+OqvM9/4FP1ZIPGaDPsvRCvcdNCB2aHeSbjmX0
         UjZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jD3Ho49ZXVfN6HlbKxzdGSI6sz6nWNyLf9zcGh6i8pk=;
        b=axvOD2Fp72Te4MlRnPsyrF48TxxZxjSd8lpxRDVWEYO/S6TZEDJiIl+jxiBWgdvgP7
         21mZMefgZ1YtFA2GdVVMqbqTlSL1Pkc4RHj+ZR+VanaJokoIGpSDh0Igcn1Yl3jzYdxS
         Cyu6mJR854PMxkQXsSjaJPScCDBR3z+YbZaybYyru4QY9M/MitfXCHnJKaQaqwGz3w4f
         AJ/VWkEbDcJTooqUp1bGtMnZGls96s3wS20RtxckbF00w+23/Kccw9iYxTmAY15gG24n
         Rpws00ugzM3lKgHv6QddaZvhQa4mxSXtsgcKK4k/OYAU+ViAt/2nUbfY6SIlsv1Ubkpt
         V+vQ==
X-Gm-Message-State: AOAM5326dtnQhIroshZIt5YWKvER1nAVHu5fZmKZHI+0cVvInjd7IwXG
        ZhYVFzMy/BJuuv035VmMCbw=
X-Google-Smtp-Source: ABdhPJwvYB0w3n8Ru3efRBiK7m5ojAAr3OM0vWrkkFa2fkcpgQfKuQ3nnAJlFknilSRiF+cdPZVAcw==
X-Received: by 2002:a05:6512:30f:: with SMTP id t15mr5280604lfp.650.1640430959306;
        Sat, 25 Dec 2021 03:15:59 -0800 (PST)
Received: from [192.168.1.11] ([94.103.235.97])
        by smtp.gmail.com with ESMTPSA id s4sm1016787ljp.40.2021.12.25.03.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Dec 2021 03:15:58 -0800 (PST)
Message-ID: <45e8c415-8aa1-7a2a-c435-3e014f3856eb@gmail.com>
Date:   Sat, 25 Dec 2021 14:15:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [syzbot] KMSAN: uninit-value in ax88772a_hw_reset
Content-Language: en-US
To:     syzbot <syzbot+8d179821571093c5f928@syzkaller.appspotmail.com>,
        andrew@lunn.ch, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux@rempel-privat.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000005fb57e05d1620da1@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <0000000000005fb57e05d1620da1@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/21 18:12, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    412af9cd936d ioremap.c: move an #include around
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=136fb126b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2d142cdf4204061
> dashboard link: https://syzkaller.appspot.com/bug?extid=8d179821571093c5f928
> compiler:       clang version 14.0.0 (git@github.com:llvm/llvm-project.git 0996585c8e3b3d409494eb5f1cad714b9e1f7fb5), GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8d179821571093c5f928@syzkaller.appspotmail.com
> 
> asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable software MII access
> asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0000: -71
> asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x0016: -71
> asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
> asix 4-1:0.0 (unnamed net_device) (uninitialized): Failed to enable hardware MII access


#syz fix: asix: fix uninit-value in asix_mdio_read()


With regards,
Pavel Skripkin
