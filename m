Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1F44E4EBE
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 09:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242946AbiCWI4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 04:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242936AbiCWI4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 04:56:21 -0400
X-Greylist: delayed 429 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Mar 2022 01:54:52 PDT
Received: from mx08-005c9601.pphosted.com (mx08-005c9601.pphosted.com [205.220.185.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DF15DA46
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 01:54:51 -0700 (PDT)
Received: from pps.filterd (m0237838.ppops.net [127.0.0.1])
        by mx08-005c9601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22N4peb7031112;
        Wed, 23 Mar 2022 09:47:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wago.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=p012021; bh=dtAROhqHJPyLadgPSspTvlWH1MbF+LAeF3wSo6civ9w=;
 b=kgJzPQscLDz6Rj+BJInX5vWKjnR7Bgk0om5s6JAQzBRoD8ydwcINIdZ2qx6ftN44vm8L
 qkNgmfKyLD6d9rGGjiCPamhHrhOv/boXDXodnmWiP3laVEQmYQQ0TVHn5vHtO+UFqmLR
 BftRFU2WbCLotgbTEXCLgj7QFpSLu0TMUUHl4JXKzq52QhMiCiBQnSk/3cuXlgNOkHMv
 tfcTyGeGX+hGWBv4OOCa5F8gFFqcpw5oug6CkH4DkDox05O62mmXhQmm5MGE2/VUpfTF
 QYpkGRhjT6cB0ZNRt6Y4uEP1gY7GFkixKzYiCkUVgIavqHtuCwsoxZT5HZ9xmaKmsLQ/ mA== 
Received: from mail.wago.com ([217.237.185.168])
        by mx08-005c9601.pphosted.com (PPS) with ESMTPS id 3ey7t09thv-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Mar 2022 09:47:38 +0100
Received: from SVEX01009.wago.local (10.1.103.227) by SVEX01014.wago.local
 (10.1.103.232) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 23 Mar
 2022 09:47:34 +0100
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (10.1.103.197) by
 outlook.wago.com (10.1.103.227) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21 via Frontend
 Transport; Wed, 23 Mar 2022 09:47:34 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LlX7tzRncmN0Ov0N+AgmZ4XmD9A3OVWzp8B6ETkqE0VR11wRLcQtWyEmt6clufFjVFNXtH1lPAJxQ1cpOesEWU0PpCTg05yXX3IFZrA3L4jnYRV3DrRRdNGtfHJlvFyfvSsbcT81lx0s49WnwubDStmRw/XBO3uhYEdjnRh1hVWh7taMYWf/DurLxSf8rNNVzdXZvRlMs1fCycLpvtlqPeOeiHl2S/FlbVJeNK7v+/vXsP3VYMaavCdO+XGSV/gIaZmJip+vASB4F077kh+fBajArh21+p+Ex7M+lrQleG+Z2MZc84GHb9qGfcQh/CMXBiiqGHbRJ/rGyMSzEYg5pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dtAROhqHJPyLadgPSspTvlWH1MbF+LAeF3wSo6civ9w=;
 b=ILoKd4DfA21JbsziAh2rPXwWBX22EvoNzL0XjzK3EH0a4IK84fhOyjRW6BtoYZdUdTD2dR0p0QVLuQcqtq65ikCYN4rTSjMr3JlF/eOcNGWFQOYz5i04Q9YHldc9Ym4oVl+R+x+QK6Ebl0xKn58sojbRQWDxRTQJnMlTYIxGRjyZt8oesLI3aL6NmESzS7vfQuQyRBHtH26DE53+HaTW/Lheq1DmBlwABZry/mn9CSkm9yFKjwtw0WTIJuo6h4V6JbqG6Gglf4t/7v6q4Y+RFzwk+kVecLKtjcJ0WLzRnYM0yf3ovUT/+vBI2aLZz21+uOHjF7VkOmydWCmXWIivmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wago.com; dmarc=pass action=none header.from=wago.com;
 dkim=pass header.d=wago.com; arc=none
Received: from DB8PR08MB5097.eurprd08.prod.outlook.com (2603:10a6:10:38::15)
 by AM0PR08MB3236.eurprd08.prod.outlook.com (2603:10a6:208:59::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Wed, 23 Mar
 2022 08:47:33 +0000
Received: from DB8PR08MB5097.eurprd08.prod.outlook.com
 ([fe80::cc57:a7c3:cf03:e4cb]) by DB8PR08MB5097.eurprd08.prod.outlook.com
 ([fe80::cc57:a7c3:cf03:e4cb%6]) with mapi id 15.20.5081.023; Wed, 23 Mar 2022
 08:47:33 +0000
From:   =?iso-8859-1?Q?Sondhau=DF=2C_Jan?= <Jan.Sondhauss@wago.com>
To:     "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "vigneshr@ti.com" <vigneshr@ti.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        =?iso-8859-1?Q?Sondhau=DF=2C_Jan?= <Jan.Sondhauss@wago.com>
Subject: [PATCH v2] drivers: ethernet: cpsw: fix panic when intrrupt
 coaleceing is set via ethtool
Thread-Topic: [PATCH v2] drivers: ethernet: cpsw: fix panic when intrrupt
 coaleceing is set via ethtool
Thread-Index: AQHYPpKjIr8iUrchREGeM/mphxhjsA==
Date:   Wed, 23 Mar 2022 08:47:33 +0000
Message-ID: <20220323084725.65864-1-jan.sondhauss@wago.com>
Accept-Language: en-DE, en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.35.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d612c19e-bd88-4fc2-e16e-08da0ca9c5c5
x-ms-traffictypediagnostic: AM0PR08MB3236:EE_
x-microsoft-antispam-prvs: <AM0PR08MB323660E987077B93B7F246878A189@AM0PR08MB3236.eurprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AaliTK2+ffv41o7Oxu6AGiEI/LsB8hvmn3V0P1PLm5nRKnqRZio19BlB0mE/pN9Zig3i/hduQXXh7x0t4PaiXS4ZolMpu1G4hG2NCktyiCgix2CCE3+0xaJ1fBaSC0c08XxBMkDLFbU1ZIsAdUWzgBMDH17xoPOuPWwGjh6eguDtqd/R10Vi3x/4AlLxbkN0e8NjrGjkxLAkp9+XKZSSoaLPnma8ghx3FIIFs5EbHexvtSmZAjK3+vgrSW9yYJ+b5UmKc8J6/0MYrD2HdktdevOJpDzMAv0DMF7Y4rXMmsnKMtaKUHkG0uhKyj2TK4wp/R3q8NibxWbTY1hd5nOeUxncI/urFf0+pWE1893pv36hyZLALPw9OZ2TiweaAomba3YjhWR2AzlIDCD3vgEeWYnLUQCHT8pQ7amhV39W80Cf86gyhb17AYrcuLAJumc/a/gSvEsahpduJr2HwMEd/48qrlTLQxgfK+WC3uADP6dkwYDa7z1uPc7p3AEVm/pZNCC3PsSFyEiAuGzkaXk3/jz5xkI3vHdxLvzjOBtyZzy2RVhXflGBhOFr57zNm+SnPVlID5V024M8EdeBrTEoY5SqWLjv3/EKYs50RcJEjfqVYsUgnAEofWr5Zb1xmDbbqyGjg47fDzOHTwq+jui73Ix6rqzGahSCaLGGZO1AOhe4juHgGXrV+pRSJ5FXffnIccHGMq5bT8Zaak3aSgQ4Rg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5097.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(38100700002)(38070700005)(86362001)(122000001)(2906002)(71200400001)(26005)(186003)(316002)(6506007)(36756003)(54906003)(110136005)(508600001)(6486002)(66946007)(4326008)(66556008)(66446008)(5660300002)(8676002)(76116006)(8936002)(64756008)(66476007)(107886003)(2616005)(1076003)(83380400001)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?RhsJlkHaiDVe0VZr1Obd0whvjAu19oBYmRm3bH7YUDeohZBxWDjGbdu4qA?=
 =?iso-8859-1?Q?osinu3F6ub1ENdj5Zu05thkalxbm/5XegklLavRK2L6DdMzp5ntYHF7dee?=
 =?iso-8859-1?Q?0XH6R4mtudu5Nrpeq+zGC4WAlrpSq4YnG8V7+GXXwlZkYI0IVTGfximfdC?=
 =?iso-8859-1?Q?zdyRR1IcMtoiQwB9y5otZhdOKHc3qO9mpjZZZfcRHuVWXVJSksZMrX+2Hb?=
 =?iso-8859-1?Q?Y+6va2gNIebjTUD1edDIpqU8YFqHTL+T4giAkfrS10jAsr2Iq78JV3u58k?=
 =?iso-8859-1?Q?pM+OHhJLW8TJjG1mlG7K8nkxNw51nlXCf8oSR+J9bI1naXvXTkJ5vDsPuQ?=
 =?iso-8859-1?Q?S7xQBJtsVy+PPNu9XGiEGxNC+WW86D2c96foZ8HbkegNoWRpcemWDwMak1?=
 =?iso-8859-1?Q?fiLThw5WJ947h87Q2OltNso1FNdZQ5/PAGgXg/ny/ESX4KTuVZfRCCuKC2?=
 =?iso-8859-1?Q?T/u0tE1R3BKfjefIosnLZcwiUW2x+2mWspMxjiGcZAJtd5P33udQ13E+6p?=
 =?iso-8859-1?Q?roV3f8N9KG1cRejcik48zgLyuWxgOtE2NqW6N/wU23iJQoxrSCKA5ebOFC?=
 =?iso-8859-1?Q?KSr5toLT6UIx0izPTIvpOhTlYJyjavNPuO+Qh+wwDTQ9jUqRx/t0S+CXtM?=
 =?iso-8859-1?Q?jFqXhnudqEtTYZtIu9Jj7Xn0KWrsE2UjMRLV8bbCI9z7YrSiO+2wuJBd2A?=
 =?iso-8859-1?Q?JNGhDD7wrw3qwr4iQ3Qd5v68UoQTeNtdElvv/Rb37jmhfx8IqHcDwIqW2S?=
 =?iso-8859-1?Q?rblxStQPqs2a0ZgnMJG96Hfcg0z22OZIogJRuZTmK/cYn5do/ynGq7ckvk?=
 =?iso-8859-1?Q?Rb+rtrpbjsUOOc/iYlzwE80d1DHu3bYnDN1GKm+QPfLPCYWjdtT9h8j9uQ?=
 =?iso-8859-1?Q?B2Zk0ceGBjthLgEaw2LB5XI0tyFv8VGDIo946JQ67mlLHheaFczPW9PRnK?=
 =?iso-8859-1?Q?y6JQiz90TGft7on1xitcT83+tgEycZiFssOszJOBz7KWOEyC5ebF5XEFLF?=
 =?iso-8859-1?Q?ohw73+R2b69EICMA6G4/6y8QZy9mkz/uHEZF5CkWlOrza/avd5vqC2vCPp?=
 =?iso-8859-1?Q?JeIm9XbSTRAVIczxOGNyGyIQY21JoTeuHIXER6+6SeyuKhdW411rjzsW+s?=
 =?iso-8859-1?Q?vDkKibvqZeZdr/RVIsfWiy2gkbWOrsKRgnB1OXPIaRh1br9g9EhWr1VqNa?=
 =?iso-8859-1?Q?k5qahItZHMADL5MMS6wAQhQnQv7+GOF2BxP0/yeNCazIWSayXfp4TnItJD?=
 =?iso-8859-1?Q?forAP12rNVDln6UGieOpQpc5vweIGV5/flcwQ7mysF18u2g5SIbpgB031b?=
 =?iso-8859-1?Q?sm3yHT+X95vDLOhIxGkUGPO0KNnpv0ZpZJivyVBuTRDtWgJo+qL9hbGCSe?=
 =?iso-8859-1?Q?KS+maiB4zkBQAJ+jz4a6KJi+vrgJ4eQDLy91YyXFuYtK+6SEUYg2n6MULg?=
 =?iso-8859-1?Q?ABmJpPxTB7hXixIgTjDCOwYmKaa6uWQV85VLvFu5z+sYrLSzO10xz/qq/c?=
 =?iso-8859-1?Q?5lITX87xm4CP/1OaX1dm+BPdDeMdWylkPdiGtdrMxmVg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5097.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d612c19e-bd88-4fc2-e16e-08da0ca9c5c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2022 08:47:33.2651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e211c965-dd84-4c9f-bc3f-4215552a0857
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TZiXxL9OZf5uftJ5H4c+1ZKmT3uF6gGS37xVBOfknPhnBZ7pSydMdu3MJHP6AsRo4fHROneegmT845f6fLCj7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3236
X-OriginatorOrg: wago.com
X-KSE-ServerInfo: SVEX01014.wago.local, 9
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 23.03.2022 06:00:00
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Proofpoint-GUID: CqETP8jOQ969yEod1g2mlyq62-pwhN0y
X-Proofpoint-ORIG-GUID: CqETP8jOQ969yEod1g2mlyq62-pwhN0y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_04,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 phishscore=0 adultscore=0 mlxlogscore=809
 impostorscore=0 malwarescore=0 spamscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203230051
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cpsw_ethtool_begin directly returns the result of pm_runtime_get_sync
when successful.
pm_runtime_get_sync returns -error code on failure and 0 on successful
resume but also 1 when the device is already active. So the common case
for cpsw_ethtool_begin is to return 1. That leads to inconsistent calls
to pm_runtime_put in the call-chain so that pm_runtime_put is called
one too many times and as result leaving the cpsw dev behind suspended.

The suspended cpsw dev leads to an access violation later on by
different parts of the cpsw driver.

Fix this by calling the return-friendly pm_runtime_resume_and_get
function.

Signed-off-by: Jan Sondhauss <jan.sondhauss@wago.com>
---
 drivers/net/ethernet/ti/cpsw_ethtool.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/=
ti/cpsw_ethtool.c
index 158c8d3793f4..b5bae6324970 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -364,11 +364,9 @@ int cpsw_ethtool_op_begin(struct net_device *ndev)
 	struct cpsw_common *cpsw =3D priv->cpsw;
 	int ret;
=20
-	ret =3D pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
+	ret =3D pm_runtime_resume_and_get(cpsw->dev);
+	if (ret < 0)
 		cpsw_err(priv, drv, "ethtool begin failed %d\n", ret);
-		pm_runtime_put_noidle(cpsw->dev);
-	}
=20
 	return ret;
 }
--=20
2.35.1
