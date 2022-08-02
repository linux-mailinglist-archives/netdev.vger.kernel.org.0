Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FF8587BE8
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 14:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbiHBMDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 08:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiHBMDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 08:03:36 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEE313F2D
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 05:03:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ay8fb9MyauJV+QYrWIL3/7DikvFwoUAksHdOk0CSf28M4JBwMcorqeqx7bQsh7jCJ+Wb5V0yg4qLXe7Ug1ZQ2Jp/hNKxgFocSa1g1KzW1jTByXA7Biy4cBKnmAcJ7xzU4d9rX0rcuqjkA+AdwqSu0AiBEwseko7DYOrzU0K1lsnJxJSPQeZKE6rUb9+s6rYonClxuv9MXFbI2SoCRFFkkIWPa9ThhpGeQexxFWZKgYgIWIgt0hiHQbsKTFAyYoimr8r+gx/bb8zoW9rNsdBj14x4iZAJhRCSVcu+qz7hFTCLK4EqsFkA4xLMq8TQbhDqjgIbChBu47wdGXuR/Rr7iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r3AclcFDVOtIPmw0zDbZUc15loegIDvXDfRN7GL+qb0=;
 b=PfHLlE51lgM4alV+pXILWQJCtpITlPa3D+tBYPqmDL7j9gDkIiJuhq4wplFMQzvYjFfaEuebIyfvJlJ+TOUP2+WK06lawySZ/K9p5ojrESVQPGOH7xmeozB77HuIj9JhefUAflcZbxzARIU9NV/7ZoRX3msWDlUpYR1krJnHb5G28UKfx7G83TgiOoSQW0uQu5qboXPLRg7XfFCwyZrXRYnxKktH4AcJKWIrD3syH1fSsnGCNadCRZLij/E6toSCMx8+FeWmB9Db2IhD1xkzdLMTG8iqQCmfdL3Mufczc3s0HoTEgXN4dJA7f1hUUk6VaX+pM8C0u6FvyMD7r6HcJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3AclcFDVOtIPmw0zDbZUc15loegIDvXDfRN7GL+qb0=;
 b=n1EFBFaHqsZIlBUlt6tK30DjuTI0si5Xu+JR5E3R9r9UFaFHFKZl80HppTD1vG/2K7ekeW05sh+zPn5ImyGc8l6g+J146Ak5ssho1hyy+wcbOZbnoVRoipSmjLvzFUfROgVtsWZt1j5RDjVwlHkocX8xelsc4D97E1t0kY9SZ92zoRgZ0eFZd4pMqEyaN+r85wVFEoFD2keHLTP3wfDtN8f0QX9SWPaM/utsNrnKJIMAIh6uMw3ceA80lI0CNJM3FhYL+rrStdn/Y14ciNuJB4RAqMmVdkPjL82CLVzDG0TnKZTB+c0ahW0qBr4r4lB1aagmjVsHYt6uRc21QL8oTA==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by DM6PR12MB3258.namprd12.prod.outlook.com (2603:10b6:5:187::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Tue, 2 Aug
 2022 12:03:33 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548%9]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 12:03:33 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH net-next] net/tls: Use RCU API to access tls_ctx->netdev
Thread-Topic: [PATCH net-next] net/tls: Use RCU API to access tls_ctx->netdev
Thread-Index: AQHYpXzdw3PxP7W5AU+7nUMUJ/fFua2acr2AgAESDYA=
Date:   Tue, 2 Aug 2022 12:03:32 +0000
Message-ID: <380eb27278e581012524cdc16f99e1872cee9be0.camel@nvidia.com>
References: <20220801080053.21849-1-maximmi@nvidia.com>
         <20220801124239.067573de@kernel.org>
In-Reply-To: <20220801124239.067573de@kernel.org>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02fe54e7-9abd-4553-d01e-08da747f05a0
x-ms-traffictypediagnostic: DM6PR12MB3258:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LcieTmtl0D7MPdRtamiejusQy4lQYHd3pRYoZdQNqlgUcACW2kpW3Pet0DmyWhjki+kOEyQjTgoLvDSNoZ999uFkezYCCYqZATy9iWgR+tuDSMjdlZ2CNxO4mrlWP47+NQgBYr5n/slZFh5X6Qzk+zdpcReQwgJqhmZP8N1i0sh288N30NN7hdIHI8a0qao1Z/6cEQVyomeg/T/WioewMatPy5pr/gEekReAi5QYWpw7Dx6Zkd8F3gQkogiGysA37cr5rjwxHzQJ/3ybpNKVj+re88qn382IxYy+ct0+ItUIokmUqSbuorLCewZ9j5z1i/6nyYhnLW2spmIZokwL7SGEAlnecHqW5G0ag3JbMjoOJrIvvfGkxU8dPvVK0kPbMqB6e4k3EfQCJUxAbPlE+75+sjRvtq6H4oGPhKkOILxIS7jXpd7at3i85grbzJlYLp39ITrKpxGy0Oe+KqubCDxMUrByyvIYDk8txp41mfQOcuiLTUCpnaWm0XCOY1cRd3ip06EqnBEZvjfudpqJdynuahHKkHPVAAmSU/PNNNcIzpveo+Lr+ivQPRJiwUgBxDYSN/KiNhMyPKb6ItHmBjwQ/GT4HGmvofd6wpT528s61EBlJ01sGOLkEZw1nulj39XmR0v95L5GvY6UUHVumTLY1N5pcvEI0q5o5MTBb1azdK/iF/ybFkP6lX3bHBNCkydqrQh9VLAeeVX4jTUhqEmX0odQcnZ+fZDT+6PgEnrFurOC78e6lbD1c1Ff+wj9HqHr0RDMWEMHmY3RtlzCMiK3DPHrb23JAMX1B+kxfRt8IDWoigVfwI9SSxtjnfm4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(478600001)(83380400001)(36756003)(316002)(186003)(6486002)(41300700001)(6916009)(54906003)(2906002)(107886003)(8936002)(66946007)(2616005)(91956017)(86362001)(64756008)(66446008)(66476007)(66556008)(71200400001)(4326008)(8676002)(6512007)(5660300002)(76116006)(6506007)(38070700005)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckhRK0N3YWRUZGtVcUROc3VmNHdCWVg0aDY2Ly9EVVNkK0pTTHdjNjRoajBL?=
 =?utf-8?B?dnIrYXh2MFprcS9QUzE2RGZlRnJSVnh3em90Ylo3T2hoQ1V3NVh4a012OVpI?=
 =?utf-8?B?dEVSZUd1M2p6K29Oemo5eEZUbjFFbzQ2N20zUEd5eGNwcTVhQU9nRFl6S2FK?=
 =?utf-8?B?dmlTcmFvV0t5RDEyR2xyVUdFZlBCdnhGbTRQMG1zMzF3MS9ON1djcitKU2ZW?=
 =?utf-8?B?VFlISnVsOEwxMVN1MUNic3NUNWdwZXZEZGsxUHpBYVk0dzA3TnlGY0VaVlpj?=
 =?utf-8?B?dGlXQ1VHa05lOU5FdEk5WDQvS2pUdisrTUlRK3BZeTVYYzFSTENyS2llcmUx?=
 =?utf-8?B?Y2l3dzA0VHR4TVpMcWNSK2prYnc3R2RjSzBMS3dlOHRWTTZKdEZLZU9GZGRQ?=
 =?utf-8?B?cnZ5NzBwbEYwODRTeG1VUVV5VGFzMkU4NWRNUVJuUlVudlZsV0djVXR0UjdS?=
 =?utf-8?B?UHdja2Jjc3ZheUtVbzcyZ01vbkwwR0gxY0kxTFM4aUtpUmhSTWJpc2ZkUnNh?=
 =?utf-8?B?cGgyczZnZzkzRnFQTHl5aWp0TCtMNlhya0Vpa2xsUEhFKzNiWTRDak5aN2px?=
 =?utf-8?B?MGFmVm5YNGhSRXhTVzNIV25YemhrL2pYMkEvUkNuNE85ZytXQkUvWGxLbmp6?=
 =?utf-8?B?eUw1QVFkb0tWUnFPVkV2dFNwZ1B6ZE5VUStjd2tFZWtEOUN5N0JPMFFBMzQx?=
 =?utf-8?B?NTA1R2g1NFJZazVLampjZ2tUakVWV0ZkZEJKdXlmakc3Rk9vNXpmVWVpaHJu?=
 =?utf-8?B?bnhtQmFXdDByTS9EdEdJY1ZkS2hLcHI1emREU3Q2dmFmd09GMytXWDlaN0Y3?=
 =?utf-8?B?c2dDWGRJckJaczBQU2JXenQ0dzAzR05nbmdDZ3dJZDBoYzlnTVo2c0VtaHM1?=
 =?utf-8?B?b052ajRUMDBrV0dvVS82VThBN0RMeHAzSnlNb0ZFRnRTUFZQbVl0bFpmQUQ2?=
 =?utf-8?B?TEtPNHR4bTlRR3lqb1JnSHcwNGNweWVQRUdneWRWV2pQU1ZvU3pYdTNaMjVC?=
 =?utf-8?B?Ymd1azBwZWdmeEE2dUVTZmRxdlY0UG1OM0VMRnJ2ZFZ5YWZOVlhUd3IrS3Fo?=
 =?utf-8?B?czgzM2QxekI5eXpyUjdkc1c2aWdwL1lOQnNjcUpLSUYrcFB5SmVuUjF2cVlq?=
 =?utf-8?B?T2paSzNGam1QeFJxTnJYbEduZXMyQVV1THhLNXE3TXNoNnJ5TUwvblhycVNM?=
 =?utf-8?B?S0VoYVZNRDk3MGV2aks2Y0pyQUxvWXdvKzUyRE5RY3dXQVVUK1paNHFHOWNC?=
 =?utf-8?B?WVljZmpmSmVVV0p2Ky9NcjJLYlZHelVtZ1lUT2U3SHpiYzM2bFljaWJvQ0NW?=
 =?utf-8?B?RHRDQTFtZElBdHBxT0d1Z05LaU95TFh3YTF0WUF4TTE1N3R1c2t6NWNVZjBo?=
 =?utf-8?B?S0I3bmF4ZFZaNW9pVE0yU1VNT1haU0s3amV0QUhiYktJbXM0REprbU9YSW11?=
 =?utf-8?B?bndPWjJKcURtanVyR3pPeVBUQ2RhNFM4K3ZxYWg5U0NGUEFKa0JiTjhzaGRv?=
 =?utf-8?B?Y0MzZ2VmN3pFN1haNWtCdUlKSmdQeGJaeHFHZEJleHZsTlVTdWliMFgvcm1N?=
 =?utf-8?B?a2x0WmZEWjhaTGIwTHFJVkZtMlB5cElBTVB6L0YzUGdiaUtkcHlET3libW9R?=
 =?utf-8?B?eVp2S2owY0RBNDg0S0UrWDJMeno3OWxqZnp4aGNOSEVhcC9VS0s3dFZ0V0Fq?=
 =?utf-8?B?NlhBcWFkZDByeiszMXkzUWxnTUtsOHZmTHFRMVJ2aDdvejdtNU9TcWNOd1dn?=
 =?utf-8?B?MURPYXBKQ0E2VTBiSVFRTkFGTXR1c0dBZ0xEaDRjTmowSUlWcmV6a2hOWkpN?=
 =?utf-8?B?WXZkT2VKN2krTzRjSjNteTlpZXdDdTc0VXYvZCtTajlObjluNFhnb2tKMi8x?=
 =?utf-8?B?bGRZWUY5SU1GSXU1TklpbERKR1VWcWJZMExoL2F3ZEd2cEtwT0ttVXY1cGxi?=
 =?utf-8?B?VUhDSTlmSEJRYVZsL2ZybDd4SmV0REpOdDV4d3pwazJscmJHYlBQYy9IZzN3?=
 =?utf-8?B?cDVTM1dFVnBhYXcyNzBSQkdMS0FNRk5qQ1RGTStsS3FMdnErT1FITW92RkV4?=
 =?utf-8?B?Qm1yU3ZyVGp2MWNzTmd1clJNNjhLbllEWG81cUtRSUZ5dXArSGRzWEdwM3VC?=
 =?utf-8?B?VUpOM0tWc25TWVE2T2FocmxGZmhZeDZvNE5Yd2xCb3F3SmwwM1hXZUN0RUR1?=
 =?utf-8?B?b3dpNkdCRXd0NVVtdmR4Ukpad1ZpeCtqUGVWZWxjZjY4NkdzaDczK3k4akRo?=
 =?utf-8?B?TVpkc0tYV2ZVTnRmSUNTMkhRTERnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD1FEE1C1AE1D142A5B1A99FACC4B801@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02fe54e7-9abd-4553-d01e-08da747f05a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 12:03:33.0127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RJynuIhKGXbL/ASExsSV6jpzCpStt6D8ySMAwkVT3S9UtbWDNeiWOG6BZOXoXYHaJl1iaPXVRPXw5bW6ejPGVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3258
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTA4LTAxIGF0IDEyOjQyIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAxIEF1ZyAyMDIyIDExOjAwOjUzICswMzAwIE1heGltIE1pa2l0eWFuc2tpeSB3
cm90ZToNCj4gPiBAQCAtMTMyOSw3ICsxMzQ1LDExIEBAIHN0YXRpYyBpbnQgdGxzX2RldmljZV9k
b3duKHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYpDQo+ID4gIA0KPiA+ICAJc3Bpbl9sb2NrX2ly
cXNhdmUoJnRsc19kZXZpY2VfbG9jaywgZmxhZ3MpOw0KPiA+ICAJbGlzdF9mb3JfZWFjaF9lbnRy
eV9zYWZlKGN0eCwgdG1wLCAmdGxzX2RldmljZV9saXN0LCBsaXN0KSB7DQo+ID4gLQkJaWYgKGN0
eC0+bmV0ZGV2ICE9IG5ldGRldiB8fA0KPiA+ICsJCXN0cnVjdCBuZXRfZGV2aWNlICpjdHhfbmV0
ZGV2ID0NCj4gPiArCQkJcmN1X2RlcmVmZXJlbmNlX3Byb3RlY3RlZChjdHgtPm5ldGRldiwNCj4g
PiArCQkJCQkJICBsb2NrZGVwX2lzX2hlbGQoJmRldmljZV9vZmZsb2FkX2xvY2spKTsNCj4gPiAr
DQo+ID4gKwkJaWYgKGN0eF9uZXRkZXYgIT0gbmV0ZGV2IHx8DQo+ID4gIAkJICAgICFyZWZjb3Vu
dF9pbmNfbm90X3plcm8oJmN0eC0+cmVmY291bnQpKQ0KPiA+ICAJCQljb250aW51ZTsNCj4gDQo+
IEZvciBjYXNlcyBsaWtlIHRoaXMgd2hlcmUgd2UgZG9uJ3QgYWN0dWFsbHkgaG9sZCBvbnRvIHRo
ZSBvYmplY3QsIGp1c3QNCj4gdGFrZSBhIHBlZWsgYXQgdGhlIGFkZHJlc3Mgb2YgaXQgd2UgY2Fu
IHNhdmUgYSBoYW5kZnVsIG9mIExvQyBieSB1c2luZw0KPiByY3VfYWNjZXNzX3BvaW50ZXIoKS4g
DQoNClRoZSBkb2N1bWVudGF0aW9uIG9mIHJjdV9hY2Nlc3NfcG9pbnRlciBzYXlzIGl0IHNob3Vs
ZG4ndCBiZSB1c2VkIG9uDQp0aGUgdXBkYXRlIHNpZGUsIGJlY2F1c2Ugd2UgbG9zZSBsb2NrZGVw
IHByb3RlY3Rpb246DQoNCi0tY3V0LS0NCg0KQWx0aG91Z2ggcmN1X2FjY2Vzc19wb2ludGVyKCkg
bWF5IGFsc28gYmUgdXNlZCBpbiBjYXNlcw0Kd2hlcmUgdXBkYXRlLXNpZGUgbG9ja3MgcHJldmVu
dCB0aGUgdmFsdWUgb2YgdGhlIHBvaW50ZXIgZnJvbSBjaGFuZ2luZywNCnlvdSBzaG91bGQgaW5z
dGVhZCB1c2UgcmN1X2RlcmVmZXJlbmNlX3Byb3RlY3RlZCgpIGZvciB0aGlzIHVzZSBjYXNlLg0K
DQotLWN1dC0tDQoNClRob3VnaCwgSSBjYW4gY2hhbmdlIHRoZSByZWFkIHNpZGUgdG8gdXNlIHJj
dV9hY2Nlc3NfcG9pbnRlciwgd2hlcmV2ZXINCnRoZSBwb2ludGVyIGlzIG5vdCBkZXJlZmVyZW5j
ZWQuIEJ1dCBpdCB3b24ndCBzYXZlIGxpbmVzIG9mIGNvZGUgOikNCg==
