Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F38B22ECBD
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 15:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbgG0NC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 09:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgG0NC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 09:02:57 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE7FC0619D2
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 06:02:57 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id o10so2393995edh.6
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 06:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k2E5R0AKcBuEyUUw+LZpqSNWjUjho4eY1h7Kd+9PG80=;
        b=1WwtTjBrKbFTRCbux9Hrsg8wz72ddusGilZdTPqH/LbOjU9iqFyVCnYpvOieoAP5GC
         WKQXUP1TMGsQ9wdFGDCQd2NcuHQtmJC/bAq2A+99RuNLVQnwc6uoTYEYr9qeIzpgGFOQ
         LVGjbU6ktzgWy8BPjywxj+KkOIOf+1/Dw/soy0jF8m/3x9W0rvYxURiDBynhy5uElQsZ
         JTcWBLmrrUNWbPAYQzi83AR9NX8wceERtCYTlrNefjyt+iUhvz76ZwEzdlSAOR76ut6e
         yD4bRSut1rkYpThlOByDLH2ZRPZMLo34uF2EqJUYe6ocSLfmO0GsFGI9ryI9APK17ahD
         S+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k2E5R0AKcBuEyUUw+LZpqSNWjUjho4eY1h7Kd+9PG80=;
        b=fkYfmphMtOuIajy8UI7rUFxUgUOVNOE4HEXfKSSK0Pk6ZfvPZLFaMyy7EPYtXzFMX+
         ca329bP311O4oDk/VnQiq4Fwt7eMH/jgzqvttdsMvDbPyWXehocwkXtjULA44jSyiQ98
         P3BZuhJPPVXd/O96BYZz0GdeIqprOOWNsLfJ+k3CrBVdrcbEFiW+EUqr/9xuBgjqj30i
         Jnyoa67mXVncpIf0hCeHR626O0uFMppofxdgPKrJ5i4XLfgyv8Xf5vwIescurnZrTxFc
         MqqTXJRw2+Mv6AGGdaKdUc5ngDXQ/h4FSvHQEMYCaWCoDlgFxlwV4+9g3pvWOUHBgCjN
         tWAw==
X-Gm-Message-State: AOAM5313mWYV55V0eLLpCiDa3DoPpp25+Y2Kl02T2AdQ1mWJRcc5m3mX
        7oanJVIpnAiqRl8ipBymxEWg/A==
X-Google-Smtp-Source: ABdhPJxEz1JkRp53mKPztoB6DzeekHTJMXWYD+sHV3ZOI9HIKs5QTnLbIEkbdwUgKvpsxVyRUAjvZg==
X-Received: by 2002:aa7:c341:: with SMTP id j1mr22010074edr.197.1595854975588;
        Mon, 27 Jul 2020 06:02:55 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h27sm7055362eje.23.2020.07.27.06.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 06:02:55 -0700 (PDT)
Date:   Mon, 27 Jul 2020 15:02:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v4 2/6] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200727130253.GK2216@nanopsycho>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-3-vadym.kochan@plvision.eu>
 <20200727123205.GJ2216@nanopsycho>
 <20200727123553.GC21360@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727123553.GC21360@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 27, 2020 at 02:35:53PM CEST, vadym.kochan@plvision.eu wrote:
>Hi Jiri,
>
>On Mon, Jul 27, 2020 at 02:32:05PM +0200, Jiri Pirko wrote:
>> Mon, Jul 27, 2020 at 02:22:38PM CEST, vadym.kochan@plvision.eu wrote:
>> >Add PCI interface driver for Prestera Switch ASICs family devices, which
>> >provides:
>> >
>> >    - Firmware loading mechanism
>> >    - Requests & events handling to/from the firmware
>> >    - Access to the firmware on the bus level
>> >
>> >The firmware has to be loaded each time the device is reset. The driver
>> >is loading it from:
>> >
>> >    /lib/firmware/marvell/prestera_fw-v{MAJOR}.{MINOR}.img
>> >
>> >The full firmware image version is located within the internal header
>> >and consists of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has
>> >hard-coded minimum supported firmware version which it can work with:
>> >
>> >    MAJOR - reflects the support on ABI level between driver and loaded
>> >            firmware, this number should be the same for driver and loaded
>> >            firmware.
>> >
>> >    MINOR - this is the minimum supported version between driver and the
>> >            firmware.
>> >
>> >    PATCH - indicates only fixes, firmware ABI is not changed.
>> >
>> >Firmware image file name contains only MAJOR and MINOR numbers to make
>> >driver be compatible with any PATCH version.
>> >
>> >Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
>> >Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
>> >Acked-by: Jiri Pirko <jiri@mellanox.com>
>> 
>> You have to remove the tag if you change the patch from last tagged
>> version...
>> 
>OK, sorry, makes sense, should I re-spin with v5 or wait when the status
>is changed to 'Changes Requested' in the patchwork ?

Np. I will review this patch again.

>
>> 
>> >---
>> >PATCH v4:
>> >    1) Get rid of "packed" attribute for the fw image header, it is
>> >       already aligned.
>> >
>> >    2) Cleanup not needed initialization of variables which are used in
>> >       readl_poll_timeout() helpers.
>> >
>> >    3) Replace #define's of prestera_{fw,ldr}_{read,write} to static funcs.
>> >
>> >    4) Use pcim_ helpers for resource allocation
>> >
>> >    5) Use devm_zalloc() for struct prestera_fw instance allocation.
>> >
>> >    6) Use module_pci_driver(prestera_pci_driver) instead of module_{init,exit}.
>> >
>> >    7) Use _MS prefix for timeout #define's.
>> >
>> >    8) Use snprintf for firmware image path generation instead of using
>> >       macrosses.
>> >
>> >    9) Use memcpy_xxxio helpers for IO memory copying.
>> >
>> >   10) By default use same build type ('m' or 'y') for
>> >       CONFIG_PRESTERA_PCI which is used by CONFIG_PRESTERA.
>> >
>> 
>> [...]
