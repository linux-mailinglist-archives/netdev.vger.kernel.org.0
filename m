Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0C56A8006
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 11:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCBKiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 05:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjCBKiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 05:38:00 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2008065AF
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 02:37:56 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BE248240003;
        Thu,  2 Mar 2023 10:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677753475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=RT8w/1WpUo5/rnQglCQFdyLexLq+tUoVxw4JfOD9Pqg=;
        b=WU37j1YIfWFxJSjjTe2axRHbmuCEPQow0Uj4sqkAyUnZAPsGtjkOqjHv72XBO8KCujOFu/
        8flcewz3PtgSkPNQA3rF6EckQYJchY9HxGuK+8+ZH2okY5X+alSNj4PkplNJ20pkXbMj6j
        aJtAOnOO+o+X3+h2mx/5r4Re5KcNaUVuVGzf8fftVJ0W5HTndRDAuGchvWnpGgsO/p/COA
        j076dJz9WZ1eql1cd+946ge3/RjbBysVR+Us/1hcOz/pHK4G7Jy637bWY7EVCk0qtCCtsp
        q6ymnTsdRMahAzOwGJNhEb2PI4szMiHQRc6HrRrwGSiaDNfOH2bvZHJZWR50MA==
Date:   Thu, 2 Mar 2023 11:37:52 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20230302113752.057a3213@kmaincent-XPS-13-7390>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
In-Reply-To: <20200729105807.GZ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

> I have the situation on a couple of devices where there are multiple
> places that can do PTP timestamping:
>=20
> - the PHY (slow to access, only event capture which may not be wired,
>    doesn't seem to synchronise well - delay of 58000, frequency changes
>    every second between +/-1500ppb.)
> - the Ethernet MAC (fast to access, supports event capture and trigger
>    generation which also may not be wired, synchronises well, delay of
>    700, frequency changes every second +/- 40ppb.)

Does this test have been made with the marvell 88E151x PHY?
On my side with a zynqMP SOM (cadence MACB MAC) the synchronization of the =
PHY
PTP clock is way better: +/-50ppb. Do you have an idea about the difference=
?=20
Which link partner were you using? stm32mp157 hardware PTP on my side.

On the thread mail we are talking about PTP rate scale but as we can see you
and I have really not the same synchronisation on this PHY PTP. How
could we set a PTP rate scale in the driver if on two different board the
result vary a lot? Although I don't understand why.

I have also differences with the PTP MAC but it is expected as it is not the
same MAC.

Regards,
K=C3=B6ry
