Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E43E0196A76
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 01:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgC2AzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 20:55:03 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:42652 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgC2AzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 20:55:02 -0400
Received: by mail-ed1-f47.google.com with SMTP id cw6so15792856edb.9;
        Sat, 28 Mar 2020 17:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ElUSaKZRyWkOVdhpqdH4XORAPdjmLaagKayrUu0ClMg=;
        b=ufN1X6r7BvDhOYuF1ccjjOpckLRvfaESmO16ScKg1xQTGWAa8vfnh6uj5+WQZlJp/+
         MnUNXgFPXf0G+TlyJRJyrBWMz6OKFFPBU+/MtzpzsLQ9NvF5Q7vqtzsYsMqWoPI5SFmC
         aRxPXbusGdqXxfeyTz46sY1zlMAI5VKFb/J0lJ0mvkOoHu7MJptUl16aaIUnkI0WuH3T
         g6IopZbVka2wT6NAF8mGh1uNilWUEVIwuEfUWnnn/ZflbFyulFuvihtR1afMuiQJoLzP
         gKxN9j7AUHwPGixh46kDmgdR4LkF8XpqaL9MzpPwxu3eip3OSMTSJYzbnqJn+iQskuj7
         EXCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ElUSaKZRyWkOVdhpqdH4XORAPdjmLaagKayrUu0ClMg=;
        b=uUnYh0UmPaTkHZiYpk+KquOCCkKCf9bB5rsDyLHbs91euTf1v58goxJpWRBtLpiG3/
         WQU2uCiTdUFbjO3b+i0m6d0Xnzh70kT6grMQUD+nfWLQ/fTp6xTwDN2gYPA4mPtnEOXF
         6nxQi3JaCI7nExmCk6yojkMSqQuLInKaGqUFzhndq4NqDZD6wa/fWVY/4S1ExMCcM5hq
         nRYcv0Qg5fVoILfflqHcUETz5wa3PJXwlwBXw6qyuSmIlTsowTvH49dIDlkDmc6ZyirV
         Hlz28yx27F238vtY4ENHeaWc8RDBx5vu9P2n1Lwt4HJNinrKhinjvYBi5SgQq0rgu9r0
         Q9wA==
X-Gm-Message-State: ANhLgQ0lsapwZQnZVtaoDujyEJW4tIG9Yjv+6GifsUCvv1jnpG28c6FW
        lOz7qgxSGvjK+d09OgoycK9RlSivvNb9P94t5e6hPg6+42G9Zoc1
X-Google-Smtp-Source: ADFU+vvxjMEsT7W16eU3WkgnXBn0aRvWEVC17P954qDhg38k7WwVHveKO/EOdSQj6mz8VaEWJ9+8MXji0gTdonhwDPA=
X-Received: by 2002:a17:906:fc18:: with SMTP id ov24mr4994780ejb.189.1585443298803;
 Sat, 28 Mar 2020 17:54:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200328123739.45247-1-xiaoliang.yang_1@nxp.com> <CA+h21hpQO=KACy9yKCmOVQenyyoTjLyFD4mX3Cj7PCQnxCB8sA@mail.gmail.com>
In-Reply-To: <CA+h21hpQO=KACy9yKCmOVQenyyoTjLyFD4mX3Cj7PCQnxCB8sA@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 29 Mar 2020 02:54:47 +0200
Message-ID: <CA+h21hpBfey-uWrusfDsh7oWocV-sQLBqoYGrhzYuQM8qZdegg@mail.gmail.com>
Subject: Re: [net-next,v1] net: mscc: ocelot: add action of police on vcap_is2
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Li Yang <leoyang.li@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Mar 2020 at 15:50, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Xiaoliang,
>
> Thanks for the patch. I've tested it, but sadly, as-is it doesn't compile.
> But then again, net-next doesn't compile either, so there...
>
> On Sat, 28 Mar 2020 at 14:41, Xiaoliang Yang <xiaoliang.yang_1@nxp.com> wrote:
> >
> > Ocelot has 384 policers that can be allocated to ingress ports,
> > QoS classes per port, and VCAP IS2 entries. ocelot_police.c
> > supports to set policers which can be allocated to police action
> > of VCAP IS2. We allocate policers from maximum pol_id, and
> > decrease the pol_id when add a new vcap_is2 entry which is
> > police action.
> >
> > Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> > ---
[snip]
>
> For what it's worth, I am preparing another patch series for port
> policers in DSA, and I'm keeping your patch in my tree and rebasing on
> top of it. Depending on how things go with review, do you mind if I
> just take your patch to address other received feedback, and repost
> your flow-based policers together with my port-based policers?
>
> Regards,
> -Vladimir

I took the liberty to repost your patch with the compilation error
fixed, as part of this series:
https://patchwork.ozlabs.org/patch/1263358/

So this patch is now superseded.

Thanks,
-Vladimir
