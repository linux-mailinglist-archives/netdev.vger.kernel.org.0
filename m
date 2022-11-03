Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFE3617E7A
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 14:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiKCN4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 09:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiKCNz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 09:55:58 -0400
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141B814022
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 06:55:55 -0700 (PDT)
Received: from 104.47.18.110_.trendmicro.com (unknown [172.21.205.29])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 4510B1000174F;
        Thu,  3 Nov 2022 13:55:54 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1667483753.158000
X-TM-MAIL-UUID: 87702ad0-36bb-437f-9c94-b35473ff1e72
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (unknown [104.47.18.110])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 26C4310002943;
        Thu,  3 Nov 2022 13:55:53 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1cB8UzTRN0vijSTPGhQqgAWY/DK+yMHp//oq6FVEUKov0x24tmBgzWNWN5PDgfRFJQcBsqEEM7otr8zp8nUmnudFDPjhaLMeLfO3l/n7a/lo8OM5FaeImggNoUVGjybXL0pb8O74A0r/IMazlfqQnKdBLrBBQt4wX5x6g/LBXOznk7xDD1UF0vIDLFBXPCBgTUbhv9wXBLxKew6qlNeICGtzPXqdga42WRhRSAMuKjOFO/6aY8hy+U8c2NhP65B1z1g+PTacLMXXHskdDIOKUk6Y008SXIyDvDJCWtJ63uB/FTx+U3j/H6KpF21O2fngxc3RC8SzUvC6gSWvWIxsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iwRakG5A0biZSpGhfbUMiGOIb4iPEuQjclWFGJsPXz8=;
 b=OyrBYBCdBZ9pbjm80JTqvsPs/RksNxUIVo1ofpoo8hA0Bg9/lmqWMCHFcuzbDBdbpiYZHKt4n6ZUX0FXVV2VL/S7EDHeAsckwfi66hu8TrrggCA3r2J1a4sf47MNVlVOgyPBF6eC9JJpfRn/eiKeSHM/VrFBadJSBdZT0p1nvv4WG3QQ9oJ19pAKPwRm4HZEef7KNB4uDcfjihyFsckHHFaVvc2YV3cYO9K4zHvwVffH20j5HIAyhvxjXls2d7rA3kPQJcYObwL2Mer84P8YlcU2IQblcyMq3Z89H9a/1kMc8N5nTT0cNoo4R7YAosipgwtg7Nw8XnqCvExWM8klsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <40e3d678-b840-e780-c1da-367000724f69@opensynergy.com>
Date:   Thu, 3 Nov 2022 14:55:49 +0100
Subject: Re: [RFC PATCH 1/1] can: virtio: Initial virtio CAN driver.
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Harald Mommer <harald.mommer@opensynergy.com>
Cc:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
 <20220827093909.ag3zi7k525k4zuqq@pengutronix.de>
From:   Harald Mommer <hmo@opensynergy.com>
In-Reply-To: <20220827093909.ag3zi7k525k4zuqq@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE1P281CA0038.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::17) To VI1PR04MB4352.eurprd04.prod.outlook.com
 (2603:10a6:803:4a::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB4352:EE_|DBBPR04MB7626:EE_
X-MS-Office365-Filtering-Correlation-Id: 89b4fd35-0339-40c5-99e0-08dabda31e0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L9xPApqOu8QjasUNllu+77mmeuulVBRF0WRY2OAVtgSp3G0/NPvDZrCVYdBg0m52Rmk09AaIpG8NpTBHZyRj6tPhbZZoN6MOSO7W/IfzOn8fLiKHwS1n/39J3YnAOBA6ia6xy/rGfam6edoi5nUKl6MGQxc+IbEvLfMk6mJnpMvsECEJGRW/ViMiF+7PZ01umhkck1pb9C1dMqsOgEX3LXIyRkoEEUwV8dQRRd4dJ13RPsgGy1YG7QmLC3lJtMWdlSJOcmY48/60Wj6PBeZ9k4uA63dwgm67U9KOQdKPsgR1YehqnGgO522zvxO7TlGaC1Y42oglAycGAI2z57FRbn7aXM7pUKuM+H9sPFSwcHOkIlW5jBEIeVPHIg3kwSiUrYuG9EIYO/CZEwoKkXt70ms9wnMBcwghFThUDHnWgMpi6ZK1oBDyU3x27YabKGh8ShWjjWMLqjbICi1OwKi90KuF5TkQgBFvlAsZ0pzxVjBUFLSANB8tmIb7Hg/ZIQxtG/yG60GZy/+bZjYiarIs7AD/wiF0ZbD3B28pDnIA8zx6qizW15PLI64eZhcymmgN5YAObOcgoMymZDyiTO1Ex+30Ut8lwcKoayYO6IFiB241pVYf4wDp/gIcgPGLSJ2BbO0Kmc07BKd0XKcEa2CQdK8g63sL4rVi+rT4/znGQcIa4blYpbfyCbAdm5nU31g6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4352.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39840400004)(396003)(136003)(346002)(376002)(451199015)(2616005)(110136005)(26005)(53546011)(316002)(186003)(6636002)(42186006)(83380400001)(54906003)(107886003)(478600001)(4744005)(38100700002)(8676002)(8936002)(41300700001)(66556008)(4326008)(66946007)(2906002)(31686004)(7416002)(5660300002)(36756003)(66476007)(31696002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXo2ZGpjOGZHVlZ1YjlxaVB6ZzBtQmEyOVBacGNkZVE5ZGJkN0JSczY5WDMv?=
 =?utf-8?B?aXJqRGk3RGozWDVteExNanVSTGgvUTd0NEdzdFpjUWFkS0x4R21leGt0Skwx?=
 =?utf-8?B?RjRrVUZFLzlMNlYyOTIwNkpacEJhRkJQVE1sMFVXZkl5dkdaN1hQLzVYUTZX?=
 =?utf-8?B?YjBOeitteTBobTNQYWVUOERFMVR3TzVHZnBHVVU5ZUViajJsU2U2SWlmWi9K?=
 =?utf-8?B?U2p6Uy9mSTk4RCsrNFlRK3pNeGt6UFplWGdVSmZJaDhlbFhzWHhJemxML29q?=
 =?utf-8?B?aDV2WmZsc2JXbjdxb2hpcUFEOGYxUVBlcHFYSnk4WDIxQytIUDR1VGp1ejlI?=
 =?utf-8?B?V0VHa0pvdnVLWHV5aEtER3ZkU3JMeVJzTnZ3YitlcVdSd1FRSUFtbDFPRURl?=
 =?utf-8?B?VWtQV3V4VFhBNjB0Z1JFcndyZGcvUS9ZODNQaXpXeVd4YWtWM1NzRTN4RU5h?=
 =?utf-8?B?M1NHZmNaa3A4MkUvQWNMYmZ4SmFpZXZnb2FyOU4vR0VSdHpibjc0QzB4VS80?=
 =?utf-8?B?UWxBRkhHN1dlWUd6M0FSOEkwdys1eW4yK0RkWEpqcFB4UWg4OFBoVjZONTZo?=
 =?utf-8?B?eWYxN0wwZW9vNDhHWVBkcHQvUzlxNHVMWDF3SkhXNEVCNXIxa0RVOTVWdW5J?=
 =?utf-8?B?dFY4dUs5Zll4ckQ4bDZTVy9wdkdNTFRxNUZVYk5ENGQxN29rVmtyaWQybXNP?=
 =?utf-8?B?NXNLZnF1TWM2ZzF5L0RZTkVNS2xoWkYyOXk1UENydEhQVGNqb0I0Y2pSQWw4?=
 =?utf-8?B?Ym53ZWdjbUphMUsxL09OazJzOGlhazQrWHl6anhJZGMyclpxTjBRY1F1aG9r?=
 =?utf-8?B?TG9XdFZWbksrbldzRndGVmZnN2d2UHc4VmhrYUgwL3RSZFVSK3Q3OHFLc0lE?=
 =?utf-8?B?WDB0Tk1WaUFMOE9reHNuZEtueS9HQ01EWVdleEFXWjNCZzlRQlE3RjRYVWRl?=
 =?utf-8?B?VE1YT3hqNXlvamlCVE83WGt1QVZlK1FVZ0xxQzBHNG12djVETWgrcm1CR0Zj?=
 =?utf-8?B?UE9VZ1hCMkxkbXlkeFlNbmo1aWdJRGFkdk1CbENqM2hDNzRxdk9aN0Flb3dB?=
 =?utf-8?B?b3VCYld4aU9DVUJIR0djT1VJejhuZCtuMFdhaDhhR2tGdWhOM1RPTDlmVGtU?=
 =?utf-8?B?RmpTVkhUSnBPR2UycENOMXM4bE1QVEl2V3ZPd0ZxbWJ2T3dhL3gyUUk2OWhl?=
 =?utf-8?B?azhyYjU4YlJFaFVGNEdBczJmN2JiSDIxVm8rRVZnbitiQU5GckhiR0Z6QjBm?=
 =?utf-8?B?N2lnbjFVR1h5UUkvaHhzbkJtNnkyQVVnMkVvaFQ0VXVtODdoMDFiQTVZSXpQ?=
 =?utf-8?B?djJqZ29Uc1hTKzRQaG9UR1VFNWYxSHVjRHAxR0NzbDRQcmVVT0dkdlRsZzQ0?=
 =?utf-8?B?N1ZnMitQbDBVQ1BVckNST1FFM3c3Sy9NVUsyRTErdi92T3dMaFQ2TjdsRCt6?=
 =?utf-8?B?cnFoL05ReDlneGdGd2oxR1p2dTlmaHVkVDdheVNhaXRCTEdGWW5Kdi9IVUZ0?=
 =?utf-8?B?RFpiNW1Pa0x2SUZWaVNJTDdpMFJ0bWtldExNQ1JBQ1hWR3VXdkxKN2lMWUgw?=
 =?utf-8?B?SmVmZDdvSkdYb0liOURCaWdzRDhwZzNyOVoySGpubVFNSDJCNTBSOG9RaE1I?=
 =?utf-8?B?UEdaeDJWcVpnVFQxZk5ueHl0dUNVM0Zhd291dHVFUmFrbUtDdThvQmRFU25n?=
 =?utf-8?B?Rzc1RlJWK1BOWmY2TU50QmR4MFFnd1Y1NzNRb2tiM3k4YzRiN011aC84UHRW?=
 =?utf-8?B?cSt1ZEdZY2ZKeE8weVlaUGFmZVJxRWoxa0tCeVlnV2xyRmJxTHd3ZUhFOTEx?=
 =?utf-8?B?aFFrRlQzazIrVGRlM05VRXM5VEsxYUxzTC9UbG5rSlFscStVVkMvNFcyeEpi?=
 =?utf-8?B?cHB1c1d5UjBhWlN0ZXFnVFRmN1VSaHVlKysrcmcybXlHVDF1TjN3MUtqZVhT?=
 =?utf-8?B?UWlyckt0WG1xZ3hOSEw4dHNoOE1XWTMyK0hza3Q3aHA2MUt6ZkxMZnRlZmpJ?=
 =?utf-8?B?dUhtdHBNdmJNQzdzMFRPMmV1em1UWS9rTFJ2MnVkSnphUDJ0U1BRSk5sRzAr?=
 =?utf-8?B?YlhSaHYyYU0zRm9jZE1KR0VVdnZ1c085SXFhakhlS0w3ZU44S2FZWFhBT0RS?=
 =?utf-8?Q?tmxJ9y7RfqxNX/KrdpU9xyIT+?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b4fd35-0339-40c5-99e0-08dabda31e0f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4352.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 13:55:50.9410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hB0fvT3LrPcyZAartBw8pEuBxV6Snz/a3aQppujD21zsrAFhMqj+vrYFJH6NpHFxIuzZCWmqFpLHKyWnebj02w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7626
X-TM-AS-ERS: 104.47.18.110-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.0.1006-27240.007
X-TMASE-Result: 10--9.073100-4.000000
X-TMASE-MatchedRID: scwq2vQP8OGwzFuyya2WsK5i3jK3KDOoC/ExpXrHizzDqO6/8R69QDy7
        zxidHhYpceyfeJ3+b5yrlBPOoG5/+mMNX/9K+QfeKsurITpSv+PYjw1QqLfrRlp6v7WJomQQ0g2
        9rlyDgeZzwb9qaRe4kznanZX3BevfYLmTo2ikrFhbKUNQk650Hb8pAYpAfWtAUV7F0kclfoLKse
        rwLhBtWxz8ZXwvG5ffuXFEQJaCEz5Nfs8n85Te8oMbH85DUZXyYxU/PH+vZxv6C0ePs7A07Y6HM
        5rqDwqt8vIo/swojrhqUiXJIvZQRWXtHqIpAbE4XXDPI+QVWIaFT0hWkhTT0g==
X-TMASE-XGENCLOUD: 92539c31-4b35-4a5a-99a5-76317ea19802-0-0-200-0
X-TM-Deliver-Signature: C91A334149CFFBD25F8C42A8AD5B59DB
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1667483754;
        bh=mFhArZiOB1ICjmPE/1sfWXlwB6eAA4Mn91DeHggw+Ug=; l=843;
        h=Date:To:From;
        b=AxV6idlYMX2X51G4sY80cFJ9upkrtGVJ+AXzcK6TesrZemodcMIzW07b3REQeMh3r
         kqj7AgPnThYIKu+21YfBDKSBXaQ3bVNfNwiD70NOBq492IHAMwmqy3sHAOAXD+uyvU
         z98zq/vaMktkx7xfb0Y2pYS+sudiVUWEqjulqOI9bEKyoRefZW8ArzsTI5XyEBDoJP
         18IeHfBsYhCjc9/NA46m0A4f+YH7iFNouZtMeGiLWXjuotDK06OBv7uIXKhhiH08pW
         8oG/9nPS02WhJya4bzDsoFmTD+4DE7RZ8n4LfIVl9TfSDD5Aa6tjCHNbxhgUmrlQXU
         fh1yb03EEKCiQ==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 27.08.22 11:39, Marc Kleine-Budde wrote:
> Is there an Open Source implementation of the host side of this
> interface?
there is neither an open source device nor is it currently planned. The 
device I'm developing is closed source.
> Please fix these checkpatch warnings:
>
> | WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> | #65:
> | new file mode 100644
> |
Addressed most of the checkpatch warnings. Regarding the BUG_ON() 
minimized usage. Removed where not necessary, reworked where a better 
error handling was possible, kept where I don't think it will catch ever 
but if it catches I would like to know. Of course I could make the tool 
happy but on the other hand I don't want to fly completely blind in case 
a bug has to be hunted.
> regards,
> Marc

Regards
Harald


