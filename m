Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389A6214E73
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgGESVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgGESVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 14:21:18 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B90C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 11:21:17 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f18so39312932wml.3
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 11:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jV9ncZE6azdAXTmLrMDQLyc4PQNhXWxYLD8EaTEEWlw=;
        b=ovEebdzqPlYY3E25O4wVVT1HJiPWHxprjxU7IPw70QicAf2tLwCV1Wtn2pytsFe4i4
         eH0vbe8Svm5UTFBFnSsSjQUO8cl4qhiKhxYqXReuDxUhRuLD+hyvxaXOC9XDlnNBuLyT
         OLSBoCNMSxdYtXGFWhriTugMUdpRH2/l6sOFrkGo7X95PonkCo9+jaAh75SzO7r7V1/+
         fL7DnxsvkE+AYU7F3lDOYK1H8hYp3MSF4eNkmgekbS+h2fm6t1OLbCwQA3zU5Ks7Bzse
         6oKGkvNsx6bicxzvNXxK5t6ZbFq0KPr/Pf8zAoXp4hNXUW6ibK9qiOPVW/22N1Xh5pDr
         XuGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jV9ncZE6azdAXTmLrMDQLyc4PQNhXWxYLD8EaTEEWlw=;
        b=qhJdi4+LURb72x5z+3rMGlaQgu4S/TOFr4Up/vsVIUTBtnQ8fWNcXXjZp0z+aDc+v3
         qL6wfuV6OH4a6Vtcv7cPmIvB37yIQ8t31K6yx8FzYyHTbW8dKoA5Fe7uNNeetwdksABc
         QwFro+fFcIR97tzUBbyDqb81w5yUztuypl9F6rLWQrERlsAUepdIYLGEoRTixSsM2c9j
         1uH9AaKrVU/Am4ll0oBrWXmbU2bwcpmoU7hUiCGvrmVEU5PTBfS+w4xW9SMqQBRufJUN
         f9COKjBdjcVq/BQZK0mIlspeeLNYZp/J0fRulZPhd+0wJkDe2ad6YqR3ouU/LP9gffUy
         ijLw==
X-Gm-Message-State: AOAM532e0voTUSxz0OcGlhHmqqDWLkB+w4e9AuPrRWq2TuVoi2Y0ECiz
        /5YpriZInxdfrHqef4Zftt6pwJVQUrr6tdB0O3hciOTX
X-Google-Smtp-Source: ABdhPJyIXTFAMnkVnNMDh+rYOLohn2VJ1fIQvsMy4ghjqIbHCRPVZ0yit4KTept9OCZnG1LpwWqt5ty2IJiZzoNhHiE=
X-Received: by 2002:a1c:6006:: with SMTP id u6mr44982437wmb.111.1593973276435;
 Sun, 05 Jul 2020 11:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <b660e1514219be1d3723c203c91b0a04974ddac9.1593502515.git.lucien.xin@gmail.com>
 <202007030446.GiX4Q8Vz%lkp@intel.com>
In-Reply-To: <202007030446.GiX4Q8Vz%lkp@intel.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 6 Jul 2020 02:30:57 +0800
Message-ID: <CADvbK_f+B1BK6khX021JTFszKa3LGG+Wjdrz439d7Gsj4BgjBQ@mail.gmail.com>
Subject: Re: [PATCHv2 ipsec-next 02/10] tunnel4: add cb_handler to struct xfrm_tunnel
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

On Fri, Jul 3, 2020 at 4:54 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Xin,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on ipsec-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Xin-Long/xfrm-support-ipip-and-ipv6-tunnels-in-vti-and-xfrmi/20200630-154042
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master
> config: h8300-randconfig-r001-20200701 (attached as .config)
> compiler: h8300-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=h8300
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    h8300-linux-ld: net/ipv4/tunnel4.o: in function `tunnel4_init':
>    net/ipv4/tunnel4.c:242: undefined reference to `xfrm_input_register_afinfo'
> >> h8300-linux-ld: net/ipv4/tunnel4.c:245: undefined reference to `xfrm_input_unregister_afinfo'
>    h8300-linux-ld: net/ipv4/tunnel4.c:250: undefined reference to `xfrm_input_unregister_afinfo'
I will add "#ifdef CONFIG_INET(6)_XFRM_TUNNEL" for this one too.

Thanks.
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
