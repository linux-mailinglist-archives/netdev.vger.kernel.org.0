Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4449C4D520E
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 20:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237730AbiCJT10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 14:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244932AbiCJT1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 14:27:24 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02802137029;
        Thu, 10 Mar 2022 11:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646940383; x=1678476383;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7RkO6gTwnsj04h+JidG23EXxvD9Gs0Se0D3a0tj1gl4=;
  b=nXfpzmjD4TjgyMENR/xw7RpQQoWfXVSJdNhovCcJxEncyQgsq1con+T4
   /vSrv4ZZJ9YYNNBQudijbx7hSTgz8s3oUYLIinz4mBNLF64DpoeqJJHW3
   FmgScik37lcIekbjNxJ/lTHBuGly30TjjPpKXtJOGMQNZ5w8p72tzqC1r
   90sIkv/jYt/n46g7xQoO1PkLWWYfsd54VxzkDaiIlKnE6VxRBsy5qBgyX
   cK/zKx5MXPOkkk1HxRAVExeTBTzl39XrsNQ6bnCdx3HcamWBcNcVy6oKV
   ULKdRaq/LsmjOvLEcXU+yN7PMpIXKIz1uYUhqw5IPkB1Pvp21XhU9HvAP
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="235301499"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="235301499"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 11:26:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="578923523"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 10 Mar 2022 11:26:05 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 11:26:04 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 10 Mar 2022 11:26:04 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 10 Mar 2022 11:26:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhmEg+Rh8k8jP90X67rEGlFApbN3+o/1QnDX79aH5+7wiiro5a19cVBlCyfsXecZxy9u4oz29TQApoOGNxQPf0Y94AJY1T1boN7CfowJwFCrG3sJ3nTDVTxVv6SiP+0Fo9Dsq1xzHuampmKwRLeYH5YlObdKXJJVzCIxLGa2fp1kzPMq3opySeB67mJjgmnn4dplP4jIfVushanyv4DELU1lWntYkuSQcF1YC9y1Y+lFmp2YYbC11QbSBhFqmA6wu8+5S3LCbzaI8wKLHLJ1IqD4Ok7zuSqmwvHEyU607nYJpmcESSkVTqvMLG5+RUnPuCr36vAO0Adlioe5R1gcRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkGG9ARXyOMFIKdAG7KTdnCJeedmBVYbTCNaDcb+Q94=;
 b=oCnrSurSysdNOYnUDsrrD8rzRI/r+DcBt8Pxpxhmb4rgpH3775LiJ86ZHUeLbTwf06xO8tUoc4DsjVPd6p0Rbsc4zO9ZCu8RPaJWYXgPNGle9rgnq31kNs7huWpVpfMTCB06IQ86NR4MCFj4YlijNnRxc8C7jGkuPdV2UeUtV2agwMmUEot/HuJeIb7ugTw1r+KoBLYzeTCi1znPXsUYucBqnvNFjI6SZx0bys+7JABmaKWT8pUlaLLnjYxXsSK586bBQG1pAm58VfJk/bSOPcB+EyQCKb37Rcpd+eagk+Yu9Jwx/Z4o4UC3igglEKKcUWiXHUUv5zA+rulapSePGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by MN2PR11MB3776.namprd11.prod.outlook.com (2603:10b6:208:ee::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Thu, 10 Mar
 2022 19:26:02 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::f02f:1868:e11a:ce8e]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::f02f:1868:e11a:ce8e%6]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 19:26:02 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Ivan Vecera <ivecera@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Petr Oros <poros@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] ice: Fix race condition during interface enslave
Thread-Topic: [PATCH net] ice: Fix race condition during interface enslave
Thread-Index: AQHYNKcFldlqr1eV60WCnd9uUWOM8qy46eIAgAATIhA=
Date:   Thu, 10 Mar 2022 19:26:02 +0000
Message-ID: <MW5PR11MB5811049F89D38725FBE7FC26DD0B9@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20220310171641.3863659-1-ivecera@redhat.com>
        <MW5PR11MB58114999381C7B98598BB568DD0B9@MW5PR11MB5811.namprd11.prod.outlook.com>
 <20220310190642.556063ae@ceranb>
In-Reply-To: <20220310190642.556063ae@ceranb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: add83706-183d-461f-3862-08da02cbd0a5
x-ms-traffictypediagnostic: MN2PR11MB3776:EE_
x-microsoft-antispam-prvs: <MN2PR11MB3776E27C4BCE7986A99A4535DD0B9@MN2PR11MB3776.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1kwbo9iQS7kGNIPR3cC9CucdCq8Ka1+rtEvoQvDj0FS2JwvZdOZSEV9UkxwFP23y0oAvNwDDMPYleMI1A4plkDqYEoSLgptXc8lNJAREPXIry9SSRJp4bxKTSdsyVXouZQMxjlVuGKcc6IApoBeEnSFZV97o+f7WDBuE1K1KWrrJAB7vR3pEOfxWTKHwO0pyqfPZJXTZQAKbe6EIDlM7t7JyTtVXNOUSTAj6pfpOH4WLeolnefamHYq0hAxG6p2CJUvw5abBfLnQzmS5gN4+lU7rcvJmCc5xwXJs+tr/nGZUyLD7RO8xlPlar6PockP9xNMncoUtalsH40OO5YXZx3Wf92TXSA3Ji3DkmsC+/anB7H4PMZGo/wlq+TpTkWE0wD00ogM5IEpXr5BY0Q2xdnIFMXUmsjPRj4nrEflCvG2h8YpGFSQbYrEDFl6ZCQIwkXRdOBZ8TUOD7wpHz5DzmbNYa4WLblp+JSJsbZFHer1Srgr2tf6aJaDpQH0LSlXwR8QmzknEeYZCdDRlHDGis4jWLLj4NUswm4HfkLnQfJAOzJsxxYmQDmMoc7TEkmtnpTKh+tlIVLJu1rFD62Fjf2NGg1zmIZJuAdSCUelkk2839aMJy7xvYTVzKMeFH5HmIZ37pIl1FTWHEJcxs604O3Dpepp1/PF+9P8FuTnwzH76mDZKxOTwZsl8D1RSzMBarMayZT1M4f7uvRPZMgoOeQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(38100700002)(122000001)(83380400001)(66476007)(8936002)(82960400001)(186003)(26005)(71200400001)(55016003)(2906002)(54906003)(33656002)(66556008)(508600001)(4326008)(8676002)(86362001)(316002)(53546011)(52536014)(66946007)(76116006)(38070700005)(64756008)(7696005)(66446008)(6506007)(9686003)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2wNQ+l0edElA7LwrlXDeZMvRKq7AsjEuHaVkuJPgt/jBSyIvfznQZ1Dy9her?=
 =?us-ascii?Q?RGWne17ZyDvSEaLqkntwO3WVPCL9CQh5QFq9cyiyfrynXN54DOM3l+ca42oW?=
 =?us-ascii?Q?X8Zg1e3TT00ju3DTtTvsyBBvO7ytlC/sIY7sEZgkRZAwYHBW5tcs3IV0xO0n?=
 =?us-ascii?Q?KssQph6Q0mHtbbbfytQuklAL4ofkc5zyD6V7xGnlCmxq8SL24G/jAMPyaWjR?=
 =?us-ascii?Q?hSj8sNU5jWbA7q2BUBKr8oLgCmdfyxe/DNiODb+Y/M/VjYqQyNriIXoD+hw8?=
 =?us-ascii?Q?7lK6Sn3RLv1HKcNkjNTTCzOx8h1vBLlCctABZI0f63iK+gf6BEw21kG6+Mj7?=
 =?us-ascii?Q?ODPF9g3tk7MMyx6nRvUe8r13zjZFQQjx/9lx3HAD2uV4DsJyEiXpRH/cjp16?=
 =?us-ascii?Q?6izEXQHB67rD6Arq7UKtBe30U4ksy2T+YpvYHrLrafWJPZ2LnPB0c0mt/0M8?=
 =?us-ascii?Q?7xCVMCn5HihdDmS9EeDnE/nvfcSQYoMTe/uAiEqUrVrwXcy+fCj1rVFOMRgR?=
 =?us-ascii?Q?Lo3F5shNqnTuLDLSYCAnlsvqzB0dNH1QbYBLqg6zVBa0pEcZt/0pxjnZvoth?=
 =?us-ascii?Q?Cc6ASNna1Z1f195bA2D+Vzg8iLwzCR/T2rh42GSfJD2yK4LGK3uYGFkBH/hE?=
 =?us-ascii?Q?itHTob2ElHSPRnkteHHjIuaIMukUYqK20nfIOCvjnzoCVeZlxRHDo2irABMB?=
 =?us-ascii?Q?j0BOkqtXJWe8wWPpQwsF26Y8rxOXjQRtbf/01yiDeExGsllApt1HZf0JikOp?=
 =?us-ascii?Q?0B60CjkIWoEYOKfTyAw3yvcoyeIx04phEGnCHzlVJ4ab+lRsitPQ5RgZYz6H?=
 =?us-ascii?Q?Ux95heH8rcSjFsYjzrfkWTYn+vl5IIugctHwPq9XnUiUz28iNtazbMlCBwoT?=
 =?us-ascii?Q?SkPvfymu9HC4Y6nqG2EnBvIE3BUcZ9fzgIGhsH67pcLkRfYo0J+kMfJ0RZJI?=
 =?us-ascii?Q?5yYoUoABSBTs+0tK+JShczbCJXhhT+GKDpDc1CecMwDSBVX/eGjT6tUyNBhT?=
 =?us-ascii?Q?plfdI3mBwJfwApUkKAmV0RS6D8xEa8xhDHRALwWKTIj2zJAjsMpKCNaTi9j8?=
 =?us-ascii?Q?xCqt7fQUvpB/uiX/mNJC4ZZorV7RIjgHK/aBwmQuf22kexpxh3iR8+IvY3S6?=
 =?us-ascii?Q?IcfMSvwJc9NR2C7+lcHWhbhPBGjV+kPJgq4p4c2Pa+zVz9194E9wwz/DYdne?=
 =?us-ascii?Q?SAPqb+ftbQ6tO5qRFIv3wbaZfDfysDyVBlcYCaVSMJU4Y7ajbIa7H+FrdWWY?=
 =?us-ascii?Q?IQARIlehHvxjYYTgzu4t++8dGzU+BXecKPJKb6i4tu4sDi/EktC9GU1mpGu2?=
 =?us-ascii?Q?9mPHE+EZS3wRTsKz6wAwDk/kDvj1Wg1b2kxS/Q4h8QAPkC/QkfrdkQS+0LOA?=
 =?us-ascii?Q?4FyqLhszudfKq/K7M3JnUkdttDWtm6s6R9ALqo1D/unJr45cKmbi5ooV0Lu0?=
 =?us-ascii?Q?bXM9/2j60chAN/fMF7Ayi8HxlquXGC8Ti//rTZ1TVhzTaV3lgTUCw6Ua6ENf?=
 =?us-ascii?Q?PUTO4pCvS+PRa3qZZOOAtGwvu4kFQDWTMZeGUw01/ATTRXw/tuirE1Wnm1eG?=
 =?us-ascii?Q?PJWMEwMIV/4w1Lb5GeYPzeGktkhMaKVmzzL621nNne1TsJKf8Eh5gOR7nil+?=
 =?us-ascii?Q?uLqUYIP7cbIJNOw5jD1C0N3Dgp0v4Ifv69aGPH2dpbzLd2PFQdLZk9dBhyKa?=
 =?us-ascii?Q?4ahrZg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: add83706-183d-461f-3862-08da02cbd0a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 19:26:02.7032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mVBime7XVbUxE+nevKdApOPIQn6jNDW17E3xAQtySTEHaGmFsSW/6Dd9ZGBeGWybOMY8AFrgQjKP4OggasU2ea1FzahMOCJv0ZDf8/f6Wss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3776
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ivan Vecera <ivecera@redhat.com>
> Sent: Thursday, March 10, 2022 10:07 AM
> To: Ertman, David M <david.m.ertman@intel.com>
> Cc: netdev@vger.kernel.org; Petr Oros <poros@redhat.com>; Brandeburg,
> Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; moderated list:INTEL ETHERNET DRIVERS"
> <intel-wired-lan@lists.osuosl.org>, open list <linux-kernel@vger.kernel.o=
rg>
> Subject: Re: [PATCH net] ice: Fix race condition during interface enslave
>=20
> On Thu, 10 Mar 2022 17:48:16 +0000
> "Ertman, David M" <david.m.ertman@intel.com> wrote:
>=20
> > This only addresses one case of unplugging the auxiliary bus.  Rather t=
han
> controlling one instance of
> > calling ice_unplig_aux_dev(), it seems like it would be better to modif=
y
> ice_unplug_aux_dev so that it
> > will pause until any plugging is done by the service task (check for th=
e pf-
> >flag bit and wait until it clears
> > before progressing).
>=20
> You cannot wait in ice_unplug_aux_dev() for ICE_FLAG_PLUG_AUX_DEV to
> be cleared because
> ice_clear_rdma_cap() is called under RTNL.
> This patch is a counter part for commit 5dbbbd01cbba83 ("ice: Avoid RTNL
> lock when
> re-creating auxiliary device") that eliminates ice_plug_aux() and fixed f=
irst
> part
> of deadlock and this patch fixes a second part and eliminates also
> ice_unplug_aux_dev()
> to be called under RTNL.
>=20
> Thanks,
> Ivan

You are correct.  I forgot about the RTNL context!

With this in mind - I agree with your approach.

Reviewed-by: Dave Ertman <david.m.ertman@intel.com>


