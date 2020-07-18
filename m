Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DFF224DCB
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 22:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgGRUTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 16:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgGRUTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 16:19:02 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6FCC0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 13:19:02 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id n26so14340930ejx.0
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 13:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vuO8C3FCA5NcDqmpw/SOaM9Ifn50fmCuBZaUngOox/Y=;
        b=F6+KpR8HofsHebbyDHX+khvOYMCgAW1WNitEitJKIWdClgWJ1fU/EaZZVvcSKfgxR3
         YngMICVUA+PuZo+yrLbuzKBi/nRNJovlDMg34IocJFRH7bSoS6gYpIm2weWJ9YLZe5YP
         Om3DxF3gTC2da/+9EFpJeCsl1xj3D2bop8/5y9Onzxwv1J44MXyFge+8qtNTFdKSpieq
         5PcT30LrS7CB/eWJErF1NBwVmvBFZA7QNi7grTUc766gMF/yh9+Qep8Ck3VZ61ohbjR3
         kw81h3Op1Qcn1X8pMTZmyF699WlG7dqeF29sRaCOm45s04bdLbEBbrhAS5kOne/USYJu
         cdrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vuO8C3FCA5NcDqmpw/SOaM9Ifn50fmCuBZaUngOox/Y=;
        b=PtTQI3bak3aGlbccAFZzsImpU32rIRA3E3sb0cGv984Bnd4mVOQuCYn6Y5uQ25kVFh
         GD/2RLUTyoKRyRM5P5c/dmjZ75aP2RqIM8rbwhMDjvtSjGDGr3ij8oQGs2ccUDlGiccd
         eCX2m08tTMar/Wve+L4repNvjM7YeUudV8LdGcajNvZ2HiEcaXzp8mww9V+DVtMlqbVe
         POhl8KR2Jr+OVXTKk2btOdPRYVXX09jLv+9po9hSe42GOOGjlqABwDx5SzRttbYNDLF5
         g9DqeVXSJhX3SozgCEUKCy596p2k3r8qrkoa8ZIWAIxRMeYMMStyfXX4jzB2SYcTcWce
         waWw==
X-Gm-Message-State: AOAM533e2POEiEps50+D1pgcz0tTxJJDEKY+kBUJV7R2eHDtbWMvMiou
        +nkUQ+fU8FQgrq7wk7icclQ=
X-Google-Smtp-Source: ABdhPJzJCi64eoFl+RX2Kem4SJJQ7R3LPm50rjCerxGMioD/MiA56Mqr0WRmpkoC6SFp9kNXb8XjHQ==
X-Received: by 2002:a17:906:7387:: with SMTP id f7mr13533804ejl.131.1595103541015;
        Sat, 18 Jul 2020 13:19:01 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id h19sm11405777ejt.115.2020.07.18.13.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 13:19:00 -0700 (PDT)
Date:   Sat, 18 Jul 2020 23:18:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        kbuild-all@lists.01.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: Re: [PATCH net-next 2/4] net: dsa: Add wrappers for overloaded
 ndo_ops
Message-ID: <20200718201858.u2urxuc4xhjt27he@skbuf>
References: <20200718030533.171556-3-f.fainelli@gmail.com>
 <202007181226.RGMXcERR%lkp@intel.com>
 <df5b74aa-0b5f-555b-fe96-8db98cd24900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df5b74aa-0b5f-555b-fe96-8db98cd24900@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 11:53:52AM -0700, Florian Fainelli wrote:
> 
> 
> On 7/17/2020 9:53 PM, kernel test robot wrote:
> > Hi Florian,
> > 
> > I love your patch! Perhaps something to improve:
> > 
> > [auto build test WARNING on net-next/master]
> > 
> > url:    https://github.com/0day-ci/linux/commits/Florian-Fainelli/net-dsa-Setup-dsa_netdev_ops/20200718-110931
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git dcc82bb0727c08f93a91fa7532b950bafa2598f2
> > config: i386-allyesconfig (attached as .config)
> > compiler: gcc-9 (Debian 9.3.0-14) 9.3.0
> > reproduce (this is a W=1 build):
> >         # save the attached .config to linux build tree
> >         make W=1 ARCH=i386 
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> > 
> > All warnings (new ones prefixed by >>):
> > 
> >    In file included from drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c:18:
> >>> include/net/dsa.h:720:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
> >      720 | dsa_build_ndo_op(ndo_do_ioctl, struct ifreq *, ifr, int, cmd);
> >          | ^~~~~~~~~~~~~~~~
> >    include/net/dsa.h:721:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
> >      721 | dsa_build_ndo_op(ndo_get_phys_port_name, char *, name, size_t, len);
> >          | ^~~~~~~~~~~~~~~~
> > 
> > vim +/inline +720 include/net/dsa.h
> 
> This is a macro invocation, not function declaration so I am not exactly
> sure why this is a problem here? I could capitalize the macro name if
> that avoids the compiler thinking this is a function declaration or move
> out the static inline away from the macro invocation.
> -- 
> Florian

Maybe it wants 'static inline int' and not 'static int inline'?

+#if IS_ENABLED(CONFIG_NET_DSA)
+#define dsa_build_ndo_op(name, arg1_type, arg1_name, arg2_type, arg2_name) \
+static int inline dsa_##name(struct net_device *dev, arg1_type arg1_name, \
            ^
            ~~~~~ here
+			     arg2_type arg2_name)	\
+{							\

-Vladimir
