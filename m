Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E4F605FA6
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 14:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJTMDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 08:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiJTMDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 08:03:40 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7091843D8;
        Thu, 20 Oct 2022 05:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666267368;
        bh=D+hEsIZ5MqHmy/cfeQgHzMHMoHuUmID1yqX63F16548=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Q54MWZ6IspGF/8DRWgMHHIJIFKtF3tD+rr3I5AVF5LbgcvaYEvX4BowHjP4rYPQBh
         sB99yt0XiUetkey1MrQzSPgZhhq+nVx1hoKad3Jl8PiPj2EvbGUGHGGt6aFhy43syh
         vfB4Uo9VfeMdLbXw2w74Pu/Xz21aOownn1KNWj44=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.146.75] ([217.61.146.75]) by web-mail.gmx.net
 (3c-app-gmx-bs65.server.lan [172.19.170.209]) (via HTTP); Thu, 20 Oct 2022
 14:02:48 +0200
MIME-Version: 1.0
Message-ID: <trinity-72a267fb-f4a0-4d9d-9a1b-f6a1ce3a43ec-1666267368826@3c-app-gmx-bs65>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <linux@fw-web.de>,
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
Subject: Aw: Re: [PATCH] net: mtk_sgmii: implement mtk_pcs_ops
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 20 Oct 2022 14:02:48 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <Y1EHy0t5nXOF/3Mw@shell.armlinux.org.uk>
References: <20221018153506.60944-1-linux@fw-web.de>
 <Y07Wpd1A1xxLhIVc@shell.armlinux.org.uk>
 <949F5EE5-B22D-40E2-9783-0F75ACFE2C1F@public-files.de>
 <Y1EHy0t5nXOF/3Mw@shell.armlinux.org.uk>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:mNvPlxKiBmdiWAYpi/kJ+DODyjnMKBtEVLi/DReg3FWYbWdKOBqmfXkS53KdL3KT8Wc58
 3qPYbsjwEfQ8WieLv/R5DqfyAWUtUkJlFZVOntWOLj2HG/nLCuxieEg6wxeB8sB0ekyVUA0CsQ4+
 +10XX+CqhswsZjMw1jD0n/tc+s16+ssb1tCD+z1Nuowh14LuyQrrB8Bt3TPkGmLxXQFib5RSb3Rn
 GbGdVQj5PkpNvDPmMn4FRXS9SAcuW7UJ3saXQwKgeDOu983RqtiRm71sI8nehUuC+YrfjqvIq3lW
 9M=
X-UI-Out-Filterresults: notjunk:1;V03:K0:sIK5fFpPQVw=:SCT0AitDal3oCczr9xpbYt
 6w2bGprDyMNI5loZRPHhnzvhQ3CQAbyR9vn4lnt+O9cgroFMcDOAuss/dKyaGICMt6nYt+4MT
 tEJE62Otdq+eIT9ZoDlAPKH0m/pfKlj+peXIdYDZPSQUsVNAvufRloZ62sbFPtu0uQ4shT50l
 EQzVNyJMTmNBgCzYGPsD225Vnwvgt7DqW2h7Ggn5uRRVJ1ZvPlLqUuW3/mHeq/lYrJNuOW0lb
 Ek7n/GD+vyJNiuDaNSBGhCGdt8epSbIxPdkH9lj4F/LfctgtALR3peEsqtOVAAjzfSHRzrLi6
 wSgLGxEyf/ghv3n1v8T5eeFRhOsx6NyCn539u/tTFIDmzLI8akThvK3uGEd2Ox9MxTEE+YMbq
 Jt8C7eZdYhlCt+3Pf8Q8cQyB5B7IWxrnqOhjIlASJ2FWBIUL8KaaM0E8+94PFIwN5xjuVbyRj
 i+sfLZII1S9Gb9A6KDB+B49uNGXOYpqpL93mg4ICY0HCa4MYDZJWX9XcuskuWM9FccpbO26E4
 tNLfWznLEtES1ZFUx36EkH9RQ+nJNLfsw2Lt6yjzljir+4bw6qwRt/WhWOGsWuowStUyJtaco
 A8ciA1EknN9W8UIF37qiaSTIN0vPy8YfQ905MfBT3JnMTAP2D5WpuvKJrH+iKuE+9gK7xVVCd
 ctVYjo5+RR+mgquFdH9PlpvEFn8YjQea+qJiDOkzzx1hFI/vEyyQGFL1Qw8OkGLoRNy4/qB6s
 6nOD0DBOu9ZSgQi+y9fEKNnGnd23orwQPwCIFqK5xbzIPJKxBbP16/fAmTJXxHnYN7WeS/9dQ
 zOUw1jtYaB7R17sQTDlFMYUxE1JfTpf1CIqN9XUcXThlmwO65wvZ/ca2eRoWUPORimiBxoIJF
 SwuiGArVGzAisPoxXic2NnpGZ+cBpHPdxkgJyT48p3lRIPKHXGTQ6FaiBAXmiMS6JFdxhipG7
 hof94x/OV0tkUxj6wQiYcyJ4ac8o4U5W+AygX87voeeNgt7NBy6S2u7IXHyGbTeCOdcRenx+1
 mAAQZJGDY4BZ1+VqE4R8wybNfIH3uPTwVnUhNIn4fuQAEYDqQrZryFvz7JJLx0KmDD/n/b4kS
 1X4FaIvxjf8wozW2NQagad1Y3s8LA51MFZyID3NqYQeQR2oEVQ7VLn16fdy3ykckb2KEL0cuT
 Dl3G2tpgxxzFj+oudmG2YBaj4SsclHIRbPS9NZJu+yTPzzNy946316JIzxcYOTmxfTzXuX0CC
 8gYco+EqtjMsxKxCqgUlvFkVBkt+HzCtM6hM+yd7iB73yrDZCdRzSPXm3HlDcVtrZo66yEyWk
 cKYphK3I
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Gesendet: Donnerstag, 20. Oktober 2022 um 10:33 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> An: "Frank Wunderlich" <frank-w@public-files.de>
> Cc: "Frank Wunderlich" <linux@fw-web.de>, linux-mediatek@lists.infradead=
.org, "Alexander Couzens" <lynxis@fe80.eu>, "Felix Fietkau" <nbd@nbd.name>=
, "John Crispin" <john@phrozen.org>, "Sean Wang" <sean.wang@mediatek.com>,=
 "Mark Lee" <Mark-MC.Lee@mediatek.com>, "David S. Miller" <davem@davemloft=
.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel=
.org>, "Paolo Abeni" <pabeni@redhat.com>, "Matthias Brugger" <matthias.bgg=
@gmail.com>, netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,=
 linux-kernel@vger.kernel.org
> Betreff: Re: [PATCH] net: mtk_sgmii: implement mtk_pcs_ops
>
> On Thu, Oct 20, 2022 at 07:54:49AM +0200, Frank Wunderlich wrote:
> > Am 18. Oktober 2022 18:39:01 MESZ schrieb "Russell King (Oracle)" <lin=
ux@armlinux.org.uk>:
> > >Hi,
> > >
> > >A couple of points:
> > >
> > >On Tue, Oct 18, 2022 at 05:35:06PM +0200, Frank Wunderlich wrote:
> >
> > >> +	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
> > >> +	state->an_complete =3D !!(val & SGMII_AN_COMPLETE);
> > >> +	state->link =3D !!(val & SGMII_LINK_STATYS);
> > >> +	state->pause =3D 0;
> > >
> > >Finally, something approaching a reasonable implementation for this!
> > >Two points however:
> > >1) There's no need to set state->pause if there is no way to get that
> > >   state.
> > >2) There should also be a setting for state->pause.
> >
> > Currently it looks like pause cannot be controlled in sgmii-mode so we=
 disabled it here to not leave it undefined. Should i drop assignment here=
?
>
> Why do you think it would be undefined?
>
> static void phylink_mac_pcs_get_state(struct phylink *pl,
>                                       struct phylink_link_state *state)
> {
> ...
>         if  (state->an_enabled) {
> ...
>                 state->pause =3D MLO_PAUSE_NONE;
>         } else {
> ,,,
>                 state->pause =3D pl->link_config.pause;
> 	}
> ...
>         if (pl->pcs)
>                 pl->pcs->ops->pcs_get_state(pl->pcs, state);
>
> So, phylink will call your pcs_get_state() function having initialised
> it to something sensible.

ok, then i drop the pause setting for now

regards Frank
