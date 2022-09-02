Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C5F5ABA18
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiIBVcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiIBVco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:32:44 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60070.outbound.protection.outlook.com [40.107.6.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42697F0776;
        Fri,  2 Sep 2022 14:32:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmxMIuuJs9ZHeWJnlonXM/om13kK7y550nZdMfxIEOq9WcASXlnmZMMGFOzpDAkrzy2aCpCI0SUQIvDciIRm7eNSbcUxYt8bA07/HnZe2eD2YJGTcJCuNBjHJkHJvtesw9PfL7NTUo34sQZHIlxVjVnUoh/1HtPNbqkKuxNN1SI5J/PNzQOAy+jObKo5x1E17P6Nb5s+8leeobhmBKRM8QGWR1sD3vKIVfl4TSwA0HOj5sqETRFuv3elHTyHRZh9Xd7X5/cmISdyc2tsOVSpH4nsitNmvyQr14kkSQaTVw+Sn7ZIZD99nCWipOwx/+/9QKiTGllkNbN12WUnbnegKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nHO4VeoA7I3FWtDGhmqYwnv2cshNwGqKPFjXixqoBc=;
 b=Xub4nu6gJPAe7Q6T+znE7AY9Lf/DBrJMMuGD9C+2rlYjgD/8w3mnbe4qiDtGjwy9qWx/8jhpZisIKDr3IuSNehGDpjr76evVtQNgyfTrOxvL8DxZY/KHS95h798z+Iuj5ot20yuDeFnxSh83J598fuVyddvK98blU38DVTneDaCFJEI4G85FpMGkwt4SDAy+7pO1yJzFxgaQx/boJJL8Ed4nllc1OT5tRKOQbjK8bah7aLbQvCUPKQJ9lRO4gPv+88JGDmE51XLhpb6duL9LQPnfMI/F4C2TCnrY+tT28sCj92Q1xU+5Dx5/OJwRkfd4sNRo/14Lhd2i/2FL+CtVsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nHO4VeoA7I3FWtDGhmqYwnv2cshNwGqKPFjXixqoBc=;
 b=xz7yliXCqr8pjhrWtNsvlE8qs4U/t2pa+77QVNPjRrjbd4SYueGx0rheJQlrDmQaSz8p6/zwKTph3pEDuq46TkKa0dcvM6zd5AfI+2uDbHzLggBgMk6r+CkPkOrj9lETKhAEAwUASZyhY+8Yp9zy+q7FcEtr7d5FKaotDh0qW+tRt4DQFVQhlTyjdKOEoiDoZpksRt6GvcUiX6ukx5xjen4y0GuQ/DOdyjuUUQplbSNcqNSrJ3umU8Y3NauiOiTm4jBAGvnyEiJQRZMBam8xjaIDSYwIsZmqrT8K+v1f1d4QULPY/hOJUeSCmdvOwR2fODOa1aeGT+c4Zxo7VCVc5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by HE1PR0301MB2265.eurprd03.prod.outlook.com (2603:10a6:3:23::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Fri, 2 Sep
 2022 21:32:38 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:32:37 +0000
Subject: Re: [RESEND PATCH net-next v4 00/25] net: dpaa: Cleanups in
 preparation for phylink conversion
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>,
        open list <linux-kernel@vger.kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
 <20220818112054.29cd77fb@kernel.org>
 <f085609c-24c9-a9fb-e714-18ba7f3ef48a@seco.com>
 <20220818115815.72809e33@kernel.org>
 <583c7997-fb01-63ad-775e-b6a8a8e93566@seco.com>
 <20220818122803.21f7294d@kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <db48eae9-e61c-cf8d-e652-56545193e51e@seco.com>
Date:   Fri, 2 Sep 2022 17:32:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220818122803.21f7294d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0071.prod.exchangelabs.com
 (2603:10b6:208:25::48) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8278d89-342f-4b06-2932-08da8d2aa834
X-MS-TrafficTypeDiagnostic: HE1PR0301MB2265:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P5ND8/tGrurvuO4Ylxaf1M/jSdP88k2kzFjngnmSsj6rdZKV6W7OnCqvG3GhzQJZ+Jc6Epq0/GrkSENSzNb0NIolhHTqHKZRwspzkgrFjKa58y6Xv6O9COMHScUEdJ5/kY7U+dyi4DrJu7/qOvLk1R24fR/jXN4hkRUzqZLL+eu7hBZ/AmDOPyQmltstbFvo61P2ZYmoAShQFgQ8f/9mgrXGhOhlqb9IyNIM6P39MX8YtQFjh/tn7aRZ/+iz6ifKKXQrLZhaKOE7p12i78QCxzdttINGvmdHOoTiVaLtGSx63a9oXbR6nyTGtSQHX4o3pdV+tukMNVrKUHKMqepjeDUrDnpn9O1DlsT2NnLd0J8a95HLC0VNfJe/12fYdMRliuakaoplEzMg2MGRt32BiIJDCbSWUKCJAkSfpOQok8qszq0Uqoy+Q0elDBAZUgm6hU0QbDerDy57M/Z1XLYnXUTKU/Sg/DTX/cmhc8Qu3LZXFRap7fkRctpwtyuLWmfUNL6ur4AVpj5TrXrin49lTVL0qrmsRWuMFwP6yZohPHXHnbiQp3Xb7z7sPnecXo0oU+XikuycvaWZDRCuXXfmMBCr23/M8kPj+Lidj/v82cwZYo3LWLFewiN4InvEYZgO8HCCG4P0La5gumcoN2xOenIDCYPXEi07VJXCzfKwyblnsisoLnmUFxKn3nMEfiu7Yzi7meVv4Hs9bEedqDHJA4Wh7apkPCOxdtvhxiSuY2L7FHwld6jVbQ3Wj+xi4/KRKr6QnG0/Qa896EuUk3YNI42C9v9/vU3UFm9SnBwS+kxCN6HG4BZ63Dugd4IkZTYsfkQhfJs8rJAu//FIhP/asA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(396003)(376002)(39850400004)(346002)(6506007)(6512007)(26005)(52116002)(53546011)(186003)(2616005)(44832011)(4744005)(7416002)(8936002)(5660300002)(36756003)(31686004)(31696002)(86362001)(6486002)(478600001)(41300700001)(6666004)(38350700002)(8676002)(66476007)(66556008)(66946007)(2906002)(6916009)(54906003)(316002)(4326008)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEsxbzlmam43NFZYeGc1RmsxY1VHWDBHWE1lQnRMWXdmdmdoSnZoMzJBVnpV?=
 =?utf-8?B?WjJLZ0dleEI3bHBvSUdsOWhLSFRrb0hkL1Vrb3RJWG9XWEZaRXVrRzQ3Ullk?=
 =?utf-8?B?V0FaeW9UblBxM0ZiKzBxN3FUbTljLzBBQUgxam54VkFCSkV2eHNzRjNhb2ZX?=
 =?utf-8?B?QTMzREhvWjRIZVBPNU1aa0kwbW1TMFpPZktjRVlyV3QwK1NIZVhrMkVNVDg4?=
 =?utf-8?B?NGNyd0cvR2d5TjJrdHdxclIzd2lGMEdTSnl6eUdNZG9OcnpTMjd5RmJFU3Rv?=
 =?utf-8?B?V2tjcC9PdHN4emR6YytIZmZGc2tIMFUrNEZBcDFUMkhyMnBlVWx1TVUrU3NZ?=
 =?utf-8?B?TVF5Snd4d3lqS3BKNmwxTXlGU0JPTHBjNG91NFNUcXROZ3FaVkhqSWMyeHI0?=
 =?utf-8?B?VDVtQXhFaS9ZQ05mU1JybWVLQ0dqZHk2WE9WWktEUngrOTJQM0IyR1BFeFg2?=
 =?utf-8?B?TEtoRUcvWGZ0bHNUcmQyNDRGMmpvL0ZqaWVwUWxnK0tCaWs3NHcxYU11VHNG?=
 =?utf-8?B?VlZkYTRYQ1Y4c0xGSDl6bFFTeVpHMkxkL3ltNWtHUHVpdStOaWF5bUJjQ2ly?=
 =?utf-8?B?MU1JYjU2TEw3d2pzNEhrdDBSdXpJTVo3cnNub3kzTlh2UlNIZDZSVjltMWdo?=
 =?utf-8?B?UmlMeG4zcW9IRXZ6LzRpM2V0QktNd0xxeDB6SXhvMW1CdHFtdjJWM21QbjN4?=
 =?utf-8?B?b1J6SGwzM1lIWERzZExUdWcremVUS2JCQmIrRTMrcTFFTWhFZUlIVk5TQ1lu?=
 =?utf-8?B?UnkybGEzQWd2S0tiNnFBQkNHMjJpSTdVWjJsNG5pSlRDNnR5TjROdmpjMG1U?=
 =?utf-8?B?Nmw3NGVHdDJ1RWk0QkFncjJ3ZmZ2Zm50VitoOVluck9hY0xGZzUwVFU0OGJS?=
 =?utf-8?B?WStJVDI4bjNoMWgyRW1QNWw2ejZqN2QwU1Bsb2QvOTlpYnFxTjRZR016a2hv?=
 =?utf-8?B?VWhnNVB1b3ZlRWd2dXJMNi9Wa3JqMGVUdFRLOGtybm5TVGRFako5ZXJLSzBl?=
 =?utf-8?B?aFBBaWsyY1RLaUh2K1VubEJlV2thTzNzM2JLbnZ5eUc3Q1JWSkpVYjcrNm10?=
 =?utf-8?B?dko0V0pTeC9qb2lVdjd4NUpkMWNhUUZ1alhnYlFkQTNGbHRQOExaQjZFbmJ3?=
 =?utf-8?B?M29kT0dDVTI4djFENWxseTZ4MUkyUE4wb1A1UGM3VHJWcFpNWjRWR1VYNUZn?=
 =?utf-8?B?MitnczJLb3JhUUowV1gyUkpOQVppN0RsSnNrUDJuYmtsOExLc1BsMXBXL0pT?=
 =?utf-8?B?c3QyT3RBR25SZDc1YzVIVjc3OGtCWDNwL1IxWjlGbGU0cnFVa2tCMHF2b2xB?=
 =?utf-8?B?RE4yU0IyYzdJK0piWmxuNVFYUkY3WHUvR0xUYkpBTUZnUzdsMjg5bGx0Y0sw?=
 =?utf-8?B?K2NkNHBZbFNGZlBEVDM0VDAvem1Nd1lRcmtoem5BMFBMSkYzcHZESWJKUElx?=
 =?utf-8?B?dE5icFdhVFRKOUJZVXNyZE1ZNW10QzkzUW4weW5tYjI3dERuaWZWa1Q1RnVB?=
 =?utf-8?B?VldCcVJRMjdUKzQ0dGN0WVpicWsyZmkwYmRSWTBXQWk1eVE4a2ozbkpLUFNK?=
 =?utf-8?B?Y29ReHFub25DNndVSjl0TktYb1o2RkhKM21QM0pCUUZrSi9UUEFKTDE2MTRx?=
 =?utf-8?B?MXBBZHVmdFA5cmppUkVsSVdyL3NFRStoOWpnbzZSY21JcGRMZ3VId3BNcDNW?=
 =?utf-8?B?cUo0bXU4OFJQejRjRXgwVTQ2YW1KUFJmelNZc2lWcElpWHBIc3ZDSkFCNVla?=
 =?utf-8?B?VUpRaEN0U3hQT2VYaGIvU0FQRjlJRFVTWktnaTlnY3BtaWs3bGFxaHNVbEoy?=
 =?utf-8?B?UHdIaWRYRjh4SGc4cXhoM0ZGVUtDaURhRll2V3M0YzNlZlJtWVdNOEJ4V2hX?=
 =?utf-8?B?VkNaajZWMTFIVlZYY1g3WTRmU2kwcHJNVWxwb3VKRzJMOEZUb3NXTVJVeTR6?=
 =?utf-8?B?VDVWL2NHanduQlpYNUFKZ2tNeDNpa1pUU3lkaDZGOU5VelhBcndGQVZ0U3RE?=
 =?utf-8?B?cnRKNnRKQUljK1o1bWtVK1hkY2Zqc0dpS1N5YTYxRElMcGR2bUpJaE8yYmJt?=
 =?utf-8?B?WlR4Vitia2pwTWJCTUNZcUhSRndtZWhnMlc1d2p6YjY0Z2Mvenk3N2ZJK1k3?=
 =?utf-8?B?VGxra1pscFhqdkhXc2hXY1FOeU43WlN2U3I1S1JId2F0VGNtbm1YOHZCMUtE?=
 =?utf-8?B?Unc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8278d89-342f-4b06-2932-08da8d2aa834
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:32:37.8198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B01/UABbp4lLU9W6/mQ7fLJSa5nXzMHftxcjZ1eqJmYIlQBtdpWmVmZ5L+y1oyBrFY9TcgF7Mbifc6DhfytJ1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2265
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 8/18/22 3:28 PM, Jakub Kicinski wrote:
> On Thu, 18 Aug 2022 15:14:04 -0400 Sean Anderson wrote:
>> > Ack, no question. I'm trying to tell you got to actually get stuff in.
>> > It's the first week after the merge window and people are dumping code
>> > the had written over the dead time on the list, while some reviewers
>> > and maintainers are still on their summer vacation. So being
>> > considerate is even more important than normally.  
>> 
>> OK, so perhaps a nice place to split the series is after patch 11. If
>> you would like to review/apply a set of <15 patches, that is the place
>> to break things. I can of course resend again with just those, if that's
>> what I need to do to get these applied.
> 
> Mm, okay, let's give folks the customary 24h to object, otherwise I'll
> pull in the first 11 tomorrow.

OK, it's been around two weeks. Aside from one bugfix (thanks Dan), there
has been no further feedback on this series. Can we apply the second half?

--Sean
