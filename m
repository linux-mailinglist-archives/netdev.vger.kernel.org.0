Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4E3668AE7
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 05:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbjAMEe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 23:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjAMEd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 23:33:26 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2084.outbound.protection.outlook.com [40.107.101.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CA95B14C
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 20:32:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsJsYQH7H0w9L4L/tTW6S6/Q/U332PyBM/sXylCek+PujleEuEnIyvPRAdrv0x/bibbKZTGDBiBmFggxWCz51UE/GTEGfAAB/5UfVdGmAtkfrkvEkOF3va62tE9dJc8v2PfshUrzUVn05LNfW43/+qaf4Ig8cayRDa8ncAK/DMCKhvpmQDk5wxxulodCWemsiEyVVcxmkjUnZdj8X9xFDwTUr5/gVtlqzI7LL3xunm0W5zwpGDf9ie64zhYzbtY4SeSwssdM+fWfAfG5B6xsf0cLl8CRzjGT/NE8dJ3CIKiBGvraCQ88cHBCao7Z7KJPIZ6OJMM+fpp1znLmXwYfxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FKW3YsJpnEsN80xV8UtSNP6c4bZZGpJ1nwYF38MBRAo=;
 b=lVRqQHvu8jaavVMvRUypbATKigdCBUOFvdRTZYL8upDGTg8OTUDOoIzPB3QNVfRGS36M3mJVEZelZFJLBZGyCFRFNtXaqPhEfjZOX6nkOVbuWEmbY73FMOz54sMzXIenMgXNvZ0zo2saWl8NRBkG9BLHbc+Ci3tcQtaePXUsh3awtzcY7r+AXir4DLIyVL2/p2esZLlOBIC9iS0ki8yByEl0IpRXm7LBqoJNPVs6wT+BtsIRCq9rdaV4N8ZtHcdm1JxAeXZ/1fF3YMU0+YpHpeTNwO0pT6MII6EduqSVnhngXOoKVSHVlEmSfSS0M87i0wJfgmblJsKuUlKw6utD7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKW3YsJpnEsN80xV8UtSNP6c4bZZGpJ1nwYF38MBRAo=;
 b=k8H5s+6bY/GFrnkhhLXurzhs2mFgv3egIkxmGsBXI3p/QSsElU6XxtpVtxHuUZHejTQShtTBeaDSeuYgO7K88IjGMZT6q9VWEcJ9vhJbqxvTcWBgan4xixabbrz28GJ7ISSDBZTHIXpVf/QMnSpk/KHoF7cQE9xvHapoHB8w9IY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by IA1PR12MB8520.namprd12.prod.outlook.com (2603:10b6:208:44d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 04:32:32 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::e7d8:1e35:79ac:d6e0]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::e7d8:1e35:79ac:d6e0%9]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 04:32:32 +0000
Message-ID: <2194019e-8b29-1c40-d050-b9eca3312e05@amd.com>
Date:   Fri, 13 Jan 2023 10:02:20 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH net 0/2] amd-xgbe: PFC and KR-Training fixes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Raju Rangoju <Raju.Rangoju@amd.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20230111172852.1875384-1-Raju.Rangoju@amd.com>
 <20230111214254.4e5644a4@kernel.org>
 <822b51ba-3012-6084-b4eb-39e21f2c066a@amd.com>
 <20230112143619.5f7e7ed0@kernel.org>
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
In-Reply-To: <20230112143619.5f7e7ed0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0148.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::33) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_|IA1PR12MB8520:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b72f70d-01d5-42bc-d7f8-08daf51f2fa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZzqYj3SGMqzhpHOHa8e+XdwiJf/siDPiL3KGhgEsKKDqF/C33RANAo3hyi/8LhCdZYp2YCcSxlkV/B+Xj5vjd2VYyUFV6K1kTsXOkPSIMfo2FqWemk6QFLgw+2gOhSs2vU6AmgUw7xHq+XTcRTg/6JkqJLdvNHgnPzdBFRcZEH/0zdUXQtIeKwwzjXzF8NVs/68JW8uUS8LcRvajJkmSy50d18EjJPYAEGe81P6bSK9QYsfBF/w45vAsgGklCKFxcsVs2VImFlOlJt87NKNfW9oCTT2DGhki/uApQEMA0IRFbwwTWPma0M4r9dQeSf298G3cw53hChRGaql/LZnNig9qPh0I+PbFpfT+NCWo5jbfAaT1pT6sxjElmCioF0fTu9ijAXRKw+t9jMA9AdnJ52pAj5kCSmEpIyWo7DG9AB5g7by62MshgmAQTK/hQmG9jqgePVE5I+YvnfXZOJiXT2S69Zv6Rb2one+rh4I9hTa2lI3Y1HFNLAUGtDxnbxHOXVfbUFHqAIDm4U0Er096/Rgq1e+RA49l5tFOyIkKLNkpzsqLk3HoP9nhZrG2RJf41ndyPq5DeS1I1Wz5FhKf06oQeg1pWtPtUbTighPMmoiEyX13SD285LvP9RPaSEVnFFLfgxE3/2eptswn2jVLTGLxzSo8/JDcDgAR55kctp9N2pZzkaiy2gHkYHYndrg2IRWu73u26IjUwZXfUhsi2xj3SxrTi1Z+/RBm+grju9E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199015)(41300700001)(66899015)(66556008)(54906003)(4326008)(66476007)(2616005)(316002)(36756003)(66946007)(6916009)(8676002)(86362001)(31696002)(38100700002)(5660300002)(4744005)(8936002)(83380400001)(6506007)(53546011)(31686004)(6486002)(2906002)(26005)(6666004)(478600001)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnYveGNPTUZyUURnQzZrUDFEelFpVloyYUd0c001RVhSbG52TXNveE5ZQnda?=
 =?utf-8?B?RjNLWDFPSkthb3lrV0NPQlZsSmRLVVdKRWYwR2Q1L0lNZVo5WWdiNlVzR3NQ?=
 =?utf-8?B?Qmw0S24zMnpBM1RjbVhpbmEyYUNMQ0NIZitSbzNMUXFCaUFOb2llMHEwQW91?=
 =?utf-8?B?RWdCUlJocHV3YmszU2JEMjBoakxacUFTNVBscnh3N2Z4c1J6bUJvY2hYblRR?=
 =?utf-8?B?OXRWWnpTMlIrQU1vY2lWZWc2SzZoRlZLbnpWVkRVdVByOU1zSnlZTzR2OENo?=
 =?utf-8?B?S1c4aEdCaFJaQXlRSkhnL0xMaHZOQmgrN3YxM3NVeG5Sb1o3TlgyQ0J3VFA5?=
 =?utf-8?B?RE1vNytVV3UvWGQ4bFNweVdJb3VFS0lZVGl4MHNwOHoxT0pCdU5Ga0VkN1cw?=
 =?utf-8?B?d3EwL3N4bmFmaExHeW9XTEJrZE1SRjc5Y1FnM3hhZ2c3QlEveFlyYWwvNCti?=
 =?utf-8?B?K01mY0RqNXB5WmVGbTVTMHlzRzM4UWlKeVBnWFBiMFZ3ZW9NaTRLajEzQjM1?=
 =?utf-8?B?cDhNSHZtbE5tN24vSVR3VzJ1WWg2Lzh2dWFoN2xsUk5kZlh6Z3M2dkJJc3Ev?=
 =?utf-8?B?LzQ2Y0VsSy9VSUkzZktqY1Y2ZzJwVFp4WC9HSTMvbEFBYWdvUi9Vdy9sLzUz?=
 =?utf-8?B?WUM3bjhiL1dGa0ZRL2tGM2ltaThUbmI1YXpvQ2twWG5KVllZQllLM0Q4TG1v?=
 =?utf-8?B?dnFrTG1vcTRZenArMlo4dTRnUnFoeXZqZHZNSjhPUTl4SUlTNlZjVGRQUHFw?=
 =?utf-8?B?UmVSY3Y0K1RoSkRCdDdNNzVSZWlTM1I4Y3YwVDA1eFVEd1hNZEdCRk1Oa1dn?=
 =?utf-8?B?TDN0YjBZSDMzdUpMVVZjSzZQZFBOdWloWkFmdWhBcHBEdDhQSlBmQUl2a1Ew?=
 =?utf-8?B?Z1lEZW5tZm8zSE1McjdiNGpTUW5uUEoweTM4ZytGNU5MN0FyWHN6dUJHTkNP?=
 =?utf-8?B?cDlrTEZQRFVmZkdFSXdjWG0wV2VIeHp3QmFYWkVYTWVOQjFOZXpsSGNkOW1L?=
 =?utf-8?B?em9qdlZuMHRRaW1QbGZ3SGR5ViswT3dBTHpRRGxmY1NObkZPK0thMVBPRUo0?=
 =?utf-8?B?UUtFZjRLMjVkQU8yMFZMTy9zaVJvdTYySWphRElOQXNDSzBjZlNqbFpmK1R0?=
 =?utf-8?B?ckxzczJnVEFJYnFkaVNtTUFSMGRmZE14NFQ5RXBYZXF1cUZQWG9vOXJqWFh5?=
 =?utf-8?B?bGt5OU0wbFBBQzF2UnpqdlhsMTB1SE1aM0Jvc2tsM1RXckt3NUtKMXBKZ1J3?=
 =?utf-8?B?bUlQbEVyM3MxYWdkajlmRzlOd3pMaVVlaVQ1ZUJUb2VEY1ozY0JaVTJvdmFy?=
 =?utf-8?B?YVN6YWdUVFpTZFZwM1RqQXhoNXgzdmYyVmEwV3d5NlNDMXR3a2VLdy9CUytv?=
 =?utf-8?B?Wlp4UGJBeWFvZEZOaTNsQ2U0UGFHeWxPM2lNQUdhTENrdjNFUXl6cWpzT2FB?=
 =?utf-8?B?Z3VGNlJZZXJiYVFZT241ZUlHWDNrdFczMnJGNVdybWNSUVdjb1ZBQVloL3k2?=
 =?utf-8?B?Um5wNzk1TThYL1pWdDRCeEM0L3BWdkZLQXZtcjlZcmw4V2sxOHdBOFMyZDBD?=
 =?utf-8?B?ZWdRMERENjVTNWd4MG1hNmtIcG1iVERFdnpEem55SmxxR3pwMWo0b2pGVTFx?=
 =?utf-8?B?dm1KajNNZUY4ZXVwVkVPZW8zWEZoTDhtMXl5NzdKakJzTHRzS3pkRVErbUJT?=
 =?utf-8?B?aEg2OFVFaEZGd05ubS9CVFcwYk9iRTJVVjVYL1lHa3E4UGxuZnJlRG83ckxI?=
 =?utf-8?B?TDNOK3lMUVlNclMxbk1qY0tyeHVzb2dybDFydWs5M0YwWTRBaURUNEhEZUdr?=
 =?utf-8?B?MzR6aENDTHVNQ0E5a2pZUUV3RTZKSnZvcnE4U3BLd2k4bWgxcVAzZzc0RWtB?=
 =?utf-8?B?azZWUkxBZzlySmxNTXU2VGw5Z0RhWXRUNjM0dWt4dHhqRDdmeGpZWWxyaEJx?=
 =?utf-8?B?UW9IcUladHZoSmN3WFdwQ3RlbnVaOG5taDZMMlZ0VU15NXRTdENUNldBNE11?=
 =?utf-8?B?dklaUmErd2tzZHRGNys5WmVkU3VuWFJUN1NVTDVpNXFtNGd4czlKK1gxeXdv?=
 =?utf-8?B?T012bVRuM244Y0FlODhJSFZDRkNWdjB5WGlXWHd3MHNJRzJCSjgra2tWWHBF?=
 =?utf-8?Q?8USixj7ohxSw/UPHvekypv9Av?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b72f70d-01d5-42bc-d7f8-08daf51f2fa3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 04:32:32.2153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oRS1ZOkbzzlM8OM4CLprR2iXzbqUJWJAkJNBeLK0vILKzcYzOBWeSXEjgh+O8c+x7/uOatGE0qlDYStOsv/mag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8520
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/2023 4:06 AM, Jakub Kicinski wrote:
> On Thu, 12 Jan 2023 11:19:34 +0530 Shyam Sundar S K wrote:
>> I have put an Ack tag to the patches in the series, being the additional
>> maintainer for this driver. As Tom is busy working on other areas, I
>> shall be a single maintainer for this driver going forward.
>>
>> I can submit a patch for the change to the MAINTAINERS file.
> 
> For Fixes of code that someone authored it'd be better if the person 
> is CCed, as long as their email address still works. For net-next
> material, if you're posting as a co-maintainer not CCing other
> maintainers is no big deal.

Noted.

> 
>> But would you mind pulling this series for now? Or would you like to see
>> the MAINTAINERS file getting updated first?
> 
> Yes, no need to repost this one. Just something to keep in mind for 
> the future.
> 

Thanks! Will take care of thie is future.

Thanks,
Shyam
