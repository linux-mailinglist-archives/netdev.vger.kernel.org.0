Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9193C4460BB
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 09:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhKEIi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 04:38:58 -0400
Received: from mail-eopbgr80108.outbound.protection.outlook.com ([40.107.8.108]:12463
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229473AbhKEIi6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 04:38:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FHtVmOkXQDqXhHssX8vIp57nfZ/henLScFetj2jMY0sJ5Dc5BoYOoVU2XA06+nWt7XNJxQc3XMRP7D8DI/wk9Wd29P/DUznJlYCeTUhf3jCyE77gs6OLRVMrqf4gl338khaIIT9vMIyUhArQEmZZInpnR8B9eCGfTrsOrs+Z/wTmhoqNADPtTlIWUTr9RrPYYBBS7mVdNSC27DyG8905kHV7iNHPDkqKckOjzkyVcVZKhWP5Zdk+T/a5jGN5QO69D9L6y57hjVfqeNi58yET7ET8hZJVDPIKEYDqOlbDrJP1N8iqAtTT+qrXIzqme4TBGiOjenQ9aCKyQiy0XApGzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkVpU3Od8+cwMMZgIfgUU1OxMGL3NwUpvqVN9tUcL94=;
 b=mLSpI/EqN8y1DhkPvdTE63t4d8wJEB8APayrKHmj6f0/6QDhyEduu+08cdpPozOFcJyoYpp0Uhu+TPGDAu54QRYkh8VplvqryNTd08QjhA2H4I0NiNEX2Ab9YAYoE6+/qY6CKyoVrGAQyNwPHq6NPhc34SWb7Ws26isBa3pgngtOTMbNqx3KqzS3mvdQ0x8o8yEqRdC76GB4N6pq5LVVzI19qwJ8YNfdTqEf8t8itFTdjf16PE30eqmTo2tpqHz5iCVRKromn2bxBP5q9PZwrLFxzdihx7SI0adbvyqva/TYuxerGxiEg1W+4GTnhcI/pfJS7ZWrJZz6WOb4Z2sysQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HkVpU3Od8+cwMMZgIfgUU1OxMGL3NwUpvqVN9tUcL94=;
 b=RX9F3Tfn5YUUeTVnap8ghzZSpu7MWCbXK3WmIFWmHmjALWySRITqnkDb8oFqcU/QFiRRXPdpszOkSf0e93F6AJsWUcuqx8Misbn3KpQ39RdIGzS8Iw//+AqnuHbaC34SR3IXm5DTv/tXMuSV26Ac/exmSpeBtIJFktOL0MBOuxs=
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0400.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18; Fri, 5 Nov
 2021 08:36:15 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f%6]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 08:36:15 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     Guenter Roeck <linux@roeck-us.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "mickeyr@marvell.com" <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v4] net: marvell: prestera: add firmware v4.0
 support
Thread-Topic: [PATCH net-next v4] net: marvell: prestera: add firmware v4.0
 support
Thread-Index: AQHXzIc5rU1sI3cAGEOhWb4OGds5cKv0STMAgABbfLg=
Date:   Fri, 5 Nov 2021 08:36:15 +0000
Message-ID: <VI1P190MB07341B8FC5398584120561828F8E9@VI1P190MB0734.EURP190.PROD.OUTLOOK.COM>
References: <1635485889-27504-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <20211105025920.GA2923425@roeck-us.net>
In-Reply-To: <20211105025920.GA2923425@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: a78552f8-37a9-bc2a-ed18-588e31ceaf59
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4660a49-df76-43db-1c7f-08d9a03754d1
x-ms-traffictypediagnostic: VI1P190MB0400:
x-microsoft-antispam-prvs: <VI1P190MB0400743C5C42782F436D31A08F8E9@VI1P190MB0400.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T+YxdD4DLq5M/iqGQHNCf6+/maf8Nqt41+dtWsCLYYQ1l1SKhLPSpkR3AWxlpemcI2MMY4f/bFtj2ewcVVB8InfXfChECJ/iuQFlpztyRrO0tdyOFyM3MjfdXYOpVAJpgFzltFQIYUrFjlwkLVfFcBvG133BcINUlv4Z6P/5LinQWTbngoWdr26McJyrZ74D/mT/H6SNMyYPIf4+sfpeT88CTnYv/LZKaQlOSsS07jFZEDxre23nAfIH4lAqvqtUwlHeKRPpvJkuC0LCzglVGPDhJ/Q0wvlaEpXbLOd556gw8AZhdnHUGBEl4kerMCb8PKZAQIs9ZmCoJPJJQ9Cjyuzsvdu1p6xoZz7f2SiCcZtqVEbqaC/bSYl/n66JCAJH8zSrTYbDiKWa4jYcuJDXdPLrNJSb5jDjeqqUx+OVijej94sT9uYQpnBzvw9wnG5OL2H1Rl88H3xI/tKDVKjpLxOYOmzapGbd8/RCm0geUm5dx2O4celzEu0eqVxtqD9r5UmSSR37doP3LgKbyP5QOD9PFO7ou5ULI+LlawxHsaNDtrqlPacbdR/BSEfN9LSiLf8QQ5oMCQBhhIAGAR8AyrQU6g9RvesB0lXmR4/84Xls0kLU6ewurEV6spxc8udtRGMBmJFpLUZxoVnTD3r8DjRpzagRRMeDAUDD2E2mDoX2EQzamfcpXHnI+7FlJkrtS//NAyWRa3utvyvroCG3OqsAUxmXQGJUrIOZntacJODFQcMNZcIl5EINnaayKtJj5Wz5t7YNG0Tlz7cJmoP+UIDcXLL5ht1OTq0CKWJaQUw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(39830400003)(366004)(376002)(8676002)(66946007)(52536014)(66476007)(186003)(66556008)(64756008)(6916009)(966005)(26005)(66446008)(6506007)(5660300002)(316002)(54906003)(76116006)(44832011)(83380400001)(7696005)(4326008)(8936002)(508600001)(33656002)(122000001)(38070700005)(2906002)(7416002)(86362001)(71200400001)(55016002)(9686003)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?MsZNsm5qCSIqDXNOQoPUKjLCsX7SyMWwCEJ1I1mZuLRYr0IKWxtBN7JSzp?=
 =?iso-8859-1?Q?Qxb1cenSesS/6o88ZIk6oOscYzRWK2wxn4Wv8WvP8McgQycBXTYP99SeTm?=
 =?iso-8859-1?Q?Deag+nEhqLiaJphvM7W37mzbStb8w1eu77KJjyZo2sJGDVsxC9BIXjpkWu?=
 =?iso-8859-1?Q?51Z73fOxaaJek4Ol6k7puFYeowU9tI/w+yX0bNoZXqzkP/3l5tpsBZpISn?=
 =?iso-8859-1?Q?nLWbc3xzlvIv9s7g3ArDQ5b7HA6mPWPscxis8WBBaCDb9Gqg4Thrt56rIE?=
 =?iso-8859-1?Q?jmLQgChCnnKyRNnVw1aCvEdPRgT/P0aessUgMJy9IyNKhaCR0INvsfuPdd?=
 =?iso-8859-1?Q?ZdatV6BR8YiUmbQBPe+QbjvqC3Vk3VwzI9qJgBzYOzd2zC5L+wJmmYC5tl?=
 =?iso-8859-1?Q?gLydziZTon1to6f2vKuH9vJibTHOXyoNu873JEu0gqTDSO6pqIwKnLEZ2I?=
 =?iso-8859-1?Q?XqAwZvk0ej5DT+p7LugcwaZlvHvfPqK5/igxOdmghZHZsrN15B2ImPpsLn?=
 =?iso-8859-1?Q?X1VdMeT6B35i5P1SqmTA+gvJVRRO5mNZd5jkeT0e7e+2rx9zv/qhG1j+GM?=
 =?iso-8859-1?Q?9XuucESpWWCUowPvoISQ7wKb0ldEUcM9AX+u3FVpwWyQ4F71azCk/u3TJK?=
 =?iso-8859-1?Q?9r04lYLRy3WMkURTzu6pHRN1c1NJZnHM4SKHE8aHtcVIwb6d/+v7lg7tPI?=
 =?iso-8859-1?Q?Bv1TycFiIZL6rLcXgNeIgBES71jORTset4yoBCJtouEVLIBBAv3bpiCkg7?=
 =?iso-8859-1?Q?+5oNdofIVhkA8PBpqK29yM4q/1QTgYmKM8KCjxF8fsW2E4MExHzDkJZbU+?=
 =?iso-8859-1?Q?Zq5htIs5DRh18AjuEBJV24StenW3wyDEdWe3Gz2HaqT2wtLdiDBtRTAOCW?=
 =?iso-8859-1?Q?Fic1QPjP7MIUVVkf9NcKjtyl+3ABVpiI/3Ih1RQW2BgoahPJ5DiQNJHsbf?=
 =?iso-8859-1?Q?4NlcyyIEjwENVEVjPJ6SdkxHa3/pe4zxEO7PMTiCvKAlAbjl7xco450Fj9?=
 =?iso-8859-1?Q?n8YJf48wHZfph6dDAH2+esu/VKGqK8gZkNlCKD9cOvtdjKhvLQTDjcZ7K9?=
 =?iso-8859-1?Q?gmOD0f5+/Fco/7+Io0G5mqxQbllu6+qA9WX25a+9zt7TPrvRIYAERKhUdR?=
 =?iso-8859-1?Q?TgudKKDFIrMOZaqJMsUb6dtZXG+c+3n2CY7aDYwdw8YAxHV2ibEaeIxOIx?=
 =?iso-8859-1?Q?mP1tRrMYHGWNnXsoainjd5kxiExTY2pzi8+C+tjrDxMjg6wrxW0tq1Arvb?=
 =?iso-8859-1?Q?6lv/VZWUxq5OFtdHI6FmXBi7ZkrgCWjhh65f3aFX3G9gxlJCd50DtWu3we?=
 =?iso-8859-1?Q?UdQjMCCSoTW7F6OAB8rpr7AyQTD7vtiqYexdKVcrr0iulCowg938r8SinZ?=
 =?iso-8859-1?Q?uSJ6wKktDAy4btmDkkSRyDuJSHx9T1cOTmNUnyEkgK7qwh/Ad+rKQws6s/?=
 =?iso-8859-1?Q?I3qQ/q3WaWXscG+mGYjgtqDu+no/SD3lPkQk0utjDhh53Hn4D6rf+uIUVA?=
 =?iso-8859-1?Q?a2c4QTAPCExzqkqF7ok1NPWFPd4GvfpBK/huqF/I8L/0RqZNlEoVckQOvX?=
 =?iso-8859-1?Q?OrjSePH2CPRVIq4fE3vqV0dM0bIe56La5zNQuiUpgnLrK5ASveisCW8auA?=
 =?iso-8859-1?Q?igTN9u7A9aS6uXZWpH578KK5NtQwYItkf2z4/PR4CN+snQxMoCxP6is0ld?=
 =?iso-8859-1?Q?tgWs9CBDpbSePT+B0QqEgT4tkkVmk1Vn+UydXtAQ?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f4660a49-df76-43db-1c7f-08d9a03754d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 08:36:15.4723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xAS430y2k5yXmP7a5Qw4+cqma31zQfHnKM3oJTUckyvfXwVO5Nr3MSwAmCjiy4obXqCZ4N9CJ+wVG+jG2Rzkgf0LP/k+Kyob+iWplt/CVLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0400
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> =0A=
> > From: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> > =0A=
> > Add firmware (FW) version 4.0 support for Marvell Prestera=0A=
> > driver.=0A=
> > =0A=
> > Major changes have been made to new v4.0 FW ABI to add support=0A=
> > of new features, introduce the stability of the FW ABI and ensure=0A=
> > better forward compatibility for the future driver vesrions.=0A=
> > =0A=
> > Current v4.0 FW feature set support does not expect any changes=0A=
> > to ABI, as it was defined and tested through long period of time.=0A=
> > The ABI may be extended in case of new features, but it will not=0A=
> > break the backward compatibility.=0A=
> > =0A=
> > ABI major changes done in v4.0:=0A=
> > - L1 ABI, where MAC and PHY API configuration are split.=0A=
> > - ACL has been split to low-level TCAM and Counters ABI=0A=
> >   to provide more HW ACL capabilities for future driver=0A=
> >   versions.=0A=
> > =0A=
> > To support backward support, the addition compatibility layer is=0A=
> > required in the driver which will have two different codebase under=0A=
> > "if FW-VER elif FW-VER else" conditions that will be removed=0A=
> > in the future anyway, So, the idea was to break backward support=0A=
> > and focus on more stable FW instead of supporting old version=0A=
> > with very minimal and limited set of features/capabilities.=0A=
> > =0A=
> > Improve FW msg validation:=0A=
> >  * Use __le64, __le32, __le16 types in msg to/from FW to=0A=
> >    catch endian mismatch by sparse.=0A=
> >  * Use BUILD_BUG_ON for structures sent/recv to/from FW.=0A=
> > =0A=
> > Co-developed-by: Vadym Kochan <vkochan@marvell.com>=0A=
> > Signed-off-by: Vadym Kochan <vkochan@marvell.com>=0A=
> > Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>=0A=
> > Signed-off-by: Taras Chornyi <tchornyi@marvell.com>=0A=
> > Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> =0A=
> Compiling this file on m68k results in:=0A=
> =0A=
> In file included from <command-line>:=0A=
> In function 'prestera_hw_build_tests',=0A=
>     inlined from 'prestera_hw_switch_init' at drivers/net/ethernet/marvel=
l/prestera/prestera_hw.c:788:2:=0A=
> include/linux/compiler_types.h:317:45: error: call to '__compiletime_asse=
rt_351' declared with attribute error: BUILD_BUG_ON failed: sizeof(struct p=
restera_msg_switch_attr_req) !=3D 16=0A=
> =0A=
> The size of struct prestera_msg_switch_attr_req is not well defined.=0A=
> =0A=
> struct prestera_msg_switch_attr_req {=0A=
>         struct prestera_msg_cmd cmd;                    // 4 bytes=0A=
>         __le32 attr;                                    // 4 bytes=0A=
>         union prestera_msg_switch_param param;          // 6 bytes=0A=
> };=0A=
> =0A=
> The compiler may well decide, in this situation, to generate a structure =
of=0A=
> size 14, not 16. The error is therefore not surprising.=0A=
=0A=
Hi Guenter,=0A=
=0A=
	This commit has been merged w/o waiting for all review comments to be addr=
essed for some reason. So, there is other commits that fix this problem.=0A=
=0A=
1.  [PATCH] [-next] net: marvell: prestera: Add explicit padding   (merged =
already)=0A=
    https://www.spinics.net/lists/kernel/msg4132698.html=0A=
=0A=
2.  [PATCH net v3] net: marvell: prestera: fix hw structure laid out  (not =
merged yet, still need to address the comments and new patch v4 to be uploa=
ded)=0A=
    https://www.spinics.net/lists/kernel/msg4132698.html=0A=
=0A=
> =0A=
> Guenter=0A=
=0A=
   Volodymyr=0A=
