Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D619A5ABF1D
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 15:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiICNYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 09:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiICNYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 09:24:43 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6AD10562
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 06:24:37 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1662211475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SiP2ZxrTmI1d495SWlanI9uEuVZnAEP4yIPhNMTL3lI=;
        b=ENRFacNxZTs2qvQhuYG4kQM7kRtJeXOOCaWJvlV6N3C30F1kVW0jp9BSEsc271qstTMzaP
        YK2BLwpIZb8bflfy8E+odzQvzEkndMCT7TtYfDyXX9b5iECkEinkAlbFwUwksq6GYspxra
        qr2pUcVS3j2wrfOcA5hNu53JsGnSFXujp2d15uZOuNhXoLYHM2DBBrwQiraTQvhz9uxLKR
        onqPe4fWagaDqpgyFnyAZiQd3CMbRLXbNfuFVCFuvJpN43LRBwivrxZNPMWzOBUGPPJhHg
        cKJxxtHaWhe6vzd/VbMzJi7A0/RRnP+w8hU8WBbj00GC1nJ551gPuJJw3uAzBA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1662211475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SiP2ZxrTmI1d495SWlanI9uEuVZnAEP4yIPhNMTL3lI=;
        b=9V8EGM8dw0miG8G4I1lBpvDgf8miy4/KwoWFr4hWmN8ld4Ovy5F0C7uckbJdGFovwuiXKp
        tODMXolU36hTQnDA==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Print warning only once
In-Reply-To: <20220901113912.wrwmftzrjlxsof7y@skbuf>
References: <20220830163448.8921-1-kurt@linutronix.de>
 <20220831152628.um4ktfj4upcz7zwq@skbuf> <87v8q8jjgh.fsf@kurt>
 <20220831234329.w7wnxy4u3e5i6ydl@skbuf> <87czcfzkb6.fsf@kurt>
 <20220901113912.wrwmftzrjlxsof7y@skbuf>
Date:   Sat, 03 Sep 2022 15:24:33 +0200
Message-ID: <87r10sr3ou.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Sep 01 2022, Vladimir Oltean wrote:
> On Thu, Sep 01, 2022 at 08:21:33AM +0200, Kurt Kanzenbach wrote:
>> > So from Florian's comment above, he was under case (b), different than=
 yours.
>> > I don't understand why you say that when ACS is set, "the STP frames a=
re
>> > truncated and the trailer tag is gone". Simply altering the ACS bit
>> > isn't going to change the determination made by stmmac_rx(). My guess
>> > based on the current input I have is that it would work fine for you
>> > (but possibly not for Florian).
>>=20
>> I thought so too. However, altering the ACS Bit didn't help at all.
>
> This is curious. Could you dump the Length/Type Field (LT bits 18:16)
> from the RDES3 for these packets? If ACS does not take effect, it would
> mean the DWMAC doesn't think they're Length packets I guess? Also, does
> the Error Summary say anything? In principle, the length of this packet
> is greater than the EtherType/Length would say, by the size of the tail
> tag. Not sure how that affects the RX parser.

That's the point. The RX parser seems to be affected by the tail
tag. I'll have a look at the packets with ACS feature set.

>
>> We could do some measurements e.g., with perf to determine whether
>> removing the FCS logic has positive or negative effects?
>
> Yes, some IP forwarding of 60 byte frames at line rate gigabit or higher
> should do the trick. Testing with MTU sized packets is probably not
> going to show much of a difference.

Well, I don't see much of a difference. However, running iperf3 with
small packets is nowhere near line rate of 100Mbit/s. Nevertheless, I
like the following patch more, because it looks cleaner than adding more
checks to the receive path. It fixes my problem. Florian's use case
should also work.

From=205a54383167c624a90ba460531fccabbb87d40e51 Mon Sep 17 00:00:00 2001
From: Kurt Kanzenbach <kurt@linutronix.de>
Date: Fri, 2 Sep 2022 19:49:52 +0200
Subject: [PATCH] net: stmmac: Disable automatic FCS/Pad stripping

The stmmac has the possibility to automatically strip the padding/FCS for I=
EEE
802.3 type frames. This feature is enabled conditionally. Therefore, the st=
mmac
receive path has to have a determination logic whether the FCS has to be
stripped in software or not.

In fact, for DSA this ACS feature is disabled and the determination logic
doesn't check for it properly. For instance, when using DSA in combination =
with
an older stmmac (pre version 4), the FCS is not stripped by hardware or sof=
tware
which is problematic.

So either add another check for DSA to the fast path or simply disable ACS
feature completely. The latter approach has been chosen, because most of the
time the FCS is stripped in software anyway and it removes conditionals fro=
m the
receive fast path.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
=2D--
 .../net/ethernet/stmicro/stmmac/dwmac100.h    |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000.h   |  2 +-
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  |  9 -------
 .../ethernet/stmicro/stmmac/dwmac100_core.c   |  8 ------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 26 +++----------------
 5 files changed, 6 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100.h b/drivers/net/e=
thernet/stmicro/stmmac/dwmac100.h
index 35ab8d0bdce7..7ab791c8d355 100644
=2D-- a/drivers/net/ethernet/stmicro/stmmac/dwmac100.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100.h
@@ -56,7 +56,7 @@
 #define MAC_CONTROL_TE		0x00000008	/* Transmitter Enable */
 #define MAC_CONTROL_RE		0x00000004	/* Receiver Enable */
=20
=2D#define MAC_CORE_INIT (MAC_CONTROL_HBD | MAC_CONTROL_ASTP)
+#define MAC_CORE_INIT (MAC_CONTROL_HBD)
=20
 /* MAC FLOW CTRL defines */
 #define MAC_FLOW_CTRL_PT_MASK	0xffff0000	/* Pause Time Mask */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h b/drivers/net/=
ethernet/stmicro/stmmac/dwmac1000.h
index 3c73453725f9..4296ddda8aaa 100644
=2D-- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -126,7 +126,7 @@ enum inter_frame_gap {
 #define GMAC_CONTROL_TE		0x00000008	/* Transmitter Enable */
 #define GMAC_CONTROL_RE		0x00000004	/* Receiver Enable */
=20
=2D#define GMAC_CORE_INIT (GMAC_CONTROL_JD | GMAC_CONTROL_PS | GMAC_CONTROL=
_ACS | \
+#define GMAC_CORE_INIT (GMAC_CONTROL_JD | GMAC_CONTROL_PS | \
 			GMAC_CONTROL_BE | GMAC_CONTROL_DCRS)
=20
 /* GMAC Frame Filter defines */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers=
/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index fc8759f146c7..35d7c1cb1cf1 100644
=2D-- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -15,7 +15,6 @@
 #include <linux/crc32.h>
 #include <linux/slab.h>
 #include <linux/ethtool.h>
=2D#include <net/dsa.h>
 #include <asm/io.h>
 #include "stmmac.h"
 #include "stmmac_pcs.h"
@@ -24,7 +23,6 @@
 static void dwmac1000_core_init(struct mac_device_info *hw,
 				struct net_device *dev)
 {
=2D	struct stmmac_priv *priv =3D netdev_priv(dev);
 	void __iomem *ioaddr =3D hw->pcsr;
 	u32 value =3D readl(ioaddr + GMAC_CONTROL);
 	int mtu =3D dev->mtu;
@@ -32,13 +30,6 @@ static void dwmac1000_core_init(struct mac_device_info *=
hw,
 	/* Configure GMAC core */
 	value |=3D GMAC_CORE_INIT;
=20
=2D	/* Clear ACS bit because Ethernet switch tagging formats such as
=2D	 * Broadcom tags can look like invalid LLC/SNAP packets and cause the
=2D	 * hardware to truncate packets on reception.
=2D	 */
=2D	if (netdev_uses_dsa(dev) || !priv->plat->enh_desc)
=2D		value &=3D ~GMAC_CONTROL_ACS;
=2D
 	if (mtu > 1500)
 		value |=3D GMAC_CONTROL_2K;
 	if (mtu > 2000)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c b/drivers/=
net/ethernet/stmicro/stmmac/dwmac100_core.c
index ebcad8dd99db..f799f8f824e8 100644
=2D-- a/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
@@ -15,7 +15,6 @@
 **************************************************************************=
*****/
=20
 #include <linux/crc32.h>
=2D#include <net/dsa.h>
 #include <asm/io.h>
 #include "stmmac.h"
 #include "dwmac100.h"
@@ -28,13 +27,6 @@ static void dwmac100_core_init(struct mac_device_info *h=
w,
=20
 	value |=3D MAC_CORE_INIT;
=20
=2D	/* Clear ASTP bit because Ethernet switch tagging formats such as
=2D	 * Broadcom tags can look like invalid LLC/SNAP packets and cause the
=2D	 * hardware to truncate packets on reception.
=2D	 */
=2D	if (netdev_uses_dsa(dev))
=2D		value &=3D ~MAC_CONTROL_ASTP;
=2D
 	writel(value, ioaddr + MAC_CONTROL);
=20
 #ifdef STMMAC_VLAN_TAG_USED
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/ne=
t/ethernet/stmicro/stmmac/stmmac_main.c
index 74f348e27005..0df248a5321e 100644
=2D-- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -41,7 +41,6 @@
 #include <linux/bpf_trace.h>
 #include <net/pkt_cls.h>
 #include <net/xdp_sock_drv.h>
=2D#include <net/dsa.h>
 #include "stmmac_ptp.h"
 #include "stmmac.h"
 #include "stmmac_xdp.h"
@@ -5015,16 +5014,8 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, in=
t limit, u32 queue)
 		buf1_len =3D stmmac_rx_buf1_len(priv, p, status, len);
 		len +=3D buf1_len;
=20
=2D		/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
=2D		 * Type frames (LLC/LLC-SNAP)
=2D		 *
=2D		 * llc_snap is never checked in GMAC >=3D 4, so this ACS
=2D		 * feature is always disabled and packets need to be
=2D		 * stripped manually.
=2D		 */
=2D		if (likely(!(status & rx_not_ls)) &&
=2D		    (likely(priv->synopsys_id >=3D DWMAC_CORE_4_00) ||
=2D		     unlikely(status !=3D llc_snap))) {
+		/* ACS is disabled; strip manually. */
+		if (likely(!(status & rx_not_ls))) {
 			buf1_len -=3D ETH_FCS_LEN;
 			len -=3D ETH_FCS_LEN;
 		}
@@ -5201,17 +5192,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int l=
imit, u32 queue)
 		buf2_len =3D stmmac_rx_buf2_len(priv, p, status, len);
 		len +=3D buf2_len;
=20
=2D		/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
=2D		 * Type frames (LLC/LLC-SNAP)
=2D		 *
=2D		 * llc_snap is never checked in GMAC >=3D 4, so this ACS
=2D		 * feature is always disabled and packets need to be
=2D		 * stripped manually.
=2D		 */
=2D		if (likely(!(status & rx_not_ls)) &&
=2D		    (likely(priv->synopsys_id >=3D DWMAC_CORE_4_00) ||
=2D		     unlikely(netdev_uses_dsa(priv->dev)) ||
=2D		     unlikely(status !=3D llc_snap))) {
+		/* ACS is disabled; strip manually */
+		if (likely(!(status & rx_not_ls))) {
 			if (buf2_len)
 				buf2_len -=3D ETH_FCS_LEN;
 			else
=2D-=20
2.30.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmMTVZITHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgtNaD/44XHzVMyphTufWjvkWuso2fc5a1ALA
/8Bqn+qnIogX76UkLsdtrBrXy3JlCUziOEHOynnCsXOnbPxor8ee4CIDpSCB7b52
KyEqGaizOfGCgo0l9pJKHbCZ9LXXhEkSYvOVeP1Oom/1/g+XT96nO8CLs+Q5s9o0
EqhJjJYRedEYxVdLJt0Th3yIae0Wret7B+Gf9akmjbxCyOYGpjzEcLsTGX8+Xgn+
hH81NP6PDkcUFk/lM9NcmfnnGTj2P5VOFuemibSRgr0hXcYEZHt8YjQJlEPwrchp
T9R+8X5AtY85L4MRBwYzJ1o3WxIOAShiP1jAWlhdNi3fc1EKhKoING6yeLfu/f6z
hGFld41riqzAbEe6F/FuKj00/P70PQGGPoR+VQaOoLbN1d4XAvKGhYS33C9APs78
cRqlolMRu09UiQL2LwF0/1f6Mb5ngcJSPLgsE14FX5XawikidaGQZgqnDv+aIUBp
zJB67dl/n9m70YSUhCZ6y+/S/UR9c0mBNezqmiFzqlMUOkDnKdLFvYgSGEMwjgaR
mbsj3JVLxFvg7ov5wp2MWUQnk0MN0bdN3gWrqeP6EBh4nFOn0sNCG2Fe7c9qt7VG
3y5ZJJ6fDOH1UvqBNzybEyPoYXQcN/j2RjYSdqYdKJUV7Rk4hK7DIFrW/EOC3As+
ul+JfgCXkF8qfA==
=uBM3
-----END PGP SIGNATURE-----
--=-=-=--
