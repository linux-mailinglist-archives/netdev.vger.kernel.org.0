Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FCB432C83
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 06:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhJSEGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 00:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhJSEGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 00:06:44 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFCCC06161C;
        Mon, 18 Oct 2021 21:04:31 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id g5so12763311plg.1;
        Mon, 18 Oct 2021 21:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XS9ORBnn63Yq23RPWchbYr9vGt7B+kOMzPbvQkkhvmI=;
        b=YHpTANS6vg3RZHwxyNQJKlRiNMTYfknVJtTWbzShiuTUzxKkjIBVnAII9GXWPB0FaK
         /1ydbRfRZM8CUJ8ItWYZmhNm0s1tHhBHLfhoXae1J8wYXWSvKrTGSVwOxrqTcbmunMqs
         88dAkE9k2WhgApLinjJ5VDGepRfuJO8luBTb6wSNa6QBjR4CFUfWdrVUbnLAw97IEtpF
         dsIuZEytcjrH3C1HCnBQVaQeNUI3mJk0ZZMU190a0pGATeFHZtyTgOD7KljC3c2WlSz9
         rG6k5RKUbtPIEao6UuzZoBjPUgsr7CuKjPGf14RB8PmrrvcKrVW46UBKFsmyHI9yU8qu
         kMeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XS9ORBnn63Yq23RPWchbYr9vGt7B+kOMzPbvQkkhvmI=;
        b=peUYzXAXK4qLAOPfcJ7IpOC44YS+WM5uZ8WFh21B3k1eygJRV6NemxQQmjdRigM5Xb
         SZdasfhjDoNHG52jkGOWZhVMCoZPVfL5CCh1fYAJBQNBEKAc2QahQEsEgpaB3BpywJQy
         CzJZscjq4LnVGM+1GbiXTjCuNRDbRmVFKIrBXi32YDP08/Uaq65+s3ZL12yHBLYfp1QA
         qNNZpGTX+KPvYgtr7D15VpISyNE2D7dz+HavYHy/Pk0cS5mWIMP7kvSGsQ5rK2i6nSYK
         0I06umsPhnYE0nLkyBga51FgH/RjXttK+rcn7AoPg/1zeFDuoI1G/SKzBdwEXhx+LAGd
         A/zA==
X-Gm-Message-State: AOAM530T9RpKzvq12hvV0/KMtKIxD7qHD3VCdN3kpNJ5Runvv3QKAobW
        lS28Di/GUMdZCvh4mUNZIWQ=
X-Google-Smtp-Source: ABdhPJztjp9yXJgaitrms0AEdFpypTs/AYnq8cRwyyVF7qx8MiAQOBp9BL4Q34Y8q0CD3H9wBvm1dw==
X-Received: by 2002:a17:90a:4b47:: with SMTP id o7mr3727468pjl.198.1634616271256;
        Mon, 18 Oct 2021 21:04:31 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y1sm14735953pfo.104.2021.10.18.21.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 21:04:30 -0700 (PDT)
Subject: Re: [PATCH] mwifiex: Fix divide error in mwifiex_usb_dnld_fw
To:     Wan Jiabing <wanjiabing@vivo.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net,
        syzbot+4e7b6c94d22f4bfca9a0@syzkaller.appspotmail.com
References: <20211019033101.27658-1-wanjiabing@vivo.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1ae64510-0519-4852-a2a0-5c32490a195c@gmail.com>
Date:   Mon, 18 Oct 2021 21:04:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019033101.27658-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/18/21 8:31 PM, Wan Jiabing wrote:
> This patch try to fix bug reported by syzkaller:
> divide error: 0000 [#1] SMP KASAN
> CPU: 1 PID: 17 Comm: kworker/1:0 Not tainted 5.15.0-rc5-syzkaller #0
> Hardware name: Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events request_firmware_work_func
> RIP: 0010:mwifiex_write_data_sync drivers/net/wireless/marvell/mwifiex/usb.c:696 [inline]
> RIP: 0010:mwifiex_prog_fw_w_helper drivers/net/wireless/marvell/mwifiex/usb.c:1437 [inline]
> RIP: 0010:mwifiex_usb_dnld_fw+0xabd/0x11a0 drivers/net/wireless/marvell/mwifiex/usb.c:1518
> Call Trace:
>  _mwifiex_fw_dpc+0x181/0x10a0 drivers/net/wireless/marvell/mwifiex/main.c:542
>  request_firmware_work_func+0x12c/0x230 drivers/base/firmware_loader/main.c:1081
>  process_one_work+0x9bf/0x1620 kernel/workqueue.c:2297
>  worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
>  kthread+0x3c2/0x4a0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> Link: https://syzkaller.appspot.com/bug?extid=4e7b6c94d22f4bfca9a0

Please provide a Fixes: tag

> Reported-and-tested-by: syzbot+4e7b6c94d22f4bfca9a0@syzkaller.appspotmail.com
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
> index 426e39d4ccf0..c24ec27d4057 100644
> --- a/drivers/net/wireless/marvell/mwifiex/usb.c
> +++ b/drivers/net/wireless/marvell/mwifiex/usb.c
> @@ -693,7 +693,7 @@ static int mwifiex_write_data_sync(struct mwifiex_adapter *adapter, u8 *pbuf,
>  	struct usb_card_rec *card = adapter->card;
>  	int actual_length, ret;
>  
> -	if (!(*len % card->bulk_out_maxpktsize))
> +	if (card->bulk_out_maxpktsize && !(*len % card->bulk_out_maxpktsize))


Are you sure this fix is not working around the real bug ?

In which cases bulk_out_maxpktsize would be zero ?

If this is a valid case, this needs to be explained in the changelog.

>  		(*len)++;
>  
>  	/* Send the data block */
> 
