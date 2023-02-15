Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9160E6985BE
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 21:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjBOUlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 15:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBOUlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 15:41:14 -0500
Received: from smtp-out-12.comm2000.it (smtp-out-12.comm2000.it [212.97.32.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83411C2;
        Wed, 15 Feb 2023 12:41:10 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-12.comm2000.it (Postfix) with ESMTPSA id E958BBA23DF;
        Wed, 15 Feb 2023 21:41:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1676493667;
        bh=T/wW1BXFaoL18LTTv9PWoNYAoa7ftFqNWIodY0zZaNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=cXDNsUJ5DJSvq2DO855rsTs4YmNTnKmKg4m1D7Gi43muwlOu7xkHNoVEl4uIxJ6us
         emEu9mDfvViF9oU41HDEasHWoPEyuNuLN4o2aD5QU7+RQNRICV7L0AVcthQGMSyl4g
         OrqeZ3laKf9/RslPSZtJxSonCOTXLUatZt3xxGhtLR5XD43ohgOgRMpdr7mB6WEp5t
         iraOOncnVV5JumVx8T0EbloqgTrB6ll6PTZOdq22WvdNHaDnnFsVal5nI+GoiQwHBI
         A/5Eiq3BSnchUzXIHeI3AEtpICabEbjGzoa0Ut55a2Qn4gFsr2vC736VbBSF8Tm7jj
         dlibyhKSEV5Ag==
Date:   Wed, 15 Feb 2023 21:41:00 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Francesco Dolcini <francesco@dolcini.it>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-arm-kernel@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v3 0/5] Bluetooth: hci_mrvl: Add serdev support for
 88W8997
Message-ID: <Y+1DXHtznirsCyLI@francesco-nb.int.toradex.com>
References: <20230213120926.8166-1-francesco@dolcini.it>
 <CABBYNZ+y2jDi=0FFx31oB86skpDFTm5n+fDd5LBmvdxzOhqoSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABBYNZ+y2jDi=0FFx31oB86skpDFTm5n+fDd5LBmvdxzOhqoSA@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Luiz

On Wed, Feb 15, 2023 at 12:36:34PM -0800, Luiz Augusto von Dentz wrote:
> On Mon, Feb 13, 2023 at 4:09 AM Francesco Dolcini <francesco@dolcini.it> wrote:
> >
> > From: Francesco Dolcini <francesco.dolcini@toradex.com>
> >
> > Add serdev support for the 88W8997 from NXP (previously Marvell). It includes
> > support for changing the baud rate. The command to change the baud rate is
> > taken from the user manual UM11483 Rev. 9 in section 7 (Bring-up of Bluetooth
> > interfaces) from NXP.
> >
> > v3:
> >  - Use __hci_cmd_sync_status instead of __hci_cmd_sync
> >
> > v2:
> >  - Fix the subject as pointed out by Krzysztof. Thanks!
> >  - Fix indentation in marvell-bluetooth.yaml
> >  - Fix compiler warning for kernel builds without CONFIG_OF enabled
> >
> > Stefan Eichenberger (5):
> >   dt-bindings: bluetooth: marvell: add 88W8997
> >   dt-bindings: bluetooth: marvell: add max-speed property
> >   Bluetooth: hci_mrvl: use maybe_unused macro for device tree ids
> >   Bluetooth: hci_mrvl: Add serdev support for 88W8997
> >   arm64: dts: imx8mp-verdin: add 88W8997 serdev to uart4
> >
> >  .../bindings/net/marvell-bluetooth.yaml       | 20 ++++-
> >  .../dts/freescale/imx8mp-verdin-wifi.dtsi     |  5 ++
> >  drivers/bluetooth/hci_mrvl.c                  | 90 ++++++++++++++++---
> >  3 files changed, 104 insertions(+), 11 deletions(-)
> >
> > --
> > 2.25.1
> 
> There seems to be missing one patch 5/5:
> 
> https://patchwork.kernel.org/project/bluetooth/list/?series=721269
> 
> Other than that the Bluetooth parts seem fine, and perhaps can be
> merged if the patch above is not really required.

In v3 I decided to not send it to the BT mailing list, since this is
supposed to go through Shawn and the iMX/SOC tree.

Given that it would be great if you could apply patches 1-4.

Thanks,
Francesco


