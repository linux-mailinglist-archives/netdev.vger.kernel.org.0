Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31D65B8857
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 14:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiINMgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 08:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiINMf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 08:35:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEF5AE76;
        Wed, 14 Sep 2022 05:35:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCczHCd8Hp5TQKHJu19GNJQp9Vg5xyBxsvSKBju5bcEkZWqMlBciOnvw/EE0p19NcFdvgXYEfSRxnbtAwe4bRXmvZx+Q6QveWD38Dy6+epDXkJ0O6O32a7DrF04SBoJR8142IVvSc5PbeVFeK5mm/xVmE7CMh79gNfduDkYrWN2Whjb0bnqoCc5XguhEtx7JoTUpKgybvOjhp8WEyX7UOkTTknJAd5mcl0aYfjfZE9alHyi9np2fg86bcOWvhPbG47aShHwDSSxiNItNFFGkxhSp6oAkFTXFeMOUeRnqPH2hm0mg/CFDxsch89BzY9NM5ObhPFP9tmq0+upxImkDIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W2fVgp/pIbEEVqZsNoHEbEMaKzxmfkYOw1Bj9NgJ1s8=;
 b=PD72Hirw31Fb4CfjgQ6sDIPV4uGL7GcVXAIWctHOeYlj8shWF5ZQUC/oADQXsmcj2lyR2jX+6o/KeJAIWCk9D20zkxrmvS54SOqwBdfoK4YDNOwisNDUX0gM35hXWftLDRC9bbaoeLNbkE3SXykq3j/e1Td+KqKpO3mpfRYtbjGw7n1TivKyB7JDkWiWtoWY4UcQ0GJM6F96P804xnUE2Usg/fgmZlvz7mQNc79DEwKRvw8FI+DMoBnokmKc4TWK7qK5Nac5psTfwtIOYNF4vUv9uk8tzJkcXAirXnJUdoEwwfEKxdkVjMkLk7eCknbI4ZoEjsnuezfaHMROmTVbrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2fVgp/pIbEEVqZsNoHEbEMaKzxmfkYOw1Bj9NgJ1s8=;
 b=qPn9dVXIHE9vKHD+SDHbaQR31xzWUHzVafzM1mxq98L6vqwrfk0FyXhVra+nS8MXysN22FcUjwPXas5bZOAvRVrN5qEbyruViy10x0CTlZI9jOAwICxpWRxpW5D0yQ7k5fcIJ14319JeKteVVBO7N0gpAV6JVe5fIhlHKSkSLP3mbTj0M0zwX44mFCb4s0BFw198tCcBy1AqExtGjI2apYFUFVJI7sWfdYETgKLFI71XROJRuOooAc2OttMn9KWO+y7YRtRbfUkJtf0pYGeaI4al7W+auJrz8B8get2TzYb4vrEshfUyjx8IUxSip26+/ac9MMa/EZeC8yPcrJqRdg==
Received: from DM4PR12MB5357.namprd12.prod.outlook.com (2603:10b6:5:39b::24)
 by DS7PR12MB5981.namprd12.prod.outlook.com (2603:10b6:8:7c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 12:35:54 +0000
Received: from DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::ec0e:6950:ee5b:8066]) by DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::ec0e:6950:ee5b:8066%8]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 12:35:54 +0000
From:   Raed Salem <raeds@nvidia.com>
To:     Yang Yingliang <yangyingliang@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH -next 1/2] net/mlx5e: add missing error code in error path
Thread-Topic: [PATCH -next 1/2] net/mlx5e: add missing error code in error
 path
Thread-Index: AQHYx31PPKeqcpdB3EaqdafynUUMC63e1Zqw
Date:   Wed, 14 Sep 2022 12:35:54 +0000
Message-ID: <DM4PR12MB5357FF348010A6436B77042FC9469@DM4PR12MB5357.namprd12.prod.outlook.com>
References: <20220913143713.1998778-1-yangyingliang@huawei.com>
In-Reply-To: <20220913143713.1998778-1-yangyingliang@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR12MB5357:EE_|DS7PR12MB5981:EE_
x-ms-office365-filtering-correlation-id: 38a853ab-a577-469a-8509-08da964daa96
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KJt/tJvplvehP1pvth7oR3uMva1hOocprlnpzDSt1DVtTI1XpRtlBE928tmEon8MFqyMfGpdvYDnRPLB3RsHi2woKHq5/xadCiCRxu79k0Uq4NKm7OxFtkIHluYIy3JB7AEPumMqf4y37+7M2GTssr56mPoG+mW65HlTguztVdnf3//fbq7qlSArY49F+4mQlLV76t+nUSleZU+6BGcfzG2LAwemLaKvmiAgrEAGtcodJfRV3UbTyR9r9735Fvxv9moP3/dIYJclzBKxXvF2EJW1OpQDDRbMa6CUvwhVX5tgOf0RRjMkCPVo+N+7b9B3NosJ2nUrSv4/I5SNyWA3bgYgmcMMoEsJydT5LpDvkkWSDbDheGLRHv057ZirxndCbC5SdpdBBJ37dFxdmlN4cLxii+4zpe4a5lJupwIlHYgQFRTjYFd2FzJE8rmXLL01aw6TcaGzP2rLlFbt4L6EsdqHokOc9CplYWj1gHZoT3LsQN8nRswtFfH5TtOmo+cYkmioG8V+x9lc1OL97BcF59bnHrbsu8QtX5x1wsLF5UUANYizKSofa3UNHHAh26Xc/6nsbLGiKx4+rWPoDZEOwX3hJpgUP6fJyjNzuc1SwaIsVp+d/UXuJdEGwzdt+D+YU/EBUU+f6m5oKuDx9V5xrEwjZ8/Yy6i/F4D6uyahbSKsiMZdPUcI5b0eBHyafENfNs+Okn3UbW7qZGEbc/aSD5aOQc6SHQz7qWeyqM8pyVRAJIBYx1Xqs7Mdo7T6ktPsoku95pPjRDa1aCSJp0YkJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5357.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199015)(110136005)(478600001)(66946007)(8936002)(5660300002)(122000001)(54906003)(2906002)(86362001)(52536014)(71200400001)(33656002)(55016003)(83380400001)(38100700002)(26005)(316002)(186003)(7696005)(9686003)(6506007)(38070700005)(41300700001)(66446008)(4326008)(66476007)(66556008)(64756008)(8676002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NXUvQ3k4UGVLNEpUMitmWkRiYmVnVXZudkxHdDJFdW5MQ2FHdjh6MFVSb1h4?=
 =?utf-8?B?TVpMbmMyYndMd0VjaWt1dk8rQVh2V0dVV1EzcCtmVFFkT0V1OXIyUlVRTWc5?=
 =?utf-8?B?SGcrWWFOMVBWVk9nSDZ6ekh0bkN2bFMrZ1pKMXgzUXk5UFlqMnkycThRVnBu?=
 =?utf-8?B?bEN5cGVNck41cEF0U0QvZEVsNHNHK2pNYi9zaUJmZEFGMU5JZC9maUdVSUYv?=
 =?utf-8?B?UmNWSHVMcWFUZ2djZ3hpcmZ0eTlCMUNIWlg0MTlsRkNBeFNlZDhranVLVDNC?=
 =?utf-8?B?QkpObVpvSi9jMHZsSG5yZGJMTFhWVjlJU1RlbndRa2F6T05zL1ZVemVWd1d3?=
 =?utf-8?B?MFQyMG01Tk1aZWhRM3pvRVpXVk9INllOQ1pqQ3JyVGN5ZXVJV29VL21Xd2Ix?=
 =?utf-8?B?Zk5yV0cwcW01aWkxV2F6bmNvMHNqWmh2ZXRrLzZBakdJMUdsaG1RSWUwVUNZ?=
 =?utf-8?B?cnN3UmQveXhoMjludk9nNk5NYSt3cy94VUtWaTNyS1lhbnFjLy9qTlB0S3ZY?=
 =?utf-8?B?a01QYTJuVktGa2VBVXBMK2hodGN3bWtna2pjWnJ3WlNuUHMzR0d6cjVuZlNp?=
 =?utf-8?B?aCs1d3dQYmxQNHkwU0FaeVFIL1V0VHBkbTRodE1xUThaL3VoRVNzZVpTOU0y?=
 =?utf-8?B?ZHJLL09uZ0ozTFBlQXFvWlBWRStvVVg4anRoZHU0aWpac3VIWVRVRUk1cFQr?=
 =?utf-8?B?cDFFSjZnSjFBMnJmVmxkQzlhY2h2S05TWS9Za3M1bThGa0FuK1NpQU1EckpH?=
 =?utf-8?B?VDdNTDV5b09VK0tyYWkzQWdwOFV4UU1ZcVFWZFQ3bU0wR2hBTy93c0xaNG90?=
 =?utf-8?B?am9UeHpZVXpCSGE2S2w2RDEyWlIxbkIzai81WGd2SEYvQVJtV2loRExzckZ2?=
 =?utf-8?B?RFl3dVVObzZJTTlqK0hQSm1VcjlHdU1WTXBDT2wvUkVHejc4bGd6dFI2alk0?=
 =?utf-8?B?Y3grdUdmZENaOE51M1c5S3VtcEJrMVNMWGZDM2NNemNRRmlSQ0N2U1ViMXZH?=
 =?utf-8?B?YWNPYTlkd0lhNUJxeHFyZE5nWmI0dVBWMFBXNWJGV3hrOG1XbjltTDFSOUln?=
 =?utf-8?B?SmR3Yk80UUlDeXJvZDBuSnc2WkNTY2h1SFljSSs1Sm9rcERHMTcyTEtpK0hC?=
 =?utf-8?B?ZkJhMzljUzQvd3hwZTl4bjNUSVZUQW9Bd3NtcHRXSjliOUdWRmg3aHQvb09j?=
 =?utf-8?B?UDEzK2NFQlJ2UGQ3VzF4WjkzK0Y3aGtEWmhETFQzSzZuazRSNjlTTDU4RVU2?=
 =?utf-8?B?ZXp6ZXNhS3Vtei92Q084c1F0WHlMR09VTklaNHNWeTlYYS9JU3UxeXF1UFJJ?=
 =?utf-8?B?NEkvVWRlQ2JBb1dJTm1HS0J1RUdrS2h1NFl1cThWdUpFbVAzWjhZYVhuaTJm?=
 =?utf-8?B?NzFHVTZISWFjQWdpQS9aSVArMTlzY0k4eDNKdEprSTNVakovR1FxM1VsVzZU?=
 =?utf-8?B?RnBxdDV5RHFnNk9CZlNHM3VwbDJURlVOYWRoRW1xRm9NR2JLNi9vV0lETkVa?=
 =?utf-8?B?d2dLTmdkV0hmWkN0UGt1czQ0ZTB3M0ROQXpWcGlZUEhaRXlydHBsWGdHODBa?=
 =?utf-8?B?QVY0eGc4bEgvcDJBNjI0c1lMNTJSTzBrd2p1MFdPbzcyY1VLTUQySnc2bkth?=
 =?utf-8?B?bkY2cUtWWWxaQmNjS0dIcHFGcEhYcGdPNXdSbC82dy9pNnBaMzhGOTkxM3NT?=
 =?utf-8?B?QlRKNHJsUHY3UjdiRmxJUWloMUtlcWVHQTZFeE5KR2M4UUpwdkdGMmNxV3B3?=
 =?utf-8?B?djRlR2RBem9HRGVieFNxOTY1U2JmSkpMajJ2TGx1dFVmMXlRNE5CSDlIWDJs?=
 =?utf-8?B?VFNLdEhyQ09HQnFIcXJOZENvVGtIY3NnNHQrNFpNcTY1Z2w2Sk55Rk1PU3ZM?=
 =?utf-8?B?ZHRXNHpjMTh3cXFsVld6SkF3a25WMC8vekphWGg0aW1RS3FkbUZ3aTNGcldF?=
 =?utf-8?B?QVhkY3gwaCtqUGE4SW1QTS9PZmNVUHVVSEcvZmhIb2labnEraXkzODBPVzNQ?=
 =?utf-8?B?dnlGdFR3UjIwVVY3emR1N29JVm94UFBVYjBkRGxvNlhVeUZQRHRNQ05oWnZi?=
 =?utf-8?B?b1JDcks2OG9UV0hXQysrR3RLMHJ3TmVZanF3YnA2bjh3U0tKUDBQQldsaHky?=
 =?utf-8?Q?s55o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5357.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a853ab-a577-469a-8509-08da964daa96
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 12:35:54.4361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SjNSrZKf84Stx0qEPs67NN8Xl3oT40gVMfVFF6K5GJHs873lArlPEh1VwG6EIChHKHYQ7KnJZCfhghzupwTbGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5981
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj5Gcm9tOiBZYW5nIFlpbmdsaWFuZyA8eWFu
Z3lpbmdsaWFuZ0BodWF3ZWkuY29tPg0KPlNlbnQ6IFR1ZXNkYXksIDEzIFNlcHRlbWJlciAyMDIy
IDE3OjM3DQo+VG86IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXJkbWFAdmdlci5rZXJu
ZWwub3JnDQo+Q2M6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbnZpZGlhLmNvbT47IExpb3IgTmFo
bWFuc29uDQo+PGxpb3JuYUBudmlkaWEuY29tPjsgUmFlZCBTYWxlbSA8cmFlZHNAbnZpZGlhLmNv
bT47DQo+ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldA0KPlN1YmplY3Q6IFtQQVRDSCAtbmV4dCAxLzJdIG5l
dC9tbHg1ZTogYWRkIG1pc3NpbmcgZXJyb3IgY29kZSBpbiBlcnJvciBwYXRoDQo+DQo+RXh0ZXJu
YWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4NCj4N
Cj5BZGQgbWlzc2luZyBlcnJvciBjb2RlIHdoZW4gbWx4NWVfbWFjc2VjX2ZzX2FkZF9ydWxlKCkg
b3INCj5tbHg1ZV9tYWNzZWNfZnNfaW5pdCgpIGZhaWxzLg0KPg0KPkZpeGVzOiBlNDY3YjI4M2Zm
ZDUgKCJuZXQvbWx4NWU6IEFkZCBNQUNzZWMgVFggc3RlZXJpbmcgcnVsZXMiKQ0KPlNpZ25lZC1v
ZmYtYnk6IFlhbmcgWWluZ2xpYW5nIDx5YW5neWluZ2xpYW5nQGh1YXdlaS5jb20+DQo+LS0tDQo+
IC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fYWNjZWwvbWFjc2VjLmMgIHwgMTQg
KysrKysrKysrKysrLS0NCj4gMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDIgZGVs
ZXRpb25zKC0pDQo+DQo+ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbl9hY2NlbC9tYWNzZWMuYw0KPmIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL21hY3NlYy5jDQo+aW5kZXggZDlkMThiMDM5ZDhjLi41
ZmEzZTIyYzg5MTggMTAwNjQ0DQo+LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuX2FjY2VsL21hY3NlYy5jDQo+KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL21hY3NlYy5jDQo+QEAgLTE5NCw4ICsxOTQsMTMg
QEAgc3RhdGljIGludCBtbHg1ZV9tYWNzZWNfaW5pdF9zYShzdHJ1Y3QNCj5tYWNzZWNfY29udGV4
dCAqY3R4LA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgTUxYNV9BQ0NF
TF9NQUNTRUNfQUNUSU9OX0RFQ1JZUFQ7DQo+DQo+ICAgICAgICBtYWNzZWNfcnVsZSA9IG1seDVl
X21hY3NlY19mc19hZGRfcnVsZShtYWNzZWMtPm1hY3NlY19mcywgY3R4LA0KPiZydWxlX2F0dHJz
LCAmc2EtPmZzX2lkKTsNCj4tICAgICAgIGlmIChJU19FUlJfT1JfTlVMTChtYWNzZWNfcnVsZSkp
DQo+KyAgICAgICBpZiAoSVNfRVJSX09SX05VTEwobWFjc2VjX3J1bGUpKSB7DQo+KyAgICAgICAg
ICAgICAgIGlmICghbWFjc2VjX3J1bGUpDQo+KyAgICAgICAgICAgICAgICAgICAgICAgZXJyID0g
LUVOT01FTTsNCj4rICAgICAgICAgICAgICAgZWxzZQ0KPisgICAgICAgICAgICAgICAgICAgICAg
IGVyciA9IFBUUl9FUlIobWFjc2VjX3J1bGUpOw0KPiAgICAgICAgICAgICAgICBnb3RvIGRlc3Ry
b3lfbWFjc2VjX29iamVjdDsNCj4rICAgICAgIH0NCj4NCj4gICAgICAgIHNhLT5tYWNzZWNfcnVs
ZSA9IG1hY3NlY19ydWxlOw0KPg0KPkBAIC0xMjk0LDggKzEyOTksMTMgQEAgaW50IG1seDVlX21h
Y3NlY19pbml0KHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2KQ0KPiAgICAgICAgbWFjc2VjLT5tZGV2
ID0gbWRldjsNCj4NCj4gICAgICAgIG1hY3NlY19mcyA9IG1seDVlX21hY3NlY19mc19pbml0KG1k
ZXYsIHByaXYtPm5ldGRldik7DQo+LSAgICAgICBpZiAoSVNfRVJSX09SX05VTEwobWFjc2VjX2Zz
KSkNCj4rICAgICAgIGlmIChJU19FUlJfT1JfTlVMTChtYWNzZWNfZnMpKSB7DQo+KyAgICAgICAg
ICAgICAgIGlmICghbWFjc2VjX2ZzKQ0KPisgICAgICAgICAgICAgICAgICAgICAgIGVyciA9IC1F
Tk9NRU07DQo+KyAgICAgICAgICAgICAgIGVsc2UNCj4rICAgICAgICAgICAgICAgICAgICAgICBl
cnIgPSBQVFJfRVJSKG1hY3NlY19mcyk7DQo+ICAgICAgICAgICAgICAgIGdvdG8gZXJyX291dDsN
Cj4rICAgICAgIH0NCj4NCj4gICAgICAgIG1hY3NlYy0+bWFjc2VjX2ZzID0gbWFjc2VjX2ZzOw0K
Pg0KPi0tDQpMb29rIGF0IG1seDVlX21hY3NlY19mc19pbml0IGltcGxlbWVudGF0aW9uLCBpdCBu
ZXZlciByZXR1cm5zIGVycm9yIGNvZGUsIGl0IGVpdGhlciByZXR1cm5zIE5VTEwgb3IgYSB2YWxp
ZCBQdHIsIHRoZSB1c2Ugb2YgSVNfRVJSX09SX05VTEwgaXMgcmVkdW5kYW50IGhlcmUgKHNhbWUg
Zm9yIG1seDVlX21hY3NlY19mc19hZGRfcnVsZSkNCj4yLjI1LjENCg0K
