Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039B860AF26
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 17:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiJXPhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 11:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiJXPhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 11:37:21 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3A93DBE1
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 07:25:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDLc/zosvteVryUuVvMB1nydxM3JCfsnh0Wo905oJYFZnGnGb2mzlIimyO4P5+Akie7kZ40NB8F0S4P4cubJ5ligrXRenPIi6OZhzdVLvq18rZAhuzvfbMq/7nVzg63s/aDbT1h95piOq2iKfeSnXjgkLHgtqXN3JlWTP/NiUkO+xOvO+ri+uiJ+4iuHs+h5waM6M9psKZQmayqyFOqGIRRN1PrDmMV1ieajnAYtRVETTplSPROt14Df+SZijyFAIT1LEY14cFoD7kYMYmNDDxDHmp2JwLyxMpQKVqkDBq8twHpSeqqe6j8/IJEe9g/6NBlSqyhGn23x7Wdt7jlFwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jlSCO+MC8FICIvJHMcX2KNPiSqxLU9wkJERhC478XiI=;
 b=ll3vjWIOb5joAzCh80MOW4YBe6bBU9ZE7Swo7jRnutv5bzKqFYrejUKpp6tIcYe6IZksY12RrWe6MYxiAM9Zys87LoXEBNrTGBdlxXKAwdwoZKy46QKjWbJ1xFcMElLcyV5IbVf8OyNiZerF30+Pvr3jS7TOgZ40r3yDx/PMAnb92gqtPfnVPmb7VoPUGYXRTZ9lEkaSpMdqqvEW+I/Dfb6uaUZMqdSZZLvXYpO5UjKYJ3CrcqXYCpc3HSEwMfxtvTLf6PkAnAXNPpKco3KmYpzMm4yJIs1qrmtlN7SOdkYynE55yTleIfeFIjTJzneQbmq9hXZk9ZtX8OKx5UaMcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlSCO+MC8FICIvJHMcX2KNPiSqxLU9wkJERhC478XiI=;
 b=ZM4CeZEv60k91msgFWPvfO8kAmFx32K6PJvXEeNy7PzcQvgCu2DUKTaW0NszREtheyhZQMQAKXtOtGROTC7PoynPohTlUVKpfwCa3qaiLu0+PV6pqKfY7qte9epIJFempANAIILrdihNZL63KpI1h2FddaOorH7idvBfqKCT3kA4Tf6jIh9XIQv0sSZyMn7WTbmJgk74dWPSGtdmlUfQA2s+5A5Nh9YI/e0FeXtY6akA7S8sFdCMAXpxHYW8f6POS0u3VpWGiTARU6lQkHD9mxVQb0IiDmhJRZ1cyTxSefRiIZvnIFVxVwMYE1Vx9HHkLomDrJ+jYNgr5h9THg2Glw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 SJ0PR12MB7036.namprd12.prod.outlook.com (2603:10b6:a03:483::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Mon, 24 Oct
 2022 13:40:00 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::1926:baf5:ba03:cd6]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::1926:baf5:ba03:cd6%3]) with mapi id 15.20.5723.032; Mon, 24 Oct 2022
 13:40:00 +0000
Message-ID: <f89ea424-1dd5-f097-a79d-e69ff61f73ab@nvidia.com>
Date:   Mon, 24 Oct 2022 16:39:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [v2 net-next PATCH 0/2] Add ethtool support for completion queue
 event size
Content-Language: en-US
To:     Subbaraya Sundeep <sbhatta@marvell.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, sundeep.lkml@gmail.com
Cc:     hkelam@marvell.com, gakula@marvell.com, sgoutham@marvell.com
References: <1645555153-4932-1-git-send-email-sbhatta@marvell.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <1645555153-4932-1-git-send-email-sbhatta@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0413.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::22) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|SJ0PR12MB7036:EE_
X-MS-Office365-Filtering-Correlation-Id: d10789c8-c5dd-4fb2-b9fa-08dab5c53f48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UJEKoYPZaX2uF/nckHVe07Z2aYzKcIFGejRonlHqjsDMbXbEVW3ijJHAqc8osrrqGI2BromK6umWRvG3pUS4ktiueVLrA26LhqyTNCuWIvPMYjVqoIKKiKmCmohew59B7Y8iC4XfyDNPRqRTwOwgsHxK0sA5LyuII37x92qScMBLh8B4GcfjPHzEPmODEFBmQMHXTUil6nL1tvbeBq1kRxfi9UoqUJ3BLvNgKQx+3I0MGCa5kOt0p5pvd9XArmTHMlQQ9b5QYylGwgK/Weu/tKaty4L/47xCd1UI35m+dx+iy7Oc1bRZr6ZUx1HXYNMX0z/y9VnY6Eo6SVe0FicHx0k/a87hY4ZTdiDtC2CjnHV5HngndDKq+3gsLxsFppEIJcSWrZTpVLtY8OrVloABTw8WR5c6Bb1X5veKb0u3szppPPdLD+mzaGqNlX09nLGCl4huluEU+wUghMGH3Il2o2fwJjmzrDkd6zEgRwA7y1E26UcWqoXVwcJdOq6olXV2cctNgUeMU0DcFUTZuP+7J+Oe6kQIppv8mEaJ8kQjqux+bs9schwlQk0W2asr+Zljf7GCMplMpRQMiPkDWB4CI1Kp3BfhDOF97hv5TWl1OmWwN9FBnrdduJSUV99ZnHdtLxxFe6DWVh1meNYMbiiquDGzUR21WQOBZ5nNESgVc8ND0M2ICof8M2c/qqAu1FGw9mM8w4MSCPwKjNF8Qb2ycfPHdbZI1z2tQa4Lz8H2ORu7KDKTo3HyYu6yswLURQnrne5xGSwqHQFTu/BHtb1emDfSOLN5powZElkY0K+ioBY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199015)(83380400001)(31686004)(186003)(2616005)(2906002)(26005)(41300700001)(4326008)(8676002)(53546011)(6512007)(6506007)(86362001)(31696002)(36756003)(38100700002)(316002)(5660300002)(66556008)(6666004)(478600001)(8936002)(66946007)(66476007)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVlIVlJEcVF0NVVkZHV1K0cvVmVXZXA2ak55Tko0c1AyMmJzV0Z3cElLNXd6?=
 =?utf-8?B?WXI4YUxjNWtQcXBWcWtzRmtBVDRsS3FQTjFPd25EQS8xWTV6RExYWllIRWI3?=
 =?utf-8?B?cFF2L3I5bndyRi9DYSt3Rk5yVUkveFNyR2FUQjJQV2h4andtbHRQRFplMy9W?=
 =?utf-8?B?YmhEeVJyYW5ZMWdmOGFEdTh0aVdiaVR0VDkxT0x4OVdENFZyWE56cXdNa0Iz?=
 =?utf-8?B?a2xhLzZVSk1RWEloZEIxN3pQUk82MWxYN0UxNmlSV01SRHZCY1E3NzZleWNn?=
 =?utf-8?B?RnJsRllMR3hUVVNKeTV0V2dmVmk1dUlDVXlONGJnU3pSaHo2ZHJlSUVQY2N2?=
 =?utf-8?B?b3ZQcSt3VnMybnpENnp3T2NBVUV3UVZJKzAyNUwzRzZtcUpnQXpUdHd0VFll?=
 =?utf-8?B?RjR3WTJydENiazdHYlhCSGRObUhNOTIzaXRKVE5xaUZtVEZZWmFrNlM3aUhw?=
 =?utf-8?B?UHhhWmJNZEhnNUxZZVcvS1RLSlMxOWNNbTdyTFByelNlTG16ZDRDeUlidWkw?=
 =?utf-8?B?dW9VejNYc3NiVzV3YzhiRjJZV0ltbVhsUkk2UHRzYlVXVytIR2VSc29wMUdi?=
 =?utf-8?B?a1JJTEVTM2gxb2c0LzVwQTZmMVdiVGsyeHF3RHdpdmVoR05aUlBtd3NiTWdG?=
 =?utf-8?B?OTBlaG0ycldXb1V4bGVrdlRQRFhFR09nMWw2SHlUYmdTV1UzS29peElSc0cy?=
 =?utf-8?B?VDU1UVhRVVRqSXVTU01zYXFyZ1NLRCtGTXpNdVVvZ3VLTHF6SWgwSVVvcXJK?=
 =?utf-8?B?aTV2NndWbUF0OXU3WEhsbkJDNUtKRlVPaENnMGVtRkI2Y3RISlVsMGh2U0hx?=
 =?utf-8?B?UkU0NXJwcXVaVDhXY3lIMjRFa2FCRTA1RE12c2NIL0UyT0VHQ2QyQVhuK0Rz?=
 =?utf-8?B?V3JKWWhaZEY0RlI2ck02dWprZ1lLTk9tZ2p0ajdSY0pDaFBrUVhtN3hmT0pS?=
 =?utf-8?B?RG4rUGttQVRjR0ZxTGZGY3g1Snd4R1p2NGdJdzFRNzBLTnlkbGd4akhKMndr?=
 =?utf-8?B?cGZ0SVRXM1g0d1BZaG5NWjVwMVgyNnRCNmYrWGJaZDlYYjBXejZIOWxleHhm?=
 =?utf-8?B?ZnBIVDZRbUQxYUcyMG5jUHFnSXNFNklIZlphQUVkWHkxc1JnSmFlajQxNXVO?=
 =?utf-8?B?U0o4TExOdzVFUllmSCtYMkk5Y215anQ1TFBZTCttN0lBZEg2ZTRhbFlGa0tE?=
 =?utf-8?B?NUR0ejRQU1FjVVV2VnN2UGZORGdJM2NOVEJtNWhHdVRDNUFpc0lpY1IzLzNZ?=
 =?utf-8?B?bldjVTdoaGJRdUVrdFR4M0NiZHVBSGpEV011T0RVNlJvOUpDQmsxaW9YTDJt?=
 =?utf-8?B?RzBBMzlkWEFOeldva2ZZaDl5N2RGNVhoMzI4Y0ZFd0tZMzNWTnVYczF0MjI3?=
 =?utf-8?B?b3MrU3R0bER0dXF6RXlhSFpXSndPdkN1VFRwVG9UUzRGTDVMK21tYzZhMnYr?=
 =?utf-8?B?K1NnUmV1L1JJMnZJaWc1K2s0YVY2cTZKTjcvRnBDOVJkdFFmemU3Rm1Ua2Jq?=
 =?utf-8?B?K3VzUHhBMHRubkdQN0JqZzdJNmNza2RpZ0hMN0dQMTdrcEhwa0t6ZnZiRjlF?=
 =?utf-8?B?KzJkWUZnZjk1MzZDYm5hSW1ZVEVvNkwxczVSbkpJc0hjVENmUHc1UlRoN3FG?=
 =?utf-8?B?MHlwdTVqNkxqWnE2aDhOUmdSdW4vbUR2QW1ZNkZFTUFsYjFoTUxPcXFWeXk4?=
 =?utf-8?B?eFJTS2VyOFdhd0MxR1cwUzFacFpzMHRZcTRiRm1seUJPTkpwNnhOa3R2Q0R4?=
 =?utf-8?B?U1htODNic1pTTWZsaGFvUzV2NERDbDNrbWZ4cHVUUy9TZCtzNlN2YmtVSEZx?=
 =?utf-8?B?TFRFeGFCZXpBUlorWklyMXA5SXh5V3JFR3dNS09qVXJTNXZnRnlzUGNzZWJt?=
 =?utf-8?B?MjhsVDZkeEpjY3htSXBpWDdhcTh3REk4SFBCdm1nZDFNY3VWR3U4Nk8zOFNB?=
 =?utf-8?B?bURqdWYrUUJsT25iUVN0YkJZMzY1VjVFOUFxd041dHVLbzFBNkFqZjFMeVVC?=
 =?utf-8?B?TXNVejhmL2Z2NWpIR0Zld2crSjVvT0VYNVRUbGVxa3VWd3I3N2FtSDNxZGZo?=
 =?utf-8?B?ckpnMmJKeXhBaC9iN2dzNEgrZHkvaGpZcGFOVnpFSnZrcnZnZEt4c3h0cnlE?=
 =?utf-8?Q?xtPY3tA22Jf9ytADKEh23vlYX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d10789c8-c5dd-4fb2-b9fa-08dab5c53f48
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 13:40:00.5337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zw+Nm+z5+5+3RKrkzGgToXx3do9hpj6+YAsBl6cjbSSZpu/dnfWOEl2Yr3SA392R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7036
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/02/2022 20:39, Subbaraya Sundeep wrote:
> After a packet is sent or received by NIC then NIC posts
> a completion queue event which consists of transmission status
> (like send success or error) and received status(like
> pointers to packet fragments). These completion events may
> also use a ring similar to rx and tx rings. This patchset
> introduces cqe-size ethtool parameter to modify the size
> of the completion queue event if NIC hardware has that capability.
> A bigger completion queue event can have more receive buffer pointers
> inturn NIC can transfer a bigger frame from wire as long as
> hardware(MAC) receive frame size limit is not exceeded.

Hello,
I just came across this feature and found myself very confused.

The driver's CQE size is strictly tied to its CQE format, and is very
internal to the driver/device implementation.
Why do we expose this to the user? How do we expect him to make sense
out of these values?
What guidelines should be provided to customers who wish to set their
CQE size?

The reasoning here (controlling the number of buffer pointers) is
hardware specific, and is just one thing that might be affected by CQE size.
I feel like this api was designed backwards, instead of exposing the
number of scatter-gather elements per WQE, we exposed cryptic completion
size values which don't really mean anything :\.
