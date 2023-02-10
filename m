Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC546925EE
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbjBJTAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbjBJTAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:00:12 -0500
Received: from smtp-out-04.comm2000.it (smtp-out-04.comm2000.it [212.97.32.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CB47B381;
        Fri, 10 Feb 2023 11:00:10 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-04.comm2000.it (Postfix) with ESMTPSA id EBF28BC6EB6;
        Fri, 10 Feb 2023 20:00:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1676055609;
        bh=he/hI8oYQXLIhVCw08HW5MwQb36nena14e9fq5cTr50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=gIbpxh81kUZvl27dGs+OzlMyymyJdmT5H0/7hHzcBHtgh76LT8UtJKsVbo/y0ZaSN
         a5F1rioggdwF4zRQqxsjidMYxQYY8aMJaDlJxjIub/VB5F1OI+TtDAEYJxx8yNeAgo
         ycCAsgz+ApTe5TlptlLXaFZGxZrtwoseHht90EPss5ppo0AXRmR8xTiBiy+ptP9xwx
         HPir4/IvEpBROmIpf18JB36iNpXCu++CLes1fsL+fVzhXMZGN/f3fnr3lkpVrwgZz8
         7V9ElXnUfDa2w0JjKMk8EAmFxYmXDxREzV7bft2dtd+ZzLWN3tfYrmUW6uJu+pKFa2
         SkkxKMaGAcBbQ==
Date:   Fri, 10 Feb 2023 20:00:03 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     kernel test robot <lkp@intel.com>,
        Francesco Dolcini <francesco@dolcini.it>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev,
        Stefan Eichenberger <stefan.eichenberger@toradex.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: [PATCH v1 3/4] Bluetooth: hci_mrvl: Add serdev support for
 88W8997
Message-ID: <Y+aUM/gIDD+byG9k@francesco-nb.int.toradex.com>
References: <20230118122817.42466-4-francesco@dolcini.it>
 <202301241423.sEVD92vC-lkp@intel.com>
 <CABBYNZLeccgTS81JksTngmbQ5Hk+ThSKDLW8V2qujT3O315u+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABBYNZLeccgTS81JksTngmbQ5Hk+ThSKDLW8V2qujT3O315u+w@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 10:48:08AM -0800, Luiz Augusto von Dentz wrote:
> Hi Francesco,
> 
> On Mon, Jan 23, 2023 at 10:38 PM kernel test robot <lkp@intel.com> wrote:
> >
> > Hi Francesco,
> >
> > Thank you for the patch! Perhaps something to improve:
> >
> > [auto build test WARNING on robh/for-next]
> > [also build test WARNING on bluetooth-next/master bluetooth/master horms-ipvs/master net/master net-next/master linus/master v6.2-rc5 next-20230123]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Francesco-Dolcini/dt-bindings-bluetooth-marvell-add-88W8997-DT-binding/20230118-210919
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
> > patch link:    https://lore.kernel.org/r/20230118122817.42466-4-francesco%40dolcini.it
> > patch subject: [PATCH v1 3/4] Bluetooth: hci_mrvl: Add serdev support for 88W8997
> > config: hexagon-randconfig-r021-20230123 (https://download.01.org/0day-ci/archive/20230124/202301241423.sEVD92vC-lkp@intel.com/config)
> > compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 4196ca3278f78c6e19246e54ab0ecb364e37d66a)
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://github.com/intel-lab-lkp/linux/commit/2ae116c8ad209e0bf11559519915e511c44c28be
> >         git remote add linux-review https://github.com/intel-lab-lkp/linux
> >         git fetch --no-tags linux-review Francesco-Dolcini/dt-bindings-bluetooth-marvell-add-88W8997-DT-binding/20230118-210919
> >         git checkout 2ae116c8ad209e0bf11559519915e511c44c28be
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon olddefconfig
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/bluetooth/ lib/
> >
> > If you fix the issue, kindly add following tag where applicable
> > | Reported-by: kernel test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> >    In file included from drivers/bluetooth/hci_mrvl.c:12:
> >    In file included from include/linux/skbuff.h:17:
> >    In file included from include/linux/bvec.h:10:
> >    In file included from include/linux/highmem.h:12:
> >    In file included from include/linux/hardirq.h:11:
> >    In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
> >    In file included from include/asm-generic/hardirq.h:17:
> >    In file included from include/linux/irq.h:20:
> >    In file included from include/linux/io.h:13:
> >    In file included from arch/hexagon/include/asm/io.h:334:
> >    include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            val = __raw_readb(PCI_IOBASE + addr);
> >                              ~~~~~~~~~~ ^
> >    include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
> >                                                            ~~~~~~~~~~ ^
> >    include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
> >    #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
> >                                                      ^
> >    In file included from drivers/bluetooth/hci_mrvl.c:12:
> >    In file included from include/linux/skbuff.h:17:
> >    In file included from include/linux/bvec.h:10:
> >    In file included from include/linux/highmem.h:12:
> >    In file included from include/linux/hardirq.h:11:
> >    In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
> >    In file included from include/asm-generic/hardirq.h:17:
> >    In file included from include/linux/irq.h:20:
> >    In file included from include/linux/io.h:13:
> >    In file included from arch/hexagon/include/asm/io.h:334:
> >    include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
> >                                                            ~~~~~~~~~~ ^
> >    include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
> >    #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
> >                                                      ^
> >    In file included from drivers/bluetooth/hci_mrvl.c:12:
> >    In file included from include/linux/skbuff.h:17:
> >    In file included from include/linux/bvec.h:10:
> >    In file included from include/linux/highmem.h:12:
> >    In file included from include/linux/hardirq.h:11:
> >    In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
> >    In file included from include/asm-generic/hardirq.h:17:
> >    In file included from include/linux/irq.h:20:
> >    In file included from include/linux/io.h:13:
> >    In file included from arch/hexagon/include/asm/io.h:334:
> >    include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            __raw_writeb(value, PCI_IOBASE + addr);
> >                                ~~~~~~~~~~ ^
> >    include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
> >                                                          ~~~~~~~~~~ ^
> >    include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
> >                                                          ~~~~~~~~~~ ^
> > >> drivers/bluetooth/hci_mrvl.c:450:36: warning: unused variable 'mrvl_proto_8997' [-Wunused-const-variable]
> >    static const struct hci_uart_proto mrvl_proto_8997 = {
> 
> This last error seems to be caused by your changes, please fix it.


this is supposed to be fixed in v2.

