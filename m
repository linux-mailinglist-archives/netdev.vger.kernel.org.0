Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0853ED8B6
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 06:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbfKDFrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 00:47:36 -0500
Received: from gw6018.fortimail.com ([173.243.136.18]:21710 "EHLO
        harmonic.fortimail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbfKDFrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 00:47:35 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Nov 2019 00:47:34 EST
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2054.outbound.protection.outlook.com [104.47.49.54])
        by harmonic.fortimail.com  with ESMTP id xA45WRZE023235-xA45WRZG023235
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=CAFAIL);
        Sun, 3 Nov 2019 21:32:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6VCK59neUa4U3OOAwcucsLkDIwjv6cLmtYP2rWlUMZnc/hentbZyf0RFtPMXpfokYOfAwbuuoupHndW9nJV0tnBDchSecD+cqO1hbX0KueFn2//+dNN76BmH3ONW4M9r6hoAPOPKmX+aNeFvFaGgIxs5yop7EVZ8ar2Iydmf75Cxq8IhuvD5d9pnrrPwcT79pg5dEA0xoPmsm1JQgitdM52/T5kIvEdlYO80tYkxQ37fRCEtcGRW/zVCx0trSLAL7GzjabjmHYo2l6aJga98V52bD37jpQdbLggUY2lgPhMMcrqMRXC6jDEjgRE4dAR6ELtYpI7A+M0k9iV7MFojg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rtkmx5O/a3IIcY3Ql7JsAcfPH8MQ+NpaQ9YPveesUqQ=;
 b=OTUBwhmHPOQ0sbTFZDbHIi4Vf5TrO9XqOgQh1fJcDQIMUfSOn1sZ+/+yI6V3YSusZKD1h1SamXfe/cmIgX51iB3rERmfdXlVBW59iQaDNXpWA69rDsVwmiY3+p9QfDgPV+Z/ZQkfZjRldm4S7isSvcl5WpX54+37Pt0P9BYkk5BgtPgzL6ME5XP0iZ2+dJkDgSZmXHz8GTCTmvclwa9bbAEoQHGTZUJREJmpVufMZSfQVHZlzh7u/36GHASkhDttWXoGtVOGo3CKnxZJc/6MXvEDwYf4fMIKyGYHe0xoZVPla6f1JdrtbLH6b49r8b16pb3N4biFIxasZ/R+a+LvoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=harmonicinc.com; dmarc=pass action=none
 header.from=harmonicinc.com; dkim=pass header.d=harmonicinc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmonicinc.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rtkmx5O/a3IIcY3Ql7JsAcfPH8MQ+NpaQ9YPveesUqQ=;
 b=QPyO2llwEK9H5Ia3jJjQlya1rL7mswIYrifFboiP44q/DISiDrP+JTyt44vZ4yKoQHZsNjfBWLiVVjnadDWGjVUEFlHVxbqUmvkvKueG0Rmq2QnpWYZihanXkARUiqZLhby+x2jz/qdOKRATwmCq3gBCgl+cgEFFrRHizjBcB7E=
Received: from MWHPR11MB1805.namprd11.prod.outlook.com (10.175.56.14) by
 MWHPR11MB1278.namprd11.prod.outlook.com (10.169.230.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 05:32:26 +0000
Received: from MWHPR11MB1805.namprd11.prod.outlook.com
 ([fe80::b088:a289:bed5:850c]) by MWHPR11MB1805.namprd11.prod.outlook.com
 ([fe80::b088:a289:bed5:850c%8]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 05:32:25 +0000
From:   Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>
CC:     Arkady Gilinsky <arcadyg@gmail.com>
Subject: [PATCH net] i40e/iavf: Fix msg interface between VF and PF
Thread-Topic: [PATCH net] i40e/iavf: Fix msg interface between VF and PF
Thread-Index: AQHVktE9LXQEe1tn8E2yMWCX6YmauA==
Date:   Mon, 4 Nov 2019 05:32:25 +0000
Message-ID: <1572845537.13810.225.camel@harmonicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [37.142.125.24]
x-clientproxiedby: PR0P264CA0040.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::28) To MWHPR11MB1805.namprd11.prod.outlook.com
 (2603:10b6:300:114::14)
Authentication-Results: harmonic.fortimail.com;
        dkim=pass header.i=@harmonicinc.com
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=arkady.gilinsky@harmonicinc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Evolution 3.22.6-1+deb9u2 
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e5e8cd90-a820-4f3a-a4bb-08d760e85fd3
x-ms-traffictypediagnostic: MWHPR11MB1278:
x-microsoft-antispam-prvs: <MWHPR11MB12785692165E8A689FB0C527E27F0@MWHPR11MB1278.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(346002)(376002)(39850400004)(189003)(199004)(99286004)(25786009)(71200400001)(2201001)(316002)(5660300002)(103116003)(256004)(8936002)(2906002)(81166006)(50226002)(71190400001)(81156014)(6512007)(6436002)(478600001)(305945005)(7736002)(4326008)(6486002)(486006)(14454004)(8676002)(66066001)(6116002)(52116002)(26005)(2501003)(102836004)(6506007)(36756003)(53546011)(44832011)(386003)(3846002)(186003)(110136005)(86362001)(2616005)(476003)(66446008)(66476007)(64756008)(66556008)(66946007)(99106002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1278;H:MWHPR11MB1805.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: harmonicinc.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IZ3cqnftVMBk2FxXBTvp2GmX0qHJZScz0c9brPXbQdB/zJ3nRAM2Waoqe3N2xL+XN8MLx/q1nehqPLWsFM0As/D/mOq1SLpDfuzHpYDn94goWgjUYr1uPmcDShUoYOFY8B+1ex1AHB72TSehlTK3wSAMIu+InvryjPkFmtjdbWUyG49kLsLcxUZn7gB6M7gQy1w3UCXSbDFDy59z/45+S04/bkb+0zNL1Ei7rjaLgFim+mGiWXsyg2iiEAn1pdVHv3RGJ1cEondJxZpiVdbLv+SZQ2oBSunw5xf2iwZ/nuyT2Gpr7Sf7BPDpLQzH+SrM5MWt1yAbMnipFLAJS/s576GNl+tHL7jpOBKsig9TtIdOdzsyhQlbtQ8IbDFdYG1pMY/gYm66owJ+TmntBwza88s4GlEXxmxkeB+XK3Ky+INg2hsj4VVMGtO5dT4AIwk8
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <A70CA1D4FF25DF4995CC4C72D718069C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: harmonicinc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e8cd90-a820-4f3a-a4bb-08d760e85fd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 05:32:25.4688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 19294cf8-3352-4dde-be9e-7f47b9b6b73d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bNu3YUgdq0R0vaX8xizubK30LqXqfK/YTm25k8MMl7i1FsJc+yBj8kyQMccVMLyKQuRyoBwlkeh2sXKqFmDwVz0uk2qzFVWTpV/eYMB/QLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1278
X-FEAS-DKIM: Valid
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From af5ab2aaa51882bb7111b026882fe217ed81c15b Mon Sep 17 00:00:00 2001
From: Arkady Gilinsky <arkady.gilinsky@harmonicinc
.com>
Date: Sun, 3 Nov 2019 20:37:21 +0200
Subject: [PATCH net] i40e/iavf: Fix msg interface between VF and PF

=A0* The original issue was that iavf driver passing TX/RX queues
=A0=A0=A0as bitmap in iavf_disable_queues and the i40e driver
=A0=A0=A0interprets this message as an absolute number in
=A0=A0=A0i40e_vc_disable_queues_msg, so the validation in the
=A0=A0=A0latter function always fail.
=A0=A0=A0This commit reorganize the msg interface between i40e and iavf
=A0=A0=A0between the iavf_disable_queues and i40e_vc_disable_queues_msg
=A0=A0=A0functions (also for iavf_enable_queues and i40e_vc_enable_queues_m=
sg).
=A0=A0=A0Now both drivers operate with number of queues instead of
=A0=A0=A0bitmap. Also the commit introduces range check in
=A0=A0=A0i40e_vc_enable_queues_msg function.

Signed-off-by: Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>
---
=A0drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 23 ++++++++++++++++=
------
=A0drivers/net/ethernet/intel/iavf/iavf_virtchnl.c=A0=A0=A0=A0|=A0=A06 ++++=
--
=A02 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/n=
et/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 3d2440838822..c650eb91982a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2352,13 +2352,22 @@ static int i40e_vc_enable_queues_msg(struct i40e_vf=
 *vf, u8 *msg)
=A0		goto error_param;
=A0	}
=A0
-	/* Use the queue bit map sent by the VF */
-	if (i40e_ctrl_vf_rx_rings(pf->vsi[vf->lan_vsi_idx], vqs->rx_queues,
+	if ((vqs->rx_queues =3D=3D 0 && vqs->tx_queues =3D=3D 0) ||
+	=A0=A0=A0=A0vqs->rx_queues > I40E_MAX_VF_QUEUES ||
+	=A0=A0=A0=A0vqs->tx_queues > I40E_MAX_VF_QUEUES) {
+		aq_ret =3D I40E_ERR_PARAM;
+		goto error_param;
+	}
+
+	/* Build the queue bit map from value sent by the VF */
+	if (i40e_ctrl_vf_rx_rings(pf->vsi[vf->lan_vsi_idx],
+				=A0=A0BIT(vqs->rx_queues) - 1,
=A0				=A0=A0true)) {
=A0		aq_ret =3D I40E_ERR_TIMEOUT;
=A0		goto error_param;
=A0	}
-	if (i40e_ctrl_vf_tx_rings(pf->vsi[vf->lan_vsi_idx], vqs->tx_queues,
+	if (i40e_ctrl_vf_tx_rings(pf->vsi[vf->lan_vsi_idx],
+				=A0=A0BIT(vqs->tx_queues) - 1,
=A0				=A0=A0true)) {
=A0		aq_ret =3D I40E_ERR_TIMEOUT;
=A0		goto error_param;
@@ -2416,13 +2425,15 @@ static int i40e_vc_disable_queues_msg(struct i40e_v=
f *vf, u8 *msg)
=A0		goto error_param;
=A0	}
=A0
-	/* Use the queue bit map sent by the VF */
-	if (i40e_ctrl_vf_tx_rings(pf->vsi[vf->lan_vsi_idx], vqs->tx_queues,
+	/* Build the queue bit map from value sent by the VF */
+	if (i40e_ctrl_vf_tx_rings(pf->vsi[vf->lan_vsi_idx],
+				=A0=A0BIT(vqs->tx_queues) - 1,
=A0				=A0=A0false)) {
=A0		aq_ret =3D I40E_ERR_TIMEOUT;
=A0		goto error_param;
=A0	}
-	if (i40e_ctrl_vf_rx_rings(pf->vsi[vf->lan_vsi_idx], vqs->rx_queues,
+	if (i40e_ctrl_vf_rx_rings(pf->vsi[vf->lan_vsi_idx],
+				=A0=A0BIT(vqs->rx_queues) - 1,
=A0				=A0=A0false)) {
=A0		aq_ret =3D I40E_ERR_TIMEOUT;
=A0		goto error_param;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/=
ethernet/intel/iavf/iavf_virtchnl.c
index c46770eba320..271f144bf05b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -308,7 +308,8 @@ void iavf_enable_queues(struct iavf_adapter *adapter)
=A0	}
=A0	adapter->current_op =3D VIRTCHNL_OP_ENABLE_QUEUES;
=A0	vqs.vsi_id =3D adapter->vsi_res->vsi_id;
-	vqs.tx_queues =3D BIT(adapter->num_active_queues) - 1;
+	/* Send the queues number to PF */
+	vqs.tx_queues =3D adapter->num_active_queues;
=A0	vqs.rx_queues =3D vqs.tx_queues;
=A0	adapter->aq_required &=3D ~IAVF_FLAG_AQ_ENABLE_QUEUES;
=A0	iavf_send_pf_msg(adapter, VIRTCHNL_OP_ENABLE_QUEUES,
@@ -333,7 +334,8 @@ void iavf_disable_queues(struct iavf_adapter *adapter)
=A0	}
=A0	adapter->current_op =3D VIRTCHNL_OP_DISABLE_QUEUES;
=A0	vqs.vsi_id =3D adapter->vsi_res->vsi_id;
-	vqs.tx_queues =3D BIT(adapter->num_active_queues) - 1;
+	/* Send the queues number to PF */
+	vqs.tx_queues =3D adapter->num_active_queues;
=A0	vqs.rx_queues =3D vqs.tx_queues;
=A0	adapter->aq_required &=3D ~IAVF_FLAG_AQ_DISABLE_QUEUES;
=A0	iavf_send_pf_msg(adapter, VIRTCHNL_OP_DISABLE_QUEUES,
--=A0
2.11.0

