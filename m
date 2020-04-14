Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807651A7251
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 06:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405130AbgDNENy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 00:13:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9670 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405115AbgDNENx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 00:13:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03E4BOXN003243;
        Mon, 13 Apr 2020 21:13:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=5f9wYR+9vK9xPdxB9ADKuxw1iflz+p+YnWVis+66RPw=;
 b=gw516SJsSSVEbZDizhrbSm0JrTvbnYFXTYvJLvPPNIyI4tu9ZXBKsuzDgFNmG87Kf+6R
 Ba1xoctK714XwwW7GB7DJc/B2ax3stv71fUgWn9X+xoCfXV17tEjFuprdm/f7fKq7aRP
 Gj6IKTRdHL9WUuY9neFDoKpSEYqg4D9FN/8lOWwjKan6MdhWJFdGB8VaIaKdEOuFFqjB
 8UxRrsWCMBQ1FcZV3yXoYJhrZ7LNjTd8Ocj9XdhFkW8sTH2346GQejCSl+Bi8uZm6vnM
 HImskPGJgV6kFtk6zh3X9jTUpN6Sppn1RNqlKuYIn/WV1rz5+9iCvSENhxbq49KkQaPy IQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 30bddkrtnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Apr 2020 21:13:51 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Apr
 2020 21:13:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 13 Apr 2020 21:13:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPGecauAIaK7WqKtKiJYdUuBIBMoUfcdiZqDOF5ig08SlQ8I+LSMXlxepRdEEa3nZFg6/SLYw0k9CJ5mesCU2sqk710JID+XwGVtRX0Y1g/kwyMwrsPHaOmlDqY5QBA23I8fI3fY1cLt4WpADDsI0+ZyFk3M66ufknKO3ftyeOnuUepZfYExH81aCbcxNChWIQv7wN2P26PJGx4s8yW5JVo+/Onal9A0FLnE9CUpNSLnzSs+KL+oIzXrscm8avB25kZXhGuiMP74LcaGsb02Zvc8tFZr0L9sgOclhwJXXOOF87xA0ZnH+x3I6MEOVMQ4np5gLAccsuZQwg1vMYSKHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5f9wYR+9vK9xPdxB9ADKuxw1iflz+p+YnWVis+66RPw=;
 b=RDNnUs518AZWw2LDBSqx//Vj6KMl/ZAMeKzPdFZ8K/IVQIZvCEAWOV86UqL6aPbzzvOMtWFG2lKvi+I601fETfJZYIRxtsdEKsbL5K/DtrnGvvXzsh+7auFN1eVz64zPfatEvUWN4DLznOhW4z/UChpsWGoxvbmdIQleW/OnC8QKqoivzQoLLZUUASbgsiyYLZgkIYY8F39qR7Z9vtDOCgKnPEKVB4GsHQSuUHX3kInkrA35BptQyHb1hI0I0GN6HfpoLn7SpFNp9UgGW/VxvgKE2sZtscN0gCjJrAwYzAJNVH5DvaVt3FxWO6ugQz4pX5bjNY6f8bSOTXxe6mXfjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5f9wYR+9vK9xPdxB9ADKuxw1iflz+p+YnWVis+66RPw=;
 b=XJUvEojcZ977geuA/igynec7L4/I5LRC0vQFGHFtWLxv/Xmy/0k+MBRjLq1ypMliEAg0UTbslQxNBSyOQnjOFoAicCsh6l2R6JEKA7oAiLFRrUT76Wgv37rbxdyd9cbt7m5bYaTtJ76R+Q14OEXMi9ry6qCf6/VAM9c1dc0Sugk=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (2603:10b6:208:103::10)
 by MN2PR18MB3151.namprd18.prod.outlook.com (2603:10b6:208:16b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.23; Tue, 14 Apr
 2020 04:13:47 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f%5]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 04:13:47 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Javed Hasan <jhasan@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v3 1/7] qedf: Keep track of num of pending
 flogi.
Thread-Topic: [EXT] Re: [PATCH v3 1/7] qedf: Keep track of num of pending
 flogi.
Thread-Index: AQHWCbDbB1NaFano4UeLM4xmkYGyCqh34jeMgAAwcaA=
Date:   Tue, 14 Apr 2020 04:13:47 +0000
Message-ID: <MN2PR18MB25278CD165DE5510B37846A9D2DA0@MN2PR18MB2527.namprd18.prod.outlook.com>
References: <20200403120957.2431-1-skashyap@marvell.com>
        <20200403120957.2431-2-skashyap@marvell.com> <yq17dyivp79.fsf@oracle.com>
In-Reply-To: <yq17dyivp79.fsf@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [45.127.44.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b14f32b-e7b1-4791-47e1-08d7e02a3a85
x-ms-traffictypediagnostic: MN2PR18MB3151:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3151771AF32E8610B36C8E9DD2DA0@MN2PR18MB3151.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:475;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2527.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(136003)(346002)(366004)(376002)(39860400002)(8936002)(6506007)(66446008)(2906002)(7696005)(81156014)(8676002)(66556008)(66946007)(64756008)(5660300002)(53546011)(6916009)(86362001)(26005)(52536014)(71200400001)(478600001)(33656002)(66476007)(186003)(76116006)(9686003)(55016002)(54906003)(4326008)(316002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w99MaKiFAK/tZzsQ5Jeoa6sZVxh2SRrd3DSmD781Nnpm4BghWXkU8QidsiYJHdbXxc7MHsROQPJgaTEo6BYJZPf5HK55/J6dOgcVlK7Gh1FUe+Oy37HJsln7N5bcN8HSrnijrICAo6oHd3zWH1nxdTvL2OIgDTlxK+OaXkm0YcmMiEvZeaR6s/LgWjEJbaeYfd7X2YJ9HnA++MlHWYAUK4NRyiRaT/0nxpM2jxyPRCYxTIKRSb8yTwswJuFsMZa1gUtOMESNBNztq5F+UUE0Lg9QprFtBpeZzSftUEvdTqMA3F824I0jSqch6xoJjLIWkg/+bLIZYiyb85VXa4bddiBYp7m3sbr0TOXvcODp8Jmns/blaOdQ9b94bOzw6ZvTElbUVbF6TzD6oWNGuwVs1p09n8TQoqq9LCgO5yc18UQBhvt0pbf/Im4MZsxG8pyw
x-ms-exchange-antispam-messagedata: EzybETKyOPRCMrm0GBPcgfk52dvqhWetGkB542TMSYdau/CGI4+oxuf4kxpuVO0h6W6IHi9ulkR4W5TovuVJmWyv0RoSWFUcIhSgOgFlX9kYCdf1gGRMCBNZRyg5IL17hHJJOIfdT0iZvATEAl4S0A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b14f32b-e7b1-4791-47e1-08d7e02a3a85
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2020 04:13:47.0256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RJu0UzUwXZGWpZ05Uv+j7AeIUARQKm9beVT5nP0Bn1LEtUNUrrTFsnY9V/52HyV85CDOaGNCMJ/+RQTdpSMoKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3151
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-13_11:2020-04-13,2020-04-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Tuesday, April 14, 2020 6:50 AM
> To: Saurav Kashyap <skashyap@marvell.com>
> Cc: martin.petersen@oracle.com; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; linux-scsi@vger.kernel.org; Javed Hasan
> <jhasan@marvell.com>; netdev@vger.kernel.org
> Subject: [EXT] Re: [PATCH v3 1/7] qedf: Keep track of num of pending flog=
i.
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
> Saurav,
>=20
> Please, no "." at the end of Subject: lines.
>=20
> > - Problem: Port not coming up after bringing down the port
> >   for longer duration.
> > - Bring down the port from the switch
> > - wait for fipvlan to exhaust, driver will use
> >   default vlan (1002) and call fcoe_ctlr_link_up
> > - libfc/fcoe will start sending FLOGI
> > - bring back the port and switch discard FLOGI
> >   because vlan is different.
> > - keep track of pending flogi and if it increases
> >   certain number then do ctx reset and it will do
> >   fipvlan again.
>=20
> That doesn't look like a proper commit message.
>=20
> How about something like:
>=20
>     If a port is brought down for an extended period of time, the
>     fipvlan counter gets exhausted and the driver will fall back to
>     default VLAN 1002 and call fcoe_ctlr_link_up to log in. However, the
>     switch will discard the FLOGI attempt because the VLAN is now
>     different.
>=20
>     Keep track of the number of FLOGI attempts and if a threshold of
>     QEDF_FLOGI_RETRY_CNT is exceeded, perform a context soft reset.

<SK> Looks good.

Thanks,
~Saurav
>=20
> --
> Martin K. Petersen	Oracle Linux Engineering
