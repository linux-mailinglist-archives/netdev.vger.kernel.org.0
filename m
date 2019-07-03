Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51BA65DC82
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfGCC1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:27:14 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8762 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727100AbfGCC1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 22:27:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x632QbbZ018356;
        Tue, 2 Jul 2019 19:27:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=pDY67x1/wjxa/xo+UI5Ng9SntzglZxlUZyviB/r/dck=;
 b=avMtdiQ0e9SNmCl9V9+sx1QcYH7spBIsPDhLryGXcZvRp/k4cbgCCLP6o72swgpR9Fr9
 upqDQSk6p19j4XMnaLyO/7d39a2lhHSzLfnUwVv935tEtsJbLu2+2yiEIwk8231Wb5Ed
 2TbPwM3a8Bi5Oj9OEorQ9TKj4wBuYmu1m+EtwPMcchKu4Zojz1kRXDwjZwd1pb5qo1iP
 q8+2WcndzpemLlwp3OZ9z5HoFz/mwUD/E5DbN/DpiF9q8PAKs1o3Ihd/nJaH2RuZzXKc
 8JkgD+ix777LjPo/HO1WPbAMioW1bQAfE2etORuC3eBwkGWSn1y4+ofKgy9DdfEMpoyh Kg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tge6q92v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 19:27:11 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 2 Jul
 2019 19:27:10 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.58) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 2 Jul 2019 19:27:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDY67x1/wjxa/xo+UI5Ng9SntzglZxlUZyviB/r/dck=;
 b=HCB3fbi2csbAy4Axg8m23bPBNHENjrfmWJYndeHqRxf6cqI1DBGua6GRrSwwbccogdxAPLAIbQ0t076rry0G9QuwXZI/nsY1QytQsh8Du77D3sbBoYEEGEX2cs7dlck4hj7FaLfHri/TuL8mvwxYEuMgRJE3DyO8xZcYyAT7DQ4=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB3006.namprd18.prod.outlook.com (20.179.84.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 02:27:05 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1%4]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 02:27:05 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: RE: [PATCH net-next 1/1] qed: Add support for Timestamping the
 unicast PTP packets.
Thread-Topic: [PATCH net-next 1/1] qed: Add support for Timestamping the
 unicast PTP packets.
Thread-Index: AQHVMOd4MvMsKvGAHE2LNv0ZTsPqBaa3tXKAgABzGkA=
Date:   Wed, 3 Jul 2019 02:27:05 +0000
Message-ID: <MN2PR18MB2528FFF4D24086CD7D3D85EED3FB0@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190702150412.31132-1-skalluru@marvell.com>
 <20190702.122329.529953597219619097.davem@davemloft.net>
In-Reply-To: <20190702.122329.529953597219619097.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.231.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1544d4a0-2737-44c2-0eb5-08d6ff5df0b5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3006;
x-ms-traffictypediagnostic: MN2PR18MB3006:
x-microsoft-antispam-prvs: <MN2PR18MB30064AD2EE638D4115D07329D3FB0@MN2PR18MB3006.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(13464003)(189003)(199004)(229853002)(8676002)(102836004)(2906002)(66476007)(66556008)(186003)(256004)(54906003)(71190400001)(6916009)(66946007)(52536014)(9686003)(4744005)(11346002)(107886003)(81156014)(53936002)(6116002)(3846002)(71200400001)(7696005)(76116006)(6506007)(74316002)(305945005)(4326008)(81166006)(5660300002)(446003)(26005)(486006)(14454004)(476003)(73956011)(64756008)(66446008)(6436002)(68736007)(33656002)(86362001)(6246003)(478600001)(7736002)(25786009)(55236004)(66066001)(99286004)(76176011)(316002)(53546011)(8936002)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3006;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: M/SDWr/AWy1x9Qtd8loUVt/3NRCf7rsXedgVKqeVD3yoY5TvrOVDbNhSRPWeVusBNjNYH2dScBk2LlPR1Aq8RkTpzgoiiiLhOiWmTtR8sk+UlkUACjt3YebNq0i5j+t2g8c3JzlbikMSs9RoXjUtckYGtpiieoSFf3qXkkyJOotEq64ENpndD337COzMOE+S1OAG3hEl2wSnzdT9UYqmA27myMBUibRYRrrcpxqocTO0+bMQTWg/RD+qFfiYBd4686vvExZikLH1yJCt2e7r9tQ3zQ3Os+2CCmvAWjojz3JyI1wMclirWXJI/k4Dp/Mt2yX7xgHUPB4CMxw8phphv8lATx/3bokU+yx2uZ78JhUAgMIdsJ+0TTH+8nxv57kFoKkvmy5dCm1px30BbKDDO03IIJwxmSAHS93GDPeV5NQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1544d4a0-2737-44c2-0eb5-08d6ff5df0b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 02:27:05.3643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3006
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-03_01:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Wednesday, July 3, 2019 12:53 AM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: netdev@vger.kernel.org; Michal Kalderon <mkalderon@marvell.com>;
> Ariel Elior <aelior@marvell.com>
> Subject: Re: [PATCH net-next 1/1] qed: Add support for Timestamping the
> unicast PTP packets.
>=20
> From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Date: Tue, 2 Jul 2019 08:04:12 -0700
>=20
> > The register definition in the header file captures more details on
> > the individual bits.
>=20
> Where is this register definition in the header file and why aren't CPP d=
efines
> from there being used instead of a mask constant mask?
>=20
> Thanks.
Sorry, my mistake. taking back my statement. Will send the updated patch wi=
th CPP define.
