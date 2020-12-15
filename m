Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6E92DB2F3
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgLORpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731231AbgLORpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:45:08 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADABC06179C;
        Tue, 15 Dec 2020 09:44:28 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id iq13so11732pjb.3;
        Tue, 15 Dec 2020 09:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ThQTZX/xY0rNYysmJ/qm+hVZ2miL/UxBMa/A766wd0=;
        b=W9ukwTxhJN/hsc4JcxP4IpiUTw4T9UdUDs32QWwUYzNyit2T1akC7c4Rh3BWmUww8c
         xBk0VPPh24NUJk65PPcBmckI7wSLSYSXyn9AHfP69veD0ECeHF5bGlWRs4vi/305Zgna
         2mMfFoXPTwuRn0DsnYA04pwUU+EAOplP73lRXP8yhYqWJ9G2GT6JHD6XmCPxb5lysyfV
         svpYyhwFziWOgo/BW9tNqymqMmXr6iYXhhA+nHX9m5xYEe8zFYTr+EjXtykqjxouZfF3
         SLSpXzS7w931hFtmhy68S2Dfh9Sr+vnYv9sBVNZBzE7PklLknBplRKoHtZ/ZWqisVrBM
         /JFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ThQTZX/xY0rNYysmJ/qm+hVZ2miL/UxBMa/A766wd0=;
        b=IPA9tzDQpFvDG71fVzXppB1aoX9kZlO5BddPpQD6J90/Qi1oqCiw73MlYH2GMUU9Yq
         9MhZHv06imxNYqpki0tfK7Eg2dibOV+jOKUi09ZrtPfCT6Ijbjp2x6mY/ATccbuMcxgE
         uJDxtLG/1SNqiKbgZwhe12eEqIycag2BEF+ju0bsnJBjkgVnwTFL8OCum0S0Nct5zqE6
         R6wvLwFmzW8Cut/JNRk7WbvoLbEhPtnln5dT5tT47AnGPA41Iv0fzVtUBb5vO1dhayFf
         hf8AO+x4AqkNfWG+h+Esapy35TMn1DXGO3WsQR98gmUh+OGEAwrDdx3hGnDwR2i2D59k
         qP3Q==
X-Gm-Message-State: AOAM531C5TCwjoJ0es92WR2UMRGPIU2Hb/Z/z3wI7U8utRR9AappQHEM
        AazhXUVTzxmMt8raUBS9AI0rNF/OuUfka7I2wz8=
X-Google-Smtp-Source: ABdhPJzg6mG1hb7cImFHyOTzX+/H92tmvffCU6eocPWOz7hP6PWerYjgwdo2xcPnpHCEdyhUaemAp4ZLkBYJcbaWa2k=
X-Received: by 2002:a17:90a:c592:: with SMTP id l18mr3019pjt.228.1608054267894;
 Tue, 15 Dec 2020 09:44:27 -0800 (PST)
MIME-Version: 1.0
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com> <20201215164315.3666-11-calvin.johnson@oss.nxp.com>
In-Reply-To: <20201215164315.3666-11-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 15 Dec 2020 19:45:16 +0200
Message-ID: <CAHp75Vef7Ln2hwx8BYao3SFxB8U2QTsfxPpxA_jxmujAMFpboA@mail.gmail.com>
Subject: Re: [net-next PATCH v2 10/14] device property: Introduce fwnode_get_id()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 6:44 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Using fwnode_get_id(), get the reg property value for DT node
> and get the _ADR object value for ACPI node.

and -> or

...

> +/**
> + * fwnode_get_id - Get the id of a fwnode.
> + * @fwnode: firmware node
> + * @id: id of the fwnode
> + *
> + * Returns 0 on success or a negative errno.
> + */
> +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id)
> +{
> +       unsigned long long adr;
> +       acpi_status status;
> +
> +       if (is_of_node(fwnode)) {
> +               return of_property_read_u32(to_of_node(fwnode), "reg", id);

ACPI nodes can hold reg property as well. I would rather think about

ret = fwnode_property_read_u32(fwnode, "reg", id)
if (!(ret && is_acpi_node(fwnode)))
  return ret;

> +       } else if (is_acpi_node(fwnode)) {

Redundant 'else'

> +               status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> +                                              METHOD_NAME__ADR, NULL, &adr);
> +               if (ACPI_FAILURE(status))
> +                       return -ENODATA;

I'm wondering if it compiles when CONFIG_ACPI=n.

> +               *id = (u32)adr;
> +               return 0;
> +       }

> +       return -EINVAL;
> +}

-- 
With Best Regards,
Andy Shevchenko
