Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279ED4BA880
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244437AbiBQSjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:39:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244424AbiBQSjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:39:24 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90082.outbound.protection.outlook.com [40.107.9.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C903F8BE;
        Thu, 17 Feb 2022 10:39:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQbkQ1lwUaSku7lcPRogGhMGEJBcSogLFRr9Pc09s0eVFlpW4GbuVMQSiMZauKDuy9iiabwtZg7Y1JOD+qoezv1Xg2YRl3raUsBXc2W1654e5MUh51KLy/YsM84Y7wkDuseXoO81PdQ9uN2mprZIXsy2wbRARetIqOLKjb5MI7JrZkYJpxrNt0JpGQILijYUKSBb8iOOtShU0lFB58dVKB/QrPV50tc/SVCdPV0a/j9ZRQDaveBUmRIwwEt5c0rFV5H3HiaFPTnjH4xET2NS70Nm0a+ugONm1eSOMHgYZ22uurWJIakyo2A/UNhU8fEdrocGQKUptDv5aVEYRqe9fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRmUWfrnDqacKXYglhCsag48kS3zXqfJpbAmi/Fl9EQ=;
 b=SzAF58NiOj2zo0UhwcjpOmMVc+3ohEQWOneSWa9fHxYPPK55qmYNEF5FoHbuiho1op6qfPrpeETzvr0i3ET6/8bmqg8wRgRjk/Mk6nsoRZCpnzRRbIxnhMyeKaNSUdfSrg6dQ9EEXaYogVHlVgJw0urtuQwW01SGd2SheYt4/A/Py7/GuJFR05c2bO1tJRmRBgUQ+DuhOlhO7bpn45XcC+0IAm+TXFtxc+i1Zl2yQWm7lqQ7CNkb9Bw0qbSELfil+yGnN1jCgHSs1ozDB7xGNmcSwoIdWY0X6y2Mbn1SroqnloEQAWq38xvoFx5MK9TEP4MZPcGsb/S0KwgCnpDRIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3d::7) by
 PR0P264MB3578.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:162::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Thu, 17 Feb 2022 18:39:07 +0000
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::3d8b:a9b5:c4cc:8123]) by MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::3d8b:a9b5:c4cc:8123%8]) with mapi id 15.20.4995.017; Thu, 17 Feb 2022
 18:39:07 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: Re: [PATCH net-next v1] net: Use csum_replace_... and csum_sub()
 helpers instead of opencoding
Thread-Topic: [PATCH net-next v1] net: Use csum_replace_... and csum_sub()
 helpers instead of opencoding
Thread-Index: AQHYJBU4T77afu4me0W/yCcZHdgWLqyX/lUAgAANNACAAADEAIAABtEA
Date:   Thu, 17 Feb 2022 18:39:07 +0000
Message-ID: <a7fe3817-a9ed-fb48-c3ab-1d17e8961e7f@csgroup.eu>
References: <fe60030b6f674d9bf41f56426a4b0a8a9db0d20f.1645112415.git.christophe.leroy@csgroup.eu>
 <20220217092442.4948b48c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <13805dc8-4f96-9621-3b8b-4ec5ea6aeffe@csgroup.eu>
 <20220217101442.0a2805b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217101442.0a2805b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc7b201e-7545-469b-26ca-08d9f244c7a4
x-ms-traffictypediagnostic: PR0P264MB3578:EE_
x-microsoft-antispam-prvs: <PR0P264MB3578D21935A344D9CEB3D8F6ED369@PR0P264MB3578.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UCPc8tEOgAwu3+heGjXXe1wSS1L3ivK9LgLEn+JYhtrjZhacu5LKlVF3fKC2SaEwr1/0DacCDQTsWOVV4PyAsyYbHZbJGGU/LPV5B6664TRvbsJQqojBsoHzJxCo2P/ZopM3NdzDxnxAZvOhjI1c0xid+2pSVMVViYOvDJgWyG2dTJicdAyNjsbeWKEXLz2BfA24J7Fofw6J5i4hmqRaXlHAvfECnJRQDEfFN3yh7eXIGc0kjiJT50ABf9Nc+f5NKY4OdlKmLnj2td4iCJNXdN5fd6Bc6q665TYpjGgGUVYLpWEAO2yJrlBBxxTKuAhGx4zCyK5/pj1iCt6omIsbc/Znx8eIyQTumT3IdeZKfznYzdxOH17ZNlGOFGguc194/30qeE1l+MwlnucoPic60vOza6GtETVfUVxxAUmd19a3b/AO3thA4AE8anDJa52QfpArbvT8fygvYZue693iIc+zhuhtpaxQ5V9QfO6PnyOQEVctZ1noUSCAA8vBkk/M8nrj2V8OIKJZPfVeBxqumJglh5ugpWevovT5Sj+bthPuh4EWg6vF9FRvUacnF8p/lkgJ6rtM0FHD92F2kJCzBz5KcbCF65Lj+gmfgNS3ZyjvBAnhOBypWcJqvmclu9n/rVMVTI4kjOQ9ixHWw1gYGGhv1sgLGW9tVrvcNqvaPbbNPcIgCFHwIn94MYL18hTyTYoLZ1I6RNsApbxYQ7fhv4eNHKn6g7VtG1RHnRPubwoT185TIvDu4/8MR5D4OqNEy0TUgaAkGjqT/StSincHpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(36756003)(6512007)(71200400001)(31686004)(508600001)(2616005)(6486002)(8676002)(44832011)(6506007)(38070700005)(2906002)(5660300002)(66556008)(4326008)(122000001)(31696002)(66476007)(8936002)(4744005)(76116006)(66946007)(38100700002)(186003)(6916009)(316002)(91956017)(54906003)(66446008)(64756008)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UzBiaWhaMXgyWFdiSm1UY2VsaGx0TnZKbEVUVld4YjZCTVhzQnZ4OFNZdGZn?=
 =?utf-8?B?K1JGZnk0cFVZS0kxNGFBWFphWk5kT0x0YitHempqUytDWktTR0hTbVNLcWdN?=
 =?utf-8?B?eC9oOURiQmVrSk5xaGhyRHJzU3pUNlVCcjFkNWtPeSs0MzkrVXFUTlM0WGhK?=
 =?utf-8?B?dG1OUE1vd3BGeGpBeURUZHhqVjJ2bWZWanhFb2ptTlNhME15SnpmQmJnLzNn?=
 =?utf-8?B?aDdYSFREUDN3SWNkd0VTT2VUbnNJMXNVcUxjak9uQ091M0hxSGlPMmZiWGh5?=
 =?utf-8?B?dnRvYmR0VWVqbHYvb1BNZ3J0U3FZTDNuRGhJTFdRdjlYaWdBaWxRMDR0NkhJ?=
 =?utf-8?B?M0ZpQktURUFoREFiSGJUb3JiN3d0RU9oOWNVUUFqRGhiOXI1aWpHclQ5UjMv?=
 =?utf-8?B?YzNEakY5Y3Q0KzRqaEoxcW1ldGUrTmNwZDJ2cVJ4Sk9zZ1FjRXMxUlJCZXpp?=
 =?utf-8?B?c3FMRWxwcEVaYU8wcFplYW8zNEcvRmd2OU5zSVMwL2hHZCtCcTJtdkNZSkxz?=
 =?utf-8?B?YmRvWVo3TDJ1ZkR0Si9sMlp5S1dFRjFMdkc2bjJ0VGZ4UGpYa0NRK3VybkJ3?=
 =?utf-8?B?S3E1c0dHQjB1Z0tLSVJod3FDd1FINUFmUE5zWGY0SXcxT2o0RWlPRUtwZ2tQ?=
 =?utf-8?B?aTNHYTAxL01UN21KUWJwWnp5V2puTjlBZUJNVGNoSUdLbG5rR014ZEx3Mm9u?=
 =?utf-8?B?VUk3ZFdCWmVYNEVyVHJ2ZjVYTXkyekREbnhKN3czaTVtNXlETEJicmQ4WnBs?=
 =?utf-8?B?dGtqM081OER5cE5sbUhkWWFFTXVrMGE3R2MyeHNraWJuNEozdzNnNHRQWlg4?=
 =?utf-8?B?cFhZNU1iZUFmYzNqUkhGVkoxdmtHSnpyeDdjR0ZBcFBhd0kvS1VBSFFWRU5O?=
 =?utf-8?B?b0llZHMrQTF1NThnM2RMd3JmQ1V2U2NRWmQ2eFdsTjlXMGRKbXpzMHRyb0pD?=
 =?utf-8?B?OE5aNTRMS0l2N0s0YmQ4TzZJM1FzeEhTQjYzcUNScERlUXI1Zm9YajhzdUhQ?=
 =?utf-8?B?Q2ZxbmlSTHUyTHJLWXlOUkloU0FkOHYycXgzTytCWkZkalArcVdUdXgyRjZR?=
 =?utf-8?B?ZlkrQU4yUUdxTGxEM285cy9JWDZTL2lwNkszQlNHNWlqQXdmSkVGQVF1MXE2?=
 =?utf-8?B?aERuV0sxbEUvUDY4Z3VVZ3l5RVk2WStKanh4OXdGMENPZGdGcVdyZi9FeW1E?=
 =?utf-8?B?NDhnU0tndEU0VmlBMzZBcmhTckpBMmZMczF3cEQ4U3A2b1pnSkRndlg3Ujgy?=
 =?utf-8?B?djdDTEV1djlzL01mc3owQ1JXaS9aakxrKyt3dWcxQVlJWk5idXBZSGRJejNk?=
 =?utf-8?B?OTB5bXM0cU9sNnMvUlh4c0VZdXlNbXNGR28rV2xEWm84ME5NQnVtZGduQXdQ?=
 =?utf-8?B?MkNIZVlNdWtXNXM5cU41THU4SkxpUWExM1RqYms3MW1hTksxVXlHVlJTZWxY?=
 =?utf-8?B?ZzZPVGVkL01YOUM0N1N4R1ZJMGUySmtrRlVKZGQ3OEh1UHYvRU9nYkxkam9o?=
 =?utf-8?B?NU5EQlpibUk3WFJJZjYwVFF4NHh4SitpZDQ4R2RkSUd6RGFvSG1FdWpCUllw?=
 =?utf-8?B?QzFtRjlzTTFWRjdlYTJSWnl6MEd6bFB1NEZEMEh4Y0VXeDVJRVJGdVYyVFFW?=
 =?utf-8?B?OVUrdGxab0FJTWlQcnVlbDFaTnE5L0NJUVExUG9PczQyV3pWaUZ5OXJqSlc4?=
 =?utf-8?B?ZnloQVBVUFpKVDFRK0RPZWdKR2cvSjF4bHZ1K1dUOE5MYU1GRFI3UVViZUt1?=
 =?utf-8?B?RjIxNXo2dGdxM0ZoekZyaFZ6ZHdZNlVzTjJuN0hzRG9qREp1MGpOamFmSjky?=
 =?utf-8?B?MExlMGhOT3Rmcit4dGpwQzBHVUhiWkJ0MG13eDNOSFFsNVd6aEVFdk5IQ2pL?=
 =?utf-8?B?VmdvK25rbS9HNTd1N2kyNzdWcCtBZDVtZDc5NnFDVFVOSnFTbVN4b0Z0K3c5?=
 =?utf-8?B?RzhYdm1BTE5JZVI0aHdpbXJDM3VJdEk3VEpqMXM4MHFNL09wNFVtQStBWk5C?=
 =?utf-8?B?Y0FPeFFzeURsd0NKdVA2NW42WDNGRTUzMklQcy9VR0gzclNzOE9TeklzZ2Rn?=
 =?utf-8?B?Ri9qcml0VXh0U2F0TVZUU0d3WFhSVm9UY0J4LzB0VDd2VzM4VkJaeVovRmM2?=
 =?utf-8?B?OVE3bnF6QUpoejlKaXowekNtL09zbHNlMm5KK2pET2owbkNsNExkcktneXlu?=
 =?utf-8?B?Y2JzYm9wa1BSRjBNMjJwZEdoMkJrRjUyUU1iandONnpjM0lBOXdRMVlnMkJZ?=
 =?utf-8?Q?7pMGZlhwARPB1x20ZeztnnPA6+Qcs7mirC1o4MTZcw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC2FB14A49888C459FEC35AB0936ADAC@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: dc7b201e-7545-469b-26ca-08d9f244c7a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2022 18:39:07.0288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h609wBXg2cGKbeZMdVoPHzcZ/9qHI3bbHGq8dJgHwRxPfRGvAL/CmaT4XGu51ZeFIZprwiex8yotPsJ9NMRQ6ZnXgZY/qijNEM6shrtqrpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB3578
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDE3LzAyLzIwMjIgw6AgMTk6MTQsIEpha3ViIEtpY2luc2tpIGEgw6ljcml0wqA6DQo+
IE9uIFRodSwgMTcgRmViIDIwMjIgMTg6MTE6NTggKzAwMDAgQ2hyaXN0b3BoZSBMZXJveSB3cm90
ZToNCj4+IExvb2tzIGxpa2UgY3N1bV9yZXBsYWNlNCgpIGV4cGVjdHMgX19iZTMyIGlucHV0cywg
SSdsbCBsb29rIGF0IGl0IGJ1dA0KPj4gSSdtIG5vdCBpbmNsaW5lZCBhdCBhZGRpbmcgZm9yY2Ug
Y2FzdCwgc28gd2lsbCBwcm9iYWJseSBsZWF2ZQ0KPj4gbmZ0X2NzdW1fcmVwbGFjZSgpIGFzIGlz
Lg0KPiANCj4gVGhhdCBtYXkgaW1wbHkgYWxzbyBsZWF2aW5nIGl0IGluIHlvdXIgdHJlZS4uDQoN
CkJ5ICJsZWF2ZSBhcyBpcyIgSSBtZWFudCBJJ2xsIGRyb3AgdGhlIGNoYW5nZS4NCg0KSSdsbCBz
ZW5kIHYyIHdpdGhvdXQgdGhpcyBodW5rLg0KDQpDaHJpc3RvcGhl
