Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CE73A413D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhFKLbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:31:48 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:33298 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhFKLbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:31:47 -0400
Received: by mail-pj1-f42.google.com with SMTP id k22-20020a17090aef16b0290163512accedso7137570pjz.0;
        Fri, 11 Jun 2021 04:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YbvaMW03e8xIxAJEJbzPaDC4DvcQ9C3SOu0CHYRMSVU=;
        b=gS/M4PcizQrWPa17aGQgAjXwYWTeS7z4noAhDP4eEdqH0iN2xzUNoS3PovNvcO+Y79
         OUWjgUlBxcrMmsfqnAZ24KZixxGIJyHWXSKjUn83WIo1/W4fQcuwPOShEs9jwGtvzxtr
         BMnS0pdY80AOn625BPv8kPaXsB/Xy/L8ROQVXTP+jhYH/rnzoBekLz1ZGh1KXOOJLyNh
         ilmSjIzuHg8iEgYYqvTHooCRx+R8KqFHD1PkOj7SsMM2svFrgYZvEBCBs8cJkaxJy5pG
         nLpRpe0qhKn/arOiTzNSjsW/iZS9KBOTDavG9rl8iCiK99kqF/3yr0Srp2PqyVpZ3TDg
         tJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YbvaMW03e8xIxAJEJbzPaDC4DvcQ9C3SOu0CHYRMSVU=;
        b=Gibqv0VPTgWhqq7H/E8qnQXPsSRzr52mfdVyjqHp4QhFj59s7HF4rF6X0flINNoiCN
         3bwc5ck8W94JNVcPKYgScUQ4ZYvV2G1D2jenr33O5HHOnaitTVpiPhH/8cD5cKdNlYsT
         xn/UJXAtiSkdimljS0aPzGAgbcpu9v+y3pgQclAtre0V8Spjo7R57aBMMpiq3VA2Zfzb
         pWArRVhbXhvbuygrhb9aKXPJkEFBniDO+kvWg2Ss6PMEmJkxGLZg/xPZvCcQ3qQ0Qmv2
         TDU9kpJoLy47lHJ+vFB1JWXQ5Z5zwkMhXijhDBF2zOP8RJjtz9wbHUQzxBVcJ0leO5kV
         j5iw==
X-Gm-Message-State: AOAM530WxHbsDMR6OKf8HjvPhGpa0NMqk7Q04cgEGy58qBRUx11iBuOT
        SuW7EE9/6vY6blOjgRWGPIWitymXOM39Q1OMxJM=
X-Google-Smtp-Source: ABdhPJwl76sa8kaBgpjXtKdfniOzow+L47tFEY0vxLwRHj2GPS6g9a54wsTVFCikSRN5qgXtJBzBbRZHaNMy9+X3+Cc=
X-Received: by 2002:a17:902:b190:b029:105:cb55:3a7a with SMTP id
 s16-20020a170902b190b0290105cb553a7amr3537575plr.17.1623410916420; Fri, 11
 Jun 2021 04:28:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210611105401.270673-1-ciorneiioana@gmail.com> <20210611105401.270673-5-ciorneiioana@gmail.com>
In-Reply-To: <20210611105401.270673-5-ciorneiioana@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 11 Jun 2021 14:28:20 +0300
Message-ID: <CAHp75VdmqLnESxf5R8Yvn02QDv=_WmkWEcRZMjxUjLg+KDcyQg@mail.gmail.com>
Subject: Re: [PATCH net-next v9 04/15] of: mdio: Refactor of_phy_find_device()
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 1:54 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
>
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
>
> Refactor of_phy_find_device() to use fwnode_phy_find_device().

I see that there are many users of this, but I think eventually we
should kill of_phy_find_device() completely.

-- 
With Best Regards,
Andy Shevchenko
