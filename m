Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEAB86E9D88
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjDTU7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbjDTU7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:59:18 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E18230CA
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 13:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682024357; x=1713560357;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DA7K9zAdo3eAxau8RqCgBmRWYOyCz23v22YwT6fj0TM=;
  b=niHyTijQQ6syU5aZx4UDXu91VXYH5Vg0DfW2FChonjXLDKt6g6JPZdH3
   KshF7KreHsVwdpH6uIa69pI3W5uxv8ln5JxPhYt4KT0qZaFrDGYNQRDf3
   NkaPTEnZKMhbDpu5CUUMdKRVxU6BeS3dVILYcQhxtk491C/26bV52DTB3
   0XeSvDNkDGu7VgG3avT77/eims0C613X65c5kOq9524VX7jzg0+8oKHxy
   CQ399Ij+uG/7pqvk+XHfbRh8Ib6xtXoZburBv7Ja/kgY1gXPjzphmynaV
   L+VboMENbSsPuyhhryhLfnh3J3oyTVr6WRZ1CIQE0ZVtp8vTFg1pVwOLH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="334718901"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="334718901"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 13:59:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="724563752"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="724563752"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 20 Apr 2023 13:59:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 13:59:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 13:59:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 13:59:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 13:59:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGtb9hm6xC6Vn7x/z6wsYh3a0tGi71dfLIEvWeQ53hCk5xcyDg8ZpSvC/ebEAgbhlu27osrsdLJRq8fQYOJLKvt+zZNDPkB3CGCb7aPIYmuwcoeppyCYsc8dOBi5ZL5D5ML6opfTSHcQqIMKL3ZtMWdeqItW0lWCfjXslAD2f6CwEUMPMxieLWbt+Ieb5CgyHKiWiMUG1fLhRib9vchDvPaCa0Z/1aIjvceDY+6NYimnUcj2m5Um8bl5hKba3Q/i3geDgRYJkB6Ep7DK4IbVOy5ccrQKBSgd1CtsbkePCl7aJepViFrHf7trLNW40WKvdo+RP6UMYyJwWRODonFDtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mbGoO6OOYVJNAe702WWOCwpzT4X1azPjVuu3XO2aDM=;
 b=MRcZLfVV6iGEi73fuPdDstmwvgpHYNAvIcvzDxYAkhx0xrZLiKXj78y24u0vmRwYE3nFrgnoOVHSHcOaZ0dF6iwbnUdduknw/XyYpqMn9UmgcqTgImvoFiffsfRxZYln7lg9YpnAUtgQ8lcpgCctHUYPb8NVoba6rX4i4dwYFiVpqXw8Ex0MRA4JMRU955nbXhFu60aYRZs6hfiimKzfy/Rp1CwZZjpxP6ll21nvmj/aCfdknYOAuSVecAgxyICndUzIQFSm9Gz5iIU0mHYrgE5BO7EWXw7TlUiiwjG3bLLBTTs1oXb/bqkkpDTRydB8zEW6BdKMtW1WzYIPRUzLMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5028.namprd11.prod.outlook.com (2603:10b6:303:9a::12)
 by MN2PR11MB4517.namprd11.prod.outlook.com (2603:10b6:208:24e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Thu, 20 Apr
 2023 20:59:06 +0000
Received: from CO1PR11MB5028.namprd11.prod.outlook.com
 ([fe80::bf74:c4e3:c731:b8c7]) by CO1PR11MB5028.namprd11.prod.outlook.com
 ([fe80::bf74:c4e3:c731:b8c7%6]) with mapi id 15.20.6319.020; Thu, 20 Apr 2023
 20:59:06 +0000
From:   "Mekala, SunithaX D" <sunithax.d.mekala@intel.com>
To:     mschmidt <mschmidt@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 1/6] ice: do not busy-wait
 to read GNSS data
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 1/6] ice: do not busy-wait
 to read GNSS data
Thread-Index: AQHZbRemsewlUEPBK0ujknEpJGwj2K80twWQ
Date:   Thu, 20 Apr 2023 20:59:05 +0000
Message-ID: <CO1PR11MB50288BD3E8FBB9A924590AAAA0639@CO1PR11MB5028.namprd11.prod.outlook.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
 <20230412081929.173220-2-mschmidt@redhat.com>
In-Reply-To: <20230412081929.173220-2-mschmidt@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5028:EE_|MN2PR11MB4517:EE_
x-ms-office365-filtering-correlation-id: 92d1dd16-8b55-4c6e-4ff2-08db41e21434
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LJUWUE10GKdDF0HjPaTTs9LNt5leq7ek0rL/+91B15kktu67dRtbmc9UX8ZJz9/niECipjQC2LDRswre+RN3RuI8y22Vla9n3H9xdwlAaFZCS5H0XcIzsPKUsh2Njn5KH08l4OQdniNbfMA1mxCbQUjnZoKwbfZOJnUWpYR37i/uhbJv995vfvaRKvXvkmzJTzSOyRfx2fj3Y04Pstsq7cdoae8vrSPKw1gs3j6viXfXgtlpgmhrh7Mb4g/ZYiiWWkUypRawJXrWoH0vE49eWuCxzH8vf8uKwDXPewnCy8bJSjqoR4XfymzGUQXMuurkX1KvG0jzKVfpQ7yJjg7cTnJvXRnWycELybm2vsgR+VM1Y0YTqcGQ4dreY9ycbSuLrQxKnlYAzUwK70h8KfJcuIJIClNt7nn2s6jP6YwnljHY2xO31p1SfC/pqW35UaaqfOdRgI4FV/twUpG/uoi+bwf7lg1UcNUD3DcWsEkphTvXXiPisnwYBzi3BJ25nU1D8yLZqCFnKtq2sFXjfM7XANRig4WoeXasAdbQv8C5Nob+8Xw8dITw1HcrSzImyMwOyjeriEPWPuvvNLj7qmlw40d1Dcsshotcqy/XxnURqy6tCJg3xwb4sKUofRF9zPzo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5028.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199021)(38100700002)(8936002)(8676002)(54906003)(122000001)(41300700001)(82960400001)(5660300002)(52536014)(4326008)(316002)(66476007)(66556008)(66446008)(64756008)(76116006)(110136005)(83380400001)(66946007)(66899021)(2906002)(38070700005)(186003)(7696005)(55016003)(478600001)(71200400001)(33656002)(26005)(86362001)(53546011)(6506007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/IYv8+fM38BFeubztI+Htdrm3IoIfWkcFRZni9VrSgWZemStKtKEresa0r8K?=
 =?us-ascii?Q?L3ve8hxSlYMF5V2RKh3IPFL1Z/Y/wJTUzb2I1Wkz4TRTOAeyrO6Z380r+tII?=
 =?us-ascii?Q?CPxxCpr0n9+Jvh0wk689F71XhvL1y93543TVRb6PTd4sV83+6TGHCZ2FkHbA?=
 =?us-ascii?Q?gR2rBJuYU9QSZzK0Zn6VCbsHoV5ORg8EQNTZc/B8mNXxNsfzgZSdxpjxOnVw?=
 =?us-ascii?Q?wOiOO7WG8cFpxNWfahRYkCGRMEFSQRE9kYsa6/k9nB0mPUgqtphDUIWNGDLI?=
 =?us-ascii?Q?DPUPOGg0HYfQUHxGUVMX35KKUXWxXADpaHUqe4Yyh42IMleYS2aehPzBN0Ij?=
 =?us-ascii?Q?N0ypnt7YrKUV5z1DfEoLB+7hFlxPxdtPSjhZOYPDxQNTLLtlsEngKTZ4thL1?=
 =?us-ascii?Q?3Ek8QfqNueuUNniHdrVrNhGP+IG7PW+Z35KTq7xr5P6IXxK/H5+excbXzzLh?=
 =?us-ascii?Q?1hr3IwRtbQ32EqecQMFnJnKypP5jEGI7nSWhMKlzA3RHNSWws/E2Q8b4AduM?=
 =?us-ascii?Q?4nDU8+Ok+qCL00zzYIKV93GNqqlWXD0sz8Oz/U8QGwwHBoZgWC1ERS1Mr2aV?=
 =?us-ascii?Q?JO7i2+tJuqYbH8IeUwFbD7NMu4HQBm1DLO/ElxfYnx1bHxntoI6x61SnWnWa?=
 =?us-ascii?Q?68hd4nGmEj3aPH5AaEWtY7Yze4RxqhtQiObMLZaDLgKsk8a8RwQdoJvMw58A?=
 =?us-ascii?Q?BPkun9P1BDOMCBmYmaZNSpHlmo07kQ18NllhngWAifslPNU7GTJCyhchXT57?=
 =?us-ascii?Q?IhcBlvgUpz2wC8hDGKulRok76w+pp2pZcd34HMtT6BA9vGfdASAvTaSnjau0?=
 =?us-ascii?Q?8gg5srK7zWvrKC7kdiZPjXy7GXKXDKVnISxeWqBBTbpeQjvTCrZ5eMjJuMVE?=
 =?us-ascii?Q?lCEt3Sz8+NlsK97YexhyowUUDf9UZzWE9qH2p2RujTYF7lWQNyiyhmnkp+QL?=
 =?us-ascii?Q?tQTbnqzNTqJdKrrAlTlIqzHY9Kv60ABz0vxnFS0OAPaY1/UQZwOonxvhGMJx?=
 =?us-ascii?Q?gUOlk6B8HARgaGIsTYq26T8BG+AggRIhYjnEOfnsJmm91JIB46zKsKfQ1u4A?=
 =?us-ascii?Q?3O53u0AEAMgNtD5Js4nGeNM8u8bUWD27D1JaxyD3NF5iMKYOPF0QKqDUKWxq?=
 =?us-ascii?Q?KLp5cRV1WC8T7DI6uqoS7Xu6yBDjG9Ht/mSmqUUjdxBwyn45cOReYCCZH6nl?=
 =?us-ascii?Q?beKxPtIfpScTxsD2jI9bfOsrYw9pYJat6X66GtYkEb5j+xr9sfwiM5LpQDaP?=
 =?us-ascii?Q?+mwbuqQPnX2faHF9ATSjWdQnwKQH6ELiunOTX8BXtV2CVIbj4rFiuHAOtSE8?=
 =?us-ascii?Q?R0AfCm+Wg7PPW3oKh6qEnukKlVVplMSrrwymlVstVdGRV7T32A2+E6QdyJeG?=
 =?us-ascii?Q?aCOjVZKGF+BMqbo+j3KkrakF+eaWKcvpPV8um4D4UGGlBWmNjmA7rf5Y6BSs?=
 =?us-ascii?Q?JFBAbHY2JbY36FUBKF6mI8hFz8TWu25jpSghxIsYs/d9iGpLIA0WoNyey6Gj?=
 =?us-ascii?Q?C9XzNvBeeV7582jaRAoaxwaBerHzUWVYIg5DEkgtoS0gDZWbT/zn2VchKXfV?=
 =?us-ascii?Q?yCehrRikSrmuOAXAS26hiVJceUCBuk0/xQQBzrbSMCC/mnzdZV3PHLd+Jc31?=
 =?us-ascii?Q?xw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5028.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d1dd16-8b55-4c6e-4ff2-08db41e21434
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 20:59:06.0019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9RJrvfmIs/EjhKaYDPXHGzLQMrsdUvtf4EHyDTBLBfqdinbF32PJJmhUT0LPq3unmaC8aM6+reQ2cJxee/Ea//ePsJrNkPE8owMppPb8oDU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4517
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
ichal Schmidt
> Sent: Wednesday, April 12, 2023 1:19 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Andrew Lunn <andrew@lunn.ch>; netdev@vger.kernel.org; Brandeburg, Jes=
se <jesse.brandeburg@intel.com>; Kolacinski, Karol <karol.kolacinski@intel.=
com>; Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Simon Horman <simon.h=
orman@corigine.com>
> Subject: [Intel-wired-lan] [PATCH net-next v2 1/6] ice: do not busy-wait =
to read GNSS data
>
> The ice-gnss-<dev_name> kernel thread, which reads data from the u-blox G=
NSS module, keep a CPU core almost 100% busy. The main reason is that it bu=
sy-waits for data to become available.
>
> A simple improvement would be to replace the "mdelay(10);" in
ice_gnss_read() with sleeping. A better fix is to not do any waiting direct=
ly in the function and just requeue this delayed work as needed.
The advantage is that canceling the work from ice_gnss_exit() becomes immed=
iate, rather than taking up to ~2.5 seconds (ICE_MAX_UBX_READ_TRIES
* 10 ms).
>
> This lowers the CPU usage of the ice-gnss-<dev_name> thread on my system =
from ~90 % to ~8 %.
>
> I am not sure if the larger 0.1 s pause after inserting data into the gns=
s subsystem is really necessary, but I'm keeping that as it was.
>=20
> Of course, ideally the driver would not have to poll at all, but I don't =
know if the E810 can watch for GNSS data availability over the i2c bus by i=
tself and notify the driver.
>
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> ---
> drivers/net/ethernet/intel/ice/ice_gnss.c | 42 ++++++++++-------------  d=
rivers/net/ethernet/intel/ice/ice_gnss.h |  3 +-
> 2 files changed, 20 insertions(+), 25 deletions(-)
>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worke=
r at Intel)
