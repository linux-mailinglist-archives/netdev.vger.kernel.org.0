Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851E5568B20
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 16:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbiGFOXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 10:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiGFOXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 10:23:39 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E6C21A7;
        Wed,  6 Jul 2022 07:23:37 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id f2so16941595wrr.6;
        Wed, 06 Jul 2022 07:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WPpPFt2vreAvukEchuJ8KcyDhd0FY1gp7qevaVZJpHI=;
        b=MipxUNNv1CuzDomW4TDLl1zhaylRYTrx3HZq9GYsjxdcB9+8zSPYgqHTdiwr1z+vMx
         1FrXYtgFdTKQJAw332y5OtL+a1DSibzdekPFpU8scZF5wsXT5IozNxflL5z/F9J/EOc8
         6fUUAb+3A0iOvdHXB3B0v7vb03sGXtWPoywgxAYh5fGJNL2Gf/akgZZ3o5Q2t/X8AhTv
         oGRsf1z5hI6JAZutJvqwANARqRbZmUNjWEgtE6le0ja1+VhmfDcpIbt7w6NmofsaRELe
         4kHBuQJNq9n9YQUGsOMl/wOhnMFV9A/p892T0cj4Bxeo7uwyANFpUYfIfrchPmUhtkUp
         n2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WPpPFt2vreAvukEchuJ8KcyDhd0FY1gp7qevaVZJpHI=;
        b=LBHHB0ohVYLuqsHu7iV26RaERXR4L4u4RGSgB2CGW/WeUB/Uz9BCtxwX1RUMTCIw/T
         yOR0mm/9iMfQ3muhp7y5YZ2C+qSdQdvixJnF/dPr8VZo5yKpIIZHImPNqqzQOmlOUkaR
         7aMfZEEyk/+tMRqSZ19l0brOdwoODOSVUyteEDxPCXW7xfY/tJNwaXLwrwUtOJeBz56N
         xu+wAqPp7aefBhmCjHSY7DYakR2uIh+B0Aea2/YQNFCSoAqeXj+o0cvwzP4hFIDLTHFA
         7zrh42WlXE0RDC/PmK6+plaBHcSY8VFN6PjafOjKmkcxpGypp7KdND0xIuLnXZvK13RZ
         NsPQ==
X-Gm-Message-State: AJIora8Zcqwi3t2CGBqtimr/51MXR5RsUkcVR6VIrQy5dfBfR3nD48/2
        1kIE3lAECQD6mM5x9FOzU/d834rns2/K6+oooJQ=
X-Google-Smtp-Source: AGRyM1vyCqZB5Fa3OerranrlSzgeG9k7CwyXwEFfqtrJ8m53fLEj0coZuzcxmy+5Zyo17nvKGoYAEoROlUXUwRhXr1Q=
X-Received: by 2002:a5d:4304:0:b0:21b:9b2c:be34 with SMTP id
 h4-20020a5d4304000000b0021b9b2cbe34mr40056150wrq.577.1657117416326; Wed, 06
 Jul 2022 07:23:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-4-schultz.hans+netdev@gmail.com> <20220627180557.xnxud7d6ol22lexb@skbuf>
 <CAKUejP7ugMB9d3MVX3m9Brw12_ocFoT+nuJJucYdQH70kzC7=w@mail.gmail.com>
 <20220706085559.oyvzijcikivemfkg@skbuf> <CAKUejP7gmULyrjqd3b3PiWwi7TJzF4HNuEbmAf25Cqh3w7a1mw@mail.gmail.com>
In-Reply-To: <CAKUejP7gmULyrjqd3b3PiWwi7TJzF4HNuEbmAf25Cqh3w7a1mw@mail.gmail.com>
From:   Hans S <schultz.hans@gmail.com>
Date:   Wed, 6 Jul 2022 16:23:25 +0200
Message-ID: <CAKUejP5modz89PxvgjWxNZ6mwyfdD+e2r_2n0Aj+HF8LFfn9SQ@mail.gmail.com>
Subject: Re: [PATCH V3 net-next 3/4] net: dsa: mv88e6xxx: mac-auth/MAB implementation
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> @@ -919,6 +920,9 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
> >>       if (err)
> >>               dev_err(chip->dev,
> >>                       "p%d: failed to force MAC link down\n", port);
> >> +     else
> >> +             if (mv88e6xxx_port_is_locked(chip, port, true))
> >> +                     mv88e6xxx_atu_locked_entry_flush(ds, port);
> >
> >This is superfluous, is it not? The bridge will transition a port whose
> >link goes down to BR_STATE_DISABLED, which will make dsa_port_set_state()
> >fast-age the dynamic FDB entries on the port, which you've already
> >handled below.
>
> I removed this code, but then on link down the locked entries were not
> cleared out. Something not as thought?

I don't see a fast ageing happening on link down. There is the two cases:
1. Soft link down

With iproute2 command the link is brought down and
mv88e6xxx_mac_link_down() is called with rtnl lock taken.

2. Hard link down

I remove the cable from the port and mv88e6xxx_mac_link_down() is
called without rtnl lock.

As the hard link down case calls without rtnl lock, either I trigger
the case you have mentioned or I have to use rtnl_is_locked()
somewhere along the line?
