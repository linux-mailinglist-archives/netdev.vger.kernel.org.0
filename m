Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F052B1CD92A
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 13:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgEKL7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 07:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727873AbgEKL7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 07:59:25 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6D3C05BD09;
        Mon, 11 May 2020 04:59:25 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id s3so7671730eji.6;
        Mon, 11 May 2020 04:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U5ZXxiY+Vm4cmvVPkyq6B2NhB+MtOkJX978j6E6fG+4=;
        b=qb8X3CpnIIceryP3gBWgaDyDmNyHT4zOBmwhw3/JKgmw2XSgMvBbThBxyy4SpNCbdE
         mHSoUe/mD22GwXm3bCO2HLwVU0Xn/lQHj150o64WHzvlhjCZePRZ8Y39kcwFSDsALe4b
         XkqrDb//Y43DacnfyCe126PMEpuV4ST/9oJrLQFStaHJCyqbNjISR97AyXvKR69NC78j
         hzjgj/WOOLHsTJktJervvJklZMr47zrVFdIaBTT7pXd24k+MPQW/LZVSkQzmvWDwIMR3
         ehxR0trEAtVLyFVQl9encN9QbCnHJjP/BHqtkMny3epMVY/N3MPUmBOUYSviRZcgcNYS
         Vcfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U5ZXxiY+Vm4cmvVPkyq6B2NhB+MtOkJX978j6E6fG+4=;
        b=cR+dvYhNHa8q5Zp0n42b+LsLDuKa8rUIeLQJHpFBPtn0yr0h9jhSgULLgkuXM9gRhx
         OrSjkgbgsVqjQPMjbZXSRKwI8p7aRNwdDH4ilG/xin4ajO7/WJORkoGShSLlkiZ8+fLl
         brVx8tmzvF/erQqpCj8GcYpS9QPleXxg6dsJCZshLetgjt0DqdVArUCtIcNg12CI60Gx
         ww5HSrgZM58gSI0bL71WWqPpVMuO4iM2tzD2ahWf9TGWCk40pT4hC44bitB5EdcT8sJG
         SLTIaGrj6LUsQmvMe3m/qAsPZoVt2nFYaa2It2NiycOuFCjAqdq4BVd5XCeodKZVCgNs
         wSug==
X-Gm-Message-State: AGi0PuaC+Lpcy5z3MwDKvKYbn/vr6Rb5m73EyFglCW3qEEPQ4ufZZJyr
        qsZRrJszZH+ogCjHmopVIA4AMpOfGNyIBz0JZ64=
X-Google-Smtp-Source: APiQypJJg8KkPWWbIEaaeTeo0z+VJjjE7t1OX2mvwN4z3m9H7eWIhdGyrtYNpETBiUKmKgYZHhWsORtA4iI2wxjVYBg=
X-Received: by 2002:a17:906:660f:: with SMTP id b15mr12112963ejp.113.1589198364261;
 Mon, 11 May 2020 04:59:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200510164255.19322-1-olteanv@gmail.com> <20200510164255.19322-2-olteanv@gmail.com>
 <20200511113850.GQ1551@shell.armlinux.org.uk> <CA+h21hpsBvjDJpRKwOj8ncN_NyE1Qh+HQfYLFu3eb_wgyS__bg@mail.gmail.com>
 <20200511115412.GR1551@shell.armlinux.org.uk>
In-Reply-To: <20200511115412.GR1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 11 May 2020 14:59:12 +0300
Message-ID: <CA+h21ho1NQS=9DGhXbrQA7SxKR2N-hXjyYH32SKGTwYLZ1TUMA@mail.gmail.com>
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

On Mon, 11 May 2020 at 14:54, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Mon, May 11, 2020 at 02:40:29PM +0300, Vladimir Oltean wrote:
> > On Mon, 11 May 2020 at 14:38, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Sun, May 10, 2020 at 07:42:41PM +0300, Vladimir Oltean wrote:
> > > > From: Russell King <rmk+kernel@armlinux.org.uk>
> > > >
> > > > DSA assumes that a bridge which has vlan filtering disabled is not
> > > > vlan aware, and ignores all vlan configuration. However, the kernel
> > > > software bridge code allows configuration in this state.
> > > >
> > > > This causes the kernel's idea of the bridge vlan state and the
> > > > hardware state to disagree, so "bridge vlan show" indicates a correct
> > > > configuration but the hardware lacks all configuration. Even worse,
> > > > enabling vlan filtering on a DSA bridge immediately blocks all traffic
> > > > which, given the output of "bridge vlan show", is very confusing.
> > > >
> > > > Provide an option that drivers can set to indicate they want to receive
> > > > vlan configuration even when vlan filtering is disabled. At the very
> > > > least, this is safe for Marvell DSA bridges, which do not look up
> > > > ingress traffic in the VTU if the port is in 8021Q disabled state. It is
> > > > also safe for the Ocelot switch family. Whether this change is suitable
> > > > for all DSA bridges is not known.
> > > >
> > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > This patch was NAK'd because of objections to the "vlan_bridge_vtu"
> > > name.  Unfortunately, this means that the bug for Marvell switches
> > > remains unfixed to this day.
> > >
> >
> > How about "accept_vlan_while_unaware"?
>
> It's up to DSA maintainers.
>
> However, I find that rather confusing. What's "unaware"? The point of
> this boolean is to program the vlan tables while vlan filtering is
> disabled. "accept_vlan_while_vlan_filtering_disabled" is way too long.
>

Considering the VLAN filtering modes as "disabled", "check",
"fallback" and "secure", I think a slight improvement over your
wording might be "install_vlans_while_disabled". I hope that is not
confusing and also not too long.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
