Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DE966C2FB
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 15:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbjAPO5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 09:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbjAPO4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 09:56:44 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1D8252A2;
        Mon, 16 Jan 2023 06:46:17 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GEjVgq2096589
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 14:45:32 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GEjO301941354
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 15:45:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673880326; bh=mx+q3yLiLRos9hCCmecWMw+O0wMnKRMkoi7oBC1P2yw=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=l1FEWKcFwozAXZT92eOk4DYK9J5PCDmXUQrfN+v/KWtvYc2fpizFf5QuySWUej9vH
         gtapsUguFpTOxxoGcK918w1E9C0f+tX/TELSuLMxT1uGkro6wLbp60oGBBdhkA41yz
         ABGYMJ8pa1LLF/WVx79N1VB0rbgWi11X6tb1CLZ4=
Received: (nullmailer pid 375753 invoked by uid 1000);
        Mon, 16 Jan 2023 14:45:24 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Organization: m
References: <trinity-1d4cc306-d1a4-4ccf-b853-d315553515ce-1666543305596@3c-app-gmx-bs01>
        <Y1V/asUompZKj0ct@shell.armlinux.org.uk>
        <trinity-ac9a840b-cb06-4710-827a-4c4423686074-1666551838763@3c-app-gmx-bs01>
        <trinity-169e3c3f-3a64-485c-9a43-b7cc595531a9-1666552897046@3c-app-gmx-bs01>
        <Y1Wfc+M/zVdw9Di3@shell.armlinux.org.uk>
        <Y1Zah4+hyFk50JC6@shell.armlinux.org.uk>
        <trinity-d2f74581-c020-4473-a5f4-0fc591233293-1666622740261@3c-app-gmx-bap55>
        <Y1ansgmD69AcITWx@shell.armlinux.org.uk>
        <trinity-defa4f3d-804e-401e-bea1-b36246cbc11b-1666685003285@3c-app-gmx-bap29>
        <87o7qy39v5.fsf@miraculix.mork.no>
        <Y8VVa0zHk0nCwS1w@shell.armlinux.org.uk>
Date:   Mon, 16 Jan 2023 15:45:24 +0100
In-Reply-To: <Y8VVa0zHk0nCwS1w@shell.armlinux.org.uk> (Russell King's message
        of "Mon, 16 Jan 2023 13:47:23 +0000")
Message-ID: <87h6wq35dn.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Russell King (Oracle)" <linux@armlinux.org.uk> writes:
> On Mon, Jan 16, 2023 at 02:08:30PM +0100, Bj=C3=B8rn Mork wrote:
>> Frank Wunderlich <frank-w@public-files.de> writes:
>>=20
>> > apart from this little problem it works much better than it actually i=
s so imho more
>> > people should test it on different platforms.
>>=20
>> Hello!  I've been banging my head against an MT7986 board with two
>> Maxlinear GPY211C phys for a while. One of those phys is connected to
>> port 5 of the MT7531 switch.  This is working perfectly.
>>=20
>> The other GPY211C is connected to the second MT7986 mac.  This one is
>> giving me a headache...
>>=20
>> I can only get the port to work at 2500Mb/s.  Changing the speed to
>> anything lower looks fine in ethtool etc, but traffic is blocked.
>
> My guess would be that the GPY PHY is using in-band SGMII negotiation
> (it sets VSPEC1_SGMII_ANEN_ANRS when entering SGMII mode and clears
> it in 2500base-X), but as the link is not using in-band mode on the
> PCS side, the PHY never sees its in-band negotiation complete, so the
> link between PCS and PHY never comes up.
>
> Both sides need to agree on that detail.

Any hints on how I would go about doing that?  I am a little lost here,
changing arbitrary bits I don't understand the meaning of.


Bj=C3=B8rn
