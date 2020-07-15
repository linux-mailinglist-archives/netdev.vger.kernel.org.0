Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7220F220731
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgGOI2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:28:33 -0400
Received: from [195.135.220.15] ([195.135.220.15]:54244 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1729989AbgGOI20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 04:28:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3DCF7AEA7;
        Wed, 15 Jul 2020 08:28:28 +0000 (UTC)
Date:   Wed, 15 Jul 2020 10:28:20 +0200
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: RTL8402 stops working after hibernate/resume
Message-ID: <20200715102820.7207f2f8@ezekiel.suse.cz>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/54tap_mlfzbWJwEAI0YrLuM";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/54tap_mlfzbWJwEAI0YrLuM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

I've encountered some issues on an Asus laptop. The RTL8402 receive
queue behaves strangely after suspend to RAM and resume - many incoming
packets are truncated, but not all and not always to the same length
(most commonly 60 bytes, but I've also seen 150 bytes and other
lengths).

Reloading the driver can fix the problem, so I believe we must be
missing some initialization on resume. I've already done some
debugging, and the interface is not running when rtl8169_resume() is
called, so __rtl8169_resume() is skipped, which means that almost
nothing is done on resume.

Some more information can be found in this openSUSE bug report:

https://bugzilla.opensuse.org/show_bug.cgi?id=3D1174098

The laptop is not (yet) in production, so I can do further debugging if
needed.

Petr T

--Sig_/54tap_mlfzbWJwEAI0YrLuM
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl8OviQACgkQqlA7ya4P
R6cCjwgAu4KNToCfxJuVVuXL8WgyN+S08ce4GmCu5muk4M14bLqWW4fxWYa6FI6/
kp2VBoh6LRvch65iqPPzIeVEqnDv0Aadc3NdJitMZf5Nn6VTuVvpK/fjw91BLmVC
zH0x8Sv1vvXO/vgKW41NFIpT02y3nyLAFuNVnQHJotuygRWW+ANOxloeOnAvky4b
uVE6kNQRz/9NFT+Z2Qb9ZIKDcFacRyEhFaDUy0EKUoNCaEgno0adPsmGbVVoU+mJ
LJ0TXZFhuPA4Ls//1I5ipOIMfDlpka6N9egOaG76auOLQs9d435sxUGkrO7VtZrJ
L6dmdRcOAV5TlTvdzfdIJlJcEu8/FQ==
=5Yt0
-----END PGP SIGNATURE-----

--Sig_/54tap_mlfzbWJwEAI0YrLuM--
