Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096ED5B8862
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 14:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiINMiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 08:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiINMiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 08:38:15 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2055.outbound.protection.outlook.com [40.107.212.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19356A48E;
        Wed, 14 Sep 2022 05:38:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiiTLvmlxTVxIB79aF+ZN6Ourz084427QnxAYh7oKq+agI6Bxfzp+h4s4xn0ysUE9e7Qi4zDYZC31ZOQ3PNWIQE8ddNuK2O9Nsg4MxGHFUZoYDsD/EdJr+wPBdCTlNG3dPaifdwtKDxg3a15OKAwPwGvrOIGNYeGV3bVAfLf+7kAKH55obInAPOhd21kKyyQL3Azoogty1OMIHlYC+akgOQXxTa/LZHNNtRVjb9bZEG3WgmUEu7cjT6ycvW6zpUr+uUNtPwDGIvPcOUD486g0P4Y6nx8uCUDiHkfMi94KrCIubCBe0FS962Zz2x5GSTsIUNgqPlhNw/Z1JrcbpQddg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/tYYaNmgtl44etVIpmOOeAbwXHxIB7qch7YTwhzke8=;
 b=Zl1dBRZKVKFUKiE5KEfrp0MeZA2U1LKZcSOcwMUUAiANVk0hKAM/Pi4aF55f+DAXp5pkbydNVwlXU7HtEY/69STkwiwjMUlrugX9LdEC8fUcFdCJC/N7ICbB/I3gsiK1Y0lGK75Ru5bM2eNVsK8tw/8W+klFNAwJMAihO9YtEj+lfjzLELwo2aluz4dooBCKtl9uBUbKYnPjm8se+/4EgeAsBQj2DcEDP0xmYYKmvXSn2pvmUDUYgiGggQZmENLdHpAQbgg691XrXf9WZo0z01PHswyF+w312ZVwaEptSA3aXGI9DUOuJZUp25HUDfJwOAB68CrpeBVKQslp6ekCgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/tYYaNmgtl44etVIpmOOeAbwXHxIB7qch7YTwhzke8=;
 b=MqxugnjAdxEI4vOcy3IOUNTkbhd/iiqwYdVPIp/NSTJPK9WPJcOsmOd2ZMdme1xJ/WeIj418HZLHh6ddpGKgA9K/4OLF+hwyQELoqEkE9NDX8uQOniQ9UANY+b2vTyt7CoK1qGXIuWynk62X8UbMZAqv8nx15r5SpZ7a7XwoIvxVTkRRCwOimeX9wel8Oe+F7Xhc2sg8IWeuMFgGq+ghb6R+5hE8KDyGRDvIC66xcLrCXGjuzQjjrB0DhsYZ1zO9fxqjH+VXi4K0rb/ZcZGaQbAQMr4nn/2QOAjm2eox/eD+c/ICv1gB97Vk8HhcJ7ZSrMBrexOap6R9kkQb4Cy+SQ==
Received: from DM4PR12MB5357.namprd12.prod.outlook.com (2603:10b6:5:39b::24)
 by DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Wed, 14 Sep
 2022 12:38:11 +0000
Received: from DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::ec0e:6950:ee5b:8066]) by DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::ec0e:6950:ee5b:8066%8]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 12:38:11 +0000
From:   Raed Salem <raeds@nvidia.com>
To:     Yang Yingliang <yangyingliang@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH -next 2/2] net/mlx5e: Switch to kmemdup() when allocate
 dev_addr
Thread-Topic: [PATCH -next 2/2] net/mlx5e: Switch to kmemdup() when allocate
 dev_addr
Thread-Index: AQHYx31PNOR1m7NKl0STfmX3LsUt8q3e3kCw
Date:   Wed, 14 Sep 2022 12:38:11 +0000
Message-ID: <DM4PR12MB53570152F63498E1BEF59EE0C9469@DM4PR12MB5357.namprd12.prod.outlook.com>
References: <20220913143713.1998778-1-yangyingliang@huawei.com>
 <20220913143713.1998778-2-yangyingliang@huawei.com>
In-Reply-To: <20220913143713.1998778-2-yangyingliang@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR12MB5357:EE_|DM6PR12MB4220:EE_
x-ms-office365-filtering-correlation-id: c43da37b-175a-40d1-06db-08da964dfc01
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mhKhI2RJ6j3N8jmN9t8NHXWW1gAe37Yz1aiwbStlR5rThsmTgDLLmQPnrd32E7yTsJL1blcLF4q69IzgJQL1sOMeqBLxgLUqXGoEOJW9EWknD6Bvwhj3Xowp3kRA2F+zLksRPye0VB0dkj/zgR2ZcjYQSBJr8lRy7YT0hFnCPNS73FQa1Qj543BC8ev3SWmlxEyMznLa1GbsWTIONnGxl+kdWMiYow7l0cizPOYy2EhO0LXmzy/jaT4B3HgDD/szFkQ1K7vAzIbLMsVS59VBFQck1IDQjcdelS6Oz/gW67FVNVFHmIRN+XeLiovtQKKIpJgJp63yaTn0dZpkTT4QOZNDcTJTaCv44G3EiZJSQ0eVYJp9T8+kdG0Qilysuobc84Z1yNvHPpTcI9NQ+gJ+UwqWVOp3QbxsZo2F56npkJNai5YpBy3gRQY3ckR2XPsq19RB2V/+Hh6Bq6rKmgJ6YONBG9lLxgFFdSxCHmBaGe8+4xqytvMBLvSdBQjHoBIfilr9Lk5cKqbfq8V+K/JcpD9U+8KQwXwBYDZvwH85b0R4+SzAG4M6dQa4xTV56qB0jK8YrFZJdwcxZBP7jyyoFRFMvKDgcqBcUE1CvstuVdJyLStI+0HrOUfPzdvaXAA6ADmvIZm18B4zz202kT//RdrAzjCSimgBWiSTPb6vIWo2Ro1n0TIerEbEJyq2x3D3rULNOzqFz+kqkaRzhvEKi7DQ4r65KwjX9NgKnZFSDpl15/BCC6qU45bwtOrG6J/sxjMenekoeJP85+sfoOlI/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5357.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(451199015)(478600001)(54906003)(64756008)(38070700005)(71200400001)(41300700001)(76116006)(66446008)(66476007)(5660300002)(33656002)(316002)(6506007)(8676002)(4326008)(52536014)(2906002)(66946007)(55016003)(186003)(66556008)(8936002)(26005)(38100700002)(9686003)(7696005)(83380400001)(86362001)(122000001)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZFdkbXRFakNKemJkVG9hREZxSnhXd1YrNTdnV3NxWm1ldDBtWmd0Nis4ZkJp?=
 =?utf-8?B?cEZERS9xWkZJTmtuQlhXODlKOFpEaWpZRThaV2pnd0F1LzBnY3pzenRJZm5K?=
 =?utf-8?B?MTMvRU5BUTg4TGVXU29rWFlES1BRdTQ0d2lQdE5EMkRxWUtLazhDd24zYXd6?=
 =?utf-8?B?Q01GSWJkTS8wejNSQU9Da041VkVzYmpwZlRUeDFER2tXK0lUSWRLd3pmZU1E?=
 =?utf-8?B?M0tFVXp2U3I1V1FQYnVVMHdDWlRkZXNZUXViL1ExY01RelJkWHBqKzJzZy9X?=
 =?utf-8?B?anM5a0RBQjN3NmhkRDZRNlhIZFYxR3czdnQ0cVlOT0xvZEtZbjdhM1MwRWhW?=
 =?utf-8?B?c3RuNk1uTzhpS2hpRVpkYmN5Z1hDSy80YzBPcVBWNlkxVEZNVUcxMnM1SjlY?=
 =?utf-8?B?WitkL2VkYlp3NGZneWh2SGhJd1pINDJFaGxEa2cycGdJWFZ3dW5DdDNGZVU2?=
 =?utf-8?B?OTRXbktFUnJRYnFSbzJaenhCMHNab3pnVFNRTm92UDhpRnMvWGFOeTZzeXZl?=
 =?utf-8?B?NXRoTWQwWHdGU1J5UHdrUTUxK0twU2ZiMlhKNHMvT2NTZDhjWDVseXdoVGxr?=
 =?utf-8?B?ZVlUZm9LNzJhV3FoWmxOSmtGWW9LekVrMnYzeUdjQjZLSGtQL3NiazgrK0M5?=
 =?utf-8?B?bW5xQjUrVVpSUE5iZ1RSQ0dlcmJMTTZhYytEVmlWR1dDaDhzYjlJdXN5RUpq?=
 =?utf-8?B?ZVE4Q2tBYm1MWjlMTTZoeFAzWGk0MWE2NkxXZEVvV3J3Unl2SXlxWXUrdXRy?=
 =?utf-8?B?UUxUN0hJQnpMb0JJZHRkRTh6c1lsMkY3ZW1zRXZTZjNTU3R3eENFUmxvcFI2?=
 =?utf-8?B?dnl3WW9oV0ZsODhHOCtPSS9SYTU5eWhtUlI5VTdZMXlXZHFOQzFXZmRhYk9l?=
 =?utf-8?B?MklBeEZQZEpLK2hPcGR5QkRpOHR6YTVBcjBKbG5pU2cwK2g5YTQxS0huRk5m?=
 =?utf-8?B?MWlRR1NMYjRYL0t0czA4cDhLSCs4cWJYU0R1Y2tzdFBpVUR4dnpib0IxRVlT?=
 =?utf-8?B?ek1ZOW4xNFIvU1hyS2xPUWErcGpHYmt4ZWtFSUtjTjl0dHlWNXdMNXpCZWlq?=
 =?utf-8?B?YTlScTR2MENWcTltNDV6S0FoWlpITU1udVlBTlZaTExOUFpKYXRSTWtVTDh5?=
 =?utf-8?B?QW1TOGRhcWJCOUQyQjlzaURmOUdnZXFyZzdIcEIvcnM1MDhlc2c3MGZVbkpC?=
 =?utf-8?B?dzlwWGRLS2tHUGNGYlZRVUtTMmRkVnhWNzhxQVhqa1Z1V0RZVnVLTi90Nmto?=
 =?utf-8?B?YnRXd0pvQjY0dmNhc0QzS2k5MHVTT3IwSlgyb2gxVkZNcEU0YTBnR29qOUQz?=
 =?utf-8?B?cGs4WWloaE4vZk5HUWxqNWQzdkI5SWk3cVBQVkswVTFtSGdaUVJwL3Vic3pj?=
 =?utf-8?B?SEJvNFNYd25wSTlHL1JXU0d0bzhWbTZMTkhYRkZQOE9pazQvQkpzSGFFSUEy?=
 =?utf-8?B?OVA5UTBlVjNlRzBiTzYxZmtGT1hrMzNxZ2g2alRoSWhENlpNOEJockMvdkJu?=
 =?utf-8?B?UUdYanVNb0RHQW5ZY3NId1lnQWpOamF1cWJ0Z3gzNlhMOG1TemNlNGFNSEdQ?=
 =?utf-8?B?dHZ5Y01PUnhZUVQ5ZmVjRHF6YjNtampSdDBGdnNDK2tqWWQ3MzhWb0o5SnVD?=
 =?utf-8?B?a21oV05tdE95TmtXVDFMTStpVm1ObVBXZi9rODgwb0x2elF6c0xJbVBXUHFY?=
 =?utf-8?B?NVJadDh3UEE0YkRGNC96S2FpbkttSDl1dmtKRnhRZUxPUTBpWGwyMU1Gcmg5?=
 =?utf-8?B?ZnFDL21xVDFOWUNRc2x0Qlg2NnhGZnRmVUc0OFBNU2FqZEMvSC9RYVZwcGJL?=
 =?utf-8?B?MTdZclhBNGcrWUxYb3pnT1l6NGd1cnVHSGNtSEsvdTdSSEdnV0svU3BZcmxI?=
 =?utf-8?B?VE9Eamd0aHJmbHFBd2VNZ1Erb2VBRTdXRkN3TG5oRGp6SkdaTXlGYzdxaWVR?=
 =?utf-8?B?dTJCNitia1ZnekdyVFZoZzIySlFJWUdTOUQ5bUxiay9RenlDRlhkU2p5eGlk?=
 =?utf-8?B?YXJ3dlZPZUJPSzN5cGkzTGVBWjRJaEZ5OTZDcTNrNFBHUHhvamJ4QndVc2dD?=
 =?utf-8?B?K3l6a0FmYUxYeVhadnI0U0hRZHdNOTlGN2pENzdhenN0WUpjeVJDNnBPSnNq?=
 =?utf-8?Q?H6NE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5357.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c43da37b-175a-40d1-06db-08da964dfc01
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 12:38:11.0764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fYmtSe7Hb1Z5pBhULwodBA5UDU508tF/uLFnmuWsN2Gns9d4khT4YYSQ/FKNJdNyZXSi6+XOYQBUafBHrh68Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4220
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IFlhbmcgWWluZ2xpYW5nIDx5
YW5neWluZ2xpYW5nQGh1YXdlaS5jb20+DQo+U2VudDogVHVlc2RheSwgMTMgU2VwdGVtYmVyIDIw
MjIgMTc6MzcNCj5UbzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtcmRtYUB2Z2VyLmtl
cm5lbC5vcmcNCj5DYzogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBudmlkaWEuY29tPjsgTGlvciBO
YWhtYW5zb24NCj48bGlvcm5hQG52aWRpYS5jb20+OyBSYWVkIFNhbGVtIDxyYWVkc0BudmlkaWEu
Y29tPjsNCj5kYXZlbUBkYXZlbWxvZnQubmV0DQo+U3ViamVjdDogW1BBVENIIC1uZXh0IDIvMl0g
bmV0L21seDVlOiBTd2l0Y2ggdG8ga21lbWR1cCgpIHdoZW4gYWxsb2NhdGUNCj5kZXZfYWRkcg0K
Pg0KPkV4dGVybmFsIGVtYWlsOiBVc2UgY2F1dGlvbiBvcGVuaW5nIGxpbmtzIG9yIGF0dGFjaG1l
bnRzDQo+DQo+DQo+VXNlIGttZW1kdXAoKSBoZWxwZXIgaW5zdGVhZCBvZiBvcGVuLWNvZGluZyB0
byBzaW1wbGlmeSB0aGUgY29kZSB3aGVuDQo+YWxsb2NhdGUgZGV2X2FkZHIuDQo+DQo+U2lnbmVk
LW9mZi1ieTogWWFuZyBZaW5nbGlhbmcgPHlhbmd5aW5nbGlhbmdAaHVhd2VpLmNvbT4NCj4tLS0N
Cj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL21hY3Nl
Yy5jIHwgNCArKy0tDQo+IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pDQo+DQo+ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lbl9hY2NlbC9tYWNzZWMuYw0KPmIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuX2FjY2VsL21hY3NlYy5jDQo+aW5kZXggNWZhM2UyMmM4OTE4Li4wZjdj
NWI5YTM1NDEgMTAwNjQ0DQo+LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuX2FjY2VsL21hY3NlYy5jDQo+KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL21hY3NlYy5jDQo+QEAgLTkzNCwxNCArOTM0LDE0IEBA
IHN0YXRpYyBpbnQgbWx4NWVfbWFjc2VjX2FkZF9zZWN5KHN0cnVjdA0KPm1hY3NlY19jb250ZXh0
ICpjdHgpDQo+ICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPiAgICAgICAgfQ0KPg0KPi0gICAg
ICAgbWFjc2VjX2RldmljZS0+ZGV2X2FkZHIgPSBremFsbG9jKGRldi0+YWRkcl9sZW4sIEdGUF9L
RVJORUwpOw0KPisgICAgICAgbWFjc2VjX2RldmljZS0+ZGV2X2FkZHIgPSBrbWVtZHVwKGRldi0+
ZGV2X2FkZHIsIGRldi0+YWRkcl9sZW4sDQo+KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgR0ZQX0tFUk5FTCk7DQpJIHRoaW5rIGl0IGNvdWxkIGZpdCBpbiBvbmUgbGlu
ZSAodGhlIGttZW1kdXAgZnVuY3Rpb24gY2FsbCkNCj4gICAgICAgIGlmICghbWFjc2VjX2Rldmlj
ZS0+ZGV2X2FkZHIpIHsNCj4gICAgICAgICAgICAgICAga2ZyZWUobWFjc2VjX2RldmljZSk7DQo+
ICAgICAgICAgICAgICAgIGVyciA9IC1FTk9NRU07DQo+ICAgICAgICAgICAgICAgIGdvdG8gb3V0
Ow0KPiAgICAgICAgfQ0KPg0KPi0gICAgICAgbWVtY3B5KG1hY3NlY19kZXZpY2UtPmRldl9hZGRy
LCBkZXYtPmRldl9hZGRyLCBkZXYtPmFkZHJfbGVuKTsNCj4gICAgICAgIG1hY3NlY19kZXZpY2Ut
Pm5ldGRldiA9IGRldjsNCj4NCj4gICAgICAgIElOSVRfTElTVF9IRUFEX1JDVSgmbWFjc2VjX2Rl
dmljZS0+bWFjc2VjX3J4X3NjX2xpc3RfaGVhZCk7DQo+LS0NCj4yLjI1LjENCg0KVGhhbmtzLCBn
b29kIGNhdGNoDQoNCg==
