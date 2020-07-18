Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D38224DCC
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 22:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgGRUUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 16:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgGRUUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 16:20:18 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B044FC0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 13:20:18 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id o22so7944293pjw.2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 13:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=teS4CYcMNQiBJ8GO5C6X/r02YtyK+hk08GtFDDCw0pY=;
        b=r1Tu+C7/WXWSxTea/2Qt2fX3bUYASflVv6m+YEHxGreGYuhf+C7tBvNxzKb0CCVRyY
         d9rdbTmH5zww1xWVi4MbQuuqHh3YV1gDXpxyKRXvPdBPuAyrnbArZyXjHNjWl+VGMWiw
         1SEUxd+8cwzlzsnVk3Y+DYq/hHMz1dyNQSbAooVc29GxOBTU9PfjrDQ/OfvWXSrn8HCk
         AXBkrWzu9GK0mw7GdmZfk2eK+QTf8Xf57lBIZMX3iovs4hhldprjY8qReae04N6o19UQ
         lOx5SJp0+uR2DuU4wqefqrWHUIngK51ZT9W3TFIm1DnUtTrCD3dpyKlHWnfaE3LG4bu5
         feYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=teS4CYcMNQiBJ8GO5C6X/r02YtyK+hk08GtFDDCw0pY=;
        b=IgibJPwfjOxM40EP5aY7ip4NECoUq5SMjd6xV7fQVkZWnwPTSeqBFn21/BLQHhMv5W
         vF8PZPoOqZxDsP31WxXudm8Pl6kL0qDyc3HhiVWRNVX4W4Cp7Vf1GpNJRo9tGyrdhI9x
         WhTiYc98Ha0R6Rz56Lk+ysU0jy+KgBeeUar4NNt3hNI8ql4Qas4npoz6aoOsEyTBkStO
         LxDnpAZJw502Tyw3SgMU0C7+7YvpwqlzAj1TD3QXIo5vS8NQr/0SlOPosWasDFA0NLV8
         JjnUm+k04ZPBpSjORDr2/F+bLI3c+6++9JsSiHKI765Hx9xFt4gdL4fcdN++fPdTSbBu
         Oxyg==
X-Gm-Message-State: AOAM5330FbyUvj5sp7k+iqW4zCpB35dMvIw7EfHtjUvcfUSXLMUrrrwS
        ujNgMKeY641g544Q0O1mEJg=
X-Google-Smtp-Source: ABdhPJxJdnUHfmBoiWJqTNRicfz3gKVacYFPtOUpk7/NjyLx5YFRgK94IagWK2QNR6UQbU/AS08gcw==
X-Received: by 2002:a17:90a:ce09:: with SMTP id f9mr16798591pju.55.1595103618137;
        Sat, 18 Jul 2020 13:20:18 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id b6sm11996431pfp.0.2020.07.18.13.20.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 13:20:17 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] net: dsa: Add wrappers for overloaded
 ndo_ops
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        kbuild-all@lists.01.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
References: <20200718030533.171556-3-f.fainelli@gmail.com>
 <202007181226.RGMXcERR%lkp@intel.com>
 <df5b74aa-0b5f-555b-fe96-8db98cd24900@gmail.com>
 <20200718201858.u2urxuc4xhjt27he@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5be17e47-ff59-b5a2-0a90-f94fbdd23cf8@gmail.com>
Date:   Sat, 18 Jul 2020 13:20:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200718201858.u2urxuc4xhjt27he@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/2020 1:18 PM, Vladimir Oltean wrote:
> On Sat, Jul 18, 2020 at 11:53:52AM -0700, Florian Fainelli wrote:
>>
>>
>> On 7/17/2020 9:53 PM, kernel test robot wrote:
>>> Hi Florian,
>>>
>>> I love your patch! Perhaps something to improve:
>>>
>>> [auto build test WARNING on net-next/master]
>>>
>>> url:    https://github.com/0day-ci/linux/commits/Florian-Fainelli/net-dsa-Setup-dsa_netdev_ops/20200718-110931
>>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git dcc82bb0727c08f93a91fa7532b950bafa2598f2
>>> config: i386-allyesconfig (attached as .config)
>>> compiler: gcc-9 (Debian 9.3.0-14) 9.3.0
>>> reproduce (this is a W=1 build):
>>>         # save the attached .config to linux build tree
>>>         make W=1 ARCH=i386 
>>>
>>> If you fix the issue, kindly add following tag as appropriate
>>> Reported-by: kernel test robot <lkp@intel.com>
>>>
>>> All warnings (new ones prefixed by >>):
>>>
>>>    In file included from drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c:18:
>>>>> include/net/dsa.h:720:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
>>>      720 | dsa_build_ndo_op(ndo_do_ioctl, struct ifreq *, ifr, int, cmd);
>>>          | ^~~~~~~~~~~~~~~~
>>>    include/net/dsa.h:721:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
>>>      721 | dsa_build_ndo_op(ndo_get_phys_port_name, char *, name, size_t, len);
>>>          | ^~~~~~~~~~~~~~~~
>>>
>>> vim +/inline +720 include/net/dsa.h
>>
>> This is a macro invocation, not function declaration so I am not exactly
>> sure why this is a problem here? I could capitalize the macro name if
>> that avoids the compiler thinking this is a function declaration or move
>> out the static inline away from the macro invocation.
>> -- 
>> Florian
> 
> Maybe it wants 'static inline int' and not 'static int inline'?

Oh yes indeed, thank you.
-- 
Florian
