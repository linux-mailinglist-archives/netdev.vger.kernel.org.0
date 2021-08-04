Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A543DFF8B
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237529AbhHDKoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236839AbhHDKoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 06:44:22 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B37C0613D5;
        Wed,  4 Aug 2021 03:44:08 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id h2so3686250lfu.4;
        Wed, 04 Aug 2021 03:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EDbRoHBLakJr51l5FalBo08vyLPH6TfSJFCeL9S4NEg=;
        b=Dzcr/KaBmQHj0ofWFNEY3UBvzF1X0LOZZuRhuhdqkX5rNHE+ThX24fuBDCi3AQvzE0
         VOS44PJ765X68VdPjNywfwcqhc+28RGHvQg6m1CWl4PwgVozZDCwoAgU1poG0TMDEGpm
         cvrUDTfnQdOqyx/kSAj6OAnnaJMJlVFdzYl1ER3HWbKck88eYx6+BLET1bfhqjwWUvuv
         7t4/XN/UWQCsMw4/NM+cOKxVneZnl5suGifymi/BSiQGlYCmbswwSjaw4poJPxzEZb0H
         n3iHPQUKQGNJkCP4DUMGkOG6Wlmd6tbb6mJSrZ9SRzkWXjSiifFd643M+ASuF1cOvp9p
         58dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EDbRoHBLakJr51l5FalBo08vyLPH6TfSJFCeL9S4NEg=;
        b=JFDvyKBAqlpsM99UU7TnAsfE31+PCVEP7TLh2vlJ/ljfjK0QkLGsV0wXtkBSo58hzO
         Iu9sApLn5TgcRU2paynojsW99Ltua7RU+gH0OO92JBPwrneUfnn3UPDlbKyPY67LmFnY
         ZWAU+Jx71VrR39iIzMesSk8IWyPryv1RuDMtO+t7NxoDntZYlLmHIeHe0A1/miB4wdo/
         jQDexNKjkSrdTSKxEDroiOwpxDLF1URvfsNZLha/JeuJ4DXtv1G9rzMiTkEzjIgOkq26
         GHuv4+Vz4l45eCbuJJ0b6tdq9BMOBb87CW2priEqBBg/7BcPXc9xuUOX4NdLKm+ccffm
         KVMg==
X-Gm-Message-State: AOAM531HW9zfPd5FpCS4rLzV2vGO/DUy4ts4g5KU8qCs/6RQMeOMbv/8
        Ir1tA9P8leTFjAs9ON0jFqc=
X-Google-Smtp-Source: ABdhPJzyguY8KQe1cfUoiAjh+4adTbryKiVxB2a30S72KJVoXPdEljIWr8X6yk+hclH3VhHymUigrA==
X-Received: by 2002:a05:6512:36c2:: with SMTP id e2mr17425624lfs.478.1628073846802;
        Wed, 04 Aug 2021 03:44:06 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id bt28sm159648lfb.195.2021.08.04.03.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 03:44:06 -0700 (PDT)
Subject: Re: [PATCH] net: pegasus: fix uninit-value in get_interrupt_interval
To:     petkan@nucleusys.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
References: <20210730214411.1973-1-paskripkin@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <9576d0cc-1f3e-4acc-4009-79fb2dbeda34@gmail.com>
Date:   Wed, 4 Aug 2021 13:44:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210730214411.1973-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/31/21 12:44 AM, Pavel Skripkin wrote:
> Syzbot reported uninit value pegasus_probe(). The problem was in missing
> error handling.
> 
> get_interrupt_interval() internally calls read_eprom_word() which can
> fail in some cases. For example: failed to receive usb control message.
> These cases should be handled to prevent uninit value bug, since
> read_eprom_word() will not initialize passed stack variable in case of
> internal failure.
> 
> Fail log:
> 
> BUG: KMSAN: uninit-value in get_interrupt_interval drivers/net/usb/pegasus.c:746 [inline]
> BUG: KMSAN: uninit-value in pegasus_probe+0x10e7/0x4080 drivers/net/usb/pegasus.c:1152
> CPU: 1 PID: 825 Comm: kworker/1:1 Not tainted 5.12.0-rc6-syzkaller #0
> ...
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>   __dump_stack lib/dump_stack.c:79 [inline]
>   dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
>   kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
>   __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
>   get_interrupt_interval drivers/net/usb/pegasus.c:746 [inline]
>   pegasus_probe+0x10e7/0x4080 drivers/net/usb/pegasus.c:1152
> ....
> 
> Local variable ----data.i@pegasus_probe created at:
>   get_interrupt_interval drivers/net/usb/pegasus.c:1151 [inline]
>   pegasus_probe+0xe57/0x4080 drivers/net/usb/pegasus.c:1152
>   get_interrupt_interval drivers/net/usb/pegasus.c:1151 [inline]
>   pegasus_probe+0xe57/0x4080 drivers/net/usb/pegasus.c:1152
> 
> Reported-and-tested-by: syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>   drivers/net/usb/pegasus.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
> 

Hi, David and Jakub!

Should I rebase this patch on top of Petko's clean-up patches? :

1. https://git.kernel.org/netdev/net/c/8a160e2e9aeb
2. https://git.kernel.org/netdev/net/c/bc65bacf239d



With regards,
Pavel Skripkin
