Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C5F66DFF6
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 15:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjAQOI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 09:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjAQOIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 09:08:24 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30E13B0D7;
        Tue, 17 Jan 2023 06:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673964502; x=1705500502;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PVlr1W8NdB9Gob3WsS6W/RvMfborXQPEiZbQXRVgQgQ=;
  b=xN3ETzLL3NoAVizXxAgzud3aScxf0BPD2mw67LhdjXVr3khrZrI59J8O
   JySuTbD+3PLP65T8ToGhpiThe4v8zIzM4vBeTAsoEmpLij84X2qGqY1z4
   qAwBZjHHNVxoREoPdI3R6lQvf0ih4nLN8ySb4pXFs9R42IfUgP9ZCrONA
   lO6qlvHEdIYqIwMxzimuVpQTC6qsNdFbF2LEUAAJT3+xgFra1/g0hvBDO
   8d3aj7tdVh7+lSzoh3UY6xuBFPK3IQjTxvCYj1AQxNHFBWKPgPDQjHIHu
   6p0zUdki7J5HTYmMMmzBTdgKdjdkXwcCBkzBhqkFp4SYXFYXGTZND020Y
   g==;
X-IronPort-AV: E=Sophos;i="5.97,224,1669100400"; 
   d="scan'208";a="208132598"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 07:08:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 07:08:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 07:08:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2X72i8fc1t5ZbkoHgamFvsHUzPIRknMjoqdnaYp4Fdx7r1QSf38XpJDAVIvtKnbLROlH/4mZqQu9DztuFE8vEq2kMU5LJmFGZnofDLi2cqQTj6kFmWfQoHKQqjjfpaiqb0Uy+SHhw0Jp9ZyP4mCM8HY8a9c/z03ZpQMotYepEDc+lySX0SBtDnPcnboxXmCecGlI2e61LiVE5gXE/BeFaPWr93QhSOIJIIuV5XxeAguunhY/ZfSWMe5IICq/TqzVI2waJ/WcG27pbjn8FY7X7wpfm7WIaHMTJriqnzoRmwO7oEHUect4+1oZksAqjf4P3n7tlLy4bv7w4UTywQtmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVlr1W8NdB9Gob3WsS6W/RvMfborXQPEiZbQXRVgQgQ=;
 b=lIS1zA7dKZam12YQAnrOWuQF+MVWHsmjhRIOTdw53ZyMELiosXT6rDxYQQGx3GjwrqoNnMqyy+JNqifJyN8LCHIwszd0V9QSfuq/LZQDiW+ZUtgXjZGqHXxv6XUjqsfMMSt7quYozt/6Nk0Mmm42pJuiAfCTzWKVqtwEvIE6KTx7vWfPOZNAJaKeQpJC6modXPOgv5g8RJEkvCjrCSTNKhb765klx9HUXioqAvvBN/5v6equrPX/1didWg1StjEsZGLWuIV1RKXaXsnYxLdAjSJXEZUf8cRoy9uYDnfq9YuoWnHhKJ5TVSInD8dV1PW3rwqDEBxuMrSrtVxIRfWVTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVlr1W8NdB9Gob3WsS6W/RvMfborXQPEiZbQXRVgQgQ=;
 b=XmWNjAb/pWyQboAsNNUMkL7VR92A2OZ9tNqcJtGHdeh3YnzqwJf7EkC/vRpHWkREFq1MbMFpwWNhFT2JtihCUap3OLEzQRx/hyLxgePeysTJ829nhxsSR7yEVrZdWQLwJPgMZCBJSio+pcV7cfnqcNG+h1sb2EnfDgPAB84wPJw=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM4PR11MB6239.namprd11.prod.outlook.com (2603:10b6:8:a7::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.19; Tue, 17 Jan 2023 14:08:18 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.5986.018; Tue, 17 Jan 2023
 14:08:18 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <mw@semihalf.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-acpi@vger.kernel.org>
CC:     <andrew@lunn.ch>, <olteanv@gmail.com>, <vivien.didelot@gmail.com>,
        <jaz@semihalf.com>, <linux@armlinux.org.uk>,
        <Samer.El-Haj-Mahmoud@arm.com>, <linus.walleij@linaro.org>,
        <f.fainelli@gmail.com>, <sean.wang@mediatek.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <tn@semihalf.com>, <Landen.Chao@mediatek.com>, <rafael@kernel.org>,
        <davem@davemloft.net>, <andriy.shevchenko@linux.intel.com>,
        <hkallweit1@gmail.com>
Subject: Re: [net-next: PATCH v4 2/8] net: mdio: switch fixed-link PHYs API to
 fwnode_
Thread-Topic: [net-next: PATCH v4 2/8] net: mdio: switch fixed-link PHYs API
 to fwnode_
Thread-Index: AQHZKnxKhrAy4N28j0aSozSARtSbKa6ipVKA
Date:   Tue, 17 Jan 2023 14:08:18 +0000
Message-ID: <422c832273696a012f7cc79b09c98185f230c721.camel@microchip.com>
References: <20230116173420.1278704-1-mw@semihalf.com>
         <20230116173420.1278704-3-mw@semihalf.com>
In-Reply-To: <20230116173420.1278704-3-mw@semihalf.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DM4PR11MB6239:EE_
x-ms-office365-filtering-correlation-id: 8d0353f3-87ec-4240-e544-08daf89448b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fKzqqko3Cqzv7OugVPxEi+FMQt4gICSqYwCy7EDx1rttwfZ18ZwaenA8B6e1cCzsI4pyTQujrCcnboRjlNk4evD6SKKlooino2iMbqhui5rapDBFs0FAgsh8V7rTn2xtbffu/RhtSrjdSUSn5bF+bgysJKze9pJiGEwIVtgv4DqpU/wKqtAjwwA9/m7uv7k4PMCRgOHv+nnZW7M9OPLPXgQExMxt0t//QOxuuAlnhSzss+JrX3tVJW4x3ZzVW5YM3NfBrO2E0pGkpk4PlpMSAT2WR7+mPz3V9/Ncfru2+EZnlY/RMRCd/4wXnfOMDQLiYpNAs5KRk5tiW6CFmo4XlkgEUpdF6q47dSDOkvgCkawSB4OR9GKxP53cyZptzeHzYTcWCxWbbhEL+o67pWh/TfjbnqFSKhNrZJUsTJ53moPMZwbfVYuMO8oa331QzgkU9SiMQhDwc4G7RJ4EA9uHMadvxq87sZni2THQHcQuZZI1T09L2mbo1AJPws/SnqEO9xQJGuXadhbw8n/9wW/GUgY/9F+g129ROYGRxUbgMI9yWb9xRel48tY+AkIMsBTHk3uAcdaWjZ7/lRlMiK2LzGhB0UzU3mGYv4peTOlot7W/fWNsyvReK09+MdJRZfF9qYrNah7QfMVHG3XtlPNfDmHZ+9N1a/OsvcC7EZmIboQLdlqtI5QUKQoq/MtyTg63Byjk15niaI9haA5BspDOKv/FDEKpBa/pxkxMeNRQ45Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(38070700005)(5660300002)(7416002)(8936002)(86362001)(41300700001)(38100700002)(36756003)(122000001)(71200400001)(478600001)(110136005)(6486002)(54906003)(83380400001)(6512007)(186003)(6506007)(316002)(91956017)(8676002)(66446008)(66476007)(66946007)(66556008)(76116006)(64756008)(4326008)(2616005)(2906002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUxQTS9La3pPR2g2bWsvU0cvc2ViN0J4enRoSEk5N0RNdU1YVzh2YjNaRzgr?=
 =?utf-8?B?UXkrbEFwbmpzZmZQZnZWOW1hTHJnc0NKWmVZdkgwLzlaWlFncXRqY1UrbE52?=
 =?utf-8?B?KzRrK0djNmxoK2taYVhzdTdYNE1zc21mdytPdnd2cC9FZjFLZzQzelBjUm9i?=
 =?utf-8?B?YnZDdWZybHdwSUVNZDdxZmlnNUZoRVNIZjJyOHBHUG4xajgwNlZScVIyQkFz?=
 =?utf-8?B?eUxYQkIwdE5iVVZ1U1M4UDNYanRwb05Bbjh5a2QxbHZtQ1RiekoxcG5FZ3pX?=
 =?utf-8?B?aVplQWVrVnR1bXNjd1dhcGwwV0V5TTVVWXRKTndpTUNXUnJYS1B2NlNtb05X?=
 =?utf-8?B?dW9rcWg4bkROMGt2RkRuMER4V3BhRmNkcEF3dEc3NVMxdHB6dlpjZlJNZWtF?=
 =?utf-8?B?SWVzM2NFRzBCWEFLZzhEY3VkVm9CdGN1SkdpTUVlTU8zOEtwWVpkTFJTQVBH?=
 =?utf-8?B?cnpHd20ydURTQ0s0d2RwYkVvaVoyUHd1OWNQR2IvaURxTUovVzhEalZoZkhK?=
 =?utf-8?B?OGFaUkgwZG1WMlJLQlQrTnZKaDJBeE9TTGc4RVA3WGdIZW9aRTArcWtZZHJR?=
 =?utf-8?B?Q0pHNlU0bjBwM3JPU2YwWDFpUDdjVmFhdTQvVHlaTktQcTArNzFGUW02ZWFO?=
 =?utf-8?B?UGNLbDdCK0ZDYUNKY2gzMHRkSkF5cDk5ckFCU3hoVm1mMTUrSkVlbmtXb3g1?=
 =?utf-8?B?NER5eGNrMmVKUm5BK2tHazN6YXFJZE1JLy9Gc3FuZUxNZllXMzBwRzU3T0pW?=
 =?utf-8?B?RnlSSTV0MU9Gemh6cnNzaGVFS3F6YXZyT0xud20xS1hJY1FtL3QrV3hNNU5n?=
 =?utf-8?B?K3hpcTRXS2ZCbTc1WTJqSzJvam5BQVB5SUlFMnY1MFh5Z1FUajRXYWRseUVV?=
 =?utf-8?B?dUt4WXV4NHFaQnBsbDlVRXNFZkhLelFpeDJDTExvdlVpdytYUEVTNElkNXdG?=
 =?utf-8?B?clJBTUsvQTA4MkNpc1VSdmJYZXdJelJUcDNuZ2FNY1dpRnpSbnJGVDQwV0VW?=
 =?utf-8?B?OHZsNjhyTjRqR21md2FjOFhCNVVVcHJwdG5UdDMxUnB4a29sQlZHWE5hMFlU?=
 =?utf-8?B?TW1UV2pIVmdKdDZ2cXdUdUovQ3N1WEd2TzhWRmNXQjNzNlFGWGZZVkxKdGh2?=
 =?utf-8?B?bGdpRHRNM2J0VGcvbzdIbnQrTXpRbTl2bkcxa3dOblN0S2p0UG1vZ1A1S01i?=
 =?utf-8?B?dGU1Rlp1OXN2WXVURUtFS2ZMQ0o3c0M5SzYvOE0zcGZvRmh6Q1h2bUFyVHAz?=
 =?utf-8?B?RnZScEhzR1JhZVI3dUVsbWJ5YklJZkI3dEpZOW85bTlQMDY0VXNFUGU5V0VH?=
 =?utf-8?B?RVZWN1RSWnF5OTdydkt2bi83U29VRDlsRFlzSjMwUnBLRVVpL09iYWFodjVo?=
 =?utf-8?B?Q0s5R1ArZlNVU1RaRkFISmQrUWwvT3dHaDhGZXZwOC9palgzNUMyU2FLYjZK?=
 =?utf-8?B?RG1RRjI0OCtZQzFyRHZNRzd4ZnRyQ1VpcUtVN05mQzlyOE5VMFlacWxyKys4?=
 =?utf-8?B?bkF3ampZWDRadFdUU3U0NFoxem5Fd2h5Q2FpV2twdUgyL01LR29KYk9LcUJm?=
 =?utf-8?B?UzlLMVlSdWg4NUw1NjZIRzZKdnVBVmxTRW9ZL1BXd1VyT1JlZFB5U1VOeG5h?=
 =?utf-8?B?a0VtaWR4OENMTjV0Tng1N0J0enRaRjVtZ2lSSGM1c3YrWUt6NmRnZjF3aEJH?=
 =?utf-8?B?eEU2S24xR1czcmFHMzg4bnBrblhwRXdGWmlpYnNHL0Y2S1pmeUpyRUhXUERV?=
 =?utf-8?B?T3NXRSs5cGoreXVwd2l1OVd5S01GL0dXenFHczFiUG9TcmVUUHo5Ny93SVdM?=
 =?utf-8?B?SnpqZzNPRDhnTDFJYU9mN1pGbzhlallER1RpM3ZuS2FiZmNzS2ZvcTRKSXBM?=
 =?utf-8?B?THdaNzAzZ25IVzNiMG1iK2FtUUV6b3EvcHhmdnM2aWNsSUhlTURJYzdnb0FB?=
 =?utf-8?B?MFcyUWdJOWNBQXVuYUlYaktNcWxFeDhWMVZRbk02bDZZTGprS3dhVm51RVNi?=
 =?utf-8?B?K0xEZitqMUs0NDVIcWtOZHNReTZvaHd4Wk0rK0FFWkZJN3VMWUxCYm5rZUZN?=
 =?utf-8?B?Z1AzUnVKbHoyVVZaa05DZzI1cVEvVm85ZjZwSm00UWl5QVZnUkg3NVcyNGdR?=
 =?utf-8?B?bnJRdHczR0R0SkxMK29mMmlTbGdCS0p5c3lJTGE0c3lGcFpHYXFnTUNiUDZa?=
 =?utf-8?B?SWUzaUd2NGVKQ2tYRGdRanVWVmVFbFhNQnN3WG5ZbC9LRm1STHkrOHdaZWNw?=
 =?utf-8?Q?ewxH/YP72g6cJEvWxgh1fCIHBUJcP3lOOu8HhsJwHc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <015BE322A94B824E9D31517A4C6A9D79@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d0353f3-87ec-4240-e544-08daf89448b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 14:08:18.4787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ocAkNIPdNFwBh/CTdqK2ZUGqj5HAa2TNaeM0OyVWYh86kN2jsh5n4iQkXcZYZ4LqspS4T9TKhPY0uN2aGeoCu/crbg0t9IER4/6Vd17/lU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6239
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyY2luLA0KDQpPbiBNb24sIDIwMjMtMDEtMTYgYXQgMTg6MzQgKzAxMDAsIE1hcmNpbiBX
b2p0YXMgd3JvdGU6DQo+IGZpeGVkLWxpbmsgUEhZcyBBUEkgaXMgdXNlZCBieSBEU0EgYW5kIGEg
bnVtYmVyIG9mIGRyaXZlcnMNCj4gYW5kIHdhcyBkZXBlbmRpbmcgb24gb2ZfLiBTd2l0Y2ggdG8g
Zndub2RlXyBzbyB0byBtYWtlIGl0DQo+IGhhcmR3YXJlIGRlc2NyaXB0aW9uIGFnbm9zdGljIGFu
ZCBhbGxvdyB0byBiZSB1c2VkIGluIEFDUEkNCj4gd29ybGQgYXMgd2VsbC4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IE1hcmNpbiBXb2p0YXMgPG13QHNlbWloYWxmLmNvbT4NCj4gLS0tDQo+ICBpbmNs
dWRlL2xpbnV4L2Z3bm9kZV9tZGlvLmggICAgfCAxOSArKysrDQo+ICBkcml2ZXJzL25ldC9tZGlv
L2Z3bm9kZV9tZGlvLmMgfCA5NiArKysrKysrKysrKysrKysrKysrKw0KPiAgZHJpdmVycy9uZXQv
bWRpby9vZl9tZGlvLmMgICAgIHwgNzkgKy0tLS0tLS0tLS0tLS0tLQ0KPiAgMyBmaWxlcyBjaGFu
Z2VkLCAxMTggaW5zZXJ0aW9ucygrKSwgNzYgZGVsZXRpb25zKC0pDQo+IA0KPiAgI2VuZGlmIC8q
IF9fTElOVVhfRldOT0RFX01ESU9fSCAqLw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvbWRp
by9md25vZGVfbWRpby5jDQo+IGIvZHJpdmVycy9uZXQvbWRpby9md25vZGVfbWRpby5jDQo+IGlu
ZGV4IGI3ODJjMzVjNGFjMS4uNTZmNTczODFhZTY5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC9tZGlvL2Z3bm9kZV9tZGlvLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvbWRpby9md25vZGVfbWRp
by5jDQo+IEBAIC0xMCw2ICsxMCw3IEBADQo+ICAjaW5jbHVkZSA8bGludXgvZndub2RlX21kaW8u
aD4NCj4gICNpbmNsdWRlIDxsaW51eC9vZi5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L3BoeS5oPg0K
PiArI2luY2x1ZGUgPGxpbnV4L3BoeV9maXhlZC5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L3BzZS1w
ZC9wc2UuaD4NCj4gIA0KPiAgTU9EVUxFX0FVVEhPUigiQ2FsdmluIEpvaG5zb24gPGNhbHZpbi5q
b2huc29uQG9zcy5ueHAuY29tPiIpOw0KPiBAQCAtMTg1LDMgKzE4Niw5OCBAQCBpbnQgZndub2Rl
X21kaW9idXNfcmVnaXN0ZXJfcGh5KHN0cnVjdCBtaWlfYnVzDQo+ICpidXMsDQo+ICAJcmV0dXJu
IHJjOw0KPiAgfQ0KPiAgRVhQT1JUX1NZTUJPTChmd25vZGVfbWRpb2J1c19yZWdpc3Rlcl9waHkp
Ow0KPiArDQo+ICsvKg0KPiArICogZndub2RlX3BoeV9pc19maXhlZF9saW5rKCkgYW5kIGZ3bm9k
ZV9waHlfcmVnaXN0ZXJfZml4ZWRfbGluaygpDQo+IG11c3QNCj4gKyAqIHN1cHBvcnQgdHdvIGJp
bmRpbmdzOg0KPiArICogLSB0aGUgb2xkIGJpbmRpbmcsIHdoZXJlICdmaXhlZC1saW5rJyB3YXMg
YSBwcm9wZXJ0eSB3aXRoIDUNCj4gKyAqICAgY2VsbHMgZW5jb2RpbmcgdmFyaW91cyBpbmZvcm1h
dGlvbiBhYm91dCB0aGUgZml4ZWQgUEhZDQo+ICsgKiAtIHRoZSBuZXcgYmluZGluZywgd2hlcmUg
J2ZpeGVkLWxpbmsnIGlzIGEgc3ViLW5vZGUgb2YgdGhlDQo+ICsgKiAgIEV0aGVybmV0IGRldmlj
ZS4NCj4gKyAqLw0KDQpuZXR3b3JraW5nIGNvbW1lbnQgc3R5bGUgDQoNCj4gK2Jvb2wgZndub2Rl
X3BoeV9pc19maXhlZF9saW5rKHN0cnVjdCBmd25vZGVfaGFuZGxlICpmd25vZGUpDQo+ICt7DQo+
ICsJc3RydWN0IGZ3bm9kZV9oYW5kbGUgKmZpeGVkX2xpbmtfbm9kZTsNCj4gKwljb25zdCBjaGFy
ICptYW5hZ2VkOw0KPiArDQo+ICsJLyogTmV3IGJpbmRpbmcgKi8NCj4gKwlmaXhlZF9saW5rX25v
ZGUgPSBmd25vZGVfZ2V0X25hbWVkX2NoaWxkX25vZGUoZndub2RlLCAiZml4ZWQtDQo+IGxpbmsi
KTsNCj4gKwlpZiAoZml4ZWRfbGlua19ub2RlKSB7DQo+ICsJCWZ3bm9kZV9oYW5kbGVfcHV0KGZp
eGVkX2xpbmtfbm9kZSk7DQo+ICsJCXJldHVybiB0cnVlOw0KPiArCX0NCj4gKw0KPiArCWlmIChm
d25vZGVfcHJvcGVydHlfcmVhZF9zdHJpbmcoZndub2RlLCAibWFuYWdlZCIsICZtYW5hZ2VkKSA9
PQ0KPiAwICYmDQo+ICsJICAgIHN0cmNtcChtYW5hZ2VkLCAiYXV0byIpICE9IDApDQo+ICsJCXJl
dHVybiB0cnVlOw0KPiArDQo+ICsJLyogT2xkIGJpbmRpbmcgKi8NCj4gKwlyZXR1cm4gZndub2Rl
X3Byb3BlcnR5X2NvdW50X3UzMihmd25vZGUsICJmaXhlZC1saW5rIikgPT0gNTsNCj4gK30NCj4g
K0VYUE9SVF9TWU1CT0woZndub2RlX3BoeV9pc19maXhlZF9saW5rKTsNCj4gKw0KPiAraW50IGZ3
bm9kZV9waHlfcmVnaXN0ZXJfZml4ZWRfbGluayhzdHJ1Y3QgZndub2RlX2hhbmRsZSAqZndub2Rl
KQ0KPiArew0KPiArCXN0cnVjdCBmaXhlZF9waHlfc3RhdHVzIHN0YXR1cyA9IHt9Ow0KPiArCXN0
cnVjdCBmd25vZGVfaGFuZGxlICpmaXhlZF9saW5rX25vZGU7DQoNClJldmVyc2UgY2hyaXN0bWFz
IHRyZWUNCg0KPiArCXUzMiBmaXhlZF9saW5rX3Byb3BbNV07DQo+ICsJY29uc3QgY2hhciAqbWFu
YWdlZDsNCj4gKwlpbnQgcmM7DQo+ICsNCj4gKwlpZiAoZndub2RlX3Byb3BlcnR5X3JlYWRfc3Ry
aW5nKGZ3bm9kZSwgIm1hbmFnZWQiLCAmbWFuYWdlZCkgPT0NCj4gMCAmJg0KPiArCSAgICBzdHJj
bXAobWFuYWdlZCwgImluLWJhbmQtc3RhdHVzIikgPT0gMCkgew0KPiArCQkvKiBzdGF0dXMgaXMg
emVyb2VkLCBuYW1lbHkgaXRzIC5saW5rIG1lbWJlciAqLw0KPiArCQlnb3RvIHJlZ2lzdGVyX3Bo
eTsNCj4gKwl9DQo+ICsNCj4gKwkvKiBOZXcgYmluZGluZyAqLw0KPiArCWZpeGVkX2xpbmtfbm9k
ZSA9IGZ3bm9kZV9nZXRfbmFtZWRfY2hpbGRfbm9kZShmd25vZGUsICJmaXhlZC0NCj4gbGluayIp
Ow0KPiArCWlmIChmaXhlZF9saW5rX25vZGUpIHsNCj4gKwkJc3RhdHVzLmxpbmsgPSAxOw0KPiAr
CQlzdGF0dXMuZHVwbGV4ID0NCj4gZndub2RlX3Byb3BlcnR5X3ByZXNlbnQoZml4ZWRfbGlua19u
b2RlLA0KPiArCQkJCQkJCSJmdWxsLWR1cGxleCIpOw0KPiArCQlyYyA9IGZ3bm9kZV9wcm9wZXJ0
eV9yZWFkX3UzMihmaXhlZF9saW5rX25vZGUsICJzcGVlZCIsDQo+ICsJCQkJCSAgICAgICZzdGF0
dXMuc3BlZWQpOw0KPiArCQlpZiAocmMpIHsNCj4gKwkJCWZ3bm9kZV9oYW5kbGVfcHV0KGZpeGVk
X2xpbmtfbm9kZSk7DQo+ICsJCQlyZXR1cm4gcmM7DQo+ICsJCX0NCj4gKwkJc3RhdHVzLnBhdXNl
ID0gZndub2RlX3Byb3BlcnR5X3ByZXNlbnQoZml4ZWRfbGlua19ub2RlLA0KPiAicGF1c2UiKTsN
Cj4gKwkJc3RhdHVzLmFzeW1fcGF1c2UgPQ0KPiBmd25vZGVfcHJvcGVydHlfcHJlc2VudChmaXhl
ZF9saW5rX25vZGUsDQo+ICsJCQkJCQkJICAgICJhc3ltLQ0KPiBwYXVzZSIpOw0KPiArCQlmd25v
ZGVfaGFuZGxlX3B1dChmaXhlZF9saW5rX25vZGUpOw0KPiArDQo+ICsJCWdvdG8gcmVnaXN0ZXJf
cGh5Ow0KPiArCX0NCj4gKw0KPiArCS8qIE9sZCBiaW5kaW5nICovDQo+ICsJcmMgPSBmd25vZGVf
cHJvcGVydHlfcmVhZF91MzJfYXJyYXkoZndub2RlLCAiZml4ZWQtbGluayIsDQo+IGZpeGVkX2xp
bmtfcHJvcCwNCj4gKwkJCQkJICAgIEFSUkFZX1NJWkUoZml4ZWRfbGlua19wcm9wKQ0KPiApOw0K
PiArCWlmIChyYykNCj4gKwkJcmV0dXJuIHJjOw0KPiArDQo+ICsJc3RhdHVzLmxpbmsgPSAxOw0K
PiArCXN0YXR1cy5kdXBsZXggPSBmaXhlZF9saW5rX3Byb3BbMV07DQo+ICsJc3RhdHVzLnNwZWVk
ICA9IGZpeGVkX2xpbmtfcHJvcFsyXTsNCj4gKwlzdGF0dXMucGF1c2UgID0gZml4ZWRfbGlua19w
cm9wWzNdOw0KPiArCXN0YXR1cy5hc3ltX3BhdXNlID0gZml4ZWRfbGlua19wcm9wWzRdOw0KPiAr
DQo+ICtyZWdpc3Rlcl9waHk6DQo+ICsJcmV0dXJuIFBUUl9FUlJfT1JfWkVSTyhmaXhlZF9waHlf
cmVnaXN0ZXIoUEhZX1BPTEwsICZzdGF0dXMsDQo+IGZ3bm9kZSkpOw0KPiArfQ0KPiArRVhQT1JU
X1NZTUJPTChmd25vZGVfcGh5X3JlZ2lzdGVyX2ZpeGVkX2xpbmspOw0KPiArDQo+IA0KPiAgDQo=
