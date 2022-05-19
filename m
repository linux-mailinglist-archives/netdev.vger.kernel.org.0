Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2CB52CE4C
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 10:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbiESI1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 04:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiESI1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 04:27:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB9A75217;
        Thu, 19 May 2022 01:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652948854; x=1684484854;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bgTbboat1WlI8D4VbsWi5TzG4qk+PViVc1wKEkWygZw=;
  b=hTML2YMj9V6K7d2rGfID29TBxg7zyOy46BIH6RwTeM0ahCJQk2PDKdt0
   2WG9xQ8uR0Qr5q/KEkkZ2VLFnkHHwHfQdd/LmYBmECy6nKUBezKVu5Zf3
   +ZvhjD41GVHfhGxSks2x3BOT5wVVrx47csA2v1iuB7YQlg4OkZQWujOJ7
   T8TN+GziCzROi92YQd2QerK6H3rgRNrhGBvGiCQQSWXqDrOzSs30xTt31
   pkWQgV2hIjlDfhOWUbvAOqLgO7lNWElta0jha7jGJCnWbfzn5KUzy7RRu
   tnrVbCkGR5IJEKne5QXJNJmfZVNvSYstFWSX4Kgk8JZb6jrmmKSYOPY/3
   g==;
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="174093687"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 May 2022 01:27:33 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 19 May 2022 01:27:33 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Thu, 19 May 2022 01:27:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eALsSJWdmiSj7OLABRDjRfLBIwS1jvlN5EDJ4t5t0QJi3JlvQGcO3aqUSI17WH/WELW0pcdbEJ1wPngnbv4IIZJgRhsSY7tmldXB5ZJ66Y7wsnX0z5LrDQUGQAP7Ik1xNUzb152bJXez0b/CiTs4QzIg2oEJW/dLny2L050P2qTGW44nQkoIAVanbX28Ti629R46A9PJGgSmUOhNq31/x7K1TOrD/HA3LJ8puQSyjoZlbynqNgb0dCQK9I5EDVkRprWDiw0d8SK+3H3kvjL6eh8WW3xs++rmA+k2xFaSDKRxmqNJpFuHmUwMviNt4gtvug1WusNnIWWdUcOPLvnQCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgTbboat1WlI8D4VbsWi5TzG4qk+PViVc1wKEkWygZw=;
 b=TyN7l5V/woRn4Jd8lseonllIyC+wawUHG0ZObmaRRSZ4NuKYEi46do7gburqp+vs9MRnWnvbcmrSgPwSLo5NklwswZFY1IrHDaSwGs9Nf4sogCks1ihtWhUkxJH2kBhneIvT3JbpHv2xmhKW7m/V82LadRQ3UIGEziBVz177akDHuXsNdF2GwxuE7t+rPLECdBEfw9cqz6xMvi6Jci4/kh/luBoPHsTbH+4F9iDNyjIhO1u21cczW7zJUMBhyFbTBjPaahAibWUqUPbVRJ9ygTDibg9yzbPPHGruCTythKGi/AkCoqYlgO31uUCoi+4+lrqmelaljESF8d6RwpMjfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgTbboat1WlI8D4VbsWi5TzG4qk+PViVc1wKEkWygZw=;
 b=CpGvgPry+8xLK/eeTZ1BYnIMthrGqVDDRPcQr/XpBlBNWqNMPfpcWLjV8giRQKMGOTcNxWQa3wXme/phUjlEaj5z+hQw9O0K7yXQ4GMWE765C4Xuqmxg7SnVWhQJknUFuovptOnsWRS1SdKaPQUD9NJABW4lJCTJdy0bKpH1WJk=
Received: from CY4PR11MB1960.namprd11.prod.outlook.com (2603:10b6:903:11d::21)
 by BL0PR11MB3043.namprd11.prod.outlook.com (2603:10b6:208:33::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Thu, 19 May
 2022 08:27:23 +0000
Received: from CY4PR11MB1960.namprd11.prod.outlook.com
 ([fe80::31fc:2c57:1ac8:8241]) by CY4PR11MB1960.namprd11.prod.outlook.com
 ([fe80::31fc:2c57:1ac8:8241%2]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 08:27:22 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <harini.katakam@xilinx.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <richardcochran@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH net v3] net: macb: Fix PTP one step sync support
Thread-Topic: [PATCH net v3] net: macb: Fix PTP one step sync support
Thread-Index: AQHYa1pDf9p5qyQfT0OacUl0MZFZ0Q==
Date:   Thu, 19 May 2022 08:27:22 +0000
Message-ID: <e22c53fb-35aa-356f-3a2d-65042dd298dd@microchip.com>
References: <20220518170756.7752-1-harini.katakam@xilinx.com>
In-Reply-To: <20220518170756.7752-1-harini.katakam@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e84922a-fbc4-4608-1551-08da3971659d
x-ms-traffictypediagnostic: BL0PR11MB3043:EE_
x-microsoft-antispam-prvs: <BL0PR11MB30430DCF718D38CDF6BBE13F87D09@BL0PR11MB3043.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TYBzcNBxQh47aftWwcQyXu+WrDkXDMb9hjbSdZITzf5KMM0gK476kTW0bh8o721q3AQ9AaXaWYIB0Atj24z1Mw0eNL+kJsQMD3WHoWz2K+cKNqw/HioVztvy/xd+VNooLkZgI1QDRy801SQ+x5lCbIzNi5gFkGqs5c4YCH9DvWOZRBf5J2p+ERHBl/ry2gtOL0Pp4L4nLCBP5jYT15C6i+/ZJ+Hyii8N0ORoObeEeIutGrwu4ZuU23EfUoxJsFjVE10hBBxRstEGOhyKyLDju3LOZdeXSumvVlIvudcq58+5g2CaG8URnWBAFyFb14mfPtoqr7BGHCZpY7M1Z+qvsXxpcK+ApAh6gtt4PcoRb8+vm8INhDjYo6wfoxQnRVdIM6pyZSJfPDNmTYXmn2jT5CY94wUZJq5OYKee1dGsI6L9i9gTTQ3c5GmO1tFQdotZmRadZppAHt50CLS719sPKLZcJK9eBCvrwNZLBUp0kmVadGx2bJQ2owixCj5vNuEPZAQ4vSJmFzPrvKAB+Xw4ip1BNaTsKtkt0vUxoubb1XuxJlSVNxr6HO9zM3Ehr8EMrLys/x5E9QN2zKlA9/0cbZ9XUUs3F2Kd4YlRA7Ng+12hk7FO0HYHCSl94CAdYMpEQULZ7sn8OuQjUm21oulaJIy36AgKFRoAuKMoMyw+PaXurmvbckh+yxz5F/A0CfmlTuqtN4aTJtDoSPGD74MuhgRwy2FblKq3yU6694hlVwa4h+aFXBFkbKsvDdDICxO5vfJuPEdJk9DPS0Bfe7e0jQNW1Bx3ZONSCzjVZdnFaJ4yVJ9VVM6B65sYhS/7y1nueBTXu8ankAXRDqs4F2SyBJYhO7Vjo3Yspbn6AcgPe4Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1960.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(38100700002)(38070700005)(6486002)(966005)(508600001)(186003)(5660300002)(31686004)(2906002)(36756003)(7416002)(8676002)(64756008)(66476007)(66556008)(2616005)(91956017)(316002)(8936002)(31696002)(110136005)(66946007)(76116006)(86362001)(4326008)(54906003)(66446008)(6506007)(26005)(71200400001)(53546011)(122000001)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vk1iWmUwMUNMZE1CMWg5TGxXR2NvTVpReWpQSVJoaVl0NDdGVVNnYzJVTVB0?=
 =?utf-8?B?MmFFSWh6L1lad0plOWFuNFBmdHlvS2F1aXlxaE1ManRQTVk1b3RGOFRuaFlv?=
 =?utf-8?B?cGNYOVpiQzhpeTUzc01NYS9CenVCeWtpV0QyVUtZTDByRVJPbWRtOXdaaXdE?=
 =?utf-8?B?azBmclpCcTZ6dkRDR3duY2J0UWtZUWhwVUFZV0R2RTQzVmxMREJPanNNSFQ1?=
 =?utf-8?B?cFBLb1F2MHlyUjNSM1huRmQ5bFVzeHdMRVBTQ3RZWXlzelhQajNRRk1WaXZs?=
 =?utf-8?B?TGRWS2FZQmdOSmZPUXN4VlFGT2JxcW9KWWhtcnVPRldTa0tnbWdiR0E2blhx?=
 =?utf-8?B?TjJwc3NIY0NLZG9UK2drWFRPMVBpWjJiRkVEWmxaZlZPaXExelUyeU41elk2?=
 =?utf-8?B?WXVPZTR2WW0reGhJYWVnN3RaUWJyVks4ek5nWnF0bGl4cEpjR1ROOWtoUU9P?=
 =?utf-8?B?VU9uNlg4OGlCMEZPWDRoQVlCdi8vZUY4MklEQXRXQkVweCtRTW9renJmK1Vt?=
 =?utf-8?B?eGNJZ1k5OVplL2tsaHBrMEFxZEVLRXByRENha2ljeDhTUmRtTHEwMTlsL0xK?=
 =?utf-8?B?YWZMbmtVTzVhYUczQVZuekNNN0RGako1eERsOEZuLzVZSkY0Mk0zc2lFYjdj?=
 =?utf-8?B?QmJBMEU2b0N3cHRKdEZzVmVOM0hKN0d1Qm1ITUdwMnhrdWtxV0NtU2prZkx6?=
 =?utf-8?B?anpYbmdHQTNGMml4WDZ1NVliUEJoSlo2QTVSdmFLVGt6cDFoUXhBdWZIUHRs?=
 =?utf-8?B?NGhZd3Bnc1p6Q3ZvZHJBMmxrb25tRkgzeXNoUjNDZ3V6bGRPeUtjcnJiNEp3?=
 =?utf-8?B?TTJEQXl6TkRLRGtCOFM0NjE2Q2VHRFF4NWs2ajJ6U3FWQ1FWdkpGL29uRHc2?=
 =?utf-8?B?eStQQzJ2azZobDA4THhrUzZsV0daZFJIZ25zR0Vzc2ZkU0kvT3hwcjdnYno2?=
 =?utf-8?B?cGN0ZUV2VFlRYmFNa0VadVQ4UXZKUmNBa3IwN00rNDRsM24wQjd3TWtta0Qv?=
 =?utf-8?B?bWhWczk4UjliZFJKRUtPZEM2cHRxZ2cvNEY1YmNzQ0g4TUFSVEJPMWFjZi9Y?=
 =?utf-8?B?Q08yRGNoYTNRY0E1T0xGVWx2cCtiNHJHNi8zNU5sNkd3OVhaNDRGQ2FaTGlU?=
 =?utf-8?B?Yzh4Tm9UNzBnRElxM1BHYWlyc0lKalNmbG92S1FqOU1mWEJtSjZYalB2K2tZ?=
 =?utf-8?B?M3JEdUFNL1N0dXZMVGRHcm03TkFqWlErRmtSdHdJeEhEckVMYkJVUXk1UW8y?=
 =?utf-8?B?aDhieVpVQnNzbHo1bXN5QWh3VElSUEtEd0FaVlQwTGtZWkxBbXZTbnNRL0I4?=
 =?utf-8?B?MHZZVGlocndkTHdhd1ZuK1E4L0dUTkIrR2d3bmNrZUttUXhESHN0U3lGaEpW?=
 =?utf-8?B?TUx2dGN5NC8xSnV6QkNLL2JXOEZHMjZNdjNEaFpaTml5eXlwYnl1R3h2V2NB?=
 =?utf-8?B?MGRFeHcvdnJQZmxoWGRvU3lHVk9RdHZOMlBqYy92bFdxZlNvYmpCclAvckhV?=
 =?utf-8?B?aUVjdWg2RUR5K2tqRWNhSVVnMWxHZ1lVNnlEdjIrN0o3eGc3aE5PTFUzR2c4?=
 =?utf-8?B?eDM4U2p0Zy9MaGcvMHNNNS9yZWlKWmNndDJpVmUwV2pjSWROOUJFdWdlTzFk?=
 =?utf-8?B?N29kaFp6NDRIMUVjbXlrb2tEZnRPM3R1OHNRRUd5K2J5Y0FTQm9qZHhvSSsr?=
 =?utf-8?B?YzFPMkRkSHF6eVh4eHo2Lzluc3lxZ3pkcnE2YnlubWczdGdkNExOTUVMQ2t4?=
 =?utf-8?B?TkdIcmZDUFRrVUEvMk45a00vUGphZEl1Y2RtNk1pMklxbFAvTjRnMzdSWVRD?=
 =?utf-8?B?N2lxcFExYkZVNHY4Y3EyNkMrY3Rzell6Vk1ROTdRMnNSSHRRd3RtWFlzV1NO?=
 =?utf-8?B?MmRVQjZqK0FqcE9saTRuMmU5YjBMTVJOS3dXaW83V2lQSDlvNFJ1V0FmVnpo?=
 =?utf-8?B?ZVJQc0dtejdJVUFoUUx5ZWRzSU5Ibkt5NHlaZ3dUN2djbHdGTGdSa3hLZFI3?=
 =?utf-8?B?ZEhDVFErWDJrdGtIbmFXdHVRcWZwNkFZWjE0R0FhSy92VGkwRWZhQ0xhdlVj?=
 =?utf-8?B?N2UvdmY2cDNEekdST1hTOGF2eDZ0Z05veU1hWmc0VGVxejVYemJSQ2hRRGJJ?=
 =?utf-8?B?ODNmY1d2eG5VVlF5T0xUa2tISDdUeGFPVk82MFVUblFPb2pSUnpXZGRVQWlK?=
 =?utf-8?B?Nk16UHEvWGdHaUxyRmZSd0lzc3BDK3ZadGdCcG43NStqZE15MXNuaFdvcm9I?=
 =?utf-8?B?MzNPL296V0lIUUdoY3FxVk1VY0lYNTVxRlZ1N2NvekhKamkzRHdHNURrdlIr?=
 =?utf-8?B?V3dqcS91VmdpVUVvY0RWOW82aE5pQjlpT2JEanYvUnVhRjdqSmRSTVVrSjhi?=
 =?utf-8?Q?7b11DMnJxCOIg9F0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A2B7236A8FB5E842AE608E1FC7E90D1D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1960.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e84922a-fbc4-4608-1551-08da3971659d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 08:27:22.4915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g9RMtdnVnT4n7/PXKpfynqZeD1stBZ8yTW+cJAa7PhXhfuHaZXfXYJ9qOG8dTecT/GMC5nPW1K3eBM/BHDUQBrFv8EbIZ2FRXaP3x5q/09Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3043
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTguMDUuMjAyMiAyMDowNywgSGFyaW5pIEthdGFrYW0gd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gUFRQIG9uZSBzdGVwIHN5bmMgcGFja2V0cyBj
YW5ub3QgaGF2ZSBDU1VNIHBhZGRpbmcgYW5kIGluc2VydGlvbiBpbg0KPiBTVyBzaW5jZSB0aW1l
IHN0YW1wIGlzIGluc2VydGVkIG9uIHRoZSBmbHkgYnkgSFcuDQo+IEluIGFkZGl0aW9uLCBwdHA0
bCB2ZXJzaW9uIDMuMCBhbmQgYWJvdmUgcmVwb3J0IGFuIGVycm9yIHdoZW4gc2tiDQo+IHRpbWVz
dGFtcHMgYXJlIHJlcG9ydGVkIGZvciBwYWNrZXRzIHRoYXQgbm90IHByb2Nlc3NlZCBmb3IgVFgg
VFMNCj4gYWZ0ZXIgdHJhbnNtaXNzaW9uLg0KPiBBZGQgYSBoZWxwZXIgdG8gaWRlbnRpZnkgUFRQ
IG9uZSBzdGVwIHN5bmMgYW5kIGZpeCB0aGUgYWJvdmUgdHdvDQo+IGVycm9ycy4gQWRkIGEgY29t
bW9uIG1hc2sgZm9yIFBUUCBoZWFkZXIgZmxhZyBmaWVsZCAidHdvU3RlcGZsYWciLg0KPiBBbHNv
IHJlc2V0IHB0cCBPU1MgYml0IHdoZW4gb25lIHN0ZXAgaXMgbm90IHNlbGVjdGVkLg0KPiANCj4g
Rml4ZXM6IGFiOTFmMGE5YjVmNCAoIm5ldDogbWFjYjogQWRkIGhhcmR3YXJlIFBUUCBzdXBwb3J0
IikNCj4gRml4ZXM6IDY1M2U5MmE5MTc1ZSAoIm5ldDogbWFjYjogYWRkIHN1cHBvcnQgZm9yIHBh
ZGRpbmcgYW5kIGZjcyBjb21wdXRhdGlvbiIpDQo+IFNpZ25lZC1vZmYtYnk6IEhhcmluaSBLYXRh
a2FtIDxoYXJpbmkua2F0YWthbUB4aWxpbnguY29tPg0KPiBSZXZpZXdlZC1ieTogUmFkaGV5IFNo
eWFtIFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRleUB4aWxpbnguY29tPg0KDQpSZXZpZXdlZC1i
eTogQ2xhdWRpdSBCZXpuZWEgPGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+DQoNCg0KPiAt
LS0NCj4gdjM6DQo+IC0gUmViYXNlIG9uIG5ldCBicmFuY2gNCj4gLSBTcXVhc2ggYm90aCBjb21t
aXRzIG9uIG1hY2IgZHJpdmVyIGFuZCBwdHBfY2xhc3NpZnkuaA0KPiANCj4gdjI6DQo+IC0gU2Vw
YXJhdGUgZml4IGZvciBuZXQgYnJhbmNoDQo+IChTcGxpdCBmcm9tICJNYWNiIFBUUCB1cGRhdGVz
IiBzZXJpZXMNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzIwMjIwNTE3MTM1NTI1
LkdDMzM0NEBob2JveS52ZWdhc3ZpbC5vcmcvVC8pDQo+IC0gRml4IGluY2x1ZGUgb3JkZXINCj4g
LSBwdHBfb3NzIC0+IHB0cF9vbmVfc3RlcF9zeW5jDQo+IC0gUmVtb3ZlIGlubGluZSBhbmQgYWRk
ICJsaWtlbHkiIG9uIFNLQl9IV1RTVEFNUCBjaGVjayBpbiBwdHAgaGVscGVyDQo+IC0gRG9udCBz
cGxpdCBnZW1fcHRwX2RvX3R4X3RzdGFtcCBmcm9tIGlmIGNvbmRpdGlvbiBhcyBvcmRlciBvZg0K
PiBldmFsdWF0aW9uIHdpbGwgdGFrZSBjYXJlIG9mIGludGVudA0KPiAtIFJlbW92ZSByZWR1bmRh
bnQgY29tbWVudHMgaW4gbWFjYl9wYWRfYW5kX2Zjcw0KPiAtIEFkZCBQVFAgZmxhZyB0byBwdHBf
Y2xhc3NpZnkgaGVhZGVyIGZvciBjb21tb24gdXNlDQo+IChEaW50IGFkZCBSaWNoYXJkJ3MgQUNL
IGFzIHRoZSBwYXRjaCBjaGFuZ2VkIGFuZCB0aGVyZSdzIGEgbWlub3IgYWRkaXRpb24NCj4gaW4g
cHRwX2NsYXNzaWZ5LmggYXMgd2VsbCkNCj4gDQo+IHYxIE5vdGVzOg0KPiAtPiBBZGRlZCB0aGUg
bWFjYiBwYWQgYW5kIGZjcyBmaXhlcyB0YWcgYmVjYXVzZSBzdHJpY3RseSBzcGVha2luZyB0aGUg
UFRQIHN1cHBvcnQNCj4gcGF0Y2ggcHJlY2VkZXMgdGhlIGZjcyBwYXRjaCBpbiB0aW1lbGluZS4N
Cj4gLT4gRllJLCB0aGUgZXJyb3Igb2JzZXJ2ZWQgd2l0aCBzZXR0aW5nIEhXIFRYIHRpbWVzdGFt
cCBmb3Igb25lIHN0ZXAgc3luYyBwYWNrZXRzOg0KPiBwdHA0bFs0MDUuMjkyXTogcG9ydCAxOiB1
bmV4cGVjdGVkIHNvY2tldCBlcnJvcg0KPiANCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVu
Y2UvbWFjYl9tYWluLmMgfCA0MCArKysrKysrKysrKysrKysrKysrKystLS0NCj4gIGRyaXZlcnMv
bmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9wdHAuYyAgfCAgNCArKy0NCj4gIGluY2x1ZGUvbGlu
dXgvcHRwX2NsYXNzaWZ5LmggICAgICAgICAgICAgfCAgMyArKw0KPiAgMyBmaWxlcyBjaGFuZ2Vk
LCA0MiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IGluZGV4IDYxMjg0YmFhMDQ5Ni4uM2ExYjVhYzQ4
Y2E1IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFp
bi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4g
QEAgLTM2LDYgKzM2LDcgQEANCj4gICNpbmNsdWRlIDxsaW51eC9pb3BvbGwuaD4NCj4gICNpbmNs
dWRlIDxsaW51eC9waHkvcGh5Lmg+DQo+ICAjaW5jbHVkZSA8bGludXgvcG1fcnVudGltZS5oPg0K
PiArI2luY2x1ZGUgPGxpbnV4L3B0cF9jbGFzc2lmeS5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L3Jl
c2V0Lmg+DQo+ICAjaW5jbHVkZSAibWFjYi5oIg0KPiANCj4gQEAgLTExMjQsNiArMTEyNSwzNiBA
QCBzdGF0aWMgdm9pZCBtYWNiX3R4X2Vycm9yX3Rhc2soc3RydWN0IHdvcmtfc3RydWN0ICp3b3Jr
KQ0KPiAgICAgICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmJwLT5sb2NrLCBmbGFncyk7DQo+
ICB9DQo+IA0KPiArc3RhdGljIGJvb2wgcHRwX29uZV9zdGVwX3N5bmMoc3RydWN0IHNrX2J1ZmYg
KnNrYikNCj4gK3sNCj4gKyAgICAgICBzdHJ1Y3QgcHRwX2hlYWRlciAqaGRyOw0KPiArICAgICAg
IHVuc2lnbmVkIGludCBwdHBfY2xhc3M7DQo+ICsgICAgICAgdTggbXNndHlwZTsNCj4gKw0KPiAr
ICAgICAgIC8qIE5vIG5lZWQgdG8gcGFyc2UgcGFja2V0IGlmIFBUUCBUUyBpcyBub3QgaW52b2x2
ZWQgKi8NCj4gKyAgICAgICBpZiAobGlrZWx5KCEoc2tiX3NoaW5mbyhza2IpLT50eF9mbGFncyAm
IFNLQlRYX0hXX1RTVEFNUCkpKQ0KPiArICAgICAgICAgICAgICAgZ290byBub3Rfb3NzOw0KPiAr
DQo+ICsgICAgICAgLyogSWRlbnRpZnkgYW5kIHJldHVybiB3aGV0aGVyIFBUUCBvbmUgc3RlcCBz
eW5jIGlzIGJlaW5nIHByb2Nlc3NlZCAqLw0KPiArICAgICAgIHB0cF9jbGFzcyA9IHB0cF9jbGFz
c2lmeV9yYXcoc2tiKTsNCj4gKyAgICAgICBpZiAocHRwX2NsYXNzID09IFBUUF9DTEFTU19OT05F
KQ0KPiArICAgICAgICAgICAgICAgZ290byBub3Rfb3NzOw0KPiArDQo+ICsgICAgICAgaGRyID0g
cHRwX3BhcnNlX2hlYWRlcihza2IsIHB0cF9jbGFzcyk7DQo+ICsgICAgICAgaWYgKCFoZHIpDQo+
ICsgICAgICAgICAgICAgICBnb3RvIG5vdF9vc3M7DQo+ICsNCj4gKyAgICAgICBpZiAoaGRyLT5m
bGFnX2ZpZWxkWzBdICYgUFRQX0ZMQUdfVFdPU1RFUCkNCj4gKyAgICAgICAgICAgICAgIGdvdG8g
bm90X29zczsNCj4gKw0KPiArICAgICAgIG1zZ3R5cGUgPSBwdHBfZ2V0X21zZ3R5cGUoaGRyLCBw
dHBfY2xhc3MpOw0KPiArICAgICAgIGlmIChtc2d0eXBlID09IFBUUF9NU0dUWVBFX1NZTkMpDQo+
ICsgICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTsNCj4gKw0KPiArbm90X29zczoNCj4gKyAgICAg
ICByZXR1cm4gZmFsc2U7DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyB2b2lkIG1hY2JfdHhfaW50ZXJy
dXB0KHN0cnVjdCBtYWNiX3F1ZXVlICpxdWV1ZSkNCj4gIHsNCj4gICAgICAgICB1bnNpZ25lZCBp
bnQgdGFpbDsNCj4gQEAgLTExNjgsOCArMTE5OSw4IEBAIHN0YXRpYyB2b2lkIG1hY2JfdHhfaW50
ZXJydXB0KHN0cnVjdCBtYWNiX3F1ZXVlICpxdWV1ZSkNCj4gDQo+ICAgICAgICAgICAgICAgICAg
ICAgICAgIC8qIEZpcnN0LCB1cGRhdGUgVFggc3RhdHMgaWYgbmVlZGVkICovDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgIGlmIChza2IpIHsNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBpZiAodW5saWtlbHkoc2tiX3NoaW5mbyhza2IpLT50eF9mbGFncyAmDQo+IC0gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFNLQlRYX0hXX1RTVEFNUCkgJiYN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAodW5saWtlbHkoc2tiX3NoaW5m
byhza2IpLT50eF9mbGFncyAmIFNLQlRYX0hXX1RTVEFNUCkgJiYNCj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIXB0cF9vbmVfc3RlcF9zeW5jKHNrYikgJiYNCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ2VtX3B0cF9kb190eHN0YW1wKHF1ZXVlLCBz
a2IsIGRlc2MpID09IDApIHsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIC8qIHNrYiBub3cgYmVsb25ncyB0byB0aW1lc3RhbXAgYnVmZmVyDQo+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKiBhbmQgd2lsbCBiZSByZW1vdmVkIGxhdGVy
DQo+IEBAIC0xOTk5LDcgKzIwMzAsOCBAQCBzdGF0aWMgdW5zaWduZWQgaW50IG1hY2JfdHhfbWFw
KHN0cnVjdCBtYWNiICpicCwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgY3RybCB8PSBNQUNC
X0JGKFRYX0xTTywgbHNvX2N0cmwpOw0KPiAgICAgICAgICAgICAgICAgICAgICAgICBjdHJsIHw9
IE1BQ0JfQkYoVFhfVENQX1NFUV9TUkMsIHNlcV9jdHJsKTsNCj4gICAgICAgICAgICAgICAgICAg
ICAgICAgaWYgKChicC0+ZGV2LT5mZWF0dXJlcyAmIE5FVElGX0ZfSFdfQ1NVTSkgJiYNCj4gLSAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHNrYi0+aXBfc3VtbWVkICE9IENIRUNLU1VNX1BBUlRJ
QUwgJiYgIWxzb19jdHJsKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgc2tiLT5pcF9z
dW1tZWQgIT0gQ0hFQ0tTVU1fUEFSVElBTCAmJiAhbHNvX2N0cmwgJiYNCj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICFwdHBfb25lX3N0ZXBfc3luYyhza2IpKQ0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGN0cmwgfD0gTUFDQl9CSVQoVFhfTk9DUkMpOw0KPiAgICAgICAg
ICAgICAgICAgfSBlbHNlDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIC8qIE9ubHkgc2V0IE1T
Uy9NRlMgb24gcGF5bG9hZCBkZXNjcmlwdG9ycw0KPiBAQCAtMjA5Nyw3ICsyMTI5LDcgQEAgc3Rh
dGljIGludCBtYWNiX3BhZF9hbmRfZmNzKHN0cnVjdCBza19idWZmICoqc2tiLCBzdHJ1Y3QgbmV0
X2RldmljZSAqbmRldikNCj4gDQo+ICAgICAgICAgaWYgKCEobmRldi0+ZmVhdHVyZXMgJiBORVRJ
Rl9GX0hXX0NTVU0pIHx8DQo+ICAgICAgICAgICAgICEoKCpza2IpLT5pcF9zdW1tZWQgIT0gQ0hF
Q0tTVU1fUEFSVElBTCkgfHwNCj4gLSAgICAgICAgICAgc2tiX3NoaW5mbygqc2tiKS0+Z3NvX3Np
emUpIC8qIE5vdCBhdmFpbGFibGUgZm9yIEdTTyAqLw0KPiArICAgICAgICAgICBza2Jfc2hpbmZv
KCpza2IpLT5nc29fc2l6ZSB8fCBwdHBfb25lX3N0ZXBfc3luYygqc2tiKSkNCj4gICAgICAgICAg
ICAgICAgIHJldHVybiAwOw0KPiANCj4gICAgICAgICBpZiAocGFkbGVuIDw9IDApIHsNCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9wdHAuYyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9wdHAuYw0KPiBpbmRleCBmYjZiMjdmNDZiMTUu
Ljk1NTljMTYwNzhmOSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5j
ZS9tYWNiX3B0cC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9w
dHAuYw0KPiBAQCAtNDcwLDggKzQ3MCwxMCBAQCBpbnQgZ2VtX3NldF9od3RzdChzdHJ1Y3QgbmV0
X2RldmljZSAqZGV2LCBzdHJ1Y3QgaWZyZXEgKmlmciwgaW50IGNtZCkNCj4gICAgICAgICBjYXNl
IEhXVFNUQU1QX1RYX09ORVNURVBfU1lOQzoNCj4gICAgICAgICAgICAgICAgIGlmIChnZW1fcHRw
X3NldF9vbmVfc3RlcF9zeW5jKGJwLCAxKSAhPSAwKQ0KPiAgICAgICAgICAgICAgICAgICAgICAg
ICByZXR1cm4gLUVSQU5HRTsNCj4gLSAgICAgICAgICAgICAgIGZhbGx0aHJvdWdoOw0KPiArICAg
ICAgICAgICAgICAgdHhfYmRfY29udHJvbCA9IFRTVEFNUF9BTExfRlJBTUVTOw0KPiArICAgICAg
ICAgICAgICAgYnJlYWs7DQo+ICAgICAgICAgY2FzZSBIV1RTVEFNUF9UWF9PTjoNCj4gKyAgICAg
ICAgICAgICAgIGdlbV9wdHBfc2V0X29uZV9zdGVwX3N5bmMoYnAsIDApOw0KPiAgICAgICAgICAg
ICAgICAgdHhfYmRfY29udHJvbCA9IFRTVEFNUF9BTExfRlJBTUVTOw0KPiAgICAgICAgICAgICAg
ICAgYnJlYWs7DQo+ICAgICAgICAgZGVmYXVsdDoNCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGlu
dXgvcHRwX2NsYXNzaWZ5LmggYi9pbmNsdWRlL2xpbnV4L3B0cF9jbGFzc2lmeS5oDQo+IGluZGV4
IGZlZmE3NzkwZGM0Ni4uMmI2ZWEzNmFkMTYyIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4
L3B0cF9jbGFzc2lmeS5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvcHRwX2NsYXNzaWZ5LmgNCj4g
QEAgLTQzLDYgKzQzLDkgQEANCj4gICNkZWZpbmUgT0ZGX1BUUF9TT1VSQ0VfVVVJRCAgICAyMiAv
KiBQVFB2MSBvbmx5ICovDQo+ICAjZGVmaW5lIE9GRl9QVFBfU0VRVUVOQ0VfSUQgICAgMzANCj4g
DQo+ICsvKiBQVFAgaGVhZGVyIGZsYWcgZmllbGRzICovDQo+ICsjZGVmaW5lIFBUUF9GTEFHX1RX
T1NURVAgICAgICAgQklUKDEpDQo+ICsNCj4gIC8qIEJlbG93IGRlZmluZXMgc2hvdWxkIGFjdHVh
bGx5IGJlIHJlbW92ZWQgYXQgc29tZSBwb2ludCBpbiB0aW1lLiAqLw0KPiAgI2RlZmluZSBJUDZf
SExFTiAgICAgICA0MA0KPiAgI2RlZmluZSBVRFBfSExFTiAgICAgICA4DQo+IC0tDQo+IDIuMTcu
MQ0KPiANCg0K
