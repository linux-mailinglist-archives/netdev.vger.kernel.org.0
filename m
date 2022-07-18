Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C105787A1
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235532AbiGRQme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiGRQmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:42:32 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691F3F5BA
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:42:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kR7zzZLkZhTbMWU5KviUpDPavrdlGtLrOlW2j+hAXPSoWxTZHzYP82yRUkxXHwz8dhkfwcFqEzD7ByycCyO63tLap0h8p6VA01wc0qxzKL+iFl9KIafWbt+uXjo03yeOqVdGPGoXY33ULAYlgBkok2lPktqhzOmvmlCJzJlGaTm+/ZcjtuYMvu0+MkO7SSHa4RfF20QBYRUYO0CNS4NkZuHxUBbnID3w6dKMZ4xWpFfYj5WtbH5oxM3Mh4K5T3dvwZUaCXXhIPwNjpiM//VKHzPYeIh8D6i23IO+PuuiDB8SBEMSOdjp2jwkJa9t9zYZv2ke03gMsSKc1LuD/PIvFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=syfLSWPcexgAXml5vjcX4JMYpez56yNXefn2R9Iu/Uo=;
 b=dSwAlLk4b1LjQ1NiLEY+a5I2BfljaAj1LSZm1iRbA8kktM1yBujYgDvp0yt5iST5LspcjtR8yIyGvWbTa/eYy7tB5JHmvThpIxaTV+jwHqUzKKiMJ96FPpFD2JX7flMS9cGnvHCYwvUNjSwg2jtwznhyK3536uTz6p7z9SQtBC2tslAhmRwsKfQtLPLb5dMfKQb7ebJ5Ad3Otk7+cDc45nPXLjXDUkwEB3yku6rFGgqtG+u2TnoGQGOM5XsmbEENfrkBNqnlg13aT2UU6T8hxI0M3+8C3/SZJ329lBHpJYISHZFcxaKJgTDBEuTLIy3WHCNVoCvTzNrFB7TsqPIxIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=syfLSWPcexgAXml5vjcX4JMYpez56yNXefn2R9Iu/Uo=;
 b=ElVjcBFd0vRgjapad/onEjwgKILpjecQ2MwlimNc+2dpMrkJ2TWf5tVrkFIS2LrTROjTxNgoYH/jkbtwDnZFnK+5nXBFSR8LwWPGnZrMYoLaAn0KN5yVlJRmQ9ELyToPtKZpYwZ1wd6reHAZp5rouR6hE0fOZwUXmygLv3jTbX1vdMjFRUPRW+q3O8NsmJHu6Q8BwFnxL4ohImXU6JJsoGZQVPwlz4rMH+75AEAYKIswBe0Pvm/vttXYX0w5tvYKEYSp3TaM60dTWlzuw9j28di9CTM861+TUOfpzcmF6pX3IcavAuNUEI2hz7sqCDPes0iU1/w/cPeENVL6AgxG6g==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM6PR12MB2907.namprd12.prod.outlook.com (2603:10b6:5:183::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Mon, 18 Jul
 2022 16:42:29 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 16:42:29 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "patchwork-bot+netdevbpf@kernel.org" 
        <patchwork-bot+netdevbpf@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: RE: [PATCH iproute2] uapi: add vdpa.h
Thread-Topic: [PATCH iproute2] uapi: add vdpa.h
Thread-Index: AQHYmsPhPF43jT2bm0m1aWtbt7S4ia2EVJEAgAAAJeA=
Date:   Mon, 18 Jul 2022 16:42:29 +0000
Message-ID: <PH0PR12MB5481FBCC2C4A165913013D78DC8C9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220718163112.11023-1-stephen@networkplumber.org>
 <165816241279.22901.10228940243657683172.git-patchwork-notify@kernel.org>
In-Reply-To: <165816241279.22901.10228940243657683172.git-patchwork-notify@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f96cde16-4c12-468c-97fe-08da68dc80f3
x-ms-traffictypediagnostic: DM6PR12MB2907:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dUuiGei60xsftBfXd7/XuZY+RKQK+ZqaRsunVWgsxS1VqE2zxc2AaG0aWxXMCcpURCbuiDHao2/mlI8A31uc7Nk+pQuu5icDnAaESsarGxA30Bb28mccNoGbR/v7sG3XUc4JbiECBlEaxWmNJYSdd0amzrOFddM7x06fpqyD4JhfVeDsg0DkGM3B4EStEWddy6FtBJGos8xQcAYd3gOhHZE1cfRnxXJuYcPYiBd03nK0mDlmcC3G+ETaoSWrDeR/0THufmoD2gfijXjXYSXOh6QS79SXEXSiMfTMbQeusymKVBXzeHNOOkMV6AWliUKIci+VWo44j/TSFmyk+trTHgcn+aaD+nspdthkxvOWBT6+O2+Y2flSqzJRmMnNLMkt54lm8j4aPefMPzUlU94AtkyIRoHbA90NnNsEeSUKGeSLcMIeWLwa63G+I05Ky+lP6SlwkxRB3xinvG0N+afW1AqBuFkI6zdobXH8n+3kayIp6w4jxQ+sjWZRFDoweeCCf5c27fJtHywBBKy86RAXIOmyzge9NbiS7WXMqzfAXrHdcPa6omM3iBGJOt7NNItlY6dSz/jLr1aYHhLdsgUbu0tOh0zUVh9aE7NW02HuuQJZk7K/pCt4o8HQf1L8mWTMWgFnREyBpkQhaf1+6vlqaldSfX4tL5zA1HlrAGw1N5uK+zQXmYfmT1Yc8HYbMVQMZ6MlETDf/2tQr5uzrk+iXuEIrDU5RoVPvmp0gDH39y+2SUXlFSLMf50R6ucLd7ZjBD34Iqb4f7zGG8fw+WhwMc+vX884z9ycTMIEk6UDr92Oo5yiryB8srueVpD3wvwl1j10GN1KOFhO55po+EqWJ/YW2yVMJWNHyaMqc6nxNSPJt4S54ldmACO1n/tye0nHlt9HLkPnBH1cMtSTddJSaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(54906003)(110136005)(7696005)(6506007)(53546011)(41300700001)(966005)(9686003)(2906002)(478600001)(71200400001)(55016003)(66476007)(66556008)(66446008)(66946007)(64756008)(4326008)(8676002)(316002)(52536014)(8936002)(5660300002)(122000001)(33656002)(38070700005)(86362001)(38100700002)(76116006)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTBZRmRhbVFFTkE2S3hOdEZvK3dHYUV2K3NPRmZzc0dNbDdHOGlTKzMxR2hy?=
 =?utf-8?B?UVFYU3UwN1lYeUdBNUduc1h1V2k4dGI0UmI1VXBWVytwQVdLOTZWYTRYMjE1?=
 =?utf-8?B?akRXWXRaQmNBZTRTNkVHUGlhMXZrV1pTaHlIVXlVOGVhZHRIZCtHZ0lyYjNU?=
 =?utf-8?B?MUNQYXova093eHFMbU01ZmszOERFZ1hsM1dkaHNMTEJYZnRFTU9xWE1sNEcx?=
 =?utf-8?B?ODhKYThFcTFDekF3MXdaOExKVG5WM256Mkg1bjJPMmQwVWxaMWhQQzRsR1dl?=
 =?utf-8?B?YlV6SFYzbUlaanhMZ3RvVnBFWXdiblRZd0E1eXFSWmFZak9YYWNsbGh6ZzhO?=
 =?utf-8?B?QXNydjY3ZVVwVmNHUWFrODZldlMxSUFoVFNKU3NjK2NqQkp5cG9aWVlrWXFq?=
 =?utf-8?B?QXhvZjlPaGdiZEw4aGdNVVI0ZWQ3R2o1VE93K0NiYTdzd25rMFEvVlFwMStv?=
 =?utf-8?B?VHF5S2ppNEIwNnowVk9KNUlyY0FQR0lsdExYMHJwTkVad2NaSWxTVnhJTnhJ?=
 =?utf-8?B?b05mNzhrR0c3Qk9XNHFTVFhrTXpzZFRNdlczUkFpNEhKMnljYTJocVVsZExt?=
 =?utf-8?B?MmxWcFNNdEcxYUNKdVZ5TWNTbE5ndzNQazZSNkYrWDh0Yk4zN3MreXNlcFNT?=
 =?utf-8?B?SURXckcwbmkyeWtuYmtrL0FUUjRFK1FnWDhhS2NSL1NjbWlaUmQ5WVd2Mm4r?=
 =?utf-8?B?a3lnZldaeFVvVVgyQWp5UXBMdWZMVkl3ZW9ZZHFuM1FVZ281M2d5anpkcCtR?=
 =?utf-8?B?M2o2NEFGWFBCMjJIVGlNZWFwb0haSnBjNTMxcG81U0Zsd0dUMU0rNW11RGxT?=
 =?utf-8?B?Rm5lMmFxQ09KY01Bb1NORXRSd1NJM243TXppMEdoN3JITTZWT0Nkc0pYaDI3?=
 =?utf-8?B?bTVVNENWY1V2RVNKNUFDckpZaXkvWHRsaVZzMnl5b2hNdURTaWVEWTF6QTFj?=
 =?utf-8?B?QVBXVGpnSnUwOXBCZ3E5QWJIeGtqZ1ZVeURXaWJaUkdmZXBNWUpxVEtKWk82?=
 =?utf-8?B?Tmx1T3N3QmQ0dDZHeVFqelRydHFYZXhSOXU5bzduZEg0M3cvdjdXQk9ud2lJ?=
 =?utf-8?B?SUN2QjY2eE40SzVtSDVYTG1qaGxIYWFJRnlILy9taXRUTHE5ckJMbENqSHpR?=
 =?utf-8?B?WWw0NzYzME1EVVFiOHFReE85bTVnZE1abW9NaTN4bFJSKzVZS0M0UmFkZm1O?=
 =?utf-8?B?ZUprT3RyR1lBdFkyUXgwUzNWVEpVaWpUVS9qQ0NscG01emJKQjZGVXJUSDFx?=
 =?utf-8?B?azFpNlIzKzN5dnNKL0I0WnFxczRwV3lNODA0M2lwTUNHY1lkRkwyUS9wZXVO?=
 =?utf-8?B?Q0ZhUzlEVTdNNWFFUlZDTnRwUVI2Ui9JUmt3WVBDKzZtbDRaNXRMc2pZejNn?=
 =?utf-8?B?cXEwLzUyQUZMYWo1MWZpR0ZVckw2T3NZcVlUYVRycUVsZkVKV3NDMkFmWCsz?=
 =?utf-8?B?RzRhMnVHb0lWa0hDTTFWOTBGeDhXMTY3NllDRFVxbkVkcy9UdGhKNFNKYTVG?=
 =?utf-8?B?VUJxWGhHaGJoM0dKVTN3QW1rUS9haWo4ZmdDZW5ndzk1bGhqU1I0aHJDRmEy?=
 =?utf-8?B?WlkveXR4RW5LSHA0RG5JZ3dIbDhUWEIwQkFzNmtZcUd1R3NjT1ZxWGk4aGJ3?=
 =?utf-8?B?bkpQTTJ1NGh6NFpwTGs3T2c3b2pYTW54YVBpZ0xyeWZRUm0yWkNoek11Q1ZU?=
 =?utf-8?B?SkFjc1VpS0hVQmpXMmdNL2ozTWFab0ZBTjdieUlFWGxGZ0EvcEkxTjNXMnlO?=
 =?utf-8?B?Q0hyUnhqZll1cFJUVFlycTFDUXFZYTltUm5HSEJjK2orZlc0WmdBNCtxaENL?=
 =?utf-8?B?VHh5bDc0S1VrQjhDM2dqMGoxUUtLS2JvT2piV053RlFqZlNsY05vNVZ3enNy?=
 =?utf-8?B?Nm5aaUd5bFZ6Z0NXOVF4M2ltdlRnalJ5aDIrMVVXbUpaV29CTHF4TXVmU09U?=
 =?utf-8?B?UnJnK29kSE9CY0pnNEFWb3FpMzU5OUFPVVdWM2JDdkVrREVEOGY1L0hyMWoy?=
 =?utf-8?B?b29TaDJvZENFK3A2T2RJaGFkWjBkWFIwWlduTGNwdlJWM2ZZNks5MTZqajZT?=
 =?utf-8?B?QW5DTWpySnphTzQ3c3ArYzFGZWcwaVFjZFU2Ti9LZHRrQ3E5TUdRVHFrN0ht?=
 =?utf-8?B?dStSa2JMbmJSTVpsQlllSC9pL25DMVRRdE0zNDNiUEdCZmkra3NqTStrbVVy?=
 =?utf-8?Q?ssGCdV/bRv/JsEt4p68sn/A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f96cde16-4c12-468c-97fe-08da68dc80f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2022 16:42:29.1419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dT/0Fw8eSJFEkKFRaxyZbpGciczO8U2fXSQwBmZ4UAJ7UYDHtaNbBGV5Jx/N8EDXttGzReoZnEi99GXUAsNPJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2907
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IHBhdGNod29yay1ib3QrbmV0ZGV2YnBmQGtlcm5lbC5vcmcgPHBhdGNod29yay0N
Cj4gYm90K25ldGRldmJwZkBrZXJuZWwub3JnPg0KPiBTZW50OiBNb25kYXksIEp1bHkgMTgsIDIw
MjIgMTI6NDAgUE0NCj4gVG86IFN0ZXBoZW4gSGVtbWluZ2VyIDxzdGVwaGVuQG5ldHdvcmtwbHVt
YmVyLm9yZz4NCj4gQ2M6IFBhcmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNvbT47IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBpcHJvdXRlMl0gdWFwaTogYWRk
IHZkcGEuaA0KPiANCj4gSGVsbG86DQo+IA0KPiBUaGlzIHBhdGNoIHdhcyBhcHBsaWVkIHRvIGlw
cm91dGUyL2lwcm91dGUyLmdpdCAobWFpbikgYnkgU3RlcGhlbg0KPiBIZW1taW5nZXIgPHN0ZXBo
ZW5AbmV0d29ya3BsdW1iZXIub3JnPjoNCj4gDQo+IE9uIE1vbiwgMTggSnVsIDIwMjIgMDk6MzE6
MTMgLTA3MDAgeW91IHdyb3RlOg0KPiA+IElwcm91dGUyIGRlcGVuZHMgb24ga2VybmVsIGhlYWRl
cnMgYW5kIGFsbCBuZWNlc3Nhcnkga2VybmVsIGhlYWRlcnMNCj4gPiBzaG91bGQgYmUgaW4gaXBy
b3V0ZSB0cmVlLiBXaGVuIHZkcGEgd2FzIGFkZGVkIHRoZSBrZXJuZWwgaGVhZGVyIGZpbGUNCj4g
PiB3YXMgbm90Lg0KPiA+DQo+ID4gRml4ZXM6IGMyZWNjODJiOWQ0YyAoInZkcGE6IEFkZCB2ZHBh
IHRvb2wiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IFN0ZXBoZW4gSGVtbWluZ2VyIDxzdGVwaGVuQG5l
dHdvcmtwbHVtYmVyLm9yZz4NCj4gPg0KPiA+IFsuLi5dDQo+IA0KPiBIZXJlIGlzIHRoZSBzdW1t
YXJ5IHdpdGggbGlua3M6DQo+ICAgLSBbaXByb3V0ZTJdIHVhcGk6IGFkZCB2ZHBhLmgNCj4gDQo+
IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9uZXR3b3JrL2lwcm91dGUyL2lwcm91dGUy
LmdpdC9jb21taXQvP2lkPQ0KPiAyOTE4OThjNWZmODgNCj4gDQo+IFlvdSBhcmUgYXdlc29tZSwg
dGhhbmsgeW91IQ0KPiAtLQ0KPiBEZWV0LWRvb3QtZG90LCBJIGFtIGEgYm90Lg0KPiBodHRwczov
L2tvcmcuZG9jcy5rZXJuZWwub3JnL3BhdGNod29yay9wd2JvdC5odG1sDQo+IA0KV2FpdCwgdGhp
cyBpcyBhcHBsaWVkIHRvbyBxdWlja2x5LCBhbmQgaXQgaXMgbm90IGNvcnJlY3QvY29tcGxldGUg
cGF0Y2guDQoNClBhdGNoIGRvZXNu4oCZdCByZW1vdmUgZXhpc3RpbmcgdmRwYS5oIGxvY2F0ZWQg
aW4gdmRwYS9pbmNsdWRlL3VhcGkvbGludXgvdmRwYS5oLg0KDQpJIHJlcGxpZWQgaW4gcGF0Y2gg
ZW1haWwgdG8gc2VlayBEYXZpZCdzIGlucHV0Lg0KDQo=
