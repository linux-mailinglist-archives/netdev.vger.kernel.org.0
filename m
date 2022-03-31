Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17AA84ED6B7
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbiCaJWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233844AbiCaJWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:22:47 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F4115E8A9
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 02:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648718457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tYXjCPs77Xt164wdsP6taJfVwR8xS0TffAVE8n4Up3s=;
        b=OtDvtM3h36qerdvOKJmIFZYSG+3TH7ULn6CKKvyPNRL5Vkn1q9NVYW1WmTIz3nrXsZCR+v
        TcKhnjXYkw3d4W+iJdpQR5xZPEl5TnsuPaIyqII1+FNCzPd0MLhYMcvm9vIAPR4qBz+IlK
        w5lI3kexmeBgpJ0frinqVgm+jbOO5Ds=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2107.outbound.protection.outlook.com [104.47.18.107]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-32-8QwFrlR1Os2ve5TpmPDo3A-2; Thu, 31 Mar 2022 11:20:53 +0200
X-MC-Unique: 8QwFrlR1Os2ve5TpmPDo3A-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lMaiYiiswT+5USvhQ6GlD6MUkG7edFIl+pIUuhBBQ8CfgXdeMmPZ5Mos9aPwwgUthBRUkJzj4Pq2gGGRzj9PM071ly+rLdqvPNzw8pzgUMapdW7mdOvHpcLXZxEDiXYDHc/r9mipNOHXKlijKdT2ShQQiXBgXK/rDxOvlgVKRZkEPMCQYObcO6OP3a2Glf9JV+BQXHRtWzFGaC4hHpRCxkBs1ZNO/PjNJarYUSyoTcrkk6lKPYvi7VBnZQ0qYoohrKhFRitxSHGGddnIBhb4nmeIvUzJ+Clt6ixWVDP/JsLxemuPwIrgZ71TdKr2RQutaklbLwXwfGhIniyNeIFOaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZJSquvbOJHXvyiSk7A2s93twta214NSg55o5XguNeBc=;
 b=jXHzqYEzEBpNO3UIUQYNncHNaaa9e+Ku2CIjvgdRmsu8cJs2JjgCK54nAlmOf6qzL3kJEGZf4f66KgHeTnc8Uado5DDhKR+LyiM4AAuEJPquvu+MEZFEhqo8NiVfypd5qCc49fMjac5nvat0K5ZMoJPzIadNX9f/6Dp+NzdqZGEGpv0CIfU5fvtOTbz21va168p1QFnbfRmmhM5ApdTcBP8DOub4u78wU1iI8/Q0tO9p5lRgj3AFREm8rklWuTMFkRxz8GhPJUr1k3XxTsB+ECSTP6xm++hidOxVsPz/upL24mo0OkmMF9v5sF6Sr2VGmADuJWQ+Ep1R1Kq2u97FOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by AM0PR04MB4324.eurprd04.prod.outlook.com (2603:10a6:208:57::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.21; Thu, 31 Mar
 2022 09:20:52 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::dccb:257e:76a7:c42]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::dccb:257e:76a7:c42%7]) with mapi id 15.20.5102.023; Thu, 31 Mar 2022
 09:20:52 +0000
Message-ID: <37ff78db-8de5-56c0-3da2-9effc17b4e41@suse.com>
Date:   Thu, 31 Mar 2022 11:20:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Lukas Wunner <lukas@wunner.de>
CC:     Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <Yi+UHF37rb0URSwb@lunn.ch> <20220315054403.GA14588@pengutronix.de>
 <20220315083234.GA27883@wunner.de> <20220315113841.GA22337@pengutronix.de>
 <YjCUgCNHw6BUqJxr@lunn.ch> <20220321100226.GA19177@wunner.de>
 <Yjh5Qz8XX1ltiRUM@lunn.ch> <20220326123929.GB31022@wunner.de>
 <Yj8L2Jl0yyHIyW1m@lunn.ch> <20220326130430.GD31022@wunner.de>
 <20220327083702.GC27264@pengutronix.de>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220327083702.GC27264@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AS8P189CA0006.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:31f::33) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56ead64a-8b3b-4de1-57fb-08da12f7c03f
X-MS-TrafficTypeDiagnostic: AM0PR04MB4324:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <AM0PR04MB432416FC1226B7AB7F3F993EC7E19@AM0PR04MB4324.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EITy+uDUnlXv1wMEqBajsxqh4PuX5AiX0Wozp1wnmk17Xta8nIE3KNKcujUwom3LrBjGgwYZd4URFstACByxlrCjxy/irxFuwMQesoNNSsJWBBBpSMaIzmY1BhhXYJ/g6XJEWQ/3Ss0FjqXt9r+qbuXoLaRi0UuzI9vdh2ff1qHwnFwep6sQ2f4KwdhL3Uz3EO6LX4MYraQwGQGzetJA+Nj+0yyQvDTPCzDMq8//Fcdv+hulS4QE/1PCmwf/fiKnEusXy7lcv6wxf3T7IRPrLVWXoLeowt3Tw9SvYr7REQ9HWcZHQz/HKORkJDUqZoPCeBCyxzFoMqIiZ2yBP4FRkf0ZBfuJIPSleygiCjJYHNpIv0FoebpjJK3cPhFtoGKnUtw5dKuOjbYi9ISXBKKEgnDdWE38qahqfS4YYZP8CE1M5SoMLs9qtJtqwEK72o9kR7MllLqdqXyHjubNvljiU/1Z6mesCdzHMxQXMRsrZ9+6Ah0LJH+2EWFeQFf1uUrCXYEZbtfvGBWLypYpsxwJIofcfx7n39799jjVTiF7RNsraSFGvJis7pfuoui1ZRQSqEVgKYAH15d17RF8GuqDBoLDcGhV8OXlygRRaDxEdj6Sq2RLb0xs6ixdkINnW87Gvns+rGxHe9njLF7hW+UGdSM8jME48mxp8xkgmLAHipQmZu8R6mvk23IBkLB4W1P1sG9QTM2XndC2BmVnHrMykTeJS/HHK9V1yexT/09sS6Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(66476007)(8936002)(2616005)(6506007)(8676002)(31686004)(66946007)(4326008)(53546011)(36756003)(5660300002)(316002)(38100700002)(186003)(86362001)(83380400001)(6486002)(6512007)(31696002)(54906003)(508600001)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RKZ25NRWXQd3beTKcfDaa6WAPsyHlkFcJYdKmIX0bah9Ahdia8ClBhitAYsr?=
 =?us-ascii?Q?4eonUZ+9EVmI04KvyVnZK/MCRdf5F3e4nHMNSBxm/8Jr0YDUck4WszHfwIQn?=
 =?us-ascii?Q?htuYs7TQjsxPkoBIpzZmNv2a+Xn32PG19UVSyE29gYMtp660ewdx72cT1QZp?=
 =?us-ascii?Q?PBYcBE1xsNfhis/Ar1GH5skgZNBdU4jdOtctKTcH2b4i1dDK1Pcb0CtW6INQ?=
 =?us-ascii?Q?PYYlq6AUwZY34iiQkdY/R44DW7U7/rr6/n4veZbO/XhYX2ftl4tv+9lR/VOb?=
 =?us-ascii?Q?1RjUrEXqNXY4sWkbOj3/Qe6fPSb1Si72f/3yv80bEbti1CNnH929vw2TDU5h?=
 =?us-ascii?Q?UNTn5esthdJmSWFRoZ48Q4UhrvsUuMcNOgYBEEOp4kl1+G4LCtYKXx+Ma7BF?=
 =?us-ascii?Q?SQRjNzvF1EX7fx0vsmwRrZeadfFJw2aBtfd2lhCH1Kf2J+DfKWXJ0JuOUpTj?=
 =?us-ascii?Q?95WOqwogTpnsnQtVM8GvGh5FNVh5M8qqfm4YPPEXJD2tlEm0DQaPhhKl5JFe?=
 =?us-ascii?Q?X4hgYJ9m5MYK88KaFLt2ftq7GhD9VpL53X+zd+UfKKscRaT9Y0peA2eNyOzz?=
 =?us-ascii?Q?EonjAkWB4A8kLybiZbkr1toHko4W84Lt4fu49RYh7W3ml43S0oYEeXnvYT6r?=
 =?us-ascii?Q?ET6EpHAUXs7VZwsOu4ia2AzBiaTYnDjHZ1DVIJ7nmRpUR3BRO6GFlda8+eqb?=
 =?us-ascii?Q?sUD21xwDnRp3Hjkp94Q5jSensUe+CpBwNV48upyFGz40DLl28ff/QnC6hNLW?=
 =?us-ascii?Q?d23M5iHrPWNugvWA+cKXZUGrx/RmQofXdPn0k4ztnM49FK29aiuQgseLvLax?=
 =?us-ascii?Q?aEkdCPwB05+XQoLnzvuxaE4sInf3HgcRcC9/cXfsj46O7x8BehRIpTW9eroo?=
 =?us-ascii?Q?uC0luuU/Ej/H/OWTZuzg/e8N/ce6ERFiPHR3RDh/15rUADWwY6TPXY3umD5Y?=
 =?us-ascii?Q?rlIK4JhJqUNGf9RAq4Ld92j7ojGLsRKNOFPS50tJWP2i37K7Pc7pcNv8mfjP?=
 =?us-ascii?Q?Fa8yRlfFu+GZuPDNV4WPe8HMwDMNjNLxbECDmEgUwLM1zBspNoVKIDir7Xp5?=
 =?us-ascii?Q?22vmA5l587gstHaFE5zOGsg4Hy5EwZcU/uaRxAHZvehyQI618AnBLZBeqmYF?=
 =?us-ascii?Q?qLVuoiJrOqow3/g1+kICMEIN2s27sd8xS1ueSF0wWvhc3KTIYqsdFRHRXPKm?=
 =?us-ascii?Q?2ea5iBUI5py81cyL0PDcDKosSd1Ojg6hXzSliXN0dKIdEKhsFOL8JqqBG3c4?=
 =?us-ascii?Q?eaty+Kk6lCWl0HJ2vORRP+uTOKRauxfUGVdU9kcVmCTqzX/vtai8dbxdmmgx?=
 =?us-ascii?Q?F7UhqvzMoHu8exqqiE5g0N8RMcPzdfwQQQUmZjiDyGBKNFk3yA0ZvkNta+ko?=
 =?us-ascii?Q?ST9sY1BdDdJlQW1BMfiT33NxmiQmc6gv5vbbcPCkCZ7oLhSzUZAfpMNhTMtW?=
 =?us-ascii?Q?pf0J6x3YH9h3nHtgna3aos7vu+s+yr0/oATvGuCcyu8374NUQn65WznZtdtx?=
 =?us-ascii?Q?2n+VAKiRArVtJGDH8WxROC/q1TxROvdGMqrMRkw4tgFZY2tXD312vB83nVex?=
 =?us-ascii?Q?rQKgr0vUTv2Z6mM9GOl5PV8aENjXlO4bzG+4QFuGmWFe9aIVmUiPbXgDJSU3?=
 =?us-ascii?Q?W3//qgrxVDpKrYK8U3kLgbQwLO0ST4O3vjb200OyxEoBu2Htt+1/qzFHV7m4?=
 =?us-ascii?Q?8+03QC2JesphE/U71yKKr4B1jK1ZLKxEAVtUPit2yhg6J+/4nz7+TqODGRzX?=
 =?us-ascii?Q?Jby6QVCxS6bZVGq4hTd3w2Dj+lEFtlkVs4lYbHZpEaMDRBr7pLqOgv1BJIH1?=
X-MS-Exchange-AntiSpam-MessageData-1: Dg+IRcfP99iuIg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56ead64a-8b3b-4de1-57fb-08da12f7c03f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 09:20:52.3101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oeve5RrL1AsNQhc9o2y5XcMY7hNoer9E0k8YmiVK6pxFQ4Xh4hHc9w1BG9bgFmao9FLkEVPQNb7Y126A99dOOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4324
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27.03.22 10:37, Oleksij Rempel wrote:
> On Sat, Mar 26, 2022 at 02:04:30PM +0100, Lukas Wunner wrote:
>> On Sat, Mar 26, 2022 at 01:49:28PM +0100, Andrew Lunn wrote:
>>> On Sat, Mar 26, 2022 at 01:39:29PM +0100, Lukas Wunner wrote:
>>>
>>>> On probe, they first attach the PHY, then register the netdev.
>>>> On remove, they detach the PHY, then unregister the netdev.
>>>>
>>>> Is it legal to detach the PHY from a registered (potentially running)
>>>> netdev? It looks wrong to me.
>>> I think the network stack guarantee that the close() method is called
>>> before unregister completes. It is a common pattern to attach the PHY
>>> in open() and detach it in close(). The stack itself should not be
>>> using the PHY when it is down, the exception being IOCTL handlers
>>> which people often get wrong.
>> But the PHY is detached from a *running* netdev *before* that netdev
>> is unregistered (and closed).  Is that really legal?
> IMO, it reflects, more or less, the reality of devices with SFP modules.
> The PHY can be physically removed from running netdev. At same time,
> netdev should be registered and visible for the user, even if PHY is not
> physically attached.
>
>
Hi,

this makes sense, but the relevance to the question of how to do an
unplug of the whole device is indirect, isn't it? I am afraid, putting my
maintainer's hat on, I have to point on that we have a stable tree for
which we will need some solution.

Nor can usbnet exclusively cater to device that expose their PHY
over MDIO. (or at all really). Intuitively I must say that exactly reversin=
g
the order of probe() in disconnect() is kind of the default.
If there is a need to deviate from that, of course we will acomodate that,
but making this the exclusive order is another matter.

I really get that you want to discuss this matter exhaustively, but we
need to
come to some kind of conclusion.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

