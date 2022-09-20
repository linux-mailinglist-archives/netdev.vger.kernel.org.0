Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4ED5BE778
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiITNqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiITNqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:46:13 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF13B1FE
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:46:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1NdcSOqwON06CUHYl+LaLnplXV4lJCGODGoTfzSBvf56oc1EDhwa8ZlDki3bS0wL6iA2Hog2lbH8CkdTf7kokjQWAGdQg9XLgeLHmaC7SFwrD/FGwaJxklH3aNWEIx8xAEGhJQ6UWO0/BVjEctWQhUGbl+/EOGfFsQ8EmGWD/Q0RPI04Vy1HclonJsZtbcnMpUznuVKFNBT83wdzEtMSazdCBddwJBko4bih8yufDI82SWtU8UFal/nZaH95dB1tjsTJihPEGi0qcTkEzEEw1xqP32Er1i8Rx1/jvCBRm1z4ytaHW09pCE5Ra683lxPNUTNegDwWXbOFlDOmYjQbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3ruSUek2HZpA12uWpflPPeI4CwwYuU9cyEch8bRQWY=;
 b=ni98DPtCI4nsb/0gyyWRtswSH8lFH3x9pR3TTTZO2JUo7lnlLM5dPvNgstsBSX4hBGp8Y1HinTC2UaxfbDxNpz6kqOAPAAjB0E8Qmortt1SJ6FD1oTGAcGbWqJRg8SP7utm0PCiZRzI97yj2pFxeNmzuwBdgSrvLeRPsPqVOql4I+kJjzYOEDlnN83wT7BmaUg/gDCbz6d85bQ0RGDzIqhBCE61pfYOzXmV4DucFOVjSMXPsLOQEnBgvoCRlQaxEkxYCAWiBMNq7KFsdZ1z8yccV9lc8Xjiwwba+rj0D2qKmlqT4wKojNJe/fWsfI6uTWHR1NIC9UOin2WNUht09jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3ruSUek2HZpA12uWpflPPeI4CwwYuU9cyEch8bRQWY=;
 b=qZVXDHh9YQ6IRDsh7w7KVYcu9rvmyrjokDYCOOSzAh/L0/AMqlYs9M6bnxcX4ZmkRRLAB6IBahJPD9wsoLLJEmz0BBZVEsNRdgMqy7+5dKaeCyNDlA9ld+dYpjW2Cx0i/yvN9nSJSsiF6L/qpU4XhgbYMp5WyORyTvZzRM/RuKW7+tOU2KEsSHzCztMkj/6lKQ6ptpDAuLSHQWZuRYjBhWtly1RiSFO5M0NRfE0/CyIqrxUA1P5TEnahXDaj3seIgUl2JoaMlEKedtC24ILWT7a+I3URYA8pTlvFqjjTw1Dozavh9ZD/eYUEwyUcZ2Q1fakNbwiEPz7jHy3YH1XsTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by PH0PR12MB5648.namprd12.prod.outlook.com (2603:10b6:510:14b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Tue, 20 Sep
 2022 13:46:08 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::c4ee:2739:5cbc:4f7c]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::c4ee:2739:5cbc:4f7c%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 13:46:08 +0000
Message-ID: <0a97bab1-2d5e-073b-e439-4e6e745dad52@nvidia.com>
Date:   Tue, 20 Sep 2022 21:45:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [virtio-dev] [PATCH v5 0/2] Improve virtio performance for 9k mtu
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, sridhar.samudrala@intel.com,
        jasowang@redhat.com, loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org, mst@redhat.com, gavi@nvidia.com,
        parav@nvidia.com
References: <20220901021038.84751-1-gavinl@nvidia.com>
 <76fca691-aff5-ad9e-6228-0377e2890a05@nvidia.com>
 <20220919083552.60449589@kernel.org>
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <20220919083552.60449589@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0116.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::20) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|PH0PR12MB5648:EE_
X-MS-Office365-Filtering-Correlation-Id: bf198847-f723-4fe0-01bb-08da9b0e78a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wlaX8VfZi9JouSs4hCWn3kyQZJmd82o4NkDwQzwvRlM7EUmfHNhtNW4Ye/Ays1XMXTgEKld6XZqfXJ4wDrGYhGaUI1bsS+GQvtpFuRlA4m3dOr6XjCZdGSXTQWJ79yy1pWXnzFMBWKF6pY5I4YyYGgy/0eow0YH74whtKRE6vh5MoDODz4Ko8VmcCD5Ukx7r97MT38NS1fZh2zxk9Veirt8kk2d55TapBlG5Wy4jmD2QJGVXTiKhCmQO4ojM7K8dxkqCfK8ZBsPtJs+ZvaOf+Zqvi6BzCgwaSfX+2Xj3/uroXkmjRu/YjYmXP9iKwRp58NYOgEPiFP/06idqsvQiSm5YhTbbelQl7dbQZ/d77/xt6HtN4fJwdSCRqRl8g/8SICBNci5gDkQ6cUJjMitWca2ESc7oXbDambhBKQYJNq4wMOJE9Am6D4li+fUeKPTgoX/em83VM9rLqyZomc4VvrL21x4b78dCzg3Sktbw+2god0AaGMkeDrd0/XyBYTmrlma+kdPQhaQ2KWM4UnBfjWDMixnfRIlvaednmCLwt1XFYdgWlPMvtE3xCF31dpWSrnSSARug+1BoPgmM6j9h5OezJvfB5obQ+GZE2lLzBBl9DX4UUvnGnI4ID8ZH0Km3QR9GVYApoGGwY9vjD3p4dk4ixMiXA2LdKu/oFqMCwA+J/x9+CksrBNY7RzA0Q3c6vu/W6HcZ5zLTvz+RKtLxTEagwcj3dniKLA3vQ12rJEGz2eg5zZ90Jyku23lQb/NOdL/zyFfJtCXCkJMmcDWgMHnKP4+vU7SyMCEVt8zez+bdciFhRsEFtqQNMTz9C/3j7mDKAGZuBvr+USyXTz6RYqa4ufUf7wFWS5gpyEx9j9hh8FdLLDIe57IafLKnCq6p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199015)(53546011)(41300700001)(6506007)(107886003)(6666004)(6486002)(31686004)(478600001)(966005)(186003)(2616005)(7416002)(36756003)(8936002)(66946007)(316002)(66476007)(8676002)(4326008)(86362001)(4744005)(5660300002)(66556008)(6916009)(31696002)(26005)(2906002)(38100700002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjlyOE1LSlZ3ak9PZGJQdldnNEVvUTc4dUxSRzltZzNKVlp3QlpIeDY4dG1Q?=
 =?utf-8?B?SXlRTkdhZWZZUDg4Zzc1Z1Q3OEppTDNBSXU4d0JOVk43TUgwdzdQU0NPZDZH?=
 =?utf-8?B?REM4ZnNIMTNVREVjdkRyNVU1MlFYbDJrSXN2MTQ1NTcreWdydG9FQzhYaTVU?=
 =?utf-8?B?ZTFaQ3B5aFhyUkpsc1A3eFpBcnltVHNYalRGSVhNR0RYbUdCQjZveitxd0g5?=
 =?utf-8?B?MVptUDdXOVExQStPbzRQZkgwTElmWlpJTTlwOENUSk9wd2x3Z0RxblV2QmJU?=
 =?utf-8?B?ZDZJa1FHSUpLMUR1MnNFZXBpZmtzUFBYc1dTaVZ1OE9ybkxaU2ZocnRqWGtG?=
 =?utf-8?B?a29leWovNUpYUngwY1dHYTByZEdnVW5CN3Zua1Rwd1ZmSW8yMzVGc2d6amVT?=
 =?utf-8?B?SW5pdHZENDNtWEszYVFuVTFBNExDUVdFazhWNjZRNm9OMGZ2WHNTcUpnbW9G?=
 =?utf-8?B?bERrdFY3aG12ZmhwcG9tVzZqTDNueHFuTXpVak9sVHRKa00wZkp4L1RjcTdQ?=
 =?utf-8?B?cjMrRkxmVnp6TTh3Vlc1ZTdlWkorMW9XOXdkVmxVcHhZbldTbS9jV0ZaUTFi?=
 =?utf-8?B?RlNTeXcvUFllelVnTmZXZFI1bnpYVWx5ZEF3aEhvUzBaR0k0aTdKcHpUZ2RY?=
 =?utf-8?B?UlZHRXkrMW9qVGMwd2pod0EzcGpsWVVhRWo5cHlha3A4djllWkhGdmNQakRL?=
 =?utf-8?B?TC9LTDNncGlSdW1kbHRHbGhsT2FFSmlmeVQzRnRKUnJqaDVXNHdTMTc3QUpW?=
 =?utf-8?B?RG8rTTd4SVlDR3VHdnFBRjB2LzBjVXF3K1FYOGQwTVpoQ1E2ODdUVmo3VWNp?=
 =?utf-8?B?anpuYXhRdmpncEhHbjZ4VklFSFMzbVo2aTZ0NnJXdkNQbGZzNVVlcUtzTjYw?=
 =?utf-8?B?MHE4YU93QlpJT3dmZ2ljc0tsSm5paGFGZFBMZHg2a04wQ05WaE5JOEsxQkhC?=
 =?utf-8?B?c0JoWnNvWjhJS0tEd2MzN1IrbVBjdHNSS2YvR0dKWTF3VTQ4ckxENUNHa3Ba?=
 =?utf-8?B?bU1KT3hXVTllaTgzYmEvRWZBQWNNTEVFSGswVXEyek53QzFyd2haSTk2VFRR?=
 =?utf-8?B?b3A4U0k2RFBZeXJ0ZXN0WnJzVGZPbFlOR2puM1dsalF3cTlmR3dsbEFxd0kv?=
 =?utf-8?B?UTVKMVVXSzVEVmZ2SWhkZGNmQU5NLzhaRFEzL1RpODMyRi9kaThhc2dFdm5T?=
 =?utf-8?B?MzdnSlE5dlVCSnpUQzdyd0NId3Y5QmRBNXJOTVhhSEFLWEdSV1FGdFltUlhw?=
 =?utf-8?B?bzdidit2ZlRuNHJlN0JPZkgxV05OUk9vR1AwOUh3cVNhWGhoY21aQnc1MlRy?=
 =?utf-8?B?cFlKUS84VmNva3RUeXVZWWNZNTg4M3RPMGIxK0gyVHNNcytiNnp2OXp6Zis3?=
 =?utf-8?B?SDUrd3ZhUW9yT0xYVHJmRVJzaDluUVp5OCtKU2RsOUUrdS9FNnFvRUE0NTFs?=
 =?utf-8?B?Z0V4SWx2VDBNTmc0NWsyb3pHWkh6S2ZOQXdBYTA2VFFheEQxcWpyUTEwd2dl?=
 =?utf-8?B?N0Mzc2VaWEZzRHRJZFJhVkpoNk1nUEVUZmF4cklPSUhOdWtnT0ljVHhNRSsw?=
 =?utf-8?B?NjFPWHdPSnVLMnNCVUZDSHAvOStSNjZaUTd6dlYvT2UyUFdXVDl0UmV2bTdJ?=
 =?utf-8?B?Qkd0YnpyN2VmblFWK2JubUVLcGdYR2ZIeEFRc3FnZWhBZStrVDVNOUQwcllt?=
 =?utf-8?B?cjFtQkhrbG9XaXBWWnNMWDVORXd6dDhERG43czFMMTk0TUhnc2xGQXIydVNP?=
 =?utf-8?B?RXhEa2ZvQmJxeC90QWVDRktndzh4NnVRRTByY3RiZllJQmdsb0JwSXl5SG5v?=
 =?utf-8?B?dU5QdlBrN2lTS1IwRWVxR04rL2Fya1pzRkNqbFppQXEzUjNZdm5DR3lsVkdO?=
 =?utf-8?B?YVJlVXpNYVo5cHR2cTJ3SW5LN2RKVnJqSWN4dURtMUdjd1Jrem54N1RGMHp4?=
 =?utf-8?B?T1I4cGNJdVEzRVBTSmxUb00vMHorb1d3bk1KUnFXNlJSOStkUWsrQlMwZTIv?=
 =?utf-8?B?T0YrenhNcUhBSURXK3k3SjM4RVF5NStkUGxXMlp2dGxMZjN5Z0RQaGU1OVNh?=
 =?utf-8?B?ZWdLbnlaMlVZNmV3dC9pOC9BN1ZzWXlzUTV6bk1PaFg5WGF3Vlp4L1U3dnhn?=
 =?utf-8?Q?kXrwyP3e8S/X9d/dHjHmPuJs2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf198847-f723-4fe0-01bb-08da9b0e78a7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 13:46:08.5998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x1a2dBOVHiIAhWXUHEaVA9KloELbMFUCfEPdqC00gyrAAmLz3qmwKnKLUyds4U/aRdq1NZ4oFcblELFBa6ZWAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5648
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/19/2022 11:35 PM, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
>
>
> On Wed, 7 Sep 2022 10:57:01 +0800 Gavin Li wrote:
>> Hi Dave/Jakub, Michael,
>>
>> Sorry for the previous email formatting.
>> Should this 2-patch series merge through virtio tree or netdev tree?
> netdev seems appropriate, sorry for the delay

Sorry for the non-text format issue of last mail.

v6 is posted at link 
https://lore.kernel.org/netdev/20220914144911.56422-1-gavinl@nvidia.com/
Would you please review it?

