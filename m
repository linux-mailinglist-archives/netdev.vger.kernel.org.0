Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD16B3B4AA0
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 00:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhFYWmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 18:42:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:4984 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229776AbhFYWmQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 18:42:16 -0400
IronPort-SDR: L5pC4HqH+CxmHzX2qlId1e1/Y6yb6Qv1dW2+ujVzBMzmV7VZ3Xo7DwX12DQkEssMWTspngbQa4
 HxuhUDO3bz0g==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="229352042"
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="229352042"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 15:39:55 -0700
IronPort-SDR: iaWiARF49Otwm8wfe8MZ1z4JPgkEz2rq20DGGzIwHOceDnq6IZ+KNONkv2W7ErV6u4kpMC0/Ic
 4/9waOLgtKtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="445784415"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 25 Jun 2021 15:39:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 25 Jun 2021 15:39:52 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 25 Jun 2021 15:39:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 25 Jun 2021 15:39:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 25 Jun 2021 15:39:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8aB8xAy0Knvp0zBclaZOyxq6NBvkBCyW05uf7xh2/TyBzGcjkIsjI9T7B3zzWwRPDbbBONnQXVOg+9IBu0Begw6D1aTJ0cQVR9FN3PoyGUOq6FjSFl3Hh7jjyLDLy7pmQ43vnM0X+TU8J9jRv0+Li91+en5MCN0vCtg8b4oC0kiLBjW4EadBaS/9Ev9gZINMgay2IP8LKfQf02SIcXw61s/kg0CnkxnhGAx9oGH8FH2zuHV75c/TGDulDedfa19pau3GiDvi6JZeaqvT3unS38lUtEicllO3ivTTiZAvR7Q7+N9OFNzsESIgAIPJzGC+L9DAW8hDmHASK/heWpwiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TKsdvgkYgodoe04lpIELI9z03We/n2R6OVTBxh2mzSY=;
 b=gxPOAQiA98tfiUhmfks4PngkvsqASJY7tbKutAuHBdbVR+OF6Tl9dI8eTzNg0bP1SFMp4rYBis8cR/s/IwnosVokJd53CYeMq00Wyx5GuFDjyCxGY5DIBemXBwiXNnP5ol9Mp2PJ9E6qNZfh1wIYDBN+VcAlnaUqrkPJGnnizfCqSvCJmeInXXb9Hgyxw1p3Ojtsw1fXTIdJXNH5A0nOuE9kBlvM7aettban0pKR9MmIpLJ1AgzCFwIHv0H+1C3Q6CfBXZ2ylFsV+v5VmzNQt0mFhMPEjcK00Y/0SC3YIN7Pn866yyn0xo8wJHoV7R+2RA2nLpBs3iyJ64yR6+ueHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TKsdvgkYgodoe04lpIELI9z03We/n2R6OVTBxh2mzSY=;
 b=ugSHFtvPgyzRBqh7Ig40SJ09cVbYXy/cqlrPsRt8Yl21P+p+4+c7gSKthetkpQrdOcD91l5PtRAjd5UBzJFFErE89RbcWAw9xEJYKPSCicV7pY+OU1F67htD6xeTfO4TVIkqw0iDQdBQqcVp1not2Ql7JleZoExlwRDqfnejklY=
Received: from SJ0PR11MB5662.namprd11.prod.outlook.com (2603:10b6:a03:3af::7)
 by SJ0PR11MB5598.namprd11.prod.outlook.com (2603:10b6:a03:304::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Fri, 25 Jun
 2021 22:39:44 +0000
Received: from SJ0PR11MB5662.namprd11.prod.outlook.com
 ([fe80::58ac:cdd:41f6:93c2]) by SJ0PR11MB5662.namprd11.prod.outlook.com
 ([fe80::58ac:cdd:41f6:93c2%7]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 22:39:44 +0000
From:   "Brelinski, TonyX" <tonyx.brelinski@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] igb: Fix an error handling path in
 'igb_probe()'
Thread-Topic: [Intel-wired-lan] [PATCH] igb: Fix an error handling path in
 'igb_probe()'
Thread-Index: AQHXX8fRAo3sf3HdIk6YWZVzvMyzm6slZl0g
Date:   Fri, 25 Jun 2021 22:39:44 +0000
Message-ID: <SJ0PR11MB56620F7C26BCA6EC7D798FABFA069@SJ0PR11MB5662.namprd11.prod.outlook.com>
References: <0b5cab7b74ca2544d3c616da89f50635e827bc6f.1623528463.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <0b5cab7b74ca2544d3c616da89f50635e827bc6f.1623528463.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
authentication-results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.236.132.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ededc152-6b50-4c19-28cf-08d9382a213a
x-ms-traffictypediagnostic: SJ0PR11MB5598:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB559849AE2FD5563879DCF242FA069@SJ0PR11MB5598.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ezwrpln9wBlkgKxOpc1JMQlVv/0Gaix5Q8oM8kO7FYWACvCT5kY84QosIAEv3/Dzytk6vgczw5EzXlriWCladD1XWzwMkM1blq7FP4+Z5h6eBvrZBRtWQCsLQ3J/Zq/J4SFnfJKNtVnXMHCKQvO1IVrudVsSFleHQ1sbW4GP8Z0m/DL5jvu7Qnn0IBm+842GcxrjUgIUrRvKx3hC6sxkO57LXGsQIgsZEW9m/3AEG1XOnAc+bAs2Qx3P1coENpgDg/dkz7ynzm/Wt8lBoyN/1jNQsKdI0p8GnC8YZ8h4L5Y3b0LvNI5MYDytfM+VQM/NDVeMHPBvNTBLF9D65KDlyPMf/kD0Uxx+J/qd9KXZfa8+GKRxjD8Db7fSUWyrQssGhVDSWFR4iF/bqRP4SONpeMPxGpAuYLKBr7EaZI4HlyN8g+3GQ1Eh0wSnPeUfz/yc7W29Ve/xA9Ic/D3WZxb9EYqC1u2hl5uRIN4ligB/K+x5GVCNvXG28RcmABjT4h9THiLReBDlhNJcjF//n4rQHPDSv0QOTmPk02HmYdC2RSm2Y3puXxX7y30odO+7uq3MByqNtbaewOUQNzidIR2qZ0L2DEamg8T2YfpxPgaHZLM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(346002)(396003)(366004)(4744005)(4326008)(316002)(110136005)(54906003)(478600001)(83380400001)(8676002)(7696005)(66476007)(64756008)(38100700002)(66556008)(8936002)(66446008)(66946007)(5660300002)(2906002)(76116006)(122000001)(52536014)(6636002)(26005)(9686003)(53546011)(86362001)(6506007)(186003)(33656002)(71200400001)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Pdjh5L+aa1kHI2AW8ltO2OMYtFtwC7lmdP0SP8FIPRX2Om1IfL7Yr1QRUmnP?=
 =?us-ascii?Q?4OuHK03iRWmuODFKkH5RrEuuSnf396K/doWtX0vR43UB6lh9CBFvI2sx8j9c?=
 =?us-ascii?Q?Er5KNeQlaccEy2NDegX4NX1E/QjwWeY3MMKfOV3VUeIfFF0xABuPrPVJg4w6?=
 =?us-ascii?Q?X/+V/c6NwDvhBWkC4PIg8unMklYCcykeT8E6bJzZ1ifTW+6O/rRLZm/UV4X1?=
 =?us-ascii?Q?X2Bo2UolHqGperTyeZ6kuI95QODwjXoN0cMHMd3VVP9V50WnCyZrE3ES1mCK?=
 =?us-ascii?Q?4FU6gyF9ynvca3aK+SWlECUT16wMNNur7y+qxTuxBP939g7LsleDdfiYzeau?=
 =?us-ascii?Q?RwkOyTvH6+3OSQLkc2qtwMDzE6KDSTHV9f7p2od02ZtH8seJaYZggvNVcYKC?=
 =?us-ascii?Q?TXyY1qmQM+ci3Xs1Ictnqd7mLqpyxSDPMyVkB5yhp//cC+V2DTTjyUjv8dUB?=
 =?us-ascii?Q?VZd2lUCAEHMtInAfGaO6upCs8dvOYmYesKqAxTzQm/o/QSyhEsp8ek4CaqdK?=
 =?us-ascii?Q?aBEAbEjT2y20WrxhKtIZiN6e3fuhvhbP9oF+ZfKsbjscyWbyoxBtHRC7B4fg?=
 =?us-ascii?Q?orQ/KNMfVekl9evXPY1tDthwUtfNrIAME/te4QeTIzKPHYchsIW3kwSXP9SK?=
 =?us-ascii?Q?9BrNzGfQ8eTykf8wXwJg4YoZlqoYEYYFswzQD+sDrL5kQTpfxJle0EcKy3JG?=
 =?us-ascii?Q?/1SX8F6EXLZfoRuIHjA0MHQ5ILuuLJrZ3+Xgysj1qyxf3r10Yehqt2ZEFsqx?=
 =?us-ascii?Q?5S7TB/Q8f0w1OoprXe6gqMo3ZVIs9Xma2FaCeW7QoDKhjNmtLmhY4zNu/A2x?=
 =?us-ascii?Q?y003Wek2l/c82gRBuOSj1TEAidu6NXd//Z03VDH7e51Mi0U3Hfg+98T8f6ly?=
 =?us-ascii?Q?aWSNpV7WwVZHhf2E8aq1tPjsB5SEx8FumIS3QUNWpZwoJDc7e2J3+JQqCPWv?=
 =?us-ascii?Q?9wK5lRMOEQnjv+I2i20N+Y9oigQ6jxrIArHuJiOhzfCMjzMBB88i6HQQ5wVU?=
 =?us-ascii?Q?8jnfK3ElbhEjm0KvqjqDYZz16ExWXxkI39M73e7br2sigfDwznk0lMwDPDEb?=
 =?us-ascii?Q?Ouz7KtIESmlQhY4ekvUsUkaqmt5NYnNh3bad28aEnyEgXScYg8FoXlg63pDE?=
 =?us-ascii?Q?UClHb1Z7LXQghHZc1FYxivRT7mI7ldudbWVbvXS2f/OpcYTyGeJbjpQ8Qygt?=
 =?us-ascii?Q?8pFUpOh20UAJTg4hlzjAgYPknN7Ida2bJdT81fjfblBCqSsTwQpys09A2wI7?=
 =?us-ascii?Q?7Vwm8CcptD8aIg/yKZ0s8AJroFlgFFqEVuHuyRlY6kELSh9WUXBgsOQ9ln26?=
 =?us-ascii?Q?ihD3eEoI8TrtZ3EtRFFW9ZVj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ededc152-6b50-4c19-28cf-08d9382a213a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2021 22:39:44.6220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vzT4moypAEgF/3Ug3NWvFybk7i7z/qQZNwEBLSDfQAeGLTeG2epw9MujqYG+aVeWDcTmw2r38dsdM2pkjeiXZH4y16AQFYOfzBo8mwdYb40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5598
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Christophe JAILLET
> Sent: Saturday, June 12, 2021 1:09 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org;
> jeffrey.t.kirsher@intel.com; alexander.h.duyck@intel.com
> Cc: netdev@vger.kernel.org; kernel-janitors@vger.kernel.org; Christophe
> JAILLET <christophe.jaillet@wanadoo.fr>; intel-wired-lan@lists.osuosl.org=
;
> linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH] igb: Fix an error handling path in
> 'igb_probe()'
>=20
> If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it m=
ust be
> undone by a corresponding 'pci_disable_pcie_error_reporting()'
> call, as already done in the remove function.
>=20
> Fixes: 40a914fa72ab ("igb: Add support for pci-e Advanced Error Reporting=
")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 1 +
>  1 file changed, 1 insertion(+)

Tested-by: Tony Brelinski <tonyx.brelinski@intel.com> (A Contingent Worker =
at Intel)


