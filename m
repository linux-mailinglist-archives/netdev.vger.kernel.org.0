Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324706F0080
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 07:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242688AbjD0Fw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 01:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbjD0Fwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 01:52:55 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178A63585
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 22:52:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QMYUY7FtQG0qoshp++QJAZG9ntinYBFQ95axTSL5pKRtZMPKtAxbeL7EP+57xzC5t8cmroqCLxsscGEGozz+xDDXHTDJ8KeBre12xb9LLxmJ142SdQI4SyoiXKwh7cF+oLYbuxWevgtRlpfJW12T6uPh/xc1kgviCqy1gUJ3EIxuLLPNp9iNQU5ga0LGcZlIoYa3QtyEAs2HJKMCy+fMCWb6ND2bUWFbzUSVdBTVrnM1qeTGMVe7n4R0UkQaIxPDyFryo5Ea0+Yy/sxv+orwsyxyyf5afSb1aaJtz8cQhcrs/t5kXu9J1DrB1c4NmH3b5mzqSnhAWjiPo6wXwaLuzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3RX9qYjYNOBQnZuGKeHQMu1bSXwWzTOQlbKIXug+c70=;
 b=jbplTpfQW0YcjMWGvWqhLqZQ2qB68PTijpyBo17KvS92dSG4n9FBz4uimZrATG5uHfG2EX+0DehLquk070M7rJ7Um1I1Q4t6a/P8mlM3cpndPqaNmyeGCWRRtdOadBg1kGtyvmfiixB8M9gH+ZKC7JzIhVvlG/0ZIy3kQr0kK69G3950oGPazNOaQ/kTHnqi7fIJPAL9HgGEBNjtW40UzROinPZxrgHcvdaCg6pFGQ3OmMLTR91LVR6ty7BvonYGRa8Zc1H73mVgbGEZ8QRm4TNTlUak43dzYGpwZAQp1BEKn405K0/4LtNnpzC6HWNKm8vNoLbCwPzr9PN28XbrYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RX9qYjYNOBQnZuGKeHQMu1bSXwWzTOQlbKIXug+c70=;
 b=FjsbbvNg+g/DoBNZfHrRZ8ol/rI6zDnbAzEI4aEqAcTdB9fKBnYThLT1Sq7YEmuOGSduK0rebntQGeZgHdLyPsJXmvVnjiwyx8GPjIpg6xrwzH8pPW6krQT8sHbvaGw9zogukx6ZQeInv+++N/71fPIbJklTMPwMpIMVbZteol0465gtkzyXIknvjkGINeEFDjMRTWk+OIaOtChuoz08JU1k8n+1Df6vliVdmpblh2S1MBlKt0DwbGJuZd9D2xP6lvU37WoxGUSMtjCHx2RSDEAcQJwjq/ejNwz2ChjbGkUnOOZfDDSiUZurm/UfnQAZ/q0W8k7z2NLqGtYx9l6Y+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by PH7PR12MB8108.namprd12.prod.outlook.com (2603:10b6:510:2bc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Thu, 27 Apr
 2023 05:52:52 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::d61d:3277:363:c843]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::d61d:3277:363:c843%4]) with mapi id 15.20.6319.034; Thu, 27 Apr 2023
 05:52:52 +0000
Message-ID: <9abbe24a-395f-0e89-e090-b29da0e71514@nvidia.com>
Date:   Thu, 27 Apr 2023 08:52:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net 2/2] net/sched: flower: fix error handler on replace
Content-Language: en-US
To:     Vlad Buslov <vladbu@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, marcelo.leitner@gmail.com,
        simon.horman@corigine.com
References: <20230426121415.2149732-1-vladbu@nvidia.com>
 <20230426121415.2149732-3-vladbu@nvidia.com>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <20230426121415.2149732-3-vladbu@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0148.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::9) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|PH7PR12MB8108:EE_
X-MS-Office365-Filtering-Correlation-Id: bdf6af40-0f4a-462e-15bf-08db46e3a326
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fU/dTcvdzerNFmo5DI31maPbLcGBFjaFURznvONHAb/4H0pN10Kgj3QRqLLW9kh4lScND5a/RsG4zNQ35dSavF5W8wH7BRdE35iDFf+F5zMFcK7epYp+SvcqxCD7arwNGQDVQEMrok1126Gu8cmTAnwdWWr+xP19jZVdwpp9bM/XweVydgMCly1A0LSxINWX2kq8Xlc1ITRvBIaOTMTZ7k5VbjtO7Ul6h2mtUnlIAnSecRgzZssYYEs4ZXpht8ZyEE8T2wTUd3/dsDyh05ZTza5a1eFpMUv1p9UBpNa8+AW16dK3MNT62VUuW3gBXE7GxhggUDPFBx8qhlP61NagK29EPulnpVmZIerzFgWa48+CxEhNaAGAnt4FApFbznORNlY+hRacD6e2GGOPs8G5N9UuN419rHVCRPYKMyolYjraKeYLH5zcyRCZqHu7Wa5gH+67FYqBRN9fph2e2Ocx7fNLbG7r9MU4zbv75J8NTrZaV1HB7pOdaXQPLm2FAHM4Vc4KUJFTZ6Gh45P6aTHulj/fftyswbs7tud+m8+lNXn2PNcaG6Q4sOAsYqbaqcULIg4JYeBMsYhSfuXvKLOV+pDiUokCitHuM1fYLO6YpE5sbIHtPQnDOHnl6iH4sf/CbbWZOlEgp3A5jIRao5gHOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199021)(8676002)(31686004)(66476007)(66556008)(8936002)(31696002)(66946007)(38100700002)(478600001)(86362001)(2906002)(41300700001)(316002)(6666004)(4744005)(4326008)(6486002)(5660300002)(53546011)(26005)(6506007)(6512007)(186003)(2616005)(36756003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHRhcWxVRGo1aHNnSy9zQVpoTm4xVXhqWlZvVVdkWmE1cjhBSjdXbkhuTnZH?=
 =?utf-8?B?bzJDenBJY0QwM1VMMWF0cDJ2TmtPOFk1b001T3BZcEJ5VnJjZ21Wb3dvY1Vv?=
 =?utf-8?B?NTRkeXZtVDFkemsyRXJHQ3Yxa0FWeGJsRWVYaFAyekFmL1lhMlpkdWNYSlpT?=
 =?utf-8?B?OVhJcWROMEpuOGw4ZkdUM25pczJvUzBlbms3UDBlR2ZqTk1EYk1JN0lGa2Rn?=
 =?utf-8?B?OHVybjUvbUszdUN5azhaWU1JblpydW9mUit3SGtFNFBaZGUrOXY0OXlhUUZE?=
 =?utf-8?B?SlVCTUp0cEkzb00zSENaYlVnclNjZmZBYjZNWHc2VUUvRU9YbG50NWZHaGdM?=
 =?utf-8?B?RGxOUm82R1NBOG9NTE5iaHdLSnlwMHpyNmFBYWhpNmRuY3o5K2pzd1lkaGFW?=
 =?utf-8?B?NkxaSXF1Y0VjTFRIbExQdnJVdlkwdmZ1ZTZTa0FnVm9wdHVkKzAyUFhCOGtw?=
 =?utf-8?B?bGg4N0k5a21nQ28xcTg2N21VTkFWMWdjMUc2OVdyS0tpRUVkWS9rR2NQQ0Fy?=
 =?utf-8?B?R3BEbkN4MlI4QVlROGxCRmNRWDV0RkJ0TEsrZVg0SjM4STM5Umg4dUFJa1Ix?=
 =?utf-8?B?NDZQS0ZWSUF6OW1ibWtCTVhQd0NXMWl1YllHQjliTllXL0NsRURiUmVxWTZ5?=
 =?utf-8?B?V2I0eWtmSGJNUGpyNGoxYnFRRWFHOWJqOTFxM3FqYjFDQ01NNEVEZXU4RmpN?=
 =?utf-8?B?eEpFUFl2RmFOV2xFTGN6VGdpdzBNSVFkQkYxZ2llOTdzRDZJMUViUlc0OW1o?=
 =?utf-8?B?bVVhMEhNaXVCVnhRR3YrUWx3ZzJxSDdEU3p4VWgzSzZqVkN4cElJL1A4MWRP?=
 =?utf-8?B?Ry9LM1JBa2QwcjBmeGc2QjRrdTgvZkZiUGdMT2FCdGVvdWs2clVNK0gxTHJG?=
 =?utf-8?B?cWNVdy9aWUVwWEdQR2NuNG51bE9mTCtvY3dXYWFkRHh5eHYvRmErVC9CZ0pw?=
 =?utf-8?B?ZFA0LzJEZm00NE1lRGZCNDlkV0NzRTJ3VXlvNStBR0g1elRTY0hJd3ZVYmlh?=
 =?utf-8?B?WUdzcUk4K3NhRlJzaUFkM3hkYm0ybFA1MVdLcUpSa0NiVTlCVVA5OVkxMHFK?=
 =?utf-8?B?VVpPM0gzWld6OFQxcXhCOG9xQ2t6NkxFSnlHd1ZmUkpyeEFkT2V1KzVLY1N3?=
 =?utf-8?B?bllKN2I1Y3M4bUtienIraVZLZU9qUVJEVytxSFl2dVZQTno5UnRUdGdhMmUx?=
 =?utf-8?B?bVQ5UFJXOUZsNXRXczc5bm1pbVNJVjYwYW1uVmdZNlo1aFAwb0NwTzh3S3hB?=
 =?utf-8?B?eTR1TDdVVE5CMHh6b1ZvRzF0dENqN3U5VDM0NGtNUnViU0FRSVhyRHVnd25M?=
 =?utf-8?B?Wm53Uno5WWgrNURpQ2p4SVMxb2VqOEpoZ2JyWUlGTUxYRUxYdXdkTkppL3Y3?=
 =?utf-8?B?a2V4T2wzVDE3dHUwakdYV3dtK05hSTljR0o1Vkw1QXNTSjBvQ20xRkJOekRt?=
 =?utf-8?B?M1ZRcVdpSXA4bCsxSk13VFpLRHBBOEpxWkZ6ZTNsSU9nTzdXWDMzdEM0Y3J4?=
 =?utf-8?B?MlVxRVJQNkZzZ0oxYTZaQlVRUWprTWVFZ2oyaVJNcWliSmcrRlZkeThHV1Ft?=
 =?utf-8?B?TXRpUDlZNVQ5cEZQV2FoTE5PN0VGUjIzY3ZjMXYrcjJHdkpOcDNTZzlWR0lH?=
 =?utf-8?B?aFBYTVpWUlZ4amRlRVNxVFZGTU1OU2NNWHhBV0RTRUtWUERYNS81cTcvQ3JB?=
 =?utf-8?B?REV5anJlcW5hNXY3VDFtT2d3OTlkd3JkREc3RVkyWUxCdUZ6bXNLajg1UjY0?=
 =?utf-8?B?SldHc1Z6R1J5WTJTdW9MMzBxMUpFUTJYQm4ySzA5NzROREtXY0VZbWVPcGRk?=
 =?utf-8?B?cXBuaUpjbjhtVXBrQU54VmpFejZtNkt6UzhTNWoySXhvZXNXSjN3d3l5NWpu?=
 =?utf-8?B?RGlLcy9SMEJyajNkOFV4Z1QzM1IzbEd2WFdyelBXd1ZrUmU1cHpwRkFCSkJS?=
 =?utf-8?B?YmNlcFpCeHZyQ3dGRFA5L0wzRTVYZStSUnc5cWt5akd4Y3JodTFmVE5FeWZM?=
 =?utf-8?B?OGhPQjY3SE52dlZBdjIxYVhLNHpPT0hsZVowempJNm5RS3VOQ1Zad1h1STVt?=
 =?utf-8?B?VUpka1BHb256R3BIMVUybW1OUllWSWI0aStIVFVGYjgxY2VlRWUwNVhBQzRi?=
 =?utf-8?Q?b1ag=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdf6af40-0f4a-462e-15bf-08db46e3a326
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 05:52:51.5754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M9+pvttFhL23XUjHMuqgQYkNd74UPoXsMxLJYBROv8U2RSbRWbTbHpksjfgrUMDol/LMKyE5mfxMf2srrX3bJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8108
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/04/2023 15:14, Vlad Buslov wrote:
> When replacing a filter (i.e. 'fold' pointer is not NULL) the insertion of
> new filter to idr is postponed until later in code since handle is already
> provided by the user. However, the error handling code in fl_change()
> always assumes that the new filter had been inserted into idr. If error
> handler is reached when replacing existing filter it may remove it from idr
> therefore making it unreachable for delete or dump afterwards. Fix the
> issue by verifying that 'fold' argument wasn't provided by caller before
> calling idr_remove().
> 
> Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>

Reviewed-by: Paul Blakey <paulb@nvidia.com>
