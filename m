Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927072B186E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 10:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgKMJim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 04:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgKMJij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 04:38:39 -0500
Received: from confino.investici.org (confino.investici.org [IPv6:2a00:c38:11e:ffff::a020])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F58BC0613D6;
        Fri, 13 Nov 2020 01:38:38 -0800 (PST)
Received: from mx1.investici.org (unknown [127.0.0.1])
        by confino.investici.org (Postfix) with ESMTP id 4CXYLd6R7pz1132;
        Fri, 13 Nov 2020 09:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1605260313;
        bh=OAJ5KD0r/OiDibphGT3PLYWsOfovB3Nb036IIl60DlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+xYWWwQ9P8uwg66bDh8CY/ajVi/Sg48dLNwc8N9xrcJnOqbJtMbSi9AeQwmL85Ek
         /8zs+5KHV6duTGCgj89Pw72UzNW1yViQigjraxSkr3YYouQKyH0+1e4QK9pTkuzrKU
         evxR3j+6lzyKiubkcqqVPXfmx6CcksrUF/yxdQG8=
Received: from [212.103.72.250] (mx1.investici.org [212.103.72.250]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CXYLd5K1Bz112w;
        Fri, 13 Nov 2020 09:38:33 +0000 (UTC)
From:   Francis Laniel <laniel_francis@privacyrequired.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH v4 2/3] Modify return value of nla_strlcpy to match that of strscpy.
Date:   Fri, 13 Nov 2020 10:38:33 +0100
Message-ID: <3167137.UV11EXrnFd@machine>
In-Reply-To: <202010301217.7EF0009E83@keescook>
References: <20201030153647.4408-1-laniel_francis@privacyrequired.com> <20201030153647.4408-3-laniel_francis@privacyrequired.com> <202010301217.7EF0009E83@keescook>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le vendredi 30 octobre 2020, 20:25:38 CET Kees Cook a =E9crit :
> On Fri, Oct 30, 2020 at 04:36:46PM +0100, laniel_francis@privacyrequired.=
com=20
wrote:
> > diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> > index 2a76a2f5ed88..f9b053b30a7b 100644
> > --- a/net/sched/sch_api.c
> > +++ b/net/sched/sch_api.c
> > @@ -1170,7 +1170,7 @@ static struct Qdisc *qdisc_create(struct net_devi=
ce
> > *dev,>=20
> >  #ifdef CONFIG_MODULES
> > =20
> >  	if (ops =3D=3D NULL && kind !=3D NULL) {
> >  =09
> >  		char name[IFNAMSIZ];
> >=20
> > -		if (nla_strlcpy(name, kind, IFNAMSIZ) < IFNAMSIZ) {
> > +		if (nla_strlcpy(name, kind, IFNAMSIZ) > 0) {
> >=20
> >  			/* We dropped the RTNL semaphore in order to
> >  		=09
> >  			 * perform the module load.  So, even if we
> >  			 * succeeded in loading the module we have to
>=20
> Oops, I think this should be >=3D 0 ?

Good catch! I will modify this, rebase my patch on top of master, test it a=
=20
bit more than what I did for the v4 and push  v5!



