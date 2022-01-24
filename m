Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCBD49803D
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 14:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242949AbiAXM73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242887AbiAXM7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:59:12 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C19CC061756;
        Mon, 24 Jan 2022 04:59:11 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id x11so49085789lfa.2;
        Mon, 24 Jan 2022 04:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=hy9h7krpA8HSqyaSzpL6OuBy89OEy4yHH0P9Egx8wMU=;
        b=nqOBZDOFIM1Lg2pZJTU9REB16Pi35arSZfYjb2hDggpiW/R9YROp+HImquIJNCHScq
         vUV7GbyRji32u+80rl/FZNU+1+4x258iXkLwQC4h/JbSwq2WWkiRf58rOstVz881uP0+
         0h7atkDx1N572sJ6VjRdjzu0e0GzHQe0NcmZOKhjm49a0U565HYU4c0DHLmGWaXcI4EK
         7vTK/fcUCh9tAYy2vse1gZrpiDX91m+GhlDkrH3R6a98FdjuCeilnIEHaJVxRYfftTdc
         LHrcrt6zVABs/EP9TVSZrebf1s9TEl175+68+WU1BVvbI+dv2ErCW7QjWXl67R7pmWh9
         TJBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hy9h7krpA8HSqyaSzpL6OuBy89OEy4yHH0P9Egx8wMU=;
        b=KFxDMGQu2h08ZRYc7cHRGWNO41V7yeNgMjpnu3ouMpIu9dC+E5Sh1rLQ1vOxzKKG+r
         EBSB8sg4rJvWGzgFbmT5h50rYtVLiW7R0rRoWEUBHBDS5pAGFP7Za+uXDPZwci0IwuqJ
         6KZaD44KawXTaA42HayuMynTC03SWo7wArdSfTGcYv6gSJ0PpZ5AX8eC2UQfWO3A8awC
         1SZuKLrLLtwb22Jgki9OaxxvpOqixW/cDBxMd6X26mDuG3kB8K+wyeRP7P34HD2nMwdE
         2ygd6/XeQ1Wm8vSIVq5d5bAYwmJiQYMyhv5dNV4V4ZziofMu8iBw0ViGU/P982uRcrxL
         hMXQ==
X-Gm-Message-State: AOAM532LB+W5OjIQ32WzocwrZ7SpGkPaM+wd4wKitPvks2QyU9AT8bFh
        TJkjXOKmczAUN5ppnKWqeCY=
X-Google-Smtp-Source: ABdhPJwI/7v8+jOw7RZaWhse02D+Um2AWJGt9KRF2IS1WPJN5qzN/xCjROOPzwZeTh7NCh2Z2/nRiw==
X-Received: by 2002:a19:6b0b:: with SMTP id d11mr12892908lfa.594.1643029149450;
        Mon, 24 Jan 2022 04:59:09 -0800 (PST)
Received: from [192.168.1.11] ([94.103.227.208])
        by smtp.gmail.com with ESMTPSA id i6sm1162352lfe.52.2022.01.24.04.59.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 04:59:08 -0800 (PST)
Message-ID: <3d071cde-9eff-c6c3-63bc-827e74f2e9ea@gmail.com>
Date:   Mon, 24 Jan 2022 15:59:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in nl802154_new_interface
Content-Language: en-US
To:     syzbot <syzbot+7bf7b22759195c9a21e9@syzkaller.appspotmail.com>,
        aahringo@redhat.com, alex.aring@gmail.com,
        anant.thazhemadam@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000f09fca05d41a8aee@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <000000000000f09fca05d41a8aee@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/27/21 09:09, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 451dc48c806a7ce9fbec5e7a24ccf4b2c936e834
> Author: Alexander Aring <aahringo@redhat.com>
> Date:   Fri Nov 12 03:09:16 2021 +0000
> 
>      net: ieee802154: handle iftypes as u32
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1084d10db00000
> start commit:   ec681c53f8d2 Merge tag 'net-5.15-rc6' of git://git.kernel...
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bab9d35f204746a7
> dashboard link: https://syzkaller.appspot.com/bug?extid=7bf7b22759195c9a21e9
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14398d94b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117fc40cb00000
> 
> If the result looks correct, please mark the issue as fixed by replying with:
> 
> #syz fix: net: ieee802154: handle iftypes as u32
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: net: ieee802154: handle iftypes as u32




With regards,
Pavel Skripkin
