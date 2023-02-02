Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D826688195
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbjBBPT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbjBBPTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:19:13 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2073.outbound.protection.outlook.com [40.107.6.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F2192C3E
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 07:18:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWniki2VLyv8A7MrBBTHSzfpkBh+0SoYQpQ7p4n3FzZgTYqRVz86LoeHCJ1VwqJgYGbULcfoHMi4vK9th0iNw/kifNEXk1tYxgPPnlGFv9kGkodENk3kWhUw8pXKYvZ8q4gsMlUeySFDXOhXbdfCeU2jxIXzjBH5Gadn+lDLgnL6lXH4aflCtinMBd52Ubisy8PyxadmB8n5hLvDt7R+NJvRXYNbcr1/ndQ2G3B71tZ92oNVNsz9iC0EEsYNYhR+LLyAl7VVnGSUZ7ynvfLijs1UKgUDOPclFxzoilPiC+XVY1gpsAP6hDDwspz5FI4ZGxSrBQgdOHTG6oMZGqdiDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=icjME53Bf0olYA/CbOfFv3rXpGUFFb0jdVdT3V11y6Q=;
 b=TI4bGnKxn7z+6Q7ODIJR/6/QzVzLoM3zX1JiBI8mobAj9fyF7hjXcruf2Iu2dhW0myBF2RrRkjVQtEhBpWWuWpfcotYdjwj59SXy+oRf+B3WMQGPtIiVn8w16Ozr9oKp8KfVRdPPwy6ADNi8WXWHbQVmVo1hSizXrWnYnDUO4qDdtiGJQyucW5lnx5B8SR3cc/ByTm1pAJJgZVOvmQ5TUdig462RPUs3BKWpLtjWDaB0YcM6CtCONH8Ltoll+gLuPjKfyA6+Rw3AmnIt6FEfH3++9ktbOOOjQt1p7z+5NE1kIiWhnNyVyPYUHiZm1jh6TtoXizdRmfoTQiCeykQtQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=icjME53Bf0olYA/CbOfFv3rXpGUFFb0jdVdT3V11y6Q=;
 b=gCwA+xvLx1x+UScRwMgnPsnA0yhQ132e4WCXmSgZsVY8chJFpVoOqoaklJSWk1qfq9G1cBlu8jkSg+2uq768D2QDhU8AQ2qAmkrKCyDiMJ5iuOyUEGPVUi46+3Tzb4wJEvD9vJWcWJoPM8fWcGs1NsIjXKNqSFdbsmhSKU7uliSYuvvbvKDQ9d+l0NQv2gwAHKpfs07VYgeH1/AqNx+Dtfg2MnQzvwUBJ1QDb5uFiI2+LU3sw9NkHc5Ngty1q85SxWP+P7Qlxmmqi67ibRdxwe24JX+VDyaaaP+2afbwRptyr2XMI/zv233rKuDUgPR0uz7uTdsS7IJycdZ0LUuUvA==
Received: from DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:138::9)
 by DU0PR10MB5752.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:323::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 15:18:38 +0000
Received: from DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8ab5:2969:2854:63f0]) by DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8ab5:2969:2854:63f0%8]) with mapi id 15.20.6064.027; Thu, 2 Feb 2023
 15:18:37 +0000
From:   "Valek, Andrej" <andrej.valek@siemens.com>
To:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: DSA mv88e6xxx_probe
Thread-Topic: DSA mv88e6xxx_probe
Thread-Index: AQHZNxmfDlWccw5bT0qZPgjeOkJESQ==
Date:   Thu, 2 Feb 2023 15:18:37 +0000
Message-ID: <cf6fb63cdce40105c5247cdbcb64c1729e19d04a.camel@siemens.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB8PR10MB3977:EE_|DU0PR10MB5752:EE_
x-ms-office365-filtering-correlation-id: 81e95e71-1409-4e2d-4cd2-08db0530c247
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: buxy89wC+5GDR9815KYUJFtMBCQUCfEWEUFn+uTZULamBn2cNaQfF0+2x/0Azd718SgSaQrJDCZvFkjefcsCcvjQge6eudNxm0nBFloGPhtKnzFPt0pzZaAF6OqYsmiTBOCQJOI6Z14qsb8uBbKpoDi5CCN3WCzj7cXWjgm5asfU+xAVJnWVzj+4PMyFCfpwoseT9p5fqIhXj10+7tXCyXfOIPpY8yx3oIswAXWdLBMaFq6htngMr/3OSkPWmhJPZYd3dBpw+H+k6qRFxjdcPKioFxfRDgwefYCrb7imRhPEkzyEqquT7inEcTJLNx5pyybcyQbEw7++0ewCrN9BHK8mgDFfTXHH4XZWvBU8DckWnePld7VXYl027xzihhyQWtdVKJ8FEhWIugHc0qsjFlkJOgJo9pD9YWaodkvl+3szuFYdD6M0AoIdJu1mHNOSHYFVC/LdQ495TDmWuIlsm9nRf5gRFhpd592g0zrcvny0/QHYUczkkWXHPVhmSicDvPUJJLkFzgFDAui2kYZ3q2W1Mcs37KwUhUt1Y1r7qimzKBcv8+UF5ZgphIfYtgMTHlJJwekdt07JX9rL+QD9/SEYwFi6aJLMG3RhNWT6nz0dZksIaYqikA0tPYMcsXRBQAn8HOf8DxhwDtwQjJ0mU4L93hdkVGhafB0aWSLydjPkD9RsbVqu4titsmeIrSUTBgGK5IvTWk8TcAm+4jsZxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199018)(2906002)(5660300002)(38100700002)(122000001)(36756003)(71200400001)(316002)(38070700005)(6486002)(26005)(6506007)(186003)(2616005)(478600001)(6512007)(82960400001)(86362001)(110136005)(76116006)(91956017)(66476007)(8936002)(66446008)(66556008)(83380400001)(8676002)(4326008)(64756008)(41300700001)(7116003)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUMyK3FyTUxhaTBXYzRWblZKRnZoSzZ2bUdydUJ2THYzdTZ1R1BMZ2JGSkRB?=
 =?utf-8?B?aTBNRko5dlo2MUZ0SXNRVkdJZUV1L1ByNXhZd2g5Vk8yTkpEY09BSjlsMThz?=
 =?utf-8?B?aWJ2ZWdkT00zNUUzYmNWdHBSby90bG5kSDNsMVRFTERWYTBlSzVwc2ZpYkNC?=
 =?utf-8?B?ZGlMR3c4TWtuNVc1b1Jyc1JpbE9hRzZ1WEZLVGlkNDhMWGVCajdXWmJqVlBL?=
 =?utf-8?B?VVQza0ZtQk5ncjAxQXJXZ3FXUTczTUQxUFZYVEh4aVlQVUNZaGJrLytvTUJF?=
 =?utf-8?B?ZmxWbWpLQlpWTjR1cXdjRksxZmtwUU9EUjhnSyt4MWVGeGk0dnZXczlaZmgv?=
 =?utf-8?B?UzNEenBva0hOWU9FN3p2S2ZjQ3BBWVRMZThEN0hxaFpDeE0wUytRV3VnUkZN?=
 =?utf-8?B?dEkvT0UyUkZub1NoRmpjeG9QdDNEeXJVVHZ1eEV1aDU5bm4zbGdRd3UxSWxO?=
 =?utf-8?B?eERTOG5BdDcveEVORGxjUnVWZVZmK1c2VmJQcW1lM0doYjBuTWxNaWs5Vkhi?=
 =?utf-8?B?d3h1Zys4TnY1Z2JRWTNsU1IraFFUQklsQWZWem1TWnprU0pxT1VldmpLaElr?=
 =?utf-8?B?S3l4ZmVoaGZPNEN4SUx2U0NyOC9KeU83UUF0UW9ka045amhGRlp3aVBZMSt6?=
 =?utf-8?B?UFcxNVN3ejYxZFVZRzF1dXFIRHYrVGVoVHREOERNMDJGWlZ3cUxSdHkzUW96?=
 =?utf-8?B?RWVQYzhmV0NtNk5RZDhpQ2lFTk9sc2FEbks1ZWlaVjIrY0FnWGhhVDV3cHNq?=
 =?utf-8?B?aGt0emsrTjJOTjJndDFrLzFySGw1QlVhd2t4cjhTalFieUcyK0FsQzh3NjRu?=
 =?utf-8?B?VXVHNzJIcnBxamhhRnVvc3BQY2lPRGJBR1FwaDVWNk42eE9DRTd5V3VING4z?=
 =?utf-8?B?RlpUU3N5cmZkd2kzMHhnLzZ3bzE1ZFhYRmtPRFRYa2s2K3dMRStPU3ZGelhZ?=
 =?utf-8?B?SUhkZnZkMHQwd1N0bDRWOEpJU2NFS1JFV0dtaVBzcFVZTGdVRHlQbmMyQWFx?=
 =?utf-8?B?eGNQMzN5ZFVjRzJOckNQV0syQ0h2aFNjcXZUbVNwdTNlSHhDd3ZTMHZwYVBS?=
 =?utf-8?B?dGFoNVhIZm10QjRYWWwzd2tmSFoycjBYUHRBM1lSU0JCOVNGRUZxcFBLaE4y?=
 =?utf-8?B?QllDNnRrcVM2VXh4WmdJMkE2V280VExwVFhCTHBvYnd4Vkxwd1IvcnN4UjNv?=
 =?utf-8?B?SGhJaENtY0pYend3U3Y1VHBpVENkVUQvNjM3bUR6Z1dncHlOZ3Qyc01qOG1B?=
 =?utf-8?B?VE9yS3RNeXBLUXVHWklQSmFxSU1NeHBrR3BDQ1ZiL2N4Q1NzbkxQQlRCakxL?=
 =?utf-8?B?dG10d1ROVmVib1F2T3AyclorL0FjbDlrc3JnVjI4ZlBQN2N2TXkxZ2doRnBQ?=
 =?utf-8?B?emhyZHk2RFdJS0hablFTNWpEQmwzSUlEUVhKTFpmdGloaWlreFZ4ampjZnFF?=
 =?utf-8?B?RGFCZ0pEbWJFZFA2b05HMUVtNG83NHFSckYvcnI3UWdSbWE0TXJpTDVuZFUv?=
 =?utf-8?B?SnRtUmwrN1l2U051QjNWeWVKbFNsU05ja1pSdkZXNDhiT0dQUHY4WkNiTTY1?=
 =?utf-8?B?bjVLL1lRMkRJVlVyMy85NUk3V3FnaDJ6REQ3OFpwR3VzMkFNek9zZHRtSkxD?=
 =?utf-8?B?NFc2clZ6OThzUjN2RDgzK3M3VUcxdTM5OWpkckIvVFNMQkEzVktVbWIySGVF?=
 =?utf-8?B?WUhWckZRK1E5VDVZQU0xT3d5Y2EydFBxeU83S2UvNTFzV05DUEllL1p0S3NX?=
 =?utf-8?B?TWtWbUpFd1JRT3d6YllpNU1JNi95aU5wTTh0NjVxSXp0U0VwNXkwVERLTFBS?=
 =?utf-8?B?djh3QWd1TndPWWVFQzBleHBzWEVhWE4rZWZvZ2hFY0RxTnZEcDdtQmNodUZN?=
 =?utf-8?B?RTF2aW5vM3J6Sm10aytDam1haGFmaVQwekI0cHVmRW1uNE5WTVZXQVMyYWVY?=
 =?utf-8?B?Rm5pNnhZSW9jS29MWEMvajBqekowYzhFMGQzYlE4SWRyQ1hYY2NXYkxrZXo1?=
 =?utf-8?B?a1F3Sis1enl0L2NQR0ZGM0dpRnQ0ZkNRWXJPRUZ6WWpsblFheVdMYlpES2Qy?=
 =?utf-8?B?aEtEdTdocngraTd1YjY3ZncrWTVsdFB1OUxSS1RQMlNrMGsxdjR5MFlkcGl2?=
 =?utf-8?B?SUpzWDZMMUova3IzeG5lRFdDZ1RnaXkveHRKYUhvSlRyL2ZKcnk2b1ZVaDBP?=
 =?utf-8?B?WFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E3360A7D73516459B80169D04A8525B@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 81e95e71-1409-4e2d-4cd2-08db0530c247
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 15:18:37.8923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pic6HXasTcyo5IfLsf4UndiQHKM2loLzv7KQ5TURNTE6DrPsRo4H7/wJNM+v6z+ODZgxgB7kByQY9rThVPDCRsLwaHAJJMOzlYdzu3O6Iag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR10MB5752
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gZXZlcnlvbmUhDQoNCkkgaGF2ZSBhIHN3aXRjaCBtdjg4ZTYwODUgd2hpY2ggaXMgY29u
bmVjdGVkIHZpYSBNRElPIGJ1cyB0byBpTVguOCBTb0MuDQoNClN3aXRjaCBpcyBub3QgYmVpbmcg
ZGV0ZWN0ZWQgZHVyaW5nIGJvb3RpbmcgYmVjYXVzZSB0aGUgYWRkcmVzcyBpcw0KZGlmZmVyZW50
IChkdWUgdG8gdW5pbml0aWFsaXplZCBQSU5zIGZyb20gRFRCKS4gVGhlIHByb2JsZW0gaXMsIHRo
YXQNCnN3aXRjaCBoYXMgdG8gYmUgcmVzZXQgZHVyaW5nIGJvb3QgcGhhc2UsIGJ1dCBpdCBpc24n
dC4NCg0KU28gSSB3b3VsZCBsaWtlIHRvIGFzayB5b3UgbWF5YmUgYSBnZW5lcmljIHF1ZXN0aW9u
IGFib3V0DQpkZXZtX2dwaW9kX2dldF9vcHRpb25hbCBmdW5jdGlvbiBpbnNpZGUgbXY4OGU2eHh4
X3Byb2JlLg0KDQpJcyB0aGlzICJjaGlwLT5yZXNldCA9IGRldm1fZ3Bpb2RfZ2V0X29wdGlvbmFs
KGRldiwgInJlc2V0IiwNCkdQSU9EX09VVF9MT1cpOyIgbGluZSByZWFsbHkgZG8gdGhlIHJlc2V0
PyBCZWNhdXNlIGZyb20gdGhlIGxpbmVzIGJlbG93DQpsb29rcyBsaWtlLCBidXQgdGhlIHJlc2V0
IHB1bHNlIGhhc24ndCBiZWVuIG1hZGUuIE1lYXN1cmVkIHdpdGggc2NvcGUuDQoNCj4gY2hpcC0+
cmVzZXQgPSBkZXZtX2dwaW9kX2dldF9vcHRpb25hbChkZXYsICJyZXNldCIsIEdQSU9EX09VVF9M
T1cpOw0KPiBpZiAoSVNfRVJSKGNoaXAtPnJlc2V0KSkNCj4JZ290byBvdXQ7DQo+DQo+IGlmIChj
aGlwLT5yZXNldCkNCj4JdXNsZWVwX3JhbmdlKDEwMDAsIDIwMDApOw0KDQpTbyBpdCBzaG91bGQg
d2FpdCwgYnV0IGZvciB3aGF0Pw0KDQpJIHNlZSBhbiBvdGhlciBsaW5lcyBkb3duIGJlbGxvdw0K
PiBtdjg4ZTZ4eHhfcmVnX2xvY2soY2hpcCk7DQo+IGVyciA9IG12ODhlNnh4eF9zd2l0Y2hfcmVz
ZXQoY2hpcCk7DQo+IG12ODhlNnh4eF9yZWdfdW5sb2NrKGNoaXApOw0KDQpidXQgdGhleSBhcmUg
ZGVlcGVyIGFmdGVyIHRoZSAibXY4OGU2eHh4X2RldGVjdCIgd2hpY2ggZmFpbGVkLCBiZWNhdXNl
DQppdCBjYW4ndCBmaW5kIHRoZSBzd2l0Y2guDQo+IFszLjIyOTY1OV0gbXY4OGU2MDg1OiBwcm9i
ZSBvZiA1YjA0MDAwMC5ldGhlcm5ldC0xOjEwIGZhaWxlZCB3aXRoDQplcnJvciAtMTEwDQoNClNv
IEkgImhhcmQtY29kZWQiIHRoZSByZWFsIHJlc2V0IHRoZXJlOg0KPiBjaGlwLT5yZXNldCA9IGRl
dm1fZ3Bpb2RfZ2V0X29wdGlvbmFsKGRldiwgInJlc2V0IiwgR1BJT0RfT1VUX0xPVyk7DQo+IGlm
IChJU19FUlIoY2hpcC0+cmVzZXQpKQ0KPglnb3RvIG91dDsNCj4NCj4gaWYgKGNoaXAtPnJlc2V0
KSB7DQo+IAlncGlvZF9zZXRfdmFsdWVfY2Fuc2xlZXAoY2hpcC0+cmVzZXQsIDEpOw0KPiAJdXNs
ZWVwX3JhbmdlKDEwMDAwLCAyMDAwMCk7DQo+IAlncGlvZF9zZXRfdmFsdWVfY2Fuc2xlZXAoY2hp
cC0+cmVzZXQsIDApOw0KPiAJdXNsZWVwX3JhbmdlKDEwMDAwLCAyMDAwMCk7DQoNCmFuZCBzd2l0
Y2ggd2FzIGNvcnJlY3RseSBmb3VuZGVkOg0KPiBbwqDCoMKgIDQuMDIyMTc1XSBtdjg4ZTYwODUg
NWIwNDAwMDAuZXRoZXJuZXQtMToxMDogc3dpdGNoIDB4MzEwMA0KZGV0ZWN0ZWQ6IE1hcnZlbGwg
ODhFNjMyMSwgcmV2aXNpb24gMg0KPiBbwqDCoMKgIDQuMjEwODM0XSBtdjg4ZTYwODUgNWIwNDAw
MDAuZXRoZXJuZXQtMToxMDogY29uZmlndXJpbmcgZm9yDQpmaXhlZC8gbGluayBtb2RlDQo+IFvC
oMKgwqAgNC4yMTg1ODddIG12ODhlNjA4NSA1YjA0MDAwMC5ldGhlcm5ldC0xOjEwOiBMaW5rIGlz
IFVwIC0NCjFHYnBzL0Z1bGwgLSBmbG93IGNvbnRyb2wgb2ZmDQouLi4NCg0KU28gbXkgcXVlc3Rp
b24gaXMsIGhvdyB0aGUgcmVzZXQgcmVhbGx5IHdvcmtzLCBvciB0aGVyZSBpcyBzb21lIGtpbmQg
b2YNCnBvdGVudGlhbCBidWc/DQoNCk1hbnkgdGhhbmtzIGZvciB5b3VyIGV4cGxhbmF0aW9uLg0K
QW5kcmVqDQo=
