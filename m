Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06532F2944
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387691AbhALHyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729397AbhALHyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 02:54:00 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F28CC061575;
        Mon, 11 Jan 2021 23:53:20 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d26so1365356wrb.12;
        Mon, 11 Jan 2021 23:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UqzE9bSyfw7pBLxRvgp7DF3YZbNavFxSZijy5c6JwJY=;
        b=b5VyuwPuAhn2V+HA6Iz5ocetuI0xCQu77AwhNw5SpLgvrdE1DCcbmvxqwB5C8cvRIQ
         T3CWV4dCrPuhbLVIkfhXVuU1woZpilzS+RRhoMJU7m1YQW6ZQNlDkK7/jZxJvUUtJ+Sb
         45dKmHoAjoNyh7CDgPBjA/t2ezgJ/DueB+9oLlQMUSvM8C2aZRizQ3A3/7z6c2KSxGX/
         L+poiMLg/dWfpS+Ee173LZqW+QpC3zVdntmejRwEsEFya6L/9aANudATjso4Hwp55Sfp
         qIhN5BMj3RjSmacBLWcoitaN3HmMU3xf4q7Dls3Bqy7t/pUGG4KLcISdRPXhpQo7UrKB
         fSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UqzE9bSyfw7pBLxRvgp7DF3YZbNavFxSZijy5c6JwJY=;
        b=Z7XYzmRsxJ6lzBt6xEP5DgwF4RwWyevne3P8rWvjOkrOWEj0+GKoHEelAxqCH9QS5n
         kwQJt37jUcRJs9+Oa/45Xe9zZA+zVHZ/8T7m8gc+VASNSuMEGfGBEXiqrzrzGl+Fhz7k
         4Z8idJxlKouHNN6uTYvlg3Yru4k4OgxkdLAsqA34lubTgAOCKhgLOWn5M4fYZMqw5AdW
         Q4+dZoJmd9k+kC5QUzZqmO/VHO6/omg9SDxrOuwf5m82ost9rz7JD1GSIAdO5Wq/TDxc
         LehJxGI6CFyJwl4RO4M7/Qg8Ap3k6+CL1LB1d/QxNDWTLrp7f0XayTiE9HpdARCb/thD
         RQpw==
X-Gm-Message-State: AOAM530bLllHxMatZAnjr8KVFvzAdVSu89j7hU8zKliTsuOvV8drxNhR
        oa+ywtSadH05gjbD5qFRHOPI0CSF5iwNFWlwY7KkAvgPphxiTg==
X-Google-Smtp-Source: ABdhPJyHEmO7FZwm3xlYqgS51SQDwed9ayUimn3k13vZIaFQGXdm9p1F3QL5HUBBfxHo53b3Tq2oFIETMvU2kVbcLdY=
X-Received: by 2002:adf:c642:: with SMTP id u2mr2849839wrg.243.1610437998889;
 Mon, 11 Jan 2021 23:53:18 -0800 (PST)
MIME-Version: 1.0
References: <8636d49cb2d5deb966ba1112b6d0907f2f595526.1610368263.git.lucien.xin@gmail.com>
 <202101120129.zxrZgmC0-lkp@intel.com>
In-Reply-To: <202101120129.zxrZgmC0-lkp@intel.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 12 Jan 2021 15:53:07 +0800
Message-ID: <CADvbK_fK1tiPcD6XNZ0Aq29K8_e6DS9OpvbskHB-WqDeajN9dQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] udp: call udp_encap_enable for v6 sockets
 when enabling encap
To:     kernel test robot <lkp@intel.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        kbuild-all@lists.01.org, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 2:02 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Xin,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Xin-Long/net-enable-udp-v6-sockets-receiving-v4-packets-with-UDP-GRO/20210111-205115
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 73b7a6047971aa6ce4a70fc4901964d14f077171
> config: m68k-defconfig (attached as .config)
> compiler: m68k-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/62229592b4c3e929eeafea82e758dacb2953fbde
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Xin-Long/net-enable-udp-v6-sockets-receiving-v4-packets-with-UDP-GRO/20210111-205115
>         git checkout 62229592b4c3e929eeafea82e758dacb2953fbde
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=m68k
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>, old ones prefixed by <<):
>
> >> ERROR: modpost: "udp_encap_needed_key" [net/ipv6/ipv6.ko] undefined!
I will add udp_encap_disable() and export, thanks.
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
