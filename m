Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2531869260C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbjBJTFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbjBJTFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:05:00 -0500
Received: from smtp-out-07.comm2000.it (smtp-out-07.comm2000.it [212.97.32.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B83D7D885;
        Fri, 10 Feb 2023 11:04:39 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-07.comm2000.it (Postfix) with ESMTPSA id E6A623C90D9;
        Fri, 10 Feb 2023 20:04:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1676055877;
        bh=1MDK5XVzuRboLUULPNbkMtdO3ShFDxOiAcQb2GE0aO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=r0+Q0enEMtciMFlKwAsHSJz0C9ASbEnj2iQ1jNT0w5pHY4nAFIFzaarQsbj2PZo8j
         3lMbt4Dyh0NQBDmm3tDZbsfO5CJZoM0iF21ZIDw7Og8MIp5v+ZmYvexrzH/AuNTUPa
         krHbMjF7Dcc3EVupy+3ewC8ntMZjG6S5zg+parP3OiHKfN6liYCFGZCjNhcgWJJBCy
         jp5nD0d8f0VnCAsUXeP+KlT/R9PPtvwnnZBE+npJv4I9Lq+9gS8m8WTcwpp66ruMII
         S6NWm/7Wi3LHcGfnsqv4Ljj4RzYnGFTBLEl3VUAXyOAunFMuLoCKYuEomtL5SHW/jg
         yWzK6R2p2ZtNQ==
Date:   Fri, 10 Feb 2023 20:04:35 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v2 0/5] Bluetooth: hci_mrvl: Add serdev support for
 88W8997
Message-ID: <Y+aVQ38sJvuUd4HM@francesco-nb.int.toradex.com>
References: <20230126074356.431306-1-francesco@dolcini.it>
 <Y+YC3Pka42SmtyvI@francesco-nb.int.toradex.com>
 <CABBYNZLNFFUeZ1cb9xABhaymWnSiZjazwVT9N12qHyc7e0L6QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABBYNZLNFFUeZ1cb9xABhaymWnSiZjazwVT9N12qHyc7e0L6QQ@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 10:52:43AM -0800, Luiz Augusto von Dentz wrote:
> Hi Francesco,
> 
> On Fri, Feb 10, 2023 at 12:40 AM Francesco Dolcini <francesco@dolcini.it> wrote:
> >
> > Hello all,
> >
> > On Thu, Jan 26, 2023 at 08:43:51AM +0100, Francesco Dolcini wrote:
> > > From: Francesco Dolcini <francesco.dolcini@toradex.com>
> > >
> > > Add serdev support for the 88W8997 from NXP (previously Marvell). It includes
> > > support for changing the baud rate. The command to change the baud rate is
> > > taken from the user manual UM11483 Rev. 9 in section 7 (Bring-up of Bluetooth
> > > interfaces) from NXP.
> >
> > Just a gently ping on this series, patches 1,2 with DT binding changes
> > are reviewed/acked, patch 5 with the DTS change should just be on hold
> > till patches 1-4 are merged.
> >
> > No feedback on patches 4 (and 3), with the BT serdev driver code
> > changes, any plan on those?
> 
> bots have detected errors on these changes

From what I can understand from this point of view v2 is fine, the error
was in v1, if I'm wrong just let me know.

Said that I'll do the change you asked regarding __hci_cmd_sync_status
and send a v3.

Thanks,
Francesco

