Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A8C4D40F5
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239677AbiCJGAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 01:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbiCJGAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 01:00:42 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2054.outbound.protection.outlook.com [40.107.95.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B139F4CD5B
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:59:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noyFiokPG72QIAkjOJdEtlEIkSYhcm/DXIMetG+qBTcpe+HLVBJAXakTIipDtVDj4hDQ3PW5xgqFwQ7jJwR/Xahzyfu/AENfm5lk/5xNpJ9fQHZY1xv6Ff89VBXP7nbgyhsPY8LlOOUtDFAhEg79tSsp0AruQDmoCdoaEdA+m76IZhErqlIdpgE9Le6LOvsTmrsdyZkd89+CKKWgQkRCIVU8hWlaqOPqHcp33RzfEkaQsSouZFjgjYimJbMgNbPROG8kV1duI7mV+SZkGqi11Cwx1A4tUIuXY9e6sH59G9kxTUNs0uCYY0SkNkId6hQO8CsKT1/U/FYeX6003jiSQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4AfKzgNB/u0sCxgDLs2dvhvmY2hfnG1js86WzUwnio=;
 b=SF/IvbXIdEpDCWqyrOCJnHtm136zqTiC6x3zWSMXqk/Pb94FNGel1PQqUo7vCRUSdWCb9ZvDqu3d7RiSMZDOmu7BIEM8Njgb7IsFBZUT92G/PYN92SY085DZT9yMic23EsStDoXGdaylx/n/2fVy2R0LJzgXOiyZE6ZIgqvS30HqTBj+pdMLpIMFWjyf/e7WaFXvBlm7hP3r1WhUlua9O1Os4fjZDM6qA+ZgzWF/h5+WVo0n0ZZUwY9+YC36Imqx3q+QV1PhMYcuU4RrS9g9MVyExBVpaBMuZ2hocYZOaWqbPTL4wQ2XdPDU+fux/RgGP3vcapChj7lZu7ZXil2TqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4AfKzgNB/u0sCxgDLs2dvhvmY2hfnG1js86WzUwnio=;
 b=kkQmSJzVbrsXOmtj66gxrDA5N3q4ykkWCv0rDFkm2ZPBDrVc5gaSLpIr/bvoed94jzYlREyB9wNPvPYQRSYlUU/d5nQnHXOxPkNBFq7OM4Np73nL0O05b+AcQYXOrPZymiV4ZIS5F3jl5O6K0ABOapRKfM9U4s6NQxHeqO7Dm8+aFzjYXhuabebYmF0meMVlIuMRYQL8ghJZasBBGWavI+ucZKirqMmsmh9Xsm0nzs1XM3FR5eku5zMNqojRitbcIKxgRe0LJcsBQhcfVfMUZk2zrVfmn6FRjzRKBH+BLHyprlCcIMrJJDNUolRGeuKM8SqhqbRLds7tkgIFCopyRw==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 DM6PR12MB4636.namprd12.prod.outlook.com (2603:10b6:5:161::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.19; Thu, 10 Mar 2022 05:59:40 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627%6]) with mapi id 15.20.5061.022; Thu, 10 Mar 2022
 05:59:40 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     David Ahern <dsahern@kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Subject: RE: [PATCH v5 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Thread-Topic: [PATCH v5 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Thread-Index: AQHYM9U6k38KSCJk4UCVCeVEOorm0ay4D8GAgAAQgDA=
Date:   Thu, 10 Mar 2022 05:59:39 +0000
Message-ID: <DM8PR12MB54001673F48C4FE659A74FFEAB0B9@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20220309164609.7233-1-elic@nvidia.com>
 <20220309164609.7233-4-elic@nvidia.com>
 <2d4bc28e-41a8-c6ce-7d52-cb1d9f523e70@kernel.org>
In-Reply-To: <2d4bc28e-41a8-c6ce-7d52-cb1d9f523e70@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cfccd244-b9b4-424f-538e-08da025b2a3e
x-ms-traffictypediagnostic: DM6PR12MB4636:EE_
x-microsoft-antispam-prvs: <DM6PR12MB4636324A421773B905821E00AB0B9@DM6PR12MB4636.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4U5skTrelvepFkZ6MxttvGejIdGZDaPUKqKPJnQKHuI7K71975WnnARyX4twkuqNKWNyoJt6qjeJ+6WsOFlQnH4zO8Z6is4IAK6wnWHLjmA/b66epqUv1f0Nm240o/5V6mFAByOuBtq3rvYPNxqe536ckk7fL3YoYFSsYety1k90JrwuSYNnrNQgwgv2pD2gaMW9TjsWR5p82UXePu+ZGM9OocIOJwpuSVotI1oRpdTDD21XCPtjz9L7dplpDx+r0mQkdbrTwC6ag0rYCwwdmo0P5VnWuuToTANhFsEzso33LLkAe0x25vFPVTzQlBdjzH6m5PYXHdvVTSpmMvulAWAHrfd2DY9jdNSnZ3MgkF9KE4KP+tuCgamnEEFOTPXk9ZuNLj1qKftt8wdvcFbTOg6sq/z12xJK/nyXzzs3DrrnirhXfboZ9PUPzkUfFb12TihfZMCCcoH1dqefBs35VfULlKUJINdjWnQ1MLc0XEKdgYcelAc2RXf6W752M618P1UwRmnfDacZ+yzq90IU5COPQglebf0tBmaOlHgUkiwkAggBuWtkclYK97hRKp2thyHgl9mrTgCrVWhisdN/Oehcj9bu8ajER0ndpWa9fNBsTfqwvaj3JjVF4pJl/9VRkRmGa8424EM+4hYJf5RIK3K+o9wR5ECL6tp24TGK1BXeVeyHg4MyTUspRFp+M6jH2a1bOqEciroHJEAB85VA1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(2906002)(26005)(186003)(55016003)(52536014)(71200400001)(9686003)(53546011)(7696005)(6506007)(83380400001)(33656002)(508600001)(86362001)(107886003)(38070700005)(5660300002)(4326008)(76116006)(66556008)(66946007)(8676002)(54906003)(110136005)(316002)(38100700002)(64756008)(66446008)(122000001)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NmNteTNubnVTelpjcksvMVJEbXp2WWFrNUNlejJ6WVljYk5nZzFHdTE4TUpU?=
 =?utf-8?B?RlR6VHdzaG1iNDludUZIVlN5T0tNMmE1eWdubWFlS0xDZVJnVzRIVjVKNlUv?=
 =?utf-8?B?STVNbVBhbWkyL2ZCVS9EQWNoMUJwMGFCODlpRUlmZmdlQmsxUy85dU52R0hN?=
 =?utf-8?B?d09MdXNadkZRclpWM3VYSW5tcFNCSmI5OFRYVk96Zk1WYnJETW9uZSt5a0o1?=
 =?utf-8?B?Wmo3YnhaM0VTeE1pZXpQYVFZYjBUc01VNldlTWxObVBnQ3NlWkNUZXh6cnQw?=
 =?utf-8?B?UHdNalQrRGdtdUsvTjNLYXhLeUs5YS95UUxiV3FpRmxVN2YwOVN6bDRsZWRB?=
 =?utf-8?B?cXNQRk5lelpkTm95TVFzZ3FLcmJxQStEcjIwMmw0RXNSSGhkRnloOUFBdWFQ?=
 =?utf-8?B?S3ZuTHdhcVQwTVhyZEk1TXNmcDVXR2dPRmF3SFFMMTVYUUFTVlVWcnZsVXhD?=
 =?utf-8?B?QUxjZ1VOeDF1eUNrMXhhbmY4VUdTaFZ3MGZxVlJFdjVlTllrLzFMdVRNNFJw?=
 =?utf-8?B?YzdQRWovM3B2T0pqZ3FlWExtL0ZDcVVaaFBSRlFXUWhKM1NYVnRFd2xMOVB3?=
 =?utf-8?B?SXNFa2k0UTZ6aG5UZm0xNHV0WUxOQ0EwRVlSNEVFSHZqa3V6aUxSQzNOeFRJ?=
 =?utf-8?B?QUU5VXhtTWRwcGVtVEU0eVRKNmtDeEFmdWRPRzBzaTk1bDFvdVc1ZnBvSm1L?=
 =?utf-8?B?WmVpNldQMWtESnlrV0orajlsN3BJZno0MzBLNElSUkFkdHlFNXBXYUtMQzJi?=
 =?utf-8?B?RXRRZ3hWUm82WisrSHhHTWVuZ21pRnVFa2tUWkl1a1haMVBHQkZwQks4czhz?=
 =?utf-8?B?T2paekVHL0RoemZlVnZjQUVyTUhUbUplaWk3SmoyMjNwZFdWYVh3WGtvcXdP?=
 =?utf-8?B?dzlHakxFazNVM21GbjBXWFNQVG5jcEVObko5bmVxRmtpMmVURHJOQUg3SHVZ?=
 =?utf-8?B?c3RKcDJaSnhhaW4xb2JKVG5ZRnhiWXpVSnQrUjdjTjhNZzFMNTNIa2tDQ09Y?=
 =?utf-8?B?OFBtMldNcnFMZ3NDckRiaC9QazltaVd5OG8xck9JMFRvYk5qaGlraTZTeXg4?=
 =?utf-8?B?NWdOdnQ2VitCclZMUjd4MjJORzZYWlp4RWdSSGNHVWpXOVduV0Rsckg5dXFr?=
 =?utf-8?B?a01DK2QrT21reGVjNnNlM2JoOFRaOXVBUDNIZ0FxSFZ1MWIwTUJIUURGTVE4?=
 =?utf-8?B?SWp0cFFFVmc5WTZ3TDNpMnNZbFhqWi8valhzTnF3dEtJZERNOE5yN2ljWFJD?=
 =?utf-8?B?M0IwSDd3aXgvbDlFUXh0WksrVm5pTlo4MC9qcGJ0ZmJkNEozWEZuRjJvd1pQ?=
 =?utf-8?B?SEI0dXk2aWdCMnViZVY3cDhWNmpsUGhUU3cvcXZvYzRVcWhhMUExdm9tM1JG?=
 =?utf-8?B?UithOEhlcW1DdmQ0SERJUG1vazhybXNjSkduT1VrQXZmSjJPcWlNeWNGZ2F0?=
 =?utf-8?B?VHpiSkFzSGNpQ213dkpaUGU2bE9IVS9mRDhUL0swYStxOWF1U1dRUldyV2gr?=
 =?utf-8?B?L3NwdjRUYkgydGhoWDdoTUU3Ky9FUnUweXRuUy9hUlRic1RkUXVUMWcwQUpD?=
 =?utf-8?B?bUVkMnlzaFBEcFQ5VGplQXI3YWZRZ05FY2J5VzhObTN3OE5adWZuWlRJN0tP?=
 =?utf-8?B?SVJhWXdwNTZ4S2JYSTFUa1g1TytxMkdJeEZaall0M1hNUnRWOUV6VmxDMTg5?=
 =?utf-8?B?WVJGcEVBcVdwb1JGSnUrckxDMDlLZGVjOVcvWE1FRmhBaHFmdGpBVytYZ0x2?=
 =?utf-8?B?Y3pucWVDamZoSzV4cVltN09yb3h2VEdqVWgrTlE5Si9ndzQzV0pwdE9jVllW?=
 =?utf-8?B?YjVnUW02eVZuNVNvUzB3UTUvei9GeGZYYmVyQm15TzAzdkRoUm5qc08zWEQ4?=
 =?utf-8?B?aGtxZkNVVS9meTcvbjd2Uk5DSnF1clp2Rm44TzdZdHF3WG1OUlJHVUxhb0Nl?=
 =?utf-8?B?RTdMM2VHZHlOUTRDdHh2VUZtL2dWRDBjdk5WWFZzY1NSWWFubjFxT0FvYnpr?=
 =?utf-8?B?dTgrcTlmSGs3cFNDcXB3SHV5TWFOeGFhYkVuQUJGVXlXN0NjZ0RFSU8zeFRy?=
 =?utf-8?B?M0NuRzRoSks0MUkwSWZ3blgxRmk0L3libkt1UT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfccd244-b9b4-424f-538e-08da025b2a3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 05:59:39.9260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tyxHh0SDfvUSs5qJmw67EOIlXVGTyjwHbjMtPsVRBgfC/bapbv0ccxWZe9ciXrkn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4636
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRz
YWhlcm5Aa2VybmVsLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIE1hcmNoIDEwLCAyMDIyIDc6MDAg
QU0NCj4gVG86IEVsaSBDb2hlbiA8ZWxpY0BudmlkaWEuY29tPjsgc3RlcGhlbkBuZXR3b3JrcGx1
bWJlci5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHZpcnR1YWxpemF0aW9uQGxpc3RzLmxp
bnV4LWZvdW5kYXRpb24ub3JnOw0KPiBqYXNvd2FuZ0ByZWRoYXQuY29tOyBzaS13ZWkubGl1QG9y
YWNsZS5jb20NCj4gQ2M6IG1zdEByZWRoYXQuY29tOyBsdWx1QHJlZGhhdC5jb207IFBhcmF2IFBh
bmRpdCA8cGFyYXZAbnZpZGlhLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NSAzLzRdIHZk
cGE6IFN1cHBvcnQgZm9yIGNvbmZpZ3VyaW5nIG1heCBWUSBwYWlycyBmb3IgYSBkZXZpY2UNCj4g
DQo+IE9uIDMvOS8yMiA5OjQ2IEFNLCBFbGkgQ29oZW4gd3JvdGU6DQo+ID4gVXNlIFZEUEFfQVRU
Ul9ERVZfTUdNVERFVl9NQVhfVlFTIHRvIHNwZWNpZnkgbWF4IG51bWJlciBvZiB2aXJ0cXVldWUN
Cj4gPiBwYWlycyB0byBjb25maWd1cmUgZm9yIGEgdmRwYSBkZXZpY2Ugd2hlbiBhZGRpbmcgYSBk
ZXZpY2UuDQo+ID4NCj4gPiBFeGFtcGxlczoNCj4gPiAxLiBDcmVhdGUgYSBkZXZpY2Ugd2l0aCAz
IHZpcnRxdWV1ZSBwYWlyczoNCj4gPiAkIHZkcGEgZGV2IGFkZCBuYW1lIHZkcGEtYSBtZ210ZGV2
IGF1eGlsaWFyeS9tbHg1X2NvcmUuc2YuMSBtYXhfdnFwIDMNCj4gPg0KPiA+IDIuIFJlYWQgdGhl
IGNvbmZpZ3VyYXRpb24gb2YgYSB2ZHBhIGRldmljZQ0KPiA+ICQgdmRwYSBkZXYgY29uZmlnIHNo
b3cgdmRwYS1hDQo+ID4gICB2ZHBhLWE6IG1hYyAwMDowMDowMDowMDo4ODo4OCBsaW5rIHVwIGxp
bmtfYW5ub3VuY2UgZmFsc2UgbWF4X3ZxX3BhaXJzIDMgXA0KPiA+ICAgICAgICAgICBtdHUgMTUw
MA0KPiA+ICAgbmVnb3RpYXRlZF9mZWF0dXJlcyBDU1VNIEdVRVNUX0NTVU0gTVRVIE1BQyBIT1NU
X1RTTzQgSE9TVF9UU082IFNUQVRVUyBcDQo+ID4gICAgICAgICAgICAgICAgICAgICAgIENUUkxf
VlEgTVEgQ1RSTF9NQUNfQUREUiBWRVJTSU9OXzEgQUNDRVNTX1BMQVRGT1JNDQo+ID4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBFbGkgQ29oZW4gPGVsaWNAbnZpZGlhLmNvbT4NCj4gPiAtLS0NCj4gPiB2
NCAtPiB2NToNCj4gPiAxLiBVc2UgdTMyIGFyaXRobWV0aWMgaW4gcHJfb3V0X21nbXRkZXZfc2hv
dygpIHRvIGJlIGNvbnNpc3RlbmQgd2l0aA0KPiA+ICAgIGF0dHJpYnV0ZSB3aWR0aC4NCj4gPg0K
PiA+ICB2ZHBhL2luY2x1ZGUvdWFwaS9saW51eC92ZHBhLmggfCAgMSArDQo+ID4gIHZkcGEvdmRw
YS5jICAgICAgICAgICAgICAgICAgICB8IDI3ICsrKysrKysrKysrKysrKysrKysrKysrKystLQ0K
PiA+ICAyIGZpbGVzIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+
ID4NCj4gPiBkaWZmIC0tZ2l0IGEvdmRwYS9pbmNsdWRlL3VhcGkvbGludXgvdmRwYS5oIGIvdmRw
YS9pbmNsdWRlL3VhcGkvbGludXgvdmRwYS5oDQo+ID4gaW5kZXggNzQ4YzM1MDQ1MGIyLi5hM2Vi
ZjRkNGQ5YjggMTAwNjQ0DQo+ID4gLS0tIGEvdmRwYS9pbmNsdWRlL3VhcGkvbGludXgvdmRwYS5o
DQo+ID4gKysrIGIvdmRwYS9pbmNsdWRlL3VhcGkvbGludXgvdmRwYS5oDQo+ID4gQEAgLTQxLDYg
KzQxLDcgQEAgZW51bSB2ZHBhX2F0dHIgew0KPiA+ICAJVkRQQV9BVFRSX0RFVl9ORVRfQ0ZHX01U
VSwJCS8qIHUxNiAqLw0KPiA+DQo+ID4gIAlWRFBBX0FUVFJfREVWX05FR09USUFURURfRkVBVFVS
RVMsCS8qIHU2NCAqLw0KPiA+ICsJVkRQQV9BVFRSX0RFVl9NR01UREVWX01BWF9WUVMsICAgICAg
ICAgIC8qIHUzMiAqLw0KPiANCj4gcmF0aGVyIHRoYW4gYWRkIDEgdWFwaSBhdCBhIHRpbWUsIHBs
ZWFzZSBzeW5jIHRoZSB1YXBpIGZpbGUgYWxsIGF0IG9uY2UNCj4gaW4gYSBwYXRjaCBiZWZvcmUg
aXQgaXMgbmVlZGVkIHdpdGggYSBnaXQgY29tbWl0IG1lc3NhZ2UgYWJvdXQgd2hlcmUgdGhlDQo+
IHVhcGkgZmlsZSBpcyBzeW5jaGVkIGZyb20uDQo+IA0KPiA+DQo+ID4gIAkvKiBuZXcgYXR0cmli
dXRlcyBtdXN0IGJlIGFkZGVkIGFib3ZlIGhlcmUgKi8NCj4gPiAgCVZEUEFfQVRUUl9NQVgsDQo+
ID4gZGlmZiAtLWdpdCBhL3ZkcGEvdmRwYS5jIGIvdmRwYS92ZHBhLmMNCj4gPiBpbmRleCA1ZjFh
YTkxYTRiOTYuLjhiMzRlMjkzOTRiMiAxMDA2NDQNCj4gPiAtLS0gYS92ZHBhL3ZkcGEuYw0KPiA+
ICsrKyBiL3ZkcGEvdmRwYS5jDQo+ID4gQEAgLTI1LDYgKzI1LDcgQEANCj4gPiAgI2RlZmluZSBW
RFBBX09QVF9WREVWX0hBTkRMRQkJQklUKDMpDQo+ID4gICNkZWZpbmUgVkRQQV9PUFRfVkRFVl9N
QUMJCUJJVCg0KQ0KPiA+ICAjZGVmaW5lIFZEUEFfT1BUX1ZERVZfTVRVCQlCSVQoNSkNCj4gPiAr
I2RlZmluZSBWRFBBX09QVF9NQVhfVlFQCQlCSVQoNikNCj4gPg0KPiA+ICBzdHJ1Y3QgdmRwYV9v
cHRzIHsNCj4gPiAgCXVpbnQ2NF90IHByZXNlbnQ7IC8qIGZsYWdzIG9mIHByZXNlbnQgaXRlbXMg
Ki8NCj4gPiBAQCAtMzQsNiArMzUsNyBAQCBzdHJ1Y3QgdmRwYV9vcHRzIHsNCj4gPiAgCXVuc2ln
bmVkIGludCBkZXZpY2VfaWQ7DQo+ID4gIAljaGFyIG1hY1tFVEhfQUxFTl07DQo+ID4gIAl1aW50
MTZfdCBtdHU7DQo+ID4gKwl1aW50MTZfdCBtYXhfdnFwOw0KPiA+ICB9Ow0KPiA+DQo+ID4gIHN0
cnVjdCB2ZHBhIHsNCj4gPiBAQCAtODEsNiArODMsNyBAQCBzdGF0aWMgY29uc3QgZW51bSBtbmxf
YXR0cl9kYXRhX3R5cGUgdmRwYV9wb2xpY3lbVkRQQV9BVFRSX01BWCArIDFdID0gew0KPiA+ICAJ
W1ZEUEFfQVRUUl9ERVZfTUFYX1ZRU10gPSBNTkxfVFlQRV9VMzIsDQo+ID4gIAlbVkRQQV9BVFRS
X0RFVl9NQVhfVlFfU0laRV0gPSBNTkxfVFlQRV9VMTYsDQo+ID4gIAlbVkRQQV9BVFRSX0RFVl9O
RUdPVElBVEVEX0ZFQVRVUkVTXSA9IE1OTF9UWVBFX1U2NCwNCj4gPiArCVtWRFBBX0FUVFJfREVW
X01HTVRERVZfTUFYX1ZRU10gPSBNTkxfVFlQRV9VMzIsDQo+ID4gIH07DQo+ID4NCj4gPiAgc3Rh
dGljIGludCBhdHRyX2NiKGNvbnN0IHN0cnVjdCBubGF0dHIgKmF0dHIsIHZvaWQgKmRhdGEpDQo+
ID4gQEAgLTIyMiw2ICsyMjUsOCBAQCBzdGF0aWMgdm9pZCB2ZHBhX29wdHNfcHV0KHN0cnVjdCBu
bG1zZ2hkciAqbmxoLCBzdHJ1Y3QgdmRwYSAqdmRwYSkNCj4gPiAgCQkJICAgICBzaXplb2Yob3B0
cy0+bWFjKSwgb3B0cy0+bWFjKTsNCj4gPiAgCWlmIChvcHRzLT5wcmVzZW50ICYgVkRQQV9PUFRf
VkRFVl9NVFUpDQo+ID4gIAkJbW5sX2F0dHJfcHV0X3UxNihubGgsIFZEUEFfQVRUUl9ERVZfTkVU
X0NGR19NVFUsIG9wdHMtPm10dSk7DQo+ID4gKwlpZiAob3B0cy0+cHJlc2VudCAmIFZEUEFfT1BU
X01BWF9WUVApDQo+ID4gKwkJbW5sX2F0dHJfcHV0X3UxNihubGgsIFZEUEFfQVRUUl9ERVZfTkVU
X0NGR19NQVhfVlFQLCBvcHRzLT5tYXhfdnFwKTsNCj4gPiAgfQ0KPiA+DQo+ID4gIHN0YXRpYyBp
bnQgdmRwYV9hcmd2X3BhcnNlKHN0cnVjdCB2ZHBhICp2ZHBhLCBpbnQgYXJnYywgY2hhciAqKmFy
Z3YsDQo+ID4gQEAgLTI5MCw2ICsyOTUsMTQgQEAgc3RhdGljIGludCB2ZHBhX2FyZ3ZfcGFyc2Uo
c3RydWN0IHZkcGEgKnZkcGEsIGludCBhcmdjLCBjaGFyICoqYXJndiwNCj4gPg0KPiA+ICAJCQlO
RVhUX0FSR19GV0QoKTsNCj4gPiAgCQkJb19mb3VuZCB8PSBWRFBBX09QVF9WREVWX01UVTsNCj4g
PiArCQl9IGVsc2UgaWYgKChtYXRjaGVzKCphcmd2LCAibWF4X3ZxcCIpICA9PSAwKSAmJiAob19v
cHRpb25hbCAmIFZEUEFfT1BUX01BWF9WUVApKSB7DQo+ID4gKwkJCU5FWFRfQVJHX0ZXRCgpOw0K
PiA+ICsJCQllcnIgPSB2ZHBhX2FyZ3ZfdTE2KHZkcGEsIGFyZ2MsIGFyZ3YsICZvcHRzLT5tYXhf
dnFwKTsNCj4gPiArCQkJaWYgKGVycikNCj4gPiArCQkJCXJldHVybiBlcnI7DQo+ID4gKw0KPiA+
ICsJCQlORVhUX0FSR19GV0QoKTsNCj4gPiArCQkJb19mb3VuZCB8PSBWRFBBX09QVF9NQVhfVlFQ
Ow0KPiA+ICAJCX0gZWxzZSB7DQo+ID4gIAkJCWZwcmludGYoc3RkZXJyLCAiVW5rbm93biBvcHRp
b24gXCIlc1wiXG4iLCAqYXJndik7DQo+ID4gIAkJCXJldHVybiAtRUlOVkFMOw0KPiA+IEBAIC01
MDEsNiArNTE0LDE1IEBAIHN0YXRpYyB2b2lkIHByX291dF9tZ210ZGV2X3Nob3coc3RydWN0IHZk
cGEgKnZkcGEsIGNvbnN0IHN0cnVjdCBubG1zZ2hkciAqbmxoLA0KPiA+ICAJCXByX291dF9hcnJh
eV9lbmQodmRwYSk7DQo+ID4gIAl9DQo+ID4NCj4gPiArCWlmICh0YltWRFBBX0FUVFJfREVWX01H
TVRERVZfTUFYX1ZRU10pIHsNCj4gPiArCQl1aW50MzJfdCBudW1fdnFzOw0KPiA+ICsNCj4gPiAr
CQlpZiAoIXZkcGEtPmpzb25fb3V0cHV0KQ0KPiA+ICsJCQlwcmludGYoIlxuIik7DQo+ID4gKwkJ
bnVtX3ZxcyA9IG1ubF9hdHRyX2dldF91MzIodGJbVkRQQV9BVFRSX0RFVl9NR01UREVWX01BWF9W
UVNdKTsNCj4gPiArCQlwcmludF91aW50KFBSSU5UX0FOWSwgIm1heF9zdXBwb3J0ZWRfdnFzIiwg
IiAgbWF4X3N1cHBvcnRlZF92cXMgJWQiLCBudW1fdnFzKTsNCj4gPiArCX0NCj4gPiArDQo+ID4g
IAlwcl9vdXRfaGFuZGxlX2VuZCh2ZHBhKTsNCj4gPiAgfQ0KPiA+DQo+ID4gQEAgLTU2MCw3ICs1
ODIsNyBAQCBzdGF0aWMgaW50IGNtZF9tZ210ZGV2KHN0cnVjdCB2ZHBhICp2ZHBhLCBpbnQgYXJn
YywgY2hhciAqKmFyZ3YpDQo+ID4gIHN0YXRpYyB2b2lkIGNtZF9kZXZfaGVscCh2b2lkKQ0KPiA+
ICB7DQo+ID4gIAlmcHJpbnRmKHN0ZGVyciwgIlVzYWdlOiB2ZHBhIGRldiBzaG93IFsgREVWIF1c
biIpOw0KPiA+IC0JZnByaW50ZihzdGRlcnIsICIgICAgICAgdmRwYSBkZXYgYWRkIG5hbWUgTkFN
RSBtZ210ZGV2IE1BTkFHRU1FTlRERVYgWyBtYWMgTUFDQUREUiBdIFsgbXR1IE1UVSBdXG4iKTsN
Cj4gPiArCWZwcmludGYoc3RkZXJyLCAiICAgICAgIHZkcGEgZGV2IGFkZCBuYW1lIE5BTUUgbWdt
dGRldiBNQU5BR0VNRU5UREVWIFsgbWFjIE1BQ0FERFIgXSBbIG10dSBNVFUgXSBbbWF4X3ZxcA0K
PiBNQVhfVlFfUEFJUlNdXG4iKTsNCj4gDQo+IGtlZXAgdGhvc2UgbGluZXMgYXQgYWJvdXQgODAg
Y2hhcnMNCg0KQnJlYWsgdGhlIHN0cmluZyBpbnRvIHR3byBsaW5lcz8NCg==
