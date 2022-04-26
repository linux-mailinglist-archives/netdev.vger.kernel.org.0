Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7ED50FBD2
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 13:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349495AbiDZLUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 07:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346794AbiDZLUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 07:20:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D75D3A187
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 04:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650971845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=04oBpXRz9dQvTo95R2G0BWiNbQsIPh3agUFG6K2tgYI=;
        b=Wuw6fMd+ajnW8gK3q3V3jwlwZ+omDQEMkSqtIyfTOdAC57ku8I1ft4CmLC8yHCaMp9x1uU
        dBldBXt6y5eDfcKZLeIP+2GkMaQxzSKkxOy8BBvuZrPV6xjYIDJ8renoQWR7yNUDPk2wdA
        DcPc8NBZXY1MmJ7kced4jCj3NHUZXFs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-DoVxxV0KMbOveznLhnY4TQ-1; Tue, 26 Apr 2022 07:17:24 -0400
X-MC-Unique: DoVxxV0KMbOveznLhnY4TQ-1
Received: by mail-wr1-f71.google.com with SMTP id g7-20020adfbc87000000b0020ac76d254bso3018594wrh.6
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 04:17:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=04oBpXRz9dQvTo95R2G0BWiNbQsIPh3agUFG6K2tgYI=;
        b=x8+E2fc7MoWaMur/4NCLWcCs6Z7QGb1Gp2qJ1YIp3Y60vrOYTedW9ChvjK+hqF/SEx
         mP3kPsEQ+HxVbPiETCCnQGKAfwKqcABQP3Hiks16OAzB8MpVp41YI1TMOo5cOqHNndrR
         B2McM2bRGgHJ+i8JTHtudPe5blpo/TaRbhW147jB1/EUHIc4FyD02C+ySge9cthle2zG
         MqCrxyCve120vxQlQES/fbBabFn74qMKGCS5DLztEcwwGndX1ylvuhXN6QrLIKiIJph0
         rQqDm3cLVP0y3PSrVr/KSlt3KC5en6XXjyI7N/tXGTAAZLXWOcYsup8lE00kP7Wm2AD9
         CDSg==
X-Gm-Message-State: AOAM531yw/Nm1TkImuxBucPdcaha2yFHCRHe0aTlxS4XCENUBG/sSLJP
        KB9/kjM8eA7K8lB/qaYrdqJAqL/Ax8NlAQ865SuN8tR6h6549LW2pbHkgIJqq2b1AU4uOko09h6
        kThJgICN/VQtwZBUd
X-Received: by 2002:adf:e2cc:0:b0:203:e8ba:c709 with SMTP id d12-20020adfe2cc000000b00203e8bac709mr17958613wrj.713.1650971842744;
        Tue, 26 Apr 2022 04:17:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwStMLfSxqQ+OCcxnqnNJykkkim5r8J/AH+nTUbkq+OS93lq+pltJzm0pB+gFuBW0G98x8GLw==
X-Received: by 2002:adf:e2cc:0:b0:203:e8ba:c709 with SMTP id d12-20020adfe2cc000000b00203e8bac709mr17958586wrj.713.1650971842460;
        Tue, 26 Apr 2022 04:17:22 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-117-160.dyn.eolo.it. [146.241.117.160])
        by smtp.gmail.com with ESMTPSA id h10-20020a05600c414a00b0038ebb6884d8sm12422473wmm.0.2022.04.26.04.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 04:17:22 -0700 (PDT)
Message-ID: <57eae113432e286b7e279102220c21fcf0bd1306.camel@redhat.com>
Subject: Re: [PATCH net V2] nfc: nfcmrvl: main: reorder destructive
 operations in nfcmrvl_nci_unregister_dev to avoid bugs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Duoming Zhou <duoming@zju.edu.cn>, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org, linma@zju.edu.cn
Date:   Tue, 26 Apr 2022 13:17:21 +0200
In-Reply-To: <20220425095838.100882-1-duoming@zju.edu.cn>
References: <20220425095838.100882-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-04-25 at 17:58 +0800, Duoming Zhou wrote:
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

It looks like the above is not enough to close all the possible races,
specifically it looks like fw_dnld_timeout() and fw_dnld_rx_work() may
still race one vs another. 

I *think* that the approach you already suggested here:

https://lore.kernel.org/netdev/1d34425a0ea8a553a66dcf4f22ca55cc920dbb42.1649913521.git.duoming@zju.edu.cn/

should be safer - but you have to protect with the same spinlock even
every fw_dnld->fw modification.

@Lin Ma: I see you don't like the spinlock solution, but this other
option looks racing. Do you have other suggestions? (and/or would you
reconsider the spinlock?)

Thanks!

Paolo

