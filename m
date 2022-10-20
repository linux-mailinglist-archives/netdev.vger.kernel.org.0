Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679C860555E
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 04:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiJTCQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 22:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiJTCQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 22:16:30 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B30B16E284
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 19:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666232189; x=1697768189;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HV8avoYgqKVrZTGTDxL+kYE5fjN7Jk9Mze85CgjkMug=;
  b=ncm1eoVWYSjNtwMfsR0CL5vuce9jN8UdYktQ9e3UrTghDS6lqAXOIq4t
   0tv60aVjDRT3dFRKv2PkcNyyHrfB//AcOH5dGz8a32IPlWARHgeBShi/x
   kADgLSK7tC0euRSGAWmy1s1VURnSKxPeewz9rC/HoWingx3NVGWUq5pHn
   ob3MMZxb7Nqq+uJXTO468/nTyJa7LVC8/fJ07VGrKI5POnrl6PVIN+14g
   JG42LiivpERtHbc4GNG2DBykj26VaMsejI2MU0dt93IxyzmLMh7DLvLHN
   WFJpBwJ+MU55gyBQDT9ejOaob8YlF88Nugl68Bt1Pyhv5SO9Win9kkYxq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="370795232"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="370795232"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 19:16:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="874725401"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="874725401"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 19 Oct 2022 19:16:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 19:16:28 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 19:16:28 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 19:16:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/LkbVlnQjKX8TJpwYCwVUMLeJVmZV/22vleUXq+PNz6mQzpFR1jlgr/8qlmrx3os+XVEsliRenPazgJv7kTJ2TwpJZ0trZqUaYlHau+j8wzgeeI1KCJUQXbCOAnTPGSbn+Mze6idutr2a/OgbwutYBU1et+jMobZWo7ZLKVGkZ+BcwKyMxTEAE2BNPKItjxj4xIZoAUAvdmFbs6VUz8asmoApDuqXh8o79TWJbaXDiAgAadSa75RV+uD9a5TSESbw0QUVp/cfecL9kaXOhHos7XoqpBQhbzPeNq6bCyGqAJNEp2LuPBrgrOW8QWakN0rvSrJrBMxqFPTe6eQyj27w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEm5utyWRaeo3OxAsqihEf6aZ8JV9avhygdsVXLLx2k=;
 b=HynYEtMaUnCdUT59Y7EqKYfGRbFtJVseg7AEb82JagHCsDLqHFGXOQUC8q+tJESuY+Ddqu/yqw1L5ymUKSzr21n+N9/jLW6AuQxD2WHlcjhmUeHtlMqI1Cdpx2U411TTa/E0vxvlnT+gCaGkq6o0sB9vxsNjAzib6yQknR/XPe0mRDui32ODUzed9bgnRFeZTHui7HpuoffSrkIjlqwwKmxMPnRY4+I2LPF8jWrSbhtCg7vQCyNmQ4Jgle/fONe0KWFL3n+M+zuOuM4zTPSwjgQhLZBw2O8vX3GeVrbzPf2aAJXyJdGADYf4vVgcvCgy6iQ1+xTjfcIsE/yW03rlUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by DM6PR11MB4513.namprd11.prod.outlook.com (2603:10b6:5:2a2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 20 Oct
 2022 02:16:26 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::ec4c:6d34:fe3f:8c60]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::ec4c:6d34:fe3f:8c60%4]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 02:16:25 +0000
From:   "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>
Subject: RE: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP packets
Thread-Topic: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP packets
Thread-Index: AQHY4o49ev0KReGUxEyWlnOqPWSac64Ug1cAgAH7JRA=
Date:   Thu, 20 Oct 2022 02:16:25 +0000
Message-ID: <SJ1PR11MB61802672AFAA8A4B0A34E81AB82A9@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
 <20221018120254.752de264@kernel.org>
In-Reply-To: <20221018120254.752de264@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|DM6PR11MB4513:EE_
x-ms-office365-filtering-correlation-id: 40786325-5b2f-4dd3-d096-08dab2411737
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AvpD0JH12I00hzfY1MDAK4h4yfM+kh1axQ3jMj9Rg7uk3raT2cKnDm7xvHeAUhpR2xBskSwWiLInsrTA77q4+o8uYvq2vdjs+wP/hpqCakhPMHwB6Np+ayGMlPj/tD+SirINQ/LmlGgB4Ik7+2WLVLQVd3Oi989q3Zic1drCDYQF/jP/48iXd9AUAbCmj7KsBy/s3cQxkQIQKdfm/jDF5zKkOEj01Ng4xNbWCDAp+NohibT9abFUdSgUIBiKZteeHzrBQa1/o1IM3755YrFXhO52T0FdmHz76XUvBjPLmw95GpzmUlzRZyj3Mr0Qkayt110CXIlP7fVyI4P7AFaQQmTwNsCoPucXWU5i4obfi2W7QP1YJ5VnNkeC7ejkPzNUZj7Rm4Jl3saR/AXeCi5DD3Z2xnMUDE63WSWWJ9PTvF35nOfOT0NvtZwsxmFB++wHKw4qbjRXdGAcmI7iYXDMhTGg2Ci+V3LvDubh6FBJtnk68gWaesN7edl58aVhpr8gStM4UnDrdBpUj4K77I3/wMDBn6Yjja9p5oWxnaXIeYkQda1TvIqw2rM7UvaNgDvMGZzV0ErgQtuJO6Ym9Hamuyl7a6kxKNlpaoW67Bgs+Y2MXQNuBmT6ib4JHgO9QL5WefYsU+H5EX9NLxpaLUUYc3YHc4h5M3dXJgZsp7ZEYiayc/LSYmafeDEBs1x8fFlRy/sf7ztlq8ko3MYYFq9mtZbUHfywYY6jCEHxvop5GqZy0010f2SZFY8hNMvoSRIWodfWoif6mNO8f2KzgpK3hm3p/l8sKtjPTvKj7ZfuKTk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(366004)(376002)(346002)(451199015)(478600001)(71200400001)(83380400001)(86362001)(966005)(5660300002)(107886003)(66476007)(66556008)(53546011)(66446008)(8676002)(7696005)(6506007)(26005)(316002)(41300700001)(9686003)(52536014)(8936002)(6916009)(4326008)(7416002)(54906003)(186003)(55016003)(76116006)(2906002)(33656002)(66946007)(64756008)(122000001)(38070700005)(82960400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5/s2G1MWsttReN13/BD71JjS6D0QRiOvnj7wBGt8lrf39jvQnBQf94dF5O4T?=
 =?us-ascii?Q?QcYA6j2ZEhKXF3O26HKptE7VYQFqAuPyIJIhistX8rM7jpIGzVDrxtAUH7T0?=
 =?us-ascii?Q?BLBcVBJ3lrREftDQqqqWzEbwjqI49PReqpx9uX76wExXgmtwu43OgPOJHfKj?=
 =?us-ascii?Q?2Gd0pJey4+mYXL6+FOtqXJLtNTTMti+GohSYzWaxpumBupoFZohy/38wX8SR?=
 =?us-ascii?Q?EfmczZnr4osX+IM+gke6Ph0SZc7QftwdrYjZmP4iDQd1zknm9zLp2oU/J/6I?=
 =?us-ascii?Q?cxWFcwHQ3QV4yKCQvYjD5GLTa7rYjMLv0t7e5oVij4nbo4e3G8bmnJgEBXJR?=
 =?us-ascii?Q?zCBVzvrwIT7PdtE3PrEdrum8tdT9rJBiSQUdVtNPb4TL7AelHTUq0/hCkkUX?=
 =?us-ascii?Q?dT+5LEXaTzahMfwfubIQZyaNjvWjI5jR3EQAJzt5UzPPWvcm2UtKzHx+bj4P?=
 =?us-ascii?Q?XPs1+szmXERoamhBX5EzpyS5Xk4nnw7gy4qv46xxWpDR16qQsOcXiw7gpB3H?=
 =?us-ascii?Q?F+Gl82LNAuXj4FZzTBZmZxwdJTAztQrqhs+M4UtV1V2W5Ic01IRYuKjcDdfo?=
 =?us-ascii?Q?iIYX4NnNmOpT9nYW55HqQ+mvYzS4oSS+dO0emH6/7/4DSQr5NmbvUPI4f8KG?=
 =?us-ascii?Q?RQv9MsBdiawapEsE7nB4oJUVr648vl5ss9bvfnjFC6+cDfLDp2aobFBQN2JH?=
 =?us-ascii?Q?YuiOWs/aMWmfNmVswdN4UXQu/Ud6iHyYI0Jo+fQ6YbFQi5pLQajMGYjBxOtD?=
 =?us-ascii?Q?mIfapFKTt0Nvbedic1PqRLU9o95XQp3u+MXyyO0kT8hqcR1qZSSb357io2bQ?=
 =?us-ascii?Q?y16YuciWtGVoq3AuJ5e52dbKF3xqEAdPIXY3CDm4XTsFYVBTik9ZYaYtjX+3?=
 =?us-ascii?Q?z+gDklG6fVIn5bJtoAKddEhImJ772RFmCrV7zirTesM0fQRLpUktX3u13lgy?=
 =?us-ascii?Q?df/1qKGzj3Qfm+NiYQNwkGfSAlxIPhUzYtlJAKPh9PQOBPAiuLyFyZZfixTj?=
 =?us-ascii?Q?0kxFLEB1+T7IMQCs6Wa9PGWQk+CPvYjs8l+bq3NSbSC5FHaN7QGGp+088fX9?=
 =?us-ascii?Q?3zit74eCEAMIv4PUPxfWY/v0EuCrIrj11tymhISmMPpCn6FLrWHrhqnTGmEk?=
 =?us-ascii?Q?uQVftzPH3Os7QmLfD/shpYN+yX3DvqbyzSIcQmHyWFQXTuo1lToi2vjpEdqh?=
 =?us-ascii?Q?a7s1lhafkW3dUZOV8KBN1Nj2tQoAGuAzdkR99hWLYmeX6flF5YxlwYJy54zo?=
 =?us-ascii?Q?egqYKfJn+mUMLYkBL/nXYyaPvU4363NfQ6U6fkyRP3EAQ4UqRyP0g7cMoDe4?=
 =?us-ascii?Q?YT07Jgn20dwGLAQE+8TKIB4Wabci8AnqM8Uf8Xm/HuDfx2YMjVqttdxhkxqS?=
 =?us-ascii?Q?xo06Qk8MHwLqMc7RPDRfJ4gGgcJrzgwmMjGNd5Jh5pIejdfzZZ3qwC150+jo?=
 =?us-ascii?Q?di1EB7EBgL/EPOqzVmKI2UYcbT8vn/uKlozlWa3f9eEz2ZJ2P5nds5+Ou994?=
 =?us-ascii?Q?d4Ks01VIvn6bbuDzv37fL9KXyJ0BuiEm5YLaRlDhIFLGu4/aS9E93LBtr0h3?=
 =?us-ascii?Q?eJbmz4mAumDK1zE9u9zI5PT5oy78g4gTpb82nTJnCbJuLvhl9+Qszxb8ACmo?=
 =?us-ascii?Q?yRTMM+oZePafLf40sIN/G0w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40786325-5b2f-4dd3-d096-08dab2411737
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 02:16:25.8341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q0y7w2+S5sNle64iI9A8nNZ83DfTW5QN4CcqHVjlE1NfRzaX/Uilio6TCUJCz0Ix6BjFC7coUTlvPr99sYptDhWEAZp0F1v9fcPrzNkcRsiktcJZRS9cK4+uAR8oEOxO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4513
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, 19 October, 2022 3:03 AM
> To: Zulkifli, Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>
> Cc: intel-wired-lan@osuosl.org; netdev@vger.kernel.org;
> davem@davemloft.net; edumazet@google.com; Gunasekaran, Aravindhan
> <aravindhan.gunasekaran@intel.com>; richardcochran@gmail.com;
> gal@nvidia.com; saeed@kernel.org; leon@kernel.org;
> michael.chan@broadcom.com; andy@greyhouse.net; Gomes, Vinicius
> <vinicius.gomes@intel.com>
> Subject: Re: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP
> packets
>=20
> On Tue, 18 Oct 2022 09:07:28 +0800 Muhammad Husaini Zulkifli wrote:
> > v1 -> v2:
> > 	- Move to the end for the new enum.
> > 	- Add new HWTSTAMP_FILTER_DMA_TIMESTAMP receive filters.
>=20
> Did you address my feedback? How do we know if existing
> HWTSTAMP_FILTER_ALL is PHC quality of DMA?

I apologize if I didn't respond to your feedback. If I recall properly, you=
 agreed to only
 use the flag rather than creating a new tx type as a result of below conve=
rsation.=20
https://lore.kernel.org/all/20220930074016.295cbfab@kernel.org/
