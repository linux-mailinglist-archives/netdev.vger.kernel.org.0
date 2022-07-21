Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF27057C6EE
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbiGUIyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiGUIyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:54:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C285B80509;
        Thu, 21 Jul 2022 01:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658393687; x=1689929687;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rP1KJpZEc/Eryhs5NURKlnQ7dxgzqL/gY5NxDxSrp4o=;
  b=WZo2/KcDsITH5l2L4PiUQRSkgjV6dShgECauarI3Yfu0Z6zCZx5WU8JP
   kH6DcSxkTAB6P9GQ8EiU/fluVGft4DPgioP0UMaiShmbPcsf5SQ9nb7+j
   Z1FDRwxWoDlKYe8znhdSuBlaG8YqnZGjUNpsWMQZMN/iBtBiR3HPxd+53
   3b3ZSWGNvpzv6zDRKtnjYu0Wn5BD3LrS5RCWk/sWj29fFLinVy9pyP2GP
   aTfRZPOrOvKyD008bCCTDuaEBgrWwj7wgE4lnxCqrgPRHugK0aAv4bCUQ
   XuZmHyzEGDTTVSTY/FZewZBvGys8MwhLN8XDMFfESfVEHL7ObSnDTb2wa
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="348688032"
X-IronPort-AV: E=Sophos;i="5.92,289,1650956400"; 
   d="scan'208";a="348688032"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 01:54:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,289,1650956400"; 
   d="scan'208";a="598389771"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 21 Jul 2022 01:54:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 01:54:47 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 01:54:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 21 Jul 2022 01:54:46 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Jul 2022 01:54:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfweMVAq0Qewuq3K4+5WhYFwG9JTrd1RYXbGpW081T76paDl8R5s59zHF13wEAl1filjC511AjMZm4uMQ/zwYt6AdFWUWbVdV9z8evSnyoxnREPrsC2i+rJdblKXVAJFZxSDa161iO5Ki57E+LcCKFo4+HKFZJYhZvSgMypV/p7Ibxtp/ergISUpeuDO9yuNfavC38ZpLMbTWmIW7uTnTkv7PMF4inc5TGAqj8TvSXxdWbJUpOM3TLxNtl2R/7yL7JyZAM2mbL6w7EA3n/jvDCso6AaLTL+XbRT1qm4k4GXyv7n2m/Gc7a+gqpEr0kl3zLtTI1FlHilaO66DDYF/qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rP1KJpZEc/Eryhs5NURKlnQ7dxgzqL/gY5NxDxSrp4o=;
 b=eqnSga5Pkowms3/UpIk1rSkFIRDlCdVIJXzdsDZQdF0saq8taoiOV/2sP9AA0is72MdJpQK0v1L1AZJaGc1617hd7GtmHy37sa1HUUxuVxZTuIem1+kHn/W1SZHug/4dcW56EFd4hsdwQk4NzXnBFdKeOhU7RVQADosL2TRS/2wKvG3WB3Z+ShEFU2VxNRAANqrudjHfr6RxsPjucC+alyEX7Pv0bHNL/d+gf/qpODq7iw+vGhG5jNl3HlJJ462skW0hE7jKFymb/78hatAl/RsofbYEDe0rW49TpjPuzaBnZ4cyiyZO0EbVy2mPSh/iYleEH7CE7tb03QxeXTHsmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Thu, 21 Jul
 2022 08:54:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5438.023; Thu, 21 Jul 2022
 08:54:39 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH V2 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Thread-Topic: [PATCH V2 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Thread-Index: AQHYl1nR/iQPrmnWoU2t9zhNVHHxZK2EvT4AgAC1VYCAAKlDAIAADBGAgAJmxqA=
Date:   Thu, 21 Jul 2022 08:54:39 +0000
Message-ID: <BN9PR11MB527610E578F01DC631F626A88C919@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-7-yishaih@nvidia.com>
 <20220718163024.143ec05a.alex.williamson@redhat.com>
 <8242cd07-0b65-e2b8-3797-3fe5623ec65d@nvidia.com>
 <20220719132514.7d21dfaf.alex.williamson@redhat.com>
 <20220719200825.GK4609@nvidia.com>
In-Reply-To: <20220719200825.GK4609@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 193fd247-35c2-4dbc-255f-08da6af6a52d
x-ms-traffictypediagnostic: DM8PR11MB5591:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5JOhkKAGokhqAJuVcO2rYEzK3A3gtKWmUQ9G7bEJwgyGSTwswFlYgWOqYDs9lX66IRGcaL+Q9dZuC4QSjL0TKkeV0EuWWCJflHCgg753rajlZfDV8I+rGbEV/CDThtBcgsUWbN/2F5JZR4ObxSflQz5MaIjxeQOJO7t4UBsUByZGa2kPKSPnBZIffcVE+t/iqbUjeYm4Vb//xI1zU68JGKZwNVKIU44SijfE8/36r3BD1QlCDOtk6pSnFN9A5gVj2GxSHGaLg7fdS9JiWVY5nhj/hij/0QHLuKDmGBQN1md8mIGbJJo2AGI25XvQmE0wo5U2ALoTCgam3e1xXzmHGUZCakQQbCZ3mD08fmgFaLJhkpzkTt5p1pEq2Y/4ekwShAriewjM5KhNsYd66CalUeeErln9CXqXpGqeNmNuBHlA+W2yRfkDcRd9Mviq8jxMPSAo8oXSUtL78RaNvDdPLLj9n2qTLxyl11DUnsBkzdjY4o7MmozY1NPEfCoadHg/ILBBZuiEHLUXtCkrnQqOWMN+6ppIUqSdKjLDodfwJfhVUxdd8+4n11DYpgPLwHGyPmbhCUBcSknxnY4iM64d2nKl4cGwMY0h5z3EYFOyhhY3yL7VV3+NB6odXY10ZjnscP/M1zuSKQ5WggRVCLsOP7RKWH9m8Lfd5ka5VeOVs4ZbZ56ElVzsIb57LwgaBJTwTIl7RPIEO5FhVOPCnLPCdfE3XGwyDeeSpg9/z6GvdIkY7m9ty2k3g40TlTuT3qwPxHRbbw4l/qXxnrZ0C2Ey56ZyV/wC3nGKnWEX/srbo4ahFTl12ZcvjHTqHYTz3Az2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(366004)(39860400002)(396003)(6506007)(26005)(38070700005)(66946007)(86362001)(54906003)(7696005)(4744005)(8676002)(64756008)(76116006)(66556008)(8936002)(478600001)(2906002)(55016003)(66446008)(9686003)(5660300002)(41300700001)(4326008)(66476007)(71200400001)(7416002)(52536014)(110136005)(82960400001)(38100700002)(316002)(122000001)(83380400001)(33656002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?apPVpGz5zX4QyQhP9nfp/uvY5Nlo3eV7oRBP1dHVzzG19WUTpFDRR1gSwCzF?=
 =?us-ascii?Q?IVHGwF/JjTGPXKg+lTAWLLg5zhYKpFAj5nFBJ4WHP4uK7Xw7FJ3nJKJFBjWt?=
 =?us-ascii?Q?QYMQCQr0/YH3kcG134Iu8VsxX3yCxR7dZlhBiWQ+3T0mY1LsobHYSbz6YVKX?=
 =?us-ascii?Q?HyBF6/aM9BWSoCojm3X7IUnLA4dC3DdSqd/L3Pz2huPNeArQrAU+LygedJdJ?=
 =?us-ascii?Q?KhDiWyuYZArkwgvV5C4Wyrkd8yTNhM4LefjmoMkmnN3BIxfsWbgaaqoe/+2S?=
 =?us-ascii?Q?eEl1eXX2yi/vMAp4HADJBcr2l2soG69Bcn2hdq4vMyHK7bO0BLJZv7dFTx3r?=
 =?us-ascii?Q?j2SlfjkCMQUfn4vCe4CMzj3CXhJvk0LJo93LN9qurtfrMgeymw4HcIawZis0?=
 =?us-ascii?Q?kTXiuIiSFf2nvwXmKZwJBc8BaD5bX/V0V7tjCY0jL9sdEMr51HslDwmn8lE1?=
 =?us-ascii?Q?6kiZ4YxHWbODgUuCkAwE9ODsUrC3tDtCskbBl4L3Ea11qDNQ23HzhAiP2iEE?=
 =?us-ascii?Q?4Yl8W2rX8hVJWQMV4a2X7Jk9uhGoMfJ8tsY2/j9mf8bzXw1ZqEQSuMg9hJ+e?=
 =?us-ascii?Q?Sir+q79+a2Z55ihC1VbL8jfveHt/UGwozUj+TqAXVJyM0QiYRRTDVyNorvyH?=
 =?us-ascii?Q?RpTw7qH47sjxy6XDMDQcz7Z32hVc3KcKJPCTCP7leSlGLjO03GFropOT2Tjr?=
 =?us-ascii?Q?IVwMPsnS5i4f0IdSvv+EVVl9W2OHH7xKLwDNzVn0aA+9/3t4rpLCMdCF2nR4?=
 =?us-ascii?Q?Jgj3ebpsF5/ridj4OX2immEbjXyZxPUtPmVFj2/7Ty1F+JyyorvlgDC04R1T?=
 =?us-ascii?Q?6Jq/TdTmsdZgRJaRYVdkXGu5zNhF8F6CkpnrJAd5VQdOqDpBWTgz+9NtkGYP?=
 =?us-ascii?Q?+eYvDUh+Z5NldscXFIFkyaUscMrGdNrxWzs/VmuVz2AVFSRKVAyrSSBoQW1H?=
 =?us-ascii?Q?guF01xzRIfMSAE93b3lbrUwMXdCDW2EQZoxa1a4FjOuNPBi+wCWl4+NxB7fE?=
 =?us-ascii?Q?J35S2SnoCWIPRqmnhqdBMIdGqwsEXd7GrFferrwct0QQKds5y+n5FFwTTif9?=
 =?us-ascii?Q?0yGINVhCG0fhgwDZH5/YnbdbSmIYROru7LAiS/ndsx6ITVZ93Ze4uibpkc2a?=
 =?us-ascii?Q?qSqxOjlVmO6A5UHp6SIaDBQv481k5lOTio3fXB3IQ+W5ruX1X8yjq45aXU5+?=
 =?us-ascii?Q?geK3MTFcRj6Qk+0Re0UPi5BWGhx1wIoKtYczCsm/UBH5yrz8s27LmsgswjmM?=
 =?us-ascii?Q?maV4misrZXmOpWV06WRapLFJjOu55S0q/cbicfyJ+IhI21r9PZ8kwNfg5yxs?=
 =?us-ascii?Q?YDMtctjhQxmyfM2Zqc+qJmpySZ4fWJwQcx9+eHrfmJXkalEyMmYMNuCWsfqR?=
 =?us-ascii?Q?8jACorMSl+OKkzPYPnnlng781JqsDqnLWz1uBTxJcpYqgRUm7+4HCoTuNr8C?=
 =?us-ascii?Q?E16qjETgfufmsv4I060KNPjTYRfeEECAXUEr2TtfNn+WJszB6aIyl/lRq8Au?=
 =?us-ascii?Q?6UrMtWHPAgjjv+N8tHjgwcFcSD66TYL6A7ZkwAGLDL2fs4p0YnaGmC3ojP31?=
 =?us-ascii?Q?epfHgMdbeDRmBSiHY6DsOlBy7kBCdazkEmqybqbw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 193fd247-35c2-4dbc-255f-08da6af6a52d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 08:54:39.1575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6WhF3nWbBJdmsYebnFEbvrXKbHeP9UcmkA/xukQAnIndIXg06B8+J4N5UO7/Om+qRWQdCIv9DEvOLN+xVdc+Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5591
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, July 20, 2022 4:08 AM
>=20
> On Tue, Jul 19, 2022 at 01:25:14PM -0600, Alex Williamson wrote:
>=20
> > > We don't really expect user space to hit this limit, the RAM in QEMU =
is
> > > divided today to around ~12 ranges as we saw so far in our evaluation=
.
> >
> > There can be far more for vIOMMU use cases or non-QEMU drivers.
>=20
> Not really, it isn't dynamic so vIOMMU has to decide what it wants to
> track up front. It would never make sense to track based on what is
> currently mapped. So it will be some small list, probably a big linear
> chunk of the IOVA space.

How would vIOMMU make such decision when the address space=20
is managed by the guest? it is dynamic and could be sparse. I'm
curious about any example a vIOMMU can use to generate such small
list. Would it be a single range based on aperture reported from the
kernel?

