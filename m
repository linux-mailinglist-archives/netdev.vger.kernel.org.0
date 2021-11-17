Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C055A4543C9
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 10:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhKQJiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 04:38:08 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29274 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232553AbhKQJiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 04:38:07 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AH2nntN003905;
        Wed, 17 Nov 2021 01:35:03 -0800
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3ccsa0hawa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Nov 2021 01:35:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBSOzc0kltDfT2qvgGlk+KIlJzu2nVYc5yjBDr1qmQHWhGUnZMn6xielYL2zrWmLZoqZn0X1XBNtlEtjaJO610A3wrV7pq0ZXbAMwFytsBETojNDrR20I6AvEffyxmfpy9Z1tDjBc9u8MUKerMlsF9bahy2xfy2utWpxi2aR2gdC7HrKoWWJf9WKcihl4UyP3qWJL06fBiMy2VD2/kzAGNDb8pbh3Ra9cP/kt/RQ7KlhbU3vtCtYt2tkDKw8ylYPzlKxNwqFiaY00UlwocvnIYGXrT1Y1O9ioIBr584gekkYKArXkQCKCiZmRNNGuIHzK91+hiEMxPNI13T36VzB9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8CFyNuCCjVa0QNrjTEnhjQvTE/ghPgDv7hOHEB5qnAE=;
 b=LDLwAiVlxEWQcAZ4t94XvW6hOzivxNfrstcVCscMZCaP2AHnLCR5lPAPkA7uwjqea0SbV+HN0DeabO88YsYP30BghZo2gkqZpZ9VW8RoaPo6ortHBz3pbKsBRbNO0RE+6Zil8g9tiEdyTC5LcX0j8rSwFBvDilTw9rIRWKrj156IKdzJaTBWJvJ8izDSQJO9DjKL+cLcWBlLK8mhUTNG2AZH3bbLtv4DEVuGbEaHxiBT3zfHdW91yRJ1V+/GeA3+lU2kX13Tzo+YZ9tku5k7jm57klhKMW4hUPSbng2tGTPB+eZ9c2m8j2H+O7XqiUv4tUxt3t25QjG/9g+MsiooYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CFyNuCCjVa0QNrjTEnhjQvTE/ghPgDv7hOHEB5qnAE=;
 b=a+YLrHu7FoGPk3VY+Keia7VTqOPExdvFiWDzaS+gdEnk9kU5P8lbhlPfrUWfGJvcFLlT0GVsX59ORxJoyDQ15Y7l/qZpWPsg2W4Ar1yCfsI/NjJqxsA+j6HUIOik6x3HratZyO8gv6dvPvDnY558/7k92EX47fL3ccrq/FWFAfw=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BYAPR18MB3720.namprd18.prod.outlook.com (2603:10b6:a02:c3::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20; Wed, 17 Nov
 2021 09:35:01 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::f5d7:4f64:40f1:2c31]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::f5d7:4f64:40f1:2c31%5]) with mapi id 15.20.4713.021; Wed, 17 Nov 2021
 09:35:01 +0000
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
Subject: [GIT PULL] linux-firmware: mrvl: prestera: Update Marvell Prestera
 Switchdev v4.0
Thread-Topic: [GIT PULL] linux-firmware: mrvl: prestera: Update Marvell
 Prestera Switchdev v4.0
Thread-Index: AQHX25X5308WrG6+E0mNghntLzHRzg==
Date:   Wed, 17 Nov 2021 09:35:01 +0000
Message-ID: <SJ0PR18MB400969B1414DAE5ECBA22E4BB29A9@SJ0PR18MB4009.namprd18.prod.outlook.com>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: f731193a-1c1b-584d-6a78-8dcf6b01f77a
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cf8d642-ae23-4fad-4f15-08d9a9ad8781
x-ms-traffictypediagnostic: BYAPR18MB3720:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BYAPR18MB37209AAA03F9C4F7AEB8F130B29A9@BYAPR18MB3720.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:330;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2tx0c43Oua7iN7UxZeO0KPuVJHGb67zA5AZSYf1x33GQINA8l9xrIUkh4oEOb4T7ihKkNJRV2IKFsjJhghcPhe+VeMi8ZyKJuFL1CDAiFLW207sGAT7omrbroq28lFmBGouTuM4HQ1Vo01w4Pjj3sKaLV8w+WxXQc4obFIP5MKqwYE+vIioH85vrfugPbMV000W2DaS3gTMzfJEzFYARe7lGbcr2eX0J8rfDqVPmef/wD380TKLM9goq13Z0XvZvxhjeU/k0xmf2W2ZhYyvDmQWnBIwSs5EkGKAn+ugauJvVwy+Ko2S2MxMFMvDrNYdo8yyEFHI4nxCoZmBZbxSZXYHZI1Ez9BWqJQGcZFAFxseQT0rGLYRW8hye8oYCFIspIIDTbxJDR/B+AA/Klcyjvb4EGUAUkuRqlgaHLwjp40dPdMfUvADb/97lPeBLpAdmY5MEjApZzxBk95ESViv85C+1MZRK8nym1NHpsu361XmArekiW3mLXJ/rna4Ams83mLpum8bgM/AKJT6IRCRcfwBRr9PzeNmByz3jKRlPgD+uAVxU+r+FSO4S2gzZhGq75XPGA0XiaAgA87Y8tYWqwMx1sGShSjsEHw84T8B8fWudDpREGe1XaZjI0UnXEdCHpKd4gUSOSWWhINPP4fGltxr2Jxthi2jHc/JmC0GQXfvgiZe72gjtrP0uNifB25gmjp07p9Tt4m8wKNwmlIb2FQZzYF4TjoUQqR5m/028/Hqazde4xs3xzD606cdvExPt0/rYbJAhXmOEuC51eslaHxy4AHj3UWSsjnT9LXHelBI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(7416002)(6916009)(4326008)(4001150100001)(316002)(15650500001)(86362001)(55236004)(8936002)(6506007)(966005)(83380400001)(55016002)(9686003)(38070700005)(7696005)(2906002)(5660300002)(71200400001)(66446008)(64756008)(52536014)(66556008)(66476007)(33656002)(66946007)(76116006)(38100700002)(186003)(122000001)(508600001)(26005)(4744005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ToDUor+17RLJhjS6pAUU52jDmsYTK3X3qCR7tbyvMwK4uiMrmhgxU0IkuW?=
 =?iso-8859-1?Q?0PcaI/bVr7YJjy7rwKK6SHs7Wz/DsEQ4u6EcoW5dnxoeCgTgjnyFW5dGn2?=
 =?iso-8859-1?Q?KwTi2nVUNgEVULwy+N8kzm5XDeK5IubFmeO84RbrxbckbsPjDJHscli7fY?=
 =?iso-8859-1?Q?j4BXdtaVsmA48DXSizOBWBdIx5P5aMicM8cpKVFiJ3ZkeCwPUHedDssw2z?=
 =?iso-8859-1?Q?UTwbrlgydt+OMzyI//Y9GsfNIY079EEsb/quNW4A0V0Go2QNaKpNqKcEDr?=
 =?iso-8859-1?Q?oltpuUgINcgfjqZWqY6E1NeJYI6nGKCgFv5mao2wgsK6x5kH1LKyPT5VSV?=
 =?iso-8859-1?Q?L5U8quSIn9QZDAMfQHpEIsf00lRcyyCaihIiIxBEhjbF2/NO2r6owgUm/P?=
 =?iso-8859-1?Q?wM2SxbnnDpTzB4lRyoNGTfdS92Nmv3yq2CFgIAX6qe7mCR7v9hmIOHSRGh?=
 =?iso-8859-1?Q?jMe2uQSvznGHS+lWuR9skgXcNuw2bJzmCHosMZpZTubAjjd/xParfXgN/7?=
 =?iso-8859-1?Q?ZH+oz7eGXb/d1snJZbrTOHuv1PF4U6u1zd2k6tKKgEj24dechevLZxEf4j?=
 =?iso-8859-1?Q?O5urbUMDzpF9yZn29uHz2kP0mWSdiUSOIsbRfJF/E//ufdtDsGNzcDFU3W?=
 =?iso-8859-1?Q?mlDz8KE0Al6Tz2jP3p7VxnkD/1AfkGjT3R5vvmZG3kKqXsHGy0GyHHzv1T?=
 =?iso-8859-1?Q?H9r8ATvl6fBm+II0+nQPdQTLyxpbHmuISUq6HteYnlmDq+QSLr+Pgc2soQ?=
 =?iso-8859-1?Q?GIQentmHYlCNP7oVG+5FXFxuv9bju+i+ZfDpFYWqg0y19CBdQogDNmSpMK?=
 =?iso-8859-1?Q?NAGJqcGt5E/thZPlNo5xduah3JRCguTeO9NYvsD/i3pewuUwR72yA4vRM9?=
 =?iso-8859-1?Q?6PU9VN3PelBsrdtPLHWnp5j0c3dgD1SVt5HwRoqqfdmMFOQDNIgejIw4Tq?=
 =?iso-8859-1?Q?zt76e6Z5LdGCZF0htwuVyo+TY6UP/VwKTDTo3x11+FKQTm4/U6xSkck1wT?=
 =?iso-8859-1?Q?wOK4+ZB/KdIjm+bZEJWm3vNEg9HI6GkkgEvuR612l+3hFFgmqNeB9Ai1q5?=
 =?iso-8859-1?Q?Ml4tlfkAJsjG1+CZ5ONgOW3KLicez+NoCZWz05EZwfUHrbU65RHETxXQMc?=
 =?iso-8859-1?Q?XJXBmntyUAtXhLswG3PSR77dj4bvyv5gNSKt38kqoD8MSZAktENQiIWNXR?=
 =?iso-8859-1?Q?DP30b6KHbwxsZ5Z84v12WahAWa2hnXv2gfIvoknsM5eHX/U5Aelw70N+CI?=
 =?iso-8859-1?Q?jLGGY0esxilD7yVcIoD6utEHOI2P5XJYdE9twQMA2wW4qPw/QjIliE1Wrw?=
 =?iso-8859-1?Q?HyVNHG1YNfRJ+gsjHfRUpe+Hvo6oF0akR+CROP6WmPoVXKwzAgaXa3q+nN?=
 =?iso-8859-1?Q?wDkSpasm9gkZLTLocbI8lmFk/qrszXGpoZXHTfo0pjrTtzINV2PJn3aymJ?=
 =?iso-8859-1?Q?Vl4c5C3sZS1hYenDVFsabXwvSrEl/RFWRzb8qNX6EhLyJkyCyFuR3AqGlq?=
 =?iso-8859-1?Q?oGPWJxLuaGdAy+GQbAXzxydVLCsNFj05oKIYXI3ce7ytgHdL3E8OPLrElU?=
 =?iso-8859-1?Q?S/OT0HbRyDDWaBw88V7oiex64gNrnfBlL2DfKBDY0dygYl1U8/vPZBFbYq?=
 =?iso-8859-1?Q?fcfSLSF5lD9hfNG3X/l4cajTsLjaB9Me13zk6kmk/ZN5+iRjb8R5a/kw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf8d642-ae23-4fad-4f15-08d9a9ad8781
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 09:35:01.6136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r6+Tum+SDRY8ZKbWFuui6IfF0uSdDCMjFQYqo6oyBmcO9X9a2nIwKmLn9CNhd7sN+xkOfVoRS2/Yb/u+4JgaWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB3720
X-Proofpoint-ORIG-GUID: e6hEplFOnJzEue3cxDz0VUUoMIvMJsbK
X-Proofpoint-GUID: e6hEplFOnJzEue3cxDz0VUUoMIvMJsbK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-17_03,2021-11-16_01,2020-04-07_01
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
for you to fetch changes up to ffa6aca983eb129023b8a003db3714455eb275a6:=0A=
=0A=
  mrvl: prestera: Update Marvell Prestera Switchdev v4.0 (2021-11-16 19:36:=
51 +0200)=0A=
=0A=
----------------------------------------------------------------=0A=
Volodymyr Mytnyk (1):=0A=
      mrvl: prestera: Update Marvell Prestera Switchdev v4.0=0A=
=0A=
 mrvl/prestera/mvsw_prestera_fw-v4.0.img | Bin 0 -> 14965408 bytes=0A=
 1 file changed, 0 insertions(+), 0 deletions(-)=0A=
 create mode 100644 mrvl/prestera/mvsw_prestera_fw-v4.0.img=
