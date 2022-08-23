Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0593959E4A1
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 15:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiHWNsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 09:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241407AbiHWNrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 09:47:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4174A112EC4;
        Tue, 23 Aug 2022 03:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661251964; x=1692787964;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0HfaDOGaKomdS9xHaOBue2gHCW9gag2JhPnNK9r/ElY=;
  b=YYVCcRmx1BigFEXwyfAPFuiiEzjUk/lTb4692YQn7XfDu1sV9zzn0weM
   mkAMYp/bvpJxNjzF9C0830sq8yzuFgUhm/Xq1gOega+6ksiEHU40vn8/q
   WjJZ7jARz4iyohgZipJsa1lEK1B8J+3jIcQXYFGaC0i1q5B6mzYhsCuLl
   6xIl/m6vXxdIFlejqwZ0CU6FfGEZ/k/z/kF9w42B0uwqLdeeIZ5g4sfuW
   pLeS9mgvEHlDi7qGHbYBa76X2nmaAJh4N8QIqDcmXqIICjTJ7osob0U4R
   2sZ6Fr9NZu/32o2kzzMSdtB80PmQ9qdp3HovGLcPrupVlcBpiYgFNkJ8q
   A==;
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="173687999"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Aug 2022 03:45:40 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 23 Aug 2022 03:45:40 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Tue, 23 Aug 2022 03:45:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEyCPPy2pLef+3FnsyoUaPIiQ0MQv2lWFEVpONEkGQoKLQ0Y+tED1byuTZXHX9ALtqsW8GceiB0c6rMQ9dJtNdPa/QTGCe6w2JhMUQY4ytSwwkdCgW0GCQjorJi9kMD98CEyQXFlngWKF1NCrKfdsYAbVxw7jMPsuyiIpN+OYJssR6wPPTvIkGY/3uFqpWfXwgfYS67/2s24Yag8J1ozBRuKWB4rY3Z9qnD+AQoXExCdUO/OIbgkXygommKzxjtTxeILGjD6jFHJL1QLEZVeSfJi9BhnRki7NOff13GRfFlJ1VkFNjkcglYlS/H3JC5jw2/LOKNvRvPLIVJpaD/9gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0HfaDOGaKomdS9xHaOBue2gHCW9gag2JhPnNK9r/ElY=;
 b=RNp4MJmXkocnxObZQMmNyYMV4sK8XC3i466mnLsft8P7r1wqntt3zXauSuXxc+Dyp4GNtfUeI0tQRDL1ClXwILUaqPJDGEDlmcbeOIBvmuPIt7evZ3CDKXZMdu6zrZRGo5SPvz3q5Lc9XKMv0dJz+bDUiZbeDuRv7eTB544JaNZ1A0IETYf+J+SmOxg4aTckN/qT17ewfn8i2Sba7/BHTQ8T1u/gHPxz+LNiHuvFc6+Aw84yCig/Obpj6sAWIAxr7J+xiIJW+gkpR0CoAA4oUkqDXqYDZRan8P0v0zC3cr/rj418x5eejkc/aBz4jNIjCtuBI8mcKlvVEA8wnSRNmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HfaDOGaKomdS9xHaOBue2gHCW9gag2JhPnNK9r/ElY=;
 b=ktKbYbZHUBpsqjWe3Ko3xbCcBwmOSyMSfrS0zV/I48gLXLTyiKivzTs5El2/6E8KGsckK+UCa0R7QM+wAaAEP3AOALBXMf/vSyWxam0TaeRa5bVCQtP3wfm76VfGtlEgTMOpz8w09FFcdr4RdxEtgtdBmYTBOO/Os4lz1DskBQU=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 BN6PR1101MB2305.namprd11.prod.outlook.com (2603:10b6:405:4d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Tue, 23 Aug
 2022 10:45:35 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::945f:fc90:5ca3:d69a]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::945f:fc90:5ca3:d69a%6]) with mapi id 15.20.5546.021; Tue, 23 Aug 2022
 10:45:35 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <andrew@lunn.ch>
CC:     <olteanv@gmail.com>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [RFC Patch net-next v2] net: dsa: microchip: lan937x: enable
 interrupt for internal phy link detection
Thread-Topic: [RFC Patch net-next v2] net: dsa: microchip: lan937x: enable
 interrupt for internal phy link detection
Thread-Index: AQHYtgiNtEkHMlfxJUuZi3LTVSyR5a265aIAgAFpO4A=
Date:   Tue, 23 Aug 2022 10:45:35 +0000
Message-ID: <b1e66b49e8006bd7dcb3fd74d5185db807e5a9f6.camel@microchip.com>
References: <20220822092017.5671-1-arun.ramadoss@microchip.com>
         <YwOAxh7Bc12OornD@lunn.ch>
In-Reply-To: <YwOAxh7Bc12OornD@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20ac56d4-5b5f-495b-bcab-08da84f49c1d
x-ms-traffictypediagnostic: BN6PR1101MB2305:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kYpY56EIQygMpJlcNuU71OYO5tjAf9gF9W2SiZTUMcTtLddUn9HI0irhVMqrRTGmeeLNUWfd92N3gGdta6ARbytoJ3VM2nDbyFePKCaEABpwsAATLQhmx4N2AU1DA0j59nnS0Xa0rnT14vFxhiNOkt7S+NdEJx8qjtGrpGt3QHPGhpcgibug3oubHZLkktZzKnUxBpSKn99/HbmwDXaN/awikMl1TU1tH63F7m5X+l9eqfsV0IhFxM3Z7Yg22dSElulisUpiDzyoVDrhRcomo/Q0O0qLZ5Y50HFxkY596PwHsSyoWQoM3S3cJL8Qbq+jo4b5bfw5veq8csfZktE7SZ31H6AujdkEA36jCIBPXVkqS+efELVe/jOaP9lv84roD3VpvfiMvoIcftEitiaY6mwSuYybw6nyRHM3+oZ5LumNh5FCxbxiyS/eDhLz3Ox9CP0TEWfRJZ4KmnGKhgkL+HsJWVwAOBS6W81Rnx13uxr2qLZJJ+1c+mcl6Rjg8aIKGWQWK2eIZFdqJYWxhsb6+Z7HCVjCOe88m+HP1bn4Hw9gT0SzDI2eZvlb0wTiZwy6w57qEsvRF0U8xNWNLBKD2fblunBnDgrcGL8fsQyYZppRCHIhTQEg/NP5xAsL3qNJNfB4wfSX2bpmppkn/Q3yCOqVfqLqRzjDiCAcylShq8GkNokAtLoLDt9w9heUZAukwQMsEfBHowCnjj2rI3HehENHhsAdfbPscA6J50ZUEy2spTq+FYylIOk4Z2JwyWi1H+0GGiPyF18llUw6Vt5iOH35RU5HT9pCIGT+4gNiXG5rjFoUnD+fIekiRgegFu86
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(346002)(39860400002)(396003)(136003)(38100700002)(86362001)(38070700005)(122000001)(41300700001)(8936002)(6916009)(7416002)(316002)(54906003)(6486002)(66556008)(6512007)(66946007)(76116006)(66446008)(8676002)(91956017)(71200400001)(66476007)(64756008)(5660300002)(36756003)(186003)(2616005)(4326008)(83380400001)(2906002)(6506007)(966005)(26005)(478600001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YzRvejl6ZWVmVE9SM2hhbTRRdlNldnlBalpWcFhqTFN0b1oyRzFnak9CK2c2?=
 =?utf-8?B?S3prYjVqMUZaa2ZyakVQaFVSUmpzMDlnQTJ6M1ZSMEJVc1VEVWlhRlczdEh6?=
 =?utf-8?B?ckw1UHRudGZjTnNPaHJiWXBoTW9JaC9OblRORUVVc1FjeVBVcjROa2dYTUZV?=
 =?utf-8?B?R1JFVVFQNStpcHJ0Wnl0VThPbWE4K1NYdGpYdUdIYmY4a0hrVG1OWElCS2Zj?=
 =?utf-8?B?OStadG44amd5SjB4YTBCbzJCOU03Z1lXcEZWam15SFpiQ24xbG44U25KK28w?=
 =?utf-8?B?c1RLMGlwTlRJM0JpWDhKVVFoa09ObnRGeDZCdTRXbmJTd1dzVWFVY05uODk5?=
 =?utf-8?B?WXIxOUJLNm16NU04aVA1U3BzTkpoMHJIalpVcjcvZy91NEFoa3hFd2NyWlRk?=
 =?utf-8?B?K2ZBUW1pb3ZONjFYUTdSTmdraTQ1ekswRFFOQmJLZnRsT3U3OFM1R25zSXl5?=
 =?utf-8?B?VEhvTk9zdXhzNjZoZjRaQWpSTHQrUGs0RGRkYkdzL2tLSzZ4bFdVa05HOW1h?=
 =?utf-8?B?TCtoMjV0N0JvNXhTNkNZMXd3QWVFekpOOUc3ZlQyczBPSlJha2wrUTlKdG56?=
 =?utf-8?B?bXJFTGVOUHFtRXBRRVh1Ujh1VmJQR1lWRkl6d3R1UmRpZlM1N20vLzUrQVlq?=
 =?utf-8?B?WmwvSTRFZDRjUGZxbUpQblBxVEQyREdtWVBLbE9xdkZCbEhyb1k3a3ltOTdp?=
 =?utf-8?B?L2NVR2pxNGRmUVRoaitpbVdiK0p3bXh3Wmd4dHQ5ZTdmdmlVakJTMG9PU1Iz?=
 =?utf-8?B?Vi82RWRnL29rNmFpTzBJQjQ2anRRN1YxTTRqVEJ4RjcyRDF2aGVIR052QUc4?=
 =?utf-8?B?UGdaa2NEOElycEZENGlDcnRMNUR1TlVzTUZKTjY3MUM0RGRIMzRLaS9vNThq?=
 =?utf-8?B?bEpXVnRCOHVxbzAxNGNJVUpLb1JFQkI4NVZqWGdpNVNUZ0VvRHlSTTBVRmhk?=
 =?utf-8?B?MnhkQWtMQVU0ZFFJSzcxSC8yR2l2eURZeTJBM2lvdWttaTIwczBCTDJFM2dp?=
 =?utf-8?B?bjRBMTg4dytnREIzb29RKzlOUWh3elN2MEtVRmRsaEZOOFQ5L1dFL2IvWjFO?=
 =?utf-8?B?K2RmQ2tXVUNER0c2NWxKVU5VeVloREI0dnZXN204bzB0SmxZN3c5Skhudndm?=
 =?utf-8?B?SzFxaGVwbm1iRWJNUE16cjhOOTR4WmVoTDRzdktWenh4OUZwWitINk5KbDVo?=
 =?utf-8?B?ZHZtQUpjdjhaQU9ZcStsWmtzaVk3TE00R0YveWtLWTZPN25abk52YjVzVS8y?=
 =?utf-8?B?ZnExekZrM0VzOE5QenBGb3F5c09BOWlvZlZ0bzd6cnhXbnArMVhVRXpONWFQ?=
 =?utf-8?B?UUc0SHFiS1NRc2JGMFJZYkJ0WFVQcFg5T2F3UG4zRkR5Q1NLeVhTM1dZdXF4?=
 =?utf-8?B?aGRCbWpZblJtL01DSTRBbEVMSGdxMFA0MVRGMmwyRG5BbnMvRm11V05Rd2Z4?=
 =?utf-8?B?NDM4LzNZdjZVc3VnUUxBc1RzdXVOellhTUlPcXAvMWMxM1g0enAzM2JXUGV1?=
 =?utf-8?B?WDhRTEs0TXFnWnFmd0E0TXRzV1RXMDNGZVpDZmR0Z3RLbVpEOXJaeTNOVWtV?=
 =?utf-8?B?blVFbW5LUVlvZk01UEIxU2UxOWhoSkZjamlORXhVWVl5bjdUdERjWnNDa2hj?=
 =?utf-8?B?aHU2bi9JMFJkWGUyR25ibFRSRnpNaUR0NzlmbHNWckFybTNONG1vS29kNEFa?=
 =?utf-8?B?ekxaUkw0VVI0NnhiOGtJMUV6dEE3N253ek1OOG82a0ZkV3JLc0pqdW9kdWpj?=
 =?utf-8?B?Mmk5Mnk4d3ZOSkJRM3BHQjdtU0NwOWJqRlUvVVlCd1ltQ0ZLVjZFN2RkbkhW?=
 =?utf-8?B?Qlp0S3I3c1BEcGY2Z2JOTFRQWVlhUnQrNTB5aFJCek9wTDF6dVFvcy90K0JL?=
 =?utf-8?B?TXhZLy9Ea0FsWU9CVmZSOFBjVThrWm5sME9KaEt5UG5YcW5QYUtJbGNoMDNH?=
 =?utf-8?B?WFV4ZGg0cVU1UmJQQjNGUkdDYlFLMndnVFBFU2VSV1lZbnlOS2R3R0ZtVWM0?=
 =?utf-8?B?RWVzNTBMVldYbFo3OFczQUJpWVpnZENWUWZpeXhmOTJOMnpSdngzcHlBNFIx?=
 =?utf-8?B?dGFnTFNMc1JjY3FDeVVSd08zL09SSXJvY3lIQ2hhc2RoM1J6MVZLTFcwNGhQ?=
 =?utf-8?B?VmhoUTQ2UVRlWER4MHFDV1ZRMFBFYVM2TmhPVXZYK0F4UjVZaWhIQ3RQblN3?=
 =?utf-8?Q?Oq+05EcMguUJmtTM8/kxVi4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0367A7BDFA7C55439FAEE2D64602A81F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ac56d4-5b5f-495b-bcab-08da84f49c1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2022 10:45:35.2115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xKxyiZuV/DDRgGd1E9qe5Bob7p4qUm66Zd5/MwguT/QHGUa+T6XGKrlE4LD/Vf1/tuBDaIejRZueXEnMAnufyoWroOVKN6fiiApzv/8auLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2305
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KVGhhbmtzIGZvciB0aGUgY29tbWVudHMNCg0KT24gTW9uLCAyMDIyLTA4LTIy
IGF0IDE1OjEyICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERv
IG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0
aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBNb24sIEF1ZyAyMiwgMjAyMiBhdCAwMjo1MDox
N1BNICswNTMwLCBBcnVuIFJhbWFkb3NzIHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2ggZW5hYmxlcyB0
aGUgaW50ZXJydXB0cyBmb3IgaW50ZXJuYWwgcGh5IGxpbmsgZGV0ZWN0aW9uDQo+ID4gZm9yDQo+
ID4gTEFOOTM3eC4gVGhlIGludGVycnVwdCBlbmFibGUgYml0cyBhcmUgYWN0aXZlIGxvdy4gSXQg
Zmlyc3QgZW5hYmxlcw0KPiA+IHBvcnQNCj4gPiBpbnRlcnJ1cHQgYW5kIHRoZW4gcG9ydCBwaHkg
aW50ZXJydXB0LiBBbHNvIHBhdGNoIHJlZ2lzdGVyIHRoZSBpcnENCj4gPiB0aHJlYWQgYW5kIGlu
IHRoZSBJU1Igcm91dGluZSBpdCBjbGVhcnMgdGhlIFBPUl9SRUFEWV9TVFMgYml0Lg0KPiA+IFBP
Ul9SRUFEWV9TVFMgYml0IGlzIHdyaXRlIG9uZSBjbGVhciBiaXQgYW5kIGFsbCBvdGhlciBiaXQg
aW4gdGhlDQo+ID4gcmVnaXN0ZXIgYXJlIHJlYWQgb25seS4gU2luY2UgcGh5IGludGVycnVwdHMg
YXJlIGhhbmRsZWQgYnkgdGhlDQo+ID4gbGFuOTM3eA0KPiA+IHBoeSBsYXllciwgc3dpdGNoIGlu
dGVycnVwdCByb3V0aW5lIGRvZXMgbm90IHJlYWQgdGhlIHBoeSBsYXllcg0KPiA+IGludGVycnVw
dHMuDQo+ID4gK3N0YXRpYyBpcnFyZXR1cm5fdCBsYW45Mzd4X3N3aXRjaF9pcnFfdGhyZWFkKGlu
dCBpcnEsIHZvaWQNCj4gPiAqZGV2X2lkKQ0KPiA+ICt7DQo+ID4gKyAgICAgc3RydWN0IGtzel9k
ZXZpY2UgKmRldiA9IGRldl9pZDsNCj4gPiArICAgICBpcnFyZXR1cm5fdCByZXN1bHQgPSBJUlFf
Tk9ORTsNCj4gPiArICAgICB1MzIgZGF0YTsNCj4gPiArICAgICBpbnQgcmV0Ow0KPiA+ICsNCj4g
PiArICAgICAvKiBSZWFkIGdsb2JhbCBpbnRlcnJ1cHQgc3RhdHVzIHJlZ2lzdGVyICovDQo+ID4g
KyAgICAgcmV0ID0ga3N6X3JlYWQzMihkZXYsIFJFR19TV19JTlRfU1RBVFVTX180LCAmZGF0YSk7
DQo+ID4gKyAgICAgaWYgKHJldCkNCj4gPiArICAgICAgICAgICAgIHJldHVybiByZXN1bHQ7DQo+
ID4gKw0KPiA+ICsgICAgIGlmIChkYXRhICYgUE9SX1JFQURZX0lOVCkgew0KPiA+ICsgICAgICAg
ICAgICAgcmV0ID0ga3N6X3dyaXRlMzIoZGV2LCBSRUdfU1dfSU5UX1NUQVRVU19fNCwNCj4gPiBQ
T1JfUkVBRFlfSU5UKTsNCj4gPiArICAgICAgICAgICAgIGlmIChyZXQpDQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgIHJldHVybiByZXN1bHQ7DQo+ID4gKyAgICAgfQ0KPiA+ICsNCj4gPiArICAg
ICByZXR1cm4gcmVzdWx0Ow0KPiA+ICt9DQo+IA0KPiBJIGRvbid0IHVuZGVyc3RhbmQgaG93IHRo
aXMgYWxsIGZpdHMgdG9nZXRoZXIuIEhvdyBkbyB5b3UgZ2V0IGZyb20NCj4gdGhpcyBpbnRlcnJ1
cHQgaGFuZGxlciBpbnRvIHRoZSBQSFkgaW50ZXJydXB0IGhhbmRsZXI/DQo+IA0KSSB1c2VkIHRo
ZSBzYW1lIGdwaW8gbGluZSBudW1iZXIgb2Ygc3dpdGNoIGFzIHRoZSBpbnRlcnJ1cHQgZm9yDQpp
bnRlcm5hbCBwaHkuIEFuZCB3aGVuIHBoeSBsaW5rIHVwL2Rvd24gaGFwcGVucywgaXQgdHJpZ2dl
cnMgYm90aCB0aGUNCnN3aXRjaCBhbmQgcGh5IGludGVycnVwdCByb3V0aW5lLiANCkVhcmxpZXIg
SSB0cmllZCB0byBmaW5kIG91dCBob3cgdG8gbGluayBzd2l0Y2ggcG9ydCBpbnRlcnJ1cHQgdG8g
cGh5bGliDQpidXQgSSBjb3VsZCBub3QgZ2V0IHRoZSBsb2dpYy4gT25seSBhZnRlciByZWFkaW5n
IHlvdXIgY29tbWVudCBJIGNvbWUNCnRvIGtub3cgcGh5IGludGVycnVwdCBjYW4gYmUgdHJpZ2dl
cmVkIGZyb20gdGhlIHN3aXRjaCBpbnRlcnJ1cHQNCmhhbmRsZXIuIA0KVG9kYXkgSSB3ZW50IHRo
cm91Z2ggdGhlIG1hcnZlbCBpbXBsZW1lbnRhdGlvbiBvbiBpbnRlcnJ1cHQgaGFuZGxpbmcNCmJ1
dCBjb3VsZCBub3QgZ3Jhc3AgZnVsbHkuICgNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8x
NDc2NjQwNjEzLTI1MzY1LTMtZ2l0LXNlbmQtZW1haWwtYW5kcmV3QGx1bm4uY2gvVC8jbTc0YTEz
OWQ0M2NhNjQ4MzM4MzJkODY4MTBlMmY0NDc0Mjc3ZDdiZjINCikNCkkgaGF2ZSBub3QgdXNlZCBp
cnFfZG9tYWluIGJlZm9yZS4gQ2FuIHlvdSBwbGVhc2UgYnJpZWYgb24gaG93IHBoeQ0KaW50ZXJy
dXB0IGhhbmRsZXIgaXMgY2FsbGVkIGZyb20gY2hpcC5jICYgZ2xvYmFsMi4NCg0KVGhlIGR0cyBm
aWxlIEkgdXNlZCBmb3IgdGVzdGluZywNCnNwaTE6IHNwaUBmODAwODAwMCB7DQoJY3MtZ3Bpb3Mg
PSA8MD4sIDwwPiwgPDA+LCA8JnBpb0MgMjggMD47DQoJaWQgPSA8MT47DQoJc3RhdHVzID0gIm9r
YXkiOw0KCQ0KCWxhbjkzNzA6IGxhbjkzNzBAMyB7DQoJCWNvbXBhdGlibGUgPSAibWljcm9jaGlw
LGxhbjkzNzAiOw0KCQlyZWcgPSA8Mz47DQoJCXNwaS1tYXgtZnJlcXVlbmN5ID0gPDQ0MDAwMDAw
PjsNCgkJaW50ZXJydXB0LXBhcmVudCA9IDwmcGlvQj47DQoJCWludGVycnVwdHMgPSA8MjggSVJR
X1RZUEVfTEVWRUxfTE9XPjsNCgkJaW50ZXJydXB0LWNvbnRyb2xsZXI7DQoJCXN0YXR1cyA9ICJv
a2F5IjsNCgkJcG9ydHMgew0KCQkJI2FkZHJlc3MtY2VsbHMgPSA8MT47DQoJCQkjc2l6ZS1jZWxs
cyA9IDwwPjsNCgkJCXBvcnRAMCB7DQoJCQkJcmVnID0gPDB4MD47DQoJCQkJcGh5LWhhbmRsZSA9
IDwmdDFwaHkwPjsNCgkJCQlwaHktbW9kZSA9ICJpbnRlcm5hbCI7DQoJCQkJbGFiZWwgPSAibGFu
MSI7DQoJCQl9Ow0KCQkJcG9ydEAxIHsNCgkJCQlyZWcgPSA8MHgxPjsNCgkJCQlwaHktaGFuZGxl
ID0gPCZ0MXBoeTE+Ow0KCQkJCXBoeS1tb2RlID0gImludGVybmFsIjsNCgkJCQlsYWJlbCA9ICJs
YW4yIjsNCgkJCX07DQoJCX0NCgl9DQoNCgltZGlvIHsNCgkJI2FkZHJlc3MtY2VsbHMgPSA8MT47
DQoJCSNzaXplLWNlbGxzID0gPDA+Ow0KCQljb21wYXRpYmxlID0gIm1pY3JvY2hpcCxsYW45Mzd4
LW1kaW8iOw0KCQkNCgkJdDFwaHkwOiBldGhlcm5ldC1waHlAMHsNCgkJCWludGVycnVwdC1wYXJl
bnQgPSA8JmxhbjkzNzA+Ow0KCQkJaW50ZXJydXB0cyA9IDwyOCBJUlFfVFlQRV9MRVZFTF9MT1c+
Ow0KCQkJcmVnID0gPDB4MD47DQoJCX07DQoJCXQxcGh5MTogZXRoZXJuZXQtcGh5QDF7DQoJCQlp
bnRlcnJ1cHQtcGFyZW50ID0gPCZsYW45MzcwPjsNCgkJCWludGVycnVwdHMgPSA8MjggSVJRX1RZ
UEVfTEVWRUxfTE9XPjsNCgkJCXJlZyA9IDwweDE+Ow0KCQl9Ow0KCX0NCn0NCg0KSXMgdGhlcmUg
YW55dGhpbmcsIEkgbmVlZCB0byBjaGFuZ2UgaW4gdGhlIGR0cyBmaWxlLg0KDQo+IFRoZSBoYXJk
d2FyZSBsb29rcyBzaW1pbGFyIHRvIHRoZSBtdjg4ZTZ4eHggZHJpdmVyLiBZb3UgaGF2ZSBhIHRv
cA0KPiBsZXZlbCBpbnRlcnJ1cHQgY29udHJvbGxlciB3aGljaCBpbmRpY2F0ZXMgYSBwb3J0IGhh
cyBzb21lIHNvcnQgb2YNCj4gaW50ZXJydXB0IGhhbmRsZXIuIFRoaXMgaXMgdGhlIG12ODhlNnh4
eF9nMV9pcnFfdGhyZWFkX3dvcmsoKS4gSXQNCj4gZmluZHMgd2hpY2ggcG9ydCB0cmlnZ2VyZWQg
dGhlIGludGVycnVwdCBhbmQgdGhlbiBoYW5kcyB0aGUgaW50ZXJydXB0DQo+IG9mZiB0byB0aGUg
bmVzdGVkIGludGVycnVwdCBoYW5kbGVyLg0KPiANCj4gbXY4OGU2eHh4X2cyX2lycV90aHJlYWRf
Zm4oKSBpcyB0aGUgbmVzdGVkIHBlciBwb3J0IGludGVycnVwdA0KPiBoYW5kbGVyLiBJdCByZWFk
cyB0aGUgcGVyIHBvcnQgaW50ZXJydXB0IHN0YXR1cyByZWdpc3RlciwgZmluZCB0aGUNCj4gaW50
ZXJydXB0IGhhbmRsZXIgYW5kIGNhbGxzIHRoZSBuZXN0ZWQgaW50ZXJydXB0IGhhbmRsZXIuDQo+
IA0KPiBUaGlzIGFsbCBnbHVlcyB0b2dldGhlciBiZWNhdXNlIHBoeWxpYiBkb2VzIGEgcmVxdWVz
dF90aHJlYWRlZF9pcnEoKQ0KPiBmb3IgdGhlIFBIWSBpbnRlcnJ1cHQsIHNvIHRoaXMgbGFzdCBu
ZXN0ZWQgaW50ZXJydXB0IGhhbmRsZXIgaXMgaW4NCj4gcGh5bGliLg0KPiANCj4gICAgICAgICBB
bmRyZXcNCg0K
