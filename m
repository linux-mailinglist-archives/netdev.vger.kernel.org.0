Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018B51B5088
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 00:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgDVWuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 18:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725846AbgDVWux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 18:50:53 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51ECBC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 15:50:53 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id pg17so3162402ejb.9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 15:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qnynys4BQPslZKoLZtv+gigYSH1mIzTxrP7hA4ww/lU=;
        b=hnSvTr/YrzIO2DvDuwHx7kv0EGHb5lLEskmSG24DfLiezXM4E7FBwY49b+iVyPyHRo
         6LQCquXfno5+hBw4zJXcJFryneho4nAqLAIAWH8uT/v0a1OutVETmlLOvrz3xe053wwD
         +QrE5uVPXhYUNOOJ9Zzltps6oM8y92jNoUCJRWOLU/VHI8JIvvfe29CKCY1CsX5ToPWN
         m5CXuEaNLmiiz7BmkMJ5/yPsdfFPRxul02UHtDeylKaO9EXF5IQWWghb/J3Va0WLOYhB
         NEEdeWGmz1n6qP95S+nAdVkWh62MrE18Vqd0YiVpW+cH/XNIpLfStsG478I85Nrw3TXW
         0Q1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qnynys4BQPslZKoLZtv+gigYSH1mIzTxrP7hA4ww/lU=;
        b=tTfLuqcYJcSwtqIA7sed5otwLfKmJCDN1DNt9JcMYjT5/Tdkpoz3HzxHDp4wEO/TRH
         +ZjnzkA1JsO639vCs/q5ucII+SCpOVtuvPLCiAHw+fs3k7pQCm69b4Ks64MlKUq1vAwO
         X9bLlMu3s2p76/VMQqfLjyoodc++lYFGNpCnlYNfjVCpheghFfgRYWfi0PDIUvwHIMaw
         IoWR4Onl0ucvTPkSYN3Gyc0D45wIPXGnSodw+w4XL0xPaC7NXZNAIphkLtwgJ7m4o2d/
         MFJnKoxwPD+W9mPRZ8ljbGk6PX3xlOtjaR6NFkC76aUgbwzJj2HoDMqvqnTQJrcBsmR+
         R/hQ==
X-Gm-Message-State: AGi0Pub+qmlaQn3Whr1LGKtXSUwJQo3EwTXpV+jvfLQ7ARlnIlIn3HR+
        kZnryhpTUI9Jf5M+qqrPiUlGqgd+6qqis4c1TcA=
X-Google-Smtp-Source: APiQypJxin7o0IPw1pRETW5NWtZLZFOiY3pfcvkzjBvmtHpZeKF9mrc/YurgBryS0gTDMU3z3XEk15L4HIujJQinlWc=
X-Received: by 2002:a17:906:6992:: with SMTP id i18mr424669ejr.293.1587595852085;
 Wed, 22 Apr 2020 15:50:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200420162743.15847-2-olteanv@gmail.com> <202004230608.ERIsSgqQ%lkp@intel.com>
In-Reply-To: <202004230608.ERIsSgqQ%lkp@intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 23 Apr 2020 01:50:41 +0300
Message-ID: <CA+h21hpDkc02Hd5JFbD_r3sAtFAOBStQN2dAT+n0aq5SxgKwvw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: mscc: ocelot: support matching on EtherType
To:     kbuild test robot <lkp@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, kbuild-all@lists.01.org,
        Ido Schimmel <idosch@idosch.org>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Apr 2020 at 01:36, kbuild test robot <lkp@intel.com> wrote:
>
> Hi Vladimir,
>

[...]

>
> sparse warnings: (new ones prefixed by >>)
>
> >> drivers/net/ethernet/mscc/ocelot_flower.c:184:54: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] @@    got resunsigned short [usertype] @@

What's a resunsigned short?

> >> drivers/net/ethernet/mscc/ocelot_flower.c:184:54: sparse:    expected unsigned short [usertype]
> >> drivers/net/ethernet/mscc/ocelot_flower.c:184:54: sparse:    got restricted __be16 [usertype]
>

[...]

>    179          if (match_protocol && proto != ETH_P_ALL) {
>    180                  /* TODO: support SNAP, LLC etc */
>    181                  if (proto < ETH_P_802_3_MIN)
>    182                          return -EOPNOTSUPP;
>    183                  ace->type = OCELOT_ACE_TYPE_ETYPE;
>  > 184                  *(u16 *)ace->frame.etype.etype.value = htons(proto);

What's wrong with this? Doesn't it like the left hand side or the
right hand side?

>    185                  *(u16 *)ace->frame.etype.etype.mask = 0xffff;
>    186          }

>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

-Vladimir
