Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9E36CD37B
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjC2Hl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2Hl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:41:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E37B5;
        Wed, 29 Mar 2023 00:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680075714; x=1711611714;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=d6frBGlvFhY0hi1TmfoL64TaAXv7fspNHbACZKf2Gk0=;
  b=LwypiUbUBg6whM6kiLYIV8lCGYHhOz5gjGK1NvU64jgyzbmkSJt8tujR
   lbso5d4YKG+2D+pfFLSuODjvLm9T35w6gA5qqRylWdmPBg5wJ5Kfe5GKo
   DW/W5SdiJCTUZVJo8LBOWXxAD9cxdZJJutxhdpwKarEisKyq52vkXcFuu
   0q3Cucjm50uudT9/C0VXQKFjpMuWvF9H5TLJuLsOymkhec7kuK+tefv5S
   xLDPFfQijm+6b9D8FkJ9EAr/LQBceqpzrQIL8xYrWobV8nIj9ktyJCGV0
   ElRsG0Gt2alF9RgFo7oGWJLR0AXAs5S4SdQB/ldzcgj1dzK+wfi0qiwHd
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,300,1673938800"; 
   d="scan'208";a="206815859"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2023 00:41:53 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 00:41:53 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 00:41:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKGS5arADlnvns7igYBSY6ECVE28EyZvUInyt9XDlTSKgVfLC7sqBG3Qco0fkUHi6MGbmLow25Rm/5g/LZzN1F7/VBpWpwcH+pPuY8aVAVEyt5t7wpcooXfZ240HsQEh84v/mOWhJfaDdbD3LBHp93zkSvIDd2H79NmR25/XO5eUbojr53essns1EbowRxPWh+ENmZYCNwZp/g5JtgXLEjV8PkHHi2BUqCT20TCWA/zwoIHMdG8lpN3+ztLZRA3L25fwJi/1ki0Q1y0YQISRcNMqaVOu0FIiLZ8mfKBcCtK3I8meSrTTTPu+VPoP3TCZXQ0mRkVku6RxfvhNMOljBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d6frBGlvFhY0hi1TmfoL64TaAXv7fspNHbACZKf2Gk0=;
 b=Lxe7H+Sw0iXLJko3Y38SEkkxMz01IyvgnAp/lXoFRb1gle6RaKZ9gQ4XSYsegSAn3tAhK+Cq4IdngiBEYHR/BZ3eEIStrpr3J4gz18+xkBi4tXR34m4/gLedEzK4EgJmldSkYedn3Q83lvgkEF9hK+dgUDVO/W94bUPAj+wHhcDBMsFmBQriyVQXvJcJvfR1HEbu+ghL6bRSdDNswLuHAv/CKdNRu1G7/OZSyCBbNNPS7SGCya0hV72BQlAxk9O1A73BxTb3rucx3Fq0LJBVg/j0LtJfg6MmL3E7eHNhrmSPqPlET2yHIWvoELWCw2pHf0kM5wmi8CFLsjIR4mtsDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6frBGlvFhY0hi1TmfoL64TaAXv7fspNHbACZKf2Gk0=;
 b=I3812I/+gdWfH3e+QMRPfAchMMyDLYf2lEZr1YJKWp6t2DH8qePRnehopLKMvBhdeZx585r3bui2ktql5PuEkQ6plE3cGndO7JE1hvqU0p2aQWmbpcWwDqvsKAEra7qV3KI9mrjpDmZc61qYNeRZjqoEDWRjdk+I1RGMm5Wizxo=
Received: from DM4PR11MB5358.namprd11.prod.outlook.com (2603:10b6:5:395::7) by
 MN6PR11MB8220.namprd11.prod.outlook.com (2603:10b6:208:478::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.41; Wed, 29 Mar 2023 07:41:52 +0000
Received: from DM4PR11MB5358.namprd11.prod.outlook.com
 ([fe80::60cd:a09b:d7fe:5b72]) by DM4PR11MB5358.namprd11.prod.outlook.com
 ([fe80::60cd:a09b:d7fe:5b72%7]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 07:41:52 +0000
From:   <Steen.Hegelund@microchip.com>
To:     <wsa+renesas@sang-engineering.com>, <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>,
        <steve.glendinning@shawell.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <geert+renesas@glider.be>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v4] smsc911x: only update stats when interface is up
Thread-Topic: [PATCH net v4] smsc911x: only update stats when interface is up
Thread-Index: AQHZYglvE5HtjopEtE6lM4l9cJdODq8RX8aA
Date:   Wed, 29 Mar 2023 07:41:52 +0000
Message-ID: <CRIP4UR9M4IS.V7ZOZHKV9QRX@den-dk-m31857>
References: <20230329064010.24657-1-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230329064010.24657-1-wsa+renesas@sang-engineering.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: aerc 0.14.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5358:EE_|MN6PR11MB8220:EE_
x-ms-office365-filtering-correlation-id: 5cf3f5cc-51f1-4cf9-3a58-08db30291005
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XWPyDuNlznaIVcRscWSTPfBQe+pP7RURTj42VRlUI86oexmQluBiWgZ2+BD2FELBGwwPTDVwIXKZbYmLELjhQJMnSI7lhvYsGghg03NhswX8KQDeipeUI1jmAKeX4YRIho1JEIqTTr7VP9YLHysb/Oxba1K+vr7mRUrI/FZOSXkJgHJaKzxxY7lW46dJyOiJ3qGCQZWWvONLKOUGQ0+OWkndHzuDLc0q86aQeY/9dvuoJXgdSCTSYjAoZThxdCsybtpeEvRa9XhkFgOU8ZbcUcZkS8cF2b1DxPEM7mwvN2/7Z+hKIVvEzn+eF+rVss6ww18XIBq/x6u/BSrtkGOEJVMlOK04NUHg8S425srAbfkI97XJ6gRm6mjWc8sj6uiF7b8yEbyXRn1tpwFQO3JUjOXropSIzxLGCXlAhLaxUWBwHS3lU59pAXNxVjwiHfLVnccbhthqRGTa7UmtygPTryxr3pvlGe6PqouSOUpL2c6AT0DbpEA6idu7f5u62bKUqi6MEdSvlftaotpyz/vw1hxjIHXLjqfoqvhb70MieODmo2ThUiV/SyjF4MdI8BrO10F1OCyjDUYFOVxioQW9a6y6YE7MLak0nVmSDKKu5QAKIhn8xCKWTRxCOfPkZEZw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5358.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(136003)(366004)(39860400002)(376002)(346002)(451199021)(71200400001)(41300700001)(6486002)(6506007)(478600001)(4326008)(186003)(7416002)(8936002)(26005)(6512007)(5660300002)(9686003)(66556008)(66476007)(66446008)(66946007)(8676002)(54906003)(76116006)(83380400001)(91956017)(316002)(110136005)(64756008)(2906002)(122000001)(38100700002)(38070700005)(33716001)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzZ5RG9QejA4SS9rRXdtUmpDWE9aYnhFdjYrc0tqNDFBdUFPeW1pNGk1Q0hu?=
 =?utf-8?B?Ukk0OFdTUnl1cTk3MFQwd1JLdmJjUkhITm9VZDErV3Nqb0x0c2lVUTlnK3dm?=
 =?utf-8?B?TSs5NDZ1Smp6RUV0YkRZNFk0Mkl5RjFxdDZ6K0gwdTJoUjVia1FlSERhZmFu?=
 =?utf-8?B?dFM1WGZsSzVZVEtua3VRcWVGb3JaZ2Z0NFNYU2N5MWgrbzFsQTdrMkFMRFVS?=
 =?utf-8?B?dVUyNzBCUmozTjBDMjJwcXpaZnJpZWdzNnROdjdSTzRhT0NhSkJwTHRTQmRO?=
 =?utf-8?B?eHc5ZDN2cmpkbUNsc1dqTEJJeUpoWklaUmFwbU1yZDJ1MFdOWGMvVXcvT3Jr?=
 =?utf-8?B?TlVqNnRBWGJwYXVRNFk1SnZJWUNaaWJTcUpkQWhjMnc1NGVVeHR5akR1cE9M?=
 =?utf-8?B?L05RdW02a2ZITjBiREdTZy92c1JtM3Z4WWt1VHZIelBTaUpTWGxWN1cwSXFD?=
 =?utf-8?B?NVNMNEFEa1hCZDBtTlhkbXdGd21ReHlaMmRadjNKUnJiWE4ySHBiMktlN1Bj?=
 =?utf-8?B?a3pRSExNbnR1L0hTU3Q0NjZOb3lONGQ1TkRLemZwRWcvSjlWQWxYV0JVVTIw?=
 =?utf-8?B?MW1DZFcyQmM1TWt2T0Q4UmVxbnVpU3RiQ0pXUXByUERYVkNPNysvWnRmMi9G?=
 =?utf-8?B?RFJpVFpUaXU5WmxaZktVS2NVVjFoenlnaitaZnMreEV5b0Q3RGRHSW5jUWJV?=
 =?utf-8?B?WHJTb1AzL25ZYm9veFJvS2oxandWYkF3bWw4Zm9BZVpZWVFsNy8zMkhQN3hS?=
 =?utf-8?B?WndOU0dacnJYSTdKZ0JXQTZzZDA2SkxxbHVOQzBCL3JaV2RIWCtpekVla05i?=
 =?utf-8?B?eWNvLzhCbHZad1IySUdEN3pMdVFtclpDTlZTNXB2QVMyeDhsZ1BxWkRBWk5W?=
 =?utf-8?B?NGw1VDlrQWIzMjRYK0kxekVvdk0rb09aWGFzek5kdnF6bTh0Z05QNnc0RUU4?=
 =?utf-8?B?SmU4YThhR3V4ZitDZDF2RlNmMFV3MUIrOC8vWTlUc2ZPM1NmbkxHNW9GVFpt?=
 =?utf-8?B?ZjRIcDVBM1BZZ295UFBERE9mMWNvRUpSb2k1OTdBaEx4Y1UyU2ZWdVl3WHc4?=
 =?utf-8?B?VWtZQng1MVpYOEZDQkNTUjF3SXh0Zlo4bGhkK0xQdDVJdk1iaHhZamUxSXlB?=
 =?utf-8?B?WkhUYXRRZTlqQVNRcENQL0F0TXVNeWYwZndyajM1MmhXRmZWNXJnb1NMMEpj?=
 =?utf-8?B?THExU2RUZ2VzZVgvT2MvSUt0azlJSnBBM1JESVpheHA2QmZPK0VsSTVHQjdG?=
 =?utf-8?B?SkRLb1hNeXI5OTV2YjYrSis3N2JCTXVNY01kUVJsTzFVUzgwaVlRY3gxakl4?=
 =?utf-8?B?N0ZhQUliSlpDcEduWC9TMG1UM1dOWGI2MlBzajlhRkRIZWY0WE1wbTFudFFr?=
 =?utf-8?B?QWp1YkF2QXd2OVlPRFVjV2ZQblZpcldwQXVkemNoWDQ5dnlDZkR6c084Nnhq?=
 =?utf-8?B?dnVNZ284cGpYZFNyc1RhOFdRcmZDekduUXlQeTJxeWY3ejZOTnhMa21mNWFD?=
 =?utf-8?B?bnU3eXBlamthTDQ2SExleWxOamZ4UlZNcWNjNEJGUWN2Nyt0emZXUkdQSmt1?=
 =?utf-8?B?aTRZcmpZTzZ1M1JTK0FKYWFydkhEME5jNTd4YTNTdytHQ0RTa1BwWFBGOVdB?=
 =?utf-8?B?K0lMWnpVOUtSK2VJMlUyOUdTY0l3VlZpTEM5bEFPYytwcEZQZ0tiN2NvUEUw?=
 =?utf-8?B?S3BncVh4ZkZZb3VaTDZTb2UwY09TekhDUEg1ZGhTb1JOa09iVENFa2hLemcx?=
 =?utf-8?B?dDR1dEx1bDVjc1J1UytuVDFBZlBNbEJGVXpNOVM4NmhGbSs0c1ppRGc5NXZC?=
 =?utf-8?B?bHAvU2tzY0FEeUpDYy9oZzVMaHJQTkJ3c21VaEVzQjZFNlpzSTBRRFFWSVdB?=
 =?utf-8?B?Zkt0WWc4VjFTU2JGQVZkbGRIbklLUUZjdUU1YUJDZkwyRmxhR3N3REtPWDFh?=
 =?utf-8?B?NzUzVk9TSTBtc3kzdXppeVcwNlcwMHl6MHA4U3cxZURla2kwVS9RaDFwK2c5?=
 =?utf-8?B?ZFJab2pKbkNpYmxpMWxSUUI2NDFrSnlZZDVuSGV2c1R1NVFIanZRUUVQZWRL?=
 =?utf-8?B?K3p1U0N3eEY4ODBvOVkwTUc3cFlvQmFlYjlsYlZHZzFaeGVZd051d0huSVVr?=
 =?utf-8?B?ZUFVRDFBNy9QbllvYUtrcjc5d0doTmhsN3BkOHBuUExieGhnMnQ5bEhOS0Ru?=
 =?utf-8?Q?7P6EBJu9W6tsjp7aI/KjM+o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02C97C9B0DFF8E4BAC3ECAF285C18A06@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5358.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf3f5cc-51f1-4cf9-3a58-08db30291005
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 07:41:52.3344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ++d77skASQMehsoUXXETTkOED2UCgzI/p+Rb137j5B7HONuQbi8Q5mfwGzU6xWktCIDOVFRQVSmGPwhGPVb2O2pgC06BIZtgiQF3dH4hgCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8220
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgV29sZnJhbSwNCg0KT24gV2VkIE1hciAyOSwgMjAyMyBhdCA4OjQwIEFNIENFU1QsIFdvbGZy
YW0gU2FuZyB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+DQo+
IE90aGVyd2lzZSB0aGUgY2xvY2tzIGFyZSBub3QgZW5hYmxlZCBhbmQgcmVhZGluZyByZWdpc3Rl
cnMgd2lsbCBPT1BTLg0KPiBDb3B5IHRoZSBiZWhhdmlvdXIgZnJvbSBSZW5lc2FzIFNIX0VUSCBh
bmQgdXNlIGEgY3VzdG9tIGZsYWcgYmVjYXVzZQ0KPiB1c2luZyBuZXRpZl9ydW5uaW5nKCkgaXMg
cmFjeS4gQSBnZW5lcmljIHNvbHV0aW9uIHN0aWxsIG5lZWRzIHRvIGJlDQo+IGltcGxlbWVudGVk
LiBUZXN0ZWQgb24gYSBSZW5lc2FzIEFQRTYtRUsuDQo+DQo+IEZpeGVzOiAxZTMwYjhkNzU1Yjgg
KCJuZXQ6IHNtc2M5MTF4OiBNYWtlIFJ1bnRpbWUgUE0gaGFuZGxpbmcgbW9yZSBmaW5lLWdyYWlu
ZWQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBXb2xmcmFtIFNhbmcgPHdzYStyZW5lc2FzQHNhbmctZW5n
aW5lZXJpbmcuY29tPg0KPiAtLS0NCj4NCj4gQ2hhbmdlcyBzaW5jZSB2MzoNCj4gKiBicm9rZW4g
b3V0IG9mIGEgcGF0Y2ggc2VyaWVzDQo+ICogZG9uJ3QgdXNlIG5ldGlmX3J1bm5pbmcoKSBidXQg
YSBjdXN0b20gZmxhZw0KPg0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvc21zYy9zbXNjOTExeC5j
IHwgMTQgKysrKysrKysrKysrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCsp
LCAyIGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
c21zYy9zbXNjOTExeC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc21zYy9zbXNjOTExeC5jDQo+
IGluZGV4IGE2OTBkMTM5ZTE3Ny4uYWY5Njk4NmNiYzg4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9zbXNjL3Ntc2M5MTF4LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvc21zYy9zbXNjOTExeC5jDQo+IEBAIC0xNDAsNiArMTQwLDggQEAgc3RydWN0IHNtc2M5MTF4
X2RhdGEgew0KPg0KPiAgICAgICAgIC8qIGNsb2NrICovDQo+ICAgICAgICAgc3RydWN0IGNsayAq
Y2xrOw0KPiArDQo+ICsgICAgICAgYm9vbCBpc19vcGVuOw0KPiAgfTsNCj4NCj4gIC8qIEVhc3kg
YWNjZXNzIHRvIGluZm9ybWF0aW9uICovDQo+IEBAIC0xNzM4LDYgKzE3NDAsOCBAQCBzdGF0aWMg
aW50IHNtc2M5MTF4X29wZW4oc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gICAgICAgICBzbXNj
OTExeF9yZWdfd3JpdGUocGRhdGEsIFRYX0NGRywgVFhfQ0ZHX1RYX09OXyk7DQo+DQo+ICAgICAg
ICAgbmV0aWZfc3RhcnRfcXVldWUoZGV2KTsNCj4gKyAgICAgICBwZGF0YS0+aXNfb3BlbiA9IHRy
dWU7DQo+ICsNCj4gICAgICAgICByZXR1cm4gMDsNCj4NCj4gIGlycV9zdG9wX291dDoNCj4gQEAg
LTE3NzgsNiArMTc4Miw4IEBAIHN0YXRpYyBpbnQgc21zYzkxMXhfc3RvcChzdHJ1Y3QgbmV0X2Rl
dmljZSAqZGV2KQ0KPiAgICAgICAgICAgICAgICAgZGV2LT5waHlkZXYgPSBOVUxMOw0KPiAgICAg
ICAgIH0NCj4gICAgICAgICBuZXRpZl9jYXJyaWVyX29mZihkZXYpOw0KPiArICAgICAgIHBkYXRh
LT5pc19vcGVuID0gZmFsc2U7DQo+ICsNCj4gICAgICAgICBwbV9ydW50aW1lX3B1dChkZXYtPmRl
di5wYXJlbnQpOw0KPg0KPiAgICAgICAgIFNNU0NfVFJBQ0UocGRhdGEsIGlmZG93biwgIkludGVy
ZmFjZSBzdG9wcGVkIik7DQo+IEBAIC0xODQxLDggKzE4NDcsMTIgQEAgc21zYzkxMXhfaGFyZF9z
dGFydF94bWl0KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+
ICBzdGF0aWMgc3RydWN0IG5ldF9kZXZpY2Vfc3RhdHMgKnNtc2M5MTF4X2dldF9zdGF0cyhzdHJ1
Y3QgbmV0X2RldmljZSAqZGV2KQ0KPiAgew0KPiAgICAgICAgIHN0cnVjdCBzbXNjOTExeF9kYXRh
ICpwZGF0YSA9IG5ldGRldl9wcml2KGRldik7DQo+IC0gICAgICAgc21zYzkxMXhfdHhfdXBkYXRl
X3R4Y291bnRlcnMoZGV2KTsNCj4gLSAgICAgICBkZXYtPnN0YXRzLnJ4X2Ryb3BwZWQgKz0gc21z
YzkxMXhfcmVnX3JlYWQocGRhdGEsIFJYX0RST1ApOw0KPiArDQo+ICsgICAgICAgaWYgKHBkYXRh
LT5pc19vcGVuKSB7DQoNCkNvdWxkbid0IHlvdSBqdXN0IHVzZSBuZXRpZl9jYXJyaWVyX29rKCkg
aGVyZSBhbmQgZHJvcCB0aGUgaXNfb3Blbg0KdmFyaWFibGU/DQoNCj4gKyAgICAgICAgICAgICAg
IHNtc2M5MTF4X3R4X3VwZGF0ZV90eGNvdW50ZXJzKGRldik7DQo+ICsgICAgICAgICAgICAgICBk
ZXYtPnN0YXRzLnJ4X2Ryb3BwZWQgKz0gc21zYzkxMXhfcmVnX3JlYWQocGRhdGEsIFJYX0RST1Ap
Ow0KPiArICAgICAgIH0NCj4gKw0KPiAgICAgICAgIHJldHVybiAmZGV2LT5zdGF0czsNCj4gIH0N
Cj4NCj4gLS0NCj4gMi4zMC4yDQoNCkJSDQpTdGVlbg0K
