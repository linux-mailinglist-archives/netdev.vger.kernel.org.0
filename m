Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C042188755
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCQOVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:21:15 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37435 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgCQOVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 10:21:15 -0400
Received: by mail-ed1-f65.google.com with SMTP id b23so26703567edx.4
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 07:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xBtvk6ghI2KuDXApkRh3im46ns4xWTJeBr32Gfgznnk=;
        b=HTjoB+7ovr/lJdi2shsGTjJg5KANMIMHl1PQr4rzJQ7YiGc/lZ7Zj0uMQeGQPobtSr
         bJGgBctZEBgw7W+VAGDNlb5qRZwqCWADtCupMnzVDWmh0US4R5qdZwLb3f+WDry4N1xD
         20XemdpvhdLp33hUexNavO4npz2ce5jAoMaRJQG7HUNE4sxXaobV/HwSc7IdNGN/3GZu
         5g+L7BTU0+jolbXsJem5cGWi615+pnHu6CCaConkCu+Mn07g1q2dZPFRT6MbZexYNKkd
         olJzqRDMc5MOEQO0iPMF+gx1uv+U1TLHCDLbVtwLaP/HOUiUAEZpsbJSnlq3e/aI0g7a
         qOiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xBtvk6ghI2KuDXApkRh3im46ns4xWTJeBr32Gfgznnk=;
        b=lJqXulmQkqKYDkewzhsv6B2D1K35dWKTBTO+hOsAwJtD4+5hw8Aybtw8exQxVisRkb
         51HJvfoVM6eqEGXcEAxj+i7Q17zVf0PzheOMA7DX4Lgnqro3Jba9GPMIwjoeiLP/FJYd
         Gf5wtCkmU42s/uQmnBDzzbZiIKf64ENL7t9rhcCEY4Kz4fYBQcQ3jVBPed/VxnfKjOYP
         z+AvFdXUvcgh72xrhalfFk1RnzIN29htsFE3X3ersz2nW7NRR3kBZhcHgcGsY0Q40Av6
         Db4uF2Oh1x0Bi3jY3zbEk09Dg8cjEV+o5+Tgnmw51hOPJrsiZF6mnrhgOwJUSdbp0gza
         5qQg==
X-Gm-Message-State: ANhLgQ1h7L+/VCpaLMQxR+jegfXVeHKcet+gxwU3GW8sQwb0/Ukv4vFf
        kqH1as43lB9X37ni/CeJem3zjDusnG9fapycn/9eXoeCPxM=
X-Google-Smtp-Source: ADFU+vugxNt6HIZJ4F+jdafHFHttONtop9w31q6KzOU64IGXNQ5ubmz6ImC7Zyx44E2K4MfKqqlpmF3eFy9et6yL0x4=
X-Received: by 2002:a17:906:aed3:: with SMTP id me19mr88968ejb.6.1584454871808;
 Tue, 17 Mar 2020 07:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200218114515.GL18808@shell.armlinux.org.uk> <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
 <CA+h21hrjAT4yCh=UgJJDfv3=3OWkHUjMRB94WuAPDk-hkhOZ6w@mail.gmail.com>
 <15ce2fae-c2c8-4a36-c741-6fef58115604@gmail.com> <20200219231528.GS25745@shell.armlinux.org.uk>
 <e9b51f9e-4a8f-333d-5ba9-3fcf220ace7c@gmail.com> <20200221002110.GE25745@shell.armlinux.org.uk>
 <20200316111524.GE5827@shell.armlinux.org.uk> <20200317120044.GH5827@shell.armlinux.org.uk>
In-Reply-To: <20200317120044.GH5827@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 17 Mar 2020 16:21:00 +0200
Message-ID: <CA+h21hpGvhgxdNid8OMG15Zyp6uzGjAq_xmGgz2Udvo3sHuZ0g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, 17 Mar 2020 at 14:00, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Mon, Mar 16, 2020 at 11:15:24AM +0000, Russell King - ARM Linux admin wrote:
> > On Fri, Feb 21, 2020 at 12:21:10AM +0000, Russell King - ARM Linux admin wrote:
> > > On Thu, Feb 20, 2020 at 10:56:17AM -0800, Florian Fainelli wrote:
> > > > Let's get your patch series merged. If you re-spin while addressing
> > > > Vivien's comment not to use the term "vtu", I think I would be fine with
> > > > the current approach of having to go after each driver and enabling them
> > > > where necessary.
> > >
> > > The question then becomes what to call it.  "always_allow_vlans" or
> > > "always_allow_vlan_config" maybe?
> >
> > Please note that I still have this patch pending (i.o.w., the problem
> > with vlans remains unfixed) as I haven't received a reply to this,
> > although the first two patches have been merged.
>
> Okay, I think three and a half weeks is way beyond a reasonable time
> period to expect any kind of reply.
>
> Since no one seems to have any idea what to name this, but can only
> offer "we don't like the vtu" term, it's difficult to see what would
> actually be acceptable.  So, I propose that we go with the existing
> naming.
>
> If you only know what you don't want, but not what you want, and aren't
> even willing to discuss it, it makes it very much impossible to
> progress.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

As I said, I know why I need this blocking of bridge vlan
configuration for sja1105, but not more. For sja1105 in particular, I
fully admit that the hardware is quirky, but I can work around that
within the driver. The concern is for the other drivers where we don't
really "remember" why this workaround is in place. I think, while your
patch is definitely a punctual fix for one case that doesn't need the
workaround, it might be better for maintenance to just see exactly
what breaks, instead of introducing this opaque property.
While I don't want to speak on behalf of the maintainers, I think that
may be at least part of the reason why there is little progress being
made. Introducing some breakage which is going to be fixed better next
time might be the more appropriate thing to do.

Thanks,
-Vladimir
