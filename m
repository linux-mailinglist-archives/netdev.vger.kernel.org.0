Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0443522D6DF
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 12:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgGYKse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 06:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgGYKsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 06:48:33 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDEAC0619D3;
        Sat, 25 Jul 2020 03:48:33 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id z5so6785082pgb.6;
        Sat, 25 Jul 2020 03:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=egbrpsXboldbIPxPzx8L1SY5zmDesIcRUjP9BGOlyoI=;
        b=kjrrwM7WcB89fOhGqr4PjxnzSeMMJi4/SGBPiDNHLr89+TEVH3Z4I4d9ryC9t/U+d8
         v0CgBjUM9UJPQGzzDj6mDK8OqUFPMpD/4E1p7BOpyYGlvqVxFOruQJTwZAJN4Qr88BCs
         TptCUrku4uSMVDFrrptZcogemfRRAkTAbeTM7IBVy+OnTnEwK6RnE9xI8ipT5u9AKcDm
         3EwaerGCJWLNrcxnooyp2hPdwt/xelBliqnv5U1VK3AHjqEmHYTiSR1zF3tATKFniP5X
         5+AWGpLSalb8r8e+0wBeKGl7Wn+d8KKqE99iN53yekZJ5KtAorXXvuJo2J7XE6faiYiD
         1F4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=egbrpsXboldbIPxPzx8L1SY5zmDesIcRUjP9BGOlyoI=;
        b=Uj0Eehc9yyoYmttIih+MMT5w76wmACfFSH9GwktwLso6UWDXFYiyygmI6OsPgRG6PI
         xCe9dUeSZSEDZX1MLaivnpA4I5Qgyivow9A6f0fR0L8vkuitadnk8hprhd7jelNdXMSS
         iXO6ht1pSfijpYM903GDK0109U7N4nxZDd94zV8a2Kd8hwiX/DLR5QLeEClHu6rh2gQK
         TJp6nCRcR+NF8MVco5ly49KDDNs3wWaD7PqMPFCM7wCZPTYxV3TuHjTt7f8kTmGDchte
         bInqSHdNw71HsQL3IbWTxela3MNIrfI98fijIRN0vEwaA4H40DZ4nuZYJWohlQsNWpzE
         mmfw==
X-Gm-Message-State: AOAM5317cBLbf0eHaBql5sUNIlN2O2cDx3Pziq5O1v3rZNUZkk/xmVeT
        iti3Ziu77ZHdk9/fPPfEX2PiZziMCEFHHIOvlJM=
X-Google-Smtp-Source: ABdhPJxBQjl87MTP8w2Gtl8kw7gZoryfmLtxtqTknFCuoMqEs9b0UOwvRNrVgOn8g9Ru9D9PuMdaH5qcEQUDuhnfwrU=
X-Received: by 2002:a63:a05f:: with SMTP id u31mr11805878pgn.4.1595674113172;
 Sat, 25 Jul 2020 03:48:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com> <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch> <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <a95f8e07-176b-7f22-1217-466205fa22e7@gmail.com> <20200724192008.GI1594328@lunn.ch>
 <CAHp75VdsGsTNc-SYRbM6-HHXSoDdLTqBrvJwyugjUR6HTxwDyA@mail.gmail.com>
 <2fee02c2-4404-cd2e-8889-97e512a117f4@gmail.com> <CAHp75Vf4nDX-LQr=_FCmv5rj_v-6ZHr4H8pHmAU_N2Wgy=c5ug@mail.gmail.com>
 <20200725073654.GA12097@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20200725073654.GA12097@lsv03152.swis.in-blr01.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 25 Jul 2020 13:48:16 +0300
Message-ID: <CAHp75VcXWB+7VyLJvb+BC6ymObWChUCh-HS-KtPmU-VY5rwxZg@mail.gmail.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO PHY
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Al Stone <ahs3@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Paul Yang <Paul.Yang@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 10:37 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
> On Fri, Jul 24, 2020 at 11:20:04PM +0300, Andy Shevchenko wrote:
> > On Fri, Jul 24, 2020 at 11:13 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> > > On 7/24/20 1:12 PM, Andy Shevchenko wrote:
> > > > On Fri, Jul 24, 2020 at 10:20 PM Andrew Lunn <andrew@lunn.ch> wrote:

...

> > > >> I think we need to NACK all attempts to add ACPI support to phylib and
> > > >> phylink until an authoritative ACPI Linux maintainer makes an
> > > >> appearance and actively steers the work. And not just this patchset,
> > > >> but all patchsets in the networking domain which have an ACPI
> > > >> component.
> > > >
> > > > It's funny, since I see ACPI mailing list and none of the maintainers
> > > > in the Cc here...
> > > > I'm not sure they pay attention to some (noise-like?) activity which
> > > > (from their perspective) happens on unrelated lists.
> > >
> > > If you what you describe here is their perception of what is going on
> > > here, that is very encouraging, we are definitively going to make progress.
> >
> > I can't speak for them. As a maintainer in other areas I expect that
> > people Cc explicitly maintainer(s) if they want more attention.
> > Otherwise I look at the mails to the mailing list just from time to
> > time. But this is my expectation, don't take me wrong.
>
> Sorry about this miss.
> In some past patch-set, I had added Rafael but somehow missed him this time.
>
> From the "MAINTAINERS" file, I got two maintainers. I don't know who else
> can help with this discussion. I'll add others whom I know from ACPI list.
> M:      "Rafael J. Wysocki" <rjw@rjwysocki.net>
> M:      Len Brown <lenb@kernel.org>
>
> If you know others who can help, please add.
>
> Hi ACPI experts,
> Would you please help review this patchset and guide us.
>
> Please see the discussion on this patchset here:
> https://lore.kernel.org/linux-acpi/20200715090400.4733-1-calvin.johnson@oss.nxp.com/T/#t

I would recommend resending the entire series with an appropriate Cc list.
See below as well.

ACPI FOR ARM64 (ACPI/arm64)
M: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
M: Hanjun Guo <guohanjun@huawei.com>
M: Sudeep Holla <sudeep.holla@arm.com>

-- 
With Best Regards,
Andy Shevchenko
