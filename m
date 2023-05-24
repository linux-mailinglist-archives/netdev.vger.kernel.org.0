Return-Path: <netdev+bounces-5124-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D03770FBAB
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:27:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42736281272
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2568D19E62;
	Wed, 24 May 2023 16:27:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F352719BC4;
	Wed, 24 May 2023 16:27:19 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091E6D3;
	Wed, 24 May 2023 09:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684945638; x=1716481638;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=20m4lDezMb/abIiupQM/BCOiwNgoYbJV8snsLeD9HCU=;
  b=dJQR1ybB6WAjGp4phDFgVvcEMleenZU8WXsKU/JeFhGhS259/AbzhEtk
   c+Kvcm8ceIgCz5/KNQX+RiJf9QjKZIcha/tosW8E2uZD+CEFf1KM6MM5L
   2SH0EUtvq/0vxivOdtDUGZYiAQndPhd4fXPqlTzRLe/wXYltgLf9ur6ye
   DnJAQAjt1X/TnKxhMm6c1V+xCCu4XDQ1H6r0li9BSTWUFI846CMNPtxgv
   4fD6t0aUlz44NiJY64Qr/8CCc+tIvwY1qB5epWeQAcwMmkI5ewGvwLTOA
   HRcFGDsTV8an46WQXdaTZbEAHg42oDr6cK5afBsm+qWo9u4amEbjDmp/r
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="333977335"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="333977335"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 09:27:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="774310612"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="774310612"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 24 May 2023 09:27:16 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 09:27:15 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 09:27:12 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 09:27:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 09:27:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iycLP9ASEm+039wlygfbhmRMi5cduNXHkD1KAhlvi8dfXVbNufvNzGkET0ZaZ7r9/KKfHlgkJVLDbTfddhQXYkNNG+7EWPI7Jk5YxifZY4PIlzxJ560yCEu/wd368vE596IESz/kBjkjnkP1crlZCY1AtNj7r4G67rTI5/9wMk3WvUy10vIhi/65xIKBF6G3s9LYiC2XFoeDcXTKYEfZvdcgn9JYZW5BC4iX4dZGFMkr7CIIIHPl+bqjcup/J6Xk43eAvuOUsBdWKRlLAr5DZyrHhAwfERY1aZnFY2xjs2tMxoYJ/qCQk0nllaJ7pB0ppEzPmkLi67+tlIG3nlRkuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FWoxE39mc65DzkR6cHHBVu76D1PLw9ynBQgKqK7el5w=;
 b=nUq5aEheGOq1ZzZS45b4Sdfay1qu8Z1ZsNgVLigUHO5Wx4xe7hFIk6GM2dA637xPTd0MWc1r9T8W6Cn+QaxuXg2aeeuNjyC5UfsbvveGtL8KiRgohylx7CUjGOdkDAlwmbC3A5+5Sdoyx+dl6ZtPS5f/uFC+FS9aVy0jMovW9AbdKhwayM81qS7VL0G1tI2L3SzN0xJUz/ZlwBD3rjGs0yQPbX8v3iD6DsNBrVNudqda3/hmjRR0EB740no/iZkvpJlVoV//aroBpk+UKy8PpeF1H53GNV/AZHXBAksxgjBapA5f0Xxw4MUuGau948yvmZxMk1NqnWqTjqJ9d+Mfew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM6PR11MB4705.namprd11.prod.outlook.com (2603:10b6:5:2a9::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.29; Wed, 24 May 2023 16:27:11 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 16:27:10 +0000
Date: Wed, 24 May 2023 18:27:03 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Stanislav Fomichev <sdf@google.com>
CC: Alexei Starovoitov <alexei.starovoitov@gmail.com>, "Sarkar, Tirthendu"
	<tirthendu.sarkar@intel.com>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov
	<ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
	<andrii@kernel.org>, Network Development <netdev@vger.kernel.org>, "Karlsson,
 Magnus" <magnus.karlsson@intel.com>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?=
	<bjorn@kernel.org>
Subject: Re: [PATCH bpf-next 01/21] xsk: prepare 'options' in xdp_desc for
 multi-buffer use
Message-ID: <ZG4611HpAB1zA1EA@boxer>
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
 <20230518180545.159100-2-maciej.fijalkowski@intel.com>
 <ZGZ66D8x5Nbp2iYO@google.com>
 <CAADnVQJN6Wt2uiNu+wbmh-MPjxnYneA5gcRXF7Jg+3siACA9aA@mail.gmail.com>
 <SN7PR11MB66554BA6BE57F4CBB407B88290419@SN7PR11MB6655.namprd11.prod.outlook.com>
 <ZG3mkn3gvLmXDUZE@boxer>
 <CAADnVQK4sRi3stAv31TB3iRZ=_096WUwW49Z49Zh8tNp2fmx0A@mail.gmail.com>
 <CAKH8qBsKxAzP+sU5diPjtmhsJG2zCYPy4URZJKU3XaV9jjiDHw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKH8qBsKxAzP+sU5diPjtmhsJG2zCYPy4URZJKU3XaV9jjiDHw@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0442.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::15) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DM6PR11MB4705:EE_
X-MS-Office365-Filtering-Correlation-Id: a1904958-715f-4ec1-4b9d-08db5c73b8e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +cNqYewH92fs2s/AaJB+XsnuzTsBZstF/jcpJvQn41Emz8GGbCcTdix6F2QGt2Z+Hj1lFdPlQDr+aTMIueW5Vhg3ivVF6vIIjKbU/8jL2y5F1mvlRjR9lTnVfjJJNDKlBdMzdMpshkUeJFXRDTz+O1TkK+aUAHHp/KaXWA88EwhDTCNZHjxsmDQJdYNz1Q8Wkfu+EVGFrke1E47Z5ZGK1xmXvGyKDp2B6zNDShA6qbYJzW2eJ/9mRUwYXiXjJTScjJZq3fMKrkBC1vvUGdP9Ev5OSsVfEHH7zbrW9CiOPBQi0QPgz0q2DNtbEtnuJE6ImSh7QvCdNRATOz6vZTa4pEKYZQpnBZCQpGLaSqoABLTZNswvuQpCTVPJkq6aT4K7Wg4FVJ+Rq4RnSAb3bwwwelyiPnu4hiQaEdS/ly8oqrmtL6QVEXw5I5F8Wjt/WDHshjKxi3eXJhXqY+wyfKjzhI3AkFIbbJsmqkbrM1JCrj6oo4/dY7b3Tl2KGTEf867SiEMWucpPfECvxJrStqzAi73rfnv2jFExKeiL3f0EoqyKYJUy9KRWZiJCAL0SUjsq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(39860400002)(396003)(366004)(376002)(346002)(451199021)(33716001)(66946007)(66556008)(66476007)(6916009)(478600001)(41300700001)(6486002)(6666004)(54906003)(316002)(4326008)(86362001)(8676002)(5660300002)(8936002)(82960400001)(44832011)(26005)(53546011)(186003)(6512007)(9686003)(6506007)(83380400001)(2906002)(38100700002)(66574015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVNFVkZsNHZGSjNmbEJIZVlQMDdMd1ZUNzRFdWpIOWhQYU5rcDRsRlZPS2ZL?=
 =?utf-8?B?ZGVNN3lIak9haVp4dDhFdFZWd1cwVnhDdjhlSVFrVmpiQURDbEJLUVZ3Skt6?=
 =?utf-8?B?bGlVRDVGbG1SOGhSV3dXNm9TN3c3MUZIN29BR0hRK1N1azRqbVBtQWxwVE5x?=
 =?utf-8?B?RkxFUUYxdlVOcVNNQ215K0Y1MENNRzBOTFN6THcyWC9uNTFYZDVTcGNDcXZu?=
 =?utf-8?B?SW05UGpkQzZ1RHNyL0puT2x0dkdWK2gvTXZIY0t0Mk02YmdGUStkdm1oUTIx?=
 =?utf-8?B?Y2d0Q1ltYmxGSWQ0bjBDclNmdUtvMHV4RGJsd1RVZW9nY2d2MWZYVjVnWGZR?=
 =?utf-8?B?dVVReEc3QUlkMCtQN2RlNzJSaFpMODBZZ0xkZytkWHAySDlkRUVWTlVqb0h3?=
 =?utf-8?B?dkVmMzI2c3IySG5MK1Nnak9CN283d3ZXNHRSc3FYOTRCZjBPTExOV2hHdmpM?=
 =?utf-8?B?dVd1c3h1Szd5ZzRvUk5iMWhacldDaUxEaEozaU4yWTkyaWprcVh0Ly95TUw3?=
 =?utf-8?B?MlB0SG5wRGdJWjYxY0xySFJuMmNSaDE5UkxpNlRnY1NyTzNRNTFxa3lmVFNL?=
 =?utf-8?B?dVhFZUxlN2ZPUGVPbm1uaDNWK1B0SE1jcE5UcEhXeUg1U0NLbElDTkwvZk1W?=
 =?utf-8?B?bzBzWHorMWRUQnRHM25ON1pYRmttcVNsVjVtUkFHRlpRVVBZeUt6dVRQaGlH?=
 =?utf-8?B?NlNmcHl1WFg3ZFZxVEZuVEhWNlFwaW5YRnd2aThRaWdVZGpnZmNxZGMwUlRD?=
 =?utf-8?B?eXEveGM4ZEFSL2hkU0lEVThjV3Mzdm8xdEROWVdraUNhTWc1T0FBcmVJTmJQ?=
 =?utf-8?B?cjZFcWE5WWVxdjRkYmZjcFlVaHJ4UFZJS2l6cGJhRy9UNno4dzhvbHNYcElL?=
 =?utf-8?B?WWswNW9PcURQWmlkWE9DTkxFOGQ5Ym43cWhKZTRMQ2dOdlFZQVBrbVNleXpw?=
 =?utf-8?B?L05sR2lNU2hrMktlcFFhMTAxcktCWkFPcU9wa2JWN0NHZnYybFhJTEg2OVox?=
 =?utf-8?B?c0I0VzNLTHU0ZHFpUTBkVkxmaHA5Q21uWjlicmRJUTMzNnRCb3BNTklZNW41?=
 =?utf-8?B?ZDFtYWFnVVRGOGtzWWdxMnZsSnVpQmdTUEZrMzg0aW9icElCWmRNVjdFeHg3?=
 =?utf-8?B?QkdWYS83WG1BK2Y4QTU1VmFHaVdLMGU0aXRJZ2tyN1Bnd2RUcnhUL2g5aTk5?=
 =?utf-8?B?T2R1OFBFZDZtcmRGTmJTWFRHZGlHQ0QvcUlKVHkzQ25jVkhuSWZ0OUE3d1NT?=
 =?utf-8?B?UFVzbC80ZSsxS2ZGMWZlL1phanp1SnB6bTdaZjlJMkgxYlpqMDhmQVhvWVcr?=
 =?utf-8?B?NlhibDJaUG84dlNkOUdTTzRiWW4vQy9CU2lNbE5nZnBSRnN2V2tPYno3aEla?=
 =?utf-8?B?N3hVZ3FkdVVTdEtVYUZYd1VqQTVKd011L2pudTVpV3pNNTZDUFNVcFp2Z3ds?=
 =?utf-8?B?bUNPSTNSdkY0NW9oZWljZUt1eW9mbkpBT05EQzhCeW9CdWhGUFJwUDAvbDNw?=
 =?utf-8?B?dXorZzhVWUFUNmgydzlJMm9vZk5sWDMxWllpQWlZTW9XRnV2OG1GSjdVN0VS?=
 =?utf-8?B?SGhjeXFkOUNPdEtZNFVUY0JOSFJ5TDhlb1RHMTA4cnNWTFIvbGRJbjJtTzJV?=
 =?utf-8?B?RHdEbGdTdXlhbnpVRzBFOEFOUXhaZm9LUS9URzgyd25MaXVSaHRsTGJrZEs4?=
 =?utf-8?B?WFRJNjI0S1hTQXhnZElKeXMzRCtoQ2ZoeXJydUxFOXNaVWtvWURaUVQyb2xV?=
 =?utf-8?B?M3BnYmhwL2owRHRvbnZCdGZGMURrVlpFUmtlTXJZZDV4REh3T29LK3A5YzN1?=
 =?utf-8?B?dStYQmVSK0FVSVRtMUJ3YXBLRlg4aUxkV1V0di9MNUlLdTFPWjdFNmxrcHN4?=
 =?utf-8?B?UXlxMGp0TjBnWGZOOVBTRG1kaTR5SFpVM0FVN1g1Nkh6REpOSEN4OUUyU0xt?=
 =?utf-8?B?U1NpMHJxOW9oZWZZR2dVRko3c29pbmY0cTRQbm03cnQ4dlYyWTRwU3d3bmoy?=
 =?utf-8?B?YXBKMGZPWHVMU3BvWVFsZWVkZnBwSmE3VVgwMFJQN2ZxQWlYNGRJVERXNkpp?=
 =?utf-8?B?YUlRQ0JJYTVpQWtkZ0xlcEVSVXRKOUcwUHdQNEFxWjhTRE1SWGIwU2RrYXQ5?=
 =?utf-8?B?eDFrc0pkUmRWQlBzYk1lOFlvblVpZ2UwclBxbnpDdko2N2NaNzVhOCtnSzND?=
 =?utf-8?B?MGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1904958-715f-4ec1-4b9d-08db5c73b8e3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 16:27:09.7570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OZ+1Rk3S2Ok34JavMfNNzox2Qe5/OH7hkqm3qzNjSexqZJ9G0xU9al36+eW+5liwmrTS8/3k/n/UGjRj0lJbkPRnwq/HhVMzDhkFzgp64Os=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4705
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 09:20:05AM -0700, Stanislav Fomichev wrote:
> On Wed, May 24, 2023 at 7:12 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, May 24, 2023 at 3:27 AM Maciej Fijalkowski
> > <maciej.fijalkowski@intel.com> wrote:
> > >
> > > On Wed, May 24, 2023 at 10:56:21AM +0200, Sarkar, Tirthendu wrote:
> > > > > -----Original Message-----
> > > > > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > > > Sent: Friday, May 19, 2023 10:44 PM
> > > > > To: Stanislav Fomichev <sdf@google.com>
> > > > > Cc: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>; bpf
> > > > > <bpf@vger.kernel.org>; Alexei Starovoitov <ast@kernel.org>; Daniel
> > > > > Borkmann <daniel@iogearbox.net>; Andrii Nakryiko <andrii@kernel.org>;
> > > > > Network Development <netdev@vger.kernel.org>; Karlsson, Magnus
> > > > > <magnus.karlsson@intel.com>; Sarkar, Tirthendu
> > > > > <tirthendu.sarkar@intel.com>; Björn Töpel <bjorn@kernel.org>
> > > > > Subject: Re: [PATCH bpf-next 01/21] xsk: prepare 'options' in xdp_desc for
> > > > > multi-buffer use
> > > > >
> > > > > On Thu, May 18, 2023 at 12:22 PM Stanislav Fomichev <sdf@google.com>
> > > > > wrote:
> > > > > >
> > > > > > On 05/18, Maciej Fijalkowski wrote:
> > > > > > > From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> > > > > > >
> > > > > > > Use the 'options' field in xdp_desc as a packet continuity marker. Since
> > > > > > > 'options' field was unused till now and was expected to be set to 0, the
> > > > > > > 'eop' descriptor will have it set to 0, while the non-eop descriptors
> > > > > > > will have to set it to 1. This ensures legacy applications continue to
> > > > > > > work without needing any change for single-buffer packets.
> > > > > > >
> > > > > > > Add helper functions and extend xskq_prod_reserve_desc() to use the
> > > > > > > 'options' field.
> > > > > > >
> > > > > > > Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> > > > > > > ---
> > > > > > >  include/uapi/linux/if_xdp.h | 16 ++++++++++++++++
> > > > > > >  net/xdp/xsk.c               |  8 ++++----
> > > > > > >  net/xdp/xsk_queue.h         | 12 +++++++++---
> > > > > > >  3 files changed, 29 insertions(+), 7 deletions(-)
> > > > > > >
> > > > > > > diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> > > > > > > index a78a8096f4ce..4acc3a9430f3 100644
> > > > > > > --- a/include/uapi/linux/if_xdp.h
> > > > > > > +++ b/include/uapi/linux/if_xdp.h
> > > > > > > @@ -108,4 +108,20 @@ struct xdp_desc {
> > > > > > >
> > > > > > >  /* UMEM descriptor is __u64 */
> > > > > > >
> > > > > > > +/* Flag indicating that the packet continues with the buffer pointed out
> > > > > by the
> > > > > > > + * next frame in the ring. The end of the packet is signalled by setting
> > > > > this
> > > > > > > + * bit to zero. For single buffer packets, every descriptor has 'options'
> > > > > set
> > > > > > > + * to 0 and this maintains backward compatibility.
> > > > > > > + */
> > > > > > > +#define XDP_PKT_CONTD (1 << 0)
> > > > > > > +
> > > > > > > +/* Maximum number of descriptors supported as frags for a packet. So
> > > > > the total
> > > > > > > + * number of descriptors supported for a packet is
> > > > > XSK_DESC_MAX_FRAGS + 1. The
> > > > > > > + * max frags supported by skb is 16 for page sizes greater than 4K and 17
> > > > > or
> > > > > >
> > > > > > This is now a config option CONFIG_MAX_SKB_FRAGS. Can we use it
> > > > > > directly?
> > > > >
> > > > > Also it doesn't look right to expose kernel internal config in uapi
> > > > > especially since XSK_DESC_MAX_FRAGS is not guaranteed to be 16.
> > > >
> > > > Ok, we have couple of options here:
> > > >
> > > > Option 1:  We will define XSK_DESC_MAX_FRAGS to 17 now. This will ensure AF_XDP
> > > >  applications will work on any system without any change since the MAX_SKB_FRAGS
> > > >  is guaranteed to be at least 17.
> > > >
> > > > Option 2: Instead of defining a new macro, we say max frags supported is same as
> > > >  MAX_SKB_FRAGS as configured in your system. So use 17 or less frags if you want
> > > >  your app to work everywhere but you can go larger if you control the system.
> > > >
> > > > Any suggestions ?
> > > >
> > > > Also Alexei could you please clarify what you meant by ".. since XSK_DESC_MAX_FRAGS
> > > >  is not guaranteed to be 16." ?
> > >
> > > Maybe it would be better to put this define onto patch 08 so people would
> > > see how it is used and get a feeling of it? Although it has a description
> > > nothing says about it in commit message.
> > >
> > > FWIW i'm voting for option 2, but also Alexei's comment is a bit unclear
> > > to me, would be nice to hear more about it.
> >
> > Meaning that uapi can only have fixed constants.
> > We cannot put *_MAX_FRAGS there, since it's config dependent.

Got it.

> 
> Same here, would prefer option 2. And don't put it in the uapi. That's
> something the users can try to probe maybe?

Yeah now I see no reason to put this in uapi. You can probe
/proc/sys/net/core/max_skb_frags from userspace.

> 

