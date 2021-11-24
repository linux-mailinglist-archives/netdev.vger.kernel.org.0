Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D9A45B622
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240981AbhKXIGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:06:21 -0500
Received: from mail-mw2nam10on2066.outbound.protection.outlook.com ([40.107.94.66]:28321
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240972AbhKXIGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 03:06:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUroBwUnN9jTbYykmnDWhrkKy78u6HF58/qk5UBohQnXAkP4/69h+uMOpf31vWzaLPrJGuQr5iAKjLvgfpWtYtgC+jkpxrMAhj+kyPc/DfxFG2H1s8Re1F3HCcf4iNO5xm4x+4R92hxqiENSQJc6aepxpbjPnMTM1c6DPEWZB5aBTX8gfBI8q1988meA508UgM7/d7escNuoqs4HNPLxlYExfnbMyX2XKvdyEEcW6tRyvJDNMF9v2gpXjls0hoLNyrMY/++wKyIigxQIvgFptkksfy+Fl7mEq8q6cjnxbNP/gMfokuwn41LG7vfJq/5HyaWa0UDwuzO8D+K1EwCsvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBF6N8GqmT9dIVIVlAjei1j6Pg4mC+c7xP7FHi+ZIdw=;
 b=hdNuXPZdrUyeeYDM4GMSi2o2G5eTXpKX61w1bkWgHCihhEl7uhVO4TtUaiSvAZs8jzLCjfZ1H1F04b3uZ3c9uTmeBZrCHbqBN1f3lAv0ZX3SZwLkCFKSEW7QMffbhjzcHiAr3ig+8JxUU4o/jsUt30spjA5h8M6IfbPJi0uoypAQ3Z5EWk9sq2D1ousmQY3qc+C/L0VgvRyhxNW8hOYJfCcnugO+SHXR5hAiy6LXSUDj1ECz8q+6EUYktO1ZfOokIkEBNMx/roIp8NOOtqdNVdvrcGTULRkZE1hKqkuLRnC5g81dXHqdS5Q39+8C/Xw85yEpKy4PYA78fVh17dVITA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBF6N8GqmT9dIVIVlAjei1j6Pg4mC+c7xP7FHi+ZIdw=;
 b=jtat7jVxutgfPHjFxkogy5ffnPz/QwUNV5qFOVU45gGi4w8/+WuMQ7lURh5qAgkcVIdxu41RjTGxO/DQ9FlV10HduwLHexG8TCnbP5KXt8Yo74oOpDmsqOD5M06Pp2/7MxUpF0TX8ywT0T09rn+nTlVZq27aMPAG1P2DOg2lUpqUPRd+Swe4eNCrdSdz2Iq7NOtD31i1QplEAaUmVAWEL2jNKmPvQalmEdfOnmUhytQFFQ6JkgNSL91D8DAfLnuIbsVPLzmkBN3ltWoNu77Fvy9sjFdQcyQVoHSvuKhMMhGwLvZyno5cM0jB/2SWvptN2seJ1X9shlcDTYcXe+oVmw==
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM6PR12MB3372.namprd12.prod.outlook.com (2603:10b6:5:11b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Wed, 24 Nov
 2021 08:03:10 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::a5c1:7bee:503f:e0d0]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::a5c1:7bee:503f:e0d0%8]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 08:03:10 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: RE: [PATCH net v2] igb: fix netpoll exit with traffic
Thread-Topic: [PATCH net v2] igb: fix netpoll exit with traffic
Thread-Index: AQHX4KpS8IRO8CTaPUObrYaieVzqnKwSTnvQgAACpQA=
Date:   Wed, 24 Nov 2021 08:03:10 +0000
Message-ID: <DM6PR12MB451625B7328FD36E7B30F325D8619@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20211123204000.1597971-1-jesse.brandeburg@intel.com>
 <DM6PR12MB451635351CFBBD86059A0078D8619@DM6PR12MB4516.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB451635351CFBBD86059A0078D8619@DM6PR12MB4516.namprd12.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 536995e3-7333-4bd0-d5e4-08d9af20db70
x-ms-traffictypediagnostic: DM6PR12MB3372:
x-microsoft-antispam-prvs: <DM6PR12MB3372DA46DD4A56CA51AC0B88D8619@DM6PR12MB3372.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fgGUZLkS4d+upBUiNu6oNkOQEwrmODaMwJ0YJwhh0wIMgIKqtbfVLOjylxUwASkH1TxfJ9JvavRmMJ24PXdf4zQTzysJaaq1ultjYYlXkMFnf2DgVTrkLmTnzU096C7vED73OIuvcesX1wwDrj0TJnN2y8a6buVfU1D1m5cfALxoas8AV7jD05iV0TmDuL6WPWQQO9Vnk7eP7mLX1vXvniqF4llJfx2BVk40Rfsp9fHtCRqn5U2acsplGEWEd3KJgEcGH25tO1aBBetzN9Pu3Sghda/wLR8hKJFPXshSuSNPp2uREmJz/RMYY2QWOARXo4/aEWIqN0kHwMEdxojJSuSpL2O8VtmMbFanCHqSXMcAtUMCpfr3VO1gog/xFpUz7AZ/lsLz/0LEYE7a2eIMI+yIi05uiXHpNItOvGn0TS2dVmUb4pJjI8Eoq/u3lB/VIC3F+LzSHnyHHvuOYRcCJTfBXzfIH790fzC4bHVTVFZau6iajKGtxhexstBsW+o0+57sqzuODoIyojrzHim3ANehCnnapkSA11Xr51DCwWY1Yr3rHaeUmigteAPRH8nIOfHjTIQ7Ip+NmNo1l3wzaomLIg2pO2pvtO7W6CwLiZWF3aWhiAPGs+Q0D5G6KnKFxzGftD0Ty/jZmOcDD7CrUP7ziHRlAUfiY/U6YjblAJ9MIaYH4gV7BGR+LzTNx5D/41p2tzm21I7okd1Dust79Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(53546011)(86362001)(5660300002)(316002)(6506007)(54906003)(52536014)(71200400001)(110136005)(7696005)(9686003)(83380400001)(26005)(55016003)(33656002)(2906002)(2940100002)(76116006)(8676002)(4326008)(186003)(66946007)(122000001)(8936002)(66476007)(66446008)(64756008)(66556008)(38070700005)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uzWX25oNdgD86W6ehdBai9lHPzDmYJ2ruRutJ+AAQgPNzLk+kxQ0ENvDVBry?=
 =?us-ascii?Q?6hia8se0kNMHt7i5+7hcU89IGIqY0RDWvESeRII2uwbfLG8Qw7Gumm1v4wjC?=
 =?us-ascii?Q?KW7r6CekUSGGUk8L7yipdldX4q/AtdcRHz5UkylaI5B+mNA+sv4DVHLnYO8N?=
 =?us-ascii?Q?mw914IzzREzamTU7xGt6zjil8KtD2N7GDrWF4zlJdxoiyCNiYM+NGjUCCGz0?=
 =?us-ascii?Q?YxnauhSPlKf3BUM6ZT3xbSDKa+ktOjiy0IQEQYACiu2RDE15TOxUWSWrTp1R?=
 =?us-ascii?Q?MXj46wwbQTZgZ0w0GuE77y/xANnTgW70L9gMjWSb3p3e1bJ93hJ6CsUPdFmI?=
 =?us-ascii?Q?KubkKHTzpEuDHU6QgWx36W6Dcv6+cVDGLbtRlzby8cyaTdjm0Qi2bTqNIlRH?=
 =?us-ascii?Q?pqTIV9fAa/AoBQIiDalEIHR9BgT04AkaY2cXB+y7MUqC30Rkw6WJd3iseelg?=
 =?us-ascii?Q?ypUNvQy/g70kdjgDTi9ANVW/hw7ShHUD/Zdaae16B0fCg0AY4kGC7ryOoV68?=
 =?us-ascii?Q?fj9jmjy9gKX/t1mpyldbgipXbsy2uu8dXDHtjbzJY40Wmdja76JcfIPsrGLz?=
 =?us-ascii?Q?hyXNSwcZETzu2GcnL/i4rdkMu/ieTMZ6DdffsK5mp0Dqz8e5Mzjg0om5NnTK?=
 =?us-ascii?Q?K2gpXj9xmtTcAStHgUQ+T6nht4nIyUtqjbogtpCgZsDOnHzWrf4YP7iVHzmj?=
 =?us-ascii?Q?/3bV31uzA+7GMEm6kTvo7pWHgC70QBOzLift2/krPGeYYPyIRjV+6m28czNV?=
 =?us-ascii?Q?a2jkDM/laASg+0z1MHUI7Rmq/jFmxjNXVbq5FOg+xozU5qn/Z/w9Xfdu8FL5?=
 =?us-ascii?Q?0Qv4b+NAG8sn7R42pCjRRh7JTZ5RUdfQhjMPMOb9LnzIEmi+Opxwxl1n9nxr?=
 =?us-ascii?Q?giT5WPtga2JF3tw1R6GSJ04FV+r4oqCWGgSkB35b1VHxt7H2dzdCMNBKIc7+?=
 =?us-ascii?Q?160/bXYAejckXmXKzdMAweg7QAmnsImpWJ9B0pJJJOjylXUwqGTAacAWpwD5?=
 =?us-ascii?Q?W9l9Orpv8XHnMNd8QjNa8vNTnD/BvQQ0IWB/cu6WCzwZZPdKyEl7uE7naa/T?=
 =?us-ascii?Q?TfSFMZPf1oyEvDgGTE7knBeJPSPSOp0ytwOmVkbzTcKjP4EUfIq5d3Jy+mWM?=
 =?us-ascii?Q?9cMrk+eDvLvD0TBrUnwip6ojeNTTGjlhmS6hh/SNfkL5M/uaWPsz2vs01GoD?=
 =?us-ascii?Q?3xCrevhn8Hv3OxqE51ReQK/P1o6EBDtF0ezSrWNfWHhNoI8Yiq7Miy4BcFwj?=
 =?us-ascii?Q?PUN/b1Y7yKvnUTrwKg/vZDY2W9vPEFGK9tDOpyTcpqmaYhNwE89fdqFy+DKB?=
 =?us-ascii?Q?yRKI1StodgJVu5NTPtEQcYB7bSkQgHRpeUDe4Qv7+HkhKURInOlVHw8V3fE0?=
 =?us-ascii?Q?fokVDATZWMZncWWf3wAx+c6AHmJ0OzyZONhSmfEIeiTA7QFjHKhtOdB+9DlL?=
 =?us-ascii?Q?zzlccjRpmvb9Uiul8BfogHnmk5nJcp1iz+TddZf6i9Rl4T0gp0ovClbs8xN/?=
 =?us-ascii?Q?nhnWVDjl4FsS0SN45TnhtO/3esnmPT59ZeUUvMDLSCViJaT//6l3F0MhyE29?=
 =?us-ascii?Q?KdB7yde16d2ZNzr478sYe3uWuMfhOOxtqk/KYOjr4JUO/CtABW23YJLfEsJC?=
 =?us-ascii?Q?lmBOQA0OjjLO+ihPLxtg6YA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 536995e3-7333-4bd0-d5e4-08d9af20db70
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 08:03:10.4268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YbGkhyWaeleJz56GBWJaN6HJ/6mL78ot2+m24sdDt3ijIlEDg8KVcww8LLHOcPYGkJIc2HHY+QuTlvlCOwjkPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3372
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> > From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > Sent: Tuesday, November 23, 2021 10:40 PM
> > To: intel-wired-lan@lists.osuosl.org
> > Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>;
> > netdev@vger.kernel.org; Oleksandr Natalenko
> > <oleksandr@natalenko.name>; Danielle Ratson <danieller@nvidia.com>;
> > Alexander Duyck <alexander.duyck@gmail.com>
> > Subject: [PATCH net v2] igb: fix netpoll exit with traffic
> >
> > Oleksandr brought a bug report where netpoll causes trace messages in
> > the log on igb.
> >
> > Danielle brought this back up as still occuring, so we'll try again.

And also:

WARNING: 'occuring' may be misspelled - perhaps 'occurring'?
#9:
Danielle brought this back up as still occuring, so we'll try
                                       ^^^^^^^^
total: 0 errors, 1 warnings, 0 checks, 8 lines checked

Please Reword.

>=20
> Hi Jessi,
>=20
> Ill run tests with you patch and give you results for if it is ok.
> Thanks!
>=20
> >
> > [22038.710800] ------------[ cut here ]------------ [22038.710801]
> > igb_poll+0x0/0x1440 [igb] exceeded budget in poll [22038.710802]
> > WARNING: CPU: 12 PID: 40362 at net/core/netpoll.c:155
> > netpoll_poll_dev+0x18a/0x1a0
> >
> > As Alex suggested, change the driver to return work_done at the exit
> > of napi_poll, which should be safe to do in this driver because it is
> > not polling multiple queues in this single napi context (multiple
> > queues attached to one MSI-X vector). Several other drivers contain
> > the same simple sequence, so I hope this will not create new problems.
> >
> > Fixes: 16eb8815c235 ("igb: Refactor clean_rx_irq to reduce overhead
> > and improve performance")
> > Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> > Reported-by: Danielle Ratson <danieller@nvidia.com>
> > Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> > Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > ---
> > COMPILE TESTED ONLY! I have no way to reproduce this even on a machine
> > I have with igb. It works fine to load the igb driver and netconsole
> > with no errors.
> > ---
> > v2: simplified patch with an attempt to make it work
> > v1: original patch that apparently didn't work
> > ---
> >  drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
> > b/drivers/net/ethernet/intel/igb/igb_main.c
> > index e647cc89c239..5e24b7ce5a92 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > @@ -8104,7 +8104,7 @@ static int igb_poll(struct napi_struct *napi,
> > int
> > budget)
> >  	if (likely(napi_complete_done(napi, work_done)))
> >  		igb_ring_irq_enable(q_vector);
> >
> > -	return min(work_done, budget - 1);
> > +	return work_done;
> >  }
> >
> >  /**
> > --
> > 2.33.1

