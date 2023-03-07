Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8556ADA6F
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjCGJeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCGJeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:34:11 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8525E27D7D;
        Tue,  7 Mar 2023 01:34:09 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 944C91C0009;
        Tue,  7 Mar 2023 09:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678181647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDE5jIWAYfQpCOINixYsq1hsvXLaCt7Nc3SPYJnvYDc=;
        b=nTW0QOTEaiFyfQ+e9Nx28gaIWZ1wGjwgKrjLCabaFFdcMGCghCGvpNYEEVc+DuE+AwYaPR
        xzXNXvK3rf5NY3Orai7vDoSJOOk0Xzg69su+39pk/fQBUfJug4qYjod2sW3jWVtnip4q2n
        q2dLsEtnVOm2yGkfal1Bcas50L/oXVbpoqZ1MGNYmX29YXuPTe/HqZvnUttDNXbfXEqJSZ
        do8+7oVlIWq/XjQAFFh2xXzFRmMTa1QG9TI8qK9DN9y1DhL1Sp9zZDKOeOft/UECb4FqoT
        6x9egD+HXjVTO5PeH6P4JFt0lwHViomHVNgHGAE9DvZXhkQdOPovP+Now53MEg==
Date:   Tue, 7 Mar 2023 10:34:02 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     =?UTF-8?B?5oWV5Yas5Lqu?= <dzm91@hust.edu.cn>
Cc:     "denis kirjanov" <dkirjanov@suse.de>,
        "alexander aring" <alex.aring@gmail.com>,
        "stefan schmidt" <stefan@datenfreihafen.org>,
        "david s. miller" <davem@davemloft.net>,
        "eric dumazet" <edumazet@google.com>,
        "jakub kicinski" <kuba@kernel.org>,
        "paolo abeni" <pabeni@redhat.com>,
        syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ieee802154: fix a null pointer in
 nl802154_trigger_scan
Message-ID: <20230307103402.4c15d223@xps-13>
In-Reply-To: <2b209456.234a2.186bb608224.Coremail.dzm91@hust.edu.cn>
References: <20230307073004.74224-1-dzm91@hust.edu.cn>
        <782a6f2d-84ae-3530-7e3c-07f31a4f303b@suse.de>
        <20230307100903.71e2d9b2@xps-13>
        <2b209456.234a2.186bb608224.Coremail.dzm91@hust.edu.cn>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi =E6=85=95=E5=86=AC=E4=BA=AE,

dzm91@hust.edu.cn wrote on Tue, 7 Mar 2023 17:21:49 +0800 (GMT+08:00):

> > -----=E5=8E=9F=E5=A7=8B=E9=82=AE=E4=BB=B6-----
> > =E5=8F=91=E4=BB=B6=E4=BA=BA: "Miquel Raynal" <miquel.raynal@bootlin.com>
> > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2023-03-07 17:09:03 (=E6=98=9F=E6=
=9C=9F=E4=BA=8C)
> > =E6=94=B6=E4=BB=B6=E4=BA=BA: "Denis Kirjanov" <dkirjanov@suse.de>
> > =E6=8A=84=E9=80=81: "Dongliang Mu" <dzm91@hust.edu.cn>, "Alexander Arin=
g" <alex.aring@gmail.com>, "Stefan Schmidt" <stefan@datenfreihafen.org>, "D=
avid
> >  S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>=
, "Jakub
> >  Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, syzbot=
+bd85b31816913a32e473@syzkaller.appspotmail.com, linux-wpan@vger.kernel.org=
, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
> > =E4=B8=BB=E9=A2=98: Re: [PATCH] net: ieee802154: fix a null pointer in =
nl802154_trigger_scan
> >=20
> > Hello,
> >=20
> > dkirjanov@suse.de wrote on Tue, 7 Mar 2023 11:43:46 +0300:
> >  =20
> > > On 3/7/23 10:30, Dongliang Mu wrote: =20
> > > > There is a null pointer dereference if NL802154_ATTR_SCAN_TYPE is
> > > > not set by the user.
> > > >=20
> > > > Fix this by adding a null pointer check. =20
> >=20
> > Thanks for the patch! This has been fixed already:
> > https://lore.kernel.org/linux-wpan/20230301154450.547716-1-miquel.rayna=
l@bootlin.com/T/#u =20
>=20
> Oh, I see. Thanks for your reply.
>=20
> A small issue: should we still check !nla_get_u8(info->attrs[NL802154_ATT=
R_SCAN_TYPE])?

Isn't it already handled? There is a switch case over it with a default
statement to handle unsupported scan types.

> > > > Reported-and-tested-by: syzbot+bd85b31816913a32e473@syzkaller.appsp=
otmail.com =20
> >=20
> > Just for reference, this tag shall not be used:
> >=20
> > 	"Please do not use combined tags, e.g.
> > 	``Reported-and-tested-by``"
> > 	Documentation/process/maintainer-tip.rst
> >  =20
>=20
> Okay. This is suggested by Syzbot. I will use separate tags in the future.
>=20
> > > > Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>   =20
> > >=20
> > > Please add a Fixes: tag=20
> > >  =20
> > > > ---
> > > >  net/ieee802154/nl802154.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >=20
> > > > diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> > > > index 2215f576ee37..1cf00cffd63f 100644
> > > > --- a/net/ieee802154/nl802154.c
> > > > +++ b/net/ieee802154/nl802154.c
> > > > @@ -1412,7 +1412,8 @@ static int nl802154_trigger_scan(struct sk_bu=
ff *skb, struct genl_info *info)
> > > >  		return -EOPNOTSUPP;
> > > >  	}
> > > > =20
> > > > -	if (!nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
> > > > +	if (!info->attrs[NL802154_ATTR_SCAN_TYPE] ||
> > > > +	    !nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
> > > >  		NL_SET_ERR_MSG(info->extack, "Malformed request, missing scan ty=
pe");
> > > >  		return -EINVAL;
> > > >  	}   =20
> >=20
> >=20
> > Thanks,
> > Miqu=C3=A8l =20
>=20
>=20
> --
> Best regards,
> Dongliang Mu


Thanks,
Miqu=C3=A8l
