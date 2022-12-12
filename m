Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C08364A404
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 16:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiLLPUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 10:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiLLPUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 10:20:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C42F643B;
        Mon, 12 Dec 2022 07:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670858415; x=1702394415;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+RhOH5rKkeynBM6qqSVzLfsAN4pHNpXsT96Q553+k8s=;
  b=PMMj4VbdTiSCKIM+fP5wnB/wrYyxOHmCmmbJhNSa/YVrbT3DU3wV7sF0
   KHG0Bs0SwHtzUhr1otABHnHog6MePDIBq+cgVd9afc8V1zbzyRnHjyiuh
   bYWUdfxnCcch+FsVlGqgzwgI3Ckud7/djEFjrqNPyJUKMGxDlppnZl6va
   I5humBgzX8XNg/dn/rwAvXKgzyL9B+jhJByQN03JPHLJ3edSFJV9v9ykI
   urerUqLeKwR61bXci09492b50qdPoSTc3s2eoz339L+QFn3JGaJwa8y/5
   e95lxRPIJK7iw6lBB/wIGo8jMdOfci5Th+xfGeUBme9Kk1PGMNOS/oiyb
   A==;
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="127709564"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Dec 2022 08:20:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 08:20:13 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Mon, 12 Dec 2022 08:20:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCngcykhheAoAxq1Er2JpqZXWzmj8RT1sjZeen8D5RfDkngJn+kL/P0CB6sYZgY+nqFi5l6jnDcOF8b61yaONntWQ+ZP+tID5HmquOIWhLaqUBgK4faYB5rYX+n+d72fs9+uJ+6BLphx2Asgvo7o7ko3ZAKQ6PTlZMyDaOCp4CwkSC0x33UiJgzZTFpsVErT7HO5WzP+BiIBe9n2NfGBG6TuDUPnWI3tbOt4vHTk5+sh9TKHp55NU6zuU82qPt+280glwZeQIkBAN2yF3NzwuDYQsbnSDcW2H3YAP7a8rfPJNY2+qygp2VVQbw8LPCO0lBYVT+BWHkO9zO96c6vCXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+RhOH5rKkeynBM6qqSVzLfsAN4pHNpXsT96Q553+k8s=;
 b=jVvC8OUMDeVghTqW4rjmj6Qoz8SLPLhmdtmbzoNX+9fVKLwKJHkxj+xcuzf92/lSxARkDNiANIj/hZw7i0slY1zCOui0rBRmzXhYYopNaSp9lYF4wgZm5d4JYqq10lYywgQfR93lqeu3Qq1720OonEuBaJHu2JnckL4Kgy3C0Qdc+Nh3rvR4r3EYbmjwlA7VGntvtRNsHvoKMbd/LsNVU6o2cAzfEWv5DIS7ei4DHhmczsptFFBOTeifc8qENF+ztnS0V9d4MzA+N9eOQho367ee6QQB/Q480hx0ug/78VJXQuW0/FSLmAh/Xq2K9Kqh1wIn4Dsy5c++4mPflFTT2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RhOH5rKkeynBM6qqSVzLfsAN4pHNpXsT96Q553+k8s=;
 b=hrza7C9m7yZ/8T7wZquieIN3k7eavgmKc4VK87akF/UmKl7y/l6IGeIL06GT3mB5sdTI8H/Aq0pTHCwo1+HA3QfeKiXTy12c5SV6B7jRGMoOPcdC4KoMnYV9s/fFF8luvX5tEl4qZ25dT+P1sJk7eAAI7iPah0Vtaj4GPnu2Zlg=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by SJ0PR11MB6741.namprd11.prod.outlook.com (2603:10b6:a03:47a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 15:20:11 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::98f6:c9d1:bb68:1c15]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::98f6:c9d1:bb68:1c15%10]) with mapi id 15.20.5880.019; Mon, 12 Dec
 2022 15:20:11 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <olteanv@gmail.com>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <Sergiu.Moga@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] net: phylink: init phydev on phylink_resume()
Thread-Topic: [PATCH v2 1/2] net: phylink: init phydev on phylink_resume()
Thread-Index: AQHZDj05DeIvdihsbk2VReDf1L84sg==
Date:   Mon, 12 Dec 2022 15:20:11 +0000
Message-ID: <d22c8ec9-49d3-3af6-cf0e-14558cbfc17b@microchip.com>
References: <20221212112845.73290-1-claudiu.beznea@microchip.com>
 <20221212112845.73290-2-claudiu.beznea@microchip.com>
 <20221212135408.j23agcjrikiucq4a@skbuf>
In-Reply-To: <20221212135408.j23agcjrikiucq4a@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB1953:EE_|SJ0PR11MB6741:EE_
x-ms-office365-filtering-correlation-id: 919c9cf9-408a-42b2-dab8-08dadc545c6f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WkRMWL2g5evo95hPA4+inGGS10hzIYwhVO4VqsE2vzlEUfgy7APWsbMfZN1/+BcGM5AkMBTxt6m/SOt7E97yrpgnRDVmepVYyAl7ZXwrYGmj7k/B3t11E1o57GJgReW2amt/Yi7OwE4Fyjhulrl2DJF1LoPbZ3gvyImaA08KBdI4mACwZX31Yv+JR4CGtVdDWeTEm/a7Sk5bIQcg3dTFLAX2d+L+sHyZvujw85/GfgWb8qtqhURoYejSLkJctH82C9j2VTwaWzKKUMjAeQFDb0sAGSNb/viyvngg9GwSo4yMQ93a/4FW6/m5LYqIEpZJFl2g+14cVIWn7XHfv2eiD77OD5LWhyzf28kMR+R4cZ/8t49b0beYaLl6qrNykgPX2kKQJqbtKuZHeNPWHPo0M7oMNrkJB0weuptZyOysYv3rK+UXTQgZLRPzc1Bo/9njsikO1BOi+mtIlypHElcKYLXF/W/AGmz+bCdxqcwAIs1tofxh9paAdKruJFBjgJI81hyAV90NYlDnuDI1C4KTztlIJkl3zobOl7ERg1GsRN2+lkG9n9pPrsG/mOhWRmTUfZhtwdG/e7wCPopoBMqfM1QiuxuMMFYJ+QYjaZxiPNYzfqkMRhOhc9Ly88/vkW2NzWGZY8NypPDSQwZElhInxjnNljPU7CEjNKOYaunH1spCpjxPEDW2H4LHMbbDFsyHY5ut8do7jRgnza9WHv001CvJcUKet/H0E4IEXE4uyndcooasMKppgdQUv9+VVituR2EOOAy8bx08hyJ0QFJH8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199015)(122000001)(38100700002)(31696002)(86362001)(38070700005)(6486002)(8936002)(71200400001)(478600001)(41300700001)(66556008)(66476007)(66946007)(8676002)(4326008)(316002)(76116006)(6916009)(64756008)(54906003)(83380400001)(2906002)(6512007)(186003)(26005)(6506007)(7416002)(53546011)(2616005)(5660300002)(91956017)(66446008)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjZZWHF4NGs0dzJ6SEpKbGhiejlTVkp2QjFyR0VrVGt6dEdjeThDZEI1RFY4?=
 =?utf-8?B?Uk5tbFdmUXhURERwTjN3TU9MdjBuQm9qVGFFUVhWakdOaytnSkN3SUI5bWsx?=
 =?utf-8?B?OEJqY25SbGR1aW9teEpFSnA0d0VQWHduOHRwdWZTS3h0V2VNS2kzSEF4UWI3?=
 =?utf-8?B?L3Jmc2UwNnZuL2hpSS9xRnd1a3hVSWZVMEZPTHhUS1NKWGRLckw5dzBINktm?=
 =?utf-8?B?MUplYzBEcytMZUFiZVNqQksrS0FhUEVscThWQ1k2T292Y1FvMjRlWHpDTlpN?=
 =?utf-8?B?Y1hhYi9EQTdkUktVQUlNQTFZWkNjaCsreEtENy9sT3NHY2gzQzQvVmpHVFhJ?=
 =?utf-8?B?UW9nOStubjdzb0RHU1JGNnBlbHkrcWs4TDN3TlczWnQxMFdkRWkwVFhiWnBt?=
 =?utf-8?B?S2dieEhySmRacGw0MWFtb2lKaGxtV3h5NFZ3SFhZeVVaSVJSZExsV2Y3WmF1?=
 =?utf-8?B?cGdnRXVvZW95bG84dllkdHVLdWlCSjBIY01rRW03ZXFjVXp0VHlacGRpaDgr?=
 =?utf-8?B?Wmg3YlU5RGVaY0NBd0c3eGUwUWdReGlpbzY0RFdmS2xmVm9kWHhmWmpxOGg0?=
 =?utf-8?B?WmxKbE5XZTJNZy9qbnQwNjQ3M3pKazBaL3oxZFhYL1hYTDFJK1B2ZWM5MVRQ?=
 =?utf-8?B?TlBzZHNYQjJad05jQWFOQnN3Q0tXOThtc3NNUmhpUUlmVXRKdFdmeGNhbFQ1?=
 =?utf-8?B?alpIMFE4OGU2b0x6a2pUNjcxUkw2Z1hoclZzSjVyYWZEclAvL2MvRnY2NG4w?=
 =?utf-8?B?TVlRQXRqQkh4dkZSUjU3aXhBWjB4Q1BGQVVSUzI3RUQ1VUN1YXBVNzVGWmxF?=
 =?utf-8?B?eXhKSkZoTzVaTmtFbm1LSWF4YjVZNnZCRVZtUjZmN0lMNGRZSXNFbS9veExO?=
 =?utf-8?B?VGF3eFBkQnhaNTB2VEJYbHQyWGlYQWoxT2swWXdwbE1vY0hDVTkrTnVmZUFo?=
 =?utf-8?B?dzhIejdnZ1R2SEU5SlBIYmQyMkh4NTRZbzJ0VklqQlkxdnlRNkFMRW03UWRt?=
 =?utf-8?B?dEhXSEQxdU94ZTJKei92cDhPZnUzRVA2NG5jS1V2b1lCSktKQW1SL2l0MUtj?=
 =?utf-8?B?UW9meExiWXNHdkZyQXdOTGR0Z3FRZnRoWXlyS09MYTFsMkJUOEVWWm9XSnNU?=
 =?utf-8?B?cjZPQzJ4L1ozLzFvaVNIVEIydW9ZdVp4WDR3UGNiYWI1VDJVOGhOY2svWWl5?=
 =?utf-8?B?N3pjQ21LZmlSOE5INzk3S0grR28zMGdYTFRWcDEveDlIWDJmam9xSTJ1cElt?=
 =?utf-8?B?TStDZHhma0ZrN2dBWk91TnFaNVAwMUJMdlhLKzF1SFhqZWdPREpVNzBrNXJi?=
 =?utf-8?B?Si9UQlQ0VkcrOGFtdHVxTStwNzlLdzB2VjVNdDlSSzNuaW9BbW9qQ3dQVVlw?=
 =?utf-8?B?WFM1YkhoOWlGZzFXNmRxK2x5YTQxR2tDM2Jlc05lTXB0Q2M3Rk5GeXlOTXkr?=
 =?utf-8?B?L3JYK1I0czdxTmIwY0FQS3FLSzBlZjBrZkRxSXM2Y29rdFNvdDZzUkxEYTY5?=
 =?utf-8?B?bjVEdllISklLNGR4YTJZTHhiQlRNdVlHcjRIajZQQ3FMT3hrZWRvZjJ4YTBQ?=
 =?utf-8?B?bGExQTJORVA5aTk2dGdqd0srbHNPYW1oNEhMa2dFcEFnQWhRSWlCWmJGSFJY?=
 =?utf-8?B?RDNUbXJsNWVweG8wWHJQdkgxY2ZqUVM0TXhqNU5WVDlGUURVZ1ZXK05vQ2VU?=
 =?utf-8?B?MUw5a0NtbzVCb3g5Yi9CQ3JVWG5YUjUrOE5GVEE4Ull0Ni9zTmpISnZvL21t?=
 =?utf-8?B?aHBlMThUeGdyTFlYR0VjbkdrR2RnNW1iMWhyQ21WQncyV3JMWUFEOEV1eGEy?=
 =?utf-8?B?RTFxdmo2TVpsTWRxY2IxNytDaHFzQ1RtT1hPemlvUzBQS04wRGpUY2xaWVJE?=
 =?utf-8?B?ck9lck5yaEVrM1g0UVlsVllDUEcrMHdNRWU1SmhNajk4ckZCUFZSbnQ0Ukh2?=
 =?utf-8?B?SnpGcTJteUtiek5aaFQ3ckJvajkwVVFxTHhvRWZEUGIrVlV6N25sN2VIS0Z0?=
 =?utf-8?B?emMyKzVGVS9CbmlaOTFBZDJnRk1kOHJrTzBNNkdHUCsxWGNmWkxTUVJURGFi?=
 =?utf-8?B?WWNRMlh1bnVySEExYTVDN3pJVGJHQzBncGZFYlJhS0FXZHF1Sm1mQk04OWto?=
 =?utf-8?B?dzF1QUNPN2l2Rms0elgxRGx6M3JEZkdnZ2JkMnAyRkpFM0R2VFphRXBiRGlE?=
 =?utf-8?B?S3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28C77561E8831C41A15DE37BC9B08505@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 919c9cf9-408a-42b2-dab8-08dadc545c6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 15:20:11.2231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z+YFH80rsODIIQXa2y8HFHyCwVNyyMva2y21c066Z+hql5cqmEn44dYFQpVTHYrUF7tomZet3PQL09qzPCWnJrMutxpTuDDVdTpF9vD7U+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6741
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksIFZsYWRpbWlyLA0KDQpPbiAxMi4xMi4yMDIyIDE1OjU0LCBWbGFkaW1pciBPbHRlYW4gd3Jv
dGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2ht
ZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gSGkgQ2xhdWRp
dSwNCj4gDQo+IE9uIE1vbiwgRGVjIDEyLCAyMDIyIGF0IDAxOjI4OjQ0UE0gKzAyMDAsIENsYXVk
aXUgQmV6bmVhIHdyb3RlOg0KPj4gVGhlcmUgYXJlIHNjZW5hcmlvcyB3aGVyZSBQSFkgcG93ZXIg
aXMgY3V0IG9mZiBvbiBzeXN0ZW0gc3VzcGVuZC4NCj4+IFRoZXJlIGFyZSBhbHNvIE1BQyBkcml2
ZXJzIHdoaWNoIGhhbmRsZXMgdGhlbXNlbHZlcyB0aGUgUEhZIG9uDQo+PiBzdXNwZW5kL3Jlc3Vt
ZSBwYXRoLiBGb3Igc3VjaCBkcml2ZXJzIHRoZQ0KPj4gc3RydWN0IHBoeV9kZXZpY2U6Om1hY19t
YW5hZ2VkX3BoeSBpcyBzZXQgdG8gdHJ1ZSBhbmQgdGh1cyB0aGUNCj4+IG1kaW9fYnVzX3BoeV9z
dXNwZW5kKCkvbWRpb19idXNfcGh5X3Jlc3VtZSgpIHdvdWxkbid0IGRvIHRoZQ0KPj4gcHJvcGVy
IFBIWSBzdXNwZW5kL3Jlc3VtZS4gRm9yIHN1Y2ggc2NlbmFyaW9zIGNhbGwgcGh5X2luaXRfaHco
KQ0KPj4gZnJvbSBwaHlsaW5rX3Jlc3VtZSgpLg0KPj4NCj4+IFN1Z2dlc3RlZC1ieTogUnVzc2Vs
bCBLaW5nIChPcmFjbGUpIDxsaW51eEBhcm1saW51eC5vcmcudWs+DQo+PiBTaWduZWQtb2ZmLWJ5
OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCj4+IC0tLQ0K
Pj4NCj4+IEhpLCBSdXNzZWwsDQo+Pg0KPj4gSSBsZXQgcGh5X2luaXRfaHcoKSB0byBleGVjdXRl
IGZvciBhbGwgZGV2aWNlcy4gSSBjYW4gcmVzdHJpY3QgaXQgb25seQ0KPj4gZm9yIFBIWXMgdGhh
dCBoYXMgc3RydWN0IHBoeV9kZXZpY2U6Om1hY19tYW5hZ2VkX3BoeSA9IHRydWUuDQo+Pg0KPj4g
UGxlYXNlIGxldCBtZSBrbm93IHdoYXQgeW91IHRoaW5rLg0KPj4NCj4+IFRoYW5rIHlvdSwNCj4+
IENsYXVkaXUgQmV6bmVhDQo+Pg0KPj4NCj4+ICBkcml2ZXJzL25ldC9waHkvcGh5bGluay5jIHwg
NiArKysrKysNCj4+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspDQo+Pg0KPj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9waHlsaW5rLmMgYi9kcml2ZXJzL25ldC9waHkvcGh5
bGluay5jDQo+PiBpbmRleCAwOWNjNjVjMGRhOTMuLjYwMDNjMzI5NjM4ZSAxMDA2NDQNCj4+IC0t
LSBhL2RyaXZlcnMvbmV0L3BoeS9waHlsaW5rLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9w
aHlsaW5rLmMNCj4+IEBAIC0yMDMxLDYgKzIwMzEsMTIgQEAgdm9pZCBwaHlsaW5rX3Jlc3VtZShz
dHJ1Y3QgcGh5bGluayAqcGwpDQo+PiAgew0KPj4gICAgICAgQVNTRVJUX1JUTkwoKTsNCj4+DQo+
PiArICAgICBpZiAocGwtPnBoeWRldikgew0KPj4gKyAgICAgICAgICAgICBpbnQgcmV0ID0gcGh5
X2luaXRfaHcocGwtPnBoeWRldik7DQo+PiArICAgICAgICAgICAgIGlmIChyZXQpDQo+PiArICAg
ICAgICAgICAgICAgICAgICAgcmV0dXJuOw0KPj4gKyAgICAgfQ0KPj4gKw0KPiANCj4gSWYgdGhl
IGNvbmZpZ19pbml0KCkgbWV0aG9kIG9mIHRoZSBkcml2ZXIgZG9lcyB0aGluZ3Mgc3VjaCBhcyB0
aGlzOg0KPiANCj4gICAgICAgICBwaHlkZXYtPm1kaXhfY3RybCA9IEVUSF9UUF9NRElfQVVUTzsN
Cj4gDQo+IGxpa2UgZm9yIGV4YW1wbGUgdGhlIG1hcnZlbGwxMGcuYyBkcml2ZXIsIHdvbid0IGEg
dXNlci1jb25maWd1cmVkIG1hbnVhbA0KPiBNREkgc2V0dGluZyBnZXQgb3ZlcndyaXR0ZW4gYWZ0
ZXIgYSBzdXNwZW5kL3Jlc3VtZSBjeWNsZT8NCg0KSSdtIG5vdCBmdWxseSBzdXJlIGFib3V0IGl0
LiBJIGhhdmUgdG8gbG9vayBmdXJ0aGVyIHRob3VnaCB0aGUgY29kZS4NCkF0IHRoZSBzYW1lIHRp
bWUgcGh5X2luaXRfaHcoKSBpcyBjYWxsZWQgYWxzbyBvbiBtZGlvX2J1c19waHlfcmVzdW1lKCku
DQoNClRoYW5rIHlvdSwNCkNsYXVkaXUgQmV6bmVhDQoNCj4gDQo+PiAgICAgICBpZiAodGVzdF9i
aXQoUEhZTElOS19ESVNBQkxFX01BQ19XT0wsICZwbC0+cGh5bGlua19kaXNhYmxlX3N0YXRlKSkg
ew0KPj4gICAgICAgICAgICAgICAvKiBXYWtlLW9uLUxhbiBlbmFibGVkLCBNQUMgaGFuZGxpbmcg
Ki8NCj4+DQo+PiAtLQ0KPj4gMi4zNC4xDQo+Pg0KDQo=
