Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6466ECBB3
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 13:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjDXL72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 07:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjDXL70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 07:59:26 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3D7DB
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 04:59:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kR1ZvVwwY4QocBa/w5A7POMgMTKKiZRq0xvNJqbBrqSKzxQvTmq12tOzQDxT4RhNDflzevr31RTwOBNCYxZ1jaCMoXB9Ve6q9437xuzQ5cmn+3xyJcr9rz5rZOo+kRpJWB/zhbjNDwRXwUD4K/GvXVvPqEYYwnlJVzq+fVS3vXTuHGnHvQvwoqR3hg81FfAKxZIptc1nPcp2CN/Yx4gccPdsrmPiROVQ/gTHPzumt6H0HlfdZcJJbomEasACkLYDFKBcy61PbOKAypCmIzRa0mKSrTaj65qv1cL4mBQjushtoBKCvkuwaaeLDWsuF4tQCZt3F4V+69Cvl4TrPO8Ofg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPtNablAvzoDq88+t1KO1WDci5MsodtSSSN+JNwW/NA=;
 b=CuOQmK5es2RZZcIlteqisTH0YJut7Fjz0acdd9jbkw9Bnsb+OileODiqiA91sSDDpbSbpT3C/nG0Wra/ihKp5ydKsysrKyMKQPHyP2QrWoys6hscFFZUqNTOPhhJqldqmBe05YkmGEJhuOFYbj3gYjWnakbiUgI63SSIYeyLvqUwaPlUefqw9bMoW7XMKFfcMSYBu7ohWxdY8FsfS1A5Vm3O7L5G/ez3yaquHd5rKBITFfRah8vehefJmfvs7qX53btpPulFmHJaZ0YcHdEU4Am1bAa5ubnmkzAsnPR9fimTdAL0mto3LNhWf7qv5O+tEf3c6a62XeSwqEnzSdJS9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPtNablAvzoDq88+t1KO1WDci5MsodtSSSN+JNwW/NA=;
 b=Xpy57HY1t3SbHiP5DamnQ0ZITmHlgi9ouDbDQizJPTo6po/ipBPMTxVsWQdmPpo7BJ2sAvs6mmrIbI4b9gP6j3J4imeNDrpSBj/f7aTIgEhlB2dkCMxVFIKuWh3OTfVqjg9uUAQfG9NrC1Ki+Mh/Yb5VUb0EJNkOZ997iGlRFc1PBViQIcEYuuheStnNmMqMcSZEwW8keFQQPu2d1XNOScBv4M/rCfVnAI+1PMiTFwnGvr0TzitRgc3ULtpZBCvz2Luny0ReR6StKyyk9C1NFB5RdwiDLTXexP/Tn5ZRw2d7T9wHpuq2cszHzNruohREvFqQQfA6aWPki1SzGEvlbA==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by CH2PR12MB5514.namprd12.prod.outlook.com (2603:10b6:610:62::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 11:59:22 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::9e8a:eef5:eb8a:4a02]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::9e8a:eef5:eb8a:4a02%6]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 11:59:22 +0000
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "saeed@kernel.org" <saeed@kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [net-next 11/15] net/mlx5e: RX, Hook NAPIs to page pools
Thread-Topic: [net-next 11/15] net/mlx5e: RX, Hook NAPIs to page pools
Thread-Index: AQHZc/IoM404MZM9zUmQz34Z3V2pk681BcgAgAVavIA=
Date:   Mon, 24 Apr 2023 11:59:22 +0000
Message-ID: <b8d13df786ea392b5337e0080bc9eaedffa95fef.camel@nvidia.com>
References: <20230421013850.349646-1-saeed@kernel.org>
         <20230421013850.349646-12-saeed@kernel.org>
         <20230420191318.1d332ebb@kernel.org>
In-Reply-To: <20230420191318.1d332ebb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|CH2PR12MB5514:EE_
x-ms-office365-filtering-correlation-id: e30755b3-68b2-44f4-c7b8-08db44bb57ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: elOtisWrrE+t8TeI1+nyvKQPdonQRhqACKQZNteeEPYfrlUGtrpVm3xCL3I0BlinRj7tvfU799TnR3F3+WZkNvGYT0M/nr2oyCyr9GIz53hUY7YeKuG/fr4v1As+WLm37nTYQGQaJeG/d0lFmmuE8rCM8e5vB8em1OvbQkJsWCYUlWxMV9/5zxLswoYnpWXo8Aeam2gwmslnWM2qwE/fcZn3o0hMwUQ43kMijvzZHLRLIl00twlulBH6jwC3WCQx99/uqEpPB5q+rRc0MmsR8y58vn31ITwvm3RxoB+ja2zJ7HRcVBYS0zZ0Npp8sT9jhbvUD0RyHlZWbbDJOR9FxKlV3YaNgdmkBJGDh9gGVki3TOKUzXxk4tP2Vccgayf9gjw1HzrBZGgAIMJr2efvInKJuL8GGoKfpPTqkorlLGtJHg2ZRBAY+kF3+O4XxkdYfp/GUSDsLXlmlyf1KQDu510vvB6Uz9dzRAGTLs4fnCQckO9BAAMu8R8Y2F6xAc4BGpZcbKGsIu3BrJg4NvJoWJrTWDH+b3ig1wHR8S0CT2EndTQbzq31Z5hAbZQKRaaIc6zsa/bDTr09I8FwILIEVC83cNKuvfyMIelqqPJ7hIROV/zHSzCA9Gb6tXXaX+yRjkKyTjj3MjqHIk1V1HuMt1yM+8AxPKS4rjyEt7ZwvvA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(451199021)(2906002)(71200400001)(6486002)(966005)(2616005)(6512007)(6506007)(186003)(91956017)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(8936002)(316002)(41300700001)(4326008)(478600001)(5660300002)(54906003)(110136005)(38070700005)(38100700002)(122000001)(36756003)(86362001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnEyY29wMU1aOGpzczhRUVRkVnhtOW5WNzNSdHpMSW5uZVY1OVNyOUF3L0h1?=
 =?utf-8?B?TWgzZXVkR00xTXNSV3pVc0ZWcENvTCtWQitlVndSVk1KMUwzVzhXd1YwNUsz?=
 =?utf-8?B?QzZCRGVOcEhWcFFGKzNLSGpzREJaT1lrUU9NL3o3NmhXa1FZcy9lbG1KOUJV?=
 =?utf-8?B?YzNsdDViZm5CdFF4OWFSZU45bWtPRnk1NGd6cWN3R2hFNXU2d3ZXOW5NWW1O?=
 =?utf-8?B?QnFvKzNTVjJZOExZZloxa3BuczFLckFhRmpEbE4xdlVkUk1EdkF3Z1VGTk13?=
 =?utf-8?B?TjlGTUxkZjN1YkRHem1BOXlveW5aK1ZLMnA5Ry9lUzVlRGxoVTVmU0g1VkJQ?=
 =?utf-8?B?dEVuWkpsa1FSdHJiYWtYR01nSllGcEoydDJaYWl0NzFPQ1dWaHl0QzFqRmlR?=
 =?utf-8?B?ZndBOFQrSCt3aENoL0JDbVRoa0lXc3Myby9HT0ZMQnZDMVo4YmJuRDN6YzdH?=
 =?utf-8?B?MlpCWG9MNHFwZDhqOFZ6WXZLYVdVN1JmdytDNUcrdnd4WUJFaWZ6MGNGTG5D?=
 =?utf-8?B?YUY4bkFLeGVOWG9sdk5YZnFSNEJaeC8xL0g1ajRvUjFvM2dBdFh0UUtrTU94?=
 =?utf-8?B?aS9aVDBxWjNyQ3FrMys3ajN4SXdpclVRSWtmTm9VaGkyOGl2U0pOclQ2OGNN?=
 =?utf-8?B?WWw1UkpuL1ZwcDZpaWlLeUVjSElLeFp5eUFPMDE2UkZtRFBvaElBeWw5bXN5?=
 =?utf-8?B?aFF6MTN5K2l1MXptbFIzZkNibGsvck1ETU1xKzZKMURRSHlJMEtmaElGVVdG?=
 =?utf-8?B?V2RSanRPUXh2cUgyaUwzVWkxWVYvVmNxOWt3dFk3QmV0cmRRWUJtM3MzZ0tv?=
 =?utf-8?B?b3l5eXozVmRsYXhHS2Q4YlNSSXVYajd2anlNRmVmWnhCTmIxV3A1NVdlb1lv?=
 =?utf-8?B?c1ZDcWo4ejdOYW5KUWpXZkJNQkRGZnh2Wng2WGxsN05JTHFxMlR2eURRVzZR?=
 =?utf-8?B?cUs2dHRMVHgrbTZPcGNUaFltdjdtakZsRjdIQy9OZ2lZTnhwSEtPUWFHV2Jv?=
 =?utf-8?B?NTEyTTFmWWI4Zy9mTnBaZURlRXJuRUg3cjBHVDFNZ0tMdDRDQkdvcGhHZUd0?=
 =?utf-8?B?REFCeDBYVG9vR0h1UGJ5eU9TTk02dkdMNnpZbGtBVHQzT3VwVnZNMWpZaFNw?=
 =?utf-8?B?ZjBrZCtoTlNCbWx3QUd6NEFPRkhzMmhwV21rY3Q0NFJOTndva1VhSG9JOEpE?=
 =?utf-8?B?WFdzakZOK0tlQTdKKzN4ZHd1aHlsZmV5RndCNytSTXkzYjZGdE1tQi9BWE5h?=
 =?utf-8?B?Y3g1RUtucVFubGYyVXB2SGpScEhiWlBlallWdjlEVVYyMWttT0JxSW8yNEQ3?=
 =?utf-8?B?Z0dHR0hGQldIMjNHY0lja1d1UzRVdWZ5eFZsb0RDNmVOTU1YamYrYXpaNEE4?=
 =?utf-8?B?TlJLSzRNTUZJSzc3V3U2SmNOTGk1V1dmTGJmR09JUy9yREdERmpaSFlqdlpj?=
 =?utf-8?B?bWoyb2F5aVlOT1FUUjZlaXhMMUJ2OTl6VzdKanJqUlJDSVlxUDNrSDhoVi9p?=
 =?utf-8?B?eFJLZFRzb2tEMHNsQlZlMGJZdTRud0d6TUkrbGN0NElSV1VBQ1lOa3Rna3hD?=
 =?utf-8?B?bFpuczlYaDV3Zk1CeFhYNmN3Y0tYd2hidFJ0Q2k5SndQTWVZMGVSQldacVRK?=
 =?utf-8?B?anZjM2VTZWRkQ1I4QW1IbHh6YWpEQVE3NS9ScnJTMlRyVTkvbzhrRmJ0bFVG?=
 =?utf-8?B?N2ZjdGdqUFZCRFhCdEZ1LzB5eFZFY0l4R01TT3Ezcm5PcU1Nb0hObTdsbmtp?=
 =?utf-8?B?amg2NUV6RkkwM2prNUlHczNmUDJFT0V0UHFQU0NnYkpJb1E3ZUxsNXJuV3ZR?=
 =?utf-8?B?UVJ6cjBPWnNqUE1LSGNtejNpNURCME9PVjJpZm5PZlVpNFUzT05aNlZBMzh4?=
 =?utf-8?B?ejFLckI5K0t2VitPb2JteEEweDlaU1ZrdVJJOUZKSnFpSVhMNnhzVXRDbW1p?=
 =?utf-8?B?Tno1WkVjQmRzNFNaWkFlc3FaaHhhbExHcmlEa2o1VCt4ZEJES0dKZld3K1NH?=
 =?utf-8?B?Ny8vVVg1WjRrTXR1TllzMUI3VkF3aTRWRHJvRVJYdTBJOUVSTEczTW1kY2VJ?=
 =?utf-8?B?bHBCcWFYRXJIWWdHWkQzQkVEaDBtMnFCclIxVjBRQlZ3UmpOVjBVKzNBa0lh?=
 =?utf-8?B?aG9CcUdJcGU1cncyNmZObzZtRmlnb3NxNE45eTgydmZyM3JyVSt2Vyt2RytU?=
 =?utf-8?Q?UFFVYo9D1qzrsVhrnpms30AlCKsLqUDGDwVQZKCdZtp2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <77EDBA93D4694B4EBC5905E051F72C7E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e30755b3-68b2-44f4-c7b8-08db44bb57ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 11:59:22.5310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PwILXSeD6H/RdemyJuYryJGrp1kViOrsMJzLwp1CINzJWItbx28o1uv+ph611vRONZD8HftvkxkLE3f9CCYvcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5514
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIzLTA0LTIwIGF0IDE5OjEzIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAyMCBBcHIgMjAyMyAxODozODo0NiAtMDcwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBGcm9tOiBEcmFnb3MgVGF0dWxlYSA8ZHRhdHVsZWFAbnZpZGlhLmNvbT4NCj4gPiAN
Cj4gPiBMaW5raW5nIHRoZSBOQVBJIHRvIHRoZSBycSBwYWdlX3Bvb2wgdG8gaW1wcm92ZSBwYWdl
X3Bvb2wgY2FjaGUNCj4gPiB1c2FnZSBkdXJpbmcgc2tiIHJlY3ljbGluZy4NCj4gPiANCj4gPiBI
ZXJlIGFyZSB0aGUgb2JzZXJ2ZWQgaW1wcm92ZW1lbnRzIGZvciBhIGlwZXJmIHNpbmdsZSBzdHJl
YW0NCj4gPiB0ZXN0IGNhc2U6DQo+ID4gDQo+ID4gLSBGb3IgMTUwMCBNVFUgYW5kIGxlZ2FjeSBy
cSwgc2VlaW5nIGEgMjAlIGltcHJvdmVtZW50IG9mIGNhY2hlDQo+ID4gdXNhZ2UuDQo+ID4gDQo+
ID4gLSBGb3IgOUsgTVRVLCBzZWVpbmcgMzMtNDAgJSBwYWdlX3Bvb2wgY2FjaGUgdXNhZ2UgaW1w
cm92ZW1lbnRzIGZvcg0KPiA+IGJvdGggc3RyaWRpbmcgYW5kIGxlZ2FjeSBycSAoZGVwZW5kaW5n
IGlmIHRoZSBhcHBsaWNhdGlvbiBpcw0KPiA+IHJ1bm5pbmcgb24NCj4gPiB0aGUgc2FtZSBjb3Jl
IGFzIHRoZSBycSBvciBub3QpLg0KPiANCj4gSSB0aGluayB5b3UnbGwgbmVlZCBhIHN0cmF0ZWdp
Y2FsbHkgcGxhY2VkIHBhZ2VfcG9vbF91bmxpbmtfbmFwaSgpDQo+IG9uY2UNCj4gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvYWxsLzIwMjMwNDE5MTgyMDA2LjcxOTkyMy0xLWt1YmFAa2VybmVsLm9y
Zy8NCj4gZ2V0cyBtZXJnZWQgKHdoaWNoIHNob3VsZCBtZSBpbiBtaW51dGVzKS4gV291bGQgeW91
IGJlIGFibGUgdG8gZm9sbG93DQo+IHVwIG9uIHRoaXMgdG9tb3Jyb3c/DQoNClRoYW5rcyBmb3Ig
dGhlIHRpcCBKYWt1Yi4NCg0KVGhlcmUncyBubyAic3dhcCIgc3RhZ2UgaW4gbWx4NSAodGhlIHBh
Z2UgcG9vbCBpcyBkZXN0cm95ZWQgd2hpbGUgTkFQSQ0KaXMgc3RpbGwgZGlzYWJsZWQpLiBTbyBJ
IHRoaW5rIHRoZSBwYWdlX3Bvb2xfdW5saW5rX25hcGkgdGhhdCB5b3UgYWRkZWQNCmluIHBhZ2Vf
cG9vbF9kZXN0cm95IGlzIHN1ZmZpY2llbnQuDQoNClRoYW5rcywNCkRyYWdvcw0K
