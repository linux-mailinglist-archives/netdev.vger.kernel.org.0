Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD211AEC32
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 13:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgDRLuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 07:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725887AbgDRLuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 07:50:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A208C061A0C;
        Sat, 18 Apr 2020 04:50:13 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a7so2009733pju.2;
        Sat, 18 Apr 2020 04:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t7x7mBwrdcLmRy6gPmeEMqwM6KZwtRU6wkHvtNG3wbI=;
        b=hmOH2DpHd1SfJlKqiFdUWs194K8KRA5mpQC4X9k8B65vQ4bXkkg+EdenNvq6sJlY5b
         Eiy+aGf0qRrlIvt2Z7HvQGTHRbvs2PnX0PDlZkabnjq9x5x1RREqo+KI0Tp73Hhq42/E
         S1KjcyrBl7bsakS5IMYNxIqmMYqtRPmP2H3j1SQvjKtgoKs8mxxrV9krT0wem4SYPQud
         eQfJWVMi5XN8f6dqiRTbMH9PL4w/xJqPjEWjFqK0PzYv3YC8xBafNeLkZ5lvNGXbfzsk
         TUuUgcO66eaGRpUawwnYisRZsjGNjNjj46b8mStEQ++T7faJjrgtuiSaEhY72j7mLC0j
         ueiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t7x7mBwrdcLmRy6gPmeEMqwM6KZwtRU6wkHvtNG3wbI=;
        b=FLT5h9r4Op4gduhit42QFXdfR1Qz8O+D9NsrQAdj8KWXBia4QBIh59RAjfDwEr9pd/
         YFIuqvJdFusIOVWmrB5x7UsGZFJuJBBTrZs4xqMa25xyKdBtuF7yapwRqvXRcZbuja7K
         dkX6m2EEaA7ORdJpClU1NmrtzuURv/IlXoqgbMQuMxbsbxKE6A+UJ3sFdGHQlcQA25tD
         Cgx97h8fbgGGARBNd5XEwKQ3irtfCpi45D2PizSuQ0M4sbPOAXzkFihmMmx4FqDRJOyu
         QpLKk8UUydloxvH0eTvrZp+Rmk8GEA6PexgnSQ3ke1Hti4xMzasFIuawinsCY4vY39uo
         hEzQ==
X-Gm-Message-State: AGi0PuaAfznX8ExMFQ1AA5XEeaSW5H3vRqiUWOpAvpZzskwjycP6Ajlh
        /MUCfExURjNfHevbMgH6a15EvlqIVWkLa6uBpKQ=
X-Google-Smtp-Source: APiQypJdq43iw4xUV6/QLxSn3B02VE0FPKDXOYpe5P9bsGiPVvtIa8M7lNnDiJjUc63A5Q3mWUbB2+Tuy2ri4POIkx8=
X-Received: by 2002:a17:902:9306:: with SMTP id bc6mr7866551plb.255.1587210612583;
 Sat, 18 Apr 2020 04:50:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200418105432.11233-1-calvin.johnson@oss.nxp.com>
 <20200418105432.11233-2-calvin.johnson@oss.nxp.com> <20200418114116.GU25745@shell.armlinux.org.uk>
In-Reply-To: <20200418114116.GU25745@shell.armlinux.org.uk>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 18 Apr 2020 14:50:01 +0300
Message-ID: <CAHp75VenEkAQ5OWtj90ij3KXTM4ZQg28Q9b_TCBwGnyC6YQKSg@mail.gmail.com>
Subject: Re: [RFC net-next PATCH v2 1/2] net/fsl: add ACPI support for mdio bus
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>, linux.cj@gmail.com,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Varun Sethi <V.Sethi@nxp.com>, Marcin Wojtas <mw@semihalf.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 2:41 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
> On Sat, Apr 18, 2020 at 04:24:31PM +0530, Calvin Johnson wrote:

> You seem to be duplicating the OF implementation in a private driver,
> converting it to fwnode.  This is not how we develop the Linux kernel.
> We fix subsystem problems by fixing the subsystems, not by throwing
> what should be subsystem code into private drivers.

I didn't dive into the details, but I feel same way.

-- 
With Best Regards,
Andy Shevchenko
