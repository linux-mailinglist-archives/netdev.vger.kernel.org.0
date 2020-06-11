Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E0B1F642D
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 11:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgFKJBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 05:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgFKJBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 05:01:38 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B18BC03E96F;
        Thu, 11 Jun 2020 02:01:37 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q19so5657856eja.7;
        Thu, 11 Jun 2020 02:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f70qcp+8H8N+7vfQUf6lwsKTErk85DZiUNo0OM0KDKo=;
        b=aKoVo3UVoRws3o5Y4Mxmlc5CpVRvnFOlr2j/nBlJVjQeEXtfxHzwrPhsJli6AvjnVV
         D2ajORkKdG+Q6wYK5z170YS1tb3dUjrKgipBAFPNvZMBU8RZ5Sp2tdFwTv1FlKsMe7OW
         XbdzdYBZJrRVLNOdydDj6PmG+jxHckRkGqscUUiKcxJO7OYqKZzlLyiEP/dAFB3tAFS6
         Y+Gu8GaZ3SIkqci3/IlZqySJX+UgzwRGmIJr1shkLm7rqC41dE51gByJBdbcObQa+Vku
         dmaUOxmJcrqwG/QvlIIMw/bCSFeSKIa+sHc4WDRDNWj9dURnpwiTLhEfpCeub4+GmGUh
         79lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f70qcp+8H8N+7vfQUf6lwsKTErk85DZiUNo0OM0KDKo=;
        b=lk1TzqMc/ZFgytuOlnyNJfgRRKHZWh5p1kXZopZXfTPqQbiLH/kNKaqPQwHg6ru4rW
         xRneWioCozNvLwh9klfZwciJ/8PegFVcz5bl9f3D47ZjCKn2GYQtV3EhB2odD5r8eXHC
         vIB2HATSbn1ig95+yqoz1Cx7xWU1NVESwW84zcnotq/3glU1pHCvd+f5l4VqmONBnWTP
         5NvOAMxPbCfCg2FaLXMshsb4LMl1tprbYwqc4I21pm5bbN/eOSNIfhHlMkYtocYRzPU4
         wjkla0B8x6ikf4Kd8JTohasz2VPpcBVPJXMcs5xnd7ppxZnNS/2RTAHprnODfThjMldH
         iAkA==
X-Gm-Message-State: AOAM532zGgKSDcmdZn6GvLAx7cpMFq0lmPGh2LJPEOXfzmSi+xPptzBV
        oGsFetqYfiKo062slpdIUuSXV/1Itu4GYniiqJ4=
X-Google-Smtp-Source: ABdhPJw0MVbn7mgfpkFtBg6RwYYq81Ac7XcqQYluRO6zP0wiUdzhOOBjlb6fIfKeADfYPAUQdunBXdk4whM5VcBN87o=
X-Received: by 2002:a17:906:2e50:: with SMTP id r16mr7250012eji.305.1591866096170;
 Thu, 11 Jun 2020 02:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1591816172.git.noodles@earth.li> <78519bc421a1cb7000a68d05e43c4208b26f37e5.1591816172.git.noodles@earth.li>
 <20200611085523.GV1551@shell.armlinux.org.uk>
In-Reply-To: <20200611085523.GV1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 11 Jun 2020 12:01:25 +0300
Message-ID: <CA+h21hqyAKucPENVANwuNo-UuCY0W3z8QF1FZ-nhd0uQ8tyC+w@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Jonathan McDowell <noodles@earth.li>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Thu, 11 Jun 2020 at 11:57, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>

>
> Alternatively, phylink supports polling mode, but due to the layered
> way DSA is written, DSA drivers don't have access to that as that is
> in the DSA upper levels in net/dsa/slave.c (dsa_slave_phy_setup(),
> it would be dp->pl_config.pcs_poll).
>

They do, see https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/ocelot/felix.c#n606

>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 503kbps up

Thanks,
-Vladimir
