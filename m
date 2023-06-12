Return-Path: <netdev+bounces-10186-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED31C72CBE7
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 18:55:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A185B280FBF
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994FF18C1D;
	Mon, 12 Jun 2023 16:55:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6F6EA8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 16:55:27 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C2294
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686588926; x=1718124926;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tqtszbc9lWQZvdr1MS1/SQfgsluow0zbNZCTkR32A7g=;
  b=Bx7TLl5hIOrCVYwXww5znW0ZeUYUyjYfIn0UsINzC3pvdBi5LzIpSo3D
   rajMgJ4VVsQvHLnBI4ufjlRG0zweoY0UxeCFgX91tzJaaggVUK8YLtF45
   fTZYyhFBpgYPI/LS0bMRK2pqzZK3/ZAWlRqULZ/7m6yHs/joT6IVEabhs
   vqxqV6dP+ghzgcjBxr6AKCjzioGPu3iNxUIDYNobhxRj9VsdW3SUXyD3p
   HTLOQJ2ol/7r0T2p+8ix8KzIWBGAViBjos0vJa9PZe3dLSb84g2jGT3f4
   njYNZ93ZaY515HA+VG1QyelqJp1IwmsuP/VBGPfE2yUL/dsDDs+6dSDSw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="342786196"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="342786196"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 09:55:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="776464766"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="776464766"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 12 Jun 2023 09:55:25 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 09:55:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 09:55:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 09:55:24 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 09:55:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lim+Kf8cua8tfgINosULxH8r3CafO/HYwABsMSkBg8Fgd8czDa7svyVkLN2pmRHjHkHwRAnH7YsQer4Qb9iEEN+J/o5v4D5muDz3ogeM6fjBLbioLTzDvKIKMWukJSrSuUMrVlO4knGSQF5bRQ9sigXI7p2nPPoCegWCfMnBpoOJyuOiVLnxHm6EvTqHN5Y3hpa34TtKQjjvMOMd5DdB1ZG9OEyGM2BrFfAv2FUdRZN62x0uYvIDO2wbvc+2GmstYMbHxmSEGDLcVjBnlmnnL9Xlds4MJHKq5lC/iCMyglecLlWwSQmoevrsaRFOJPKu/QSrg+yCC2Z7mJ5/1FLOkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfjirIP/URUoKsnh+LNwXflmB+KjSFcUacAGbgBj+I0=;
 b=Gthi1fueg7TNjsxU9B0N5Dtk7lU2CLDZw7y8PDbUIaqlqlvmjA3j+zFIriQnz97FAmBzRgyubG3/vkv+nG/VfWPQ3P/sfPHKP3jM/N7Ia23A0lebaMhZua49WCLPNOXh+jUl/DkmceilJ5c9IYDJ5uaKrGnPlL8Kwur9LtHizd0W4POsNjsOloyP6VhHzaiay572hB2YBJRMolROhleeQGmZGFaIhHkn9rSq2YKE+NTwQFMtNYP/Z7Ed9F7v9UZCp9JLlKUvdDIoDs1FrxH/0P+5oobe4EHcbJ2vZiSA0RFTh9F3UyrsiCOSJYGuYW8QQQUDZo4G23YnZ5BGSdqjSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY5PR11MB6343.namprd11.prod.outlook.com (2603:10b6:930:3c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 16:55:17 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab%5]) with mapi id 15.20.6455.039; Mon, 12 Jun 2023
 16:55:17 +0000
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Jakub Kicinski <kuba@kernel.org>, "davem@davemloft.net"
	<davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "edumazet@google.com"
	<edumazet@google.com>, "pabeni@redhat.com" <pabeni@redhat.com>, "Kubalewski,
 Arkadiusz" <arkadiusz.kubalewski@intel.com>
Subject: RE: [PATCH net-next 1/2] tools: ynl-gen: correct enum policies
Thread-Topic: [PATCH net-next 1/2] tools: ynl-gen: correct enum policies
Thread-Index: AQHZnUcKE+0IEPrT9U2swHSKHxAJYq+HYmeA
Date: Mon, 12 Jun 2023 16:55:17 +0000
Message-ID: <CO1PR11MB50894C8C69D64CD0578CD07AD654A@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230612155920.1787579-1-kuba@kernel.org>
 <20230612155920.1787579-2-kuba@kernel.org>
In-Reply-To: <20230612155920.1787579-2-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|CY5PR11MB6343:EE_
x-ms-office365-filtering-correlation-id: 9633f82b-04b3-4250-773a-08db6b65ccb7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0LULclUzWzgBoONZSRmuFqYI+Z4nHJWlMy9vP1ZAPR4Lpv7BSuVMgNXvwqBwJE8sWwvX0TvdN/JLLIuOe6NWGFeUULZIo1N2oamZ3GBeKNxNSMZqUS1QsOCmxZJpqkKwvTYNPCb+hDbMsOJrgQ0xdPExp/zKLek+thz/AbFe0QYlCh5TMwcvR16+HikJh2Vtc4exByAoLlPA/ftS8IfuqukTap+Bf29i2Kks48eKysCBFQKFKRLeDkRKoT7IYlxjsY+22+tfWow4M+P3VeFVD2oH5zluRaosR9UIW5m/ZVJY0K6qmOx9i+04b2MrVmP7SrK0w+YrHply6A2lBWCGpX4nS4dSJkAga6A4XqBk76ui1JeUo3DKoOndK3yb1kQHLyEAst96Ha6PVyVQuEl7ZDk7twYZQzc0S1b1Jr+c/s6aMaRXJe/7aVEhXYUB5oP8AtJEHlTnbK1KgiONa180OFR2fI94N7c646pyjPAZ0HzuJ0NlJp+OaY2g24BPpdrAJB//x4912D00hs48z8RLMBVa5i+eoFl8UvExQd880PXnGoYLdQccPoXdvMn6niN3Z6gWb3fGLvYKxnRYkt3UFaRN6pOB47HwuAvs2Y0JX60JzlGNNOQc6hO4Rf5Jz3T+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199021)(66556008)(66946007)(4326008)(38070700005)(55016003)(83380400001)(2906002)(9686003)(6506007)(26005)(33656002)(478600001)(54906003)(53546011)(7696005)(110136005)(107886003)(66446008)(71200400001)(8676002)(76116006)(64756008)(8936002)(66476007)(5660300002)(52536014)(41300700001)(316002)(38100700002)(122000001)(82960400001)(86362001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TlSDqGk6EljFyhkPqR+Q++OZN8nZQ04stH1EMssE1MlA7skcHQJaEEU28i7O?=
 =?us-ascii?Q?pln0QnFQlOwlyHSAarcrf6vWMIUwu12eysKmEWwYMemeRrs+HSRzMgYvyKu8?=
 =?us-ascii?Q?5zCKWTLiCggxExagXMu5LK4CJORQgMQ4+hffHOmPXUoCCi8pxWoOg1W0xgPD?=
 =?us-ascii?Q?lh1eJOOkFA8gEFVO4dtWdSB6dbO4zyerCpHVEob6TPJI8zQlDYG3ObazXvx9?=
 =?us-ascii?Q?XdjF9et0wcxpRiWD+et/+yJSW2Eh9DSb43Dp/zJ2VNCixHqp6EQUON1oUbgT?=
 =?us-ascii?Q?X+vxWmB4RZG2E9von2sHDoLFpTpYSNTAdiizmykYVVJI0P8PlxI/KC7IdZSC?=
 =?us-ascii?Q?utbQIyxWv5MtVo/A1ALqvbILuvOPcABpADdzQPE3YzmOMa4lBwCHr4LiJdhw?=
 =?us-ascii?Q?2vr0xHSnWo8aiSmErcd0NnvBzyEd+8afANoV5cFMNXmoJtaiGw9b8fabWGgP?=
 =?us-ascii?Q?nGDHkfKtrEqs2q0vWtBJ6VrwWNyVRLL+yane1wJHBT/7Xsl0DQSHlGFJPiFO?=
 =?us-ascii?Q?VJYMrE2molRGR27NBLlyrpEjN/1hUvKsu3G/eTHNQsa3eyljW/Ik+g+OTPCQ?=
 =?us-ascii?Q?WTHJXKN4NADb6YG7iMlUQAEHEsMo6dw23b/kcC5l9Jf+U/wYGxJW+DdYmpkj?=
 =?us-ascii?Q?1P1XymjfLxFYITAEweYuwpOUFfUCcmGNorWQPGMyduMXc1EJsluqzP05GUDV?=
 =?us-ascii?Q?KKJrkTyrVYHp2zWYwkZXll0+VBMkdps22ieBLZXgM+3Fvt6QM+eP9wdTW9qE?=
 =?us-ascii?Q?agO9SrfCOaQvFQgAgqN9+mR6y0zyR51LlYxpEJNOJlc4wvIH9WgqzO9wbyNX?=
 =?us-ascii?Q?ZwakoCaUwQ+EvtDoxGxemVVEUp0V7V1JW3olxf0oFO68BSfopfAVxmSFFhAe?=
 =?us-ascii?Q?56//FrDEj+N/DOhOu7ea6za+/pph+v4vScfhaOCHK0w02rVHljJhesg9rT8f?=
 =?us-ascii?Q?qGmPd7sQoIRuNpfadXMdkXny8nPomtl8Xq0tirOk6/vVC5u6VBLTNabJSvHL?=
 =?us-ascii?Q?v6ph9kPS5mnTeSqUzbqrC/thNnLeaicuOpomPVAtn4PKvuq4RR7lL5NPI/61?=
 =?us-ascii?Q?Z9H2hyt36pRS9gCH/tREJs3eqDpthBybNRscFw/bTp6oGBocoYQ8gDBBYUas?=
 =?us-ascii?Q?c+2q8RRu0Cn+lFZf4aaFEMOg1za+G6jWl/88sdimBBuUIAsPFeW44FvstrHR?=
 =?us-ascii?Q?kOpHPkqXGjY7gSLJdWTXfMgfXnjKLybvBNkx122LAaUz/xicVMf5cdpIYf2F?=
 =?us-ascii?Q?TDYJmoasUdzTIjPCuvRUcmRcMPlnhnkdAICUbkNj4x72lQMBpPydpeukzWzo?=
 =?us-ascii?Q?vwFwXAsnBVsXtBA3cxtSQWDhE1N8Gko77vTg1hMfyrvmIBB4YVhLIaDc/HEQ?=
 =?us-ascii?Q?xEhwKpiWAmR5e67s0l/2LmDBO/AImXB++KBOQBpsx40HbQqGaNI9zdMMFHfg?=
 =?us-ascii?Q?6UJvha5sArCUIibAU5Asi59zVxLWj6iesADu0kkbpFsn5Fyax+DHoDmpSZOr?=
 =?us-ascii?Q?bemSzYGqqLWYbuvSwEQsuo09w1j6HoEGM6SwCVccwrWTzT/ruFWC7L/GL8DX?=
 =?us-ascii?Q?NehaCqXzFAOFccjwCdrF8zQw6AWSCtLkEVpmNQFw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9633f82b-04b3-4250-773a-08db6b65ccb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 16:55:17.3111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6jB0q+OaJxu96hqeTbWU4hsD10oJozPo/HQMD1QAL2xmsnXlVMAakZ0WdTU4mYLez1ZPFcCgTLjHNtqNkodf/OqhP+3pH+WKo8dxJQ72kyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6343
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, June 12, 2023 8:59 AM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; edumazet@google.com; pabeni@redhat.com;
> Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>; Jakub Kicinski
> <kuba@kernel.org>
> Subject: [PATCH net-next 1/2] tools: ynl-gen: correct enum policies
>=20
> Scalar range validation assumes enums start at 0.
> Teach it to properly calculate the value range.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  tools/net/ynl/ynl-gen-c.py | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
> index 870f98d0e12c..54777d529f5e 100755
> --- a/tools/net/ynl/ynl-gen-c.py
> +++ b/tools/net/ynl/ynl-gen-c.py
> @@ -300,8 +300,10 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr,
> SpecOperation, SpecEnumSet, S
>              return f"NLA_POLICY_MIN({policy}, {self.checks['min']})"
>          elif 'enum' in self.attr:
>              enum =3D self.family.consts[self.attr['enum']]
> -            cnt =3D len(enum['entries'])
> -            return f"NLA_POLICY_MAX({policy}, {cnt - 1})"
> +            low, high =3D enum.value_range()
> +            if low =3D=3D 0:
> +                return f"NLA_POLICY_MAX({policy}, {high})"
> +            return f"NLA_POLICY_RANGE({policy}, {low}, {high})"
>          return super()._attr_policy(policy)
>=20
>      def _attr_typol(self):
> @@ -676,6 +678,15 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr,
> SpecOperation, SpecEnumSet, S
>      def new_entry(self, entry, prev_entry, value_start):
>          return EnumEntry(self, entry, prev_entry, value_start)
>=20
> +    def value_range(self):
> +        low =3D min([x.value for x in self.entries.values()])
> +        high =3D max([x.value for x in self.entries.values()])
> +
> +        if high - low + 1 !=3D len(self.entries):
> +            raise Exception("Can't get value range for a noncontiguous e=
num")
> +

Guessing we don't anticipate any non-contiguous enums so an exception here =
is fine

> +        return low, high
> +
>=20
>  class AttrSet(SpecAttrSet):
>      def __init__(self, family, yaml):
> --
> 2.40.1
>=20


