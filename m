Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC836455FB8
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 16:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhKRPpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 10:45:00 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53220 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230376AbhKRPo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 10:44:59 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AIEYDMt026889;
        Thu, 18 Nov 2021 07:41:52 -0800
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cd802cdq3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 07:41:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJbsELRbYaaikrME8uKgYQI/3fiTKMqyWCI0w35tNNwo0+Qb1VXvEC8VJrPinC+m9f3BGSjc8AWU6OzrkPjJ+d2FtmAvDNtvB23PB1h39XWLSRJoq2sbWg1bhqrppB2KX2P+Vy0+mHNZNZmu+USWcVC1SgMIySKM27KyNnmFdZVQzF4ZJArGym/MdTTWZ0ei0JhNu0uuWF1+qsn3vwPg1Nde0owiLhv6LIMz63yhjyM/RUtiiV5ymvQI540j52BdGLcol6PBCapPBUjmeWq0QbCzYZ//OlOhEGi53yOn6Kg4R88aFPBxrpnTGF2sO7JeQthAXxkZRBaCg5Qsyok/7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFgTKFXVonStw4hgDLsfwwUd725MWZF8dLOmDeO4iA0=;
 b=R0Lc1rxOmGGzr++ztuR2UyziRaaK4BFFJIy3cAU7DMz2ce8n6P7PGnYfDnDqHdyXZZ9DrbTtTR1ZNYzc07BbEwniUmi6luDuSd8H/AC6EX11NWKkQQjkh4wkrXitbPjyk/1fgyxXeU60GYhPHRs26V60k72NzhzrDrH+BAKdJDja239719smI/f431cHsmLVGPoH6f366x+G24j1K6GqAF2YuKfYUP8e7qUs837VXuDWXcoJtM6+R/4gOpuK1Py7SAV3GetSMQXJXITG5jyMiL2mMZh54bi8vTkgFvUqE2m6DoHoT3Ak1VihTSNf0SScrPQamxjDOwJRQUsNlUO3Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFgTKFXVonStw4hgDLsfwwUd725MWZF8dLOmDeO4iA0=;
 b=NH7GH/b2Qf0VM6OxwXf2AC5AVoAwN1kz+uE/6kIH1dTvH1gjftXOo1ydP2FW+q+8Zu1Y2iT5ZlKyzvfCR+d2dZYmMVDFGNGE9TtQ4Hr2s51lg+8sWtB7sHXuQPLXGi2p+aDI0VyxOGK81fVgUGh0kSl/5SjhpmYfJA+AitqOQBM=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BYAPR18MB2903.namprd18.prod.outlook.com (2603:10b6:a03:10d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Thu, 18 Nov
 2021 15:41:49 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::f5d7:4f64:40f1:2c31]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::f5d7:4f64:40f1:2c31%5]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 15:41:48 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [GIT PULL v2] linux-firmware: mrvl: prestera: Update Marvell Prestera
 Switchdev v4.0
Thread-Topic: [GIT PULL v2] linux-firmware: mrvl: prestera: Update Marvell
 Prestera Switchdev v4.0
Thread-Index: AQHX3I6Bw+UkR9aHykq17j+pfuWtug==
Date:   Thu, 18 Nov 2021 15:41:48 +0000
Message-ID: <SJ0PR18MB4009A38C84F0529CFA8B8FD3B29B9@SJ0PR18MB4009.namprd18.prod.outlook.com>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 17f2d3c3-ca6f-9a92-3642-d3a311d90a57
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8ebf4e6-e31e-4140-cbcc-08d9aaa9ef30
x-ms-traffictypediagnostic: BYAPR18MB2903:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BYAPR18MB29032EF09AC43D1359F269E8B29B9@BYAPR18MB2903.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:376;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cs1G/kA8srpQci/AXvGEesxsoJzeFi4wnxvf+l0zik0VeZj9rpJIbfzuw4vkMJFKBzkQtORsJreXYw2OE/dWHv3cWOKx8TaWBx6YWMPDn6nOn0Xiz8KSlzpJzO+qVDsUN5AZi30Dek58X7UY2s7VtzovSoE/2I3Nyh0qcKCWlPQqLCvJvqMsjJ9TFFZSemgoLgqHYh+C+7k2p7AnyRFradmLOx4Ml72+kvAGvW0wb2cihuMqp6pg/RtO0PwU3he6XLsyNkm47/x1kGHTRx/0UI+ahaly3ULOM0ue13JbenXbfTSGiNa+JslKof+dyN4FLyXyoUG29kRXczD3nPk+BZzYuasUH/MWVyrPBD2Iq55WohA6mwpVTAYV5BtaehK1RgBP2WCUBPzI04hzbMh+mDXbEUBg4p3xWaLOyyWh26mEJ5xNYKfxyaD/Il8aezQoZ5wDNPua0KPUAWjoEoUMjKIdV95BQM/O7SNrPpkwkJTRHAXgXWCDK0wq+TUjosgRNWLco/oyEc6x0nYpY8V9OP+/8en2SNEJur2PDziy4DjMkSIm+iggZZ2YTAb8DSqtCfvOqcU0yN2nsIPwHLPHufCJG6ZgHLZ1CZlGmL9AFh3H0Zm47ySHG8HKJu9Gf76cAMlQDZWVlkL8qj0rCDq7a4iMxIWClvzgJBEY1L5A6WTw9iXndhE5s3D/FrO07FwSBoXabHjpQ5SOLt1+trBWSlZX4O1ta7V49U5rbAK6PYeJLhoz1ZbRTL3gXKgKScB06lzmrF3Q8kR2+LXxmP4Vpccj8dfLZRWsHXichsXloxw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(9686003)(6916009)(508600001)(55016002)(8676002)(7696005)(966005)(5660300002)(54906003)(38070700005)(15650500001)(122000001)(86362001)(38100700002)(71200400001)(6506007)(4326008)(52536014)(8936002)(186003)(26005)(83380400001)(2906002)(66556008)(64756008)(66446008)(33656002)(76116006)(316002)(4744005)(4001150100001)(66476007)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?l3VN2i0Uu8HEKl4bGHKd6T+tnzAyOsRztyopWWd3lEmf5qkOzEgqUJ7SyM?=
 =?iso-8859-1?Q?qaB2sCHczVSRcsfL/ftpAM7igyyaXMnBXwIdqBXq8Ahm98OQcOrj3DyUlf?=
 =?iso-8859-1?Q?LbXdcovBjpAq5ebmh8PpEK2tsw6sv8Fd9xFLUFMJ6AGw3glYTJ8+IqMNOt?=
 =?iso-8859-1?Q?tKf0iW8OagNNBK+UUJJk8zkAign4twRtCNAvZtBt0nxU0mI9t05BsJxpvX?=
 =?iso-8859-1?Q?I6K1Tce/HnNG55wKXl9qed5nIFkO6LlEhFYL38+IIMbemo6Rlm74jx+5q7?=
 =?iso-8859-1?Q?PqAvnUY53pKLkTsZ/LYPN5MG5ZeJo+LhMIH6g853qJyWb7tt1VXsfzU1hB?=
 =?iso-8859-1?Q?/wt/hgztSpcHz/v0Y0FefoVgyB6MPQN9htAXskJL9XiyFXhdUNb1G0zroe?=
 =?iso-8859-1?Q?aAKXAMSFSzGs92dFfv+HAHYjXGkzhI/ru2pTDsi0C2ItEGgODu6b5NohvL?=
 =?iso-8859-1?Q?YZEG4Pnm+4+XSmoI8iwmQ6SGouLYxV+zOiiUhCcYYzr9bDCfbkZF0bURPF?=
 =?iso-8859-1?Q?YGzQDfZGjC+yxvCKkNKIVd42Am3oPCc90XrLQdR17LMyqKGL1MrTrBKPQU?=
 =?iso-8859-1?Q?nP+UJ9vRzVwl3+3SQbec3XNaZXHiducwMxnzf2Cfz+V6zWFWGQ4ZP8TCpD?=
 =?iso-8859-1?Q?0EvyMr3Zhp4xIsTQadZQJ7awNMkFPD5sZ3urbh1veI/JNW+GPFpfzy6QdN?=
 =?iso-8859-1?Q?hlZ9wRG78OxklDxDOt1w6HJxkLyqoRhH7UdCk81ntlMyxm+ELMdQMr55mv?=
 =?iso-8859-1?Q?dWWvgEQ49ck3jJpB0ankzRaIu929I8ww5uCmgw7NdnqOklYLaPj6Ao1UPg?=
 =?iso-8859-1?Q?dIcSL+uhxhWGdImXo9eVUu8e4v26UFOYDIGhxEBGC+LxxR/Zpz20qdMish?=
 =?iso-8859-1?Q?3VtTWXiNByeP04lqNfkkyMwzANtvwnTFnvEw7nVxkRCpVhBzbQxDVQpBWI?=
 =?iso-8859-1?Q?pVZHsjhteVenJX86cRct2UVpYvCHvfHrX4SCRazSMfMsFYNr7XbgtO7iF+?=
 =?iso-8859-1?Q?gkAx79BgXFMsO05HN5QK5whzr7zdcM5VGZJy/DROtKLw+TZU9Pjmxpid/y?=
 =?iso-8859-1?Q?z3epOAVf47noWZM3iTuN8v2uAfEGXBxrDjV61CgaFEzUi2qbLMPJ7zUJ8t?=
 =?iso-8859-1?Q?x0LOEhLPvAj2l1JLNEj+gFWNsU8Z1XYvqZ5PakDbj5Gl/sbqjpds/SlUOq?=
 =?iso-8859-1?Q?SdIbNgDcHPyzvFYoYvmttnaXHDg9n944LhZi+2y4xQc2aMNWMsgl7xVNaZ?=
 =?iso-8859-1?Q?OyGMbeTmkvVOhUrp7vABd8qsGV1vsaNTfrbpTGU518Xn6QHIg39TWZaLil?=
 =?iso-8859-1?Q?+xdC9CQ2QQTWCJLy24petnt2uL9WIfm+8rTg+46j+0VKFF1H0VRxgWE0YU?=
 =?iso-8859-1?Q?YBnGNXU/q/mAMwGe49pINYyfktUhLjbGfkqeumZajbUfCQFGyiREBIYdNV?=
 =?iso-8859-1?Q?a9DmKl+8mo5U9lwh8SG1gOne7SbDJcUxHYIPiXsJekPc5WG1QrBX5eGwgw?=
 =?iso-8859-1?Q?IaA9d46Mn9OVC+79+BwemKNN2OVHjfy2iaRHOKT/5SV/sG/0bzgPzuMABN?=
 =?iso-8859-1?Q?Q4DmLOn4jeqe1aI/KfTVXZEQdB9KbrHfZYvVAdMFTubi5cLE0L+1vbHmzC?=
 =?iso-8859-1?Q?tkyWqyuIyDLH7dqb4p4YmDw+M/vctDFpsmt1/Z0JQFGznYYt0IYtfhKA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ebf4e6-e31e-4140-cbcc-08d9aaa9ef30
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 15:41:48.4830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gIkGaZ5+Xua/OMcNsrsK5GlGsy5o+Ybv98AEkaHQtny5S1Vk9E3p23fUJa5sBMTazsB2ua3GrG2Kgj2XjOrN8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2903
X-Proofpoint-ORIG-GUID: fnDBTKOw2jnGuHsDqy1jpp76wVFHX5tb
X-Proofpoint-GUID: fnDBTKOw2jnGuHsDqy1jpp76wVFHX5tb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit f5d519563ac9d2d1f382a817aae5ec5473811ac8=
:=0A=
=0A=
  linux-firmware: Update AMD cpu microcode (2021-11-15 12:49:19 -0500)=0A=
=0A=
are available in the git repository at:=0A=
=0A=
  https://github.com/PLVision/linux-firmware.git prestera-v4.0=0A=
=0A=
for you to fetch changes up to 77e72100290150317c3a29baddf97f8fd27b58b4:=0A=
=0A=
  mrvl: prestera: Update Marvell Prestera Switchdev v4.0 (2021-11-18 17:05:=
16 +0200)=0A=
=0A=
----------------------------------------------------------------=0A=
Changes in V2:=0A=
  - Add entry into WHENCE=0A=
=0A=
Volodymyr Mytnyk (1):=0A=
      mrvl: prestera: Update Marvell Prestera Switchdev v4.0=0A=
=0A=
 WHENCE                                  |   1 +=0A=
 mrvl/prestera/mvsw_prestera_fw-v4.0.img | Bin 0 -> 14965408 bytes=0A=
 2 files changed, 1 insertion(+)=0A=
 create mode 100644 mrvl/prestera/mvsw_prestera_fw-v4.0.img=
