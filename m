Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523D025E8ED
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 17:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgIEPxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 11:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgIEPxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 11:53:34 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72C3C061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 08:53:33 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id a65so8645895otc.8
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 08:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zrdHXvLI6MPE3rYha+kZy0sO09hPJ/rhtevQQwfmg6U=;
        b=Je9NvyFz01loSRKcXcFBV26U1JMY+FJv8pWsfptmuVPAUlKM9LsLKu6kWu5pI3ZIBB
         t0+PS/aZY/DsyaM2w5Zv1ZIhqNazG9/WtyK36t76YXkJ7wONuogqANDbT8Dfh0JoEc7F
         SAR1lhqrXPEO22INfmz1npu4kxduksv3Ahoy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zrdHXvLI6MPE3rYha+kZy0sO09hPJ/rhtevQQwfmg6U=;
        b=Tj0coGTBlfUXm5lxDzt/uUYAMYm7jy9aT+JWjURNQu1uyGMAmiU43Pi+ujNtg+JEAE
         T6g71+0JculFHkc4FSLl3ri84Clv8vPb6yOl24h4qn+jb3Lju0i/hVb3clZXY4S8Z8Xw
         UIjmm5oe5od/g5rjO7qMkAMxvp3cjtwH4IO+/T2JzTqWRyLi6HPJHbuMWPBsKZIIiMOQ
         jff4XchTNqwywfo8BdeyuGYjUSytnoTjLjaE9p/x9BclNiKk+4Qv2wRtls36nXOb2GDI
         rfNWyx5jT1RDNDQqK37uedc+QyIC3Xf/5C6CyJ8OB4C/lZGznBF3ZPzbgeZhy1dpFtOF
         JGdg==
X-Gm-Message-State: AOAM530/Hkh1vZgc0FmH4rBqbbbxFDI3NP1OTYxd5XZM2sHBaKzcZiEA
        sah3XtRhIiawl1M71EeADUcM/UyFlRM5mzTxxOPClaRR223pmA==
X-Google-Smtp-Source: ABdhPJzHBdpDv13rAFaoWrNUBMeWlhScQbeLSHCIBVKnziysggQrUuS8QhjZO44/pzuj0rdQvbkWlw7IvkpRUw1I7EY=
X-Received: by 2002:a9d:24aa:: with SMTP id z39mr9433272ota.258.1599321211196;
 Sat, 05 Sep 2020 08:53:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200905140325.108846-1-pbarker@konsulko.com> <20200905140325.108846-4-pbarker@konsulko.com>
 <20200905153238.GE3164319@lunn.ch>
In-Reply-To: <20200905153238.GE3164319@lunn.ch>
From:   Paul Barker <pbarker@konsulko.com>
Date:   Sat, 5 Sep 2020 16:53:20 +0100
Message-ID: <CAM9ZRVs8e7hcS4T=Nt6M4iyDWA8uT42m=iRnYzQFg0ajL6rwTw@mail.gmail.com>
Subject: Re: [PATCH 3/4] net: dsa: microchip: Disable RGMII in-band status on KSZ9893
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Sep 2020 at 16:32, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Sep 05, 2020 at 03:03:24PM +0100, Paul Barker wrote:
> > We can't assume that the link partner supports the in-band status
> > reporting which is enabled by default on the KSZ9893 when using RGMII
> > for the upstream port.
>
> What do you mean by RGMII inband status reporting? SGMII/1000BaseX has
> in band signalling, but RGMII?
>
>    Andrew

I'm referencing page 56 of the KSZ9893 datasheet
(http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ9893R-Data-Sheet-DS00002420D.pdf).
The datasheet says "The RGMII port will not function properly if IBS
is enabled in the switch, but it is not receiving in-band status from
a connected PHY." Since we can't guarantee all possible link partners
will support this it should be disabled. In particular, the IMX6 SoC
we're using with this switch doesn't support this on its Ethernet
port.

I don't really know much about how this is implemented or how widely
it's supported.

Thanks,

-- 
Paul Barker
Konsulko Group
