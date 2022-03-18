Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F104DE42E
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 23:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241359AbiCRWrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 18:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiCRWrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 18:47:18 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B87022AC72
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 15:45:58 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id w3-20020a4ac183000000b0031d806bbd7eso11831751oop.13
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 15:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ekiD2sX45IwGk6wtsqdwxLttTAGZcGccRjZl1i6g1JA=;
        b=dMDapo5gWo0mYQwoT0A/aOZqMdPyZSCOVsL5zPGffJvLJZp0AfN2E9xdlck/nSLv/N
         hEsSe5KNbjsmefIhgIIv1yDVHMP+6YIgd44fW9U2d/c1Akfns382n70WbM/10yIkuHjZ
         SUNIZp82WOT2MEcG49QwDBCrffF4++Gcu4CkY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ekiD2sX45IwGk6wtsqdwxLttTAGZcGccRjZl1i6g1JA=;
        b=WKXKfdpsq73sxBMvOfeHQq8XLgGQM4/RsbVTWkrd95Pg9ELnN1mWxznY1b8Mn7cq2w
         cru4WcU8meJD23q3ElKDKribjAAFLUxodrdWN1dtB2LtjVoYlprmFMDbmp1CZw4YqoCo
         nvZEX+Qf3j2cycQ0oxe0sXC1o95L2bbHWa4xgyrgW7jH//5YwJaX0L4GRH6AzVp7neUz
         QIhj25mCKlRAn2JAU0PbEw2XYi1UGfmmr3Iqc+GiZXfCV3IZX748W7JHWptjX0GbEyxk
         UZrF+5DT5vQIJFrnF7drCBCE8WD7Zor6Mn31Fp1R1T6u8jOf5Cn5Uut/JMJtDL0Ymr6L
         JcKg==
X-Gm-Message-State: AOAM533xp0yt8DMSobWNQNJXTaH461cIYAP7CoxHb/FTmc5T/qG8bE3w
        nc91h8FFFaXHrQu511WLhNi/Og==
X-Google-Smtp-Source: ABdhPJziihDBziDyTkE7iKcLTBW6BUUFUpCgkLWdsk/9MySxxcozoxXb4xoR4U6FbxLxPWes+cEMkA==
X-Received: by 2002:a05:6820:814:b0:322:b1b2:2456 with SMTP id bg20-20020a056820081400b00322b1b22456mr3591951oob.0.1647643557718;
        Fri, 18 Mar 2022 15:45:57 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id x12-20020a056830244c00b005ad233e0ba3sm4330223otr.48.2022.03.18.15.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 15:45:57 -0700 (PDT)
Subject: Re: [PATCH 7/9] usb: usbip: eliminate anonymous module_init &
 module_exit
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Amit Shah <amit@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Igor Kotrasinski <i.kotrasinsk@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Joachim Fritschi <jfritschi@freenet.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Karol Herbst <karolherbst@gmail.com>,
        Pekka Paalanen <ppaalanen@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, nouveau@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220316192010.19001-1-rdunlap@infradead.org>
 <20220316192010.19001-8-rdunlap@infradead.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <282f4857-7b4f-810e-af0e-e9ca8129c7fc@linuxfoundation.org>
Date:   Fri, 18 Mar 2022 16:45:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220316192010.19001-8-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/22 1:20 PM, Randy Dunlap wrote:
> Eliminate anonymous module_init() and module_exit(), which can lead to
> confusion or ambiguity when reading System.map, crashes/oops/bugs,
> or an initcall_debug log.
> 
> Give each of these init and exit functions unique driver-specific
> names to eliminate the anonymous names.
> 
> Example 1: (System.map)
>   ffffffff832fc78c t init
>   ffffffff832fc79e t init
>   ffffffff832fc8f8 t init
> 
> Example 2: (initcall_debug log)
>   calling  init+0x0/0x12 @ 1
>   initcall init+0x0/0x12 returned 0 after 15 usecs
>   calling  init+0x0/0x60 @ 1
>   initcall init+0x0/0x60 returned 0 after 2 usecs
>   calling  init+0x0/0x9a @ 1
>   initcall init+0x0/0x9a returned 0 after 74 usecs
> 
> Fixes: 80fd9cd52de6 ("usbip: vudc: Add VUDC main file")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Krzysztof Opasiak <k.opasiak@samsung.com>
> Cc: Igor Kotrasinski <i.kotrasinsk@samsung.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Valentina Manea <valentina.manea.m@gmail.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> ---
>   drivers/usb/usbip/vudc_main.c |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- lnx-517-rc8.orig/drivers/usb/usbip/vudc_main.c
> +++ lnx-517-rc8/drivers/usb/usbip/vudc_main.c
> @@ -28,7 +28,7 @@ static struct platform_driver vudc_drive
>   
>   static struct list_head vudc_devices = LIST_HEAD_INIT(vudc_devices);
>   
> -static int __init init(void)
> +static int __init vudc_init(void)
>   {
>   	int retval = -ENOMEM;
>   	int i;
> @@ -86,9 +86,9 @@ cleanup:
>   out:
>   	return retval;
>   }
> -module_init(init);
> +module_init(vudc_init);
>   
> -static void __exit cleanup(void)
> +static void __exit vudc_cleanup(void)
>   {
>   	struct vudc_device *udc_dev = NULL, *udc_dev2 = NULL;
>   
> @@ -103,7 +103,7 @@ static void __exit cleanup(void)
>   	}
>   	platform_driver_unregister(&vudc_driver);
>   }
> -module_exit(cleanup);
> +module_exit(vudc_cleanup);
>   
>   MODULE_DESCRIPTION("USB over IP Device Controller");
>   MODULE_AUTHOR("Krzysztof Opasiak, Karol Kosik, Igor Kotrasinski");
> 

Thanks for fixing this.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
