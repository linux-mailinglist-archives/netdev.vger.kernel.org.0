Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A131530B1
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 13:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgBEM2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 07:28:16 -0500
Received: from relay.cooperix.net ([176.58.120.209]:49756 "EHLO
        relay.sandelman.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727892AbgBEM2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 07:28:15 -0500
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Feb 2020 07:28:14 EST
Received: from dooku.sandelman.ca (ip5f5bd76d.dynamic.kabel-deutschland.de [95.91.215.109])
        by relay.sandelman.ca (Postfix) with ESMTPS id 4B8E61F45A;
        Wed,  5 Feb 2020 12:21:40 +0000 (UTC)
Received: by dooku.sandelman.ca (Postfix, from userid 179)
        id 6A87F1314; Wed,  5 Feb 2020 07:21:37 -0500 (EST)
From:   Michael Richardson <mcr@sandelman.ca>
To:     Alexander Aring <alex.aring@gmail.com>
cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: ipv6: seg6: headroom fixes
In-reply-to: <20200204173019.4437-1-alex.aring@gmail.com>
References: <20200204173019.4437-1-alex.aring@gmail.com>
Comments: In-reply-to Alexander Aring <alex.aring@gmail.com>
   message dated "Tue, 04 Feb 2020 12:30:17 -0500."
X-Mailer: MH-E 8.6; nmh 1.6; GNU Emacs 25.1.1
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Date:   Wed, 05 Feb 2020 13:21:37 +0100
Message-ID: <26689.1580905297@dooku.sandelman.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain


Alexander Aring <alex.aring@gmail.com> wrote:
    > This patch series fixes issues which I discovered while implementing RPL
    > source routing for 6LoWPAN interfaces. 6LoWPAN interfaces are using a MTU
    > of 1280 which is the IPv6 minimum MTU. I suppose this is the right fix to
    > do that according to my explanation that tunnels which acting before L3
    > need to set this headroom. So far I see only segmentation route is affected
    > to it. Maybe BPF tunnels, but it depends on the case... Maybe a comment
    > need to be added there as well to not getting confused. If wanted I can
    > send another patch for a comment for net-next or even net? May the
    > variable should be renamed to l2_headroom?

I had discussed this with Alex over the past few days.
I had not looked closely at the code during that discussion, and maybe my
comments in chat were wrong.  So these patches don't look right to me.

I think that the issue we have here is that things are big vague when it
comes to layer-2.5's, and fatter layer-3s.  Maybe this is well established in
lore...

My understanding is that headroom is a general offset, usually set by the L2
which tells the L3/L4 how much to offset in the SKB before the ULP header is
inserted.   TCP/UDP/SCTP/ESP need to know this.

MPLS is a layer-2.5, and so it quite weird, because it creates a new L2
which lives upon other L2 and also other L3s.

Segment routing, and RPL RH3 headers involve a fatter L3 header.

Of course, one could mix all of these things together!

--
]               Never tell me the odds!                 | ipv6 mesh networks [
]   Michael Richardson, Sandelman Software Works        | network architect  [
]     mcr@sandelman.ca  http://www.sandelman.ca/        |   ruby on rails    [


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEERK+9HEcJHTJ9UqTMlUzhVv38QpAFAl46s1AACgkQlUzhVv38
QpBXbAf/esJasXYzIXpM5QlQ86jcP9DTVkAbAR5aZ6ROozi9/IdiPq8k6naBIlSj
zWfFfCFnt9B0fpidq4DFlNaBLtZGFCZS7CHWuXtjZO0keW4yttiuNEYrxfsirHPu
HqNHihTN8gRFGjS6QhjqliRiJS0eaH63xvCVssqDzD7kNnmGtk/uTHxBexw5Z+nG
j4LW7zzukVYSfM/hzjFsissC0G+4oiuCKRaHUEMisCSmwR+fftE+Z0ZPW+A1OFiu
gS3lhTw7lD5SUkBUxNlT2E6CGen6hn48ToWw6Wzy/tGo27k1D9PBynh+XVDfx8CK
utDTdAG6fKhWvBfMMPVCbJE2hugjcA==
=/Oxf
-----END PGP SIGNATURE-----
--=-=-=--
