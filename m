Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC89121076
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfLPRCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:02:24 -0500
Received: from mail-eopbgr10084.outbound.protection.outlook.com ([40.107.1.84]:35200
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726747AbfLPRCY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:02:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7Bh/OrX2wyybymAhmlYGHNhsK5po/CaC7ctd1zQXFzV6jDdsXR51QoRwy9df777RUo8Z7a800UpY92nQjL8Rws7glBoFuzpD9txCLzclWmc9TN+441LbNQ3AclI2RnONikn8NfTQSNSkTpVrNmYz/E+fLdxvkSkz6K+K/FSWQ6qNx9bMp9+leod4OBlSrEk4T82xqEOskQJ7vSDFpFqrN6UZaDYl2BEDVmGllBcTfGvPFpTnKWQDNcyyOJv50TeRsbN+j/fJQ9lUs/5PRm9ls/Zq2vLTTHHL+Y+wkVuhLvPCZ4mMLTKU4RS9BHvv5QEw1i2cfM37OMx6g5tjOW9dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFW9YhSHjR0JWaX99Z/w0JB5GS0LNCGSxmwoj+AFL5o=;
 b=aXxy9aNmlmxzhAZCN2JiLuPJzCB+uLvpYj9+b2cLwgG72q5gDg9CLUtw9BK+VeoAK/gh5dUHh7ilOcTNYwy6ogXX00gbWQWfHYE8PVpbzM6SfJo3XFT/YoZLkBvO3TKWFHxmpnEPSI6pMp/SJI6qCAK5j2hZaFS92GNL2yxK0x3UdfOKQB4AO+ShIq2qpT8NGXuXbir1ntttOaELKO7tWuABmn5789dSH/KA2hLOSPp03YjEHSC2e2TPQEyQjBsMgVot8yNdLa0l52jppFBSEDiaQjqkmFqDbCQtLITCm6Y5kKimYYaB8LSmz9i76NVYyKH535jS95h5p/f0cSiRbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFW9YhSHjR0JWaX99Z/w0JB5GS0LNCGSxmwoj+AFL5o=;
 b=k1V81gLoqIryjUaJekN+FXeLuKIEdmucqc3yUxQGalHAkKQQ0Bz7A/984dhP0uK4SIU+pRG5pOEwogV8uZZio1x/oTHpfhY4cDDnLAThUB2U9CgkziiOoQZwYc+7cCt9h2rru5b0d/c64NJaKKl9sL8hsQN0x7/5bRZyIMVXqNU=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3014.eurprd05.prod.outlook.com (10.172.248.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Mon, 16 Dec 2019 17:01:51 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:01:51 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v1 06/10] mlxsw: spectrum_qdisc: Generalize
 PRIO offload to support ETS
Thread-Topic: [PATCH net-next mlxsw v1 06/10] mlxsw: spectrum_qdisc:
 Generalize PRIO offload to support ETS
Thread-Index: AQHVtDKCtP1+FO+gGUeTx8JCyiJBBw==
Date:   Mon, 16 Dec 2019 17:01:51 +0000
Message-ID: <b22486cf0eb0da08789589876f754ccdab53c882.1576515562.git.petrm@mellanox.com>
References: <cover.1576515562.git.petrm@mellanox.com>
In-Reply-To: <cover.1576515562.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: PR0P264CA0027.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::15) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: abc0b9bd-60c0-4a0b-6a19-08d78249a503
x-ms-traffictypediagnostic: DB6PR0502MB3014:|DB6PR0502MB3014:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB3014B67DA3F2891348121A4FDB510@DB6PR0502MB3014.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(189003)(199004)(186003)(6512007)(26005)(316002)(107886003)(71200400001)(6486002)(81166006)(6506007)(81156014)(8676002)(8936002)(66556008)(66476007)(66446008)(64756008)(66946007)(2906002)(478600001)(54906003)(6916009)(2616005)(86362001)(36756003)(52116002)(4326008)(5660300002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3014;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: km9rBRpvoJf09SP23kIbiFH8Or2dln0WQSPn1i2pGDF4+nSsbqOXlgZRvKaZRbBBdxQMYCc12OI2SOEMx0lvsyq72E7Vig+N7Zqrc8HVAD1P1TT/HOppSiD6xEm+e3Qpb3XvxNv+mkyAaqibccWhBSgk8td5WK2TMAtURXcAFkgCjD6DQYyAsXB5POGlqb1XlR6reyKQUB9qdnI5Mb0EjXVgt0gnSNwXtGZqERpDXM2dOd/OeBnmT5jFW4qulXo/NNJpzcz6eMMxESXgHVbJ0MOgwy3JiA4EtOnDVfxxLiDkhmfJcnsELsXC7Fb2mWAoCQxjyI6dPFVYGGP7+FmiYbbAsj6PJ4N7wZ1mkY04Y0fwG1LT8OBBrpsVlluUqfsqQ9doFkT+9Dom21tx87gI+vjHQEc/Ks+kwbnsIjQeN/pqN4qSs3MW3M+igfxamWWpEkS+6Feo7djw6WDCefdKsHS5L+nYBOGuQ+s6IC81LsNLt/3TE5L2zeyNBAHQDR9u
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abc0b9bd-60c0-4a0b-6a19-08d78249a503
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:01:51.2171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N5JMUTVcFKF3i0y044KhbTw5AR7R2jDcJIXLu85GdRvOspAn/+aJOiyFkIG9tO6OrIInT1c/jf+md2Wg7wTX4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3014
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks to the similarity between PRIO and ETS it is possible to simply
reuse most of the code for offloading PRIO Qdisc. Extract the common
functionality into separate functions, making the current PRIO handlers
thin API adapters.

Extend the new functions to pass quanta for individual bands, which allows
configuring a subset of bands as WRR. Invoke mlxsw_sp_port_ets_set() as
appropriate to de/configure WRR-ness and weight of individual bands.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---

Notes:
    v3 (internal):
    - __mlxsw_sp_qdisc_ets_replace(): Pass the weights argument to this
      function in this patch already. Drop the weight computation.
    - mlxsw_sp_qdisc_prio_replace(): Rename "quanta" to "zeroes" and
      pass for the abovementioned "weights".
    - mlxsw_sp_qdisc_prio_graft(): Convert to a wrapper around
      __mlxsw_sp_qdisc_ets_graft(), instead of invoking the latter
      directly from mlxsw_sp_setup_tc_prio().
    - Update to follow the _HIERACHY_ -> _HR_ renaming.
   =20
    v1 (internal):
    - __mlxsw_sp_qdisc_ets_replace(): Convert syntax of function arguments
      "quanta" and "priomap" from arrays to pointers.

 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 104 ++++++++++++++----
 1 file changed, 81 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers=
/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 135fef6c54b1..d513af49c0a8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -471,14 +471,16 @@ int mlxsw_sp_setup_tc_red(struct mlxsw_sp_port *mlxsw=
_sp_port,
 }
=20
 static int
-mlxsw_sp_qdisc_prio_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
-			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
+__mlxsw_sp_qdisc_ets_destroy(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	int i;
=20
 	for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		mlxsw_sp_port_prio_tc_set(mlxsw_sp_port, i,
 					  MLXSW_SP_PORT_DEFAULT_TCLASS);
+		mlxsw_sp_port_ets_set(mlxsw_sp_port,
+				      MLXSW_REG_QEEC_HR_SUBGROUP,
+				      i, 0, false, 0);
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port,
 				       &mlxsw_sp_port->tclass_qdiscs[i]);
 		mlxsw_sp_port->tclass_qdiscs[i].prio_bitmap =3D 0;
@@ -487,6 +489,22 @@ mlxsw_sp_qdisc_prio_destroy(struct mlxsw_sp_port *mlxs=
w_sp_port,
 	return 0;
 }
=20
+static int
+mlxsw_sp_qdisc_prio_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
+{
+	return __mlxsw_sp_qdisc_ets_destroy(mlxsw_sp_port);
+}
+
+static int
+__mlxsw_sp_qdisc_ets_check_params(unsigned int nbands)
+{
+	if (nbands > IEEE_8021QAZ_MAX_TCS)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 static int
 mlxsw_sp_qdisc_prio_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
 				 struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
@@ -494,30 +512,36 @@ mlxsw_sp_qdisc_prio_check_params(struct mlxsw_sp_port=
 *mlxsw_sp_port,
 {
 	struct tc_prio_qopt_offload_params *p =3D params;
=20
-	if (p->bands > IEEE_8021QAZ_MAX_TCS)
-		return -EOPNOTSUPP;
-
-	return 0;
+	return __mlxsw_sp_qdisc_ets_check_params(p->bands);
 }
=20
 static int
-mlxsw_sp_qdisc_prio_replace(struct mlxsw_sp_port *mlxsw_sp_port,
-			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
-			    void *params)
+__mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+			     unsigned int nbands,
+			     const unsigned int *quanta,
+			     const unsigned int *weights,
+			     const u8 *priomap)
 {
-	struct tc_prio_qopt_offload_params *p =3D params;
 	struct mlxsw_sp_qdisc *child_qdisc;
 	int tclass, i, band, backlog;
 	u8 old_priomap;
 	int err;
=20
-	for (band =3D 0; band < p->bands; band++) {
+	for (band =3D 0; band < nbands; band++) {
 		tclass =3D MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
 		child_qdisc =3D &mlxsw_sp_port->tclass_qdiscs[tclass];
 		old_priomap =3D child_qdisc->prio_bitmap;
 		child_qdisc->prio_bitmap =3D 0;
+
+		err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
+					    MLXSW_REG_QEEC_HR_SUBGROUP,
+					    tclass, 0, !!quanta[band],
+					    weights[band]);
+		if (err)
+			return err;
+
 		for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-			if (p->priomap[i] =3D=3D band) {
+			if (priomap[i] =3D=3D band) {
 				child_qdisc->prio_bitmap |=3D BIT(i);
 				if (BIT(i) & old_priomap)
 					continue;
@@ -540,21 +564,46 @@ mlxsw_sp_qdisc_prio_replace(struct mlxsw_sp_port *mlx=
sw_sp_port,
 		child_qdisc =3D &mlxsw_sp_port->tclass_qdiscs[tclass];
 		child_qdisc->prio_bitmap =3D 0;
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, child_qdisc);
+		mlxsw_sp_port_ets_set(mlxsw_sp_port,
+				      MLXSW_REG_QEEC_HR_SUBGROUP,
+				      tclass, 0, false, 0);
 	}
 	return 0;
 }
=20
+static int
+mlxsw_sp_qdisc_prio_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			    void *params)
+{
+	struct tc_prio_qopt_offload_params *p =3D params;
+	unsigned int zeroes[TCQ_ETS_MAX_BANDS] =3D {0};
+
+	return __mlxsw_sp_qdisc_ets_replace(mlxsw_sp_port, p->bands,
+					    zeroes, zeroes, p->priomap);
+}
+
+static void
+__mlxsw_sp_qdisc_ets_unoffload(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			       struct gnet_stats_queue *qstats)
+{
+	u64 backlog;
+
+	backlog =3D mlxsw_sp_cells_bytes(mlxsw_sp_port->mlxsw_sp,
+				       mlxsw_sp_qdisc->stats_base.backlog);
+	qstats->backlog -=3D backlog;
+}
+
 static void
 mlxsw_sp_qdisc_prio_unoffload(struct mlxsw_sp_port *mlxsw_sp_port,
 			      struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			      void *params)
 {
 	struct tc_prio_qopt_offload_params *p =3D params;
-	u64 backlog;
=20
-	backlog =3D mlxsw_sp_cells_bytes(mlxsw_sp_port->mlxsw_sp,
-				       mlxsw_sp_qdisc->stats_base.backlog);
-	p->qstats->backlog -=3D backlog;
+	__mlxsw_sp_qdisc_ets_unoffload(mlxsw_sp_port, mlxsw_sp_qdisc,
+				       p->qstats);
 }
=20
 static int
@@ -657,22 +706,22 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_p=
rio =3D {
  * unoffload the child.
  */
 static int
-mlxsw_sp_qdisc_prio_graft(struct mlxsw_sp_port *mlxsw_sp_port,
-			  struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
-			  struct tc_prio_qopt_offload_graft_params *p)
+__mlxsw_sp_qdisc_ets_graft(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			   u8 band, u32 child_handle)
 {
-	int tclass_num =3D MLXSW_SP_PRIO_BAND_TO_TCLASS(p->band);
+	int tclass_num =3D MLXSW_SP_PRIO_BAND_TO_TCLASS(band);
 	struct mlxsw_sp_qdisc *old_qdisc;
=20
-	if (p->band < IEEE_8021QAZ_MAX_TCS &&
-	    mlxsw_sp_port->tclass_qdiscs[tclass_num].handle =3D=3D p->child_handl=
e)
+	if (band < IEEE_8021QAZ_MAX_TCS &&
+	    mlxsw_sp_port->tclass_qdiscs[tclass_num].handle =3D=3D child_handle)
 		return 0;
=20
 	/* See if the grafted qdisc is already offloaded on any tclass. If so,
 	 * unoffload it.
 	 */
 	old_qdisc =3D mlxsw_sp_qdisc_find_by_handle(mlxsw_sp_port,
-						  p->child_handle);
+						  child_handle);
 	if (old_qdisc)
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, old_qdisc);
=20
@@ -681,6 +730,15 @@ mlxsw_sp_qdisc_prio_graft(struct mlxsw_sp_port *mlxsw_=
sp_port,
 	return -EOPNOTSUPP;
 }
=20
+static int
+mlxsw_sp_qdisc_prio_graft(struct mlxsw_sp_port *mlxsw_sp_port,
+			  struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			  struct tc_prio_qopt_offload_graft_params *p)
+{
+	return __mlxsw_sp_qdisc_ets_graft(mlxsw_sp_port, mlxsw_sp_qdisc,
+					  p->band, p->child_handle);
+}
+
 int mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct tc_prio_qopt_offload *p)
 {
--=20
2.20.1

