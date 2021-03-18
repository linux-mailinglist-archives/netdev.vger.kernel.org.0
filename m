Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9295233FD9A
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 04:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbhCRDMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 23:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhCRDLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 23:11:49 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F79C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 20:11:49 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id k14-20020a9d7dce0000b02901b866632f29so3902614otn.1
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 20:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=qDEEKW39GJM93l+cGmf0wRwtqC1isSFVEaed65FtvnQ=;
        b=OgTR833LfImZRCvJGnaGOzvAXQFvGwiqmJjMf860dwnMJXADbY/WghwdFrPhn9J6ai
         iQFi/5Ymp4GLc1I5GQq42yIf441Se4p/RCnThOhlm/Fy8ydVAl9rHYvw6keWRfRZSoTR
         NNZc6YW5ezzgd/5gDlk3bv73z61DhuuZ7A4rL//KLYjMhVEYvj0pXHeY0L11R0+FK+iP
         UG5W+MGxMQX/u8/Q4tWRsbEhZKOY13UOjas6MZR2hYN5wp0tDCrCgNv8oqDPMbMC+ixj
         92TO8z5NSaMwSzlV5YiVTQy8toYB3jQ1DwvDqhIumSrLdtsaQ1Y3SexYVP/sJLgTNdOT
         LwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qDEEKW39GJM93l+cGmf0wRwtqC1isSFVEaed65FtvnQ=;
        b=qCd0hAlh9dqXlDj64DOhLHwGEb6P9+/o/qqrW3DT2fpTV3iFSC1KfVA524sis7vh1A
         p+gtermdrCnpGubT9w3kmdMFXFEHj5xQR5tA/t5spAZYEjQ51CQMGV6eJqDT76CjgLb1
         WRNyd9xHn8FP2GvgCVY8RDmwMEQUo5BA8ymhP74kwJM4pGrvmVxGv2vJIaXpTyqStF/r
         zHWQYy35fqJJ8jcq+PV9geZzsUWToCchlGo3Sj5IwqeQZm75DLzHpUuqWU9Mr8fBNmnB
         HXh4i6mwHWppS+b8JoJG8DFCY6DBaVh/YRJ43pS8P5jFaV8gdovnJt9GN16jHOcodQtg
         wTlw==
X-Gm-Message-State: AOAM530doPLoMuEvy5ALKWkoHYXhn+Zgfs4xw54oTUnN6NiYyxPI2zzJ
        aQD7GIAMASgkcHZsobnQhkfLEBH856A=
X-Google-Smtp-Source: ABdhPJwvt9s/N1oFmrN6CgOE4RcYYME9hzm2gpSItTCMo9fWMxZfVD7LWam4xBmIOEjZGDQTJfcfwg==
X-Received: by 2002:a05:6830:2118:: with SMTP id i24mr5811045otc.290.1616037108294;
        Wed, 17 Mar 2021 20:11:48 -0700 (PDT)
Received: from ?IPv6:2601:681:8800:baf9:1ee4:d363:8fe6:b64f? ([2601:681:8800:baf9:1ee4:d363:8fe6:b64f])
        by smtp.gmail.com with ESMTPSA id x18sm179412otr.73.2021.03.17.20.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 20:11:48 -0700 (PDT)
Message-ID: <72c4ccfc219c830f1d289c3d4c8a43aec6e94877.camel@gmail.com>
Subject: Re: [PATCH V4 net-next 5/5] icmp: add response to RFC 8335 PROBE
 messages
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     Network Development <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>
Date:   Wed, 17 Mar 2021 22:11:47 -0500
In-Reply-To: <202103150433.OwOTmI15-lkp@intel.com>
References: <a30d45c43a24f7b65febe51929e6fe990a904805.1615738432.git.andreas.a.roeseler@gmail.com>
         <202103150433.OwOTmI15-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-15 at 04:35 +0800, kernel test robot wrote:
> Hi Andreas,
> 
> [FYI, it's a private test report for your RFC patch.]
> [auto build test ERROR on net-next/master]
> 
> url:    
> https://github.com/0day-ci/linux/commits/Andreas-Roeseler/add-support-for-RFC-8335-PROBE/20210315-005052
> base:   
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 6f
> 1629093399303bf19d6fcd5144061d1e25ec23
> config: mips-allmodconfig (attached as .config)
> compiler: mips-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget 
> https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross
>  -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # 
> https://github.com/0day-ci/linux/commit/54d9928f1734e7b3511b945a2ce912b931a07776
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Andreas-Roeseler/add-
> support-for-RFC-8335-PROBE/20210315-005052
>         git checkout 54d9928f1734e7b3511b945a2ce912b931a07776
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0
> make.cross ARCH=mips 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    mips-linux-ld: net/ipv4/icmp.o: in function `icmp_echo':
> > > icmp.c:(.text.icmp_echo+0x658): undefined reference to
> > > `ipv6_dev_find'
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

I'm still learning the ropes of kernel development and I was wondering
if someone could help me figure out what is causing this error.

The file compiles when compiling with allyesconfig or olddefconfig, but
it cannot find the ipv6_dev_find() function when compiling with
allmodconfig and returns the error seen above. I am including
<include/net/addrconf.h> which declares ipv6_dev_find(), and the
function is defined and exported using EXPORT_SYMBOL in
<net/ipv6/addrconf.c>. I've tried declaring the function via extern in
<include/net/icmp.h> and in <net/ipv4/icmp.c>, but neither have
resolved the error and checkpatch.pl explicitly warns against using
extern calls in .c files.

Is there something that I'm not understanding about compiling kernel
components modularly? How do I avoid this error?


