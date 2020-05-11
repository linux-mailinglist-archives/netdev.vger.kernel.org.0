Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84AAA1CD8AC
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 13:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgEKLkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 07:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726068AbgEKLkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 07:40:41 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEE3C061A0C;
        Mon, 11 May 2020 04:40:41 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id d16so7641761edq.7;
        Mon, 11 May 2020 04:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7rvqhtiTLlj4w2K6mESQ0NuOZ1bKvCaqJT+NBpPz/2E=;
        b=D5WgdzfJizVSqox0msoDzj7m8OdEmO0/kiBnC2gqWQquhJ83Dwd9dPrLcGsAdKXUwa
         D+7VQ2KAtE8ACaOLR4DD55ytcAvPISoQc+ejib9hhqKxweAIMMT8h8JexGt5hWL4gESr
         6ktW8JIZm94gvklYOtVQtXpJH9OBHD7vLXalm6hM6IC564h7lxALH3CVqGTS7RCf2VSc
         3wWeblWu1I8pKdU1dDZkpCQkhx6eLEYvq37srP0Gi7MPYtLJQRoYEZAODzVmcWDFl7ax
         9ykFu8ahU9ONiAYHqU9efoz31OM3HUZIVEOgddooqndO5yFf6hHOBoX6UM9+LdtFl+LI
         GzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7rvqhtiTLlj4w2K6mESQ0NuOZ1bKvCaqJT+NBpPz/2E=;
        b=ew26OjFcVV3bYcBryrVJRaBrsPoPCaS3mZFTH7+ZV9C3Tm94BtiZUdEopJ557+aZpN
         hMs866/dwZOtr3OUzzmLMrz7a4ndG/7zLYULs2uhHbWQUwY5htyIDUdJ7PKbQwsiTNit
         DrS9dkAMxSfz/EtulqQegcj/YItRD2At4Me6/fHvkXwGrcsVW+Coxqw0iaQEOU1FjBbR
         WwL5pj9+Rvxska57fjpHUw9MYugpsNJnF61GyZKuSG0JiwcOkbE+2HCLqI/zcgrOhlUN
         69+QTs2bBoiH7dpfMI8bWxQx7N9KWmi4H1zCXFYgP7mek3BjPTPqT4g/KbA0PnTspe5C
         fOIg==
X-Gm-Message-State: AGi0PuZ1X4lUDYA+M0oyXF4xdbz/tMvA0P92SHQZn3wySFGy8CDW+uRV
        ZL2rlmkioiiSoI/v5vxTW4/FxAABtAdfcscSVQ8=
X-Google-Smtp-Source: APiQypKwShxGEPDFc1vGG1bR/2hzLWwravJ6XPl0N2apYLrtl0wXKsm6Gfw/sGNUmutdffdPAF47R5C5vClfjqUKHpk=
X-Received: by 2002:a50:e002:: with SMTP id e2mr13431004edl.179.1589197239963;
 Mon, 11 May 2020 04:40:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200510164255.19322-1-olteanv@gmail.com> <20200510164255.19322-2-olteanv@gmail.com>
 <20200511113850.GQ1551@shell.armlinux.org.uk>
In-Reply-To: <20200511113850.GQ1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 11 May 2020 14:40:29 +0300
Message-ID: <CA+h21hpsBvjDJpRKwOj8ncN_NyE1Qh+HQfYLFu3eb_wgyS__bg@mail.gmail.com>
Subject: Re: [PATCH net-next 01/15] net: dsa: provide an option for drivers to
 always receive bridge VLANs
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 May 2020 at 14:38, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Sun, May 10, 2020 at 07:42:41PM +0300, Vladimir Oltean wrote:
> > From: Russell King <rmk+kernel@armlinux.org.uk>
> >
> > DSA assumes that a bridge which has vlan filtering disabled is not
> > vlan aware, and ignores all vlan configuration. However, the kernel
> > software bridge code allows configuration in this state.
> >
> > This causes the kernel's idea of the bridge vlan state and the
> > hardware state to disagree, so "bridge vlan show" indicates a correct
> > configuration but the hardware lacks all configuration. Even worse,
> > enabling vlan filtering on a DSA bridge immediately blocks all traffic
> > which, given the output of "bridge vlan show", is very confusing.
> >
> > Provide an option that drivers can set to indicate they want to receive
> > vlan configuration even when vlan filtering is disabled. At the very
> > least, this is safe for Marvell DSA bridges, which do not look up
> > ingress traffic in the VTU if the port is in 8021Q disabled state. It is
> > also safe for the Ocelot switch family. Whether this change is suitable
> > for all DSA bridges is not known.
> >
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> This patch was NAK'd because of objections to the "vlan_bridge_vtu"
> name.  Unfortunately, this means that the bug for Marvell switches
> remains unfixed to this day.
>

How about "accept_vlan_while_unaware"?

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

Thanks,
-Vladimir
