Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A27621D473
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgGMLEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgGMLEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:04:50 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E29C061755;
        Mon, 13 Jul 2020 04:04:49 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q17so5362204pls.9;
        Mon, 13 Jul 2020 04:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hSMlBgpefQn/5IJ0QNgfZUmGiBsaBmqcHOKu/c2Jtek=;
        b=S5gJpXnDOHLnveGaXQG5oUz+dfYuYFgP4j5WHzrqDnTEV8nD64pDRyBUyDnjZStJ0P
         o4BzZvlyGJ7cO//Onmb5sE0kpRHSK4YG0/tOm3xEOvG6f1LuIZAiaml3Tlwoj/8JsKBx
         ME7Xs0YTCDn7n/+WG9qRKcsuxm8L92jMyqL8RkRyoWYDv5ozripXmkQK8dHBNcZPPU/B
         dSUyAiCT08WQYXNjoYRNIscDgou/T4YKzXdYMq/BpfuBp0NeAtRre9NLmHmnBNLJLNDo
         RwDU9uTMbI+kSG2YTVDn3BT+MLR9B0DlMcBB8csCvIln4y4NaNQcMrAVSXVgQP1/nuB+
         YUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hSMlBgpefQn/5IJ0QNgfZUmGiBsaBmqcHOKu/c2Jtek=;
        b=qJ9cKpifU24DX2YGxt7Oc1coQ5Ba+1fXOf9TuKzo4YUymt98t3WZ/f+EsloriELk/C
         7ol0tXyOe0ezVY+DWSiNJdsHVet3DIDGXmy6zcTUgXBiGPjiipebUJDbJAOdCJkYAyGp
         YC3C6DzhKL5lfGOhJSTjlERtu/LSxX11+NFZla132FTHjFI+oR4YA7JBeHbg/HwNUPQl
         Xcc6+iLMTE9kQreAX0lb8O1lr8jCjZcKWeGCvnBc0xMy1GjKQqIo8x8MEzvhN31lrnkE
         VdLE3Stg67A0XvmC6enM75xH0Q1BYM3A//YC/D2pjnNB4OLw8BNl1stDOTZxUZW8Bp+n
         VWyw==
X-Gm-Message-State: AOAM533RqD4ac+5vI0QOn5g9peaNni+M0JFfX8LmZYgxd22ITngX+1WF
        3chLA5p6q05D0WT0lOW9P4b6GWV2nJ5Il6MQ0ho=
X-Google-Smtp-Source: ABdhPJyohLCtRqYdOM93T0P+SKcg6qAqmo8iHjm3j/tTRl+M5hGxOPYOdaBg+gj7Py9adhD9CIGRmPX0w+JyS9N7Zis=
X-Received: by 2002:a17:902:7288:: with SMTP id d8mr71388162pll.18.1594638289446;
 Mon, 13 Jul 2020 04:04:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
 <20200711065600.9448-5-calvin.johnson@oss.nxp.com> <931b7557-fefb-52c5-61dd-6ab13f7b5396@gmail.com>
 <20200713060416.GB2540@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20200713060416.GB2540@lsv03152.swis.in-blr01.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 13 Jul 2020 14:04:33 +0300
Message-ID: <CAHp75VdhhADSatLyBm+F+aV8J280LVjwCJZh7YzAPk8xW_vzXg@mail.gmail.com>
Subject: Re: [net-next PATCH v6 4/6] net: phy: introduce phy_find_by_mdio_handle()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 9:04 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
> On Sat, Jul 11, 2020 at 02:41:12PM -0700, Florian Fainelli wrote:
> > On 7/10/2020 11:55 PM, Calvin Johnson wrote:

...

> > > +   err = fwnode_property_read_u32(fwnode, "phy-channel", &addr);
> > > +   if (err)
> > > +           return ERR_PTR(err);
> > > +   if (addr < 0 || addr >= PHY_MAX_ADDR)
> >
> > Can an u32 ever be < 0?
>
> Will remove it.

Since it's harmless and we have a fix to shut the compiler up on this
kind of checks and Linus actually in favour of _seeing_ range checks
explicitly I think no need to drop, but it's up to you.


-- 
With Best Regards,
Andy Shevchenko
