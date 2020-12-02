Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728662CC7AF
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbgLBUYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:24:00 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:22256 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729063AbgLBUYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:24:00 -0500
Received: from pps.filterd (m0170393.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2KGi3o025288;
        Wed, 2 Dec 2020 15:23:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=hRZDNZAUGrEAEkfp3uVnqaw3wcJpUEWL1OUI3DzxMOo=;
 b=yWB5bbzwaUoOV8VNPElnO1c0ztI9YXlRfSzT+9OBtygiZZQV/VDsSuI6nBdYj+kMZ+hY
 I128HZzIybe3zEErBk8t/7HscOZLKAlLzOVJFf51NJI1NO38lSdAog9VzgPB6XT3/zKw
 nYIhX9Qa/H2ReepaPKeAay/lH/eiX8NdGQuwNrXTPmAvrTwNcbnFTb7rbzimz+2/tykb
 BcjX7v7Qp/qp/ddspxc3k878vAe7a4Jcj38ZebOielck987dPnj7PYzegoHZIi40pMlm
 Wu3WaDwU17SnDeTiaTCM4G5relFCl/w7yHtpDu3xzy835DMkkouxLhGDribv70NU7rLU Ew== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0a-00154904.pphosted.com with ESMTP id 353jrq1s7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 15:23:11 -0500
Received: from pps.filterd (m0134318.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2KItso091679;
        Wed, 2 Dec 2020 15:23:10 -0500
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by mx0a-00154901.pphosted.com with ESMTP id 356hms86ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 15:23:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lh1wS2NZ62jlSdULdrp4S72+xLlp3dk1OtDJ8gSiq6gQpj6cwUHXXTBp7bnioz2SbiVqT+OWGrU+RmC/cTiwwwa8id0waEg76P8Q24ilSQ252w3CWsifAweCIPruI1YJW61Hb0s82KP7h/HzN8OUQsqX+U3e6lDo0ScBbRqADCE1RoYeLqqpMX/p5Lzi6eCnbUB0UlrtP1vLHSlbUSpmR1bfx53O1eji7ImP5ML73iTm3j/48x/ONJwBq3raFHJPejand9Z9/MEylWJXjdORSBfRf7x3YYa7pys5YLfsxyZFT/pHyXe4B/aSmxKJO4Ar9q1P3UcDXJjvH5jATFdEwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRZDNZAUGrEAEkfp3uVnqaw3wcJpUEWL1OUI3DzxMOo=;
 b=gxRu/6vQMzibnsMEaY6Yoff+/i4OUqPjGI5qQs2iF3j+cyDYjIe5JLzCm9q38aKFWG5l38gPDTUwtSwq+ydJwrzSXYEkR2E/uEcx2u7nqYNgV3G+qSt6romiVS3vs9hCQqUeJkgLOnR9vJUmTkDUEZZb8t0z/heDk/iCMBXVCuvRLH+V3Hr5j+S3MrJMIWHODES0mjMZroMlq3AVS7T8ERqlf25lZkiLjGkF8c6EZ3z9rFlNUho6mWh6tNhTYu5mlegv8KJAnt9MbhJehT2YbnFBnCPZgBSU3a75ZE46NjkIL24ZDXVzAvbuFEhx2TLGgNSsxH7V+mGcoJWo2X9MbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRZDNZAUGrEAEkfp3uVnqaw3wcJpUEWL1OUI3DzxMOo=;
 b=DANMMbh2RHauWZ9BS9NV2+6/xI8CtlzJk0DuCU/HclPnzkmFOlpfKnPyB/t7hmiKCkiO2JNP87C1r+Ny3doJYYmbZQNnr+K4JnJ/Yvmp/v483bWK8kWRJuASHDRaetxsAnl+8SPsFG4QDrlnpoBUTPwLaHJLeMamuCJwpk0IbIs=
Received: from DM6PR19MB2636.namprd19.prod.outlook.com (2603:10b6:5:15f::15)
 by DM6PR19MB3897.namprd19.prod.outlook.com (2603:10b6:5:229::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Wed, 2 Dec
 2020 20:23:08 +0000
Received: from DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914]) by DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914%7]) with mapi id 15.20.3611.032; Wed, 2 Dec 2020
 20:23:08 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@dell.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>,
        "darcari@redhat.com" <darcari@redhat.com>,
        "Shen, Yijun" <Yijun.Shen@dell.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>
Subject: RE: [PATCH v2 0/5] Improve s0ix flows for systems i219LM
Thread-Topic: [PATCH v2 0/5] Improve s0ix flows for systems i219LM
Thread-Index: AQHWyMa4QDPSYh8b4U6WaEiBVk3soKnkKvoAgAADISCAAA/NgIAAAbsA
Date:   Wed, 2 Dec 2020 20:23:08 +0000
Message-ID: <DM6PR19MB2636D3D47AFC1B67113BD566FAF30@DM6PR19MB2636.namprd19.prod.outlook.com>
References: <DM6PR19MB26365E4B4EA330B499A325CBFAF30@DM6PR19MB2636.namprd19.prod.outlook.com>
 <20201202201425.GA1467301@bjorn-Precision-5520>
In-Reply-To: <20201202201425.GA1467301@bjorn-Precision-5520>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Mario_Limonciello@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2020-12-02T20:22:49.5935631Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_ActionId=3fd8d0eb-1391-4ebd-9529-426751061dbc;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=Dell.com;
x-originating-ip: [76.251.167.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56a5fe49-c09d-4514-a1a5-08d897001574
x-ms-traffictypediagnostic: DM6PR19MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR19MB3897A4CB3FD1F0040221412BFAF30@DM6PR19MB3897.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rBLQxnLcfxv0IsUH3iCPh1fLQ3IAvocHjXF/M4OlmjMh9tbWiGwUmjfOErFKINm9MTd0NRiTdGJjB4qHNsOsr9oeEYwzEeO3F2XC+015tf+kMesmyqYAE5Hue3jr/bGKsI6qsxy+bimoHT8vXw9bxGGqhSJSwF+ob73mSV5nxj3UWMLS6rguUaqXmoc+Pj+LVku8lkFkQpNo2IJve2pCqMbvpSvGmxpd0xiWSqXyvGgjQs3MzZotXnlXewxWDi+G6ErODWUP3hY42ExnQyAFuwikE53wO27KF5PwFeBMUZDuaxJjz/+0BxRIS5ikIrFnsTviZ21LHOjopjPWKGS0VKuO7z7pYbKJ88ia/WrlH3wKmyw7jN2U6ftnPbS9Hog13IvP1G8ZKfQ9zGWp1lbi0iX4hLR+yGXZr1CSxieXsipxBnxu5+0nO4ew5kRWRrteUOlFergsY5aR7Vasn2v+6N370BV1jS4wKMNTb/6nWi8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB2636.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(7696005)(966005)(9686003)(4326008)(76116006)(66556008)(64756008)(66946007)(478600001)(52536014)(66446008)(107886003)(5660300002)(66476007)(83380400001)(6506007)(186003)(6916009)(55016002)(26005)(8936002)(33656002)(7416002)(2906002)(8676002)(54906003)(786003)(86362001)(316002)(71200400001)(32563001)(6606295002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Uy2dUMBabhgcgXhiVi/ZVmMtHa3b45sP4OjWtXmrDnn392sydLskZ33b9zwb?=
 =?us-ascii?Q?wW5bwX8ozwiqPhuX/GG8QdtnRY5ldHCebQZzRVnvXRQlFyiZFS/NWQMBTho2?=
 =?us-ascii?Q?5aYF9hltsFnrbhU/2JwMA3d74cCNjrKEkqYdjbZhGc6eFb8WKut/VFHbJ73Q?=
 =?us-ascii?Q?IAlpmCjT/uI2lECmaC9gggQa49FK+wW4Im2LBlbyeJCbLBKGFbbp4VyvMo8H?=
 =?us-ascii?Q?gLDqOQSMjysBAZEmFRC3yabwx6MWDB1goR4ngIHWYh38FHBZyopphizHOXYr?=
 =?us-ascii?Q?xr3lcciEcSFbB3IE2lupSdSTeLnxqhDE7rn0hCQ1CGaIRPY8zZhWjGy7BKLC?=
 =?us-ascii?Q?ODpBkNvul3buASbjEa3xqRQDbvimt93qLG8TExbYVXnq5ZBTcvSPJYioAgh6?=
 =?us-ascii?Q?aiKWAceE1S3qwxIxV1O+YyPDn4VzOwuUjbqgoCC6WBcN6apZx0U9wZ4aWhYy?=
 =?us-ascii?Q?Tan6YWx0xHebUWiVaTM5Q61q9+OiHrEsAGkxdjonerDmcqs31AYnWMPbw0ct?=
 =?us-ascii?Q?+Ob/xVgcGVs00KCZa14P4bhy4D8385FAJZzzeuGGxw9v2D78VaMF0ySe4rEL?=
 =?us-ascii?Q?zLmIttP/geGURXqbRGF+ovHlq6mBwVJQBbNx0moGYgvpYsLWu7rlwyM1sH1w?=
 =?us-ascii?Q?VbYtDZ5Us2DOTo6U+Ikgrg7DccdIfhMewUkmT5lhR8NO6mqcgk322i8pTIF5?=
 =?us-ascii?Q?FY8d5c4rKr778avVImEmzD80uELwZ3nLaozsz5beomBlkDh3OMZMIzpaCrXA?=
 =?us-ascii?Q?U7E6LTx0h1cGz+Qu9NWHhR8XHQ5GWnYyIYB9sY0KqTKBa14ucPpKscIxsltq?=
 =?us-ascii?Q?rYd1EwU8a2H7P4gFxKD98ITIY72RdnzhJSoIOWLM00laxbFusayj3CMmuma5?=
 =?us-ascii?Q?OFu6bjnJkCcruPwPb0lj7HmOItJSVkYLdvy8zEGvxC8jQOxdz603ZI/n2ku2?=
 =?us-ascii?Q?K0kSh7m9dxNkoYuuquc0wtwS0etOlqKpE5PuYuOMXsU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB2636.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a5fe49-c09d-4514-a1a5-08d897001574
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2020 20:23:08.7744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cHCfBKV0xvkYAUCUXUVmLfqWHzKowT7qqFgFcDxkVeNhidrb6WOBIY3vFoCnTnayK/2SU5lnZI8AVdfZeS38sl1brR0C8BjIOwfu2pamAdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR19MB3897
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_12:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020120
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > On Wed,  2 Dec 2020 10:17:43 -0600 Mario Limonciello wrote:
> > > > commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for=
 ME
> > > systems")
> > > > disabled s0ix flows for systems that have various incarnations of t=
he
> > > > i219-LM ethernet controller.  This was done because of some regress=
ions
> > > > caused by an earlier
> > > > commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for cable connected c=
ase")
> > > > with i219-LM controller.
> > > >
> > > > Performing suspend to idle with these ethernet controllers requires=
 a
> > > properly
> > > > configured system.  To make enabling such systems easier, this patc=
h
> > > > series allows turning on using ethtool.
> > > >
> > > > The flows have also been confirmed to be configured correctly on De=
ll's
> > > Latitude
> > > > and Precision CML systems containing the i219-LM controller, when t=
he
> kernel
> > > also
> > > > contains the fix for s0i3.2 entry previously submitted here:
> > > > https://marc.info/?l=3Dlinux-netdev&m=3D160677194809564&w=3D2
> > > >
> > > > Patches 3 and 4 will turn the behavior on by default for Dell's CML
> systems.
> > > > Patch 5 allows accessing the value of the flags via ethtool to tell=
 if
> the
> > > > heuristics have turned on s0ix flows, as well as for development
> purposes
> > > > to determine if a system should be added to the heuristics list.
> > >
> > > I don't see PCI or Bjorn Helgaas CCed.
> > >
> > > You can drop linux-kernel tho.
> >
> > Correct, that was intentional that PCI (and Bjorn) weren't added.  Sinc=
e I
> came
> > up with a way to detect platforms without DMI as suggested and this is
> entirely
> > controlling a driver behavior within e1000e only on systems with i219-L=
M I
> > didn't think that PCI ML was actually needed.
> >
> > Since you disagree, I'll add Bjorn into this thread.
> >
> > @Bjorn Helgaas,
> >
> > Apologies that you're looped in this way rather than directly to the
> submission,
> > but the cover letter is above and the patch series can be viewed at thi=
s
> patchwork
> > if you would like to fetch the mbox and respond to provide any comments=
.
> >
> > https://patchwork.ozlabs.org/project/netdev/list/?series=3D218121
> >
> > I'll include you directly if any future v3 is necessary.
>=20
> No need, I don't think.  AFAICT there's nothing there related to the
> PCI core.  Thanks!
>=20
> Bjorn

Thanks, appreciate your comments on my terrible grammar.
I'll fix up my commits from the series and submit v3 once I've got some cod=
e feedback
from netdev folks.
