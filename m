Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF9E30B8CC
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhBBHk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:40:59 -0500
Received: from mail-db8eur05on2111.outbound.protection.outlook.com ([40.107.20.111]:28608
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229976AbhBBHk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 02:40:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcQ4U8NXwkO9uB7HgKlIw6zQ2wctUB0mKIUMZnGai5zF80gnHy2YrQ20bQB7WwF4x061FOavVspRrmH12ywUfsgA265Q0ftYaRI0PGma8UJ7QPJ99cm6SfuYhvcTaSsVckgbWhgwTg9osMm2tR8/HrUgeXu2LbaLpEVPja4ZnVCkdQRFOr6o+NIi9cfIfSD3w6Ml3yao/NJ4tzKOfVeDzFUrhxk0/48/WoGaBfDFXHnrqrXh5JON7f7hxAZ43wQzlMuMQS4oy5cgh1FkicpU0W+DWR4oL9djm685YHCKY+AR6cEPIQ/c+pODA/TJIjl417pnV33gP8rukSG/CRFt9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxzfDAmNd1X5DohUgnI04lTuJPE++e2zEAcq1ZOVBKw=;
 b=FZ1vmUp++2a93dH1jVQolu0eRgNOFJkQCwbkTsnaPTbGUWIfcmjLZ3hHSCA6arpcd9zWIP2TuCPhvPjTWY1770O60mIum2VMpEBCKpCepTsN1JGyTcOCGeopIaUgkLt4ImePtQWkegQU+cks6X/AcD7uppUitdVcHgofwggWHL/mhTNdlbGORscK7nI7VdQdI+2vviEAxljmV+x1qTCUIjd+6wHyX0LhK0/COemXQdR4WpWWGB8df26TJmahv2z74yrYvLc6IgGBzxUwATPPssdMu5X3+rBZBiUhyzzvGAd5gs2tcAS6w78wV2jd+VofiQLaWr4RXiMiuBdAEemHag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxzfDAmNd1X5DohUgnI04lTuJPE++e2zEAcq1ZOVBKw=;
 b=c+DLeSCmMU5nRe5/hBfWC+wv4nQRRMCBT0HkRM2MMwv6ngMa/GjNjSye2ENUEP+7Pm7FTT3BEEGBSiYNLXnJaaMdRlbaidUGo9FfNpWwGW1igVXVfJNay+LrzWgEIGChsDxSqKt10guLYMpni+Ryc7ZD1M5282uN8aQjrdt9yPw=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2241.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:dd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.22; Tue, 2 Feb
 2021 07:40:08 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 07:40:08 +0000
Subject: Re: [PATCH net-next v2 0/4] bridge: mrp: Extend br_mrp_switchdev_*
To:     Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>, jiri@resnulli.us,
        ivecera@redhat.com, davem@davemloft.net, roopa@nvidia.com,
        nikolay@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20210127205241.2864728-1-horatiu.vultur@microchip.com>
 <20210129190114.3f5b6b44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <9143d15f-c41d-f0ab-7be0-32d797820384@prevas.dk>
Date:   Tue, 2 Feb 2021 08:40:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210129190114.3f5b6b44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6P194CA0098.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::39) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6P194CA0098.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:8f::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 2 Feb 2021 07:40:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23df1b40-0b46-47e8-e6be-08d8c74dc163
X-MS-TrafficTypeDiagnostic: AM0PR10MB2241:
X-Microsoft-Antispam-PRVS: <AM0PR10MB22412718D1DBEF78DCA149DC93B59@AM0PR10MB2241.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n1xL1Nzzelkgb4FD/BIUWGjxlqd2rAjTISumqMt7lO2nn6a40Nekhd8qFGAL+swQ1BOu4q8q/zMC3ADjy9V/uxqpZLtzfGUNvZXuzunZ3Csm40bGiHHWGprK4FwY0CkSH0P9RivcMu8D5kFisop7QaXPg6OUGg6BDtNaiq1Z14tkdQBEviDfxjRZWfkgK1rKd1bzUDXLcUlczNPWgMLgjuhVub7KwiH0qsuKIuJPzP4bMU42Dg++xM7yptnz6Os9iS0WluRbYNvURcUILhf1J6KqdLbF0T1V/xj1qU1/TX42sYcgWzQ0ua/5qIEbSNLOHvd1Qxh18eJKbrlqcNzCArIbSHDMpIwuOZCzvU5raiNsnujr2c9woKt+MASSOHDdHYjz0DAmRjzbqEAsOy0czkgqAUmgZhV6aQy3Y8k5sqp2r311Svr2gB8nUBwKwHWBJpKuTfW4GTZDslVJirSU5kLk71BnfqpL6UKMbaoexKDzmrihghuYbYOYaROVJkw7NXGPMvCQgY8DpxwA61RByagvu/VkXkYikoTR3AvWcydoypNSOMLuKI5rPdCL3ZY/ygoOw/rgpwSg+c9paL21fokCqHtHB8FGzIi0DpYtjKw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(346002)(39840400004)(36756003)(31696002)(44832011)(26005)(66946007)(956004)(6486002)(66476007)(66556008)(186003)(16576012)(4326008)(52116002)(478600001)(2616005)(8976002)(8936002)(110136005)(31686004)(5660300002)(4744005)(316002)(86362001)(7416002)(83380400001)(8676002)(16526019)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?2dQWzn1QACPc9U6hSNBOf8E6Mq3kGXS8hlz4+Ogq3OukjF9rclU43ack?=
 =?Windows-1252?Q?2KLRLEDoP1gzDfebgmmELIX/YMrWjqFZ1Pz1Nodo9GYN6kmCQXiod6F2?=
 =?Windows-1252?Q?YjaGoEKjYKsG8Qh5tJgHYNzLjjAHPdvGNYORexeJ+m7RyzQBIJmC6Qoa?=
 =?Windows-1252?Q?l2xAc78STJIGb1Xxyo4oc0dh5zKqGGj7Nu5WMIMclBkCzcZ2PSvAjs98?=
 =?Windows-1252?Q?8KlcErNpDlnLXsyV2twzPGJcl4cFgbdI1KzP03UEB/vA7sxJUjI0RX2/?=
 =?Windows-1252?Q?XUNBzyziOhCbi1MdzvFrGcTWQw/qYasd+Z8cAKb7PWbglX59zW1MMfCX?=
 =?Windows-1252?Q?RlAY+rRasHJrKmJWM+dIRqXJxBLlmWR3fYrfIrEwbFi3RPUElp8GlWCg?=
 =?Windows-1252?Q?bqOsYJaXpvG6uEkdgEdWwLxftusPdmOY4H4YLiBZax9BgsVhC14d2tmX?=
 =?Windows-1252?Q?+pQOFfjrJmnvtI9v5xDT0K1VAhSLM1Epk3ta6+kPPfYOy5FRBOFu8ASK?=
 =?Windows-1252?Q?Q5FiD2PuGJlox5F4dLPgsHF5rJc2KOO5EdSpcpUca9woHmL+2HWnPN/L?=
 =?Windows-1252?Q?wqU9RiJwR22FvJ05Oa6SrpJQS9yOARkYsb9h/DXpy7dclNWBiUuGSftx?=
 =?Windows-1252?Q?KuSZ1LuWhPSG+NnxgWSAza8aep84JGcO8N0DeytGOzLisnBh5hs4BJyv?=
 =?Windows-1252?Q?JfY/z7FXbOwsWT2mZg9VTLZNqtvIJvRQ/lXnbK7JlapuTBWXqk4Lmjew?=
 =?Windows-1252?Q?MHiVL5FfK8WHFUBT390YiPRUJl4s30+tyV/8XYelFT7l0p7lYDW2VWQn?=
 =?Windows-1252?Q?v3WdaH3043n6ig3plfzukXsqsmiIm+pnyJozFp1ZbWCvL9Hva51Hsw2X?=
 =?Windows-1252?Q?qgv6swfgibbdibeJN/i4hGLm0IFdy4ga+UF3sm+z9/2njoY1Ysox4tZL?=
 =?Windows-1252?Q?rlsfdH9G7hV9mXrfCDvIHa+aj20PMLBwvBz/Xys/3wxBGRnMj2aGGMQu?=
 =?Windows-1252?Q?5EHz5y1LJI+n6TX36cUvC9jls6mu5V75zfCmE62T7pT79Hn7mlQFEwOW?=
 =?Windows-1252?Q?IvjHZNoj2X0jUIZEoXBSFFqAZYSfnD3IBIxdZlJTYRl+4wkfvaut4nfx?=
 =?Windows-1252?Q?Eyvbf8OBjxpD/9th9Zc4xTP/?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 23df1b40-0b46-47e8-e6be-08d8c74dc163
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 07:40:08.2132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m51jHrw0LUL6ZCgNoDRju398P1xsBrQb2bqUyF9ebl66T0bUIp8ZeSMSg10rspKBXtDdy1E6uVe6P7LVM0gDUKYtdLJwwORg0W1zjt/H0zs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2241
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/01/2021 04.01, Jakub Kicinski wrote:
> On Wed, 27 Jan 2021 21:52:37 +0100 Horatiu Vultur wrote:
>> This patch series extends MRP switchdev to allow the SW to have a better
>> understanding if the HW can implement the MRP functionality or it needs
>> to help the HW to run it. There are 3 cases:

>> v2:
>>  - fix typos in comments and in commit messages
>>  - remove some of the comments
>>  - move repeated code in helper function
>>  - fix issue when deleting a node when sw_backup was true
> 
> Folks who were involved in previous MRP conversations - does this look
> good to you? Anyone planning to test?
> 

I am planning to test these, but it's unlikely I'll get around to it
this week unfortunately.

Rasmus
