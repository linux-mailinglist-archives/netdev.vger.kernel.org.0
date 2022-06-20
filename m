Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4D0552797
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 01:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346319AbiFTXGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 19:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345765AbiFTXFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 19:05:48 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20DD237F8
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 16:05:10 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id b23so4919562ljh.7
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 16:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=de5jrWZiqnn0+oFXecM5dyCJcFars+Fig56GZVQKRUg=;
        b=S3KHvFP4pbdA13PxLXWdUbeHiGeLTu+AnNZDZZo2fRkHCc1fRDpOiH209phqN4S65r
         IrE4rY0XcuSi3iuFjk+Y0tYmzqqX/4qU3JZsq53gZUVuIznV6xWkfNwFHljlFaHQSOZ6
         6UDM5Cgiljd2WQaw4PGYW16fEkmglmu6XMkfqvsEUidgLxqX2TwH2zjBZJvr7CtnVNBE
         +Ny/2ggA1c72rWU6szfvjhBftki0eBOkKjN2SmIiy0bmbCjN/2BhlHp3+dao+rbXc7V1
         f1nZxG5MGtOhx7aBEpcqDOEUVwvgFZ0UNPV3dwM3v6QKks49I+mES+lpM1g/wH1DNOZg
         mDTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=de5jrWZiqnn0+oFXecM5dyCJcFars+Fig56GZVQKRUg=;
        b=FBBVkzXZ5WndtaJddBY0Ipu1xQn3vrk73uqugve3vdp4ulkjHancaOdS3K64WHhrCa
         +6K1GZ3hzoce2/tR3qTV9Sr0f4z/kdM3Q5GGwY/8PHe+LoQ4hLdfI0fpHU82YCFw9JQH
         Qle6WNr+5Tbc9mD8azNmCcfcmmV9hJswVChOw0RuXiHbloR47Fo/nmDuEWhW4szexelV
         X72S8T2SFmZvIZ5EEqcCNcnJU6/s9oEXYitUg4I++BXZZIj5eXGWVYwbSPLaAqoDb1rE
         RlHVfdSOhdWlBCFjXBmEBJv+nEW545Qz6aCGm1W6wbz7CINYf0zTPAev5i8Km5pQw6Lm
         7xVw==
X-Gm-Message-State: AJIora/dO/RVevtD+mIR93v3wrJWvBE4XY2nrNAjVkuKpX4MBVM6/w1u
        kyKBt9zsvBdIus5JDXuTNJAlG4u+FvxSbC+w2i5Wbg==
X-Google-Smtp-Source: AGRyM1sHtnzUqBBH1KYBCQyTHabvpAr+fu4M3EbV1mZSz0+FUrrK9084OV28eW2kvYT50WgKf3f05ZnG//nxZP+RA68=
X-Received: by 2002:a2e:860e:0:b0:25a:6dbe:abb5 with SMTP id
 a14-20020a2e860e000000b0025a6dbeabb5mr4403829lji.474.1655766308953; Mon, 20
 Jun 2022 16:05:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <20220620150225.1307946-9-mw@semihalf.com>
 <YrC0BSeUJaBkhEop@smile.fi.intel.com>
In-Reply-To: <YrC0BSeUJaBkhEop@smile.fi.intel.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 21 Jun 2022 01:04:58 +0200
Message-ID: <CAPv3WKdiftkA4_D-z_j1GqyAVk9Rit2Rwf_z=OttMaAZ4f2oAQ@mail.gmail.com>
Subject: Re: [net-next: PATCH 08/12] ACPI: scan: prevent double enumeration of
 MDIO bus children
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        vivien.didelot@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pon., 20 cze 2022 o 19:53 Andy Shevchenko
<andriy.shevchenko@linux.intel.com> napisa=C5=82(a):
>
> On Mon, Jun 20, 2022 at 05:02:21PM +0200, Marcin Wojtas wrote:
> > The MDIO bus is responsible for probing and registering its respective
> > children, such as PHYs or other kind of devices.
> >
> > It is required that ACPI scan code should not enumerate such
> > devices, leaving this task for the generic MDIO bus routines,
> > which are initiated by the controller driver.
> >
> > This patch prevents unwanted enumeration of the devices by setting
> > 'enumeration_by_parent' flag, depending on whether their parent
> > device is a member of a known list of MDIO controllers. For now,
> > the Marvell MDIO controllers' IDs are added.
>
> This flag is used for serial buses that are not self-discoverable. Not su=
re
> about MDIO, but the current usage has a relation to the _CRS. Have you
> considered to propose the MdioSerialBus() resource type to ACPI specifica=
tion?
>

Indeed, one of the cases checked in the
acpi_device_enumeration_by_parent() is checking _CRS (of the bus child
device) for being of the serial bus type. Currently I see
I2C/SPI/UARTSerialBus resource descriptors in the specification. Since
MDIO doesn't seem to require any special description macros like the
mentioned ones (for instance see I2CSerialBusV2 [1]), Based on
example: dfda4492322ed ("ACPI / scan: Do not enumerate Indirect IO
host children"), I thought of similar one perhaps being applicable.

Maybe there is some different, more proper solution, I'd be happy to
hear from the ACPI Maintainers.

[1] https://uefi.org/specs/ACPI/6.4/19_ASL_Reference/ACPI_Source_Language_R=
eference.html?highlight=3Di2cserialbus#i2cserialbusterm

Best regards,
Marcin
