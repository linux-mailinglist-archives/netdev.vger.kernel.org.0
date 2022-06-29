Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C37B55F976
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbiF2HpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 03:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbiF2Hoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 03:44:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B226D3701C
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 00:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656488693; x=1688024693;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xi+bYUiZQUFl5/kzHDv8qjXE5MFrJEo80XL7aKoFIBw=;
  b=Hv84fTxAa+x5ffVaXXPutxLZhAJp8z+yPSweucEP3KliR6/K5JOpCkN9
   7NlgrDDNs/0PAd0lnhf92jpwBW+QAtZONm3PN5ZuTjl2A1p/Duafwe35z
   HyWBR6sXheU++H+sittVuB75YGmpBaryOh7dFCMsVyD3e48j4AFnubzuA
   xBxkQFMSUl+SHu9pTMXlEH4SkVtCutpVaYbILwQ1DbDAR0pq6yE1anDNr
   04geSp08icXNqNyTBY/AJy8GDS/OPKIFsDUIHlajtvCXBjtMlOincmxvj
   iVeKpZr2KQnDjLjP2K1mL8V/Olmh3o1seR2ee38/tjOHgJzPVTe2KES7S
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="343643571"
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="343643571"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 00:44:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="658453921"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jun 2022 00:44:52 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 29 Jun 2022 00:44:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 29 Jun 2022 00:44:52 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 29 Jun 2022 00:44:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3zI4u7wZmMtzsajEDRCncaIoUGncJfpzmEDEPjS/NTXp6baSV/oAiB5j4h8945iGpNzk1Po3x6BvQms6cwHM0H9udnWNyZjVfJSHmy/TBP6vGYJdlincmw+e4wnutK1TjcIBgstUZC24Qz9MrjYkQ9NziB6rc3/QCOH+zz4elN4ywbzYL5eVTIGR0sUQj1DmygN7XlYicQ8RpcdvFShlhPxJ8yH5ubTy47r9rnI5oKBrxCp+YIHG4CTD1FAIoLFdYQ5QtSl5l5VqhB2CK5nUAxfdWlguKlVs97DcS0lGvVVjv6RPeMZNs8lzYHagC32P8VhyB+1Ir2bWqMetbC3Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pbB0SfDDApHxYPB9IyAVHZTjgR/bGLek6pvtOMo8twU=;
 b=OEaK9DzOFzy5Habt8PNfc+lfANn92rLKfdqQJQkkIUNnadStuxJ3hsElEC3lTkg1KnNN3FWSbLifKnO1avzAEM1+8AYhCWITzWSiibotdZY5b/EtLOAc/WjZZzR/Fdca24rUYn6lHyxV5Hnr5b/CLNuyZoCz7LhOippI0VY4J0JqKz1vi1h0KVqxslg8r8JkigwNCmid1YBroX01Eh5386ZakDbWOeMqCPoPMHGPX98CavHm87YKPJvPLvfl0FUxMcKcpt8ZlPJRXsZewfL+zM/YpNMhDPa//yDqfIkbsQmwECskIgfLqa73jtP2KB0JJeNbxBDiKuQWqCQcqNPr3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by BYAPR11MB3589.namprd11.prod.outlook.com (2603:10b6:a03:b3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 07:44:50 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c%3]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 07:44:50 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Marcin Szycik <marcin.szycik@linux.intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "boris.sukholitko@broadcom.com" <boris.sukholitko@broadcom.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "paulb@nvidia.com" <paulb@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "komachi.yoshiki@gmail.com" <komachi.yoshiki@gmail.com>,
        "zhangkaiheb@126.com" <zhangkaiheb@126.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>
Subject: RE: [RFC PATCH net-next v2 1/4] flow_dissector: Add PPPoE dissectors
Thread-Topic: [RFC PATCH net-next v2 1/4] flow_dissector: Add PPPoE dissectors
Thread-Index: AQHYiuJgPy2R/ctN5UOlVmjbud8j6a1lzugAgAAwpUA=
Date:   Wed, 29 Jun 2022 07:44:50 +0000
Message-ID: <MW4PR11MB57761A084A3A556F4070F8CDFDBB9@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220628112918.11296-1-marcin.szycik@linux.intel.com>
        <20220628112918.11296-2-marcin.szycik@linux.intel.com>
 <20220628214020.0f83fc21@kernel.org>
In-Reply-To: <20220628214020.0f83fc21@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57365633-ef76-433e-75c5-08da59a33f51
x-ms-traffictypediagnostic: BYAPR11MB3589:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uR2HSJV+6JoYyb0i5f73kvDNXhW5DmUa7Ew+J4YBeONujoOlM3rwW4FGWV2+X2/aO14CxmcUCHKx1aGtYjXsTxyMRfm5G4Xb7rPGmaZTnk271IBXEbddqKVOmqq3Cyo5eoNyENeo//OlX4Jtsr4FG1jfaiQjb5x4h2RDv3ZaBjV3XqEuG95IisNQt1i07uB5zK6kyMiOXzU8CaiM+6XzNZwMlqdwEyUG9IfHFvBuuC4kdhQydzPbHlyToCA3UkWpWCokUrMz4O9+4hBF0/Iv1vcvDgGmpWGjH2B6FGo5bsDfVnvtLux+hTr0C+ehpPEu2SQpxPLO7XGWcxLHRprX2NNlAou6DR4FrCezc1Ma3NoN5dt2POq1M8mHipYnEASfO8lIha98+oWppAZsNqc7qoOIUh20oqry8RrlmTdim213UYg5YvSUX7ClK3+j+LYWKdDunwhmKEKZUhpDW5PiExT8f74PeBUOKga2wxEcTXuHBxbuF/UWjVDAiJHmw0dhgY8s1XGGqwGd+/wZvahkXXDES06N3b7fzLxy469fhKp4csmKPmKJEVQFk0p1yi/G7LDQrogWJjNFas0mFQiH4Mi4lGgbneDCB29uGRHsG861wp4o1/dWZGebEZw1rhATTWWy0nLP1ttULCtX/FG1CHDoJTNC7exYQ5anGfObF8oVyW0ChwMLqA6NyU9vGh1ZULVysfrR/vOtHJXAy8P7++FL2qKMfwiK4EZ337ETQuPM3uxxPhTzmDpNZBdpBaPtZADGxv6XywhQ+972s8eIOCRGfb55MiIqD1zmWYKfUXc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(136003)(39860400002)(376002)(186003)(66946007)(8676002)(41300700001)(6506007)(7696005)(83380400001)(8936002)(53546011)(54906003)(26005)(82960400001)(38070700005)(64756008)(122000001)(66476007)(33656002)(5660300002)(38100700002)(4326008)(7416002)(9686003)(66446008)(86362001)(71200400001)(316002)(2906002)(110136005)(76116006)(52536014)(66556008)(55016003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?ltjt9TMDhw5XR7bnqOl5eroaXvip+hsnqzSTc8PqRza7rEvass5rjt0wEu?=
 =?iso-8859-2?Q?T8AEZVHuz/hzLiUBPrtNqdEfAhTJPkv1BAZOjYv9fA3k3NnglSfZKNe5iV?=
 =?iso-8859-2?Q?ckm9taeeVBVBX6VJx2fmfCVYuyOoJnIQiWiMuQ7kdvWYz8rxdev/OCSuUo?=
 =?iso-8859-2?Q?p7yxMtYlF/pdfGMH9tECnVdEnslM6noh9vKRqJBt4O0gEuwa1/euDVJe9I?=
 =?iso-8859-2?Q?DCsBH/WRkm0buK46xGEc30/k1aoiNPFpLsJR8oOzsk8/x1n+CAFaBZZrLE?=
 =?iso-8859-2?Q?R2f388xScEcM9sVdsDqjtbgFDrxx1nbbg9uvok/SvrjntuwUe4Vm4xChIJ?=
 =?iso-8859-2?Q?5yVnbYaCGz1/1z1CqqCWlkxdXbQbtk//a7+3iNb3J+Xg0endhEE0hM1q26?=
 =?iso-8859-2?Q?Eo8vNevDnek2t4pApW2oJ47zwtM5wLiQqwsSDvvnQwTpPbXuOGJOWLEzp4?=
 =?iso-8859-2?Q?bvFC87ml3I6ONlsYOOObURn1E2rQ/P9f3G6uaRXijSaTNsOgRTHrDxq8rJ?=
 =?iso-8859-2?Q?+pZ6gEUGlWv6fsfHWr4XqKSnx2oh5D+tVsJpc+KK1+etDbiZdN+aahp3dM?=
 =?iso-8859-2?Q?A9bdsGNX13AyDHh479gIPh0roE0JNvDYE6a6IuFH3kqvMk70PMNeqcd2c1?=
 =?iso-8859-2?Q?oNZF7OosxiUfu3FbZ/0u5yu/YbMc8zE0tLgSuff7i9jh8VgebsI5dcebND?=
 =?iso-8859-2?Q?8h1lTVEhBaSRmBDYOiwuZM49H+UHq+dmYaSkpkXRX08u7G69GJ2WAGKm5e?=
 =?iso-8859-2?Q?16lYi5VAcv1FQEXvS1/+s9k6LzfbxpOqzrQgsBebYIjIJ33qQ+BoxZsFkp?=
 =?iso-8859-2?Q?ADZKdaVBtyhwsdQjzMllK21MEiqL+9m+KA+UKCxzn1zh3T/K+FlTK4yjO8?=
 =?iso-8859-2?Q?M/PNHcMJhOVMBDw3dV+nbvRQt9okExPbNSnqaUGozIjSOrA26HttTWy9s/?=
 =?iso-8859-2?Q?14EQ2o++Fwr/ameA04xa5nZBMHEyHfRopeoVgD4NaEQ7Sm8/vRhEyWoyn/?=
 =?iso-8859-2?Q?NcRlQ7bW38JhFeZY2cM5ISpzVhYlqbwm51YOBxmw/XBflyZih1CEhUxRT3?=
 =?iso-8859-2?Q?bHDw+4PLiMaW4HkYxlwpVwZ8FnRJ0HIXf+NmOXr7WjYt/9TmfzHpEkC3CM?=
 =?iso-8859-2?Q?6tll5zLHOzQjJ0vCg5V8YTRFd7CBI5MwDINzTGEB+Q4n2j+TRh0AXCHCny?=
 =?iso-8859-2?Q?j3EYscE/NtkF+TZ3YrzWIb3yDEnxty8KHwi7qwY76Xx57ypbUhCPTdXDYp?=
 =?iso-8859-2?Q?bBycf8ySO9aB+04QGesZ8k1B8oEYTjMGo1WsgrByhApnUwd7RfmKSkzNxu?=
 =?iso-8859-2?Q?a+OeSSkqhfpEBGtb+XJLwmG2QV9cP7ydgbpTkgiBlrP+/DVAebdYHIPX2s?=
 =?iso-8859-2?Q?dGhGwXlehKJtH19ae41gwOmf5MWCMTwdtSaA5JP/Be9NC++EsxFZw0hl0E?=
 =?iso-8859-2?Q?tJrFLOveRGp4Z/z/8a+78bJ2JN8k2lz8UF3H9C1r6G7hzfPoz2PQ8hPX2d?=
 =?iso-8859-2?Q?vU2Cz0vLhP+9HGCA04ruIDdBCgCfeyQQy+rAVK3X5J0iRzJw3eFGTzlrBz?=
 =?iso-8859-2?Q?yyWV0ap1DS9LUVLy0bEvvdNisngu1NIIkaYW7g9rd5/Y3BclStRWgvGHz0?=
 =?iso-8859-2?Q?LQGmU5wbbtwBiIgaZnr0BkZDOsSJ4LRRTH?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57365633-ef76-433e-75c5-08da59a33f51
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 07:44:50.3034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /5RIk5PnyLDa3F7GsbF/F+7J1ESA9tlh7fPq+Tx3G+sUDM3QxjpG7o199Nv17NhrKYSuNZoL98hzpqbB/G3HTvmzJQB8y3bxPo+RM7dNIzQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3589
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: =B6roda, 29 czerwca 2022 06:40
> To: Marcin Szycik <marcin.szycik@linux.intel.com>
> Cc: netdev@vger.kernel.org; Nguyen, Anthony L <anthony.l.nguyen@intel.com=
>; davem@davemloft.net;
> xiyou.wangcong@gmail.com; Brandeburg, Jesse <jesse.brandeburg@intel.com>;=
 gustavoars@kernel.org;
> baowen.zheng@corigine.com; boris.sukholitko@broadcom.com; edumazet@google=
.com; jhs@mojatatu.com; jiri@resnulli.us;
> kurt@linutronix.de; pablo@netfilter.org; pabeni@redhat.com; paulb@nvidia.=
com; simon.horman@corigine.com;
> komachi.yoshiki@gmail.com; zhangkaiheb@126.com; intel-wired-lan@lists.osu=
osl.org; michal.swiatkowski@linux.intel.com; Drewek,
> Wojciech <wojciech.drewek@intel.com>; Lobakin, Alexandr <alexandr.lobakin=
@intel.com>
> Subject: Re: [RFC PATCH net-next v2 1/4] flow_dissector: Add PPPoE dissec=
tors
>=20
> On Tue, 28 Jun 2022 13:29:15 +0200 Marcin Szycik wrote:
> > +static bool is_ppp_proto_supported(__be16 proto)
>=20
> What does supported mean in this context?

It means that only those protocols are going to be dissected.

>=20
> > +{
> > +	switch (ntohs(proto)) {
> > +	case PPP_AT:
>=20
> Byte swap on the constant.

Sure, it will be included in v3

>=20
> > +	case PPP_IPX:
> > +	case PPP_VJC_COMP:
> > +	case PPP_VJC_UNCOMP:
> > +	case PPP_MP:
> > +	case PPP_COMPFRAG:
> > +	case PPP_COMP:
> > +	case PPP_MPLS_UC:
> > +	case PPP_MPLS_MC:
> > +	case PPP_IPCP:
> > +	case PPP_ATCP:
> > +	case PPP_IPXCP:
> > +	case PPP_IPV6CP:
> > +	case PPP_CCPFRAG:
> > +	case PPP_MPLSCP:
> > +	case PPP_LCP:
> > +	case PPP_PAP:
> > +	case PPP_LQR:
> > +	case PPP_CHAP:
> > +	case PPP_CBCP:
> > +		return true;
> > +	default:
> > +		return false;
> > +	}
> > +}
