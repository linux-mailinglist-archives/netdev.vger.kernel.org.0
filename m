Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CC31FF86A
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbgFRQAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 12:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729482AbgFRQAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:00:33 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDC6C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:00:33 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bh7so2597414plb.11
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M7KHyNuCpHap1znfgvGDEcijue2ky0WZLK9C2zSvI94=;
        b=hj0/9z3RMZsaOonId/hBjGFJSSVatJvbTVXtS51NnQUTaXBA24I62Jq5dggbkoMEna
         Nw/oNk1aib83UTvCmaeXa+y39Eq+BZHRLbbi9Kq6vsJL+kuztR4iRdxnP/Tz3OIoGSJ4
         qCXICRnVCLQwGULSDOUTAIejYKELBfV6Ujg9Es8vWv9Yrn+K+hhPXzJubjS0pC7x53ra
         NWpukLXcKJLxp6hU8YXfST/jZjM9N5Eji/JA6rqSNm1SltPdEEMYeX5UfhFoSBw3cy1N
         v0LhxhNsmouSRy+3+oL0rMf46YrntYtu+Cvg+Yb+A11JJ9pj+dj9zJlB+cQ31kcRt0O2
         ixkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M7KHyNuCpHap1znfgvGDEcijue2ky0WZLK9C2zSvI94=;
        b=Tv1fiw8sHCo7BR+TTbd3azuNN/SJdjgsltqZl+4eVRo9bVQc0iSiHXrv6vfB4fDHev
         xm/VbBPNSh8pGl4eHV22mOzbpPxf5O14WZY45IIOnVd8REFvz1kFYHCTLSDpn/cDCKhM
         F61+xju81AcTqQCJksHSB9Fh+ROEfs65NZneXstCaYQP//RF+ILyybp+W4k5iQOk5wnC
         LsQ/j5QnL7wemLEQsgeT7sV/5VgOJGYb/whue7fie+SrmMldYkNQyFSOfupE7T0c3dHI
         ebehEhO7ZtYaGnLB0DdmrE2Xkdw0sQjyRypLYIMEYl9ajLaQy906HjpHNAeEfdO/QEKb
         Ad6w==
X-Gm-Message-State: AOAM5335GxYv8GTrkorXNhPOXGe0tWPwJGgHkDt/2xyNjPcSU22Q+l8g
        Pp/5atRqr9T8Dx9vLGIT67gAwuA6MakIGSohBt8=
X-Google-Smtp-Source: ABdhPJz26e8NqHjwD2HBe6pbWqQM2cyHRHBO5yOXu6wf3SNFoK6Wn/604rE4VbXO1T97h/jm2ndLVAbvqCdXKh1QASk=
X-Received: by 2002:a17:90a:b30d:: with SMTP id d13mr4849390pjr.181.1592496032806;
 Thu, 18 Jun 2020 09:00:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-3-calvin.johnson@oss.nxp.com> <20200617173414.GI205574@lunn.ch>
 <a1ae8926-9082-74ca-298a-853d297c84e7@arm.com>
In-Reply-To: <a1ae8926-9082-74ca-298a-853d297c84e7@arm.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 18 Jun 2020 19:00:20 +0300
Message-ID: <CAHp75Vdn=t2UQpCP_kpOyyX_L6kvJ-=vtWp2t87PbYBbJOczTA@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] net/fsl: acpize xgmac_mdio
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 6:46 PM Jeremy Linton <jeremy.linton@arm.com> wrote:
> On 6/17/20 12:34 PM, Andrew Lunn wrote:
> > On Wed, Jun 17, 2020 at 10:45:34PM +0530, Calvin Johnson wrote:
> >> From: Jeremy Linton <jeremy.linton@arm.com>
> >
> >> +static const struct acpi_device_id xgmac_acpi_match[] = {
> >> +    { "NXP0006", (kernel_ulong_t)NULL },
> >
> > Hi Jeremy
> >
> > What exactly does NXP0006 represent? An XGMAC MDIO bus master? Some
> > NXP MDIO bus master? An XGMAC Ethernet controller which has an NXP
> > MDIO bus master? A cluster of Ethernet controllers?
>
> Strictly speaking its a NXP defined (they own the "NXP" prefix per
> https://uefi.org/pnp_id_list) id. So, they have tied it to a specific
> bit of hardware. In this case it appears to be a shared MDIO master
> which isn't directly contained in an Ethernet controller. Its somewhat
> similar to a  "nxp,xxxxx" compatible id, depending on how they are using
> it to identify an ACPI device object (_HID()/_CID()).
>
> So AFAIK, this is all valid ACPI usage as long as the ID maps to a
> unique device/object.
>
> >
> > Is this documented somewhere? In the DT world we have a clear
> > documentation for all the compatible strings. Is there anything
> > similar in the ACPI world for these magic numbers?
>
> Sadly not fully. The mentioned PNP and ACPI
> (https://uefi.org/acpi_id_list) ids lists are requested and registered
> to a given organization. But, once the prefix is owned, it becomes the
> responsibility of that organization to assign & manage the ID's with
> their prefix. There are various individuals/etc which have collected
> lists, though like PCI ids, there aren't any formal publishing requirements.

And here is the question, do we have (in form of email or other means)
an official response from NXP about above mentioned ID?

-- 
With Best Regards,
Andy Shevchenko
