Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D4B51F49D
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 08:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiEIGzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 02:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236046AbiEIGqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 02:46:10 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7C911E48E
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 23:42:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVN/tkopG9vzOnDdMBisCMMiNWa+3ifTH860WdTh6rXReh3X2veqScn3nvAlhRjY5En1dbT6a0K8txuub6FDeJy3G/2L2pDw5jgpAGGCPRNiKkVfVcSOQfBvAX82Yzvmuh2/MSaNQBlt4G8hruYzalhBNZF11g8jdecKIqtDBB7dKW4FWzfLsBuzAPOJiqnMEJnZS4ZW6GCn/y705slvBCaxRgkPtXLrEcxKRPqB0F0V3gL75shlU4CZWQ++8xrd47oaf7kw/AV5B7Yw5xJAqPOpK3fnqu1c8R7VQwDYZSNH/IxDelNgOjhrho59AftMBENw9TJtmfJ2MO5ICMqS7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9zJ45SAy2ERU79kC8SC5Pxt3aCFDDaQOaI+5v6voZk=;
 b=Pg1UFbrQdBNwmyvYueMHU4SoF2+15EN5+3EBsKor7cSybvOhcQrpDs+RZhHHXJ4w/HPBpRCBU3n2hyXiwOXEKwaWwGsRbImn3B7B4CEt/YQKJjo7eJ7SPDTgTzY0Dv3o4Z0duZeBfXE5DrAIE3oOUcJTPXFdRC7pTLjtKumG06RrTU/AeVs7rk5Yhr/D5F1uyVZq+j+2ibG2kNH7kQYx31QP3XngyP8+wPOF2fBkGJQYM/ez7egL8g2E0q+ruOizlIHU7pVepYFd3fWqYuJDx+l8H9WeKDzseRqaPwDyOiOmH1KzM9GlGA6LPgxT2C9fYeMYLEKrqNsK5uKzRo5cog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9zJ45SAy2ERU79kC8SC5Pxt3aCFDDaQOaI+5v6voZk=;
 b=qqifa0zGj5err2xEroTMdG3DKVbPow1GORu3qC5wrG1b5uivsmdcQCn6GpXq0HvWxAK2I/CN2fFWCk2a0v2moBoloQWI5wUxHBwPDQ71RRjNM8ksdn+ZkPmvfWWjrecygojA213CuxC8C6UyNZopVxAEPQdacv9tAl1WzotfQEiVVJ5wMLhSQhMyV5T2TVmuqRFF4EqpodY9uBho/K0hQ8EQBhz0LyMxi4nZrDVTZfYHH/IgBI1amozrUZQN9ZzyHndFij+aXkQlySNphzb69idarzLANjnev6Rg/+cCYY9fIBRlGYxR0nf+AU2Z+KQQhzpn+2yO3W/pHKgR6ySm4Q==
Received: from PH0PR12MB5449.namprd12.prod.outlook.com (2603:10b6:510:e7::24)
 by DM5PR12MB1209.namprd12.prod.outlook.com (2603:10b6:3:6f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 06:41:49 +0000
Received: from PH0PR12MB5449.namprd12.prod.outlook.com
 ([fe80::6506:1534:603b:c58b]) by PH0PR12MB5449.namprd12.prod.outlook.com
 ([fe80::6506:1534:603b:c58b%2]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 06:41:49 +0000
From:   Lior Nahmanson <liorna@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v1 00/3] Introduce MACsec offload SKB extension
Thread-Topic: [PATCH net-next v1 00/3] Introduce MACsec offload SKB extension
Thread-Index: AQHYYrtpheXeAhinuUe0kCrynsOz160VHnOAgAD7RZA=
Date:   Mon, 9 May 2022 06:41:49 +0000
Message-ID: <PH0PR12MB5449EED9BF691A80E9414E54BFC69@PH0PR12MB5449.namprd12.prod.outlook.com>
References: <20220508090954.10864-1-liorna@nvidia.com>
 <Ynfkc7CxqF29VTBv@unreal>
In-Reply-To: <Ynfkc7CxqF29VTBv@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11c126db-6e39-4ec1-f186-08da3186fe8e
x-ms-traffictypediagnostic: DM5PR12MB1209:EE_
x-microsoft-antispam-prvs: <DM5PR12MB120909B0E5A26B33FE677AF7BFC69@DM5PR12MB1209.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hRr/pyIe+PwyJksd3B0Jd3EMg5xHgmZhA4G7sn17xUrQVpuWOYNK7hFdMz/LEXZXkm5lSdalgiiysMw10xk+qkgpkg84rohm1JAJfTOVVuWwk6hkKtV+7dXda5lTsmxWsdZ6k/dVoTjA+eFx+8/dgz8Px8xR6HzptZeGEU4m3yuIBJX+XcMtjvfFyXZ9bqbpPZp/mdTgguy3itND3oe0k+ScgeH6I0Bkow+R9Gvwa1xjgy0jjZQqHglOnJ6r4qD8TVsss2F9UMMU02djCQw6T3YL6h0SRyny2pBB8WwFKj0CIttzmVUId0XU+BVyiHxBxzN0jNLQQUshAkbwgd8HKrOtLJ3/5V3gwnsSZq/06RjQ30s5ZS718rJ5v+rHprc2cxlMaNpbCjdIT/Lj+ejTbtfydyEaG0B+5TonR+R5jjAJ40C4+hRZDmK5Bkw3jTf+3XrL+stDlRq93IzsSkxtk0BGlNUoa4Sqg9W1gD3VlGRwRp9QIEeYvYCx1pO93t9SvFfPkgLdNOP5ZI0DWEL2O8f7uNVfxMoeHkpo+fQaT+wYvNYNKOxlZ98riKSl5m/ZFyX2KwaoatyNIQBB0j3HiZDZ8sSE32ZCCv1ffHzXkm5E489QL8Pkj3KhXGwC893akG78o5rpeX38VFauf1Cb2J+gvgefV5c1PJq5PWQzgXVQRZGrwGSiaWnjyym5h1OkcKWFgtLmR1OrMR2p+51KC8k2RaJzfqxEGOazNuC2aW2SrrRBUfHzgVS/6gEaALypcCuK5QvO5lIPo2EVFz+AbdAjZC1Otoi1m8ZURWpd8ZY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5449.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(966005)(66446008)(55016003)(66946007)(76116006)(64756008)(66556008)(508600001)(9686003)(66476007)(186003)(7696005)(2906002)(54906003)(8676002)(4326008)(71200400001)(6916009)(38100700002)(86362001)(33656002)(122000001)(26005)(52536014)(8936002)(6506007)(83380400001)(38070700005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YS9DWXJoVWJISHlyT0RxZFhPcHliVmh3RUVXelNaaW9aSkJvTDQyUkNPeE91?=
 =?utf-8?B?RDV1N0ozMG9JNzAvRXFRM05YNDl2dHZqRzM3UkpVUnoyWGlkTXNmS3dvdmtn?=
 =?utf-8?B?MGIrOVVOZ2dOdGxTMkFoSXlyclp1RTVxQWJzcmdNREJIRklIUlFZNlJxSUdG?=
 =?utf-8?B?dkR3dERYNitPcFUrMnVYbFAzOUttZGlxNXRvL1dpbzJxU0doNGRZOXV3WWxQ?=
 =?utf-8?B?dFN3YmVxQ1ZiMmMweVB1Y1EzdityT2lpcXVkQmE5bitBOXRkUzQyemlzdVcw?=
 =?utf-8?B?Y3JWTnFld2t0dVF5Znl4V0hBQWYyaDI5YjVqYmlvVDA2QVdXMk94am5JTmdl?=
 =?utf-8?B?L09yeCtEeDV3TGlyL0Y0QVJUZE1sY3RUTktOTk9XNm9JWVdjaGFjZzMvbHZm?=
 =?utf-8?B?S0xjeHRvMGkzamFMUXB3VEVZUlNEMTBNTjN5Rmhhc3VLbnhtRGdJc3l2aTRX?=
 =?utf-8?B?d3RoNUZjSEIyYnNKM2x4dUZReGZxWkdQQ2szRGhmcFJhTTUxQjROVGpRemVU?=
 =?utf-8?B?VzJMM3pPcXp2V2FEUDdXUG9KSkRyNWtnRTZEb2pvSVJJVEF4RTI4clZZdVlL?=
 =?utf-8?B?ZUZmSEwvL2IvbFFYWHFrSEJyVGY1ZGFoaW9DdmZ2cnFoL3hQMmhUcU5pUks5?=
 =?utf-8?B?THBiTE4xLzAwMy9vM2xYMnU2dFVlOUhtNnd0MUVaYSt2SzdWdkNnRXRzTDlD?=
 =?utf-8?B?cHZGTVhTcjYyc1RHeHZicHV5RmNIY0k3WU95NGRWSTNsTjdWeWxjdkExZlkz?=
 =?utf-8?B?LzQ1QStMeXE2aE9laUZqcUtwOFBTWS9PMU5kTGJTdGZJY01tdVJzREhpM2xn?=
 =?utf-8?B?REduMFNMOCtHNG9aTmNZZnNML3NObkxOSmtnRDloS3NyRjJWS1I0L25OaGNw?=
 =?utf-8?B?L2dRZkZXSzRXRkk5cDBTd1QrWG1YVHcwSkV0YXVRa3dXWURUL1dKWUVOc3Bo?=
 =?utf-8?B?eVVhWGViQitrTE5mZFlBUVVhdGtmQ2JsbHg0MmFla0JtWW9acG5IVkgvYmFo?=
 =?utf-8?B?U05RalZFOWRhd3J4MEJqYVBHZ2VKTUVwSnNFM3RseVVMR0VFb05RN3lyS2dm?=
 =?utf-8?B?Um1JNkpmY0RlVnljdU5BR3greFdYYWptNnlkMzdZZk82U2lEb1phTEpxbjM5?=
 =?utf-8?B?cDliZnJUaittZlpnS0N6cWxkODVPVlBxQzVFZXI0RDlNNWN2UFFFVFg4V0VX?=
 =?utf-8?B?TUJSWlNOWCs5eTI4ZjdZaXpKQnJpV2dWMlY4b1ZTVTNjcFphUmxlclIzM00x?=
 =?utf-8?B?aEsvVDNrbVdFV2F3Sk0xUkdpeEZvOGtvMFYvNDcrMVpqOFlscUhNODBYZkVG?=
 =?utf-8?B?cXJpL0dUNm9MOEtQbkxiTU1vYnZxMEJWbndDQm9NM1l4dURzT2ZnMUFEMEFy?=
 =?utf-8?B?UVpwd1FpNktpbUd6WmNhT1ZtS081cWZaN08wMGg1YWJRbWJzdGE0c1ViVW81?=
 =?utf-8?B?RWhMV1RmcXRSenZaek1jWnl2WEpBTkNUVVN4UGNhQVF1cVZQQTc5VnR4dXFp?=
 =?utf-8?B?WnRLb2o3NUg1U2ZDLytQQlEzWXhLdFd1YVJUeUcwZmZSTjR0RGdrNytnRUt3?=
 =?utf-8?B?dGgxS3V0TmM0cGJiL0xEZnBWSlJvNExPOE1BcGRoNjduelhPTURLV3JleWFt?=
 =?utf-8?B?dFlkSDVCajRxSmdpWlYrWUNEVXlsUThjand4bEUzRC9HRGJzTnltUTJEckto?=
 =?utf-8?B?SWtHckZ6RkFYeXlQSTYzMFg5SkF5RmN1Mm9GWkV6eHE2UzR1cGphVXdGbFVZ?=
 =?utf-8?B?Z0VRZmlRUDBZTVlHc0RhNDZUQVdJVFpUQ1oxZGlzVmxYV200S1orbVI0a2R2?=
 =?utf-8?B?Q3hDYURtZjNnMVh3dFYyNDNhenYrUlVrUFN3ZFN4QzFnWmFEMFRldEdIZmI5?=
 =?utf-8?B?Qk5XQ1ZmWVBFaTkzcDE4OEZrbGNlNmw5ajkwL1FKZkJFRWNIVFdkTC95SW96?=
 =?utf-8?B?aGdVZVllOElMa2NYZXNwWnBNOXRYVHdBN29tcVF6U3lFMEd5SjJsNFQ1QlA2?=
 =?utf-8?B?UEd3Mk80REcxK2VnUXBZczc5dlVjU3lpMStDbGl0bnI4MThLR2xiYjB6WWpR?=
 =?utf-8?B?NEphbVpYQ1phNGt0Ti9ORXRReTJNNHJGcHh1Y1MzUDJqMWhraGJ3dGZMcVZG?=
 =?utf-8?B?N3RCcTdnSWx5Wjl2c1FmajNFdTdQNE83VHplWFlKTTROR3g5VW5jeTZSMlVO?=
 =?utf-8?B?MTlNY1FqNU1hQzhhSlhPOHZvSEwrN1hUam5Xa25kbWFTdGsrYjFJUGU1eXVX?=
 =?utf-8?B?aG84cFlTeG9ISjlBV21oZEphcXBQS1lVM1VhaldBTlJnME14ek8wRldnZnhz?=
 =?utf-8?B?bnB5Z2xYSmxsTndBbXVtQkU3ekdpdUVYeHNzeWVoRUFsZ2JlQk01UT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5449.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c126db-6e39-4ec1-f186-08da3186fe8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 06:41:49.2037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oEFW97j96A+Pgsnx85ChU2omgBacMN00gOjibwWWIZ2YnnOhUST3a+50lnmTs2DPc01krbJJo2uD0OUwpwHowQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1209
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ID4gT24gU3VuLCBNYXkgMDgsIDIwMjIgYXQgMTI6MDk6NTFQTSArMDMwMCwgTGlvciBOYWhtYW5z
b24gd3JvdGU6DQo+ID4gVGhpcyBwYXRjaHNldCBpbnRyb2R1Y2VzIE1BQ3NlYyBTS0IgZXh0ZW5z
aW9uIHRvIGxheSB0aGUgZ3JvdW5kIGZvcg0KPiA+IE1BQ3NlYyBIVyBvZmZsb2FkLg0KPiA+DQo+
ID4gTUFDc2VjIGlzIGFuIElFRUUgc3RhbmRhcmQgKElFRUUgODAyLjFBRSkgZm9yIE1BQyBzZWN1
cml0eS4NCj4gPiBJdCBkZWZpbmVzIGEgd2F5IHRvIGVzdGFibGlzaCBhIHByb3RvY29sIGluZGVw
ZW5kZW50IGNvbm5lY3Rpb24NCj4gPiBiZXR3ZWVuIHR3byBob3N0cyB3aXRoIGRhdGEgY29uZmlk
ZW50aWFsaXR5LCBhdXRoZW50aWNpdHkgYW5kL29yDQo+ID4gaW50ZWdyaXR5LCB1c2luZyBHQ00t
QUVTLiBNQUNzZWMgb3BlcmF0ZXMgb24gdGhlIEV0aGVybmV0IGxheWVyIGFuZCBhcw0KPiA+IHN1
Y2ggaXMgYSBsYXllciAyIHByb3RvY29sLCB3aGljaCBtZWFucyBpdOKAmXMgZGVzaWduZWQgdG8g
c2VjdXJlDQo+ID4gdHJhZmZpYyB3aXRoaW4gYSBsYXllciAyIG5ldHdvcmssIGluY2x1ZGluZyBE
SENQIG9yIEFSUCByZXF1ZXN0cy4NCj4gPg0KPiA+IExpbnV4IGhhcyBhIHNvZnR3YXJlIGltcGxl
bWVudGF0aW9uIG9mIHRoZSBNQUNzZWMgc3RhbmRhcmQgYW5kIEhXDQo+ID4gb2ZmbG9hZGluZyBz
dXBwb3J0Lg0KPiA+IFRoZSBvZmZsb2FkaW5nIGlzIHJlLXVzaW5nIHRoZSBsb2dpYywgbmV0bGlu
ayBBUEkgYW5kIGRhdGEgc3RydWN0dXJlcw0KPiA+IG9mIHRoZSBleGlzdGluZyBNQUNzZWMgc29m
dHdhcmUgaW1wbGVtZW50YXRpb24uDQo+ID4NCj4gPiBGb3IgVHg6DQo+ID4gSW4gdGhlIGN1cnJl
bnQgTUFDc2VjIG9mZmxvYWQgaW1wbGVtZW50YXRpb24sIE1BQ3NlYyBpbnRlcmZhY2VzIGFyZQ0K
PiA+IHNoYXJpbmcgdGhlIHNhbWUgTUFDIGFkZHJlc3Mgb2YgdGhlaXIgcGFyZW50IGludGVyZmFj
ZSBieSBkZWZhdWx0Lg0KPiA+IFRoZXJlZm9yZSwgSFcgY2FuJ3QgZGlzdGluZ3Vpc2ggaWYgYSBw
YWNrZXQgd2FzIHNlbnQgZnJvbSBNQUNzZWMNCj4gPiBpbnRlcmZhY2UgYW5kIG5lZWQgdG8gYmUg
b2ZmbG9hZGVkIG9yIG5vdC4NCj4gPiBBbHNvLCBpdCBjYW4ndCBkaXN0aW5ndWlzaCBmcm9tIHdo
aWNoIE1BQ3NlYyBpbnRlcmZhY2UgaXQgd2FzIHNlbnQgaW4NCj4gPiBjYXNlIHRoZXJlIGFyZSBt
dWx0aXBsZSBNQUNzZWMgaW50ZXJmYWNlIHdpdGggdGhlIHNhbWUgTUFDIGFkZHJlc3MuDQo+ID4N
Cj4gPiBVc2VkIFNLQiBleHRlbnNpb24sIHNvIFNXIGNhbiBtYXJrIGlmIGEgcGFja2V0IGlzIG5l
ZWRlZCB0byBiZQ0KPiA+IG9mZmxvYWRlZCBhbmQgdXNlIHRoZSBTQ0ksIHdoaWNoIGlzIHVuaXF1
ZSB2YWx1ZSBmb3IgZWFjaCBNQUNzZWMNCj4gPiBpbnRlcmZhY2UsIHRvIG5vdGlmeSB0aGUgSFcg
ZnJvbSB3aGljaCBNQUNzZWMgaW50ZXJmYWNlIHRoZSBwYWNrZXQgaXMNCj4gc2VudC4NCj4gPg0K
PiA+IEZvciBSeDoNCj4gPiBMaWtlIGluIHRoZSBUeCBjaGFuZ2VzLCBwYWNrZXQgdGhhdCBkb24n
dCBoYXZlIFNlY1RBRyBoZWFkZXIgYXJlbid0DQo+ID4gbmVjZXNzYXJ5IGJlZW4gb2ZmbG9hZGVk
IGJ5IHRoZSBIVy4NCj4gPiBUaGVyZWZvcmUsIHRoZSBNQUNzZWMgZHJpdmVyIG5lZWRzIHRvIGRp
c3Rpbmd1aXNoIGlmIHRoZSBwYWNrZXQgd2FzDQo+ID4gb2ZmbG9hZGVkIG9yIG5vdCBhbmQgaGFu
ZGxlIGFjY29yZGluZ2x5Lg0KPiA+IE1vcmVvdmVyLCBpZiB0aGVyZSBhcmUgbW9yZSB0aGFuIG9u
ZSBNQUNzZWMgZGV2aWNlIHdpdGggdGhlIHNhbWUgTUFDDQo+ID4gYWRkcmVzcyBhcyBpbiB0aGUg
cGFja2V0J3MgZGVzdGluYXRpb24gTUFDLCB0aGUgcGFja2V0IHdpbGwgZm9yd2FyZA0KPiA+IG9u
bHkgdG8gdGhpcyBkZXZpY2UgYW5kIG9ubHkgdG8gdGhlIGRlc2lyZWQgb25lLg0KPiA+DQo+ID4g
VXNlZCBTS0IgZXh0ZW5zaW9uIGFuZCBtYXJraW5nIGl0IGJ5IHRoZSBIVyBpZiB0aGUgcGFja2V0
IHdhcw0KPiA+IG9mZmxvYWRlZCBhbmQgdG8gd2hpY2ggTUFDc2VjIG9mZmxvYWQgZGV2aWNlIGl0
IGJlbG9uZ3MgYWNjb3JkaW5nIHRvDQo+ID4gdGhlIHBhY2tldCdzIFNDSS4NCj4gPg0KPiA+IDEp
IHBhdGNoIDAwMDEtMDAwMiwgQWRkIHN1cHBvcnQgdG8gU0tCIGV4dGVuc2lvbiBpbiBNQUNzZWMg
Y29kZToNCj4gPiBuZXQvbWFjc2VjOiBBZGQgTUFDc2VjIHNrYiBleHRlbnNpb24gVHggRGF0YSBw
YXRoIHN1cHBvcnQNCj4gPiBuZXQvbWFjc2VjOiBBZGQgTUFDc2VjIHNrYiBleHRlbnNpb24gUngg
RGF0YSBwYXRoIHN1cHBvcnQNCj4gPg0KPiA+IDIpIHBhdGNoIDAwMDMsIE1vdmUgc29tZSBNQUNz
ZWMgZHJpdmVyIGNvZGUgZm9yIHNoYXJpbmcgd2l0aCB2YXJpb3VzDQo+ID4gZHJpdmVycyB0aGF0
IGltcGxlbWVudHMgb2ZmbG9hZDoNCj4gPiBuZXQvbWFjc2VjOiBNb3ZlIHNvbWUgY29kZSBmb3Ig
c2hhcmluZyB3aXRoIHZhcmlvdXMgZHJpdmVycyB0aGF0DQo+ID4gaW1wbGVtZW50cyBvZmZsb2Fk
DQo+IA0KPiBDYW4geW91IHBsZWFzZSBwb3N0IGRpZmZzdGF0IGFuZCBwYXRjaCBsaXN0IG9mIHRo
ZSBzZXJpZXM/DQo+IEFzIGEgcmVwbHkgdG8gdGhpcyBjb3ZlciBsZXR0ZXIuDQo+IA0KPiBBcyBh
biBleGFtcGxlOg0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMjA1MDgxNTMw
NDkuNDI3MjI3LTEtDQo+IGFuZHJld0BsdW5uLmNoL1QvI20zYzZmYmZhYTZjNGU4Yzg0MWU4YmJi
N2U4OTUzZGFlZmQyYTUzY2Q5DQo+IA0KPiBUaGFua3MNCg0KICAgTGlvciBOYWhtYW5zb24gKDMp
Og0KICAgIG5ldC9tYWNzZWM6IEFkZCBNQUNzZWMgc2tiIGV4dGVuc2lvbiBUeCBEYXRhIHBhdGgg
c3VwcG9ydA0KICAgIG5ldC9tYWNzZWM6IEFkZCBNQUNzZWMgc2tiIGV4dGVuc2lvbiBSeCBEYXRh
IHBhdGggc3VwcG9ydA0KICAgIG5ldC9tYWNzZWM6IE1vdmUgc29tZSBjb2RlIGZvciBzaGFyaW5n
IHdpdGggdmFyaW91cyBkcml2ZXJzIHRoYXQNCiAgICAgIGltcGxlbWVudHMgb2ZmbG9hZA0KICAN
CiAgIGRyaXZlcnMvbmV0L0tjb25maWcgICAgfCAgMSArDQogICBkcml2ZXJzL25ldC9tYWNzZWMu
YyAgIHwgNDUgKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQogICBp
bmNsdWRlL2xpbnV4L3NrYnVmZi5oIHwgIDMgKysrDQogICBpbmNsdWRlL25ldC9tYWNzZWMuaCAg
IHwgMjYgKysrKysrKysrKysrKysrKysrKysrKysrDQogICBuZXQvY29yZS9za2J1ZmYuYyAgICAg
IHwgIDcgKysrKysrKw0KICAgNSBmaWxlcyBjaGFuZ2VkLCA1NSBpbnNlcnRpb25zKCspLCAyNyBk
ZWxldGlvbnMoLSkNCg==
