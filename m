Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E471C640638
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 12:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbiLBLzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 06:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbiLBLzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 06:55:23 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259EEDF637;
        Fri,  2 Dec 2022 03:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669982025; x=1701518025;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IFzXYr3e4jwzRlwnAhELd1OJ1a/HtkyZ/BXJmUceAA4=;
  b=C3JT4criDxO3SX6PN3J1dqPYq4nHQTcue3RwZS7OL3DE0Z0STJ6ejOfi
   hXbRFkI749PoVvUOe0c652PIsDLEd9soK74xeH6IDL005lzLwuCEbPEHW
   626YH+ooml357Ytvfmf2WgBNIA7TufJgKAdAydZnrwqsYZPSJILinMFJZ
   lQqmdTcoSSgMk8U5Gz/5rSe8Gy8EwSWbKMyR3GBARSQP3EbkyVDoGCxnk
   HovgtYq2r11zw3s+VU0LOhlZOmw2M0pZHGoLswjPeWbU/lja7SdCPoINM
   1a4os7Q54BBk+Ci+VcK3vPRXKyboqYp4XyyKD6HzSpcOjlLFONV16uagP
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="189727655"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Dec 2022 04:53:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Dec 2022 04:53:35 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Fri, 2 Dec 2022 04:53:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eaBtvoFm3pn521cAGk2HtHMj+oo4Mk6Epg5+RkqGOTjpMhgEXSVMnatRyAvd3pCXTZLWZP91nTIwV/2D8+k4ezHWxJtEppheMn6/24p7dXUZ4eNklLGdRxx0fep3aw9I65iaXqWhN8tigw36vVZfX5nRYUCcdsbjvEKmgNbwLWHTzeUko+3he+69O9sYwuqLaW8eIpbYwTz5UIW3J08bDiUC1U2ulClAfPK5ne3AzlHhMh2RaB+Katk7wiVW1yJ21asa2Pbp1VfpEAFppiY/WbWWipmGY5+TFIdGYsYX3Tr4hDRVlZnwzEL6whYbKrLugcntfLXmg1YbtGMzA4GlPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFzXYr3e4jwzRlwnAhELd1OJ1a/HtkyZ/BXJmUceAA4=;
 b=GL/4aRqwSfVBwZLz6KsKG+/9HDj/RafWspNSmZcGehCeT/RyxBtXwlSjxF0a/xxyZ5hfnjdDtCEnDX2PAP9KHp2hROqH10/QHE4sYD+xJH7AVg+KJAroyGq2FHncnanrBrkXMfAKIZ9YeDDxxh/Scrtb/Gf7W4WpXizhkFtoZD+0QKP3ZTVljzPZnBQcRQuOSWvM+NsPeAmgtyuFbu2jyC4QqCSIp0hbWPpGql0bi6xmwEOl/L+aA8roydHfw79sqiDLR+iLkXkw5oo7bxwbMYc+QoDNSBU+FOyni96GZA7afLBjUu0k1f5KmEiNEZRLapXfy5+23Lsf1xnQXXK6kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFzXYr3e4jwzRlwnAhELd1OJ1a/HtkyZ/BXJmUceAA4=;
 b=kp7MyTdSDVruqAvELWnhDc46c75ERSQ17mlYO3X+kaHp7lhLiAnoF/2YF/1gCXm4+8fU6jEOylbqryOKJZjWc2xfRTwnvxhWJ50r47IOmy0gnSZAuewxtEvDj+e3AeFDFf9khDaKTSrl2VZtY+iuF9nnEHPuFotacsLxDB1cizg=
Received: from MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9)
 by MW3PR11MB4745.namprd11.prod.outlook.com (2603:10b6:303:5e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 11:53:33 +0000
Received: from MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::5a5d:62cb:c735:3cfe]) by MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::5a5d:62cb:c735:3cfe%5]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 11:53:33 +0000
From:   <Rakesh.Sankaranarayanan@microchip.com>
To:     <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <Woojung.Huh@microchip.com>, <linux-kernel@vger.kernel.org>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <edumazet@google.com>,
        <pabeni@redhat.com>
Subject: Re: [RFC Patch net-next 3/5] net: dsa: microchip: add eth mac
 grouping for ethtool statistics
Thread-Topic: [RFC Patch net-next 3/5] net: dsa: microchip: add eth mac
 grouping for ethtool statistics
Thread-Index: AQHZBL/kFk8KaIXPwki3IPVPsEeqbK5Z/EsAgACDeYA=
Date:   Fri, 2 Dec 2022 11:53:33 +0000
Message-ID: <6c1a53a825bee2b22f7e532885e6e777685c0726.camel@microchip.com>
References: <20221130132902.2984580-1-rakesh.sankaranarayanan@microchip.com>
         <20221130132902.2984580-4-rakesh.sankaranarayanan@microchip.com>
         <20221201200230.0f1054fe@kernel.org>
In-Reply-To: <20221201200230.0f1054fe@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB6088:EE_|MW3PR11MB4745:EE_
x-ms-office365-filtering-correlation-id: 704a6199-6f3c-4c3c-fa33-08dad45bd6ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SBWB4k8UxgKPkjg7IXwkAOcwi6C6MEo2CG6Kczun+KT/6Eg9Yi4zxPM2iwVfLhH+JEFwWZxMpRyxtPAFx9+A24VB2N25fUNPflMDQrbQ/vc3BQxwk4ezUS7jqe/MmXLoMjpybemM917cl86Fj4a2ilyg5iWECmClSwn0vkGge+Ue2AZSaWEwnMpxMvk5qWbwT2QFaIpaC75kz/kkJCrtWn5AQfW70pd4NKoZCgkn1tJybvj5xERtDSvv8K0MDpB5UQ15g/PM4GsNYSwl2gWY1sl5dvqEuOMoix+8vtW96Hwys6PAsD8UYlTTTbBM1j1ZR7dETYFlcZjtVB6vFoX5y+RzxA4pQOFsNcF9LYS3d7Vv0JdcBvkJ0FL0Vvus6bT3wirWIbJHP+b3v8FsxELeS1iDJmlN9CDUccqnaGqOjc2ijs0PUrGpQAwf5XzQWqdnoKCkPjUKSWPUch4ZOi8cs4/iI6aJCLsE8iO2T0pA52U5Yri02N77hYI85zo3exo0n9HHbHkcU/N9H6zlgkCtXt+TEIVQ0l76/xs+fQ0upBl9nK25xpPyaQJz9C3RiOvXbsM+09qFaJJ75mlYFD1OO4MppJCwKo+HBz+Id1mnwI5JO0ihfa/sqiJCDzB6qWDQR7frIjBtiMOvZxm4VlcTfKtCHoY1CvsthbEwkgMrYw3AWHqdCJGehMZvUQrUic63QM5BGZwr8BPs6qjZdGH1Qw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6088.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(396003)(366004)(136003)(346002)(451199015)(316002)(6512007)(26005)(6486002)(8936002)(122000001)(6916009)(54906003)(2906002)(2616005)(83380400001)(5660300002)(91956017)(186003)(41300700001)(36756003)(64756008)(4326008)(66446008)(8676002)(66476007)(66946007)(66556008)(76116006)(478600001)(38070700005)(6506007)(86362001)(71200400001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0NEL1BtMlV6Tk5RNXlwTVpnVm5sTFE2RStUSHpjMFB6aDFsVE1iU1F6S2lJ?=
 =?utf-8?B?SkxCK1ExS2Y5dk40ODl2NkFyeWZtZ1NkRWFXUnlxZGNDM2NDU21ZU3FMTGJi?=
 =?utf-8?B?MUIyaGNNWXJzOGhJak9oS2lEanc0UE9ZK1J2QkhveEVlSVpPd2dWWmF6Ryt2?=
 =?utf-8?B?SmttZUpEWFVOeVkxMlUxdk5UMnIvMGNMSmZaZGVSYWZyRjJVN1c3NEFZV0J1?=
 =?utf-8?B?em1DRTRjN0tDRU9rNGlEekhxS3NwUytRTlpDcnB1TityTUtBSS8yTWxaUS9B?=
 =?utf-8?B?MlV3VTdHM2MrTzBPclJXeGI5QUZiT25keXFxT1RPSFVNV1NYb3p3Zm53aUlV?=
 =?utf-8?B?dWxLNTVPK2w1QVZNL2JzeXMxYlc3VW5teEgzemFRTEtmUmpWTU5jVm8yTndE?=
 =?utf-8?B?SGZRYXpPZVdsNGlnV0syMW5UenZJOXBMblZPcWIrK1VTNWdDZjJUaEJYY0NH?=
 =?utf-8?B?elhqT2xHTzR6bWFKU05kRitXUjd6YXFDNjVoT3RkY1lSL0ZHWUdrL0ZFMnI3?=
 =?utf-8?B?aWVTZUVGb3owQjJtWlZCakthd1BBU3YwanVhWUg4d01KNnZ4alVFK3RSV2F2?=
 =?utf-8?B?NlhlZXB1empVSWI3L0Y5UmxlNnZ5Wlp0Rk94RHRJTEJyeFdLOEQvcGp3R2VD?=
 =?utf-8?B?SnVYbjl6TmpwOHA2a1FLMjRiK0g0UEEvSEUvblIvZlVXaFFISlZqVFl3UWpB?=
 =?utf-8?B?MmsrcDd2VDZuUVFuV0phVk1GMDd2Rzh4MFdJNDVxTzVDK2tIRVFYMzJWOUxm?=
 =?utf-8?B?T3RvMjlmQjNoUGo1dDZ3OG55TUU4UHkxQXcvU2U1Uk1EaHpZNmNLbGpYaktN?=
 =?utf-8?B?cTBzc2E5eEpzN2RQZDdqRC9tcVdlWmZvNFJMcjcrdzVORU1ITU9adVhWdFRD?=
 =?utf-8?B?TDdZZVpXV2EvWUNZaWFUN3hUc05uWjFxOTFjTi93bzN5TzlsU0tSYW9wQTcy?=
 =?utf-8?B?eWttQUR0VzFwU2VPT0dnaFJzNTRyc1NmdHlCNjJSNWdHdjc1TW1XRUFBRldS?=
 =?utf-8?B?T1dQT213ZDZBSm5DOEV0SXozSklZL24wTFBYZzJyUnB0aWVQZmFpZi96V3RU?=
 =?utf-8?B?NXVpdmZ0QlE4VXMwS2lNa0t6S1UyQkREVUd6TGpzdWJ3ZUd1Z0ZtN1N2Zk5l?=
 =?utf-8?B?QzVNc1A0cTNMeWxuQlpnMU5EdTFkYUw2bTF0OU03Q0Fhek55UWlaa2pPRFgw?=
 =?utf-8?B?OXNVa1JqUDAxSkI5OVU5NGpKU3dvMGE2bVo2cStEZWVvWkVaRUZDakRBZWpD?=
 =?utf-8?B?cDJHd1FPdEZ6Mm5CanRmMWR2eHE1MnZUQjZKbHgwa1cyMVdmcU4rekNzMDVr?=
 =?utf-8?B?elpMczY4ekJGU0R1MUdpbkZmR3FycDZrNFlVa2ZsYUJQMTlFV2dYdjYvdHJO?=
 =?utf-8?B?VmREOGZrNWFJMzR1YXFzejdmM0FOaFE1NEhuNFdJN0k3ZVVBemNGNjZaRFVF?=
 =?utf-8?B?V1NIbHNOR1Z3bmtSSllvMnUyOER4cnFFM0EzV1FZMnVVMzZhbThMMmd5Yjd4?=
 =?utf-8?B?anlyVktuVDV4NC8zWnM1dlRyR1pENGt4aFNrMHl0blg3ckpBVVBMTjVpdGpK?=
 =?utf-8?B?UU0yMXpWQUJjeS9ocHJQZkRpL2lXempwandVUmk1OHRGWUhwUkpBMTZXVldv?=
 =?utf-8?B?aEpxWXdNc2E2cTdNeGo5YlgzYXhLZWpBV1VLWlpOU0sxZDZWNW5RL2FzL0J2?=
 =?utf-8?B?bEcyL0pHciszOGxBV3NoSlJ6bGh5WEhFVmt2Uk0wSG5IWm9OMW13Qm9VMzl6?=
 =?utf-8?B?cXRpOEg4S1pyd0dwMzduMWV2aHQvU1UwRlhNOU9Wa3F4WHkwT01XUEdIL2Zk?=
 =?utf-8?B?cU1RdlpVRGd5a3R0dnEralBvRC83ZmhiMGoyeEc4b1Y2VXM1ZUR2elpYdTlk?=
 =?utf-8?B?bnF5QTBsUmlVdUdMYXM1NEZ6b1Jia0Y0TEZwSFNQMmtUWGwwZ3lqL2YzM1hN?=
 =?utf-8?B?VDFNMWpYYnUwZ1FycDBvNEJVTm95N2hiblJQVFk2OW4rV090cEpIS1FRUWJE?=
 =?utf-8?B?YlZ0b002Ym9JN0FDVjFmcFhNNGVNYkZxOGhBRittb2FQRUUzU1pPS1dGVkZt?=
 =?utf-8?B?eGg4bmpLcEpqalVTQVlGbDBjMTBQUXFyUDA4TkhvR2M0K0x6Tkd2OE04KzhZ?=
 =?utf-8?B?UzkyV2hMZWYvcE9kd1NTc2JodUhyWjZjdW1WSW0vOHNJYVNKd1d0RXRYNUZo?=
 =?utf-8?Q?iTWOAcgR3BCnMZRQxoQJ9UzDhgwLdgA/0+bXQDSbFP4M?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <90CA00A6DFC4344083FFBFD313866EC2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6088.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 704a6199-6f3c-4c3c-fa33-08dad45bd6ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 11:53:33.6773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8K5i4DFfPA0V1WMqWrzFMrwhhgmMF/VEyO3bhGYcMzlmIed2uvhwV9gjBa9Mivif4f67sKOpE3XaHazp3yIFeZmOk7+lGexvZ/WrtYhl9KgbpdcYaf8HlEZm01PN8T9c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4745
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsCgpUaGFua3MgZm9yIHRoZSByZXZpZXcgY29tbWVudC4KCk9uIFRodSwgMjAyMi0x
Mi0wMSBhdCAyMDowMiAtMDgwMCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6Cj4gRVhURVJOQUwgRU1B
SUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UKPiBr
bm93IHRoZSBjb250ZW50IGlzIHNhZmUKPiAKPiBPbiBXZWQsIDMwIE5vdiAyMDIyIDE4OjU5OjAw
ICswNTMwIFJha2VzaCBTYW5rYXJhbmFyYXlhbmFuIHdyb3RlOgo+ID4gK8KgwqDCoMKgIG1hY19z
dGF0cy0+RnJhbWVzVHJhbnNtaXR0ZWRPSyA9IGN0cltrc3o5NDc3X3R4X21jYXN0XSArCj4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgY3RyW2tzejk0NzdfdHhfYmNhc3RdICsKPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBjdHJba3N6OTQ3N190eF91Y2FzdF0gKwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGN0
cltrc3o5NDc3X3R4X3BhdXNlXTsKPiAKPiBkbyBjb250cm9sIGZyYW1lcyBjb3VudCB0b3dhcmRz
IEZyYW1lc1RyYW5zbWl0dGVkT0s/Cj4gUGxlYXNlIGNoZWNrIHRoZSBzdGFuZGFyZCBJIGRvbid0
IHJlY2FsbC4KPiAKWWVhaCwgSSB3aWxsIGNoZWNrIHdpdGggdGhlIGRvY3VtZW50YXRpb24uCgo+
ID4gK8KgwqDCoMKgIG1hY19zdGF0cy0+U2luZ2xlQ29sbGlzaW9uRnJhbWVzID0KPiA+IGN0cltr
c3o5NDc3X3R4X3NpbmdsZV9jb2xdOwo+ID4gK8KgwqDCoMKgIG1hY19zdGF0cy0+TXVsdGlwbGVD
b2xsaXNpb25GcmFtZXMgPQo+ID4gY3RyW2tzejk0NzdfdHhfbXVsdF9jb2xdOwo+ID4gK8KgwqDC
oMKgIG1hY19zdGF0cy0+RnJhbWVzUmVjZWl2ZWRPSyA9IGN0cltrc3o5NDc3X3J4X21jYXN0XSAr
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgY3RyW2tzejk0NzdfcnhfYmNhc3RdICsKPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBjdHJba3N6OTQ3N19yeF91Y2FzdF0gKwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGN0cltrc3o5NDc3X3J4
X3BhdXNlXTsKPiA+ICvCoMKgwqDCoCBtYWNfc3RhdHMtPkZyYW1lQ2hlY2tTZXF1ZW5jZUVycm9y
cyA9Cj4gPiBjdHJba3N6OTQ3N19yeF9jcmNfZXJyXTsKPiA+ICvCoMKgwqDCoCBtYWNfc3RhdHMt
PkFsaWdubWVudEVycm9ycyA9IGN0cltrc3o5NDc3X3J4X2FsaWduX2Vycl07Cj4gPiArwqDCoMKg
wqAgbWFjX3N0YXRzLT5PY3RldHNUcmFuc21pdHRlZE9LID0gY3RyW2tzejk0NzdfdHhfdG90YWxf
Y29sXTsKPiAKPiBPY3RldHNUcmFuc21pdHRlZE9LID0ga3N6OTQ3N190eF90b3RhbF9jb2xbbGlz
b25zXSA/Cj4gClNvcnJ5IGFib3V0IHRoaXMuIEl0IHNob3VsZCBiZSBrc3o5NDc3X3R4X3RvdGFs
LiBJIHdpbGwgcmV2aWV3IGFsbCB0aGUKcGFyYW1ldGVycyBhZ2FpbiBmb3IgYXZvaWRpbmcgc3Vj
aCBtaXN0YWtlcy4KCj4gPiArwqDCoMKgwqAgbWFjX3N0YXRzLT5JblJhbmdlTGVuZ3RoRXJyb3Jz
ID0gY3RyW2tzejk0Nzdfcnhfb3ZlcnNpemVdOwo+IAo+IFlvdSB1c2UgdGhlIHNhbWUgY291bnRl
ciBmb3IgUk1PTiBvdmVyc2l6ZSBzdGF0aXN0aWMsIHRoZSB0d28KPiBkZWZpbml0ZWx5IGhhdmUg
ZGlmZmVyZW50IHNlbWFudGljcywgcGxlYXNlIGNoZWNrIHRoZSBzdGFuZGFyZAo+IGFuZCB0aGUg
ZGF0YXNoZWV0Lgo+IAo+IFJlbWVtYmVyIHRoYXQgeW91IGRvbid0IGhhdmUgdG8gZmlsbCBpbiBh
bGwgdGhlIHN0YXRzLCBpZiB0aGUgSFcgZG9lcwo+IG5vdCBtYWludGFpbiBhIG1hdGNoaW5nIHN0
YXRpc3RpYyAtIGxlYXZlIHRoZSBmaWVsZCBiZS4gS2VybmVsIHdpbGwKPiBub3QgcmVwb3J0IHRv
IHVzZXIgc3BhY2UgdW5zZXQgZmllbGRzLgoKU3VyZSBKYWN1YiwgSSB3aWxsIHJldmlldyBteSBj
b2RlIGFnYWluc3QgZG9jdW1lbnRhdGlvbiBhbmQgc3VibWl0IHRoZQp1cGRhdGVkIHJldmlzaW9u
LgoKVGhhbmtzLApSYWtlc2ggUwo=
