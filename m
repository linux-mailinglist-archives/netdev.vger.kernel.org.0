Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1CD4E1B7B
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 13:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245036AbiCTMG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 08:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245034AbiCTMGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 08:06:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C5C4A37A98
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 05:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647777900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dluyFNWHj0wdqGZD9WiZi8hb8qI80pWjkbX+xynrT7U=;
        b=NatXzc0l1hN+DWDEjPhDLQWVCskvBWypGy0/f3JsM9la9Fem8I1WVXP33pw+FTDZ8EuMdk
        ecThVAuHL7OiXJFuy4MV+aaotNm88zM6FWkAPaVh3A77efiyU6Zz2Qk1S062nUElNwFZ3i
        XJRCrJqBaQxcHKASe9+UIymvmIj7i/Y=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-EbryE1QqNI-NBG1g8qqp0A-1; Sun, 20 Mar 2022 08:04:59 -0400
X-MC-Unique: EbryE1QqNI-NBG1g8qqp0A-1
Received: by mail-ej1-f71.google.com with SMTP id hz15-20020a1709072cef00b006dfeceff2d1so644340ejc.17
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 05:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dluyFNWHj0wdqGZD9WiZi8hb8qI80pWjkbX+xynrT7U=;
        b=dMGAKjqztWJlKpkEJQrayO155fp2EurDtYy984etML5YEzgpAKyjc6jnG8O7CS2kr4
         6ndkweZEE93pHgpOQCJ3IzDg3/FB9ehBTZljmUa0ZiC1Q2inWeWKw41Ch+yjFXcfa1Cn
         rozSBDUBrqy4zikfGPgXaNiC0yczIO0R5+x4vPcZcgeUGEWnHkG5Nyv6IY9CNY//mKfF
         Xstj9kSYIHoFLDLC/uduxwMTBaG7+pS0aRQn9j4gjOCZ75UQFyHj7/MY7jnGjRGWE8xj
         6kO8OGYu4X+lCtwVWIr88kGmhgSw3qlEb+OqkV6P5Nf31xRedeINVr6zdG47h/9I1PQj
         C56w==
X-Gm-Message-State: AOAM533LztfLC+CDRJgS8kJB3IrPYSbrkTv28ZZkmcBF5nqABRJD2c2j
        lxyM5hB6IciQ01Zpkz8UyW7f/kZ175yE+8SDf7v1Xw56HXsoTwAXygLYG2VN0XVyRPCddcIdkoH
        JA9Z8841r/5u/kaLD
X-Received: by 2002:a05:6402:40c5:b0:418:e73c:a1ab with SMTP id z5-20020a05640240c500b00418e73ca1abmr18517080edb.52.1647777898156;
        Sun, 20 Mar 2022 05:04:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfAQhzmlNy6q9yY+EnFX+2g1gYETe+axmQh3kzhVOc32at9/0TqUx+j50nzMAK4FS++1BWlA==
X-Received: by 2002:a05:6402:40c5:b0:418:e73c:a1ab with SMTP id z5-20020a05640240c500b00418e73ca1abmr18517008edb.52.1647777897820;
        Sun, 20 Mar 2022 05:04:57 -0700 (PDT)
Received: from redhat.com ([2.55.132.0])
        by smtp.gmail.com with ESMTPSA id 27-20020a17090600db00b006df6b34d9b8sm5854831eji.211.2022.03.20.05.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 05:04:57 -0700 (PDT)
Date:   Sun, 20 Mar 2022 08:04:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
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
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Igor Kotrasinski <i.kotrasinsk@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
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
        virtualization@lists.linux-foundation.org, x86@kernel.org
Subject: Re: [PATCH 2/9] virtio_console: eliminate anonymous module_init &
 module_exit
Message-ID: <20220320080438-mutt-send-email-mst@kernel.org>
References: <20220316192010.19001-1-rdunlap@infradead.org>
 <20220316192010.19001-3-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316192010.19001-3-rdunlap@infradead.org>
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 12:20:03PM -0700, Randy Dunlap wrote:
> Eliminate anonymous module_init() and module_exit(), which can lead to
> confusion or ambiguity when reading System.map, crashes/oops/bugs,
> or an initcall_debug log.
> 
> Give each of these init and exit functions unique driver-specific
> names to eliminate the anonymous names.
> 
> Example 1: (System.map)
>  ffffffff832fc78c t init
>  ffffffff832fc79e t init
>  ffffffff832fc8f8 t init
> 
> Example 2: (initcall_debug log)
>  calling  init+0x0/0x12 @ 1
>  initcall init+0x0/0x12 returned 0 after 15 usecs
>  calling  init+0x0/0x60 @ 1
>  initcall init+0x0/0x60 returned 0 after 2 usecs
>  calling  init+0x0/0x9a @ 1
>  initcall init+0x0/0x9a returned 0 after 74 usecs
> 
> Fixes: 31610434bc35 ("Virtio console driver")
> Fixes: 7177876fea83 ("virtio: console: Add ability to remove module")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Amit Shah <amit@kernel.org>
> Cc: virtualization@lists.linux-foundation.org
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


If this is done tree-wide, it's ok to do it for virtio too.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

No real opinion on whether it's a good idea.


> ---
>  drivers/char/virtio_console.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- lnx-517-rc8.orig/drivers/char/virtio_console.c
> +++ lnx-517-rc8/drivers/char/virtio_console.c
> @@ -2245,7 +2245,7 @@ static struct virtio_driver virtio_rproc
>  	.remove =	virtcons_remove,
>  };
>  
> -static int __init init(void)
> +static int __init virtio_console_init(void)
>  {
>  	int err;
>  
> @@ -2280,7 +2280,7 @@ free:
>  	return err;
>  }
>  
> -static void __exit fini(void)
> +static void __exit virtio_console_fini(void)
>  {
>  	reclaim_dma_bufs();
>  
> @@ -2290,8 +2290,8 @@ static void __exit fini(void)
>  	class_destroy(pdrvdata.class);
>  	debugfs_remove_recursive(pdrvdata.debugfs_dir);
>  }
> -module_init(init);
> -module_exit(fini);
> +module_init(virtio_console_init);
> +module_exit(virtio_console_fini);
>  
>  MODULE_DESCRIPTION("Virtio console driver");
>  MODULE_LICENSE("GPL");

