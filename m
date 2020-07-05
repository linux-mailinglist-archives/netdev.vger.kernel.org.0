Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765B0214E02
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 18:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgGEQr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 12:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgGEQr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 12:47:27 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14515C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 09:47:27 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f2so10248113wrp.7
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 09:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sb5x4d5r+yMutzzmFAifZEUxsPWeybJCbpYWhTtRtdk=;
        b=Jec0pTZOPMhAg4j5gnsG01x7lBDneh+N3xqG3WXZs53ubmS4hsrdJXOYLrKj4kCE9c
         qk9nf1RBLCkKFk2fQLxW2LpSqU4iPg+i8Mh9Q2LyvCpQzHFp0Oh0WM0tJ+I+u0VhX0tr
         QlS7W7Y+Uf/zOiXnk2M3ItWeuQNs6Gcx03xjxdqORuoX1sNhNKKgP7GFZYM5AEOqCIuy
         Ui2HKYi+0+gcDkzGixEDVLRvnMnkdrMqGN4fdo9EpX/UeIyw2npSZDQqSGRTpRWrmdcu
         fvP9+Jsyvt6TCFl/Jl5CfGit+KtqQZ+l1XwtJcHtGjta7NNbLy5jPThg5h5trin4zHjR
         KnUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sb5x4d5r+yMutzzmFAifZEUxsPWeybJCbpYWhTtRtdk=;
        b=FmzS5B+ODzSpjB2eM99x6zKFhSM+r/JhaAYjJSmPpFY8NSJqA5oUfDBikjrre9pl+g
         GCnDhrjwJuD0G+Qbkgk1L0OY/iwyCWHlxSnLaSpsBUj4sP5MT7G19FdqO7QZzHRkr3gn
         uPPbyDbS2qU8IBkIk71CfaLfAHTGSgX3rgwkg5TT7z45X37AmhQrr6sL8evg+g7VPmHl
         NawsauCAG+Ht+Eeze+g+rMvDNERBfyvgs9IEa+yh8bXtSbd8ntreh+ZStQAQi+7COWGu
         9v0hkb0s6MHaK1sW6lbrBfb7XXnx9W+NMXPREKJ+QeTzBcbyB3shar7vSIiKlN6teuz7
         wDoQ==
X-Gm-Message-State: AOAM530gfOBwBduwabbxwQ8d9vnl6TBmLdCMwjCxx9cF+p+bK9xPUeok
        agTdir7e4q8BK+vqixj276vZcUqa7rc+HVGLOHr08tpb
X-Google-Smtp-Source: ABdhPJxy49I/Rw7z7lLyF4lP1oABmEpwKFloZhieQXzBNJ4s6tzz5dfLSHzpcTKSmnnzmNx0sofC5ZGg+fRuQxkrV9Q=
X-Received: by 2002:adf:f34e:: with SMTP id e14mr44733071wrp.299.1593967645704;
 Sun, 05 Jul 2020 09:47:25 -0700 (PDT)
MIME-Version: 1.0
References: <1b18c11f965775fed2647eb78071af89177a70b5.1593502515.git.lucien.xin@gmail.com>
 <202007030736.2LOKlNn1%lkp@intel.com>
In-Reply-To: <202007030736.2LOKlNn1%lkp@intel.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 6 Jul 2020 00:57:07 +0800
Message-ID: <CADvbK_fOR_4uviyiRKT6ujRt=JwexQ9S0PCk=x08RWwDToQ=zg@mail.gmail.com>
Subject: Re: [PATCHv2 ipsec-next 06/10] ip6_vti: support IP6IP6 tunnel
 processing with .cb_handler
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

On Fri, Jul 3, 2020 at 7:33 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Xin,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on ipsec-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Xin-Long/xfrm-support-ipip-and-ipv6-tunnels-in-vti-and-xfrmi/20200630-154042
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master
> config: x86_64-lkp (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-14) 9.3.0
> reproduce (this is a W=1 build):
>         # save the attached .config to linux build tree
>         make W=1 ARCH=x86_64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>, old ones prefixed by <<):
>
> >> ERROR: modpost: "xfrm6_tunnel_spi_lookup" [net/ipv6/ip6_vti.ko] undefined!
That's right, I will add "#ifdef CONFIG_INET6_XFRM_TUNNEL" to fix this.
Actually, for ipv4 one, we also need "#ifdef CONFIG_INET_XFRM_TUNNEL".
It is because in vti(6) and xfrmi this feature is also for  IPComp(6),
 the same as xfrm(6)_tunnel in xfrm route.

Thanks for the report.

>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
