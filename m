Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDC13CC5E0
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 21:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbhGQTa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 15:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbhGQTa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 15:30:57 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B534C061762;
        Sat, 17 Jul 2021 12:28:01 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 59-20020a9d0ac10000b0290462f0ab0800so13552262otq.11;
        Sat, 17 Jul 2021 12:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OY5P3Qs+aXS0GXol5NiwP3hCcodvv6jduZx0L8iwDwo=;
        b=GDk8Q5ty9EG6/PxzOvcNyuxFvY3tmhdqw7RivNyfIxypiERnzVII2o4n99M/A0CW7S
         VinDg91/OEAyiWKItlwXmj14zRZ2+Q8mI85uXkJoDaHFtxJVeCA2Rf0zj/MLDoB57sYD
         3fdxcK3vIVbyxy+qai/R2xW9qhnXyixG658F7PJfVMdd8qOJ/hDdgESJGXzjeMbzj7GS
         Ybo/6iFiSMw8IeXYBFfCCeT30MgaoW4CvAi0ft8h6tycRO+eTSLtxIAMrEQ+HRkywvX+
         6fhmYpWK1iqLEdnzqmw0U38orl/6XXuu0Tnl9Px7BQal2AWfR21w8eZrZWO0F/Y9aLW5
         kLxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OY5P3Qs+aXS0GXol5NiwP3hCcodvv6jduZx0L8iwDwo=;
        b=jpHOBAxkwt0AuPwFDYRZJDjstvarYSkvo/hXYIhyY9eBoMjFfTblYtk41nBy5Khtgl
         LXVEKTckQEc8dSZfOF6s+WxPzEi7Gy1Q23mbBEoZuI3X6Y4t6jHKZvupHK3JHt4h9i93
         7XlnjRkExOUCquHASeP0NyowPsKjqdpFV/kfiXcBOavn9MI0KWhPsfJoxB0k3FICWTS1
         hZszK/WWTsb4icr+kqrJgtLw+khkjJgVGzca5UfVYldZWVdqUkTs7ESpdzvyhJ0GIzeb
         4AvLt+1IsdBNCdYKoAj4pDBdFSG9DnswVNdzjHGWKqo4s5GqfXW+g/81NWlEZL8Oz8l3
         jOBg==
X-Gm-Message-State: AOAM530ZEueH5IJlpkpHz4mot1Mf+P2EdP7uqdS918gjGq0Cp7uoqvVL
        G9kkhAaXgIYYG8HcsegmxqYF1caljSsXhBkRVRY=
X-Google-Smtp-Source: ABdhPJwdOL3GQLIGVxozk87GaIpeCxhnrSlIsGBjkPcciuhg1QX81Gna8arxi6vshxr7dwIurSKHYHuctsQpn+aidjQ=
X-Received: by 2002:a9d:7e6:: with SMTP id 93mr6516748oto.370.1626550080413;
 Sat, 17 Jul 2021 12:28:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210716153641.4678-1-ericwouds@gmail.com> <20210716210655.i5hxcwau5tdq4zhb@skbuf>
 <eda300a2-4e36-4d0c-8ea8-eae5e6d62bea@gmail.com> <20210717154131.82657-1-dqfext@gmail.com>
In-Reply-To: <20210717154131.82657-1-dqfext@gmail.com>
From:   Eric Woudstra <ericwouds@gmail.com>
Date:   Sat, 17 Jul 2021 21:27:48 +0200
Message-ID: <CABROOSdLyDZd0SBrN7Su40cqZgK1o2hp19mTJ3t4vcgORd-pdg@mail.gmail.com>
Subject: Re: [PATCH] mt7530 fix mt7530_fdb_write vid missing ivl bit
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 17 jul. 2021 at 17:41, DENG Qingfang <dqfext@gmail.com>: wrote:
>
> On Sat, Jul 17, 2021 at 10:09:53AM +0200, Eric Woudstra wrote:
> >
> > You are right now there is a problem with vlan unaware bridge.
> >
> > We need to change the line to:
> >
> > if (vid > 1) reg[1] |= ATA2_IVL;
>
> Does it not work with vid 1?

No, I also thought so, but it actually does not. I'm working here on
5.12.11, but there should not be any difference. It needs: if (vid >
1). Just tried it with (vid > 0) but then it does not work.

I really like your fix on wifi roaming, it works nicely. However I
found, still after this patch, it sadly does not work on vlan > 1. At
least it does not on 5.12.11 (the 'self' entry does not get removed
automatically, but after manual remove the client connects ok). I need
to go 5.14 one of these days because I just read DSA has a major
update. Then I also move from ubuntu focal to a more recent version.
Then I'll try wifi roaming on vlan again.

>
> >
> > I have just tested this with a vlan unaware bridge and also with vlan bridge option disabled in the kernel. Only after applying the if statement it works for vlan unaware bridges/kernel.
