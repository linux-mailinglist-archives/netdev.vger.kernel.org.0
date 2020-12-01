Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0732C96D5
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 06:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgLAFTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 00:19:38 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56032 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbgLAFTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 00:19:37 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B15GAkx007895;
        Mon, 30 Nov 2020 21:18:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=Wrj5bzSJUFdrX6YZGt/U4c79NnISR3DXRPUiaRnQTbE=;
 b=gxtOWEwE9NVujILF0n2r2XQwg8ZTu3pwWlNREkrZ+t2OaGMna7DUQO7hoberHOsKnKpS
 2VyGiU1OFxoRMooCoeKvBCJ695KSwGj6XE0ph+OAgyPLmIB72M4KAt0sDIlXpwrP4/P3
 3J/Le2HAJfV0SYhlJXFn5VfvKILhSt7z0tWTWeK03THjuh1jR0p/u1vhd6eevodQP2lQ
 PJv5S/XmlP5ztUjvm30iR92u2kOFz061U2jLh01J3ZU47R93sUWqWoCGWjFh0ydFv015
 U1HUDJtlmLsfwPXQKEhKGoqc069+RRlzY4w106HgjfZKQAaVVIJK5oCcha+j+SCcU4Xd wg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 353pxset51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 21:18:48 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Nov
 2020 21:18:47 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Nov
 2020 21:18:46 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 30 Nov 2020 21:18:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGV5XcyrXkV6HLGdLAIuOmKPlxaPvqZtQt/ejkwy7XVcWwpeG2CrDNpkKMuh7+aCTHC0EZUUxZoDPjmcQHu3RNrJW6HkMx3wHQVh69hvEhRZXglLKtqkbYDa0galzcbnVDTeh/CFEmFvOYprGC2NPWgA2D4CEY7/VP7TKRNZ1oohltHuOxpcvMHSw3yvW5cFg9BNGJphw1OLlR8lyr0+XJl22+sMpKag+kYnzTuXm6KpDMkAjhnE7cuKnaFKLMoDIpwKq+FXHXEr2sFZKeMTDrBeWAWXsgisqEpyWR639iGMkFzwaeJnrz/0L3DIieWoxPyoXcFBNmoIq2Xl7CfFkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wrj5bzSJUFdrX6YZGt/U4c79NnISR3DXRPUiaRnQTbE=;
 b=MrbaWVTtygnKxY4EjOYoLGsJleFB+fHDlX312RmEWWomxDHkNLiju6xeN9CrKfO+iebKiUyOvOxC7EqSped4rCFd68UCh6mt1TEWeVMdNRxyQEnRI+RHyNyc/BubTQTSlEBp1tsyZRLkMJIsduIYDQsu+v4kE0l8PvLT1JAgR4VZ7jaradj1Sdm+F/+GZhZzx4L18EnWmr8u7dMO2NucfrEGo16i9xMC2k1Gm5HFn4b+ULZteE6StTfFzuXI9VPDSo5E4n7S6xFNYnGYZN9VYevj5F45LFnOMmc8Vw1gfpAfhmNFulWYG8y+J78jwZ/Lrdd8HBu/3ohDfDRQpiuZ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wrj5bzSJUFdrX6YZGt/U4c79NnISR3DXRPUiaRnQTbE=;
 b=gr3QWzO7/4soxrtEZqdont3rsfcqx0I1Pt177zrdASOk6l/3RLNAYQG+vO1owIaqwqFH0KHhH/cL/ziDl3tvELGMAdMzLLw2nkAmGxgYvM9QB/w1cxgKPR1YrMRiu/cPOPxdiBFxfAQvn5+t2rDEaWZglzOvSse3ovJUoJxXeYE=
Received: from BYAPR18MB2679.namprd18.prod.outlook.com (2603:10b6:a03:13c::10)
 by BYAPR18MB2422.namprd18.prod.outlook.com (2603:10b6:a03:139::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Tue, 1 Dec
 2020 05:18:43 +0000
Received: from BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a]) by BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a%7]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 05:18:42 +0000
From:   George Cherian <gcherian@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: RE: [PATCHv5 net-next 2/3] octeontx2-af: Add devlink health reporters
 for NPA
Thread-Topic: [PATCHv5 net-next 2/3] octeontx2-af: Add devlink health
 reporters for NPA
Thread-Index: AdbHkfXh13uAAxORSn68kJWCJhFAHgABlcMA
Date:   Tue, 1 Dec 2020 05:18:42 +0000
Message-ID: <BYAPR18MB26793451EC000695A56D3B00C5F40@BYAPR18MB2679.namprd18.prod.outlook.com>
References: <BYAPR18MB2679898E4AB4122CE2E566D6C5F40@BYAPR18MB2679.namprd18.prod.outlook.com>
In-Reply-To: <BYAPR18MB2679898E4AB4122CE2E566D6C5F40@BYAPR18MB2679.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [116.68.98.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdd99e41-182c-4a8f-0989-08d895b8920f
x-ms-traffictypediagnostic: BYAPR18MB2422:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2422E40F5D6FDE752611EBCFC5F40@BYAPR18MB2422.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kF556qpKU+j9kZ9au0r8Fn+PGLT+CDat/auwpwYVf9JSDgwwlKidu4GZgkwKQLVp4giRqzFbu5qapM3Y/8Xd19L68gDAy9JiMDiRNZyADutpri2KJDR3X8SSxIK1Dx29TceuZV5XwLVa5QefzYnw4oieYo3MVPLf/5gq40pUBuFqRDiS7G1x3K5ZcJPLEaDLLK2aGNDI98Rj3Z2RqqLwAuGHu+qIzh38pDtcIpAKYtaJEeSUh48Y9zk0LKzG4y5IS3Y+JE2jAhxVpgpOuRGFqbX01KxyoW45UTWJav6JGD1+xVZAXwUpRoFUXms5/8boxdAfsi6tTGLZMc3EHyu81g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2679.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(186003)(33656002)(2906002)(86362001)(26005)(76116006)(7696005)(4326008)(52536014)(53546011)(54906003)(55236004)(6506007)(9686003)(2940100002)(71200400001)(55016002)(66556008)(5660300002)(478600001)(6916009)(66446008)(66946007)(8676002)(64756008)(66476007)(316002)(8936002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rgn0qa2PhlVSNc026VWbKGTJUNHGh9q7FP/lmZRXkWzSQfelKiMcqFSAeIT2?=
 =?us-ascii?Q?kCKA5PnHvTWoSxrMjwunvLuiXpYmpHDeL6oD4yeMxBd4fk7zcSpp3cAtpYIS?=
 =?us-ascii?Q?UzsspiMWdUdWPe6NTgZUyhn7IgYQIqp6V0x/xUKLbyYSn+nHVmjOuApf3Ix6?=
 =?us-ascii?Q?7Ew+yWM7TjjH5i1WaF9DT7NWrPVG2kM2eB6pPNkq6+kGzKDs9YyakRo0miLf?=
 =?us-ascii?Q?YRpiN3+IiBytm6IG9X4WhZGj01ejVyQKzbLW4eAJoUOgmL3jOmyfon/PP6Fn?=
 =?us-ascii?Q?samfmef9dI9eahX/I+HRr2UrKcIy11jzaqYCyocIzUv1gf/X/3ltPV1DC5OB?=
 =?us-ascii?Q?ubQaDBWEasp0BxR06zaWsREmm9PtlrNspZhXKepj4Y/+Q1xYD53x7Q/xK3hd?=
 =?us-ascii?Q?GNrXDbKLs1S65h0ZOnVWnZQZasI0Rg6+oCQjB/Tgq3mWY2EmXDQEnxupVGOX?=
 =?us-ascii?Q?gmQSdXL5XDQ5470PiNpSds62H8wVu5wLlok7i+SeDth/Jvv3Xg5figagkHBr?=
 =?us-ascii?Q?sy/yA1sEAx+xVB52NG8zjXk06GLNpNsOt9u3/jgMjJmidI2qFVohjbo4Jdci?=
 =?us-ascii?Q?BFVmihdDIHckcJyeeEbxxMC0qZSLhdZfBQ4VzZQbvyezupg3OAyArEtUuVGU?=
 =?us-ascii?Q?HYfZct00qzibmeXZp0uI0XRVaGnWK5srU1Mikl/+Fn0aTCx9GhID8w5/1bGk?=
 =?us-ascii?Q?Yj+KG6T+6roSbGP4X1TO40Xo/AZefTqm6eXK5CLsAr711QuwaOe19rGaFZyZ?=
 =?us-ascii?Q?x1YOjmcYLcSRZPxO2Ub89Q6xj5IiR+GRfPSC++bDDWHd22QR9jPSmhTiKHJT?=
 =?us-ascii?Q?Ecm9eskD1UO672te5dj1HA2O/QXJUOOzE1eBCvF9RFMFRCwNqFLFmiW3hZV/?=
 =?us-ascii?Q?DYumKiZI+FWFKHFuj2PqfIAzi/K8EcHv9rKH7mkfNLR0z5qRCqW67hP68/bX?=
 =?us-ascii?Q?VwvEPNFafMySVwDXcmOw9+cfzSIsPlJr3msjUX6R1r4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2679.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdd99e41-182c-4a8f-0989-08d895b8920f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 05:18:42.9285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hsr7Y8vCLCTlgNS6wcgk84/tIN24lJGKZ65z8LaVfvH/ZKxaGpGe1J2Ij4VJGwwJsBuDFzlq64OoZ7taISkdAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2422
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub,

> -----Original Message-----
> From: George Cherian
> Sent: Tuesday, December 1, 2020 9:06 AM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net; Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> Linu Cherian <lcherian@marvell.com>; Geethasowjanya Akula
> <gakula@marvell.com>; masahiroy@kernel.org;
> willemdebruijn.kernel@gmail.com; saeed@kernel.org; jiri@resnulli.us
> Subject: Re: [PATCHv5 net-next 2/3] octeontx2-af: Add devlink health
> reporters for NPA
>=20
> Hi Jakub,
>=20
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Tuesday, December 1, 2020 7:59 AM
> > To: George Cherian <gcherian@marvell.com>
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> > davem@davemloft.net; Sunil Kovvuri Goutham
> <sgoutham@marvell.com>;
> > Linu Cherian <lcherian@marvell.com>; Geethasowjanya Akula
> > <gakula@marvell.com>; masahiroy@kernel.org;
> > willemdebruijn.kernel@gmail.com; saeed@kernel.org; jiri@resnulli.us
> > Subject: Re: [PATCHv5 net-next 2/3] octeontx2-af: Add devlink health
> > reporters for NPA
> >
> > On Thu, 26 Nov 2020 19:32:50 +0530 George Cherian wrote:
> > > Add health reporters for RVU NPA block.
> > > NPA Health reporters handle following HW event groups
> > >  - GENERAL events
> > >  - ERROR events
> > >  - RAS events
> > >  - RVU event
> > > An event counter per event is maintained in SW.
> > >
> > > Output:
> > >  # devlink health
> > >  pci/0002:01:00.0:
> > >    reporter hw_npa
> > >      state healthy error 0 recover 0  # devlink  health dump show
> > > pci/0002:01:00.0 reporter hw_npa
> > >  NPA_AF_GENERAL:
> > >         Unmap PF Error: 0
> > >         NIX:
> > >         0: free disabled RX: 0 free disabled TX: 0
> > >         1: free disabled RX: 0 free disabled TX: 0
> > >         Free Disabled for SSO: 0
> > >         Free Disabled for TIM: 0
> > >         Free Disabled for DPI: 0
> > >         Free Disabled for AURA: 0
> > >         Alloc Disabled for Resvd: 0
> > >   NPA_AF_ERR:
> > >         Memory Fault on NPA_AQ_INST_S read: 0
> > >         Memory Fault on NPA_AQ_RES_S write: 0
> > >         AQ Doorbell Error: 0
> > >         Poisoned data on NPA_AQ_INST_S read: 0
> > >         Poisoned data on NPA_AQ_RES_S write: 0
> > >         Poisoned data on HW context read: 0
> > >   NPA_AF_RVU:
> > >         Unmap Slot Error: 0
> >
> > You seem to have missed the feedback Saeed and I gave you on v2.
> >
> > Did you test this with the errors actually triggering? Devlink should
> > store only
> Yes, the same was tested using devlink health test interface by injecting
> errors.
> The dump gets generated automatically and the counters do get out of sync=
,
> in case of continuous error.
> That wouldn't be much of an issue as the user could manually trigger a du=
mp
> clear and Re-dump the counters to get the exact status of the counters at
> any point of time.

Now that recover op is added the devlink error counter and recover counter =
will be=20
proper. The internal counter for each event is needed just to understand wi=
thin a specific reporter, how=20
many such events occurred.=20

Following is the log snippet of the devlink health test being done on hw_ni=
x reporter.
# for i in `seq 1 33` ; do  devlink health test pci/0002:01:00.0 reporter h=
w_nix; done
//Inject 33 errors (16  of NIX_AF_RVU and 17 of NIX_AF_RAS and  NIX_AF_GENE=
RAL errors)
# devlink health=20
pci/0002:01:00.0:
  reporter hw_npa
    state healthy error 0 recover 0 grace_period 0 auto_recover true auto_d=
ump true
  reporter hw_nix
    state healthy error 250 recover 250 last_dump_date 1970-01-01 last_dump=
_time 00:04:16 grace_period 0 auto_recover true auto_dump true
# devlink health dump show pci/0002:01:00.0 reporter hw_nix
NIX_AF_GENERAL:
        Memory Fault on NIX_AQ_INST_S read: 1=20
        Memory Fault on NIX_AQ_RES_S write: 1=20
        AQ Doorbell error: 1=20
        Rx on unmapped PF_FUNC: 1=20
        Rx multicast replication error: 1=20
        Memory fault on NIX_RX_MCE_S read: 1=20
        Memory fault on multicast WQE read: 1=20
        Memory fault on mirror WQE read: 1=20
        Memory fault on mirror pkt write: 1=20
        Memory fault on multicast pkt write: 1
  NIX_AF_RAS:
        Poisoned data on NIX_AQ_INST_S read: 1=20
        Poisoned data on NIX_AQ_RES_S write: 1=20
        Poisoned data on HW context read: 1=20
        Poisoned data on packet read from mirror buffer: 1=20
        Poisoned data on packet read from mcast buffer: 1=20
        Poisoned data on WQE read from mirror buffer: 1=20
        Poisoned data on WQE read from multicast buffer: 1=20
        Poisoned data on NIX_RX_MCE_S read: 1
  NIX_AF_RVU:
        Unmap Slot Error: 0
# devlink health dump clear pci/0002:01:00.0 reporter hw_nix
# devlink health dump show pci/0002:01:00.0 reporter hw_nix
NIX_AF_GENERAL:
        Memory Fault on NIX_AQ_INST_S read: 17=20
        Memory Fault on NIX_AQ_RES_S write: 17=20
        AQ Doorbell error: 17=20
        Rx on unmapped PF_FUNC: 17=20
        Rx multicast replication error: 17=20
        Memory fault on NIX_RX_MCE_S read: 17=20
        Memory fault on multicast WQE read: 17=20
        Memory fault on mirror WQE read: 17=20
        Memory fault on mirror pkt write: 17=20
        Memory fault on multicast pkt write: 17
  NIX_AF_RAS:
        Poisoned data on NIX_AQ_INST_S read: 17=20
        Poisoned data on NIX_AQ_RES_S write: 17=20
        Poisoned data on HW context read: 17=20
        Poisoned data on packet read from mirror buffer: 17=20
        Poisoned data on packet read from mcast buffer: 17=20
        Poisoned data on WQE read from mirror buffer: 17=20
        Poisoned data on WQE read from multicast buffer: 17=20
        Poisoned data on NIX_RX_MCE_S read: 17
  NIX_AF_RVU:
        Unmap Slot Error: 16
>=20
> > one dump, are the counters not going to get out of sync unless
> > something clears the dump every time it triggers?
Also, note that auto_dump is something which can be turned off by user.
# devlink health set pci/0002:01:00.0 reporter hw_nix auto_dump false
So that user can dump whenever required, which will always return the corre=
ct counter values.

>=20
> Regards,
> -George
