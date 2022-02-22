Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736464BEF48
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238783AbiBVB6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 20:58:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238697AbiBVB6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 20:58:50 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45116584;
        Mon, 21 Feb 2022 17:58:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2qJQXl1cwX30SjsusxsEMK2tQzlWsOdfMSM3c1t160Rw0JGzJKKhLULMjImpiBeWqWCW7UcXbfcyFYhf5y2GpR46ckVU7KUTJP016Rv1bw17KLghKj1EvdzZTvRpwL7HbnT1pLCb3kIe9ECVFXW6K674gxOWc7FyFavvBc+VDno/tb5jHwQZ+aAAs2hJ1uc39RPH8/mUO7Y48lnVRUvzdYgF5ATEvLBSRMJRGGehmgfiPRy+QHj2gAnDXLukwzDe4BDpqbN5yWcvbO+f4kx63pMOemnE+VpUNllrDxlwTZaq9ZbDzs8eEA7iN8PJXyKkmhfmvlbjmA+CcW74YaDkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8DZ4HaekZZqr+Iszf3BIJX/R14MApG6NwDbXjDC9Hb4=;
 b=E9iSisMyvXuFk33MVDYdt5l2vCaRTQ3pDJWTGCxaPpMaz/EWxJd7G345ZZ7KR0zqpthbQPEaQ0v8JWxr8x4B/T9mw3fKVOLV3DHUA02SV4HkUi6BavmPm2g6Ww7Uv80atS+gkfsedYQcsCcAxiEB5J9a0cqsLe3xC5RVz2o3mjeFpxtLdf4vOlh0q2cmbtDo7q82yqRQulqUaB3sjWlgzvBNCDMB+Vi3fS8GuSzLL28QSj34JhIW+CAXAjewi86bm8CIWneKmirHZ/QEqNNBj9c+JsUR0dJx7JiGrVD2t5g5Z85yb1Fk/0d787rzgefVWcJqmw3StKVsbAfkr4iGNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DZ4HaekZZqr+Iszf3BIJX/R14MApG6NwDbXjDC9Hb4=;
 b=QcmBNxjmfYtcAXxtU59e53w+yHuCzQnr36BD5qHuVBESXbz63FAb51KanyMvZs/hph7qwfblIZcjyPg8qcLBcdWMtjSaCq1z0aH60wTmeuMt/7NSAEr1YDqTt52Do4LctxtqY4IFLorRXsLCz+7GtMyK/vy/FcRfuctNAlxSCjqcSFgFMgxpbkfNXffDkrYafiGP3YQcAkxsDCE6qEAQpk+uo2e4DRvxe2Oo5c9tsFa3KXALUUCwYJMZ/QDuu2GimZMI/6jZaQ2fxY4Q4Rd05Ms3QR4S99M6Pw9CYkssAWxZN3ToBzGkinBr8D4cwubnsLOqHIFy33joT+wttc+beA==
Received: from DM4PR12MB5198.namprd12.prod.outlook.com (2603:10b6:5:395::17)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 01:58:23 +0000
Received: from DM4PR12MB5198.namprd12.prod.outlook.com
 ([fe80::ccdd:3262:885f:6f5e]) by DM4PR12MB5198.namprd12.prod.outlook.com
 ([fe80::ccdd:3262:885f:6f5e%4]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 01:58:23 +0000
From:   Jianbo Liu <jianbol@nvidia.com>
To:     "olteanv@gmail.com" <olteanv@gmail.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>,
        "hkelam@marvell.com" <hkelam@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "peng.zhang@corigine.com" <peng.zhang@corigine.com>,
        "louis.peens@netronome.com" <louis.peens@netronome.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "rajur@chelsio.com" <rajur@chelsio.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "sbhatta@marvell.com" <sbhatta@marvell.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        Roi Dayan <roid@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "sgoutham@marvell.com" <sgoutham@marvell.com>,
        "gakula@marvell.com" <gakula@marvell.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/2] flow_offload: reject offload for all
 drivers with invalid police parameters
Thread-Topic: [PATCH net-next v2 2/2] flow_offload: reject offload for all
 drivers with invalid police parameters
Thread-Index: AQHYI9hnxKB/8XMkm0uWEB4X3Xu2BqyXsfCAgAcltYA=
Date:   Tue, 22 Feb 2022 01:58:23 +0000
Message-ID: <6291dabcca7dd2d95b4961f660ec8b0226b8fbce.camel@nvidia.com>
References: <20220217082803.3881-1-jianbol@nvidia.com>
         <20220217082803.3881-3-jianbol@nvidia.com>
         <20220217124935.p7pbgv2cfmhpshxv@skbuf>
In-Reply-To: <20220217124935.p7pbgv2cfmhpshxv@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.0-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4e8d26b-b2e8-46a7-b109-08d9f5a6cefb
x-ms-traffictypediagnostic: SA0PR12MB4575:EE_
x-microsoft-antispam-prvs: <SA0PR12MB45753F1819923D5574B7DC28C53B9@SA0PR12MB4575.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jhmDOOaBD+o3XEJSplJ/d8s6pX8BoYbrgCY1cTkDcKtpWD1wAvIBec3Hl+96TBFO5OtGohgm8cWKgA7rfXd3YfVLSe0mkvGPlr62V9jPISqmwpcAsEX7bad33W2bORl6qdGU/+ty8zDiC98aiYb5EhCqfP6kLqTiw3MP9TqdOXFx5HCaBXWNcr+CPYPqGABgPOKJvdGuHsYoEkquzIZksvgiseTcCPXxqHD80B1zIg/KRz9qc3hfVLjg9vFqBta3sMzge7y8Vwa+SVr4l/cBeykoQ695mW9yMkXqMb3K0tE0WqcyRzE3nZrCz5Byd49LVphBxZ1hbwMvmHzE8akxCG9zk7IPPEFdNDNHqnI73AaOhFb6DEfcec66mnNPN7V3RUNnp0/FkerCUZNT+gGxqi7P/OjFh0mqeRLjqvemhtaHdU/S893QlUlLwgUxQFLQTrqRhsCLA+ecRY/ceoIdrjs0UF76BPzuIHN6cbLiHcjCyUQ8Vy/30NodFd2WZ6wVA/3DMez0/ZxAqBG0gEFyxELXsHMrRARGQgkHflcwtrOhrECjBohyZOKCbRyNBvuU3YIlzCFGpSmbA468uOJpAujINPk2N1qT2j6uoWmAdd6tw6PfIP34Dbmal/rI5mPzGhsVKQ8accaGGJdgtlpfKloKswE7O00u364/ERmPz5pb1i3/JYiIiD3voq5dd8E0edfY7yJd2oEGfdolOaT9WA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5198.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(83380400001)(66556008)(64756008)(36756003)(66946007)(186003)(66446008)(122000001)(2906002)(7416002)(6916009)(54906003)(86362001)(38070700005)(76116006)(38100700002)(8936002)(2616005)(5660300002)(91956017)(4326008)(71200400001)(6506007)(8676002)(508600001)(6486002)(6512007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlJDMUI5ZEpmNjc2cFBlaHJuSWpRVFNzVlZsNW1BSlZHUlBDU3VRWDFuMlNu?=
 =?utf-8?B?a0tGMGNRcTBvdStmdlhkV1BNdjJGN1pHVEVvQThUa0FjeldpYjdtVDdtaGxD?=
 =?utf-8?B?WTNERHJRTVdySERpSGxJNXNub1hYRy96NnRXbUtxd05RTExZSUtIRlptOXVS?=
 =?utf-8?B?NnlmUVRXSEczT09CUTBSRzhLUjlCNmlrcm5wb1RtYUZ1QzJtU3Y1ZVd6NWNG?=
 =?utf-8?B?TTJqalBxNkxFOGE3bmk5WG5qai92RVVxOXc5b1JMUGdwM3hRSkJTaXY0Vmdy?=
 =?utf-8?B?MUljUnFyaS9zdVlNK0xaRkdCdDJSQkdGY2JwODdMNnNUallqMmpYa0pxZzBy?=
 =?utf-8?B?b3JQQUlQbDFNL2huV3lQOUEvSGZDdlJhQVRhdlhCMmc1NzJQVi8zNmVjKzhk?=
 =?utf-8?B?RFUvdTRuUFZZTzlFZnB1ZDlCK2pSUlRjQlRFZmVBZm83R003Slg2MW5CSERL?=
 =?utf-8?B?Q2ZFNGc5d3dUMCtDWHplM05TUmNvajNFUldtVFI5SlgyamNQcUZrczJkYzBO?=
 =?utf-8?B?YUQ0QVBuYjdyZ2E0clp6cEdTZ3NMd0lwWm9ZWVVxSHNLd0s5SHJ5YURNcmtr?=
 =?utf-8?B?MVFTSG5GWTE3K1k3cWRuQjVKNUtzcGNjd3hMQjM2MWdzZm1KT1l6NThIM2gv?=
 =?utf-8?B?aVV1algyZW1wNnBNdnpOOWQyZ2MrYUhrb2o3aWsvcDEzcmh4TlpPVUZKWTVv?=
 =?utf-8?B?b3k5ODhlZFJ1S1dFS2hSQlduYkl1Q1M3aEZlMFI0S0liMndWTjdRcVJJOE9i?=
 =?utf-8?B?RjFTajZXT1RDTThMaFpSdmtkOGZZQTlDVFBkc081eEdkNUxib1NvY2J5bGNC?=
 =?utf-8?B?RGpPVGs3cGI0UmgzNDU3RFZPNTRPZGlpVGpmcGk4N2dHK216ZHBsMkQ5dHFV?=
 =?utf-8?B?SFR3dnI3ZUxYNEZxbGVFUkdCTkFNcHlSVHpMaDRJa3BOOXpVcmg5YVU3MzlR?=
 =?utf-8?B?ZkJqV2FobWpiT0ZMUHh3eFBreXVSOEFVYXdINzN3R1R2NUVzMW9kT1I3QWNR?=
 =?utf-8?B?enhQNlF2YitONWtodTh2TWN4S3lLd3l6WE5MRVIvZFN3UTJxVnVQRTV4Znlm?=
 =?utf-8?B?cDZoMlRGWmRKMmNmUUlRYWV2NG5Za0tBU0FaSUJEMUM2Q1U0RUdtS3lsVURu?=
 =?utf-8?B?V2NjS3N1ZjI4TWVlR2VhMEhReDlncHFDNWNVb2dHbi9DRUNxOUY2L2VvTXkr?=
 =?utf-8?B?UWhnZzVmUHpNc0hQNGVhWDU1SHllWGtYd2ZVRzc4b1ZiWUh0Q0lORUpNdlVT?=
 =?utf-8?B?dUtJSEZSc2w5OE5hUU9zM0YrMUNEMUd3eXdjQTJIdm5zbHVyU3JkbEZJY2FX?=
 =?utf-8?B?TW9YamhkMjJ6MTUxUWVLbTIwNU1EaTJ1RVV6YWhLMDRYenRzd1Y2ZUNTNFNC?=
 =?utf-8?B?YkJQK081V0tGaDdOckp6cEF3WVdNYVpRNFpXZ1BYTHJiSzAxY3ZxWjM1aHdi?=
 =?utf-8?B?U3d6OUdleDNzUUk1M21TczVsZXExcTRnRWZiakJVRUFvL0wwMkF0VGlsdjVU?=
 =?utf-8?B?VzU5RmlmalRQaW9CdVFNbWsrWFNoSzgxVmdYTzY3blJFMStHaCtBQ1hVVkRN?=
 =?utf-8?B?VURRVWU4WHViOFM2ZVRXVFJXZnJ2T1BTUFl0Y3NCNjU0ZHdhNHVydm9hNlRT?=
 =?utf-8?B?aUZFZVZ6aStmUTFzNG90bEQzUVRnK3ZtNy90RW5JQm9qZFJ2bVdNYXdoUEdw?=
 =?utf-8?B?YWVOakhTbXEvd01OOWpOTXhlSjBHcjVtRGowamtlR0dMazIwa3U3RHFhN0ta?=
 =?utf-8?B?amxWd1hITU1ZdFd6NnloRlJZODFDK3JaN01jR3BySzZ3R0I1b1JnYjErSCtR?=
 =?utf-8?B?b1R2TnNsN3BORG9sYUxoYmEvNHZvWC9kODhaRjdDSFNMeFhPbENZWitxL210?=
 =?utf-8?B?K24vbkx4TXN5L0dwSEZCMEJZWG90SW16akFPUGtWZW1EYkoveFZrYXVKRHpp?=
 =?utf-8?B?ZGhTRjRINjRZd3U0QUJnN1FjVDRtbndZejMyZExiWWEyRG9sZnZJc1JUR1k5?=
 =?utf-8?B?ZERqL2FscFVFNEFKd3RRcEpZa3QranpIZXVWRHFyZ0tSZWE0MjBNZ1A5dFVB?=
 =?utf-8?B?NmxYUzFKTXJCdHNucXM4QzRuUmVoUjNUWHhDb01NWlJjRld4ZlhJZ0o4TnEw?=
 =?utf-8?B?Z2VXUzlxYWNDUjYxSHpoQmVLUXAzL0xDUzBaMlhmUUVIUEVKczV4anZqRjFR?=
 =?utf-8?B?K2w3YXRlTHNiVVYvYWI5aElKekF4V0pJMUd1UVptVzBKMnBnUGZwd091ZW5a?=
 =?utf-8?B?eEJwMGhaR0xNaVFEMkZHZXNGRk1nT0hVZjhYWVRVZzB1TFZpYXYwWE1kR3V3?=
 =?utf-8?Q?DPiOfVwgb+4KRJLyFE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F2EE1D2DCDEA54187F73C0252C64C7D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5198.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e8d26b-b2e8-46a7-b109-08d9f5a6cefb
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 01:58:23.5156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AzeyHH20JROcJTonupI0ybZnP1osg+qtNlC0bYR5JfWNpmZygixlukCZgiejZdKsoXPWCvu6FwI9YMg40Jh52w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTAyLTE3IGF0IDE0OjQ5ICswMjAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IE9uIFRodSwgRmViIDE3LCAyMDIyIGF0IDA4OjI4OjAzQU0gKzAwMDAsIEppYW5ibyBMaXUg
d3JvdGU6DQo+ID4gQXMgbW9yZSBwb2xpY2UgcGFyYW1ldGVycyBhcmUgcGFzc2VkIHRvIGZsb3df
b2ZmbG9hZCwgZHJpdmVyIGNhbg0KPiA+IGNoZWNrDQo+ID4gdGhlbSB0byBtYWtlIHN1cmUgaGFy
ZHdhcmUgaGFuZGxlcyBwYWNrZXRzIGluIHRoZSB3YXkgaW5kaWNhdGVkIGJ5DQo+ID4gdGMuDQo+
ID4gVGhlIGNvbmZvcm0tZXhjZWVkIGNvbnRyb2wgc2hvdWxkIGJlIGRyb3AvcGlwZSBvciBkcm9w
L29rLiBCZXNpZGVzLA0KPiA+IGZvciBkcm9wL29rLCB0aGUgcG9saWNlIHNob3VsZCBiZSB0aGUg
bGFzdCBhY3Rpb24uIEFzIGhhcmR3YXJlDQo+ID4gY2FuJ3QNCj4gPiBjb25maWd1cmUgcGVha3Jh
dGUvYXZyYXRlL292ZXJoZWFkLCBvZmZsb2FkIHNob3VsZCBub3QgYmUgc3VwcG9ydGVkDQo+ID4g
aWYNCj4gPiBhbnkgb2YgdGhlbSBpcyBjb25maWd1cmVkLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEppYW5ibyBMaXUgPGppYW5ib2xAbnZpZGlhLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogUm9p
IERheWFuIDxyb2lkQG52aWRpYS5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IElkbyBTY2hpbW1lbCA8
aWRvc2NoQG52aWRpYS5jb20+DQo+ID4gLS0tDQo+IA0KPiBUZXN0ZWQtYnk6IFZsYWRpbWlyIE9s
dGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+DQo+IA0KPiBCdXQgY291bGQgd2UgY3V0IGRv
d24gb24gbGluZSBsZW5ndGggYSBsaXR0bGU/IEV4YW1wbGUgZm9yIHNqYTExMDUNCj4gKG1lc3Nh
Z2VzIHdlcmUgYWxzbyBzaG9ydGVuZWQpOg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2RzYS9zamExMTA1L3NqYTExMDVfZmxvd2VyLmMNCj4gYi9kcml2ZXJzL25ldC9kc2Evc2phMTEw
NS9zamExMTA1X2Zsb3dlci5jDQo+IGluZGV4IDhhMTRkZjhjZjkxZS4uNTRhMTYzNjlhMzllIDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2Evc2phMTEwNS9zamExMTA1X2Zsb3dlci5jDQo+
ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9zamExMTA1L3NqYTExMDVfZmxvd2VyLmMNCj4gQEAgLTMw
MCw2ICszMDAsNDYgQEAgc3RhdGljIGludCBzamExMTA1X2Zsb3dlcl9wYXJzZV9rZXkoc3RydWN0
DQo+IHNqYTExMDVfcHJpdmF0ZSAqcHJpdiwNCj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRU9Q
Tk9UU1VQUDsNCj4gwqB9DQo+IMKgDQo+ICtzdGF0aWMgaW50IHNqYTExMDVfcG9saWNlcl92YWxp
ZGF0ZShjb25zdCBzdHJ1Y3QgZmxvd19hY3Rpb24NCj4gKmFjdGlvbiwNCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGNvbnN0IHN0cnVjdCBmbG93X2FjdGlvbl9lbnRyeQ0KPiAqYWN0LA0KPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
c3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKQ0KPiArew0KPiArwqDCoMKgwqDCoMKgwqBp
ZiAoYWN0LT5wb2xpY2UuZXhjZWVkLmFjdF9pZCAhPSBGTE9XX0FDVElPTl9EUk9QKSB7DQo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBOTF9TRVRfRVJSX01TR19NT0QoZXh0YWNrLA0K
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgICJPZmZsb2FkIG5vdCBzdXBwb3J0ZWQgd2hlbiBleGNlZWQNCj4gYWN0aW9u
IGlzIG5vdCBkcm9wIik7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
LUVPUE5PVFNVUFA7DQo+ICvCoMKgwqDCoMKgwqDCoH0NCj4gKw0KPiArwqDCoMKgwqDCoMKgwqBp
ZiAoYWN0LT5wb2xpY2Uubm90ZXhjZWVkLmFjdF9pZCAhPSBGTE9XX0FDVElPTl9QSVBFICYmDQo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoCBhY3QtPnBvbGljZS5ub3RleGNlZWQuYWN0X2lkICE9IEZM
T1dfQUNUSU9OX0FDQ0VQVCkgew0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgTkxf
U0VUX0VSUl9NU0dfTU9EKGV4dGFjaywNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAiT2ZmbG9hZCBub3Qgc3VwcG9y
dGVkIHdoZW4NCj4gY29uZm9ybSBhY3Rpb24gaXMgbm90IHBpcGUgb3Igb2siKTsNCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRU9QTk9UU1VQUDsNCj4gK8KgwqDCoMKg
wqDCoMKgfQ0KPiArDQo+ICvCoMKgwqDCoMKgwqDCoGlmIChhY3QtPnBvbGljZS5ub3RleGNlZWQu
YWN0X2lkID09IEZMT1dfQUNUSU9OX0FDQ0VQVCAmJg0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqAg
IWZsb3dfYWN0aW9uX2lzX2xhc3RfZW50cnkoYWN0aW9uLCBhY3QpKSB7DQo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBOTF9TRVRfRVJSX01TR19NT0QoZXh0YWNrLA0KPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgICJPZmZsb2FkIG5vdCBzdXBwb3J0ZWQgd2hlbg0KPiBjb25mb3JtIGFjdGlvbiBpcyBvaywg
YnV0IGFjdGlvbiBpcyBub3QgbGFzdCIpOw0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiArwqDCoMKgwqDCoMKgwqB9DQo+ICsNCj4gK8KgwqDC
oMKgwqDCoMKgaWYgKGFjdC0+cG9saWNlLnBlYWtyYXRlX2J5dGVzX3BzIHx8DQo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoCBhY3QtPnBvbGljZS5hdnJhdGUgfHwgYWN0LT5wb2xpY2Uub3ZlcmhlYWQp
IHsNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoE5MX1NFVF9FUlJfTVNHX01PRChl
eHRhY2ssDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgIk9mZmxvYWQgbm90IHN1cHBvcnRlZCB3aGVuDQo+IHBlYWty
YXRlL2F2cmF0ZS9vdmVyaGVhZCBpcyBjb25maWd1cmVkIik7DQo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqByZXR1cm4gLUVPUE5PVFNVUFA7DQo+ICvCoMKgwqDCoMKgwqDCoH0NCj4g
Kw0KPiArwqDCoMKgwqDCoMKgwqBpZiAoYWN0LT5wb2xpY2UucmF0ZV9wa3RfcHMpIHsNCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoE5MX1NFVF9FUlJfTVNHX01PRChleHRhY2ssDQo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgIlFvUyBvZmZsb2FkIG5vdCBzdXBwb3J0IHBhY2tldHMNCj4gcGVyIHNlY29u
ZCIpOw0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FT1BOT1RTVVBQ
Ow0KPiArwqDCoMKgwqDCoMKgwqB9DQo+ICsNCj4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIDA7DQo+
ICt9DQo+ICsNCj4gwqBpbnQgc2phMTEwNV9jbHNfZmxvd2VyX2FkZChzdHJ1Y3QgZHNhX3N3aXRj
aCAqZHMsIGludCBwb3J0LA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBmbG93X2Nsc19vZmZsb2FkICpjbHMsIGJvb2wNCj4gaW5n
cmVzcykNCj4gwqB7DQo+IEBAIC0zMjEsMzkgKzM2MSwxMCBAQCBpbnQgc2phMTEwNV9jbHNfZmxv
d2VyX2FkZChzdHJ1Y3QgZHNhX3N3aXRjaA0KPiAqZHMsIGludCBwb3J0LA0KPiDCoMKgwqDCoMKg
wqDCoMKgZmxvd19hY3Rpb25fZm9yX2VhY2goaSwgYWN0LCAmcnVsZS0+YWN0aW9uKSB7DQo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3dpdGNoIChhY3QtPmlkKSB7DQo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY2FzZSBGTE9XX0FDVElPTl9QT0xJQ0U6DQo+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGFjdC0+cG9s
aWNlLmV4Y2VlZC5hY3RfaWQgIT0NCj4gRkxPV19BQ1RJT05fRFJPUCkgew0KPiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBOTF9T
RVRfRVJSX01TR19NT0QoZXh0YWNrLA0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgIlBvbGljZSBvZmZsb2FkIGlzDQo+IG5vdCBzdXBwb3J0ZWQgd2hlbiB0aGUg
ZXhjZWVkIGFjdGlvbiBpcyBub3QgZHJvcCIpOw0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVPUE5PVFNVUFA7
DQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQ0KPiAt
DQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGFj
dC0+cG9saWNlLm5vdGV4Y2VlZC5hY3RfaWQgIT0NCj4gRkxPV19BQ1RJT05fUElQRSAmJg0KPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBhY3Qt
PnBvbGljZS5ub3RleGNlZWQuYWN0X2lkICE9DQo+IEZMT1dfQUNUSU9OX0FDQ0VQVCkgew0KPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBOTF9TRVRfRVJSX01TR19NT0QoZXh0YWNrLA0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgIlBvbGljZSBvZmZsb2FkIGlzDQo+IG5vdCBzdXBwb3J0ZWQg
d2hlbiB0aGUgY29uZm9ybSBhY3Rpb24gaXMgbm90IHBpcGUgb3Igb2siKTsNCj4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0
dXJuIC1FT1BOT1RTVVBQOw0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoH0NCj4gLQ0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoGlmIChhY3QtPnBvbGljZS5ub3RleGNlZWQuYWN0X2lkID09DQo+IEZMT1dfQUNU
SU9OX0FDQ0VQVCAmJg0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAhZmxvd19hY3Rpb25faXNfbGFzdF9lbnRyeSgmcnVsZS0+YWN0aW9uLA0K
PiBhY3QpKSB7DQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoE5MX1NFVF9FUlJfTVNHX01PRChleHRhY2ssDQo+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAiUG9saWNlIG9mZmxvYWQgaXMNCj4g
bm90IHN1cHBvcnRlZCB3aGVuIHRoZSBjb25mb3JtIGFjdGlvbiBpcyBvaywgYnV0IHBvbGljZSBh
Y3Rpb24gaXMgbm90DQo+IGxhc3QiKTsNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0NCj4gLQ0KPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChhY3QtPnBv
bGljZS5wZWFrcmF0ZV9ieXRlc19wcyB8fA0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBhY3QtPnBvbGljZS5hdnJhdGUgfHwgYWN0LQ0KPiA+
cG9saWNlLm92ZXJoZWFkKSB7DQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoE5MX1NFVF9FUlJfTVNHX01PRChleHRhY2ssDQo+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAiUG9saWNlIG9mZmxv
YWQgaXMNCj4gbm90IHN1cHBvcnRlZCB3aGVuIHBlYWtyYXRlL2F2cmF0ZS9vdmVyaGVhZCBpcyBj
b25maWd1cmVkIik7DQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRU9QTk9UU1VQUDsNCj4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9DQo+IC0NCj4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoYWN0LT5wb2xpY2UucmF0ZV9w
a3RfcHMpIHsNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgTkxfU0VUX0VSUl9NU0dfTU9EKGV4dGFjaywNCj4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJRb1Mgb2ZmbG9hZCBub3QNCj4gc3Vw
cG9ydCBwYWNrZXRzIHBlciBzZWNvbmQiKTsNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmMgPSAtRU9QTk9UU1VQUDsNCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByYyA9IHNqYTEx
MDVfcG9saWNlcl92YWxpZGF0ZSgmcnVsZS0+YWN0aW9uLA0KPiBhY3QsDQo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBleHRhY2spOw0KPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChyYykNCj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGdvdG8gb3V0Ow0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoH0NCj4gwqANCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgcmMgPSBzamExMTA1X2Zsb3dlcl9wb2xpY2VyKHByaXYsIHBvcnQsDQo+IGV4dGFjaywg
Y29va2llLA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
JmtleSwNCj4gDQo+IEFsc28sIGlmIHlvdSBjcmVhdGUgYSAidmFsaWRhdGUiIGZ1bmN0aW9uIGZv
ciBldmVyeSBkcml2ZXIsIHlvdSdsbA0KPiByZW1vdmUgY29kZSBkdXBsaWNhdGlvbiBmb3IgdGhv
c2UgZHJpdmVycyB0aGF0IHN1cHBvcnQgYm90aCBtYXRjaGFsbA0KPiBhbmQNCj4gZmxvd2VyIHBv
bGljZXJzLg0KDQpIaSBWbGFkaW1pciwNCg0KSSdkIGxvdmUgdG8gaGVhciB5b3VyIHN1Z2dlc3Rp
b24gcmVnYXJkaW5nIHdoZXJlIHRoaXMgdmFsaWRhdGUgZnVuY3Rpb24NCnRvIGJlIHBsYWNlZCBm
b3IgZHJpdmVycy9uZXQvZXRoZXJuZXQvbXNjYywgYXMgaXQgd2lsbCBiZSB1c2VkIGJ5IGJvdGgN
Cm9jZWxvdF9uZXQuYyBhbmQgb2NlbG90X2Zsb3dlci5jLiANCg0KVGhhbmtzIQ0KSmlhbmJvDQo=
