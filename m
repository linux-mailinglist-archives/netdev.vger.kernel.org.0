Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B75D62884D
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 19:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236870AbiKNSaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 13:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbiKNSaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 13:30:03 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09F524BEB
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 10:30:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlQq63ReB/BM1gGqxDij6+1F0CaFyW59f3fD93g1qgryI1JkStqokOicdKcE4j8Omw2t6NdEA2c6MaFeWOH7ztiMR6b6RK/9zBcTXsDFNNebRRaP8BPRf0Hubdb0RTXbAVom/HHbrm2nDDk+wCbwCiVgSTI4oS97Q4dko8ctM7YnoWQEH5AxyewF77v+V1HHU++uwr0Ss3YkrP3JDJajxVWbAmAnq0uaPNNTpWwjSpAw98RuUD1SpV6TY31S2mxyMF1jFSWAZvhLM8saOorSd7Xa1Z60b7Jcn/FlDwgzSOJpjmQphAwrPD+ZtvYENRI8b7TgaOZ3E2aw87jIpgP05A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdiHx0gPW1TARPFhSdyUECV2cF6ogIEcFzV96Ew0Ynk=;
 b=bD77817YZXqHcL9stIuX6qtfxSqK6o8G3CFoCIx+iw+QOqxNnG0NhD8wvds9XSOfecLFvRbYwAQH4+jP9klx5OfNH8DT6u+aWO4euQ66Tm2uKeRJxBd48Vr9MTU5pftZRpzL8I1jrtguqJb1yi+kiwc1eKRxa2nsYalsqXi3C8RmF/XyCBKmDq+5vVqRxQj7YQorECavG4WX7RpLmnexiGdeGiaccV96GKIxLPmP1lcLo8F/dvp7o+j7nIUIgQx0OS3fVgCAUhxCJOhSl1UNzUN60kGZE4oS/AJuQQwGVHFkZpnlSN2QZtkU45tNYnhua3pLgY8NJGq6vHASbzFtDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdiHx0gPW1TARPFhSdyUECV2cF6ogIEcFzV96Ew0Ynk=;
 b=o0V/H4JRKOG1QnHt3OUTFBT/4VIuD381TwZKSU2aZ6hUnH3rZPqW18nxX7l4lpkT6ph5yPyj0aG/EawvZBzbQTC1dP8jS9uS5O4r833Tvsx6dj36XXKT8l2CDWWpWQqib3XqNtrD+EIoJbLQy1vOzHE36qUuwY/JjGZKC8yTups=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH8PR12MB7448.namprd12.prod.outlook.com (2603:10b6:510:214::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 18:30:00 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%5]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 18:30:00 +0000
Message-ID: <c0ba2254-2c16-e471-5a98-56106121af6f@amd.com>
Date:   Mon, 14 Nov 2022 10:29:56 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH] net: ionic: Fix error handling in ionic_init_module()
Content-Language: en-US
To:     Yuan Can <yuancan@huawei.com>, snelson@pensando.io,
        drivers@pensando.io, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, brett@pensando.io,
        netdev@vger.kernel.org
References: <20221113092929.19161-1-yuancan@huawei.com>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <20221113092929.19161-1-yuancan@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0010.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::23) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH8PR12MB7448:EE_
X-MS-Office365-Filtering-Correlation-Id: 50d0a0b0-ff5b-4988-1510-08dac66e3d0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X0HNqMqmDbVsPvosYtCmFYSkeEwRE58a6mKCPkKl6eC+EpIHlFLlV52Dn/zVkQRPskCB7z/KmctDzyQ92Vl1F+D9cFsW0/RLZMQlW6c5TND3UvjfZvinUTKOx+ES2OiPF+dhAy6W3h5Hb0YRRXBihz6nVNQsL6FoYWJd9Bl9aK5y5iU/Xes3OdsyW/QYb02rktYc68zvLBYdDy/JWfHdwlpJcK50Qn/qU01BJDnlg1t8escVfeFgirR9VcIaoqNpu4+0Qb0kISG3bF+sN+/qwlMXT5xB6QHKttG2mPW8F0xZJ9RZXhrpDg0KvrFtmnE+Gdnrwy2pFKJaAwemuRz1UJNjTdc8uUoIjAbIFGpbWIN0GRTaNClWXbDoo68c6XId96vtUFlITWdM6RoPzqbK5CZSQ4mM8vKRTtL3rhb37w//16xw56jZGLU/rjVlz3SqPx6StokzN/wZp8z7jafZn0XSua8c6fiNas5olNk99jDX/lvQbeJZ6Cx56nnZhA9FPHsFIwsQfc44Dskw2pbuqW4aLUrMLinuzp0AD3wfYKxso8bD+YVYekYH9h2uMN81j+VeA0uXsFQYU43JtkraJC7Wj+VaqRxTDl2jEcIDzIvo95973m/zwX5xT7Q47msJ524pXiO3KYrXxZBYxVMPeHeXcLE60O/Xy1h5j+DFo5TLHHn+GaplIrkfeQ4vQjM5r7UgLKevew7Tz+cTIruNeSGntkawfXjwzSARFws5dhH3wPssPRh38+bNYG1WeEbWfszcw8nGGMMgC0Wd6wElcEYWqaGhNITgyFIkfbCEuqY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(366004)(376002)(39860400002)(451199015)(83380400001)(2616005)(186003)(2906002)(8936002)(38100700002)(6486002)(478600001)(26005)(6666004)(6512007)(6506007)(66556008)(66476007)(5660300002)(8676002)(53546011)(66946007)(41300700001)(316002)(31686004)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGk0YWFuYkxqR2RXNVZWMmROQk9wZStob1YwYmdSR2tPcm5KcVd3a0tTVUcx?=
 =?utf-8?B?NHNUV3YvMmYzbVh6VEtlUWJiTE1CYVBadWs1MGJid1ZyWFhnUlN5cWk1VnE0?=
 =?utf-8?B?WGx5YzJWcXNibmlpNjNVKzVacFRLdys3ZzRQY2hjcUZxaWxYblB1SDdVVENU?=
 =?utf-8?B?VlNKUXZxKzRVcVIxakFIVThhV2hHY09oTGFuRGdoSFlQcTg4OWVrQW9nNEtr?=
 =?utf-8?B?WHFocW5kQUNJbnNHYmxFdVVGZDZZajY5bmNJZkVXNk5aY01RbWc5cDBUam1u?=
 =?utf-8?B?ODFEYXFXbDgwODJzcmtFTllieEhnODhCSU1wVmFRUElJMGo4TGRSSmtXdHRY?=
 =?utf-8?B?R3hlWnVUTThNWTNSWkk0cjhyd1p0ZStHZkZGWXZqQm83SVRVdjlKbVFUR3hQ?=
 =?utf-8?B?MUtDbklpcDBYS2N5LzhoMERCaWdmaHp3V09iamxmWFFGeHBJYTRSTkQ1R2FT?=
 =?utf-8?B?TWJpcnhsbEl6RlpVWHhiT3Vsb2lsZDBzTjNqcjdKendheXhDdnM5Y2QzSzla?=
 =?utf-8?B?UHhVcE1xUUFDSFlpaXFCazYrK24vaVM1TFp4NERBYlBrYTRpeHU1dlEva1Nq?=
 =?utf-8?B?NiticllKN2VXMWgwS0hxTzVQV2NSU0kvdFFwNHAyamhVdGJuOWtibVJKVEh5?=
 =?utf-8?B?WGVOYjd0YXI5dGszSVkrQVJSOERSSmo3UnQ3ZmFCMzVNM0ZBcHlrbDFFWGtY?=
 =?utf-8?B?aDkwcUwyaVVqNlBMaE15Zms3YnFuWnpZZDFtenoxTThmcHZsQlZoNVlxVmcz?=
 =?utf-8?B?RFNTSnBuT0ZvVlUwems5RUFWUGI4d1Jid0JjanFRa0FiYml1RFE3a2FPNkpE?=
 =?utf-8?B?V2NhUE43eFRJK1YwZ2tFQTZ2S0N0eno1dWoxajlqN0w2WWNPM0E5SkpPK1N3?=
 =?utf-8?B?c3FXRFpnb1l6Qm84Uk83aXBRcHliSHkyZmJQeGhvM0NaM2RGeUFlRWd4THlr?=
 =?utf-8?B?OTRQSzFqZ3N5L2tyZlBYdGdiV1RUaEN0ZndXTmkxR1JWd0tvcEVMbWtCUGNv?=
 =?utf-8?B?TWE3U05wK01YVXQyMU5jWjM5K0J0cHl2OUdWRHcrQy8vdEtTbmlPN3I2b2RO?=
 =?utf-8?B?OU1PWkhxMk01b1g1MndRR1pST2ZTU1JpKzY0dE5OdEpDNTROMzRhUEZuYllj?=
 =?utf-8?B?VzlSdmhjMU5WOFlHdmFQVU9OdjNDK0NTUEk1Q0FCK0I4U0xyK1ZRK3Izcktq?=
 =?utf-8?B?ams2RTNNdU9zR0MvbVNuRGNmdmdwbFJ6SFRTZDZvM2dRVnBoazEwMVpmS29M?=
 =?utf-8?B?N1djL3ZOOEhTN3B5blI5UEgzR1NkeEEzaE1ubXJPSVRIdURiSERJSEplR2x4?=
 =?utf-8?B?MEprMjNmOVJpOGpYdFIvM09YdjVLR3hsaFUwY1llbWExeUNSZVhseXVhbnQ1?=
 =?utf-8?B?VnB4SEVNd2lCOWEvSm1lbGc1b3NsNmxBSlJIbXZwRXNMSjRhWGxGcnhUVGN0?=
 =?utf-8?B?clRQZzVsL0dLQlVsZ0wyVWovVERuSGxqMUxnRDc2UlVaemlIM3FscnV6cHJn?=
 =?utf-8?B?SWNqb0VFeUMyVnJUUmE1STZMWDFpN0x5L216b3RhcmNrbU14MVc3cWlYMGkr?=
 =?utf-8?B?UjI0M1loRzdZWVZNRjh3TXk3aVVoYjdxeXN3RHhnRzdXaGJXaTNTUVhmaS9s?=
 =?utf-8?B?dE1pSEtpUjNOQ2ZwSGdVUmJLenpyMFNyMnppQjBjZGN6MWNDMGE2cUxkb1Zj?=
 =?utf-8?B?bVNya3IrSlZ5MHJ5aDBJUDNpeCtSeHltMGc0S3lxM01XYWJheWMzOXI3ekk4?=
 =?utf-8?B?TmhsUWZyRTJPSjVyUVljcEpTVitmSjdLb0pkc0o1c2hvSlp3OVJiL0pzU05P?=
 =?utf-8?B?TEs2VWdxNkV3WE1FK2gwQTN5bThXcDVEbHRkR0tKZ01LUzI5Ym1iVlBINHB1?=
 =?utf-8?B?Zk5ENSthYTFsNE93alVYdXNSUGhPOUNXQmh4NHQvamRxV29RZ3JuN1QyTEJn?=
 =?utf-8?B?N2dzT0xvckE1ck53YlpjRldRUm5RNXljbzVqZlFQdHVvVjZTOXpGanh3L255?=
 =?utf-8?B?a2RKSHYxeldIdWdDWktCK0xPVFhHUmJvOGsrV3lYUE5aenpVT0tWdTlFazJF?=
 =?utf-8?B?T3h5dThsUk5zT2RabGhhZ3JVb2ppelc3REwzeCszeHdIbm1peWRwV0Uyak1k?=
 =?utf-8?Q?Px7GiJAofsn4VYbbD2DKjEK+M?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d0a0b0-ff5b-4988-1510-08dac66e3d0d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 18:30:00.1502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sWiXj47EhgoFG3q8szGmn6xdVKvVRcI9bTKa82KjPvh5iO6STz2gxymgfIHuYvffPnuAlJpPDZO146J4tFEnsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7448
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/22 1:29 AM, Yuan Can wrote:
> A problem about ionic create debugfs failed is triggered with the
> following log given:
> 
>   [  415.799514] debugfs: Directory 'ionic' with parent '/' already present!
> 
> The reason is that ionic_init_module() returns ionic_bus_register_driver()
> directly without checking its return value, if ionic_bus_register_driver()
> failed, it returns without destroy the newly created debugfs, resulting
> the debugfs of ionic can never be created later.
> 
>   ionic_init_module()
>     ionic_debugfs_create() # create debugfs directory
>     ionic_bus_register_driver()
>       pci_register_driver()
>         driver_register()
>           bus_add_driver()
>             priv = kzalloc(...) # OOM happened
>     # return without destroy debugfs directory
> 
> Fix by removing debugfs when ionic_bus_register_driver() returns error.
> 
> Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
> Signed-off-by: Yuan Can <yuancan@huawei.com>

Acked-by: Shannon Nelson <snelson@pensando.io>


> ---
>   drivers/net/ethernet/pensando/ionic/ionic_main.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> index 56f93b030551..5456c2b15d9b 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> @@ -687,8 +687,14 @@ int ionic_port_reset(struct ionic *ionic)
> 
>   static int __init ionic_init_module(void)
>   {
> +       int ret;
> +
>          ionic_debugfs_create();
> -       return ionic_bus_register_driver();
> +       ret = ionic_bus_register_driver();
> +       if (ret)
> +               ionic_debugfs_destroy();
> +
> +       return ret;
>   }
> 
>   static void __exit ionic_cleanup_module(void)
> --
> 2.17.1
> 
