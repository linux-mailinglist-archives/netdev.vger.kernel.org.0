Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910CE214E06
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 18:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgGEQsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 12:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgGEQsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 12:48:08 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349E0C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 09:48:08 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id o11so38246783wrv.9
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 09:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A2xoqgm4zPrRyWBu8p7ufKqdVMOdcDJT+txa+uZq4Ew=;
        b=paRCrvSlYxBooHHEuf7UMkIskiW7Xo9p/tF+usmnCp10MP7C9xhbXCrrceowTkWY+U
         acVk0m+USQPN18lBQ/sT5bzYmE3XwQKxcMkmw1kgIvHHIvym2M/tcbNftvhxyiy4wU66
         8a3UnjNKpeXedgaEykKrasnOH+tB3DJ8ak3n6kgB0yk5NKjw1g3qqTDM06PVAXvCYIr5
         sgJPJwetxO0vga2HO+wOS2MXz1iqooRsCXgQzYFmhUvCmIYhmqEJFuE8zvJP3ksc1aJv
         fz8hgWelSIvTRZ4rKX8OJsX+NpQMVjWlSU59MoHCzEh2KH5r3GE7m6Vnbdd8XvCEBP/z
         uelA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A2xoqgm4zPrRyWBu8p7ufKqdVMOdcDJT+txa+uZq4Ew=;
        b=Nu3bAlkGu9/VESf/be9Dkln27NDN3JxL37fy0EtUmODCGp0LSGmUSjFb/1OQopt0pk
         S++nCMzi96TS17xoyvX6seTRu4gsgw9dWuwc9GWyFKmc1yGrVcRNf/d+UboEOVv8YHaB
         n7S3qDjuy7+vqC2zp4dSeoJdVHdLZldYRCJmYs4vTP+6Nygar29NJHScZZ6FJDnmBJAL
         r8WUFtsw2Sa7glJCXh4nnR3ikzcSIBourLydMHSr69tYPBYs9e1nHLRto20nPKsE9z8P
         MFjTv3k2d6gU7e/BPIBhrpmeAgQ2uYKaXMMfkm+AhSIJj+vFTEJ4+XjjwdMQQGbuI/OQ
         bghw==
X-Gm-Message-State: AOAM532HLvU6Xg7f4lkPa86hUTE2WuhK8qJNyZUuAeCkFl6U+fGdvpce
        gzNNhmBkJcPeCYra0YEhsubBL+u/xHiTHndbxyM=
X-Google-Smtp-Source: ABdhPJyMY/GB+jEACvxzjzq0JNth+vG7UCC/CeBWEGRqYGoLXYTRoRton6y/7OQVeJ8Cj2X9qrQzI2PeSil9t1l3Q4Y=
X-Received: by 2002:adf:f5ce:: with SMTP id k14mr42979370wrp.234.1593967687010;
 Sun, 05 Jul 2020 09:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <c13ffdfb739d487a415897b72bf8eee6981830c6.1593502515.git.lucien.xin@gmail.com>
 <202007030758.OQAC7CGY%lkp@intel.com>
In-Reply-To: <202007030758.OQAC7CGY%lkp@intel.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 6 Jul 2020 00:57:48 +0800
Message-ID: <CADvbK_ebOEv-V+GZUtsmmOxsZSK4VKfkD5pHW_9K7ZoK_omFtA@mail.gmail.com>
Subject: Re: [PATCHv2 ipsec-next 09/10] xfrm: interface: support IP6IP6 and
 IP6IP tunnels processing with .cb_handler
To:     kernel test robot <lkp@intel.com>
Cc:     network dev <netdev@vger.kernel.org>, kbuild-all@lists.01.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 7:55 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Xin,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on ipsec-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Xin-Long/xfrm-support-ipip-and-ipv6-tunnels-in-vti-and-xfrmi/20200630-154042
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master
> config: x86_64-randconfig-a012-20200701 (attached as .config)
> compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
> reproduce (this is a W=1 build):
>         # save the attached .config to linux build tree
>         make W=1 ARCH=x86_64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    ld: net/xfrm/xfrm_interface.o: in function `xfrmi6_rcv_tunnel':
> >> net/xfrm/xfrm_interface.c:807: undefined reference to `xfrm6_tunnel_spi_lookup'
I will add  "#ifdef CONFIG_INET(6)_XFRM_TUNNEL" to fix it in v3.

Thanks.

>
> vim +807 net/xfrm/xfrm_interface.c
>
>    800
>    801  static int xfrmi6_rcv_tunnel(struct sk_buff *skb)
>    802  {
>    803          const xfrm_address_t *saddr;
>    804          __be32 spi;
>    805
>    806          saddr = (const xfrm_address_t *)&ipv6_hdr(skb)->saddr;
>  > 807          spi = xfrm6_tunnel_spi_lookup(dev_net(skb->dev), saddr);
>    808
>    809          return xfrm6_rcv_spi(skb, IPPROTO_IPV6, spi, NULL);
>    810  }
>    811
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
