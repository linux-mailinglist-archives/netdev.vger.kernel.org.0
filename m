Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23FD5118E69
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfLJRAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:00:09 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38910 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727594AbfLJRAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:00:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575997208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3dB94LQUBJkMOJeSEOHdtsYk1BT0v5hAZCHPp4F9ZeI=;
        b=YK349DFvPZ76PNXIcY7ADPuRtWtO/TGUlTt4c6zVVDMPozUXGYf4kfukWDbPeRxKzi4ov/
        1KDyuWL755Ua+yCINrnJWacpsDBnzpmaC343vyusKLZYqr1XqbU/bI9CaiN6yIC5rAvbM9
        f/B4vTQvuaL8wTvWl+HcvS2iMb9ibJ0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-kHL1pVgjN1iYZ4U8ULyHcw-1; Tue, 10 Dec 2019 12:00:05 -0500
Received: by mail-wr1-f70.google.com with SMTP id z15so9248425wrw.0
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 09:00:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=npAFJ+C4mayaGTVlZU27tz3u2WVWbqw1gKmB7lx/bg4=;
        b=CgSA0BZxHsJeANJCwdiwF/CXWE2D6EO4u7/FD7rrApqN+03UhB4HDtXqDHxrYHZc/e
         BhcaYeWDemRc848L+Uo4wu9th60AyhbGBX3o805RpCh4iRiBWleDdEdrYCXoejA4VSaV
         WpKZkwuyL+C6GWGf7P+cnvf98qjmGw4KohlmVvQZGZX0Ci/Mkceyp5w90ZsNFlje8Dbh
         GEq0DwV1t/sgYt3IzLr7kgtBoC1pusePx0rkpdfkhM65G8KOtQas/SaM75FF23vowYZb
         WzRxEKyRTfF7aKEgAVY/Ke0WCfj20TcYBg9UYab2/fRrFzJlm14U59b/fNWSvZMRmgC5
         oBpw==
X-Gm-Message-State: APjAAAUaRZp847u+bG3lTSdXNJo7OoG9TQN81Ur2axwiNb5W0GPahmCr
        XYmH9aFEqDux4Ad+dx01gIX4rb7YpMUbO1wD1/uxSXPIbTa4Atg2CeBOouip43eMMqhGwE/wEO1
        UlmzXvYDBs8ZwrZcR
X-Received: by 2002:adf:b193:: with SMTP id q19mr4424748wra.78.1575997204039;
        Tue, 10 Dec 2019 09:00:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqycC+lzfTdcSHEMVrWGPPKGkvmih5Ijn8BOZukD9JpbZ9w0Ey4kS/ZfiV9LFmKarnUoVGTU7A==
X-Received: by 2002:adf:b193:: with SMTP id q19mr4424683wra.78.1575997203333;
        Tue, 10 Dec 2019 09:00:03 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id s15sm3977254wrp.4.2019.12.10.09.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 09:00:02 -0800 (PST)
Date:   Tue, 10 Dec 2019 18:00:00 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        ja@ssi.bg, marcelo.leitner@gmail.com, dsahern@gmail.com,
        edumazet@google.com
Subject: Re: [PATCHv2 net] ipv6/route: should not update neigh confirm time
 during PMTU update
Message-ID: <20191210170000.GA1132@linux.home>
References: <20191202.184704.723174427717421022.davem@davemloft.net>
 <20191203101536.GJ18865@dhcp-12-139.nay.redhat.com>
 <20191203102534.GK18865@dhcp-12-139.nay.redhat.com>
 <20191203.115818.1902434596879929857.davem@davemloft.net>
 <20191210033656.GM18865@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191210033656.GM18865@dhcp-12-139.nay.redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: kHL1pVgjN1iYZ4U8ULyHcw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 11:36:56AM +0800, Hangbin Liu wrote:
> Hi David,
>=20
> Sorry for the late reply. Hope you still have impression for this discuss=
ion.
> I discussed this issue with my colleagues offline and I still have some q=
uestions.
> Please see comments below.
>=20
> On Tue, Dec 03, 2019 at 11:58:18AM -0800, David Miller wrote:
> > >> > That's not what I said.
> > >> >=20
> > >> > I said that this interface is designed for situations where the ne=
igh
> > >> > update is appropriate, and that's what happens for most callers _e=
xcept_
> > >> > these tunnel cases.
> > >> >=20
> > >> > The tunnel use is the exception and invoking the interface
> > >> > inappropriately.
> > >> >=20
> > >> > It is important to keep the neigh reachability fresh for TCP flows=
 so
> > >> > you cannot remove this dst_confirm_neigh() call.
>=20
> The first is why IPv4 don't need this neigh update. I didn't
> find dst_confirm_neigh() or ipv4_confirm_neigh() in ip_rt_update_pmtu()
>=20
> > >=20
> > > I have one question here. Since we have the .confirm_neigh fuction in
> > > struct dst_ops. How about do a dst->ops->confirm_neigh() separately a=
fter
> > > dst->ops->update_pmtu()? Why should we mix the confirm_neigh() in
> > > update_pmtu(), like ip6_rt_update_pmtu()?
> >=20
> > Two indirect calls which have high cost due to spectre mitigation?
>=20
> Guillaume pointed me that dst_confirm_neigh() is also a indriect call.
> So it should take same cost to call dst_confirm_neigh() in or before
> __ip6_rt_update_pmtu(). If they are the same cose, I think there would
> have two fixes.
>=20
OTOH, the dst_confirm_neigh() call could easily be replaced by a direct
ip6_confirm_neigh() call in the current code (maybe using an
INDIRECT_CALL wrapper if necessary).
I'm not sure where dst_confirm_neigh() would go if it was moved outside
of __ip6_rt_update_pmtu(), but that might make such optimisation
harder.

> 1. Add a new parameter 'bool confirm_neigh' to __ip6_rt_update_pmtu(),
> update struct dst_ops.update_mtu and all functions who called it.
>=20
> 2. Move dst_confirm_neigh() out of __ip6_rt_update_pmtu() and only call i=
t
>    in fuctions who need it, like inet6_csk_update_pmtu().
>=20
> What do you think? Please tell me if I missed something.
>=20
> Regards
> Hangbin
>=20

