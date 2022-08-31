Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540D95A86CE
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiHaTe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiHaTe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:34:27 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A59E9276
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 12:34:25 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1661974464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3J7Qo5W24M7IeEiJ8fJ6rUK/1SMNUmuliO7m7fGcfRA=;
        b=Xcx6okHB2XNZKBysqIztTd34PvWQY0AGt1niAIZpW/eX/JRjj1OHj36YXHZTbMn0TUF6xC
        eqyiBQ9pHJ2HCAtGv2xWxxR1vW5i9bFEfqq5eUCL+TUWPFuNjdoqQOjGWwofr7UkaR+gWb
        7KNdIGvmtN19uhpHKe5q2EmDHJ99kjrKYda+ktHmqkrlFhnOjoYJbpeUfG+VohhNXi4WSK
        EmrGex9r1XyF3h1zyNVKQaq9AivsAvMD890eu5f402VRynrZra2jejb2YB4qzjTfHeCloQ
        2j4HqLCUWSasGUcOgZo1txt7rAyins4Z/5mvcvZ6BryQiY/Y/RThJU3CInhyhg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1661974464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3J7Qo5W24M7IeEiJ8fJ6rUK/1SMNUmuliO7m7fGcfRA=;
        b=4RqNGXfIr1BuV+rGFCrDpMEiQ39RzG38G2fsvAq4Otnl9XQ66o3aD7iuY2Uq/DofkzLqIC
        n2BZTJLfv6NjvpDw==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Print warning only once
In-Reply-To: <20220831152628.um4ktfj4upcz7zwq@skbuf>
References: <20220830163448.8921-1-kurt@linutronix.de>
 <20220831152628.um4ktfj4upcz7zwq@skbuf>
Date:   Wed, 31 Aug 2022 21:34:22 +0200
Message-ID: <87v8q8jjgh.fsf@kurt>
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

On Wed Aug 31 2022, Vladimir Oltean wrote:
> On Tue, Aug 30, 2022 at 06:34:48PM +0200, Kurt Kanzenbach wrote:
>> In case the source port cannot be decoded, print the warning only once. =
This
>> still brings attention to the user and does not spam the logs at the sam=
e time.
>>=20
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
>
> Out of curiosity, how did this happen?

Well, I'm still looking into it...

I've plugged my hellcreek test device into a Cisco switch and saw these
messages flying by. It said it failed to get source port 0 at a constant
rate. Turns out the Cisco switch does RSTP by default. Every STP frame
received has source port 0 which doesn't make any sense. The switch adds
a tail tag to every frame towards the CPU. All STP frames have their
tail tag not really at the end of the frame. It's off by exactly four
bytes. So, maybe it's the FCS.

The DSA master is a older stmmac. It has this code here:

|drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
|	/* Clear ACS bit because Ethernet switch tagging formats such as
|	 * Broadcom tags can look like invalid LLC/SNAP packets and cause the
|	 * hardware to truncate packets on reception.
|	 */
|	if (netdev_uses_dsa(dev) || !priv->plat->enh_desc)
|		value &=3D ~GMAC_CONTROL_ACS;
|

Actually, this has to be done. Without disabling the ACS bit the STP
frames are truncated and the trailer tag is gone.

Then, there is

|drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
|		/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
|		 * Type frames (LLC/LLC-SNAP)
|		 *
|		 * llc_snap is never checked in GMAC >=3D 4, so this ACS
|		 * feature is always disabled and packets need to be
|		 * stripped manually.
|		 */
|		if (likely(!(status & rx_not_ls)) &&
|		    (likely(priv->synopsys_id >=3D DWMAC_CORE_4_00) ||
|		     unlikely(status !=3D llc_snap))) {
|			if (buf2_len)
|				buf2_len -=3D ETH_FCS_LEN;
|			else
|				buf1_len -=3D ETH_FCS_LEN;
|
|			len -=3D ETH_FCS_LEN;
|		}

Great. Unfortunately the stmmac used here is a dwmac-3.70. So, the FCS
doesn't seem to be stripped for the STP frames.

Now, I'm currently testing the patch below and it seems to work:

|root@tsn:~# dmesg | grep -i 'Failed to get source port'
|root@tsn:~# tcpdump -i lan0 stp
|tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
|listening on lan0, link-type EN10MB (Ethernet), snapshot length 262144 byt=
es
|19:25:17.031699 STP 802.1w, Rapid STP, Flags [Learn, Forward, Agreement], =
bridge-id 8000.2c:1a:05:28:06:c1.8006, length 36

Thanks,
Kurt

Patch:

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/ne=
t/ethernet/stmicro/stmmac/stmmac_main.c
index 9c1e19ea6fcd..74f348e27005 100644
=2D-- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -41,6 +41,7 @@
 #include <linux/bpf_trace.h>
 #include <net/pkt_cls.h>
 #include <net/xdp_sock_drv.h>
+#include <net/dsa.h>
 #include "stmmac_ptp.h"
 #include "stmmac.h"
 #include "stmmac_xdp.h"
@@ -5209,6 +5210,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int li=
mit, u32 queue)
                 */
                if (likely(!(status & rx_not_ls)) &&
                    (likely(priv->synopsys_id >=3D DWMAC_CORE_4_00) ||
+                    unlikely(netdev_uses_dsa(priv->dev)) ||
                     unlikely(status !=3D llc_snap))) {
                        if (buf2_len)
                                buf2_len -=3D ETH_FCS_LEN;

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmMPt74THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgqbSD/9NVb6wxhzvA8gW9f53yUwurkfytuHA
EGmvRpVIOhO3pyyjoIxD/v44JvqyydeeyNrZruwWsSWEdVvwxihi9SDpqAut42A0
BPG5yn17Wldvur1SEAhi8s6XyapXiASnYykmkFfBcafftDPBoMcC0qOLE2NbEMr+
WBlm1Go1BzrKUI3d8gbXwrJ7iuuy0v/v/hxH2CGUMgz4DLDVDBMQ/l69h6EaCDwa
W5C39kqkqkZsZdi55tGbWp+GaipyMC74omGv+iH6ROedsZrMOcv+6P1Fi7UldTaf
v8TZIDbpQP8N6vSPrZFV3CzHP4MWl7bpufeBC4z10crUzXgjoIc22hpF5Kl2iKuN
0YVKjlqM4S0KiDJwyq4QIvhsKiUYBtvuUr0EwWCciYPyY90z6jPG6lpRLhyNWBxV
eh6+t0TsG/86z+dj4P1wIJIWs0wYDul/YEFyg2at3r8rvDNJOfVWTVq99bOX1BQW
i0Ke34uTdHyHOOyM2xEbvI50Mkj4Z2O4+8E6oomOxJ+aFWO2jr7sNq7QGLp5hQhe
2DTpx1ZhvokuH0Bt5gyGCgGlfBRIibSccKhJfn0zWR1eOq7OV2UIPpq9HZNpfZzX
8ZFy4cV7QzWWmB+VsHtpuk6sMoftp//tcRB/Fnj8HO2CMoDVg6/rjMY623YWoeso
UyzRWCg/zxeBHg==
=hudf
-----END PGP SIGNATURE-----
--=-=-=--
