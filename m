Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0251660E00E
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 13:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiJZLw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 07:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiJZLwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 07:52:55 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37184A7AB2
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 04:52:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rf9A0iZuEfJIjHMtoJyeH4fIvmM780VciZibrBFCtOjKNfOYYVyIXuu/Ixyo2WQevhm++j8/OEUd4TBQrqdwv6Qwrr+cPhyprsM9yMRR7JuFuVCBiaYLQGtyOqOFmU7+6zxVwNaPqJvReKReXgg7paJNDw//kfdsqInWhC9lXlWKMpE4/VXdoQd3mM6WesZV3zoFEhafbBoI3qlSdWSM8VDqTq9JNwPLc+wvXKT/a9hATeV8xMbm8lm6geZ4gMtxdqM3CtHHe2ir5stGzyK+eUmEu79Z1XUcCTQ801ZKa7sJ4yy6EutPT9QPEdFBDFZclRh7l3COlMoi85gwadOOEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qMcadjS9/OLpP08UdjP96esSZlMI7fryV3ALsvTnq10=;
 b=czxZbkfj13OFeEmR109jjYO4uA2rA067miHzEHe97DateWQWNAQHR/06ATSb811Tx4abwOUoEDUXjaLxpOmCOT2z3BdOdSwvsc7IFz+ckg2/AhdePqY5nvpYr6C6sG1W9JA99a5xM/9gwbld1yWTBac4dAHGI+us/PUSqJ6xn3zHq9S8GpVBpA8GAC5RZJz10Siul2BxSWGb12ZRZEELE+LUegvokouvWBXqdtCv29GNaNd3eOtx/8eIjFXD1KH0Tz7L3UaYwZiwuJc/nQanP6/o4XowivyV99JWH9G98ENHnQQEgOoj5terHVMajh4L5l7L6AZZg8Ce0M5tYeXDng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMcadjS9/OLpP08UdjP96esSZlMI7fryV3ALsvTnq10=;
 b=oc50cA6jZnlMJxFtdUhaBo7YgMvjR7jj3xo1BUBKg+fSE5nB61E3IA4V/VLp60FaBhZeRVfrvmnpHL69VTIcpjnOUKyiM0qiTib2RL/kHdMJKrRJ4PsRO/n1uG01wmyk6q6vqtbIjkdf0u/8tmQR/3qK/VTnApGo4lv2iuBkDQLFwbECGM4JjpG+pFZDM3BEvggO9dx5Evw0kkCMXV9z7RNr81Ur307kXd4P9ZRTggwrl4y9sD+C3hJcrxFgA0g1GdoDsYOV/nbsyoGD3TgCUAW2IRAlOptHZKD/ULtCT/bG4ogUOQ2zKMNiEiPILTLdxqVm2g+Vbv6mVZmv8RsgTg==
Received: from DM6PR12MB3564.namprd12.prod.outlook.com (2603:10b6:5:11d::14)
 by SA1PR12MB5640.namprd12.prod.outlook.com (2603:10b6:806:238::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 26 Oct
 2022 11:52:53 +0000
Received: from DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::76e5:c5e9:d656:b0d7]) by DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::76e5:c5e9:d656:b0d7%7]) with mapi id 15.20.5723.029; Wed, 26 Oct 2022
 11:52:53 +0000
From:   Shai Malin <smalin@nvidia.com>
To:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Aurelien Aptel <aaptel@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: RE: [PATCH v7 04/23] Revert "nvme-tcp: remove the unused queue_size
 member in nvme_tcp_queue"
Thread-Topic: [PATCH v7 04/23] Revert "nvme-tcp: remove the unused queue_size
 member in nvme_tcp_queue"
Thread-Index: AQHY6Hol/pxgny+zOESMfOrEJsXCfq4fSNMAgAE7HwCAAAdNYA==
Date:   Wed, 26 Oct 2022 11:52:53 +0000
Message-ID: <DM6PR12MB356483814D8B7D3498A157C5BC309@DM6PR12MB3564.namprd12.prod.outlook.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
 <20221025135958.6242-5-aaptel@nvidia.com> <20221025161442.GD26372@lst.de>
 <4a721959-c3c3-4377-d1e3-7fa7d6c3e814@grimberg.me>
In-Reply-To: <4a721959-c3c3-4377-d1e3-7fa7d6c3e814@grimberg.me>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3564:EE_|SA1PR12MB5640:EE_
x-ms-office365-filtering-correlation-id: d44d1330-96ed-43c4-e45b-08dab7489d6b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bqIuqe1Vvcsh9/X/BqyBhNlEsnDp7IzrDb/K7f81FaCqKwp8GoCykLRjA+A1Sz/DykdcPgkk2nyA18vVVNVOGPhur//DM5qq2iogcDjObNIKb1S5yyqKhCqQUOjwZ8/m9V3Y2K5PSHIAy5+5MEQw32TtRHlltKc86fSTlXI7eDgQM4rGfmWNYFf4HLqDHH+cDPvTMWC/9XKbcZMogKMr1ALeWpH7bSgg4IVvewvk/r0s/65/mOcBAdUUcANgjPpwoMRD4nMdLclArXLf8j+asGV15rItbXadvZL75g2PR2+ZZ1tzBF3gp1GF81EuZamEilcNGsqtHkakFoGsr/7jj063e9igyHzzYLhjRGY1oDtkfR67m+YK7HKpayo0NWT5faWqebAlBd47Q1uTZSuWT1WH7Qj9PXhONYtgXDkJ99UYe815uERkn1yfpmrIDRZnykEqqqVFPJGG7mBt34qMjJcqOqnPp7U6DuNgLcuBIo+RucpulGM+kiKYdIcUaTKRGuihlsZNv++tcnRqeaiNFHXiRkgKB6HHcfimAWso7M3jOpw6H/H6S+29MpJh+rgD0HHEn1CAZ/VpcqeHrX5t7v4INT/r/kpTy+sF+zcMHyur7gZX8fCY4SIk1cKaNNDKfgWsKN+eo1BP/34/Q705ay0h61R3PbZWIcBhD8ICdKLxuDilPID4Gw51lNdj7gaPLi3lI8AbMZu0NskzI8919kmAw8nmDhAsnvx6/UhPhy0gk9AbvXRfx3amTpb8qy7Uo93SYydRV84uAnA8NJ8Pag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3564.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(451199015)(33656002)(86362001)(122000001)(38070700005)(64756008)(83380400001)(38100700002)(4744005)(9686003)(7416002)(5660300002)(26005)(55016003)(76116006)(2906002)(186003)(7696005)(6506007)(6636002)(52536014)(110136005)(66476007)(8676002)(41300700001)(54906003)(71200400001)(8936002)(66446008)(4326008)(316002)(478600001)(66946007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2oydnhkYW80RkM0azU3S2cyQ0YyVm40L2pEd2NsdStyWlZ0bElrMWFSWEJS?=
 =?utf-8?B?STB5aEc3U1V3Y3JRWVZDUGVYbS9wazd0a0pockhsa1dHZHJPR1FYUlFUL2pS?=
 =?utf-8?B?YytpVU50U0J4Y05KTmRPQ1RxeVZ2cmt4K0wzZnBGVFNWL0gzRkRzSFhycjRR?=
 =?utf-8?B?TEQxeDZwRE43Sjd5STliV0Y0STFYbjhFanV1MjlRM1YvM0FFN3BtbEZPTzcz?=
 =?utf-8?B?eUdTVWs0dDlEY2hpdzQ0UEhVQ2laMU1maG5VZkVUc3BsNTMzRGIvTlhCWnJ3?=
 =?utf-8?B?SytVV1dXMTFESk1PS25qZDYxQWRKdWh3UERBTnlkQnVmWmRqRzBEcy9MOTZR?=
 =?utf-8?B?M1lYcldLY3h3LzBXeUJ5TFd0NC84UHk1OG1ZS2hhTm9TY3N5a1VuOGtNdm1V?=
 =?utf-8?B?amJXcHAxVGh4Y0Y5bTZpYmRwMXBFOHU2NDYvVTVEUVJ4RVFINkxLR1Z1c1Bm?=
 =?utf-8?B?cHp6VVBIazhsb2lqRmxIakc4TGFlN2dqQndkNHV3azZ5ZTBXWFNrUnlIWUxT?=
 =?utf-8?B?Q0QrbXlKWGg2Szh3cjVVT2RwRTd4Z3Z3TGNMZWlCSy9RaGRndGFZdjUvMHpL?=
 =?utf-8?B?MWFlbzBZUEZHanpWT3ZsMkt3QUN6RklJVnNnNzN5UE13bUtScGdGeHJxQ2tQ?=
 =?utf-8?B?SzU3OWtZWTYzVzlvWWQzYWdLSmREbmg2cHFrZ3dxckNBcVpaaEhqY0JZN0RM?=
 =?utf-8?B?UFRIL1oydUw5N3Voa1FYNW9ZbSsxSmdXcW8wdHBnMnY3dHdMZ3duYnB1a2c3?=
 =?utf-8?B?ZzdsNTR4dEVvNjNML21tKzNKYkFmelppNEFjMEE0ZG4vcU9BTk5sTVFGQ3o4?=
 =?utf-8?B?VUVZSUNMdGI3UU1VSGpnT3pQVjRRempGNkEyb3pxbEZMZTdaNVVndnV2YWVB?=
 =?utf-8?B?dTBPMmhmZUxJWEZwVm1JVzViVi81V0tWWWVJUGc5RWNvQVBrbG9zTGw4bERH?=
 =?utf-8?B?VFVUOGwwS0EwWXlHU1MvUU00VmRJQjJucENmQ05qZHh4SDlubmJwVGVBUWxl?=
 =?utf-8?B?K1c1djgyMlZ1anRWbUxaWEpXb29qMkpWeG9BUVpBUHhiQ25PRG1pMzFHRmlP?=
 =?utf-8?B?MFBSRkllcFhtTUVlejR3bEl4Z2R0NWo0aUh5WlZWTVFYNDJ3eDNhWHV4OGJk?=
 =?utf-8?B?YUMySlFkZG1VeTVrZnVEUjI0VEdzRGJjN1p0MEd6OU1tTEhsZ2Rmc01FNmRn?=
 =?utf-8?B?UkNxM2hJRnVObnFiOXhQYVBjMGl4MGZzdW01SmFZWE5TVXZaVnEwVzNyRmti?=
 =?utf-8?B?dlZEY1dZTVJvTUdaZmJNaTNxdjI4d1R1RllPajR4N3ZKZWs3OTlWdjJUQ3E3?=
 =?utf-8?B?TGFEUU5ZU1kvK2VNbytadEQvTFhBanMrei9LQithTkdyeFJJNytodmx0MDR6?=
 =?utf-8?B?a2JzZ1YwdjNvd3RsOHVtODRDN2JBMmVkYTkweXFNclVjdC9uME5nQm16aEtm?=
 =?utf-8?B?SERTNWtOWE96dmM3Skw2aHgraGQ2UUJpQmRGR1dnV1p1WTUyL0JpTHBLc2hZ?=
 =?utf-8?B?UExURCtOUWFCbC80YkNhKzBEdDZJR3ZIVFAwSEhBc3JzbVprVG80VlpUQWFE?=
 =?utf-8?B?ZDB1aUl5QkpoUTJ1VXhSdmRVY0NxT1Z6VS9vUEljeFFYdm1GanhSL2wyMnNx?=
 =?utf-8?B?dlFQRU5iaXlBR0djQ05FcU9yMDVzOCtrZWxmNWpnNUVNY0RGcDgrZWZaZTk1?=
 =?utf-8?B?ajRRK1RqK2hxYWxCZDM2MUlEWHpqN0UyaHc0c1JjUVlXUmV2RGFQSnZxbngw?=
 =?utf-8?B?VE1HQm1Vb1YydWpzL1U5aUc4bEwzNWt3bStFNERJMFpxbTdDRE1xdS8yZmll?=
 =?utf-8?B?YURZQyt4bE5jbVFJYjVqQ3JySmRsRGVXSWgzZzZxNEhwMHREVkxibzRCSUsw?=
 =?utf-8?B?bHgzVVMzQmM2YkVtRmYxZFNKemRyQ3BqRUFIWjA5YlJhUVl6WUozNk45ejFx?=
 =?utf-8?B?V0MyRlpxakV5ZEt1Y09tSCs4eVVnajgzQzh2Q2c1dHkvUjRjbXRjalpmRVhl?=
 =?utf-8?B?TjNpTWYyMlIxQlN6Q2NFbTBia3V3eEROV3kyYVptVWc3Tk4wOVkzdnVWdG1J?=
 =?utf-8?B?R0RTSG4vRVViakJpNFA0N1FZSWp1OStDcHhuZm0zTGtLVXArRGduWkFWeXFi?=
 =?utf-8?Q?kpcl9EP8h+olZlaxlHbPRMAss?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3564.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d44d1330-96ed-43c4-e45b-08dab7489d6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 11:52:53.2812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W7ck/eQaMUTe5MOJyRaWVzvk8VuYbB3jtVl+gpDZE5y4JqbLxO/3rFyIxybsDWsAO3l67kCvJuc5wtx2YG/mkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5640
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyNiBPY3QgMjAyMiBhdCAxMjowMiwgU2FnaSBHcmltYmVyZyA8c2FnaUBncmltYmVy
Zy5tZT4gd3JvdGU6DQo+ID4+IFRoaXMgcmV2ZXJ0cyBjb21taXQgZmI4NzQ1ZDA0MGVmNWI5MDgw
MDAzMzI1ZTU2YjkxZmVmZTEwMjJiYi4NCj4gPj4NCj4gPj4gVGhlIG5ld2x5IGFkZGVkIE5WTWVU
Q1Agb2ZmbG9hZCByZXF1aXJlcyB0aGUgZmllbGQNCj4gPj4gbnZtZV90Y3BfcXVldWUtPnF1ZXVl
X3NpemUgaW4gdGhlIHBhdGNoDQo+ID4+ICJudm1lLXRjcDogQWRkIEREUCBvZmZsb2FkIGNvbnRy
b2wgcGF0aCIgaW4gbnZtZV90Y3Bfb2ZmbG9hZF9zb2NrZXQoKS4NCj4gPj4gVGhlIHF1ZXVlIHNp
emUgaXMgcGFydCBvZiBzdHJ1Y3QgdWxwX2RkcF9jb25maWcNCj4gPj4gcGFyYW1ldGVycy4NCj4g
Pg0KPiA+IFBsZWFzZSBuZXZlciBkbyByZXZlcnRzIGlmIHlvdSBqdXN0IGJyaW5nIHNvbWV0aGlu
ZyBiYWNrIGZvciBhbiBlbnRpcmVseQ0KPiA+IGRpZmZlcmVuZXQgcmVhc29uLg0KPiANCj4gQWdy
ZWVkLg0KDQpTdXJlLg0KDQo+IA0KPiA+IEFuZCBJIHRoaW5rIHdlIG5lZWQgYSByZWFsbHkgZ29v
ZCBqdXN0aWZpY2F0aW9uIG9mDQo+ID4gd2h5IHlvdSBoYXZlIGEgY29kZSBwYXRoIHRoYXQgY2Fu
IGdldCB0aGUgcXVldWUgc3RydWN0IGFuZCBub3QgdGhlDQo+ID4gY29udHJvbGxlciwgd2hpY2gg
cmVhbGx5IHNob3VsZCBub3QgaGFwcGVuLg0KPiANCj4gV2hhdCBpcyB3cm9uZyB3aXRoIGp1c3Qg
dXNpbmcgZWl0aGVyIGN0cmwtPnNxc2l6ZS9OVk1FX0FRX0RFUFRIIGJhc2VkDQo+IG9uIHRoZSBx
aWQ/DQoNClRoYW5rcywgd2Ugd2lsbCB1c2UgY3RybC0+c3FzaXplLg0KTm8gbmVlZCB0byB1c2Ug
TlZNRV9BUV9ERVBUSCBhcyB0aGUgb2ZmbG9hZCBpcyB1c2VkIG9ubHkgd2l0aCBJTyBxdWV1ZXMu
DQo=
