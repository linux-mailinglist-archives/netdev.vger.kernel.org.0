Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0494897A0
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 12:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244895AbiAJLiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 06:38:14 -0500
Received: from mga04.intel.com ([192.55.52.120]:43080 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244737AbiAJLh1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 06:37:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641814646; x=1673350646;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aRwm9BSr+/lyncfAhzyvTDibGltTZ40pcpJtbZFFmgA=;
  b=a52YAXbZ1xvuYRsKBQ5cDuiKIyjkSBaKyQ78VEWKL4wWpiaD6X7jc96l
   PAAii85Tf2u2iTKC0x+55S/WjwxvDy+EfuEx8w0M9hktWwP6n4MXyofPS
   pSMuf4soP/wFlLoU+L2qPjaF8NBa/pmslTSCV0RiK0Mr9sBtmfgMdHxdk
   PaOqvBcK94gpnVDyoU1BfiDANYTTwokUBxSYT83RIAePLRGXzxgAlf3/j
   jAQgsh6UtaIVQwCfygF6m+YSGJhKkP2dwuYFlqZO7VaLBvsqpNMZUsGqI
   x2lALLldbHoLRq7LLLPZdHvyV06v2mniMaV7bIZC8GAWWD1gWzrlkl8S0
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="242019043"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="242019043"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 03:37:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="575790317"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga008.fm.intel.com with ESMTP; 10 Jan 2022 03:37:24 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 03:37:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 10 Jan 2022 03:37:24 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 10 Jan 2022 03:37:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChPkxO3So2mpru1ruq4KPw5FF8NgGHlOZn5z7G7aQcCA4H3Wq8DDosyP997bOYlDWYY87+SOKPNGyNI2I/wEOhuGFqQKs1T82bhSv8DVEMl3w6ZP4Y1FzVXNmEIAhGWRrD01TJ28LXAHC/yvsU5RyQWo4ZtEvAGYwYlY1choznzYoh2CkcUpz/gzm2J6aqWcI2ZCNYHiJQLoljlsPgMoN2UYQV+DH6S80jB6UyzfvJYJiyl9/qxZGJaMRFaS79joViVIsU+CA+DLFVypt5BmcXx/876kXt9Ab4Qv7SgJnbaVWyyE5+dvVgsiiw9Ef2lK+Wa61E/b1Z0ETLO4euIUow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J0qtqLWl1A7DKyhHwsnH4BuLoYHy3pm2TB8pARcxpz0=;
 b=f4LTok9GjOw/rM7G+zLK4kcvbiSYmV03hjVdVI2lnbnd3C/P75owkJoXvXN0LuJokqv3oYF5c3mZVuMPCDwvja7qti+gku7WADHiTf29J+BwWngcarQDHOlGsBj1HU10c6pfvDA6nrlbt65u9/e0tGmrFyef3juHZEZcpVVnvGjzvBQX/AYTK8zGW8iZtcfI5jf+wOFdPm3E57g+VckcD/dVwFEZWiUP9EALRLl/VyP274kTpNfDKAs3ejVSn1xWw69KMgQ0YjPODCSWeef3uheZI7znOwobtGCsCDuYF+XEK7jqu3lwXjaT/b0wcax1vrPBJoVrNt9/reFYli/3HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM6PR11MB4756.namprd11.prod.outlook.com (2603:10b6:5:2a7::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Mon, 10 Jan 2022 11:37:21 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f%3]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 11:37:21 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "Brouer, Jesper" <brouer@redhat.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>
Subject: RE: [Intel-wired-lan] [PATCH v4 net-next 5/9] ice: respect metadata
 on XSK Rx to skb
Thread-Topic: [Intel-wired-lan] [PATCH v4 net-next 5/9] ice: respect metadata
 on XSK Rx to skb
Thread-Index: AQHX7D0b2J0zbA5oYk25b00TVMSFGaxcVB8g
Date:   Mon, 10 Jan 2022 11:37:21 +0000
Message-ID: <DM6PR11MB3292226E5E815F1F335437F8F1509@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20211208140702.642741-1-alexandr.lobakin@intel.com>
 <20211208140702.642741-6-alexandr.lobakin@intel.com>
In-Reply-To: <20211208140702.642741-6-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0af93922-5d8a-4173-44d5-08d9d42d90bb
x-ms-traffictypediagnostic: DM6PR11MB4756:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB4756C2A8DB2C1363B6F20AE4F1509@DM6PR11MB4756.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8QclybQfgKNZdlvcbLUzyVIvweADJQW8maJGWdkZU89RUxtX0WtYQp9vUPq3/q8tSZZHZB3TJ0YXUm8r2+RO2ad4W4ZtJTMnZcIGKpTrzeMhVJ30h81XWzXjjuGOoiEdX7G8ikYd4I3hxK1kg+wUcd9ky513G/lGyq1LZfUlySapnau44ZPNTwpEHBEuZ7Euv8CVNdqo9js2Ki3b4+msO+dAdZ9rYz5lLVowJpE3ofW1mrsly6FiljTMA9iZM9eMbFy/xz/WxJL+BOfJIbMnTLs63EDGHpTW6nkXGYhgUzp1kH83ZHfgUzmKq/62jiTmrhcrQDH4N0Qi4J0Zkh7C5ouC7oR1aZNfyRgnRjQd/ysZUq2NmPJO2W/rNXLqeUq0/3D5x87L5g19qqg9/R12GEoIgcgK2nOrIUiUuKBjCpzmmO8ZdDmispqUX26cWe0ViosRL800a/z3H8M8X8K75r+Rbgf42aMPKZ2jl/RRlHVTUA6MATdHhaorZIoUldfbchxQb21Wy9KHrKHj2SdCKnjxy6DAK7mMHT2Ms387jLfClE6K+Kcza1zNLlsBIBKFJOfC8dO01QtVN/fQDD7PhsYZkemCX0m7rXSeiSXJ8fYLeskHo5nPDz0dRROiptK/HVxz/aX+1CtGWsGQsRSMy9wCRbPt1d3MhKoFNOmcvld9C8x2xbwcuRpRgeLL1lQTM845yr2wiNpR90RQ4qwt4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(64756008)(66446008)(8936002)(110136005)(82960400001)(4326008)(26005)(54906003)(86362001)(33656002)(2906002)(66946007)(76116006)(7696005)(71200400001)(7416002)(52536014)(38100700002)(53546011)(6506007)(66574015)(55016003)(508600001)(316002)(8676002)(5660300002)(186003)(122000001)(9686003)(83380400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?n0HBeTU2NpWfLtATkCOT6Eodpm7tHCbB/8dxVlnOD/2P7yTijT5tFwTK3L?=
 =?iso-8859-1?Q?hEWMd3cfP1bwBwPEBz5oL8tkq7DiDfp/97dhGAdVdWGNlbdypSwfu8nSPB?=
 =?iso-8859-1?Q?L+xmWPG5Nx78igf68IDZX2HAIw+xX/SQc5zS2m8HPOrxi9q0RpBUD04PZG?=
 =?iso-8859-1?Q?s9Q2a5K/Zv2QS+gifQTj/rhGdNHqplMGmiGB9w0yDKaOU6PvNgzB/M+v1A?=
 =?iso-8859-1?Q?O0rKEKey6itCijxS3F894VLe515mqDIAN5z38R0EumqfgVSRw/h4ia/Gfn?=
 =?iso-8859-1?Q?XbsvS7GHf7enQQeI6BoxrYRXf55QY5kPU99+ZdyfAzDysF0BSY6p1ob1If?=
 =?iso-8859-1?Q?z/HST713x6d1qY0kr9h0mGijsCsTOxBI4vuB7ktkxBVCa7uH43VYKE8khB?=
 =?iso-8859-1?Q?B2HPbYlC2DCpb8MG0iDbRglmLf9dJNWMISmwa2KhSuyLxscX9d+muD8uDe?=
 =?iso-8859-1?Q?yGS3wTzWOtp+RkaUPoh2/Hp01dGqifxifsiLc1NqHqPdenjC4ZzQDPaBNU?=
 =?iso-8859-1?Q?0lf9l0/yt8sUXDLLBNOoZ4KLL4yZoDQV5R1QKADwYjRy4E5bZHJxBa7dud?=
 =?iso-8859-1?Q?BP474ieGtmMBO8uY+jCzF4gNxsSUa+//DmE4fMNd9uo/cHanjtqydtIN3X?=
 =?iso-8859-1?Q?uP8g/XSSK31don7PtORea666RxZ49FrxmwJccOPVyFU9oMI1IRv9BuTLXS?=
 =?iso-8859-1?Q?0x2FKz/wvSyE+BlR7dnL4IVuiPr3kqAohuX3VDb/eh2bIsf8AWhrZQkOg0?=
 =?iso-8859-1?Q?fW4gffJcmGTXTKv5m5dPq799ulQKHJY9S17werpygDdfcSE/AmtW99u00O?=
 =?iso-8859-1?Q?0SHEftnm1NxwzNGoK/ekW1s1JMgzaMGBpeIkVB+vjQx9WJCp9PRWCdKccI?=
 =?iso-8859-1?Q?0/PmWAA0ChY7jrevuyWTwdY7nRGBo3zw5PthhhexFfZy93DQnFrldgcRTo?=
 =?iso-8859-1?Q?XaWwcycnlhnVWH59ZbJsdGC0uiXvWFDg+3QImgKpyqyHZi/Rl+6xvwzQml?=
 =?iso-8859-1?Q?vgSZ3EbIoauhrGHm6u81Z1QJsm9qcbSGHZQzDrCOjNPoNq08Cde4PImLDS?=
 =?iso-8859-1?Q?tUttyyU9IM/oXdC9j4eUpPAPf6WoSxEjVveD0LLAx/z1kUyf1jJuLy36I6?=
 =?iso-8859-1?Q?ci9UMK3RX24aTcm3LB704Og9NQxG+Lyp0FkI/D8okS9anu+SmClqcuXCQS?=
 =?iso-8859-1?Q?NOQ85tm6IYaHVGV+A51PZfQPxtt3zaGr1u4GNTUI5TL/hS/NeOCGrhr6Zx?=
 =?iso-8859-1?Q?AnrQ44fNYvZrgu3HN8HXeqByawWlxZC7vqiBFZjh/AHD56HakAKHg84Kvw?=
 =?iso-8859-1?Q?nUuBzKqHfylrDzCnYfs5X/8kWLzEpzkAKAca9B/GD6rIDIH7kJZeWCmEqS?=
 =?iso-8859-1?Q?Rf/de/ijL64fG3DnOS60Cqfahsqvlo/OT2yaxUcoWVpyzRDRh5Zg5r4/Cl?=
 =?iso-8859-1?Q?WgrSfgPLVo2UIREQdvTbCuHLV+z+aEN6PGxe3NCHOXZh55F8cyRsl+3oln?=
 =?iso-8859-1?Q?0ChtfZw1xZmPDUKOABDjwDBJKVMBdWbD4Z53btE85aTkwCiEw1XGb4bX3s?=
 =?iso-8859-1?Q?/GQoVoqnq0wsREKuCfrBj1QPtDTsXg1u2noZ/DS7vnk3LuV2NcKhYspjS8?=
 =?iso-8859-1?Q?+ZnnwHQgCH4/2cP8Ul/wGWvvXQLEuggN/cCTZ9thMwWmwvb0vudgTrIPRG?=
 =?iso-8859-1?Q?wQoRkePGFNTxXuVbowk7ZJH2+s29unSK/I9hajG62ovzQ5tIauHwfsJRvF?=
 =?iso-8859-1?Q?9V4g=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0af93922-5d8a-4173-44d5-08d9d42d90bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 11:37:21.2694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HG6Qph+mEOkif0oR1xLqCf3Jv4pUTfnbW/roWZ+OS/TvMBoE//eUvmPl9qJFUgNzcPMB8mBkaAk5KhIfH2QrTB37gDfWpKatPl5QqI0f7TY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4756
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Alexander Lobakin
> Sent: Wednesday, December 8, 2021 7:37 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Song Liu <songliubraving@fb.com>; Alexei Starovoitov <ast@kernel.org>=
;
> Andrii Nakryiko <andrii@kernel.org>; Daniel Borkmann
> <daniel@iogearbox.net>; John Fastabend <john.fastabend@gmail.com>;
> Jesper Dangaard Brouer <brouer@redhat.com>; Yonghong Song
> <yhs@fb.com>; Jesper Dangaard Brouer <hawk@kernel.org>; KP Singh
> <kpsingh@kernel.org>; Jakub Kicinski <kuba@kernel.org>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; David S. Miller
> <davem@davemloft.net>; Bj=F6rn T=F6pel <bjorn@kernel.org>;
> bpf@vger.kernel.org; Martin KaFai Lau <kafai@fb.com>
> Subject: [Intel-wired-lan] [PATCH v4 net-next 5/9] ice: respect metadata =
on
> XSK Rx to skb
>=20
> For now, if the XDP prog returns XDP_PASS on XSK, the metadata will be lo=
st
> as it doesn't get copied to the skb.
> Copy it along with the frame headers. Account its size on skb allocation,=
 and
> when copying just treat it as a part of the frame and do a pull after to =
"move"
> it to the "reserved" zone.
> net_prefetch() xdp->data_meta and align the copy size to speed-up
> memcpy() a little and better match ice_costruct_skb().
>=20
> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
