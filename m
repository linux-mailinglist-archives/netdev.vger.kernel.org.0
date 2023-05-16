Return-Path: <netdev+bounces-2982-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7EC704D95
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:16:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB428281629
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 027A424EBF;
	Tue, 16 May 2023 12:16:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71AA24EA6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:16:00 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDACFFA;
	Tue, 16 May 2023 05:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684239358; x=1715775358;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0eVWaBQtn79Ddp9/7zqrwtCa85gGLWM+uFF6qfuCBHU=;
  b=Ak6YuViU1ILwaQF9uPc42NoVoR9e7ViMxpPbzi86w7LX7JIrdJxlmEKO
   NF8X/CJZEFhKpsxzso0GCPHD6dyF3NM7AF4Rps+IuG82lQh/82CA9ZNPa
   0088+0iR7lzBPg64VOuKS5Av5fNBlHqiK3WF494DuOqdiWBbftmQND/ub
   lrplhW7qLU2GtK18fiy9+Vfzhgu2qojlOSOtI09/f1QTILWg9WQMKd2tW
   wom/WXAZSR0XnBuWYsJhE53udRl0zQstfmt83Ao59cdpIEyOLPtTBEbJn
   U4N432FcqNT83LhvC0/PuGmLC7q51GShqDbwTp5QaGKVObWQE/JB143bh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="336005243"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="336005243"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 05:15:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="813405396"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="813405396"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 16 May 2023 05:15:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 05:15:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 05:15:56 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 05:15:56 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 05:15:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flp8PNMWZe7kvcWHxBdLnWO6YZYtP9/5g4cxBy6FLz8EsTTu97j3OfvsOEsNjw1fGW5LoWtM6BIyEX8/5gRxEfCaeyZC/aFhfeqFw2g9W2GainKioxpK1kkv8oHM7H1yArbI3z1o4JM9VvrrstwVj3wNDzkCK3Rmi/I+NrBoH3kecIGuQNtZXvsGUokptpU861zWrrCjaq4qA/87omXH/pZXo7m2KmqgHxzYu+dfcjHpR7WruEf/6OYWcbrTAZHtKU9D8E937q0YJMs+zZTIZehBKzNY5YAzov6IJLMhSf7K/RWyrHsOuVwmQuHpU7nyHgLWMpdSYVd6Cdla9bZs2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hc4/RNdHP0AzgM3cHd54VccJSu3r88Fm+en5C20FNrw=;
 b=UCdbpsQkCWj4lRF//bGdmwmOq6aOfISQrRq5Cqi5BeMScpSTVszGgESdPeNdeS9eT/e0iyMAWEZt1nndJwUj8qJm60hXo285u4w3+9fAcyFkGtuOA0K8TMnXibizikriA4ShLJkSENvghSpliSDdNMXhBEw/ueqmJFwtAGf/HYY/oTCITjci04sI3AJq7CsWGDffB326lUN+Jefcm6mcBLe6Xk4HxN74Mz6WAeACSZ5WR49ZJ5hACbcLaNelt0FsJCbl8t1kMI9PU1PUzZy8mIvH8vI5McKxSUhy2ok1oTqEJvij14IKGJGhDP60kCDDpclCkbar55dOBtwsvez4Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM4PR11MB6168.namprd11.prod.outlook.com (2603:10b6:8:ab::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.33; Tue, 16 May 2023 12:15:53 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%5]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 12:15:53 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Vadim Fedorenko <vadfed@meta.com>, Jiri Pirko <jiri@resnulli.us>,
	"Jonathan Lemon" <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>, "Michalik, Michal"
	<michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZeWdNus9yie+T1ke/i4FdVA4f5K9KDcsAgACdH4CAChnlwIAAgLyAgAA0FNCAAFRrAIAG+76g
Date: Tue, 16 May 2023 12:15:53 +0000
Message-ID: <DM6PR11MB4657499C8AA3DDB87AAB16AD9B799@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
	<20230428002009.2948020-2-vadfed@meta.com>	<ZFOe1sMFtAOwSXuO@nanopsycho>
	<20230504142451.4828bbb5@kernel.org>
	<MN2PR11MB46645511A6C93F5C98A8A66F9B749@MN2PR11MB4664.namprd11.prod.outlook.com>
	<20230511082053.7d2e57e3@kernel.org>
	<DM6PR11MB4657EF0A57977C56264BC7A99B749@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20230511162926.009994bb@kernel.org>
In-Reply-To: <20230511162926.009994bb@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DM4PR11MB6168:EE_
x-ms-office365-filtering-correlation-id: 75e09df6-d335-4b42-a13f-08db56074b83
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OOv031ukjyYFMRfiQkncYQFpUovFnP9I9jaxqLhMU9z+FOv/KvqWTqOQfmmZKf9do5XBIMFcwxfXo76YJgBioCJD9Ys6VHddCI66Hb0VcBQiQf5i7YwT1NpmBjrxo0xLxs5VuAvlEzbLGFvKRkoQVYEiOI1FNp92Ol+GpP+8kq4gSXkOTD1anuiKK42vxgW32n/1xGOKE+aUxYibFEZgrlHsqwBhVCRa6KSJ1RQF7rkv8z+CbOz5GGMB+OHhCqJwqu42zCaPAMZqyuSVU5qXpjpf3TU2FN2EApacLtJq18ADVtjLS/2HDul07W/GZdXF1qQbpyd7TVk/+642PteWCowbxpixWC6yqVArC4AjRYLWqUtskyKVWQMntbF7uQhuqdoFEuoelPOMZp/T33uaI2GMy+sxOrxiyuiPEgLZ5G/mJPXMp1/TprY6nx5iC0ErrYAAsDE6ueGdyi90JEU7zQ23OZq/DwUE485wRRF4H82kl9jNZX67GqWfeq5vTwIPCQHuV6VGa3Hl90DVuhrLDxMa5vpRlwlmEUUheBaIxMwKP2TXj4C2vYPXr5F091hW/K4Bx7wcSQkf4cwWzPrVrdi3rrMrn4w4p2WS28/g3p0t+ua8rpMNrEzz0+S380j+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199021)(8676002)(7416002)(8936002)(316002)(6916009)(52536014)(4326008)(5660300002)(122000001)(55016003)(38100700002)(71200400001)(2906002)(41300700001)(478600001)(82960400001)(38070700005)(7696005)(54906003)(66946007)(26005)(186003)(64756008)(66556008)(33656002)(66476007)(66446008)(83380400001)(9686003)(6506007)(76116006)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7O6mlkj15Ba5XdPW0bJi1I8AhIaU5ANT8dkdoDXBxiJ5x9GT4KCFGmRLWHNm?=
 =?us-ascii?Q?j/P4SqnjBTMVSmJpxRiJdC209ggH2lD6PdzUXaCy0nZcMxAS4sNQ6ahNRuyX?=
 =?us-ascii?Q?V9DQAYUHw4Iqu3yS4sDd39I7CyOgjCYt143DfmAsS7vpkxtLc2Cppev2tgYN?=
 =?us-ascii?Q?iw7RIzTf7qVotqGewXZu8cNpntIBmHfzMGgKXtzqOCKneaM65byFmBGLN1zB?=
 =?us-ascii?Q?Sb/io+OJ72JTTvO2yGZ8dV/lxNxGyuanuV4zw4gEE6LW7rGSVa5746lCN+nt?=
 =?us-ascii?Q?OasgcU1TvJw87HivpZFmt4CzVUumwRrHl/pfjLg4EZBNBUK0nJgRKKSmVJlF?=
 =?us-ascii?Q?Bq9aBYmjedP5KMnkVSZClTRV6wMESFjev0x3CZsV/7rsKc82Z6tjQFiEvsio?=
 =?us-ascii?Q?R6FKzq4/1Ks3rqBJYoygIFRt2LP8I9bxRnIljMXZCyG8MD8xBBGd9ZoIyaNz?=
 =?us-ascii?Q?w5YqfdlG2gGx2WzzOlmHNRKR8rJIWd4DngoE0fJQShZ1iZQkRzbAQx1/R/nY?=
 =?us-ascii?Q?lhQBSRKAOelw7SA1jCNsouBKGc0lq4wMim/qScK/7uKgITDfDv/HxO/dyWaT?=
 =?us-ascii?Q?CdVWo+V/2Fw8ttzEEgh2L/74cmYWLGYXHvYsTUtgPwbDHwyyM54NBLdYmNlq?=
 =?us-ascii?Q?nfJeutSbBQJe6XrocxK7ada1L9ixzJD/JcfAwb3/WqJImQUODPMx4Wk/sILW?=
 =?us-ascii?Q?nIr2Ba0gRvgIpq/+kRF7ZsSamFA0gYT7NgFixgFm8Y4mV2WVBFNcwkhPMceg?=
 =?us-ascii?Q?Go6zE+vTpDO+3F4SataMzHn+sPAVmnovUgXGKt+nBYls9AwN2QyYHABxK2d1?=
 =?us-ascii?Q?yWgBv62LaMbe+SK40I8EDyk6o/Z6zShtfNGxy4kMVWPK+4GDY2asA1RNWAdv?=
 =?us-ascii?Q?Ge5T3fIr5Z8BBQ7kk+LgJEtVrGqDHePLVUb2eyQbj6VL6JBLPVzkR91Qgtqr?=
 =?us-ascii?Q?BfUYk4cF16LKSL4J35NH6+Q7EKFp1rUFxyG0pBO2bNC1xinxQGGC+7HIDjsz?=
 =?us-ascii?Q?olsTMr0G3KN4hHjjgsZxv6Op1k1R58rq/LDq6vX9C09bzgxOs2ydX/ere41T?=
 =?us-ascii?Q?oKU1JLeWwNCanYqR/6h3qdfIgJ4Gn5yFtwsUDhm4hKqNw/ybrx8+nVtqcqQQ?=
 =?us-ascii?Q?5bk8ILYqaFxtsb4VWPGR09NY1OzJKONGXy1YGb9zS5Ldwqd3mYsDldxvlKRL?=
 =?us-ascii?Q?r20r3Ibmz4agw/5fcf3J8sFBC5/dRQ3s2SaWKX/SAE96bEzYKekTE9P1p5S1?=
 =?us-ascii?Q?S34lkrEAeTr5c8j6NMzbxzyKqiRzX+J/5Y4m42GwcYrzQPeTh3Ig2rRyVF3J?=
 =?us-ascii?Q?196E9YzADMIZL0+TAW2qivocZzsgG0Ui5GaruXXmZS2c6IUxrxOMPgfUZTl1?=
 =?us-ascii?Q?6Gd9LgfDSVI8ieCqens397ykj6npDfX9gysvIquyYx5Q9t66AzS7m4Lxzagl?=
 =?us-ascii?Q?Bcb8j8RGusxidfUkqbyLp7xgAE3gRRp/uP8OI3afUTaajnu/gnh0MROrgTzk?=
 =?us-ascii?Q?CiyFkqvK4fgZR6XH3vr65TLMR70u8TsibSBAGCZQZCXzXZsHOkPvjRzPJvYc?=
 =?us-ascii?Q?ggVNW2yNyUSmSz62Z66iTW7pBcq/s9nOQfQSmxjlc1TdOS7X7exAOE4PyodL?=
 =?us-ascii?Q?PA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e09df6-d335-4b42-a13f-08db56074b83
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2023 12:15:53.4637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YrF7+fOFJrzonzo7lfKys06eovKEnrLZSoY+7U2aqot5rq4uV18jtb/IHfTZRnV5DeEowstgCAUbIvpRQcSUngS24etq5vTOnj5C4Pr4HPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6168
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Friday, May 12, 2023 1:29 AM
>
>On Thu, 11 May 2023 20:53:40 +0000 Kubalewski, Arkadiusz wrote:
>> >Because I think that'd be done by an NCO, no?
>>
>> From docs I can also see that chip has additional designated dpll for NC=
O
>>mode,
>> and this statement:
>> "Numerically controlled oscillator (NCO) behavior allows system software
>>to steer
>> DPLL frequency or synthesizer frequency with resolution better than 0.00=
5
>>ppt."
>>
>> I am certainly not an expert on this, but seems like the NCO mode for
>this chip
>> is better than FREERUN, since signal produced on output is somehow highe=
r
>quality.
>
>Herm, this seems complicated. Do you have a use case for this?
>Maybe we can skip it :D
>

True!
Actually yeah, I agree let's skip it, we don't have implemented example and
there is no need for it for now, we will have to discuss it someday if some=
one
want to give control over it to the user, and as Jiri already pointed, prob=
ably
it could be done with using internal oscillator type of pin and just
configurable frequency.

Thus I will remove the NCO from the dpll modes.

>My reading of the quote is that there is an NCO which SW can control
>precisely. But that does not answer the questions:
> - is the NCO driven by system clock=20

Yes it is, other part of documentation lead to this conclusion.

> or can it be used in locked mode?

There is also a behavior called "NCO-hybrid", and as I understand works
somehow as you described, dpll can lock to something but additional offset
based on so called "System Clock Input (Jitter Reference)" pin is applied
to the signal (the pin is also used for normal NCO mode).

> - what is the "system software"? FW which based on temperature
>   information, and whatever else compensates drift of system clock?
>   or there are exposed registers to control the NCO?

The synchronizer chip firmware provides the knobs in form of registers to
control frequency offset for all the outputs, as well as for dpll's
frequency offset.

Thank you,
Arkadiusz


