Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788B6459D3F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 08:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhKWIBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:01:10 -0500
Received: from mail-dm3nam07on2123.outbound.protection.outlook.com ([40.107.95.123]:15430
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233959AbhKWIBJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 03:01:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZfqhmntQo7SQXqeq8+xqbpFmlknpRMNlc7DtZtVxsESfLgzf2mGElnp2yNJwrS5UMxffawk61H8mmpStW0RBmG/udk/VhyEoVLallSe2ZXd1tfktclOkvrZhaUoMIBoQsZ89ygpPzLi31Op63e0+KBOb+9/ayJHotArOJXEwxKXhC12H9KqITmxE7iaFJzdbkhPrS+cS6wQBrf1ahlkebDR9gabrJm1yF/5WAr/hoXauygZwCMg6jb7IagnTYh9+fNRiga3OOpblUPFKRnP2A4gFIirnVTwuB0u0Kma2MUdtueSsn7PyDQ3TlPOycBWLgJCnoK5JKal2VPEUoVk/mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3cSs5od0MaF8xMYNQnogM+paR2vbnW4YDaDGVBQ6lM0=;
 b=RJlrpFxpWG69k6lXy+iH+M5+iTokxPtwxsZDGKVYY+4T6i0SgcRh/yvjcTFfx7oZfjmbOFY1M95Qw9vHw+fawYkejAgP3s/OASGSV4hf/EUERnJ8pRkkqJoKqr0D1VXuNPhI2G4SBWXyZImqZq83bxWq7zTgICHULDV86WviSbO1DPrJ99qj8eVpJsvumS+PuCe2kWV5oNZADymFHPuWfX9vhauHwdu4Dy5tDmZZEsdP5ulK6iYYBl8qnh6k7J2vdoRIUJYcVR0KYnOi7XFn9tty05MsWG22uh30YPfez1G3veneaKiJbgHy8kHDS888ZPVvQRUVSPb4Ubt2LwNh/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cSs5od0MaF8xMYNQnogM+paR2vbnW4YDaDGVBQ6lM0=;
 b=pb0GIYPWALhgowY5BPRFxoUbBFeJTK6D+IyZj7kGpOfM+xR/aperSU1GtZefjMwLXdwl/RMoisJMbRX/WNhjWgCBEl7GEjWTcH+1fwbpTxSgl1V5yrLCdx5Mh8JDJKNPElaSUf/N8vlrF3kRhFDeVmZVZitRZJk4Lxmo+D+Ue4Y=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM5PR13MB1868.namprd13.prod.outlook.com (2603:10b6:3:131::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.16; Tue, 23 Nov
 2021 07:58:00 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15%4]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 07:57:59 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH v4 net-next 0/10] allow user to offload tc action to net
 device
Thread-Topic: [PATCH v4 net-next 0/10] allow user to offload tc action to net
 device
Thread-Index: AQHX3H1ok7mY7Y+TRkqju/Erc51xvqwPfLoAgAFJPjA=
Date:   Tue, 23 Nov 2021 07:57:59 +0000
Message-ID: <DM5PR1301MB21721695E39BAA6B19FCF1F3E7609@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
 <d1a69d88-e963-a64e-5db3-735dad42fc4e@mojatatu.com>
In-Reply-To: <d1a69d88-e963-a64e-5db3-735dad42fc4e@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ed3f970-e385-4c6a-c479-08d9ae56f7f3
x-ms-traffictypediagnostic: DM5PR13MB1868:
x-microsoft-antispam-prvs: <DM5PR13MB18685778170DEE8A52D03ACDE7609@DM5PR13MB1868.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:751;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n58OJ8V5/dzCoSz2nwA8C0XJSRuRXUmHulhGik9xBjTEcLHirXo6xEHH4cYJfzqAtlyP7sdDpNM3PXuLdoK7q0PgpSfaQaaJ+GW87faIAm2q6W/YcCiv3AoMSeOEz8fG/y1iVmEDavTdgtlWAiQlTFPK3yxABCwQWISsfZSBUe6QGY/2c/AoZJVO7San0xTLErxBrwvhJHo575JxTdLWb8OnmZhK+TjWnnCfnAkNhskbhOClkr1jJxAc+RGLrZip+OpX0nFN6LGwrb4QnepTSJLGcr25I6njd7lElV9ns5HzcVU10i1TTOSqca7UQJkCzvgYhc9q+7u0J12fiMyn2K7poCxu9kJwoSZOMI+6K1dYW3uXkVg41lmCDaPKPdKJsvjh+ZSXqjQNVn3HEyiNSqsHrZV8xIo8m6KZlpPyu9FnL8KPtAHzzLBbjwgQjfvTfuerxNujSIN1ueb7s8E9Iv8b6ZwbIVVXXwekFx9b8DG7ApeGYNkANoRmf9I9dMVORMSfTR3cNuukhbLjEcjDY9ZW+exHO71iZ7ZPHzngwzxKSfoflXLZUcBLdHQFK91jGVzvD+CcFb7PTpmJFTg2cNjcLnsL32gIVk8L/GHZkrRQvGB9FJBraABYzVwwnyOubyjDHkTb9KK54JhPzuSBFAYZQonMkSXpsiRiyy89pXy0pDam/0ZSoYSWu2crfV40vCP52n7S4wwLRAX5b/ZfXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(366004)(39840400004)(376002)(33656002)(4744005)(66946007)(316002)(66446008)(52536014)(44832011)(54906003)(110136005)(8676002)(8936002)(4001150100001)(26005)(2906002)(76116006)(186003)(38070700005)(9686003)(6506007)(71200400001)(66556008)(66476007)(86362001)(508600001)(38100700002)(5660300002)(7696005)(55016003)(122000001)(4326008)(107886003)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFlxQzd3SzdNQjczVkJWbHJrRlV2N3g3OFh4bmhVeTluejVpU2ErbS8zK2pu?=
 =?utf-8?B?enNRcUg4VVFBbk9hZFlxUWhGS2l3ZlRVR1pMdFRPM2VTTHp0c0l6WDE1TitN?=
 =?utf-8?B?RzQ0bGtZOGd5eHczNjk2cTRQajJzYi91eEhOZ013bG8waDh4TE5DWWZOU2Zt?=
 =?utf-8?B?THlETXpFYWhvaldYanFsVEFoa1J4NzZtcVRoWTJ1WVNzblcwQlQxUkZVM25K?=
 =?utf-8?B?NEMzTzB5ZHJsMDJuL2JkZ2gxY0tSeXJESHc3Y0QzUmd6b1lnUzB1S3AzWW9N?=
 =?utf-8?B?TXhRaWVGckJWbXJXaGo3M1IzWlk3THB6Uk51NlFQd1did0UzNEVvbmsyWWVT?=
 =?utf-8?B?Um00emVKOTg3bStUYUZvbTRXRXljUkdFRm9FOEc3TEE4RjYzcDNtNWwrN0N4?=
 =?utf-8?B?a1Y5ZnRDUVhnN0kwZ1AvNXcwNEZJaHVXYWo5R1lwVlpFRG96S3RQQTF2T013?=
 =?utf-8?B?SW5DMTgyWVpGaklkaUVnK2crNzRoTUpOTmtkWGpNQ1hUZlRSdWkzOTFnRTBI?=
 =?utf-8?B?TlV1aXVGb0R0N0xTR3liaS8rUlpISU0xRHlsRG5tNS95NEY0VWt3cFhJM0RK?=
 =?utf-8?B?YnBmSUsyYlVSVUt4QlIxSS9YeFU5ZHROa09XaDcvRE43U1JrYVp5VERFaEhM?=
 =?utf-8?B?TTBYRS9kUVUxMENJUFpyWjZGQm44OVNtVCttV0s0OWY1b3UrWU96ZnFoRnVP?=
 =?utf-8?B?MFFUSzNNM0c4Q0J6YUd6WitkR2NseElJcW5GYm9QN3pYVms1elorcGwrTUpv?=
 =?utf-8?B?QXlNRnhpZ3k3UU1lQS9ORUxJS2NHM0NtKzhnSy9yZWpYdFVJTHVNQVBSVkpl?=
 =?utf-8?B?SVdBRURpenlCaG5PcHdEWlJENEF5dEo4ZVVwL2lBbEloaG5aQVNoUjBpU0h1?=
 =?utf-8?B?aVprQTNjQkhiTmFZT29TY1h5anhtZFRsd05ZQ1JSb1BiNWtVOTE4aUhRZnhi?=
 =?utf-8?B?dHVTdytIU2Uza1dlL3pqZ2ljcmpaVzQ3NmFTOWJ1YUJLVjFqZWhVU1ZrQ0RR?=
 =?utf-8?B?RzMzaTNyNWdRVmovZzQrTitWUkpxcFBMeTlkMlBnNEJwY1ZBVk41SDJyaDZS?=
 =?utf-8?B?SEg1YXgrZGI1bitYa1VMbnNDdFNBckNIczJ4Z2VSRlRaY293WnQzMjl3ZUNp?=
 =?utf-8?B?a2dmSGRCVlRwT0MwRzRSY2kreE14THJjby9yQlR0RjU4ZkdtTDFvWnVvMWp1?=
 =?utf-8?B?RTVOa01zMHlYalBVcFVteDVxN2RnM3JTNjcvQmsvVXRZcEZGMUlQTlZvZGpS?=
 =?utf-8?B?L3hFcEIyc25UMWhNSmtCeEY5M0JhUTd6K1VSSENYRlZidWd5YmgzWkgvdGJ3?=
 =?utf-8?B?bncrcm5tN2FFanhTV3F2OFNLSFp3V0FYUjljdldRd0dRRUVPU0Z6RGM5ajVj?=
 =?utf-8?B?ZXhvWEt6emxXWndlTyt4c3FpTmdiZjljOTZTWnhubW0zenhqd3JYSUdySENK?=
 =?utf-8?B?QWNWbGVOOGphVmRXM3dva2tGVjY1dXRpTm1SY3JJVHN0aENKb0tkeXM0MmlH?=
 =?utf-8?B?RnJ1TzkwSmJzS1RCL2xOc1RZM3prL1JYUC9NcVd2MDBvT2E3a29HbElzZnMy?=
 =?utf-8?B?T1FkL2hmaDZMakZZbnZNZ1RGaytIZHpzODhBVU54dTJFUjNscU9aakp5NnZr?=
 =?utf-8?B?Z0U1bXlwZ2Y2UkF3eUZEeWVianREdVRvYzZpZkRjcHpHUnNQdS9DV3JPclIy?=
 =?utf-8?B?N3BKbzJOdGVZR0NMdEJvNkF6Y2NHOTBDckE4dElDMnpuOXBTS3ljODlZTGZ5?=
 =?utf-8?B?YVhVZHdpSTdXYklZMkdweVVGcmVnK0I1Q0lidWlRZ3ZUaVZtUUhlZ3ppTFBt?=
 =?utf-8?B?dmJPSGM2Z3ZnVDdaN1hJL28vKzJVV1NYSU01ekRMUzhwMVhjWXp5MlRESlU1?=
 =?utf-8?B?V3lHZFFPSWZ4RUowbzAvdldwTVhxZldCem5hUTdJeXd4L1VsMUtxWGFxbi94?=
 =?utf-8?B?c0xGelJuRjVzUUJudmhpT1RLMUxnd29xQkI2TXJrcCtQdk1Qc3hNRUJZRHVQ?=
 =?utf-8?B?NVJzWmpNYnUrNHpCc0NxME1WUUNNa1FjSXdLMzhKcHE4VzFIMVZNUWV5OEtL?=
 =?utf-8?B?R081TGtIQnJwT08vSzBjU3h4Vnc2RTQxMjcyTkZzWXplNkNTSDY5UEFMLzlH?=
 =?utf-8?B?OGhSSkFPOXZSYmV0SDJZMTJta0VFT1o4VFFXeXpjK2tsaEJyM1psV2cwNkZw?=
 =?utf-8?B?NHdKSytOaGtIWU1NendUbTJkUmtKaGZINkJtalV2dkRUSmlpUHUreWhGcklT?=
 =?utf-8?B?VmltZytna2xVeVN3cnVRb3pIUVl3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed3f970-e385-4c6a-c479-08d9ae56f7f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 07:57:59.8664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k8ZBAzMpitajkKHu2PcGatRh9/F3HTlBOpEMSDIj3THHopkxDV4uZtEfgam12KTKFkw1oehSdJv3Y6NvgcsaY/SHheG67ypIk9mIX1irhGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1868
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTm92ZW1iZXIgMjIsIDIwMjEgODoxNyBQTSwgSmFtYWwgSGFkaSBTYWxpbSB3cm90ZToNCj5P
biAyMDIxLTExLTE4IDA4OjA3LCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+PiBUYyBjbGkgY29tbWFu
ZCB0byBvZmZsb2FkIGFuZCBxdW90ZSBhbiBhY3Rpb246DQo+Pg0KPj4gICAgdGMgcWRpc2MgYWRk
IGRldiAkREVWIGluZ3Jlc3MNCj4+ICAgIHRjIHFkaXNjIHNob3cgZGV2ICRERVYgaW5ncmVzcw0K
Pj4NCj4+ICAgIHRjIGFjdGlvbnMgYWRkIGFjdGlvbiBwb2xpY2UgcmF0ZSAxMDBtYml0IGJ1cnN0
IDEwMDAwayBpbmRleCAyMDAgc2tpcF9zdw0KPj4gICAgdGMgLXMgLWQgYWN0aW9ucyBsaXN0IGFj
dGlvbiBwb2xpY2UNCj4+DQo+DQo+Q291bGQgeW91IHNob3cgdGhlIG91dHB1dCBhYm92ZT8NCj4N
Cj4+ICAgIHRjIGZpbHRlciBhZGQgZGV2ICRERVYgcHJvdG9jb2wgaXAgcGFyZW50IGZmZmY6IFwN
Cj4+ICAgICAgZmxvd2VyIHNraXBfc3cgaXBfcHJvdG8gdGNwIGFjdGlvbiBwb2xpY2UgaW5kZXgg
MjAwDQo+PiAgICB0YyAtcyAtZCBmaWx0ZXIgc2hvdyBkZXYgJERFViBwcm90b2NvbCBpcCBwYXJl
bnQgZmZmZjoNCj5TYW1lIGhlcmUuLg0KPg0KPj4gICAgdGMgZmlsdGVyIGFkZCBkZXYgJERFViBw
cm90b2NvbCBpcHY2IHBhcmVudCBmZmZmOiBcDQo+PiAgICAgIGZsb3dlciBza2lwX3N3IGlwX3By
b3RvIHRjcCBhY3Rpb24gcG9saWNlIGluZGV4IDIwMA0KPj4gICAgdGMgLXMgLWQgZmlsdGVyIHNo
b3cgZGV2ICRERVYgcHJvdG9jb2wgaXB2NiBwYXJlbnQgZmZmZjoNCj4NCj5TYW1lIGhlcmUuLg0K
Pg0KPj4gICAgdGMgLXMgLWQgYWN0aW9ucyBsaXN0IGFjdGlvbiBwb2xpY2UNCj4NCj5TYW1lIGhl
cmUuLi4NCj4NClRoYW5rcywgd2Ugd2lsbCBhZGQgdGhlIG91dHB1dCBpbiB0aGUgbmV4dCBwYXRj
aCBmb3IgYWxsIHRoZSBhYm92ZSBjb21tYW5kLg0KPmNoZWVycywNCj5qYW1hbA0K
