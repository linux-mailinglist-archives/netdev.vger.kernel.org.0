Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905983D2BE0
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 20:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhGVRox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 13:44:53 -0400
Received: from mga12.intel.com ([192.55.52.136]:34305 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhGVRov (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 13:44:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10053"; a="191303113"
X-IronPort-AV: E=Sophos;i="5.84,261,1620716400"; 
   d="scan'208";a="191303113"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2021 11:25:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,261,1620716400"; 
   d="scan'208";a="497049314"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga001.jf.intel.com with ESMTP; 22 Jul 2021 11:25:24 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 22 Jul 2021 11:25:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 22 Jul 2021 11:25:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 22 Jul 2021 11:25:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVgRspd0xh8RDePZtwv0nzmPsnxGuG/eEelK95CKp80MCIXUG4ajXd7/FGmSnrKe0SqtXxyFrK4l6TTV5iBJhfPSDOQzOK0CBvPY9Tsf/X9+M3J08ip9cJ/842JzEsiD18kADsZluqNRHzvGSzvBm4d1celUbc4Id7mTHqJgZMxdMYn6x0JhmwAMM97NJprY3a0clVRKEP3Wgk9ZLZg4HVKssrN9A6cZYxMZkGhNeWOqYe9Lk/MhX1K0p4v948dEXFKLv/YIGODVQTMa33TDbvYowdwZ0anRl7LU/JDaH/1XAVVSNDo4EunHCqLW/y16Nltzeu/mAkEwhz/euYRlbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibmmrsllGk7svV1IlzL4Zl1YVwZZbEuNwalV24hu7R4=;
 b=QOhLENpJtudohkNopZPWalnwMKv44bfJfOj5wEuVUuFLMY/7zkkSBD7oHwn5BHss0ju3TJOpOlsGYS47KC44VugLMGFv6G3QG8wML+V0qANFd+K+Ox5sU4/Lzo/ds1gqjLfRBVS2504sZr5YombIzCJEB8m0QvGP1JJrmg/kO9AtKZTtWHOZPZ5leg23DX2vB5Ta8d6yha+y5YNYAJMjDfm3eQ6b0LCgEB2mgZPmihhMWkpuyt6ukus/nYFnywB6bR/3fwtMgw/bdHQbv9ncSA2Imn22D7KZhu0jXYosMwvalq+krxebzaoekIt1dz8khTOca7qZQA0AwRlO5y35Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibmmrsllGk7svV1IlzL4Zl1YVwZZbEuNwalV24hu7R4=;
 b=QLbp4TBu+Ddoeu7WcdGXm7EoYMu+8NGMSjROcrlQ0M6mW7aaNqp3rMrf1yk7aj5Hazb/50qXnphU3E7QvZPHBvGyvRuOj0l2rzTN9U9mP1re6kEcLdrDrrXe9eeq3xanb4PGqpHhfDWLPBySPcWVwN38TvsdVg6n5353Gl/bSKU=
Received: from DM6PR11MB4692.namprd11.prod.outlook.com (2603:10b6:5:2aa::11)
 by DM6PR11MB3355.namprd11.prod.outlook.com (2603:10b6:5:5d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25; Thu, 22 Jul
 2021 18:25:12 +0000
Received: from DM6PR11MB4692.namprd11.prod.outlook.com
 ([fe80::b528:9dc5:64b6:d69]) by DM6PR11MB4692.namprd11.prod.outlook.com
 ([fe80::b528:9dc5:64b6:d69%5]) with mapi id 15.20.4352.025; Thu, 22 Jul 2021
 18:25:12 +0000
From:   "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "jbrandeb@kernel.org" <jbrandeb@kernel.org>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        "abelits@marvell.com" <abelits@marvell.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "rppt@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "chris.friesen@windriver.com" <chris.friesen@windriver.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        "pjwaskiewicz@gmail.com" <pjwaskiewicz@gmail.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "thenzl@redhat.com" <thenzl@redhat.com>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>,
        "shivasharan.srikanteshwara@broadcom.com" 
        <shivasharan.srikanteshwara@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "james.smart@broadcom.com" <james.smart@broadcom.com>,
        "dick.kennedy@broadcom.com" <dick.kennedy@broadcom.com>,
        "jkc@redhat.com" <jkc@redhat.com>,
        "Latif, Faisal" <faisal.latif@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "tariqt@nvidia.com" <tariqt@nvidia.com>,
        "ahleihel@redhat.com" <ahleihel@redhat.com>,
        "kheib@redhat.com" <kheib@redhat.com>,
        "borisp@nvidia.com" <borisp@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "govind@gmx.com" <govind@gmx.com>,
        "jassisinghbrar@gmail.com" <jassisinghbrar@gmail.com>,
        "ajit.khaparde@broadcom.com" <ajit.khaparde@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "somnath.kotur@broadcom.com" <somnath.kotur@broadcom.com>,
        "nilal@redhat.com" <nilal@redhat.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "ahs3@redhat.com" <ahs3@redhat.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "chandrakanth.patil@broadcom.com" <chandrakanth.patil@broadcom.com>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "chunkuang.hu@kernel.org" <chunkuang.hu@kernel.org>,
        "yongqiang.niu@mediatek.com" <yongqiang.niu@mediatek.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "poros@redhat.com" <poros@redhat.com>,
        "minlei@redhat.com" <minlei@redhat.com>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "_govind@gmx.com" <_govind@gmx.com>,
        "kabel@kernel.org" <kabel@kernel.org>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "Tushar.Khandelwal@arm.com" <Tushar.Khandelwal@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH v5 06/14] RDMA/irdma: Use irq_update_affinity_hint
Thread-Topic: [PATCH v5 06/14] RDMA/irdma: Use irq_update_affinity_hint
Thread-Index: AQHXfb7QMXs3nReFFUuOZg0j1omUtatPUjKg
Date:   Thu, 22 Jul 2021 18:25:12 +0000
Message-ID: <DM6PR11MB4692D7AB064416EFBBB53331CBE49@DM6PR11MB4692.namprd11.prod.outlook.com>
References: <20210720232624.1493424-1-nitesh@redhat.com>
 <20210720232624.1493424-7-nitesh@redhat.com>
In-Reply-To: <20210720232624.1493424-7-nitesh@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 882dda16-57e7-4fc0-9a48-08d94d3e0b8d
x-ms-traffictypediagnostic: DM6PR11MB3355:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3355AD98860D818AE0428F23CBE49@DM6PR11MB3355.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:962;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xg+zuxxi1Vte//t6iM60f2dhDY9DRCbpfYeLQ0jzg6ScVc7wBLckWRXm1IDtgDPsZNZf+/KwUmrkWFjB9oNIgUv1lZZZGjs4ODdvT8dXQRZ3rx7aqQzmOimjlCP5x8QgpDyZfStqFdvtq8l42wYu5hEdIgIFcDOfSvlNjWbG32OGr769kZ763zZh3wkwRed1NC0INuf+V2YKPFoorBcHYw6Bglq1bc+2MyKatvil80hs9wpuQYIHx+CuDYZItDYRIge1ri19vJIwfWqUXZqRBcx4NkMHrueAHv5xViWBf8NY1JlPkaEvKo/SY/3mlmPtSwO0k9T/dik2+zDGXCRlwGDTiM2mBw/tzqiCPcx4kxd305/rED8ZakrwQh+Ni4cJTvvQ4AhMW0Sd0zzxclRSQjRHz3OU1yfbzcylpi6hy0zDzEVcf+188JZLuzuQG4OuuyhJr4YJrW/guonS48WYibrTKnLi5lqhKTCLHvKQzRohQ9mk5DT2uk/ElBTa1LcA9I2XBqSSaVNIvQxz3ecAUzyi6cUT8UuQmSI2zzx/V1+4y2rIDmDgDz9B4XIKinZfGhgndCiXP9DFQQT/iKyhBnYXBYgET1O2T3RDUBZZ91gb5A2vGRVi+kNyG/EzfCBaWG1dcU26zWgBQGhXgCz58rla+1TWWHhGkXVEB9QfpKWxJlZaW53WSz9wBL+J3p+6yYdideGkKBmqLVlOKNNjBKwrUwQU+KQkpE1w7W39th1yxUTULImRd/aX+SKZXQcl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4692.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(5660300002)(71200400001)(2906002)(921005)(66556008)(316002)(66946007)(55016002)(7416002)(52536014)(8936002)(38100700002)(9686003)(122000001)(66476007)(26005)(76116006)(64756008)(478600001)(186003)(110136005)(66446008)(53546011)(8676002)(33656002)(7366002)(83380400001)(7696005)(1191002)(7406005)(6506007)(86362001)(518174003)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/EJ+amK5ZxBXcUXvAblI7yF4261IY4KABUNk9hAw0038bxegxlmVIkOiZ6vr?=
 =?us-ascii?Q?ANhMQH0Gc1xihFT7eupW3SAgO7QmqHiQNDwW5WM9L15TPbDp+VuAdNSl5NUQ?=
 =?us-ascii?Q?/Sl0tmlmEY6Yydr3zHzb9wMUQAuVdkFvZmncjIdB7ezXcp/0xDMxGjQgPohN?=
 =?us-ascii?Q?7BifoZfV1uPvILNNMkAWTbBjT1ppakq0FJ6tIe8GNaTiPtAlYgAxlaYbBXY7?=
 =?us-ascii?Q?Wp2fqTMhwIN6Y55befOl0euMa0dJfI18mHLZydI9nQrRilNOBLplVrxBjzvW?=
 =?us-ascii?Q?5VZItrvqZfxd8mcfjI2NcI8t9Url/4t3ZqjNF9H1A5fwFY8SS3iS5o1sn+x2?=
 =?us-ascii?Q?URlgKErScvbThwDJMoAfa6c9lwzK1UUJ8k3rmKrhQ3baYHhGTdRDi4C+Ze9k?=
 =?us-ascii?Q?gpBB2PIz/OVPf7/HWI5Ts/hMlv/hFIH8y9KB7Q401wIEkGFE+/HAend67fvi?=
 =?us-ascii?Q?J4Gf3czwoTfFceeaVH5b5JfF8+yn/mnTEgE7tpNyj6z8yMpkybS4EJ6oc9X9?=
 =?us-ascii?Q?Bb2/rhSZvaIZGTVK2y6ZOwJAPHVHRBOnb6afW6TjXf6ZU5MvZ5gUCPtUc6Br?=
 =?us-ascii?Q?njC5ifcfSD8lsDleSTHeWm9huVYJQ6yS8EBDZKY/FVzWx/n4GxCzAxj5ySbH?=
 =?us-ascii?Q?TBjN2Mp6mowKHltOdoyLlupalZtRN3BA0s3zw8AJzI80ui+1uph10HVZcaMI?=
 =?us-ascii?Q?45/0qMAs61kSeyFu0ugQhQW6cH8GDy0OO7/2bdTb+s63VvxMvbbO9ADuQxKw?=
 =?us-ascii?Q?/DmF1OA9zXK0XChvE+D3L849w5oXIDNFDg468xtgGkG+xkciXVHZ58zspNAd?=
 =?us-ascii?Q?PWC3vmvl9mFRXWYrM/ZABYXNmareYe6MG1MZcv47aYoAY9c0VFoK55jt6Hw4?=
 =?us-ascii?Q?+VQJ5azz/yqvLIDF9nxR5UHvQGdetDEBkiXBMbXo6XmqdEfKs+lXta7zcl6v?=
 =?us-ascii?Q?Kjx9ipozmvYRsqpvYz4ox0iwHkU+4D4CP4ZKiDyWwqkIDiFNA4p++2AKxse9?=
 =?us-ascii?Q?I+9MzbudIBhSfO9IQ5bqHLCh5BQoQ+uFhpuAZ3Hqe77jrPggYzFZFazh8QzG?=
 =?us-ascii?Q?N1fLR0el1z+ddG29XeQfSRyHs+hMS532RV3XkFcSberPrhnoSDZNJdKY5a62?=
 =?us-ascii?Q?erMIRZRonm4Bsgb9rAlS+3pW5U3J1ojFKHHzCyiyxT+oAWa4+EQi0bnEUuYm?=
 =?us-ascii?Q?Z7WAGxnt11Xcm+LMO3vHBx3zkdgsFLh6CCaQBQg/oWgI8HL2/rLSZvJRpTWB?=
 =?us-ascii?Q?M2lUDv51Z8x3qGasYePyn23ACb7dC6Y3kcPug2pEW9UpjOlh6N5qT/envL7+?=
 =?us-ascii?Q?kN63P/QU1GSckjCAzDVPSjFk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4692.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 882dda16-57e7-4fc0-9a48-08d94d3e0b8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2021 18:25:12.5860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hm6fEHuo6kcxjKh9kdCLEPH5nsv7ZlPeSsE7rGQAYCZBXF4J5Tl+q4qHQy1AOskG2o29HIYcWgmwCemj0zWFRhyYWgpCLErmf8Eefznh8wU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3355
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Nitesh Narayan Lal <nitesh@redhat.com>
> Sent: Tuesday, July 20, 2021 6:26 PM
> To: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; intel-wired=
-
> lan@lists.osuosl.org; netdev@vger.kernel.org; linux-api@vger.kernel.org;
> linux-pci@vger.kernel.org; tglx@linutronix.de; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; robin.murphy@arm.com;
> mtosatti@redhat.com; mingo@kernel.org; jbrandeb@kernel.org;
> frederic@kernel.org; juri.lelli@redhat.com; abelits@marvell.com;
> bhelgaas@google.com; rostedt@goodmis.org; peterz@infradead.org;
> davem@davemloft.net; akpm@linux-foundation.org; sfr@canb.auug.org.au;
> stephen@networkplumber.org; rppt@linux.vnet.ibm.com;
> chris.friesen@windriver.com; maz@kernel.org; nhorman@tuxdriver.com;
> pjwaskiewicz@gmail.com; sassmann@redhat.com; thenzl@redhat.com;
> kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
> shivasharan.srikanteshwara@broadcom.com;
> sathya.prakash@broadcom.com; sreekanth.reddy@broadcom.com;
> suganath-prabu.subramani@broadcom.com; james.smart@broadcom.com;
> dick.kennedy@broadcom.com; jkc@redhat.com; Latif, Faisal
> <faisal.latif@intel.com>; Saleem, Shiraz <shiraz.saleem@intel.com>;
> tariqt@nvidia.com; ahleihel@redhat.com; kheib@redhat.com;
> borisp@nvidia.com; saeedm@nvidia.com; benve@cisco.com;
> govind@gmx.com; jassisinghbrar@gmail.com;
> ajit.khaparde@broadcom.com; sriharsha.basavapatna@broadcom.com;
> somnath.kotur@broadcom.com; nilal@redhat.com; Nikolova, Tatyana E
> <tatyana.e.nikolova@intel.com>; Ismail, Mustafa
> <mustafa.ismail@intel.com>; ahs3@redhat.com; leonro@nvidia.com;
> chandrakanth.patil@broadcom.com; bjorn.andersson@linaro.org;
> chunkuang.hu@kernel.org; yongqiang.niu@mediatek.com;
> baolin.wang7@gmail.com; poros@redhat.com; minlei@redhat.com;
> emilne@redhat.com; jejb@linux.ibm.com; martin.petersen@oracle.com;
> _govind@gmx.com; kabel@kernel.org; viresh.kumar@linaro.org;
> Tushar.Khandelwal@arm.com; kuba@kernel.org
> Subject: [PATCH v5 06/14] RDMA/irdma: Use irq_update_affinity_hint
>=20
> The driver uses irq_set_affinity_hint() to update the affinity_hint mask =
that
> is consumed by the userspace to distribute the interrupts. However, under
> the hood irq_set_affinity_hint() also applies the provided cpumask (if no=
t
> NULL) as the affinity for the given interrupt which is an undocumented si=
de
> effect.
>=20
> To remove this side effect irq_set_affinity_hint() has been marked as
> deprecated and new interfaces have been introduced. Hence, replace the
> irq_set_affinity_hint() with the new interface irq_update_affinity_hint()=
 that
> only updates the affinity_hint pointer.
>=20
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  drivers/infiniband/hw/irdma/hw.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/irdma/hw.c
> b/drivers/infiniband/hw/irdma/hw.c
> index 7afb8a6a0526..ec8de708a4df 100644
> --- a/drivers/infiniband/hw/irdma/hw.c
> +++ b/drivers/infiniband/hw/irdma/hw.c
> @@ -537,7 +537,7 @@ static void irdma_destroy_irq(struct irdma_pci_f *rf,
>  	struct irdma_sc_dev *dev =3D &rf->sc_dev;
>=20
>  	dev->irq_ops->irdma_dis_irq(dev, msix_vec->idx);
> -	irq_set_affinity_hint(msix_vec->irq, NULL);
> +	irq_update_affinity_hint(msix_vec->irq, NULL);
>  	free_irq(msix_vec->irq, dev_id);
>  }
>=20
> @@ -1087,7 +1087,7 @@ irdma_cfg_ceq_vector(struct irdma_pci_f *rf,
> struct irdma_ceq *iwceq,
>  	}
>  	cpumask_clear(&msix_vec->mask);
>  	cpumask_set_cpu(msix_vec->cpu_affinity, &msix_vec->mask);
> -	irq_set_affinity_hint(msix_vec->irq, &msix_vec->mask);
> +	irq_update_affinity_hint(msix_vec->irq, &msix_vec->mask);
>  	if (status) {
>  		ibdev_dbg(&rf->iwdev->ibdev, "ERR: ceq irq config fail\n");
>  		return IRDMA_ERR_CFG;
> --
> 2.27.0

Acked-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
