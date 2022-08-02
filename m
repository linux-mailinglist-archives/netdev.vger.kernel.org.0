Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B510E587BF6
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 14:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236735AbiHBMHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 08:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbiHBMHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 08:07:21 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4969832ED6
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 05:07:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQWfkin6BasWBrSCENXZ315O4Qo/CgNxBYerXxsul6D/k/FooPHZMguGBxw691n5OIVn4RqP7el01VoJKbs7O/eBfNUml1dOgN9X5P9fri2bQmgod6CrbG3lFzDop2yUWlmcgDGC3KjYFhBWaQavP/t1aijGCuNEMu4IEC/8PbMRhQQyxtmgGJxha18vK0kOsqi/Xe5OaRQC57i5LzU8VkvzZDS/cjjOFmiSZbDOWsNdfkBvAgYZpvTcoefInaJT3X16H0BX654mH/BngRzvQU/qoj7HmjC0CdIoO8oIQpJs/2q6x/VyLajmJn+DkVCfwAQKndcD5zA5GnZdxubJdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NevBwL32JWYLsDkGGNaMqGDsV7Yw8lBHGAhymcR/Iuk=;
 b=cti++6WW7eBp/jCHGsUML25DOCgSxfpCuH6Pyq7nUmPOhG5jaFYFRiWo/M/F19gfokyFLYQZCKFet5SYqgIaN3eWuwFZnIB4vRGatcNjzYmSaLjK1M9SaQ9GDBNW7LpnFuyphD3Pa/g+XZPDQHtTM6noHsEYqMcmv809P6KqImO7f4avmgoT4jYm8YqIkcqUufhQm3s2eLxMOS5lP5Dn8IMay4WPq5u59BU8l+U4LVvSf+oD39P7ABRE3hMHo8jZE23CDZ6NfWdFHt22Ll7+uqc6JNigDZV7XHQWahyyMZUhrEJpPcqesIkqpL6nbsapAMsLTR3hMzcLQxZFj/WwdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NevBwL32JWYLsDkGGNaMqGDsV7Yw8lBHGAhymcR/Iuk=;
 b=oKmeUIFhxnInVvwlR3xEsu7lhGIkr8IC8HmGKrCgxAqD3FDI+Z38yhwXONIX+uz1MJuqiRrFHUx+UU+8SZveZVBXuQrZv6pQyFBWr0IJB+PfaQIZA8UGmHxDc/Smr0/WnmKqm6dpmwj7wUZPAC/SFPcHg4km/wGdFoY9Yaq2joDxy4aBZNFOqTtR328FhHO0BLp2J7wARGayXm8mqwv0r6HZ3/xfhZgTuRXmbmMku3NLFUqcq/VFYsgS2Fc0HM2ojtRr1aBx/u5u/oO5lStFXu3W9FfQNMohUJQ5+v7twMMI7ulGTvg7/V6LaHWjbPKqqnVTKiyQCi+NuDHIK/5UNg==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by DM4PR12MB6255.namprd12.prod.outlook.com (2603:10b6:8:a4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Tue, 2 Aug
 2022 12:07:18 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548%9]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 12:07:18 +0000
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
Thread-Index: AQHYpXzdw3PxP7W5AU+7nUMUJ/fFua2aczSAgAESo4A=
Date:   Tue, 2 Aug 2022 12:07:18 +0000
Message-ID: <4a49be4bb85f99de60cfec4c57bce5f1a356416f.camel@nvidia.com>
References: <20220801080053.21849-1-maximmi@nvidia.com>
         <20220801124419.4aaffcac@kernel.org>
In-Reply-To: <20220801124419.4aaffcac@kernel.org>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2569d3b9-dd74-48d7-ce83-08da747f8c35
x-ms-traffictypediagnostic: DM4PR12MB6255:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tM2dd+n03JEQJ8GkzMnVg+pfzmldqNmgqDoD+eYj1NG9MZjHlfYsJU9tH+gHfHlZV0ojCMu9YbAB/FNIb/BcApqYM2uskqjApNqZ5BZfS9wmUyGToK7723HVv+Un2xLGxOEcrH90oZolgA2msxg/KiVz9oW98y5SZ5yPvWLTiRDzH/qJUv50sYNRkINisJRfC2t3HN/fCnDpRtebEBSwvj6B3XUuKV6VKO/RkzGQBTsib/uKlkxl4Z3XWiFKPUUqoXaZUzkyVqohD9hPMRLfKVz0zJpqcZMdPsTkYVhsMmZZgd80CXaM67ctvYyWtUSV0beRJ1/3imvOuIWFVD6IrmKlWUp/WKvCP3mx16VtjyNL4u2LOCA5sIlmKWiU9uo2Dio59c00rIKa33tJiSYKog/Jorv7ttfHOi7IXYsKjcHUgLrwS0HK52SgN1D4DNlIMQwNENTU71FUktLMHp9vflP+u4g7YtPdAVN2Lfb9HwBE8XIShoaKXsEVyTxYuD3syJONKxPu060oxEnMSSK5Vj5hU04N/tSPsyglwetdmGWBY13T6EGtp2InXllrTVS0ldMZPmxnyYjyxVxr01TLyYO+z7affzAkMLUFGYk1Is7s0twMkccoIIMtugy5r1epCsq8NnAQDoQGM/ZDpeFc41CVt51s2xUd0APp06TPm5+z1GKhYz5vpAiZAO49cW7M4jvxTOOz2OIn+OvCcU9gez4pHha95x9ApHTE7JckM9sANfRRWXVkkfA/dbk00Xb9gJ29xdKWbaFRwTWFxQ/17ws5FwKJeEJqK1OFdN8VV8sIkfbvTnhuXnsZcQoP4eRc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(107886003)(76116006)(36756003)(186003)(38100700002)(2616005)(64756008)(66446008)(66476007)(66556008)(66946007)(91956017)(86362001)(71200400001)(6506007)(83380400001)(8676002)(6512007)(4326008)(6916009)(54906003)(2906002)(41300700001)(478600001)(5660300002)(38070700005)(8936002)(6486002)(316002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlUvNVhmZS9mRkFCVXp2cXBmZEtRZGFjU3N6Nms5K1dScU02ZWRMZXJwVXQx?=
 =?utf-8?B?YkZIanJrWm5lQmtKL202V085NHhqRmFkUHNJa1V5a1lWNHdLMkg4VEd6YW42?=
 =?utf-8?B?bzJmSVdFclg0ZlhrQVE0dGFHNlZZeHdtc3l6UEI1elN4SG5jb3BOVW5kY2kw?=
 =?utf-8?B?WTFUQTRmSlArd0M4V3pYKzdWZUZKdG1mOU1RNmNUSXZydTNSV3FuK3EzNlp1?=
 =?utf-8?B?VkpFZENlWUpQRGpnUFBSKzhlcWNvNUltUlJwQW9LL0wxZENFcHFsQ08wL1Ji?=
 =?utf-8?B?UlZZb1QzUjBiMUFPcnJ3VFJJOHUwM212akxWcU5rL0xIQWVqbllFVjZTRG9j?=
 =?utf-8?B?c2xwSWVPSkwyMXpTamwxNmw2OERnUzB0OGNtaysyZ3NjRGluWFpUb3JsSUxV?=
 =?utf-8?B?WkpnaGZ4a2RLemJUa29TckErQ3FVdjljWDhlUWFWWThNN2M1ZkI1Z2RtL2V0?=
 =?utf-8?B?WDJFejE0QjhxUkltbkpFUDU1dkNQckZLclV6L2FsaGV5OFdoRXdvbHBVWUQv?=
 =?utf-8?B?OEtRcjVOV2dmS0NLdWQ1ZUE2VklxNTF1eDR3NjJDeTAwMGsrcC9wSjhYSWFQ?=
 =?utf-8?B?S2RIOUorUFo4ZklhQ2lwVEJ0Nmg3OGFaUzRtR2pBWVFhVnRVaWdHcThuUFpQ?=
 =?utf-8?B?UTZNcW5sRk9QNDZJTFBZa2YralU4eDNCVm1hcXhXZjVuTnh5QmhKamVGTUhT?=
 =?utf-8?B?cS9JZHl3ZmgwcDJoKzJIMzJQNWFxZUluVWI5cEFkOUpSVE03Vi9jS3JJbmhy?=
 =?utf-8?B?RDhrZXR4bjZzSzY0SkxlNC9BK0tLN1ZsejdxWWFic0E4ajFUVEdOR2VnNGJ1?=
 =?utf-8?B?Si9JZUQ5QTRBQlZ5eWZPamczZTlzMVVIZFlXK1FrczNjejBuOW1sRzVtT0NL?=
 =?utf-8?B?NU1YY3dXS2tWSmxvUG1hTTNGYjQ5NVIzcGpESXNvSDYzUEsvNG1aRHE4NDRL?=
 =?utf-8?B?VWNBekpIRythaEtKa1NGTWcraU1aMlh4SkZkaFBsa1ROcGlaVUw0WE5IK1dC?=
 =?utf-8?B?b2FtL0lQaG5UL08wREFPTmRzVGowdldkWkVKWUJwNmx5V0luMUF6MWQraGZG?=
 =?utf-8?B?K2RLWEx5VHpPai8vaXhFQThhWlMwM2NENHNpYUxFZks3MDY5TUV4TjZESXhE?=
 =?utf-8?B?cEsxV3RGM0hteThoSWhVZHd5V3ZLWGZ5WEI2eVZhNmhMTThtRkxya1lZS0tp?=
 =?utf-8?B?ajhyUU1UMDhYNm5STTRSL0hzY0V4cE4yUHYvUWFOOFVpS1UvMXNOUzFzaG9G?=
 =?utf-8?B?YjJpNThhOFlvOTNCSUgrWWpLNDBGdVUyNklVWGdwcnA5ek1YMi9uSU83L0xw?=
 =?utf-8?B?SDFvSmtNMUhKcStqbUJLVTVNYWtwdlNLOWp2ZGJNV1FJRFdiL2JyS3F4ODBp?=
 =?utf-8?B?dzZLSm9rb0xzZlRYSjJJKzBNb1JXQi9qUVBnT3daQllZY1BtNnlzRGloOEs0?=
 =?utf-8?B?OWxQR3JsOUUyaWhUdXBIemN6akV4WlNiMlZacFpLK2Z2dzgvUmpjcjdPZzZY?=
 =?utf-8?B?MzhjTnZHdUk2WW4vWW1uRE9zWkw5aFFVYkh3alJ0T1VQT0QwWUFCNU5HdU03?=
 =?utf-8?B?NU51SjJaQ2F5TDN3WDg3MlZ1NnNLV3VRb244SlcxWHJ5c1M5SGZkenp1TWR5?=
 =?utf-8?B?MEk0MTE2eGl5eGV2VmJ1OVNYK0Uxd0tOR1BLRU5ackV0S1JOZDMwSXlpSVcv?=
 =?utf-8?B?VnQ4U2cvcWE0TXlkRFV4d2FubnJvNEFXSzJidUh4S3UzcHdZRnZ5S3lxNml5?=
 =?utf-8?B?Y3pwcUJJa2VkeVdULzRxbDlqRnVKblJyc0UyK3MzbFRWL05VeklaekY0TGtl?=
 =?utf-8?B?VWlWcjJQbDVzaDYxVTNhVkpqTkxYaXhQY1FKQnFpbncydEhIVjVZbjlQNUtB?=
 =?utf-8?B?N3N1VVpHMDZOeVVqSUc1cFJRQmNvM1IvbGlWZnJSZmluYkFVRjZLTVE2eUFv?=
 =?utf-8?B?cmxkVkxWL1hhcExPWUJnVWU2NkYvT094OEF4WERNMDI3VEdGaHNRbXNZVDVK?=
 =?utf-8?B?d21XUHlJYlQrZ1JDM1lVZnFzRi9Gc1RmMGcyRmoya0JwUGNGTkgrSHlmMmNk?=
 =?utf-8?B?R1V2L0o4a0g1SWNZTWUvT3ZybkZ4QkRteTdyYWhpdkJLYjdCTkVwT3VWVVNY?=
 =?utf-8?B?VGsyOFdjWCtIcVQyQkdSZFVDRXo2WmJ0V0FGQnlXcWZ3UmJXUit6UThWYjcv?=
 =?utf-8?B?NjNqWVZSeWNidE1yRnJDMG1kTEd0STBJcjdUZTNEeFBuNW1iUWI4R1VXR3RX?=
 =?utf-8?B?Z0h4dlpSZVlOeEZHRTczQkFUc1RRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB31EB6B97CCA8429B4CA84924723D74@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2569d3b9-dd74-48d7-ce83-08da747f8c35
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 12:07:18.7882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f1MwoHrLIurXkdOrhT8epR6p9tdnJEAe7FV2LZ+ZIoc9zlxG9bkexWfTALkH8rpeldWQ4fLZrJV4irBGwMSDRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6255
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTA4LTAxIGF0IDEyOjQ0IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAxIEF1ZyAyMDIyIDExOjAwOjUzICswMzAwIE1heGltIE1pa2l0eWFuc2tpeSB3
cm90ZToNCj4gPiBDdXJyZW50bHksIHRsc19kZXZpY2VfZG93biBzeW5jaHJvbml6ZXMgd2l0aCB0
bHNfZGV2aWNlX3Jlc3luY19yeCB1c2luZw0KPiA+IFJDVSwgaG93ZXZlciwgdGhlIHBvaW50ZXIg
dG8gbmV0ZGV2IGlzIHN0b3JlZCB1c2luZyBXUklURV9PTkNFIGFuZA0KPiA+IGxvYWRlZCB1c2lu
ZyBSRUFEX09OQ0UuDQo+ID4gDQo+ID4gQWx0aG91Z2ggc3VjaCBhcHByb2FjaCBpcyB0ZWNobmlj
YWxseSBjb3JyZWN0IChyY3VfZGVyZWZlcmVuY2UgaXMNCj4gPiBlc3NlbnRpYWxseSBhIFJFQURf
T05DRSwgYW5kIHJjdV9hc3NpZ25fcG9pbnRlciB1c2VzIFdSSVRFX09OQ0UgdG8gc3RvcmUNCj4g
PiBOVUxMKSwgdXNpbmcgc3BlY2lhbCBSQ1UgaGVscGVycyBmb3IgcG9pbnRlcnMgaXMgbW9yZSB2
YWxpZCwgYXMgaXQNCj4gPiBpbmNsdWRlcyBhZGRpdGlvbmFsIGNoZWNrcyBhbmQgbWlnaHQgY2hh
bmdlIHRoZSBpbXBsZW1lbnRhdGlvbg0KPiA+IHRyYW5zcGFyZW50bHkgdG8gdGhlIGNhbGxlcnMu
DQo+ID4gDQo+ID4gTWFyayB0aGUgbmV0ZGV2IHBvaW50ZXIgYXMgX19yY3UgYW5kIHVzZSB0aGUg
Y29ycmVjdCBSQ1UgaGVscGVycyB0bw0KPiA+IGFjY2VzcyBpdC4gRm9yIG5vbi1jb25jdXJyZW50
IGFjY2VzcyBwYXNzIHRoZSByaWdodCBjb25kaXRpb25zIHRoYXQNCj4gPiBndWFyYW50ZWUgc2Fm
ZSBhY2Nlc3MgKGxvY2tzIHRha2VuLCByZWZjb3VudCB2YWx1ZSkuIEFsc28gdXNlIHRoZQ0KPiA+
IGNvcnJlY3QgaGVscGVyIGluIG1seDVlLCB3aGVyZSBldmVuIFJFQURfT05DRSB3YXMgbWlzc2lu
Zy4NCj4gDQo+IE9vcHMsIGxvb2tzIGxpa2Ugd2UgYWxzbyBnb3Qgc29tZSBuZXcgc3BhcnNlIHdh
cm5pbmdzIGZyb20gdGhpczoNCj4gDQo+IDIgbmV3IHdhcm5pbmdzIGluIGRyaXZlcnMvbmV0L2Jv
bmRpbmcvYm9uZF9tYWluLmMNCj4gMSBuZXcgd2FybmluZyAgaW4gZHJpdmVycy9uZXQvZXRoZXJu
ZXQvY2hlbHNpby9pbmxpbmVfY3J5cHRvL2NoX2t0bHMvY2hjcl9rdGxzLmMNCg0KTG9va3MgbGlr
ZSBuZWl0aGVyIG1lLCBub3Igb3VyIGludGVybmFsIENJIGJ1aWx0IHRoZXNlIGZpbGVzIC0gc29y
cnkhDQpJJ2xsIGZpeCB0aGVzZSBhbmQgbG9vayBmb3IgdGhlIHVzYWdlcyBtb3JlIGNhcmVmdWxs
eS4NCg0KQlRXLCB0aGUgYm9uZGluZyBjYXNlIG1pc3NlcyBldmVuIHRoZSBSRUFEX09OQ0UsIHNv
IGl0J3MgYW4gZXhpc3RpbmcNCmJ1ZywgZXhwb3NlZCBieSB0aGUgdHJhbnNpdGlvbiB0byB0aGUg
cHJvcGVyIFJDVSBBUEkgaW4gbXkgcGF0Y2guDQo=
