Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC883DBDCF
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhG3RfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhG3RfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 13:35:21 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B4FC06175F;
        Fri, 30 Jul 2021 10:35:15 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id v21so18182294ejg.1;
        Fri, 30 Jul 2021 10:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Doj/dcye763oRah83vvNs5pzHAb0NoOee/TncGZwApU=;
        b=BQg7DckksWodBw0VQ7WPS4t2HMmrgZ+HfNAu/6WhoBRD0YwS2xvVFwP59v6wjDZcxe
         wKQO2DB9rWXR5UyTuC3T+0KaypDyuZAhGPyEk0webhsBW4dcFfoSO0ZSGtilfWKtwXwd
         fw5Fd7AMIFWvsSPXKtQyob0xfiO+S925Xz05Y+jD0w3V2XEYJvDHteBWvxp/Fx0AzMtf
         0hZpqnuIP1KH22HtnuX0kz36ulXHzIOYribAhl8SjjtkFWzX0eGuExK6LfsJZ+m70Imp
         x2EBmf0dpQnKwtkrMZHhBycAkUjA2+el5Iac1fepoQjWZUg2z/lC89lIeEIBTM8g/t42
         uToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Doj/dcye763oRah83vvNs5pzHAb0NoOee/TncGZwApU=;
        b=B0vyQ1kpPHN7bshIAO7bnBc0jY8xLH8AHiphyPFJ0wkpPQMUm/ocfeXcFdQuSMTm8x
         MOBY15kIw8Z/ajcFP6ONXl9OFFOS3x7oFBEJi/uFresscUrby4ibqja5OTjUWPwpnv7U
         DgUyyI1k2UFmtpOHEszJHqsI8J/Am3JdjAiSf5mokzOYdAy4VZNWemsT1e5Fbqp2wO2C
         OG06Tw1dfBk1QTjUOhRNRbAsPnbo72y+Y+Vye5BlYZ5iusPZNPwneV/opdT0/64B3qAD
         vosRXl/wvyP5V/emIvR9xGuKzPhIfdnDUAXRhvFx7tX0BWve6mmsc0abhXwpC65bLzG6
         uA9Q==
X-Gm-Message-State: AOAM532u0kFHbvLGqFr7+S30QwTRHnypkQrOSxpruluNxvTmyroxIbTV
        HcXyDQoWx00QCOZq6AwnWko=
X-Google-Smtp-Source: ABdhPJyOwdP7JUP0KwB6OY34dpeaov8/WjtVtdb0zSBQ4iypGBdQsBLuQqvFN1QpHl2aLsLMa1Bnag==
X-Received: by 2002:a17:906:5509:: with SMTP id r9mr3748176ejp.74.1627666513708;
        Fri, 30 Jul 2021 10:35:13 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id ha26sm778371ejb.87.2021.07.30.10.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 10:35:13 -0700 (PDT)
Date:   Fri, 30 Jul 2021 20:35:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next 2/2] net: dsa: mt7530: trap packets from
 standalone ports to the CPU
Message-ID: <20210730173511.ulsv7wfogk5cpx5j@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com>
 <20210728175327.1150120-3-dqfext@gmail.com>
 <20210729152805.o2pur7pp2kpxvvnq@skbuf>
 <CALW65jbHwRhekX=7xoFvts2m7xTRM4ti9zpTiah8ed0n0fCrRg@mail.gmail.com>
 <20210729165027.okmfa3ulpd3e6gte@skbuf>
 <CALW65jYYmpnDou0dC3=1AjL9tmo_9jqLSWmusJkeqRb4mSwCGQ@mail.gmail.com>
 <20210730161852.4weylgdkcyacxhci@skbuf>
 <20210730171935.GA517710@haswell-ubuntu20>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730171935.GA517710@haswell-ubuntu20>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 01:21:14AM +0800, DENG Qingfang wrote:
> I just found a cleaner solution: Leaving standalone ports in port matrix
> mode. As all bridges use independent VLAN learning, standalone ports'
> FDB lookup with FID 0 won't hit.

So standalone ports are completely VLAN-unaware and always use a FID of
0, ports under a VLAN-unaware bridge are in fallback mode (look up the
VLAN table but don't drop on miss), use a FID of 1-7, and ports under a
VLAN-aware bridge are in the security mode and use the CVID instead of
the FID for VLAN classification?

Make sure to test a mix of standalone, VLAN-unaware bridge and
VLAN-aware bridge with the same MAC address in all 3 domains. If that
works well this should be really good.
