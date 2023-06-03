Return-Path: <netdev+bounces-7607-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A5C5720D79
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 04:51:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51ED21C2127D
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 02:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE92F179;
	Sat,  3 Jun 2023 02:51:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD53B1C06
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 02:51:19 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22ADB1B3;
	Fri,  2 Jun 2023 19:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685760677; x=1717296677;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lAwzLZszPemVEIxG2ZpxMfJ062GpzO5OYgJtv6ZOxd4=;
  b=DL8WfqEashvxwjpT0Zj3OmuZ/TIKw5K8f0pxvH1eS8prhk59hezJ6EeN
   m7K1plhUtOc0jmyNwvxvfuzwr1Nie8bz61GpatbFuNUI6AuwlrZmkVlyh
   ddXF+IuW2xqLCRflx3UMa/N+PzHOHFDRUNeyinlXJ/pUXcBMYc8x+9qMa
   iahHsMVw52AHAlNXoMvCna1jJclChWxk/8ACIltNUQ/IXojJVt+ghvW1V
   gJXBsdWiRnkO4Mt2tBWjV4Syr5+6C2gq7smhPDnPzPycYhl1M7/1nnvGU
   nlz8IwPwsreL9u87qUIUa0cD2YcN/jHLuTkaePFErGGFizmUBe/ad38H7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="421840748"
X-IronPort-AV: E=Sophos;i="6.00,214,1681196400"; 
   d="scan'208";a="421840748"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 19:51:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="702154100"
X-IronPort-AV: E=Sophos;i="6.00,214,1681196400"; 
   d="scan'208";a="702154100"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 02 Jun 2023 19:51:13 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q5HMH-0001CH-0M;
	Sat, 03 Jun 2023 02:51:13 +0000
Date: Sat, 3 Jun 2023 10:50:53 +0800
From: kernel test robot <lkp@intel.com>
To: Shunsuke Mie <mie@igel.co.jp>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Shunsuke Mie <mie@igel.co.jp>
Subject: Re: [PATCH v4 1/1] vringh: IOMEM support
Message-ID: <202306031019.wWKekRGz-lkp@intel.com>
References: <20230602055211.309960-2-mie@igel.co.jp>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602055211.309960-2-mie@igel.co.jp>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Shunsuke,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mst-vhost/linux-next]
[also build test WARNING on linus/master horms-ipvs/master v6.4-rc4 next-20230602]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shunsuke-Mie/vringh-IOMEM-support/20230602-135351
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
patch link:    https://lore.kernel.org/r/20230602055211.309960-2-mie%40igel.co.jp
patch subject: [PATCH v4 1/1] vringh: IOMEM support
config: nios2-randconfig-s053-20230531 (https://download.01.org/0day-ci/archive/20230603/202306031019.wWKekRGz-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 12.3.0
reproduce:
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/de2a1f5220c32e953400f225aba6bd294a8d41b8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Shunsuke-Mie/vringh-IOMEM-support/20230602-135351
        git checkout de2a1f5220c32e953400f225aba6bd294a8d41b8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=nios2 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=nios2 SHELL=/bin/bash drivers/vhost/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306031019.wWKekRGz-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/vhost/vringh.c:1630:21: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got struct vring_used_elem *dst @@
   drivers/vhost/vringh.c:1630:21: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/vhost/vringh.c:1630:21: sparse:     got struct vring_used_elem *dst
   drivers/vhost/vringh.c:592:18: sparse: sparse: restricted __virtio16 degrades to integer
   drivers/vhost/vringh.c:592:18: sparse: sparse: restricted __virtio16 degrades to integer
   drivers/vhost/vringh.c:592:18: sparse: sparse: cast to restricted __virtio16
   drivers/vhost/vringh.c:1280:23: sparse: sparse: restricted __virtio16 degrades to integer
   drivers/vhost/vringh.c:1280:23: sparse: sparse: restricted __virtio16 degrades to integer
   drivers/vhost/vringh.c:1280:23: sparse: sparse: cast to restricted __virtio16
>> drivers/vhost/vringh.c:1610:46: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got restricted __virtio16 const [usertype] *p @@
   drivers/vhost/vringh.c:1610:46: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/vhost/vringh.c:1610:46: sparse:     got restricted __virtio16 const [usertype] *p
>> drivers/vhost/vringh.c:1610:45: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted __virtio16 [usertype] val @@     got unsigned short @@
   drivers/vhost/vringh.c:1610:45: sparse:     expected restricted __virtio16 [usertype] val
   drivers/vhost/vringh.c:1610:45: sparse:     got unsigned short
>> drivers/vhost/vringh.c:1623:28: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void const *src @@
   drivers/vhost/vringh.c:1623:28: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/vhost/vringh.c:1623:28: sparse:     got void const *src
>> drivers/vhost/vringh.c:1637:28: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void *src @@
   drivers/vhost/vringh.c:1637:28: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/vhost/vringh.c:1637:28: sparse:     got void *src
>> drivers/vhost/vringh.c:1644:21: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void *dst @@
   drivers/vhost/vringh.c:1644:21: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/vhost/vringh.c:1644:21: sparse:     got void *dst
>> drivers/vhost/vringh.c:1616:34: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned short [usertype] value @@     got restricted __virtio16 @@
   drivers/vhost/vringh.c:1616:34: sparse:     expected unsigned short [usertype] value
   drivers/vhost/vringh.c:1616:34: sparse:     got restricted __virtio16
>> drivers/vhost/vringh.c:1616:46: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got restricted __virtio16 [usertype] *p @@
   drivers/vhost/vringh.c:1616:46: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/vhost/vringh.c:1616:46: sparse:     got restricted __virtio16 [usertype] *p
   drivers/vhost/vringh.c: note: in included file (through include/uapi/linux/swab.h, include/linux/swab.h, include/uapi/linux/byteorder/little_endian.h, ...):
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:25:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:25:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:25:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:25:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:25:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:31:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:25:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:25:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:25:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:25:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:25:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:25:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:25:24: sparse: sparse: too many arguments for function __builtin_custom_ini
   arch/nios2/include/uapi/asm/swab.h:25:24: sparse: sparse: too many arguments for function __builtin_custom_ini

vim +1630 drivers/vhost/vringh.c

  1606	
  1607	static inline int getu16_iomem(const struct vringh *vrh, u16 *val,
  1608				       const __virtio16 *p)
  1609	{
> 1610		*val = vringh16_to_cpu(vrh, ioread16(p));
  1611		return 0;
  1612	}
  1613	
  1614	static inline int putu16_iomem(const struct vringh *vrh, __virtio16 *p, u16 val)
  1615	{
> 1616		iowrite16(cpu_to_vringh16(vrh, val), p);
  1617		return 0;
  1618	}
  1619	
  1620	static inline int copydesc_iomem(const struct vringh *vrh, void *dst,
  1621					 const void *src, size_t len)
  1622	{
> 1623		memcpy_fromio(dst, src, len);
  1624		return 0;
  1625	}
  1626	
  1627	static int putused_iomem(const struct vringh *vrh, struct vring_used_elem *dst,
  1628				 const struct vring_used_elem *src, unsigned int num)
  1629	{
> 1630		memcpy_toio(dst, src, num * sizeof(*dst));
  1631		return 0;
  1632	}
  1633	
  1634	static inline int xfer_from_iomem(const struct vringh *vrh, void *src,
  1635					  void *dst, size_t len)
  1636	{
> 1637		memcpy_fromio(dst, src, len);
  1638		return 0;
  1639	}
  1640	
  1641	static inline int xfer_to_iomem(const struct vringh *vrh, void *dst, void *src,
  1642					size_t len)
  1643	{
> 1644		memcpy_toio(dst, src, len);
  1645		return 0;
  1646	}
  1647	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

