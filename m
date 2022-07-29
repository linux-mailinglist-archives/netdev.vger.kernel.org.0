Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCCB05855D4
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 21:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238989AbiG2T57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 15:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238597AbiG2T5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 15:57:54 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A7388747;
        Fri, 29 Jul 2022 12:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659124670; x=1690660670;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lcjqI8FrP3V5N/9npV1/6lw5cZCj1gLkdJcDcjHZ4tA=;
  b=QQxQiignqrOX4VzD1ChXQIFWI9yTidSGFXkjg0iangbf/0rJ+NMaNcBt
   EzsExpUCyMipe6ZhALgA0LLYchGNkVTcYwIeINg/R2kFeiBp9HpTvYMKT
   3P48wzwuXGL79aoc888P6SAZy91mVnDq4iCmej7nEHyHE1277lNiZk5TT
   Q2Togq7YL+ABK3lxElKrQ76byL+DQkn7e8glZ9WxI8FE0UxQ/rp9n/iJ5
   akVdbG4A6jpFS0gbRjyBjfdeS5Qls8zoyRc9dGiPchJlBbbeFYronKkJK
   xr1+xGRS+lS6vvyffGjQUj+/ZA42rLXrxpfT585R1caOtauAJrN783K6z
   A==;
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="184367832"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jul 2022 12:57:49 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 29 Jul 2022 12:57:49 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 29 Jul 2022 12:57:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DkEMFO+yWv0Huoxt2d+cCDmyRShLIWDQE0ertng5GbQWqhmG+laUw0/Nr7O+IlhcL5bJVZ94XT8Hd00QJR9tvQ2cjLHRbbf64mMHOlq7Xl1WuXfc/23T/vgnp79NSBxHQQpFSIUKQeemu93UsidCGD8RP9Rr6Lh+TtuIuU0sEXSoLURJW94s+Ad/DGudxXjpiBx2/R3ESOohVnRyJx7JXMqEFfRB8R2KUkAIO9C2mODv1HCS8QvHpZxbKF/9JswXiMzPAs+Ssqj0zO6SnX/tZl5NXqhnb9YBSZQ012Lg5E+KkyOTQwwn/o59rHu+tjaIIZV7PKVIsEJGIhC+/hs73Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lcjqI8FrP3V5N/9npV1/6lw5cZCj1gLkdJcDcjHZ4tA=;
 b=feDQgVtXePoGlgMbs69/JBHFny9BT2OiqfaSBoUftLcy9d+sYR7e22csKrcKKc/x0srGTeD/GThHauRyUAep4R8SsWMXEpEE5Huai5T1Dc2OFdb2+Fd6F8Wg6zRL9waEWB+UEwY9xEdCg1mEOpSL3oMYYY00fxMOg7t+2TrmtMNpmBuDcqRVyYGSu8KXaQhmk1II02Ku66h5eBBBY8esthYG9aHv99M50j3o3Z7Z/QjLXxasmdS/Sg8IFs6cbITO/1ygoYQ+gUa71rxYuf3PxNf6UENJBqIvRtVN3WNQf/8lYCR2I344CnkWepxsa2EuEHmZpIalvj038el8B1/7ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lcjqI8FrP3V5N/9npV1/6lw5cZCj1gLkdJcDcjHZ4tA=;
 b=nfryQOzPLyBXnLM3ydIXfzForTtS7IFonYicxPS+K11CrsFFooo4lxslFgZSo+0j6HGLJgUaJhtIIUqRwRJGwHh8uYFhEHh5ZPMyOvSUrxIBapICszfHS0LfAbsefx/l97GepRaEcXn/YmJQT7bFgCGd328moCK2NP+ut0kKElY=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by SA1PR11MB5947.namprd11.prod.outlook.com (2603:10b6:806:23b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 29 Jul
 2022 19:57:42 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::ac89:75cd:26e0:51c3]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::ac89:75cd:26e0:51c3%9]) with mapi id 15.20.5482.011; Fri, 29 Jul 2022
 19:57:42 +0000
From:   <Conor.Dooley@microchip.com>
To:     <radhey.shyam.pandey@amd.com>, <michal.simek@xilinx.com>,
        <Nicolas.Ferre@microchip.com>, <Claudiu.Beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <gregkh@linuxfoundation.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@amd.com>, <git@xilinx.com>
Subject: Re: [PATCH v2 net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Topic: [PATCH v2 net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Index: AQHYo4V27nMabYc56kyi1EJgLCldPA==
Date:   Fri, 29 Jul 2022 19:57:41 +0000
Message-ID: <68815710-cdf2-a8b6-fc1f-5ecef6e112e8@microchip.com>
References: <1659123350-10638-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1659123350-10638-3-git-send-email-radhey.shyam.pandey@amd.com>
In-Reply-To: <1659123350-10638-3-git-send-email-radhey.shyam.pandey@amd.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4395d0fa-6085-4121-8adc-08da719c98e8
x-ms-traffictypediagnostic: SA1PR11MB5947:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: shCS7WXxtC2DoCbzkHavYSDWtvvI2rb3BKCFCpHhBGNhvxoNgdax2UxUNN6T0tZGGsOTSRjtJPGeFL7BfqAtWD3ZCneV1HQ/S/TVAKK8ylhZE/hKlY/SZ7XwyOGt8fDL+DNTbRjYWXHNQNJaCX49h1BTGpxZefaLwzYuV2hAieRiFZ0+DzQqu/C46rF/L1LMeyNxN/OKHaolMW3crfxkL//eqxk2eE2oh2eFqelo8xqYEgrkOz7kJf30ohcYViULGrQtO/ZD4qmBdC4MI9pncvNCVKAJwCRq2Yb6x+T0JLm9leH0d5e5VhSZfFF42mLdqBC8t/wh5hifk+H63DBhEdmYIzimKHmm4g3kZfuLQaeLsGY7UPVtBYDtiD2OvybJAT5aWaPp3rdCWYsJOfZOPT9kiVlHqzYRIvbyb+nJVG5X/ILRemhzSLG9FizNFthfgqIPuQxlZLQG0qAlnc834N1rq+RswzKcHfKLzHVTFoJif3EQPZuSOKqsGlfLHajWrl8VB1vIEuhxJt0kv4T48/WIGhyX0RiDeeXlQdv6Hru9jkOEa2OrSuqHaaSlw1LZsFQZx+LlUR1PteXECVtf2iG0pFJSEa6pBuUNJVnKUptuykQ04i3fmmbHs8gy6dtXBvRnjLS10NGlq3bFq67LT2OW2bmwV+JvxGFkUJapADNVtmH3rjEg7eAHwjeYvBtJ2rDYCF/i0uybfrTX5ymhuB46+rIXWPuSRUc6h4uBikloqhtEH7dj7dDukUXPBgkYXPsc36/EvghtrQrlc1lRev3l5ckeAc/wvkRiIU2CdR+n5vy9VpvQOeH+lc2RpbBP02NuMasNAACHEb4l9cN2wvmMfIX8Ji8rPOZEC4Y+XYhSore+eNZhO/oyM4AdCymz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(376002)(136003)(366004)(39860400002)(4744005)(5660300002)(2906002)(8936002)(36756003)(7416002)(110136005)(54906003)(76116006)(316002)(91956017)(4326008)(8676002)(66446008)(64756008)(66556008)(66476007)(26005)(478600001)(41300700001)(31686004)(66946007)(38070700005)(31696002)(6512007)(6486002)(71200400001)(6506007)(86362001)(83380400001)(186003)(38100700002)(2616005)(53546011)(122000001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmhhMkNGcUNPWmpaeUtFeW14d1hLTmlGWkxXbkRwaFJxc3ZoS0VrSTlXa1c3?=
 =?utf-8?B?VUhkaFgvUzVkQWRzb3hsUHhvYjJJWnZDZnlQQ0FPNzlHZnViVTkxbEZsSEVt?=
 =?utf-8?B?d3NmLzVuTHBkbEdTRnoveEdiTlR2ZDVJQkRnS2JxSXlzbS9kQlhzMnpleDdl?=
 =?utf-8?B?U1BERUVmYXdLd0t4NmQ3WVVheTh4ZEVPTndDdEtGSjN3dVYrY0pLbzQxRTRl?=
 =?utf-8?B?U1JFczRESUVQYnZkTGJXcjJwSkpkT0wzb2lLRW5OUDRNeDhNeElDUzZXa0o5?=
 =?utf-8?B?N212c0NJakhlR1BqcWZpRXdON3lmSjZtL3FGNkI0cFJ5cnRCVHMwcjZqV1hU?=
 =?utf-8?B?MnlPd1pZSDQ0OGs4N0xwLzNLdXRVck51OUtCc3lLRkUvcWFRSkZtbnVzZDVu?=
 =?utf-8?B?Tnh1VUg5YzFoMUY4cnNBVGlHVjJwRGtMcFJWNWdCRWtzMzZIOWtidkczaThx?=
 =?utf-8?B?M1FRSE10OS94d1VETG00UWgrOExpWVpJR080eEx4MXZrR2lLTU4vWG9oNGJs?=
 =?utf-8?B?TmdlY3pXSTVndENreldqSWs5YnVaZzRXMXlQZ0RuMFhHSXpYVVp6bDdRd0o4?=
 =?utf-8?B?b2FVOGpqMEVCZzczcnBqaHkwYnl2V3NveHlrL0MvMDNzcTE2ajNNNk82Tk1R?=
 =?utf-8?B?R24rM1l2THpxRHpHcFVOV3VPSmY2VGxqZGlxR1F4NFVNdXZJRzQyZnJhMnVu?=
 =?utf-8?B?b1dNZTYrM2RoQTYrMWRnL05VdU1QY3QydlJNVFlQc0pFQUhjSmlZRmxQUXZs?=
 =?utf-8?B?UXNtUElHVGdpMnVTZGF4cGU1VjU0U0RtUWdCMUZEem1udGJxcmkvb3VzVDkw?=
 =?utf-8?B?M3BHOVJMWEFIc3dkTUF1V2NVSXNBMGZGdkRqZ2thRGtXZTJhOFp1SHJaQS9Z?=
 =?utf-8?B?TlU2WTZSNTR0c1Z1SDJEem10bU52MnZ1eWRGdERUeFU1NWVqUkIwLzF1dUpG?=
 =?utf-8?B?T29LMmMrYzJhZ3lPeFZBMkRYd1RUUFBPMWlNS0U0TlIzbmNUc3BvOGJCeGlj?=
 =?utf-8?B?WSs3N3VmTy9LV1NyQXlMR2J4WDE5Q0JvMlRyR1BrVEtQOEZhdmh5UWFKVy9Z?=
 =?utf-8?B?WllFekg5Q3g4NkRtOXF6ZXlleDR3THVRekNWcVRjU2hlZXBKN1dzaks5Vmdu?=
 =?utf-8?B?Wk8wdnI1aUVEKzBONmVFa1orcEpZMG0rUi9SRXFDV2JqRzNTeVBPK2UxUUMx?=
 =?utf-8?B?dE9FcE9UMXVWVkdJYkh6NUNxVE00K1F5VzFSaTRHWmpmSG9waEJycDVkRzFZ?=
 =?utf-8?B?amhqTlJUYXYwTXR0OHc0ZnUwQ3JEQXdZR2F4bGw2ajFraHFFLzZuOXZreSs3?=
 =?utf-8?B?QXQzNVprSVJTREVGQUREMCsrZ3ovY251M2d1QjM5dkhCK2NYTkxZYVhiRUUv?=
 =?utf-8?B?TWRRbkZFc3FBMk54MWlyZWVrUmtEKzgzME0rM1gzK2syenFiV09Qbjdaaksx?=
 =?utf-8?B?Y1JpSkFHNC9zb2MxK3QzRGlLUHNJMkpWa3c1cm9aZUtDVUVDb0U3dFJ4Tmg2?=
 =?utf-8?B?citLTzBxOTc0ZHBXbklxMXZhdUlZbmhvV2huVG05emIyOGtXYWNUTWpQR1R5?=
 =?utf-8?B?OC9adUlpL3pDSXYzWVYrazRzZDlGT1h6TytBZVlJZTI5U3NnNU9GV2hhSjdN?=
 =?utf-8?B?Z3pvSTlnZmtnVldHeVBwekpFVTdZRWg3SW11K3oxTGFRdjF3dGw0bWRqS3ph?=
 =?utf-8?B?NVBIUkdybytCUmNnSHJBSXNucWY5QW53MWREaTBBS2dhWTROWHNmd1QzWlp0?=
 =?utf-8?B?aXE1eFZKKzFjdkJSZURtVXdLSWRpRDMrcWdnZXNEUDBjTGlqN0Q5UWQ2U1pX?=
 =?utf-8?B?L3JDUjE0VllxNzdIWWkwR3gxSFdrLzBHN29BUW5yNU4rNTR2RUtzeHQyNGJw?=
 =?utf-8?B?MjFsOGRYVGJ3anNCdFpZUDd4SkhYM1UvNVR3V1J5dy83dkRjc21yejdGTUNQ?=
 =?utf-8?B?WTlFa2NreSsrWWNlc0xQZWpFQSt1d2RqNVdsckVadVNvRjZRSVd2ZzJ6SHY2?=
 =?utf-8?B?cng1MmRoZ05TVUt6Z3c5bmIxUFFTblEvVW5XOC9GZjRoWkJPa3o4Uk1jb01Q?=
 =?utf-8?B?S0dZUHIrSGV4WVF4YlJEVTc5TUV4SjQ4SmVKVzh1d25YcDJmc2o0VFpTVkNO?=
 =?utf-8?B?akhJK2RYenBCazhvUno3allVbXM0cXNzTjJzc2NxQmd0RjVVMC95bWNYc1Nk?=
 =?utf-8?B?VUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <01838CEF147ECA4390A26DE0A4BF13C5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4395d0fa-6085-4121-8adc-08da719c98e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 19:57:41.9935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nss1iOn7wThviWpKMh+yjKbhTdghEpgteuAEluv1JP9Oj4wMyAhk0Foe5r34YjBi7l3YLaBDXJ+Ch/yS9974UL5TcrVcA4VLMXPU1D6D5K0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5947
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjkvMDcvMjAyMiAyMDozNSwgUmFkaGV5IFNoeWFtIFBhbmRleSB3cm90ZToNCj4gQWRkIHN1
cHBvcnQgZm9yIHRoZSBkeW5hbWljIGNvbmZpZ3VyYXRpb24gd2hpY2ggdGFrZXMgY2FyZSBvZiBj
b25maWd1cmluZw0KPiB0aGUgR0VNIHNlY3VyZSBzcGFjZSBjb25maWd1cmF0aW9uIHJlZ2lzdGVy
cyB1c2luZyBFRU1JIEFQSXMuIEhpZ2ggbGV2ZWwNCj4gc2VxdWVuY2UgaXMgdG86DQo+IC0gQ2hl
Y2sgZm9yIHRoZSBQTSBkeW5hbWljIGNvbmZpZ3VyYXRpb24gc3VwcG9ydCwgaWYgbm8gZXJyb3Ig
cHJvY2VlZCB3aXRoDQo+ICAgR0VNIGR5bmFtaWMgY29uZmlndXJhdGlvbnMobmV4dCBzdGVwcykg
b3RoZXJ3aXNlIHNraXAgdGhlIGR5bmFtaWMNCj4gICBjb25maWd1cmF0aW9uLg0KPiAtIENvbmZp
Z3VyZSBHRU0gRml4ZWQgY29uZmlndXJhdGlvbnMuDQo+IC0gQ29uZmlndXJlIEdFTV9DTEtfQ1RS
TCAoZ2VtWF9zZ21paV9tb2RlKS4NCj4gLSBUcmlnZ2VyIEdFTSByZXNldC4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IFJhZGhleSBTaHlhbSBQYW5kZXkgPHJhZGhleS5zaHlhbS5wYW5kZXlAYW1kLmNv
bT4NCj4gUmV2aWV3ZWQtYnk6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gVGVzdGVk
LWJ5OiBDb25vciBEb29sZXkgPGNvbm9yLmRvb2xleUBtaWNyb2NoaXAuY29tPiAoZm9yIE1QRlMp
DQoNCkRvIHlvdSBoYXZlIGNjIHN1cHByZXNzaW9uIHR1cm5lZCBvbiBvciBkaWQgdGhpcyBub3Qg
Z2V0IHBpY2tlZCB1cA0KYi9jIG9mIHRoZSAoZm9yIE1QRlMpIHlvdSBhZGRlZD8gSW4gdGhlIGZ1
dHVyZSwgcGxlYXNlIENDIG1lIG9uDQpsYXRlciByZXZpc2lvbnMgaWYgSSBwcm92aWRlZCBhIHRl
c3RlZC1ieSA6KQ0KVGhhbmtzLA0KQ29ub3IuDQo=
