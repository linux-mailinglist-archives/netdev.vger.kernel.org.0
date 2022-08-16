Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4428A595313
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiHPGxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiHPGxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:53:12 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39F6C28;
        Mon, 15 Aug 2022 19:07:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XG7HtKQcziubq22yw+q6Fb+g6zspl4ITn/uLpGquUKSSkKpHR8ZVfHBn/VCxmqEDk+dB4i+f3hU6Rrp/E7c6m33lMWXIkqr1yORg/MnBg3iz2JYMN40kJV4BKQcJM7OyyLfDiUgUD7mc8C8BFVd2tL2iEXj+egClOvpzaeEz8kiWMQ5fwEuF5/UJqJWZF9fS9h+/3H2RtESDLDIa9PSzyoFBTZIJ/JzIOPQRNl+NM/ujpE0JZ7yGZt5MML9p1vRqyuC2BoA4wrOOUmPSyNB65u1yXukKJyRdAsdEoYRq4h6PLnxI6OOKOF6be47WgIAN5V/ourTPWOX/L5cqeKemFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uu1/qDV3egnFfWr3+bo8TYZ3P/AesTpUFgwt9Js5enM=;
 b=Nt/T/r9Vj2y5rHTJQ147uCUe1fsJx5SHjijjKpr113uyPTViyJIDqWoFYBFPP7zL+mNWVTh/BqqxobSGCwk8mOrQRv8Vt2qI7Aj506oWgSIXYNS7dwVnzEyCLR2WvC9yb45yc9opihDBsrNNAcGIOm/PTR3tRVw9RWS0C74KAhUP+8c6Msio0n8CmiXbgMVAb2Vi5fO/Bjpy823DiB5qwKwdCGu7vWT/QX77APsN3NX1mOSI2fi/vTIo4s9PG8ysnAvUvjJ0GMTLnLKEYlDnRRlCbMuh6KOhBpphu0GcjmzzobCGbecKhzvYtxmdp8FO1LFiLJ1aH0sOKSg19HkyNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uu1/qDV3egnFfWr3+bo8TYZ3P/AesTpUFgwt9Js5enM=;
 b=M4161Mr0SKsll8xIkVj1gSWzAr7yw6K+7cE1UHXOQYKE6kBgkfCVD9HuH2VAv9XxsrxKzWuk28nHFKJwDQLF/fHKH2nRboF0sh04KpGSY4pjB9WNm0Gu0nZbSAqIj/FmKWEsBPLVCI6YVU1VJqADyama6+cRWTV/P50duvAWTtCS6W6z8kHX9s63UtiX1V0rcgrqeeMQ3X0wBzirlnxqWaiFjD9So9+EYZC8nTQLMuX22TOIEOJtck9MEJKNn/piSbfSvIn04u1B84+cCmaDjh5oVq964iBvqDTZ3HL8pTKj6nSGDYO8C2ugdygN38/kar0AjPDcya7LBiDLlSp3/g==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BN8PR12MB3075.namprd12.prod.outlook.com (2603:10b6:408:67::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 16 Aug
 2022 02:07:42 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e%6]) with mapi id 15.20.5504.028; Tue, 16 Aug 2022
 02:07:42 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH 1/2] vDPA: allow userspace to query features of a vDPA
 device
Thread-Topic: [PATCH 1/2] vDPA: allow userspace to query features of a vDPA
 device
Thread-Index: AQHYsIpIliMOnnfYsEiEnQkZkiGZ8K2wRQEAgAB+qICAAAQOUA==
Date:   Tue, 16 Aug 2022 02:07:42 +0000
Message-ID: <PH0PR12MB5481EC56E9951B99B98A6668DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-2-lingshan.zhu@intel.com>
 <15a9ba60-f6f5-f73a-8923-0d0513ea7d62@oracle.com>
 <cea494d0-d446-274f-f913-723822a53e6a@intel.com>
In-Reply-To: <cea494d0-d446-274f-f913-723822a53e6a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d41c0740-3281-4b60-17e2-08da7f2c1a4b
x-ms-traffictypediagnostic: BN8PR12MB3075:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HhtTEtFoNuglGjR3l0zru8x8FU+3UU8DOLw241ygpdCnczO/Pu+/P1jO10XwjVqBxZo+EUfG46uUGD5LvCGU/mb0cR+DbYFDFcIlhx4r51Ju7pFBB4B4egFSDoN/kY9sCAhfVbDqME2RhsiKlbgVrv77jhG4Dfs89mgmeu0TYCgCDXxPgkyHL8Tg+34RrlUx346YkGybX+yyzIkL4KghTzSf9jbXoF2bsqmdIPSqr5Y9gnJnn0nJgGfOQ0+p9reUn50pPIsKUJwXSWEEpW8xV6+pwvx3ecqwRYztYGz3kpardUztefpzcJvA4w7J+NiPY41H4i64S1MF1u7QZqXIs9USgjGV52mHPDqA5YEQI1hEl6tGnsNDUY3XWOXMBR+etnxgIHjdGunk2w4eprQd8fNh+uqMBmduLkYCzoocS+ki5pTey6W76a89X+Gf19MZQhjK+hpNWTN4w8RqSL1Zk3/dXM8UzmVfROukApMwjw7yPp+XQlhKYy1+1OongXAvWcnE9YlzD9R1hz9m5S0hraJGDRallFW5PoX2/OEZfI2jugWif9onuzvmOac6ytp9LjvDWtiFjd18H7frChDF3nL+lIkhp6INHMpjwfwp+Plq6YER5m7ZgI/v0PRlxGvONKlMU1JD0q/V0ir6D/CnJifkVduWGwtDexS4hJwE+k0EAg/nk0D4LP5h/3a9vsAsk2IENzbDjPIlk0F5woour2BaSGxmrTHtnE6xZq4eN96CL4U0KRoFuEvQyDfZYVbzV8VNQoGFWPb6pPsnRxt41/X0Y/fSENBMrXQYKdAj9YmN+6p2tk5VLtv248uCAVJI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(316002)(122000001)(110136005)(54906003)(76116006)(66556008)(66476007)(66446008)(4326008)(8676002)(66946007)(38100700002)(55016003)(53546011)(26005)(64756008)(83380400001)(9686003)(7696005)(6506007)(186003)(33656002)(71200400001)(41300700001)(478600001)(5660300002)(38070700005)(8936002)(52536014)(86362001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZzdUNnk1Ri9EM1lacTVOQ1FTZUtHUXBiRmRlTDZaZUUzak9aek5GMkZPL0w5?=
 =?utf-8?B?UHA5cUVWL2J6YnRvcjZlWWE3M2ZYVjFpZEJKU1ExVHlJUDduM0lwK3FBcDRS?=
 =?utf-8?B?V2grTWRiZWxnK2xMYUw3M0ZpSm5IV3ovTytVcmhMSnQvRnc4U0RsQ2V5d0NC?=
 =?utf-8?B?UTJtWTVHWDU5dlhUMkVJTEFNSkZmZTNSRHZjZjMrT25QSUZURlAwNlVISjJR?=
 =?utf-8?B?SXlKR3dHT3R0aHI3WDFBdFYxakNFMldiYjFYV29USjZQT3hhV3VWb2t5aEUz?=
 =?utf-8?B?VGRTTTQzZFlpb0lJUWZrYUZ5TXFVNUpOVXkxZHVkNGZZQVVuY3A1NzJOa0Nx?=
 =?utf-8?B?cG9RdEpkWU8rajBmQWhuWkhUSFpYR3dXUVczTDVNbnIrTmNlNE1RU2VlUTJE?=
 =?utf-8?B?R3VyR3NjY0lOS1BjRnZPQkJmYmpHVmZMY0lsZ2hiQXFqbktodG54ajhzbHNK?=
 =?utf-8?B?aktGRlNWQ09qVEhDa25wOFVsTGkxaDZsVVZXMDI1Mm0waDIrVEFNT3dPUHJJ?=
 =?utf-8?B?UVZjUDBzRllUczlSWjNnbmZUc0dTV3lLeHgyMXhhaytYZjdQTWczRXRmOXdG?=
 =?utf-8?B?cXc5dExPWTRHS2tNZzBLREFqak05NDRBblVMbk83enJaRWJQclVUTGFMTDgy?=
 =?utf-8?B?VGt6Qi9DMER0dW9aVHpjV0RkWWdpSXg1dURHcGszY0p6V0xOYjA3MW1QS2tY?=
 =?utf-8?B?dis4eTljalBiNCtNS3pWWjIwUHJ4cjFxNnVuQTd5MXdhOVFiNlJNYU41djlR?=
 =?utf-8?B?aVdJU3dQS2VHSFJLWkFDcXloUXZPZGtBVlloN0RybittOUxpdUptbmVCeUNJ?=
 =?utf-8?B?Kzlrc0VXbDhKUGVvaUg5UU91SUNFa0w2Y3BoaTZrb3NabEcxYnFPcDdVMUJl?=
 =?utf-8?B?NENCZWNDZFpqbUxYL0p3ak1jRktXMXRadEJZTy9GK0lmc3ZpZ1RnZDRWQlc1?=
 =?utf-8?B?anpLRU5DalZXaldZQ09IS3RURE1hNmZ4c0wrelZ0OTNTa3ZaTFI5VnNkeG41?=
 =?utf-8?B?SkZlT3dBK2Nvck44bUpsL3JuQ0plY0lCYXdpZXV3cFFjM2lCRjZWMXdSYjQr?=
 =?utf-8?B?OTlReFZPRnp6OVVMbFByYnZwZGxybDRvSk9zRWplWnJlVmhic2FvTmZhTHlZ?=
 =?utf-8?B?SzdLeE5hZnRSUi95RVBXc3ZoaXRwLzVHTmZYeXRLSWNYUVZlMUJ2RG5uejg0?=
 =?utf-8?B?SXkwbnRIR2RyLzArbzBtdytxZE9IbWYya0ZzVit5M1JxaG9kQTdxVlZIT1Z1?=
 =?utf-8?B?M3RrWjJkUGkwN2JwOUNZeTdNaXJnT1VsTVNPU1d1MXhuRWFxdnZueXV0aFM2?=
 =?utf-8?B?OFJmS0FWakVETi94c1N1M0NQdWZ3R05VRlJjd2w4YlRjaUJ6TkFXaVhUNTE3?=
 =?utf-8?B?Y0J0bzcyQmk4WENvNGxsOVU1cnB4U1kyM2FXMkJqcm9mN3ZiWEVncjgyNlA3?=
 =?utf-8?B?SnEzRHBsOGpPRGVNK0QrOXZONU00RjlYb00yOTFpcEh2ZDBWS3dCWFpVOHJI?=
 =?utf-8?B?Z1h6dlV3YkN3ZjFMUVdnZG1CQllsSlliU0dZclRBV1QwY2VUM2pTeUlxYVkr?=
 =?utf-8?B?LzJRVnZDSTRHU2haQkI0cGJDcGR1WmhiQVFEOVQxUFE1bzU5Sk1lR2hLeFBv?=
 =?utf-8?B?UDFZUG1PUDFtVGoya1hVUnlCQ0hwUE95MXNFZ1p4WEtuTjBGZVd5cGoySmhl?=
 =?utf-8?B?VnZaN3E3TjlxTXNOa1RwekFKQkFRMDZsZmY5azFUT3JTTUI3aSt0RWlrQmtt?=
 =?utf-8?B?SWt0eXFmZjF5RGFmRjJzSUo0VHlISWZxWHd5bmJ2MVZKYktQUTVZdVcwQUhX?=
 =?utf-8?B?ME12eUVEcFF5Tlh6akVjZG5YSUN6SzlObTVnbVN6MnN2dVdITnFOWTY3Wjgw?=
 =?utf-8?B?MzUrVG9EL2E0aFdqc2Z6UC9EMmhsNm00NFpMTjZvVTZKVnR6cEFSQVpWVGtK?=
 =?utf-8?B?N3kvZTdObkF6d2ZYdjJQbGxQVWtrOStoamxBNk52TE0xV2QwMElIU3BiVGdU?=
 =?utf-8?B?QjdFUDdFTk1TOFY0blR0ZllLVFBZYjFiMGNndVAwRGFmSXRQSk5WL3dVbGJL?=
 =?utf-8?B?bWIyWXo4ZG5hcEZZOFZaTG9NaGQrVjZucUtnY0xvR0I4UnlwbGZiM3QrVXZF?=
 =?utf-8?Q?baSY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d41c0740-3281-4b60-17e2-08da7f2c1a4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2022 02:07:42.2608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QJQ1RVsmhx6BDeedL+KFGGodAuc7J0o93ZOyfvkkuzdDs9pg0mdVk4NJAbp84rq/5nnMMF0nxmq7ucaeuUY7ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3075
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFpodSwgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+IFNlbnQ6
IE1vbmRheSwgQXVndXN0IDE1LCAyMDIyIDk6NDkgUE0NCj4gDQo+IE9uIDgvMTYvMjAyMiAyOjE1
IEFNLCBTaS1XZWkgTGl1IHdyb3RlOg0KPiA+DQo+ID4NCj4gPiBPbiA4LzE1LzIwMjIgMjoyNiBB
TSwgWmh1IExpbmdzaGFuIHdyb3RlOg0KPiA+PiBUaGlzIGNvbW1pdCBhZGRzIGEgbmV3IHZEUEEg
bmV0bGluayBhdHRyaWJ1dGlvbg0KPiA+PiBWRFBBX0FUVFJfVkRQQV9ERVZfU1VQUE9SVEVEX0ZF
QVRVUkVTLiBVc2Vyc3BhY2UgY2FuIHF1ZXJ5DQo+IGZlYXR1cmVzDQo+ID4+IG9mIHZEUEEgZGV2
aWNlcyB0aHJvdWdoIHRoaXMgbmV3IGF0dHIuDQo+ID4+DQo+ID4+IFNpZ25lZC1vZmYtYnk6IFpo
dSBMaW5nc2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNvbT4NCj4gPj4gLS0tDQo+ID4+IMKgIGRy
aXZlcnMvdmRwYS92ZHBhLmPCoMKgwqDCoMKgwqAgfCAxNyArKysrKysrKysrKysrLS0tLQ0KPiA+
PiDCoCBpbmNsdWRlL3VhcGkvbGludXgvdmRwYS5oIHzCoCAzICsrKw0KPiA+PiDCoCAyIGZpbGVz
IGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+ID4+DQo+ID4+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3ZkcGEvdmRwYS5jIGIvZHJpdmVycy92ZHBhL3ZkcGEuYyBpbmRl
eA0KPiA+PiBjMDZjMDI3MDQ0NjEuLmVmYjU1YTA2ZTk2MSAxMDA2NDQNCj4gPj4gLS0tIGEvZHJp
dmVycy92ZHBhL3ZkcGEuYw0KPiA+PiArKysgYi9kcml2ZXJzL3ZkcGEvdmRwYS5jDQo+ID4+IEBA
IC00OTEsNiArNDkxLDggQEAgc3RhdGljIGludCB2ZHBhX21nbXRkZXZfZmlsbChjb25zdCBzdHJ1
Y3QNCj4gPj4gdmRwYV9tZ210X2RldiAqbWRldiwgc3RydWN0IHNrX2J1ZmYgKm0NCj4gPj4gwqDC
oMKgwqDCoMKgwqDCoMKgIGVyciA9IC1FTVNHU0laRTsNCj4gPj4gwqDCoMKgwqDCoMKgwqDCoMKg
IGdvdG8gbXNnX2VycjsNCj4gPj4gwqDCoMKgwqDCoCB9DQo+ID4+ICsNCj4gPj4gK8KgwqDCoCAv
KiByZXBvcnQgZmVhdHVyZXMgb2YgYSB2RFBBIG1hbmFnZW1lbnQgZGV2aWNlIHRocm91Z2gNCj4g
Pj4gVkRQQV9BVFRSX0RFVl9TVVBQT1JURURfRkVBVFVSRVMgKi8NCj4gPj4gwqDCoMKgwqDCoCBp
ZiAobmxhX3B1dF91NjRfNjRiaXQobXNnLCBWRFBBX0FUVFJfREVWX1NVUFBPUlRFRF9GRUFUVVJF
UywNCj4gPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWRldi0+c3Vw
cG9ydGVkX2ZlYXR1cmVzLCBWRFBBX0FUVFJfUEFEKSkgew0KPiA+PiDCoMKgwqDCoMKgwqDCoMKg
wqAgZXJyID0gLUVNU0dTSVpFOw0KPiA+PiBAQCAtODE1LDcgKzgxNyw3IEBAIHN0YXRpYyBpbnQg
dmRwYV9kZXZfbmV0X21xX2NvbmZpZ19maWxsKHN0cnVjdA0KPiA+PiB2ZHBhX2RldmljZSAqdmRl
diwNCj4gPj4gwqAgc3RhdGljIGludCB2ZHBhX2Rldl9uZXRfY29uZmlnX2ZpbGwoc3RydWN0IHZk
cGFfZGV2aWNlICp2ZGV2LA0KPiA+PiBzdHJ1Y3Qgc2tfYnVmZiAqbXNnKQ0KPiA+PiDCoCB7DQo+
ID4+IMKgwqDCoMKgwqAgc3RydWN0IHZpcnRpb19uZXRfY29uZmlnIGNvbmZpZyA9IHt9Ow0KPiA+
PiAtwqDCoMKgIHU2NCBmZWF0dXJlczsNCj4gPj4gK8KgwqDCoCB1NjQgZmVhdHVyZXNfZGV2aWNl
LCBmZWF0dXJlc19kcml2ZXI7DQo+ID4+IMKgwqDCoMKgwqAgdTE2IHZhbF91MTY7DQo+ID4+IMKg
IMKgwqDCoMKgwqAgdmRwYV9nZXRfY29uZmlnX3VubG9ja2VkKHZkZXYsIDAsICZjb25maWcsIHNp
emVvZihjb25maWcpKTsNCj4gPj4gQEAgLTgzMiwxMiArODM0LDE5IEBAIHN0YXRpYyBpbnQgdmRw
YV9kZXZfbmV0X2NvbmZpZ19maWxsKHN0cnVjdA0KPiA+PiB2ZHBhX2RldmljZSAqdmRldiwgc3Ry
dWN0IHNrX2J1ZmYgKm1zDQo+ID4+IMKgwqDCoMKgwqAgaWYgKG5sYV9wdXRfdTE2KG1zZywgVkRQ
QV9BVFRSX0RFVl9ORVRfQ0ZHX01UVSwgdmFsX3UxNikpDQo+ID4+IMKgwqDCoMKgwqDCoMKgwqDC
oCByZXR1cm4gLUVNU0dTSVpFOw0KPiA+PiDCoCAtwqDCoMKgIGZlYXR1cmVzID0gdmRldi0+Y29u
ZmlnLT5nZXRfZHJpdmVyX2ZlYXR1cmVzKHZkZXYpOw0KPiA+PiAtwqDCoMKgIGlmIChubGFfcHV0
X3U2NF82NGJpdChtc2csDQo+IFZEUEFfQVRUUl9ERVZfTkVHT1RJQVRFRF9GRUFUVVJFUywNCj4g
Pj4gZmVhdHVyZXMsDQo+ID4+ICvCoMKgwqAgZmVhdHVyZXNfZHJpdmVyID0gdmRldi0+Y29uZmln
LT5nZXRfZHJpdmVyX2ZlYXR1cmVzKHZkZXYpOw0KPiA+PiArwqDCoMKgIGlmIChubGFfcHV0X3U2
NF82NGJpdChtc2csDQo+IFZEUEFfQVRUUl9ERVZfTkVHT1RJQVRFRF9GRUFUVVJFUywNCj4gPj4g
ZmVhdHVyZXNfZHJpdmVyLA0KPiA+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBWRFBBX0FUVFJfUEFEKSkNCj4gPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiAtRU1TR1NJWkU7
DQo+ID4+ICsNCj4gPj4gK8KgwqDCoCBmZWF0dXJlc19kZXZpY2UgPSB2ZGV2LT5jb25maWctPmdl
dF9kZXZpY2VfZmVhdHVyZXModmRldik7DQo+ID4+ICsNCj4gPj4gK8KgwqDCoCAvKiByZXBvcnQg
ZmVhdHVyZXMgb2YgYSB2RFBBIGRldmljZSB0aHJvdWdoDQo+ID4+IFZEUEFfQVRUUl9WRFBBX0RF
Vl9TVVBQT1JURURfRkVBVFVSRVMgKi8NCj4gPj4gK8KgwqDCoCBpZiAobmxhX3B1dF91NjRfNjRi
aXQobXNnLA0KPiA+PiBWRFBBX0FUVFJfVkRQQV9ERVZfU1VQUE9SVEVEX0ZFQVRVUkVTLCBmZWF0
dXJlc19kZXZpY2UsDQo+ID4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IFZEUEFfQVRUUl9QQUQpKQ0KPiA+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FTVNHU0la
RTsNCj4gPj4gwqAgLcKgwqDCoCByZXR1cm4gdmRwYV9kZXZfbmV0X21xX2NvbmZpZ19maWxsKHZk
ZXYsIG1zZywgZmVhdHVyZXMsDQo+ID4+ICZjb25maWcpOw0KPiA+PiArwqDCoMKgIHJldHVybiB2
ZHBhX2Rldl9uZXRfbXFfY29uZmlnX2ZpbGwodmRldiwgbXNnLCBmZWF0dXJlc19kcml2ZXIsDQo+
ID4+ICZjb25maWcpOw0KPiA+PiDCoCB9DQo+ID4+IMKgIMKgIHN0YXRpYyBpbnQNCj4gPj4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC92ZHBhLmggYi9pbmNsdWRlL3VhcGkvbGludXgv
dmRwYS5oDQo+ID4+IGluZGV4IDI1YzU1Y2FiM2Q3Yy4uZDE3MWI5MmVmNTIyIDEwMDY0NA0KPiA+
PiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvdmRwYS5oDQo+ID4+ICsrKyBiL2luY2x1ZGUvdWFw
aS9saW51eC92ZHBhLmgNCj4gPj4gQEAgLTQ2LDcgKzQ2LDEwIEBAIGVudW0gdmRwYV9hdHRyIHsN
Cj4gPj4gwqAgwqDCoMKgwqDCoCBWRFBBX0FUVFJfREVWX05FR09USUFURURfRkVBVFVSRVMswqDC
oMKgIC8qIHU2NCAqLw0KPiA+PiDCoMKgwqDCoMKgIFZEUEFfQVRUUl9ERVZfTUdNVERFVl9NQVhf
VlFTLMKgwqDCoMKgwqDCoMKgIC8qIHUzMiAqLw0KPiA+PiArwqDCoMKgIC8qIGZlYXR1cmVzIG9m
IGEgdkRQQSBtYW5hZ2VtZW50IGRldmljZSAqLw0KU2F5IGNvbW1lbnQgYXMuDQogICAgICAvKiBG
ZWF0dXJlcyBvZiB0aGUgdkRQQSBtYW5hZ2VtZW50IGRldmljZSBtYXRjaGluZyB0aGUgdmlydGlv
IGZlYXR1cmUgYml0cyAwIHRvIDYzIHdoZW4gcXVlcmllZCBvbiB0aGUgbWdtdC4gZGV2aWNlLg0K
ICAgICAgICAqICBXaGVuIHJldHVybmVkIG9uIHRoZSB2ZHBhIGRldmljZSwgaXQgaW5kaWNhdGVz
IHZpcnRpbyBmZWF0dXJlIGJpdHMgMCB0byA2MyBvZiB0aGUgdmRwYSBkZXZpY2UgDQogICAgICAg
ICovDQoNCj4gPj4gwqDCoMKgwqDCoCBWRFBBX0FUVFJfREVWX1NVUFBPUlRFRF9GRUFUVVJFUyzC
oMKgwqAgLyogdTY0ICovDQo+ID4+ICvCoMKgwqAgLyogZmVhdHVyZXMgb2YgYSB2RFBBIGRldmlj
ZSwgZS5nLiwgL2Rldi92aG9zdC12ZHBhMCAqLw0KPiA+PiArwqDCoMKgIFZEUEFfQVRUUl9WRFBB
X0RFVl9TVVBQT1JURURfRkVBVFVSRVMswqDCoMKgIC8qIHU2NCAqLw0KPiA+IEFwcGVuZCB0byB0
aGUgZW5kLCBwbGVhc2UuIE90aGVyd2lzZSBpdCBicmVha3MgdXNlcnNwYWNlIEFCSS4NCj4gT0ss
IHdpbGwgZml4IGl0IGluIFYyDQoNCkkgaGF2ZSByZWFkIFNlLVdlaSBjb21tZW50IGluIHRoZSB2
NC4NCkhvd2V2ZXIgSSBkaXNhZ3JlZSwgd2UgZG9u4oCZdCBuZWVkIHRvIGNvbnRpbnVlIHRoZSBw
YXN0IG1pc3Rha2UgZG9uZSB3aXRoIHRoZSBuYW1pbmcuDQoNClBsZWFzZSBhZGQgYSBjb21tZW50
IHRoYXQgVkRQQV9BVFRSX0RFVl9TVVBQT1JURURfRkVBVFVSRVMgbGlrZSBhYm92ZSBhYm91dCB0
aGUgZXhjZXB0aW9uLg0KV2UgZXN0YWJsaXNoZWQgdGhhdCB0aGVyZSBpcyBubyByYWNlIGNvbmRp
dGlvbiBlaXRoZXIuDQpTbyBubyBuZWVkIHRvIGFkZCBuZXcgVUFQSSBmb3Igc29tZSBwYXN0IGhp
c3RvcnkuDQo=
