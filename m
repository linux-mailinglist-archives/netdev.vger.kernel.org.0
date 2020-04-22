Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D321B4387
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 13:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgDVLtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 07:49:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1852 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726043AbgDVLty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 07:49:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03MBjUFh027235;
        Wed, 22 Apr 2020 04:49:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=Jtudjpz9BIykaW5G74y5UHKodfWrYOKMMdnG6JPqqVs=;
 b=iqQcpbPWxsLVZ1kr9nr6gzjoclhP/VNo77zCAyiS4WXujFlwC0m+d41j2Bc6C31cdeGi
 skCy/P9Aw9X6e8DqiWPf/nt5DXpd7UHTQk6D7PmaGvxRLqnCo/SjpO1RICY+QZ3yJENy
 Khau0w7TVNi60FJ8zj7NuR+83QrXC1b38G9Wy4Q4plnSue0rIGAfDSgou/54+Xk867uK
 To9DSBeWL0tO6+Y2E1R0JNSvNtGzFhItXOxHJIB4gSpTVaNM1oLZpbIwsvVIb+Idsknh
 7/NEAorhi0jCfOaU3h9d5xneJqz28JxNZUjEnXgbfmm2FBSjQZZMcBmuRsV+pQA32a0W KQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 30fxwph8k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Apr 2020 04:49:52 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Apr
 2020 04:49:51 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 04:49:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vw+tqhEuRvz/nlY00Wa2nf/blXiOgzzd8WvkrfaiPFmK1Gc2k+9MTsXQCDti9d5ug1FZ/qLQKXo+dgs65m94VXA2zhe+JkLaFH9foPtqhbu4gnQbV+er8YZcfMV7c4da43Qt3R7lQm+ZMrLCwBY2eONVk0aCqG9jHghfIphf4AZmsg5CTMC/eVKqLfcjp0zgjBaxvL1A9O0A1f2U6/fj2cHsCc+GLNP8YYpeZrvPetkkyFKyWVfPotx6/pMtvfCmJlfTD/UXbEUGmQv2SDeWyMpcywN04pT4S9bx/SiSeYfvAvfuTJaomBrBGrDNExEitk7DH+I2H340TFTfpTXkgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jtudjpz9BIykaW5G74y5UHKodfWrYOKMMdnG6JPqqVs=;
 b=HDHSc7ucL3fUJg1gg4vUkcQ1nS/lSUmuxwDj5giAW1dzcqnnP2Dz6sxVUwMNohjbVXE5NXBFb7Uq8QTOwp07s4cx4mS2GvCU2pNzn5gXuSbidlUGpX1Ca6N7ESLvzlX2sovaX914qO1tZ742N8j8f0dlyn/eFOF+wgcK22dfhL7aQSnN1ohfaSnqFPDc5ZfS7iVwRKI9fu1XhS08AsVZQb0PVaQupuJ93LbSypm/bjcaBFMTInKctR4w+7yYohPQo1mdkmzTMOdVRZo36Jjzfady0AkKIiuxifFnhTdxNXL48ACsENgI0oyzTfl8rFHLOleWgf/F5Yfyz76kHEWWCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jtudjpz9BIykaW5G74y5UHKodfWrYOKMMdnG6JPqqVs=;
 b=L/E7kc0uwVkBPEh46GWY1Pw0YXLB7hUX5+8tx1XRDgZ2JMZr2uQMLtu/5nq8ToYeFMsi/5jZF26X7SelGAMhJHY364TdvTsuaqK4hnYTazfRXQ1NFkzyvFX3K1RiT4GjP0Ti24o6tBg3NdGUSC+/w9EbFFym2uXOD8sETBsOn2Y=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (2603:10b6:208:a9::22)
 by MN2PR18MB3478.namprd18.prod.outlook.com (2603:10b6:208:24f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Wed, 22 Apr
 2020 11:49:49 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::d983:da73:4d17:cc36]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::d983:da73:4d17:cc36%5]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 11:49:49 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>
Subject: RE: [PATCH net-next 2/3] qede: Cache num configured VFs on a PF.
Thread-Topic: [PATCH net-next 2/3] qede: Cache num configured VFs on a PF.
Thread-Index: AQHWF+3kK3TQoSBHGEWNQCoxA1mX4aiD5esAgACwIiA=
Date:   Wed, 22 Apr 2020 11:49:49 +0000
Message-ID: <MN2PR18MB252804B93F5D54AD010DBEEAD3D20@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20200421145300.16278-1-skalluru@marvell.com>
        <20200421145300.16278-3-skalluru@marvell.com>
 <20200421113010.6ba2fe5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200421113010.6ba2fe5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2401:4900:4820:a52f:50b4:8580:4582:fbd8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a5a89a8-43ab-48c3-4a58-08d7e6b3434b
x-ms-traffictypediagnostic: MN2PR18MB3478:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3478E93C86222D55DD5B1C12D3D20@MN2PR18MB3478.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 03818C953D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2528.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(136003)(376002)(396003)(346002)(39850400004)(316002)(66446008)(66476007)(76116006)(66556008)(9686003)(186003)(478600001)(6916009)(6506007)(53546011)(54906003)(66946007)(7696005)(33656002)(64756008)(4326008)(8676002)(81156014)(8936002)(55016002)(52536014)(2906002)(4744005)(107886003)(71200400001)(5660300002)(86362001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gdc0UXwCYdFqK75j1Pqfzf9WiHbieWEdNaEDSXaSL9RDmDcNMW9mIbclwugbLs0aBWjuUVKX6OO3SyhbIqKus6e91zyow5PsHjSnqtEdADdcK7uK4aEGfDHrxFqmN6EVZlDZHAFsT8cxRQwY3Kf/51VyRPVw1x+OdQHaIvqEJ/M+WCHyvMzOTodjeKgnw5nZfGBXo9Dq/3tS/Atwq25NQdYBV9NTFN9Ex1x0SPcRiNjtSZFmgo+xrT8GGrIZPoAoKUbmojMx0gdEVq9vEFIv0qHww2rPICcsWyghFpIiyJT5WfacyvEIbZNKKpOV2slC6ysISSSrMXni/DDpu0ym1hVbshVv46JgFtoBafQyf/VF9BiSUq0X/og3RgvwBf45v0KcDBPebNO6f7FK/6j7GS3JS557b0eSqU+JwTohRPrMYYonZ02lFFvafT7EblaN
x-ms-exchange-antispam-messagedata: lC5X+U7z+VSFzqKx8i+Gi0PateiMafSz8tYOq9Z/cr0lalzVupn7iD0HMhG47355YpmOCUiw0hmzVJf+j23j7wF8zlqdH/qYMh+MP0jwpHLTNwr8PxD3sc2WdK5GlDuVLhNitJu7tymzQnRvC/skVdmYz8RWXLYc42rWy7JpaUA8MAl6QDERO2iUXgEBdMD7dYK4mP2keyN+5scXH4YfPw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a5a89a8-43ab-48c3-4a58-08d7e6b3434b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2020 11:49:49.7497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e4AtRTT1lpsYCojiwYSvDsnupzPc8ltsJ1cWS3VHpKXoCjl/ONieEevP4IAo7EaUbMR7VL1+E91kToCR/709Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3478
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_03:2020-04-22,2020-04-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jakub Kicinski
> Sent: Wednesday, April 22, 2020 12:00 AM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Ariel Elior
> <aelior@marvell.com>; Igor Russkikh <irusskikh@marvell.com>; Michal
> Kalderon <mkalderon@marvell.com>
> Subject: Re: [PATCH net-next 2/3] qede: Cache num configured VFs on a PF.
>=20
> On Tue, 21 Apr 2020 07:52:59 -0700 Sudarsana Reddy Kalluru wrote:
> > The patch add changes to cache the number of VFs configured on a PF.
>=20
> Please use pci_num_vf() instead.

Thanks for your review and inputs. Will use pci API and drop the current pa=
tch.
