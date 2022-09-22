Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F6A5E5D1A
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 10:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiIVIKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 04:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiIVIKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 04:10:22 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E542580BA;
        Thu, 22 Sep 2022 01:10:20 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1663834218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yk37Sm5RjPl4UM/wzjBk81ZqNgBCf/jvihfnr2HHbmQ=;
        b=P0fi/JSHZxDEpWm+kyqNqlwL8rKUkQd7pIeHdLT3EMWFnW/67mJQyJ3Bt0APH6aIk9FnYN
        L3hxok8BqhjzwrikH94uAD37KZsml2XE1oX7iWwnQJrr6J9y1KnIuo9+6J+xK5rH5rVYsn
        rFwRFPoCwlfpbUfk3aICi/phuIJtbEJkqAeDz+fFG63ztOplEZW/2Kn/ZLc9fkH2hvhOIu
        n6LCp7yZrQBfcTJccnOuo5jVtcBcqCnTQ5bY/MxL6YsdNApyQTXa1YEJvVg5MlAa73qaDb
        FVnHM4HPQscsa64nh/YCpXTc8bEeNstX5XuWNmVGCb5LcC5Hk4zNZ1/jNdK8sw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1663834218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yk37Sm5RjPl4UM/wzjBk81ZqNgBCf/jvihfnr2HHbmQ=;
        b=9yxXWJ9Uwb/92HpkvOpk1PH3pma/UUMrKllv4gTJEOMedTG98Gi9fooPTxdsfgp5ZkSGTx
        uJzPAkw+Gg3/RaAQ==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 08/13] net: dsa: hellcreek: deny tc-taprio
 changes to per-tc max SDU
In-Reply-To: <20220921142115.4gywxgkgh2fqthjz@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-9-vladimir.oltean@nxp.com> <87a671bz8e.fsf@kurt>
 <20220914184051.2awuutgr4vm4tfgf@skbuf> <87r10dxiw5.fsf@kurt>
 <20220915115925.zujsneox4jqzod2g@skbuf> <87bkr9m0nn.fsf@kurt>
 <20220921112916.umvtccuuygacbqbb@skbuf> <878rmdlzld.fsf@kurt>
 <20220921141206.rvdsrp7lmm2fk5ub@skbuf>
 <20220921142115.4gywxgkgh2fqthjz@skbuf>
Date:   Thu, 22 Sep 2022 10:10:13 +0200
Message-ID: <8735cjrfru.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed Sep 21 2022, Vladimir Oltean wrote:
> On Wed, Sep 21, 2022 at 05:12:06PM +0300, Vladimir Oltean wrote:
>> On Wed, Sep 21, 2022 at 01:46:22PM +0200, Kurt Kanzenbach wrote:
>> > >> So, configured to 128 and 132 bytes (including VLAN Ethernet header=
) is
>> > >> the maximum frame size which passes through.
>> > >
>> > > Frame size means MAC DA + MAC SA + VLAN header + Ethertype + L2 payl=
oad,
>> > > and without FCS, right?
>> >=20
>> > Yes.
>> >=20
>> > >
>> > > Because max_sdu 128 only counts the L2 payload, so the maximum frame
>> > > size that passes should be 142 octets, or 146 octets with VLAN.
>> >=20
>> > Ok, i see. So, for 128 max-sdu we should end up with something like th=
is
>> > in the prio config register:
>> >=20
>> >  schedule->max_sdu[tc] + VLAN_ETH_HLEN - 4
>>=20
>> What does 4 represent? ETH_FCS_LEN?
>>=20
>> So when schedule->max_sdu[tc] is 128, you write to HR_PTPRTCCFG_MAXSDU
>> the value of 128 + 18 - 4 =3D 142, and this will pass packets (VLAN-tagg=
ed
>> or not) with an skb->len (on xmit) <=3D 142, right?
>
> Mistake, I meant skb->len <=3D 146 (max_sdu[tc] + VLAN_ETH_HLEN). So the
> hardware calculates the max frame len to include FCS, and skb->len is
> without FCS, hence the 4 discrepancy.

Yes, seems like it.

In case you repost this series, can you replace your patch with the one
below?

From=206488e0f979f3ea8c6130beb1b3e661cdb7796916 Mon Sep 17 00:00:00 2001
From: Kurt Kanzenbach <kurt@linutronix.de>
Date: Wed, 14 Sep 2022 19:51:40 +0200
Subject: [PATCH] net: dsa: hellcreek: Offload per-tc max SDU from tc-taprio

Add support for configuring the max SDU per priority and per port. If not
specified, keep the default.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
=2D--
 drivers/net/dsa/hirschmann/hellcreek.c | 64 +++++++++++++++++++++++---
 drivers/net/dsa/hirschmann/hellcreek.h |  7 +++
 2 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirsc=
hmann/hellcreek.c
index 5ceee71d9a25..c4b76b1e7a63 100644
=2D-- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -128,6 +128,16 @@ static void hellcreek_select_prio(struct hellcreek *he=
llcreek, int prio)
 	hellcreek_write(hellcreek, val, HR_PSEL);
 }
=20
+static void hellcreek_select_port_prio(struct hellcreek *hellcreek, int po=
rt,
+				       int prio)
+{
+	u16 val =3D port << HR_PSEL_PTWSEL_SHIFT;
+
+	val |=3D prio << HR_PSEL_PRTCWSEL_SHIFT;
+
+	hellcreek_write(hellcreek, val, HR_PSEL);
+}
+
 static void hellcreek_select_counter(struct hellcreek *hellcreek, int coun=
ter)
 {
 	u16 val =3D counter << HR_CSEL_SHIFT;
@@ -1537,6 +1547,45 @@ hellcreek_port_prechangeupper(struct dsa_switch *ds,=
 int port,
 	return ret;
 }
=20
+static void hellcreek_setup_maxsdu(struct hellcreek *hellcreek, int port,
+				   const struct tc_taprio_qopt_offload *schedule)
+{
+	int tc;
+
+	for (tc =3D 0; tc < 8; ++tc) {
+		u32 max_sdu =3D schedule->max_sdu[tc] + VLAN_ETH_HLEN - ETH_FCS_LEN;
+		u16 val;
+
+		if (!schedule->max_sdu[tc])
+			continue;
+
+		dev_dbg(hellcreek->dev, "Configure max-sdu %u for tc %d on port %d\n",
+			max_sdu, tc, port);
+
+		hellcreek_select_port_prio(hellcreek, port, tc);
+
+		val =3D (max_sdu & HR_PTPRTCCFG_MAXSDU_MASK) << HR_PTPRTCCFG_MAXSDU_SHIF=
T;
+
+		hellcreek_write(hellcreek, val, HR_PTPRTCCFG);
+	}
+}
+
+static void hellcreek_reset_maxsdu(struct hellcreek *hellcreek, int port)
+{
+	int tc;
+
+	for (tc =3D 0; tc < 8; ++tc) {
+		u16 val;
+
+		hellcreek_select_port_prio(hellcreek, port, tc);
+
+		val =3D (HELLCREEK_DEFAULT_MAX_SDU & HR_PTPRTCCFG_MAXSDU_MASK)
+			<< HR_PTPRTCCFG_MAXSDU_SHIFT;
+
+		hellcreek_write(hellcreek, val, HR_PTPRTCCFG);
+	}
+}
+
 static void hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
 				const struct tc_taprio_qopt_offload *schedule)
 {
@@ -1720,7 +1769,10 @@ static int hellcreek_port_set_schedule(struct dsa_sw=
itch *ds, int port,
 	}
 	hellcreek_port->current_schedule =3D taprio_offload_get(taprio);
=20
=2D	/* Then select port */
+	/* Configure max sdu */
+	hellcreek_setup_maxsdu(hellcreek, port, hellcreek_port->current_schedule);
+
+	/* Select tdg */
 	hellcreek_select_tgd(hellcreek, port);
=20
 	/* Enable gating and keep defaults */
@@ -1772,7 +1824,10 @@ static int hellcreek_port_del_schedule(struct dsa_sw=
itch *ds, int port)
 		hellcreek_port->current_schedule =3D NULL;
 	}
=20
=2D	/* Then select port */
+	/* Reset max sdu */
+	hellcreek_reset_maxsdu(hellcreek, port);
+
+	/* Select tgd */
 	hellcreek_select_tgd(hellcreek, port);
=20
 	/* Disable gating and return to regular switching flow */
@@ -1814,15 +1869,10 @@ static int hellcreek_port_setup_tc(struct dsa_switc=
h *ds, int port,
 {
 	struct tc_taprio_qopt_offload *taprio =3D type_data;
 	struct hellcreek *hellcreek =3D ds->priv;
=2D	int tc;
=20
 	if (type !=3D TC_SETUP_QDISC_TAPRIO)
 		return -EOPNOTSUPP;
=20
=2D	for (tc =3D 0; tc < TC_MAX_QUEUE; tc++)
=2D		if (taprio->max_sdu[tc])
=2D			return -EOPNOTSUPP;
=2D
 	if (!hellcreek_validate_schedule(hellcreek, taprio))
 		return -EOPNOTSUPP;
=20
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirsc=
hmann/hellcreek.h
index c96b8c278904..66b989d946e4 100644
=2D-- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -37,6 +37,7 @@
 #define HELLCREEK_VLAN_UNTAGGED_MEMBER	0x1
 #define HELLCREEK_VLAN_TAGGED_MEMBER	0x3
 #define HELLCREEK_NUM_EGRESS_QUEUES	8
+#define HELLCREEK_DEFAULT_MAX_SDU	1536
=20
 /* Register definitions */
 #define HR_MODID_C			(0 * 2)
@@ -72,6 +73,12 @@
 #define HR_PRTCCFG_PCP_TC_MAP_SHIFT	0
 #define HR_PRTCCFG_PCP_TC_MAP_MASK	GENMASK(2, 0)
=20
+#define HR_PTPRTCCFG			(0xa9 * 2)
+#define HR_PTPRTCCFG_SET_QTRACK		BIT(15)
+#define HR_PTPRTCCFG_REJECT		BIT(14)
+#define HR_PTPRTCCFG_MAXSDU_SHIFT	0
+#define HR_PTPRTCCFG_MAXSDU_MASK	GENMASK(10, 0)
+
 #define HR_CSEL				(0x8d * 2)
 #define HR_CSEL_SHIFT			0
 #define HR_CSEL_MASK			GENMASK(7, 0)
=2D-=20
2.30.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmMsGGUTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgtggEACyeEp0bzZvEccfIhL0cyFVLvhUXBVu
8oS5PO4of2nlIwX499CSYesbrgE4wHbyXXxrU0nW4/nQY07cP/stNlFVf9bAuwhb
syAXZSVADPG35DV6ROr77EjEsrcBf43yf1yqCFVqx37DzCdgWPCI6mCcLa3p0am7
Pb399tXm/llO25I1lTml9jYmojQGIc9h3dwxmB6tgjsf558nWZI00P3KGIFXqgmq
Nlbk3Q27iBsrKjt4Aukz9j4AepMSqdtL6b7qYOKf3UZF6wt+r4CGIZB6LQxPgqH2
rSVGuvGvILkvlT2RiESmBAYXPGfNFWRlj0s0KvjgyQDcCrxCV/CxV02GukYkhnPA
t7V9e2FliLZNZKTb9XIteIVxS4xeZgDpK+Q848iRc9X30uejMea5Gp8+2rX/n3RH
ETFW9ESi24CI5pxTZrFPwC0dutAZpnSSVk1HYHyLd39G/V+gEs2aKf9MoZi9Wpdg
KBWqReaQfyfD3wEd7HiMYPj4SsY8TA+4Q/l4WBiirfbuHz3q/pdPbYtAT8h6WCJ5
1Ri1vaAFKjBvAWYrfZmQHrjVekXJKKmIgjAgdXyMbTpgJDEvfvU4zQM0GTr/BX0y
MXaln9yGjgKBndIF7KBi8+SsUoFfzUV98HCYoa/Pu3A6/nhIC+b8pqQXpJtCUuWk
5aRIBaJzP0vjBQ==
=7Q4o
-----END PGP SIGNATURE-----
--=-=-=--
