Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F404D2C8D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbiCIJxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiCIJxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:53:13 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D1816F973
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 01:52:15 -0800 (PST)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4A4B83F79C
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 09:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646819533;
        bh=U75FRdLGbZ3F+BR5tg2Db57c8QbYtEzo66rlGoHxRKA=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=gTKaCzf8axqkYnK61BsdDpcMM28luPO81aTRtsHy0UP6f4Fh3Lo3ScP2s8IYE97WQ
         8so6JQkTsoDu7dPLT7Of/pvHOOLs0mklZZtnAJ2o5QJxIzLewHS+ldCKMg+dCWgeU0
         qeHLy2KV3HjiPDeefCqzcr3BE319IOW3+/VFqfHBgIxK4APjPNOPavkPdODcs6mh5+
         3mTgislXzrXoccWMvb8RhPAGI41n3aF3e1jLhdtv9wkNP1mOVP5w7kA+GkL0oKdu9W
         XlBm9yKVD01v0Gna44udhglojdjh+KB6KhQg/I1DI7CAgor2sBVBjaHzhgpjs5VdxV
         2VVLbRC7uVVuQ==
Received: by mail-ej1-f72.google.com with SMTP id q22-20020a1709064cd600b006db14922f93so1014413ejt.7
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 01:52:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U75FRdLGbZ3F+BR5tg2Db57c8QbYtEzo66rlGoHxRKA=;
        b=xZWao5zxCYx5tVHGQ/kO+V8EQcm2gvQ/gTYCdd4FCReyKCBpk2CkfLBYcxyRL2+ZV4
         emycveXJajxhscSgSKDOlYHqPFmxjBFYTpx7n5PNoH0Gvv4CxY7D2FxFl03Dc5Ev1G5T
         eGRxD9Dd37VjnWUefSnxbP9zacelNkoRd4aQHJxCyOMKtuJbvGpBw/8Q3UfNwz2hCYGv
         NC2LI1P9HDtPJaJcZbDbEHkcfclqw6Xw8FXlkJlUKq4UASCp4ze8+L615bTQ9ulB0V6d
         +ZzpeW0KsFRWo2ucguB3CSTren9LxfFrCdVUvsu0b1h2axKtxCeQjvrseKuFWAmkMIg4
         5GmQ==
X-Gm-Message-State: AOAM531rgCqcHhKxARStUyHrjGPlOIJzFMWQtPmfl2AEQ+3O9Q4/ZxSz
        JT9wZ6587xBf7iCL5NB0DpiQBCw59GM06ulNGjX9xBY+BHMTeImwRyT7E/MMx009vl0OlNX5ztv
        qOEPOKsf5y+W86zV+qPmvh6ItFz3KvkcELw==
X-Received: by 2002:a17:906:d1c4:b0:6d5:83bb:f58a with SMTP id bs4-20020a170906d1c400b006d583bbf58amr17198187ejb.672.1646819532932;
        Wed, 09 Mar 2022 01:52:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxypo8WhHmI7QrJIfEnzBsw31JbIstN4NTAsHC8a7RLBqVyTNgRad9/mbPcfeKtI/FKHnDF1Q==
X-Received: by 2002:a17:906:d1c4:b0:6d5:83bb:f58a with SMTP id bs4-20020a170906d1c400b006d583bbf58amr17198172ejb.672.1646819532666;
        Wed, 09 Mar 2022 01:52:12 -0800 (PST)
Received: from [192.168.0.144] (xdsl-188-155-174-239.adslplus.ch. [188.155.174.239])
        by smtp.gmail.com with ESMTPSA id mp33-20020a1709071b2100b006db6dea7f9dsm373267ejc.168.2022.03.09.01.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 01:52:12 -0800 (PST)
Message-ID: <cbdd5e41-7538-6d8f-344a-54a816c6d511@canonical.com>
Date:   Wed, 9 Mar 2022 10:52:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] NFC: port100: fix use-after-free in port100_send_complete
Content-Language: en-US
To:     Pavel Skripkin <paskripkin@gmail.com>, sameo@linux.intel.com,
        thierry.escande@linux.intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com
References: <20220308185007.6987-1-paskripkin@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220308185007.6987-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/03/2022 19:50, Pavel Skripkin wrote:
> Syzbot reported UAF in port100_send_complete(). The root case is in
> missing usb_kill_urb() calls on error handling path of ->probe function.
> 
> port100_send_complete() accesses devm allocated memory which will be
> freed on probe failure. We should kill this urbs before returning an
> error from probe function to prevent reported use-after-free
> 
> Fail log:
> 
> BUG: KASAN: use-after-free in port100_send_complete+0x16e/0x1a0 drivers/nfc/port100.c:935
> Read of size 1 at addr ffff88801bb59540 by task ksoftirqd/2/26
> ...
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0x8d/0x303 mm/kasan/report.c:255
>  __kasan_report mm/kasan/report.c:442 [inline]
>  kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
>  port100_send_complete+0x16e/0x1a0 drivers/nfc/port100.c:935
>  __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1670
> 
> ...
> 
> Allocated by task 1255:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:45 [inline]
>  set_alloc_info mm/kasan/common.c:436 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:515 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:474 [inline]
>  __kasan_kmalloc+0xa6/0xd0 mm/kasan/common.c:524
>  alloc_dr drivers/base/devres.c:116 [inline]
>  devm_kmalloc+0x96/0x1d0 drivers/base/devres.c:823
>  devm_kzalloc include/linux/device.h:209 [inline]
>  port100_probe+0x8a/0x1320 drivers/nfc/port100.c:1502
> 
> Freed by task 1255:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>  kasan_set_track+0x21/0x30 mm/kasan/common.c:45
>  kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
>  ____kasan_slab_free mm/kasan/common.c:366 [inline]
>  ____kasan_slab_free+0xff/0x140 mm/kasan/common.c:328
>  kasan_slab_free include/linux/kasan.h:236 [inline]
>  __cache_free mm/slab.c:3437 [inline]
>  kfree+0xf8/0x2b0 mm/slab.c:3794
>  release_nodes+0x112/0x1a0 drivers/base/devres.c:501
>  devres_release_all+0x114/0x190 drivers/base/devres.c:530
>  really_probe+0x626/0xcc0 drivers/base/dd.c:670
> 
> Reported-and-tested-by: syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com
> Fixes: 0347a6ab300a ("NFC: port100: Commands mechanism implementation")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>  drivers/nfc/port100.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
> index d7db1a0e6be1..00d8ea6dcb5d 100644
> --- a/drivers/nfc/port100.c
> +++ b/drivers/nfc/port100.c
> @@ -1612,7 +1612,9 @@ static int port100_probe(struct usb_interface *interface,
>  	nfc_digital_free_device(dev->nfc_digital_dev);
>  
>  error:
> +	usb_kill_urb(dev->in_urb);
>  	usb_free_urb(dev->in_urb);
> +	usb_kill_urb(dev->out_urb);
>  	usb_free_urb(dev->out_urb);
>  	usb_put_dev(dev->udev);


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Thanks, this looks good. I think I saw similar patterns also in other
drivers, e.g. pn533. I will check it later, but if you have spare time,
feel free to investigate.

Similar cases (unresolved):
https://syzkaller.appspot.com/bug?extid=1dc8b460d6d48d7ef9ca
https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869
https://syzkaller.appspot.com/bug?extid=dbec6695a6565a9c6bc0


Best regards,
Krzysztof
