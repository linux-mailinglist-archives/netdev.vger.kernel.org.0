Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3522259C4C0
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 19:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbiHVRK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 13:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237256AbiHVRK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 13:10:26 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F4E219E
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661188224; x=1692724224;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KUXUWDzTRov/AXidPiapqZWQ5dpW9P14WN7CJYQiyLg=;
  b=aks5qFRqjmwn/zawSsdyOcKMi4wRfVNri2cbIoI+pkAxppKgdbwZ14tL
   HWycPmly9WxTs8YnkzwkKiXrtDKuWiPPQGmMVhrz1D52Qw6vXB5PQcujD
   Ag8WjrFKeDUTcqy6b/ZRRWh9GdInKHPngVJF6Gh4OIAgx0EdqSHJFf9F2
   8x06HgJhb5YH4+CJHvGecRcDMlpsFGmS1SREw6woC7rJFesyGvrZjXx2S
   od3UA6zgxtMxdXN8GUrhwFXGzFJboWe1+3Ulv6eAwy9w1Gjqcf4T0wPBE
   UENMUj8v4pug150kjQHmx5bI35OImQrpvhsalIO2WGIwNBJGy4Wzo1SIz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="280443793"
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="280443793"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 10:10:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="585606016"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 22 Aug 2022 10:10:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 10:10:19 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 10:10:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 22 Aug 2022 10:10:19 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 22 Aug 2022 10:10:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bypO8a7ucRLLdWMBfUo/7c4w0hz1ReWyS2Vt7ixtr26/3vtE/W/9rMG6qCTBRukqN6B7DG3ItcDBbc8PBouj9b4xeFBziZWaUyFxqvSBBnlWw8xknexYd3vyC0d1WTlVeLKnishl6zcxR6qbE1DdTnNNNm1cfKE19BJg767LlHxEJPZZ6hAp0An5LzwR/KkLTWG6w5RlvUH+ZImerjGESYdk+yTJ7vRxe7olA75eEOLQtqWt8jE+YHEvQptXHopCBbdaWsh28Nn7WN5vo82R90h/IWxtZwHUTjZfv4d33gwwzDWQzBt7exkAUtX2lhIgp+EPaN7Ns1GSrlg2ai/VfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SHT/yvQLWTNBjRxOLG36RFSxMxzUJ5BS9lo62Z1w0wM=;
 b=FudiEDe6gjxj/AvK7WDT6vb8jwA/eurZ/YeZQkUkrgtDp1s0FuTgnpyT/G9NYfCtA1RLZ2swBHHrZBOMYnGQiAwnEfplmKOa/YZj7SnaqxvBV1xlJkBs4NEqhVs/Fl/TCYjC5cCfDUga2bKZ9l9LL+R2gUlZQ8IQBS1BHzg6VXYkPnz00rOix5wByF0fVN6V+Hdz+llw2+MGD4JYipJmTiSc74+3ZwD7DPvtC3d88AvoV0RzPGZjlnB7mYOP+rIy0FtwFoEtWRmi3ckvjxb4z5oI1wTGuqKn2+//y4DfycZ15BmcYQm8f+hzOp9OaPj8mJppnzoSTjqgYV4p/vnrgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN6PR11MB1540.namprd11.prod.outlook.com (2603:10b6:405:d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Mon, 22 Aug
 2022 17:10:16 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5546.023; Mon, 22 Aug 2022
 17:10:16 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     lkp <lkp@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Cui, Dexuan" <decui@microsoft.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Siva Reddy Kallam" <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Bryan Whitehead" <bryan.whitehead@microchip.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "Alexandre Torgue" <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Thampi, Vivek" <vithampi@vmware.com>
Subject: RE: [net-next 10/14] ptp: lan743x: convert to .adjfine and
 diff_by_scaled_ppm
Thread-Topic: [net-next 10/14] ptp: lan743x: convert to .adjfine and
 diff_by_scaled_ppm
Thread-Index: AQHYs1HJHtAIU6+gykqZEP0ZAkEtJ625fPoAgAGwWmA=
Date:   Mon, 22 Aug 2022 17:10:16 +0000
Message-ID: <CO1PR11MB508911401FEA7092B5C2D11CD6719@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220818222742.1070935-11-jacob.e.keller@intel.com>
 <202208212326.87xlsbQB-lkp@intel.com>
In-Reply-To: <202208212326.87xlsbQB-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fb70f5d-f650-45f2-50f1-08da84612ef8
x-ms-traffictypediagnostic: BN6PR11MB1540:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i96G8V+5T8dhLZqbcTuT1tRTFx8TAhxrafoRdZGFs9fc6mqHZpJ98wWr+7QTlG3xZKUWBwjxcbT9EDyze8dXRgp+eLkUkxdAybKhDnivYVAbhT6uEFyFJxs47IMWHmVHwwEi8Z0zNWLol/amle44CLxQlVXl8Oy686CMugT97407sGZbCN6RtMe6cu7JEQ5mvShRk8KxGhe8lzbeG+PCA6z8iV0BcpLyNBaYMIzpjuk77eMX6FkQHToTHl/fl86CvcDDb/UHjCeOFufRgFYxdMIMhkjukNyGM1YIR/9ofKT+I0ZW13TqW8W8SaMTRBx+9fqN602PSUTy0uQJSJwCwdIW5oRiq2iWWGdDLXnQcTvBZwTsbYw9mKO9LGp3V1A0+7D9Uo7LvPDIRzy+n5yYTsxYy5JHCu6HMF2qnPeUGy3GDkz0QRoZxcrG07HuXOxLChXYbFQsKHQlh98wBn6jjFcv5kJDi5bSE+DjOfzlvOEGcO16VO73T5bjkboSQTLQpHW0w0MMY77U4jFMuoap6LWN6VP3CFKAwJkWhMwiLtIvlxNcGiXmln9HGkIUREcksVeGn5we56IKYCOLgYpXNa+NrN5bj4vmppf0uXOsZqmxHw7nE3z94wmOjOyfnQxpOToehtzpCT3svg79Z1h58n9s0NZeJiD/x5Hv5i62wNimG6mlItDPDroWJC2dB87hCBVhurzdol+Xy1lBU3ulx9R7yXC0Z+1Fh/s9BHQiLzx8hRF/lKr2ofJZrY5Y2VPs1E93uPo1qmVe4w7Ru3P24GQC/ohz25lxWgycnnO3xcMpIKlLlx+a+bHqtlHrRIrDzjaH8AbXOM7n05nlqnDD27MhB5+P8tM8P1E+v/rcWoM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(396003)(346002)(136003)(376002)(966005)(6506007)(478600001)(41300700001)(7696005)(71200400001)(186003)(83380400001)(52536014)(9686003)(8936002)(26005)(53546011)(2906002)(7416002)(5660300002)(55016003)(316002)(54906003)(110136005)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(38100700002)(76116006)(86362001)(33656002)(122000001)(82960400001)(38070700005)(142923001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Goy014mkoh1aUiaOApgWrjRs4qa7+a6V8WVyoC0RBwgkhY2I2pqT0OwnzKtt?=
 =?us-ascii?Q?WJx1vI5Soo8iTPz+GADex+/C1CzagTZzK4NKSz7O933h9cvPXZJg0P6MzosK?=
 =?us-ascii?Q?MMJlOzoH6P4j1ty6m3ugmjn9+kErjH4lER9QR3KCXJytW+ct5WOLzYmlkjIa?=
 =?us-ascii?Q?vooM+1/bITO0IqPZ/mDf/vjynkM4M0eBUeY4wSqlq9VT0imc2IBDK8n1Rtj+?=
 =?us-ascii?Q?+GZYUqlVA9cCWSK3/YglrrbPJ3WePy3rjk3HD0QmVlT+uN3Pun1DvFdvT+F9?=
 =?us-ascii?Q?9x7WxNcPhi5imGs2T88AA8gSRfK4ekKYeML+yYYGj5hRHa8g8xoWnQElRYGs?=
 =?us-ascii?Q?2h7Ept9X1VXke80M2Novgc1aA4nI2q+NK5PQ7xM0Fl0FFLEoodYvh9Bov3DW?=
 =?us-ascii?Q?4wfZYQ8cCkJO5PzlFx7demExl+QK8mHiGpRxj0CrbOzt9S1XA53lK5qcFlGG?=
 =?us-ascii?Q?1Ziq1gMoO7b7g9c1LCqirZC5dHesCeKvWdWgqKv06/ne/EM8qgoaRu9r4ZNw?=
 =?us-ascii?Q?TvQCMJ23Qhsiiylf8W/lGkHWjEgfv6OH9w1GPV6yyskOcnack3jzqtrJ76uP?=
 =?us-ascii?Q?13paHfOJQShBgFrqATJ7kNla3yMBTvvcQgiXI5leNUrBSTEVjfHlWrlTOfTV?=
 =?us-ascii?Q?MTeaUs35B60GLq+ww6lG/94axpEmG4XM4pMPUTwJ3zk7rP7d6/bqidWZg2hc?=
 =?us-ascii?Q?v3EGP3mpd7WFxw7vUZ8w/ZVfhu3+qfYydt28NFry1/6lV2q478w0vezdJeC2?=
 =?us-ascii?Q?PPb1NvXZhpNOimWM9z6xXh9fyQp5zJBAOnhGRG4z7NBARiZ11+Gx8oPSkSNF?=
 =?us-ascii?Q?LTPmIFUKBqcuyGEaC86Qnp5mDKgsqxNPwbskzYlnRI4fZ2wVAkFjr14DPLYJ?=
 =?us-ascii?Q?8DNyHE108ZO05pXMQjcQ9RIe5W1DdXCcOZ0clbveyNWHP+Och7yJ0mD4H/kr?=
 =?us-ascii?Q?iw6+lnlFF2N8XC7vopD03O1y7SGMrwMvK7UqI0GxZ1WQBr4FRe2xODiMr0rh?=
 =?us-ascii?Q?z/QupfFhgRS02HQuBa8ZpqcPWcvyBQi61wsudm+pIS4FPVwb66O0tBXCMw9Z?=
 =?us-ascii?Q?U23lsJfuvL3yWyIxymfVcCrqgQK96h9eeogh6eYDkQ/4YV8NGs+2BSny0r53?=
 =?us-ascii?Q?3g0JmbxZz+1rwrftV/+Q6ecfGWaoFbCQNBRIA1DvwC507eCPJZ9DKnovL82j?=
 =?us-ascii?Q?6qZVs4d/arY013B1KPc4C6okxZUL+25xuQ+JLhHpM5txhW7gGLAvn4n67PQ1?=
 =?us-ascii?Q?fPRryjqUV7Z0TRWzjOupYSHXD12s/QyBF3NV8BwtgovCNytsRmU3TvQEIEzG?=
 =?us-ascii?Q?PVNZvNZRnUD+R5eLFUqSwlOFmnxN4OqblRKbwqqRyHdgfRNG3RNoIwfEvEAg?=
 =?us-ascii?Q?0feQUKazEvxN946VDNXP6KPMGZlGXBjwXCCEqdYxHFsfZ2XG6HeGhy8Wg59B?=
 =?us-ascii?Q?DkZYwvq3p5ubbj3s3useFTEbUoFiGjfOUppavTnPmJOk2pqdJIXqVKYwYDlw?=
 =?us-ascii?Q?l3LCD49fufv0amc6Nmo8aN67sXaUDxLpsXHwTU6+wnH8R0zQGvn1EZHEwhIQ?=
 =?us-ascii?Q?GfAmyBg3uxd1cWOq3uWXxjPmjktX3VIXblzVSrEF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb70f5d-f650-45f2-50f1-08da84612ef8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 17:10:16.0753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WMCVScYAWvTtP9PSP9YF8XRmtKD9Wsn5DYuyqYKYPDbmFgk7Py+RR2zlUG2oR3wMBmtE7mpswYudgArwClOhZV1OQzt5FAcTbwsxkhyq9GM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1540
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
> From: lkp <lkp@intel.com>
> Sent: Sunday, August 21, 2022 8:22 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>; netdev@vger.kernel.org
> Cc: llvm@lists.linux.dev; kbuild-all@lists.01.org; Keller, Jacob E
> <jacob.e.keller@intel.com>; K. Y. Srinivasan <kys@microsoft.com>; Haiyang
> Zhang <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Cui, Dexuan
> <decui@microsoft.com>; Tom Lendacky <thomas.lendacky@amd.com>; Shyam
> Sundar S K <Shyam-sundar.S-k@amd.com>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Siva Reddy Kallam <siva.kallam@broadcom.com>;
> Prashant Sreedharan <prashant@broadcom.com>; Michael Chan
> <mchan@broadcom.com>; Yisen Zhuang <yisen.zhuang@huawei.com>; Salil
> Mehta <salil.mehta@huawei.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Tariq Toukan <tariqt@nvidia.com>; Saeed
> Mahameed <saeedm@nvidia.com>; Leon Romanovsky <leon@kernel.org>;
> Bryan Whitehead <bryan.whitehead@microchip.com>; Sergey Shtylyov
> <s.shtylyov@omp.ru>; Giuseppe Cavallaro <peppe.cavallaro@st.com>;
> Alexandre Torgue <alexandre.torgue@foss.st.com>; Jose Abreu
> <joabreu@synopsys.com>; Maxime Coquelin <mcoquelin.stm32@gmail.com>;
> Richard Cochran <richardcochran@gmail.com>; Thampi, Vivek
> <vithampi@vmware.com>
> Subject: Re: [net-next 10/14] ptp: lan743x: convert to .adjfine and
> diff_by_scaled_ppm
>=20
> Hi Jacob,
>=20
> I love your patch! Yet something to improve:
>=20
> [auto build test ERROR on 9017462f006c4b686cb1e1e1a3a52ea8363076e6]
>=20
> url:    https://github.com/intel-lab-lkp/linux/commits/Jacob-Keller/ptp-c=
onvert-
> drivers-to-adjfine/20220819-063154
> base:   9017462f006c4b686cb1e1e1a3a52ea8363076e6
> config: powerpc-allyesconfig (https://download.01.org/0day-
> ci/archive/20220821/202208212326.87xlsbQB-lkp@intel.com/config)
> compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project
> 01ffe31cbb54bfd8e38e71b3cf804a1d67ebf9c1)
> reproduce (this is a W=3D1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-
> tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install powerpc cross compiling tool for clang build
>         # apt-get install binutils-powerpc-linux-gnu
>         # https://github.com/intel-lab-
> lkp/linux/commit/d3c6eac5778f2ce74e7d6d7be90a60f616551718
>         git remote add linux-review https://github.com/intel-lab-lkp/linu=
x
>         git fetch --no-tags linux-review Jacob-Keller/ptp-convert-drivers=
-to-
> adjfine/20220819-063154
>         git checkout d3c6eac5778f2ce74e7d6d7be90a60f616551718
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross W=
=3D1
> O=3Dbuild_dir ARCH=3Dpowerpc SHELL=3D/bin/bash
>=20
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>=20
> All errors (new ones prefixed by >>):
>=20
> >> drivers/net/ethernet/microchip/lan743x_ptp.c:368:12: error: redefiniti=
on of
> 'lan743x_ptpci_adjfine'
>    static int lan743x_ptpci_adjfine(struct ptp_clock_info *ptpci, long de=
lta)
>               ^
>    drivers/net/ethernet/microchip/lan743x_ptp.c:335:12: note: previous
> definition is here
>    static int lan743x_ptpci_adjfine(struct ptp_clock_info *ptpci, long sc=
aled_ppm)
>               ^
> >> drivers/net/ethernet/microchip/lan743x_ptp.c:386:3: error: use of unde=
clared
> identifier 'lan743_rate_adj'; did you mean 'lan743x_rate_adj'?
>                    lan743_rate_adj =3D (u32)diff;
>                    ^~~~~~~~~~~~~~~
>                    lan743x_rate_adj
>    drivers/net/ethernet/microchip/lan743x_ptp.c:374:6: note: 'lan743x_rat=
e_adj'
> declared here
>            u64 lan743x_rate_adj;
>                ^
> >> drivers/net/ethernet/microchip/lan743x_ptp.c:388:3: error: use of unde=
clared
> identifier 'lan74e_rage_adj'; did you mean 'lan743x_rate_adj'?
>                    lan74e_rage_adj =3D (u32)diff | PTP_CLOCK_RATE_ADJ_DIR=
_;
>                    ^~~~~~~~~~~~~~~
>                    lan743x_rate_adj
>    drivers/net/ethernet/microchip/lan743x_ptp.c:374:6: note: 'lan743x_rat=
e_adj'
> declared here
>            u64 lan743x_rate_adj;
>                ^
>    3 errors generated.
>=20
>=20

I'll fix this in v2 once I get feedback for the rest of the patches.

Thanks,
Jake
