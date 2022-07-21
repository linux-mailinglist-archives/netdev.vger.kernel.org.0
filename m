Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A0157D3BB
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbiGUS6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiGUS6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:58:08 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F968C14F
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 11:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658429887; x=1689965887;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jGWu+/d9/b/7tmpqaH1n+TEXmQAM+NWegGy88A29gs0=;
  b=S6AnMVUVDhYDwI9nTOm4hFJ1zsP3EBQw1GhO3MI1J9+iMTp3RGHnsow1
   qAC1GrFwKViyk8N54xoMfC610Rp9OHiUYk5SDw5O6jF8l8iylKbz9ZEbt
   loVi9Z9bbo2wF2IV7pAssuTAdHssyhBKK5WkJOeNfzqtfFVj7tVPqsPZx
   4Om53SVSfOjYkUuRBESaS+wOorhQm5XmoKmwmlHz1cO3j6FpjoX24n6Pe
   iPIUeGg8UL7m5HhaGSBH6U+rtrl4OrOHUYAZBr4HIJYHfy4uMwhbNECuU
   pUzn29P4/pwQzPgAMFX12Hr9f5IM8YpRBhhfsErPlPMoty1lv9QkV3lVc
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="287155591"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="287155591"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 11:57:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="573868677"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 21 Jul 2022 11:57:57 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 11:57:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 21 Jul 2022 11:57:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Jul 2022 11:57:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGzGDn/liyi1lMpcevHeGbEnO8yFg0ehtzJjHunK94BF+Gc4XvKuDrGGnPAAhnyrhuuUtR1Ir3BfCPNd5hJTd94KUQJlvwNP5UCIpnRuxSLliMwC4NNbh9Y+xT+EhHPp0bYZUNUy0rLKPxNtvyMfSZJVMQOyc5uZBLcxO/ahhioSy0vALOPEQc2dbYVMyZm9DvthrJvf+rENUr/ZQ5AmqZqoRRahfJuNPpia3eaTBVlopovLCB0NOdfqII3jBqR9frS4oDIcUZjB+1JsuujU7Y8HIxXpqP4JPyAXaPY1bgLck5INo7U3xsZAlNe0QtggFLeQzOxxDVSBo6AFtPY1AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGWu+/d9/b/7tmpqaH1n+TEXmQAM+NWegGy88A29gs0=;
 b=PQUpNxj6FLr3MGq6i+X4DwAGgWrdPZu6cLLVbVr1LMQlS6gdk3Mu61HIBjqKQr/RqFvomGAJnxb5FoNFQenjO3kCtmthgFqJ3oe3aXzHYQSu3Z2wsfqR102hjCFYHcQunPvGxhWKlhkLMn5PbRMtbL1YKa3rt6Wlox7EIdrTijuRtapoUy9ahjfYeDWOyIOwjl5WgycFKTdrmiLxgHRa7c0C3QNBzc1goDv98Gqbflv4ZQkA4pYLOVeGaGkxE7Oo6K8FjqsX9ZjrB8rVIUcWmfoqW75myuGXiI4YmmjjFeK3B8rr8lkZxv6I2aUZnyDoHES9JpMfuH1tYNas9/6jaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by DM6PR11MB2922.namprd11.prod.outlook.com (2603:10b6:5:63::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Thu, 21 Jul
 2022 18:57:55 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 18:57:55 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Topic: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Index: AQHYnGds4JyoDr5oaE22k7ooTa/97q2JCpMAgAAkJRA=
Date:   Thu, 21 Jul 2022 18:57:55 +0000
Message-ID: <SA2PR11MB5100B32B6410C59EE27DCD23D6919@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
 <20220721094824.6a5c7f5c@kernel.org>
In-Reply-To: <20220721094824.6a5c7f5c@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf2c065e-6001-4ac4-3e80-08da6b4aebfc
x-ms-traffictypediagnostic: DM6PR11MB2922:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KdW8RSYB0Zvyr5bYwgfbBwzuEuyMmtHzMGm7+qxj0Ocoh3+/NcEpNIuDjL2sG9pE93hULwS1AwlwP0qNN2KwgKic8VA0Ge78X9hEflj68JluZFBcpQuyjiZkYvUQslmVZZeTqIec7lqXeCGb7cB0Gydcg5uIo5q9Ffoh7R2AdRb90FYB7BRSb4xNg+pB2JyMjoOYsDYgyqMv2cEfDdLtriFv9JzQlPtczNuHOCqq+xzDxRROQ5ZyhsIlqq1qr/9nJH9ldHG0exz/raDNt1mfAbedUtjnmCvwhI9PNk51tapAvP0nQzXWSf1FvppvDGa/n1eNu2MJtIfoH0X7XGiKXoNOy3sdLC/ziQLZvC1heqwaktLjxth8j9nxnn4cu8EeROvSFa0HlT6uXkFT3FwxtPiKmNw01gxlCvVoDdzshUgVj/6kULeGSo7W+fb4TPYItZIkHVLVhHciDIyZ64JUm/9XT1uM5kBhr9HfMPRKlQU/sb5ZlZVFNJk8W9qONSlIzMvEUctfRtZ4K/eRjYHSVi33sST7wNjREEpoXtcuE6Qtpf/puyGreL5aoHLVyopiPYJcJsXG+0MJP3mUstJ8X7sGr+oDkA10gx3DiQLVlnaxoXlSmbaDPfESVEwQDFGYGkcrGjdlZe+fbjy8rq0s80Pg11DiUSOvekr8c+MhG/+fAmoTWc0WmAWV2oAN0UcYrqiL59gr1uuQ4P/ncTf4gKYCxUfhn4o7HWZMAjuAaRqAQx0o3/cq5n6woyHW9lJLAJuO7J/p28NVG1XHwvYdTZz7EN0ir75sbdaKHJacK76uT5wlOAtwIgJQZBnKk3zm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(366004)(376002)(39860400002)(136003)(8936002)(64756008)(8676002)(66446008)(15650500001)(7696005)(6506007)(5660300002)(52536014)(33656002)(66556008)(66476007)(4744005)(4326008)(38100700002)(55016003)(66946007)(76116006)(2906002)(83380400001)(82960400001)(6916009)(86362001)(9686003)(71200400001)(41300700001)(122000001)(38070700005)(53546011)(316002)(26005)(186003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AGsFxyLMja4+0nxk8eVLK8Y1RiUXQ0IkIm2nfaiPQFqWM3TdEpOH+vDBNBga?=
 =?us-ascii?Q?6xnEqUJbLcq40FnbH2yf42mOGsHmBbFATZderC81Ze1bI3u+25XM8hON9x7J?=
 =?us-ascii?Q?WImirsUeau1X5zc6bekhHA729TVJYSOqPw2FNtq/HbIZ9fV1qycu773ns3rb?=
 =?us-ascii?Q?vzWRG+kqIu0ACMA0/+AAUgSeOnBXDFHTX/TobiKC5JeQqVDx5P+/dpz/Ou+k?=
 =?us-ascii?Q?fHOfqHKloMA4yC8GOZ5g4A5rNWrFv4PN3xdZJevcXjl000dmqCXr7cm3t9CZ?=
 =?us-ascii?Q?+91tZtbB4axJtU4dmHUgzqtNUy5fZB5+PQldnsQvQ7rhhunsRl+SJXZjs0Bc?=
 =?us-ascii?Q?DR92+Lk8vWYXY491qjuvnQoUWDszE4RCsaDVmwP8pFo8gg+J4KDifCF/NLQE?=
 =?us-ascii?Q?vzoxUUV+wuMtd3K/wf6BNwrg0eg0C6aBHxqJC4BlKqp4ZihT77g1QqWElhZP?=
 =?us-ascii?Q?SAo3jeWiIgIVvSw0d/dqxE9Nyfe7HRkt/wJdY4K0Sisj+fGUUzQEAxJMe+Od?=
 =?us-ascii?Q?DRXfv8FbC/5SBbJCzZqjXf9RuWgkLEksytY6IDeDO+NIAVuKbEcQpPkJoz1E?=
 =?us-ascii?Q?LVym9oY5g3+3nFm5mcuI9hgEG661HDtmaIoIvmHQQ80Hquf93WV4bGBRW3vP?=
 =?us-ascii?Q?N8CZtA8TU5EZick79altVOZ3awS5mZPyEw7Uhyn1TDgtZKVpdrqq7svkwXGW?=
 =?us-ascii?Q?352tMUmQH6DXlFXXmi/cG6Zpe5+V9JNclLMEgjgotH6vxXF7qx/mhphWK3qP?=
 =?us-ascii?Q?Aa6dnd0TicV3+ZrerqhkpD/SZoFoJ8g8kDcKbBv28cp+JDxvh72vRi7NEdbi?=
 =?us-ascii?Q?jS0fZKeg4fFnhRAoO2SYjP6gjZjEl6eBMGUHp7FJo39nwQV0YDk11DBwbJk9?=
 =?us-ascii?Q?V3W9lqHELNPk4KYEcVTyvSq0GDx57iAIHQOlEtZ8klnwQ1zSnRXPznjimmCh?=
 =?us-ascii?Q?yBPKvrwOSKU66n3vXNFHAV7PKwCOBWIKv9qfpG9lbEvKSEkNBNH8qZ+mLwfZ?=
 =?us-ascii?Q?zCji9f4376+WUb0lZgihwN7QFWDIdrOl/ffYp8TrX6nG76S2TDKKEFfWHGip?=
 =?us-ascii?Q?V2zt/WxVCLmGUyUAKg/GYqiADhNrsP5Cn1w8qv2/soLGsOutSdW/0DZmOjDK?=
 =?us-ascii?Q?izjQM9lPtLlyp+hF4W7AjjDWJSDg2z7AN7pbS+SITI576oyR+jDL/8PcdG3X?=
 =?us-ascii?Q?qlg7YxMFqG4NgM50Sso6phDEG1onl5EwffkJBeuNqvKXDSld0FEOQYbjvX6y?=
 =?us-ascii?Q?VFuMFRTznLIZBVXFUDHqakJ7FuBk8eWJKyTJYvZ/prK2k3cQ9VLwPHVd2qii?=
 =?us-ascii?Q?GVYdf9ko0jXuwMYBC37NPTSDRIYa2Ow2RUJ1p2zlwM+HvzhMNZPGgCzrxYXP?=
 =?us-ascii?Q?zAwne6/Yycdo58EM7UfWVAIumrR/PAf7rRR6Il9eoxTTqkXp5kvP+6n1j4Vy?=
 =?us-ascii?Q?aFCQD3NnlQxB/Hzslq18I7L3QlOoL44bEm7r9kppgPIXbhB++77j96xcyR5V?=
 =?us-ascii?Q?6prSMmBfbP+dzR0PjRMatVCbdUcIPPreapfLLVh+79rhqb36LftCUp62MNsl?=
 =?us-ascii?Q?CFGJtyxP+X9KuMgi6IXa9lru4kMkyoUyAlkgwy6b?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf2c065e-6001-4ac4-3e80-08da6b4aebfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 18:57:55.6962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9mCws8OXo2VG25jhQS8kgoEPAP7cwKOsbYEsvIEdI8AVThQ25WbHlfE+HneCtZt1Qm4P50VMAeg60sNPQwCHoqcC4e5ZAwSg1ih4VsQpX50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2922
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, July 21, 2022 9:48 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash=
 update
>=20
> On Wed, 20 Jul 2022 11:34:32 -0700 Jacob Keller wrote:
> > Users use the devlink flash interface to request a device driver progra=
m or
> > update the device flash chip. In some cases, a user (or script) may wan=
t to
> > verify that a given flash update command is supported without actually
> > committing to immediately updating the device. For example, a system
> > administrator may want to validate that a particular flash binary image
> > will be accepted by the device, or simply validate a command before fin=
ally
> > committing to it.
>=20
> Also
>=20
> include/net/devlink.h:627: warning: Function parameter or member 'dry_run=
'
> not described in 'devlink_flash_update_params'

Will fix.

Thanks,
Jake
