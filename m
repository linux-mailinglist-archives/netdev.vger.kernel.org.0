Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011C039E089
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhFGPeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:34:14 -0400
Received: from mga18.intel.com ([134.134.136.126]:37747 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230197AbhFGPeM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 11:34:12 -0400
IronPort-SDR: j/TkjKoybiiUQMGzNG2Hp1IwumGfR+KPwKXeiyKzjHg7Nhs9idgau4kT0DsiajT65mIWkIaQli
 DKmf8dcesPrQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="191971623"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="191971623"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 08:32:16 -0700
IronPort-SDR: 83+55YP48jKDSvIPo9GevfU/3jxIycAmRGHECHA+9xnz8jHoyk2Ohcujr6Q0LTcgCf+NSlf+c3
 sLKxR4ltiZtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="440090670"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga007.jf.intel.com with ESMTP; 07 Jun 2021 08:32:15 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 7 Jun 2021 08:32:15 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 7 Jun 2021 08:32:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 7 Jun 2021 08:32:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Mon, 7 Jun 2021 08:32:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ecvwh4heagMoHTEb6QWOqiqHXjVASrpw8YPTw0RGKTdGj8vpkyHrugMfR3v8P/YNkberoT03ebmDYHsWXb01XtmPtPdWna1RRIoVROxnmShb1NoUMltbaoAOIEp9E9infcTDkgpaa0xP1U53FP8UBpuYTtxcbQKGQhsh4p87GPbW5qyOSHvjd0Ngt+dM/m4EwzKSuHdeIbrAIoVpnrsEJTx1ZsS5ORgQHZnqo5xA7ZkOnpj+efk5kpoU7/qfp42XlKv+Xuq1S7OTtpbxr1ZPzUztV6JS9MYcR2KMSkwrfFYsc0Q1Kq2jETEz0zo7XJ62Epaim1l3/v1Wz7njfBg8+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THD/WKQVINWY/J4/kCwisjNlDrK4bq4Po/xF1vTF35c=;
 b=CypRorhfkpq5WUzJ9hWKC9xdVZ8LuflmmPrPasnWJrrACIUa2ZbjcLQnoFP3BDk7hwyuTbxgi+dBEsomzl/rW6HGh4gFRxIUjxtSKK+mNaIYRUT2CE604bzdpyNX3f8pTHXNhRtF9wxnMB2kUYOx2Ny7vEmDhWGZL0nMYRyN3ilEgtisT7n3GPeK7G/bHEV+mIGmlijvl70XHVWVQxhZvoWGxJSwC64LSAk5Ld27aj8NFtay9Thmvjw9LNzosZp4ninNOKDf7zjjcCbXMNHo+AFJZfJpuP52mSPS1hplDY8x+8tXPwxAa8ef/msT3/R6kvKU0rkUh4glJY8ErhWtTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THD/WKQVINWY/J4/kCwisjNlDrK4bq4Po/xF1vTF35c=;
 b=JBnBaNvS7SFk1Q8UDkN6nl8FLOifZ9SBD6uBzpsMZ2x8hISvJGkA5FXt88QNd7DwXRpG2TJH+n+ufvEZXJPFcNxgEws++Uus3PX/V5L78tgOoFRoCsGSUnkcW0+32NIJRvCtj0SJNiU7Zdn02sCigg7KzXRiHNeBkIZ4I+y+D4c=
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM6PR11MB4723.namprd11.prod.outlook.com (2603:10b6:5:2a0::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.20; Mon, 7 Jun 2021 15:32:10 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::ac71:f532:33f7:a9d7]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::ac71:f532:33f7:a9d7%3]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 15:32:10 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v2 intel-net 2/2] ice: parametrize
 functions responsible for Tx ring management
Thread-Topic: [Intel-wired-lan] [PATCH v2 intel-net 2/2] ice: parametrize
 functions responsible for Tx ring management
Thread-Index: AQHXTUQC2ZaCXc4NikWDjO7/8JOhqqsIycSg
Date:   Mon, 7 Jun 2021 15:32:09 +0000
Message-ID: <DM6PR11MB329297990325F28CCF5CD35DF1389@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20210520063500.62037-1-maciej.fijalkowski@intel.com>
 <20210520063500.62037-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20210520063500.62037-3-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [198.175.68.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a816aff-3a4b-43ba-df0d-08d929c96a88
x-ms-traffictypediagnostic: DM6PR11MB4723:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB472324729C1068C53F87D5D4F1389@DM6PR11MB4723.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iAmzjPbF3gEyWut5n15Yc3M5SwIfuFTEGJWpfZme0SA0ILI0cgWDgr7s/xOdlAtLZIT3JjqS7Bg2Hxgl6AjNQPfIDhi1Fwq8xi44YDq6N3kU9+sG7RXSQhod68f+eilUX6xG++Pabv6XOJeFoM6L0dDNZzAsLDz3Dhf3MNc9NGlXQvAgVQcRCFh8l/ITJaYTHHBdTuVoLMG730j/fraPlzXn4Dig/wHRjaf7x4sv6iVEbva9hsfylNwyAo+2mvLGSbXJrqP+PeDBhEQo+X8A4RocjF7XP+NwyR0AcnCszBnhZHAKEuLT4PJEO+k+ZWTfs7VTZnapV2htBz1MP0pKSC8CnV69JtlqZjgqtW2qT6tTCphAEoLDblo6GMJ254KFoxw7z9MDCQ3DmfBVL0urToFnl18CDatr0WJ9FwsvuqUN6TWALY9cdrodVaVofjQ/Nr1vHW62fV0wKUYeGi55KTZ2xlvuan/IQGjouF236tp+j+t9Rk6B58mv4Ji8xl9uX4f7gcZ7xPbbbH8te8bp1ZIhHhqO2juLCDiqQSvSFx+ipfp3wRglXcvvA5baF5J4264ZnT+gm+gt5pNphCMBN7tfT2ARsHX21JBaVUi9Ppc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(39860400002)(346002)(396003)(478600001)(55016002)(83380400001)(4326008)(9686003)(53546011)(6506007)(52536014)(66946007)(66476007)(64756008)(66556008)(5660300002)(66446008)(26005)(122000001)(38100700002)(33656002)(8936002)(2906002)(76116006)(316002)(8676002)(86362001)(107886003)(54906003)(110136005)(7696005)(71200400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?yVjq7fhrD20T5wgdKbqJ03Gm5TKAI+me9YopmL77R70GcnCsn3bpF30pAl2T?=
 =?us-ascii?Q?jDG2FDr3nDuncWPGcWsnEeV9H3eXgnuq30bqcNQIKo61TFu7/cQVazSZX04p?=
 =?us-ascii?Q?IpCQhEVmk2ySqWsSMXBa8iKVWdLj4pC1kXbvhPbPpNQbIeF24XVoavvnBN9v?=
 =?us-ascii?Q?5vqTvIzIyFXv9r0xYSudFUk653Q2VUPeyEdqWrSazRGw+QcDo0YAkrvyWEfU?=
 =?us-ascii?Q?6NHRycGX20IjmVaF1h/o495WMyyW/2jaGNRJwdrLJMUeQNOX5BkQpGgLzkF7?=
 =?us-ascii?Q?QmDIzM0aqe3uVrZwey1ehxBZfdHGBqmIi2cfPG7/venTJhF+aoXDVQvHs8RF?=
 =?us-ascii?Q?AIsHB4F0QncHZ+ZKNvdjSu78PHH4/bsC9gOR2yRV2QzqdoroiHPcQR0/+4UK?=
 =?us-ascii?Q?ijG25maObdyB0+V5jbBGNBGhS+kiRcOznR/imhdiDZPh7gN/TcQBsz55N9x4?=
 =?us-ascii?Q?b1wV7fw5rUA/8YJ9FwTmajiBL1P6zMX9/gzDARYEjjB25V1RTUMh3ecu93GA?=
 =?us-ascii?Q?MfpkR6a5GFIaT0yQNP6XixEgNySG0I5sy4UTzWR5yN8eCYWTG1LGqNqKbsC+?=
 =?us-ascii?Q?yoKD1U0I/T4cxfmGgpvcgF8m3ijtyUqNHhIXFWZ+XEDgK4Y0cxuo+c51M7sn?=
 =?us-ascii?Q?KRYikAiagAKcLLOy/taTrZg/lOJ6GJ6H7zMfzJa0kWkw/VTN08etb27ESVJj?=
 =?us-ascii?Q?gMEpD/f0hF4i7j8b23bSYkok0q3bXC30kf4zwvvj8Y/wBGdS4bQeSOQapt72?=
 =?us-ascii?Q?C2I1qxrB11NEF8W57mZBFq2M4PjytvoQFnmlHPR9TMxG9q8Ry+EjLNN5yblU?=
 =?us-ascii?Q?/MOw3iDXqJ8wevXFd5IhCpiqGyz9+geO0kenqYcjPi9cmxiBRpXErw2urzZz?=
 =?us-ascii?Q?1LuVoLJQDbi/HRI/y/LuT5h1OhGsCIJwVpZLR7gYTvxtth2dCnbQEKunngPM?=
 =?us-ascii?Q?32GrmBVYGo0X5rmD6F6OGVLlsdL2ZpzBCZAiu1H8a74wB5XqJkymrZ7RGmnn?=
 =?us-ascii?Q?HNukZgCOLnLGatFAsN5b/EzlX7eNs8dhin9u16w6A+FXJ7t6H/JmeJJAzFQ3?=
 =?us-ascii?Q?+lnuAH4rvAy18ZfCixpYfW765lm6OWojli7poYdrMzHZwds7D36rY4GuYZ1g?=
 =?us-ascii?Q?nrUjOhkM0lHgnh0oeH3qwLU9myj1THetjfbfqWAPi/DMP46VJK32yOV7MR2S?=
 =?us-ascii?Q?wZbZoRfnP5VP8tN3NGWrkwShFteCOFJ9vO8r0Tuc+AQg5kQCKsWhR7J52agZ?=
 =?us-ascii?Q?hKyRwe47F2IIvHCxPKK5WRPPLHu5S8zY+vuZFOhdrGMrCHRW2lMET5rsAKXD?=
 =?us-ascii?Q?v9+czwjzRNytqTF9wLAuT4ZI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a816aff-3a4b-43ba-df0d-08d929c96a88
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 15:32:10.0429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z0IW3z8klcThaHi4HMJXG8yW0wTz1Ekompk9LT3W4pDiNCs1nCkK+koJeT0t5YANDjbWXqsi/eDhGFU8U1tFPfy6bEDskYOLcCuTZ5sHAZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4723
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Thursday, May 20, 2021 12:05 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; bjorn@kernel.org; kuba@kernel.org;
> bpf@vger.kernel.org; davem@davemloft.net; Karlsson, Magnus
> <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v2 intel-net 2/2] ice: parametrize func=
tions
> responsible for Tx ring management
>=20
> Commit ae15e0ba1b33 ("ice: Change number of XDP Tx queues to match
> number of Rx queues") tried to address the incorrect setting of XDP queue
> count that was based on the Tx queue count, whereas in theory we should
> provide the XDP queue per Rx queue. However, the routines that setup and
> destroy the set of Tx resources are still based on the
> vsi->num_txq.
>=20
> Ice supports the asynchronous Tx/Rx queue count, so for a setup where
> vsi->num_txq > vsi->num_rxq, ice_vsi_stop_tx_rings and ice_vsi_cfg_txqs
> will be accessing the vsi->xdp_rings out of the bounds.
>=20
> Parametrize two mentioned functions so they get the size of Tx resources
> array as the input.
>=20
> Fixes: ae15e0ba1b33 ("ice: Change number of XDP Tx queues to match
> number of Rx queues")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
