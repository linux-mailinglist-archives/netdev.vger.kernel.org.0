Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE5566CA85
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbjAPRD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbjAPRDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:03:34 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C069E2FCE3;
        Mon, 16 Jan 2023 08:45:54 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GGjIot2102675
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 16:45:19 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GGjCAw2045407
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 17:45:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673887513; bh=Qcp8xlkY5pqGPztw1JirgSBLbAT2r9HBNw+DIb8btZc=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=ki3+2OVSuhhCJ6R/10JXtk8u3HQaA0qMl05kLjpiFig2pIgv2O/MxCozSVGWUldEi
         9Z+jR6FLLv94+NTJWW6NVWy2pLHD9rP+qXhu9iH4XVQSyBWCaQtgVEhjHaHTHq1dCt
         uysrckr110k4OSbFm188Xvrq7k/sur/AXiFw1/fs=
Received: (nullmailer pid 377826 invoked by uid 1000);
        Mon, 16 Jan 2023 16:45:12 -0000
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
References: <Y1Wfc+M/zVdw9Di3@shell.armlinux.org.uk>
        <Y1Zah4+hyFk50JC6@shell.armlinux.org.uk>
        <trinity-d2f74581-c020-4473-a5f4-0fc591233293-1666622740261@3c-app-gmx-bap55>
        <Y1ansgmD69AcITWx@shell.armlinux.org.uk>
        <trinity-defa4f3d-804e-401e-bea1-b36246cbc11b-1666685003285@3c-app-gmx-bap29>
        <87o7qy39v5.fsf@miraculix.mork.no>
        <Y8VVa0zHk0nCwS1w@shell.armlinux.org.uk>
        <87h6wq35dn.fsf@miraculix.mork.no>
        <Y8VmSrjHTlllaDy2@shell.armlinux.org.uk>
        <87bkmy33ph.fsf@miraculix.mork.no>
        <Y8Vt9vfEa4w8HXHQ@shell.armlinux.org.uk>
        <875yd630cu.fsf@miraculix.mork.no>
Date:   Mon, 16 Jan 2023 17:45:12 +0100
In-Reply-To: <875yd630cu.fsf@miraculix.mork.no> (=?utf-8?Q?=22Bj=C3=B8rn?=
 Mork"'s message of
        "Mon, 16 Jan 2023 17:33:53 +0100")
Message-ID: <871qnu2ztz.fsf@miraculix.mork.no>
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

Bj=C3=B8rn Mork <bjorn@mork.no> writes:

>> You have bmcr=3D0x1000, but the code sets two bits - SGMII_AN_RESTART and
>> SGMII_AN_ENABLE which are bits 9 and 12, so bmcr should be 0x1200, not
>> 0x1000. Any ideas why?
>
> No, not really

Doh! Looked over it again, and this was my fault of course.  Had an

  "bmcr =3D SGMII_AN_ENABLE;"
=20=20
line overwriting the original value from a previous attempt without
changing the if condition.. Thanks for spotting that.

But this still doesn't work any better:

[   43.019395] mtk_soc_eth 15100000.ethernet wan: Link is Down
[   45.099898] mtk_sgmii_select_pcs: id=3D1
[   45.103653] mtk_pcs_config: interface=3D4
[   45.107473] offset:0 0x140
[   45.107476] offset:4 0x4d544950
[   45.110181] offset:8 0x20
[   45.113305] forcing AN
[   45.118256] mtk_pcs_config: rgc3=3D0x0, advertise=3D0x1 (changed), link_=
timer=3D1600000,  sgm_mode=3D0x103, bmcr=3D0x1200, use_an=3D1
[   45.129191] mtk_pcs_link_up: interface=3D4
[   45.133100] offset:0 0x81140
[   45.133102] offset:4 0x4d544950
[   45.135967] offset:8 0x1
[   45.139104] mtk_soc_eth 15100000.ethernet wan: Link is Up - 1Gbps/Full -=
 flow control rx/tx



Bj=C3=B8rn
