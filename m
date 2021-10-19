Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11861433B67
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhJSQAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:00:03 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:48339 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbhJSQAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 12:00:03 -0400
Received: (Authenticated sender: thomas.petazzoni@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 655E7240006;
        Tue, 19 Oct 2021 15:57:47 +0000 (UTC)
Date:   Tue, 19 Oct 2021 17:57:46 +0200
From:   Thomas Petazzoni <thomas.petazzoni@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: Re: [PATCH] net: renesas: Fix rgmii-id delays
Message-ID: <20211019175746.11b388ce@windsurf>
In-Reply-To: <YW7nPfzjstmeoMbf@lunn.ch>
References: <20211019145719.122751-1-kory.maincent@bootlin.com>
        <CAMuHMdWghZ7HM5RRFRsZu8P_ikna0QWoRfCKeym61N-Lv-v4Xw@mail.gmail.com>
        <20211019173520.0154a8cb@kmaincent-XPS-13-7390>
        <YW7nPfzjstmeoMbf@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 17:41:49 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > When people update the kernel version don't they update also the devicetree?  
> 
> DT is ABI. Driver writers should not break old blobs running on new
> kernels. Often the DT blob is updated with the kernel, but it is not
> required. It could be stored in a hard to reach place, shared with
> u-boot etc.

Right, but conversely if someone reads the DT bindings that exists
today, specifies phy-mode = "rgmii-rxid" or phy-mmode = "rmgii-txid",
this person will get incorrect behavior. Sure a behavior that is
backward compatible with older DTs, but a terribly wrong one when you
write a new DT and read the DT binding documentation. This is exactly
the problem that happened to us.

I know that those properties are considered obsolete, but even though
they are considered as such, they are still supported, but for this
particular MAC driver, with an inverted meaning compared to what the DT
binding documentation says.

What wins: DT ABI backward compatibility, or correctness of the DT
binding ? :-)

Best regards,

Thomas
-- 
Thomas Petazzoni, co-owner and CEO, Bootlin
Embedded Linux and Kernel engineering and training
https://bootlin.com
