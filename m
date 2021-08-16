Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675DD3EDF17
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhHPVLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231726AbhHPVLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:11:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3FE960F46;
        Mon, 16 Aug 2021 21:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629148279;
        bh=uU49V8oNTxUuUKJfCOPtOFSrBQEluIMcgIiHXrPZIC4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=u5L3iMHW1ePBo+HV4RwoBM38N1kPUPjOqvAEmoqel0uYhbR0myrufWe9z2LAyHJY4
         lb/5QJA3ijpQTAsr1t2m6LhkoZNuc+ZkoavBTrz/CmNJbMg1AVly/DMPSjQHWCc0zZ
         U9rzNLoLTxywz6+1ZHBL3tonDNccbofhtH7D6P9RqgLGFAY+IiufYAPhyv2HT5D9Lq
         kwrYsoEkfuYUg+9A1mZDIBWnmOyuapJ2s+7C2mwXYsQQDPiVQfgLkdbc1dq+rPxrhr
         XG1V9ZAKifG+au9CpMngXrILvNHiyLkoQFIkOEl6MJC0yYIZKGR1u+o5y3DlpQb56r
         pf4XJSHGgzOCg==
Received: by mail-ed1-f51.google.com with SMTP id dj8so20595677edb.2;
        Mon, 16 Aug 2021 14:11:18 -0700 (PDT)
X-Gm-Message-State: AOAM532j0uRL9fpWpy62X8IR+5Jx9FIDN2vsnLl18SHmsxDt6H3IibK5
        nvY3QCGk0Rj3JPvku//ADpV87qMZkvw+8YMWVA==
X-Google-Smtp-Source: ABdhPJzlYlKHsA2uwLLLmX6jSZmmgRu2N+aTYNGrBYIwqItA4EmqMVYZzbf2UyIiwA3stCGIrMCWEp7JGf1l82Z9PkA=
X-Received: by 2002:aa7:cb19:: with SMTP id s25mr161324edt.194.1629148277582;
 Mon, 16 Aug 2021 14:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210814023132.2729731-1-saravanak@google.com>
 <20210814023132.2729731-3-saravanak@google.com> <YRffzVgP2eBw7HRz@lunn.ch> <CAGETcx-ETuH_axMF41PzfmKmT-M7URiua332WvzzzXQHg=Hj0w@mail.gmail.com>
In-Reply-To: <CAGETcx-ETuH_axMF41PzfmKmT-M7URiua332WvzzzXQHg=Hj0w@mail.gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 16 Aug 2021 16:11:05 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJa_8sxdKit_UKHwkuOhK9L=SDYuRAD0vsY7pRE6sM3Qg@mail.gmail.com>
Message-ID: <CAL_JsqJa_8sxdKit_UKHwkuOhK9L=SDYuRAD0vsY7pRE6sM3Qg@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] of: property: fw_devlink: Add support for
 "phy-handle" property
To:     Saravana Kannan <saravanak@google.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Rowand <frowand.list@gmail.com>,
        Android Kernel Team <kernel-team@android.com>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 3:43 PM Saravana Kannan <saravanak@google.com> wrote:
>
> On Sat, Aug 14, 2021 at 8:22 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > Hi Saravana
> >
> > > Hi Andrew,
> > >
> >
> > > Also there
> > > are so many phy related properties that my head is spinning. Is there a
> > > "phy" property (which is different from "phys") that treated exactly as
> > > "phy-handle"?
> >
> > Sorry, i don't understand your question.
>
> Sorry. I was just saying I understand the "phy-handle" DT property
> (seems specific to ethernet PHY) and "phys" DT property (seems to be
> for generic PHYs -- used mostly by display and USB?). But I noticed
> there's yet another "phy" DT property which I'm not sure I understand.
> It seems to be used by display and ethernet and seems to be a
> deprecated property. If you can explain that DT property in the
> context of networking and how to interpret it as a human, that'd be
> nice.

For net devices, you can have 2 PHYs. 'phys' is the serdes phy and
'phy-handle' is the ethernet (typically) phy. On some chips, a serdes
phy can do PCS (ethernet), SATA, PCIe.

'phy' is deprecated, so ignore it. The one case for displays I see in
display/exynos/exynos_hdmi.txt should be deprecated as well.

There's also 'usb-phy' which should be deprecated.

Rob
