Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A403257D24C
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 19:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiGURQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 13:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiGURQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 13:16:05 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2087.outbound.protection.outlook.com [40.107.104.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5041B64F8;
        Thu, 21 Jul 2022 10:16:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Euvxa+/q9A4LLWQJndjy/E+hMJWNoqlwlMdrFqFv2a9I/uK+TllhzmpqciLvWkqnbBLnblkkRGp2tQffAz1aEveyPMAflL/Nj8PTmNikAoCyGC7TGmKmTY76PjgkLTvjkbprinDiCXBpgFTetPTMtiNxs5NR6nbGsyRtVwrG+FQAEYAwgZPnk/dEu4AL+rjBaXNGPKQJtns4kf2SD+xm4WwPGEe+VTkti5xhWbnlc66Yw5yxykWb4z5i+XbL3NtjqeiO+calDi/oGTzihjxGCkexuBgNFrHy/DAV8DoYisdT9ga6BfqGClsyfjUYI4vZIE+9E4DaQU6n+pPpgQFlZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wKLMoAURk13Y5ouMxTVYXEQRKhHSqeYcHNO+Dp/l/Ok=;
 b=DsChx1OCcDhHzlX6xV2xixPfz+85oKZ6I7ocSPyCez2Yky/eXbpWyJ/ckKtf+59AzU3sSiAkmHtGA6p5mDoSlMblNCEfckdvKHiM3U612fUvM55Ae1WOQvEdkvnbBjFQHCaAYEZyj7jCOo+4cYJPeILJIqj9To+AOPK29g6wKQ/iDLDYXndGEuvqerVkMUnNy0Ov22o5+Cd9D5fnh0jP+RZrfjD8IGWsGFg0lQVD1Cnh6P0GQdzsN4pNOWXUcCZ4/OnEfy2Ff/ft+IJedUzQFnXkiAcn54XoPDRxbVzwt7FbjIZIguWSCmLS2ptUUYj5GEDxUBZsbDTI5UhBcco0wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKLMoAURk13Y5ouMxTVYXEQRKhHSqeYcHNO+Dp/l/Ok=;
 b=jyiBQvtUDAbHrekRKW389CQ+TbmEd7A+G+p9P/uVrr/WN4M5wfmZJyIOiwLr+q+67XTFxRvEGWBYUoCpMfJawp55BqSP8VyFqkcOf7K93HyfPUmfUKS6p+lOWK/s21E8VWILnqAq5azE+5kW1PKsXyROqZvkgTrzkwoflCZ1s9UAK364ufatrHKb8Il4VnC54M1ExR8pyMhWpzd5K/pXUXYa5Ex4ZsETwUo9M9ryMnp1oF04xu+tPtU+5pe509SY9Vs2Q01xpq5Bx/PGpxCzR7miylmrQve6CHjGuCjsDP0YeHaA10Ilifc+fCnsTsI0tLr4CDwT7YNEXkFq9ypMhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5126.eurprd03.prod.outlook.com (2603:10a6:20b:81::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Thu, 21 Jul
 2022 17:15:59 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 17:15:59 +0000
Subject: Re: [PATCH v2 10/11] net: phy: aquantia: Add some additional phy
 interfaces
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-11-sean.anderson@seco.com>
 <YtfodwyLc5pMw4Gb@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <35c49437-c0fa-509f-f56a-530986891131@seco.com>
Date:   Thu, 21 Jul 2022 13:15:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YtfodwyLc5pMw4Gb@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:208:120::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61ff3f9f-1688-4f4d-2e4b-08da6b3cae04
X-MS-TrafficTypeDiagnostic: AM6PR03MB5126:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D2yVnzsgQkPu0p5f/IpmqUQDCLZbkCO45snZQ7k3dGw0CvxWI4KWYdi70TP/BcVAnnG85dRx+FaVXk/2cd6E5pjEDwz0tqZLybTsrJ2Zg/claMfjtUfwcsDjUAMKtmbFHouYv5fhs8IE49eN4Sh5HW2WZB2G9hNKtQ2sXT7VsOeP9fbIHsW1im6GeyLP8n7iaILftZ7Z5eez6Z7Z69DRicEH8UjQMtTz1g0Jw7LC7aQO7/Cz8Nj4E3qQoRC225bk4u3UOKpRz5ck/tKjcihZ4zNAoXssuPdspFX8o/aksDzoy4NrcNsvnvSOkRIgohZk6jurompvUT+gugy/BCVdHDgZGAZ8Lz1akJVF/ujiM1wnaIQCIZLQXKHPELOz3Z5Oi8OZu4VK7//lc1XF6g0zSxnxUcApkLMJoWx/PGf5q40cWGctOMq0tBZ5sESExTOB7KQPO/zUek3Jxat+lsgc6pIg7JKifq/hLo/z3DY4uPOJl+umVKU4M2f5oW2xJN/Bdckb/bs1f4/rtIx2t5Q7ReXcu0itvnNZVGGW0BMq/AMtAaW5ZxOZX0SBguz4VdEv85CchbzyywmWidJyw0b0xPhVo0LiSEDgsFL2WuZCD/UYH74VMdvZBWSOd/XTtnEDwD1aw1aDFZsiV1J+HCnUSh/aQGcPKx+3pSwL5Ew0eKHhrVnH+wMmpjEIhpjunneggs1U0tV+yoUA/nzJDznNxkrjBbBMh7/qgsnqRqhTMyPqGy+/g5AwiuJNMtYg38luwCdNvA+tlGnavoszimXQ2i1GuBWPasuKocZUJlL9LrM7YaqM/tcPz8ty7I9m66x6PvaOD5EaLagOgiFSIgYmz364PGGQ1CVggf0oPE8qnufsH0GZTCVr+tjqLh2nGVhQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(136003)(39850400004)(366004)(316002)(38100700002)(26005)(41300700001)(52116002)(2906002)(4744005)(6512007)(7416002)(53546011)(186003)(6666004)(66476007)(6916009)(31696002)(478600001)(66946007)(38350700002)(36756003)(31686004)(54906003)(4326008)(8676002)(6506007)(6486002)(86362001)(66556008)(2616005)(8936002)(5660300002)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OStwcGFqWWx6UmJmT3FFbFViblhtazY2TFBDQlE0QU5UZmkrK2l2cFJBR1dR?=
 =?utf-8?B?enErZ3JiWW1GRmREUjZDUDd1VXZaWlUrOHByMDdMak9GbFc5ZGVIOHhGQWxj?=
 =?utf-8?B?eTcrdStzMzdoUFRweWpjK0dWcnUydUNzMXQ0M1pCVVJyTERqd2g1RHF5K3FX?=
 =?utf-8?B?YjQ0QStZa2xsVHJVZU1pK0F0U3h5enZ2NGpMYUsvS0dBVmU2V3pQZmVRTm5F?=
 =?utf-8?B?c1R4elIwYWxTbEFacmhxMzd6TkdEZ1RYdWkveHExZEI3VDhiSFNCMmVJRnJS?=
 =?utf-8?B?YWNobEdMQlNaRzM1QXNaZHJGZFRkZzB2dEk5V0JFUVNFNGtIYnNxVTlKQVpD?=
 =?utf-8?B?a2szL0kxTzZPRmNOZUpkd1BCSjNyVjVRcDU3djliY3ZwM0RJL2tUTlNDaGI0?=
 =?utf-8?B?NkttTXF6MTNtQkxBdG5kVjNFSE9rSGlkaDVyMU53OGZob2xJbGF0QnJxaXVE?=
 =?utf-8?B?OURmVFAzZnlMcEVXa2FhZzZFZ3NVU0RuTFRTRWYvS1hDclF1QnJwQ3dBckhW?=
 =?utf-8?B?VVlKTWpsY3FJaUo5UVVFclhWbFpQbU92dGFRSVd1Y1JpU2ROUGJsdVFaV2lS?=
 =?utf-8?B?YnNuQjJlSkx3K3RhNVRsODFndnZHSDFVTUFRVURCbU1KRG1QdXI1N3pKb0Yz?=
 =?utf-8?B?RXRwUUNEK3lhcnVhL3FPNndibVEzVjhuRmc1NmxMcDlNQVBsT2h1MFJhUUVB?=
 =?utf-8?B?dExhdk0vK1Q1a3c0eVlteXZTU0M1TVhFSnhOQnBUYi94UXd6MDVmZFArSUtS?=
 =?utf-8?B?eS80WkYwMS9ETUczbjdxOU56cTFsckQ0ZHIrTjFNVDEzd3F1bitxQ0hZNWVv?=
 =?utf-8?B?Q1JiV3ZjVzJPenlmQlZ4ZWZ2b3hmYXp4d2RSSmVmeGZhSGQ4VkJQcFdnY1NV?=
 =?utf-8?B?d1RReXl0OWxUOXJnYTlIeEM3Y2dZdUZFamI0c29kalNwNVhMNm9kQTJsOFFS?=
 =?utf-8?B?VHI1WjNiVzVreVJNS3FibTNQc1ByOVIrdmRmbC9KSitRbW9BbzRaMXhPcm5D?=
 =?utf-8?B?TXYvSm92SUtpbXdJczdLTTIrNUFBanVENlJPVWovRk14Wnd3MlYvSUNyaks4?=
 =?utf-8?B?bVZ2dktPRE1oeS9EZFVvdWFtWkN5bnRlZnhVbml5TjlLNnVYbmdta2xiOTg4?=
 =?utf-8?B?RFFDVW5UZHl0eUwwUEd0RzNkeU1UYzZ1YVd6VGF4amthNWtnc1BsNTlUWE9H?=
 =?utf-8?B?YWxMc2RqOG9OSGRWd1piMXZ0ci9GUXZmQ2lVNy9yRitCU01lVkMyVDNRelRo?=
 =?utf-8?B?cGlUNENwWWJIQWZsL1BUdVVWMVNTQ05iVG84a2gvZTJxUWcvSFJ3SldrZlNF?=
 =?utf-8?B?d005NjNJeTI0LzRFVVJtN3RyT3NNQkpZaTRLQmFXM1E4M0xrSEJjUGc5NFJJ?=
 =?utf-8?B?ZWVseUEzendvVVhxNVY1QWV2cmgxYW1CbTZSUnd6UVIyOTh0eWVBc1NEK3NZ?=
 =?utf-8?B?Si9rU3FHSUtzNVpFRTRWRzFKTTRnMko4ZGI4OUtnYnJNSlNVWTRjSXN3M2p3?=
 =?utf-8?B?OW5nVWxGYzgwYitwMnZGZEk3cVFLSHpScmJRcnFpZGNVQllYUUlISTU0TndX?=
 =?utf-8?B?VXh1M2ZlYlJXWHYvMms5VnZrWjRNK2VidHJBbURhR1o4enZRUFZ1SzRZL3Fv?=
 =?utf-8?B?a2JIODJTOXdKOUxhN0JjRjRoZGhPcGJMRUcydW0zMW1sc0lnK3Jhd1BUWGkz?=
 =?utf-8?B?MFYzU0xXWVNyV05jRnVGWjlnWGRsbVJzWEdJQkRWOGxadS9XeGd2MHoxUTVi?=
 =?utf-8?B?Ritwa3FQaEJSUjRWQW1VblBxK3Axb1lrYTRJamtXU2xQaUM5ZlRqZlBpb0p0?=
 =?utf-8?B?R2J0T0dvcjc2QS9SbWFXQ3J2MFY0MDh4ajk5SzFiSERnWmMxeFhjL0hMSlFL?=
 =?utf-8?B?eGswNkJDRXlNWllWaTVyeno0TXJJMzlaZ3JrQXA2NklGL2xEZmZTTVNoam8y?=
 =?utf-8?B?QS8xRkszMnFENERjd3NvZ1Y0Q3ZlbFNkdmpGY3lxclM3Y1IyUHQ2Um9VK0M4?=
 =?utf-8?B?QlhKblhxeElCTXZXelFSVmpScUI4TGNwUkZ3UlN0MFN3cWswaC9WUHBaeGVn?=
 =?utf-8?B?dEdlMnhFWDJTTmR3L3RldjZpUksxYXNDNzJJMjZNMG5QRkl5UFJFR0g3REhk?=
 =?utf-8?B?ck1CczFOd0tTR3BIWmdnanF0WW90UHVsTXpLaER1SlVoRlZ1bnhhdHdKaHJT?=
 =?utf-8?B?RXc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61ff3f9f-1688-4f4d-2e4b-08da6b3cae04
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 17:15:58.9940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6a+Uflh4+dHRYqXFgNJCubbeFCPUh4rWemo3ByprRfA7BkYShraiUIppYk6cVj+U9RJfSck18wNiAv5Flyy1UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5126
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/22 7:35 AM, Russell King (Oracle) wrote:
> On Tue, Jul 19, 2022 at 07:50:00PM -0400, Sean Anderson wrote:
>> +/* The following registers all have similar layouts; first the registers... */
>> +#define VEND1_GLOBAL_CFG_10M			0x0310
>> +#define VEND1_GLOBAL_CFG_100M			0x031b
>> +#define VEND1_GLOBAL_CFG_1G			0x031c
>> +#define VEND1_GLOBAL_CFG_2_5G			0x031d
>> +#define VEND1_GLOBAL_CFG_5G			0x031e
>> +#define VEND1_GLOBAL_CFG_10G			0x031f
>> +/* ...and now the fields */
>> +#define VEND1_GLOBAL_CFG_RATE_ADAPT		GENMASK(8, 7)
>> +#define VEND1_GLOBAL_CFG_RATE_ADAPT_NONE	0
>> +#define VEND1_GLOBAL_CFG_RATE_ADAPT_USX		1
>> +#define VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE	2
>> +
> 
> Shouldn't these definitions be in patch 11? They don't appear to be used
> in this patch.

You're right. It looks like I added these too early.

--Sean
