Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8039C3F32D8
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 20:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbhHTSMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 14:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbhHTSMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 14:12:08 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12902C061575
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 11:11:30 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id k65so20226117yba.13
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 11:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q2WwvkIyOl9ePMfsVsrQUR37blIu+NQiIR5G+xeyofM=;
        b=oEp82GmvTPS9i1jFpfmfGn+sPZf/NxFWp6A0EDtnZFn5YWMdLd3CiBoPhHqvX98Hbu
         p2KQxFtWCk14tzoRr+1qrx4XyodnlfRqFUEhCdqbSr+Ajx1qq277e8Aup66XvZHy1A6w
         ynLqLbyI5P/vYATuw6FRRfdj6R9Vdz6SocQo0LzHOyDsa0EZ1mwKKhBIxweX7d3qUU3N
         cw2Y6zmQqe2XUY+4fq5tXby4mBc5QKmg7Gb+IwpM1iyDG3ZkcPIbOqPNasRQWZfr/2ri
         J6F1D2VXUOMO1GLw61+ztH57jYg4yTKFDX2bEEFMv4VdyoDbRDgoPOFFMl/yu78+HGZZ
         4W8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q2WwvkIyOl9ePMfsVsrQUR37blIu+NQiIR5G+xeyofM=;
        b=CmPOm0CL/mXsCWE+/SvzgkLQr8oYcEB35wTOOgCRwP5MoqAe9ovL1Glled8c+m6ZVR
         a3j0S5RIwiauGix/Mzy/BkVWA0O9lprxUCqeKO+FI/zWxQN6VHsausrgy4oGGLjBufD1
         yyIC8fuAq78ohJK4PUkJkh+HSq9zaFh5Vw4opnxlUFQJM8yvJEqrlTt7xlScclJDVCNU
         TxUAsonpwrxUGRgzWfut3tFrIqwfD0ZWdqjlYfdBDkynuWXcHWw+4L8rMmclMnsFJ+7G
         6HsTlbtClOAK/ql3ZGOeAMgzgYDJxstygMeMOWweyKq/NqdF8daRtVs5rPfLglr/hSEQ
         J6Bw==
X-Gm-Message-State: AOAM533axj36R/TqBhvVEJeYvrMS7X7yleNASUr3zxXHSYQ+HZnKRYjn
        jBxcXAoUg7GvfqadlcualiF4aPYKrJr1Cp6PLPuaRA==
X-Google-Smtp-Source: ABdhPJzMkAn9JdhWjk8yC2KiroM3f9aSYz5m4VxZL0M+DzKbrfIL/INDzmAKEZNlMU0c2BtzAb3BKKavVy8RkYV/JgY=
X-Received: by 2002:a25:804:: with SMTP id 4mr25437724ybi.346.1629483089175;
 Fri, 20 Aug 2021 11:11:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk> <20210817223101.7wbdofi7xkeqa2cp@skbuf>
 <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
 <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk> <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
 <875f7448-8402-0c93-2a90-e1d83bb7586a@bang-olufsen.dk> <CAGETcx_M5pEtpYhuc-Fx6HvC_9KzZnPMYUH_YjcBb4pmq8-ghA@mail.gmail.com>
 <CAGETcx_+=TmMq9hP=95xferAmyA1ZCT3sMRLVnzJ9Or9OnDsDA@mail.gmail.com> <YR/sWodANPdthPyA@lunn.ch>
In-Reply-To: <YR/sWodANPdthPyA@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 20 Aug 2021 11:10:53 -0700
Message-ID: <CAGETcx-47UCb+pgfvtSYLOM+XQE76e14Z2o6ihire5E=Ajbv0g@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 10:54 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > 3. If dsa_register_switch() fails, we can't defer the probe (because
> > it already succeeded). But I'm not sure if it's a likely error code.
>
> That is not a safe assumption. The tagging driver can be a module, and

I don't know what "tagging driver" means. And yes, this is just a test
patch for now.

> not be loaded yet. So we defer probing to allow it to load.
>
> Ethernet switches can be a big graph of parts, not a nice tree of
> parts.

fw_devlink can handle graphs well. It has cycle detection for a reason
:) Look at slide 10 for a complicated example:
https://linuxplumbersconf.org/event/7/contributions/787/attachments/529/942/LPC_2020_-_fw_devlink.pdf

However, after sending that email I realized that fw_devlink=on would
make sure all the dependencies of this device would have probed first
before it allows this to probe. So EPROBE_DEFER can't really happen.
But for now I just want to see if it fixes the issue Alvin was seeing.

-Saravana
