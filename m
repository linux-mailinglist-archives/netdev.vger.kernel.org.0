Return-Path: <netdev+bounces-5943-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D29A0713801
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 08:27:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E5481C20940
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 06:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F71366;
	Sun, 28 May 2023 06:27:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C925565D
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 06:27:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4024FDC
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 23:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685255245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qd1HsDPoIQCA1W8M9wRkc4OBlzVkt6/Jqm85Xt985zA=;
	b=VoAnEOLvwQPpXS7B1WHtXlhuhwwb8FtoIkCfqONequm3c0nt43u38jndYC3IzGvBzZddwI
	PK6vwicUSxnFkmcECyV6RKj+R0SbDdzShYT/AKvVoDCzDGjiKOQIOCpXJ78N909NUlBYHV
	8P9YwER4v8rKONczqqfAw0gJc4cqyaU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-9Mq45xi4Ma-x7nStC8vSMg-1; Sun, 28 May 2023 02:27:23 -0400
X-MC-Unique: 9Mq45xi4Ma-x7nStC8vSMg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30ad0812151so1256561f8f.3
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 23:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685255242; x=1687847242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qd1HsDPoIQCA1W8M9wRkc4OBlzVkt6/Jqm85Xt985zA=;
        b=DS99yy75/u83g4OrX5BpLpPJiqDiWxdCNpqpmWDW/PnWWrngaZHvg/1ghZMT0SjE86
         DQc8dBoCa9Ag5H0s4XnBtPKiHt5TyVRvt6+S6lPr9tGnQVIa9ZU8HAztGRmF7PY6WdyZ
         tvSSQiuk2pDy1s1onwVfwQCIFk21ljSFsgFrmNypd7T09TKQEdTbchn7aAMgf0NN8KYk
         ToiLA3spnP4Lnl6bpPogRy7SI/5xyHNdoNRXeilB0YgTRQct1NowEPJLGkBahWzHRCIe
         a4fbWsJvZiCt6w6V+jyM4hI727A2Su9PRFX5msZw7aPXl2i2Rce+OckRGw6oKrPUgPlU
         dCQA==
X-Gm-Message-State: AC+VfDwlyWzvVpG5CZCCfsDseh2p5adOqB0HVuBBMO2WcM7UMDSYQdMU
	nYvfilKBIUjmwovwGPhK6EfoIim4c4vPx6XoZLym+L0RWX+ifJbwoV5klGFNGISvgz4WHTpPk3Y
	nMySfu7+qDFlt1m3W
X-Received: by 2002:a5d:4746:0:b0:307:a36b:e7b1 with SMTP id o6-20020a5d4746000000b00307a36be7b1mr6251105wrs.5.1685255242762;
        Sat, 27 May 2023 23:27:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ45TZmWQVMRhP5RvxBOirJj2cEFa5HQb7lqFSHk19mNXmZUM8pT5LmgfgqJSeZVjSeHHK6LuA==
X-Received: by 2002:a5d:4746:0:b0:307:a36b:e7b1 with SMTP id o6-20020a5d4746000000b00307a36be7b1mr6251097wrs.5.1685255242491;
        Sat, 27 May 2023 23:27:22 -0700 (PDT)
Received: from redhat.com ([2.52.146.27])
        by smtp.gmail.com with ESMTPSA id q1-20020a1ce901000000b003f423dfc686sm10083677wmc.45.2023.05.27.23.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 23:27:21 -0700 (PDT)
Date: Sun, 28 May 2023 02:27:17 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kernel test robot <lkp@intel.com>
Cc: Liang Chen <liangchen.linux@gmail.com>, jasowang@redhat.com,
	oe-kbuild-all@lists.linux.dev,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com,
	kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
	pabeni@redhat.com, alexander.duyck@gmail.com
Subject: Re: [PATCH net-next 2/5] virtio_net: Add page_pool support to
 improve performance
Message-ID: <20230528022658-mutt-send-email-mst@kernel.org>
References: <20230526054621.18371-2-liangchen.linux@gmail.com>
 <202305262334.GiFQ3wpG-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202305262334.GiFQ3wpG-lkp@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023 at 12:11:25AM +0800, kernel test robot wrote:
> Hi Liang,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on net-next/main]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Liang-Chen/virtio_net-Add-page_pool-support-to-improve-performance/20230526-135805
> base:   net-next/main
> patch link:    https://lore.kernel.org/r/20230526054621.18371-2-liangchen.linux%40gmail.com
> patch subject: [PATCH net-next 2/5] virtio_net: Add page_pool support to improve performance
> config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20230526/202305262334.GiFQ3wpG-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/intel-lab-lkp/linux/commit/bfba563f43bba37181d8502cb2e566c32f96ec9e
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Liang-Chen/virtio_net-Add-page_pool-support-to-improve-performance/20230526-135805
>         git checkout bfba563f43bba37181d8502cb2e566c32f96ec9e
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=x86_64 olddefconfig
>         make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202305262334.GiFQ3wpG-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    ld: vmlinux.o: in function `virtnet_find_vqs':
> >> virtio_net.c:(.text+0x901fb5): undefined reference to `page_pool_create'
>    ld: vmlinux.o: in function `add_recvbuf_mergeable.isra.0':
> >> virtio_net.c:(.text+0x905618): undefined reference to `page_pool_alloc_pages'
>    ld: vmlinux.o: in function `xdp_linearize_page':
>    virtio_net.c:(.text+0x906b6b): undefined reference to `page_pool_alloc_pages'
>    ld: vmlinux.o: in function `mergeable_xdp_get_buf.isra.0':
>    virtio_net.c:(.text+0x90728f): undefined reference to `page_pool_alloc_pages'


you need to tweak Kconfig to select PAGE_POOL I think.

> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki


