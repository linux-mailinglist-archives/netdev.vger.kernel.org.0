Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CA32C95D3
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 04:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgLADg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 22:36:58 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8386 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726026AbgLADg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 22:36:57 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B13ZhEM024717;
        Mon, 30 Nov 2020 19:36:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=NDscaHDOG43//S21SULHIlyz+W8hXCiXosMNaPRDOWo=;
 b=ew420EiYA59IssWrolYl49CyTnWUV9WZB6IaJKy/FsEqjpLALc7idE1qxrWkjx0wH4L6
 lB+rRKS+uDXy5OIsEs7q1o/DYFLWzCTqE74Jo28TLkRc1yGtZRMti1kRj2pRWfjmkcDp
 10f2PnawoEHu4EwPwHe7QtvOibjR2nKH89phiNbKT9BvhW1o1xGEGx/YBHvf4/psvXIt
 f3p8T2RGAhAa2b2H2nJiJ/Mp40tcXRiJKmyJJR9cG9ShuYEuBmmGG6SWeprlkllC2mtQ
 w2cDBXN3jb9YtZ2O0Swv+2dxWcffBV58pCFnMRbZh7j+qbp/HELcQOUFMeJUEhlrbBcs iA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 353pxsem19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 19:36:08 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Nov
 2020 19:36:06 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 Nov
 2020 19:36:05 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 30 Nov 2020 19:36:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1lX5wcxrppsdUbTvyTwa9NsOt1pdBQ8b9P42RHSRE2B0CkjC1vRIod1r9doAC+nF3eLL+goyOCQLI/yRhTjMY+NGG5YZxfDUx9lzc9ULAzdLLN15FQaXwlVeMqpz0H73GsmQXOMfvY3EtSZV9EM3MgSptlnwHY3UfVw8W2v4w56Q+TMVUzYC4nBwR5MjUoVQKB4fbbzub6l8DuuTpoprL5GKdtX2DPBI6wR9z9CsQpy0pvVf+DBJXi5u2QDudz9pJirsA5jAcaMgoM4vB/7nfUcLWx2TTU09B89kBM4e1NAsbBVhpiEVSBWuMarDkRIL4F7NMKBGI4YwcBBWN7MGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDscaHDOG43//S21SULHIlyz+W8hXCiXosMNaPRDOWo=;
 b=PlyFHpbxz2ArL4w0JPGy1w0g02TnALXLETjar1I6LXbb/cbUOAHBnItGnpO23t078GqWHEUEG55EDZ2uAop27PPueP1SNzpo/ukq27ElQHrNz56LbFf8JkwrM1e0cf9dHrQfX6oCvTl+QMsrgu5/GIqddvC7MIkpy4UkwitMOGtA5BW5VWTNn9L6/VlWR+hk44p9zty7xJvGKwwq7MlqnnwXVsUKr6lzqdg4xlSeQkZxeXLTE+LHUbHi5yvfAAxSG60GlA1Q3Jr+1qGGmSoHW5RvetmhXEsgZGbOS4kjTi2z/H+nAyOExinY8iYoXBdhR/WVq0hqhWWY8c4KmfhocA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDscaHDOG43//S21SULHIlyz+W8hXCiXosMNaPRDOWo=;
 b=HGrAnMBfvyTsTqGI0FaBuleczvoKBlG3ULjsoYevltoPRBVvmoQXQ7U0uMu7y6l2awMn1bjK5FE79p8ILrljXTalVq+LE+Hrgm+HnA8+loXBRZvK7TsvjfcpQOppBF9bN/jtr5sc/Zo2Q6P3ZrqZyywvi4ZME/BiA3Dqgfgxh9w=
Received: from BYAPR18MB2679.namprd18.prod.outlook.com (2603:10b6:a03:13c::10)
 by BY5PR18MB3425.namprd18.prod.outlook.com (2603:10b6:a03:1af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Tue, 1 Dec
 2020 03:36:02 +0000
Received: from BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a]) by BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a%7]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 03:35:56 +0000
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
Subject: Re: [PATCHv5 net-next 2/3] octeontx2-af: Add devlink health reporters
 for NPA
Thread-Topic: [PATCHv5 net-next 2/3] octeontx2-af: Add devlink health
 reporters for NPA
Thread-Index: AdbHkfXh13uAAxORSn68kJWCJhFAHg==
Date:   Tue, 1 Dec 2020 03:35:56 +0000
Message-ID: <BYAPR18MB2679898E4AB4122CE2E566D6C5F40@BYAPR18MB2679.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [116.68.98.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bde665c-66ba-441e-56fa-08d895aa36aa
x-ms-traffictypediagnostic: BY5PR18MB3425:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3425BC865923554E1FB20B90C5F40@BY5PR18MB3425.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jJwNTR0obKBlHLtR2RCopWH/tXdms8wJA5orKTjez7MgM0gYt6l36pPz5DAmNnsxseyJeUG3AsCD3dnFALHhTrAcRi0G8DbGPTyOt+nNNuxlfHtuYIABz5hm3KW0bX9nnySZqQC2t/uEEFzFZmrKv1yozhqQEohQkNYvK7LFJkVUPEY+YBpqePptPyAkhz1mKHb0bCQWTLZOlKVSyWyf9df5a+housq7cQ+MfCbgHoLNjZciHpDfN5yIyBqlAqDa/Rsbo9CA4HQqgcwU/bBai2t6MIXPVmhnJvbb2jmjxvZtITHUtwKkmNTK8WM1poeHVN9t88fXPLMoD0F00yyKgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2679.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(66946007)(5660300002)(33656002)(66476007)(6506007)(478600001)(7696005)(66556008)(8676002)(54906003)(86362001)(83380400001)(186003)(55236004)(53546011)(9686003)(55016002)(66446008)(76116006)(71200400001)(26005)(8936002)(4326008)(64756008)(2906002)(6916009)(52536014)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?74NRP7u6ruv5xQMNp1PsmclCirhLv77vrdskqXIt7S9pkISj9ZE52zYkJ7/9?=
 =?us-ascii?Q?GPoxhRvlpKVoVotZ/OKxaRkavwTEfxxsquXmDTGSr3UvOKnSL25TbMpsXJh+?=
 =?us-ascii?Q?d0ZEF3G8rSx2vWAd0ZQK4BRaXcpr6BDwlfIcq0jWf95TSnJIQQX83qxJ/hYe?=
 =?us-ascii?Q?ktQs3QDAhC0AnuiimT1ZVWYwvaIjB3zSKt2N6OKF0EzC1m3YYLGAxaC5zSMR?=
 =?us-ascii?Q?X2bd0p2/BRNpX9J6sxsy5jbxk8JqX9gJHuMSRPSkfY8MjKTFEqDH6/sJhrzP?=
 =?us-ascii?Q?KSfStGTBSAlkK0rMDpVq/sNahdfZ1upGG4kJGtvVKOarYiiuNzRGzNWQ7/SU?=
 =?us-ascii?Q?jqKFCmekOdmoIWrtlXla0Z6XeGAv/VEzr85Gx4n7uAMnKQYYsX+PAZ5P2h0f?=
 =?us-ascii?Q?NTR5m5vOWaUCuo2wrfkKThB36RqfADMuHoHpC0gKvXqgadHHpBD5VuepURib?=
 =?us-ascii?Q?RFL+3h8z4lp0UgFZ8QO/0rVg4sAKMAUI2Ou3KpVjNmhQRAYyYb36KaHwtxGJ?=
 =?us-ascii?Q?82537xPDDzyT04xDV0hPoFQabSkx/Wad4mYbuKoUkb/YOJveNldVHsxv1nh8?=
 =?us-ascii?Q?TiD9PqGGCUf521BRDVP0OLgdJNg8dGEVnByQ9Pkw/X6IeVZYHHiWFI5HbxJh?=
 =?us-ascii?Q?MF7sf35lCLulWYZcgZcQof7fXJu0RVJY1Vm+0j4taGroYbiWlDUAyz+213iy?=
 =?us-ascii?Q?nOONPL+VYJnv7F9kftLM8D7Ivkk8vrAxQJQNnesL9dCOY8M1x6499IsIYHvo?=
 =?us-ascii?Q?qwNz7FzW433Zb2HV4m72F6/4rWTYKAIaJxmAacX3t2LLf9MK7t80tMrSGsdQ?=
 =?us-ascii?Q?q9d/OPFA+yRRMd8m55MSEYKb7UzDHvFBuJNC7lUpuf0IRGyi0Y7pYjXjbIrX?=
 =?us-ascii?Q?+YSEClYcBEMfUSXW/nog5WbFesgZLFrMimse9PTFIh3NITGh3Eo9gulDI/3m?=
 =?us-ascii?Q?0WbCOJEY8D/O1wkFAiNVmXhnRVtbdW+1DI1GrsBym2o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2679.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bde665c-66ba-441e-56fa-08d895aa36aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 03:35:56.6097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5sbkgPxW54bVe7xvcZZ+lYxcIiPgDWnVTzSOvEcpm5ZAQepvkecSjq5C4s1LG04csoCApVbHDh8/uQIs2CPtEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3425
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, December 1, 2020 7:59 AM
> To: George Cherian <gcherian@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net; Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> Linu Cherian <lcherian@marvell.com>; Geethasowjanya Akula
> <gakula@marvell.com>; masahiroy@kernel.org;
> willemdebruijn.kernel@gmail.com; saeed@kernel.org; jiri@resnulli.us
> Subject: Re: [PATCHv5 net-next 2/3] octeontx2-af: Add devlink health
> reporters for NPA
>=20
> On Thu, 26 Nov 2020 19:32:50 +0530 George Cherian wrote:
> > Add health reporters for RVU NPA block.
> > NPA Health reporters handle following HW event groups
> >  - GENERAL events
> >  - ERROR events
> >  - RAS events
> >  - RVU event
> > An event counter per event is maintained in SW.
> >
> > Output:
> >  # devlink health
> >  pci/0002:01:00.0:
> >    reporter hw_npa
> >      state healthy error 0 recover 0
> >  # devlink  health dump show pci/0002:01:00.0 reporter hw_npa
> >  NPA_AF_GENERAL:
> >         Unmap PF Error: 0
> >         NIX:
> >         0: free disabled RX: 0 free disabled TX: 0
> >         1: free disabled RX: 0 free disabled TX: 0
> >         Free Disabled for SSO: 0
> >         Free Disabled for TIM: 0
> >         Free Disabled for DPI: 0
> >         Free Disabled for AURA: 0
> >         Alloc Disabled for Resvd: 0
> >   NPA_AF_ERR:
> >         Memory Fault on NPA_AQ_INST_S read: 0
> >         Memory Fault on NPA_AQ_RES_S write: 0
> >         AQ Doorbell Error: 0
> >         Poisoned data on NPA_AQ_INST_S read: 0
> >         Poisoned data on NPA_AQ_RES_S write: 0
> >         Poisoned data on HW context read: 0
> >   NPA_AF_RVU:
> >         Unmap Slot Error: 0
>=20
> You seem to have missed the feedback Saeed and I gave you on v2.
>=20
> Did you test this with the errors actually triggering? Devlink should sto=
re only
Yes, the same was tested using devlink health test interface by injecting e=
rrors.
The dump gets generated automatically and the counters do get out of sync,=
=20
in case of continuous error.
That wouldn't be much of an issue as the user could manually trigger a dump=
 clear and=20
Re-dump the counters to get the exact status of the counters at any point o=
f time.

> one dump, are the counters not going to get out of sync unless something
> clears the dump every time it triggers?

Regards,
-George
