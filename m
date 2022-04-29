Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295A051434B
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 09:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355163AbiD2HbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 03:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351280AbiD2HbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 03:31:09 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DCAB7C50
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 00:27:51 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id i19so13734406eja.11
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 00:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=426SeVWvTBmWgp6+vPEzTWxW/V3Y1qoClMQITyweQyc=;
        b=WBAcf6TEIg34iHR5Q6qjksGSsHPJYHpPDK/N7znrFFj6U5Z46bBJLDuzEb/FZr1aCe
         ePthdh5JB+98RNNM16+mP8b1GfYQkeG51HO014+IZyTabyz1xSEjlOplyekq0Jomp1Qi
         ZALZk0xwG0wtcmRXWXnpGPjRGwWZlxMHYqmqhTUpnHx5yxl1GPRiIU4HbVBwyy395+wo
         vmNSONT6e0ac8tkdJTMhv1l1x8Or3RHG4t16/Wnv1UCXWn3EFiEuUHXFlixUuJfwm78J
         A2Ej0WRYhjp0S2CXLzGGay2R1J7habn1I9kbpeXHMx6274qT7e06f/O2jzPdXH4cLvWK
         R2iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=426SeVWvTBmWgp6+vPEzTWxW/V3Y1qoClMQITyweQyc=;
        b=RU3UR/muSBgHJRIgQLw46Oi2wKmXuGPDDxGFO/fXsbBPCc5cbeOxsJr2eVoqsKhNJO
         q5lGt+KAkDEUaqKqFLPcx34efhb+vlIYyNuQ5JVwrw3rHnHA0qIB/O0GNuR0Otn+xzCA
         11iyvrvv8kUyUDC9Z3Ajx8wifm2utkql7LRJetYQs/xf91ikO5dxPIf15Czen0qN8pv/
         dv8qkG3ytDtFFd854D2As+gUXjyONz/mSRLO/+cb7SfhrbYleIfHpzYHGZHcgGr9QtsB
         WOCh67uiLMQ8O5sSIK1w7PZ2ByY2sc0JscC5qdixLvDOttdwES3xThsbKrj7AVg/Scy9
         gQdQ==
X-Gm-Message-State: AOAM533P5vt7VSSoRVk4a2b8iN1ujg2RCwP6mV+sd9oGF15k0Y8DfNOW
        JkjbUnD7wCA7r5O8f4vChNjg0g==
X-Google-Smtp-Source: ABdhPJw61ElsVvSXRmO9oRGAiiYwCtNWvDn03Ok8U7W7hzZ1gKvbMzTpdaucHTW9sQfJXQtYZj7Sog==
X-Received: by 2002:a17:906:99c5:b0:6df:8215:4ccd with SMTP id s5-20020a17090699c500b006df82154ccdmr35473631ejn.684.1651217270514;
        Fri, 29 Apr 2022 00:27:50 -0700 (PDT)
Received: from [192.168.0.169] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id r22-20020a056402035600b00425d6c76494sm2574635edw.1.2022.04.29.00.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 00:27:49 -0700 (PDT)
Message-ID: <8656d527-94ab-228f-66f1-06e5d533e16a@linaro.org>
Date:   Fri, 29 Apr 2022 09:27:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v5 2/2] nfc: nfcmrvl: main: reorder destructive
 operations in nfcmrvl_nci_unregister_dev to avoid bugs
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org,
        kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org, linma@zju.edu.cn
References: <cover.1651194245.git.duoming@zju.edu.cn>
 <bb2769acc79f42d25d61ed8988c8d240c8585f33.1651194245.git.duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <bb2769acc79f42d25d61ed8988c8d240c8585f33.1651194245.git.duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2022 03:14, Duoming Zhou wrote:
> There are destructive operations such as nfcmrvl_fw_dnld_abort and
> gpio_free in nfcmrvl_nci_unregister_dev. The resources such as firmware,
> gpio and so on could be destructed while the upper layer functions such as
> nfcmrvl_fw_dnld_start and nfcmrvl_nci_recv_frame is executing, which leads
> to double-free, use-after-free and null-ptr-deref bugs.
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

How exactly the case here is being prevented?

If nfcmrvl_nci_unregister_dev() happens slightly earlier, before
fw_dnld_timeout() on the left side (T1), the T1 will still hit it, won't it?


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

Please always strip unrelated parts of oops, so minimum the timing. The
addresses could be removed as well.

> 
> What's more, there are also use-after-free and null-ptr-deref bugs
> in nfcmrvl_fw_dnld_start. If we deallocate firmware struct, gpio or
> set null to the members of priv->fw_dnld in nfcmrvl_nci_unregister_dev,
> then, we dereference firmware, gpio or the members of priv->fw_dnld in
> nfcmrvl_fw_dnld_start, the UAF or NPD bugs will happen.
> 
> This patch reorders destructive operations after nci_unregister_device
> and uses bool variable in nfc_dev to synchronize between cleanup routine
> and firmware download routine. The process is shown below.
> 
>        (Thread 1)                 |       (Thread 2)
> nfcmrvl_nci_unregister_dev        |
>   nci_unregister_device           |
>     nfc_unregister_device         | nfc_fw_download
>       device_lock()               |
>       ...                         |
>       dev->dev_register = false;  |   ...
>       device_unlock()             |
>   ...                             |   device_lock()
>   (destructive operations)        |   if(!dev->dev_register)
>                                   |     goto error;
>                                   | error:
>                                   |   device_unlock()

How T2 calls appeared here? They were not present in any of your
previous process-examples...

> 
> If the device is detaching, the download function will goto error.
> If the download function is executing, nci_unregister_device will
> wait until download function is finished.
> 
> Fixes: 3194c6870158 ("NFC: nfcmrvl: add firmware download support")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
> Changes in v5:
>   - Use bool variable added in patch 1/2 to synchronize.
> 
>  drivers/nfc/nfcmrvl/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
> index 2fcf545012b..1a5284de434 100644
> --- a/drivers/nfc/nfcmrvl/main.c
> +++ b/drivers/nfc/nfcmrvl/main.c
> @@ -183,6 +183,7 @@ void nfcmrvl_nci_unregister_dev(struct nfcmrvl_private *priv)
>  {
>  	struct nci_dev *ndev = priv->ndev;
>  
> +	nci_unregister_device(ndev);
>  	if (priv->ndev->nfc_dev->fw_download_in_progress)
>  		nfcmrvl_fw_dnld_abort(priv);
>  
> @@ -191,7 +192,6 @@ void nfcmrvl_nci_unregister_dev(struct nfcmrvl_private *priv)
>  	if (gpio_is_valid(priv->config.reset_n_io))
>  		gpio_free(priv->config.reset_n_io);
>  
> -	nci_unregister_device(ndev);
>  	nci_free_device(ndev);
>  	kfree(priv);
>  }


Best regards,
Krzysztof
