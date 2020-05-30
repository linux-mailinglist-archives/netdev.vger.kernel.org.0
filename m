Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD321E93F0
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgE3V0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgE3VZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 17:25:59 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924DDC03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 14:25:59 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id s19so4390896edt.12
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 14:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4d9dU5SW3iwBCvmV+StspTzSCuDB488WNnwA44+dh/Y=;
        b=cETQiW/v2CHFXlxiihdLVEgVHj43q7kOSbvWO1yY6b4hLJThxRu5fzX3pF+av1G+L0
         ISJSIZBxKTBqqUs4EZlkWt64BBndtu81KPFUR/Ixo3950T52VZRcJibHEE7U7MV5/a/Z
         +BDcO3tsVEsxD631gy1IAG5QOhBILLb0isZ0FJXXhsl7YpBjpaolM99slM30CgZwp+FY
         e6wlh0IDC1qG6lOIU5jWpP0WvaxhizT675yc+Opt5aLzc6YwXdjqc43QujVWDN9prZeA
         Yjl4Bstu1SyqqmH25LnQ4+l0vsQUuD/0xu1t8XkTB8LKHgwENxFW1gfDlKdwzomANCDo
         zSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4d9dU5SW3iwBCvmV+StspTzSCuDB488WNnwA44+dh/Y=;
        b=EvWtv8kXLnyWQ/AfN+l9rJPaCSUgw4dyO/tXZwhPWMtdJ/dGS8SRsuC+zhCnnc+Kl0
         eX2HSL2O5ZtoWvmjTatT8b4pEQ/pHAFs+j5ZQdXX8xaJoGS/ziId8l4ovVcL364zDcgt
         8YBB3syNRxi9wBeHGx0I6Q8JLGj700QxYx9Y0rfCcl4BOKmC7lwZh2d4tcyqIstgiu3s
         jp+TR2zqwWfU8BQrlwMySy7XXvTeXxOoBhrLkdmStFmnRgksWroK8VDVjXJ3kF/eRyui
         jn6CTxx4ltLezE+chFbdw0PUGPS4fnoHaQrkDdCfNMLVN/n8PfuznASMYhE1lsi5S9KH
         X9nA==
X-Gm-Message-State: AOAM530cfxuZvfS+PuefOmdBaq7L9OfDb15eI75WehkJ05B5/tlEWIL6
        Ilzi3ZyB9hTguitJSm/BGahLhhSjMMGf/AdLvhU=
X-Google-Smtp-Source: ABdhPJyUYrvGE1pQLe+RMMfvHL23K2IkVRVEiAwx57a5W67Dz5pVy0eLqSTxrzZM6ZhfTm6ieTH/+WVEJLZTx6AOASc=
X-Received: by 2002:a05:6402:2213:: with SMTP id cq19mr14617034edb.337.1590873958159;
 Sat, 30 May 2020 14:25:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200530115142.707415-1-olteanv@gmail.com> <20200530115142.707415-6-olteanv@gmail.com>
 <88be2af0-b68d-4eea-bfb4-9a7dd5276df8@gmail.com>
In-Reply-To: <88be2af0-b68d-4eea-bfb4-9a7dd5276df8@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 31 May 2020 00:25:46 +0300
Message-ID: <CA+h21hpEZchbE_weA_tZm-XW9o9uHU=7TvKhD2ZAYX7e5GootA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 05/13] net: mscc: ocelot: convert
 QSYS_SWITCH_PORT_MODE and SYS_PORT_MODE to regfields
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Sun, 31 May 2020 at 00:18, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/30/2020 4:51 AM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > Currently Felix and Ocelot share the same bit layout in these per-port
> > registers, but Seville does not. So we need reg_fields for that.
> >
> > Actually since these are per-port registers, we need to also specify the
> > number of ports, and register size per port, and use the regmap API for
> > multiple ports.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> > Changes in v2:
> > None.
>
> [snip]
>
>
> >       /* Core: Enable port for frame transfer */
> > -     ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
> > -                      QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
> > -                      QSYS_SWITCH_PORT_MODE_PORT_ENA,
> > -                      QSYS_SWITCH_PORT_MODE, port);
> > +     ocelot_fields_write(ocelot, port,
> > +                         QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE, 1);
> > +     ocelot_fields_write(ocelot, port,
> > +                         QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
>
> I am a bit confused throughout this patch sometimes SCH_NEXT_CFG is set
> to 1, sometimes not, this makes it a bit harder to review the
> conversion, assuming this is fine:
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> --
> Florian

Yes, this is a subtle point, but it's correct the way it is, and I
didn't want to insist on the details of it, but now that you mentioned
it, let's go.
Seville does not have the QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG register
field at all. And using the previous API (ocelot_write_rix), we were
only writing 1 for Felix and Ocelot, which was their hardware-default
value, so we weren't changing its value in practice. So the equivalent
with ocelot_fields_write would be to simply not do anything at all for
the SCH_NEXT_CFG field, which is actually something that is required
if we want to support Seville too.

Thank you so much for reviewing the entire series!

-Vladimir
