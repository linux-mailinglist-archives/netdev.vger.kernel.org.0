Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509046CD54B
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjC2Ix6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjC2Ixy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:53:54 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2050.outbound.protection.outlook.com [40.107.13.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DE940C8;
        Wed, 29 Mar 2023 01:53:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZIZlr9fLtco/CfGEnx45R891zqmhO7QW3rYgB4ysuykjCsvbeQz+WunzfMyBryHKlLM0l94eGLaFwOIDQOOLQV9/Gu/tfKounKhPB+NHRJFX33K2MQJWMuW60vgnc3BEgO9MSUwwuW4HhATty0e0Ue61HoolrIbl+6vZm2J6O52Yn8LxevJpI0co3WUs5ax7O3JClj2vt4KwTigkLzESRJXwJ6TUPQVtyjdD7iah/w3QLkzy4zlzDcF3rGwIOi7F2Ici4LiYvq6X7HxTrhy4Qoc62PuUlpr3LybR4sl40RCObs4S2JFml5b/VHNGZlNAezuwAm/orVQVf89nsxIGDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvSd7dcVqEtXl8d7+Tp/X5T6833dC7VLQ2+OEGCALc4=;
 b=ISr/4pI/LM/fAySvUK+7D1X15yfXYwBwzGVvurvJAxYeYzOJemuM/0m4wQmfyChFjw9UdA3MG7R0q/5KUHHliY8tqCelKGaBOPWjvTWIrxVjQNEphaZkCEjwWYhd3f84WVODJJj5N/ZxFEVzrTgFX3u/wbBdm5H0JGPrOjweHPtQaduH/kvcF5P0JaGyQs2L6w5wr6LlDmwrii291/+opxy7JQh0e0g5kQqOu2GnRKyhtn4yrjCC2RXYfcNWkJCqCCKtCMJFtKVZ2Eri07sjoXk3yHaUeOBl4Wz8xSaNZ6pQkWd9lmEipjASVDX030wZAR6hlQK121/YbIJ7CGKWUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvSd7dcVqEtXl8d7+Tp/X5T6833dC7VLQ2+OEGCALc4=;
 b=kmtzEDh4uToYu7UtoFQrKxFUPj+LFRKn+JLGIN09BTdjLZU4DrHeSJazA48ijAZw+QOrv57oqByKz96nunBhKGod9NwJ0p0GjjExJa4o7Ob5usm9SLhWPbKlqnGhQwcimY/XffOoRbbLtNq9SW4C6LTvxGixlWskPGAhoOMtJglFfoKO6h6RLOd9vXArjoA0QIPpFuzXEflOesoEW17d3+jePwv3a+NiPCZWqiJOljiJ48/FiHkEJbxZgIuwraMIyvgRQjjBlzQw8SJb9wTlUYUdZ912GT/418vCc4HnFyRUdsGXgQ2Cp/KAEeZQ8EXf0KCTJlhPAxYs4Z3/23c1Fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by DU0PR04MB9669.eurprd04.prod.outlook.com (2603:10a6:10:316::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Wed, 29 Mar
 2023 08:53:31 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::154e:166d:ec25:531b]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::154e:166d:ec25:531b%6]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 08:53:31 +0000
Message-ID: <f8795f25-718f-9336-266c-ca26c86b0e73@suse.com>
Date:   Wed, 29 Mar 2023 10:53:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v3] xen/netback: use same error messages for same errors
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230329080259.14823-1-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20230329080259.14823-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0093.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::7) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB6560:EE_|DU0PR04MB9669:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a1978ac-6632-4666-b801-08db3033125a
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: efFBkTqaAKFwfGrnXogBWzhMps+7pJ/MCF20Sar5rBZPIgLYrB+S1+7kZub8G1PLQUNTBbMTSbiI4SCDb8gI1TaiRz4g1tHHUYR87nHdk3ycyTSHVvc3d7M0j4UcS08VfO+VSp8UtaZGIu/wAFgATlUgOBoj/cLnsxkOr7AAS0osS0Y+7uCb8C4AvUVwYzwdDwD5rw/n3HaHS1Wj//8x7uSmljtKYK9NlutO74+yB/nmOfeUP8IK5oWKq5wJeAwAM+D/r7M1T2GeULXdScJg6uaZ/h7kHwjc3wg/YLwrOFavIgrTDJZucbrgAuJ1uSW+igdgEcTovYdF6CtQw7lWhrTj7TiMBBTP7dWx99RB6K0VuEJ7AFLmLXtv3+lSWLEi886IdsihbazNwSyHGKJIh8H/44vn75sXEZRIxVmG0WCkCos3GNeuXh8r9QaByfTTeVX1gulmvvc8kKwCsPleZOop9PRsPbcobD8ETV6Xg409nfH+kutIKI1IqO2nKU0RqssxwYKjlxIlYtuWP16mZNkTp/JzgYa6BnFUczI2cj3lJ4JWu/bGzo5B7YznhsdI++o7mRs1dteBc2O+O/wDvFi6QCs4fe+Jx7+PMFmAMzsa9RJtoc8tXyi6nkoNFrVjHeDpMrvICW14s7MoWp2psQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199021)(53546011)(6512007)(26005)(6506007)(41300700001)(186003)(6486002)(83380400001)(2616005)(31686004)(478600001)(54906003)(37006003)(6636002)(316002)(4326008)(15650500001)(66476007)(38100700002)(66556008)(4744005)(2906002)(8676002)(66946007)(31696002)(86362001)(5660300002)(36756003)(8936002)(6862004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TS9xYmRheW5VWEp5Nzh3aHZxVFFSZkhYR3dOWEZCdGdXQkVqWEtoOWlwSWlp?=
 =?utf-8?B?eldZaWhiK0l0UHRTTWNmazVHd0tMY2VVSEkyMTRiLy9Vc09LSEJPQjVxWlVx?=
 =?utf-8?B?Qm5WaTd6NjRUVFlGbHIvZkRUMUt4NGFIL2l0QkFXYWpJdUZ5V3BMeFRCVmFh?=
 =?utf-8?B?WWcyaG9HL0VWZE8zUjZXOUdRUzBURzlVNmJiNzVMMjBqSThxUFFkV2dQV3F2?=
 =?utf-8?B?Zml0bG41OGFMOW5ydDcyeTN3K2FiQ2UzRjdtQjRoZkVPUWJqald0UktEc1h4?=
 =?utf-8?B?S3N2c1NPcEFEVzBqRkluUW00NmY4RmxWZUZjTTcwZE9KODdxYmtCc2xGaFdw?=
 =?utf-8?B?ZFBLckVXc3hCZDBDbFEvUWJjUG1lY0R5RjczU04wa3RzWmtBZFRrV0pyUTh6?=
 =?utf-8?B?WEwzbWo4TGM3d3ZmR0t4ZnZaRytSWUVtbVZ0TGJOM3dPQUhOeFVRZGUxMHl2?=
 =?utf-8?B?S3JUUVNkNVJFWkx3VEl5YW5GNXg4bS9FUzBBQ2ZBby8yUkxsQkZjSTRMZGVl?=
 =?utf-8?B?bDFvalBJcjBlMDhrb2hPODZjbGFSMkY4WDNIZ0lxQWhHSUFuNGlSYnQrZnBF?=
 =?utf-8?B?ZnlyUE9haThkTWg3UmJTaXFpaXU1eFgwZzEzOE5DcE9vREsvN09oc2drcVlp?=
 =?utf-8?B?d0xEZ3JKRWpvc0d1OEN4TkhqZmkyckVBNy9oZ0c2c1g4clVheUp1TUdLQmdP?=
 =?utf-8?B?K29rc2o0UVM2KzBjTnM1NXlBQ1JWR3lGUmlqNGtCRm8yaWRLdE0yK05oK3Vh?=
 =?utf-8?B?VW9vS21RMml1M3daV2E1SmQxZHQ3YUFaa2hud1JHcjFDREI1QlNpeHpZMHRa?=
 =?utf-8?B?SkZkVnpiWWU4cnU1RU1Md3d2a0xGZzVZemZOaXU0d2FvdEsva0llSlJHS05l?=
 =?utf-8?B?RWczd3Z0Y0l5SjNnZG56T2JCOXdXczJYMXcxNHpTWVhsaXRvam9jd2QxTzdN?=
 =?utf-8?B?M2lrTjBzZGlSQlczQUhZV2VGdUtpamJreEtVb3ZjQkF1d3ZWZy94d2VYTGFh?=
 =?utf-8?B?eWFSSW1ZZ1Rwb3AydGFieUdacWlwOHVuN0JSYzJKeWVGQmRWOUlXRXVCYmIy?=
 =?utf-8?B?R3MxMkZDTXRCWEUzeXo3ZnRaT0NwL214RDFmaHc3Q0NTTlN4V005K3luYTYw?=
 =?utf-8?B?OE5rOVF6WDhidGlQMEpvZGRhSkRkT3d6ZnNtb1BmSENISHQyeG85MjJvRU9I?=
 =?utf-8?B?UUhQM2JodTVtQjdxSHVLdjNQRlpJdGlyemFpdjJEdXZxQno2OUtxWjQrRG9J?=
 =?utf-8?B?TTlXTjkyUDJsSzM0UWtFdTNzUlpOTGRTc0hPeUN4aVdhU1pKNHpMZEhZU21Q?=
 =?utf-8?B?SkFpQUs3Qm5pMUI4SUdjbktVNnA0UXkrKzVrRDVJU1kyNVM3alQ2M0RPeXpK?=
 =?utf-8?B?eExyVEtEU1UvUmRlcjhFaU83WHNSUjQvekt5ZWRnaklodVFra3k4NEhERmNw?=
 =?utf-8?B?Qk5aUElPaTBrTHZmYnZ5T1k0T3lpYWtoTk1xbXZHdFY4NW1jaElBT3FXSzFp?=
 =?utf-8?B?VWN5Y3BVTXJ3SE9NVkx6YWdBTGlFcnJJc0NzUkpzcUw5Z1VkTTdTSmlMazVS?=
 =?utf-8?B?REhnWDFsZDdjWERhTE1kTjdBWGNwNDdrZzEyV2FRcGFDQUNQS3lqdno1ZVVX?=
 =?utf-8?B?UDIrQ0JWUnZPdG1wYmEyb096Um5CVkFMdmNBcXQ3ZHBtLzlSOWpCcUdkZGo1?=
 =?utf-8?B?Z01SRllaSXlRNUhLYmYzSG5uVWYrcDRVeE9XdkRpUi9LUFdkOWFIMzN5NEYw?=
 =?utf-8?B?Uk41NHFmWExQc0xGRkMrbzNCY1oyNmdJVE4zVmRIM1dGOHhuOGlJVkE2SkI5?=
 =?utf-8?B?UEU0MTgwOHBrcVdGM0hEZXc4aUdKQVJsZlB1S2xtODBiSHZ6blFCNkJ6bGsx?=
 =?utf-8?B?cXR4S1pYalQwbnpZQWVJaUlCYVpKOExucGRSc3lJTzVkQUNZSXhma0V3V0lT?=
 =?utf-8?B?cmN2TWk2eFpXR3hhRDV2KzdhUW1oOUFJOFkvTXlNSWZsRkV0UFUvODgvTkhR?=
 =?utf-8?B?SkxiZWZ1RzFrMWRJbXZGSzlZVXU1RGNLVWw0MEtlYkJGeXlrakNqT3M4dWhJ?=
 =?utf-8?B?MlVMWm1aRkpvVmpWT251S1I2YnV4YkJlbzJGNDRpNnBJdTdia3U1QjVJMzB4?=
 =?utf-8?Q?Tkv68dxnZiReuctMWfU4o/XWS?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1978ac-6632-4666-b801-08db3033125a
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 08:53:31.4089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E7QVC5OQ146+3Y8GEjRZ7j3YPPOOY+eFL9qt6rO0fNrUXDoKQ+xSFB7yBUfu8TW8U36AsWUB2xHK8NZoP2l/NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9669
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.03.2023 10:02, Juergen Gross wrote:
> Issue the same error message in case an illegal page boundary crossing
> has been detected in both cases where this is tested.
> 
> Suggested-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>


