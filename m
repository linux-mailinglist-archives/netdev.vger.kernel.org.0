Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA7930AAD6
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 16:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhBAPQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 10:16:04 -0500
Received: from mail-eopbgr70110.outbound.protection.outlook.com ([40.107.7.110]:62944
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230110AbhBAO5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 09:57:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+OHQ+l4tUfI8jSrRfHmu+kByZRAtrX2vI88KBdNkmyYFiCCRrpIhdYGxIG2mMTfJF43Blf3R/Vift06wwyjp7+PRRc59d551q1Ji4fX8daZtEKPrLI8wQMR3OHcJGNN8uiqBoxZ9PBIdONLHsc8QiitUw+StSYflMK9UToAz7lug5lheTQ8/ABypxTW9dqsYC6oMxiP9pDbZsTEIqLgNT+3McEAlHJPHAV264vH4Z9FaNQde5kzXzqOafcQIdl3I6zgTulKhtRLWdp+5PHVLXZcVByUrb/vGVCueS1jqIQUGrNj72YCmL/QvXCsg7ByIYqtgwcp/Q74AIgX3JqWgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kddF4h8VgPR1/onoiaxBv5aGABmn14IopA3qUc0EsPU=;
 b=SbszN1RGfTNFWBGjCQZ6Y2q523ZdCMDbAjXk9y2TjJXpAHuI/+knGpKvIOs9xQ+Cwwa9HqReA0lJTZ74bBc+lRudIhbsUjQiI8LK6eWY4/0ri/JSWtD0z4SfzF6/rqvYsuV6Wi0w/CTs5rntqYH5YuCOTOnoYFfP8foE3fejkWw2W3HnmPbyYEEAzjNy0a5mLatQUGYhT/SXOekreM6IrebXV3wyaQwPK0RO6Tz77Uo0lB6zJ0ZgvKXDeLNwiRLGPBSC9hB9HHrfynhSi2nUvBLdnSGT485qm9lsjREw1FMitRWjj50mzi9HiCgPhtXCiB9IJzTHzodh+dQJuRPwiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kddF4h8VgPR1/onoiaxBv5aGABmn14IopA3qUc0EsPU=;
 b=F3XNetrjEBmanFutA531XK50pd++83o8C3rtCtiyHoLNzk38SyE2yKCy8uu2mqpQN3YJVRFX9YarMm8GAYiVrZTB3mJyA3tsJ/wmGen3PtoCiETbnw9mFrT5WfdKzWA6fDrW8dlLYFuPri49EKs9HYLkr78EaX5A5A0MAhap+nE=
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1154.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:271::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Mon, 1 Feb
 2021 14:54:55 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3805.027; Mon, 1 Feb 2021
 14:54:55 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v3 net-next] net: core: devlink: add 'dropped' stats field
 for DROP trap action
Thread-Topic: [RFC v3 net-next] net: core: devlink: add 'dropped' stats field
 for DROP trap action
Thread-Index: AQHW8xcXY5euT+iepUq2JFXYOtkL6Ko42mmAgAWdF96AAImvgIAEbH7J
Date:   Mon, 1 Feb 2021 14:54:55 +0000
Message-ID: <AM0P190MB07389749FDC9EE63F1F8435CE4B69@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
References: <20210125123856.1746-1-oleksandr.mazur@plvision.eu>
        <20210125132317.418a4e35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0P190MB0738FC4657CCB0E435C40B24E4B99@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>,<20210129111937.4e7e17d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129111937.4e7e17d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
x-originating-ip: [213.174.16.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c4ff9c4-8ab0-4d45-e8cf-08d8c6c15649
x-ms-traffictypediagnostic: AM9P190MB1154:
x-microsoft-antispam-prvs: <AM9P190MB11540AEB65B5B4FCAA6FB19DE4B69@AM9P190MB1154.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jJS9n3HQzCZkYA1pFogkXAEnNLQ3c7eVixkYNiXAT68xRCtZqwSW6ky1pw18TZzY2vRjsxCvlKcLIJnqjVL/J/xXz0ozOAXt2UXwhcLk6qq3zGgC72H3RNzUrHp/NbI9+yIgi70LUB9xcM4/eAHR0+dFUOkQ0bJbOJd3oO3Fbj4UD3kqBV/EUmvnAq3OT8hEBTArORLvExrYIG0y+GrcXHz0KWJjrA97n9kQ4RkD1DYGk13hkUjgo5K9y5bdXaX5wf1mepOpC7HUd7LVnZjW+ft3uMGlgYOQhgJqkJR54INpYPjY0I5YJgtf/MMEf63MV4SPVr5XFuT15DQ5xMS1yJVlmwUoF/j/4j0L2LCrN+HGD/ksxq43BiBDg/C/jSVOSIV7k/PAoaMNNLGyY8E3yEwWfci3JcAcUtYx5g0nwD7t6Csa/ylpEIx189n+nwdDIVlrW8kujEAsmAZw0ninYnglkSc6L2gX8KgCfvc5AkZhc52c9Z+S0O43g24MgYZlk7/0tJP54ecxjd1wEXfYRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(396003)(39830400003)(4744005)(44832011)(54906003)(6916009)(4326008)(26005)(71200400001)(6506007)(8676002)(2906002)(7696005)(33656002)(186003)(8936002)(55016002)(9686003)(52536014)(5660300002)(91956017)(316002)(76116006)(66476007)(66556008)(66446008)(86362001)(478600001)(66946007)(83380400001)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?2Wa53tGPEuaxx0LFrUyfF7GOMC8cQUbaqjGc6BOiiyZWs0aC4eWxs0iaqF?=
 =?iso-8859-1?Q?0m9jD2QaAaTYKZEqGIjBBisNclJ7diBo2tBoM2u10O+KSQY9pQITXStMrr?=
 =?iso-8859-1?Q?pJBiLPEKOh3TGi8KBf8Ajhf6dUpXJ5g7QKoxfeiJLXfkMTqUx0PSne7e74?=
 =?iso-8859-1?Q?ilwhEZ899tzLu1FtNcJPoPQvFzJ6ly85CAALMuILw7GxjC/oE9llw7D3jU?=
 =?iso-8859-1?Q?D+IPzxFdE7kYGlTKvr3NsFjc116ydT12S00a6v0Mdj3sNBrlNLTEWBp+/c?=
 =?iso-8859-1?Q?q8EeSnKVYPJ60moW4cr0sCwUZ3qGqnQZ8iKIYf+vTLti3uWKUQdPREx2cn?=
 =?iso-8859-1?Q?O1Hu1RPnl06T3I4194rpUzGd6+8pKqs9kDNdEikYyuApIxzQRO6ncU4xp0?=
 =?iso-8859-1?Q?R33sNUepTztj4INysug3Bczk3JXxlrIbciHJNcMBtaU8JOI/4I/YWZZgsk?=
 =?iso-8859-1?Q?+hbpL8W57VF+gOAN1XKY2d+b3wZV74zoSdITzD21fU38nI0HoCX2FRP2V2?=
 =?iso-8859-1?Q?J/yLxtqaKQ/70w9Gi+ROqfOeb8QEktUODzwF5fxG721EsaiY2D66uCdMGD?=
 =?iso-8859-1?Q?pY/Xq1WlJQ14a11xIkS/9os2UWqbGdxJOtSNu2/MhiJMXT9LSvEd0Db7VJ?=
 =?iso-8859-1?Q?9ND38SDmZW/2UZbz+wCXLjyNG8Leq+B69bdPV1LMdMLdHc6Am8eApO2c7y?=
 =?iso-8859-1?Q?6kcG3/7KsMF6y/q4QWnvyXGtmEAtyxCDUP1w8WItL1X3LLhuaM2JVwfcuL?=
 =?iso-8859-1?Q?Bh8Ivnak2oRQeSnMq8Xa3iyeCvJdi+VkD1b6io/UaGu6H0GYAys9D/tt9h?=
 =?iso-8859-1?Q?BskdpyzKilLHfaVZLk2NeMcV6Y51UnyWHsGHq3qmVN0fmJjk5qGuDvbljk?=
 =?iso-8859-1?Q?/c26fkHnIdOXk7sTXQk3sG7TNlmbWMbVV0MMsSdF0iJbSlpjd52JSs15Yw?=
 =?iso-8859-1?Q?OVd9Mx6DyJnuODhdKB47zcfgVaqb7pPV1Tt11RhwahRKIrhdm4T/KbApTM?=
 =?iso-8859-1?Q?nXEL9czG7lIT8FU4RU2QDaxyKy1WKHXmFBQrk9b09xEQ5iHWyTdUgFLh2/?=
 =?iso-8859-1?Q?SCoh+lkBZqyL5y+zUNMCSpd0HH/GFULtf/TWjoSVmQeD?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c4ff9c4-8ab0-4d45-e8cf-08d8c6c15649
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 14:54:55.0123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nUwZovZFnxGWTliR0DfJbemsxonZkO3yssb61+kr4hzKhvqRYUq2uOrNIy/acCS7KcM9gdb4Fs6jblFvvSTOAtGsc75RoULz5c0erCO89qw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1154
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
On Fri, 29 Jan 2021 11:15:43 +0000 Oleksandr Mazur wrote:=0A=
> > >Thinking about it again - if the action can be changed wouldn't it =0A=
> > >be best for the user to actually get a "HW condition hit" counter,=0A=
> >> which would increment regardless of SW config (incl. policers)?=A0 =0A=
> >=0A=
> > >Otherwise if admin logs onto the box and temporarily enables a trap =
=0A=
> >> for debug this count would disappear.=A0 =0A=
>> =0A=
>> But still this counter makes sense only for 'drop' action.=0A=
=0A=
>Okay, well, "dropped while trap was disabled" seems a lot less useful=0A=
>of a definition than "number of times this trap would trigger" but if=0A=
>that's all the HW can provide then it is what it is.=0A=
=0A=
>Does the HW also count packets dropped because of overload / overflow=0A=
>or some other event, or purely dropped because disabled?=0A=
=0A=
Hw starts counting traffic (hw drops) only when action has been explicitly =
set to be 'DROP';=
