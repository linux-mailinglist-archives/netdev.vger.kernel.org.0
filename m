Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47965368856
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239500AbhDVVAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 17:00:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:23281 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236949AbhDVVAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 17:00:18 -0400
IronPort-SDR: Dz3fnNf0ODR4mdEvinj+NmAC755BONIV+0jBcwI9d2QrhhvpqzPmgqvfDc+6hXhc9YtwxDl818
 3V8hznmAzTfw==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="216653017"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="216653017"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 13:59:43 -0700
IronPort-SDR: IHJZwbos2uX4np10Lz2BW+Qbttwy3gExdb64j2/CwwKrCPDgPOgnbSwmGaAW0F98vq4tXZvxtc
 6+AY7lMyIuuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="614520725"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 22 Apr 2021 13:59:43 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 22 Apr 2021 13:59:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 22 Apr 2021 13:59:42 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 22 Apr 2021 13:59:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMF/3prffXwNXnnvtZF5TbswfX0+EijoSpQRG8HeOp0LO3hNBCARMDvp2LpzHcZOJIavhP6DblMenvBQLjtTDBUfFJOzMmvj+CrIpBf2FWZ80JneilbyWN45Gd+Hq+MQXg4amqo4Zij9e8P9oyBkAttK3oC3Z7fWQAGo+zmXOo8P03u1qxp3CAMEiXomyvlHDPB7hAdjs5jb6VffNop/6Pl96hYVyXbphaAj6xcZuZmtVSah41ZyqMl9vzGO6UODv8azOg0leVqlycpdNdLO/Syk5jXxnBDLrfhgG/Ve/+AN1h7rjBJdTmJW5Nrzw4hcCZnfqESrjViZYiM1S3fAMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Le4T09IOHSdAkXRu9STgbWoM8n7rjJTx2OgkvAztz/4=;
 b=dSi6E0T5uIuHgTqU7s2sHmvGZ/hkSMLo9nCdGL0ph/TJYR/TrLT00SYTKZd7Kcp8lKr9AlLB94OE5Nme03uDacNoIn/70qc/ywDUq0itOHgMaIZQDx0+VS+9+ccvA9acAAQO5GnhMDpg+jlWeJG2K0ZnL0GfqpTABA7oGs57J1iD15x03i+BRPOWZIcscBXv41JfRHchid0GStOGIvbPZjPBZ4zVdRfxTFuLkhVVOOcx9w/kpvJSdiQHVyoO8L6YB+U3VdUVFb6bmChQFJ1vPqx3+a27Rgd+w9saxOr6Pd9hqLfwyvg5JOvCCwzpDwyYjc7rI+MPf1qG4e2EQHLIfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Le4T09IOHSdAkXRu9STgbWoM8n7rjJTx2OgkvAztz/4=;
 b=c1fKGqN1Zjm2WWbm1TsphRXKrtvgonyDz0HBwSrcZWb9LRwUZ1a153Flk0DNLMfLtNaj46+trOiwG1NY4vzNBAaA8jefKrFQVIqFmkf0D9AJuvH+bL4wgSZH7y0MgwFvxuuHdiEnsXXJ/HWzF3pe9EbbHQ1qOFURyoc0yavax8c=
Received: from MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9)
 by MWHPR1101MB2254.namprd11.prod.outlook.com (2603:10b6:301:58::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Thu, 22 Apr
 2021 20:59:40 +0000
Received: from MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::a995:ea7a:29cf:d212]) by MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::a995:ea7a:29cf:d212%5]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 20:59:40 +0000
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
Subject: RE: [PATCH v1 2/3] i40e: use minimal rx and tx ring buffers for kdump
Thread-Topic: [PATCH v1 2/3] i40e: use minimal rx and tx ring buffers for
 kdump
Thread-Index: AQHXEKICsFmzW4FtlU6aSXFGeBQu6qrBU25g
Date:   Thu, 22 Apr 2021 20:59:40 +0000
Message-ID: <MW3PR11MB474851ACCF8ADCC33EA928C6EB469@MW3PR11MB4748.namprd11.prod.outlook.com>
References: <20210304025543.334912-1-coxu@redhat.com>
 <20210304025543.334912-3-coxu@redhat.com>
In-Reply-To: <20210304025543.334912-3-coxu@redhat.com>
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
x-ms-office365-filtering-correlation-id: 6e5d0ab3-a14f-4b00-7a46-08d905d18c2d
x-ms-traffictypediagnostic: MWHPR1101MB2254:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2254B90BD3BE8EA77F520811EB469@MWHPR1101MB2254.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yTyWEVrEkc2mHGB7u2oJpiGkXxgI94bcx52YNeJwuez3+tq0syKxy8U5ObgJyxt1qfsMC83YmUXRhd7b71OJW6PdSSPiVbOKfX2+XT4GElCoGWNsIFFJ0diRKrVeHIBtEe+q5xp14COrxsMuf7mQTmTwGa/+Qb2H5Jd/1cKB7dYIkFFRIbwrtL4+5GIvCtX3oLPQpaqeXWq1qnieMYed3I2Rmj/Ok8uXPjPUkNXPsIWpj0Vuh+Z/hw/HyZ6Zn/BgyOZIiOzPc/eFRkXbDUG6RTY2zCioduWbKGBPZZcHjpCDEaDa32xMc2n7Y5q0Oe6zbwh9DYI0HoZugi/14ISqtKxrXmQnTTF8+2hUU5OJP0H4w2Eqmhg1F9eZpenOOc5kLsMyg2EhlcKmUrz4UbCh6Qb6xcD4OyYIVQs2XH1R3o1H27r+UPdXpKIf8fYzh1eKYhh85ClhcK+g04RhByy/c9O0TIg3GFBLJnZsWNOX2Rf/6dIgyostcbwWptS8i+7Di33fTR42UKkbOE4Hf07kFmTp/PmJn3Dh+icjFg9bu5ldf4jAySvgrikkVLuPT0Jn6zxveIFmgTzhkxwIhY8eK4lceVMWjJxbWoKMn/86DZI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4748.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(83380400001)(316002)(66556008)(186003)(2906002)(71200400001)(26005)(122000001)(66446008)(7696005)(6506007)(478600001)(38100700002)(4326008)(33656002)(8676002)(52536014)(55016002)(54906003)(66946007)(8936002)(5660300002)(9686003)(4744005)(110136005)(64756008)(66476007)(76116006)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?yN5joTknpfwsjcnqiW0+SE0WhmLuRwFpTsghAD2zkP8E/xzZixttib6fLhmQ?=
 =?us-ascii?Q?vTQhKvPGXHFkqgrPoukvIATHRo+88yT5mYZyPir0mRA0zqS4E6CTc7J/jVXW?=
 =?us-ascii?Q?E3c0BUAtxgscuJuvdn3gaHcEIna/RDRKVJiblVcPCEhMG/zK3eBDZZeQpEFv?=
 =?us-ascii?Q?o3BpgRuZtDdJ9gQMxaO8rYj/8uO5kug5K2eDf+eZ0AVaa6oLPPjx/DiHyO/Z?=
 =?us-ascii?Q?PUWJqUlyJCpeBXHqs+1pPASOrK82oTbpar2bSdWVa301AeRX8sWzpG6yBKDg?=
 =?us-ascii?Q?tkA79AW8NYnmvCJb6EmtQ/1SkI2aQ9anmT8dzQmOqyBBxvutLZVMFBkQ8V6U?=
 =?us-ascii?Q?98TQOkAftWE8izdROHqsl7mx1axQiH68hHlTgIiRSR1LYogfuhsplxIeByMj?=
 =?us-ascii?Q?u11AVLrJRL48og6USxp7110o9SfYF5VcE2AW7v5rMFDWmr3OfHRe0W7EQzZP?=
 =?us-ascii?Q?xbBDU288MKW4xSAWpeW6y6nIhvopdwRsLlYjE0+QxlWpdUwCCIuuYXr/fxVi?=
 =?us-ascii?Q?TFTZ/PjW2ybVnq+M+wKyEBLvp29OqIucObOWLczOMgvQZJLzLF4vmJ5g3jYM?=
 =?us-ascii?Q?Rz0fxKcvHiNOsPmFkSJay5GKxH3Rix9ga1IDZMfZN8BNkc2dINI8vQs9oejb?=
 =?us-ascii?Q?cHKU6pdr3gZPuIiQDVwATHhdbZyBVSZb31vntI8GgvizIBQ7/idEohQhR0Su?=
 =?us-ascii?Q?UzE7ugtriOj/tw80Q/mOGAUCDOJGJy48kNi+tK6aAy7JsTrl6PMGwiR/zm9x?=
 =?us-ascii?Q?O9Ae4owG7xk9lyUFJuTCOI37EruO6tzr4BbVku4ljeWg18I3nVgoQa0inpPr?=
 =?us-ascii?Q?HdJJFF3SD+X1qg8+9m+hcWB93ifnHFoOTZ9Fs2MhOgQ26W8MbOy8wJdDygjd?=
 =?us-ascii?Q?D0uIUViezYBnoDnk9E676FpykKeSyYa4qOBR30rqqdIOElqhNl62VxfoERLE?=
 =?us-ascii?Q?9CdlTZ/T1MD40LiiX5ZOYTJ4AyMgWG2cuq9ufwWPMZl0A9762PmSyogY2t1I?=
 =?us-ascii?Q?s1vjFewuXzLbgxbV66lXvACiLITaHnX+zpSX2VZ5KqKxysExJIzOYOoGXgdS?=
 =?us-ascii?Q?2hlJT6APS8XALl+xC2lkCRsMj42gEgVFZHSR0kHfT7mANH5nbWNNZZ88YZU1?=
 =?us-ascii?Q?qWH0uLZEq6XUcMg8QU/pp6BZMJNrtT1tP+BlBr5Vvx5vdjADTlx0PQc03Jd/?=
 =?us-ascii?Q?meUAYogaTVq+Wp6wVXshknBIbsrQ0LD9aAOcvw08RwaJHL4PQcWCB+7iKlvK?=
 =?us-ascii?Q?JTttGDoyKjVAv/+OWjl0h7qNNgT0sk/kIj6F6JVeBQn4jMhF/Q03BYgemRGA?=
 =?us-ascii?Q?pkw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4748.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e5d0ab3-a14f-4b00-7a46-08d905d18c2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 20:59:40.6635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fI/tYTQ8LgyF+Wzh96lynyUkRVvxQRQGsDyQsmNz3bGf3xzEgAw7nxMU0SI2rBCTYMxuX7O+X81RhUW/H+SCDQ==
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
>Subject: [PATCH v1 2/3] i40e: use minimal rx and tx ring buffers for kdump
>
>Use the minimum of the number of descriptors thus we will allocate the min=
imal
>ring buffers for kdump.
>
>Signed-off-by: Coiby Xu <coxu@redhat.com>
>---
> drivers/net/ethernet/intel/i40e/i40e_main.c | 5 +++++
> 1 file changed, 5 insertions(+)
>
Tested-by: Dave Switzer <david.switzer@intel.com>

