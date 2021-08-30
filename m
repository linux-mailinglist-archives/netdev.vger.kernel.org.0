Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010E33FBF89
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239121AbhH3Xsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:48:51 -0400
Received: from mail-oln040093003013.outbound.protection.outlook.com ([40.93.3.13]:33667
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238942AbhH3Xst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 19:48:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkU8R2QtzExxrr8wZiVFQfkzl76KzYVHcYSotfRQkFRDn/0R1nazCEPjaGPAHzGxVcuS23yaHl8AQpmjHOxfZQWEdCRWB1mO8jAE3irt8QNSP9aHKVmijj/85ROvll9WVdfNf83aW5ws8ZCHcvjjlSAoaAVisjKnc678X2Shr8DIL9AFoZYdSLshbMYHUQ7Gp4kztfWIQLIhKwS6Vk1tWy8CGUJKzd2Whomt/lJn3MowiF/PT99gQkS3biSU4jDsvIie3foudYDua9yMAUpE2Vwjf0ogqS13ixDLUNHqMRahafXVGgB1RjrI/e6xpkJ77iltCJVcs/E0FyzC3g4glw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KcLJqGoJ1EUDlt8AShrB8g/aH/PbSXSPhuGS81ka2BA=;
 b=cznRmg6KQQ5V08tYP8KUm0YLts2baeKTQmwAQgpoJr8fzRnlF+73V4wH3cynJVBGejsAM+PB2CecUoVppXPx+DIL27GD+w7YWz1/9BBVmDEuxr+tq/MPepL4wASJQ9IHCfNGzXcL67FNA4gj8NQwwlY1hydVdYSSD6XxidBXfcCHDnAErXJXnOKgfuwoBtNlhS9EkkAP6Sv58ex1bq+DU5iN0zP18TGC0d2retc8kseIBtHdnhhejklSkzk7uuKwjoAQ4oC0NVmVFG1UDPCLpjTb6HHeQdMhpZXT1p3ATlqrN3/YYk1sWdE1WX4ssYwYYLlHm6WPj8F9veOX6GgXHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcLJqGoJ1EUDlt8AShrB8g/aH/PbSXSPhuGS81ka2BA=;
 b=cLdg/5FznnM/EwK3OmftsTiwD9Leku201/Wr0+9UanRsXznEpc6rRLu2IFVxaGDNPl4PP2fs88dy4vXLMWvH70sjxXm/F18a3+fuEG0x8qEdNT2lWivPl70uibtnc0u1nCnOQ7Pr5uOeh79eQ3YkrkcLBczPRu5KEDe87UR4tCc=
Received: from BL0PR2101MB1316.namprd21.prod.outlook.com
 (2603:10b6:208:92::10) by BL0PR2101MB0996.namprd21.prod.outlook.com
 (2603:10b6:207:36::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.3; Mon, 30 Aug
 2021 23:47:53 +0000
Received: from BL0PR2101MB1316.namprd21.prod.outlook.com
 ([fe80::64b6:4ca2:22ed:9808]) by BL0PR2101MB1316.namprd21.prod.outlook.com
 ([fe80::64b6:4ca2:22ed:9808%7]) with mapi id 15.20.4500.003; Mon, 30 Aug 2021
 23:47:53 +0000
From:   Saikrishna Arcot <sarcot@microsoft.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Change in behavior for bound vs unbound sockets
Thread-Topic: Change in behavior for bound vs unbound sockets
Thread-Index: Aded9liCI+QX/nn6SXqyC7ZHygI2fw==
Date:   Mon, 30 Aug 2021 23:47:53 +0000
Message-ID: <BL0PR2101MB13167E456C5E839426BCDBE6D9CB9@BL0PR2101MB1316.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=08e59ce1-de4d-4c4b-aba9-368567f4be77;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-30T21:50:57Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7dcd6fdc-b6e8-4571-3a1e-08d96c1095bd
x-ms-traffictypediagnostic: BL0PR2101MB0996:
x-microsoft-antispam-prvs: <BL0PR2101MB0996D1C95A9D86A9B33FBD16D9CB9@BL0PR2101MB0996.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1SbDTFWNZm3abJacfkHZ4BDeET+mhQ7YL8gLl5Z1IdjXzgLe1wejoGBVPEm94VEDCmOqK1T/knPKeIhKbvAuEAb2hsPV326osPCsFoJK17I3Gp+UP/mMlub7IbPh6/7igGA2PW4l4hSKJO3Ffp70jghfIkpU4pNMULJsooNZZW0ipH02hUkr53TnyYGnxKKF5BKNepw4T8KzOf3Himai0l7zQgflu1zVbrPYnF9xr/l4qbks4ZNRYeeNlWg8pCRk+zD2KnpymQQk/VE8wLJ7IAZyOnHV2te4luZaE9Rry1t1DalHkvbx/NDOaI5WiA6ESH4+pJ7gazQYCIbOIQXXWRLkEGWktWcrbRA0xrTfiASuW9iSiScf8WWzGtdqfHVAX5Wfn0TxozmJmaH7bcpL/9O3BUvRXrhvtiKHDRHmvS24aINUo8L7P6nt0iYcPjX7q7CaSiTkaQcBvJyABbBUQMAsiCVagVRNXT1O4CRzOW1f3hW3px+NIQX1V0Tauga7qWkzMoD6JBRrI1GklDd38m6JwWbRIIBwDu0cLvikcUXSphMT7MWN01DSE5MaJtfxF/aEg6F0DMOimxjR0is8blfzKwmaWH7auisXf66URrm1gLNka8yvHvL0z94dn+alU2IT1LeUo+o8qaT/A3e5NUPscME61tPUgONzl2EBu7Vcapkz5k2PznxCw8hJbA2nrG4ctPJI38zsDkAsG6HflQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1316.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(83380400001)(64756008)(9686003)(55016002)(66446008)(316002)(76116006)(10290500003)(86362001)(66476007)(82960400001)(38070700005)(2906002)(8990500004)(82950400001)(38100700002)(122000001)(66946007)(508600001)(186003)(8936002)(7696005)(33656002)(5660300002)(6916009)(6506007)(71200400001)(8676002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wL3ejTK4GBaql2HURIzh2Rpk1fonyyO3eGlJqBrJC1DQq2/8TFv8HV7VNVB9?=
 =?us-ascii?Q?M0CPzE58mWxNRj8jiloDVHAAziGORxQbwdIxuZzTjRiz5s9Fy5bhDRLGBraH?=
 =?us-ascii?Q?3/Fz/Y2zH5kyMnwreq5DtbnaS++7vf5FMEHgDQVOMBEq2tDmmflzOfbg9GGk?=
 =?us-ascii?Q?K3ZAZNK6Vmq4x9R6EyCc6mrsfcnHkH8zAFe8ClXeKSQVhwPgPLgYU/GSFiSV?=
 =?us-ascii?Q?WnaLN9229Cz1CFggetki4WPIL0DDeatx3PlSEIoimhJ7iJWMqGY+BqGLfCiE?=
 =?us-ascii?Q?exRAS4S/YreQRI7b0kIEUvJq82xzp2xNC/XBjjCK4CcfXhQuoCxUb31RuD4y?=
 =?us-ascii?Q?jZ+QA7050eBAzinDAgtvddha1evq98isihGGZgajLY61dygrGRrop+VLwRsI?=
 =?us-ascii?Q?Ajlt0yOvrsK+5dh8x3Qe7bOwuZxO0Tycd2L45srZ0by/AvlOKAW4cj8Whpok?=
 =?us-ascii?Q?wqiGOiwk3Wlt//xtGVcw986Y3xgmsbs1GZ27KAUxx2X6WI7wtvbHw3t7ITpO?=
 =?us-ascii?Q?qwQ0d1MACyPWIKfGP7E4SMAPGWteut14+l1pX9ktvJs55OhHgnyTxs70YZR4?=
 =?us-ascii?Q?D3mU52OiCe//hIxQ8hUoVSRM4hlp67MV6kHIa6MajMqwF9gONcXH9voy5I/Z?=
 =?us-ascii?Q?zZFZ6bAEw7XJqbUyPUJzAqClqRQMCCuSY4C/Uv5HOaR+LTfZL06N6KkquWYz?=
 =?us-ascii?Q?YsYzzjeZUdiW1LTjUqYKmJdxPcxonmeVS+wm2Gcpzunh4nOFYcYwSNC/ttgp?=
 =?us-ascii?Q?j62eY6ofZBVQJltrTwyxgahN5IJGYVt2kBhUVGzRROo95FB1RZw5CZ02IHgZ?=
 =?us-ascii?Q?bYiX5Xc9ZHmp81CyDGdfngr6sEaR1VfyHBKVFCtyVH0tB7tZWwQiXYJ10psX?=
 =?us-ascii?Q?s9sNS9ZotNYkqpsDo4CwSjaKgNklkhCFNpKjkxpiSjImPrAXk1osOUCQK/o2?=
 =?us-ascii?Q?O5ntAe6oI3rxI3sWCIWu35RmThHzLsqAmpJe7fnXqv+b+gXPjrj4bPXfrKPI?=
 =?us-ascii?Q?tm6LVbspaaPpLODe2RyhrWTOB7BBSoxSPrkRBStQG81hcTIbeM0Sb7ujwhgu?=
 =?us-ascii?Q?G7eKM/siayf6blOE96ET7+/TsOVAVfh5xObdbCkMXx2OKyUd06lwt+DnAmnu?=
 =?us-ascii?Q?ynZuhnl1dvfSuSnBNz/NzSeZ4uw5Zk+yEm9fxNvwsLxevR/3ke40lv/FXPfl?=
 =?us-ascii?Q?/is9Kw/9Pb3QLwOA0utqHEqfUbLa9bJs46nnk9dHao9HApFA66G11QIR6zHz?=
 =?us-ascii?Q?fuLhQXezbea6lCmNBSJxTPxnQIjFwdS8MdI66LwXOv2NmdTdxCpq7kLT1+Ue?=
 =?us-ascii?Q?T8M=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1316.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dcd6fdc-b6e8-4571-3a1e-08d96c1095bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2021 23:47:53.5625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wGu1PQP3ToZr06gFMQX+JIkEKO0lcWcKbFsPzrPcXiZt3AzEI9b6eMCntuPZQ61GtMrJ8jsB3KN1mk24AgzAjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB0996
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

When upgrading from 4.19.152 to 5.10.40, I noticed a change in behavior in =
how incoming UDP packets are assigned to sockets that are bound to an inter=
face and a socket that is not bound to any interface. This affects the dhcr=
elay program in isc-dhcp, when it is compiled to use regular UDP sockets an=
d not raw sockets.

For each interface it finds on the system (or is passed in via command-line=
), dhcrelay opens a UDP socket listening on port 67 and bound to that inter=
face. Then, at the end, it opens a UDP socket also listening on port 67, bu=
t not bound to any interface (this socket is used for sending, mainly). It =
expects that for packets that arrived on an interface for which a bound soc=
ket is opened, it will arrive on that bound socket. This was true for 4.19.=
152, but on 5.10.40, packets arrive on the unbound socket only, and never o=
n the bound socket. dhcrelay discards any packets that it sees on the unbou=
nd socket. Because of this, this application breaks.

I made a test application that creates two UDP sockets, binds one of them t=
o the loopback interface, and has them both listen on 0.0.0.0 with some ran=
dom port. Then, it waits for a message on those two sockets, and prints out=
 which socket it received a message on. With another application (such as n=
c) sending some UDP message, I can see that on 4.19.152, the test applicati=
on gets the message on the bound socket consistently, whereas on 5.10.40, i=
t gets the message on the unbound socket consistently. I have a dev machine=
 running 5.4.0, and it gets the message on the unbound socket consistently =
as well.

I traced it to one commit (6da5b0f027a8 "net: ensure unbound datagram socke=
t to be chosen when not in a VRF") that makes sure that when not in a VRF, =
the unbound socket is chosen over the bound socket, if both are available. =
If I revert this commit and two other commits that made changes on top of t=
his, I can see that packets get sent to the bound socket instead. There's s=
imilar commits made for TCP and raw sockets as well, as part of that patch =
series.

Is the intention of those commits also meant to affect sockets that are bou=
nd to just regular interfaces (and not only VRFs)? If so, since this change=
 breaks a userspace application, is it possible to add a config that revert=
s to the old behavior, where bound sockets are preferred over unbound socke=
ts?

--
Saikrishna Arcot

