Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B270514754
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 12:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358237AbiD2Kt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 06:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358066AbiD2KtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 06:49:16 -0400
Received: from GBR01-LO2-obe.outbound.protection.outlook.com (mail-lo2gbr01on2106.outbound.protection.outlook.com [40.107.10.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B31CCABA5;
        Fri, 29 Apr 2022 03:44:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BORkrA9n+vGr+eR7C15z0WtTJ3gNsCsyL9y3t1CllSAGjikn88EhfHpBY+pCL+0ee3FcaZIJfh9i4E7KWwUxvFz2dcOZXympWVkNQ9SDHDzW5n8dTTxlksW/MRiSdVJ2+WzJ1kgYoytLrhxR11kdZgjGY3uJT1rBBHpzYZf+DVrbE3GWsjYO75suhr6xV24Rzw7JjbztvxIJcuLn92Qwpp7gp7QZlpMKN86pTu2VoAZnhvnkrt/uNSZI+vTa9GDmpNHe7/vnioiTDKVVb3n530vUtblandY4K3BNZNp4vFkpMuLCiLwG2Ofc7AjpPvCXrYWbYzrT5zMTWpI1Lohv5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1jv3A8b/jlzR1f3orh9FinfcD9ZCCwUSWYX0tGx6PI=;
 b=TBkSWSxJhATNwIGt39zCTp4MLnNZS9oueeaQ4K8EPpapJAJsqagb3+ogX+JmxY/ziYL+JzJRF11mumcb7hDoGV7tQYIEaHmCpsV5IqHU6WJ8LOyxQ3AEZ3df1X3Jir3YJbUGMNt9kIVQYVG5Ngj3csOu9GKW8ludU0oSLSmVYl0AdLdiVYoWzU2qJb0eetCIMQzieEecF+172wdPa4Xy93hy6v6oIrQ5k4R6RaP/x8rAQ7APv9WSOigiGULdzY9Xp7wcXp50eGR+hjmQTy+fQHWHNv49/+Oeael9jlc+5CvPOa4/jT6ttDUEjzZsGqDAF4sQ/6TQtaCpGD0Okubu9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=purelifi.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1jv3A8b/jlzR1f3orh9FinfcD9ZCCwUSWYX0tGx6PI=;
 b=nm9Rq4mU/UQjBqpYC4kQsdW4esKa7Ma3Csdhpl93IGeRtnf+eskjudBodfOfsw5+ZjCJJlIOKyt8NQpvYMQEYzrzSn6CcNTfDEgpYH4dH94lj1z70D4vYzPBNyXm5yD6kg9yKqTminoQzxdz4kUDxdx74DB09HBJ8FpjzrX1Tbs=
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:bb::9) by
 CWLP265MB6514.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1da::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.13; Fri, 29 Apr 2022 10:44:22 +0000
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::9d97:7966:481:5c10]) by CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::9d97:7966:481:5c10%7]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 10:44:22 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] [v2] plfxlc: fix le16_to_cpu warning for beacon_interval
Thread-Topic: [PATCH] [v2] plfxlc: fix le16_to_cpu warning for beacon_interval
Thread-Index: AQHYW7VCSGKUmXooIkS/HDoSbm90EA==
Date:   Fri, 29 Apr 2022 10:44:22 +0000
Message-ID: <CWLP265MB32172ACD5B2F2ECD0A512F0DE0FC9@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purelifi.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64e49a2f-e5fb-49d0-0442-08da29cd38e0
x-ms-traffictypediagnostic: CWLP265MB6514:EE_
x-microsoft-antispam-prvs: <CWLP265MB65144AA6DE4FF475F897B2CCE0FC9@CWLP265MB6514.GBRP265.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2PnyOTmK1IJ9pB9OD1KYw+TDWc1bCbjYlQWGBh70GJLLJA4BPyrSS/YPk5CCfJyC/0nWyKvXrQp5CvgppM2JUK9BYMO2A44s8S0SaVZquMfbAU8Sxy0J9SRPw0gYTgr50+/cWGFouQm66WgVa+FVJZUk1uGw/jsysucIeulATCDa4AXGq3/YiF5/XY284tQwMv4CR1cRi8Ykq4MGfV1boFucksuWaW9IZH4tdbqMj173XE1kSLjfUeBSdpTlQckOc/9txTVxT7b+WmxE9Bo5bsAAEkvlCLamc6KdJaM7sGqUlTvfLruyqigp47ZvRIefeDQWh1EWYeV4K8oH9UnCUT+BHo9MTXK/K+urVOp8ffll0qk+WW9GGq6ROvOOaVmLzIgAgRPJ26UxCDt495PqBJosBODj/LbuTPa+HVVFJ8C7xh+qk+Ik7UWBXWdaIjT5rJmv0C0R+q5HKWrk/Mtg9RghgGEh613KmFIvuMZ7nSmfj8W/oKtEGmiEHs5Gx6qfc1dGbl+r46IOwHTHbUtg1r5WHcqLcqA9suVXofpDJEz4QHjmbfRbKrCL3rqN5PfBrBsVlZG53wS2KfgLKpxhVLF0lmbAAwtNsioZKbtZUGj0AuaMX/HKUulg1C9Vqb6AtxEa4pGxl5AMh4VmHLq1JPLk9nr8OI00bsnDKxhlBy/MA1HqfZSzxtkpAJ6cZsqkeEwbxfk0exDOQPEp1fVCZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(396003)(346002)(376002)(39830400003)(136003)(366004)(66446008)(66476007)(83380400001)(66946007)(91956017)(64756008)(66556008)(5660300002)(86362001)(76116006)(186003)(6506007)(9686003)(38100700002)(38070700005)(26005)(2906002)(7696005)(8676002)(55016003)(109986005)(71200400001)(54906003)(4326008)(122000001)(52536014)(8936002)(33656002)(508600001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?kpUnt4q3f5EnvynyU3CoTqBmtdcQ2P5lHQwJIbkhVOZ4yyzSuW2pSycK/S?=
 =?iso-8859-1?Q?jdCGXYySILKFFAB/m3hUQ4f5AEqmSVpgMEBGas1mrXOScGLZeI/Uc0Hk9B?=
 =?iso-8859-1?Q?quVatOXrZRi2lcSrkTUXputAPyXHc6N++8qAWNGODVSZ7sTGMMPO7Eb5oy?=
 =?iso-8859-1?Q?PnU7t6c8PS6okqr1OjcTHX/T179aozuo/vVZ495JPvZVdoRF8Af3iqRpFR?=
 =?iso-8859-1?Q?jz+LGBIqOwOgRe17SbnbzZxanOwhfzIgVrvcMpapTy1KodggwEoAQzbM8e?=
 =?iso-8859-1?Q?bMQnBr35ypVUZViTwSUoiw863TavY46ABL+OL0poLHP0zkY8O5GtIIoIQ3?=
 =?iso-8859-1?Q?N5NUBknj5U4WFUC9wf/Mk28P+cJ+rmgmFYUG1Lrm0df3PH8Ab/d8ihoJfK?=
 =?iso-8859-1?Q?HZ1QyutopI4p6DC0NH5RoHuJ7xDFk45PxbEVmn4nNpveqjw7HTGDqYp98J?=
 =?iso-8859-1?Q?xc1RR2awM5YDULJUAL/hl2NeDzcdvY1HvTBvUs9cofzgRZIh1EmQMUR4UL?=
 =?iso-8859-1?Q?jRKPO4GS9nKaCBD0DEJapEpOnXIJWHZmKn6a7j5AdcD6qboLLVsa1BrdBr?=
 =?iso-8859-1?Q?CxMfoY2j39dK1DOu4YY/WxiYamgleSS3BERa/nx3SdgEIxBhIO+dMqtWgb?=
 =?iso-8859-1?Q?fiPZCtD58Oj3d88ybVqqILF7bg4GCJ0qVgHEv/B17pA28NNjbrBfdu6zEq?=
 =?iso-8859-1?Q?A+uHff7X6vy0jTdk45uKxRDBRfssFD/tlE03whpKGRGDzPeSxgvA+3XsFC?=
 =?iso-8859-1?Q?gHnzKfZLEa2IbvDW8SpWk+Sodbo21BjdpkVgjXPaJ9f2aiRel52l7DOpOT?=
 =?iso-8859-1?Q?5YKI5s+2FNWiCi8ySvBidW0WTdFOgxWifndWXz8tjMcbNA28c7/aDKtWf0?=
 =?iso-8859-1?Q?kBB7uKEnNRSSaQm/OwXr8LOk1ErNkgbied4C8/WALWUyRZX7fVqnJZ4sfP?=
 =?iso-8859-1?Q?BIU08iKKyIP9soyCIfSp2LSod0YxyDVOYOW2bioUiXFzQjla4AbjIEETJy?=
 =?iso-8859-1?Q?SeRaXxDKgMfqoyjKoYvK44rcOwXZcCI3Ct2sAiUsq7xoM1SY0ZKmMsYujR?=
 =?iso-8859-1?Q?Rawa0CezXafMVOr4pcHcHz245cZA0VxJunqP2Xwj0XJ8hMtUU3YxOJuKF5?=
 =?iso-8859-1?Q?z464lbtOY3R3F137ypdHolylit2SnXJ3gAvfBsHK4OsLmBQtPL1g8+8sdO?=
 =?iso-8859-1?Q?9i0gZiOHcUqc4MtDgZGCFDNGyxghygGFfZJOaTANCuqh1jIs4zVOzAiQ9k?=
 =?iso-8859-1?Q?WfAWa8Arl4GsYUGb9BvCxKyKx83uCfuOrf3/XGcyalOSTK8cj8nP/aTNMc?=
 =?iso-8859-1?Q?XcWQDpsCPtFYOFJd0irZWgXQ5gqPY7/3dzfsiiJ0m6MAJ2iQN+ssDVgKUJ?=
 =?iso-8859-1?Q?rG4hb1zEJ+AfRBaIXeZ0eU4oxCT9LakMCiTIWcWj8fLqK08ZOnV08LRg5A?=
 =?iso-8859-1?Q?AZEa446hbCNqX/Ae5uefrfMee8PMqZLca0uFj3mTAF2tpar0oBhcSQwuIC?=
 =?iso-8859-1?Q?zLSZeJZz7147/cQMb6d0ypBzXZfhKwD2sm6npRbeFXLDakeKkkfwWsmbOd?=
 =?iso-8859-1?Q?JQ4X2Bah+2ZaPkBl9t69IEfr0wz2MCoVMTBi55qDI6xRC1OVVn3w1Gb0tp?=
 =?iso-8859-1?Q?BaCegQqdCV1d8MuHvxFhKo8Q7+2OBRM2n49Xhh+yIyO/pklcgEhrWevGIZ?=
 =?iso-8859-1?Q?Y0/BrR6q6uUVx5ZyuSKDoDP0hSbjz7J6Abl8sHQj3wpQobZL+GJmlzifgy?=
 =?iso-8859-1?Q?s7VtF4Ns5HrAR2HdpFITBiNpfFovAhKhHrTmVvz588YSxjFXY5XtQ2VeOw?=
 =?iso-8859-1?Q?6a6tNPOnrQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e49a2f-e5fb-49d0-0442-08da29cd38e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 10:44:22.5430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BxKqbVAcG62hv0JnL/SpCB4NUh92jyRElkYhcyckxh7etoTh5QPzMagH8rX0dp9x+mhPZyTeem7lx5hRe77Y7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB6514
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warnings:=0A=
=0A=
drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: expected unsigne=
d short [usertype] beacon_interval=0A=
drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: got restricted _=
_le16 [usertype]=0A=
=0A=
Reported-by: kernel test robot <lkp@intel.com>=0A=
Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>=0A=
---=0A=
 drivers/net/wireless/purelifi/plfxlc/chip.c | 5 ++---=0A=
 1 file changed, 2 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/drivers/net/wireless/purelifi/plfxlc/chip.c b/drivers/net/wire=
less/purelifi/plfxlc/chip.c=0A=
index a5ec10b66ed5..79d187cf3715 100644=0A=
--- a/drivers/net/wireless/purelifi/plfxlc/chip.c=0A=
+++ b/drivers/net/wireless/purelifi/plfxlc/chip.c=0A=
@@ -29,11 +29,10 @@ int plfxlc_set_beacon_interval(struct plfxlc_chip *chip=
, u16 interval,=0A=
                               u8 dtim_period, int type)=0A=
 {=0A=
        if (!interval ||=0A=
-           (chip->beacon_set &&=0A=
-            le16_to_cpu(chip->beacon_interval) =3D=3D interval))=0A=
+           (chip->beacon_set && chip->beacon_interval) =3D=3D interval)=0A=
                return 0;=0A=
=0A=
-       chip->beacon_interval =3D cpu_to_le16(interval);=0A=
+       chip->beacon_interval =3D interval;=0A=
        chip->beacon_set =3D true;=0A=
        return plfxlc_usb_wreq(chip->usb.ez_usb,=0A=
                               &chip->beacon_interval,=0A=
-- =0A=
2.25.1=0A=
