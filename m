Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DDA3ADE5C
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 14:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhFTMl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 08:41:58 -0400
Received: from mout.gmx.net ([212.227.17.20]:58347 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229594AbhFTMlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Jun 2021 08:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1624192767;
        bh=P2Oa1kEoUnZ9uZBpomj9L2/Kaf6nQv+HA6VnBNPmyS4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=BiqN0galNEZ3DUbxYKqmjCEmHeUqorBKCr4mjQPwTKfKeW+jN42qml5+TogrZMti/
         4g47vAH+QynSYcd2TmCdPOCOlm7sgex7ICBaMaKIckwyXMSi86lUXPHKRod9FlSidN
         8oJvtqQlCQ7fW4qG0cuLXw4/PjSpf7ZcMHfsCB68=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ubuntu.fritz.box ([89.247.255.164]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MVvPJ-1lknpS1z65-00RmSI; Sun, 20
 Jun 2021 14:39:27 +0200
From:   Norbert Slusarek <nslusarek@gmx.net>
To:     netdev@vger.kernel.org
Cc:     ore@pengutronix.de, mkl@pengutronix.de, socketcan@hartkopp.net,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        nslusarek@gmx.net, kernel@pengutronix.de
Subject: [PATCH] can: j1939: prevent allocation of j1939 filter for optlen = 0
Date:   Sun, 20 Jun 2021 14:38:42 +0200
Message-Id: <20210620123842.117975-1-nslusarek@gmx.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6KD94nw0dBWNm24DNAnE6hLXHzV9kqsHJCPAfVN2ryg41alYIyZ
 itPA9wOqD16xvHHHhVQ4qqJictavtGLf06NSBLOMMzVgAYUHZtbTIBhjXkVP+IObrz55GXc
 Gy40mo/cE3jZ6mtjhH96f+uyiSc9ByaJz2aI1VoA/CtB//iiAkB412h+52hC28gBU295gjy
 ly4kPJDpM/tq5lxZMIhhg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:n86gtVvcqUU=:wZHh/wVq4L7RQDRaobRqOI
 VxpDHNBS92gtzU1b8TvSl9e+18upgs+sykab3LgvYvQbAWYL/T5UxmumSrmYM+xiNuumYg1LA
 fSejN65l80BImgjWPOYLTM0TG9kt/cx5AcHepoFALEk8lAoJpKrEBgZ8+N7L7wGh9i2QLanex
 DqGDRJukzBSCEECfgbPVlsrvy1vgi5ukRAGnACQ0HknNgoVLdkSD9mft//Ii/1rMK2s2572tE
 M/v+PqsFZlrJg7GcsiPjThSrhlCQYJ9WAuCL6yrpe1BZR0p/dqkmUTHGFIy8XZ+7ltk0xyhlT
 4yNhj2EhEFu1ZviKxO8tRRVvWC8WBDpOXHTKm4e7MiDePoBl+RpwMV4clEnLY1Ym9NQj/lNaf
 qzdSw8WGZxmvH3Mm7oNCpL4JdM/vwfMohAOMSbERSr/z1LYMuzecFKV/yJOQ+G6DoGKAt1NOS
 vEeiBtDCWiYmxDd/bI8D2L6VIjKCTC+FWJYAcJ93T/XfEurWmGgKtvX0/B9UWcbPkncU/70Wj
 C+QmQmLnwLPD5cbUDYvEUqBLjmnT0Z067dG1zcqUxmsvzWtIm06aONf0CYDvu08aYylK4t80E
 JuGnPLARncyR6njEvf3xbYjcB9rz8yOoki2tgjjyf3LyN0oCGAyNXkfuTBUMhdCtZyc6XFSb3
 mIqyuyV/1ow1Ge8O6PXfC7EwLEaM2Im7e09kzH2LA1Q0ZR25/97Mp3eZaoBmfti93BmK+/rzv
 A+B9Tc2bwnlrtZ2789oXFsgzu21pv8DDQhUsSIzV2WV1JAGdEcvI1JYrtzcvFEDcx1G3eARDp
 Pde5CRQZPuqO5nBqCZMCZEG/bl3cTy+e4f62Ghuc/vHBBmV0R3U8WhIKSmsNdaThFE7wg8yQJ
 AjdadVrGwOaZzQfQcYVNzIXuE3yRzi2ccmOl+TnhsxahrJC5bAkn5Nz1qN2IlD8wPc/VJ+RRy
 kfTeLkFxpNowKDZYDbVVdYJdDLQ4AVRyDk4X/7klUdKciR+pD06sdlscPKFTuOWoKeYy8SG8f
 47Z7qy42hzFxdHaRE24Faw+5HUQzS4D4J/YsVPFDIscm3QGnGGSSn+TEqgbesUWQgJbSiYkw3
 dOl8sh5VIQRQ7UgYf4XYL4/RVbBlg7hgCSP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If optval !=3D NULL and optlen =3D 0 are specified for SO_J1939_FILTER in
j1939_sk_setsockopt(), memdup_sockptr() will return ZERO_PTR for 0 size
allocation. The new filter will be mistakenly assigned ZERO_PTR.
This patch checks for optlen !=3D 0 and filter will be assigned NULL
in case of optlen =3D 0.

Fixes: a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>

=2D--
 net/can/j1939/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 56aa66147d5a..ff20cb629200 100644
=2D-- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -673,7 +673,7 @@ static int j1939_sk_setsockopt(struct socket *sock, in=
t level, int optname,

 	switch (optname) {
 	case SO_J1939_FILTER:
-		if (!sockptr_is_null(optval)) {
+		if (!sockptr_is_null(optval) && optlen !=3D 0) {
 			struct j1939_filter *f;
 			int c;

=2D-
2.30.2
