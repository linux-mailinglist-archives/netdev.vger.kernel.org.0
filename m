Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBF436885C
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 23:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239678AbhDVVBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 17:01:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:52003 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239577AbhDVVBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 17:01:06 -0400
IronPort-SDR: u3C803Pbcbaq5m00Gn599Si6mlAam3KHYDg7dxQmbrnG4xyXK4NPTnCWrisarHXKsoL/flKhZn
 xK7M6T6Y2O+w==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="259926307"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="259926307"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 14:00:30 -0700
IronPort-SDR: ylaLofzuhJte67FINI+In4tUwlHNdAxfT4BCNMIi+4C1OgJtNiWhx5Y7x+mTPgmGDfsAG0Qdqz
 ukDYXWj0poZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="421520649"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 22 Apr 2021 14:00:29 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 22 Apr 2021 14:00:29 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 22 Apr 2021 14:00:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 22 Apr 2021 14:00:28 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 22 Apr 2021 14:00:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6pC46+Gyk6R3+cCkSprefKcK9GXX/XJ4ELLTrs3MqgDkuu5HoJjI3tHfiQslUcuCeOexOmI+tPxqcU3I7cldYEp8oCnM0gx54u70Nq3gNZ1CQUvnfJ9qcqXUYYe73XJMqrPGTGswHNGdhj2AF4ekl6+0bNRdMiLxHS5bqzl6rfF7eBF4ROoL+x1ohkKUHk0lsMiPepbMimWu13IoLDY3UVe9ypj6jmsDTEptzcUdAUvqf4MIW7p8re/YW4Kq/QCp3+naZxyjvkikMzbAhHte+hkF8Wz2Be6d7S/zaumuRKgp0R7T8siKzFgpeBmh4Mk+DY8lhl1MFpS2fmZRQWEkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MDBnDacZlelPuT2a38j8CxitI0eqZ/DC2ai0+QjdWQ=;
 b=Bt6tf7gRzBT+7drWBNdTlAQp3iRjoc3IuHXchOLjmsUaBtun/vG1yfo5zmMpREbiHTUxCR0JE8Ziavh/+E6nfn6gyqHLc1QcndYUJgxba5ZjsSUvhPLnXhL+GXGdlI1AdUyIBYpTM5pYKyW6bip3cwBH7olTOO+qeuFvAT1Ob0bTQ/5CurqnZJa12dzIgPlqLCR+0YFyPphhvTIwT7AQgNo8rsBao1150OsKk/5wXBHDn2C7IUHoDfEWpONaoEm/KF185AVGk4H7x2E19YhPFeip/O2JJ95HbXMEZai1JLy5X8gPrNeNRE//H9d8CejfLSDgmh4aRJlhfTBH8CNAPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MDBnDacZlelPuT2a38j8CxitI0eqZ/DC2ai0+QjdWQ=;
 b=ED0AlwBGbPMM9npoSGwceIEktPiixXmmi8owU1WJF2SVrCXg+/rDC+UnLO7F+boP+OUMO0gLp7etZj9FhhwLCW1nkpMGXfLrtb/PIs26RyupjwZ/F1Ees60yxzXoNPd99nfBnV8Fbu643gRkK2LMRYTmhhnQf0J/25ZPozd5ud4=
Received: from MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9)
 by MWHPR1101MB2254.namprd11.prod.outlook.com (2603:10b6:301:58::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Thu, 22 Apr
 2021 21:00:26 +0000
Received: from MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::a995:ea7a:29cf:d212]) by MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::a995:ea7a:29cf:d212%5]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 21:00:26 +0000
From:   "Switzer, David" <david.switzer@intel.com>
To:     Coiby Xu <coxu@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 3/3] i40e: use minimal admin queue for kdump
Thread-Topic: [PATCH v1 3/3] i40e: use minimal admin queue for kdump
Thread-Index: AQHXEKIJvpMuXEQS00e9J+LB+2eEKKrBU51g
Date:   Thu, 22 Apr 2021 21:00:26 +0000
Message-ID: <MW3PR11MB474829A1CB3A794198D0B319EB469@MW3PR11MB4748.namprd11.prod.outlook.com>
References: <20210304025543.334912-1-coxu@redhat.com>
 <20210304025543.334912-4-coxu@redhat.com>
In-Reply-To: <20210304025543.334912-4-coxu@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.40.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f1822db-39fe-4c20-58b3-08d905d1a743
x-ms-traffictypediagnostic: MWHPR1101MB2254:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2254E1BA388543535F09E03AEB469@MWHPR1101MB2254.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5rGECEmN/rkmv8bpS2JhievPWuKihiElwmwjFVBu/vEXQKLcHnYx3UispQ1KGGAzffiKjc6tuTSaWp1MYQqCuIZLAkvQEI/l+TCPNsrNgzRigO7tM/55K/z0WriWlSZjs5O6m3cl/9sAMOagwVmY+IOaL2ALs0f754lsbgOttlHkluLPZTOPnWW0G1dokTmgx+MfspziBF2lLys9ydHck4ot72kwLNv0gC1C1Nmheqh4eoumrtKDaki7IGb6WuTQtVXWrQPz+jY858jVFXAoxKoSJIyNT/fajeUOTXEvpCYLUtVXJ/aqbLRGaMmdi5D1hOAHKEDA63IqVhYvOMfmS4MEWDlub/CCx4KZxZYY5hb7UWvkaxKErOznH94FqnG06X5WtEnNhS7aryy3gDC2ezqb4dqChby49SF3uy8Ipe4vlByIeut3eGzc3yxjXQmgkrJRSR7IAS4sxHwnQ5aslDrZh/nmPeg5EOK35MDzc7jHppUaGGdW4NYRFhfUuaswjnbEm4DGIDLfLJIkLu56UrLxOikDI0YuVHCWp2qF8Wz8NGK1IhaZGu3Ij+HylSA0LinDTJkTKPIjj6UOvC4/CXPScqWhpXikD2EpGWW/kOw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4748.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(83380400001)(316002)(66556008)(186003)(2906002)(71200400001)(26005)(122000001)(66446008)(7696005)(6506007)(478600001)(38100700002)(4326008)(33656002)(8676002)(52536014)(55016002)(54906003)(66946007)(8936002)(5660300002)(9686003)(4744005)(110136005)(64756008)(66476007)(76116006)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ODjBCiyJURAmj8rdeIYbSdL5jdVmjYrUa85q7Ojdm9pNPoMOYC6BtUSirIvK?=
 =?us-ascii?Q?PcwYq++Vznw3KdIbi0Vs7Eb7hUeB10EO668nWzyS6HRRcaT/QWNnSwM5akCF?=
 =?us-ascii?Q?yn/ra1t8EanoVaNkzPfMwxQ3TlwkDlHu6SbPAoUsY2f5mBmMBUg4tRaRguiu?=
 =?us-ascii?Q?xGVTbgdTftXwqZg8RFr+fyXDpRLWRdf5bbqWWVpFMAos0wpVB8gPULLtkHx8?=
 =?us-ascii?Q?eYgT+KC8oXU5GZZQI9cUERUUZfsOJvuKjzs5vHNXYJSYHVTRo6Rqk4Ga2CLj?=
 =?us-ascii?Q?DFPU9HPn7hFYpu6LYF22DRKjqL2hqGFbq3AbJSPjJSk9Wv4m1QCQR7/lV4Ya?=
 =?us-ascii?Q?f32uV6pLxSF1Vwdu+67yL6BT0cJ2XPmiPhJOCAVtppQHQZ/aeDpMyw90WGhr?=
 =?us-ascii?Q?9f8PSyxCssF1fOsri1SMuoSNjpaGvx4xmmkIiyPXxMR9xm1Brnynae4CBaHZ?=
 =?us-ascii?Q?mazf7ULoaU7VwiN48COAVWLJRIolD5+FSZn2iT7uHP+M9FMATjeTzAtnPEgE?=
 =?us-ascii?Q?DSi15CAmS/ZS1sUGDOZvZqP7q3BpLs73lxWwrdWpnofxmR/nE6v2IDtyOmYd?=
 =?us-ascii?Q?vv4uAg4PN9e/6IsNf7iw8Inn+5cDH3076ksbAbIljjkbU8AP+epRf7Yk6X4i?=
 =?us-ascii?Q?iZ660IWBUKHj98ZHTVE5/X6B1njXcVhDrc+GI5Nl9JVb5+aQCzgbsxMbrGY6?=
 =?us-ascii?Q?2KOBCdnGE9Cozuz+oVZxdMcOLt4OxkK4xVRKOkkd1EIzyiTLKVDDU2xyA5/x?=
 =?us-ascii?Q?GnsSY748I8NJfw11TAMPS3KX3OUdcz3ILpAVZF4dVG4YMBwowaQrz8KeamQ2?=
 =?us-ascii?Q?NyIugyh7R31gXMgE+b9tqsFD/lkFfcz1D97YGKO8Lm6UwehJj8FmgeK64etM?=
 =?us-ascii?Q?oxh3Eq2GPvCFGbyhygX33u9NDspeA/m9HIM9kGSgIzKb+6aa0XInD8bHJBNG?=
 =?us-ascii?Q?S0PDAY7BE6/DN6uVyfsvvZ/spiqseTdIxHm69I6px1LTK3LJo3ftKxJ4Zkl8?=
 =?us-ascii?Q?co831tOU9Rxifk3X+BahZhHv1rJdR59kQw6VAxhqpVAV4ysk4WOPaEnTp9Wq?=
 =?us-ascii?Q?OlzZnOf1Yk60DpOGPUBLzkwD+hYh7HZY5PEcZMOi/QFRAe95wJ/BI1ksiDyQ?=
 =?us-ascii?Q?H+sZmy0kFZGDTdr/8i3Lrt2N3Dw/ZMQvAS0LA0nmtBUNvJR/ZBbVJu5yufye?=
 =?us-ascii?Q?7Nd4XGYf95RqNV5KEouIwx4k7CD8F8wx9WCWyRNVHizYxqhnjyyRQrP4b7Zt?=
 =?us-ascii?Q?eaGRRusu/UuNS+KFEurF+OD4QjD3+thsy+w/KpFBchRkSdLiJvWbeV9tqXZP?=
 =?us-ascii?Q?3wM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4748.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1822db-39fe-4c20-58b3-08d905d1a743
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 21:00:26.0525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g2CDvJfnY87POjcy8HuGQhtQ5bS8pYaRP+GCwuNFbx4Lv+y1kmuHB5llaIHN65Ymbtb4KrPG4CnLRolriQl11w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2254
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>-----Original Message-----
>From: Coiby Xu <coxu@redhat.com>
>Sent: Wednesday, March 3, 2021 6:56 PM
>To: netdev@vger.kernel.org
>Cc: kexec@lists.infradead.org; intel-wired-lan@lists.osuosl.org; Jakub Kic=
inski
><kuba@kernel.org>; Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen,
>Anthony L <anthony.l.nguyen@intel.com>; David S. Miller
><davem@davemloft.net>; open list <linux-kernel@vger.kernel.org>
>Subject: [PATCH v1 3/3] i40e: use minimal admin queue for kdump
>
>The minimum size of admin send/receive queue is 1 and 2 respectively.
>The admin send queue can't be set to 1 because in that case, the firmware =
would
>fail to init.
>
>Signed-off-by: Coiby Xu <coxu@redhat.com>
>---
> drivers/net/ethernet/intel/i40e/i40e.h      | 2 ++
> drivers/net/ethernet/intel/i40e/i40e_main.c | 9 +++++++--
> 2 files changed, 9 insertions(+), 2 deletions(-)
>
Tested-by: Dave Switzer <david.switzer@intel.com

