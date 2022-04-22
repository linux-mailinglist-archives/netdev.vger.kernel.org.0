Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8365B50BE7B
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 19:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiDVRYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 13:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbiDVRYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:24:21 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEAE986F4;
        Fri, 22 Apr 2022 10:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650648077; x=1682184077;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/glr8O3Zuuqgkd96EO9dnVVc727rfgUq4glZycMebd4=;
  b=MY+cYFlOdlYvMsox8za3YqhL5at8lBp4odHdHQJ6gBRX1Hs3aa9nvwtL
   3H1Du0k+WkCo5hH86lK7KV8ptRUi861qPBAAxay8uXg0E6qOscX095ftc
   8S8Q0/X12u09Jq30LUSiQAG6kNbm7ZFaty2XpY8jB2oDFd+qpGdbNvtG9
   y8w0aHqaXEekSr8JKy3VtJo4bAwc0Q5H8IGu8i3Nyg8dd/Zv3pI+4UII1
   jxRQZuLpfIhVpQ4BEK6lQXo8gcNYBO+yunQY/ftkvLEfOj9/7U5hv0+ra
   ZNIW8O3krdhNd/ksLN7Y++eRH2mH49r/RtMGA4gTdBm9GCOYodeMfAJCJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="245305197"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="245305197"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 10:12:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="648702661"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Apr 2022 10:12:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 22 Apr 2022 10:12:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 22 Apr 2022 10:12:52 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 22 Apr 2022 10:12:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ie4h5y/4KtLzhp3CBPL9nw6HAbDvNMvfXHDo2HoeQ28aOTM12D1B085IVSJNswsczK2A8miJU2qKIq/a/yFRHFMO1K8cHaZbNPF4hTIzENf7cyxjvSW0FAxXVFOb+5iFZQ+y5dPW/tUJ8Ou1UJT0JejN0RUGMi6SmfKDP6SwNewCfteLgGHdujo/5b33ExOHu2rKM0zZakWCGgWeyPRJKpf5XParJ6TdTevypC8AYIwJRnZmVqFS8C8rkSxvIcSRvB4nLr4Fxbc9oKVol6kQVzAV7fxJ9IoCoch5Iq3n5zCiCXqFHd/HkcGkesVEVyR9dMx9w6kifRTxtZyDJdbcgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paRO9YEz4kfCGJZo3ClFwwq/OJKZzDlA8Xava8X4dDI=;
 b=S3qx+irj3YvT3OXiac76VssXI86lHyGuyxGMyV2vgRq1PDLg3acROoNuj/IS8x5T8aMSzuNBaq0NDIbs0ixbr4Qh8CYrYa/iKC+LLgS7qoDIr87b+70yDhRfYKddiLqu61/hbTlbylZJmP+gwM4FVgWm1RwKzZzXybpQfgzPzpqsA5X7AKI9hbSDf82col6/tlJBL5w7T1doJze13OpbxH+sBQwBFO0UTjOyWhazwUk15aPsIyxySzG7dYpRHOeZjIS/alBbVNFuy4gcdaydS9La4/HPAIPCq+SLUvE+ArkdEh3gOw/hO6JZMjBiIsP/PuvtNJ5OGG2itf4oALj6MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by CH0PR11MB5217.namprd11.prod.outlook.com (2603:10b6:610:e0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 22 Apr
 2022 17:12:50 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::6820:41b6:a038:7a3b]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::6820:41b6:a038:7a3b%6]) with mapi id 15.20.5186.013; Fri, 22 Apr 2022
 17:12:50 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v3] ice: Fix race during aux device (un)plugging
Thread-Topic: [PATCH net v3] ice: Fix race during aux device (un)plugging
Thread-Index: AQHYVUZcHI6VX+DIGkiO7KkonUY3tKz8LcQQ
Date:   Fri, 22 Apr 2022 17:12:50 +0000
Message-ID: <MW5PR11MB5811B1CA163538BE14F58DA8DDF79@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20220421060906.1902576-1-ivecera@redhat.com>
In-Reply-To: <20220421060906.1902576-1-ivecera@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51477307-bd93-4a86-111c-08da24835482
x-ms-traffictypediagnostic: CH0PR11MB5217:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CH0PR11MB52170A2ECACF35CD594837CFDDF79@CH0PR11MB5217.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TDPWmlAK/X0lIjLl4NlZCLp7mixv9TKjfiuZVoQboc34kAdfaYZ8Ba/CuLbFzurwaAYeyu21h/+dFtLesxInxoSFDB7Oo1KRYVskbRd0Ajaetpn1kogaCIem4bgAz8TXPNUaNFNwyKeWBHnYVplRFWncSEU9CJXsqyl1KmdHr2ZUQs4Ztro/Hu1jk8od2jNl5kWtUmF3qhfoSNsDog/MKZu1x+em6pA7cQiEG5HmUiyUCDtAEQ1NeTf0nH+4d1SmUmw7E4E8p//jyDnJr7sjEefiBA5/yvwH14Y4iiTcllKxuFxk45J+riH35f4HnkiyALImyuPbInTpja0INRo4qhlignLxM30KjFjSVxJUnbDoQbuO66ZYMtner6f0Yo0JeO6AhBtlPty+m2YGVuYY2kHIIqBp85VJjgSbAkXsvYRf9nTXIKtb2yLqIVoPsqM0Rs6k2lcCSvmvxvhxV693UT7ZpsE+fd+W439Fm33SW/cQX/dz3wXJnJsJ7ZfwCVV10TPyBd3OISWtb4oBn4qrJ2Cj/NgBOX4SKPNkmDZ46SEiPoBWf75bfOw9meBBwZrkqok42cDEWZ8PtEmfgJO161Nrbk3Zd/iFFC1KGN2YjaDhjaK0S/99YOY44jdocBHhpJFrTPALAtxMXyaStKUxuvNnQOShAEtxTB4YDHG/7uQw3HGKhAFAQzJCT2Lzd0NvGzHCsBsknQMXSFFOgS5oiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(7696005)(33656002)(7416002)(186003)(86362001)(55016003)(71200400001)(9686003)(2906002)(8936002)(5660300002)(53546011)(83380400001)(6506007)(26005)(52536014)(38070700005)(54906003)(110136005)(76116006)(66476007)(8676002)(4326008)(64756008)(66556008)(66446008)(82960400001)(66946007)(316002)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kmsCbamAOrKQAwy/FbpYTiM2Tb2bE+HfgeBGr8ZyqNLLYnyIuEkiDtRRDjOl?=
 =?us-ascii?Q?kIBbsDmDZxjm0Fi0Zgd9Ia4YK1SkHB9SYBUvMRU0LccBX3Gpix9WDCUXYtLO?=
 =?us-ascii?Q?NJNcvHhrTNjRYYgbq6eEHminb70LUiH43boE/MN+gXHhgN+6gt0ezyMe32mO?=
 =?us-ascii?Q?QsaY/RUQm/nLSAUlto9RpRRoQ0vqxtoFZ7fnxdp/FvfXpa+uKmJdoBJOIgl2?=
 =?us-ascii?Q?buVaHcSOfGtLMj1j539feSvAXKWh4zqY0aBkiWPjzvooFa8Vh3X/OBv1zXpo?=
 =?us-ascii?Q?g/o7Wn6mBp9IPxvMr0kowA0/fOLSLrdYexVr6dnfvZrIKJXJ1OrnfL3SFqFy?=
 =?us-ascii?Q?gSHayE8i5rXYPGDbr2G8WhBtrD2819fXe6sj2S4zmW+9Xoh52GhR/waknCTd?=
 =?us-ascii?Q?dp8RIzgtfYKPeZZdaNyvprTn+WHlGDr9t64xYGaS1i0hBQL26ZywZWKjaq+x?=
 =?us-ascii?Q?o+H02QAfdsUSi82IaeMEFhdd7m51qDZb4dL0INfU08YyTq6RgPvdSChvM++/?=
 =?us-ascii?Q?3THoTOXgwHwB46pphse4pr2OyYNRGZliR5fX/4D65z/zwm4ZRlosOWpJgMSw?=
 =?us-ascii?Q?HEPbuPco1++u2DWY9oZ+2A6UNZjImXRl8wM35E8yOI+AWN5iv9TYT11qCUdL?=
 =?us-ascii?Q?qszDeyRLUvYNrz4ReZmoTE7FCrhMX5QZmap21kZiduiyb2SWZ720+rA+kwpH?=
 =?us-ascii?Q?mrDH5s7e8QmL7GJVpJNM6X7q7poPz1DzrUXTrnEFixwe3H9qxnJoSaJAN6mF?=
 =?us-ascii?Q?1NznviotqxZRq6X/ACINLCU+YmLGikNnQ3hbceC8CHJ10NeQBCu1TYjW6wn0?=
 =?us-ascii?Q?nHfT+P0cp5Bk3b8FcR8vOZwKuDFuOqVkhDUI9v8DYxRhDFfnCRtm+Nr4/3Nc?=
 =?us-ascii?Q?ZHb+AdqZ1+iRS+OY79mi5B+TVUuf/fCShC4s12cvaBUvlLTaXcr2a+Ou66dr?=
 =?us-ascii?Q?c4gpPg6ZdB1/5QZAQwpA+HcYcp4YDBfoVMjgYMCDhuTUvk4lyTIVZ0hmKScF?=
 =?us-ascii?Q?JW8H8Fp28gdDd/hYWmBHBje4qzkibaLgsYhsJ7/kJ48o1wJ/9bjXrk+DLBEb?=
 =?us-ascii?Q?zLxm7wrJ0e4fgiVpNoz+VpkZ9dmAowUOg26p9Gfy8of/gyo3b6FstElq/PZ0?=
 =?us-ascii?Q?3XeLqa5euj4YpyOd8ASi2e5lPcENZV1V8O2bUz8RljehWXxsEB38U3fd5T/T?=
 =?us-ascii?Q?AGOmYNbA1oGnuv+iHy56gfSVLTSbZG2G3tbraSJtMsbFO6iLJZmwp+hNWo33?=
 =?us-ascii?Q?OwpCyGI1qpCcFCkjV07JYe1lR9Xpn2DNPRQ6WjX+SIMnBIUTmpcSdCQDFk34?=
 =?us-ascii?Q?VjeSPImBBYiuYPZ8jju/Q60f5DdkTgvxbXWqKbzPpBMAw3D1o8iBy6DXRo7x?=
 =?us-ascii?Q?13mDXQ7ycuodVyaMWni5G83lAn9n2ziINnSWTCAlk+Vza2VQOwqbdBpU+i2W?=
 =?us-ascii?Q?8YckqHf8ebj3qavv7LK7CGUpHjUByzfHp+uDBkgNl5T6UGWGLzOth4WPS2jS?=
 =?us-ascii?Q?0ZF43o6sWlEWdwgsdlA8tWAZ8ac4P9pEVBlaX23nYQI2+if54YuyKiLovklS?=
 =?us-ascii?Q?6TBpPAunWiuVfFqFBogC24reC3TrCx6bfIY+vFo84ML/yP8rurzKrRhrfdx1?=
 =?us-ascii?Q?+hzqAxEbZSOGidTs0GPXe26/7an5ePIyW61BpLaVCcQF+g12+g+qXP8f6V2d?=
 =?us-ascii?Q?3LW0qx4ugeuoVuO7Ta/fJrO+HOFxgog6vWRY/6sPwmBdSVK5CrWGJO5HZz1Y?=
 =?us-ascii?Q?7wJewRzC1H+JWh78BkOpfBrR8ak7GNE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51477307-bd93-4a86-111c-08da24835482
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2022 17:12:50.2847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5bYgqjQ24xRg4JrDo1nSZK5BmFmcdWuIj4weoY+8nE+p/cd4IwR3y6L/H+b0+/vczfSgZKdGtb8XdjwJ86VrMh8ZWhBbsYR3hCDIiP8MqWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5217
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ivan Vecera <ivecera@redhat.com>
> Sent: Wednesday, April 20, 2022 11:09 PM
> To: netdev@vger.kernel.org
> Cc: poros <poros@redhat.com>; mschmidt <mschmidt@redhat.com>; Leon
> Romanovsky <leon@kernel.org>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> Ertman, David M <david.m.ertman@intel.com>; Saleem, Shiraz
> <shiraz.saleem@intel.com>; moderated list:INTEL ETHERNET DRIVERS <intel-
> wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.org>
> Subject: [PATCH net v3] ice: Fix race during aux device (un)plugging
>=20
> Function ice_plug_aux_dev() assigns pf->adev field too early prior
> aux device initialization and on other side ice_unplug_aux_dev()
> starts aux device deinit and at the end assigns NULL to pf->adev.
> This is wrong because pf->adev should always be non-NULL only when
> aux device is fully initialized and ready. This wrong order causes
> a crash when ice_send_event_to_aux() call occurs because that function
> depends on non-NULL value of pf->adev and does not assume that
> aux device is half-initialized or half-destroyed.
> After order correction the race window is tiny but it is still there,
> as Leon mentioned and manipulation with pf->adev needs to be protected
> by mutex.
>=20
> Fix (un-)plugging functions so pf->adev field is set after aux device
> init and prior aux device destroy and protect pf->adev assignment by
> new mutex. This mutex is also held during ice_send_event_to_aux()
> call to ensure that aux device is valid during that call. Device
> lock used ice_send_event_to_aux() to avoid its concurrent run can
> be removed as this is secured by that mutex.
>=20
> Reproducer:
> cycle=3D1
> while :;do
>         echo "#### Cycle: $cycle"
>=20
>         ip link set ens7f0 mtu 9000
>         ip link add bond0 type bond mode 1 miimon 100
>         ip link set bond0 up
>         ifenslave bond0 ens7f0
>         ip link set bond0 mtu 9000
>         ethtool -L ens7f0 combined 1
>         ip link del bond0
>         ip link set ens7f0 mtu 1500
>         sleep 1
>=20
>         let cycle++
> done
>=20
> In short when the device is added/removed to/from bond the aux device
> is unplugged/plugged. When MTU of the device is changed an event is
> sent to aux device asynchronously. This can race with (un)plugging
> operation and because pf->adev is set too early (plug) or too late
> (unplug) the function ice_send_event_to_aux() can touch uninitialized
> or destroyed fields. In the case of crash below pf->adev->dev.mutex.
>=20
> Crash:
> [   53.372066] bond0: (slave ens7f0): making interface the new active one
> [   53.378622] bond0: (slave ens7f0): Enslaving as an active interface wi=
th an u
> p link
> [   53.386294] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes
> ready
> [   53.549104] bond0: (slave ens7f1): Enslaving as a backup interface wit=
h an
> up
>  link
> [   54.118906] ice 0000:ca:00.0 ens7f0: Number of in use tx queues change=
d
> inval
> idating tc mappings. Priority traffic classification disabled!
> [   54.233374] ice 0000:ca:00.1 ens7f1: Number of in use tx queues change=
d
> inval
> idating tc mappings. Priority traffic classification disabled!
> [   54.248204] bond0: (slave ens7f0): Releasing backup interface
> [   54.253955] bond0: (slave ens7f1): making interface the new active one
> [   54.274875] bond0: (slave ens7f1): Releasing backup interface
> [   54.289153] bond0 (unregistering): Released all slaves
> [   55.383179] MII link monitoring set to 100 ms
> [   55.398696] bond0: (slave ens7f0): making interface the new active one
> [   55.405241] BUG: kernel NULL pointer dereference, address:
> 0000000000000080
> [   55.405289] bond0: (slave ens7f0): Enslaving as an active interface wi=
th an u
> p link
> [   55.412198] #PF: supervisor write access in kernel mode
> [   55.412200] #PF: error_code(0x0002) - not-present page
> [   55.412201] PGD 25d2ad067 P4D 0
> [   55.412204] Oops: 0002 [#1] PREEMPT SMP NOPTI
> [   55.412207] CPU: 0 PID: 403 Comm: kworker/0:2 Kdump: loaded Tainted: G
> S
>            5.17.0-13579-g57f2d6540f03 #1
> [   55.429094] bond0: (slave ens7f1): Enslaving as a backup interface wit=
h an
> up
>  link
> [   55.430224] Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.4.4
> 10/07/
> 2021
> [   55.430226] Workqueue: ice ice_service_task [ice]
> [   55.468169] RIP: 0010:mutex_unlock+0x10/0x20
> [   55.472439] Code: 0f b1 13 74 96 eb e0 4c 89 ee eb d8 e8 79 54 ff ff 6=
6 0f 1f 84
> 00 00 00 00 00 0f 1f 44 00 00 65 48 8b 04 25 40 ef 01 00 31 d2 <f0> 48 0f=
 b1 17 75
> 01 c3 e9 e3 fe ff ff 0f 1f 00 0f 1f 44 00 00 48
> [   55.491186] RSP: 0018:ff4454230d7d7e28 EFLAGS: 00010246
> [   55.496413] RAX: ff1a79b208b08000 RBX: ff1a79b2182e8880 RCX:
> 0000000000000001
> [   55.503545] RDX: 0000000000000000 RSI: ff4454230d7d7db0 RDI:
> 0000000000000080
> [   55.510678] RBP: ff1a79d1c7e48b68 R08: ff4454230d7d7db0 R09:
> 0000000000000041
> [   55.517812] R10: 00000000000000a5 R11: 00000000000006e6 R12:
> ff1a79d1c7e48bc0
> [   55.524945] R13: 0000000000000000 R14: ff1a79d0ffc305c0 R15:
> 0000000000000000
> [   55.532076] FS:  0000000000000000(0000) GS:ff1a79d0ffc00000(0000)
> knlGS:0000000000000000
> [   55.540163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   55.545908] CR2: 0000000000000080 CR3: 00000003487ae003 CR4:
> 0000000000771ef0
> [   55.553041] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [   55.560173] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [   55.567305] PKRU: 55555554
> [   55.570018] Call Trace:
> [   55.572474]  <TASK>
> [   55.574579]  ice_service_task+0xaab/0xef0 [ice]
> [   55.579130]  process_one_work+0x1c5/0x390
> [   55.583141]  ? process_one_work+0x390/0x390
> [   55.587326]  worker_thread+0x30/0x360
> [   55.590994]  ? process_one_work+0x390/0x390
> [   55.595180]  kthread+0xe6/0x110
> [   55.598325]  ? kthread_complete_and_exit+0x20/0x20
> [   55.603116]  ret_from_fork+0x1f/0x30
> [   55.606698]  </TASK>
>=20
> Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
> Cc: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h      |  1 +
>  drivers/net/ethernet/intel/ice/ice_idc.c  | 33 ++++++++++++++---------
>  drivers/net/ethernet/intel/ice/ice_main.c |  2 ++
>  3 files changed, 23 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice.h
> b/drivers/net/ethernet/intel/ice/ice.h
> index 8ed3c9ab7ff7..a895e3a8e988 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -540,6 +540,7 @@ struct ice_pf {
>  	struct mutex avail_q_mutex;	/* protects access to avail_[rx|tx]qs
> */
>  	struct mutex sw_mutex;		/* lock for protecting VSI alloc
> flow */
>  	struct mutex tc_mutex;		/* lock to protect TC changes
> */
> +	struct mutex adev_mutex;	/* lock to protect aux device access
> */
>  	u32 msg_enable;
>  	struct ice_ptp ptp;
>  	struct tty_driver *ice_gnss_tty_driver;
> diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c
> b/drivers/net/ethernet/intel/ice/ice_idc.c
> index 25a436d342c2..b9e471137f6a 100644
> --- a/drivers/net/ethernet/intel/ice/ice_idc.c
> +++ b/drivers/net/ethernet/intel/ice/ice_idc.c
> @@ -10,13 +10,15 @@
>   * ice_get_auxiliary_drv - retrieve iidc_auxiliary_drv struct
>   * @pf: pointer to PF struct
>   *
> - * This function has to be called with a device_lock on the
> - * pf->adev.dev to avoid race conditions.
> + * This function has to be called with pf->adev_mutex held
> + * to avoid race conditions.
>   */
>  static struct iidc_auxiliary_drv *ice_get_auxiliary_drv(struct ice_pf *p=
f)
>  {
>  	struct auxiliary_device *adev;
>=20
> +	lockdep_assert_held(&pf->adev_mutex);
> +
>  	adev =3D pf->adev;
>  	if (!adev || !adev->dev.driver)
>  		return NULL;
> @@ -37,14 +39,13 @@ void ice_send_event_to_aux(struct ice_pf *pf, struct
> iidc_event *event)
>  	if (WARN_ON_ONCE(!in_task()))
>  		return;
>=20
> -	if (!pf->adev)
> -		return;
> +	mutex_lock(&pf->adev_mutex);
>=20
> -	device_lock(&pf->adev->dev);
>  	iadrv =3D ice_get_auxiliary_drv(pf);
>  	if (iadrv && iadrv->event_handler)
>  		iadrv->event_handler(pf, event);
> -	device_unlock(&pf->adev->dev);
> +
> +	mutex_unlock(&pf->adev_mutex);
>  }
>=20
>  /**
> @@ -290,7 +291,6 @@ int ice_plug_aux_dev(struct ice_pf *pf)
>  		return -ENOMEM;
>=20
>  	adev =3D &iadev->adev;
> -	pf->adev =3D adev;
>  	iadev->pf =3D pf;
>=20
>  	adev->id =3D pf->aux_idx;
> @@ -300,18 +300,20 @@ int ice_plug_aux_dev(struct ice_pf *pf)
>=20
>  	ret =3D auxiliary_device_init(adev);
>  	if (ret) {
> -		pf->adev =3D NULL;
>  		kfree(iadev);
>  		return ret;
>  	}
>=20
>  	ret =3D auxiliary_device_add(adev);
>  	if (ret) {
> -		pf->adev =3D NULL;
>  		auxiliary_device_uninit(adev);
>  		return ret;
>  	}
>=20
> +	mutex_lock(&pf->adev_mutex);
> +	pf->adev =3D adev;
> +	mutex_unlock(&pf->adev_mutex);
> +
>  	return 0;
>  }
>=20
> @@ -320,12 +322,17 @@ int ice_plug_aux_dev(struct ice_pf *pf)
>   */
>  void ice_unplug_aux_dev(struct ice_pf *pf)
>  {
> -	if (!pf->adev)
> -		return;
> +	struct auxiliary_device *adev;
>=20
> -	auxiliary_device_delete(pf->adev);
> -	auxiliary_device_uninit(pf->adev);
> +	mutex_lock(&pf->adev_mutex);
> +	adev =3D pf->adev;
>  	pf->adev =3D NULL;
> +	mutex_unlock(&pf->adev_mutex);
> +
> +	if (adev) {
> +		auxiliary_device_delete(adev);
> +		auxiliary_device_uninit(adev);
> +	}
>  }
>=20
>  /**
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> b/drivers/net/ethernet/intel/ice/ice_main.c
> index 5b1198859da7..2cbbf7abefc4 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -3769,6 +3769,7 @@ u16 ice_get_avail_rxq_count(struct ice_pf *pf)
>  static void ice_deinit_pf(struct ice_pf *pf)
>  {
>  	ice_service_task_stop(pf);
> +	mutex_destroy(&pf->adev_mutex);
>  	mutex_destroy(&pf->sw_mutex);
>  	mutex_destroy(&pf->tc_mutex);
>  	mutex_destroy(&pf->avail_q_mutex);
> @@ -3847,6 +3848,7 @@ static int ice_init_pf(struct ice_pf *pf)
>=20
>  	mutex_init(&pf->sw_mutex);
>  	mutex_init(&pf->tc_mutex);
> +	mutex_init(&pf->adev_mutex);
>=20
>  	INIT_HLIST_HEAD(&pf->aq_wait_list);
>  	spin_lock_init(&pf->aq_wait_lock);
> --
> 2.35.1


ack
