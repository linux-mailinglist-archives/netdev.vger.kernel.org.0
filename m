Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693ED46799A
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 15:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381494AbhLCOs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 09:48:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:38580 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232079AbhLCOsZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 09:48:25 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="236793942"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="236793942"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 06:44:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="513266073"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga007.fm.intel.com with ESMTP; 03 Dec 2021 06:44:51 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 06:44:50 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 06:44:50 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 3 Dec 2021 06:44:50 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 3 Dec 2021 06:44:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SuYPyBsQcie4o2yLVXAte/ppYGz5r+Z9/3YcDodNBo1j9aozAsFJv2+f6q5l7AmlXDoHm/2VPms9gL2h+QG1vizODw5UCE8FUTGshxFFuLbtLAKJQHu6vVhhERGQTqp0bJDJw1uVUcvssN3C+NqBI8RAssBXd3zRY+nhTbiTbE94yfrl8kzdtrIHBw8SQKdKjP/jE7+uLJsfUuuNv6hbPDPCVB1k42/7gnI/ULgK5aV9KwcrukaPLE14t77ZyDF5UaRgfgylEhka4TyMQrTftqVRHRd3ZZSJjLyoYaQDojgrKQjmy4ffMiibzeBS+taRjmC2R9XKoQP0qNEJZFUS0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ldfps3wwbXVcQZSDY0OCErTC7P67KsSM9lelclKi2A=;
 b=IKXwGg4WfAkOTuqVYFwodGFlp0RzQ63DIlxg3h3T0pNVWp2RTa5pYWLQTFrMe0E7rskVJh/xpeF/bMQ0VyKMfwDt0OtpjJT8GTcKTduT7nBy2dOSzFXf+877QrG87ZQDM/gXIb2mYeskP+UmBqKwaFWof3sWFoSkAXzpU+yfVhK476j6bKtFONsBgMuJ87fes24m1+UiEwFdEpJxpZY0K2Q6tD2vk2Sx6PaFJ5LPFx8blxGWhZeqBtVypha8LLSL+gdTIuqrVRIV9/ufXTFWZul9JMGxpcOIYCiX2BsCLDSwhJGPDYziP15Ltyw6eTaLsxHDqdh9+4uCURKQba43rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ldfps3wwbXVcQZSDY0OCErTC7P67KsSM9lelclKi2A=;
 b=yvqYT3sWgtCFR3x3ce2z2RW6oHMYrGiN/+hWp7ZhsqUtV0e07A9uEqI8YamyFzmtuqFkIk4tg6tghsxsOIGrZoxeQG0Pogjfc1eAn0RkIKOzrpZVQNfhzJuxafw2oQEQ6+yV7zjnn/70Oen0SENWfk//uT1gc4kDZTjIs3HdA3E=
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BYAPR11MB2744.namprd11.prod.outlook.com (2603:10b6:a02:c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 3 Dec
 2021 14:44:49 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d9a0:60c3:b2b2:14ce]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d9a0:60c3:b2b2:14ce%7]) with mapi id 15.20.4755.014; Fri, 3 Dec 2021
 14:44:49 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net-next 3/9] i40e: switch to
 napi_build_skb()
Thread-Topic: [Intel-wired-lan] [PATCH net-next 3/9] i40e: switch to
 napi_build_skb()
Thread-Index: AQHX4I93XrxEIB+NsEi+2fFDFyILS6wg50eg
Date:   Fri, 3 Dec 2021 14:44:48 +0000
Message-ID: <BYAPR11MB33677F05900A004E3CF63808FC6A9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20211123171840.157471-1-alexandr.lobakin@intel.com>
 <20211123171840.157471-4-alexandr.lobakin@intel.com>
In-Reply-To: <20211123171840.157471-4-alexandr.lobakin@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 288db604-f562-4e83-9186-08d9b66b7501
x-ms-traffictypediagnostic: BYAPR11MB2744:
x-microsoft-antispam-prvs: <BYAPR11MB27440D80E7F9522B0D6A99A3FC6A9@BYAPR11MB2744.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JaUF7GDiPmo5l6t8wMS6j519PqoNYawEpY4RIXMJj84RplQkMZOliP+ebAg3OPJsWyoMN3UeKerhYOnD8RpF182e2fsbnjuK6oJbZezcF7Ndh1jwLEwVCDz74ji+cbltT/4EQ+wk4fZ0AoUnQKLp5vrqB4nOhUY01HQvZPbvuKIVC27k7Rqj89BhD0awNo0OJCEz6dz4y7TG7d1me56V+/qtKN+M+hns+1JCm2M9MrlnkKWt/EoegQ+FD4Fc0Mhrkjnl62sBUtHWNla6Jqe3V99XYYhvMvs6f4JDgNm8O8UbEqnC85Gub7HfdZBXVgiJi6jqlxC0wZZqdMmFdmvxtQONApuVNAZlEyGTPGqweD40AkSy4zh6J/wgSldBJpKqi9bVN9GzGyCNvOyguYWr630jJaJvFrLhWMrlNggUJ5mdaEofQVU0mfpWOh99TpI0KUVejoQlOZq6aacmurnW+7lukrMfr4CazxHOspGadwcZFpHb2BAIexrW782tHYe63oE32L6zy82BnjIqo3PYr5mBMAaJZaxmTwyDGa3L1uYjZitJQjqDsK01ySv33xUB4c5qXAVFaVximD7oWQtYUI+zgb53R9bnNUswDMVNySCneVQHAGY8EbKLX46NHfibyMz2jz6gdRJ25oWP7LpOZh0lVqKlXY0VtHgayJPCMCLdUxOcU4izSfmDM2fR6neyYMfMyTORubvvDsCSYJeOUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(26005)(9686003)(38070700005)(83380400001)(316002)(7696005)(8676002)(8936002)(2906002)(71200400001)(4326008)(76116006)(52536014)(38100700002)(54906003)(122000001)(5660300002)(55016003)(6506007)(53546011)(66446008)(66946007)(508600001)(33656002)(82960400001)(64756008)(186003)(66556008)(110136005)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lb2C3dB6MjD2eGs1ZR/SMHqxJ7hxg92ZVG7J/QQq9T/6t+JIl188PGAGd8EH?=
 =?us-ascii?Q?BZ2rksKNptqK9zhzlP8dMn5PmYM0/ins99/+sPCUd6AiiDIxLDfqvhrFyt/2?=
 =?us-ascii?Q?jVY4HSbgOotzN6/GgUhYjBCo8hPOnS39HwVLK3DygCMztcdduJ2vcSioVVQr?=
 =?us-ascii?Q?o20dp3Zb+JkP8FB5UWCFujcfoqR4luS1p9dRxpgmpNSxlOYH/t0JuGog3CmW?=
 =?us-ascii?Q?LHJ1hJvZ6an9ewnTjuYAw0V86sQMq1DFHUolI/aCRaEBI5EmhYIT4UZt96ZN?=
 =?us-ascii?Q?lDceNzw7OxX8AgonLZcINC2trOsFv9kJRQRF4p37zaao6VdX7WP+tGxIotzh?=
 =?us-ascii?Q?9tkXuJXZWAtiCVG5ywir8iBFW6ydLJTtGBSBWovCa6DF8E+QqEeLnN4fgef0?=
 =?us-ascii?Q?WhcwTDFeBeRFTeJW5XHsBoE75pAl/DD/J4JI+B55f+pzY4zmnp5/Lxta4Y2Q?=
 =?us-ascii?Q?2PS7Mf0AD2wg+D12hBseAQyOTg0PBRR/o5Rdf/2mrZF8Ve64Un99JoX3qZfX?=
 =?us-ascii?Q?zMLdxuuK5dmKpuJMJx2d0xIZvZT34cuVAotAI74n7kral85sTxiqudMEqdX0?=
 =?us-ascii?Q?TNAVH2W/l8npo+sdk8HDIFGCFeB3LCLzloSvb4GhekiZIy9dVRAaE9t5vBlT?=
 =?us-ascii?Q?eNIx5Ng9G86snxdORza2s+nh2UaAWcK9RpV4H9A57pkDr6GZzhF6AZKLS6L9?=
 =?us-ascii?Q?gMbecAyaHUvDyQmdcVZk2Qy2z+kMdWOqp0k3n8envKZAjVS3EME9fzSH+0OC?=
 =?us-ascii?Q?t7OZXqw5C+Zili4k/r0JlZoJx9+kZuoZov1P2fmVvsAleiceW5Sekf1mJj31?=
 =?us-ascii?Q?JUgpDHKOZOPqQZLEI+maEbHXfAK402EfgzWqkezeJzxlvTGMl+pCjitwFPbb?=
 =?us-ascii?Q?3OmH/3J6BgrVcyULeBHwhL2PyILWDa/bqWajmXffybXzGq5UXUdINvmyBqI1?=
 =?us-ascii?Q?23IvZaF2p3fB053grpVMyh6PzqCp3f+IwbIwoZ20jrVcbWVotlwta3aQOtaR?=
 =?us-ascii?Q?Ti+MEO5LQ3v095C9M9zlY34OimwaINjS0CqyVi4XKlxBPrUM7Y+SSRRFTEp9?=
 =?us-ascii?Q?S7ta2VKKoL2fzRDzCJaYc/xJzbwnaOOSrZMiyE6h3epf13VqwfCfdgSOAOCn?=
 =?us-ascii?Q?FXBz+G/zielGwgcIH9h2lIu3AG77KmbIcxZ/t/oKLc9tjS6a+4lpDAoHxBI5?=
 =?us-ascii?Q?AbJ077UmA+7Nh7d1DwzgduP+ukcnSSPxbOEfDMh+hhCAQJ5K2vzHdXKmzJLY?=
 =?us-ascii?Q?HO8d/TSfcD4OjQNKumsOUvizjFLBPOB/IKsmHyZJ5XMYqcaaxFyGeTjNqdy9?=
 =?us-ascii?Q?YIsTatcQIhbzdq34Z/FPKOV9ciGHdZqjAKmzhSVugNeVsMTtbVYvvk91TPHP?=
 =?us-ascii?Q?CEBcg0l+IlrCnPkiQ45sMpp3toxTeYsaWen11eb3fQZwvbzfkHUWYf0lDmoD?=
 =?us-ascii?Q?orQwgJKbPJkr4L3z9KlxixiXY5slt4YYsiASjc0kzLNFXY9T65RJDf2COkHj?=
 =?us-ascii?Q?uQVVPuBzyooY0CDH4d+B1keJnpQHyLPrJAMFOouHyIO2H/WseydFcVsp1aAN?=
 =?us-ascii?Q?dFKSbOhsCPdlwQjaLaRHV8lK9tqhcq34h1BRUMDXve0fQH3qjpwjGrD11Ad7?=
 =?us-ascii?Q?xA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 288db604-f562-4e83-9186-08d9b66b7501
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2021 14:44:48.9329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GyiZTkvJ7sgSDvUFSisy54Bw356nOomsq/qDnwwxSITpvleBdwO+SQ6kvWPlgc5zQW1HP3srlb104DJ/F52cfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2744
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Alexander Lobakin
> Sent: Tuesday, November 23, 2021 10:49 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jakub Kicinski
> <kuba@kernel.org>; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net-next 3/9] i40e: switch to napi_buil=
d_skb()
>=20
> napi_build_skb() reuses per-cpu NAPI skbuff_head cache in order to save s=
ome
> cycles on freeing/allocating skbuff_heads on every new Rx or completed Tx=
.
> i40e driver runs Tx completion polling cycle right before the Rx one and =
uses
> napi_consume_skb() to feed the cache with skbuff_heads of completed entri=
es,
> so it's never empty and always warm at that moment. Switch to the
> napi_build_skb() to relax mm pressure on heavy Rx.
>=20
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
