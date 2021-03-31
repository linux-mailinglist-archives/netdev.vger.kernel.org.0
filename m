Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06E2350386
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 17:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235719AbhCaPdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 11:33:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:34325 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235674AbhCaPdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 11:33:14 -0400
IronPort-SDR: CF8SCsSqSRbHLE3s7DzqihiCJfQ3MuLw8QwAIjs7SIU102RprpwkOsdJuH2Xg5wiZrhJX8mgOO
 TwrkJPsi/4Tg==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="192053393"
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="192053393"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 08:33:11 -0700
IronPort-SDR: b+u0o+Bzcc7wvmJYwHoT9SjeVmrpAzAcGIWO8pYEJBZhn/Zl6+oJH8n1DxJGq83ux9lAUCQ6kD
 RplH7cb/qaeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="377311939"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 31 Mar 2021 08:33:10 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 31 Mar 2021 08:33:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 31 Mar 2021 08:33:10 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.55) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 31 Mar 2021 08:33:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xzh9P80+eoxqg8Q1pdBj5+C5I6YykFw77AHT8L+NRKIQchkqxX1rTIDTSR/x6zRZy/LvQCWPniKMsTr83WhHUV5A/ejmbIP+H2EcPwnEwi1Zv63lMXmHxJ0ZJvVsuhk2BSkrOKiVx2B7X0UZbNsZ37XMukKsqkBm40mV15Op5tlSn0tFRwmhMbf9iLSyrqtDZjbFZ1/mJ02H1oQ++3mLVXJjYscuP7K/scXLHb1dIEj0msA8cjTkRmDRwU8blXtzy6nke+6BllJ15cXvS3BAPmkj4OSKTTluCbyZDnizvdbdoCkBjSHHFOJW5s0HbfuMBTXzXTDp+AgwShj007Uw5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NRCbm0tCTIg7bwVPUrjMd87vRAi8e4mOdHuN6rtGkcw=;
 b=MOxnaUeZIG5/3yAMd2MBn0ciAU3mrp8dxzbKR+5ExyMM+kq2E4o3EVURPC5qXaDUkwKxotfNUb7sc4uZOe7LZsMidVE2insocNVB1M+ANYCauC9Rk6j+qZnHAt/SLIqKW+WSURr7jhpUCzNYUSJA2TN4SbjIR4elVOhk5JVThvWo3eAKLsnX31KUopCa9NIMWJi1m53bhCilmxOqEuHBbjSfXD8UAQOcjGKYtUGmNFZMAQq1EvmGK6/PF10cjsVVDi1UWN76mP8xmo1Kd79hHu+/A9RtaU7Hb/xxlq0KzMWF5Oe6J6FQzHC0MGXoR58vhMTj/oT9hISLCfSp+2EnYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NRCbm0tCTIg7bwVPUrjMd87vRAi8e4mOdHuN6rtGkcw=;
 b=YZCrrW+mc6MSBbVegqFsPWhhqdjVW0JSPJoKuKrcCQt/B29NW3LEsvgvl7/9Ywm34hU+oyPnHrTw+ALLFWc7AroyzYhG8/3D2lXLoBCAsSzjKKCS9Z078oiSbaS41FUDqhzt38gW8lUIMTCg+AkAVraPgr2n87RPxkRU/yaC2Y8=
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM5PR1101MB2153.namprd11.prod.outlook.com (2603:10b6:4:56::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.28; Wed, 31 Mar 2021 15:32:59 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::dcb3:eed0:98d1:c864]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::dcb3:eed0:98d1:c864%7]) with mapi id 15.20.3977.033; Wed, 31 Mar 2021
 15:32:59 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
CC:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH net-next v3 0/6] stmmac: Add XDP support
Thread-Topic: [PATCH net-next v3 0/6] stmmac: Add XDP support
Thread-Index: AQHXJkL6V6DW7zDlgUy0wbB2MEpyE6qeOZpQ
Date:   Wed, 31 Mar 2021 15:32:58 +0000
Message-ID: <DM6PR11MB27802A13B4946C51570664DFCA7C9@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20210331153541.1892-1-boon.leong.ong@intel.com>
In-Reply-To: <20210331153541.1892-1-boon.leong.ong@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
authentication-results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [42.189.169.167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7dac727-cf0b-42be-9065-08d8f45a438b
x-ms-traffictypediagnostic: DM5PR1101MB2153:
x-microsoft-antispam-prvs: <DM5PR1101MB215321EE7ED418BB6CB2A7BFCA7C9@DM5PR1101MB2153.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i+r9cLtIJqFf5uNwE/vFdHlzWWxVfa/2Y5Al06Lf+cgb5hRjdeg+DgVwjN93mDYd959FySik0FfWGqbRE3+WkK/JIXEWUP6B8N7M/WqyeDCKmdGRsXDS2DINw6Lcop04rz6UPyKlmtJmZuanmUv04kPnLSnMUgByC8nOFq1XWrxjU//FxftoSF1c/W5yXN6eRYEFivCYQie58901zQr3petdIbg2vvevIPtLtkroEk71Xyul7PYRRQutjOBlSvEKd9rcOqEtfSeFe+JinLzw2yCypE3e/jcazPYiDlsycKBIEpB1iyzcSmWgshuXZ4iO/6EIoXlo8e3kBjO/8WzDzm8jQPni7u7T+gkcfQbqog0TVqaOG0GygSiseOop9oloWLAomOlNfv9tfc7bQ1EfXSIRAB1llzN6SCVDm1b+5I8s+eVnObLoqxyxbsL6Wakhd3PQCgJR226kmWj7E7lY7a5X0Mam19txek9UN0nv9ImIoD3gxcvNKa830DLmYNSucub83ptTIOFDGChIRvhGGkkLo9OMqTo2kYHZFhLI6hA+cO4fx0XqEpL43ar/flYuwHwbx4Cc1kEpdXTSYqGZKm2Wtn+JU/afuujkQACerKYfNVNJhUAXKuWmoR8jcYAnYllauRiGlqVYCBEOAOAUcgZaZOQKs3gnzCBp06rWbdfDiCJOfwhrSiGM0jc2cHYO8laIiiJfyC93jfFkiYr+WroV841YuxbzJBTDllt7jfg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(136003)(39860400002)(396003)(52536014)(186003)(71200400001)(33656002)(5660300002)(4326008)(66476007)(478600001)(66446008)(64756008)(66556008)(316002)(26005)(76116006)(110136005)(54906003)(66946007)(966005)(38100700001)(7416002)(8936002)(9686003)(6506007)(86362001)(55016002)(7696005)(8676002)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S25reEVrWCtrdmdxNVphcUpCUlY3a2pac1FFNEQ4Z2ZYdkVTbDNHeDl4bnU4?=
 =?utf-8?B?RmxLc2xxdURNQ2M2T1FoVzNpbG9ZYllZSFRkV1BlMFVveDFKMWxHZ1UrL0JC?=
 =?utf-8?B?ZGhUaVlHc1ZkbnJqV0RNUDNEMG9jblJPZ01ydE5RYlZjNWMrQVBtOVZqRHNh?=
 =?utf-8?B?KzREMVM5UWJCcmtTZTZIdGhtdWQxekk1ZE9LclR3QXZsbU9mQUtqcXhDZEFn?=
 =?utf-8?B?U2J3SnN1dDBlSkptbDVHU3Q1cDNrSGpaSXU4cEgxRFF4dWRoOCtiTm0zUHlS?=
 =?utf-8?B?cEVYWTdRaDdScWV2cFFpaDAwMGhFYmVhRTl2ZURYYUI0cktVQ09jajE4N3RC?=
 =?utf-8?B?ME9CT3FlckpNV0JhZmVXeFVsRU92RmNuTWVIWDU0TkR0RjJrSGtOcUduVVRC?=
 =?utf-8?B?cWJmVEdLME9ERjNDck00RFNkUElzaGNycmdmbStGck51TmdlWTdjZlFzaDRh?=
 =?utf-8?B?cGdyZUl2YXhOckdPQUFDbFdocGRUVzBOZU1VTHVtS056V2d5aGd1MTFzYjRw?=
 =?utf-8?B?cWlQYmFxMlVFK3JMeDFTeHoxVEJ4ZURWeHFqRVlPWWlWOHRySktHN3B6WjBH?=
 =?utf-8?B?NDB5dUVLTWM1dmJlZXpJalpuK2dsWkcxc1JZbGpqcG1JREc2UkpWRzFBYStT?=
 =?utf-8?B?cWZ5QW9aOHhXYktieTMwZHlXc2x0RkEzdkNiTTJGb2oxQ1lMVWNsTCs1KzR2?=
 =?utf-8?B?VkJ1ZWRGbjJ5VlJEUHJZcWFsZkZVeGUyclBxdVUyUEZLQTN4L1lDN2NKUFlB?=
 =?utf-8?B?akV0ZEVYQzdNTXN4ZklxRnhvaWdXL1o4UFBLRVU3NXVYZVp2L2hTL0JQTmZ1?=
 =?utf-8?B?NXNLNE1oVlUveEJlQXZnRHU4TE5zd3c3d240M0lYd2ZCT2RGcXFYK0RUUFhJ?=
 =?utf-8?B?VnFwZWRsYnNBbTJtQ0t2VXJJZFVkWm9HL2FpemI1VlVPTWI1Rnp4MzgyUlhT?=
 =?utf-8?B?QjRGU0NLUlVTeGE3ZnhPcVVQNkhFTHRrcmRyV1BrMFk3bXJJY2lrOTF5RDRx?=
 =?utf-8?B?eXV2cktuOTVvd2V3am12UUI5YldCNWZrNnF1NHcvR0JTMXVRQUl6dk9jeURX?=
 =?utf-8?B?QmF2YTNyeEZ0TEc1OElycU1FRWQ0NWdNVUI5eUdYeldheEI4aTBBOERqb1RG?=
 =?utf-8?B?ZzFuanh2TS92WTBKTEtoM3RlRDJDb0JCWGN6dTBNWkp4VXkyTWtVbXR5eEFN?=
 =?utf-8?B?dU9KUzNkQk9mM1B6L3Bkb1RTSU1TTU5UVDJLdkxjS1RXV3pGTm0wLzU3MExk?=
 =?utf-8?B?WjFXWTJlL2VoWGJXOC8vb0dSemNqbG5mM3ozbjc4blNlVnZkanFOQndTVVZK?=
 =?utf-8?B?MStMbzNJZ28yRUdyNlJvbStrSytodHFPem54VU55UkVKS3dHYWRWRUhvN2E1?=
 =?utf-8?B?TDltS1pIdW84RFgwcXYzQmY3czcxUFJLekRrRmJOM0Y1ak5rek9BbkR6REdh?=
 =?utf-8?B?dVYzSy9LKzVzQ1Z0d1poUE5EanZ5UlRyLzUyODJwT1JwY3Y3cDdZK3d2Tk5E?=
 =?utf-8?B?dDR3M1duZ3JuZzYrRHI3WTlvTmhUNW5UYjRNWG9TdXFoTmNMc2lHckJYdDQr?=
 =?utf-8?B?QkhxNWIzYk1DN3dFQVZMakM1cDQ2ZHdCRWFMd3doMGMrV29oT1d1aXJ6cTU5?=
 =?utf-8?B?MGt6cFc5dlNFeDVhU2IxUmN0NjI2UXlhUGdHN0xwVnhuQjZNMy9KMWVEK0JM?=
 =?utf-8?B?U01OT281NmZFSmRsU3JRUEppdVVZaVcxRXQxcEdzNzVTS0tVNVpLZUNXNTFZ?=
 =?utf-8?Q?0hvIWO6skz7f++3LcYCDD23Mr5+dVTX5yAU8VTt?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7dac727-cf0b-42be-9065-08d8f45a438b
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 15:32:58.9399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ti4hoeMES6kQ6xDw85TRxRxQ026G/aUJH6wr4SVhgVkjxilgvrDqOwqxFB2otpGPkb0NhEfFj2i4e1mN/yMiVtL4YZZPQ2XNpk95+kevfgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2153
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UGxzIGlnbm9yZSB0aGlzLiBJIHdpbGwgcmVzZW5kIHRoZSByZWFsIHYzLiBTb3JyeSBmb3IgZ2xp
dGNoIG9uIG15IHBhcnQuIA0KDQo+LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj5Gcm9tOiBP
bmcsIEJvb24gTGVvbmcgPGJvb24ubGVvbmcub25nQGludGVsLmNvbT4NCj5TZW50OiBXZWRuZXNk
YXksIE1hcmNoIDMxLCAyMDIxIDExOjM2IFBNDQo+VG86IEdpdXNlcHBlIENhdmFsbGFybyA8cGVw
cGUuY2F2YWxsYXJvQHN0LmNvbT47IEFsZXhhbmRyZSBUb3JndWUNCj48YWxleGFuZHJlLnRvcmd1
ZUBzdC5jb20+OyBKb3NlIEFicmV1IDxqb2FicmV1QHN5bm9wc3lzLmNvbT47IERhdmlkIFMgLg0K
Pk1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5l
bC5vcmc+OyBBbGV4ZWkNCj5TdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+OyBEYW5pZWwgQm9y
a21hbm4gPGRhbmllbEBpb2dlYXJib3gubmV0PjsNCj5KZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIDxo
YXdrQGtlcm5lbC5vcmc+OyBKb2huIEZhc3RhYmVuZA0KPjxqb2huLmZhc3RhYmVuZEBnbWFpbC5j
b20+DQo+Q2M6IE1heGltZSBDb3F1ZWxpbiA8bWNvcXVlbGluLnN0bTMyQGdtYWlsLmNvbT47IEFu
ZHJpaSBOYWtyeWlrbw0KPjxhbmRyaWlAa2VybmVsLm9yZz47IE1hcnRpbiBLYUZhaSBMYXUgPGth
ZmFpQGZiLmNvbT47IFNvbmcgTGl1DQo+PHNvbmdsaXVicmF2aW5nQGZiLmNvbT47IFlvbmdob25n
IFNvbmcgPHloc0BmYi5jb20+OyBLUCBTaW5naA0KPjxrcHNpbmdoQGtlcm5lbC5vcmc+OyBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1zdG0zMkBzdC1tZC0NCj5tYWlsbWFuLnN0b3JtcmVw
bHkuY29tOyBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IGxpbnV4LQ0KPmtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGJwZkB2Z2VyLmtlcm5lbC5vcmc7IE9uZywgQm9vbiBMZW9u
Zw0KPjxib29uLmxlb25nLm9uZ0BpbnRlbC5jb20+DQo+U3ViamVjdDogW1BBVENIIG5ldC1uZXh0
IHYzIDAvNl0gc3RtbWFjOiBBZGQgWERQIHN1cHBvcnQNCj4NCj5IaSwNCj4NCj5UaGlzIGlzIHRo
ZSB2MyBwYXRjaCBzZXJpZXMgZm9yIGFkZGluZyBYRFAgc3VwcG9ydCB0byBzdG1tYWMgZHJpdmVy
Lg0KPg0KPlN1bW1hcnkgb2YgdGhlIGNoYW5nZXMgaW4gdjMgKHBlciBmZWVkYmFjayBmcm9tIEph
a3ViIEtpY2luc2tpKTotDQo+DQo+NC82OiBGYWN0b3IgaW4gWERQIGJ1ZmZlciBoZWFkZXIgYW5k
IHRhaWwgYWRqdXN0bWVudCBieSBYRFAgcHJvZy4NCj4NCj41LzY6IEFkZGVkICducS0+dHJhbnNf
c3RhcnQgPSBqaWZmaWVzJyB0byBhdm9pZCBUWCB0aW1lLW91dCBmb3IgWERQX1RYLg0KPg0KPjYv
NjogQWRkZWQgJ25xLT50cmFuc19zdGFydCA9IGppZmZpZXMnIHRvIGF2b2lkIFRYIHRpbWUtb3V0
IGZvcg0KPiAgICAgbmRvX3hkcF94bWl0Lg0KPg0KPkkgcmV0ZXN0ZWQgdGhpcyBwYXRjaCBzZXJp
ZXMgb24gYWxsIHRoZSB0ZXN0IHN0ZXBzIGxpc3RlZCBpbiB2MSBhbmQgdGhlDQo+cmVzdWx0cyBs
b29rIGdvb2QgYXMgZXhwZWN0ZWQuIEkgYWxzbyB1c2VkIHhkcF9hZGp1c3RfdGFpbCB0ZXN0IGFw
cCBpbg0KPnNhbXBsZXMvYnBmIGZvciBjaGVja2luZyBvdXQgWERQIGhlYWQgYW5kIHRhaWwgYWRq
dXN0bWVudCBpbnRyb2R1Y2VkIGluDQo+NC82IGFuZCB0aGUgcmVzdWx0IGJlbG93IGxvb2tzIGNv
cnJlY3QgdG9vLg0KPg0KPg0KPiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjDQo+IyMjIyMjIyMjIyMjIw0KPg0KPkRVVCA+IHJvb3RAaW50
ZWwtY29yZWk3LTY0On4gJCAuL3hkcF9hZGp1c3RfdGFpbCAtaSBldGgwIC1QIDQwMCAtTg0KPj09
PT09PT09PT09PT09PT09PT09PT09PT09DQo+aWNtcCAicGFja2V0IHRvbyBiaWciIHNlbnQ6ICAg
ICAgICAgIDAgcGt0cw0KPmljbXAgInBhY2tldCB0b28gYmlnIiBzZW50OiAgICAgICAgICAwIHBr
dHMNCj5pY21wICJwYWNrZXQgdG9vIGJpZyIgc2VudDogICAgICAgICAgMCBwa3RzDQo+aWNtcCAi
cGFja2V0IHRvbyBiaWciIHNlbnQ6ICAgICAgICAgIDAgcGt0cw0KPmljbXAgInBhY2tldCB0b28g
YmlnIiBzZW50OiAgICAgICAgICAxIHBrdHMNCj5pY21wICJwYWNrZXQgdG9vIGJpZyIgc2VudDog
ICAgICAgICAgMSBwa3RzDQo+aWNtcCAicGFja2V0IHRvbyBiaWciIHNlbnQ6ICAgICAgICAgIDEg
cGt0cw0KPmljbXAgInBhY2tldCB0b28gYmlnIiBzZW50OiAgICAgICAgICAyIHBrdHMNCj5pY21w
ICJwYWNrZXQgdG9vIGJpZyIgc2VudDogICAgICAgICAgNCBwa3RzDQo+aWNtcCAicGFja2V0IHRv
byBiaWciIHNlbnQ6ICAgICAgICAgIDYgcGt0cw0KPmljbXAgInBhY2tldCB0b28gYmlnIiBzZW50
OiAgICAgICAgICA4IHBrdHMNCj5pY21wICJwYWNrZXQgdG9vIGJpZyIgc2VudDogICAgICAgICAg
OSBwa3RzDQo+aWNtcCAicGFja2V0IHRvbyBiaWciIHNlbnQ6ICAgICAgICAgMTAgcGt0cw0KPmlj
bXAgInBhY2tldCB0b28gYmlnIiBzZW50OiAgICAgICAgIDEwIHBrdHMNCj4NCj5MUCA+IHJvb3RA
aW50ZWwtY29yZWk3LTY0On4jIHBpbmcgMTY5LjI1NC4xLjExIC1zIDMwMA0KPlBJTkcgMTY5LjI1
NC4xLjExICgxNjkuMjU0LjEuMTEpIDMwMCgzMjgpIGJ5dGVzIG9mIGRhdGEuDQo+MzA4IGJ5dGVz
IGZyb20gMTY5LjI1NC4xLjExOiBpY21wX3NlcT0xIHR0bD02NCB0aW1lPTEuMTcgbXMNCj4zMDgg
Ynl0ZXMgZnJvbSAxNjkuMjU0LjEuMTE6IGljbXBfc2VxPTIgdHRsPTY0IHRpbWU9MC41NzUgbXMN
Cj4zMDggYnl0ZXMgZnJvbSAxNjkuMjU0LjEuMTE6IGljbXBfc2VxPTMgdHRsPTY0IHRpbWU9MC41
ODIgbXMNCj4zMDggYnl0ZXMgZnJvbSAxNjkuMjU0LjEuMTE6IGljbXBfc2VxPTQgdHRsPTY0IHRp
bWU9MC41OTUgbXMNCj4zMDggYnl0ZXMgZnJvbSAxNjkuMjU0LjEuMTE6IGljbXBfc2VxPTUgdHRs
PTY0IHRpbWU9MC41ODUgbXMNCj4zMDggYnl0ZXMgZnJvbSAxNjkuMjU0LjEuMTE6IGljbXBfc2Vx
PTYgdHRsPTY0IHRpbWU9MC41OTEgbXMNCj4zMDggYnl0ZXMgZnJvbSAxNjkuMjU0LjEuMTE6IGlj
bXBfc2VxPTcgdHRsPTY0IHRpbWU9MC41OTkgbXMNCj5eQw0KPi0tLSAxNjkuMjU0LjEuMTEgcGlu
ZyBzdGF0aXN0aWNzIC0tLQ0KPjcgcGFja2V0cyB0cmFuc21pdHRlZCwgNyByZWNlaXZlZCwgMCUg
cGFja2V0IGxvc3MsIHRpbWUgNjEwM21zDQo+cnR0IG1pbi9hdmcvbWF4L21kZXYgPSAwLjU3NS8w
LjY3MC8xLjE2Ni8wLjIwMiBtcw0KPg0KPkxQID4gIHJvb3RAaW50ZWwtY29yZWk3LTY0On4jIHBp
bmcgMTY5LjI1NC4xLjExIC1zIDUwMA0KPlBJTkcgMTY5LjI1NC4xLjExICgxNjkuMjU0LjEuMTEp
IDUwMCg1MjgpIGJ5dGVzIG9mIGRhdGEuDQo+RnJvbSAxNjkuMjU0LjEuMTEgaWNtcF9zZXE9MSBG
cmFnIG5lZWRlZCBhbmQgREYgc2V0IChtdHUgPSA0MzYpDQo+RnJvbSAxNjkuMjU0LjEuMTEgaWNt
cF9zZXE9MiBGcmFnIG5lZWRlZCBhbmQgREYgc2V0IChtdHUgPSA0MzYpDQo+RnJvbSAxNjkuMjU0
LjEuMTEgaWNtcF9zZXE9MyBGcmFnIG5lZWRlZCBhbmQgREYgc2V0IChtdHUgPSA0MzYpDQo+RnJv
bSAxNjkuMjU0LjEuMTEgaWNtcF9zZXE9NCBGcmFnIG5lZWRlZCBhbmQgREYgc2V0IChtdHUgPSA0
MzYpDQo+RnJvbSAxNjkuMjU0LjEuMTEgaWNtcF9zZXE9NSBGcmFnIG5lZWRlZCBhbmQgREYgc2V0
IChtdHUgPSA0MzYpDQo+RnJvbSAxNjkuMjU0LjEuMTEgaWNtcF9zZXE9NiBGcmFnIG5lZWRlZCBh
bmQgREYgc2V0IChtdHUgPSA0MzYpDQo+DQo+DQo+IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMNCj4jIyMjIyMjIyMjIyMjDQo+DQo+SGlz
dG9yeSBvZiB0aGUgcHJldmlvdXMgcGF0Y2ggc2VyaWVzOg0KPg0KPnYyOiBodHRwczovL3BhdGNo
d29yay5rZXJuZWwub3JnL3Byb2plY3QvbmV0ZGV2YnBmL2xpc3QvP3Nlcmllcz00NTc3NTcNCj52
MTogaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L25ldGRldmJwZi9saXN0Lz9z
ZXJpZXM9NDU3MTM5DQo+DQo+SXQgd2lsbCBiZSBncmVhdCBpZiBjb21tdW5pdHkgY2FuIGhlbHAg
dG8gdGVzdCBvciByZXZpZXcgdGhlIHYzIHBhdGNoDQo+c2VyaWVzIG9uIHlvdXIgcGxhdGZvcm0g
YW5kIHByb3ZpZGUgbWUgYW55IG5ldyBmZWVkYmFjayBpZiBhbnkuDQo+DQo+VGhhbmsgeW91IHZl
cnkgbXVjaC4NCj5Cb29uIExlb25nDQo+DQo+T25nIEJvb24gTGVvbmcgKDYpOg0KPiAgbmV0OiBz
dG1tYWM6IHNldCBJUlEgYWZmaW5pdHkgaGludCBmb3IgbXVsdGkgTVNJIHZlY3RvcnMNCj4gIG5l
dDogc3RtbWFjOiBtYWtlIFNQSCBlbmFibGUvZGlzYWJsZSB0byBiZSBjb25maWd1cmFibGUNCj4g
IG5ldDogc3RtbWFjOiBhcnJhbmdlIFR4IHRhaWwgcG9pbnRlciB1cGRhdGUgdG8NCj4gICAgc3Rt
bWFjX2ZsdXNoX3R4X2Rlc2NyaXB0b3JzDQo+ICBuZXQ6IHN0bW1hYzogQWRkIGluaXRpYWwgWERQ
IHN1cHBvcnQNCj4gIG5ldDogc3RtbWFjOiBBZGQgc3VwcG9ydCBmb3IgWERQX1RYIGFjdGlvbg0K
PiAgbmV0OiBzdG1tYWM6IEFkZCBzdXBwb3J0IGZvciBYRFBfUkVESVJFQ1QgYWN0aW9uDQo+DQo+
IGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL01ha2VmaWxlICB8ICAgMSArDQo+
IGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hYy5oICB8ICAzNSArLQ0K
PiAuLi4vbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMgfCA1MjkgKysr
KysrKysrKysrKysrLQ0KPi0tDQo+IC4uLi9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3Rt
bWFjX3hkcC5jICB8ICA0MCArKw0KPiAuLi4vbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0
bW1hY194ZHAuaCAgfCAgMTIgKw0KPiA1IGZpbGVzIGNoYW5nZWQsIDUzNyBpbnNlcnRpb25zKCsp
LCA4MCBkZWxldGlvbnMoLSkNCj4gY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L2V0aGVy
bmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY194ZHAuYw0KPiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJp
dmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX3hkcC5oDQo+DQo+LS0NCj4y
LjI1LjENCg0K
