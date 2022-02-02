Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CBA4A6D99
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 10:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245385AbiBBJOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 04:14:36 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:44239 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245376AbiBBJOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 04:14:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1643793269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UBmHr7XJ2cSQWq1RgLritFwFLWPO+yJ4B2kV0XhQgc8=;
        b=CV21d9pgShHOGo4dvHghV7VPE/dpqKyEg2kAbqfcY9r5WDjmAWTiQSGlgyMop2WAS2jcI+
        IFtYzxJUr/TsTjao4rtm4XsIHuzDcGCswbqEpXEKcgf0xzsRZmpIJrrk5/mnNBx81NdR8A
        cReeaYSnPf/UrbTo+65wiauYJFpbVP8=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2112.outbound.protection.outlook.com [104.47.18.112]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-27-22GnjADvOfq7LDE6sSTx9A-2; Wed, 02 Feb 2022 10:14:28 +0100
X-MC-Unique: 22GnjADvOfq7LDE6sSTx9A-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FiPdST3AjZbb5rCPBhnwsAQKpAr0S8hhhYHwDENeNoWRIRJWOiAyIFWaXrppW9+lTEfdk8gmeXVniQ6ZUil5oU5zO3gZ3B39u91wjOm/3vEwB3hFeScWc5pkbeOlJcAUKc6kUgAjQL+6srN1k1S7EModYhzCqmf1pK7lDNZVmX1IS8GAw6JpHOB8igsMNxZZOiMuhEREsXxpm1WixpH8f8ScRQMgJTnRUSTHVarXXTREysY//ohALByZogujonLafDNM57J3nTW4FWxggx+xv1q/jeJIsBBpDZ/6/ME/9UMgXBBv1BQAHzqJWcSY9GQLqH52/cj4P9x3T9bTpTOHrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrllmYw8FVFJvxxl//zlJylkyhfC65JPMFsvsktnt/U=;
 b=e4Tj4qig96yJgbcZ3edKu3AK4rzRsJ/0Yg5NC4WSofaSVXTbiehh72tCMXRlTcDZAlaVOocx+GxG9gtBMS/hF5QdlKT43JFq1oufAtOqppyR13HDxXcakKz2zCCS4AyzfvHwOnWhNfIEl6J/P7yBJhWzQJ9WGxv3dF9Isf8J1T9iGoW9vYUkRr4dHgQOIvhDF/FjoR2B9ra3RP83g9SGis/utnXufgk8zAjR7TNDiWSPIQayirsOfn5uLONvifbdgaUbw0zBok2EcXLrju8D5XafPcTPnbmrPNHxT6jtHS0kdo2M8ldBkgYrlM/kgD7rjNTm1MxQ9cQLzP01AZJKvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by PR3PR04MB7227.eurprd04.prod.outlook.com (2603:10a6:102:82::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 2 Feb
 2022 09:14:26 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115%3]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 09:14:26 +0000
Message-ID: <59e18374-0941-1298-4119-366452375404@suse.com>
Date:   Wed, 2 Feb 2022 10:14:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v1 1/1] usbnet: add devlink support
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Oliver Neukum <oneukum@suse.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20220127110742.922752-1-o.rempel@pengutronix.de>
 <YfJ+ceEzvzMM1JsW@kroah.com> <20220127123152.GF9150@pengutronix.de>
 <YfKcqcq4Ii1qu2+8@kroah.com> <YfPPpkGjL2vcv4oH@pengutronix.de>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <YfPPpkGjL2vcv4oH@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AS8PR07CA0019.eurprd07.prod.outlook.com
 (2603:10a6:20b:451::22) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d59b0fb-f3f2-4a50-699f-08d9e62c6901
X-MS-TrafficTypeDiagnostic: PR3PR04MB7227:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <PR3PR04MB72272B40D9ADE0FFEB942371C7279@PR3PR04MB7227.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 25wUT3buttfXQTYco/4qWqaQGCmXVNxUGCJvyIfszyPRPDbeSLUYAyrpZrzqPfFuFabbIjQ0cpE2dKKGDH7KACafzTltI9BmhU31HrDe5AZKhfX0PsYzDaSlkv+1ve78ZuqGKmHksVJFyqxgYIkh3tDSkkExLnDmM+saRJKdAS+zqR6bwr2hPTmugYMV73FuDZzFtRWcOTYVnLHvF2Hq+s2LZbxa4hewMFuJqYSJpYlk9RLjeXY8qCnVC9/hm1vLxKBKvypJ5c8OdoBnz+l+7j/EFBInPIM498KOZ0W5qAXpSwstgE7CT4sdC6PT30B1FTrA501GFmZFAAkERPNVwaBaxqnVamRZ8fi5nIvEhxAi/irt6DYg1sqkfJN2J4dq0AsZvx4dqTwwfkyy1LtIMAfs9YvMiJ+kQL5evFNjr/EgLlf810hxPeBXFKd2wOFhXamhRRKn7ZkHz/eHg+9MVWFw0a8k+yOLrZ5+IRaGnEEzZUv84kYngGbAwCYRRus8Ey8DbmTzPPR8I/16kMANcpMQ8/E3qvuBQT9ps5ov+Hxgkpy7idlMJpSmaEVmdjgAJg1dRdKeC4KsxQorjeyMbvY68EcxbGEzHu5/+cy/Z+WpYdjobOAWw9E7pYYyQzcxizuJy+svU3ZsLTl3H2g6ev31pdSyLSOzgLFKwPeU9LYJ0DsCP1uVOrYwi/D9OTeVrATgEKI5zrAZ3gZFUIkqJy3N8yj/Ym2ikbxl1g8UuN8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(38100700002)(54906003)(110136005)(66946007)(8676002)(8936002)(66556008)(4326008)(66476007)(36756003)(5660300002)(86362001)(2906002)(6506007)(31686004)(31696002)(6512007)(83380400001)(53546011)(186003)(508600001)(6486002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p80v6NX8vrDjFwNapdvUM1AuXW2XTBhrW9ahx3bN7uFJ7I8rU56nKnk2TjAE?=
 =?us-ascii?Q?+SAl6GV7+uoN90zw7Xm12WnXc6T6R8PdRTYiRGV+V7riCOqIrlmnPFlSkY+4?=
 =?us-ascii?Q?wXiichN1K7CBkT7PMk1VGR7PV6UimnrEsDrlYgKA6iNdKmASLqGQrP968iTW?=
 =?us-ascii?Q?wGglAXtydxprZTW/JhH87CchkIayXmZkWiUYd6a3lFsTbbhaWX+PkQhz8DGG?=
 =?us-ascii?Q?vrK9QYtFR5Ld08QfYNy5AxzQjhIXUDy7oi2aeIW/fms94cSkc6jVY8DrX6Mp?=
 =?us-ascii?Q?jp34k2fk5nHTUBOS/YndXvangz9DQx/GMnPiEBFmtifnOFzlzM46RsaGgqsK?=
 =?us-ascii?Q?pw17/XbKucoQhif0dnWXEuVU/E9I0OZl1hMTbJkvCK5J28x0W3cKX/3RrIy4?=
 =?us-ascii?Q?qNxyJhpmOgbSpbdKmscElZ5PbjU+O1sVSPvIgRdHzt2usYx/aqoocNTevXwG?=
 =?us-ascii?Q?wwQd2aoPS7PTXPx7+kpLhga0HJ1IhzLO69ofO+QSVZWasr4CTM5UJeNTBVcr?=
 =?us-ascii?Q?CBXQLkDgS1WUsQE/FSGM30M2lgh2tCLtWhUBYexrO4YGYIGPnpWVmGZakBHu?=
 =?us-ascii?Q?mJwPPQIPAwmDxn+er7NBpx1JOSjbnPPrVYDVgKkJ4RbkqPabce7cBrBt/cuY?=
 =?us-ascii?Q?Dda554xGVjqPtOKNW1Zw6o4TeRvGv8YcbNzI1AYTnArWCnzTSkZZd6CQje1w?=
 =?us-ascii?Q?zm/N5h+CSdKNGZ/LawEedZSJCCkKRQsTRNyvxNp6hE6KcJHJV0qMfw/3/D0B?=
 =?us-ascii?Q?ltP0op4MOeVJsFfN32EbFGQIFAlt3GmLeXDuAe1aitICFCKk7sLIh9LncODe?=
 =?us-ascii?Q?4TMKVMtScmVe//WEsdkbq04ESy4pZ8+VCEM/08SMZxdnSx3wGJClzGjEAbY2?=
 =?us-ascii?Q?vsf1axBXlI/wA6yu2RfLU5ka5P6J3vh6deg7cg5Tbu02F14ykYjRdjtYzO8r?=
 =?us-ascii?Q?dPXChwIm9l99g+HJgLawxvWhIu9nnPu5MkkZZ6nL4lVbQUCqQV+OGyE0wxQd?=
 =?us-ascii?Q?7MbaSNXgkkfNeXH1V5a9jKZ4CLIFlkJKBBP4WUuaxC9cxXWVKOlFNRrlunF4?=
 =?us-ascii?Q?Tg2a1GHaETJLTtB4xyyKnF2WiVykTYcHHwAk09wokCqMMGvJCKjJAU7ZarVP?=
 =?us-ascii?Q?O3EKlQwddkhVMpJJapHKoDjwFYae+JcqDDxtIRwALBYFtmmtsWU05CDnXRck?=
 =?us-ascii?Q?VOT3gZVd5vOwhRNhGK+fuvaAVqzPYpZ/PFRB5jVRtDAR+O5SIYuV7CAh0Rfa?=
 =?us-ascii?Q?vxTDrqbBss8QnCZ2lCMOXoA9r18bKnsERjuxqMWn80MqHc0QbDpGo6kCLPrv?=
 =?us-ascii?Q?OO12t7JAY/72bF0QmaTdUl7Hq8IiP6Yh/yLhTuc7miWt2RwBpKZHOanJuegB?=
 =?us-ascii?Q?TeDC74d5m5OOpWJZDjbVnsNrMtdpOtLWh4OBNAuQ6nmpkgKDLBYvviIKjDXB?=
 =?us-ascii?Q?LpXW0O/+yuvy1fV8dnqUf8OHUV8o63zi3Iuzd4frj5mNiUn5QHIRzJnJicPi?=
 =?us-ascii?Q?Sh7tAggqgEFvS5bI+qN9Z8vUu09xmu6Yzp63e6BbvI8z3QuHQMv84joMwLe9?=
 =?us-ascii?Q?+iGWwPtWftvXXjIpUKUblkj7VQSkvZ2UdQWRiq73b6UHQvJ2zhRpQBZQ+y9G?=
 =?us-ascii?Q?MzD5sdguURNnP1Euw+nn0r5IexRiT3mLn2sILvVGRGz0UobV/LGoXEescQ33?=
 =?us-ascii?Q?e06ZDMU8b8kkfx6Z3TU8gYWXQIs=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d59b0fb-f3f2-4a50-699f-08d9e62c6901
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 09:14:26.5535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mocsg7xctJB0xnP3WUKVccdHLZCyndul8aNwLcWcgSUTZqezRhl0gUUvqONnx/MfY5laV0L+ypDhVIkcftIyog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7227
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 28.01.22 12:12, Oleksij Rempel wrote:
> The user space should get an event in case there is a problem with the
> USB transfers, i.e. the URB status is !=3D 0.
That would need filtering for unlinks, but that is a detail
> The use space then can decide if the USB device needs to be reset, power
> cycled and so on.

This is highly problematic. Not necessarily impossible but problematic.

Executing URBs is part of the

* device removal and addition IO paths
* block IO path
* SCSI error handling
* PM transition IO paths

While we can send messages to user space, we cannot allocate a lot
of memory and we cannot wait for responses.

> What about calling a to-be-written devlink function that reports the USB
> status if the URB status is not 0:
>
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index d0f45600b669..a90134854f32 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -1648,6 +1648,8 @@ static void __usb_hcd_giveback_urb(struct urb *urb)
>  	usb_unanchor_urb(urb);
>  	if (likely(status =3D=3D 0))
>  		usb_led_activity(USB_LED_EVENT_HOST);
> +	else
> +		devlink_report_usb_status(urb, status);
> =20
> =20
It seems to me that you are approaching this issue on too low
a level. Drivers generally do at least rudimentary error handling
or rather detection.

This would be easy to use if you gave them a nice API. Something
like:

devlink_report_urb_error(usb_interface * intf, int reason, bool handling);

Maybe also report resets and hub events from the hub driver and
I think you'd get what you need. You need to be aware of a need for
some kind of limiting logic for disconnects.

The change over from logging something not very helpful to
properly reporting is easy.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

