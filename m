Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C314C9A84
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 02:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238864AbiCBBjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 20:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiCBBjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 20:39:42 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18D590FF6;
        Tue,  1 Mar 2022 17:38:59 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2dc0364d2ceso1302267b3.7;
        Tue, 01 Mar 2022 17:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LLKlqKzUkpOU56hdk9SWA5R0Ik1JOWyqvR2LTFZ3yp4=;
        b=Rnp5rAoNtu3gDH1vuFvkBJe4LMgnykbZ4gg68qOtydwwKjZBtqKFlwjwGO+pZuD60X
         JaEQAxmYsbjLxavwgIp1IfqIpD+l3zczvOR4rkEWy7/zD+JnOopHsrnMbrANNvCH2AaZ
         EZSZBPhe333sYrSAuMGE4LJ0ZExqIC3xVF7RfX982mJKqr3fZpoZsI37CQjjFNHfN+Nt
         HO4vl0O73acYXD6d9OoE4N4wBougB0RPrpNQdBQq3gerBX2uWPB6DmkkZ7MSEPARfENP
         IVXm4cvtgTCPQDXpCNPMfbzYlznJBrmHeC6z8j0kzBt5uFLSRpb+RSedGfJYapZVCNuE
         SQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LLKlqKzUkpOU56hdk9SWA5R0Ik1JOWyqvR2LTFZ3yp4=;
        b=AtdhBwird9UMX2XUnalM1wsqiB7X28+IMg0cFcuVNpceJX32P0IuLHl/5bp3riPkKC
         PL093e7+KBlFkFeKbFEhs8nbmdcR0zdyroPOeSVZFe3/vSZwPve9fWlpWmhHCrrdKwhu
         KW8/h6kIpwortPzNrUvxiwcXM+wcx+PVul5FZb9TGd4XueGE4C/8uQCqSewZjE3M8djc
         OMnv/Ttznv71Nh+KXgOzCU5AwbjQvy/IaArHdKs6Lxmx0LYqWFKSQ/GGnSADjMqMxkHe
         vQg142WlHCQa6JJSkNIw2/BLalSF+AjHHIctwwWB/e8yXjb9AeQSsdZq32nqh0kCW44Z
         wgvw==
X-Gm-Message-State: AOAM5318896CcMk4NgKMQrI+pNHf5ujl1RDFkH+5W3OpfrSTjIMm9BdF
        E+28jqloN1VnduzFPSigDI8aw/4gkkL0oT3yGX5pmGXwR1K6RCy0
X-Google-Smtp-Source: ABdhPJziTwnIKRcvY5gcxujlb5q3AilceeEAXk/7Q9PmLTupqV6Wijp6ewP9aW2pqwztjVlZtI0xpRsOGqo3p2B+hjQ=
X-Received: by 2002:a0d:c383:0:b0:2d0:f04e:7ada with SMTP id
 f125-20020a0dc383000000b002d0f04e7adamr27474848ywd.229.1646185139206; Tue, 01
 Mar 2022 17:38:59 -0800 (PST)
MIME-Version: 1.0
References: <1646115417-24639-1-git-send-email-baihaowen88@gmail.com> <202203011855.FRrOViok-lkp@intel.com>
In-Reply-To: <202203011855.FRrOViok-lkp@intel.com>
From:   lotte bai <baihaowen88@gmail.com>
Date:   Wed, 2 Mar 2022 09:38:47 +0800
Message-ID: <CAFo17PhmubhDXMh=pudoAmYVfDhgwxPLECfUkZMRQpuhvoFTbw@mail.gmail.com>
Subject: Re: [PATCH] net: marvell: Use min() instead of doing it manually
To:     kernel test robot <lkp@intel.com>
Cc:     sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        kuba@kernel.org, llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

@Heiner Kallweit
Thank you for your kindly response.

kernel test robot <lkp@intel.com> =E4=BA=8E2022=E5=B9=B43=E6=9C=881=E6=97=
=A5=E5=91=A8=E4=BA=8C 18:30=E5=86=99=E9=81=93=EF=BC=9A

>
> Hi Haowen,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on net-next/master]
> [also build test WARNING on net/master horms-ipvs/master linus/master v5.=
17-rc6 next-20220228]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Haowen-Bai/net-marvell-U=
se-min-instead-of-doing-it-manually/20220301-141800
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.gi=
t f2b77012ddd5b2532d262f100be3394ceae3ea59
> config: hexagon-randconfig-r041-20220301 (https://download.01.org/0day-ci=
/archive/20220301/202203011855.FRrOViok-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271=
fc04d5b97b12e6b797c6067d3c96a8d7470e)
> reproduce (this is a W=3D1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbi=
n/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/55e43d9d6e3e0a8774e6a5e=
3976808e5736f6c9f
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Haowen-Bai/net-marvell-Use-min-i=
nstead-of-doing-it-manually/20220301-141800
>         git checkout 55e43d9d6e3e0a8774e6a5e3976808e5736f6c9f
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross W=
=3D1 O=3Dbuild_dir ARCH=3Dhexagon SHELL=3D/bin/bash drivers/net/ethernet/ma=
rvell/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> drivers/net/ethernet/marvell/mv643xx_eth.c:1664:21: warning: compariso=
n of distinct pointer types ('typeof (er->rx_pending) *' (aka 'unsigned int=
 *') and 'typeof (4096) *' (aka 'int *')) [-Wcompare-distinct-pointer-types=
]
>            mp->rx_ring_size =3D min(er->rx_pending, 4096);
>                               ^~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/minmax.h:45:19: note: expanded from macro 'min'
>    #define min(x, y)       __careful_cmp(x, y, <)
>                            ^~~~~~~~~~~~~~~~~~~~~~
>    include/linux/minmax.h:36:24: note: expanded from macro '__careful_cmp=
'
>            __builtin_choose_expr(__safe_cmp(x, y), \
>                                  ^~~~~~~~~~~~~~~~
>    include/linux/minmax.h:26:4: note: expanded from macro '__safe_cmp'
>                    (__typecheck(x, y) && __no_side_effects(x, y))
>                     ^~~~~~~~~~~~~~~~~
>    include/linux/minmax.h:20:28: note: expanded from macro '__typecheck'
>            (!!(sizeof((typeof(x) *)1 =3D=3D (typeof(y) *)1)))
>                       ~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~
>    1 warning generated.
>
>
> vim +1664 drivers/net/ethernet/marvell/mv643xx_eth.c
>
>   1653
>   1654  static int
>   1655  mv643xx_eth_set_ringparam(struct net_device *dev, struct ethtool_=
ringparam *er,
>   1656                            struct kernel_ethtool_ringparam *kernel=
_er,
>   1657                            struct netlink_ext_ack *extack)
>   1658  {
>   1659          struct mv643xx_eth_private *mp =3D netdev_priv(dev);
>   1660
>   1661          if (er->rx_mini_pending || er->rx_jumbo_pending)
>   1662                  return -EINVAL;
>   1663
> > 1664          mp->rx_ring_size =3D min(er->rx_pending, 4096);
>   1665          mp->tx_ring_size =3D clamp_t(unsigned int, er->tx_pending=
,
>   1666                                     MV643XX_MAX_SKB_DESCS * 2, 409=
6);
>   1667          if (mp->tx_ring_size !=3D er->tx_pending)
>   1668                  netdev_warn(dev, "TX queue size set to %u (reques=
ted %u)\n",
>   1669                              mp->tx_ring_size, er->tx_pending);
>   1670
>   1671          if (netif_running(dev)) {
>   1672                  mv643xx_eth_stop(dev);
>   1673                  if (mv643xx_eth_open(dev)) {
>   1674                          netdev_err(dev,
>   1675                                     "fatal error on re-opening dev=
ice after ring param change\n");
>   1676                          return -ENOMEM;
>   1677                  }
>   1678          }
>   1679
>   1680          return 0;
>   1681  }
>   1682
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
