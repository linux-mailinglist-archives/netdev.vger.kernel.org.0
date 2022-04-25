Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01E150DAD1
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 10:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241524AbiDYIEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 04:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235084AbiDYICl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 04:02:41 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122222FE6B
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 00:59:35 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id p18so12212290edr.7
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 00:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rmQFdUllbHaIXvTF9BqWURgdXwe6MDDC4tLyjCYMhRs=;
        b=FERFQB41XNDl23ARhaw4RmRKJDQBd3z1i9sKLaaqpjfwXMtWowdri0COVuWdGUsiQA
         NBcuNXaQrJZFme9N+pKuuCWcS9cBPaQ3E2QmgYknFXWSSh/9diD2yjnoNHO+gsMjjX7s
         h1wJUYwNFLUtJvMUm6Xo5Th5iGEvqCGTOibcgkXhSWAE+sAiHACw6Fusb8dShHa7608A
         C0hUEKXNTfCopkSh1AtyLp02KUi8X1i3dmx9Ky7cAX0f3ZJcIedhJjSFUnF3m62FfQZb
         GcY7wb1vcql3N6Ujiy81sknBVTIOoK1/PQZKjTMC4oRomTGnUum/dC3oeNn4385KeUkc
         VFzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rmQFdUllbHaIXvTF9BqWURgdXwe6MDDC4tLyjCYMhRs=;
        b=XWjxi57HCzNY1QMKvORio7DvDonoQLzCOdh54EXvA8M8XRrBMNa/JyzvkYrl5Uz5Lg
         C+ByvmoKCycO2wu9sCc7CReVFsOpa+7I8VNqHnWzWl/PCGx8Scox0MNdINWyM++7kv0o
         yQxHvfSZahSu0DPMgFVPgnFsFdYVsbZqf0EIl3yFRErPaiN1cY+5DlNE/4g7Am8EzHk/
         YebiLGw6M1NwKNZhJPH+oa21vaNZQyJp1Qdg//fZYk4z9Q6y/a87aFFOy7GSBa3d3evC
         0+jRA6uMSM1+jsV8MpwB/ghJy+3n+OddEsva/BuBovmOTBtjoUjzHFpWuylGNYzdLtz+
         jZCg==
X-Gm-Message-State: AOAM532tvbek3J+771wlZyyYweR1553fRRCqQx4bcGni34fm6ZHIObKE
        Llf3VJKKxiou+1wPF4SDAs7TWQ==
X-Google-Smtp-Source: ABdhPJzn4cDDxnThKF/U8ABvLE3F0JvmqfaFRO7pOTaHwgeHEgObTl8f5lJSHr4Ocj+AgQifnNjOgA==
X-Received: by 2002:a05:6402:42d4:b0:416:5cac:a9a0 with SMTP id i20-20020a05640242d400b004165caca9a0mr17658385edc.86.1650873573607;
        Mon, 25 Apr 2022 00:59:33 -0700 (PDT)
Received: from [192.168.0.240] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id o2-20020a056402438200b0041fb0f2e155sm154517edc.20.2022.04.25.00.59.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 00:59:33 -0700 (PDT)
Message-ID: <d7aefec5-a51d-00ba-10d6-79c90fbc8eb4@linaro.org>
Date:   Mon, 25 Apr 2022 09:59:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] drivers: nfc: nfcmrvl: reorder destructive operations in
 nfcmrvl_nci_unregister_dev to avoid bugs
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, broonie@kernel.org,
        akpm@linux-foundation.org, alexander.deucher@amd.com,
        gregkh@linuxfoundation.org, davem@davemloft.net, linma@zju.edu.cn
References: <20220425031002.56254-1-duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220425031002.56254-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/04/2022 05:10, Duoming Zhou wrote:
> There are destructive operations such as nfcmrvl_fw_dnld_abort and
> gpio_free in nfcmrvl_nci_unregister_dev. The resources such as firmware,
> gpio and so on could be destructed while the upper layer functions such as
> nfcmrvl_fw_dnld_start and nfcmrvl_nci_recv_frame is executing, which leads
> to double-free, use-after-free and null-ptr-deref bugs.

You need to correct the subject prefix because it does not describe the
subsystem (git log oneline --).

> 
> There are three situations that could lead to double-free bugs.
> 
> The first situation is shown below:
> 
>    (Thread 1)                 |      (Thread 2)
> nfcmrvl_fw_dnld_start         |
>  ...                          |  nfcmrvl_nci_unregister_dev
>  release_firmware()           |   nfcmrvl_fw_dnld_abort
>   kfree(fw) //(1)             |    fw_dnld_over
>                               |     release_firmware
>   ...                         |      kfree(fw) //(2)
>                               |     ...
> 
> The second situation is shown below:
> 
>    (Thread 1)                 |      (Thread 2)
> nfcmrvl_fw_dnld_start         |
>  ...                          |
>  mod_timer                    |
>  (wait a time)                |
>  fw_dnld_timeout              |  nfcmrvl_nci_unregister_dev
>    fw_dnld_over               |   nfcmrvl_fw_dnld_abort
>     release_firmware          |    fw_dnld_over
>      kfree(fw) //(1)          |     release_firmware
>      ...                      |      kfree(fw) //(2)
> 
> The third situation is shown below:
> 
>        (Thread 1)               |       (Thread 2)
> nfcmrvl_nci_recv_frame          |
>  if(..->fw_download_in_progress)|
>   nfcmrvl_fw_dnld_recv_frame    |
>    queue_work                   |
>                                 |
> fw_dnld_rx_work                 | nfcmrvl_nci_unregister_dev
>  fw_dnld_over                   |  nfcmrvl_fw_dnld_abort
>   release_firmware              |   fw_dnld_over
>    kfree(fw) //(1)              |    release_firmware
>                                 |     kfree(fw) //(2)
> 
> The firmware struct is deallocated in position (1) and deallocated
> in position (2) again.
> 
> The crash trace triggered by POC is like below:
> 
> [  122.640457] BUG: KASAN: double-free or invalid-free in fw_dnld_over+0x28/0xf0
> [  122.640457] Call Trace:
> [  122.640457]  <TASK>
> [  122.640457]  kfree+0xb0/0x330
> [  122.640457]  fw_dnld_over+0x28/0xf0
> [  122.640457]  nfcmrvl_nci_unregister_dev+0x61/0x70
> [  122.640457]  nci_uart_tty_close+0x87/0xd0
> [  122.640457]  tty_ldisc_kill+0x3e/0x80
> [  122.640457]  tty_ldisc_hangup+0x1b2/0x2c0
> [  122.640457]  __tty_hangup.part.0+0x316/0x520
> [  122.640457]  tty_release+0x200/0x670
> [  122.640457]  __fput+0x110/0x410
> [  122.640457]  task_work_run+0x86/0xd0
> [  122.640457]  exit_to_user_mode_prepare+0x1aa/0x1b0
> [  122.640457]  syscall_exit_to_user_mode+0x19/0x50
> [  122.640457]  do_syscall_64+0x48/0x90
> [  122.640457]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  122.640457] RIP: 0033:0x7f68433f6beb
> 
> What's more, there are also use-after-free and null-ptr-deref bugs
> in nfcmrvl_fw_dnld_start. If we deallocate firmware struct, gpio or
> set null to the members of priv->fw_dnld in nfcmrvl_nci_unregister_dev,
> then, we dereference firmware, gpio or the members of priv->fw_dnld in
> nfcmrvl_fw_dnld_start, the UAF or NPD bugs will happen.
> 
> This patch reorders destructive operations after nci_unregister_device
> to avoid the double-free, UAF and NPD bugs, as nci_unregister_device
> is well synchronized and won't return if there is a running routine.
> This was mentioned in commit 3e3b5dfcd16a ("NFC: reorder the logic in
> nfc_{un,}register_device").
> 
> Fixes: 3194c6870158 ("NFC: nfcmrvl: add firmware download support")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> Reviewed-by: Lin Ma <linma@zju.edu.cn>

It's the first submission, how this review appeared?

On the other hand, you already sent something similar, so is it a v2? I
am sorry but this is very confusing. Looks like
https://lore.kernel.org/all/20220425005718.33639-1-duoming@zju.edu.cn/
but there is no changelog and commit description is different.

Please read:
https://elixir.bootlin.com/linux/v5.18-rc4/source/Documentation/process/submitting-patches.rst


> ---
>  drivers/nfc/nfcmrvl/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 


Best regards,
Krzysztof
