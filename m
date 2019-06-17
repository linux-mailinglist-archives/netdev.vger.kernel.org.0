Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B138A48136
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 13:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbfFQLrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 07:47:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41190 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbfFQLrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 07:47:25 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HBkBpx000508;
        Mon, 17 Jun 2019 04:47:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=H7VLLzLCy2HusDDZ1YQ7PmdQ2dPUliNUTRIRRpRdlYI=;
 b=rtpKMccSSZogIZ6AAfay2AHzxZEayIsxk5Her9JlwIq7aXBwT0U8D5y4rgcyzJNfEWuk
 SuVKmOF0lOD4KJ0iziPv8NfnTNeU30H9abypjzbc73y9//BrZwjHmWww8EPlkmJImy72
 lSWKCLYaEbdghhwLt9uoXneG2dx8d7QwgIB/bc+AVg9Bs79sVgEC0yj9djyYvGzJYgN5
 PlFMiFMOub0Rd3purTuZVrbI672unSrQMJjpWZQ31Ttx5yaGNJsbLhK4lfLURR8KGS4s
 WvpAVSXsFomVoJ8qr35sfrM5GNq80biba8lvlKARO0Gd4Bgu+BadgiiYFKEjrjM9NECk hg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2t506hxdve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jun 2019 04:47:20 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 17 Jun
 2019 04:47:19 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.57) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 17 Jun 2019 04:47:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7VLLzLCy2HusDDZ1YQ7PmdQ2dPUliNUTRIRRpRdlYI=;
 b=VZtJ6tt97cn/W4yiBxkF4rw0rlt+PDk9E8tM0+JG29LtscbqekCXSTzRoNSqFiDRGH6F8XJnXJNHNNrXkiTI9prj162EvcuyBoG1rRhHhrpAAT/7F8TsAKsbLUuoc9AFb5hjFEderZTzY9qSfrlXeXCcCdEonx4kduK6lPWamwA=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2959.namprd18.prod.outlook.com (20.179.23.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 11:47:17 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::5c9b:c441:b4d2:da19]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::5c9b:c441:b4d2:da19%7]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 11:47:17 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     David Miller <davem@davemloft.net>,
        "maurosr@linux.vnet.ibm.com" <maurosr@linux.vnet.ibm.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
Subject: RE: [PATCH net] bnx2x: Check if transceiver implements DDM before
 access
Thread-Topic: [PATCH net] bnx2x: Check if transceiver implements DDM before
 access
Thread-Index: AQHVJIORLasmcadWBkGgHURJjRzasqafnnsw
Date:   Mon, 17 Jun 2019 11:47:17 +0000
Message-ID: <MN2PR18MB25285A81C813B5C8C004079AD3EB0@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190613192540.15645-1-maurosr@linux.vnet.ibm.com>
 <20190616.133904.49117769286698801.davem@davemloft.net>
In-Reply-To: <20190616.133904.49117769286698801.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2402:3a80:505:9892:ad39:4932:9551:13db]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efab127d-c755-4d7a-23b4-08d6f3198c59
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2959;
x-ms-traffictypediagnostic: MN2PR18MB2959:
x-microsoft-antispam-prvs: <MN2PR18MB295924473E64F7E17B71F7F1D3EB0@MN2PR18MB2959.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39850400004)(396003)(136003)(346002)(376002)(189003)(13464003)(199004)(8676002)(4326008)(25786009)(14454004)(74316002)(46003)(186003)(33656002)(478600001)(2906002)(476003)(86362001)(110136005)(11346002)(446003)(76176011)(54906003)(107886003)(316002)(6506007)(53546011)(102836004)(7696005)(6116002)(6246003)(486006)(53936002)(99286004)(14444005)(256004)(71190400001)(71200400001)(52536014)(81156014)(229853002)(2501003)(68736007)(8936002)(81166006)(9686003)(66946007)(66476007)(66556008)(76116006)(64756008)(73956011)(6436002)(55016002)(305945005)(7736002)(66446008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2959;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BfOLDi7Q2/7FGPRlzK+DiLrexQZlgTBM0j6UECdDQErbgvPhD8HxnKg0CQu+f3rchebAFGKTE6FwrCbyILI0RHgKIkCbDledRBUe7TLVRP63FqKQDLFHYaq2s4ngqQZ3ZjpME27frbogPSABnZcSiX2VK8HrHK6KjfHQplIliq5duiryqslmTfR4KBfnLwClfqOyGB4/rU7T5pnPSh5sohRKjX+Dva/MMNI3+k2cphtGD+k1C2S/1JYYX+VIpc1KYYDw0PnZpZd9/bIEVjmC+pJQhjGenZbxAXMjKrNwm+6UiB45n9CTyIFbE3avb/CjiqBmJ5n0nhRc8QTFHzunAxSaNt5MX42ifXuwFgfNrmgOPDqMDOUx55RWrtF8F1dF9hjTV06pQxiA35wKd1lxKerPAiJlgiNnfP1DTzwmn24=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: efab127d-c755-4d7a-23b4-08d6f3198c59
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 11:47:17.2698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2959
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_06:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Monday, June 17, 2019 2:09 AM
> To: maurosr@linux.vnet.ibm.com
> Cc: netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>; Sudarsana
> Reddy Kalluru <skalluru@marvell.com>; GR-everest-linux-l2 <GR-everest-
> linux-l2@marvell.com>
> Subject: Re: [PATCH net] bnx2x: Check if transceiver implements DDM befor=
e
> access
>=20
> From: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>
> Date: Thu, 13 Jun 2019 16:25:40 -0300
>=20
> > Some transceivers may comply with SFF-8472 even though they do not
> > implement the Digital Diagnostic Monitoring (DDM) interface described
> > in the spec. The existence of such area is specified by the 6th bit of
> > byte 92, set to 1 if implemented.
> >
> > Currently, without checking this bit, bnx2x fails trying to read sfp
> > module's EEPROM with the follow message:
> >
> > ethtool -m enP5p1s0f1
> > Cannot get Module EEPROM data: Input/output error
> >
> > Because it fails to read the additional 256 bytes in which it is
> > assumed to exist the DDM data.
> >
> > This issue was noticed using a Mellanox Passive DAC PN 01FT738. The
> > EEPROM data was confirmed by Mellanox as correct and similar to other
> > Passive DACs from other manufacturers.
> >
> > Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
>=20
> Marvell folks, please review.

Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
