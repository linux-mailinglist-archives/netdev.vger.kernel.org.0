Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FC330838D
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 03:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhA2CGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 21:06:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:58039 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229627AbhA2CGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 21:06:14 -0500
IronPort-SDR: hIXfG30QHlhsEXQ19MTguZbMMeTFQJj31sB6mwSEP+kkpUieoUFgKZWPKXa8tMg7KjJlJDgVtv
 oJORm7/Q3eiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="180490185"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="180490185"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 18:05:28 -0800
IronPort-SDR: ml1GMd+51piw56cSSQ8PG43llJlP/zkM1ixRF12qlG1uCBAToNi67OrEDz6zcm2km9pU9crWnQ
 d/hkY/RQjFZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="573867347"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 28 Jan 2021 18:05:28 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 28 Jan 2021 18:05:27 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 28 Jan 2021 18:05:27 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 28 Jan 2021 18:05:27 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 28 Jan 2021 18:05:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgJNEyU6tu7DAU2o4cPHNrKLVQmRO/IWYUVvjwQ78s96GsjqUBoMKJcBArtCVZT7ilyLR1VKGloO8GbF0K7QXPqkp1JnWvK+duis1LD2q7B3YzEMXIbBGWxd6py+FiT03tlQrqKzSwG2TXbEckOo06HhAah4MGFJLdwfA3AKSY+xzuDc6t+7NkObOfurhOpeSCZgZHOZ4/XzaEXLuxQ/rMqQDmKgE9Ulzch6M+p9p8DpcDJjCxUf10GqqqNOl9Ud9b5V30UmRXdaqPLHKdWco4X2pFF8swXKHqbAvlZE6RZThLkVdZx013LKz3tXsjdqsmi/YCHE4bxMfxPx9kSW2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKORvpjFMdJbfF02kVhPzBucXuNpuT3afAxYLXyhxk8=;
 b=Rhem8IujqBpuYloSu/12mIFOlZTgCcKvtcaj0nFRO3/Cte6wPJkUGd0HmahEROELi0wRhGsCA5KErk/oWPFlgKisB/MtmFxJyglizspCACyu6etVpFG7Ar8OQah+oha5XNtdxzvegbbWz5K8mYYmJt7JijiiUJWPnd2b/57TxWs96JVKYY5EEKtY8Vq8FIwnR00Yp5m8kjtb41YEkHVWWpkgHJbFOINR41uDToGrlhlM7/XSuqUSqLKwj/fV222bPYlcYD2LfETirfc6XR+FmwCSdXKuyizmuJ5baT3gRm0kkGRTANplBRqcLJfsgnRj0AKGqVsg18GqYMIy184o8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKORvpjFMdJbfF02kVhPzBucXuNpuT3afAxYLXyhxk8=;
 b=uy1pi94xX0n4Wy1IBqppr/XcbBhZdIJD6omuf30DxR55kPrktj0+MtaKRt+A7pfEzMGI0TXSTK6s2T99E+nwX/B8oCGx0KQDJEvRhTTMxShj+rwXAUxlerPARLnoq56ru/Zgyd1Uuw3cdl8n0RZ0EfeBuutnxMFTlBbLl+PLN40=
Received: from SA0PR11MB4558.namprd11.prod.outlook.com (2603:10b6:806:9e::12)
 by SN6PR11MB2976.namprd11.prod.outlook.com (2603:10b6:805:d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 02:05:24 +0000
Received: from SA0PR11MB4558.namprd11.prod.outlook.com
 ([fe80::b940:a037:a4d8:1319]) by SA0PR11MB4558.namprd11.prod.outlook.com
 ([fe80::b940:a037:a4d8:1319%9]) with mapi id 15.20.3805.017; Fri, 29 Jan 2021
 02:05:24 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     "patchwork-bot+netdevbpf@kernel.org" 
        <patchwork-bot+netdevbpf@kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] stmmac: intel: Configure EHL PSE0 GbE and PSE1 GbE to
 32 bits DMA addressing
Thread-Topic: [PATCH net] stmmac: intel: Configure EHL PSE0 GbE and PSE1 GbE
 to 32 bits DMA addressing
Thread-Index: AQHW88tDQtUpuEdQyEWv+Jmd5eCfy6o9jyKAgABOvAA=
Date:   Fri, 29 Jan 2021 02:05:24 +0000
Message-ID: <SA0PR11MB4558209CFC8BF8373D0B2532D5B99@SA0PR11MB4558.namprd11.prod.outlook.com>
References: <20210126100844.30326-1-mohammad.athari.ismail@intel.com>
 <161186881130.25673.3724673380406985947.git-patchwork-notify@kernel.org>
In-Reply-To: <161186881130.25673.3724673380406985947.git-patchwork-notify@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [42.189.202.169]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72823ebf-cdcf-4aef-4db6-08d8c3fa570e
x-ms-traffictypediagnostic: SN6PR11MB2976:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB297603E25EB6412058E0C527D5B99@SN6PR11MB2976.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P2qYG02kgmFEkKD6+S/qSErjS+U3Qld8dG3N9wbysVZrNKKzYcAnuyjK01vq95vwh8uTimg1ZWd5jFf8sqEdI8kJKBoc7OludHrrUPCXnotsMMyRkhNht7pjb5697ndy24JrX+PEb4KhE+70W9beXrcFJ11nmz4nUN3DRmokKOPoD9zE+IVRE2rsB2IH8FCxDtR6yeCPcgyu/J/Ujr2wlQC/2ONr9iQN5uJcqquRQNl+iZyOpgag03BwN/PLkmYlE5t20J1p2N1SJ17UZq1qH2qXgkeXIhMrTBy6CRfdU1B6DdH+GRU1SkfXDJR1l84qXzGKbmiLKIWe5DKBs75PVLuNYFgqsdKdZbztuZJYD6ko49+N7cTzqb/zmW4sszLGgUTsMZIjXIqaDFiTQHQoXkxS5FqKcRoN/k7KlhH5iexHs04Pg0ABYpw9JkLA0scZg+IVXbCFSLAF0X1BQqwS1sB7AcdXmCrZQM080m7/3nc4Z+2itZ5Yf50h6AKKO8rSDemJtNqf4Vtk0Lw4MCY2BNFF7qSPQghTWxK6mO9wmB2PDAVOoS+J+cRYmdSGUfFgn9DGWOYidsABZWOOU/ln6Ahne13cuoeWsh2lA+EJqg0sMIsGOTPKGhc7dMtvwCusVJoXTie7z+BJI7R+LH4zrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR11MB4558.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(2906002)(71200400001)(7696005)(7416002)(110136005)(83380400001)(921005)(9686003)(55016002)(45080400002)(8936002)(8676002)(478600001)(66556008)(66446008)(66946007)(64756008)(66476007)(966005)(5660300002)(53546011)(6506007)(52536014)(33656002)(86362001)(26005)(186003)(316002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?L0JsWkJXSnVBQ09Wd1BFU1BmMEFZNXhzRThCQ3QvMnBZS0g4MjRxaVJRUGtN?=
 =?utf-8?B?ZTdTSU1FaVloTnY3Slo4Rzc0bmt0MjlqZmFlUmtnV0wrbWd5cE1KMUcxV2N4?=
 =?utf-8?B?SVJBZHJ0b1lXSFI2L0tJMzZpbzhySXdNY2trYnpRYlVndWdDV0tkUG81dmc0?=
 =?utf-8?B?Zkg1LzdUWnN6Zk43WFVjZGpseGNpL3NXam96TVp5MDBrZVJ6MG5uSitqd3ZX?=
 =?utf-8?B?alVkbk1LanFwRDg1T2pncEMrdnpRbWZpQW5VZTNZK3dDUE1vV1hCdFQxYnhU?=
 =?utf-8?B?NWNUU05RV01CS2RNUEI1cThXNUV5Z250UHh4eHdWSUZ0dkFMbWNNOGgzS3E0?=
 =?utf-8?B?VDBrQzV5YkpZamNrT0lsWldsTUZWR0NQYTBUVlY5cDYwKzJ3QURpMEZNOFRX?=
 =?utf-8?B?NFNFSXo5ekQvUDlOZGhObThML2cvQ2N1ekpFdzVzR1kybDE5Q3VxMVFscDc1?=
 =?utf-8?B?S1BFUU42Tk1sVW5JZ0JleWVsNklDWFNLOXF0RGpRMXVpMG51VTZzczNwSWlh?=
 =?utf-8?B?SXNBT003aTNRakkrdlo0RWJYR3YwTW9iMlYyajJWMWlFSm96aVpGdHkvbDVL?=
 =?utf-8?B?ZVpueStWU0R4QStadVQ1Wk4vemZuM3BldjdXb2NiOHhuamljY1RqQTBBNFJo?=
 =?utf-8?B?aE8xdGlmZmNPc1BhUXg3WkJvSldFRGhXMHl0dWRnSktyUjZWc0F0aVpQVjJZ?=
 =?utf-8?B?aDVMaUZKUWNHTmVycW9DT2NHNW1xZGxZRHBrM1FCUGpuUENoNVdjNjE4b3Fv?=
 =?utf-8?B?RGhmQzI0bGhrVTZQRFdWL25leGYrdHl5WmRLcHkya25KRXpxaElBWXVrSnRt?=
 =?utf-8?B?RlZmZlhRQUhrYzIzeEREd2svYTRZNXdpY25UdWNQUjV0dHQwMFFrNmcvNnlr?=
 =?utf-8?B?NFdSZDBHTDdrNjZ1cGZ1VU9DVHh2aGY0ZXpIS1AxYXQ5TEdrcFE3ZDlWZU5v?=
 =?utf-8?B?SkNNQlFyWndFOEJ0aS9rUC9sRW5QV3BjcTFiOXliNmZvVEZBUU5TRU9yRDV1?=
 =?utf-8?B?a2ZJMUhiOFNmSkNqc2RxbFdwZ2E5anc1ZXp0Q1A2TnpTZjU2cUcxcFpEdUpz?=
 =?utf-8?B?YUFveUlVVktkQlRQMWdUdnR0YWh6dGN4V1ByQWtCUHE1SkZpN3lYTk9WWkZI?=
 =?utf-8?B?Q056Z3VTZk9XaXJkZ2FKNGlDRnQrNHZQN0F6MFBJL3I3REt0YnNQOTNwUWgw?=
 =?utf-8?B?eCthQTBMT1hFYnFob0QvSGxYeXN6alowMy9Bek9NSFZ0MVpucDVRSkxrRm9h?=
 =?utf-8?B?NTlReU94QUlHS1JDclRNakN4Vmk5MStjQ1VpQ3IwTWhtWnhZVVZXTTc1OFZL?=
 =?utf-8?B?SkRpbktGVXV4WHYvUUttY3gyakttSUJBTUU2eFNUdXR1OGtTeUYydFZnNmFD?=
 =?utf-8?B?VHpVaW54bmVzYi9NMWtHTk9VazcvZUhpbEtWekhmcUh2aUV4aTdINlB3WDZS?=
 =?utf-8?Q?SZ8HnhpJ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR11MB4558.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72823ebf-cdcf-4aef-4db6-08d8c3fa570e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2021 02:05:24.1754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3hrB3g4Keyt/luTxBsXbYik6jt19qMcq7qAo6O1dQSYinMFOvBHOb0FNNRRJLVHWo6xmLNNllc3AdjZY9ECzdY5SiDGg43mHZ2mxVUNGpAtv21WDaFQ/OJpNxzSIolly
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2976
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNClRoYW5rIHlvdS4NCg0KUmVnYXJkcywNCkF0aGFyaQ0KDQotLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KRnJvbTogcGF0Y2h3b3JrLWJvdCtuZXRkZXZicGZAa2VybmVsLm9yZyA8cGF0
Y2h3b3JrLWJvdCtuZXRkZXZicGZAa2VybmVsLm9yZz4gDQpTZW50OiBGcmlkYXksIEphbnVhcnkg
MjksIDIwMjEgNToyMCBBTQ0KVG86IElzbWFpbCwgTW9oYW1tYWQgQXRoYXJpIDxtb2hhbW1hZC5h
dGhhcmkuaXNtYWlsQGludGVsLmNvbT4NCkNjOiBwZXBwZS5jYXZhbGxhcm9Ac3QuY29tOyBhbGV4
YW5kcmUudG9yZ3VlQHN0LmNvbTsgam9hYnJldUBzeW5vcHN5cy5jb207IGRhdmVtQGRhdmVtbG9m
dC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgbWNvcXVlbGluLnN0bTMyQGdtYWlsLmNvbTsgT25nLCBC
b29uIExlb25nIDxib29uLmxlb25nLm9uZ0BpbnRlbC5jb20+OyBWb29uLCBXZWlmZW5nIDx3ZWlm
ZW5nLnZvb25AaW50ZWwuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtc3RtMzJA
c3QtbWQtbWFpbG1hbi5zdG9ybXJlcGx5LmNvbTsgbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZy
YWRlYWQub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBSZTogW1BB
VENIIG5ldF0gc3RtbWFjOiBpbnRlbDogQ29uZmlndXJlIEVITCBQU0UwIEdiRSBhbmQgUFNFMSBH
YkUgdG8gMzIgYml0cyBETUEgYWRkcmVzc2luZw0KDQpIZWxsbzoNCg0KVGhpcyBwYXRjaCB3YXMg
YXBwbGllZCB0byBuZXRkZXYvbmV0LmdpdCAocmVmcy9oZWFkcy9tYXN0ZXIpOg0KDQpPbiBUdWUs
IDI2IEphbiAyMDIxIDE4OjA4OjQ0ICswODAwIHlvdSB3cm90ZToNCj4gRnJvbTogVm9vbiBXZWlm
ZW5nIDx3ZWlmZW5nLnZvb25AaW50ZWwuY29tPg0KPiANCj4gRml4IGFuIGlzc3VlIHdoZXJlIGR1
bXAgc3RhY2sgaXMgcHJpbnRlZCBhbmQgUmVzZXQgQWRhcHRlciBvY2N1cnMgd2hlbg0KPiBQU0Uw
IEdiRSBvci9hbmQgUFNFMSBHYkUgaXMvYXJlIGVuYWJsZWQuIEVITCBQU0UwIEdiRSBhbmQgUFNF
MSBHYkUgdXNlDQo+IDMyIGJpdHMgRE1BIGFkZHJlc3Npbmcgd2hlcmVhcyBFSEwgUENIIEdiRSB1
c2VzIDY0IGJpdHMgRE1BIGFkZHJlc3NpbmcuDQo+IA0KPiBbICAgMjUuNTM1MDk1XSAtLS0tLS0t
LS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0NCj4gWyAgIDI1LjU0MDI3Nl0gTkVUREVWIFdB
VENIRE9HOiBlbnAwczI5ZjIgKGludGVsLWV0aC1wY2kpOiB0cmFuc21pdCBxdWV1ZSAyIHRpbWVk
IG91dA0KPiBbICAgMjUuNTQ4NzQ5XSBXQVJOSU5HOiBDUFU6IDIgUElEOiAwIGF0IG5ldC9zY2hl
ZC9zY2hfZ2VuZXJpYy5jOjQ0MyBkZXZfd2F0Y2hkb2crMHgyNTkvMHgyNjANCj4gWyAgIDI1LjU1
ODAwNF0gTW9kdWxlcyBsaW5rZWQgaW46IDgwMjFxIGJuZXAgYmx1ZXRvb3RoIGVjcnlwdGZzIHNu
ZF9oZGFfY29kZWNfaGRtaSBpbnRlbF9ncHkgbWFydmVsbCBpbnRlbF9pc2h0cF9sb2FkZXIgaW50
ZWxfaXNodHBfaGlkIGlUQ09fd2R0IG1laV9oZGNwIGlUQ09fdmVuZG9yX3N1cHBvcnQgeDg2X3Br
Z190ZW1wX3RoZXJtYWwga3ZtX2ludGVsIGR3bWFjX2ludGVsIHN0bW1hYyBrdm0gaWdiIHBjc194
cGNzIGlycWJ5cGFzcyBwaHlsaW5rIHNuZF9oZGFfaW50ZWwgaW50ZWxfcmFwbF9tc3IgcGNzcGty
IGRjYSBzbmRfaGRhX2NvZGVjIGk5MTUgaTJjX2k4MDEgaTJjX3NtYnVzIGxpYnBoeSBpbnRlbF9p
c2hfaXBjIHNuZF9oZGFfY29yZSBtZWlfbWUgaW50ZWxfaXNodHAgbWVpIHNwaV9kd19wY2kgODI1
MF9scHNzIHNwaV9kdyB0aGVybWFsIGR3X2RtYWNfY29yZSBwYXJwb3J0X3BjIHRwbV9jcmIgdHBt
X3RpcyBwYXJwb3J0IHRwbV90aXNfY29yZSB0cG0gaW50ZWxfcG1jX2NvcmUgc2NoX2ZxX2NvZGVs
IHVoaWQgZnVzZSBjb25maWdmcyBzbmRfc29mX3BjaSBzbmRfc29mX2ludGVsX2J5dCBzbmRfc29m
X2ludGVsX2lwYyBzbmRfc29mX2ludGVsX2hkYV9jb21tb24gc25kX3NvZl94dGVuc2FfZHNwIHNu
ZF9zb2Ygc25kX3NvY19hY3BpX2ludGVsX21hdGNoIHNuZF9zb2NfYWNwaSBzbmRfaW50ZWxfZHNw
Y2ZnIGxlZHRyaWdfYXVkaW8gc25kX3NvY19jb3JlIHNuZF9jb21wcmVzcyBhYzk3X2J1cyBzbmRf
cGNtIHNuZF90aW1lciBzbmQgc291bmRjb3JlDQo+IFsgICAyNS42MzM3OTVdIENQVTogMiBQSUQ6
IDAgQ29tbTogc3dhcHBlci8yIFRhaW50ZWQ6IEcgICAgIFUgICAgICAgICAgICA1LjExLjAtcmM0
LWludGVsLWx0cy1NSVNNQUlMNSsgIzUNCj4gWyAgIDI1LjY0NDMwNl0gSGFyZHdhcmUgbmFtZTog
SW50ZWwgQ29ycG9yYXRpb24gRWxraGFydCBMYWtlIEVtYmVkZGVkIFBsYXRmb3JtL0Vsa2hhcnRM
YWtlIExQRERSNHggVDQgUlZQMSwgQklPUyBFSExTRldJMS5SMDAuMjQzNC5BMDAuMjAxMDIzMTQw
MiAxMC8yMy8yMDIwDQo+IFsgICAyNS42NTk2NzRdIFJJUDogMDAxMDpkZXZfd2F0Y2hkb2crMHgy
NTkvMHgyNjANCj4gWyAgIDI1LjY2NDY1MF0gQ29kZTogZTggM2IgNmIgNjAgZmYgZWIgOTggNGMg
ODkgZWYgYzYgMDUgZWMgZTcgYmYgMDAgMDEgZTggZmIgZTUgZmEgZmYgODkgZDkgNGMgODkgZWUg
NDggYzcgYzcgNzggMzEgZDIgOWUgNDggODkgYzIgZTggNzkgMWIgMTggMDAgPDBmPiAwYiBlOSA3
NyBmZiBmZiBmZiAwZiAxZiA0NCAwMCAwMCA0OCBjNyA0NyAwOCAwMCAwMCAwMCAwMCA0OCBjNw0K
PiBbICAgMjUuNjg1NjQ3XSBSU1A6IDAwMTg6ZmZmZmI3Y2E4MDE2MGViOCBFRkxBR1M6IDAwMDEw
Mjg2DQo+IFsgICAyNS42OTE0OThdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6IDAwMDAwMDAw
MDAwMDAwMDIgUkNYOiAwMDAwMDAwMDAwMDAwMTAzDQo+IFsgICAyNS42OTk0ODNdIFJEWDogMDAw
MDAwMDA4MDAwMDEwMyBSU0k6IDAwMDAwMDAwMDAwMDAwZjYgUkRJOiAwMDAwMDAwMGZmZmZmZmZm
DQo+IFsgICAyNS43MDc0NjVdIFJCUDogZmZmZjk4NTcwOWNlMDQ0MCBSMDg6IDAwMDAwMDAwMDAw
MDAwMDAgUjA5OiBjMDAwMDAwMGZmZmZlZmZmDQo+IFsgICAyNS43MTU0NTVdIFIxMDogZmZmZmI3
Y2E4MDE2MGNmMCBSMTE6IGZmZmZiN2NhODAxNjBjZTggUjEyOiBmZmZmOTg1NzA5Y2UwMzljDQo+
IFsgICAyNS43MjM0MzhdIFIxMzogZmZmZjk4NTcwOWNlMDAwMCBSMTQ6IDAwMDAwMDAwMDAwMDAw
MDggUjE1OiBmZmZmOTg1NzA2OGFmOTQwDQo+IFsgICAyNS43MzE0MjVdIEZTOiAgMDAwMDAwMDAw
MDAwMDAwMCgwMDAwKSBHUzpmZmZmOTg1ODY0MzAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAw
MDAwMDANCj4gWyAgIDI1Ljc0MDQ4MV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDog
MDAwMDAwMDA4MDA1MDAzMw0KPiBbICAgMjUuNzQ2OTEzXSBDUjI6IDAwMDA1NTY3ZjhiYjc2Yjgg
Q1IzOiAwMDAwMDAwMWY4ZTBhMDAwIENSNDogMDAwMDAwMDAwMDM1MGVlMA0KPiBbICAgMjUuNzU0
OTAwXSBDYWxsIFRyYWNlOg0KPiBbICAgMjUuNzU3NjMxXSAgPElSUT4NCj4gWyAgIDI1Ljc1OTg5
MV0gID8gcWRpc2NfcHV0X3VubG9ja2VkKzB4MzAvMHgzMA0KPiBbICAgMjUuNzY0NTY1XSAgPyBx
ZGlzY19wdXRfdW5sb2NrZWQrMHgzMC8weDMwDQo+IFsgICAyNS43NjkyNDVdICBjYWxsX3RpbWVy
X2ZuKzB4MmUvMHgxNDANCj4gWyAgIDI1Ljc3MzM0Nl0gIHJ1bl90aW1lcl9zb2Z0aXJxKzB4MWYz
LzB4NDMwDQo+IFsgICAyNS43Nzc5MzJdICA/IF9faHJ0aW1lcl9ydW5fcXVldWVzKzB4MTJjLzB4
MmMwDQo+IFsgICAyNS43ODMwMDVdICA/IGt0aW1lX2dldCsweDNlLzB4YTANCj4gWyAgIDI1Ljc4
NjgxMl0gIF9fZG9fc29mdGlycSsweGE2LzB4MmVmDQo+IFsgICAyNS43OTA4MTZdICBhc21fY2Fs
bF9pcnFfb25fc3RhY2srMHhmLzB4MjANCj4gWyAgIDI1Ljc5NTUwMV0gIDwvSVJRPg0KPiBbICAg
MjUuNzk3ODUyXSAgZG9fc29mdGlycV9vd25fc3RhY2srMHg1ZC8weDgwDQo+IFsgICAyNS44MDI1
MzhdICBpcnFfZXhpdF9yY3UrMHg5NC8weGIwDQo+IFsgICAyNS44MDY0NzVdICBzeXN2ZWNfYXBp
Y190aW1lcl9pbnRlcnJ1cHQrMHg0Mi8weGMwDQo+IFsgICAyNS44MTE4MzZdICBhc21fc3lzdmVj
X2FwaWNfdGltZXJfaW50ZXJydXB0KzB4MTIvMHgyMA0KPiBbICAgMjUuODE3NTg2XSBSSVA6IDAw
MTA6Y3B1aWRsZV9lbnRlcl9zdGF0ZSsweGQ5LzB4MzcwDQo+IFsgICAyNS44MjMxNDJdIENvZGU6
IDg1IGMwIDBmIDhmIDBhIDAyIDAwIDAwIDMxIGZmIGU4IDIyIGQ1IDdlIGZmIDQ1IDg0IGZmIDc0
IDEyIDljIDU4IGY2IGM0IDAyIDBmIDg1IDQ3IDAyIDAwIDAwIDMxIGZmIGU4IDdiIGEwIDg0IGZm
IGZiIDQ1IDg1IGY2IDwwZj4gODggYWIgMDAgMDAgMDAgNDkgNjMgY2UgNDggMmIgMmMgMjQgNDgg
ODkgYzggNDggNmIgZDEgNjggNDggYzENCj4gWyAgIDI1Ljg0NDE0MF0gUlNQOiAwMDE4OmZmZmZi
N2NhODAwZjdlODAgRUZMQUdTOiAwMDAwMDIwNg0KPiBbICAgMjUuODQ5OTk2XSBSQVg6IGZmZmY5
ODU4NjQzMDAwMDAgUkJYOiAwMDAwMDAwMDAwMDAwMDAzIFJDWDogMDAwMDAwMDAwMDAwMDAxZg0K
PiBbICAgMjUuODU3OTc1XSBSRFg6IDAwMDAwMDA1ZjIwMjhlYTggUlNJOiBmZmZmZmZmZjllYzU5
MDdmIFJESTogZmZmZmZmZmY5ZWM2MmE1ZA0KPiBbICAgMjUuODY1OTYxXSBSQlA6IDAwMDAwMDA1
ZjIwMjhlYTggUjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIwOTogMDAwMDAwMDAwMDAyOWQwMA0KPiBb
ICAgMjUuODczOTQ3XSBSMTA6IDAwMDAwMDEzN2IwZTA1MDggUjExOiBmZmZmOTg1ODY0MzI5NGU0
IFIxMjogZmZmZjk4NTg2NDMzMzZkMA0KPiBbICAgMjUuODgxOTM1XSBSMTM6IGZmZmZmZmZmOWVm
NzRiMDAgUjE0OiAwMDAwMDAwMDAwMDAwMDAzIFIxNTogMDAwMDAwMDAwMDAwMDAwMA0KPiBbICAg
MjUuODg5OTE4XSAgY3B1aWRsZV9lbnRlcisweDI5LzB4NDANCj4gWyAgIDI1Ljg5MzkyMl0gIGRv
X2lkbGUrMHgyNGEvMHgyOTANCj4gWyAgIDI1Ljg5NzUzNl0gIGNwdV9zdGFydHVwX2VudHJ5KzB4
MTkvMHgyMA0KPiBbICAgMjUuOTAxOTMwXSAgc3RhcnRfc2Vjb25kYXJ5KzB4MTI4LzB4MTYwDQo+
IFsgICAyNS45MDYzMjZdICBzZWNvbmRhcnlfc3RhcnR1cF82NF9ub192ZXJpZnkrMHhiMC8weGJi
DQo+IFsgICAyNS45MTE5ODNdIC0tLVsgZW5kIHRyYWNlIGI0YzBjODE5NWQwYmE2MWYgXS0tLQ0K
PiBbICAgMjUuOTE3MTkzXSBpbnRlbC1ldGgtcGNpIDAwMDA6MDA6MWQuMiBlbnAwczI5ZjI6IFJl
c2V0IGFkYXB0ZXIuDQo+IA0KPiBbLi4uXQ0KDQpIZXJlIGlzIHRoZSBzdW1tYXJ5IHdpdGggbGlu
a3M6DQogIC0gW25ldF0gc3RtbWFjOiBpbnRlbDogQ29uZmlndXJlIEVITCBQU0UwIEdiRSBhbmQg
UFNFMSBHYkUgdG8gMzIgYml0cyBETUEgYWRkcmVzc2luZw0KICAgIGh0dHBzOi8vZ2l0Lmtlcm5l
bC5vcmcvbmV0ZGV2L25ldC9jLzdjZmM0NDg2ZTdlYQ0KDQpZb3UgYXJlIGF3ZXNvbWUsIHRoYW5r
IHlvdSENCi0tDQpEZWV0LWRvb3QtZG90LCBJIGFtIGEgYm90Lg0KaHR0cHM6Ly9rb3JnLmRvY3Mu
a2VybmVsLm9yZy9wYXRjaHdvcmsvcHdib3QuaHRtbA0KDQoNCg==
