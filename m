Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5EB6C4720
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 11:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjCVKBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 06:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjCVKBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 06:01:40 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B724FAA7
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:01:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EydPZGLE7fPgjqlBGPiXKxyNOT96BSzkDTzBRYaBBPrD4K9iog6ViAcA62hj1EbaTroZlzd00WAmdjtRFf+Hdt9uVPDIs78RldBvu/wtzp6YM2wCm6oYd6A6ToxwPJMfPJ4fuFjOenwXfVkvIc+Q28Kb8CJAcRXo07q5lmd6p7RaPvrPx18oXL1Tu+t5x4P0ne/5VEEF2SBPH82AdWeaj122aG0DlPqjUKDXbt/tv27lTZ5pKCN2qkajQ0bKn3/L8MC0ebeIndoonPskoXcU0F50lxVrmmGW1lVagecmFxXbZNuohP9W22EEjQPd3nxEUJfeO7s+Pnfi9K8DpfIGBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IlGWzvb2wIHLgADFsArUdtBONJe8xh1CUv9pDN5c9Ao=;
 b=KEXvlOtU3uahZU/xaR3lrjiM8+Mbi8x3bOw/RIjuXdY4EGXF3eo9/h19IIboNwuhILvLXeOZEsuyUm6j/gBDCkbPla03O2DY1J0iHHz6QmvDUftD1tSThZzJF2XWW+g7FDVyucweTawd5WOkM92NaxE3NHfvw9OOjiJbai3CRoZ9i5bzk8ws2wJ+Oj9OGCz1z2a6gwYSy0K0dxbgTFRJOv4aDvftZymn/tW5hJPnxnry9j5JU+lWzCtSTx7LUKoMUjqg8hu9s5c91+kLzJgiFU5QNfZQJgTR+0KSFcGAl1AMu01OdT/jUpKNw/2XZGmqiEoXuehqKpnnx9JUWaajGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IlGWzvb2wIHLgADFsArUdtBONJe8xh1CUv9pDN5c9Ao=;
 b=Bvao/d6fe7AbU42beJMJQFBKN5hQdSPG47HY3gJpkdfeGfbLmmtL8fwVQJASotgrlcxpnyeaZSNeCCmd5DGcQgmBtm84tG5RBXOEQbcvoCWcLLrjQ1nR39IiFI4wBA4Tn+th/nnQykxREc+V6AMsMr/0ZLOXjdVdXMZaQn0FdckAG0a9fGyJS1D0u+M7xLGULhCruEo1Wu0ZFKceYtnNaZ7fvhvmKvGQIOGYtv2CC/ORzTnG+nWXELP70B60A7lDeVolM0aJ7+2bOq7SGq1cMYjH4vEwZfmQs2F+eZzls2NYI2/hT79NhzdmLNHILSb+lRXs72WLGcRtqIZvlMgX2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 DS0PR12MB6559.namprd12.prod.outlook.com (2603:10b6:8:d1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Wed, 22 Mar 2023 10:01:35 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::ff9c:7a7e:87ba:6314]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::ff9c:7a7e:87ba:6314%9]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 10:01:35 +0000
Message-ID: <d58cfd92-7c94-408e-bcb5-e2a9947f8f35@nvidia.com>
Date:   Wed, 22 Mar 2023 12:01:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [net-next 02/14] lib: cpu_rmap: Use allocator for rmap entries
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230320175144.153187-1-saeed@kernel.org>
 <20230320175144.153187-3-saeed@kernel.org>
 <20230321204028.20e5a27e@kernel.org> <20230321205050.763deee8@kernel.org>
From:   Eli Cohen <elic@nvidia.com>
In-Reply-To: <20230321205050.763deee8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0174.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::7) To DM8PR12MB5400.namprd12.prod.outlook.com
 (2603:10b6:8:3b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5400:EE_|DS0PR12MB6559:EE_
X-MS-Office365-Filtering-Correlation-Id: d5255beb-1b37-4698-4f57-08db2abc6bc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rDegd13sLzNUEMTrqT8LX7IUGOo8xXh02PrZOO6dBN0gjA/w6S0ELuZc/6pV9Htxpcw+w8i9LRptJd7O7UesLCOfJD2pP8uo/74mBNrJ3sJI3FYIipTkbFQ4m2bWHwdSHgReLs6l6ajSpiAMbYd7eofOJtiC402chxYC/ZBI+LmZpjPKeHD1Bn7pV7Pip3dt+iqFQq/fZVTS+pYVBVNsuPH/nf7eHDgbL70IkXWuzRKSZJ5aWAB2GsTxkh7mJl+IXTV/oCVaXtDtxCN4XZABr9JzMB8gh44o2IuI3Ry5rrL48IgAK7OIpmmtDpX3uhA1mZAK/oxtzqCXqYj0hmnGy7WpqrWUhxD/vOis/lPMhFx1v8uQouDHML/L0aKB4L6EWZnXhSpxwjcP2/6mAgUs+CvixvfyGHN5EpSJPjGVp6XPoB56n06LA3dYYxhL8UU9wTwl2b8A2GPifhvLQK6gRxryOeD7KnqVB9eh6YoTSoAUnGaemP7wRQJUDt83hQy9N54UWfVG3G6qe7kTdIHKLQjiaIDNTWfZB5wM3UsxUE8wJp7efBeNKs7rTZ/wSQOFtNtL1TsI9epU8c70zrkRN8BbbspLDJrl1bZJ8Dtt9rwl61ozqTqx/PCsphGiXx5m6IsxQCzyhZG/jiELbwWxNFwe40FLyPy12zRLnIezw9YN05uvDL8KunWZ1wAO3yBQgnZjW02nn26d3vuyNcoQrRvD5lY33hJNgNOlq9Ik5SU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199018)(316002)(54906003)(6666004)(107886003)(66946007)(38100700002)(4326008)(8676002)(478600001)(110136005)(31686004)(66556008)(66476007)(6486002)(2906002)(2616005)(41300700001)(186003)(26005)(5660300002)(8936002)(6512007)(86362001)(31696002)(6506007)(36756003)(53546011)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Lzl1NG10RTdPNzdYMURnZFhBTTV6bE9IQkgxVW1QNFovaXBlTkNPNjZ3VXJX?=
 =?utf-8?B?SE5rTTQzY3k5ZlJRaGZyVkpKckFXbU9vSjExYUNRRXBvNEdTM05PUkh3VEJn?=
 =?utf-8?B?TnRHUSt2REk3d1ZVUEVHSkEzb3VaM3N6eSthRjNEbnArTUVpWEtBdVhwcWZI?=
 =?utf-8?B?NGhRWlJZRnN5c1hjb21YNjhzVGs5UFMrVFV6RHlUV1BMamhiSkdsMmlWa0N6?=
 =?utf-8?B?bStMMk1iNHRhTnNzZXpxa1B6VitySE1QMHh0MWRXN2F1Q0RWNkRnYWV3eHRI?=
 =?utf-8?B?ejBlalpTVE13blBXYllDck5VZGZQTStIMUlPYW5LZ1NmUFBkckIveHVjZTBt?=
 =?utf-8?B?aWd3K0JFbmExS0xXeTRYQ3hza3RNTllrQm4vTXVxYmNpM2drZUhNQUo0NkU5?=
 =?utf-8?B?U0tTOFNUMTdpVk1pOXhYZ0lDd0x5dmlkbklSYzNjQit2UU5CTlFRUnpQYTho?=
 =?utf-8?B?RCswTk1GN2VLL2p5eXI3aFRjQVltWnJwQWdZZVVSbnlZWXNzM3o5MmJud0ZJ?=
 =?utf-8?B?bnpXaUYwSXlVSEVvVzl0bnUrK2phSng3WVluNks1UzE5Nmhza1BkVXMycm1X?=
 =?utf-8?B?UXQ3b01FOEhVdGVsb00xeVVINEc4VlJxYkpJcVhESFhBZldkc2JrcFpjaDdh?=
 =?utf-8?B?QTlrNWpwWWNFV2k5STZjcTB0UWlzK2E4NXU2QlR6ZVNZSU9iUGJEV0p3V2th?=
 =?utf-8?B?TG9NU2ZwcEJoNHVJRmFTKzVnWE84NkltOExGRkVuakxRYUlVQnJFYVVpd2tP?=
 =?utf-8?B?YmppaitKM2U2YW9wTkRuL083cGtUM0RPV25OSlIzRm4ycmxHeHM3aG5YTGE5?=
 =?utf-8?B?NVlPeUJiMFF5UWRhWE9FRXltcWd5U3NGdlRmcEZweFN5NHZXQTFDaXljVUNP?=
 =?utf-8?B?UTkySERUMmx4UWk3Q0NxTXZlckdqYmdyRTBXTDZ2a2Vza01FNGhzeU9BM01W?=
 =?utf-8?B?SDZ1S3MxcnNsTlpCbTRSYUF4aU5TdFRxRS9XUUh0WDVTTVYyeEUyV0xUZHVw?=
 =?utf-8?B?QU5iRG00QldwcW1VeVpVeVBOejVPL3VPK0hJZHVKc2dtL21ZU0hkSGt4WFc3?=
 =?utf-8?B?eW5tNC9rRlBpczU2dEl5ZkFTUmFhOVZEcVpCVFMxbjEyRTFTemU5bU9OYkdS?=
 =?utf-8?B?YW5Ob3FSZlBEWVR1bFFNT3FwaHIvdzZGNGxqb0IzblVHVXNkZ3dvTnJQRXZV?=
 =?utf-8?B?YlhrVWcveEFxV3NoZWdnVkRGa0hDTDlBMVpBZ0tla05BcVFEUWtRaUQvTXpw?=
 =?utf-8?B?YWRFUkxsbjd4Z3RWRzZYQzFRZk9VTng3UVlUb0Z1ZGFDVnNwbEE5RVlwSkJy?=
 =?utf-8?B?d2FuQ2dFb1JjRnYxWDlZRFRiV3VKY2FYVm9McUtCR09ZazZjeVJPaW1TZkNR?=
 =?utf-8?B?dGl3bGRUSXVEcFA4bkNzOVFlYStnSUJZQkFONk8xUEo2d3cvWmxpcVYwZklF?=
 =?utf-8?B?S2puRnlnU3NaaS95OHVURWxOdEdHa0h0Q1VmR2YzOXNJbzFOYng3a000ZWIv?=
 =?utf-8?B?b0ZZajJKdmo3V0JFcGltUWs4THNlYm9HK3hsNEJ6RE9KTi82MGtiYTMxdExs?=
 =?utf-8?B?dlllOFhxV2RsYUpaQzFDWXQvb3J4VnIxWlBDN3RhZm5hdlB4dXJndlI1NXpn?=
 =?utf-8?B?U1hRcDg5N2gwTG90VkxYcWE5NFMrY2tkVk5sL1lrZTAxWmhrcFVPdzkvNmFu?=
 =?utf-8?B?T094QUdVem5mbDlkdVluZTMyQUZ0MktOb0UvVWRzQ1dFREljVXVndjBpRnRE?=
 =?utf-8?B?UFI1N1g3YW1TRGE1bS9maW51Ymp6WTBtcUR4b3Q4TEVVVE9ucHBySzVnYUtO?=
 =?utf-8?B?S09oeUhpZTdVTEc4eGl5UzlWY25hMzRpalJ0YVM3TElkMHUwWWY1bm5HWGMw?=
 =?utf-8?B?S0VnbCtLT1N1UEp5RDdpc2tjbFUycUNjRzlGU1FacTFnMDY2TU9oMUVJUmVC?=
 =?utf-8?B?S1oyM1FuL0lqYkpDSlk2THhTUGNkUEZDU1JjdmpmQjNGQWRTandCUmRvU3NT?=
 =?utf-8?B?ZTZKMlFYSllWMWlhcy90dXZYTXlLK0J2L3VSUXl1QzA3UUplcVdRelZ2MjNw?=
 =?utf-8?B?K2MvclpqVm1ZdXpHSlR1Sjd1bHVZOTJqa3BjZDMybFlNT3Z1SkdrcUJyTTJv?=
 =?utf-8?Q?lpJQ3rMnlcYAfqqmLhg80YExU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5255beb-1b37-4698-4f57-08db2abc6bc8
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 10:01:35.6220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ahHg+YYRKOp1/u6rYOqyM8uQVcoKVgqJXjRwXMTLv0uuJuN+jZOjtCbL7Nun+dQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6559
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22/03/2023 5:50, Jakub Kicinski wrote:
> On Tue, 21 Mar 2023 20:40:28 -0700 Jakub Kicinski wrote:
>>> @@ -295,7 +307,11 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
>>>   	glue->notify.release = irq_cpu_rmap_release;
>>>   	glue->rmap = rmap;
>>>   	cpu_rmap_get(rmap);
>>> -	glue->index = cpu_rmap_add(rmap, glue);
>>> +	rc = cpu_rmap_add(rmap, glue);
>>> +	if (rc == -1)
>>> +		return -ENOSPC;
>> which you then have to convert into an errno ?
>>
>> Also you leak glue here.
> .. and the reference on rmap.
Will fix
