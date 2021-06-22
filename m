Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C523B0313
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 13:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhFVLqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 07:46:24 -0400
Received: from mail-vi1eur05on2096.outbound.protection.outlook.com ([40.107.21.96]:45185
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229900AbhFVLqX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 07:46:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YB7USs05JrGK3AsVoUtt23BBsyTH0M6lRSfHiSOlw78Rj2rRBR8tMwEqEqmWL16yqOqTWUrSi0L8xp8NNM10qVAh+MOSHJ5NqwYIU92gZcWXspPosOnuegLPj3uZve8/CpjgizeJ7FUotYWbqO/6Bda2bMiA4sMQdibM2r5VlXkwtiXsNlHtOTgDBYgDnyyEwRdC46ruWfQt5KI1UlKFITeeQns3tq2odilQBgHyJ8ZWeMckuOaulNmfw/VP9OIzQrf9Knbk7gGChShZN0VpwVUo/aLaXq21yR9OElBtXykWdzJ7YIUgnaPm2QN7JERlpmus1zaGLlQHYRFhkle48g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgrrMXUCPa3zqwmXKD+DGzENpBkgsdaTKAG7Zct5cYc=;
 b=L3gGsPq6HHxZnW+JScNg3pvsqLucdcd50wd7AVFcKVOf3TVDa8y5BGkFl/Nof9CGNXMYCn7WgMubR/tILjy37A4MknYO3FUOTW3IoBVZBKJVVY5K1kNKSkaOt87UlBynwKtzs37ODtRmbIFagkF3mgObBHHkgHQFhRtGWZvY02o2OW+LEgcteaQVK7i4jLFw97ptdS18gUrbn5I+T4IYLGJMCxc8LGsrKOO1W3RTicD3G6HwBy/iHePmt50iDlReplpCIt9VFp/e6NBItgSQ/qYjwgVa/teBvhUQrHIfb3H9YYlnD8h6PIjyMlyzf5yuLkU5BKgXU/ytBpNdMr3Y3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgrrMXUCPa3zqwmXKD+DGzENpBkgsdaTKAG7Zct5cYc=;
 b=tK2BlO+OFhRS/nXUZUNbdnYTsmYLnWtJAvXWCdObWjpO5Qjj292Mw3T09gj1YUq/HVoC9+Vty+MdLHXXnnW6PBiEh31JrplRzqYTY6smVX1X1J8FYmdHqI8si5rqVQ9i7N0uZvoTWy/vbryCwDAsoSVEVbWR0igvRROt8Obkyb8=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0508.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5c::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.18; Tue, 22 Jun 2021 11:44:04 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%7]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 11:44:04 +0000
Date:   Tue, 22 Jun 2021 14:44:01 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-firmware@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [GIT PULL] linux-firmware: mrvl: prestera: Update Marvell
 Prestera Switchdev v3.0 with policer support
Message-ID: <20210622114401.GA32650@plvision.eu>
References: <20210617154206.GA17555@plvision.eu>
 <YMt8GvxSen6gB7y+@lunn.ch>
 <20210617165824.GA5220@plvision.eu>
 <YMv0WEchRT25GC0Q@lunn.ch>
 <20210618095824.GA21805@plvision.eu>
 <YMyikxsdqNi8V5zG@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMyikxsdqNi8V5zG@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P194CA0003.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::16) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P194CA0003.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 22 Jun 2021 11:44:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47d9c500-e193-4940-450c-08d93573090b
X-MS-TrafficTypeDiagnostic: HE1P190MB0508:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0508BF371EC305B4981AC53D95099@HE1P190MB0508.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pzlz/lZmbJ4xrNKltMCDD7XkRV6ktP9Sz6EzH9K7zdEbPZKHUPuShs3zZt5qJNy01+as62Q9y5QZ0gmEfedmMs78ET7SZP+M3JI+Uh7EU/MX8GkpOFUzs1W43PmNi8fahaWiX32IhWBpwtRSMs+kIeKCJ5Cb9vGOUUWrkGjrnVgdb5Hb/0EEafGSTwC+n+FVl4DO2d1svZo9tIug5u1W3PaWEba2+Rq2/TlUEUXOMnL2td3hnoTo3+1aGXgF3vEHFv8K/D8eFUGYJIpo5aHgF6fuCii7kK1S0Y8Fj8Ti0KTb3p/DvgZuzi8jCOmmLwc66ZvEuFDKC36shMc00RM36p72AAvIwa9Tq3gnduAiupwyC8kUJR4N4SReDFAP/2TodIRzEa8ufPTp5xuHUwcT7WPpIyQl74EvUjtV3SvILN72AEzqSM3285IXLSCc3pDIGVwl0VNZOCh/FW3RKFu63shmm1BIZ7s+/EhzYh+3u7ZI/UYeMehOHfE9S7tv8Lksh0wCCeu7dPcOIV6hhokKBQfu73589dPVvEWj7Cyia7awvQ6KLkM6Gq6eZRdeDubF6WCpwwSVRzsDCAC3CinxQhMtMXskLSxqKWvviu+orR2nsaS30t204dEbk2WIvD2+wX4Nt74M4o2a+zkmv/QNT+1W043rN2Ih24P358C022mj2idBQs8Oe/+/87y4SthAj27S9ssWjMjWHDreQDzo2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(376002)(396003)(39830400003)(478600001)(66476007)(66556008)(4326008)(5660300002)(83380400001)(6916009)(66946007)(55016002)(316002)(2616005)(26005)(8886007)(956004)(8676002)(36756003)(16526019)(38100700002)(44832011)(38350700002)(15650500001)(86362001)(54906003)(8936002)(33656002)(7696005)(52116002)(186003)(1076003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jh3WLtEVxJasIjagRMAOLY5WhSBAKCe+JYjY49gOeQ/Fzas3wSMtmc18JiGB?=
 =?us-ascii?Q?+Jh1Dba4f2lS5Z5VB/03bIlsia5fKN35lPvVsauKCDyh3mx/6TcdP1j7YOyS?=
 =?us-ascii?Q?5xtKjrNQQMlgUd32Eek1OFC3zMceQkhLG00TXiACESG3LOejHgB6KaJOUtXx?=
 =?us-ascii?Q?L69wNUNusREYm6ffpL6mzfDe3n+HeGxFjE0Hoz5jwRXNSVw1p1IpznaCsHdB?=
 =?us-ascii?Q?0xfjoIzbWplfN50qDoFz6D8hRnlfBSC9EXSRfR9PeP3fhZiPVP/5t6aQoe9D?=
 =?us-ascii?Q?f3nwaqZFn9h2RYSFnwvJBi8M4bx6MxWLXLHJHycPKXiPp5JuF1t1qiJsfwMR?=
 =?us-ascii?Q?D1MM9sDIXwBxmvNiuGd42Hys5bvEw0XfCf41HZDYmMtt6qGtRGsETGd383Bh?=
 =?us-ascii?Q?g/dJN3o0V29nwHG5InJskwuMyzEAwlyKMzs8qY7upKESoQG9dFOJenDn8W1t?=
 =?us-ascii?Q?Oxwd6VIzym30vdBgcbl1QHTiN2t/1KE71ELACDo25jNlAl+jrKcYb5ev/ywz?=
 =?us-ascii?Q?RpalUhSgmrqXsAc3i93IvyxLFV3oQ4FhCe57rx5krnhQfBCUtisfCm791ju/?=
 =?us-ascii?Q?GBiTqb2pq298GFdqeX2l7CzYAYMMbVOIKik/v8xrzouMeOLgIRIEA2MzWqc7?=
 =?us-ascii?Q?w+fM8i37hW/psuOtI4IPoHKja32Q0VNotFbDcIh541oYsQJaGOyR7/67bEpf?=
 =?us-ascii?Q?Lhv/fIx8YPzJUeVpZzs7bI4FsATIyP362wHcTjTyqv3xPNHyjCMiNYcWvXuZ?=
 =?us-ascii?Q?uyqA8PLWF5E2WgI+aVJT+4FrI324ZflncJ4GY6iR4JYv5jzyQonz4QYQ5Zb+?=
 =?us-ascii?Q?XlPhtkMWbJLOyTwyQyDyEBfS0Vdq6zeLHXE48Jp8p9yYRRCunmwSYPE7h6sz?=
 =?us-ascii?Q?Zn3boSHfxPWC2Z3mZDR0w5TtoW0HalW1M1wxUG20XV+ZM6RL+8Pwl9hh+tqY?=
 =?us-ascii?Q?jCqCaT91uyiAT2DiKiy5U7ST2h9LQ0EzbnbUYlM6pxIAJ2KI59lgJKXLTj4c?=
 =?us-ascii?Q?Ecxu+az61HiXQC+MyIE79rqSeNhW836WleY+P9/8op4RL+aDYP6zpHqmw0Qa?=
 =?us-ascii?Q?4zRfBZcujeWiSjORYSOYSpHExD0ujrvwVjfZKwod5fr8JvgzdSLffmP9+GLH?=
 =?us-ascii?Q?0/xI+J6DsF1WyR8hyIJNMrDNaBRO+FJCv2hEZJDRRBe8OrZ/SNG9Xtv1EixM?=
 =?us-ascii?Q?HPIUBDBSKsT7i/yHHbSuikVhOt/tDHUf7p8j45AvbPmrPg1wtiy2sTei2dWj?=
 =?us-ascii?Q?HabgN31gpnMxlc4zt41tFusD4KjI5lEBQbXBEzlAzCcNU+rcUosWgyBLQSO/?=
 =?us-ascii?Q?+gg7pTVzOpR/EVN1+YBGe3Va?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d9c500-e193-4940-450c-08d93573090b
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 11:44:04.0819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cycpqZiEJrz77MoaevRAOLRSJUjLMc26/A6lSJkvMwezjSceKklvmfU3WBGi3PctCm7OcrAv6xWu2TljO6gHFIAZU7ClHIezT3oRjfzx7YE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0508
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Jun 18, 2021 at 03:41:39PM +0200, Andrew Lunn wrote:
> > I just picked some from the git log:
> > 
> >     48237834129d ("QCA: Update Bluetooth firmware for QCA6174")
> > 
> > this just updates the binary and description says that it updates
> > to v26.
> > 
> > Not sure if it is good example.
> 
> The filename is qca/rampatch_usb_00000302.bin. If you look at
> drivers/bluetooth/btusb.c you can see that 00000302 is the version of
> the ROM in the device which is being patched. So there is no
> expectation of knowing the firmware version from the firmware
> filename.
> 
> > But anyway, I agree with you that better if new changes also reflects
> > the FW binary name (version) so it will be easy to find out which FW binary
> > have or not particular features.
> > 
> > So I think better to add new FW 3.1 binary ?
> 
> Probably. But please consider your whole upgrade story. You are
> changing the firmware version quite frequently. How do end users cope
> with this? Is the driver going to support 3.1, 3.0 and 2.0? Or just
> 3.1 and 2.0?

I think 3.1, 3.0 (still need to check about this) and 2.0, and the
driver need to be changed to use array of versions rather the previous
hardcoded value.

> 
> Do you have more features in firmware 3.1 you need to add driver
> support for? Or can we expect a 3.2 in a few weeks time? What are your
> users expectations at the moment? It could be, you don't consider the
> driver has enough features at the moment that anybody other than early
> adopters playing with it would consider using it. That you don't
> expect real use of it for another six months, or a year. If that is
> true, you probably can be a bit more disruptive at the moment. But
> when you have a production ready driver, you really do need to
> consider how your users deal with upgrades, keeping the firmware
> version stable for a longer period of time.

Thats, actually true, at this stage the FW can be updated frequently
because of bringing new offloading support. And you are right that
currently this driver is mostly in the sandbox mode. But even for the
earlier adopters looks like it is good to keep the version consistency.

For this particular update it has missing small changes for policer and
routing offloading (so it is kind of fix for 3.0 version). So, for
easiness it would be good to just replace the current 3.0 version, but
for consistency - better to use some extra version.

> 
> 	Andrew
