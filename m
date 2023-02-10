Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B636925BD
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbjBJSsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbjBJSsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:48:35 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D3944B6;
        Fri, 10 Feb 2023 10:48:21 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id a13so5763185ljq.6;
        Fri, 10 Feb 2023 10:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Un3RuNgUuXGsJqK22XSK4qt6d+DyNCQCjtzKzuT7iV8=;
        b=f9JS4IqNiocsgZc6Q/4lDcG5ZyE4R6yte4HjVwg25QhIMi0OxcI2Idc0Wsf2N0cXr8
         uYzJolc2LaVFTfA8998whggL4qW3+S0ZUuvjoqaAWLX2QkGgnlrsCSgnCSJ086ZxsDH8
         5Se49xq6SduTGP2z1hpH8RH9WDUUL/f8Y6ANP4f7finsEEDNbI09goPQXKMK06IMZlfm
         Tn87yF5WS5OLso/gv4LxnILz3sblGrUZjk3Ge7N3mDj+A8Ig7U30mEs+cUFmzSmKP8lX
         SIWtJnaMpxoky4iN/ylKMCQvYu4O5t0pumPq7vE42QANhx9i5M3B1e0/RiDJvplf8Ahf
         iMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Un3RuNgUuXGsJqK22XSK4qt6d+DyNCQCjtzKzuT7iV8=;
        b=SDJA/zXiHEBLztHAtIfNlqHwFSz0AZU4MNHlsFIx7tXA/Hxb9a2O6ip/xO1rpg4igc
         ivW8dEt35FlGMPwGn149XpousEyQhGHaTwufteTV9WJzrrCpYEKygSR7VQlDV8ZjljLS
         311RnnIFWJY+QDXiohE8khLTHJ1nu/zay0Eu+DKfas6ayfrEU/0Fm1VoW+t9Nnhrzv3d
         qM+aS7+k6CC5eVBUoiQTkXN6wZJa5edHwJTbRDaWA/7kppo9lJRMPIWdRet77gxhQY+e
         bAM1Fol0n9f9nD4DrmAjLpLOHfDncOr18qJccKzzxX2AWmtX3ERg6Iyz4G5ZlDTt4Bef
         fXTQ==
X-Gm-Message-State: AO0yUKUvhIlzSfnqLR+Rjz2Lpe0Hnv1d9CP2nYv7HbXl/PdggHXeyFNj
        9dcN4efc8hRY7VtRXq9aD5fqHlVp+vaRKtHFBoI=
X-Google-Smtp-Source: AK7set8VRS+sDgEAjIlJHWcEeXq4SCqwMaW9eBNL4x1j4y7j6PNnrHHn0QLhNZpl8G3BRlEZNZm327D7hQyW1CAeZVo=
X-Received: by 2002:a2e:8e32:0:b0:283:33bb:42a5 with SMTP id
 r18-20020a2e8e32000000b0028333bb42a5mr2276152ljk.29.1676054899654; Fri, 10
 Feb 2023 10:48:19 -0800 (PST)
MIME-Version: 1.0
References: <20230118122817.42466-4-francesco@dolcini.it> <202301241423.sEVD92vC-lkp@intel.com>
In-Reply-To: <202301241423.sEVD92vC-lkp@intel.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 10 Feb 2023 10:48:08 -0800
Message-ID: <CABBYNZLeccgTS81JksTngmbQ5Hk+ThSKDLW8V2qujT3O315u+w@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] Bluetooth: hci_mrvl: Add serdev support for 88W8997
To:     kernel test robot <lkp@intel.com>
Cc:     Francesco Dolcini <francesco@dolcini.it>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Francesco,

On Mon, Jan 23, 2023 at 10:38 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Francesco,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on robh/for-next]
> [also build test WARNING on bluetooth-next/master bluetooth/master horms-ipvs/master net/master net-next/master linus/master v6.2-rc5 next-20230123]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Francesco-Dolcini/dt-bindings-bluetooth-marvell-add-88W8997-DT-binding/20230118-210919
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
> patch link:    https://lore.kernel.org/r/20230118122817.42466-4-francesco%40dolcini.it
> patch subject: [PATCH v1 3/4] Bluetooth: hci_mrvl: Add serdev support for 88W8997
> config: hexagon-randconfig-r021-20230123 (https://download.01.org/0day-ci/archive/20230124/202301241423.sEVD92vC-lkp@intel.com/config)
> compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 4196ca3278f78c6e19246e54ab0ecb364e37d66a)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/2ae116c8ad209e0bf11559519915e511c44c28be
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Francesco-Dolcini/dt-bindings-bluetooth-marvell-add-88W8997-DT-binding/20230118-210919
>         git checkout 2ae116c8ad209e0bf11559519915e511c44c28be
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/bluetooth/ lib/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    In file included from drivers/bluetooth/hci_mrvl.c:12:
>    In file included from include/linux/skbuff.h:17:
>    In file included from include/linux/bvec.h:10:
>    In file included from include/linux/highmem.h:12:
>    In file included from include/linux/hardirq.h:11:
>    In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
>    In file included from include/asm-generic/hardirq.h:17:
>    In file included from include/linux/irq.h:20:
>    In file included from include/linux/io.h:13:
>    In file included from arch/hexagon/include/asm/io.h:334:
>    include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            val = __raw_readb(PCI_IOBASE + addr);
>                              ~~~~~~~~~~ ^
>    include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
>                                                            ~~~~~~~~~~ ^
>    include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
>    #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
>                                                      ^
>    In file included from drivers/bluetooth/hci_mrvl.c:12:
>    In file included from include/linux/skbuff.h:17:
>    In file included from include/linux/bvec.h:10:
>    In file included from include/linux/highmem.h:12:
>    In file included from include/linux/hardirq.h:11:
>    In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
>    In file included from include/asm-generic/hardirq.h:17:
>    In file included from include/linux/irq.h:20:
>    In file included from include/linux/io.h:13:
>    In file included from arch/hexagon/include/asm/io.h:334:
>    include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
>                                                            ~~~~~~~~~~ ^
>    include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
>    #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
>                                                      ^
>    In file included from drivers/bluetooth/hci_mrvl.c:12:
>    In file included from include/linux/skbuff.h:17:
>    In file included from include/linux/bvec.h:10:
>    In file included from include/linux/highmem.h:12:
>    In file included from include/linux/hardirq.h:11:
>    In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
>    In file included from include/asm-generic/hardirq.h:17:
>    In file included from include/linux/irq.h:20:
>    In file included from include/linux/io.h:13:
>    In file included from arch/hexagon/include/asm/io.h:334:
>    include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            __raw_writeb(value, PCI_IOBASE + addr);
>                                ~~~~~~~~~~ ^
>    include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
>                                                          ~~~~~~~~~~ ^
>    include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
>                                                          ~~~~~~~~~~ ^
> >> drivers/bluetooth/hci_mrvl.c:450:36: warning: unused variable 'mrvl_proto_8997' [-Wunused-const-variable]
>    static const struct hci_uart_proto mrvl_proto_8997 = {

This last error seems to be caused by your changes, please fix it.


-- 
Luiz Augusto von Dentz
