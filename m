Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0A75B4C32
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 07:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiIKFhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 01:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIKFha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 01:37:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498AF3ECF2;
        Sat, 10 Sep 2022 22:37:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SrQ9X7Fg2a2jtIya7SpnUGm1QrzSKoyvoYB+UQ8VT4qJXQIudOg5lEjEerzY5nhFFisAe/5X4gtaerLIs19Uc1/yGKaxgjeGOfcw/gu0gJHcTrhhRUZoSyNdfVetEmBTFPVhCjnFAABFcS9uhDb0YlLhU8ybn6oqhNYPEb4p1apasAKL6sUMzSAHxejIC9gy0eoR3N2ZXr43bScySBvIpkwI5Bqz2evJbzOMPw6akmJRMEWGKUroH4qozmGo7we4VDFM8gJi2rwlWTUvmDPSZ4QCvxGRR7GVyPFYoMND4wPg/iBiGp8KsJ759/cok8N2VxJLJKwGv7V1qIiJ9W4uFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEBNMiM1X/YsDhRRdVRZTFrxdzmSnYcUYHRrH7gfSPQ=;
 b=LHPoDgJFbqN0FL4CtsfjI9iZqp/LUaH9a46cyKxFaqj0fMzos8TY8MHvTviGPlQ3YAahuP0Gg/y42g+QHxkBG615U/WWH/X+/FnrmGJY3aaMJYFX4Kgzqw9iAG5fVMWdWXTgs02aeL/5A4uSP0g79m8jlIcnGBaru9Lrn28A7acnRYNOcWvlfFW/IPi+gYOwUdiwfVML/7+/gdCG/ri55nH9Y/v66kcyH+fpnmZ9zOBtKNNM26L4x4E+RK7zxoz+yXmq6EYgd59ycZ1M9z84jqy3m6KT9dgVtLIj/L0+F+ysP4/Z2JC1mCFmlaTFA6EyoRat0F/m8ukyCEG/iUwQqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEBNMiM1X/YsDhRRdVRZTFrxdzmSnYcUYHRrH7gfSPQ=;
 b=LkLWM0CHYYP/so/0ekei+WVevj2AvkAEltgJHL+zT4bcwv+47dMwo+9eLpn6DXE/E/061BBidVccN91pF7/AWRhos0mMbkhsJ/VaeGdqrH5DRWwkZUMBAMzO4kgq1bmqvQ6cOMM2lHtZB6a0msSrDRYxRzXrd3sG9k+4N3fvrkn4YqQdHkkdnGv+IAW2F57bu/lM3ghgz1O1ZdofndyuT+KGxmLg7SIsqXeiUpg8Z7bG7s0qV7HZdYiAHU4mdm6CzBjyFChG5YPBjPv4qSS1EhuRcD6D91zVLOPBhaGhJSJR9Pfuqzvrx9gEIcm2mHLU9uKeKeDfGU6SvGxLNJ/sJQ==
Received: from DM4PR12MB5357.namprd12.prod.outlook.com (2603:10b6:5:39b::24)
 by DM6PR12MB4187.namprd12.prod.outlook.com (2603:10b6:5:212::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 05:37:27 +0000
Received: from DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::ec0e:6950:ee5b:8066]) by DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::ec0e:6950:ee5b:8066%8]) with mapi id 15.20.5612.022; Sun, 11 Sep 2022
 05:37:27 +0000
From:   Raed Salem <raeds@nvidia.com>
To:     Tom Rix <trix@redhat.com>, Nathan Chancellor <nathan@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Nick Desaulniers <ndesaulniers@google.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH net-next] net/mlx5e: Ensure macsec_rule is always
 initiailized in macsec_fs_{r,t}x_add_rule()
Thread-Topic: [PATCH net-next] net/mlx5e: Ensure macsec_rule is always
 initiailized in macsec_fs_{r,t}x_add_rule()
Thread-Index: AQHYw5jCdqo7S6Fjp06+PFaLHx2lRK3VyqaAgAPpzIA=
Date:   Sun, 11 Sep 2022 05:37:26 +0000
Message-ID: <DM4PR12MB53570DA53F0DA74F132698EAC9459@DM4PR12MB5357.namprd12.prod.outlook.com>
References: <20220908153207.4048871-1-nathan@kernel.org>
 <43471538-22b3-b80e-a1c6-7f3e24bc414a@redhat.com>
In-Reply-To: <43471538-22b3-b80e-a1c6-7f3e24bc414a@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR12MB5357:EE_|DM6PR12MB4187:EE_
x-ms-office365-filtering-correlation-id: fec48ac2-29f0-4f63-e7ae-08da93b7b617
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sx+vMEAPcGKftexoBwt5J/nDh89w2QZRv7xG9aAoGBZEUpSLoEftVunlURlUNobbb5X8ZmxoezEX2+W3lRiaUNQTlMnW1ZvsHLYhC2P+MHIFVVTKZ+tEvoGMdNFF8O0ETJgdrSNZQAfkzfhH8PHVD+Tyti9v0Go1RFNAXsMvHzV2yYSH9C7I+GjnigmBJ6R+TItFoDHSno+m1aRKrj/0GKtDAJ8ZoZtCFvzKpnBosr0Ciz7v0AXQ56o2BIMe4U1bGgejHTgc9l+p9NoneU+0pashp4XekyKfGH/UxAqkeY035/Su5f6Xjibf3994mB8mETTv80unUW44bBYNidqlIG5CBdF1NKIfA7C23eS/aDZ/xMoc8UcIswUSNY/FlEh475WOUXy9F26vtfexVzARPA2YYA3HH9I6Q7AD2AyQpBG7QdAO4jd5GxgJmO0TN/KAlDNxKBxnnw+FGHNOEXCGB4rr6xXoQuMib7d3cGDcHwAqP9GAG7z+LpMnEWtS6HFkGhZtvxx/nd33diCHmU2q8S3jnyGwjeJsfPuE1+4mDrNGz3JH6rAPutyFwTuu7aMcHbcNw6J+iuQwfpLqn5qA8OAUmrpEe0lZnhGBhPZD3hQT6Zy9EzYPIY6yUJ99kwmLpknzNtbl247BjrsfZS4hhd9WL4fEJxou7zZ5kbmuRYMU/w+JwTAp2UANeIhyMB74RwTCCAOr8Vvhxz+hXNgqtlK1qDhmPdzd3bdM76Tm5ouJFK36gTM4hXOmZ01rtUnDHxfrMRa4/eO1vS7LzYKT+UJF6zuYhsLzbKzIk0LyxOIxUcMkVgpXPJ6T4QFe8MxKoGaEt3X8WGOd+XIUGMUQTvT3fq4QNQfWgeKgVM/c7AY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5357.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(26005)(38100700002)(9686003)(4326008)(66556008)(66946007)(64756008)(66476007)(66446008)(76116006)(122000001)(110136005)(54906003)(6506007)(41300700001)(86362001)(8676002)(55016003)(53546011)(7696005)(316002)(2906002)(38070700005)(8936002)(966005)(83380400001)(478600001)(52536014)(71200400001)(5660300002)(7416002)(33656002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?alVQbHZyaEZrTjdQajRhSU1iUHRtZGpqaTA0Wmtrd3djYlVPdHFJVi9TNW1Y?=
 =?utf-8?B?cEVvTURWREZPTDk0Vk9vYzdGMTJ1RGhKd0kzdE1ML1UrVmF5Rm9UL0IrRFB1?=
 =?utf-8?B?SDhseDZWelpDN1BrWTNka0ZRVnJoeWp4M2JWWUFCTkwwcTh0eFFRSTl6elJk?=
 =?utf-8?B?NEFKVnJ2SVRYMHlISVlaVHFVekY5T0dYMGFlcW0xbklvbUcvZ1ZVbEh5S3pj?=
 =?utf-8?B?ckV2Qkc1TlZrYmpDQ2gydGZnVXV2b2ZjOGZqcXYyc0FvTHFuVEU1eGRDTVEz?=
 =?utf-8?B?a1VSQ3dqRjFvY2NabzV4L2xpS205aExsbjlVZUk1R25xUGJhankrUTlUR3ZT?=
 =?utf-8?B?YnRBcHhOS2pWbkQ1Qyt0anIzdGl3djdrVm9lMFBmRkY0bkpzN21zVDRYNExB?=
 =?utf-8?B?aWdIc3lEVTNXVWZnWlVYbDN3eUZqK1p3cGVrVUF3SU82Ti9Ea25zZTRubXFv?=
 =?utf-8?B?U2J2QkI0VkFoNU1IeEdPaDYvL0NFUEthRlVpcTk2Rmhscjc2SGpjMVptaEIv?=
 =?utf-8?B?T0tOQUcxZ3ZUQkNzNXFnRUlOSGYrVUJuS1VIRXV6RUorWlpveVUwcGczUEdz?=
 =?utf-8?B?VGI3ak5Sc2hyeW9rVll1cW53WFltaEZ0cUUrUnMxS3hDV2ZaQzkzSkcxWUpH?=
 =?utf-8?B?aWZNU1RWK1Z3Ums5RUMxbUJpQlcwV29xT0RSak9UbzBtc1ZkWFBOd21ZSm5M?=
 =?utf-8?B?Z2g0QllHSUVVc0tYRjJJR0Q1Y0hrYnhNbVFtdDcxbHVQdEVta2d6ZWN0YzV3?=
 =?utf-8?B?WGZUaElnekwrZUZOVmdPMFM1Q0ZkSk5UcWhhWDc3cENTeDgzZEdhODBxeWxH?=
 =?utf-8?B?Kytzb1o5b1BTQ2hSYzdwNlZ3bS9YKzR5TDI3WDI3MWJHYVRBcURKYUtpc2xN?=
 =?utf-8?B?b05BOGZJSTBJM0NTTjFzMzY2Y1VHbEthYTJmT3doUmFYTzdWYno5T1BJMTNk?=
 =?utf-8?B?aEdKdzZWOVRKMTltTWZVQStkZ3FPdVJZLzlQbHJzY28yaTUzSnJUNTVWYXRQ?=
 =?utf-8?B?Y1plQzRUYjMzL2hJWEh1VGFJcDF1VW4rS3E4cUhUR2dJY0s1M0dRVkJ1MkFr?=
 =?utf-8?B?QmJUeWFLSDVjYzRhaWVwdlNpOVV6THdiU2lvazJaeVo2T1FqQnVkS0Zjdkd4?=
 =?utf-8?B?cXNsTlRDNHZDbTdnOGt6SXM2YUFoSlFTdWw3VFErZGdkMHI4S2laRkc1OHpE?=
 =?utf-8?B?NVF3YzNWYWorcEpxbEpPdmFOaThVT2ZORGlmQ0x5SElCR25MMjRCWjRWZytI?=
 =?utf-8?B?K1BjZHJSUjBLT2pvNzhRSXQrTkZIekRURE00Q3FiT3lXQ2d0dnZ5ZndIODBK?=
 =?utf-8?B?M0VSa0l1S2x5cCtySGJLZlhZZUJsMzg5RUYwV0xBNFF3UDN6SVFhOXJtSTBt?=
 =?utf-8?B?WmdCcXlYbTlIVEZEZGFpaE8rOXVxamdVSFFITnpONmNnNFgzUFhKc0x1UDRF?=
 =?utf-8?B?K1Q5KzR1MTlRVFIzaWZPcitjWnUvVVNYcm80eENXQmxhZFlLY2dzZG9pYnR5?=
 =?utf-8?B?UkdoQmtUZ2cyOGxoU29IWjl2MXk3dUZzSWRvZStqdDE0a3BLOUZIcDBwTjRy?=
 =?utf-8?B?UmFzcGF0bnNUT29BUzI1OHVIakxwblhIZm1ZSytKMVpidTI3L0ZOZE5qeGJx?=
 =?utf-8?B?V2lXTkhuVHZVTW8zd1dlS3krSUhSOFBrQkIwUDJ0L1V6eHNlZjUwL3grYlJl?=
 =?utf-8?B?T0Jqcld2WjY1WmhPNWdOakRKUXdad1QrTzF3M2tIRi9mM2V6VHNZZHllZ0tJ?=
 =?utf-8?B?S1N6RjVNUTdIaFAvbkdqV3UvYVYzZXJDU0d1R3A1dzdpM2VNZFVpZVA5WVdv?=
 =?utf-8?B?WXNCWUFkZU5qcldUL2x1YXpkeXFyU09SMnNLa0FaV2J4alk3cUpWcHhSeDIy?=
 =?utf-8?B?RFEwMGplR0dIQ1ZJU0JFYzJhcmE1ZmE4ckJFNUpUQTh0YTN1YmFES2RkM2Np?=
 =?utf-8?B?VDdzc29FUEdkaEhETy9TbU9OU1Nia0hOQndsN1dIK29hRlB1SmVpajJxNGh0?=
 =?utf-8?B?Q3BLeVlmRU1icTl5Y2ZIeklSNERoZ2lqVWFLZVR5R2JPUnp0ajFGakYzUW5P?=
 =?utf-8?B?cE1lQ0dOeExIVHlvUnhEd2tYSDVld0NyQytrL3lLcFhzZTdKeTRuODR5MXFJ?=
 =?utf-8?Q?mS2U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5357.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec48ac2-29f0-4f63-e7ae-08da93b7b617
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2022 05:37:26.9196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yGaWEttscHGTCkn14L2sRMI0mLWBcyit8EE/gK5CMcoT8adISL98Vl8fmueOd9uR+cJ7B1NWdhR024VlAnk6Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4187
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS84LzIyIDg6MzIgQU0sIE5hdGhhbiBDaGFuY2VsbG9yIHdyb3RlOg0KPj4gQ2xhbmcgd2Fy
bnM6DQo+Pg0KPj4gICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vu
X2FjY2VsL21hY3NlY19mcy5jOjUzOTo2OiBlcnJvcjogdmFyaWFibGUgJ21hY3NlY19ydWxlJyBp
cyB1c2VkIHVuaW5pdGlhbGl6ZWQgd2hlbmV2ZXIgJ2lmJyBjb25kaXRpb24gaXMgdHJ1ZSBbLVdl
cnJvciwtV3NvbWV0aW1lcy11bmluaXRpYWxpemVkXQ0KPj4gICAgICAgICAgICBpZiAoZXJyKQ0K
Pj4gICAgICAgICAgICAgICAgXn5+DQo+PiAgICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW5fYWNjZWwvbWFjc2VjX2ZzLmM6NTk4Ojk6IG5vdGU6IHVuaW5pdGlhbGl6
ZWQgdXNlIG9jY3VycyBoZXJlDQo+PiAgICAgICAgICAgIHJldHVybiBtYWNzZWNfcnVsZTsNCj4+
ICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn4NCj4+ICAgIGRyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9tYWNzZWNfZnMuYzo1Mzk6Mjogbm90ZTogcmVt
b3ZlIHRoZSAnaWYnIGlmIGl0cyBjb25kaXRpb24gaXMgYWx3YXlzIGZhbHNlDQo+PiAgICAgICAg
ICAgIGlmIChlcnIpDQo+PiAgICAgICAgICAgIF5+fn5+fn5+DQo+PiAgICBkcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fYWNjZWwvbWFjc2VjX2ZzLmM6NTIzOjM4OiBu
b3RlOiBpbml0aWFsaXplIHRoZSB2YXJpYWJsZSAnbWFjc2VjX3J1bGUnIHRvIHNpbGVuY2UgdGhp
cyB3YXJuaW5nDQo+PiAgICAgICAgICAgIHVuaW9uIG1seDVlX21hY3NlY19ydWxlICptYWNzZWNf
cnVsZTsNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Xg0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IE5V
TEwNCj4+ICAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2Nl
bC9tYWNzZWNfZnMuYzoxMTMxOjY6IGVycm9yOiB2YXJpYWJsZSAnbWFjc2VjX3J1bGUnIGlzIHVz
ZWQgdW5pbml0aWFsaXplZCB3aGVuZXZlciAnaWYnIGNvbmRpdGlvbiBpcyB0cnVlIFstV2Vycm9y
LC1Xc29tZXRpbWVzLXVuaW5pdGlhbGl6ZWRdDQo+PiAgICAgICAgICAgIGlmIChlcnIpDQo+PiAg
ICAgICAgICAgICAgICBefn4NCj4+ICAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lbl9hY2NlbC9tYWNzZWNfZnMuYzoxMjE1Ojk6IG5vdGU6IHVuaW5pdGlhbGl6ZWQg
dXNlIG9jY3VycyBoZXJlDQo+PiAgICAgICAgICAgIHJldHVybiBtYWNzZWNfcnVsZTsNCj4+ICAg
ICAgICAgICAgICAgICAgXn5+fn5+fn5+fn4NCj4+ICAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9tYWNzZWNfZnMuYzoxMTMxOjI6IG5vdGU6IHJlbW92
ZSB0aGUgJ2lmJyBpZiBpdHMgY29uZGl0aW9uIGlzIGFsd2F5cyBmYWxzZQ0KPj4gICAgICAgICAg
ICBpZiAoZXJyKQ0KPj4gICAgICAgICAgICBefn5+fn5+fg0KPj4gICAgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL21hY3NlY19mcy5jOjExMTg6Mzg6IG5v
dGU6IGluaXRpYWxpemUgdGhlIHZhcmlhYmxlICdtYWNzZWNfcnVsZScgdG8gc2lsZW5jZSB0aGlz
IHdhcm5pbmcNCj4+ICAgICAgICAgICAgdW5pb24gbWx4NWVfbWFjc2VjX3J1bGUgKm1hY3NlY19y
dWxlOw0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBe
DQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0gTlVM
TA0KV2h5IG5vdCBkbyBhcyBzdWdnZXN0ZWQgYW5kIGluaXRpYWxpemUgdGhlIG1hY3NlY19ydWxl
IHRvIE5VTEwgKGFuZCBjaGFuZ2UgcGxhY2VtZW50IHRvIGNvbXBseSB3aXRoIHJldmVyc2VkIENo
cmlzdG1hcyB0cmVlIHBhcmFtZXRlcnMgb3JkZXIpID8NCml0IGlzIGNsZWFuZXIgYW5kIGFkaGVy
aW5nIHRvIHNpbWlsYXIgZXJyb3IgcGF0aHMgaW4gdGhlIG1seDUgZHJpdmVyLCB0aGFua3MgZm9y
IHRoZSBjYXRjaC4NCj4+ICAgIDIgZXJyb3JzIGdlbmVyYXRlZC4NCj4+DQo+PiBJZiBtYWNzZWNf
ZnNfe3IsdH14X2Z0X2dldCgpIGZhaWwsIG1hY3NlY19ydWxlIHdpbGwgYmUgdW5pbml0aWFsaXpl
ZC4NCj4+IFVzZSB0aGUgZXhpc3RpbmcgaW5pdGlhbGl6YXRpb24gdG8gTlVMTCBpbiB0aGUgZXhp
c3RpbmcgZXJyb3IgcGF0aCB0byANCj4+IGVuc3VyZSBtYWNzZWNfcnVsZSBpcyBhbHdheXMgaW5p
dGlhbGl6ZWQuDQo+Pg0KPj4gRml4ZXM6IGU0NjdiMjgzZmZkNSAoIm5ldC9tbHg1ZTogQWRkIE1B
Q3NlYyBUWCBzdGVlcmluZyBydWxlcyIpDQo+PiBGaXhlczogM2IyMDk0OWNiMjFiICgibmV0L21s
eDVlOiBBZGQgTUFDc2VjIFJYIHN0ZWVyaW5nIHJ1bGVzIikNCj4+IExpbms6IGh0dHBzOi8vZ2l0
aHViLmNvbS9DbGFuZ0J1aWx0TGludXgvbGludXgvaXNzdWVzLzE3MDYNCj4+IFNpZ25lZC1vZmYt
Ynk6IE5hdGhhbiBDaGFuY2VsbG9yIDxuYXRoYW5Aa2VybmVsLm9yZz4NCj5SZXZpZXdlZC1ieTog
VG9tIFJpeCA8dHJpeEByZWRoYXQuY29tPg0KPj4gLS0tDQo+Pg0KPj4gVGhlIG90aGVyIGZpeCBJ
IGNvbnNpZGVyZWQgd2FzIHNodWZmbGluZyB0aGUgdHdvIGlmIHN0YXRlbWVudHMgc28gdGhhdCAN
Cj4+IHRoZSBhbGxvY2F0aW9uIG9mIG1hY3NlY19ydWxlIGNhbWUgYmVmb3JlIHRoZSBjYWxsIHRv
DQo+PiBtYWNzZWNfZnNfe3IsdH14X2Z0X2dldCgpIGJ1dCBJIHdhcyBub3Qgc3VyZSB3aGF0IHRo
ZSBpbXBsaWNhdGlvbnMgb2YgDQo+PiB0aGF0IGNoYW5nZSB3ZXJlLg0KPj4NCj4+IEFsc28sIEkg
dGhvdWdodCBuZXRkZXYgd2FzIGRvaW5nIHRlc3Rpbmcgd2l0aCBjbGFuZyBzbyB0aGF0IG5ldyAN
Cj4+IHdhcm5pbmdzIGRvIG5vdCBzaG93IHVwLiBEaWQgc29tZXRoaW5nIGJyZWFrIG9yIHN0b3Ag
d29ya2luZyBzaW5jZSANCj4+IHRoaXMgaXMgdGhlIHNlY29uZCB0aW1lIGluIHR3byB3ZWVrcyB0
aGF0IG5ldyB3YXJuaW5ncyBoYXZlIGFwcGVhcmVkIGluIC1uZXh0Pw0KPj4NCj4+ICAgLi4uL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fYWNjZWwvbWFjc2VjX2ZzLmMgICAgfCA2
ICsrKystLQ0KPj4gICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgDQo+PiBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl9hY2NlbC9tYWNzZWNfZnMuYyANCj4+IGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL21hY3NlY19mcy5jDQo+PiBpbmRleCA2
MDhmYmJhYTVhNTguLjQ0NjdlODhkN2U3ZiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9tYWNzZWNfZnMuYw0KPj4gKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL21hY3NlY19m
cy5jDQo+PiBAQCAtNTM3LDcgKzUzNyw3IEBAIG1hY3NlY19mc190eF9hZGRfcnVsZShzdHJ1Y3Qg
bWx4NWVfbWFjc2VjX2ZzIA0KPj4gKm1hY3NlY19mcywNCj4+DQo+PiAgICAgIGVyciA9IG1hY3Nl
Y19mc190eF9mdF9nZXQobWFjc2VjX2ZzKTsNCj4+ICAgICAgIGlmIChlcnIpDQo+PiAtICAgICAg
ICAgICAgIGdvdG8gb3V0X3NwZWM7DQo+PiArICAgICAgICAgICAgIGdvdG8gb3V0X3NwZWNfbm9f
cnVsZTsNCj4+DQo+PiAgICAgICBtYWNzZWNfcnVsZSA9IGt6YWxsb2Moc2l6ZW9mKCptYWNzZWNf
cnVsZSksIEdGUF9LRVJORUwpOw0KPj4gICAgICAgaWYgKCFtYWNzZWNfcnVsZSkgew0KPj4gQEAg
LTU5MSw2ICs1OTEsNyBAQCBtYWNzZWNfZnNfdHhfYWRkX3J1bGUoc3RydWN0IG1seDVlX21hY3Nl
Y19mcyANCj4+ICptYWNzZWNfZnMsDQo+Pg0KPj4gICBlcnI6DQo+PiAgICAgICBtYWNzZWNfZnNf
dHhfZGVsX3J1bGUobWFjc2VjX2ZzLCB0eF9ydWxlKTsNCj4+ICtvdXRfc3BlY19ub19ydWxlOg0K
Pj4gICAgICAgbWFjc2VjX3J1bGUgPSBOVUxMOw0KPj4gICBvdXRfc3BlYzoNCj4+ICAgICAgIGt2
ZnJlZShzcGVjKTsNCj4+IEBAIC0xMTI5LDcgKzExMzAsNyBAQCBtYWNzZWNfZnNfcnhfYWRkX3J1
bGUoc3RydWN0IG1seDVlX21hY3NlY19mcyANCj4+ICptYWNzZWNfZnMsDQo+Pg0KPj4gICAgICAg
ZXJyID0gbWFjc2VjX2ZzX3J4X2Z0X2dldChtYWNzZWNfZnMpOw0KPj4gICAgICAgaWYgKGVycikN
Cj4+IC0gICAgICAgICAgICAgZ290byBvdXRfc3BlYzsNCj4+ICsgICAgICAgICAgICAgZ290byBv
dXRfc3BlY19ub19ydWxlOw0KPj4NCj4+ICAgICAgIG1hY3NlY19ydWxlID0ga3phbGxvYyhzaXpl
b2YoKm1hY3NlY19ydWxlKSwgR0ZQX0tFUk5FTCk7DQo+PiAgICAgICBpZiAoIW1hY3NlY19ydWxl
KSB7DQo+PiBAQCAtMTIwOSw2ICsxMjEwLDcgQEAgbWFjc2VjX2ZzX3J4X2FkZF9ydWxlKHN0cnVj
dCBtbHg1ZV9tYWNzZWNfZnMgDQo+PiAqbWFjc2VjX2ZzLA0KPj4NCj4+ICAgZXJyOg0KPj4gICAg
ICAgbWFjc2VjX2ZzX3J4X2RlbF9ydWxlKG1hY3NlY19mcywgcnhfcnVsZSk7DQo+PiArb3V0X3Nw
ZWNfbm9fcnVsZToNCj4+ICAgICAgIG1hY3NlY19ydWxlID0gTlVMTDsNCj4+ICAgb3V0X3NwZWM6
DQo+PiAgICAgICBrdmZyZWUoc3BlYyk7DQo+Pg0KPj4gYmFzZS1jb21taXQ6IDc1NTU0ZmUwMGY5
NDFjM2MzZDkzNDRlODg3MDgwOTNhMTRkMmI0YjgNCg==
