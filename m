Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC016439A1
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 00:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiLEXiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 18:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbiLEXht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 18:37:49 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A356DF37
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 15:37:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNhFUL9JZWe/hTdsBT5rgN92Gy63kBdeHGGyrr+7ZFROKgz8E4JYqAaKlynuTNVKOSO81vmX1vclBkYf06BUeAUc/zHp4GeYESg+QVlpAUfvtspwZxmf4Np2T5tVXxztz3SEvPAf3FsHIHlani+wmw75cJBq1EfzyU9lrXR9braJFR1GOvcpkwRPZSdtsmvgFmv+hjbUtpyAc49OhK9JeESD5wUSiukIzcu/eassxbwpf3LDfGlRCs0OL7RzFdrfD9U6bqPNBAAQQHlAwL0x3amBWjLZ5YGFSPCsVBAIg/Dn/3IASiNPxcrxHn+7tqbVMQM7QffUUHAKJbtbWW6aSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wACtw72BcviLe8lLSHosBls5kPDOj85RK9UyxuizInA=;
 b=WzG4MVUJXfxegIwqZ8JaxQzSjWv6WvOAFuYzgiWyYpjVB57s3obT1Ju0ZTvTOn+MeaW2qZJsVg7GZiZVixj6snGQX70BtBHxLRt033jQBZ8dZjhteL3b5oOCXsft/15WW62L7B25B15RVF/aTQdGc5Pfg99gS5zio+JDiFFIuH/wtRHK66KmQdLRRc+qM1bZ/uvTiiSFDInZZATicoWYw1TudsPAixSfw8HM6O7Ho02dyeZMTdccdCwmZjFMoLaN9pn9EwAutfdC3AzWb5pjYF8+F/d+NItNfUWIaz+A1YHpplLfWpCL2vOizuqK+QD9VBNw+D/FblkXmyV5O9STcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wACtw72BcviLe8lLSHosBls5kPDOj85RK9UyxuizInA=;
 b=qeun9Y6jO3tYx12sv7t/JenElF07UxBC5UiXjVKE/9YH+UjOa4mW0qyEx00OxXT2ft8qWgCvRP5jIWAuaoqau8s/iXPENeJ15wSd7v3GI/kXSgUJ9i7sAhvjxhXDizZQfazfNW8HTGHzRHoVoZFogzKOwdGINZhJdygxTt0i5Ck=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DM8PR12MB5429.namprd12.prod.outlook.com (2603:10b6:8:29::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Mon, 5 Dec 2022 23:37:46 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%7]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 23:37:46 +0000
Message-ID: <7e3deb3a-a3fd-d954-3b6f-8d2547e036d5@amd.com>
Date:   Mon, 5 Dec 2022 15:37:44 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net-next V3 7/8] devlink: Expose port function commands to
 control migratable
Content-Language: en-US
To:     Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Cc:     danielj@nvidia.com, yishaih@nvidia.com, jiri@nvidia.com,
        saeedm@nvidia.com, parav@nvidia.com
References: <20221204141632.201932-1-shayd@nvidia.com>
 <20221204141632.201932-8-shayd@nvidia.com>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <20221204141632.201932-8-shayd@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0077.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::18) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DM8PR12MB5429:EE_
X-MS-Office365-Filtering-Correlation-Id: f3e9c1a5-5eb7-4d48-353d-08dad719b6d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KPWyw30HUySv+4tj7HMuPFEC4+8T/srcavh9A104TSwh2zqcwWrdL+nolYr8eFnQZx0Eqm6DhsSRuNb9QlyfXfFVyH/p9e6YQ8l8OyR5nsIjxfQwjoohN0eHwNUAWszQ+883emt3uCuFX/iZJXehhKTlLbBaEZw/0SGzGFk/WzT10HDx228dMN7YISWzf+deJjdo/ZMp7/Kkd29QxVRfGcjVXWV/OoOFBvspkjby4No/i0NNwWjfoxMK9+IJK+NKgoZ6MlplD8XSIuADIXNpTWSs2mj6GCQFXQul6SQjWXy6hcmFnmBqHoE/Ib8YgtiW5+T+BCXVHgrsY9SsAR6lRmCLbjxKj2XJLo+hKhy8rRzpBHxzeliFNVdKd/bk5y2Mv09ug79/dnOZK5mhXaPXhbi6HqYkcI5A+wqfKC3eKs4jkGp/9zw6VrP6fAfxugirwyuTNkcMvUBwDK9qjapgr/EGZRNi5CsBjLh5Dx77oNZg834K9hQplgV0WGmH9evfDkE62S5McLmVI6ibj7zTfsrQAFOFL1rMcBJa60bLo7BD5ZiE7AabctYmndwSYksrwlFcLbwYBPFAQy2mv0Few7Lk+vP0cvsT0GRNNjbtwy4f0PaVm9OnJu2gn3OrO0QE+d2D7w+l4Spr2hyhGLqTN7bsunM3rdMDoeRAIZMozhvzB2WA5pi+2+jb0VKRANP0g+Ml14t5hXVoxRU8vSTQm4GiIZqWG1qw6LYNdgGiuKM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(451199015)(83380400001)(31696002)(38100700002)(5660300002)(8936002)(41300700001)(2906002)(4326008)(8676002)(26005)(6506007)(53546011)(186003)(6512007)(316002)(2616005)(66556008)(66946007)(6486002)(66476007)(478600001)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnpMRElQc0wrRGYwOGM1NVdyaU1KTkN6dmhGeWVybWRSSENIY3UrL1FkV2ho?=
 =?utf-8?B?ZHBxaldnaTVGcUcybXZFS2NMaXhvcFcyMWlVOXQ0OUNHS241R1RHQmR2L2g5?=
 =?utf-8?B?UnNUcUZJZFBIR2E1OEVBOG9FS2theEJSelFkbCttYWdWUEFjMGdyTldvekZr?=
 =?utf-8?B?L2hqVXJTMk5Id0xtNmJhQndDOFdvL29ZeGkvRmdSbkpTVmV4ZWhleW41cHhs?=
 =?utf-8?B?anVWRWVtWnd1THlLMlRxK3hXTjlOTDNJQkpVZUYvWFFsSk5YQm55TXUvWjVK?=
 =?utf-8?B?WXRMRG13VjJ1Qjg3Wk9vQ2NBVGttRHI1NWFhb1VsdTM0dzk2UVhtNEpaMnZK?=
 =?utf-8?B?djlUVnltb3hnRGlLc2RCcTJhNlV0NVEwRWd6b3RHZ3IrL2t1VjlqNW5Ycll5?=
 =?utf-8?B?eUdEQmFHVmJCVlUyK0RmQzVRbXM0dE1iaGhPMXBEY0E5WUJFblhIVEdYUzBx?=
 =?utf-8?B?ODA3ODF0bXNYNTBrMWtJZGJPTmN4azNEZEI0WHdoV2FYZVFEOGUwcm5XWnJo?=
 =?utf-8?B?QmNNMmZ3OHFsOVpWNTFpQ3h5bGhobmtIdzROdU1DTWlXejArc0tIRWlBRXJ4?=
 =?utf-8?B?R3ZoMVY2WDkxSm5mTldXSEtNUFkwLzRHUG15dHVmTVlZNUxyZGo2SGhUQjlh?=
 =?utf-8?B?bzNiU3VEWGFWbmJMVzEvOHlPRWxVY2FxWXI3VC9aeStVdStBME9ydXhXbFpo?=
 =?utf-8?B?c0kvdTF4YVRuSmoxS2dCUTI3ZWhpVFExeFFEOWc2U1NaMzdCRkkzamFCODVC?=
 =?utf-8?B?MXJ5VGVmdG4zY0NBeklrMVVhYzRYNEgzTERnUDVUUXJXTjI2UXlrYWNaSkpJ?=
 =?utf-8?B?NEwyUjVRbmk0WGtxY2hNNmZiZXcwRTZWZENpTEpzZll1S3RZUFljZzJwY1N5?=
 =?utf-8?B?N2V0WGJyMm5LTFd2TkJ3ZFFVMS9DbWRkKzY3YUFKMUpCSWduZ21vOXF2Yy92?=
 =?utf-8?B?cjRodGVDWVc0WEMzU0ZTQURGOU5GZFI2T3MwT2o2WmpuZC9ubUs2VU9EYVVt?=
 =?utf-8?B?R2VEWGt0VDhYTGh2SW9yRkNqa1N0QW5wLzIwRXVrb2NWSzBVMWZFa2hKd1gy?=
 =?utf-8?B?VHZ6NzBEaDdUVUh6YzNOcVBkQ1hFb0lkbG9LSEVQdU42V1ZyWXNMQUNVRFdn?=
 =?utf-8?B?ZkhYcVNDS1Z2eGFWT2ErRWU1MStvMHpQUTJlNGVyWHVCY2svUUxXOXpFeVh1?=
 =?utf-8?B?a0FlcFBlMGZ5UVJCanBGN3loN1NWa3kzRjc3a2F4Y05TMDFVeXRjNHlHTUpB?=
 =?utf-8?B?ZzFTdHFQWW16V3dlKzNhTnY2TUp1bTNpTFRtSlZSbVcwZzAvS0NFSW9Hb09t?=
 =?utf-8?B?cXpWZ1kyTWpPWkZha3ptdis5SzV5ekRDU0FrQ2Z3eUZRYTNtV3NIZGtwN2VH?=
 =?utf-8?B?M0R5NTh0eVUvNGF5eXFUYVM5b0F0Y2pvOXAvWXU1ZmtWaDBZTFU4QU5lVHVI?=
 =?utf-8?B?aHFYNHh6dnVwZ1lTcWRkMDRCaUY0VjIwRWZ1UGZiQXlYd095WGRQQ09GWlVD?=
 =?utf-8?B?VkJFWXJnOHVGU2M2dlozck1RWlBIeE8xb1U1bEhvdFQ0eURoblRRcU1xVXl0?=
 =?utf-8?B?aGs5UGxNejU4UkM4OTlXaG5lN1JWMGExYmxxUURnK2FTazJvY2lBWGtZOVpT?=
 =?utf-8?B?dk1yOVhreVg0SGQwMEE1TlYzVmxjUlRyU3FmdjZESFdXTWw4bFZTV2xIZGRR?=
 =?utf-8?B?aC9jbTZKQ05STG9EbWh3REdlMVFWSnB3blp1MHdNVkRRekY3NUQ2bXFvc09Y?=
 =?utf-8?B?VUY4dktoNTB4SWZWNDM1cFJJMFZiRmxZaWJSNW84N2M4TytKWmV6bUlHUTUx?=
 =?utf-8?B?SUpBU1UyNWRMQXgxNUVjMi9VM205azhTMGkzTlg5SGxRSDlVODcvR1BWSGNV?=
 =?utf-8?B?ZUUzTVRrdWltYzJzVU5qbSsybG5sLy9FWEt3Z3h5dGw1RlY2UE1QL1c4eWxQ?=
 =?utf-8?B?d3hFNHg2OHlkWmRNRk1qdzRnbkZIVTYwcUM3b3FzMzNzQTJsQkZNVVhWQTdY?=
 =?utf-8?B?TkJJWVo5QjMwcDRSVG9jVzRQU3FTR3UwR2tDd1RMUzkyRWVhQzYvaTVGZjdI?=
 =?utf-8?B?QnJzMGFyK2xLczRNd1JKSk5PNytXVTVBUjR1N09iVEVsNEhQd0tpeitieVNQ?=
 =?utf-8?Q?AaB+mnDvPjLgJIHmvFIs9CheG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e9c1a5-5eb7-4d48-353d-08dad719b6d4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 23:37:46.8799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYzJ8ppBlmecbRPiFl1H8yRxtf6EsKv7k5am8xHIf8u2Mw7Z7mKICLTKHA9Ylx18zjoUX7h0/mmZI4yBZXyFIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5429
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/22 6:16 AM, Shay Drory wrote:
> Expose port function commands to enable / disable migratable
> capability, this is used to set the port function as migratable.

Since most or the devlink attributes, parameters, etc are named as nouns 
or verbs (e.g. roce, running, rate, err_count, enable_sriov, etc), 
seeing this term in an adjective form is a bit jarring.  This may seem 
like a picky thing, but can we use "migrate" or "migration" throughout 
this patch rather than "migratable"?

> 
> Live migration is the process of transferring a live virtual machine
> from one physical host to another without disrupting its normal
> operation.
> 
> In order for a VM to be able to perform LM, all the VM components must
> be able to perform migration. e.g.: to be migratable.
> In order for VF to be migratable, VF must be bound to VFIO driver with
> migration support.
> 
> When migratable capability is enable for a function of the port, the

s/enable/enabled/



> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 20306fb8a1d9..fdb5e8da33ce 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1470,6 +1470,27 @@ struct devlink_ops {
>          int (*port_function_roce_set)(struct devlink_port *devlink_port,
>                                        bool enable,
>                                        struct netlink_ext_ack *extack);
> +       /**
> +        * @port_function_mig_get: Port function's migratable get function.

I would prefer to see 'mig' spelled out as 'migration'

sln
