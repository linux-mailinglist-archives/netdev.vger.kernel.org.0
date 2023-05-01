Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7F66F31AF
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 15:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbjEAN6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 09:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjEAN6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 09:58:32 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3A713D;
        Mon,  1 May 2023 06:58:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABT4uLOIRmDxegvtJaBplIE3n6DAXYSsA8N8js38o/OCQaHn68vlaR8UM0SP8Tj5ECO2mXJ2JHydIujwiB+e2v6slteMjVz28vA9v/uvFxGruEQM05RgRPPgXe8d0CnPFYqGipZ6nEhAdfNCVoeFdLgdwwzh1InFWn/SEV6LCplRjzzO9HFTtvhpCOutLgPniG6pLHzQGCH0PNgjL5YZRasglGD5SnshgMsZ2rlzUUB3NV7azaOYqifOjTbAmvCGRbbaV1PYU5VCdLSyigit1hQyiEM9jyScFZN5ybSktr+6kPrzPue/ph79Wrn1KpT4s7eo9IHSqqNyu2k5KWawkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ly/Jrmcdkap48OO8akA+nr2rPNFhEsfs4PTZS6ujoto=;
 b=oT9KjX9LAJTkf1BnbQHmLi1Zo+R3QPWon0TOHGdytDeFHvxBSq3jTlVr8Wq/gXQ9dG9eh7IEtUuZ/1+KOJdvBdPOkRCjCdmoalrJY+qxZ9vC5R3uDR18qzyfOaEsveeI83QdWM4dNgv056BerzNpuu452RbNweV/T0inkcudGGSTl1w7+15nNfuenXlm2skXOO/h7KAGmwj5EatngobkC1adj7RXON55gVNSWLfJ32IjMGRyMFLdL9pveleKU5prHP/bYIRWiG3xzNe3SZ4GTnSWGZy5XW73aebIDNWbOPr/MtTj8uFEQJg1YI+5ivFMDUUqC5Hp1762aNQ7wgwl5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ly/Jrmcdkap48OO8akA+nr2rPNFhEsfs4PTZS6ujoto=;
 b=djxvhlQDPj64E7aqFX4YHPm3W6qRSy6ArrqEzKNdZ403pTQK1UM/RiBxEYNFLsYXLJTvSuQRSl322cStzIpUP0wag6vra725D9rfLdB8DlveUl/gyz0ysOfPA2F7ucR46oupXAb8PZyGhr8I0+qRZ6p/vutkkGFj1d2ROGKzuryS+NVJNfKF2mIxiNzlcyqEUtxPEtoxQx0oGl0KVypAD0+OEa0/8GkQLq56vIwLCmb626gryPtPPn8D9be6gSPVJXcfoFPNAp8jvgnwRnKo4QE7/mHHogTTv/N6gyGAugolEkw0sLo8qxmr4D/Rc/BtWGiH8kJx5CEbN7MuuzQXAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6201.namprd12.prod.outlook.com (2603:10b6:930:26::16)
 by CH2PR12MB5017.namprd12.prod.outlook.com (2603:10b6:610:36::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 13:58:22 +0000
Received: from CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::a7a3:1d9d:1fa:5136]) by CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::a7a3:1d9d:1fa:5136%8]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 13:58:22 +0000
Message-ID: <9dba94bb-3e40-6809-3f5a-cbb0ae19c5b7@nvidia.com>
Date:   Mon, 1 May 2023 09:58:18 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net v1 2/2] virtio_net: Close queue pairs using helper
 function
To:     Simon Horman <simon.horman@corigine.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        William Tu <witu@nvidia.com>, Parav Pandit <parav@nvidia.com>
References: <20230428224346.68211-1-feliu@nvidia.com>
 <ZE+0RsBYDTgnauOX@corigine.com>
From:   Feng Liu <feliu@nvidia.com>
In-Reply-To: <ZE+0RsBYDTgnauOX@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:805:de::32) To CY5PR12MB6201.namprd12.prod.outlook.com
 (2603:10b6:930:26::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6201:EE_|CH2PR12MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f6ec97c-ec03-4de2-e032-08db4a4c202d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PxRqKspMaEWI6qajPlGrhWHyjlVMUyh5FVQCyxQVJSN7t9FTCuIjMmLZHjm+LZPsMhPEpsnYrptUZd6Hi7CAGaVejaNZ/UsmWL2k2LW7A+T5PAmwdsQdAJAYoc5QizBLnatmElwQT6gxE/11sWx0V9YPUAdJITusz1izZHczuZxGc4+T/Jz0sGZwu2wyiGwKT8OPk1r2cWEay36p9MkrIfTQRWN2yJvXBOodD8tOChRsiVSRvoLHZc6fTMyGGu5Z8u4Aq9unvNjDEKgWvbup3o+AuS0sG40KgG77iPPwME3PtQBOycrOW3Z/sj2sk5J2qIcL4l5d+dfJbfEHUcI3Lv8uawI/HcXHpsJ7KBpeX4QVSSyJAGQ0KLRhqH7jIFzmVTwX0+2bBl4TVfh4HU8SO+ByeFMJ5oFcjuerxJV5i1oU9S8rJQJUR362gZ4GZvoivQv0VQWV9y1STm+DjXY2XtooB3fd5iGeQQ6FlS9tdpk3m9dUCFq9240eeSbBvmVR5DdfqK25/PLyxSDwl8SwowBlf0FMre0lSlUkxNFqBHg5BbAFgvI013JxXahWR7EvA2uGdW1I9DlgsUcmdCZpffLk3GIRQ1dFcslEL6PqCzfbtDnERm8FUVbL8h6PvSk4TUdX33Vmy4An0eVQH/J/8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199021)(2906002)(478600001)(66476007)(66946007)(41300700001)(6916009)(4326008)(66556008)(316002)(5660300002)(4744005)(54906003)(8676002)(8936002)(38100700002)(6512007)(6506007)(107886003)(2616005)(31686004)(31696002)(86362001)(36756003)(6486002)(6666004)(186003)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzJPSFlvYjFBd0ljQlhhM3JHVHc3d3R6T1JleDYyZHRFaEEzRFlvd0tEWmVt?=
 =?utf-8?B?K1V2cFRGTlpIcyszNU5sYVhIaVBMU1dnRi9wOUR2ODFEOHhsZUdNSDY4STBz?=
 =?utf-8?B?eUk0SWhrTHA4L21tSngzcDlyTWZLZDRMbm1RWFZZTmVISVowUFVQYXB3dEZW?=
 =?utf-8?B?c0dhOUowaFlodHJ5VWZRQlhqQkhwR0VVbnJWcGRRaERJbXd0VFJEaHlIUVNn?=
 =?utf-8?B?c3BBVzZlcExZMjBnS0U1OHAxU1BaOXJvVldWUU1KQXlBUzR6M3NBUmwxazZm?=
 =?utf-8?B?R2FpaHpXUFlLSDRzOUlHZHlRV3J4MkpkRVo3eW1OZmVDWXpUdGVUY2xPTXU4?=
 =?utf-8?B?UXEyQnY2eklRQjZlcE1KamFvMmNXOGFkeUhwdDNZK2MwRXlTUWphYkQrK1dr?=
 =?utf-8?B?NXRaK2N4YjNsQW0zQWQ3V2RHbEMzbjB4NmdtcU9FQ0VHYW84OThsSU9YYmdW?=
 =?utf-8?B?cjJpLzlhS21xVFkyZkxhOXJnTlFoZzBxRFNlVU84ZjZwaTVMMVZpODIxMEpV?=
 =?utf-8?B?RXdaUVZNempPdVozS25vdGl5dVRYeUVVS1dYZ1ZsYnpkenA4WmQyYjhiM0RJ?=
 =?utf-8?B?bnhvT0I1Z2NhVmZXd2tVSDFnMklyQmE4M0kvdWNzRW5CZy9vRElHVXY0U01T?=
 =?utf-8?B?bW8vN0tHd0tmMWFpTXc0bHVVMCs3V2RSL09HcnJuSFFMOXY5R0ZBd2dwaVR4?=
 =?utf-8?B?TEt6NUZPbkhUUCtVNWcrUzJRVWtJbmFxNExNSDVyMEJNQ0tMNnNDWlM5UUJl?=
 =?utf-8?B?UnN1amlvR05TbEV6MjRqRmlXNEp6OWRobzJMU2JBaGNubkhWVDBqaHNLVW1V?=
 =?utf-8?B?eE5wYjRBTm5ob1FZZFRTSkJwMU1BeVM2SGFqWm5LYUJJeVlRd1l0U1JBS09l?=
 =?utf-8?B?d1pRWDMzMDVnNlJwWFh3dHFLa0NnRTM1cEx3TUFIbTJuY3NRVjg5WnZ0d1Zo?=
 =?utf-8?B?RnNVUEhxQVcrYzY5b3ZsWFVrdDh5Q2l6eHhBT2h5UVBCVzdCM2ZqbXFIZCta?=
 =?utf-8?B?L1pUeFo2NjFmbFozaE1Kc1FHM1lTQ0wvbHRvN2hxLytKWENpKytqd1d0MHpU?=
 =?utf-8?B?SmNndGRqWG11dGZxUjNWYnFhS3hKRjJpNTZ0dGJ1Rm96ZjMyd0x3b09WeTVk?=
 =?utf-8?B?RktSaWMvbHlPS3VKbkxlaE1QeTdwRU43TkxJQ3pNWnhPa3JFYXNTZzJnT0xZ?=
 =?utf-8?B?TW1RdVNSMDZFd3ZFbmVucmhRZWUyWUlHOWx3VVpwVjlyVG1yaDR1WWlNUDQy?=
 =?utf-8?B?UU1qQnI1OUw1M3dpUWh3R1VlMWtTcjBGZ1BrWmg2MTFPK01IRE1IemQ1WEJW?=
 =?utf-8?B?MENZS3dyV2NrSHJtTmhOK1p6TWhsNVFtdk9NTTF6MlE3bERLRmFubitVaUdy?=
 =?utf-8?B?VVFwM2tUT1owZ29qMU5ucS9aSGF2RnBSdkgxVWdjaHMrZWNZd0FPRWlkK2R4?=
 =?utf-8?B?K2JrMnRMUkVGN1dOSXl5NURXZnVJTDFNb08wWWZTc3ZzRlgwZC85SUYrTTVo?=
 =?utf-8?B?VFF4R2JUQUNGby83bjV4Q3NqWElXUitSU013WjA3VWcrN3RtWEdVN0F2VVFo?=
 =?utf-8?B?Zkc0SnJFWkUxVWk5dlM2UXNla1RCazB4R2NhU21ZYmtBOHZ5S1RDRDYwQ0U5?=
 =?utf-8?B?UUtaMnZibU4rRGZSS3BmRG0zdWt0Z2tTSEJnQ1RneUNUSW1uVkR4dzVlWDly?=
 =?utf-8?B?NUpLOWFjUFpHMUYrL2xXZ3dGNW5FaWdNN2lwQnNIYVBpV0NQajFnOS9FQlFW?=
 =?utf-8?B?ejZTNVNoL3ZJSmxKdW0yanVpTTkzVjZmWEk0bHZ5Z1VQU1BNalM4Nk11N2RO?=
 =?utf-8?B?RG1sSWQyUTcxdWRTeWY4SmMyb1FXeXU1cWJYZnNMOThxLzArSkZ6eEVaUmk1?=
 =?utf-8?B?N2haUnhjMkd6VzB6M05xS1UrUnlWWnNJbUdtaHNJZXI3WG1BUktoY2tURWpZ?=
 =?utf-8?B?NnJuUmJlbzk3NlBwMkNFZlU4ajRDdm03MXoyRHhSVlJOSUVRTUQ2bGhTQWNl?=
 =?utf-8?B?YWp4NzFMNU5OZUhGTkRJMzR6MHRCWUFRVG5QRThxN1VpZ2Q0Rng4NnYrNUox?=
 =?utf-8?B?N2cyRXBtako1SmZia0EvQXNTZXE1ZTVUOEJIOGU3QVVzZjExeW5kOUxpTUpQ?=
 =?utf-8?Q?SKMW+G7E3sB1fBQ98ACNd3Rof?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6ec97c-ec03-4de2-e032-08db4a4c202d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 13:58:22.2380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dGhjaxc1ijizVJcYhZTgjk4+Hi+2HJPT4AJ8UKZ3v3lFinTv8KeGlfvS2diudAbI8rCxNBVB6dGVpehR6Ktb3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5017
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



On 2023-05-01 a.m.8:44, Simon Horman wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Fri, Apr 28, 2023 at 06:43:46PM -0400, Feng Liu wrote:
>> Use newly introduced helper function that exactly does the same of
>> closing the queue pairs.
>>
>> Signed-off-by: Feng Liu <feliu@nvidia.com>
>> Reviewed-by: William Tu <witu@nvidia.com>
>> Reviewed-by: Parav Pandit <parav@nvidia.com>
> 
> I guess this was put in a separate patch to 1/2, as it's more
> net-next material, as opposed to 1/2 which seems to be net material.
> FWIIW, I'd lean to putting 1/2 in net. And holding this one for net-next.
> 
> That aside, this looks good to me.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Will do, thanks Simon
