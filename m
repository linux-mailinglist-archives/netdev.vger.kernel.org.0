Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9494DBDAF
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 04:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiCQDfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 23:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiCQDf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 23:35:26 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D815EBCF;
        Wed, 16 Mar 2022 20:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647488041; x=1679024041;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=fvSysYrUKMfGk8/VVxHhcMOBMFAuiZiHLOX32nrDtbU=;
  b=ijtUhERXG3Cy/OyvJ+RNLnnZ5+yQSuWExjPEYB6Uya4KUqOLlGBlfy4n
   VokXRrEApHQCN8C9fgZVoqSGqMVIDMlzdK1vJpDj4d60B5c8GD7YINXuQ
   /ap/w+IUoRT0L8EUC2eRakgNkOtMwpgefpIGaHH8IzbYT5p1++4a1q/+q
   uMZbG7GFB7Jh7y7Mgds5Cjj6g2JZ0DqL7RdfVsVhPCTfHWM8FAXdXtjZ9
   qk+aw/9gi3GGCXlsWJeSu8EcHsvVsDLnbEeVqJj8gPQ8i+iVOdgT26ZUE
   wOmnRv5brtQ/iJ88qhIomSeXO8CfnfHLexCjAAOWxuHyBuTlS3KopbNyx
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="238935622"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="238935622"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 20:32:55 -0700
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="613867506"
Received: from mbhanuva-mobl.amr.corp.intel.com (HELO localhost) ([10.212.30.158])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 20:32:54 -0700
Date:   Wed, 16 Mar 2022 20:32:54 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
Subject: Re: [PATCH 0/9] treewide: eliminate anonymous module_init &
 module_exit
Message-ID: <YjKr5vU6Vu8iW8VL@iweiny-desk3>
References: <20220316192010.19001-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220316192010.19001-1-rdunlap@infradead.org>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 12:20:01PM -0700, Randy Dunlap wrote:
> There are a number of drivers that use "module_init(init)" and
> "module_exit(exit)", which are anonymous names and can lead to
> confusion or ambiguity when reading System.map, crashes/oops/bugs,
> or an initcall_debug log.
> 
> Give each of these init and exit functions unique driver-specific
> names to eliminate the anonymous names.

I'm not fully sure about the Fixes tags but I don't see that it hurts anything.

For the series:

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> 
> Example 1: (System.map)
>  ffffffff832fc78c t init
>  ffffffff832fc79e t init
>  ffffffff832fc8f8 t init
>  ffffffff832fca05 t init
>  ffffffff832fcbd2 t init
>  ffffffff83328f0e t init
>  ffffffff8332c5b1 t init
>  ffffffff8332d9eb t init
>  ffffffff8332f0aa t init
>  ffffffff83330e25 t init
>  ffffffff833317a5 t init
>  ffffffff8333dd6b t init
> 
> Example 2: (initcall_debug log)
>  calling  init+0x0/0x12 @ 1
>  initcall init+0x0/0x12 returned 0 after 15 usecs
>  calling  init+0x0/0x60 @ 1
>  initcall init+0x0/0x60 returned 0 after 2 usecs
>  calling  init+0x0/0x9a @ 1
>  initcall init+0x0/0x9a returned 0 after 74 usecs
>  calling  init+0x0/0x73 @ 1
>  initcall init+0x0/0x73 returned 0 after 6 usecs
>  calling  init+0x0/0x73 @ 1
>  initcall init+0x0/0x73 returned 0 after 4 usecs
>  calling  init+0x0/0xf5 @ 1
>  initcall init+0x0/0xf5 returned 0 after 27 usecs
>  calling  init+0x0/0x7d @ 1
>  initcall init+0x0/0x7d returned 0 after 11 usecs
>  calling  init+0x0/0xc9 @ 1
>  initcall init+0x0/0xc9 returned 0 after 19 usecs
>  calling  init+0x0/0x9d @ 1
>  initcall init+0x0/0x9d returned 0 after 37 usecs
>  calling  init+0x0/0x63f @ 1
>  initcall init+0x0/0x63f returned 0 after 411 usecs
>  calling  init+0x0/0x171 @ 1
>  initcall init+0x0/0x171 returned 0 after 61 usecs
>  calling  init+0x0/0xef @ 1
>  initcall init+0x0/0xef returned 0 after 3 usecs
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Amit Shah <amit@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Eli Cohen <eli@mellanox.com>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
> Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Krzysztof Opasiak <k.opasiak@samsung.com>
> Cc: Igor Kotrasinski <i.kotrasinsk@samsung.com>
> Cc: Valentina Manea <valentina.manea.m@gmail.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Cc: Joachim Fritschi <jfritschi@freenet.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Karol Herbst <karolherbst@gmail.com>
> Cc: Pekka Paalanen <ppaalanen@gmail.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: netfilter-devel@vger.kernel.org
> Cc: coreteam@netfilter.org
> Cc: netdev@vger.kernel.org
> Cc: linux-block@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: nouveau@lists.freedesktop.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: x86@kernel.org
> 
> patches:
>  [PATCH 1/9] virtio_blk: eliminate anonymous module_init & module_exit
>  [PATCH 2/9] virtio_console: eliminate anonymous module_init & module_exit
>  [PATCH 3/9] net: mlx5: eliminate anonymous module_init & module_exit
>  [PATCH 4/9] netfilter: h323: eliminate anonymous module_init & module_exit
>  [PATCH 5/9] virtio-scsi: eliminate anonymous module_init & module_exit
>  [PATCH 6/9] usb: gadget: eliminate anonymous module_init & module_exit
>  [PATCH 7/9] usb: usbip: eliminate anonymous module_init & module_exit
>  [PATCH 8/9] x86/crypto: eliminate anonymous module_init & module_exit
>  [PATCH 9/9] testmmiotrace: eliminate anonymous module_init & module_exit
> 
> diffstat:
>  arch/x86/crypto/blowfish_glue.c                |    8 ++++----
>  arch/x86/crypto/camellia_glue.c                |    8 ++++----
>  arch/x86/crypto/serpent_avx2_glue.c            |    8 ++++----
>  arch/x86/crypto/twofish_glue.c                 |    8 ++++----
>  arch/x86/crypto/twofish_glue_3way.c            |    8 ++++----
>  arch/x86/mm/testmmiotrace.c                    |    8 ++++----
>  drivers/block/virtio_blk.c                     |    8 ++++----
>  drivers/char/virtio_console.c                  |    8 ++++----
>  drivers/net/ethernet/mellanox/mlx5/core/main.c |    8 ++++----
>  drivers/scsi/virtio_scsi.c                     |    8 ++++----
>  drivers/usb/gadget/legacy/inode.c              |    8 ++++----
>  drivers/usb/gadget/legacy/serial.c             |   10 +++++-----
>  drivers/usb/gadget/udc/dummy_hcd.c             |    8 ++++----
>  drivers/usb/usbip/vudc_main.c                  |    8 ++++----
>  net/ipv4/netfilter/nf_nat_h323.c               |    8 ++++----
>  15 files changed, 61 insertions(+), 61 deletions(-)
