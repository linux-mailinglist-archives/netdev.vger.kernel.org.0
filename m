Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8081CEA04
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 03:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgELBLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 21:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728105AbgELBLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 21:11:24 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D620C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 18:11:23 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id x20so6010313ejb.11
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 18:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u1IGoBFLlOBtxyiTa7xy7JvdOLUHFUBwK/nJ4zWevEQ=;
        b=GU2g48g7i/OsI/0aTx9Zxu96Koc8J+TM23rgiZ+H89cfeEnrgvBMWzX/cqjPp9FCuE
         XUjqIIdbB+mgov5vcfdoS3ou1hzGFPiBHFBo+ku9lpnKv48mI2EP9fcNQ1x0DAWGmP1I
         Kv0tibO6gHWOW20ei4NZ7nshfI+gqpELU3GGJpL03cY2kZ5vdI1i34wSnmWjRgoPdjPg
         HYitUyqqILUfqhuZ2QKoOVejtQQuTC9cApcoUWayu9IWXm5Fc4nfs7LQECxOThSQrCmL
         EmuUkA05VxmehR+2uVuodpJ1BahJDlr8savHv84Ir+Gz+NbwLIxjYUKsgpeQvgBTGh+q
         Qx6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u1IGoBFLlOBtxyiTa7xy7JvdOLUHFUBwK/nJ4zWevEQ=;
        b=sUuLnCQra5WwSk+M/IfDQDIwJAXrfBmUZuVf8vx4JvGrMY+S8/3yjzG0s+e1o3TDAQ
         8ooNiH13PdGpT6Psu4szUb9cLfJtAHbT6tE2HRtmgHaVeIMyDfRoYA6B305E3SW0+xJS
         N0xSUa/BOtVrrnntIEuE8T7WDjomlHvseZ8XE2+JYQANNciGrb0bksBv3joMHN6LWjIo
         qMmxSstpaqqie0v0cokveQuJN+B/UCmYrZDONPDJx7FwJAJ1Sa1Qer8jcU1+awqwNEhZ
         RasCrobtszTkk+jXJPvhB4+i05lyyd02d/7FYmSntH40dai620wNiHMWw8yQ12nzfsm7
         6DMg==
X-Gm-Message-State: AGi0PuaDnUUS5+oENGLhGRJ9PpdMBsq76uz8rz5UGQCvbbWZ4IAB3TpI
        5i/1Exn6q4KFU3RfQZ1KRyFyOUzyN9+gqO9D6NA=
X-Google-Smtp-Source: APiQypI5uqdYp99dxrRbRjhWishHh1HDyAGy5NVLW+4waeq39Cx7TWBLSp71nb84BiZfWglSWmmtQWEcCd8qNf4DD8k=
X-Received: by 2002:a17:906:2458:: with SMTP id a24mr15295004ejb.239.1589245882053;
 Mon, 11 May 2020 18:11:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200511202046.20515-1-olteanv@gmail.com> <20200511202046.20515-5-olteanv@gmail.com>
 <16b11435-e9f4-f869-bbcd-fea3cb069f71@gmail.com>
In-Reply-To: <16b11435-e9f4-f869-bbcd-fea3cb069f71@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 May 2020 04:11:11 +0300
Message-ID: <CA+h21hpXpakJ06BufXRzWeAVG5-av2zTzVLjcz9NUvnWpAB7Bg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: implement and use a generic
 procedure for the flow dissector
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 May 2020 at 02:15, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/11/2020 1:20 PM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > For all DSA formats that don't use tail tags, it looks like behind the
> > obscure number crunching they're all doing the same thing: locating the
> > real EtherType behind the DSA tag. Nonetheless, this is not immediately
> > obvious, so create a generic helper for those DSA taggers that put the
> > header before the EtherType.
> >
> > Another assumption for the generic function is that the DSA tags are of
> > equal length on RX and on TX. Prior to the previous patch, this was not
> > true for ocelot and for gswip. The problem was resolved for ocelot, but
> > for gswip it still remains, so that hasn't been converted.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Given that __skb_flow_dissect() already de-references dsa_device_ops
> from skb->dev->dsa_ptr, maybe we can go one step further and just have
> dsa_tag_generic_flow_dissect obtain the overhead from the SKB directly
> since this will already have touched the cache lines involved. This then
> makes it unnecessary for the various taggers to specify a custom
> function and instead, dsa_tag_generic_flow_dissect() can be assigned
> where the dsa_device_ops are declared for the various tags. Did I miss
> something?
>
> It also looks like tag_ocelot.c and tag_sja1105.c should have their
> dsa_device_ops structures const, as a separate patch certainly.
> --
> Florian

Actually I wrote this patch in such a way that the assembly code
generated would remain the same, since dsa_tag_generic_flow_dissect is
inline, the arithmetic would be done at compile time, which it
wouldn't be if this function were to look at the tagger .overhead.
I don't know, I can do either way.
