Return-Path: <netdev+bounces-8318-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C89BF72392A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 022B72814FB
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D68A134D9;
	Tue,  6 Jun 2023 07:38:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182496106
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:38:50 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4320FE64
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686037125; x=1717573125;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tCW/XKztrB2pVO1VDyHPrVkNfCwdafTjVqV39NjHQRQ=;
  b=cvTu4MyMrtDoplB4SouciUr4XrOShp+PKaKqzXKmCSUnWRg93hRsD+Fs
   Qm6gpMz1A6ekjJO4p8iq8uuKvzhBqGozWoYrBHo4ZFAkFeWkhg81twlqJ
   xHZf11ty0n6fo1mZblHCdgFwElZt93lATsasGu3PYiRORp/xFrqztRiYr
   haY1tq6XN6l9g4evyaiEirTgo60CzUD5QiqtMyg5MqnZnr2V1opWWtcUj
   JPcjQma9UKafCRGQ+g6r3qd+EXw46ZwKJmlH9sRwXLGv1XS37jO+yl63f
   Umg+ROJuuA3ky/m0Q5s9pscmYTxSFvC/P73XjXWGTwrjlRXEzfJlO9i0q
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="356601923"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="356601923"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 00:38:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="738669285"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="738669285"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 06 Jun 2023 00:38:36 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 00:38:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 00:38:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 00:38:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 00:38:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lc6apeS46ix3h5oFiQT+EmYtRq5cRqE+5OKijJlfZ4dFiuiLBW+K7pNqNbSMtK4koT+tdUx6AZ0FcOSO9PkBQo6kkCLtETIJF3ThmLKOqbnBmGyjjSl00S8rm5f4C0HpaC75iUx5hJ4oYJvnomgHaHN0dWSPW87dV6AGzCNitajtgIJ1GGLAhPGEzvVzWJ8kxsz8o6eMpgdxcEGV6t4cs4C/e117kpdc5jk4yeb95acZguCCCArCrwEWGYooWLWK694+00wvK3rrkLKu8av8AFvyhz85GZernyvqFMH1N2+8MCARHihHqNMdcpkBs9/M0ZTDiKX0004Flga5SpxMMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hIaptd4nQNzERuNbY7IUdxdubb3zcThohGYyc00cbFY=;
 b=GQWMFfdNoTPPL8HfcbqeSoaA3ZyvZrA6raW+8RaZcCqVP3hL8CHicfPNo7C5d4I0sVw7OUx/dULfeegUnNx4J7W1GzdryhVhysxs2f9VDty1El9nBA49rZ3JQIMgUnVkguObfG9o//u+uZnGCpHvRpLG9Xb2ztgdVqPaoFN/Ij2qTX4WoAV9PvvGVY8dejIjjF5XkY8qRMl91RDmXVfdY4QrZl0ysu+kBxS3mOOkuSEfVdAph2vv45qxQAByqRQzB+otB1FgOHLo7+zCDxjwn/Wq6RevOI2WswSaToXXTWgnRSbycy3Tcbpaz7ooZyBVjdBw4KF9uVYMyh+tVDuSVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5028.namprd11.prod.outlook.com (2603:10b6:303:9a::12)
 by PH7PR11MB5886.namprd11.prod.outlook.com (2603:10b6:510:135::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 07:38:27 +0000
Received: from CO1PR11MB5028.namprd11.prod.outlook.com
 ([fe80::a5d5:532b:7e2e:46f0]) by CO1PR11MB5028.namprd11.prod.outlook.com
 ([fe80::a5d5:532b:7e2e:46f0%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 07:38:27 +0000
From: "Mekala, SunithaX D" <sunithax.d.mekala@intel.com>
To: Simon Horman <simon.horman@corigine.com>, mschmidt <mschmidt@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Kolacinski, Karol"
	<karol.kolacinski@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "intel-wired-lan@lists.osuosl.org"
	<intel-wired-lan@lists.osuosl.org>, Johan Hovold <johan@kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net v2] ice: make writes to /dev/gnssX
 synchronous
Thread-Topic: [Intel-wired-lan] [PATCH net v2] ice: make writes to /dev/gnssX
 synchronous
Thread-Index: AQHZjvB83km85Ano0E2emw3bDsgnPa9sRr0AgBEujaA=
Date: Tue, 6 Jun 2023 07:38:27 +0000
Message-ID: <CO1PR11MB502804441B4BE5DD49873E04A052A@CO1PR11MB5028.namprd11.prod.outlook.com>
References: <20230525100446.125117-1-mschmidt@redhat.com>
 <ZHB4Lk2NlY5C9nKW@corigine.com>
In-Reply-To: <ZHB4Lk2NlY5C9nKW@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5028:EE_|PH7PR11MB5886:EE_
x-ms-office365-filtering-correlation-id: 23da6200-8058-4239-843a-08db66610497
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N1w788SODrndEfoTDS1+gWa5VKELV10XhAuPv2o0FSjanpmfjSmJVXnm23Tiiwc9fspiViMuChgYxSyedrQVRnQcGHhaKSFSxH4azT2eCzqpFVF9qhJdqmCIjlmoYJvsmNPpUh8lJAoWJOKsyx6Lweat5wfjMcARcIfJORQMwZRCLq7WHGNUY2WUf4aks1nq4T0NZOSY3RN1SrM5DoEYEmpt9MFaz9xF/QL3Auc0U6BOFFyE+OJORfA/98Qi3kLxsfcQRB4ZSjBAW/QUKdJk+wMSZ/aB0hmiYQmaxCgauSTMAGG8aIV7re959YKIWtJuo4h9WQcE/yeDyAJZjEzJUnWIIctPXwxyQE4MA1kRV0BIIWd8V/26/4hdmdiU/+THlGWNXXbudfjQNtiSWivyRQQdvWUBRcvQ018xCYfbuYUdDJPA0C5glAjsmKefpSShHVZK6P5rEAppIzlya/p2AlsF+x+7FO/U80RiWZOD56luGs4Y7Enf9l0StmUFF8MrYE0FTZq+7RqZME9oIfXsL7FcBPwOQwkvn6i9xmdsHNeMiyJb5XF7tzEQ3JbYkBSG0F0vOsVZl3uD2lzZSGXUA+JRJKdjGyJDSazuc143731xEzIjhxXC8w7zOAI8vSjn0ec+F/uhVSVfJgGrEfbvSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5028.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199021)(41300700001)(316002)(110136005)(54906003)(122000001)(82960400001)(52536014)(5660300002)(2906002)(66946007)(64756008)(76116006)(66476007)(4326008)(8936002)(66556008)(66446008)(8676002)(478600001)(71200400001)(38070700005)(7696005)(966005)(86362001)(186003)(38100700002)(55016003)(26005)(9686003)(53546011)(33656002)(6506007)(83380400001)(15398625002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MvNWxF+k0bai0Za6SfmvpNSQsWCMvWBr5j3zVcvOeGF+b9IiaJWFDIxjU1um?=
 =?us-ascii?Q?YXqcUEez+jlQTAEPHvOaU4qGboTIYDq7UQU/f9Lut9/GaIKBFtrpi/CRqkWF?=
 =?us-ascii?Q?aZu3o9yamKIg0hiSfnWnJTR2f58f4QolpnYIutzKR+v0Pk2OzbA2f4iUN1Ty?=
 =?us-ascii?Q?wm9HFN1t+5Y93qysxjDBG2ZPNx0pp/BvdbtK8o/th0BNmyZReUpIEvOqrnWK?=
 =?us-ascii?Q?Ft5vzPqnUAJFhFiFO5AV6Vm2LO2pNMUKgAIrm1xIpT+eme/q0ohoX9l9+xNB?=
 =?us-ascii?Q?rSQvEU/6h4nP6y+XsHk5W0MelNNmXmNkVvkUmC+SGep6sRXXY9/8bOnFfG6Z?=
 =?us-ascii?Q?8XM9O9jMyl+biDNDhiiGLRBm8uYKDcuttHIXAw/Sc72/N8KWoGK2FkNfOtfn?=
 =?us-ascii?Q?Z8wb5jpEYK3x4qxbakBYxPCJzHUnzlvLonWbPalmjoT3OjTxGBBYQ3FV35Mc?=
 =?us-ascii?Q?gYz0z1254uEw+E2RnWlK0gMSNv34Vdxhk99eoP/OLjRT2vZa648B2XIuzR7m?=
 =?us-ascii?Q?E8f9lzjohAKJolgpV/Sw6qsgu61mDWJVv301/iQBgMRvA/QMBA3spx60GOV8?=
 =?us-ascii?Q?1xoRPHi6Ywc4zmayzAZx++TEGYZuuKf42/tMApbVbemypYiNGefsMPwyPXVC?=
 =?us-ascii?Q?KA4JUZlWV1qiAwn0oDVTsFWLnFgi0WhUDQuhor+BJzDSdf5wk3HXL/MPnpK3?=
 =?us-ascii?Q?j+antrr5rZ3msnftS9UMFS6cUh0TzNSwoKm3HqWsaGmYVB4fSOZit5TiQW3Z?=
 =?us-ascii?Q?UGkidWrvK8bUDJbMqaTIbe90zKp44PuwAb0SSY2tDDcW5yOKivyyzY3apigL?=
 =?us-ascii?Q?em0pJjuUzwBlw923jF+IsqQLuUnIof9OxWievg5At+SsOZPQuYniO3kAeJYk?=
 =?us-ascii?Q?SF+Y1/S+VgGiSlamshBbTXzCRiH1qU/u24yA4pDco4/U7dZVaz/gjiLlLbkT?=
 =?us-ascii?Q?abxh2Q8t2WlxwvdEtCZCUBVhD+ETQ7Dp5RBzqQvmtI87N2CcYhjZPS82Lfml?=
 =?us-ascii?Q?RKd2t7mbsbiEZkurFL9F+2pQTKKRcNvzhb+WkPvjirmKrbgt+Ko+mph1yy7N?=
 =?us-ascii?Q?AeA15wg5Zdcvyn1bhbwzAnaiielSNgFm3mSTlfdvaaMowea9w7yl9a+X1wKu?=
 =?us-ascii?Q?Dji6TUHu16c9x45yav2qmTuB7M4jfxj/drjHdoyTjyAWfTg9I2Q5NOvukqAf?=
 =?us-ascii?Q?1LMJ2wiudmb8FxnrMsoCQHULgmCyVmiWufedrgIwA1YVUky3MEfymN7g3BUv?=
 =?us-ascii?Q?+NTkwP50f/ZJ3A+O3hMH6rnr+FmkOAmyuE/nX1l/1jIVzuumjYQMpYE91XoV?=
 =?us-ascii?Q?xKB8bL35EyHUUeoAVwmfEgB7JMcJUe0nonz65ixeadHKIZ/RboQXumvSTw43?=
 =?us-ascii?Q?lwGSrlESeBSdgL2EzU/PxI5fk+ZX2Uv77A2idX2Xptx0wwTQ/aJSNPeHTM+0?=
 =?us-ascii?Q?dLa8GUWvaipaJ/YixXWIdS8ww1amgtELpMT9YL+AmeO/w7aBwjLSH5Yt3Xrr?=
 =?us-ascii?Q?2qqpmUvWiMGfYNuL9C14htpVzHAWFXYCxeuWekCF5QgOWoIaL/DeM5l84/rI?=
 =?us-ascii?Q?tRGYHrk+el9mUPIwJFOt5+k9q2s3SBlhXvJ6qK1xRUB6A8x86wdn/FXO22k5?=
 =?us-ascii?Q?WQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5028.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23da6200-8058-4239-843a-08db66610497
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 07:38:27.7495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5xhVjBhEo+qMtzzWDNhW/h1ZR7pkrsCqyFGx34Z5cSurGDCRhtRfxKZQitpKkAUU9M3oI/CGbGcWCtSDnQPJklqrJWifz0Zd0nHvvd3NkpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5886
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of S=
imon Horman
> Sent: Friday, May 26, 2023 2:13 AM
> To: mschmidt <mschmidt@redhat.com>
> Cc: netdev@vger.kernel.org; Kolacinski, Karol <karol.kolacinski@intel.com=
>; Nguyen, Anthony L <anthony.l.nguyen@intel.com>; intel-wired-lan@lists.os=
uosl.org; Johan Hovold <johan@kernel.org>
> Subject: Re: [Intel-wired-lan] [PATCH net v2] ice: make writes to /dev/gn=
ssX synchronous
>
> On Thu, May 25, 2023 at 12:04:46PM +0200, Michal Schmidt wrote:
>>  The current ice driver's GNSS write implementation buffers writes and=20
>>  works through them asynchronously in a kthread. That's bad because:
>>   - The GNSS write_raw operation is supposed to be synchronous[1][2].
>>   - There is no upper bound on the number of pending writes.
>>     Userspace can submit writes much faster than the driver can process,
> >    consuming unlimited amounts of kernel memory.
>> =20
>>  A patch that's currently on review[3] ("[v3,net] ice: Write all GNSS=20
>>  buffers instead of first one") would add one more problem:
>>  - The possibility of waiting for a very long time to flush the write
>>     work when doing rmmod, softlockups.
>> =20
>>  To fix these issues, simplify the implementation: Drop the buffering,=20
>>  the write_work, and make the writes synchronous.
>> =20
>>  I tested this with gpsd and ubxtool.
>> =20
>>  [1] https://events19.linuxfoundation.org/wp-content/uploads/2017/12/The=
-GNSS-Subsystem-Johan-Hovold-Hovold-Consulting-AB.pdf
>>      "User interface" slide.
>>  [2] A comment in drivers/gnss/core.c:gnss_write():
>>          /* Ignoring O_NONBLOCK, write_raw() is synchronous. */ [3]=20
>>  https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20230217120
>>  541.16745-1-karol.kolacinski@intel.com/
>> =20
>>  Fixes: d6b98c8d242a ("ice: add write functionality for GNSS TTY")
>>  Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
>>  ---
>>  v2: No real change. Just rebased, per Michal Michalik's request.
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
> Added Johan Hovold to CC list in case he has any feedback.
>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worke=
r at Intel)

