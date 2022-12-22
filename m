Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2710654395
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 16:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235898AbiLVPEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 10:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235811AbiLVPDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 10:03:48 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1E32CC99;
        Thu, 22 Dec 2022 07:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671721374; x=1703257374;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=BemLfJGRQcaAB/OnhUXouvv/1MERj6C4v/FiqDQcucs=;
  b=qhA2Xp89w6j4QioYt+0s4p06/6C6NWqMXKCZAWe/nI7FrUWTURLVR4WV
   UaBwUgkMUQD0xqgzw20y2OQR6+BphUJy8cAS2tMhSO7LBx5VLFxe4OJE7
   KGGVrDlX8rTjEazsfvWT7j+d9e1j+8G4vUMpnmJb03x4zLYBZtX4dcitw
   Z8oyERT2Q4KlguYR9fVCEHY/dKFAeZs+5V8q94OnKXhdVuNYAdeqlIg8C
   8rwHWymiPoOz8RBe0in6XWCZ8Vlew4CB1B1R/rF4k5KnjCmLZxX+j3yoI
   r22Ghz79g11NX9AETexe9RLpGfNAbSFkNGKK4he/tMVYzgN5xd0nRgKS8
   w==;
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="189343420"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Dec 2022 08:02:52 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 22 Dec 2022 08:02:51 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 22 Dec 2022 08:02:48 -0700
Message-ID: <cc41ccf443b1f2c7a4cb5e247dabfa53a6674226.camel@microchip.com>
Subject: Re: [PATCH net 0/8] Add support for two classes of VCAP rules
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>
Date:   Thu, 22 Dec 2022 16:02:47 +0100
In-Reply-To: <0efd4a7072fb90cc9bc9992b00d9ade233a38de1.camel@redhat.com>
References: <20221221132517.2699698-1-steen.hegelund@microchip.com>
         <0efd4a7072fb90cc9bc9992b00d9ade233a38de1.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On Thu, 2022-12-22 at 15:22 +0100, Paolo Abeni wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> Hello,
> On Wed, 2022-12-21 at 14:25 +0100, Steen Hegelund wrote:
> > This adds support for two classes of VCAP rules:
> >=20
> > - Permanent rules (added e.g. for PTP support)
> > - TC user rules (added by the TC userspace tool)
> >=20
> > For this to work the VCAP Loopups must be enabled from boot, so that th=
e
> > "internal" clients like PTP can add rules that are always active.
> >=20
> > When the TC tool add a flower filter the VCAP rule corresponding to thi=
s
> > filter will be disabled (kept in memory) until a TC matchall filter cre=
ates
> > a link from chain 0 to the chain (lookup) where the flower filter was
> > added.
> >=20
> > When the flower filter is enabled it will be written to the appropriate
> > VCAP lookup and become active in HW.
> >=20
> > Likewise the flower filter will be disabled if there is no link from ch=
ain
> > 0 to the chain of the filter (lookup), and when that happens the
> > corresponding VCAP rule will be read from the VCAP instance and stored =
in
> > memory until it is deleted or enabled again.
>=20
> Despite the 'net' target, this looks really like net-next material as
> most patches look like large refactor. I see there are a bunch of fixes
> in patches 3-8, but quite frankly it's not obvious at all what the
> refactors/new features described into the commit messages themself
> really fix.

Yes the patches 3-8 is the response to Michael Walles observations on LAN96=
6x
and Jakubs Kicinski comment (see link), but the description in the commits =
may
not be that clear, in the sense that they do not state one-to-one what the
mitigation is.

See https://lore.kernel.org/netdev/20221209150332.79a921fd@kernel.org/

So essentially this makes it possible to have rules that are always in the =
VCAP
HW (to make the PTP feature work), even before the TC chains have been
established (which was the problem that Michael encountered).

I still think this a net submission, since it fixes the problem that was
observed in the previous netnext window.

But I will rephrase the reasoning in a V2 to hopefully make that more
understandable.

If you still think it is better to post this in the upcoming net-next windo=
w, I
am also OK with that.

>=20
> I suggest to move this series to net-next (and thus repost after Jan
> 2), unless you come-up with some good reasons to keep it in net.
>=20
> Thanks,
>=20
> Paolo
>=20

BR
Steen
