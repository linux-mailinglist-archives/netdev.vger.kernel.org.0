Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1DA45467B
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 13:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhKQMlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 07:41:19 -0500
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:4454 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229563AbhKQMlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 07:41:19 -0500
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AHCH35x001500;
        Wed, 17 Nov 2021 04:37:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=Q4AZ1veJgFNAK4rCMDxSk5INFm4LgzDXCrsWkgIlTMs=;
 b=suL5Z9c2F4lKYaKhNSzCPJD1yYGyP/R4hPN19VRg2V7KKmszOt++9ndALd5SoFrZ7NYc
 mkb80phPBg5fchcsmQ+nSYaYRVOW7YienDIJfjhX+6T0+J1s3K9TdPfm++qv0VynbQJE
 S4XYp0gkk9eC6VPozsM6+bO6yZvLPwEQuQx3rRXCrDXuQmVxBN2NA25TkhW+DIwx4XbI
 ugdMoj+i6lrOoycVcxzXrjzYpAHkY82yVXNvZsVlNfUvK5EyaF1zpt8+MrjjjDvI6Qh9
 Y6lg2Ru2VNmu9wadXfRj/o9Ow1DRgNYPmuIea7d1mo+baU+P946vBHzkHJ8dkz5nJogJ OQ== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ccww005x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Nov 2021 04:37:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJnuJWALt82742h9K9wpcDhhG8x81bs77U/yjO/HfWLYnVPcB2G9L1FCNt5rwwps72iscqPdchx0C1aL1gxZGUsBAjZ7Ja6MAeaPZAFFg0AgOt53MEQu0Xp/DLwYAXD7VWbuwW7I+DqU3WI1sui6/cpa6sfHqgH4aRiKjzjy+4oFxollGaoIUoZMuAHD5j/7n/1QYjgFkG0bd8dOuhIM08Gl6Rdqa8E9rxMWUsK7MqPslWa1BYxgX7Ot/X1wBBOspV3lE7m3LjnP9kssq1wIgJzVp6mFb9yCqqxQlV2vIcmqo/nYqWOamXzNB0GYupy9D3hWuJG87g9KBp14CFzKMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q4AZ1veJgFNAK4rCMDxSk5INFm4LgzDXCrsWkgIlTMs=;
 b=gkmla/q8hkp+1ZHqGo6xSiquw7p+Ca+ecaB/K2qQKjqZVvW9idzKd9TRbKL2mCGJiADoZLHOU+rmazeUV8y66Vs6FWjMWU4okgmC2Z+gHtb375TPCn2ZOU0juL+73Ivp7ydwXPU5BN14OrMryltP8FIOa7xEUD8Q2/W4Nn30ZGCguoXxPeEXnPobwT4ncgwiVmwafZmG6CIf80Jt6zQiORsL7QvqjTxnlasMXdUDSLn3tP0/e5K2mCMoRNRbNLf+F8rKtfBeZOKUxXEar8Tte/Qz+ohgb5I966AzXCgDeBJBghv7wPfh2NbVQJ3pZpSTWpcUMVeveXj/kTR9qf7/uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM8PR11MB5686.namprd11.prod.outlook.com (2603:10b6:8:21::11) by
 DM4PR11MB5536.namprd11.prod.outlook.com (2603:10b6:5:39b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.26; Wed, 17 Nov 2021 12:37:46 +0000
Received: from DM8PR11MB5686.namprd11.prod.outlook.com
 ([fe80::c439:a54b:3935:964b]) by DM8PR11MB5686.namprd11.prod.outlook.com
 ([fe80::c439:a54b:3935:964b%4]) with mapi id 15.20.4713.021; Wed, 17 Nov 2021
 12:37:46 +0000
From:   "Xue, Ying" <Ying.Xue@windriver.com>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Jon Maloy <jmaloy@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: RE: [PATCH v2] tipc: check for null after calling kmemdup
Thread-Topic: [PATCH v2] tipc: check for null after calling kmemdup
Thread-Index: AQHX2jotl85lhMqGjkuUe5aW5Kh/4KwHq1xQ
Date:   Wed, 17 Nov 2021 12:37:46 +0000
Message-ID: <DM8PR11MB56865CBD8366FFFE28E0A6D6849A9@DM8PR11MB5686.namprd11.prod.outlook.com>
References: <20211115160143.5099-1-tadeusz.struk@linaro.org>
In-Reply-To: <20211115160143.5099-1-tadeusz.struk@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30ed7933-edfa-42f1-d25f-08d9a9c70efd
x-ms-traffictypediagnostic: DM4PR11MB5536:
x-microsoft-antispam-prvs: <DM4PR11MB55360188959923D22B97BDB3849A9@DM4PR11MB5536.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Rs4Qgw7YJx76i8TeJP34cyOgpElZ1JNkjRBQWmDTJnyCWLyaRKl4qPf2VaaT2LX4L1AemjUczwm3wr+2PUIncq0sPEUsxk3hJshrZX0Ej3yxw94hK6dkLe0W788ImpDVtT6o60hFvgkoJQJxRFGhYK1oGwt9AGSkmfx31MGOF1tx7kiV7YSEJw3YNHEC2eN8KcmBtM/FiC+HihxqkqRstvfgWOcFS0DjRY0C5ynI4OLo0UdwI52z2OuG3zZa+WGwApNVV9asLUuqWYZhJkuaClhyjPvd9XcUbNAh+wIl0F8dpeT7MZm7vD/UGOkG6UZ51BC2VDAXT7tsnLelXx9Rrcir8eWEAyUoaFJk518HdyDtgkaGza6RdczJkkGdbjaJ5cW8DsEyiRJqpTOmE6ocg7zSVZ8tPl4c36sd/4z+QRCxpj3CxXeQKACurBW7tXGHHBImIZUeVeQ14gNKbD4hlnTxxtgqg0u0TALCxk/MYN0FsIvBQVcTwtzCJ0vR0droobIaK9vkjFqEpFQIuCY/Xv5QBvIBI3wH3TKya6UT3mRdnxhWss6JYWkzYIOhQaY3KNaZb/IPMPg5V+GdiIiPHJw4TXSEjurh9AAGtFn50j5LQ4tzvn96hFwCt+qVaq5LtCqzIIfwXBb+6s8YISjaD18OtqFreoeE7TwGm4M6fOaAtmX/7I61fHaDW8gQaCyFGoc/LGz+zImjLJ8FjVj2nA0HLEgCpdC+qdjczfizviyobzMzF6ads8Q2gTVwU2jOyKSc6ik42qtLOsD9k8GFxSo7xW6RKtW+pcVkOPPiwDTPt1Xqmw5NSqEW/ajh982
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5686.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(5660300002)(64756008)(66556008)(8676002)(7696005)(122000001)(66446008)(33656002)(110136005)(38070700005)(508600001)(966005)(55016002)(54906003)(4326008)(2906002)(186003)(52536014)(53546011)(66946007)(76116006)(86362001)(316002)(9686003)(8936002)(26005)(83380400001)(66476007)(71200400001)(6506007)(99710200001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IxYmxlOT30KeGrISUcE/YRNCw72+G5mskxrpPM2K7f9i77FiT2RckV0tbLOr?=
 =?us-ascii?Q?Ha1WlW0v9UQRQf79yE09QtJLCDI5NwlN5n4yFaibImx2WaP3OA6GFhNPOtfv?=
 =?us-ascii?Q?geBdNFO3vqcAdenX0QUqeTRkgD07iaBAazNqIuuAOEJ38s1dKzdDEKBhZHdS?=
 =?us-ascii?Q?KRomsmMG64CzqnBqmzMxiiyjUnfq+BzuCFKBQZUvLy8ROO8HJo6bM8yOvgg+?=
 =?us-ascii?Q?25+k9RxqpjegSRz2W5gn32OzTIv5gUo5Fv8WChSb1OA/79wbD4klDSpaqcLx?=
 =?us-ascii?Q?jagRyvBHxpRAFrmOXEteWgk9XT0GY6LfLTzrHuxR37AiUAK/Hh6QBUKEYdUu?=
 =?us-ascii?Q?hXFmJO1pFvW9Ag5KcJn/l82XaLNd78bWlAP2qBbrrDBavZPmAUMoIw98GaUy?=
 =?us-ascii?Q?Q7c1S1qxLaKiMi3K7QPpHlhN2WlEI/WOUdG53Y4Gx45CaCyGe7rPtd+yLqxX?=
 =?us-ascii?Q?xiIZmRMLglZRZz4msx/Vx3r8BDvsyydiIj30NQnQ0ikymIgeyR0tI8IVq6M0?=
 =?us-ascii?Q?f2+qly9Fo6S3OwpMkLjM00nvdGWqxpeaGUQI5reehW1nnUWCum/L9wUIavuo?=
 =?us-ascii?Q?opQj0JCxlRizhNBbdu60eHwAxkPWhw8P/u08Y5G2WowtYWjZBLfpGO4aOlJD?=
 =?us-ascii?Q?VK0bbMnvvgGdu8AnNTBfhwJPNk5/fbA5SKccDh8WVcdFsB9pYDU3vGo+LT0F?=
 =?us-ascii?Q?uAk1nMlsDFqiFk+Md3rJUokJ/AYMboYcx09dIyzJOv1i6WHwF3zKupwjVDuD?=
 =?us-ascii?Q?g45oMLRHvrncAVi6Ddy4psGLs7Yo2hpTmitMtXHYIetBvD0PBtZACoi1p+Fl?=
 =?us-ascii?Q?lGatfFHcJZueA920z4NE3VX6dP40q1QgOVo3R9ZNi0V17ot+tNNXJiwOmMKE?=
 =?us-ascii?Q?oLjnii2CJfOR6rsphhwFdeKwNbMe+PsImk+Akjin4/kLYwAvUTiPDQYrrM4q?=
 =?us-ascii?Q?7yP75JHDhNjReJU9Ozzwi66e55ravfPsCqyrjnRXUjwVWpN/yB4ePw8CoaRA?=
 =?us-ascii?Q?eKwaN5o3B6qk59eQ1TozA0Sxaj10X9TRe80omn7ErvpVAkgV4SAAZXAoeVuk?=
 =?us-ascii?Q?RUwZpF4XZwzJhdYOodBkKTptQ07iVJJenIi4fyX/c8u6g/yO5MRiLoUMBg5T?=
 =?us-ascii?Q?qE+zAc2NmjROswEaayOOvOBuKKa7aQCRuHdiOhTgMUlv9saEB4wn/+LoHn8x?=
 =?us-ascii?Q?tIbAjL8lSEdsIw1Z9IPavMa7Q7OmuH3UWTK2rY7oBQwZhUCKxv19SnBwqe01?=
 =?us-ascii?Q?xsUcdWmPPf84grjWSlOz8O6+MMd8nNVeWl8RDCJDl4C3JlGFjuno29wNtnrA?=
 =?us-ascii?Q?MW2N4MMH+mF0xJfqncUnidXKunmbpewnRKQPnZfo/TnhdXo6kr700QQAEwYp?=
 =?us-ascii?Q?NOtu+t8tdWYWmpBM36JKAP4QqQjFvz7ljmkGYr9u4BRMTTcWIZ5DVhyWDh6n?=
 =?us-ascii?Q?I8wnLpalNgYNWCA2GHPtXAZjdPxF3CLmNJQn+f0oa0NJ4T48IDV6FVoPA351?=
 =?us-ascii?Q?WjNGvjWDjZQQP1d/+nyaYzwUKWTErZ+baU/ZoBx6cyy2rvKXheQLC66BraZ1?=
 =?us-ascii?Q?hNraXokjoKxXTOlcAtjd6oQpNMZAKlRlXWyYZA3fdySYDTFo2yThgWg6TtxI?=
 =?us-ascii?Q?rj1M23kwDEfqOI5gzl9stKo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5686.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ed7933-edfa-42f1-d25f-08d9a9c70efd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 12:37:46.2875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vQo+ZeRgbl/ZR24w4/ZvlutBsdg4lbA/eoqZ2H3BSdJ/expCjd9GU0qJsTv61eMSwGps1dXZzjxFTqFgtxpI9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5536
X-Proofpoint-ORIG-GUID: DwA_ecA-iwYtgBB-yXfNLcgn-NoFsin5
X-Proofpoint-GUID: DwA_ecA-iwYtgBB-yXfNLcgn-NoFsin5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-17_04,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1011
 impostorscore=0 priorityscore=1501 adultscore=0 spamscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111170065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Ying Xue <ying.xue@windriver.com>

-----Original Message-----
From: Tadeusz Struk <tadeusz.struk@linaro.org>=20
Sent: Tuesday, November 16, 2021 12:02 AM
To: davem@davemloft.net
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>; Jon Maloy <jmaloy@redhat.com>=
; Xue, Ying <Ying.Xue@windriver.com>; Jakub Kicinski <kuba@kernel.org>; net=
dev@vger.kernel.org; tipc-discussion@lists.sourceforge.net; linux-kernel@vg=
er.kernel.org; stable@vger.kernel.org; Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v2] tipc: check for null after calling kmemdup

kmemdup can return a null pointer so need to check for it, otherwise the nu=
ll key will be dereferenced later in tipc_crypto_key_xmit as can be seen in=
 the trace [1].

Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # 5.15, 5.14, 5.10

[1] https://syzkaller.appspot.com/bug?id=3Dbca180abb29567b189efdbdb34cbf7ba=
851c2a58

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
Changed in v2:
- use tipc_aead_free() to free all crytpo tfm instances
  that might have been allocated before the fail.
---
 net/tipc/crypto.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c index dc60c32bb70d..d293=
614d5fc6 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -597,6 +597,10 @@ static int tipc_aead_init(struct tipc_aead **aead, str=
uct tipc_aead_key *ukey,
 	tmp->cloned =3D NULL;
 	tmp->authsize =3D TIPC_AES_GCM_TAG_SIZE;
 	tmp->key =3D kmemdup(ukey, tipc_aead_key_size(ukey), GFP_KERNEL);
+	if (!tmp->key) {
+		tipc_aead_free(&tmp->rcu);
+		return -ENOMEM;
+	}
 	memcpy(&tmp->salt, ukey->key + keylen, TIPC_AES_GCM_SALT_SIZE);
 	atomic_set(&tmp->users, 0);
 	atomic64_set(&tmp->seqno, 0);
--
2.33.1

