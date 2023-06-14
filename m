Return-Path: <netdev+bounces-10712-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53D5472FEA5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:28:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ABC12811AB
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78886AD29;
	Wed, 14 Jun 2023 12:28:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655A68F74
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:28:33 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EB31FF0;
	Wed, 14 Jun 2023 05:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686745711; x=1718281711;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PMahPiq/RSK/pyfF+oDFP4SDFIHTsV+7kvcMBVnwMrI=;
  b=XDYb/XKC0acNrItLcktr9nEbJqKqoFknvVQDtDJPuumLT9lv7IVas8r2
   avO5MHd3ozFv+KWrYtxZh7PcMBbmMruIo7HLb/jcyN0jad0vKEG1ouVWq
   ZCHBcLP7O/0PxY6In2CH+QyPDNoG6NyXFoylzfq9aDjrRi4zGnrFHYRzW
   vL2weIcf7to2hfjjvW/8Lfxq6weq1wqJCnjnkXWlkkQ8uMNNYfgxD6BnF
   EqqJh3WdWpu5FmWE9agbCmZ81ACgnAiT1l5OMDboGSyDTncYzAWvdT5Ad
   n/C9ZA8R8ZILlPgDFz1WPwHAjplGMELd4MK9BvWyXloFUoBE8FnZaTneX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="357477602"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="357477602"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 05:28:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="886211587"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="886211587"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 14 Jun 2023 05:28:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 05:28:29 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 05:28:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 05:28:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXOn7+TWlbmY8uulsbqmXKypv1BQF05EIan2sAvGlQGzZRXf7YdzD5An2ui2zm/caVWN4sthU/Te0MiiPu/8pW3yvpWGYS5Wyi1TZwYFy8xRR0roVpyYapnI7c9CK/SgUqjAfj8zM0QfRvj1cg9DnY/74FrTw6gs0OYcArYW8KdQEz4WDBAUPsSG63bx20SNda5fwBgyGLpCCy/ZIczAhD1VDJyqwlR7CdTYI+Wuw0ZDkCCybm7rzQl8Yn3q9XZMwD0NLMHbcYRgLiPCf1QMIzWaiqDvDbpJRuP+poYPA89PaJOsRmhZ2m0tA/D6FiJofPlq6wEIwKuqcbmIbuM0ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMahPiq/RSK/pyfF+oDFP4SDFIHTsV+7kvcMBVnwMrI=;
 b=COHRrbsz8ZV2RySi0pIhFQwt8p5MkoqdrZUmcC43SfQlquZQzTlETn4VbihPHKWu/gDovXax2I8q5eeLBCSfuwsvgWukg66Mhy4IAH1YwihVGZ6XqZOydis6iMS8O6sq0BdNqT1dbfsJGqnltXF5wQjBmmbJtz64DiDnX+4aNZlREh4a4r43FMGu82AccCug+8WTHWhrBnQHOnB8fxc6zbcpSlA5Yilt7nve7b4BGIZ74lLzE1L9FX+Ylf1R279/6832jLXIaHqh1hiHrjqUbBT2KEkJwTlGL4K88fxfBgfpbBwVrsJD+gNmWW10XzWoRzftABsWAJ1JOWlqcFjhew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 CH3PR11MB8140.namprd11.prod.outlook.com (2603:10b6:610:15b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Wed, 14 Jun
 2023 12:28:25 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 12:28:25 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "edumazet@google.com" <edumazet@google.com>,
	"chuck.lever@oracle.com" <chuck.lever@oracle.com>
Subject: RE: [PATCH net-next] tools: ynl-gen: fix nested policy attribute type
Thread-Topic: [PATCH net-next] tools: ynl-gen: fix nested policy attribute
 type
Thread-Index: AQHZnk1/UXRcaWtblku7CYhq2FDxoK+Jd+2AgADChtA=
Date: Wed, 14 Jun 2023 12:28:24 +0000
Message-ID: <DM6PR11MB4657C9D29C67874FC90365EC9B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230613231709.150622-1-arkadiusz.kubalewski@intel.com>
 <20230613175051.32196c59@kernel.org>
In-Reply-To: <20230613175051.32196c59@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|CH3PR11MB8140:EE_
x-ms-office365-filtering-correlation-id: 454af03b-5d6f-468a-f5ac-08db6cd2d971
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kosr8iLZuyNX0BBdOQEvHXM7diENxnXQsh/vqFWVCHwNPS0pjPVvdqJthO3df1wzkitHDpqf/p4nkMwyYykHO2tbQ64/2N/mZiQ/7UGSbKPI3bJ6ONvXsmQm3knvtQFS5BHwpHy/vQ9WVak7pPIKXGdiPCFIyrmx06t55F7rQz7dQJhkgWblIgwgARUybU2eSEMkb+gvp6Oux2Gzbrqy1dZc1FpgjjMHuhYl0uobpgAFBPoIbql3bVwAZVbkR3xwrZ9gTLIDWrmCJsMuqql/7NgJ+k9998SR1ZSj+JCCbd2LkBmsLP069rEXJeA2fvF+Tyre/RuSOpPd9GrTdGDEjCQcKsivBGPz63Ma2XKfwdu+TT68ZZ4kxH/7FGCr1Cc3VxYn9cap02/caeq/8FbySH2upawdRV65Y38DoKCcGuKAtXp7VBdiK4fRhV9dE4TmZeaXC1DdojLeYnb8I8wqihfWRWcCtMjCCthAhnnNPvevoCk4FKd5dnVWZmCUPWMkMZWW3TIzGQcN71FKHV6u9FfeQkArmC9mV9cLW+cFmAYRrg8n6AcZGGTNCs/LEX6pZVJCzVeq7vsk2sHcnctLTHGpGNsn27gLGmF6US9D2Bo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199021)(8676002)(8936002)(52536014)(5660300002)(66476007)(66446008)(6916009)(66556008)(66946007)(64756008)(4326008)(76116006)(316002)(54906003)(2906002)(41300700001)(71200400001)(478600001)(7696005)(122000001)(55016003)(9686003)(186003)(6506007)(33656002)(26005)(82960400001)(86362001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hdpv9bcK3NubXkhfksZLcaORN8M17p7mGFmXehWzYy0gXRyrje8hJC26i3Zm?=
 =?us-ascii?Q?nhTU8962O5I4j6BR9xgvImp7Aq1u02llzlTenYeP3xisJndgf2yzVEaGcHge?=
 =?us-ascii?Q?NidEvDJV2fDJGc7tvg3vrbh9BeTOjgdo21NtUaqwPDeKkXomWbIYyOogNV69?=
 =?us-ascii?Q?vdcPf9zQGjkPV3v1u6Y59+sJZ9/uP4pucxbwN3tFDnhsU2L9LaTp3fQ+eSFU?=
 =?us-ascii?Q?nZhX342DADs7kM/IsHylvYw/32tGq/B6TdbOHZMHOzb4IPEQCNs4ZoOyCZF0?=
 =?us-ascii?Q?+dqRJqZ2sGXL2bu5HsQ81hwAd520ErKdewYmc3OVNQSvg2XAOGjC03ufMSSN?=
 =?us-ascii?Q?SWcFg3lb8mr197DhPs/S28gNhJnMsvBYX0e4VM9polBGpsL+A8TSmu8BC8Q+?=
 =?us-ascii?Q?zAA5sdrkQ5xAt6R3dN6PSmxxlDQ84CI+CS4Zl5NVOI28vE6SLINwa3eT9PSB?=
 =?us-ascii?Q?FYm1T5a+fT4SlFocjxVyLCenHbHherCIlAhB6uXU7LgpszE0jOYlr3FjHj2M?=
 =?us-ascii?Q?MC4uJMy9GCywtbX3vZWSF1/BcRZWkuoS+bjUmJVp0+RTcwWifv37OcEFTQtX?=
 =?us-ascii?Q?KcfiYHlXoOppSBtQqfOiK4bXyXFfRAG47fzavdMlm7KDP33UUq/uZFKXgYBO?=
 =?us-ascii?Q?BiNJ0p7gy65/74LXxBVosroFFkaUWU4+15E7IWbmqNDUctYwb1IRffwP26/5?=
 =?us-ascii?Q?1fuZssJMVGSVrg8NwJqPe1NHpFGqs7XQifrBHPgV6WiMLYLHEZvJAtq7LMYG?=
 =?us-ascii?Q?HnImBZ9lvx7k9DTduuHa1zUaluyhMwxC1ie+AzKcSPtPWzfOcrSG1ZNdIY1Z?=
 =?us-ascii?Q?ZHwHfbMVSjdRmDCnZ1ajGLuC4P9H1oHD5PKCxCG4R8bqs5Z6Dm+vtemYFVH+?=
 =?us-ascii?Q?ipd5XxsfW94MnR582gLj4RHTSqcQDu0LzIDRbSvA5rxTxJN1DfgnYUxEPxAM?=
 =?us-ascii?Q?+Gz8lU+VTKPbV1A+oK/Xj272tWSgicNCcSIlgN3Dr1JX+I6IpPnRHoEHVCBs?=
 =?us-ascii?Q?YXxWJQ0Me4aGipbE8UXRn7dN/6krGRLFzlAWaEr0UiCMHS1DeeUIpsyEf+vV?=
 =?us-ascii?Q?48AxZxT1+uyW5+ZOAZitTY9CaGyZRvPd6FQvQeXuySsa2s9uZp/R2qYiXwSl?=
 =?us-ascii?Q?imu9BZXh5MXjMXGSfmqtTDXKl3qGxkQXpTMkTfxuZAfu3GExGt7I/AELEIIF?=
 =?us-ascii?Q?+Q4DO5MqGPpo77jU2YfTyfsJIXeF8JdvMiB1qqWYo4QnLGGFY9d1hFGng+UG?=
 =?us-ascii?Q?m9i2owxiM6m91r75DwiruoYKvlyQjZdyIz0iZjhq5dMu62gzaWp2fC/jCBAZ?=
 =?us-ascii?Q?f/GnEy89M23yAKRi4I6xocPkfUayogmU6xAf0ekDfX9REkw3oTr4lLG6UVn/?=
 =?us-ascii?Q?5023KB2IqlVPSDNgt71gcHmGBJf83qZgY3B8GPj3CvhiFzbi6baARlc43Soj?=
 =?us-ascii?Q?bJtSSPW+Ma5/ipQHx1XDyviwsB4Yt6rctf/70SJ3uPy1jdNaBFAY39uugA6W?=
 =?us-ascii?Q?yEWqt9q+bxib92wSqL1E5fyOojIc9jAdnMB7x73OFAtEzy8KqaMCEGlQWQ0/?=
 =?us-ascii?Q?8Pre0KFKP+2S1mR5Fgx9c/scse8lZDWVkyf8JffOAjaOkGyfyIiO+q0k7dp/?=
 =?us-ascii?Q?XQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 454af03b-5d6f-468a-f5ac-08db6cd2d971
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 12:28:24.9711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lrvnG8boQ7JZD/nCv0Kx4N+6714iEprXivTEbv5vEVoR4IiFDuhSYaY9qI431Hpdm1lpOaZc+sPgH3EBrvnSw3eXK+kB7jrTIlHp78Ki5f8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8140
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Wednesday, June 14, 2023 2:51 AM
>To: Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>
>Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>davem@davemloft.net; pabeni@redhat.com; edumazet@google.com;
>chuck.lever@oracle.com
>Subject: Re: [PATCH net-next] tools: ynl-gen: fix nested policy attribute
>type
>
>On Wed, 14 Jun 2023 01:17:07 +0200 Arkadiusz Kubalewski wrote:
>> When nested multi-attribute is used in yaml spec, generated type in
>> the netlink policy is NLA_NEST, which is wrong as there is no such type.
>> Fix be adding `ed` sufix for policy generated for 'nest' type attribute
>> when the attribute is parsed as TypeMultiAttr class.
>
>I CCed you on my changes which address the same issue, they have
>already been merged:
>
>https://lore.kernel.org/all/20230612155920.1787579-1-kuba@kernel.org/
>
>I think that covers the first two patches. What am I missing? :S

Yep, sorry I missed them.
Did rebase and it seems your changes are great, everything works,
please drop this patch.

Thank you!
Arkadiusz

