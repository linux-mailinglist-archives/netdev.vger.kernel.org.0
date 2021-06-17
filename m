Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBC53AB471
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 15:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhFQNSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 09:18:18 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18046 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231224AbhFQNSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 09:18:17 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HDBBZW013769;
        Thu, 17 Jun 2021 06:16:06 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mx0b-0016f401.pphosted.com with ESMTP id 397udrtp9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 06:16:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNtt/25NLSx0ruvUTOgpyC10YGc/bbAgbZ0fbSq8xnIHElng0qau2FklSuVgWiUD9ErGXjTpHG1ucH6fPQe8vEDDUJGucQ99pgtZ5l7uvzqdu/ZiOKgil/c50OLmMc4thE4Ka9ojtzWRZBMDrU2XVyBH/wCayU0H4KOWU9YhyhIN5Yp49BNN5B//jekBHNhlcvPnEFKWTpJbzTSkxlZlIJecS/oEzKNMu10fI22q7cmGsOxAJHBoR2TjzAAMib76YAwqWqSL8E1O5+yXbkSCXDMonhc2HHwC0CyRO3O1PYq7cOfzxnbuA/rLnOnaU29PyuD3USytixeFX7Jci7DYJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHPVKrl8ZgY2Jj77KByD5EG1Tj9P7jGuLAP2kShGQaY=;
 b=UfogK+mjLeWX0xGrPPVw5yYJ9/kepRIFgzI3rJMNde2o3Gikb6ox1Vq7eDq+/ZW9CMRaIBmzdugy4zCRBhSr2PkIesyup0kMwl0l+qZojBBZiPkf51I/+Zg2fNkMSJGY7vq5Kea2qx27AOWzumGNEafZuqisAKKfagx67k/Ds8o8ba/PH9dvVtO2M9dmhvPo4tKDNqbamzWMpeCdHhYOQOubKpSnY+UHI9UQsyO9bF3KUBXlg5TGfSzdL9CMgyg8Hopn9L/uRnFtDzXtBDDo9Me8YDzUGnUKT8+vZ9cs4cIeJhcLyJcYWKINo/0ACSWmYVXx/ZlM3htaBR9gg8LhIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHPVKrl8ZgY2Jj77KByD5EG1Tj9P7jGuLAP2kShGQaY=;
 b=mPzkXiENm5meL5Z+2khhWgH/NNfmB2k7OwofRFwcYkaEFbsnPG6xzT5EzwuBHbdRjLvw0zv5UXXviXngxABDyK7ovJqteSaXrkH+E2WxuDXAAaq5KCKgizqnEqXKyPfV2ilN3yuilxybwSIEIYd5ln2V8mTfWuUsSwVqSh5I3EM=
Received: from BY5PR18MB3298.namprd18.prod.outlook.com (2603:10b6:a03:1ae::32)
 by SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 17 Jun
 2021 13:16:04 +0000
Received: from BY5PR18MB3298.namprd18.prod.outlook.com
 ([fe80::98ed:f663:3857:12a4]) by BY5PR18MB3298.namprd18.prod.outlook.com
 ([fe80::98ed:f663:3857:12a4%5]) with mapi id 15.20.4219.026; Thu, 17 Jun 2021
 13:16:04 +0000
From:   Sunil Kovvuri Goutham <sgoutham@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next 1/2] net: ethtool: Support setting
 ntuple rule count
Thread-Topic: [EXT] Re: [PATCH net-next 1/2] net: ethtool: Support setting
 ntuple rule count
Thread-Index: AQHXYq5VUTtl8j6Y5EG/MQGN8HpAqqsW7MqAgAFC7iA=
Date:   Thu, 17 Jun 2021 13:16:03 +0000
Message-ID: <BY5PR18MB329854137536121BC345502BC60E9@BY5PR18MB3298.namprd18.prod.outlook.com>
References: <1623847882-16744-1-git-send-email-sgoutham@marvell.com>
        <1623847882-16744-2-git-send-email-sgoutham@marvell.com>
 <20210616105731.05f1c98c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210616105731.05f1c98c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [49.205.243.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93da16ef-ea46-4af7-178d-08d931920f5d
x-ms-traffictypediagnostic: SJ0PR18MB3882:
x-microsoft-antispam-prvs: <SJ0PR18MB3882FF522D3AF0E3CE23C043C60E9@SJ0PR18MB3882.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3zTSf6fqKcILuFakzNsXxugRx0lNO1AGtfxlUreEInyI9qrcdqJhk7FoR+pMOraxAidkQDbtobdpO+aXw4HzR5W2qbozCCKk4kBb85FQPhC4ZmTe/oK2uRi1aH27HmSPIvRavfQTrsdK0sx5drmUE2pmgalnns/EKFfmqPFpgG02LDhrLP2xOSdoEfONPl2kvZjcnp7M9X4E9+Kq3HxU/IW5VRZh+VMQXzf7PT5RCZfiUraHe3WQtFH6GyClEDHKzd25r64HYMXbaHxOUZ+n2hXckFlB0uEHsnY71BMPE39J3O153/ZM335hj69zN/JD5exLg5EVC9R2dSttfJilWmfUtvlNrJYTtkb4DjbMUv/Wg8rCDUtxl3GLaecNKl5QTJ3UFUXWzGyrUlerqWmydnQUG9utBfGVG7blpt6q+MPd0oLK9tnnEYysizRHt9k2+YmmrM8H7v3U1qFzdEcf0c87c0VpKmQvmaCmRzdgg/3blCH90aUkQW1oVZ8KzFj7TW0zpIcYP99ZxThHxFJukRY12RhyhqfuOB+dD91xExQtuEsTexK7Y61mG4dANFONh2KSKV4pNFOEmPT/3FIu8CnSdjF2PZ7vqdro65iCmU4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3298.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(186003)(55016002)(33656002)(2906002)(71200400001)(53546011)(26005)(83380400001)(7696005)(64756008)(54906003)(52536014)(6916009)(8676002)(66556008)(86362001)(76116006)(38100700002)(122000001)(478600001)(9686003)(8936002)(66446008)(66946007)(6506007)(4326008)(5660300002)(316002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yjZnkl6Wyb5F/5LuFpEc2VWz9zBlP/BxO5OXzCLxSWiGqDQvzdVwXgj9Zb/6?=
 =?us-ascii?Q?M5dSMpCpVvuyMZ03cTQL7ZtLbX2DKGVd6LYavwH26DkaV46VkUP7ks6hfeLo?=
 =?us-ascii?Q?tYLZNg+1j4/HaqWJIAfGXJka/OMpjhHBpalj8AQgis3JkTVXBl7Hb8BXOS13?=
 =?us-ascii?Q?ibXp/ldOK+G7jv81d0xpDEzLxZGC181tK02wq9BzLAjlNRD6M62VW0AD8NvP?=
 =?us-ascii?Q?mMTS9eLZtHYvAhZ4adg62i0V6BIMIu61PRxJnA7l51SHD+mofewDJgji+ibB?=
 =?us-ascii?Q?L0wqgR4pqgaI5ssFh75vdwmVK09+TetJ+jqA++wMz2N1olSKT87B67P0wdj6?=
 =?us-ascii?Q?t8TU0BPyjM90XJFBI85Vj1eZi0mrZBv+yRCvBfH5PZjk8XNB5WQuJ2RSFUF5?=
 =?us-ascii?Q?hS5VAN27ilcuzAPVWVUh5ZglIvoB8Zyi24/9gVm6SkfD+eFR6yLJCEu8M/0p?=
 =?us-ascii?Q?QJzDPAzQLol2Y+/bvJvFTaVTRXOGi1I+Myk5dwO5uIgcTxJsC9j0D3+U1rXf?=
 =?us-ascii?Q?a8hNN9WIbybTPRFI7A6k3LiH6xhNjoVf5DQpWWmS0QaWvxRF+c5sxVLkwfcW?=
 =?us-ascii?Q?5+sHMLAYLuLr+s2oMXGQSVFk+MbhZceixQedWrcmpuoC474pupxZFDEN2DDD?=
 =?us-ascii?Q?sdnuSQg4UqevNX3eU/X/LJCklI+W4MDlOXBsYGtkE6ISRiFwA3Z8fSAaMpf9?=
 =?us-ascii?Q?wWR4D4W2x149Ak26DZ73jRtmzOV6dqGsotpSzaFapBHUAysBTEINFuqJtdqj?=
 =?us-ascii?Q?32x1E5CTccWKslAW9hWfogcxDtWdYk9MbB26kXR2TDJeHhSRFygD++62H1t9?=
 =?us-ascii?Q?O38wULSkcBbOEoLpUni/JRIBLjwfyp6OO+lN8J6rboUmU030jcPUlsIy7dhe?=
 =?us-ascii?Q?1WuaS0hej4LK79eXGia5BOVhlYsV6xLES7H3DckQ9MqHL9h6S8gSElr4W2Gr?=
 =?us-ascii?Q?GpJplVErNuPoffhChCxYkP/FwmoRiY/D6BxhBQ6x0rZuMnCyht6i8fGsL+so?=
 =?us-ascii?Q?JYvXZQn3B+cVUC7+UOFH/+Pkqzn9VcgaDPRJR6RZa8n/JVqXYTpbD+b2jJhV?=
 =?us-ascii?Q?YyQ4zMTfZs0DGw+7B0qdJ7NTEyKgOYvspZegIoJSPUXC+T0yiWEaDyn69xpd?=
 =?us-ascii?Q?+3I/ucQJ9x/wPqa/PjqO/XE/Is3bf8afWEYdgKf0Iq6ShHMUo076BOCucJ6y?=
 =?us-ascii?Q?dyc3u8nrwjBTabuz5CeSpQXUIx5cUf929uzcfRhCZjSXggcQX5oX2q7Ghd6l?=
 =?us-ascii?Q?suffhhySN97eFdVxsqzqLMD6jIrT7ehWTW0aTyTMlUcPMhnnDx3Nf96y+feu?=
 =?us-ascii?Q?KsryMOC3SbtzA4HTmqDTwcQL?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3298.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93da16ef-ea46-4af7-178d-08d931920f5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2021 13:16:03.4435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K0B1dTnIWcOxlh4vvP2bPUuniMpUkz/LBpuw7gV6Zuxp6cyD6c5HGKl44+jiDfrFRooM5UWwFZ2tre4s9ZHJ5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB3882
X-Proofpoint-ORIG-GUID: FoLSAilX3NpCAbWfw4xBHEQSEcSYSNu8
X-Proofpoint-GUID: FoLSAilX3NpCAbWfw4xBHEQSEcSYSNu8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_10:2021-06-15,2021-06-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, June 16, 2021 11:28 PM
> To: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org
> Subject: [EXT] Re: [PATCH net-next 1/2] net: ethtool: Support setting ntu=
ple
> rule count
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Wed, 16 Jun 2021 18:21:21 +0530 sgoutham@marvell.com wrote:
> > From: Sunil Goutham <sgoutham@marvell.com>
> >
> > Some NICs share resources like packet filters across multiple
> > interfaces they support. From HW point of view it is possible to use
> > all filters for a single interface.
> > Currently ethtool doesn't support modifying filter count so that user
> > can allocate more filters to a interface and less to others. This
> > patch adds ETHTOOL_SRXCLSRLCNT ioctl command for modifying filter
> > count.
> >
> > example command:
> > ./ethtool -U eth0 rule-count 256
>=20
> man devlink-resource ?

Since ntuple rule insert and delete are part of ethtool, I thought having t=
his config also in
ethtool will make user life easy ie all ntuple related stuff within one too=
l.

Thanks,
Sunil.
