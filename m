Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC51E1D036C
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 02:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731689AbgEMAIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 20:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgEMAIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 20:08:14 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77365C061A0C;
        Tue, 12 May 2020 17:08:13 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g9so8130613edw.10;
        Tue, 12 May 2020 17:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BMQvVCbxTnVE2CljpCdNOkybEdMUp//44DEGyffYS0w=;
        b=MxH5iuZjf+GWvkLOVksnb1X6IAiV1+u6vJC58AFEVVz12QYAZ02TSyYy37trIEQh6I
         roKz4ltlwjm9JvwdZJrlfycfP/K3NQiH/mXClCMSrRieYH8GeVp383xP3ID614ymJl5V
         V9TA8XdJLAlujnVC7eSVAS1zAQlsQpoyERDsqLvjU1pj3lk8CM9OjbsuJVvyRGkA0YvN
         zbNJMkh/dmVIErAnjXzZXn+p0iIYxz6TwSnn+4zE/YZx0uwl8HzJjEvwfKurQEbof4o6
         sKF3MajYDxVK7eyX/vJhXFuTodPvoPWSZVW2GPOjTGXuB58KoHvbjwp3h6m5U47jqNc4
         Pf0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BMQvVCbxTnVE2CljpCdNOkybEdMUp//44DEGyffYS0w=;
        b=JD7TeM87Ts0fyYcC6yHXkpy8vkauBzf0xYHu5PRDnHohMfxPJ6SGHWAIZO8RsWnr4W
         FQ95C/nUlgw5ahrMAtYlr3UV5oEJYMgF/PgaZtoMe/XWhebC04roQ3LZJqr/EMjE/bhe
         xHBnkfbfmf9zfNfoDOZ69ABLKjWBPUu0XLMBkUwBtMgnANZdhEtqInY/3svTvnEhuadr
         wk1eJyF8N4FIXo6Kn4ngMhfnPYJinmF0JafbwJRhKga+IRRVwhePxJPtAd0U7WecFdkT
         TlsYSIprYUmic9yCkZxd7gLZ/r/7EfN0AYA98gyA1T0tCxGoxNvyjiAB7xanerqgofHw
         5oyg==
X-Gm-Message-State: AGi0PuaDHkEE9ZiPk7SpmgJIESyZ4TF8H5MeZ5o4BW1kAfbp05JVlPtV
        E36gS9o8+doYZhbTYkGHm+0Er8CnWs7YizeZYiQ=
X-Google-Smtp-Source: APiQypLcoYAMoRPreXIJcC1LSQG7BZKbV1YGfPD05li98d86rgQMdJb/a8xCpFvhsoon22wO2tmxk9aP74qL+0HNot0=
X-Received: by 2002:a05:6402:6c4:: with SMTP id n4mr20499279edy.368.1589328492085;
 Tue, 12 May 2020 17:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200512172039.14136-9-olteanv@gmail.com> <202005130724.KFjVH0Y9%lkp@intel.com>
In-Reply-To: <202005130724.KFjVH0Y9%lkp@intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 13 May 2020 03:08:01 +0300
Message-ID: <CA+h21hq_p=q7L_LFeu3mn3utAXSdA6FUNYFB=4qQ1LJ1J=BTVg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 08/15] net: dsa: sja1105: prepare tagger for
 handling DSA tags and VLAN simultaneously
To:     kbuild test robot <lkp@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        kbuild-all@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@idosch.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020 at 03:02, kbuild test robot <lkp@intel.com> wrote:
>
> Hi Vladimir,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on net-next/master]
> [also build test WARNING on next-20200512]
> [cannot apply to linus/master v5.7-rc5]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
>
> url:    https://github.com/0day-ci/linux/commits/Vladimir-Oltean/Traffic-support-for-dsa_8021q-in-vlan_filtering-1-mode/20200513-012422
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 3242956bd610af40e884b530b6c6f76f5bf85f3b
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.1-191-gc51a0382-dirty
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
>
>
> sparse warnings: (new ones prefixed by >>)
>
> >> net/dsa/tag_sja1105.c:76:34: sparse: sparse: cast to restricted __be16
> >> net/dsa/tag_sja1105.c:76:34: sparse: sparse: cast to restricted __be16
> >> net/dsa/tag_sja1105.c:76:34: sparse: sparse: cast to restricted __be16
> >> net/dsa/tag_sja1105.c:76:34: sparse: sparse: cast to restricted __be16
> >> net/dsa/tag_sja1105.c:76:16: sparse: sparse: restricted __be16 degrades to integer
>    net/dsa/tag_sja1105.c:79:34: sparse: sparse: cast to restricted __be16
>    net/dsa/tag_sja1105.c:79:34: sparse: sparse: cast to restricted __be16
>    net/dsa/tag_sja1105.c:79:34: sparse: sparse: cast to restricted __be16
>    net/dsa/tag_sja1105.c:79:34: sparse: sparse: cast to restricted __be16
>    net/dsa/tag_sja1105.c:79:16: sparse: sparse: restricted __be16 degrades to integer
>
> vim +76 net/dsa/tag_sja1105.c
>
>     71
>     72  static bool sja1105_can_use_vlan_as_tags(const struct sk_buff *skb)
>     73  {
>     74          struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
>     75
>   > 76          if (hdr->h_vlan_proto == ntohs(ETH_P_SJA1105))
>     77                  return true;

Oh my, I really suck at this...
I think it's complaining because I should have called htons instead of ntohs?

>     78
>     79          if (hdr->h_vlan_proto != ntohs(ETH_P_8021Q))
>     80                  return false;
>     81
>     82          return vid_is_dsa_8021q(ntohs(hdr->h_vlan_TCI) & VLAN_VID_MASK);
>     83  }
>     84
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
