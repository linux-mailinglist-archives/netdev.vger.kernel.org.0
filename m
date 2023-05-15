Return-Path: <netdev+bounces-2471-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17590702266
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 05:32:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBE121C209DF
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 03:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEE6F1FA5;
	Mon, 15 May 2023 03:32:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88901C26
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 03:32:14 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C69F133
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 20:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684121510; x=1715657510;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GahaOQOp2ZaRt2WdgSvQMu6U7J/46N+LNH1qW38l7c0=;
  b=lEavGjeUZJFbf0xMeU/ZoOPXcQKy3arNghai+Gxldn790uYOtLCp0Oua
   VdLHfNvtjmv7MSZCJcseQ3C0ihq39Memo+u5ts758X5KTcD4gQYiPWnyF
   9M3UBHwVKHXX7jVrLjVRqYw7JphPaQAfob4K9CCjxJ6idNnX/8qoKG2F0
   Zx0S/qC9NjEcl5GBnN9R2oVqsmgP7b80cYB532z+pWQ/CTlkKeUSBGIo/
   LGFp415W9N4xsc8G/lcZ0Sczbfi78JiHV2EswHLzEdJZ9rfAoKLGu7sqq
   JueGwePKJinyo1Hq4XcC+K8eLoasL+X16D9OnRMF0TZlztPxmPslYqWiE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="349941811"
X-IronPort-AV: E=Sophos;i="5.99,275,1677571200"; 
   d="scan'208";a="349941811"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2023 20:30:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="947272876"
X-IronPort-AV: E=Sophos;i="5.99,275,1677571200"; 
   d="scan'208";a="947272876"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 14 May 2023 20:30:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 14 May 2023 20:30:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 14 May 2023 20:30:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 14 May 2023 20:30:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 14 May 2023 20:30:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3YzmgfYF07aeJ++w/7kU1tcVj9N1WRrN8M496ZfRiOu6GmIwBr063G9659Y/xF5c5dk8kFuKXCfX+rFSeiD5yN4ReCl5VkS/1Co/qONAT5atIj3UnDNHus7LTH6begpfdepbyL8mZieGXNW22xVO513NMuva0LpNCnkmSMGYgQmvtBzvk2bhhs5wxHT8X7N8yKvAuP8yEfrNRdkGk/rlo0C+8M6w+5mnj4ndOv0nkXraGJvgfPbCrbDcVQY2WxKQmMcZu79N3uissXCY/b0+9dkDsmtxn+CjtGkqnyEVJrUmEC04iVUmXxIJuoMicq97A7/emhIJqXwk8vy4nkPTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SQwm8oXiqRsrPej3rOxk5KTwNyg3FLXYSy9Kgy0PqC4=;
 b=aLaOa/ko5uM4QK4OuZi8RaoBZ3qqAvlEULixO0jVeqw12Frex8qQ2t9a7laZIgiaqz4PMSl4j+a3OD4bK1E4Y0V4cF+ZPzdtRwDF4fXJG20ECp3/yYiL9pHPb9ZbusvaFkkkwddfgPUIJJsr0Mae13UrvJFBsABDwXpBN7/pKH+miRs7+JdTHAr6FLdOEEAKv9FxZ3IEh1lavyhwhm48zSAIms41ptb2x1c3FSp9KAIe31TXbPAACCaTy0rQod9cinS1YYEfyT2jXSOR+duDU8QO7n03Jvjjz7sLPOGEdkjot9WTAuH3x0VoCPvk3q9ZvVSfJGOrRKUoa8NieOUZNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by SJ2PR11MB7715.namprd11.prod.outlook.com (2603:10b6:a03:4f4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 03:30:50 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::748:8cea:e1b3:88f8]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::748:8cea:e1b3:88f8%7]) with mapi id 15.20.6387.029; Mon, 15 May 2023
 03:30:50 +0000
From: "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To: "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC: Jakub Kicinski <kuba@kernel.org>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "edumazet@google.com"
	<edumazet@google.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Neftin, Sasha" <sasha.neftin@intel.com>, Naama Meir
	<naamax.meir@linux.intel.com>
Subject: RE: [PATCH net 1/3] igc: Clean the TX buffer and TX descriptor ring
Thread-Topic: [PATCH net 1/3] igc: Clean the TX buffer and TX descriptor ring
Thread-Index: AQHZgpmIJU3pEBCZU0q9nhkqarffDK9UV20AgAH8XvCAAHRbAIAD5Bzg
Date: Mon, 15 May 2023 03:30:49 +0000
Message-ID: <SJ1PR11MB6180F748B6C5AEF5999B3A55B8789@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20230509170935.2237051-1-anthony.l.nguyen@intel.com>
 <20230509170935.2237051-2-anthony.l.nguyen@intel.com>
 <20230510191428.75efff66@kernel.org>
 <SJ1PR11MB6180BBD70342998B2C639472B8759@SJ1PR11MB6180.namprd11.prod.outlook.com>
 <ZF5bkhhs+Ue+DZfG@boxer>
In-Reply-To: <ZF5bkhhs+Ue+DZfG@boxer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|SJ2PR11MB7715:EE_
x-ms-office365-filtering-correlation-id: 9b2123e2-a1ec-4bda-04f1-08db54f4c77a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GcdjbNCX/yubpsGF4ZeRbe5bc67yBOoZkTPFdIpfNmwOox7KjBIttp3XyuPvvduTW/6jv9g3oEJaPmdJA07aXUh9r/EHjiiklvVe1+DmWc2H8tCZ6s8E5qCaLYiRKIwRxUhRM62HayAwd8rC1h7Abku4uvouPnibQugqemdowKENiC4bWr6MTaFBdS+Emlk6FxGFSftof8bFtdWaImUzjQx+LxOIRyaJ7L6SN/ujqGDE57myWyz6C1h1b24CnvrwR2xJfII7Jr4gmxZBsYmhVXAmD7NtBf5ZIY6bEwSv2IlwxB8KQxu1mMf3XYPw2nfkviSrgd6mGBLD9wtXzyU937NTCNbKKGwT0uFacoCjor5Fs2VzNu4wrlzV7Aiu58PwrbEWbO8rjEVzGAb/0TI34IGLOdXdyUxvgOx7aECJ6+F+p323KVQYdFdDs+1b4E1piEVLrucB97SKNMpHGTH/KQvBYdnHG9sGQBwrL10kvam5epr83Dtvuh2nh+Wu3aRJexqs0p6FGsMHfKZxyAFYZRsXPgtjY6HV47eth11XKjEOmoT5MN4eauGRZoANgK1TTVMibKJnBxjh6SAUu9Y2v3LXjsT7m+MgVQDW1zZsCuw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(346002)(396003)(366004)(376002)(451199021)(9686003)(6506007)(26005)(83380400001)(38100700002)(41300700001)(71200400001)(7696005)(966005)(186003)(478600001)(45080400002)(54906003)(6636002)(64756008)(66476007)(82960400001)(4326008)(66556008)(55016003)(66946007)(66446008)(76116006)(316002)(122000001)(52536014)(5660300002)(6862004)(8676002)(8936002)(38070700005)(86362001)(2906002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oEXcnNtrM4nGRxYSXALwtj9NfTtBuZabw2EYFJiZcTB89ij0DUsGW77byyPa?=
 =?us-ascii?Q?oyLRSYO3r3RNgWe9DckGgQVlScz8BHVN0xxsFkGZ0WB/kUdNTPwxMp1qpWcJ?=
 =?us-ascii?Q?fNISG/0ZJRgJkhDeJweq8kFYSiUXukiE2bgqL7f8YQJV/mYIHnWVd6KSdWSC?=
 =?us-ascii?Q?nSuw8M/NGJa1v6diMg4KXy5cOTF02NKVq2Xw7oqLoc4vfLcG5VLGKtrkVqUg?=
 =?us-ascii?Q?st3OPVFqfyQUfRcXq5fM5d5tYR7XbWmt7Wgo1HGnDHYweDewXE3CfE/8ekBa?=
 =?us-ascii?Q?mlGPN5jM6jPYHtBGSS5KjtLOredNKdHu+KDHOaKgPagZ87QWhqihxp4nu8tR?=
 =?us-ascii?Q?NvcLFHV2spEe43gZRdgVQXHJ7PgO9uOQHcK30oTpg5wALMOX7BTyiREdTVw5?=
 =?us-ascii?Q?Ljc/zdaRBtud7/pIsI+GQrLNkGEFajq5+qqgPzpdcX6wIGj3einql7pwLWCD?=
 =?us-ascii?Q?BbWOE2l5S+LGbhGfD2AtY4DCYbbLNShnvtllpAbwlzHn7Xnc8XoypyA9nW+T?=
 =?us-ascii?Q?MC9O/zSfEn3Sf336We0ceEQDyEW3DqQyMm5tpwJ19wXa+dYDIu/66lpSwr+1?=
 =?us-ascii?Q?1w7OyzqhnF2EC1FOsxlHhjuRVH8tAV0FozLj2cqwlOm1De89PZWwxOL+Vh73?=
 =?us-ascii?Q?wMz5z0W+CqpsNUfSAPW2sEAM3yXPHKSBOslrNh7NLj49KNtqH/FEc2Gryw0M?=
 =?us-ascii?Q?zepcqkFXAZtdRCbmOiB5F8LxKHeJZLiRCO+5WV7DHq6d0e+i2UsQ95HyQ0hA?=
 =?us-ascii?Q?xM13bfm34l+FiBCVWC3zIeSUKD6ap0RtVCsWaO9/d7W4e4K93thgJEwsQ/2v?=
 =?us-ascii?Q?P+2H3yAv+Llb5K3l7V1kAOcCnCToGmy3jvV2SbGB5kBAr6Q8KsUVYgeOt+1a?=
 =?us-ascii?Q?r8ZKXxq7LatCEtalhpFK06XBp8ilc2Gw9VqaIyI386NT0KV9bg+W69lVwc5O?=
 =?us-ascii?Q?gECE4Y1zndhC47TOP+NYXDYISbV1BdoPs/CdNQ7x7nJh5okbqqEhfO1tX1Hf?=
 =?us-ascii?Q?f4B6HWQ2FV9DReCKKi3Yng24ndJxnNYOpI+Czw7/FN2mdHjuu+iOOyuxZ1xI?=
 =?us-ascii?Q?WAtUfAO8binBQJ1oaXQpJXT6AnVWJKV/xUxH4/Oiastq1hu8gRVtMW2P7wCS?=
 =?us-ascii?Q?BOuaK7ZxPI/w/dEXltulTNXNo/KLSBeN0IT0cTH2rwLqUW2rMKDcN8mhR372?=
 =?us-ascii?Q?CMiWXKjW5lagcLbGuZruy68Hp6BxrNO1JFPjYWh86Z2M3jIHXlsQJjzhdABJ?=
 =?us-ascii?Q?Xeh567qdDHUzmh3YjGEPu3NAnwRympwREwAir9zlU74AgluNwjPgHdIAh1ug?=
 =?us-ascii?Q?M6v3gjKBqzrPZfQSKz0+mk9wusmqX0rgaOFRS9KTjjNmytAFprVa97zpXBYG?=
 =?us-ascii?Q?HgzBarovurW6xxI77ZwyBUBCsdISId3BzYHPKR7Yu09seZ6TDppxeAtUA/nA?=
 =?us-ascii?Q?HSFzz7okTWVQwQ2ltYZS3fR5FTbG3Cj86N+slRNhI5ikx683iy6bwPdxqmmW?=
 =?us-ascii?Q?Wo27eGEi5Y+8KTFwfJUiPcnIMXAt1mwS1OPUxCxbb53b47FNZWFGGYhMVMVP?=
 =?us-ascii?Q?mjLhv5pv5/+CiarvzM5jyEQ4DExOSKEO5AGZFOBeZeOVZyWgXusBHUy2IZv6?=
 =?us-ascii?Q?3V/ZOZZuHSlbtlWgqJgbxas=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2123e2-a1ec-4bda-04f1-08db54f4c77a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 03:30:49.7856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r7rrjU3lu2rBgGS+PWa80MWSYobIIJlyzRlzAUWnz60xDAnWloj9TkILx1eTLbLRWlsEq0N4pWKN5VhBmC9pr3Y9P+Jci+Sss+/37cQiipLw6Qbqy10K6l96vP1+jXcD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7715
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Maciej,

> On Fri, May 12, 2023 at 08:51:23AM +0000, Zulkifli, Muhammad Husaini
> wrote:
> > Hi Jakub,
> >
> > > On Tue,  9 May 2023 10:09:33 -0700 Tony Nguyen wrote:
> > > > There could be a race condition during link down where interrupt
> > > > being generated and igc_clean_tx_irq() been called to perform the
> > > > TX completion. Properly clear the TX buffer and TX descriptor ring
> > > > to avoid those case.
> > >
> > > > +	/* Zero out the buffer ring */
> > > > +	memset(tx_ring->tx_buffer_info, 0,
> > > > +	       sizeof(*tx_ring->tx_buffer_info) * tx_ring->count);
> > > > +
> > > > +	/* Zero out the descriptor ring */
> > > > +	memset(tx_ring->desc, 0, tx_ring->size);
> > >
> > > Just from the diff and the commit description this does not seem
> > > obviously correct. Race condition means the two functions can run at
> > > the same time, and memset() is not atomic.
> >
> > While a link is going up or down and a lot of packets(UDP) are being
> > sent transmitted, we are observing some kernel panic issues. On my side=
, it
> was easily to reproduce.
> > It's possible that igc_clean_tx_irq() was called to complete the TX
> > during link up/down based on how the call trace looks. With this fix, I=
 not
> observed the issue anymore.
>=20
> then include the splat you were getting in the commit msg as well as step=
s to
> repro.
>=20
> from a brief look it looks like ndo_stop() path does not disable Tx rings=
 before
> cleaning them? This is being done when configuring xsk_pool on a given Tx=
 ring,
> though.

Yes you are right. We shall disable tx queue ring as well.=20
I will submit the V2 to replace the igc_clean_tx_ring() to igc_disable_tx_r=
ing() in=20
igc_free_tx_resources() during ndo_stop callback while maintaining the mems=
et=20
to clear all the ring des/buffer during igc_clean_tx_ring().

I have tested this on my TGL setup with multiple loops iterations and no mo=
re
Kernel panic observed. Will update this in commit message as well=20

Thanks,=20
Husaini

>=20
> >
> > Almost similar issue reported before in here:
> >
> https://lore.kernel.org/all/SJ1PR11MB6180CDB866753CFBC2F9AF75B8959@S
> J1
> > PR11MB6180.namprd11.prod.outlook.com/
> >
> > > --
> > > pw-bot: cr
> >

