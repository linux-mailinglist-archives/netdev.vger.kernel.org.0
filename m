Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8AB6AD9E2
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjCGJJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjCGJJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:09:11 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C34B521F0;
        Tue,  7 Mar 2023 01:09:08 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 72E5C2000F;
        Tue,  7 Mar 2023 09:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678180147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tfEXGeK3r8IepmXyCN3O+CQO+OTuTekK6f/XtQOU0sY=;
        b=iZIt8MiYGDIUgrVnCV8xsRaDE3ZRy7LdSAcAV6CCOHg9qdeqsK9lcjZxfcwCmmkW3962b+
        yzXAdLF7nyjmSUb9Km2tckxMuVg9nWeYS5sN5wpeKD10NHQ9dSuDS5VDvLfiJizNtvzZpS
        L3HyqEdNVYXwlRMnrQ1dtPUuOY7i+btjcPPNn72c8JAcuU0SaHzbtCdwS8WHqEByv/gy2I
        mervmjXY+o4cfJ3P2DRetAbQmfLqMXjXpKv9VsSo6+WZncLGdXzTZG9TY0erSy3VkIt9h+
        bB3sIpaB4nUx3peEyvlrTYVL+0+Jm7tSQPvt+Nb36EhpVUcjHo0wdLf+C0nyaQ==
Date:   Tue, 7 Mar 2023 10:09:03 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Denis Kirjanov <dkirjanov@suse.de>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ieee802154: fix a null pointer in
 nl802154_trigger_scan
Message-ID: <20230307100903.71e2d9b2@xps-13>
In-Reply-To: <782a6f2d-84ae-3530-7e3c-07f31a4f303b@suse.de>
References: <20230307073004.74224-1-dzm91@hust.edu.cn>
        <782a6f2d-84ae-3530-7e3c-07f31a4f303b@suse.de>
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

Hello,

dkirjanov@suse.de wrote on Tue, 7 Mar 2023 11:43:46 +0300:

> On 3/7/23 10:30, Dongliang Mu wrote:
> > There is a null pointer dereference if NL802154_ATTR_SCAN_TYPE is
> > not set by the user.
> >=20
> > Fix this by adding a null pointer check.

Thanks for the patch! This has been fixed already:
https://lore.kernel.org/linux-wpan/20230301154450.547716-1-miquel.raynal@bo=
otlin.com/T/#u

> > Reported-and-tested-by: syzbot+bd85b31816913a32e473@syzkaller.appspotma=
il.com

Just for reference, this tag shall not be used:

	"Please do not use combined tags, e.g.
	``Reported-and-tested-by``"
	Documentation/process/maintainer-tip.rst

> > Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn> =20
>=20
> Please add a Fixes: tag=20
>=20
> > ---
> >  net/ieee802154/nl802154.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> > index 2215f576ee37..1cf00cffd63f 100644
> > --- a/net/ieee802154/nl802154.c
> > +++ b/net/ieee802154/nl802154.c
> > @@ -1412,7 +1412,8 @@ static int nl802154_trigger_scan(struct sk_buff *=
skb, struct genl_info *info)
> >  		return -EOPNOTSUPP;
> >  	}
> > =20
> > -	if (!nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
> > +	if (!info->attrs[NL802154_ATTR_SCAN_TYPE] ||
> > +	    !nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
> >  		NL_SET_ERR_MSG(info->extack, "Malformed request, missing scan type");
> >  		return -EINVAL;
> >  	} =20


Thanks,
Miqu=C3=A8l
