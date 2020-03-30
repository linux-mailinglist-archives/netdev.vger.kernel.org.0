Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A1A197A57
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 13:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgC3LEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 07:04:44 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25490 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729254AbgC3LEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 07:04:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02UB0BZR000758;
        Mon, 30 Mar 2020 04:04:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=sZw9+cqqE3+wPK1L5BxYzy6zCF3bNHmdvEW32DbYd68=;
 b=fVB3p8t54+Lmnh6a+qw0fgf8OCJBEw3BhLs6cPbUbRxmZm7a4kKKjxZStrk40hKwSOtI
 p173D8Tb8yqw4OywShINAdHborhT4eJoIF2j7/rq/4mY5ALZSWa9JeRUXRbfeeoQiLOH
 uWk4pdQnviNVLu5GGhwKjl6EpiepG1zNEh1K61Zy34s81aMcuHW3uW/C705DoKacHfqp
 U0lp6RVsszFFJIkOu+dbaR/vhinFYPEvKEtSWkEsq4kFFwTrBixXq59CHobN80pKEzNC
 U4+k9e3VEGBk7Jm0YO1y5lmSJEhm2H46a3xh81s+oHIipmdM+rNGmuOJyzrm8POVi7Xc +w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 30263kdrqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Mar 2020 04:04:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Mar
 2020 04:04:39 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Mar
 2020 04:04:38 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.51) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 30 Mar 2020 04:04:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZovJc6xJNA3cII/IgGyPRvvZit9IFNoq0dFVHfntvxUG4VgdhJAm6/lup6yudSr9Go/H0P6wkaX+aVRq8QZxBqOwR1hVv2XkQPac4efGHFfnIVyznEWCH0juMrdPTxrm/pykwRf6gbANN+luUyPKi5nwKP1sIRTYogwqeJ7g2slL/ysc+oCgNHIedMQqm71iZSX2h8hLq5Ph07JsH+sOD5O3CfIzqfiB/hTSVPlF59RnvBARfNfNTjdxgFwVwqSYooLFh6d1PN1xGLiPUSa05m7Sop8zkEyUfkucvQ3i6T6JcgFZRLaF8U94bPwiIq3oIDIYQHOhLh/aiUgumrzw0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZw9+cqqE3+wPK1L5BxYzy6zCF3bNHmdvEW32DbYd68=;
 b=SdPrIowGy+xQY+A3PwROPkdIF772sziKDPFR6vn8D5Q/d0iKAUsRbI2nMNyoguadZLZxY/UfLKL3U8d4Pw2BtvjXAOFn8L+2UVgSQxqo4TJDFSXOKsMlVEiLp9QyGwk0hZPjnClQTn3u/e4EIvnzITFsjxSPUpe3jXMpRMoJ1MpMXyCBQCJo0fxzjII5PPa4YWwadNS8eMKA9wUb5ozrF3swTKNyoDE2oXmx7ZclTgsggRErSA37a/QlC4rDu+HTMsD9g0wJc7OVlmAe5t/CGeL1dvkaXXSX4vPBfVeZDEA9+YTnRVEHp4xeu6xLVvPJ9W+U4M7NU0tXIIKioscQmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZw9+cqqE3+wPK1L5BxYzy6zCF3bNHmdvEW32DbYd68=;
 b=envbXg4C/bBs+WhJoPSPgraV4TlfXzCy+DEOY1Sdq/Ia7QcvJ2wrjlXJTR5Ma/suzeO7H+5ESVv9urYOvKVoNmyfEi+J30i/Sy+jF8DCyDQWWImHc16FvB030brs/uUH/BrGiq5ScjqUmsMuyIqxw6X85g1u3LaYYj1ugljxiG8=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (2603:10b6:208:103::10)
 by MN2PR18MB2957.namprd18.prod.outlook.com (2603:10b6:208:3c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Mon, 30 Mar
 2020 11:04:36 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f%5]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 11:04:36 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Javed Hasan <jhasan@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 8/8] qedf: Update the driver version to
 8.42.3.5.
Thread-Topic: [EXT] Re: [PATCH v2 8/8] qedf: Update the driver version to
 8.42.3.5.
Thread-Index: AQHWBlzN85ZXE53mFUuRoKceb8d54KhgvguAgAA7D2A=
Date:   Mon, 30 Mar 2020 11:04:36 +0000
Message-ID: <MN2PR18MB2527831D6825442A2DB3A5A2D2CB0@MN2PR18MB2527.namprd18.prod.outlook.com>
References: <20200330063034.27309-1-skashyap@marvell.com>
 <20200330063034.27309-9-skashyap@marvell.com>
 <20200330073237.GI2454444@unreal>
In-Reply-To: <20200330073237.GI2454444@unreal>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2da2c45d-487e-4c89-f2af-08d7d49a2260
x-ms-traffictypediagnostic: MN2PR18MB2957:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB29575843225AD637B6259231D2CB0@MN2PR18MB2957.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2527.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(366004)(396003)(39850400004)(33656002)(86362001)(55016002)(966005)(4326008)(76116006)(66476007)(64756008)(66946007)(66556008)(66446008)(478600001)(316002)(52536014)(53546011)(6506007)(7696005)(186003)(6916009)(9686003)(26005)(5660300002)(54906003)(8936002)(71200400001)(19627235002)(81166006)(81156014)(8676002)(2906002)(15650500001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J/4PZNOgamgxk8dW8Xao9j7VPBqcAaDE9gH1yo948s7vs7ZBYtYa/nJtwP+CPL/gfeUg3/qF4S5lVJ+U+ViL1K5Fkp8MqS7n5u6u2OEMYsFpo7JuzETWCc3vbucDvLr+i3jjwAjpejXVzT3b0JrywScTAxtOj6UcZfOqF2FXU5rXCWy1xiidHvdFr3t5K2BzieQftlpQ6B30zhH/fmNB2Mcq7OlTgxcrIiVZa4jtDg3OLMlPjMFlU/r5ilc9d6F55bKEIeDfjCriA7uQyGejx0lV2vYVefP54EMSAqBZWoYIzJ3KYwkPZcJR0OofN85ay+vDOcjmTFbWHpggTKavEJuy2udYdxkt8NJcVHBvya+Ey8F1P86KcwA0NxAyVbxt63rHLHENzjpnWAgGpx4MrMeaj106YHOl3s0Ui1Z5frZjrUVKbyWpOdjz2k9aLG6FvfW7juTbQCvrJV5aCzYisXObUvrITq4qz0JGrbOZA8F04ESy43m7wkBapNhVD4ILX/9YlfhPmmXV+yqeZqVw9A==
x-ms-exchange-antispam-messagedata: Q5gKOZWR8Yhj7Q//dJUtmkOQPaCQP32UQIj42p8AvzBO7EP+KSMTRLBw90mmGl2WqWtVQeRfJ+eSxBFfcLzsMVPoW/G/3xlcHH/8bl0CSEr/h4Jmzky/CucVOMjqdbalSquPCttF/mSD3clJVICvmw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da2c45d-487e-4c89-f2af-08d7d49a2260
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2020 11:04:36.2575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qGSired4rj/VUQhAwG/fviO2gazzeEXjnD2d061QX/mmghF/b/7wyfI6hsXic3XJ2VPKChh46ImWvGtuJg87Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2957
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Monday, March 30, 2020 1:03 PM
> To: Saurav Kashyap <skashyap@marvell.com>
> Cc: martin.petersen@oracle.com; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; linux-scsi@vger.kernel.org; Javed Hasan
> <jhasan@marvell.com>; netdev@vger.kernel.org
> Subject: [EXT] Re: [PATCH v2 8/8] qedf: Update the driver version to 8.42=
.3.5.
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Sun, Mar 29, 2020 at 11:30:34PM -0700, Saurav Kashyap wrote:
> > - Update version to 8.42.3.5.
> >
> > Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> > ---
> >  drivers/scsi/qedf/qedf_version.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
>=20
> NAK, please delete this version and not update.
>=20
> For rationale, take a look here.
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__lore.kernel.org_ksummit-2Ddiscuss_CA-2B55aFx9A-
> 3D5cc0QZ7CySC4F2K7eYaEfzkdYEc9JaNgCcV25-3Drg-
> 40mail.gmail.com_&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DZHZbmY_L
> bM3DUZK_BDO1OITP3ot_Vkb_5w-gas5TBMQ&m=3Dwvdgi6kwJlIOn1Gwy-
> tbE4Mg_iT5XW1DB7POPjKNALs&s=3DiAYLw5KnzDLbtgJ4Mlr8IQhGhD_5peOEw
> wI35EWImM4&e=3D
>=20
> Thanks

Thanks for the feedback, will submit v3 soon.

Thanks,
~Saurav
