Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4981C4B1028
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242320AbiBJOUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:20:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238798AbiBJOUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:20:44 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BACF5
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 06:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1644502843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FU3FeccL/jKBexQ5LIcXSqco/tRRzJi4qbSjbsgUYHQ=;
        b=S9NdXSOEJLGfMDtsT9DCw+3MhnN6xrTGsJifGJ4QzbCk65b6Rb19U1fu7c9B2GnmeNVTLx
        oT9YtuAxL58nA+xkHWGXVgogJOvjQUj1IIG8nNbcbs29dMkCHEbUeWZSw1GH2VB/WoxWXO
        HZQCR9pu+XHDA8lCmHMPP/z2leyFTL8=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2050.outbound.protection.outlook.com [104.47.6.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-39-H5XpV4osMbikkxiDM6x6dQ-1; Thu, 10 Feb 2022 15:20:42 +0100
X-MC-Unique: H5XpV4osMbikkxiDM6x6dQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZLLjmubt5oDt+XRQ7h5NUwH5NWOEC9ClXKYCxSPueDBBVubj3F6eAzoyLwLhzDNTuP1qXrqXOxHk5J/ewCTLMmCjjAhDy7elO/pxtMRzFfTLTqxKKAYAHZgtXBfF3pExR8/d2ROyb2uYCe7Rn6KsRPutRiIM2OMiIg9HRYlTh/qC1qvjghkpXI+x1vevQ397lu/sSSTBWvb+Db0UOQOOtOQZjYkyWudIs1ykWhQBgQ77niE65qb1uc2zoXLATNbfBuKQHdXNMNVXo2TAyrsD/Q95vQuQ8yHp+f3/5U7itDv1CcWkkaM4tReIQ7HdoOHKsuXXaQLJG478RtdigGp7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFQ+NPR2ss3iqgU1rnvxfdIuglc1wNgOf8ZdqZIQzgs=;
 b=mglbhwFpeTXcE183WKAaI3qTjWnzcxkZyfsrc3Lfc8qp4+OQHBaDA9ZqTbyRa+MWzPD8DkvLfeLHMiP/burA3m1Ca2eWsgNV74rkUlGYcYlwWGhCmo6sZOxrjkgDxSYU8azxY6rQvczo67Lt1XDYbj5uTTg/41lPfMNUqkOnfKiuSWrjq6B3SYs4LxBhrbuXJ3RP2B5NQZhq30Q29Qm7bjOSppPmHOw4Z3Bxt8uuMJRYUdhdLYZpzUCWvGWEpczgNE3E5ImRojeG3uaC1oxAVjKZXXDiz39G1toGBeDxMYZWVuDH+rZ9VCgWJhtgb/wYSQLCegTYrWeUks5cTIIAQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by PA4PR04MB7646.eurprd04.prod.outlook.com (2603:10a6:102:f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 14:20:40 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115%3]) with mapi id 15.20.4951.018; Thu, 10 Feb 2022
 14:20:40 +0000
Message-ID: <118c84c8-d3aa-c3cb-06f4-c088e49c416f@suse.com>
Date:   Thu, 10 Feb 2022 15:20:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] USB: zaurus: support another broken Zaurus
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>
CC:     bids.7405@bigpond.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
References: <20220210122643.12274-1-oneukum@suse.com>
 <YgUL6y4F34ZgC2K/@kroah.com> <6d5a8cb4-1823-cecb-a31e-2118a95c96a6@suse.com>
 <YgUei+MqkHAE2Oet@kroah.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <YgUei+MqkHAE2Oet@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::24) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b80cc6b1-32bb-4172-8945-08d9eca083c4
X-MS-TrafficTypeDiagnostic: PA4PR04MB7646:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <PA4PR04MB7646CBF24BC776D8046AA3F7C72F9@PA4PR04MB7646.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QixJslC6fmyqR8YEce5+vval+63NmuSdbQsa8E9bjskHu29htftxv2wBeU3B8b5oGY0/SVMmRhtdyPISqJsZgrSUV+A5Y8Red/OLmlaTGNbHcUaEw3DbP5hf8ELtqSktSSRn6oOPibhnR97pzjjjqakQYOHeQQ+3rYTfwgb2X8QdPV0eQGXe6hYRSlz4a+ovJrCIZYXS+sVWQcviaMQkEfON75+AdPWe5BalijJ7lBUS6MkezoiDyG3PQk7Bkdws4JObt0zNvDvNbBnkhjrfpyZLN//wud8ig+8pKT9+2bAT27r2FelrvkbnVjwjplKX8KxlQV+VKMnzzt5+GdH4axoyWsGUTwn0XnMhnQ0M04NLOX01pTboxSmh2PrJk22V45l7TdgZPb5cWEwARrf+M/TKFCTukAFwaxVp68RBtCPGA7KtIjCSTt2nsKNCNgwjOemK0LUF4cqF8fUJ/FjRDmHl1LYrTp5EP3XKvkxG6FIMZOQ2DFeics7uKuz60wm57xknbWc8L62SYqKM2gkYbM3tToyFe0V4sDc1k4pT6svkpJmqQ8dXYjbqFcjev267c7w4sHcC1CxEBtmp4sncHf1ZKAi3L9eVOKdBaD3WjYsCNTARRZxhHuwIjeNT+e2+Of4N3C5cTm0W4y7vjLVZqWI8CCdvVn3dHaRcjkhnwz33F3yLRj47PSCiPMQldQcmhURPQkeY2IzmEwNF90aUUCeJZ3TV+e410eMGEpgj6zg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(186003)(6506007)(6512007)(2616005)(2906002)(4744005)(8936002)(5660300002)(66476007)(66946007)(8676002)(508600001)(110136005)(66556008)(6486002)(31686004)(86362001)(38100700002)(4326008)(316002)(36756003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?afjoy7w4OwmGiY6/B+wl8e1ZUC/zdGKKQt4t1bBjrXE5fllCzPYy4ceO3z12?=
 =?us-ascii?Q?BunCHijXXbri84AVTs/qPxS20OR3zsD9LZ3243df4P3Ovp/UzmHPmIFTTPBA?=
 =?us-ascii?Q?Mw3uxvoIcNrS3lyKbN3/yt+CqgnInnGP677P4rTU7iLazIneJdIM3vq1IaRS?=
 =?us-ascii?Q?02umMGZLDPGrSIL7qj3cKEracryIpF9dyKmIXaw2sgpgAxaqhUvfJi1thgao?=
 =?us-ascii?Q?XX6KY/gIMzcZ3w/QKLbdKmtlrHEFmUFdJw0a1UT77c1oBQBjw6aKGjuveazC?=
 =?us-ascii?Q?E45nzZ9JhlUMZ0aJh9wbSgq2UkVHUwiE5orT9vkjxP9WEn7+cpx1HpJO+Oh9?=
 =?us-ascii?Q?aXuTpb7l5PUXMnpyW2SgymSUFyg7S3kMGbaZEPzsM1Kjl8jpQxwyrMAyojMb?=
 =?us-ascii?Q?tBsc2G5OHv9n5mJo6pa7eSlscPoWDnzW5lxwD4awkB5S9p5GPjc1lOXbK7xK?=
 =?us-ascii?Q?m8Yu9JXUFrr5kjsDB6hEkvPTj10Jeeyi4aBzWIFdkCD6aQDCddkvv24YQv0/?=
 =?us-ascii?Q?56oM4wAYCsfEFD/vmhXbvIzkenh+BgI9vLk7CZf9RYbQNxLTaEpZYjNtObZf?=
 =?us-ascii?Q?HfNHUP2XX3svanU1K5eWfgdOPpplPB3aGzCV0MasQBZHiswkoQ3el6fCpggN?=
 =?us-ascii?Q?ZozsxVvl9kRqYc1xXvIA8SesV/GYFkzJqTMB8f4MJ80vjBWvjTZiVNqQY632?=
 =?us-ascii?Q?gUwW5cw7AB/8oryUDxrQh27YXSYAa33j54vDmgfDqM1pGyquukevz7rTTdl5?=
 =?us-ascii?Q?TJwcNLEFz8+CoAltCQe0h018nAS7Q0Znj6B4pDC1HBnhoOL6OkcT9amtQpsH?=
 =?us-ascii?Q?bTE/5eGlNc0n2w1EWnyzsYcwW60ZIJIF4PdwdFD/2mJa+16/MosFEPFqfwH9?=
 =?us-ascii?Q?NlVpuco/Iff+nuz0EN3tLpVE1Yx8Ym2Ced9W9DJm1CwGfEWhVZLfvMYRVHeT?=
 =?us-ascii?Q?UZyGlT96jxY/MuJprFrMtLniakvGoe7cWbjXAhrabZ2SgceOyWezTeGa7CYo?=
 =?us-ascii?Q?m7JblFplVYh1sQ9NmVWEQV5ZbOr9u/nFb0aDSsa3yddt6gWuuxFRKsjbgsiA?=
 =?us-ascii?Q?m8Ak0YqwUXinPjjg6iNYd6kKJYz5nOoRgAJPDw5WKMEE0KwMOclrXY+fNQI1?=
 =?us-ascii?Q?nfroOgr964ye6pcV/6m0/L3NzXbqk7iGPOo07HXN2FO73mqQbREHadtylxPH?=
 =?us-ascii?Q?9iirjXhQcugy8+KfXWWySDlyRbK5KcXqm8oqUftXw0YdkkQaukeypoXvBsgZ?=
 =?us-ascii?Q?XNGvrjsPLmtvckj5JsZKwi8TJjPDinYtQuu2KWOSSJai305ZNcf/sYw2Rw7m?=
 =?us-ascii?Q?uwOGYrYce6ayoQ+wttZNfMNXe3g1TYaMww00/UuKPkIwCiedqGq4sVZ7TnG3?=
 =?us-ascii?Q?3OoGM8l8HHC95z8ysbTB+EC20tMaD3Wwu8MinkIvnquhFqXEHe5156rniuCQ?=
 =?us-ascii?Q?9ROQlw/lHr87ph3+rKFxs+t00q0oVtulP7pXH8yBxp4CT02101D9FbMnB4Qm?=
 =?us-ascii?Q?k/R1RyobAsT5grKzQOAZ8teWImI/QupglmGjxZdT8jswDmDAH9gMebF20cs+?=
 =?us-ascii?Q?4U6v2BqovgiWHjADgzM2HnOUuP7UOHYjObE0qvXo99PAxAL08enGj43XvKPi?=
 =?us-ascii?Q?vY50Re/C9tiKruIkrqgWLOkpCO6BxHcgZa4ZMhsXn56FvhG9yzIAikDWTEm8?=
 =?us-ascii?Q?c4zQe8jHRh8oLCNxTGOh8uaPNd4=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b80cc6b1-32bb-4172-8945-08d9eca083c4
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 14:20:40.1284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQ4W11VUPXC2hALJwtbU8GrFv9t3JR7Mb204rl4faaqe4sX167GTxn1+J/Mi5NVLJRkcitmWf0+ldj6vtA5TkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7646
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10.02.22 15:17, Greg KH wrote:
> On Thu, Feb 10, 2022 at 03:13:49PM +0100, Oliver Neukum wrote:
>>
>>> And isn't there a needed "Reported-by:" for this one as it came from a
>>> bug report?
>> Do we do these for reports by the kernel.org bugzilla?
> We should, why not?

Hi,


because it sort of implies that it was reported to a mailing list.
If there is a bugzilla for it, shouldn't we reference it?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

