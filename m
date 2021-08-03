Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18673DF4F1
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 20:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239239AbhHCSsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 14:48:00 -0400
Received: from mail-eopbgr1400110.outbound.protection.outlook.com ([40.107.140.110]:19496
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237482AbhHCSr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 14:47:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZouQTo+rZivQ/mmYz7nrXQXVGOT4169KeNvS5ekNo0RzBhPbUgOhS1K1iwJ7DNedw7KfZl+yJHgy+TgcMfyeGlEMPXMwhoZ5E3IFybIArujpVdy8XYF2KYCuwMUGkjlCYI9v9dNGsb09XMRHi2gVG2csPZFBgF7TJ9ARkUSNMwH4kBg7C2flFOiZ4HeAN8Re0RAbc0ADdiSdrdvbNakE8zsCQjsz19xk+3Xr8bHONeE8LlNC4a/x/1j/FbElIOFws+0+EOKBxwZbkcO7F/roF7yHDcWsgIKvISFPPUVLKo77HSNMNsQx2DyWfeKWT8rGW927A/m0odzoe//fYsEvbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NabsZazAhzC4/w17kgoXwYf+oHoT26NVGXfQ6gQfzg=;
 b=YgX3omNFxmCKm2VkXEui90FPAAuE8wpmQp+g+cKXv4wBF7S/A78yACk5xb33UZ9iy521jDKEKoGwRtG2rRFeZ4pXFsD6Yp8VhqFTr8qetkRnAmfHUdJjPHE1KORWj9LJCqbwJdLfM8DHHKl+xhDtnTfZehUDvQgpi01yYE7iv66oxZDSPbZI5hFchBRAAhsnttMPZ5G2Gql09d7a/5nzkokiJEA9xAVyM+Jc8WywYePcgyioAMjXabY8ta0LRtzDzTKtlfHsG9obk/47PnBHE8NmpAfyP5S+zR5SpEx/qD23q42Lo7EQKD4BgfE1QRFvejr3+FCnAYOnBM73dyhISw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NabsZazAhzC4/w17kgoXwYf+oHoT26NVGXfQ6gQfzg=;
 b=XX2Cdf+IPgYXY4+0HT5eaLQzGThnV13eM+p/ylAP4dhwZD6XyHzLZPydfCc1MuVYmq+psDQmuSpVwHj2bwl9zgVnqGdVALqC74/A79rVcCdD0nTv7/S2bfTjdndsevZVy7CKIlcMZaCkWvA8Y8GnXR1ItTyhr6U6uwIyzyjz7Ek=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB3732.jpnprd01.prod.outlook.com (2603:1096:604:52::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Tue, 3 Aug
 2021 18:47:42 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 18:47:42 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next v2 4/8] ravb: Add stats_len to struct
 ravb_hw_info
Thread-Topic: [PATCH net-next v2 4/8] ravb: Add stats_len to struct
 ravb_hw_info
Thread-Index: AQHXh4j9M4Z9oAopg0m93dUdkrpFFKtiHbOAgAACw7A=
Date:   Tue, 3 Aug 2021 18:47:42 +0000
Message-ID: <OS0PR01MB5922AEAA259BECBED6286CF086F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-5-biju.das.jz@bp.renesas.com>
 <766c4067-d8b3-6aaa-5818-b4d9d5c6f42d@gmail.com>
In-Reply-To: <766c4067-d8b3-6aaa-5818-b4d9d5c6f42d@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06500dc2-da72-4562-c8b0-08d956af2d30
x-ms-traffictypediagnostic: OSAPR01MB3732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB3732F772CF931F271F4945EE86F09@OSAPR01MB3732.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wnotJM/G2x72pH+UnoR4wJ5sy44Ck/tsjcwv7vq7QJeGqPyVRdeXP/mmIluH4HaH5vZ9tEEMaKeGmvYhTD6CZ4nUOaQ9ZgNAuFdfg/0sDO+MIHRJv1LS5pBabJDVatpSfIEtCYMtbNhsGehOY4JUbxDabfQKb/D6F3LE+YDVQMns+Wqfqef/DIvdBmtMFPC06g/Se+ysswHkCt8fLa5LrZbSWUUSDPXPDQ3f1wclX+0hCUkRBbct09EeiL7vjvw3SyzZNIcWVrbXgYNgeehIwu5fg2FcGJ+Owr9wjb0XsJmAjwYOS4SRKz7LZByP6MwkWpuXDoClx6kgR37LBPLvpnAP/ThfZGQsTfS5f+H9kbpAb1dmBIqolW11ajWOEvkKi3KXWlGNODpy3KK6GFggesNbhgb9uWfEoizianAIqrNGmx1GZWUQKdJd1llf7SeeiO0poaoUSOIx1nxSSda4mMf4Y8xhnf+grDmqJXzqWl7jSEKTBOhOWvGuOdB+X8m8C7VvI9sXb6Y9pl+L18RzXvQqPIGbFvMAHE3Yk/VVstM3LQB6Ao6apLGD1LIxCyJ8Qe0IPQY+3ODXAgN2vHgQ9sz8UGic+i7ywRXvS3PXT73vIxbzJm1xEAoPbj+Da7BS/fk1LI7xs5pJKdyIM+GlDQTWCOZJXdABdleweIn9wKGdoe07K7B3wJaUvvT3XKh5st3pyie0svbPeHLroyLzbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(366004)(136003)(346002)(376002)(5660300002)(8936002)(66476007)(107886003)(66946007)(7696005)(66446008)(66556008)(6506007)(53546011)(76116006)(4744005)(7416002)(54906003)(26005)(64756008)(4326008)(110136005)(316002)(38100700002)(71200400001)(122000001)(52536014)(8676002)(478600001)(9686003)(186003)(55016002)(38070700005)(2906002)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEhFWkF6enBObUlyc0dtTW9nSFlIaCtCU3NJa09na3JQV0l1SkVYV081clc2?=
 =?utf-8?B?ZTVUMk1OL09oU3hwd3RyUEl1L1Z0d3lORjNTdThKaXNyZ29EWmtiQzluZ3RG?=
 =?utf-8?B?ZHdGV2FmNlVHVy9KK0lteE1OamV4SDA0akxwbXo5WjFUS3JLamJLTnNJdnk5?=
 =?utf-8?B?eGxmT1JjQlZJREQvVHRBTTNjU2s5MWdmT1BZZXprQkE1VTdxL2JqMEVUd2pF?=
 =?utf-8?B?VTA3R3ZranlDV2xXQnJCcmdiTjZCVXpCdnptMkl0NjlBTnlWejdydWZVc0RJ?=
 =?utf-8?B?YVFlbE1icjB3emI1ZUhMdnlrUW9iSHY0ejZzVi8rUDg2QUNiL1FpdDZWK3JI?=
 =?utf-8?B?QStqQmhXdGtESnErbHMySEtUM0ZkQ1ZncFJtQjJWdUU2Rmd5MW9Rd3lYTWxy?=
 =?utf-8?B?d2FtSmdWcXYrVU93dnlyUlg3eWgxWnNEdlVkazc4eXdaZGFzN0RXdk53aGxu?=
 =?utf-8?B?aTMza3V4NXY5NXpHRm9zcC9qd2dwR3IvQTFIV1Q0RVZVMXlWRzdxN01XUUxj?=
 =?utf-8?B?Q2N6SjdRRUZOMnY4RG9mS3BuV1FvdjlQbWlsRUx6cjBBb1l5VnpWN0RLMzBi?=
 =?utf-8?B?NGFGSE9oVk1hUDJXYlhJV0lhd0hMaHlGK0syTXFwNHBjd3JZV1BxaDFBL3Rm?=
 =?utf-8?B?Tk91L3ZhR0E3WHFTekh6YjdBMzJwME9zRWdJTkdNUkl1aEduWFJ5RnhVQnIy?=
 =?utf-8?B?Z0dVeHFmU1FjK3VROUJ2aTBoOG13blFFKzlnbXVhTDFELzJhYXV5ODVobnZJ?=
 =?utf-8?B?bU1tMnNrSjcvZnJ5aFNhMFhVSnc4Sm9zRWMySnNlZnhnUFo2blJzazZLODFB?=
 =?utf-8?B?UjBZcm8vUlBJUTV2U0grdmx0MnRFWkdmdFNxNTNqb2QraGpSMFlYbE9ZWTkv?=
 =?utf-8?B?T3dxNXZtS1lvMmlJRFJFR3dYSTNwZmQweWRHalVEZW05V3ZqR2U5QlF5NjN2?=
 =?utf-8?B?SGpkNUJWYWo2UStZYkpOMHZDNmlLN0ZsMEtkODJCR2x1SkovNHZaQ2Y5SS9P?=
 =?utf-8?B?OWx1NlRWOVkyc1ZRcUs0bUZ4ZlRuOTExTnpEdTVyV0tnN1ZzWWIrSllZNFBY?=
 =?utf-8?B?K0ZPS2NIQzlrOGg0dlFhN1NVcG9SRVA0UUI4SzFSQ21KaTB6SVg5amhFVHQ0?=
 =?utf-8?B?SXQvaUpvdW1vcytRWmZjMlIzNGs3Z2pIUHA0bDE0UkRDMFpRd0F3UFdzdENM?=
 =?utf-8?B?UktPdS9ycWFnT2hPdlgydWQ0enY5L3dzUS9uM2Z0ckZnaXhaL1c3ZWxManZq?=
 =?utf-8?B?anBlak16NzFUUzR3djBZdFF3djExNzllRXdyU3d6cjU2Vmx0WkhUOEhBRFgz?=
 =?utf-8?B?VzVhQlhqVkVyNHhBODFzclRYbHdhZlo5YW5QemU1TlRpenpETVhUdFRWZDEv?=
 =?utf-8?B?Tks3Q1dpcUhMNzk0dlM3YUFud3JOdnVZZ2owZ0VianZNcFRZcTBqLzNrUGZD?=
 =?utf-8?B?ZHBaSUwzWi9WOUVMUGFYaUhDMTlsSXZTdlJPdVgrN3FWcG1oSkZ5RTFJc3NE?=
 =?utf-8?B?V1Q1U2VVTTN4WHRPbzdRSnN4MHl4Tk9YRjFyMjMwSkUyVHNWSVAvVzFZekJw?=
 =?utf-8?B?UHYyRDVwbkNLZklhQUZoLzNRRHg5YUZrV0FOQndkMkhVdnZNa094RjVERHBi?=
 =?utf-8?B?R3ZJTDhTc2UyMkJ4WS9OTHBGL20zOHo2L2pQeDdqb2tReDBJUmdCc0grOUxQ?=
 =?utf-8?B?TkJlZ2xtUkdFN29abEswWDhSaUI3dk1UL0FYRHNqeGRZWkNIS09GdSsvMXdl?=
 =?utf-8?Q?2KoJxNWMKvoVTiKGpxYEvtoo2/bhqvYhnOmV+yC?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06500dc2-da72-4562-c8b0-08d956af2d30
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 18:47:42.5599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wjAA3Y46RZPGLO0ZCXbOVJd6fZYpdYzXVKm7SxgvorAMZLRdCGZz9JWa3pQVwPgMHkvgBzL9LoyE9Vewery9a4idv2acDrVEZ9HR5iVXnr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3732
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBTZXJnZWksDQoNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2MiA0LzhdIHJh
dmI6IEFkZCBzdGF0c19sZW4gdG8gc3RydWN0DQo+IHJhdmJfaHdfaW5mbw0KPiANCj4gT24gOC8y
LzIxIDE6MjYgUE0sIEJpanUgRGFzIHdyb3RlOg0KPiANCj4gPiBSLUNhciBwcm92aWRlcyAzMCBk
ZXZpY2Ugc3RhdHMsIHdoZXJlYXMgUlovRzJMIHByb3ZpZGVzIG9ubHkgMTUuIEluDQo+ID4gYWRk
aXRpb24sIFJaL0cyTCBoYXMgc3RhdHMgInJ4X3F1ZXVlXzBfY3N1bV9vZmZsb2FkX2Vycm9ycyIg
aW5zdGVhZCBvZg0KPiA+ICJyeF9xdWV1ZV8wX21pc3NlZF9lcnJvcnMiLg0KPiA+DQo+ID4gUmVw
bGFjZSBSQVZCX1NUQVRTX0xFTiBtYWNybyB3aXRoIGEgc3RydWN0dXJlIHZhcmlhYmxlIHN0YXRz
X2xlbiB0bw0KPiA+IHN0cnVjdCByYXZiX2h3X2luZm8sIHRvIHN1cHBvcnQgc3Vic2VxdWVudCBT
b0NzIHdpdGhvdXQgYW55IGNvZGUNCj4gPiBjaGFuZ2VzIHRvIHRoZSByYXZiX2dldF9zc2V0X2Nv
dW50IGZ1bmN0aW9uLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFz
Lmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBMYWQgUHJhYmhha2FyIDxwcmFi
aGFrYXIubWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+IFsuLi5dDQo+IA0KPiAgICBG
aW5hbGx5IGEgcGF0Y2ggdGhhdCBJIGNhbiBhZ3JlZSB3aXRoLiA6LSkNCj4gDQo+IFJldmlld2Vk
LWJ5OiBlcmdlaSBTaHR5bHlvdiA8c2VyZ2VpLnNodHlseW92QGdtYWlsLmNvbT4NCiAgICAgICAg
ICAgICAgXlR5cG8gaGVyZS4NCg0KQ2hlZXJzLA0KQmlqdQ0K
