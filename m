Return-Path: <netdev+bounces-779-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E40006F9E75
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 05:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1286B280E29
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 03:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B94A813AC6;
	Mon,  8 May 2023 03:58:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F9F101FD
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 03:58:39 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0339E3C24;
	Sun,  7 May 2023 20:58:35 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 347M5wHj013348;
	Mon, 8 May 2023 03:58:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=DmLdFf5GbKuXALcyl6r8ua9yPdo6+ISCb8BlbyVddbE=;
 b=Qv30NwiVM7/2nHwCGuOduv5vNFWjc+yJ5TUwBKwpnSlU3k2zkqvKbu0frwsZpb/YfhwJ
 fWG5CY+7nmmdeohNRlRLBhmrJZrB5J+n7DYN62lpH3oevbSUb/ORNZHu/QqIQ0vusyV5
 c2wBdaMpsQK+8IOAsXCdP1WP9BuGSlqwhZbFMU/l+7EO204tXH0m+I+1dT1qpa1QpZcR
 z6oWtDOUir32lfBOJoSyLdX3AwMgWkpwmjPkQXGBifnFHPOoMlob/JXrmrdSJUpgfbfx
 kY/QjtjojAX5dQFz7WsTIssUg87yu8NkVAf3zhPEhbjdbmVvAxI0AlguTNuI5cHSgjcG eQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qddae28nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 May 2023 03:58:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3483X1qx013808;
	Mon, 8 May 2023 03:58:12 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qddb45myp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 May 2023 03:58:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkOVpTkYE4gYuEF+evHdORPMTAM44M+g9O8mKLq98bPldXhn4NSON334pewr6xC6oLlYypjNEoSK7YFtqBazw2/mr5It6tZrCRy00CS47V3zuo2fRV+Kc2TURoF4ATq/5s4NYCi5dXdriX8mvzDDrCPuGm9ew0UjR8Qx5wyINMshMCxBB2z4zW//eYohrD55kQTdbdkOlC1tziM6J2TuoRYTENkdSG40vnOalZvJnsYc0wwUrtgW/jCMKEv3jRpZ3jafinci/QJC/pLnQ5EPCt8WB64gNHv7zDtVbvufpY8O0mCVZT21XFUoX/heoutj5LPpxIEMZDY5SOzIQQ/Zew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmLdFf5GbKuXALcyl6r8ua9yPdo6+ISCb8BlbyVddbE=;
 b=VQgdW2DgW70IijpVQND85F93ftZOLDSA1q9qsSmZ2pE1xDghQjYfhS2znKuUO7fpISUn/iqJ+1kPu+lMsuyB689S/NsYqEfwPq2a6iy+AQ5Cto2cO5jhj8nhJKGldrHQPiIsI12Y51JcHo86APU9QK5yayIrimU04Y9UYwSPJz7Szp/icrZl/cpQFJCZyQJAh1rr19D5frq5BRBL1bzRO7597+pdqJY8r5yrIaOFUaRdNIKzbkibQxjRkSp2bqDjm/ysK5zSZEVJZ1YCUH4q0t0fXFtARXiHa873eQ0sa4tR84dkSNA2V83+R0zafMPpKQ/0+If4cGitzWMdOM07RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmLdFf5GbKuXALcyl6r8ua9yPdo6+ISCb8BlbyVddbE=;
 b=xPPOlZ45CymNM+dBoNnyfdFkQriG+9t3YcRSqCg20Hj96pYYBGgIkmmeC4nMLthwkizi16oAYbZU7ANM8v4YPo47mCtcOXMlnzU/eoe8s5hF3Tw6U2+YFO+oITp3NkKyK8LpE8XRdXnm+QGvrzUme1/60og0YkSP4fCSH44bV0w=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA1PR10MB7214.namprd10.prod.outlook.com (2603:10b6:208:3f3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.31; Mon, 8 May
 2023 03:58:09 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 03:58:09 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Ding Hui <dinghui@sangfor.com.cn>
CC: "jlayton@kernel.org" <jlayton@kernel.org>,
        "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
        "anna@kernel.org" <anna@kernel.org>,
        "davem@davemloft.net"
	<davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Bruce Fields <bfields@redhat.com>,
        Linux NFS Mailing List
	<linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] SUNRPC: Fix UAF in svc_tcp_listen_data_ready()
Thread-Topic: [RFC PATCH] SUNRPC: Fix UAF in svc_tcp_listen_data_ready()
Thread-Index: AQHZgMQOKc4fcioBR0q2bzqWePFl4a9O7x4A
Date: Mon, 8 May 2023 03:58:09 +0000
Message-ID: <EED05302-8BC6-4593-B798-BFC476FA190E@oracle.com>
References: <20230507091131.23540-1-dinghui@sangfor.com.cn>
In-Reply-To: <20230507091131.23540-1-dinghui@sangfor.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|IA1PR10MB7214:EE_
x-ms-office365-filtering-correlation-id: 97cc5516-c80b-4047-e76d-08db4f786fdd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 HFugf7Cl3OM15oSJLJqfj7f1NZ7Y5hDdRtHKO04FOwoTZFHdEQUyeoNLRuNu9A09+1qg5KSjirgwYvnGwj4OZ+ZmXwqqFaMFvk7iEGb+FHoLaKy8GtY4qiTe8mTBCXxcqDUgBymsowDtsHgd63kYrmDnOS7jKYTzMBtktxM5zevxIFVyd/SGVn4SS3ZsH+Un69hSxgY/PGHJxf0QQd91q4STPteP47MNG60cFilNkRjuyIZfxU6awwZ1gw2ujeC+/i75GnGF8TrwX5Jq+vLokMr20axGawASSo9SiO+0dhHhZTsWWwt3EZI0bFriYUs+V02k945I1WfEy4x4Qh0I6dUgS24nMDiHXsvZIDfT34fJlafynB3OxQJAU4CDr9FY3jotj6MD74DDvNGCWpSoIUFOWsXHV2/UlBW3Uhjiasl2KEOQLM3ZJ37HaO+xq+carYNNlP4SmX5R9wQzHp7+sZW9/oq40MsqShVECXyxqwSuzIuxzvJ68mFGzvA1hby/Un0hrEcIgs7+Kc+1rvGPi7ge3eXjcmREY2xqJbTleaSv/pjgZgTSGj3nJRi92zZkhYNu4HOF1uh+6m1Kc1OZn62wv9LYPRpX+frUhuNmdNbP3ZJ83OzyDFqIAZYIliCf4UJuv11s+7gqb38aTaaSqw==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199021)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(6916009)(4326008)(478600001)(6486002)(316002)(91956017)(54906003)(86362001)(33656002)(36756003)(71200400001)(83380400001)(6506007)(53546011)(26005)(6512007)(2616005)(8936002)(5660300002)(8676002)(7416002)(41300700001)(2906002)(38100700002)(38070700005)(186003)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?8DB6IElHvTX296ohbwLqFhNYZFTNOQgSL+DUVvSmnyVREf9HYTHmMJ4hYdSF?=
 =?us-ascii?Q?OQuyomWVdh8je2BtzoPUq5NtTezy9diJDNENx2vZvt0nsr66P7rVpsk0JF+c?=
 =?us-ascii?Q?RXNrpXnLQ4XDfvVYUMT9DVxO7XYxVXVq4w+ePwRqHHUUsqYK94slnum9Uzrb?=
 =?us-ascii?Q?nv2IujLo8f5nSC8pV8UgNo56mldsO08YhGBmCcovUdoVQY2zSXynjwK1d8c6?=
 =?us-ascii?Q?rd1LPQCsMlMpn9GLQ0IzemKwlKPr2+VT1Ijtp9Lc8Wz3QyZN6NVjZN+TLAi5?=
 =?us-ascii?Q?olNtM6UzQO8wzSe2C/QUiYJ+qcZBJaFdW0hjLKfbMtRwU0xn0K3/LvJNyTlU?=
 =?us-ascii?Q?32DPm+aXtSN0aYmvr4Qzh7LibYj6L+ZVasBQGdg6/1ifAjfAO8rEwdFmXZoD?=
 =?us-ascii?Q?qW0TYnAocX4EVSqa2ns4GPYLQrxGnzLgQts6crZJtd1fHOduQBbdFNCXU8fH?=
 =?us-ascii?Q?/hWFdtwRNzTJrbGb56qSwbWg+GLEma8lC89tXS7KJiUC+6NJct6PPvEtR9Sx?=
 =?us-ascii?Q?tLjpSd6yKTQ05vK7FAMYzP4JROd5AbYqmjZJwgcsG52YpmINsKHVg0MmFg8p?=
 =?us-ascii?Q?JMUyKpWxGWQzkgVwbfX2FPNIj80f+tt8tzj+qCCBFXwf36Jro2YigPzqL4xp?=
 =?us-ascii?Q?t0nFLCbfj/LccXrP+CG6x4UDbhbudsQzDCvY7mNG0xdCUJamtjdIKIYjN4hy?=
 =?us-ascii?Q?1QPI1oWBJhOl/YJ9kF6QQG6L+4zzmXK5nNERxKmSl8TzlqGNqln5eMQEdfMu?=
 =?us-ascii?Q?PDC9gH5M4BYnkDxH55ZtTbG9/QKOq2hqMO5ZtKnhnXf8LmqcErMahZb4Pwms?=
 =?us-ascii?Q?2BxMGxSiUYgMSuuLgyKU/9tHeeCWvoiYTso0IGkylJ4BdlHIPUsh+Zzbpkle?=
 =?us-ascii?Q?kJ69DrjWiBGchzkqQyzwA/sHGIsnXY4apDi42oYUN1/lPYYMJIzVwWp0OKSF?=
 =?us-ascii?Q?806BakV+guCfLZDYOrbZ+hYSIvuUEvheE/xbm86RQ/KLefDoDeQwGjL2dI0h?=
 =?us-ascii?Q?GzWiJpgrIW8VkJDhq3Dk+aUfYaNtUObQUcBXnkDNu3OcKkhvOeC9tVJR62cY?=
 =?us-ascii?Q?ILnkwsfSjAEVVdYR5/L+bd0q/SI1hFHdIR7kCqXzFfcL5n9aFwrjAeuWYma3?=
 =?us-ascii?Q?q3X2AMMjT5Zl5tnGaNjm7yyPk42x4ib/lBLsIpXjPc1vhkrcZ9dXTZATB8BN?=
 =?us-ascii?Q?M1hKTJJpxnc6eU5EYxR1bbOANHFlsiRdtENwmcH64CLqwjyCQI8BMvyLsbGE?=
 =?us-ascii?Q?jj8ElbH5GP8PiQb5hL7JIWJ2hjYMyZMDO1YDh6l13yVahhHOae1jQVghERqX?=
 =?us-ascii?Q?Z7OIO+MhAmatpvGIevD4ZvQjTljhOmel+hVwW+0BIbCfh6tu/Dmi3pSP7n+P?=
 =?us-ascii?Q?BBnpXR2XNh9Iqe/wya7SApKXszjIfliRmXY09qbBB17zx8ovqR2UDu7yxgy9?=
 =?us-ascii?Q?OyjoBa1/kjlr7zLyjF20mfMdGULrJTCA+ZAbrV8+DXRL0XF5N31iOsHYM7ei?=
 =?us-ascii?Q?+rdNdzIKl9aj272wVNrV/Nm4SdjeudXRElGn3njHUErK2xPpClE4l0GyRh6v?=
 =?us-ascii?Q?oeYHSvXgCAGMslRki7nYBcGZs2eHqUoalgpxF6eDpwH1qQRWgIu9NKhN+wat?=
 =?us-ascii?Q?fA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BC0381D605460E4DB3BC2C89A555A1B9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?lTDfl/UAso3s2KsHdQGy9d/8ZFffPasOpy7Zj1D4nI7tSfNoaBoEktiniLBp?=
 =?us-ascii?Q?EAyif8vOZkBNr/FeuZO82Z5ykzGVAZRQRWH2/bxcTzTFzATHoRNHzVvglCh9?=
 =?us-ascii?Q?i4v+BaZkliSxMW1T35jwsvt2BSpt++vhECXDjBxEmOhj3WvCWIA8NbETU1Ls?=
 =?us-ascii?Q?cY9Z3h05dGeR3sK+86p1lyKeZTRPJVB91mbbwMrWSKzcON/OnO8pcaCN+Z4+?=
 =?us-ascii?Q?BN5Kbb/cP2khJb/W5NHkqaB2oAn944o8ex/d7qobKlnn6b/GDXCU5MgvSlVD?=
 =?us-ascii?Q?p7wXmxoMYsNx89j9j5ZZy9wYF9ggC5v4FT050ce/ha2kVuYSdSQPuOVQg2/q?=
 =?us-ascii?Q?+9Hs8/haKTRC/4+tO+r43AzSWI2eb4kYiz6TiMxxQWBfWi4YN4lQKInpwGX4?=
 =?us-ascii?Q?Gp/lqtNxBWMusMM6w+t6uQvCcy2sXN938sJaUUPfrn2bA4LLIyVfsR4Rg6S2?=
 =?us-ascii?Q?EkN3Sf8tAj0n/KKirbp8ObiuGjhDhEZyQd6cHLsesptZHw+99ulNIxMobTCA?=
 =?us-ascii?Q?L6ZgHJXOiVdF9Y145B4s2209NeHRnK6843CYXe262J64hAQX57in72ICrEn9?=
 =?us-ascii?Q?iDIIsjKM/SSy36yY7fXTsW1yjC3i/yJ21evLUh5HL2zC2fMLT6yGWPl92ZR4?=
 =?us-ascii?Q?x+7PQ4Ng1zgc+VA/jdSQMBqLeui0lFuck8yCxYYACQR2FAqpoMEykFtOIEqc?=
 =?us-ascii?Q?MVTvekCnGw5yEYmZNkMk/GGnhFlhWRQRr3a9p9h3TkodimCtGoss6gSrFQlq?=
 =?us-ascii?Q?j0IQSBlGB/1QVtJGABQWXOq2iEND5Sq1gaK5Lz9jYUV6b0xynDK+HDET9N3n?=
 =?us-ascii?Q?Un/Mp+fSxS951l0OSmw8s+6xph4wPlT4dMeutFZocqyX7B1tYk4fxMmj4PMC?=
 =?us-ascii?Q?28CsQv0qARank5oG6bJwHKmAc9tcz/xWtfb5eOeNH1c2bAULsddyvyHf9ono?=
 =?us-ascii?Q?VQP3fFxHm4LcEOm2X8mlaQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97cc5516-c80b-4047-e76d-08db4f786fdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2023 03:58:09.3950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QxhRTiysMbn6YieVs/tjtxWmZvMU0V67SJVDVc4bzLfQqa0WYH0yWrntmQnR2wv0XUaqgmfhC6Iw7mHb/REpUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7214
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_01,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305080025
X-Proofpoint-GUID: M6EL1FsAxGORj_czROY_D0tSKrNXYcLr
X-Proofpoint-ORIG-GUID: M6EL1FsAxGORj_czROY_D0tSKrNXYcLr
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 7, 2023, at 5:11 AM, Ding Hui <dinghui@sangfor.com.cn> wrote:
>=20
> After the listener svc_sock freed, and before invoking svc_tcp_accept()
> for the established child sock, there is a window that the newsock
> retaining a freed listener svc_sock in sk_user_data which cloning from
> parent. In the race windows if data is received on the newsock, we will
> observe use-after-free report in svc_tcp_listen_data_ready().

My thought is that not calling sk_odata() for the newsock
could potentially result in missing a data_ready event,
resulting in a hung client on that socket.

IMO the preferred approach is to ensure that svsk is always
safe to dereference in tcp_listen_data_ready. I haven't yet
thought carefully about how to do that.


> Reproduce by two tasks:
>=20
> 1. while :; do rpc.nfsd 0 ; rpc.nfsd; done
> 2. while :; do echo "" | ncat -4 127.0.0.1 2049 ; done
>=20
> KASAN report:
>=20
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  BUG: KASAN: slab-use-after-free in svc_tcp_listen_data_ready+0x1cf/0x1f0=
 [sunrpc]
>  Read of size 8 at addr ffff888139d96228 by task nc/102553
>  CPU: 7 PID: 102553 Comm: nc Not tainted 6.3.0+ #18
>  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Refere=
nce Platform, BIOS 6.00 11/12/2020
>  Call Trace:
>   <IRQ>
>   dump_stack_lvl+0x33/0x50
>   print_address_description.constprop.0+0x27/0x310
>   print_report+0x3e/0x70
>   kasan_report+0xae/0xe0
>   svc_tcp_listen_data_ready+0x1cf/0x1f0 [sunrpc]
>   tcp_data_queue+0x9f4/0x20e0
>   tcp_rcv_established+0x666/0x1f60
>   tcp_v4_do_rcv+0x51c/0x850
>   tcp_v4_rcv+0x23fc/0x2e80
>   ip_protocol_deliver_rcu+0x62/0x300
>   ip_local_deliver_finish+0x267/0x350
>   ip_local_deliver+0x18b/0x2d0
>   ip_rcv+0x2fb/0x370
>   __netif_receive_skb_one_core+0x166/0x1b0
>   process_backlog+0x24c/0x5e0
>   __napi_poll+0xa2/0x500
>   net_rx_action+0x854/0xc90
>   __do_softirq+0x1bb/0x5de
>   do_softirq+0xcb/0x100
>   </IRQ>
>   <TASK>
>   ...
>   </TASK>
>=20
>  Allocated by task 102371:
>   kasan_save_stack+0x1e/0x40
>   kasan_set_track+0x21/0x30
>   __kasan_kmalloc+0x7b/0x90
>   svc_setup_socket+0x52/0x4f0 [sunrpc]
>   svc_addsock+0x20d/0x400 [sunrpc]
>   __write_ports_addfd+0x209/0x390 [nfsd]
>   write_ports+0x239/0x2c0 [nfsd]
>   nfsctl_transaction_write+0xac/0x110 [nfsd]
>   vfs_write+0x1c3/0xae0
>   ksys_write+0xed/0x1c0
>   do_syscall_64+0x38/0x90
>   entry_SYSCALL_64_after_hwframe+0x72/0xdc
>=20
>  Freed by task 102551:
>   kasan_save_stack+0x1e/0x40
>   kasan_set_track+0x21/0x30
>   kasan_save_free_info+0x2a/0x50
>   __kasan_slab_free+0x106/0x190
>   __kmem_cache_free+0x133/0x270
>   svc_xprt_free+0x1e2/0x350 [sunrpc]
>   svc_xprt_destroy_all+0x25a/0x440 [sunrpc]
>   nfsd_put+0x125/0x240 [nfsd]
>   nfsd_svc+0x2cb/0x3c0 [nfsd]
>   write_threads+0x1ac/0x2a0 [nfsd]
>   nfsctl_transaction_write+0xac/0x110 [nfsd]
>   vfs_write+0x1c3/0xae0
>   ksys_write+0xed/0x1c0
>   do_syscall_64+0x38/0x90
>   entry_SYSCALL_64_after_hwframe+0x72/0xdc
>=20
> In this RFC patch, I try to fix the UAF by skipping dereferencing
> svsk for all child socket in svc_tcp_listen_data_ready(), it is
> easy to backport for stable.
>=20
> However I'm not sure if there are other potential risks in the race
> window, so I thought another fix which depends on SK_USER_DATA_NOCOPY
> introduced in commit f1ff5ce2cd5e ("net, sk_msg: Clear sk_user_data
> pointer on clone if tagged").
>=20
> Saving svsk into sk_user_data with SK_USER_DATA_NOCOPY tag in
> svc_setup_socket() like this:
>=20
>  __rcu_assign_sk_user_data_with_flags(inet, svsk, SK_USER_DATA_NOCOPY);
>=20
> Obtaining svsk in callbacks like this:
>=20
>  struct svc_sock *svsk =3D rcu_dereference_sk_user_data(sk);
>=20
> This will avoid copying sk_user_data for sunrpc svc_sock in
> sk_clone_lock(), so the sk_user_data of child sock before accepted
> will be NULL.
>=20
> Appreciate any comment and suggestion, thanks.
>=20
> Fixes: fa9251afc33c ("SUNRPC: Call the default socket callbacks instead o=
f open coding")
> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> ---
> net/sunrpc/svcsock.c | 23 +++++++++++------------
> 1 file changed, 11 insertions(+), 12 deletions(-)
>=20
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index a51c9b989d58..9aca6e1e78e4 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -825,12 +825,6 @@ static void svc_tcp_listen_data_ready(struct sock *s=
k)
>=20
> trace_sk_data_ready(sk);
>=20
> - if (svsk) {
> - /* Refer to svc_setup_socket() for details. */
> - rmb();
> - svsk->sk_odata(sk);
> - }
> -
> /*
> * This callback may called twice when a new connection
> * is established as a child socket inherits everything
> @@ -839,13 +833,18 @@ static void svc_tcp_listen_data_ready(struct sock *=
sk)
> *    when one of child sockets become ESTABLISHED.
> * 2) data_ready method of the child socket may be called
> *    when it receives data before the socket is accepted.
> - * In case of 2, we should ignore it silently.
> + * In case of 2, we should ignore it silently and DO NOT
> + * dereference svsk.
> */
> - if (sk->sk_state =3D=3D TCP_LISTEN) {
> - if (svsk) {
> - set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
> - svc_xprt_enqueue(&svsk->sk_xprt);
> - }
> + if (sk->sk_state !=3D TCP_LISTEN)
> + return;
> +
> + if (svsk) {
> + /* Refer to svc_setup_socket() for details. */
> + rmb();
> + svsk->sk_odata(sk);
> + set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
> + svc_xprt_enqueue(&svsk->sk_xprt);
> }
> }
>=20
> --=20
> 2.17.1
>=20

--
Chuck Lever



