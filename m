Return-Path: <netdev+bounces-4137-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B05AB70B3F1
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 05:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F4701C2099B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 03:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5645CEBD;
	Mon, 22 May 2023 03:56:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4478EEA8
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 03:56:46 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD71BE
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 20:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684727804; x=1716263804;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qweljOWKuY9p//IGtc5PCAI2ier/R6MrrcJ38ODJ0kM=;
  b=n6bk3uXJn513pbaOkzxsE1kTMB2YQj/5BzL8LnikFteNL5ZLFRQZAK54
   A2Kl3bPn/T/JkfpgvoL9EbAdpGdiJ0R/35dZ4FnWtso/8QkL/VEtZ5oOt
   mhQklRioRbsczN+8FWOFnjHpfVyXLih6AbWnMtrMTw2LQlHK+OeC3x6O9
   OhyQYjzMDxmCe+4xi/xT5acuKKX6Ahr3o8Ms2cLB8PAmXn+det04JzAKK
   SKuBJFB0rDmY3/hKVMLqQWGgctzhBFQ3QqgxzirglKoaAR/YJArZZW0Wi
   5mncS5n2PCa0Cl98UcTdGXb5q9SA1wtzMWMimffdMTusxYXraRt4daNFc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="332425852"
X-IronPort-AV: E=Sophos;i="6.00,183,1681196400"; 
   d="scan'208";a="332425852"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2023 20:56:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="734095738"
X-IronPort-AV: E=Sophos;i="6.00,183,1681196400"; 
   d="scan'208";a="734095738"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 21 May 2023 20:56:40 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 21 May 2023 20:56:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 21 May 2023 20:56:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 21 May 2023 20:56:39 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 21 May 2023 20:56:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvXYNYeY9KV3vRXi/wcGW61WJEz4B47dBwdU/WumjLs25jMh4Ww0pu9QV/z+E9xQ58xC2uGN2rQNfiW76qt9yVXa2VGDqbKGbwf1mi6yNtWyiXVqvDrHNeTkDzI2V0mW10+R4WAOzzTbP+0XIyREmToJypvCzKHPu9wNcbHqbKmshTKYlrbB+kfXaj1GRLZZEPZ+RGvwYRGGnJDg1wGvGwWkRROQHypgTH05TfE02j+hbOo4BDegUNnWvUE7eWgrdAw3+GSq3gzZMopaNeWBH7xQ5sUYcZ2CUPsv1+BWcjY/Wvzrdr9uiLWeYGIxiOlvz7s7W7pkK+MhySOJtROK/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qweljOWKuY9p//IGtc5PCAI2ier/R6MrrcJ38ODJ0kM=;
 b=OdyOXAvF9Cb+aVgaPNfQVhFNJRPfjvYTyPi20gUaYGilAzWrYp3EU0Cn/BJy1gttwww4pT19tZqXDkdUB8zj/IFFgaAlaghgfTlJK8m8cNxpq8hrpZeIEKsEPVH0wxgHOTRoF1TirLVu9o1xgMCIfhLJSOhfk9VofA21vetgvvpjOPY53GVQwQa+5c2eZy/siBAmxWPZ3QYN4SNMDq33UXfiuLZQDRswCT4qIsmFE9NjzkZb4CfqDJf2pQ+xuciHxCLWzh/CoWOsonjFvxMZzGtC2i8ANzN3rXNlCgIxvJ2qPBbQTbTAJliIw5mWgarBI+5HVFow0d4vWxzH+fYpdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by SN7PR11MB7707.namprd11.prod.outlook.com (2603:10b6:806:322::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.27; Mon, 22 May
 2023 03:56:36 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::748:8cea:e1b3:88f8]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::748:8cea:e1b3:88f8%7]) with mapi id 15.20.6411.027; Mon, 22 May 2023
 03:56:36 +0000
From: "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To: Jakub Kicinski <kuba@kernel.org>, Vladimir Oltean
	<vladimir.oltean@nxp.com>
CC: "Russell King (Oracle)" <linux@armlinux.org.uk>, Andrew Lunn
	<andrew@lunn.ch>, =?iso-8859-1?Q?K=F6ry_Maincent?=
	<kory.maincent@bootlin.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "glipus@gmail.com" <glipus@gmail.com>,
	"maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
	"vadim.fedorenko@linux.dev" <vadim.fedorenko@linux.dev>,
	"richardcochran@gmail.com" <richardcochran@gmail.com>,
	"gerhard@engleder-embedded.com" <gerhard@engleder-embedded.com>,
	"thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
	"krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>, "Keller, Jacob E"
	<jacob.e.keller@intel.com>
Subject: RE: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Thread-Topic: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Thread-Index: AQHZio+3KVVtDjzUB0m9ZcDySvDzpa9lrCUw
Date: Mon, 22 May 2023 03:56:36 +0000
Message-ID: <SJ1PR11MB61800D87C61ADC94C57DB237B8439@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20230406184646.0c7c2ab1@kernel.org>
	<20230511203646.ihljeknxni77uu5j@skbuf>
	<54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
	<ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
	<20230511210237.nmjmcex47xadx6eo@skbuf>	<20230511150902.57d9a437@kernel.org>
	<20230511230717.hg7gtrq5ppvuzmcx@skbuf>	<20230511161625.2e3f0161@kernel.org>
	<20230512102911.qnosuqnzwbmlupg6@skbuf>	<20230512103852.64fd608b@kernel.org>
	<20230519132802.6f2v47zuz7omvazy@skbuf> <20230519132250.35ce4880@kernel.org>
In-Reply-To: <20230519132250.35ce4880@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|SN7PR11MB7707:EE_
x-ms-office365-filtering-correlation-id: cf55d485-4b2c-4c88-3537-08db5a788a4b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xgxG8xrXI8jxhyuU7IY1nLjIaj1ghJXSvqyD3jW2vvStYvETU/taEOwQcuzk8GdxRfZNoq/5Fxl+9S2qaeibw5iBGrejOETu+hFyyC28ZkuBVaORSXpRClGnczOiwBSmD5LQJqmFvkXj3+hPMFS5rxQxnAZPEG4BDid0e4Y1MmOv3eqQEnNYDSsJos43pm7+Qa9xbV+ilIsktvR3PGy+Oam51Z2B32lblyY+rAUFPGf5Y62ZlQY4ocvWmxN+ueNm04BT/R9BDme/lc9qzJZ+jbmJLjwojEV2nUgAVjzsEmMeZnH34z8Z+66JP89OrbE+3GBCgrhpuraCrcAkD4n3eglsICbuhVoQ/sVnOBCt7OYnLsuIANRjZpNbxSSEnt+qCuX3NOnVI+8mKP+4rbPmMGlfhbLK/nm+siIBri4cXgrcc/CUNVp1rQ5DAdNEabIezx6xnHMnj7nW7sN0qYb1EGx7y3LmVITPjqmh+VYjuGWzsnHT7j20TzZZXAWu6DseJw/pRlmb9nLd4qFC51w8tP1wkuiuSiPFX9pHlPbPbCAbWastBSknH+hQWr96HpatyOj17wCd0Gg613XYK0rWgIwKLR34pmSkAPhoT4pSEMM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199021)(8676002)(8936002)(52536014)(5660300002)(7416002)(186003)(26005)(9686003)(6506007)(86362001)(122000001)(38100700002)(82960400001)(38070700005)(107886003)(41300700001)(7696005)(33656002)(71200400001)(55016003)(966005)(66946007)(76116006)(66476007)(66556008)(66446008)(316002)(64756008)(4326008)(478600001)(54906003)(110136005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gZtC6OsFaKmYgx7OX+nQgwJ0zmIm2OVjj8PUY8wJnp3rqfub2vbzYm9J4p?=
 =?iso-8859-1?Q?OWoA/wrOtpcmYxpKcQaG3E52AS761DYIcTn8pXEsV4cSoSJt11VIBupglr?=
 =?iso-8859-1?Q?BoEAGkg0q1eKE9Kz/ZnSUpgyBlq6vd9fyWmgGWRBCgf2TTAg/w/yPbNSLH?=
 =?iso-8859-1?Q?iJ5q82WTT6bfsKMO8yuLNL8RSZzSpGCkeOpo4aRv42JHlv3fFV+HV/dL2D?=
 =?iso-8859-1?Q?8dcF4N1wVc+JdwIpLF2UWLAv+L/Vrelxy53XMYIi/CQhZivxwTeUKqzanf?=
 =?iso-8859-1?Q?x1nKm+sZ2ghql5MOJLe4eZowwrZkFgVwJaWsIvtAywj1YXuNgdWDFplwJB?=
 =?iso-8859-1?Q?s1UpMrldyvRbpp+HOHy214pVTYw/tiheAL10nKRYe3Wnrj1QRDIbGudwb1?=
 =?iso-8859-1?Q?QHR65hLrenRHJw1B7pHD8XlKgaw4UCZwmSBPLlPJAyvdtNhl3fdWhq/kIM?=
 =?iso-8859-1?Q?dq3sjkn8EfpYOgUm0zlWFe+hhod345RUK65tRLxFATBmgqIhvj7hlTiOIO?=
 =?iso-8859-1?Q?jF5M/PumhTuoUGRW+htIucoFMOfNx9SDKHkUzGTwJ1NjvfN0zaHDLtqF0J?=
 =?iso-8859-1?Q?mo3tsMdfLMnkh58MyzLw+1tIRxkNqwJ9h7Puh3tJeXQ7GQFtRg+VmP2OGc?=
 =?iso-8859-1?Q?BsNaBwr6w1k/OL7YmSSG9CI/TOmwGQV31K8gGF7UYp1hdFT44/841ZQZ91?=
 =?iso-8859-1?Q?692obsOGjK4p/zPTrV5oO/T+xJ5S7O6jxsra+HN3Bp4v5STkakhFOwjbfM?=
 =?iso-8859-1?Q?jLfl6bF1/k2lFQGnZoKg163m5VZ9iSWOp+9GurJlwLGbGg9K3Gf1cL2euz?=
 =?iso-8859-1?Q?heaiezu3vGlnvHcEMIrozbG1xnT0XWhN4UlXTx0OQRcfgVfUKr2yO9ZRko?=
 =?iso-8859-1?Q?Nb+DgWomenNw4+X9IWCGzkp3e6yOe1Kw5SDnspsDHIFqIGp9guuPVsWutl?=
 =?iso-8859-1?Q?d06e0PoKe/1Nzo60IuXPM6b7W3X3/av2Tp+Ms4U+GeImPZd2nwaiTwAVET?=
 =?iso-8859-1?Q?YUU8p46gxmnMfYTdlSFXGRAanGJgAX8sCp01Qpg4fqrnO+VOoSN6du2Fkw?=
 =?iso-8859-1?Q?t7vVhdZK0GULqU/x37F/3KbJlSfKC/8f7Sbvkr7o25NK1wH2I7DSkV3veH?=
 =?iso-8859-1?Q?yARpY18OFPxQ3Xgs4LE0dCM/uL2DA7oUywMC24W9VtzUOfM59OXNnwx//8?=
 =?iso-8859-1?Q?u+XBuUjG//5Gm31NBJBzVPtKfwDZ3QklLLQ9vUz7jYwx9MDEPSHdjIwyzt?=
 =?iso-8859-1?Q?r78C44gPAK3+RX64L3Htfo6xZ+txaBEZXdh/fd2r37mXEICtkcmXYbAUtV?=
 =?iso-8859-1?Q?0cgbGUWHE6D99cfB3vs/QHqTHbiRGPkc8afcGi9sI32Con0Ku5Ch2bQb3j?=
 =?iso-8859-1?Q?fXP/yw3r37TM159xCJHbZroBdXcTsDjVTjrXAO1B0ILWYmMSSacafbYsNg?=
 =?iso-8859-1?Q?in/ma77hAhCutd1mU/43vLoKoMcGYYLSx2dIXaB7ZIoLIg3GiDMkT4zp91?=
 =?iso-8859-1?Q?4m3N5/U4N8SRnIy4Wjj1SILAUQSTeyJbet1biCwXM9v59Go8XmrnEbxufL?=
 =?iso-8859-1?Q?hK+n3NydWWvAHLhznQs9NQvIBjep+P4n65F9o8qsc0NhcQz7Nthu6Ce+h9?=
 =?iso-8859-1?Q?jBhtd9S3LML0hNRyZRqCZOdjLyUxM2JNSgw+WtuVDqozqOV79J1zyvBDH+?=
 =?iso-8859-1?Q?r2KFiH1Y/OCexWFz4pk=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf55d485-4b2c-4c88-3537-08db5a788a4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 03:56:36.5636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KD1Qdo+rmdGwhzDot/GXS2k9BpNkMSKm0WOwI1SMbGD5/+WBiWFeVhH5Jw7tiU5QwIJGTrqOaE359ChPPB/4mF+uEgmCOD3limONn55LWfVgZoo86bgh/K8K3dkmhkjZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7707
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi All,

> On Fri, 19 May 2023 16:28:02 +0300 Vladimir Oltean wrote:
> > > I may have lost track of what the argument is. There are devices
> > > which will provide a DMA stamp for Tx and Rx. We need an API that'll
> > > inform the user about it.
> > >
> > > To be clear I'm talking about drivers which are already in the tree,
> > > not opening the door for some shoddy new HW in.
> >
> > So this is circling back to my original question (with emphasis on the
> > last part):
> >
> > | Which drivers provide DMA timestamps, and how do they currently
> > | signal that they do this? Do they do this for all packets that get
> > | timestamped, or for "some"?
> >
> > https://lore.kernel.org/netdev/20230511203646.ihljeknxni77uu5j@skbuf/
> >
> > If only "some" packets (unpredictable which) get DMA timestamps when a
> > MAC timestamp isn't available, what UAPI can satisfactorily describe
> > that? And who would want that?
>=20
> The short answer is "I don't know". There's been a lot of talk about time
> stamps due to Swift/BBRv2, but I don't have first hand experience with it=
.
> That'd require time stamping "all" packets but the precision is really on=
ly
> required to be in usec.
>=20
> Maybe Muhammad has a clearer use case in mind.

A controller may only support one HW Timestamp (PHY/Port) and one MAC Times=
tamp=20
(DMA Timestamp) for packet timestamp activity. If a PTP packet has used the=
 HW Timestamp (PHY/Port),=20
the MAC timestamp can be used for another packet timestamp activity (ex. AF=
_XDP/AF_PACKET).
If all packets require and use the same HW Timestamp (PHY/Port timestamp) a=
nd we send a huge=20
amount of traffic for AF_XDP/AF_PACKET, we may discover that some packets a=
re missing the=20
timestamp since every packet is attempting to read the same HW Port/PHY Tim=
estamp register.=20
You may see the tx_timestamp_timeout from ptp4l also in this scenario.=20
Giving the user the choice of selecting MAC or PHY timestamp through the so=
cket options can help=20
resolve the above issue if they enable per-packet MAC(DMA) timestamping.

Thanks,=20
Husaini

