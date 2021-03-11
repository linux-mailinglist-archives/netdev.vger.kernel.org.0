Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEEB336AC5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 04:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhCKDff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 22:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhCKDfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 22:35:05 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8F6C061574;
        Wed, 10 Mar 2021 19:34:54 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id o11so20458343iob.1;
        Wed, 10 Mar 2021 19:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q3VYOKPLK02wgZWHswLew0WYlzNBXfD24og6vidOw2M=;
        b=fiqFsmN51ODtfC6BXdCcCJY3bzDL/GDBMkcujMQ7rsJseC3Hi44Pevit56gdgUCmxO
         rucShBW3uEy8BZbQvEEMiPrKiz7egAguc2jr0UX4FX3e+kiAkR1v035L3oO80NxDFAYG
         dIgKFgGlOuYEl65nYClh7uPi1DyNzGsdkpfzep/zUZEmLeAzX3oKHGQfPexPbp6Mnfo6
         MIySTlJWiGx0megFNySpxfDECEt58y0tY+AbG7A0ue837CqxI075mO8dkqp51Fwphgq7
         RTjXq/exaY/0YSe6dTq1jmOTA5dw335Qo+Woj2yg8zeQiNQwC/2w/P7GO2DLEaYVTKmc
         0yFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q3VYOKPLK02wgZWHswLew0WYlzNBXfD24og6vidOw2M=;
        b=Kf/cZRE6J+doDvtPUkXhWlB3zuC2R8HnC+Llwr6CQ2gwVet6EU9eGqNf4x3rT/QdhW
         9eEUhZMZkWZXifA/jv+5lG8QnTWCyeMvba5yPEvA+A+iickQRuRv7N1PESbJZSWn1bOX
         N7YdbxLv47Qc6wgHIU3ZyTNos7FEYCP+8cBmUw1vuhYElMKFIVYDNn7QSXy/rKl3UXps
         ishoGj8uRVvBvAQIW7QcsRgynfVw/iikCBZEdS9iqMm6CkAmOZ7ozX8c8kxFZs1/Xs7+
         mzlSLF1qX8gBD0maWHPAl0WyM0Lq1aB0AhTohoyepNzAHzxsgOJ+jkSyYSV6+eeTxYPA
         JbRw==
X-Gm-Message-State: AOAM531gn2SBDky39DlKUik6nNMt2qcG2dXVrUyjXPLrtk0Zufgpez9/
        n/Y2FEoBdfAySp71543qdJ+85eTgrvFHlJ0YPNA=
X-Google-Smtp-Source: ABdhPJxGDvfOGhh8O/le4UU6rChPhKFoz7CbvicMWCgnlHqdRMsOjAwOQYA3caLKxpVMyVEnpObGLVshcCNy4h1wIwI=
X-Received: by 2002:a02:817:: with SMTP id 23mr1641989jac.23.1615433694363;
 Wed, 10 Mar 2021 19:34:54 -0800 (PST)
MIME-Version: 1.0
References: <20210310211420.649985-1-ilya.lipnitskiy@gmail.com>
 <20210310211420.649985-3-ilya.lipnitskiy@gmail.com> <20210310231026.lhxakeldngkr7prm@skbuf>
 <CALCv0x0FKVKpVtKsxkq5BwzrSP2SnuYUaK38RHjd_zgoBCpdeA@mail.gmail.com> <169c64ac-c200-fa5d-6563-3be5263d0b99@gmail.com>
In-Reply-To: <169c64ac-c200-fa5d-6563-3be5263d0b99@gmail.com>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Wed, 10 Mar 2021 19:34:43 -0800
Message-ID: <CALCv0x2HZJXrE7nXu9a+bf1hX5dpUGh1ehqsE_1SyYHFghpiDQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: dsa: mt7530: setup core clock even in TRGMII mode
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, Mar 10, 2021 at 7:20 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 3/10/2021 7:17 PM, Ilya Lipnitskiy wrote:
> > Hi Vladimir,
> >
> > On Wed, Mar 10, 2021 at 3:10 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >>
> >> Hello Ilya,
> >>
> >> On Wed, Mar 10, 2021 at 01:14:20PM -0800, Ilya Lipnitskiy wrote:
> >>> 3f9ef7785a9c ("MIPS: ralink: manage low reset lines") made it so mt7530
> >>> actually resets the switch on platforms such as mt7621 (where bit 2 is
> >>> the reset line for the switch). That exposed an issue where the switch
> >>> would not function properly in TRGMII mode after a reset.
> >>>
> >>> Reconfigure core clock in TRGMII mode to fix the issue.
> >>>
> >>> Also, disable both core and TRGMII Tx clocks prior to reconfiguring.
> >>> Previously, only the core clock was disabled, but not TRGMII Tx clock.
> >>>
> >>> Tested on Ubiquity ER-X (MT7621) with TRGMII mode enabled.
> >>>
> >>> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> >>> ---
> >>
> >> For the networking subsystem there are two git trees, "net" for bugfixes
> >> and "net-next" for new features, and we specify the target tree using
> >> git send-email --subject-prefix="PATCH net-next".
> >>
> >> I assume you would like the v5.12 kernel to actually be functional on
> >> the Ubiquiti ER-X switch, so I would recommend keeping this patch
> >> minimal and splitting it out from the current series, and targeting it
> >> towards the "net" tree, which will eventually get merged into one of the
> >> v5.12 rc's and then into the final version. The other patches won't go
> >> into v5.12 but into v5.13, hence the "next" name.
> > I thought I figured it out - now I'm confused. Can you explain why
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210311012108.7190-1-ilya.lipnitskiy@gmail.com/
> > is marked as supeseded?
>
> That looks like a mistake on the maintainer side, I do not believe that
> patch should be Superseded since you just submitted it.
Thanks for taking a look. I thought maybe I did something wrong with
submitting the same patch to net and net-next, but the net-next series
(https://patchwork.kernel.org/project/netdevbpf/patch/20210311020954.842341-1-ilya.lipnitskiy@gmail.com/)
depends on it, so the way I did it made the most sense for me. Let me
know if I did something wrong.
> --
> Florian
