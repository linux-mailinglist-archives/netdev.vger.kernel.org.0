Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A125B4D7E
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 12:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiIKKfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 06:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiIKKfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 06:35:36 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D151AF02;
        Sun, 11 Sep 2022 03:35:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCjk4HZ3rSVt8Rrd5w3gNRzFqB15rHzdxmgiB2ND/ea3VPmWosizpb6C2ELAhk62qe7+3ZKvPhSNqPDhMp0doFELXNPB/4boG2mEGk1ONaslY7XIN52OE07xp3azAFv4WB1MqJrjcO5XDVFasntBmAOAY//eoCeW5u89fMlRRmzakUcghukiIPkgKkzIWViYQfwDMwgwjH4veWpJrntOQgwiGvpWx37FhCpVtzMl07Gw/lHVp0KNgat+DVwgjcHQj1zy+g7z7seI5cC90cxKdGaNPJJAgSv/SmqqCIvP8Ce3XvNqpMOrhRDleVDXNTWE9UeYL0s7xuU7DYyJTRAg4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALWUua554sRjrpslyPaNuZ538fwIqVtJbNVtwv/4xfY=;
 b=LsSqaM/RxsLnMMDQAOPaYTqG2CYVFlhTS5xwgVt7siYgCm/QZ/uF007+YrYMuSeZ3m8PKa8ghLfrSdSj7h2aH7PBYvNFr6IOH52oA6Vd6sMYCu59JXuFey09nPeRzs4wu51BAVo7XwkyF7oCY9hfX5ZqlhnhZXdU4azY6hgNMM9D+YGcwD4Y1cSflmEtJ9B4XBjq/5pxMgAguZzNtzrDwU8fuB4patbqMFwGbEnEqudWHNikFSb3fNZNmpZSA8MI3d4c11hPb6dcIOiPqh+XbPzz+V0zGCEGaRsxhpBZWsDu+B18mx7dd5eGf8kb4yaayskZuh7TmYpcDs/Uz3kLuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALWUua554sRjrpslyPaNuZ538fwIqVtJbNVtwv/4xfY=;
 b=OznqQfQszAJnfmE+nqD4R2zsiujQgiFrxrL7kMW3DkmYL7JPx09eU2tXAd5S5a3u/khtqBuP2Kud/AZQfp7SahSIonpNN1SHN+AKKriADPCJ7dv31kecd0bBNJIjC2GrvLLuG2kfQmPRSkfICsXSqN6dR6CLFHlhkDZeyOZGekSKYVkdED4FwFogsUOFXSWj+jsg7jAKy8biJJthqofAXUHNS4kGN2BLpSorARhrJ/MNpAOMTrMxHiisD1F/cklWzN53m7sH8+gY5jiQ1PpBhn2v5XSWSjNmIm74yBoN4cYEEuVvjHrS7Hy6+q4f8UXfIDPp5cX8ZrleLAzocHk4iA==
Received: from DM4PR12MB5357.namprd12.prod.outlook.com (2603:10b6:5:39b::24)
 by PH7PR12MB7212.namprd12.prod.outlook.com (2603:10b6:510:207::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 10:35:29 +0000
Received: from DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::ec0e:6950:ee5b:8066]) by DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::ec0e:6950:ee5b:8066%8]) with mapi id 15.20.5612.022; Sun, 11 Sep 2022
 10:35:29 +0000
From:   Raed Salem <raeds@nvidia.com>
To:     Nathan Chancellor <nathan@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Boris Pismenny <borisp@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH net-next v2] net/mlx5e: Ensure macsec_rule is always
 initiailized in macsec_fs_{r,t}x_add_rule()
Thread-Topic: [PATCH net-next v2] net/mlx5e: Ensure macsec_rule is always
 initiailized in macsec_fs_{r,t}x_add_rule()
Thread-Index: AQHYxb1X1r5x049b50ev50nMoeRc9K3aCGEA
Date:   Sun, 11 Sep 2022 10:35:29 +0000
Message-ID: <DM4PR12MB535784B4F2F90DD3079E8F44C9459@DM4PR12MB5357.namprd12.prod.outlook.com>
References: <20220911085748.461033-1-nathan@kernel.org>
In-Reply-To: <20220911085748.461033-1-nathan@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR12MB5357:EE_|PH7PR12MB7212:EE_
x-ms-office365-filtering-correlation-id: 6564a143-b278-464b-57ac-08da93e158de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cHU9XvwAqTii8ffUbHekgYD1yWlB5AHQkUvyCMvzAhpzjVJaDo9X3jUJQFIcH/n0vyVHFG39dTEvyc/HMiiHdg6jGnYaH1zzGPbz0imfUli5bXTvseJQR2ZGL85PqPoq3HZeusRni1BhS8ifUmsnpqcGh5Urh3SPUUQ/2Cd+GpNVtxYkCO319zkplnCKsJQK+M7srAJgtEmF6DwZx5lTaKWb5CRZeEG61WfpRhCeN7Dv6+MUyMfDx/X+7imMq0MsRMs+Pn/3mJHKTUj7Y51BrbPGaP8pTimviTtPKyu8sJ2M9aojEGqfY4ZTXHT6NCB4NhsK9sKFGFxBiEVYAd65LZH59KL0eNRNHmHaR5HoQJc63831KhaQ2Nay0LfcSDugpT0ucFBhZNYCnk0LQEf6febmJ6qynUi/hM9ZVK/0FShkSQAkgsgCRo2jS3yJHUOtu5JAr5vN1DnJKBVeOWzZ62fItOtbry54qdoD30hsCj8AA9EfBJvZ0eQe8Gq1mxYfxUkG36oUG7L3uwqp+J1U3e9ZYVmqmiPmmJNAIUUDKJVI3Eo/Am0TojiXxd+gbgyPbeCa9geUumh3KP673AL1BIwtGiLD8TMnDIZfDA/iAcecvji6HdBje6jxcz/7zMqG69MRRuxXWVjM/9qCQbJeiquo9koIMy1qYjBd9ogYpfctH1gi6zLWWy8r4U/FoyqZRYev5QFxc3OCdfvgvcAFDgDNawBfWj0gtSj5IxIyYMyO72atmVBKnZyWutIMgV5yKBKhiv8aHSNKnQ/qcgPQscNIRsNiRTrclHBAote7Bp3LG1a85jSMS4i4XEkHhn2o1ZfAaBzLnteiR7B7S7jnrm4Kj71F3m+GKbbVBh/KzRR1k5gMw4UsWzEz3OGkQt/qfQuQrPWj3334uPkOGNKooA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5357.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(26005)(7416002)(9686003)(38100700002)(8676002)(76116006)(5660300002)(4326008)(86362001)(66946007)(66476007)(64756008)(66556008)(66446008)(38070700005)(110136005)(8936002)(71200400001)(52536014)(6506007)(966005)(316002)(54906003)(7696005)(2906002)(186003)(478600001)(33656002)(83380400001)(55016003)(41300700001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eS9UNnVLb0I4TmgzcVVHL0NUYXlDWmdLbFE4UmpHNFZ1L1ZQUnFNUjk3YytE?=
 =?utf-8?B?d1hNNVFzVndHa1RnbjdhLy9saWIxS0VLVTBCVzRkSkpJQVZsMjA0TjFmRENX?=
 =?utf-8?B?OGkzdURpVGx5aUM3a2dEMkZuMjFLWEZTbGlYRkxEMHIvbzJtVEp1Z0VkY2hE?=
 =?utf-8?B?WjBoZndnRlJoZ2hTWUptWGRsK0N0SEJ0VXF3Y2xaMzBHSTZOWktObmlnWkc1?=
 =?utf-8?B?OElHWGFaUnZkRnhMRkZtMDFNV3BsS3ZseUtYMUp1QXdQK2lZL1FSd2hZd2Rw?=
 =?utf-8?B?ZVN6aWhCTW15TEpsSjFKNTl6ZHFBbmRjTjZUSlU2dnduWS8wUUNUV1RzMURT?=
 =?utf-8?B?TWZCaU1GVUxTcy9HYnZPVHR3aGZHNDN5UzJabXNWZ21iM0RxMTNJNjdjeUsy?=
 =?utf-8?B?S1lUUnQ2aEpXTEFiR3h0dFRtWVJ5WWNWZVlsMENXZ3l6TldtVjNWUlRjYlRM?=
 =?utf-8?B?amorbUJrWVpPOU5rb056SEVxM3NUNkFJcE9zbmVQQ0dKa3hjaVFWVzQwRXBx?=
 =?utf-8?B?YVdtUmlWU2lzTlp1TkRsalQxZEtXckZjVXh6UkxLRTJGT04xU0RpaENxb1kw?=
 =?utf-8?B?dE5NTnpmZkY4dElYaklHbko0dXJydHVnc0o5MWxnWWJMeTNPcjRuK1pLOWxj?=
 =?utf-8?B?bzJ5K0Rld3VpOVFOK3k4Qm1MVzBzUDM1Sjdwb3ZiSkU4SXc2aFpUQ1dDblRM?=
 =?utf-8?B?US9za0lYdHlSR2cyd1hDRGQ5bk1lME1peFVuNXNPd0lWdW4wZzBUem1Qcjl4?=
 =?utf-8?B?UE1pSG8xTWpPWGtyMEoxYktEMkE2bDFNRnhFWUV3Umcwd0NRb1liL0hudUhV?=
 =?utf-8?B?YUhoc21FZzRWM1h3Q3d3T3kwb1JKc0JQd0g4Q0JtSUN3Q3NSc0JVQW10aU4y?=
 =?utf-8?B?VW1KT3BnemJNWGd6UGRxa1ZjUXorbmRteUlQek01MDlsOUdENmd5djV3RVo4?=
 =?utf-8?B?ekNCaEx5ZmRIVHBHRE1hMTNrelh4M2p6VFBhREtXSk54M0RSQmJvT2JIc3h1?=
 =?utf-8?B?R3lCdDRlOEhZYXd0SnBTL0YvUHZuMmhaM3JBcVFGM0IrTkpnZzBDSFdMQUd5?=
 =?utf-8?B?eUFMalVIRjh1T3NuOElYMmZQZGt6Z0JkRXI1R2NUMVZpcEMrb0RtcWtidDgv?=
 =?utf-8?B?NExsZDl0SVo1dVpocjVWY2MxNWJWMExQTWtvaTRKM2l4akN2amE2c292aWpo?=
 =?utf-8?B?ZjF1VXlzOVJxU3BESko1Njllc2ZNK0ZvKzVOYUpnNHlXZTVlcnoxcUc4alp0?=
 =?utf-8?B?L1pXbHpMMHJIK0NpVVNzM01mVkxmd0plU1ZmaTJwSkN1NWl4NUNyb3VYVXEx?=
 =?utf-8?B?c1lTWWZaTHcwSjQvenU4OXB5K1FpbzJ3eHRHREtFNnFXaVZiM3pxTG9pUFkz?=
 =?utf-8?B?TGY2SVJvVno1VG5KRWk2TFI4eU9xSTZ2cEZNYmtDbUk5Wjhobk5VYlJiaUtW?=
 =?utf-8?B?VFJ4T3ROaDdxZ0YyYzRrcWdXSWpFcENGWXA5a1VHeVdJdnlQSzNETGk3YTF0?=
 =?utf-8?B?U01ZU3FQMk1rL0lvVGxHL1c1dGhqR3BQOUM0K0JEMFUreWtsdjFNTGVzbEdH?=
 =?utf-8?B?MlppU0tkUFlFSWJDV1diM0N4b3dRMFVRM2FaNFZveUkzTmUzcExXYnhiUEM4?=
 =?utf-8?B?cHJTb3Vqc2hpZFcweUpFK3gweDB6QW9RS0NrT1RQQTVqV0RmNzgvN01hUWVR?=
 =?utf-8?B?R1BzQThwQU9iS1loeU5YclNvdDNTYlNqekV2K28zWE1pSmNQOG04Y2pUNEdm?=
 =?utf-8?B?eVZ3eWY3THN4UUU4MkJjMFdkb2NhdThXeXVNUGtkZ3lDcmFhRUFPeENhLzha?=
 =?utf-8?B?Yi9RWkNvQW94REhmSTdJTFBnWGwzQWdTaExselI2UERaZ1BmRjAxWW1IcThP?=
 =?utf-8?B?cSszN3JGRGV6VW5PdThKN3VBbC9UdEV5Sk43YXFiUkZKSGFVbnkxdDlHeVdi?=
 =?utf-8?B?QXhrSnFTeHlCWDdKMXpjdHpOVDRreUMzYjNDK0lqcmlrbmZnRTJ0ZUQyZFla?=
 =?utf-8?B?L0c3bDIrMWZHVGlRbm9tSWkraTM0NEpUTUdnREdCOGZjUWx6NWU5Y3prNlow?=
 =?utf-8?B?MXhKZGJFNUlnbjR5TTd0clB0NzNvcWRNajQyWmNzUlMydmlGSTVCSXdIWldh?=
 =?utf-8?Q?0Res=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5357.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6564a143-b278-464b-57ac-08da93e158de
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2022 10:35:29.3755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +p1iw/wG0dfFzT7kBpnrqauoqdXCTj757Z1aIEVfmQlZv4Iu1TChB7rU4mbBhBXp4A05lGWq+13vbyje1HHa2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7212
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IE5hdGhhbiBDaGFuY2VsbG9y
IDxuYXRoYW5Aa2VybmVsLm9yZz4NCj5TZW50OiBTdW5kYXksIDExIFNlcHRlbWJlciAyMDIyIDEx
OjU4DQo+VG86IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbnZpZGlhLmNvbT47IExlb24gUm9tYW5v
dnNreQ0KPjxsZW9uQGtlcm5lbC5vcmc+OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9m
dC5uZXQ+OyBFcmljIER1bWF6ZXQNCj48ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtpY2lu
c2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBBYmVuaQ0KPjxwYWJlbmlAcmVkaGF0LmNvbT4N
Cj5DYzogTmljayBEZXNhdWxuaWVycyA8bmRlc2F1bG5pZXJzQGdvb2dsZS5jb20+OyBUb20gUml4
DQo+PHRyaXhAcmVkaGF0LmNvbT47IEJvcmlzIFBpc21lbm55IDxib3Jpc3BAbnZpZGlhLmNvbT47
IFJhZWQgU2FsZW0NCj48cmFlZHNAbnZpZGlhLmNvbT47IExpb3IgTmFobWFuc29uIDxsaW9ybmFA
bnZpZGlhLmNvbT47DQo+bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtcmRtYUB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4LQ0KPmtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxsdm1AbGlzdHMubGlu
dXguZGV2OyBwYXRjaGVzQGxpc3RzLmxpbnV4LmRldjsNCj5OYXRoYW4gQ2hhbmNlbGxvciA8bmF0
aGFuQGtlcm5lbC5vcmc+DQo+U3ViamVjdDogW1BBVENIIG5ldC1uZXh0IHYyXSBuZXQvbWx4NWU6
IEVuc3VyZSBtYWNzZWNfcnVsZSBpcyBhbHdheXMNCj5pbml0aWFpbGl6ZWQgaW4gbWFjc2VjX2Zz
X3tyLHR9eF9hZGRfcnVsZSgpDQo+DQo+RXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5p
bmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4NCj4NCj5DbGFuZyB3YXJuczoNCj4NCj4gIGRyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9tYWNzZWNfZnMuYzo1
Mzk6NjoNCj5lcnJvcjogdmFyaWFibGUgJ21hY3NlY19ydWxlJyBpcyB1c2VkIHVuaW5pdGlhbGl6
ZWQgd2hlbmV2ZXIgJ2lmJyBjb25kaXRpb24gaXMNCj50cnVlIFstV2Vycm9yLC1Xc29tZXRpbWVz
LXVuaW5pdGlhbGl6ZWRdDQo+ICAgICAgICAgIGlmIChlcnIpDQo+ICAgICAgICAgICAgICBefn4N
Cj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9tYWNz
ZWNfZnMuYzo1OTg6OToNCj5ub3RlOiB1bmluaXRpYWxpemVkIHVzZSBvY2N1cnMgaGVyZQ0KPiAg
ICAgICAgICByZXR1cm4gbWFjc2VjX3J1bGU7DQo+ICAgICAgICAgICAgICAgIF5+fn5+fn5+fn5+
DQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fYWNjZWwvbWFj
c2VjX2ZzLmM6NTM5OjI6DQo+bm90ZTogcmVtb3ZlIHRoZSAnaWYnIGlmIGl0cyBjb25kaXRpb24g
aXMgYWx3YXlzIGZhbHNlDQo+ICAgICAgICAgIGlmIChlcnIpDQo+ICAgICAgICAgIF5+fn5+fn5+
DQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fYWNjZWwvbWFj
c2VjX2ZzLmM6NTIzOjM4Og0KPm5vdGU6IGluaXRpYWxpemUgdGhlIHZhcmlhYmxlICdtYWNzZWNf
cnVsZScgdG8gc2lsZW5jZSB0aGlzIHdhcm5pbmcNCj4gICAgICAgICAgdW5pb24gbWx4NWVfbWFj
c2VjX3J1bGUgKm1hY3NlY19ydWxlOw0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBeDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgID0gTlVMTA0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuX2FjY2VsL21hY3NlY19mcy5jOjExMzE6NjoNCj5lcnJvcjogdmFyaWFibGUgJ21hY3NlY19y
dWxlJyBpcyB1c2VkIHVuaW5pdGlhbGl6ZWQgd2hlbmV2ZXIgJ2lmJyBjb25kaXRpb24gaXMNCj50
cnVlIFstV2Vycm9yLC1Xc29tZXRpbWVzLXVuaW5pdGlhbGl6ZWRdDQo+ICAgICAgICAgIGlmIChl
cnIpDQo+ICAgICAgICAgICAgICBefn4NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbl9hY2NlbC9tYWNzZWNfZnMuYzoxMjE1Ojk6DQo+bm90ZTogdW5pbml0aWFs
aXplZCB1c2Ugb2NjdXJzIGhlcmUNCj4gICAgICAgICAgcmV0dXJuIG1hY3NlY19ydWxlOw0KPiAg
ICAgICAgICAgICAgICBefn5+fn5+fn5+fg0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuX2FjY2VsL21hY3NlY19mcy5jOjExMzE6MjoNCj5ub3RlOiByZW1vdmUg
dGhlICdpZicgaWYgaXRzIGNvbmRpdGlvbiBpcyBhbHdheXMgZmFsc2UNCj4gICAgICAgICAgaWYg
KGVycikNCj4gICAgICAgICAgXn5+fn5+fn4NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl9hY2NlbC9tYWNzZWNfZnMuYzoxMTE4OjM4Og0KPm5vdGU6IGluaXRp
YWxpemUgdGhlIHZhcmlhYmxlICdtYWNzZWNfcnVsZScgdG8gc2lsZW5jZSB0aGlzIHdhcm5pbmcN
Cj4gICAgICAgICAgdW5pb24gbWx4NWVfbWFjc2VjX3J1bGUgKm1hY3NlY19ydWxlOw0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBeDQo+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gTlVMTA0KPiAgMiBlcnJvcnMgZ2Vu
ZXJhdGVkLg0KPg0KPklmIG1hY3NlY19mc197cix0fXhfZnRfZ2V0KCkgZmFpbCwgbWFjc2VjX3J1
bGUgd2lsbCBiZSB1bmluaXRpYWxpemVkLg0KPkluaXRpYWxpemUgaXQgdG8gTlVMTCBhdCB0aGUg
dG9wIG9mIGVhY2ggZnVuY3Rpb24gc28gdGhhdCBpdCBjYW5ub3QgYmUgdXNlZA0KPnVuaW5pdGlh
bGl6ZWQuDQo+DQo+Rml4ZXM6IGU0NjdiMjgzZmZkNSAoIm5ldC9tbHg1ZTogQWRkIE1BQ3NlYyBU
WCBzdGVlcmluZyBydWxlcyIpDQo+Rml4ZXM6IDNiMjA5NDljYjIxYiAoIm5ldC9tbHg1ZTogQWRk
IE1BQ3NlYyBSWCBzdGVlcmluZyBydWxlcyIpDQo+TGluazogaHR0cHM6Ly9naXRodWIuY29tL0Ns
YW5nQnVpbHRMaW51eC9saW51eC9pc3N1ZXMvMTcwNg0KPlNpZ25lZC1vZmYtYnk6IE5hdGhhbiBD
aGFuY2VsbG9yIDxuYXRoYW5Aa2VybmVsLm9yZz4NCj4tLS0NClJldmlld2VkLWJ5OiBSYWVkIFNh
bGVtIDxyYWVkc0BudmlkaWEuY29tPg0KPg0KPnYxIC0+IHYyOiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy8yMDIyMDkwODE1MzIwNy40MDQ4ODcxLTEtDQo+bmF0aGFuQGtlcm5lbC5vcmcvDQo+DQo+
KiBEb24ndCB1c2UgYSBsYWJlbCBhbmQgZ290bywganVzdCBpbml0aWFsaXplIGl0IHRvIE5VTEwg
YXQgdGhlIHRvcCBvZg0KPiAgdGhlIGZ1bmN0aW9ucyAoUmFlZCkuDQo+DQo+VG9tLCBJIGRpZCBu
b3QgY2FycnkgZm9yd2FyZCB5b3VyIHJldmlld2VkLWJ5IHRhZywgZXZlbiB0aG91Z2ggdGhpcyBp
cyBhIHByZXR0eQ0KPm9idmlvdXMgZml4Lg0KPg0KPkJsdXJiIGZyb20gdjE6DQo+DQo+SSB0aG91
Z2h0IG5ldGRldiB3YXMgZG9pbmcgdGVzdGluZyB3aXRoIGNsYW5nIHNvIHRoYXQgbmV3IHdhcm5p
bmdzIGRvIG5vdA0KPnNob3cgdXAuIERpZCBzb21ldGhpbmcgYnJlYWsgb3Igc3RvcCB3b3JraW5n
IHNpbmNlIHRoaXMgaXMgdGhlIHNlY29uZCB0aW1lIGluDQo+dHdvIHdlZWtzIHRoYXQgbmV3IHdh
cm5pbmdzIGhhdmUgYXBwZWFyZWQgaW4gLW5leHQ/DQo+DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9tYWNzZWNfZnMuYyB8IDQgKystLQ0KPiAxIGZp
bGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPg0KPmRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fYWNjZWwvbWFj
c2VjX2ZzLmMNCj5iL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9h
Y2NlbC9tYWNzZWNfZnMuYw0KPmluZGV4IDYwOGZiYmFhNWE1OC4uMTNkYzYyOGI5ODhhIDEwMDY0
NA0KPi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2Nl
bC9tYWNzZWNfZnMuYw0KPisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbl9hY2NlbC9tYWNzZWNfZnMuYw0KPkBAIC01MTgsOSArNTE4LDkgQEAgbWFjc2VjX2Zz
X3R4X2FkZF9ydWxlKHN0cnVjdCBtbHg1ZV9tYWNzZWNfZnMNCj4qbWFjc2VjX2ZzLA0KPiAgICAg
ICAgc3RydWN0IG1seDVfcGt0X3JlZm9ybWF0X3BhcmFtcyByZWZvcm1hdF9wYXJhbXMgPSB7fTsN
Cj4gICAgICAgIHN0cnVjdCBtbHg1ZV9tYWNzZWNfdHggKnR4X2ZzID0gbWFjc2VjX2ZzLT50eF9m
czsNCj4gICAgICAgIHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYgPSBtYWNzZWNfZnMtPm5ldGRl
djsNCj4rICAgICAgIHVuaW9uIG1seDVlX21hY3NlY19ydWxlICptYWNzZWNfcnVsZSA9IE5VTEw7
DQo+ICAgICAgICBzdHJ1Y3QgbWx4NV9mbG93X2Rlc3RpbmF0aW9uIGRlc3QgPSB7fTsNCj4gICAg
ICAgIHN0cnVjdCBtbHg1ZV9tYWNzZWNfdGFibGVzICp0eF90YWJsZXM7DQo+LSAgICAgICB1bmlv
biBtbHg1ZV9tYWNzZWNfcnVsZSAqbWFjc2VjX3J1bGU7DQo+ICAgICAgICBzdHJ1Y3QgbWx4NWVf
bWFjc2VjX3R4X3J1bGUgKnR4X3J1bGU7DQo+ICAgICAgICBzdHJ1Y3QgbWx4NV9mbG93X2FjdCBm
bG93X2FjdCA9IHt9Ow0KPiAgICAgICAgc3RydWN0IG1seDVfZmxvd19oYW5kbGUgKnJ1bGU7DQo+
QEAgLTExMTIsMTAgKzExMTIsMTAgQEAgbWFjc2VjX2ZzX3J4X2FkZF9ydWxlKHN0cnVjdCBtbHg1
ZV9tYWNzZWNfZnMNCj4qbWFjc2VjX2ZzLA0KPiAgICAgICAgdTggYWN0aW9uW01MWDVfVU5fU1pf
QllURVMoc2V0X2FkZF9jb3B5X2FjdGlvbl9pbl9hdXRvKV0gPSB7fTsNCj4gICAgICAgIHN0cnVj
dCBtbHg1ZV9tYWNzZWNfcnggKnJ4X2ZzID0gbWFjc2VjX2ZzLT5yeF9mczsNCj4gICAgICAgIHN0
cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYgPSBtYWNzZWNfZnMtPm5ldGRldjsNCj4rICAgICAgIHVu
aW9uIG1seDVlX21hY3NlY19ydWxlICptYWNzZWNfcnVsZSA9IE5VTEw7DQo+ICAgICAgICBzdHJ1
Y3QgbWx4NV9tb2RpZnlfaGRyICptb2RpZnlfaGRyID0gTlVMTDsNCj4gICAgICAgIHN0cnVjdCBt
bHg1X2Zsb3dfZGVzdGluYXRpb24gZGVzdCA9IHt9Ow0KPiAgICAgICAgc3RydWN0IG1seDVlX21h
Y3NlY190YWJsZXMgKnJ4X3RhYmxlczsNCj4tICAgICAgIHVuaW9uIG1seDVlX21hY3NlY19ydWxl
ICptYWNzZWNfcnVsZTsNCj4gICAgICAgIHN0cnVjdCBtbHg1ZV9tYWNzZWNfcnhfcnVsZSAqcnhf
cnVsZTsNCj4gICAgICAgIHN0cnVjdCBtbHg1X2Zsb3dfYWN0IGZsb3dfYWN0ID0ge307DQo+ICAg
ICAgICBzdHJ1Y3QgbWx4NWVfZmxvd190YWJsZSAqZnRfY3J5cHRvOw0KPg0KPmJhc2UtY29tbWl0
OiAxNjljY2YwZTQwODI1ZDllNDY1ODYzZTQ3MDdkOGU4NTQ2ZDNjM2NiDQo+LS0NCj4yLjM3LjMN
Cg0K
