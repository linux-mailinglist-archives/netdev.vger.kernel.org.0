Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACD64D8B0F
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 18:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbiCNRul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 13:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbiCNRuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 13:50:40 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE0513F0D;
        Mon, 14 Mar 2022 10:49:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLE5Bih6Jj1s+0teWpBemzajxkqfKpSHTfWIun9363uTxlhYBXCLKbmFK+KFVdM/z1/A2xqMNwWiAFiHgFQxvJjbutLrxq6F8Ab0E6MlX/5KbPRXCg5Jal0KqySWLF5GEa5XTXpZ2i7idt8TKNs5iapXILF0Rmp/p/lNvO4EAPqHTwM2ygscB2f2rTIKs3jBgtt4ODU8kV0HzwDn7v3MY8/Xv4FJBp9wZtdifXgXfBn//FXvxBt/Sh5EXlDXMghDDA4tcDifwDC7SLK4cFm/l1dVZNC10lEv0XydzI51pzAAiGjsLNOHGnn1CXadu6lxeRjco/wFImVnYX2UMBspzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pJAeCdwc0G3BU8mKaj3Bd3i72j3kF66N/ivoVmIKQPo=;
 b=cU3Md7gAube8wyBOkxKZsOqEsUmvWK1MN3nq71J+dyzeZlXFXyY76U//RW0+W1yREVmKj2iyKvqyFmdImtYVvwtx6VLXj+yYhN6V3thm2kxxMeEH1SNeVyykMGSdF/FKx70TdHgYU5B0Md4hR+O6eN/y51FAWdtJfo5cLBhAz+Rh8IkGjKI5lVW2s08JB6ST5kn8+rpG3xEQUbTVmfoVy5NRpedcGDp5+Xsp7W1xnoyeDnM7KTP4L+Zb2ButUR39T+6tbiQhoenaQhkAEQPC7NN3SYBtzr6wwPF4NaUVOfp65qgrv4gdhZzx0H9luiTXteSwyQLNoV9wA7zc5CX7SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJAeCdwc0G3BU8mKaj3Bd3i72j3kF66N/ivoVmIKQPo=;
 b=p4oISbtrpqBTYdK7cp7B3Jo4uijKA9FOBxPcK4b/fdDMsRFCcS4ZGZUI3CK0N4SHbMNFr8uKbPQEBPpWCaZlcuc6K4iPA7Wg41Y/A8Eaxi82n7EAwI6w2H5ZNCZi1ronm0LGFwhQyDjWkXo1FJKG1O+dSny0FAXQQD6SvK5VDz/1gK7Yiaj0SwyJEZNARKJh5+N/Tsnti2EoXp/Am0Y0ysvVxiiMkwpxfS3E4BkcrfyyOlA05QJ4IeWRuZsrD1ZFvhdvI9w8XzsZxEDHzfEuUQhjEjIQjMl3CaFQ/owhj0ecruQU0gnav9V4e3KvFMIdb2b1urgQNpFCZHF+pcvSfw==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BN8PR12MB3187.namprd12.prod.outlook.com (2603:10b6:408:69::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Mon, 14 Mar
 2022 17:49:28 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::698a:be42:9ca2:bb4f]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::698a:be42:9ca2:bb4f%6]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 17:49:27 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: RE: [PATCH bpf-next v3 4/5] bpf: Add helpers to issue and check SYN
 cookies in XDP
Thread-Topic: [PATCH bpf-next v3 4/5] bpf: Add helpers to issue and check SYN
 cookies in XDP
Thread-Index: AQHYKZEIZ876oRailk6qPfc0r7EgGKymwCiAgBOy65CAABU5gIAESBlg
Date:   Mon, 14 Mar 2022 17:49:27 +0000
Message-ID: <DM4PR12MB5150784C9D592F74350B9E0EDC0F9@DM4PR12MB5150.namprd12.prod.outlook.com>
References: <20220224151145.355355-1-maximmi@nvidia.com>
 <20220224151145.355355-5-maximmi@nvidia.com>
 <20220227032519.2pgbfassbxbkxjsn@ast-mbp.dhcp.thefacebook.com>
 <DM4PR12MB51509E0F9B1D2846969A6A72DC0C9@DM4PR12MB5150.namprd12.prod.outlook.com>
 <CAADnVQL-44zw3MvyuCNm6fn5K6m8hnzYmXWJbBF3aXrLKQFLVQ@mail.gmail.com>
In-Reply-To: <CAADnVQL-44zw3MvyuCNm6fn5K6m8hnzYmXWJbBF3aXrLKQFLVQ@mail.gmail.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ad250f7-aa8f-4648-9c0a-08da05e2fc48
x-ms-traffictypediagnostic: BN8PR12MB3187:EE_
x-microsoft-antispam-prvs: <BN8PR12MB31877E79D6C88999730E1BF1DC0F9@BN8PR12MB3187.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zNIrHNKF3llnLoxD+RJruQ72+dXq53SPLLzylhXPOs0HrFLPxdZIA3GXRDmfHoMplOL1u2V29Diu4sh1moLA6mmWxnHRVZ+D4aePg2dvI+O72euQteE8m6SQcjjJoAkQ8iyVa70KReFQZVEBVsXhwT1ejC6VVEMeuNr5aUFGYvtszgsKOBz3wFxNBcbjc9shsVwPHLtQgW9XXEs65hyKYhJsViyxWHTnRPT4DNw3OcB7rgCFb78Q1vfuXg+MP27nbEN6N5PW3dpgyLDYfLEP7+N1QX20geVw3kT/LdzdDWgBybA/BUF9ECliXsP0co01m6CqngtRQ24Af0QQcmh84+oluj0HiLSLU3MScC5UEaH82r55H+el6hKDtwMLh+rLW5EWzRK6kiXbN5FkCQs4/E8W39kS+Ny9Cf8+D/HfOWOtBxbX5aSEFDa7FnPVTOf9+G80tj02t/rszbkFcXhu6Bk387HF4KvambOGXVliLvLXHUJ/O+P2hDeid2+edovrfg9xNWn+jyTyqKTG07NrhZ92OGUc9pttMo/+LgnRro3CBB4pXdBeITEg1ikmlsPKk+ZFZkTvjoYWC7Ljl8ahDkRsQRe7+pd+wSrTY/Ju3Iisy0t5n7pMuH9aCHwfQODDuF6orBgOmuU0hjjXfczwoWmJqOkKZRIANIpTrS20Zb+YZBoWb/4H8jTiLXIuEW+UvCNhGXej0XnV4TWcUBvPsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(316002)(2906002)(55016003)(86362001)(38070700005)(4326008)(8676002)(52536014)(64756008)(66446008)(66476007)(66556008)(66946007)(7696005)(6506007)(53546011)(508600001)(38100700002)(8936002)(71200400001)(9686003)(6916009)(54906003)(122000001)(26005)(33656002)(5660300002)(186003)(7416002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enM4ZmZGVmcxU2NlTVpxUzNKM0FrTFBnMkVDdG9lM01zWHg1dmdpZkh4NC8x?=
 =?utf-8?B?WjVYd0NzOVB1NE5va3U5ZjhJZTQ1RDYxM1dsd0xmcCtLcGptQ2QzTm5MdFIw?=
 =?utf-8?B?bisvaHoxaDFEdWFlZWVJTThHWlJ2TDZQelBDQWx6Ny9tOHJ0bmpyRGw3RVk5?=
 =?utf-8?B?czZmVGZsOC9WaE4zOFhSVUVwL3ltUVFUNXdjMitOUk51UmJhcHdyY0VEWmsz?=
 =?utf-8?B?QmdyMWo5YitOUGdhcVlZZVBwQmZjTzN0MGU1aUFFNEJQWHBhZXg5TG41T1FS?=
 =?utf-8?B?Ulo4OVZUTDR1YjdtaUk3TTBVM3Z3SVJkZmpvMmZMSjNvUGlqK3hoajlvMWhJ?=
 =?utf-8?B?NVRYQ3FlRytTNzhDcDMvSkVPYW5mQUNJOXZ6TWpvcjJVek9uWEw3TmZRRnow?=
 =?utf-8?B?cDhDWVowc1kwdWxuWjFVZFJXYXhlOTVpSGovLzJJblVYNkZLUGNLZVZvVEpG?=
 =?utf-8?B?R0xUazFKVER0b3JLRzYwU0dxWTdZVW9vME9Ldy8xL2pXbzFkdkxuRTRyUUpU?=
 =?utf-8?B?NFkrNVhLREtNb2l5eSticGJkcW4zNjE4WkRtN2U4WWVsM2wwVllJVUQ2SGk3?=
 =?utf-8?B?OTRYSHVLME1HN2c5WStZeFd3TnpiWVViQUNOWWo5dndiQ3Vmb1VHb0RuMkhh?=
 =?utf-8?B?VVdQQmk4dVdsTGtvR2V6QmdrQWFDdUVYdUEyN1dFR2RmK2FYby9DRW9DYi9k?=
 =?utf-8?B?bUJwcWRTTlh0endUSDFaYjVPR2JFeEg0NXVhUkptWEhlYlQ2dWtaMkxOSTQv?=
 =?utf-8?B?T1lhOWEwL0Y5S3Rqa0ZlNDJFSE5qOENtMGhlSlZJTkdhWnUrc3JPamljUVcy?=
 =?utf-8?B?WVRBVXgxRXJWNVRpaEgyRWJydGJvSzFpMSs0UzN6VU1vdkUxSm51ajlaN1pB?=
 =?utf-8?B?ZXlPYjc0RUlzVXI5N0pjVm9mMXl1Q1RHaGhHdFJYdXNSbWJVMVYvb3g4emt2?=
 =?utf-8?B?SW1xSGhZWm5KVVliUko4M1d6TDR0cUFrSFNZSDMvZ3dpN3Q2bTZNbVFjZWU3?=
 =?utf-8?B?ZzZuRkF3Qk1TOG85SDF0dHR6VEVsVHRnYTk4OTFOZ241L0IwS0swSW1qS3M0?=
 =?utf-8?B?OWlhN0hWWjMwYjRwbFhyaHVGRGpFM3JWRVZ1Qkg2aGZuT21BTHY3ZU5tckdw?=
 =?utf-8?B?cFlnU3lLVVNpUjJrUUZ3SUtLQnN3K3JEM08vWHF1em1GQm5XZU9OVFdVMFFr?=
 =?utf-8?B?TnRSS01Wc3lNMUxLdUd4VGZRTkRNYXdVbll5akdxZ0ZSNnBCUGthenJCTVNV?=
 =?utf-8?B?NzJiNHdMNEs1a0J1VUcwMnNRVStzTGM4b1Z0ckxHejNPVVozQTZnZTVtaURS?=
 =?utf-8?B?V0hkRjREWEFIR2tnL0p3UHlibVNNaHNKMzFSb201N2M3QUZtWW45cmtSZGlR?=
 =?utf-8?B?MWNYOGw1SnRRblFHRlFBYzZ4NnRFNFhHZWdpcmI4NldxemUwUEwxbThzbkU5?=
 =?utf-8?B?WmRkZUI4M2ltTGQyYndDcWs1d3ZHNnp3QTNkenIyU2wvZVV5K0JYUXhKTkU0?=
 =?utf-8?B?RnR1Uk9zWW1qdFJxMkx5UTBRaENCMHh2aHVLeHo0RzFqZ0RQdUZVRkEycE1O?=
 =?utf-8?B?QjN4QWNsZWpQcUtjdVdOcVZST0ZZVTJwVy93Y2dqbVNOVmttY25lSDZMMVlE?=
 =?utf-8?B?SmZUcEZWU2hWR3Z2MlJJQWZuU29tVHFrN2poNUpoYXNEdWFXT2dId0ptM0tu?=
 =?utf-8?B?UnZ3ZDUxNDJ0cVJiYjlCaGRlZUJUUlFyMTFGSW04czVEOVlWMmZxM1B2SHpa?=
 =?utf-8?B?S2lnWm94c0hselNMY0pxcmhPUk51NGdWMDhKOUtsdFF4Z3ZPQ0RFUTNrRkhn?=
 =?utf-8?B?Z1RkZXhjSzAzQktORnBOMVJHWURlMU5PVXdTMUs3a211NU5VSnVuRzBxc1Jl?=
 =?utf-8?B?dmdGZ0R0ZW1iYnZXWTB5UkdmdFZjcHBDM0w3UTNkNWRNOUMrSEVlM3dhZ0p3?=
 =?utf-8?Q?zr5DAtfCtkUVSTzFebd7goaITVs/eQRK?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ad250f7-aa8f-4648-9c0a-08da05e2fc48
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2022 17:49:27.8148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DXdIJG2CoXbixJHQUdINrV0HyfKB+yueEJN8S3ZnQd3ANYOm4+yH+Py51CfjveKPlHkNK0E61n+84seacXtMHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3187
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGV4ZWkgU3Rhcm92b2l0b3Yg
PGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+DQo+IA0KPiBPbiBGcmksIE1hciAxMSwgMjAy
MiBhdCA4OjM2IEFNIE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1taUBudmlkaWEuY29tPg0KPiB3
cm90ZToNCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206
IEFsZXhlaSBTdGFyb3ZvaXRvdiA8YWxleGVpLnN0YXJvdm9pdG92QGdtYWlsLmNvbT4NCj4gPiA+
IFNlbnQ6IDI3IEZlYnJ1YXJ5LCAyMDIyIDA1OjI1DQo+ID4gPg0KPiA+ID4gT24gVGh1LCBGZWIg
MjQsIDIwMjIgYXQgMDU6MTE6NDRQTSArMDIwMCwgTWF4aW0gTWlraXR5YW5za2l5IHdyb3RlOg0K
PiA+ID4gPiBAQCAtNzc5OCw2ICs3OTE2LDE0IEBAIHhkcF9mdW5jX3Byb3RvKGVudW0gYnBmX2Z1
bmNfaWQgZnVuY19pZCwgY29uc3QNCj4gPiA+IHN0cnVjdCBicGZfcHJvZyAqcHJvZykNCj4gPiA+
ID4gICAgICAgICAgICAgcmV0dXJuICZicGZfdGNwX2NoZWNrX3N5bmNvb2tpZV9wcm90bzsNCj4g
PiA+ID4gICAgIGNhc2UgQlBGX0ZVTkNfdGNwX2dlbl9zeW5jb29raWU6DQo+ID4gPiA+ICAgICAg
ICAgICAgIHJldHVybiAmYnBmX3RjcF9nZW5fc3luY29va2llX3Byb3RvOw0KPiA+ID4gPiArICAg
Y2FzZSBCUEZfRlVOQ190Y3BfcmF3X2dlbl9zeW5jb29raWVfaXB2NDoNCj4gPiA+ID4gKyAgICAg
ICAgICAgcmV0dXJuICZicGZfdGNwX3Jhd19nZW5fc3luY29va2llX2lwdjRfcHJvdG87DQo+ID4g
PiA+ICsgICBjYXNlIEJQRl9GVU5DX3RjcF9yYXdfZ2VuX3N5bmNvb2tpZV9pcHY2Og0KPiA+ID4g
PiArICAgICAgICAgICByZXR1cm4gJmJwZl90Y3BfcmF3X2dlbl9zeW5jb29raWVfaXB2Nl9wcm90
bzsNCj4gPiA+ID4gKyAgIGNhc2UgQlBGX0ZVTkNfdGNwX3Jhd19jaGVja19zeW5jb29raWVfaXB2
NDoNCj4gPiA+ID4gKyAgICAgICAgICAgcmV0dXJuICZicGZfdGNwX3Jhd19jaGVja19zeW5jb29r
aWVfaXB2NF9wcm90bzsNCj4gPiA+ID4gKyAgIGNhc2UgQlBGX0ZVTkNfdGNwX3Jhd19jaGVja19z
eW5jb29raWVfaXB2NjoNCj4gPiA+ID4gKyAgICAgICAgICAgcmV0dXJuICZicGZfdGNwX3Jhd19j
aGVja19zeW5jb29raWVfaXB2Nl9wcm90bzsNCj4gPiA+ID4gICNlbmRpZg0KPiA+ID4NCj4gPiA+
IEkgdW5kZXJzdGFuZCB0aGF0IHRoZSBtYWluIHVzZSBjYXNlIGZvciBuZXcgaGVscGVycyBpcyBY
RFAgc3BlY2lmaWMsDQo+ID4gPiBidXQgd2h5IGxpbWl0IHRoZW0gdG8gWERQPw0KPiA+ID4gVGhl
IGZlYXR1cmUgbG9va3MgZ2VuZXJpYyBhbmQgYXBwbGljYWJsZSB0byBza2IgdG9vLg0KPiA+DQo+
ID4gVGhhdCBzb3VuZHMgbGlrZSBhbiBleHRyYSBmZWF0dXJlLCByYXRoZXIgdGhhbiBhIGxpbWl0
YXRpb24uIFRoYXQncyBvdXQNCj4gPiBvZiBzY29wZSBvZiB3aGF0IEkgcGxhbm5lZCB0byBkby4N
Cj4gPg0KPiA+IEJlc2lkZXMsIGl0IHNvdW5kcyBraW5kIG9mIHVzZWxlc3MgdG8gbWUsIGJlY2F1
c2UgdGhlIGludGVudGlvbiBvZiB0aGUNCj4gPiBuZXcgaGVscGVycyBpcyB0byBhY2NlbGVyYXRl
IHN5bnByb3h5LCBhbmQgSSBkb3VidCBCUEYgb3ZlciBTS0JzIHdpbGwNCj4gPiBhY2NlbGVyYXRl
IGFueXRoaW5nLiBNYXliZSBzb21lb25lIGVsc2UgaGFzIGFub3RoZXIgdXNlIGNhc2UgZm9yIHRo
ZXNlDQo+ID4gaGVscGVycyBhbmQgU0tCcyAtIGluIHRoYXQgY2FzZSBJIGxlYXZlIHRoZSBvcHBv
cnR1bml0eSB0byBhZGQgdGhpcw0KPiA+IGZlYXR1cmUgdXAgdG8gdGhlbS4NCj4gDQo+IFRoaXMg
cGF0Y2hzZXQgd2lsbCBub3QgYmUgYWNjZXB0ZWQgdW50aWwgdGhlIGZlYXR1cmUgaXMgZ2VuZXJh
bGl6ZWQNCj4gdG8gYm90aCB4ZHAgYW5kIHNrYiBhbmQgdGVzdGVkIGZvciBib3RoLg0KPiAiSSBk
b250IGhhdmUgYSB1c2UgY2FzZSBmb3IgaXQiIGlzIG5vdCBhbiBleGN1c2UgdG8gbmFycm93IGRv
d24gdGhlIHNjb3BlLg0KDQpJJ20gbm90IG5hcnJvd2luZyBkb3duIHRoZSBzY29wZS4gSXQgd2Fz
IGRlZmluZWQgZnJvbSB0aGUgdmVyeQ0KYmVnaW5uaW5nOiBhY2NlbGVyYXRpbmcgc3lucHJveHkg
d2l0aCBYRFAuIEFza2luZyBtZSB0byBhZGQgU0tCIHN1cHBvcnQNCmlzIGV4dGVuZGluZyB0aGUg
c2NvcGUgYW5kIG1ha2luZyBtZSBkZXZlbG9wIGV4dHJhIHRoaW5ncy4NCg0KSXQncyBhIHdlbGwt
a25vd24gZmFjdCB0aGF0IGZlYXR1cmVzIGFyZW4ndCBhZGRlZCB0byB0aGUga2VybmVsIGlmIHRo
ZXJlDQppcyBubyB1c2VyLiBTb21ldGltZXMsIGZlYXR1cmVzIHdpdGhvdXQgdXNlcnMgKG9yIHdp
dGggZmV3IHVzZXJzKSBhcmUNCmV2ZW4gcmVtb3ZlZC4gQ291bGQgeW91IGVsYWJvcmF0ZSB3aHkg
eW91IHJlcXVpcmUgbWUgdG8gZGV2ZWxvcCBhDQpmZWF0dXJlIHRoYXQgbm8gb25lIGlzIGdvaW5n
IHRvIHVzZT8NCg0KSW4gbXkgb3BpbmlvbiwgdGhlIHdob2xlIHJldmlldyBwcm9jZXNzIG9mIHRo
aXMgc2VyaWVzIGhhcyBtYW55DQp1bmhlYWx0aHkgcG9pbnRzOg0KDQoxLiBJJ20gY29uc3RhbnRs
eSByZXF1ZXN0ZWQgdG8gaW5jcmVhc2UgdGhlIHNjb3BlLg0KDQoxLjEuIFNwbGl0IHRoZSBoZWxw
ZXJzIG5vdCByZWxhdGVkIHRvIHRoZSBmZWF0dXJlLg0KDQoxLjIuIEFkZCBuZXcgZnVuY3Rpb25h
bGl0eSB0byB0aGUgdmVyaWZpZXIgdG8gYWNjZXB0IG1lbW9yeSByZWdpb25zIG9mDQpmaXhlZCBz
aXplLg0KDQoxLjMuIEFkZCBzdXBwb3J0IGZvciBTS0IuDQoNCjIuIEknbSByZXF1ZXN0ZWQgdG8g
cmV3cml0ZSB0aGUgc2FtZSBjb2RlIG11bHRpcGxlIHRpbWVzLCBldmVyeSB0aW1lIGluDQphIG5l
dyB3YXkuDQoNCjIuMS4gSSBoYWQgdG8gcmV3cml0ZSB0aGUgc2FtcGxlIGludG8gYSBzZWxmdGVz
dCwgdGhlbiBpbnRvIGEgZGlmZmVyZW50DQpraW5kIG9mIGEgc2VsZnRlc3QuIEl0J3Mgbm90IG9i
dmlvdXMgdGhhdCBzdGFuZGFsb25lIHNlbGZ0ZXN0cyBhcmUNCmRlcHJlY2F0ZWQgKGFtIEkgYmxp
bmQsIG9yIGlzIGl0IG5vdCBkb2N1bWVudGVkIGFueXdoZXJlPyksIHRoZXJlIGFyZSBhDQpsb3Qg
b2Ygc3VjaCB0ZXN0cyBhbHJlYWR5IGV4aXN0aW5nLiBJbnN0ZWFkIG9mIHNheWluZyBpdCBmcm9t
IHRoZQ0KYmVnaW5uaW5nIHRoYXQgdGhlIHRlc3QgbXVzdCB1c2UgdGhlIHRlc3RfcHJvZ3MgcnVu
bmVyLCB5b3Ugd2FpdGVkIHVudGlsDQpJIGltcGxlbWVudCBhIHN0YW5kYWxvbmUgb25lLg0KDQoz
LiBJIHJlY2VpdmUgY29tbWVudHMgb24gb2xkIGNvZGUgdGhhdCBwYXNzZWQgYSBmZXcgaXRlcmF0
aW9ucyBvZiB0aGUNCnJldmlldy4NCg0KMy4xLiBTS0Igc3VwcG9ydCB3YXMgbmV2ZXIgcGFydCBv
ZiB0aGUgZmVhdHVyZSwgYW5kIHRoZSBzZXJpZXMgcGFzc2VkDQp0d28gaXRlcmF0aW9ucywgYnV0
IG5vdCB0aGUgdGhpcmQuDQoNCjMuMi4gU3RhbmRhbG9uZSBzZWxmdGVzdCB3YXMgT0sgaW4gdjIs
IGJ1dCBzdWRkZW5seSBnb3QgdW5hY2NlcHRhYmxlIGluDQp2My4NCg0K
