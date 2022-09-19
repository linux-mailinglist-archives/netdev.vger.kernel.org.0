Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3469C5BCD24
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 15:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiISN1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 09:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbiISN0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 09:26:54 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2065.outbound.protection.outlook.com [40.107.96.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA1B3054C
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 06:26:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sslsi1kMGCBacJGhJUYKl9k50mCjAUFNNpMTenumuloDC9m7WX7oe29qWuN43L5RUFc8icNKa0dzFzyGtalflkbTEyjp8T80b6MiivH7HxV/Qx7vFiC7QO/Zn8u4drS4pkZUgwij0pSkPbvmKQ6reQke8lXKrXW2Nw8onVs74NoWIHQ9d2lv0Y+pgCQ29GzaUgBsY+34OHfmNYmSYqAldK9gl4tuljlplmZXt1LH1aZrcDjcI4F29iWrFYUJBpRTcC8OXMM013F7UQlEhG/wM0F+I/tUW24fjW0z79/SHyjdmCMCsYMVbir9gjT56YBRYpHqCK+2QXqHXlWm2YspVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G57AvgEMBUqzufk5VYjpNvLJCC92ymHuEcs1XJnrYBY=;
 b=DFFTyzwCO774hdQ0LqA9aRTNw7xvzjAKj6t6IiLcxF6PH2o+sYbTx60K4f2UqPSwVOseCnldhHIHBg1iQG5atnz/fbj0hzuDM6G6oOJ+ZgM1o7IHxGMp0BlK7lrEo1Q0FyyJKfKrlpjx4FRfd7AdCwL+rWKI3qtapS4Zv27vElWrffIg+jhO8G+557iDFCrdIYSWoO/DJYdZEpzK6bcx46EYxPyMy1XD69+drP2U07rZnSZhNyL4Oqubi2BjfR/Eo1AaCtlKzRNJSmFEvtYcO8xl8xLEvlqg63ftJ0yNOdQI/x8VoXAaM+HArs/GV1xmsbvIwjULGNz53EYq0dLQqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G57AvgEMBUqzufk5VYjpNvLJCC92ymHuEcs1XJnrYBY=;
 b=TUnjLVejjpaqtKVwfMQjsrPQsxqCit/FIeJa+TiT8pqQ1Dqec1zsmKeh24RRXtKfo5wpVyCUtbFHlVjEx3RJMLrfx/xPipvH0inSHXsj1SyaHNc65rDmtA9en4UNR9NjJA7XAlEUa9N/iUmUqX8a6/8VgAmKgtiDOw5GHFR9phkK9fvcsEHh9XgItRwdXV0iOTWttsdW5Kh5KyByjpg3eVZzXljE/QkZ9hp+AbLmNRv1BJ39OCVod6Zdo2SN+gMOsWvXgCNyCnl87lpm6cP/Rk7UJQq5bM+CL47PxdNLI0lOadyZtk4LB/fXv96NUWC3T5zWrbeUUKT4wc+jRug9mQ==
Received: from DM4PR12MB5357.namprd12.prod.outlook.com (2603:10b6:5:39b::24)
 by PH7PR12MB6537.namprd12.prod.outlook.com (2603:10b6:510:1f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.17; Mon, 19 Sep
 2022 13:26:26 +0000
Received: from DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::ec0e:6950:ee5b:8066]) by DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::ec0e:6950:ee5b:8066%8]) with mapi id 15.20.5632.021; Mon, 19 Sep 2022
 13:26:26 +0000
From:   Raed Salem <raeds@nvidia.com>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>,
        Antoine Tenart <atenart@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "naveenm@marvell.com" <naveenm@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: [PATCH net-next V2 07/17] net/mlx5: Add MACsec offload Tx command
 support
Thread-Topic: [PATCH net-next V2 07/17] net/mlx5: Add MACsec offload Tx
 command support
Thread-Index: AQHYwbCRLYmJp6/+y0CvT0msjmHaEq3fDBgAgABkg4CAAJAdgIAAAYeAgAAtSwCABlntgIAASCAw
Date:   Mon, 19 Sep 2022 13:26:26 +0000
Message-ID: <DM4PR12MB53579A35887680D5211AC282C94D9@DM4PR12MB5357.namprd12.prod.outlook.com>
References: <20220906052129.104507-1-saeed@kernel.org>
 <20220906052129.104507-8-saeed@kernel.org>
 <CALHRZuq962PeU0OJ0pLrnW=tkaBd8T+iFSkT3mfWr2ArYKdO8A@mail.gmail.com>
 <20220914203849.fn45bvuem2l3ppqq@sx1>
 <CALHRZup8+nSNoD_=wSKGym3=EPMKoU+1UxbVReOv8xnBnTeRiw@mail.gmail.com>
 <CALHRZuqKjpr+u237dtE3+0b4mQrJKxDLhA=SKbiNjd0Fo5h1Nw@mail.gmail.com>
 <166322893264.61080.12133865599607623050@kwain>
 <CALHRZurLscR15y48fzJXC4pAWe+wen8JZVCwk2fwT4wujqSdRQ@mail.gmail.com>
In-Reply-To: <CALHRZurLscR15y48fzJXC4pAWe+wen8JZVCwk2fwT4wujqSdRQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR12MB5357:EE_|PH7PR12MB6537:EE_
x-ms-office365-filtering-correlation-id: 050df2bb-80ca-4bdf-083b-08da9a428d9e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6W5Mugdk2U/Nw+bsQByAkZ3uAz49SaQrRbJ/dMMvnm+ZoSWupJXwjIIV+e46pUfYzhDQ+PvBb2eGWr1Qf9cZjel1n4kMaEdlqgiE+mdeoKYXzhnAm9kge540y6KP70XDowb66Pr0haSrIcEazoWjR8hyhwG7Oz5ZMu9pD0nl71Mvh8VHkuSkf1Sljk+PsULHCWE4TD5WGt2K4lGtt1+/X9CPce/mAmsBnPtt+YaBoTvp0szmTldWHNamhdkjsZv20wjQd4I0aRAbTgl5R4HyCht682Ntoom4VP0XAiBsyaqab1D3/cHTxG28OCwSI0Sq6AGhgs+Wldk4jYPoCpoRzdk/5IQwtas/JPoDh3YB0NAL2Msu3BKihGDJChT68T8BYACtnqcvC40Q7rA54mcVm1UyXeH+ai/KX39yCA5nLF2t//5deC0Gv1LyeWH9AvwHUdSHP/i4v2uRthNXqsSaHa405+ZAAz/8wIgkDnK8D8bcb6zyFLoSoE7DGi9FlcUNR12MZ1rgNYliHdH+SVxnmVZjLicE449ViHNvf/gVcuy87Dt+YLs8Oj5f6fgbqYzisck9d/Y/8+7vYFyqlsLrYY8BtRbBlY8TmZYuEW4nqbmRIQAww4bUJIjyTwOK6AaU76HD2h9BTBehUuzqBjHx3a+DABmqPeOkVJY9bZCixQ0rLa8FTJRT7OUFgT+ttQ94o0At6pVbzJJ/WusT3xkyoNzvSf8JX3Rt7JpAzNVp11dcul/6CWoV+Fv4FYuNADO4Pr/VHN2jgwQ7Heqyfid20w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5357.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199015)(478600001)(71200400001)(9686003)(6506007)(7696005)(26005)(53546011)(2906002)(5660300002)(66556008)(52536014)(8936002)(7416002)(55016003)(33656002)(316002)(110136005)(54906003)(66946007)(41300700001)(64756008)(8676002)(4326008)(66446008)(66476007)(122000001)(83380400001)(38070700005)(38100700002)(76116006)(86362001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzJwbDE2V0RtNTlGRWRvZ2VTSjJqNXMvd2VTSWNLeUJGdlJkQllUT0NMUytV?=
 =?utf-8?B?bldFYk50WmpGZFRtTUg1alROOTRSdm9qLzVncVRUanVia3l5RWg1T0xGamRh?=
 =?utf-8?B?Uks5UzZZcDZnOEhDRjQ4Z05JNzRKMTc4Y3M1cWJ2WVdaendzVVlIWGRMVlMx?=
 =?utf-8?B?SUVnb3kzK0Z1YzRzZlg4YkZXaHIzODV3N2lHTll5NVRMaDNnMzBQekZjSHRq?=
 =?utf-8?B?cGdkdnhKeitSODNrNUlUOEdIUWFpaU5Ka2p5emlEWi9CZEN4VU5TaHVTUjZG?=
 =?utf-8?B?bHBDaGZaMmJ6cTlMT1VhcVN5SXpvdUpobmdvQ0hvb3paWWUxZVJqZkRHOGZq?=
 =?utf-8?B?N3UwMFE3MTNyRE54WVlJN0dObE0zYytYY0pqdDN6NXAzS0VTRmpiYzlFQyt6?=
 =?utf-8?B?TmlPZGhReFFBNWwxZ1hWUER4ZVNVS283Vkt2V0NWcStBaDhMK2lyMlc5V3M0?=
 =?utf-8?B?MjhrbWJzbzUrNzV0VnZTN0pVNy9tY0FDY1duMHdkN0srYXV1QzB6MDZRVWpk?=
 =?utf-8?B?amEzMXFnWGZSeThmL2NQQ0tac1J6cjd6aGJxV1hxQW0vYXlISkNOZ2dvYWds?=
 =?utf-8?B?V1FBRHZvTTlpZE9SSWhHSnB6YzZRRDlpZ1NVYVdiTWNxaUZrdmo5bnJxQ2ky?=
 =?utf-8?B?MkFBWVB1enVaN0R5MG1RY2dqR3IxSmNSUUM3T2hTRG1zSTFmZ0dRbTd2akV3?=
 =?utf-8?B?QWJCOXZVTXJlZkM5dHd0SytvSDNnNlBoblZiZm5MY1I3Ulhha0FtS3dMTFc5?=
 =?utf-8?B?YUhZTUFGaEtGWG03cWNUT3d5QTJyempteWtvK0lRVS9TSUgranhmenNXTzJ0?=
 =?utf-8?B?R1NZQnBVTng0WnZjK1dtWks5L2lOSjR2UHhoeUhmU1V2di9kaDFvZU5mVkxP?=
 =?utf-8?B?a00zdWlWNHIzM1pDRE1BdGR4VEpvWUp0SWxiQmJ6U3hTWjFrbk03czBVQkxS?=
 =?utf-8?B?VGE5ZnRoTjd2YlVXb3NWdUVsK1dtQ2IrQ05kaTlPbnNDS2g0Qi9rUjBrTUNo?=
 =?utf-8?B?VEllWTRwZVVyWFZtcWd1eGttT1NINkNab2RabE8zSWNlR2NqeWtGYjNJd3Jl?=
 =?utf-8?B?bHg5bUlDcS85QlEwOXlIYWVubVBZaG5UN1JNYS9QYlpSTnRyYmI1NG4yWHQ2?=
 =?utf-8?B?UXNXbUk4U0FDL2NKQjhBcVQwR1JNVEluL0EzMVladmVPNnlGeHlhWkJNZENh?=
 =?utf-8?B?ZWhwSjZZVDFSa0kvWURyRHAwRW5qTFNuK2VvMzMvNVkwRmhJekdCajVvY0pn?=
 =?utf-8?B?clVFTkcrNTErWGNENlU1bWJDMWlyajlGMEJRR2IvVG5GOGVua0ZKOHJVZk5u?=
 =?utf-8?B?cituS1NnbmlYQzYvUWYxZExJQVBtdWtxQ1RUazJZdTVYWXNhcXpxR09ZTWNE?=
 =?utf-8?B?VDRtN1FQVkJsZGpZaVZtL2lwUUtWMTU0VFNab1RlVG91SzdvcWREUVcvTEtx?=
 =?utf-8?B?ZkFBUExNM1VaUE5xbU1tOFo0TURjN0dZejVtYjZ3aG5QeGtMbDFGdDZyZXZF?=
 =?utf-8?B?N1ovOS9oWm1CcDhHYlRKN0Q2UGlYOHA5bk5jZzZSbkhSRnlyVWRYZVYrMXo2?=
 =?utf-8?B?b3ZCelpjZnExbnhQc2RUWFR3SWRaSWR4STNPcC9kRlo4L0JMdVlHcGx2ZlpM?=
 =?utf-8?B?MUJOK3RGWlhVSm00ZzJNak5nTFN3WGp5dWd0MWczR2pHWFh3bCtYNk1zMitp?=
 =?utf-8?B?QUpMNUZGWW9TRGxqZlBiK3JyQTMxZ3pOOHNybTJRVXhpVXh0VWI2L2E5Qmk2?=
 =?utf-8?B?eFZacEhQTE4vNnhYWGd2cXZhVDR0eUt3bTdSeFVWSzA0ZjlNRGQ3Z284cXlR?=
 =?utf-8?B?MWcvQStXTVJwRGNSY3hja2Zna0xndlBNU1FxUGNiVy9acVpBRGliTEc2Y2lF?=
 =?utf-8?B?NmxaMklQTjM4TkpvUzNva3Z1ZzF1SWY4ZGpRcWg4bW9hNGZya3hsNG5Gc1N6?=
 =?utf-8?B?VTF3YVNDUnRnS3hzbDFNdlNYaEVxL2dSbkVqUXVhYjhITVhSaGFKemgrekRB?=
 =?utf-8?B?MDhTblQrQnhiZWc3Wnk5dW9Eb2d2QlFmK29kTXZjNXNyV2p6UE9LRUZoMDVB?=
 =?utf-8?B?a2JOdGEwMVI1Mk5YaWhBVExFVEZraGRVTTNFSklOUVBrYnRKVk5MSmFvZE1k?=
 =?utf-8?Q?li54=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5357.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 050df2bb-80ca-4bdf-083b-08da9a428d9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2022 13:26:26.0653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gUgsVuvf6N/5tnwToOTjTFdsJKLxkMB4hLTxT3bv0/weMZFlv7RaUNxsef1nKqrNa2wWnsrEn2rHTAbz05FGWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6537
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IHN1bmRlZXAgc3ViYmFyYXlh
IDxzdW5kZWVwLmxrbWxAZ21haWwuY29tPg0KPlNlbnQ6IE1vbmRheSwgMTkgU2VwdGVtYmVyIDIw
MjIgMTI6MDINCj5UbzogQW50b2luZSBUZW5hcnQgPGF0ZW5hcnRAa2VybmVsLm9yZz4NCj5DYzog
U2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBudmlkaWEuY29tPjsgU2FlZWQgTWFoYW1lZWQNCj48c2Fl
ZWRAa2VybmVsLm9yZz47IExpb3IgTmFobWFuc29uIDxsaW9ybmFAbnZpZGlhLmNvbT47IERhdmlk
IFMuIE1pbGxlcg0KPjxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFA
a2VybmVsLm9yZz47IFBhb2xvIEFiZW5pDQo+PHBhYmVuaUByZWRoYXQuY29tPjsgRXJpYyBEdW1h
emV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsNCj5uZXRkZXZAdmdlci5rZXJuZWwub3JnOyBUYXJp
cSBUb3VrYW4gPHRhcmlxdEBudmlkaWEuY29tPjsgUmFlZCBTYWxlbQ0KPjxyYWVkc0BudmlkaWEu
Y29tPjsgU3ViYmFyYXlhIFN1bmRlZXAgPHNiaGF0dGFAbWFydmVsbC5jb20+Ow0KPm5hdmVlbm1A
bWFydmVsbC5jb207IFN1bmlsIEtvdnZ1cmkgR291dGhhbSA8c2dvdXRoYW1AbWFydmVsbC5jb20+
Ow0KPkdlZXRoYSBzb3dqYW55YSA8Z2FrdWxhQG1hcnZlbGwuY29tPjsgYW5kcmV3QGx1bm4uY2gN
Cj5TdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IFYyIDA3LzE3XSBuZXQvbWx4NTogQWRkIE1B
Q3NlYyBvZmZsb2FkIFR4DQo+Y29tbWFuZCBzdXBwb3J0DQo+DQo+RXh0ZXJuYWwgZW1haWw6IFVz
ZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4NCj4NCj5PbiBUaHUsIFNl
cCAxNSwgMjAyMiBhdCAxOjMyIFBNIEFudG9pbmUgVGVuYXJ0IDxhdGVuYXJ0QGtlcm5lbC5vcmc+
IHdyb3RlOg0KPj4NCj4+IFF1b3Rpbmcgc3VuZGVlcCBzdWJiYXJheWEgKDIwMjItMDktMTUgMDc6
MjA6MDUpDQo+PiA+IE9uIFRodSwgU2VwIDE1LCAyMDIyIGF0IDEwOjQ0IEFNIHN1bmRlZXAgc3Vi
YmFyYXlhDQo+PiA+IDxzdW5kZWVwLmxrbWxAZ21haWwuY29tPiB3cm90ZToNCj4+ID4gPiBPbiBU
aHUsIFNlcCAxNSwgMjAyMiBhdCAyOjA4IEFNIFNhZWVkIE1haGFtZWVkDQo+PHNhZWVkbUBudmlk
aWEuY29tPiB3cm90ZToNCj4+ID4gPiA+IE9uIDE0IFNlcCAyMDowOSwgc3VuZGVlcCBzdWJiYXJh
eWEgd3JvdGU6DQo+PiA+ID4gPiA+SGkgU2FlZWQgYW5kIExpb3IsDQo+PiA+ID4gPiA+DQo+PiA+
ID4gPiA+WW91ciBtZG9fb3BzIGNhbiBmYWlsIGluIHRoZSBjb21taXQgcGhhc2UgYW5kIGRvIG5v
dCB2YWxpZGF0ZQ0KPj4gPiA+ID4gPmlucHV0IHBhcmFtcyBpbiB0aGUgcHJlcGFyZSBwaGFzZS4N
Cj4+ID4gPiA+ID5JcyB0aGF0IG9rYXk/IEkgYW0gZGV2ZWxvcGluZyBNQUNTRUMgb2ZmbG9hZCBk
cml2ZXIgZm9yIE1hcnZlbGwNCj4+ID4gPiA+ID5DTjEwSw0KPj4gPiA+ID4NCj4+ID4gPiA+IEl0
J3Mgb2sgc2luY2UgaSB0aGluayB0aGVyZSBpcyBubyByZWFzb24gdG8gaGF2ZSB0aGUgdHdvIHN0
ZXBzDQo+PiA+ID4gPiBzeXN0ZW0gISBpdCBkb2Vzbid0IG1ha2UgYW55IHNlbnNlIHRvIG1lICEg
cHJlcGFyZSBhbmQgY29tbWl0DQo+PiA+ID4gPiBhcmUgaW52b2tlZCBjb25zZWN1dGl2ZWx5IG9u
ZSBhZnRlciB0aGUgb3RoZXIgZm9yIGFsbCBtZG9fb3BzDQo+PiA+ID4gPiBhbmQgaW4gZXZlcnkg
b2ZmbG9hZCBmbG93LCB3aXRoIG5vIGV4dHJhIHN0ZXAgaW4gYmV0d2VlbiEgc28gaXQncyB0b3Rh
bGx5DQo+cmVkdW5kYW50Lg0KPj4gPiA+ID4NCj4+ID4gPiA+IHdoZW4gaSByZXZpZXdlZCB0aGUg
c2VyaWVzIGluaXRpYWxseSBpIHdhcyBoZXNpdGFudCB0byBjaGVjaw0KPj4gPiA+ID4gcGFyYW1z
IG9uIHByZXBhcmUgc3RlcCBidXQgaSBkaWRuJ3Qgc2VlIGFueSByZWFzb24gc2luY2UgY29tbWl0
DQo+PiA+ID4gPiBjYW4gc3RpbGwgZmFpbCBpbiB0aGUgZmlybXdhcmUgYW55d2F5cyBhbmQgdGhl
cmUgaXMgbm90aGluZyB3ZSBjYW4gZG8NCj5hYm91dCBpdCAhDQo+PiA+ID4NCj4+ID4gPiBZZXMs
IHNhbWUgd2l0aCB1cyB3aGVyZSBtZXNzYWdlcyBzZW50IHRvIHRoZSBBRiBkcml2ZXIgY2FuIGZh
aWwgaW4NCj4+ID4gPiB0aGUgY29tbWl0IHBoYXNlLg0KPj4gPiA+DQo+PiA+ID4gPiBzbyB3ZSd2
ZSBkZWNpZGUgdG8ga2VlcCBhbGwgdGhlIGZsb3dzIGluIG9uZSBjb250ZXh0IGZvciBiZXR0ZXIN
Cj4+ID4gPiA+IHJlYWRhYmlsaXR5IGFuZCBzaW5jZSB0aGUgcHJlcGFyZS9jb21taXQgcGhhc2Vz
IGFyZSBjb25mdXNpbmcuDQo+Pg0KPj4gPiA+ID4gPmFuZCBJIGhhZCB0byB3cml0ZSBzb21lIGNs
ZXZlciBjb2RlIHRvIGhvbm91ciB0aGF0IDopLiBQbGVhc2UNCj4+ID4gPiA+ID5zb21lb25lIGhl
bHAgbWUgdW5kZXJzdGFuZCB3aHkgdHdvIHBoYXNlIGluaXQgd2FzIG5lZWRlZCBmb3INCj4+ID4g
PiA+ID5vZmZsb2FkaW5nLg0KPj4gPiA+ID4NCj4+ID4gPiA+IEkgZG9uJ3Qga25vdywgbGV0J3Mg
YXNrIHRoZSBvcmlnaW5hbCBhdXRob3IsIEFudG9pbmUgPw0KPj4NCj4+IFRoaXMgdHdvIHN0ZXBz
IGNvbmZpZ3VyYXRpb24gd2Fzbid0IHBhcnQgb2YgdGhlIGluaXRpYWwgUkZDIGFuZCB0aGVyZQ0K
Pj4gd2FzIGEgc3VnZ2VzdGlvbiB0byBnbyB0aGlzIHdheSBhcyBpdCBjb3VsZCBhbGxvdyB0aGUg
aGFyZHdhcmUgdG8NCj4+IHJlamVjdCBzb21lIGNvbmZpZ3VyYXRpb25zIGFuZCBoYXZlIGFuIGVh
c2llciBzL3cgZmFsbGJhY2sgKHcvIHBoYXNlIDENCj4+IGVycm9yIGJlaW5nIGlnbm9yZWQgYnV0
IG5vdCBwaGFzZSAyKS4gVGhpcyBtYXBwZWQgfnF1aXRlIHdlbGwgdG8gdGhlDQo+PiBmaXJzdCBk
ZXZpY2Ugc3VwcG9ydGluZyB0aGlzIHNvIEkgdHJpZWQgaXQuIEJ1dCBsb29raW5nIGJhY2ssIHRo
aXMNCj4+IHdhc24ndCBkaXNjdXNzZWQgYW55bW9yZSBub3IgaW1wcm92ZWQgYW5kIHN0YXllZCB0
aGlzIHdheS4gQXMgeW91IGNhbg0KPj4gc2VlIHRoZSBvZmZsb2FkaW5nIGRvZXNuJ3QgZmFsbGJh
Y2sgdG8gcy93IGN1cnJlbnRseSBhbmQgSSdkIHNheSBpZiB3ZQ0KPj4gd2FudCB0aGF0IHdlIHNo
b3VsZCBkaXNjdXNzIGl0IGZpcnN0OyBub3Qgc3VyZSBpZiB0aGF0IGlzIHdhbnRlZCBhZnRlciBh
bGwuDQo+Pg0KPkkgY291bGQgbm90IHRoaW5rIG9mIGFkdmFudGFnZXMgd2UgaGF2ZSB3aXRoIHR3
byBwaGFzZSBpbml0IGZvciBzb2Z0d2FyZQ0KPmZhbGxiYWNrLg0KPkFzIG9mIG5vdyB3ZSB3aWxs
IHNlbmQgdGhlIG5ldyBkcml2ZXIgdG8gZG8gYWxsIHRoZSBpbml0IGluIHRoZSBwcmVwYXJlIHBo
YXNlDQo+YW5kIGNvbW1pdCBwaGFzZSB3aWxsIHJldHVybiAwIGFsd2F5cy4NCj4NCj5UaGFua3Ms
DQo+U3VuZGVlcA0KSSB0aGluayBpdCBpcyBiZXR0ZXIgdG8gZG8gYWxsIHRoZSBpbml0IGluIGNv
bW1pdCBwaGFzZSBhbmQgbm90IGluIHRoZSBwcmVwYXJlIHRvIGFsaWduIHdpdGgNCm1vc3QgZHJp
dmVycyB0aGF0IGFscmVhZHkgaW1wbGVtZW50ZWQgbWFjc2VjIG9mZmxvYWQgKGJvdGggYXF1YW50
aWEgYW5kIG1seDUgYW5kIG1vc3Qgb2YgbXNjYyBpbXBsZW1lbnRhdGlvbiksDQp0aGlzIHdpbGwg
bWFrZSBpdCBlYXNpZXIgdG8gZGVwcmVjYXRlIHRoZSBwcmVwYXJlIHN0YWdlIGluIGZ1dHVyZSBy
ZWZhY3RvciBvZiB0aGUgbWFjc2VjIGRyaXZlciBpbiBzdGFjay4NCg0KVGhhbmtzLA0KUmFlZA0K
Pg0KPg0KPj4gSWYgaW4gdGhlIGVuZCBhbGwgZHJpdmVycyBpZ25vcmUgdGhlIGZpcnN0IHBoYXNl
LCBvciBjYW4ndCBkbyBtdWNoLA0KPj4gaXQncyBwcm9iYWJseSBhbiBpbmRpY2F0aW9uIHRoZSBw
YXR0ZXJuIGRvZXNuJ3QgZml0IHdlbGwuIFdlIGNhbiBzdGlsbA0KPj4gY2hhbmdlIHRoaXMsIGVz
cGVjaWFsbHkgY29uc2lkZXJpbmcgdGhlcmUgYXJlIG5vdCB0aGF0IG1hbnkgZHJpdmVycw0KPj4g
aW1wbGVtZW50aW5nIE1BQ3NlYyBoL3cgb2ZmbG9hZCBmb3Igbm93LiBOb3cgaXMgYSBnb29kIHRp
bWUgdG8gZGlzY3Vzcw0KPj4gdGhpcywgdGhhbmtzIGZvciByYWlzaW5nIHRoYXQgcG9pbnQuDQo+
Pg0KPj4gW0FkZGluZyBBbmRyZXcgd2hvIElJUkMgbG9va2VkIGF0IHRoZSBpbml0aWFsIFJGQzsg
aW4gY2FzZSBoZSB3YW50cyB0bw0KPj4gYWRkIHNvbWV0aGluZ10uDQo+Pg0KPj4gVGhhbmtzLA0K
Pj4gQW50b2luZQ0K
