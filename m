Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDDB58023A
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbiGYPvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234646AbiGYPvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:51:05 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30070.outbound.protection.outlook.com [40.107.3.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F8BB1C6;
        Mon, 25 Jul 2022 08:51:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6tYi2ehw/LZz+Sssy0/Wng2E1H3i6UrS2GqvOQbVt3tkFapVadYp+sVAPlaFGgrzYI4nZgnmh8wFDsetO/Xrs5fg1SogkjQUmEyo1oPc0cKZuTG2SBzoR1ixUBstq1bi0s8pGw+7aAnMzhSX4gH/5r7GKETz4FSRdjbdB0FzIIwiVSqAZfs52GtUUc247CDW3yol6Tvy1OHOXHUFm9fdFUIKgWAYQpM3Ii/vBvP49yC8BUVIOn0QSfiMp5ZBieumvFjA60FSJF6XboccMOQA8eCW/V6TmGYa9Hbc2MkopnNwLa0aV4IwTI39xqJOK6r3prk9ngvGGfzLiixR/Jg8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9mSf8BvvoKxgJxxfdN8/36y3HhVdJ9MbqbfWyuDeUA=;
 b=gQnboKOhDLHx0pHjDDw2QUHuJlYks5lMDdLfpc6Rnnw4thuVhy3QnYg6AoxVFEWKvoxCvUvtYpCyI1Q2kVtMSlshPaMYLe+r1dDtrEn9zmTWJ909BbqMtrvDrRCWFS6vyd1+MMC8m6TTUQC0/fTyQVPwlmE3OF5i271a7pyLZ5p1V0gJ0Biu1fhXNKkPzx+u9sXOQRQ1EugIw9laJh17MEre5TJO9szhQy3ypKSWbyMI9LlNJ7P+BZP1U93DDfzj0xuWThW3JkdrXD5/9TLLUUzAdrE1QoSfmkeA9hZRqnBfUW8luAGcCWNRn8UDqEw8Z/WFhntxI/yF7j9X4IqjJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9mSf8BvvoKxgJxxfdN8/36y3HhVdJ9MbqbfWyuDeUA=;
 b=Irho2/RdcjPIP6QigZSzF8YDBMF1s1ZuXYCYCpVI5yi7xk/BFzqeQRKJw2Vs1b3WjH4LeCNfA0EgncvG4RImdOek6ageCvXF7Na5FwZgsX6JqLHiYq2jqbOvN2CTWeyvJ3WCPTcgKM0SL7suBUVJo463ZbuSAdLJoNtnyqyluXWXV6dNVV+Chv/IiS1Bc8dEeLRY6TnjRUNEEN5A5mqPjIxZrEP8QcsJT49w2rLJyKP9R7IGT3UC/mft20T0W//rfK6ireVUOmHWoVrAa2q6wuo30KHPYJrCgTPafPQMLQs3/OW8Eu4CORPq5+GwYbbuY+IgwzxsOI4cMuNrMFD1eQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM0PR03MB6018.eurprd03.prod.outlook.com (2603:10a6:208:162::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:51:01 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:51:01 +0000
Subject: Re: [PATCH v3 06/11] net: phylink: Add some helpers for working with
 mac caps
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
 <20220725153730.2604096-7-sean.anderson@seco.com>
 <20220725154103.e3l4cde3bhgdl65y@skbuf>
 <2c7b01e3-0236-3fae-7680-05a47b9c266a@seco.com>
 <20220725154623.ynt64sgphyhm3wgm@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <0f70a21a-9dc7-a512-e60d-f599f5e8926f@seco.com>
Date:   Mon, 25 Jul 2022 11:50:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220725154623.ynt64sgphyhm3wgm@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:208:120::20) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11456512-2e86-4686-4ce8-08da6e55796e
X-MS-TrafficTypeDiagnostic: AM0PR03MB6018:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwYMcJzqbsh7jNh6+p63qz86ld10n1b9bG/N7TW7e3ltOaXNYwCV9BVqtuDwHnNwNu3hFHploOx60/pEDR0K/3+2Mt48bG3fTetNQurv1RGdz2RA376cFal2sxTgUyPNjV9MgP2Jve+zAVKipO0aBEoj0dZ0RHLgRYNWbCYfsLmamhDcy183UQn0Fk2xHVOCRJAIiCC+vQVvxq4NAD24nF3m9t8wmjoEAEC+0OC+bwQBDtNA164QkVu7RP8K2L0nytZlVHe6yfBKO52qKLweuk5l6w40th5vqHBI2bEovpxcMjeDf7iNq/mQuIZKsha5DhXRIF+HnQaE/4pR3jTacDBpJOd3ZFsGvIBSkX7r8CQDrlaUX1LsZzE6finC9YfhGdFRs++gzhTYoPtxUQwI1UALMx9Una2ESR9zD0sbbeHrirZX83CAUe0Kqm85L+GfTCdNrSN75fjUB4PArcwI1s8OeIrh1unHus4pURDoii4uPPHydr9147hOAecHy0iKmhMC5jOAthYiUIXfllo5ROUfzlo/KTAC8zK+pX5G8qWmlZZkLmOnpEE26/mDWHgDim5TpHcHCFuMLyTKSS4vdMITwLoQsBzyp4QCVDvXd2AfHb/CJ20+BUtwTVLLuRKGeReqWYumK/9Mfo464xX6xF8rD85wZt0vvJXbTysQiQbo18GO8jYwwxCrT4qkrEc8o0TuRpn0Zi6CfOlgddUjXhLZ6jixziqKOQ4d98jPX+E/dDNcO2sv3R/c6REuoNOm+3dX3XpUkrZwYEy7zxPwSZq9sN2V8O2qAj8cfayto6sWCxoXrrtYiRI3ezTMYju6Vnv3fab1zV+5tMRG/bRlMS/Dw95vHo0eVw/51wtWrqoIwhCSZefJ+9Of648sm7V3lJ6waByc/ClEPVOvmeliwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(396003)(376002)(39850400004)(346002)(7416002)(5660300002)(2906002)(4326008)(44832011)(38100700002)(66476007)(66946007)(38350700002)(8676002)(66556008)(8936002)(6666004)(53546011)(6506007)(31686004)(6916009)(41300700001)(54906003)(52116002)(6512007)(26005)(6486002)(36756003)(966005)(316002)(86362001)(2616005)(31696002)(186003)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TURYTHNRWW1sbVJGZFkySFBaUWtwNlNrckhKaU15WFNVZjJDMW1vWTlRaDBW?=
 =?utf-8?B?bS9zczBFSjRkVlJ6TVVxOStEcHFYYjBBTDIzZzZMQlhvbVVpZ1pZaDBNWmpl?=
 =?utf-8?B?OG1HVjNycDJVWkhoUFdiVEVLRTB1amNFT2FQb1JKazFFL1JVdzBTZmpkUEI5?=
 =?utf-8?B?eStoYlVwK2MzbXFVc1g0K0YyVjNIQlliUlBwTGhEdEp1UWtTdHpaYy9LdDBV?=
 =?utf-8?B?d0dtWFhhQWVaKzhEclI0YUdWYThQRGhqV1hBcWh4QmJxVFhSQllyd3ZhUDBh?=
 =?utf-8?B?OUJlT05sbHc5SkdVNTJuZDZEY0NCMjVzUE9EbEcyVzkrWnYxb1JleHJqcDRn?=
 =?utf-8?B?bDdIcmFBUEJ1YjhlTkMrakdVUDE0S0tzOW5UZ3RQdkJvalo5a2xCanM2clhv?=
 =?utf-8?B?M1p5VGZTUVJ0MTlvSmxob1F2NldmRXRXeURMeTJqRnVUQ0lDL0owRGVESXJV?=
 =?utf-8?B?WGNHWFdGSkZ5eG5OMzZhV2dmMFZBQ0VhRVoxZExwcWhWU3pPUUtPbUF0R3ZO?=
 =?utf-8?B?KzZJWFowalp3TjZ2Q1QrcjlMcGVXaFZGdS9lM09OYUNGaFJYOUhicWVsNWY5?=
 =?utf-8?B?Q3hvRGNKMzR0ZUY1aHAxdXBUMlM2c0Qyb2JmdEREZjdwbXprSFFjQ1JXSzd6?=
 =?utf-8?B?Uk5iNUFYWE81YXZNT2pGdHArQVJDaldFRFN0V2prME83S1pwd1llM1BOdmVi?=
 =?utf-8?B?WE1oS2hzeXhTL0JhVkRyMW9tMm1nOGNKZFE4SStuanJFTUZPWWw0MzB0T0F1?=
 =?utf-8?B?RXN2Tkc4WXB5TDd5dnJTZ2M2bXkrRWI3UXhkNHNOc2xlK1J4RjRiZWJJV0RQ?=
 =?utf-8?B?WFovM1ZKZ3YxZm5FNTlmSEtzcWdva0ovWWNjOXpGZVpqM0hTL1JXQUNmSmM4?=
 =?utf-8?B?WllqVWF3VnVDWnorTHUxUG1XRFd2Z285Z0J0OG5vcUp2RStHRUl3VGNWTTI1?=
 =?utf-8?B?K2EzSXg4azRCbVBIa1B3N1dPSk80ejFIZXpSR0JKaWl2Z1g5M2JLOFhKVTNp?=
 =?utf-8?B?aTVpdUpJUHk4RU1KUmFKWnpWUDUzTXREVG00Wnp2dFhUQmxxVzlUZGtXaHd1?=
 =?utf-8?B?Z3N3UHpielhuWGhNNGlWb1BKR3d6MURjbTFZYTVQSldHK3lCSGl4YndncERS?=
 =?utf-8?B?a1MrQVd6YUFTZ2lYVU02OUcrMWJ2ZkRyV014dDB0aXBINlNnMmZHUHJqaGxk?=
 =?utf-8?B?YUord1ArMTBLekprM0tUdTQ0dnBLdmxmbGswNkRnOFViVXg2SGZ0UTZiQkdE?=
 =?utf-8?B?NndvZDg1eWhEQ2VqYTBZMFBaUGdCRHVTekpHeXNBbTF5ZTk2TUJmN3l1ZjIv?=
 =?utf-8?B?dWovSU9vWFZPMlYwWUpBYlR5Ym9wUWwzSzFQVWc0ditWYm1Ea01HUFk2YmRX?=
 =?utf-8?B?ZUlHcTZtdTdjWnBBRkg2TGpLRnEwV2taeVcwcWtlMFNGdmcrUUdyZ09lYzNB?=
 =?utf-8?B?dWNpbm0rSTVYcE9WcDMwUEphMnJBVW5XdVphdU15T0YwaVdlNWVvL2RSRTZG?=
 =?utf-8?B?UGFRMXpOVnorM0ZBSVBWQkFBWUZJaElEdzNMRXlBOUczS3ZaQkplQ3AzK1dE?=
 =?utf-8?B?ZVl6anoxSm1xT1I4enJVZzlUUU9UTkttWWdDRk9EUVJaVExYSjVidDhNcTRN?=
 =?utf-8?B?NnZyNVhlUHo3THlLMkNGMHF5MzFrZGsyRitzN0F6S1hGdzB0TTdoRkY0NzJJ?=
 =?utf-8?B?c2RsaVpKZFJ6SUtSRzdzYTNMdmZTdlF4YWtRSWpjWXpXNGlFNGphMHhid0E0?=
 =?utf-8?B?dFdYR1hFZnRoOGtEa1BnMW1yQzhGYmxXeGZUVGdIaXdqbGFJT0h4MDE1cGxj?=
 =?utf-8?B?VGZRL2h4Q1dYQUFBYTRDMm9wVVpQb1YyaDgxM3lvRUdVUmkwOVdDN1M3SGZC?=
 =?utf-8?B?UlJzekZzWjZ0Y2tJZHpEdlNDZlFKZC9NTWVIamxpTFlONEpITkIySFFJamlq?=
 =?utf-8?B?WHc5b3dNNFRNQS9GTGFuaTNCS3h2cTZRMURpVWpYZ2hzcmhxYmluZDY1cE5U?=
 =?utf-8?B?YzdhYUlpU1pjUW9uQmhSUFhvQmE2Q3J5ZkdzOWZKY3FkNktYaldOeW5vclVt?=
 =?utf-8?B?SEU5OWRIbGphNlFuelF3K1FHc0t3ZittZVFrZldyanNzOStyeW94NkZ4ZzdO?=
 =?utf-8?B?bHNVV1lZU3o4YXZPQkdpYlVVLzlmaGF0ZUZESmtqa2VodnlIbDgxNkZ0L0ZE?=
 =?utf-8?B?Wmc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11456512-2e86-4686-4ce8-08da6e55796e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:51:01.6299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+ADej3Dts/HMw4NCIUJJMEFB2yyA4GuNRAPqOsQ//rAMeJ2c5dR5ozKaiYcr72CiNtZ2kbfuC906CKrb9R24w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB6018
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/25/22 11:46 AM, Vladimir Oltean wrote:
> On Mon, Jul 25, 2022 at 11:42:25AM -0400, Sean Anderson wrote:
>> Hi Vladmir,
>> 
>> On 7/25/22 11:41 AM, Vladimir Oltean wrote:
>> > On Mon, Jul 25, 2022 at 11:37:24AM -0400, Sean Anderson wrote:
>> >> This adds a table for converting between speed/duplex and mac
>> >> capabilities. It also adds a helper for getting the max speed/duplex
>> >> from some caps. It is intended to be used by Russell King's DSA phylink
>> >> series. The table will be used directly later in this series.
>> >> 
>> >> Co-developed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> >> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> >> Co-developed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>> >> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>> >> [ adapted to live in phylink.c ]
>> >> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> >> ---
>> >> This is adapted from [1].
>> >> 
>> >> [1] https://lore.kernel.org/netdev/E1oCNlE-006e3z-3T@rmk-PC.armlinux.org.uk/
>> > 
>> > I did not write even one line of code from this patch, please drop my
>> > name from the next revision when there will be one.
>> > 
>> 
>> I merely retained your CDB/SoB from [1].
> 
> Yes, but context matters, the logic that you cropped out from that patch
> was exactly my contribution to that change, the result no longer has anything
> to do with me. Maybe you didn't have any way to know this, but now you do.
> 

OK, I will remove those lines from the next revision.

--Sean
