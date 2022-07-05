Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44FC566F46
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 15:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiGENd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 09:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbiGENdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 09:33:33 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150080.outbound.protection.outlook.com [40.107.15.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0462A286FB;
        Tue,  5 Jul 2022 05:54:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2J/l6d1R734G5fQNt7Vh2bVgEXY188EoM8vJOu6O6kq83jt1tExWUKxv1HGHDl3i0yAIWyZ9CJ1K6I7ULQC4c1qGoA0GrKBi/6/ZND31Grt2LGxFGrH1o3kL0y+kkQlv4PoKFLEbakhDIPAz1RfaCc4/H0a1JMWbYqqiNXEUffOObHUNyklXy12y7q/5iaO2+4kpMO2QOSIaWvrG7avudLZ5VozklViqMULV8gAK2rQPswuwJpYZyjkNTYMg9b9TltuNJKBv7Hk2VUaPZSYNoL7zucNvvsDlGpknsN6cbXkoRkqCZamyc1pYXRbt8kYBimabkfTRdX7dALyYc/qqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJDBnd6JulzaBQ2XIFI6iPDps9BJBxmqGcgNiG/GXVo=;
 b=CsG+3lAeteG9juPR2G2sOs5MESZIWMkSuQ1vy3pS/Gk9T5gxQYrX+QN38pqjnrTDDOlm9JmgPBTlLxRh1mcXJaN/A7rWWQ2gXmQho4JvDV87ZcOGv26/vZEWqre2G2apb/t2PcE5lKWoZVYz7/lXvX/TcZ4r8f+xlHq35sXj4MH/B6gqTFa/eDnV6AWpO1kbpIAv6VpSSdx+iZLRjw5TBNr3D7QbNK7SEqhWK1jlBRSITueh+irlQCWVZIsKj3l2g2aJr8iveKC7XtM/Y7zSKEy0RLc552BO2jskIP3dIlGEtYUdv2DqVce4i+spwCCgzM0LsGL9ntIaVnJaWq5wew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJDBnd6JulzaBQ2XIFI6iPDps9BJBxmqGcgNiG/GXVo=;
 b=scGqoeZj8s1WS4+AqSb5oqhP4jV/Jx71j4ZFVxTqD3dlLdeZqfSuRCGx+oFiusyDdh4nGXJjvAs0gacIa6LEo7+CKBIbOiMBMjn14we43zKwP+yQEG8WGy99vaEPhtfEYVyYztDAhzWrZDQ43ZuGIbHAmf4+jV/nVD7m+8A+yXFg8Wa2P6IQvK2ULeaMok9Vec/Dg4PsrTdVvDmwwUD4Wwj5V+PMnoW/MeX3uvsofMZQFIIkVcazRf57nZCaDsJtHHybPhUwY4OFQOvH8fHyyCm8BKYyR/rhHa6zK2EjShTeRwfxXzcuPOQUYTbrmeWN2IHauuMTWZSfmTOOYP7hvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by DB7PR04MB4572.eurprd04.prod.outlook.com
 (2603:10a6:5:31::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Tue, 5 Jul
 2022 12:54:54 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d%12]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 12:54:53 +0000
Message-ID: <169171e3-fb74-e7d4-f290-9f7c4cfc16f6@suse.com>
Date:   Tue, 5 Jul 2022 14:54:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCHv2] usbnet: fix memory leak in error case
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <20220628083128.28472-1-oneukum@suse.com>
 <20220629203633.56382dca@kernel.org>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220629203633.56382dca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0601CA0040.eurprd06.prod.outlook.com
 (2603:10a6:203:68::26) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f68846f-e351-4de5-bbe8-08da5e858e2c
X-MS-TrafficTypeDiagnostic: DB7PR04MB4572:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XFfF5bK/z+sKQMtnMA0gMfPiFrFdGEuHFhTibeRcG/r9neVA6b9Asrb3uMYIc39WIvDDleCSEN3jjNVozWazreoWR9g5oIPHeAw+30+imztu9YxVS1leQajWz3hpO1OxW7VrLzCUuKySN0O5h0D5tPO35tDRPE7WCN7SJ2lmkMlxgwZQjk9szbV2wJ9lom0vmObcxWDmme6l7BLd+ILLOAopcN9jCCEprOIH69hsaxkRVX4WJElIXcwx1u6GyexUs08iMijssA83L2ahYY2yNJIIiS5bUJ37l7brPxnXjkucqsVIxoHz1IAWJuQq18MmiWyFbyEMYgmX12sDB3vPQOjAqMxMharLPa5okBvFiaCCZDqEOr6BrCZ3ZshzaZFkpilZA3ZDa3oY/Mh5uD4sONl918jb9jlmY+9jam/pkLNWlkl5LWVwMC6WHkI7ZbK3aZthlQlM0dHiUlhyntd/L/Nr2tL+f5S6wnNUf4ITPGIoty36afhRUuXAADrl+8ZFbI56Y614yoBrOXW/J9gCF63rpFEvX+lVwBT9H4wO/Mx/4lnYn4N2MsuuZ/bK5BBo1K6UOYsYSG0xBksoDbC2mSrwGYZ35+Ug9ZSOrpFcNlwIA4Vl89vCPzMFgn4gfLX+9vXGiE3IF9uRvvJuP9y9/DdoZwccjyAKGj26ZjFpHP3Oz8c74VEnt0M/eAOXvTl4v0cU8ZVkfDSth27R4EEPILzav6Bu5yuAFmwq29QdyxmPeMtwyS+FFRPtJWOnX0qTMsZZ+aq4Q9/+by8txO3VDnwztDdmE00pExsyKDMKjO7adihYONYzr6XhHxK6AJ7C8rC/FlBb/hfoZwSoEENq0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39860400002)(396003)(366004)(346002)(558084003)(2906002)(6486002)(110136005)(31696002)(86362001)(38100700002)(66946007)(66476007)(8936002)(66556008)(41300700001)(316002)(5660300002)(478600001)(186003)(31686004)(6512007)(53546011)(2616005)(8676002)(6506007)(36756003)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnNrT2dRZWl0bDUwaGJWQnV2dlBuNFUvUTJyOVIrRHRZV09MN0E5MzlrbW1S?=
 =?utf-8?B?VTlTV0xpTnNZbmkxSVo4OEM3eXJiWldnM0VUQVJJVHk1OWxtY2RwQm1JcHEx?=
 =?utf-8?B?OHRvSm9zS2hSQlNsK2E5TkdNVGFDZ2kwTnVkTStLMzM1Y3FFTkxOOUtyM3BH?=
 =?utf-8?B?MlcwZmkybmd1SG0zZ3U4V1hPdEY5cDNibWFMYWpTRWIvbi9UTVlPcG00RjVz?=
 =?utf-8?B?OHdoc3hWSmJYYndqLzZhSXZxUlhwVFdGaDVzb0dPOER3dGswelBmb1p2U084?=
 =?utf-8?B?ZFMwMkhVVnVOQitRTm1JNTJQMmxCeGZTUUd6d2R0YVY0Q3ptb2haRVdGQmg1?=
 =?utf-8?B?bmVTakl2MGx2RDJNaXlCdnU4Wi9kVVFvbVJISGJXaTJZNGhOMkF2YURBK3VS?=
 =?utf-8?B?UGFJQUpvN29JZmtIengveC9seVUxa3lBRm1PTnpoSGljVnRkdDZ1a2x5alRD?=
 =?utf-8?B?Q3NtcDVuRG9mSEpvMi9DS1kwQkY2YXBQanZDUnlhMnZZRFAwUGNuTDZnTDNa?=
 =?utf-8?B?SkJOTDdmb3hHV25EdWl1dEJOS3RRYlRHWE5USERKSS9pUmpTUVlXQXJHalZK?=
 =?utf-8?B?YnJBRWtTS2M0RGhqRDBjbGdOZXN5QThqMmhJYVlpUVlDcU9nTUlsbWs1WE82?=
 =?utf-8?B?bG56c0ozUkx5Z01IOG5yTFdLTktCVHFKZmw5d2UwbXpYUU1SaFB1dDVFLzRq?=
 =?utf-8?B?UnJDMWY3dW04NzRveGVUZUU0WWFKaDExdzdrU2NXMWdVTVBMU1VCeEh0NCtz?=
 =?utf-8?B?Y1U0WVduS0NpM09adXg5N0tUd0NBM1NMWlRCREVFQU5mYk9mdUdwWXM4MzFq?=
 =?utf-8?B?OWQ3Z05sZGl0TUQ1czF4VFpoeEhzWEovRWcrbTEvYVVVRUZQcTl6K0Rwb3lB?=
 =?utf-8?B?RDl6dFRRWFZDSWgwRjdGakNnK041cjJPNis0cU5aZkRzWjByWk4vTUp0ekV4?=
 =?utf-8?B?MVBpbS91cGY4d2FvYm1SQ2FyQjJLVFdoMjFmOFRIam40bk9STnRtYzRvazM2?=
 =?utf-8?B?ZGtWM0l6YTU0bUUwY2tkYTd3ZEM1ZWJQd3g0bjNaYWF3bS9QUWFMeWVrUUZK?=
 =?utf-8?B?cUdrRDhqNXIwVnl0OFpqSmM1SDkvcjR1Q21rZk5ON0NNc3RUVXI0QXZMVkl1?=
 =?utf-8?B?cC9FN1F6MnpWVmxRRWJzbkg4K2RFM3AzUVNCdDlOUnpzVnFaQzJFQjRWUW1a?=
 =?utf-8?B?eFhOZWhyZ0NDMEQzT2RXNXU2ZHAySStNOWF5bmQzWHd4bWZ6M1VWdTRnWC8w?=
 =?utf-8?B?dTZ6TFZ6L0JpeUJ0bkpwbmpLdy9tV0oyQ1B3aFo4K2dSanB1amtYTHVzQVNO?=
 =?utf-8?B?SnJjSWU4V0h5Nm4zZWk3MVZkM0xLbnpqMGhIZnBUWldKcU1sZklyM3JRMElo?=
 =?utf-8?B?Umw0c0greVRxRnFvYlVZcDgwWDRNcVhwMkVIWmdHaFAxWUZEOE9INmtnSTBY?=
 =?utf-8?B?L3NFeDNzT1N2YmVBQjJ3OEU4dzJyTjB6Yi8xaHR1WlcrY2I4RWo2VWRmN2Vr?=
 =?utf-8?B?allORGI1dlZpQmg5UVJlbUFldWRNd280emRyWllULzVHcDJOT3BqU1JrZDZC?=
 =?utf-8?B?RDBvSlFoeDZTV1JrT1BUK2lnL2FGWG5GYWt5d2p2TFppV0FQbXc0NGZVZmE5?=
 =?utf-8?B?OGFhVVZ1MHV0SFhqNlpNZkxkR2I3eGNVM24wZWxkL3lWNHB2ZHFGTG5vMUxk?=
 =?utf-8?B?NEhvSnZPdWZtbzdkSCtjOFFWZjdBRUszYldQa2VFODZEQkRObXhMNVpBZCtw?=
 =?utf-8?B?Uk5hNlV2Ri9vcnhvVW16YU11QXBKRjlTWHJabkNFQXQ5OVd5SHhCSlZmdTBi?=
 =?utf-8?B?ckNPK1B3UkdwU2JYUWkyNkt0UG1pM3B2NmQwZGIvMlgvUnlGUURydjlPM2tY?=
 =?utf-8?B?NWp2bUFObEJwcTVYWHdUVTdjVUd1a0NFb3EySC91UDMzUHppNWJvV0hsQXF1?=
 =?utf-8?B?L21PR1lIWkZqaFdtbFl6ckVBMitIdVY2M0Y3NHd5aWplWlRFUFRYWHlxcnFk?=
 =?utf-8?B?b2JiZTVSOGVlbWFtSGRqRGkwNUN0Tys5Y3BTMTlBWUs0dDZzVkRQSXBwOEZk?=
 =?utf-8?B?bjNsbGJCVzFkb1hwSzliM3pqVG9XZmVKeDJzS2pqWGNpaEwwR3dOcFlHc0dl?=
 =?utf-8?B?dTcxemFFeEc4b0ZRbllBK0RQMVdsRitqVnUyckFHK2JNT2FNTU1ka2FMUjJF?=
 =?utf-8?Q?Ke0yUJ4JEuIO9hR4c3htUD7lgjp9bPENEetzmv1G/PMd?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f68846f-e351-4de5-bbe8-08da5e858e2c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 12:54:53.7804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K45hqOa4l6hxzgraqK4zOiCayK9eukqrqaKcoZk/TlkqJjxK7ZLijx3fgwL1q6oMHxHZHBsj65vjnwwUlZHScA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4572
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30.06.22 05:36, Jakub Kicinski wrote:

> 
> Seems like the buf can be uninitialized now if data was NULL

Thank you, are right, sending out v3

	Regards
		Oliver

