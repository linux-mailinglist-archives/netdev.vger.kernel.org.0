Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E053755D9
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 16:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbhEFOqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 10:46:43 -0400
Received: from mail-db8eur05on2104.outbound.protection.outlook.com ([40.107.20.104]:53728
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234759AbhEFOqn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 10:46:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dnFHV8mo+jHoQ6UkYdDtUCG8rTuMT+Y02HDcqB8k0L/jRJeJJjXjMgrFgXfi3or4RUiBpn4t3Dj0GAGZ3ZUQWguzsmLq+/MK2h8eS4AKgRR6t8DgnPWGolZgN1NO51mnmrivHNWHs8kGc52GKsXcM7QFWOA9BbDhwSC8ZA+mk4/Na0EzbsIg+M3hxMXuLU/Q0Ueuj75e0pH6oJmLArUKHM8ffcsyJGsfMcdHq1FRQyYHsllzPEIkqLYdlosbTBPmKyHFjPSwxJ3QCjgPSnxU7F6VUwUMRYwHUFDP0tifOypEbrT2u9oLzBdStmyPgYEwJiUX+plZE+E/Hi3amwj/nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arMt/mw3wVlE6zOKEHlG/Qc4XZsAIrM6LZT3Dy4hUhw=;
 b=KB3m9qjVr387EYjeQH41qlrNH6zuJPzMcouH1/vZ8ANa/7yn8VKIYeZVDer0AHx60PTsAGxGpSkcdH5ZiQRsIWfwN7+hpxX8eBn3q5Jt9fekKPj05YibUBFeg8pu6l/txTVYOPdPa2SnxV/U3j+4KDmSc5MSE1rZJdW5h2ES0JygM8Yn1lI/t3XODiHCb4Q1uaCuawJYuiLXD0jvUCpLVD66tDiBKPuLEZFHSsRlzIDXutHE4Q+BQch68lNm+mPRoVy0Y5ZSOkdp2UuyeGk5RCnxu6TRl24i87rulsbDJQyVTQpTDicnuVJPyRuloeARFdFEAE1O7WC+Sq3ZYsog/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arMt/mw3wVlE6zOKEHlG/Qc4XZsAIrM6LZT3Dy4hUhw=;
 b=R3GfeRHY3OZ5/QaT3QAV983jwgT7CPjd28f7MhpC7yi2olxD/id/45HEj6x7vmpXT12NHTpO7yzw+sTUFPhQUcXc4kfvz5w0Ip964BNLvvCfgr7InheuYl7aJrsGPxxI9FaDtLIL0PhmjcrvgZJ2zoFLtzSRg1vpGjypLsIkCpY=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM4PR1001MB1364.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:96::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Thu, 6 May
 2021 14:45:41 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4108.026; Thu, 6 May 2021
 14:45:41 +0000
To:     NXP Linux Team <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Subject: i.MX8MM Ethernet TX Bandwidth Fluctuations
Message-ID: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
Date:   Thu, 6 May 2021 16:45:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.244.180.42]
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.27] (89.244.180.42) by BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.9 via Frontend Transport; Thu, 6 May 2021 14:45:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bce4c713-8a6d-487d-5394-08d9109d9e8c
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1364:
X-Microsoft-Antispam-PRVS: <AM4PR1001MB1364FD7801EFB8BB59DD455FE9589@AM4PR1001MB1364.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8VgSkR82/0b54XO2/e2oZv/mjdlTr1KLNlExUdQrRLg5UTjx0iEPGkOBvNkaa+6c1rewZ8Fgfh4nKOsShV2g3y2Sfk5Nj4DWmNNkFK5iC1u/L0xRVSCRez9lu8XYj9UshiSWVSmK/7SuBBuWeQttAeUgMj5HFl443+LBSKj0d4V4AD3ZzK9wOBkBJZ0fEaRb/hOktuPlgyeHpPrMNR9uO1x6mFhu1QGDD+qen8xphEACEw/Ep3BUwHYrNfFfki973783atuS0zSdPEnpXhhxRx+Q+KBeojVhNt8OQ0Aie3UmzFqE1jsfiAJ6uI5ChTBUjU3pyuCBdKQm+GUKKUTyT82DsOlsUQtEW/J4Ff3DnMYdezfICVFdmbOrIXk07Dg1CRoVZUXL1PiD/EV6rqsjVV9DOEJocICV4h1GObZQfdoslwktYjHOzrgzraEwo2JOw7+w9Ozt04lWkzVswVV6hlRzrU2clpprl3Rx0ymqHQZZZTYrU1PgzXz6+LBNV+BgTmoYlxOLvxsw6RK2AyaHLEYdeVjYK7XviYBi2gvf4P0fA0nfC+UoOD+En/LZ6T5aRFAIUOvYVNAsWKgATlu5JRuxHVx0EFi+aeq6kvDc2UmD5tg3T48fFSR4H9yrxAbM5VGut1+WIUf0C7zTLuEr0nranLdm5LlEOMdRaB+Te3PnUTpnwcDJCNNC5Y/8EeLJkfRw8VQ/I4GOJ5KWeZxrvDuF5bWLMaPtjy/6msxbtu0f8O8zYjtCbvN0mwPZegM1BkjwuZtQt1m9AUnKPTvoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(8936002)(5660300002)(66946007)(478600001)(66556008)(66476007)(26005)(31696002)(31686004)(186003)(8676002)(110136005)(36756003)(16576012)(16526019)(956004)(38100700002)(316002)(86362001)(6486002)(44832011)(966005)(2906002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b0p5SzlOVTcyeG56MmFlYWFHbGRPeG5nSmhNZWUwSXRzUGVQTkV4MGNITkdV?=
 =?utf-8?B?YVZua0dic0lSbDBycm1tN3k4blkzSkM3MEdBNi9iWFJpMXJkd0JVU09yR3Nu?=
 =?utf-8?B?c1VIUkxuekFYOHNYRktMUm9BNjZUbXRKcVhoYm1ESkRWYTdFUnRoNnRqWXNO?=
 =?utf-8?B?M2Jnd3c4a21XcXZ0bjBiYU9qRTErYjlEVGNoVHJvYnpXNTFhRW5ZSlNCWWV5?=
 =?utf-8?B?V2Jlb1hNQm85MW1UeThGQVl5akp0QU91ZHh2K0ZCOUFlY01zUDArRDVjMmc5?=
 =?utf-8?B?cXU0T09maVJsSkF4Z0FxeHhPaW53M2drQ2FGV2JxaEVpRXVqZVNVckk0V2FU?=
 =?utf-8?B?YlZ3d2k2WmNrODdyaFFrOU9yYUV0cDRBSlQybmlBbnpSV21oYXZYZlRlSWxv?=
 =?utf-8?B?N2VpM0lpRjdRRUliejlGN2V2aENMb01aWERBcGhLUDlxNEx3RlBKdTI1cXFr?=
 =?utf-8?B?eUNxdmVGaGpPQ05Fb0tBWklORmdDcTNORDZvQmVQQWl5Vk4zOWVPVWJmYXox?=
 =?utf-8?B?aHBFNExFVmRUMlhUT2pqT1llVkZEYjZEWk1YUlFvbnhzemhWQ2hKRUVqWitH?=
 =?utf-8?B?TGNvL1dtaC9LaFBzbklOdmpCSVZ4Z0FqVDdIR1ZLKzZlejZzYjdudk1vQktk?=
 =?utf-8?B?eFYzVkJycVVtYThnOTN1OFAwYWxJbnphSnVEaHY4WjJsQlA1V0RFeFZDN2to?=
 =?utf-8?B?N2pUcXpja3k4Rmtoc283bVhRd3pWUDFMeEVxRjZ5eXBtTnZBQURCeW8wRGJD?=
 =?utf-8?B?RVJHbkpLYXBhQzdad2ZjTXNqNFNvQ1czYlpGZ1JXVDhZV1NkeEpIUks0TWRv?=
 =?utf-8?B?OEozaTFmelF2Wnh1cFhIU1N3Z3hOKytNYmRBckh5K3p0a3BYWnZSbitzQmta?=
 =?utf-8?B?cE9ER3pBa1hLSWxVNFVWV1MxdFp2YnFxem1FTnJmU3RMS282cDlCMDJkQlh0?=
 =?utf-8?B?S1NjdzB1NlFMNm8xaS9mVVllbWlFaXdsVllXQmhZMy9NZCt0eVI5SE9na3Zw?=
 =?utf-8?B?VjdOOEpiN0c4VXpjMHhzVGVOUDJidXlDVXA5ZDBWVDlpa2VueXQrdGQ4M0ZF?=
 =?utf-8?B?VEZocS9HblpmenNwTU4rdEI3eHZubzJ2SVNjcS9Gd0xPMkpTMUdudjJ2TzAr?=
 =?utf-8?B?eDlFOUw5OHltQ0RmZkNKQlVvdnU5cVN6bHdqKzhRWTFuZlh3aWFnRmlsSytt?=
 =?utf-8?B?Ymo4SXpuNnNYRVdGaFZ4bHdIYTZFdDJ3Zlp2VzhBVFgxTERNajRSSU5LVFp1?=
 =?utf-8?B?N1ZySFRoQ3VFYnB5ZU0xWTA1aWd3UE1lTklEWG16Z1NpQlNtOUV6UStqeStp?=
 =?utf-8?B?LzZJdjZUOXBIRTREdW1uOGRnOEhtM3hVcmR3dXhVOE5vQlRnTEtIR2Z1TkZE?=
 =?utf-8?B?S1l3WGxTQXFtWXhYd1duY3pMWlE0YmRpT3hEQ21sSWNKVldLTE90aXVDQzNy?=
 =?utf-8?B?a3U2KzEyWFJsa2tjOGtHdXROV1BiTSsyUGExOElsTjhJY1RHaCtzZkttSFNm?=
 =?utf-8?B?dVJDTTV5MWlWenB0ZHFmN2ZqQlNwUmlJajBVajREbjdJb3lVb1dwOXhkU3hF?=
 =?utf-8?B?bEc3ZDB1SVEweHM2aEpjREhVMk13c1VheVYxNktSbXJuQnR2ZkYvbW9YVzNG?=
 =?utf-8?B?cEdsQXhVTkhjUndnRE8zQ0xtblp2aWFwWUlYTi9RdjdsTytrTytHenNtOXlz?=
 =?utf-8?B?OVpza2tWcDF3S29nb2o4dHFBNmRMT20wY3k2Z3drd05nREl4UGI1U3hpQ0xW?=
 =?utf-8?Q?ObX+RLsb8sZ/PackOGuF6BAastI0A1huZUzew3s?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: bce4c713-8a6d-487d-5394-08d9109d9e8c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 14:45:40.9360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vng/j8vqXIQ2Yrzjo47PwiuEVpXxBriP6I9f0GuvvMK/MVjBfdPbXhHYDxID2ajEH+/Eru1YPlzFfMPdvyzu1ZWMajPoozqfI3GwQPPJXg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1364
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

we observed some weird phenomenon with the Ethernet on our i.MX8M-Mini boards. It happens quite often that the measured bandwidth in TX direction drops from its expected/nominal value to something like 50% (for 100M) or ~67% (for 1G) connections.

So far we reproduced this with two different hardware designs using two different PHYs (RGMII VSC8531 and RMII KSZ8081), two different kernel versions (v5.4 and v5.10) and link speeds of 100M and 1G.

To measure the throughput we simply run iperf3 on the target (with a short p2p connection to the host PC) like this:

	iperf3 -c 192.168.1.10 --bidir

But even something more simple like this can be used to get the info (with 'nc -l -p 1122 > /dev/null' running on the host):

	dd if=/dev/zero bs=10M count=1 | nc 192.168.1.10 1122

The results fluctuate between each test run and are sometimes 'good' (e.g. ~90 MBit/s for 100M link) and sometimes 'bad' (e.g. ~45 MBit/s for 100M link).
There is nothing else running on the system in parallel. Some more info is also available in this post: [1].

If there's anyone around who has an idea on what might be the reason for this, please let me know!
Or maybe someone would be willing to do a quick test on his own hardware. That would also be highly appreciated!

Thanks and best regards
Frieder

[1]: https://community.nxp.com/t5/i-MX-Processors/i-MX8MM-Ethernet-TX-Bandwidth-Fluctuations/m-p/1242467#M170563
