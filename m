Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4866B1BA3
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 07:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjCIGiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 01:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjCIGiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 01:38:21 -0500
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2111.outbound.protection.outlook.com [40.107.135.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8359515141;
        Wed,  8 Mar 2023 22:38:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJbvxb7mDjrNEPSvQtgefizMnqOd4Ur5Q/vJuMo3du328Dbkk8y12KP1p9bbcbHfyTT4GqdW5NvWF4J6XNpqYKgHxqaLmqnIoItNo87Xzzx4K6I1AR9HOyPj0f9w1i/KXwhcNp4nz6BqfzZulIIislH3TJRISTsT0iJNKYtxYIpORkr4ZxhYfiOTPdWxErYARFfukUaMK/vJSjNBmBPl26GhK1ASDupzzwQDubwke7bx1C7mkZbQJDNmR6izb8VffL+G9DynAw2A12cy6M7CDvgZrAw30zLiz3FKqXT5f8AU2cJKvJRlEHlyYJZNy+2SQR81zLxXh7wv+solyljivQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UWoUvAUKrAvs6jwHs7HVcG7wE2S8wTrEY9wQrfY+pus=;
 b=NsfOLEZ34PRp34wF9Mu9W7w1VludZIvbXaqx4f/PEOtkQJeozB8yjBQKjTpVd+Aen1S8Htub9A6PP8JGqfT3VEhtksdb6b9v2REZwkaxFODttfT5nIjbZIfRu0wHeRam6ssseH5ahW6b1uxu7YDn8mraptM3VFgvgVegdeFLdUoa8ZHmv3dThqXd8YWFLkAkTnLoSszx+7kDRb6qeHq/tJ3T7JNtamncVjx+FrmNDvzh0s8Xb++0SuOwU9oCMM9mApW30kZocQz+IDDool2v//lczOTTO67Ua58HFStMqoaJSF/RbQC3kLXiREBKjQHbN+mXdbp+mG360t5nuNJxZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eks-intec.de; dmarc=pass action=none header.from=eks-intec.de;
 dkim=pass header.d=eks-intec.de; arc=none
Received: from BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:31::10)
 by FR3P281MB2544.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:4f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 06:38:13 +0000
Received: from BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7331:4276:a6d7:4924]) by BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7331:4276:a6d7:4924%8]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 06:38:13 +0000
From:   Adnan Dizdarevic <adnan.dizdarevic@eks-intec.de>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net/packet: Allow MSG_NOSIGNAL flag in packet_recvmsg
Thread-Topic: [PATCH] net/packet: Allow MSG_NOSIGNAL flag in packet_recvmsg
Thread-Index: AdlR0Ka7ViCRuFYNTDm8ZA0ECs1FwwAA1u0AAB9XLIA=
Date:   Thu, 9 Mar 2023 06:38:12 +0000
Message-ID: <BE1P281MB185890BDC75B0B70C5294C2DA3B59@BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM>
References: <BE1P281MB18589C91B10886A86B26EB6BA3B49@BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM>
 <6408abecce45d_1319ce208d2@willemb.c.googlers.com.notmuch>
In-Reply-To: <6408abecce45d_1319ce208d2@willemb.c.googlers.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eks-intec.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BE1P281MB1858:EE_|FR3P281MB2544:EE_
x-ms-office365-filtering-correlation-id: 31b01342-1026-4b11-cfb8-08db2068db41
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f0V6L7GMhcFoUC8zxCeg+7y+VBW4pVGjXRL+bl+6rT+LXlLKzph9+MBRQKkGG6MoZHQu65+lpKV37LFjHyUn9DGRAkjcPUdBtGeweNpyTpgNEU5oxQUcqAS9626dQUDFuFvVjz+LWqlOouPBVOQzYYVVN85Xx34onDQBHT/5yBRxrN5tJnvBAKlKK5WIEdgGFQDLG2p3bGWCxhA33ekclsjBoiwIEhjWvPNZZrkYGFVEjYPIZykva9KlJ8g9IPb2dNaq5lNtYSb506ldeK80fewYsM5i7yU4w1IYyVlRAkZuUDjkjnVlbbTqkrI5Zto30AoKaA2bKLeVknBRHj+wtwnA7wegZF+yOlNq84e7NmttLXWaiEH0ICfQr/H+GQ8nOkAmfjwKDvFPQMw7ACbldt/taeJImCXFM0HgSf+PauSETRxjpCm/SHAjPn5pjrLFrMaXXbN9xhiy6bhe6N9pcIqeCJLT91zbbZERg5Kv/EwkVhG1DR+gNTxtas/CXLnQqYd7v/MzXaqD359g21ccu9SfqTM6TA/Ikh0gNjhJYCCA6uTdwH6kt49FZWvdg9oBIzcLPvRRMFs9EAALVJ1iOP3oJVFQYVqa0lTVUlHfuE+nvYJVktsUYhKrjNC66OTWW2nHMmaM1ha0UzRLxgECpepGYLoI5m//7NL7IaQe3CHh8dsn5gwfRPzqXNJ4tE56
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(366004)(136003)(451199018)(38100700002)(86362001)(316002)(54906003)(66446008)(8676002)(6916009)(66946007)(4326008)(52536014)(66556008)(64756008)(66476007)(122000001)(76116006)(8936002)(38070700005)(966005)(478600001)(4744005)(5660300002)(41300700001)(71200400001)(44832011)(83380400001)(186003)(2906002)(7696005)(53546011)(55016003)(9686003)(33656002)(26005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXI5MDVZdGMvVnc3TURuaXhpVU1hemcwT2EyTWkxSDAvcDcwMnFBNmQ3Kysw?=
 =?utf-8?B?OEtqMGpBdFlSYm01MnR1OXJkQVFHRUlhdTFOK3VnZW9Qd1hJbW5iTVB3YXBH?=
 =?utf-8?B?b0h4K0xyeWNXL3NlV01sVEUzZjdPNm5XSDZrbHpWanhJL2x0RHArc0FYcnhO?=
 =?utf-8?B?R3E3LzdpNzVqZmdTRXUvYVNLZGF3QlJRczhVdEc3MWtmV3pZVTJrSnlXN3hw?=
 =?utf-8?B?NldBRDZNQS9Qb3l5UGhlbWx5dXlBMUN1QzJYNHUrMWhqQnJTZjVXNkN2WnY4?=
 =?utf-8?B?dXkrVXdic1I2ZTc0K0N4Z0FVbFhySEpQNExveEVLWHRKYWRZZnNTT01Bemww?=
 =?utf-8?B?ekw2TVVWRnN0S2ZuV1E1OUE0WEJaTWNlNiswSnpPbUFvYi9pWXdFamlmOGJK?=
 =?utf-8?B?MVNjbHlLZVpCSXRHcHExaC9EYXY3RFAzejY5QkJYdGxOVzJCTEhvcmIyQ1Bo?=
 =?utf-8?B?Y1VhVUJRSlMwdEZLV0VleUptalFYTVR0eGZJd2g3d1lCSzY4ZWhZRDdGaVM0?=
 =?utf-8?B?Y0lZakZmMlZVVytoamtjN1EzNmtza0ErMTJIUXlqZ202Y0JOMnBvYi9jTXlm?=
 =?utf-8?B?OTNCalZTTVFIRTVwYW0xandkNDVIOHYwdm4rVFpmSmhZWVRpZGp0VUxLMjly?=
 =?utf-8?B?MzJHOTMxREFCWTBseHh5b0hqdFpjbkdwTVVkRU04NW0raFdqSmVBYmNlZGdG?=
 =?utf-8?B?eDFmQmxKRTk5SnVaUVpDdGtWcHQrVVgxWHNZY0JGT053eVU3bDZLY2pseGxO?=
 =?utf-8?B?ZmJvN2Q0Ui9wY2tTcUZqT2wvQXFSTVR2V255b213eHpBNWp5Zmg1TmljL2RX?=
 =?utf-8?B?U3kwUS9WTy9obHNrWlpsbGYzeWRwN3ZXWjcxVFh3d3JPeThzYlRZUlZVcE9Y?=
 =?utf-8?B?cUNta3pYdDdKdDczUUo0bkcwbFdvOWt3UHlBbnJZSFlGSFlTZzN0VzRka0Qr?=
 =?utf-8?B?ZlZUUUVRbG1nSU1CRGdKOGVlWnJITGpBMmpTdndmd0pOK1l5anUrSWFjNXlY?=
 =?utf-8?B?RFE0SmxnajZWZGFzcDZZTEJxN3NXdEpiQWFPVDM4U0tOd0pmRFp4WFM3NG9I?=
 =?utf-8?B?OHB1V0xKN1BzOVJEZlMxSGdrZm5uQUZ5WG1oSDJEYWxwb21YTUVhTjI1alFU?=
 =?utf-8?B?NitHZTBFdDlLMWxvUTVIZENzWWg3WGgySFFybFJ6SEJaM2lYS09DQ3Nra1dl?=
 =?utf-8?B?UnpLMzgrT3hFczN4QzFIU3I5SGxIdVIyYldPams5YnIyL2t2eG5sUytpYUNU?=
 =?utf-8?B?cjdjYm4yQVg1eTJHSXMzOW9zZlI4Q0VlVEphWGthZGNZa0RoU1NKQkFiTk1v?=
 =?utf-8?B?NklaNUlCQWhzajBSNm5Dc0MzdS91K21uZmxqZFIrUktmaXJSekRxV3N5SXlh?=
 =?utf-8?B?bnZKUnlMZ0JPUmxMRURRMnVHS2QrclAzWFl4VFY1cUtyVm9SZ2x5cjBSc1ox?=
 =?utf-8?B?N1N5dkhTOGgvNW5EYkVUaXFlK1hYRDllaEs5VjE5Y3FzQXRWN0lKNk9CdFlu?=
 =?utf-8?B?Rmw2V0ZRS2NDL0t2LzhodkM5bFFZZEx0b3N5Y2xGdkFKSzBhVGFqNGErTVFF?=
 =?utf-8?B?VWVhNWduc2kxWnQvMXp4YjlPMWx5VFdYOFQzWGxZY2U3Ryt4a2FvZEVZUUt3?=
 =?utf-8?B?em9qTExhQUhqZ3dZa2h5cGk4alA3ZHBlazM2WTNVejZweHkzQnFhK25uWWZw?=
 =?utf-8?B?T0Zsay9iSWdkYjlCWVdqVGpXZnhteUYwWVNTclZKNStVV0Y4R2ZUMnF2YWZu?=
 =?utf-8?B?TUs5b3hlemZPc29QTzBod3JGbEhMNUM2MFJINkU4dGF4Z09GVTJic3g4bkZ1?=
 =?utf-8?B?d2lRUzIrNHhSMENjUksrNHZaWEJ6U0xHN013MWlwMW53T213QjZrRkVUMWtK?=
 =?utf-8?B?VWJBaVR4K3pJN1I1K3lLUzNVOXVKeXVGaU1KVS9zSHNNRU1nVVlncVJuU3h3?=
 =?utf-8?B?WXRyaUM2Skc1WUZ6QWo4ZUE2c2RKV1daMmNLUGN5aERJSEZnKzRybG5MN2dn?=
 =?utf-8?B?VGt3Kzg3K09qenFFczh4a1NkU1JSZ0RVdDYxT2VDeFZqTU8zMngvb3U1cEc2?=
 =?utf-8?B?ankwbk0rZlhRYXVTQkFSZnc5K0hMU2FCMDZKS0RKd2VmZ21YazFJTHNOS3NY?=
 =?utf-8?B?bW14OGJTMFM2NU11ZisxaVJyR3djMHp0ZGprQkZybTBHVEJzdE1UY25pcnFZ?=
 =?utf-8?B?SHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eks-intec.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b01342-1026-4b11-cfb8-08db2068db41
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 06:38:12.9799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 24a4746e-2db7-4bee-9bc1-9d6f336af481
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D8yDA2TQN6HOCovq1xlCDvxDPB4G5LraJ687LVy2GbaF9+iHfPtUeqUlMrDqvLfp6rEsbi7Do6AdGNpT8z8B6m1AqtALvNUUmN5IZMgpbFE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR3P281MB2544
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB0aGUgdXBkYXRlLiBJIGRpZG4ndCBub3RpY2UgaXQgZ290IGZpeGVkIGluIHRo
ZSBtZWFudGltZS4NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFdpbGxlbSBk
ZSBCcnVpam4gPHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb20+IA0KU2VudDogMDggTWFy
Y2ggMjAyMyAxNjozOA0KVG86IEFkbmFuIERpemRhcmV2aWMgPGFkbmFuLmRpemRhcmV2aWNAZWtz
LWludGVjLmRlPjsgd2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbQ0KQ2M6IGF4Ym9lQGtl
cm5lbC5kazsgYXNtbC5zaWxlbmNlQGdtYWlsLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1
bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KU3ViamVj
dDogUkU6IFtQQVRDSF0gbmV0L3BhY2tldDogQWxsb3cgTVNHX05PU0lHTkFMIGZsYWcgaW4gcGFj
a2V0X3JlY3Ztc2cNCg0KQWRuYW4gRGl6ZGFyZXZpYyB3cm90ZToNCj4gQnkgYWRkaW5nIE1TR19O
T1NJR05BTCBmbGFnIHRvIGFsbG93ZWQgZmxhZ3MgaW4gcGFja2V0X3JlY3Ztc2csIHRoaXMgDQo+
IHBhdGNoIGZpeGVzIGlvX3VyaW5nIHJlY3Ztc2cgb3BlcmF0aW9ucyByZXR1cm5pbmcgLUVJTlZB
TCB3aGVuIHVzZWQgDQo+IHdpdGggcGFja2V0IHNvY2tldCBmaWxlIGRlc2NyaXB0b3JzLg0KPiAN
Cj4gSW4gaW9fdXJpbmcsIE1TR19OT1NJR05BTCBmbGFnIGlzIGFkZGVkIGluOg0KPiBpb191cmlu
Zy9uZXQuYy9pb19yZWN2bXNnX3ByZXANCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFkbmFuIERpemRh
cmV2aWMgPGFkbmFuLmRpemRhcmV2aWNAZWtzLWludGVjLmRlPg0KDQpUaGlzIHdhcyBkaXNjdXNz
ZWQgdHdvIHdlZWtzIGFnbyBhbmQgaW9fdXJpbmcgYWRhcHRlZCB0byBubyBsb25nZXIgcmVxdWly
ZSB0aGlzIGNoYW5nZS4NCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2L1klMkZqYTNX
aTB0SXl6WGNlc0BlaWRvbG9uLm5veC50Zi9ULw0KDQoNCg0K
