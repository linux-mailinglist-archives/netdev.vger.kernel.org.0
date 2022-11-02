Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94381616718
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiKBQHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiKBQHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:07:41 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CCF2C11D;
        Wed,  2 Nov 2022 09:07:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bem749Doo2PspjewfPSjUqaFxZucYr99Tbh5dey6DkgCMAe3RKVGE5cocwJ1/Qbf5AeH9eX5hnRrNJ0URuxkk3eDgnofN3JaVTZOsITTBd2V31uFzVUJAfdcQ8Whj0LiC7Vk3UCP8y4N+A0dPrU4tnfjrZQ8jX7W8AWgh9MYXRlG3d4dCWIqExk2/qAGoVzlL8//lF2ObGCcN8RccFLvFY9g5BNdRoihC4iVDK77RBII7s/4E0QZZoJlP6bsrO5CIEU2dueS7LSJXWcUemQw//1GlRn/2Ddr1rGfixEDRaUOc3Vj24TFkayynv2aDxi9D7BhV9FUQeFuZu6q8EIyUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4hv6wzZf6gzZKh07z0q40mh8/pQOq3J+cU8J6NWKbQ=;
 b=oMeeN68kYCWoptyafXKEmHfTg6kVuWkWnRNpq0q/MfJLMGvvpNewPYjclFPXttye4GzZ8nHKL6GuiiK79+s0/3DhlTnjmiCsJ+7Up1UG/BufszUrya6Ht2uKX1cnEpPF4FgSF+/lYEFgHc7L5VhwPgW4f7zR9or0X5A/zPNAafC2D0Y4w6aIpUuDurQlTzaFeVu8aDjbdH5PPhvWcHjvPnc8Z/9xeMnJHEfq8fj53GSsXXsMaZMsbpxHL7v6T00y7KpaTRC3hJTRz7vckUfxuzGZtLPqfi6t2GsXGX+n4Vvl+AJXzRQENMo6nQw8Y7KbowXVHOHIHwYWWr9ZsskcgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4hv6wzZf6gzZKh07z0q40mh8/pQOq3J+cU8J6NWKbQ=;
 b=GOdMYieOloicPaK/WCIWDko11vyDs2mnQEDqrPiJ51eZk69IY9eYwR+xxJ05MBkhJLmccKOl3C5wbtSsLGiFnU23eFzLZ0U5LAOHyvmpjsKNy34T4UTJaTc0fK+kTTmZcfHqnI8mPQMB1kQ0zYpPr7AK9YRgIx7ZFkRNo+GCQio=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH0PR12MB5467.namprd12.prod.outlook.com (2603:10b6:510:e6::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.19; Wed, 2 Nov 2022 16:07:37 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::442d:d0fb:eba1:1bd7]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::442d:d0fb:eba1:1bd7%9]) with mapi id 15.20.5769.019; Wed, 2 Nov 2022
 16:07:37 +0000
Message-ID: <17ef4641-7cb3-fea8-4b1a-30b90c1719a1@amd.com>
Date:   Wed, 2 Nov 2022 09:07:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH linux-next] ionic: remove redundant ret variable
Content-Language: en-US
To:     zhang.songyi@zte.com.cn, snelson@pensando.io
Cc:     drivers@pensando.io, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, brett@pensando.io,
        mohamed@pensando.io, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiang.xuexin@zte.com.cn,
        xue.zhihong@zte.com.cn
References: <202211022148203360503@zte.com.cn>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <202211022148203360503@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0015.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::28) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH0PR12MB5467:EE_
X-MS-Office365-Filtering-Correlation-Id: e4f516cf-b3c0-4fcc-5ba7-08dabcec5c58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iH60uv/E6ZF022+um1lHYcAeyFndtlKuNgwoC3rzfTQkv8LQxbY761VlBF7UWVx9qKcSD7VlrddzQ1rFcmkIU4VIEHQbom+FANyf3ypVWj/QM2wMqQdx5Qe6sbfc4m/qyx1ZKqB0ajAex5zax3K1nr1T2fIFKMiyYtzyX6T+YmQC0jlN06ZWcSWKhpiwf0Kk7F4aZ+cpz5HTsKC9MZAoZyHbc/4Aq8QoxgOCCDGH+ly6lad/Kk4709t1K9i9ET+IfI84Cr88QQpZF0hi7vOq9fh9i94YWOIm31MSdp3Bxh3MsuYFocwT7d/Q8BshUSd3YqGdiUvm2izzAs2FpLiv3XY4eoAuS9xguNIfpmTBWGoMBjWnGmrO7JbRRzA+HltC8KT/hE3fJMvPHw+ekYhxmReedPkcDw9lmN2naiL5BqZt0ocXu7ZscNO8q2hFqfkS+LYl6fPzvL7exvrsJJLubY7qMiMTejzSC2FbYxrqVb/LwiW2Hkw5wXT06wdOq5HxhpGREOagyHCaDTpmzUvrFu9b/6Ue8VwN3iEB4YBk4PeBHfXucSzxwx9q6WpzTriSxpPM/h7m+IuWnonGBmd0DsvFfa3fbNWMxiX6JZMYs2YFKPh32FdGI2oURgAvt/7atjvEHHNIlsUADb7Q+EiN88lwaB+p8jddiXer0UgTeDqvHp8s6U2PSfBGI4Ln7PWG7uNLVl4jT+J96aYO2mgOs+JcO3UreHFG0lm3LGWYKL3xRipyJtH0OGzzwFQVRql1p3qqEvetszteHxAxaAGy5LPYlVkdTc8OzDvfACDMDWg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199015)(31686004)(83380400001)(31696002)(6486002)(6666004)(66946007)(2906002)(8676002)(36756003)(38100700002)(6512007)(26005)(2616005)(186003)(53546011)(66476007)(66556008)(4326008)(478600001)(316002)(8936002)(41300700001)(7416002)(6506007)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkVkZHE4VllhdlVBRlYzeDFvZkFJaVhoQVc3OVJaczFEaHRObmNONTBKK1p0?=
 =?utf-8?B?alZzeWRHUUtJRmkrS2x3eTNscGlDQkxxZzNkQXBlUHNsTGd5L2ErRlpwY25N?=
 =?utf-8?B?RklYWHhaNHNzQnJZNVpNKzVCUkc2U2RtRHpML2pqdkpyZytiVnpTMGc2cFdv?=
 =?utf-8?B?TEFFQi8zWnd4Z0lQUUt2SXkzaFNZcGhWVnA5ZVFsL2hqendMaWRKOVI5SFdS?=
 =?utf-8?B?SjVvQjNQMnFBWUxyeWpIN0J4em5TcmdyT3YrbVBoQjMxT3dWUVZaRWM2T21z?=
 =?utf-8?B?QmVOWVN5enZSUjdjaXErTzRyak9ZV1F3L2ZGS2JSSURqVGFMM1o3OGNzNzNZ?=
 =?utf-8?B?MkxiRmRRMDVEMnVEc1hwMXhUQkZiclRja1NsQStERHU2TFBaN1piYUtPNERy?=
 =?utf-8?B?aSsvSnNXYWUrdmdzK2N5UldDeEt4MWJtWEZSclNvRGE0dld5KzJtaVlRUUYz?=
 =?utf-8?B?LzlYei8yQzF4VXlJMTgvcnBTeHlGQVR6a01TcWlMU1VNcWJNYmEyUU5hTFc4?=
 =?utf-8?B?b2gvZzlLcmY1RWdtUGdLaXREdHlVaU5TOFdwMXNMb0Z0d2U1bE9xVnZuYzlw?=
 =?utf-8?B?Q29MaE1LdXBjQ3pQR0hHTHZXYm1xdnJGSUtjWVdyN09tYnNBVmJ2cUgyRlp0?=
 =?utf-8?B?NFNYVFhDeUJvbkNWdzlMT0JkeWFYUk5OOXQwTUN0OWViY01laHlreU9zb1Vy?=
 =?utf-8?B?eWFJYTNZQUxzOGFKVzhvTGlKL0ZoZ3ZzTjcxaE4xaFhWVkVyWXliV28wbHo0?=
 =?utf-8?B?MElBSDZvbkI2anZSc2t1dGRHTy8vd0ZzQWJTa3QzdUF5M1o0L1NEbDZpS3Jx?=
 =?utf-8?B?UXN2RUw0cTROZjdvUGRvUjFDYWJEOHNrbS9Pb1RyZ0k1K1FCUnNwMEk1blVJ?=
 =?utf-8?B?TTJsT0hHVklpVUZUWkFoRXNlSGoyb3JDKytMYjQ0NUVkMzhJVUJtenZXbEU1?=
 =?utf-8?B?K0ZnNCtvNFNzWEhUUU5QQjE0Nld3N1VPNFlJZmszUFFVWVAyZlFYd21PT0hs?=
 =?utf-8?B?S091bmRSMS9sdGtCbFFsdnZGcEVFUWpnRktRMkRLVHpFOVkrWWJOdDluM3JW?=
 =?utf-8?B?N1FrakFVejR3SmdGb01xeVdrREE3aXQ1a2ZIc2J1S1VSSk9tTWhOOWZ3SW84?=
 =?utf-8?B?N0E3d0NGdmhrSkZYcXM5SmlVc1EwWEMrOGt2R3Nzaktub3FZYlMwb01PWW04?=
 =?utf-8?B?clllU1RnOWFOWkNiWm9XQm9ISGNxTURKNG9NYTdaSjd4SU0vRDBIZXFJSnQx?=
 =?utf-8?B?MVZEYVlqTWFzNjVkdDJiUlpYVHVGdUs1cVB4M3VYQVZlazNTMVZHVkJpdTFF?=
 =?utf-8?B?Q0JVTGJPblJVMk1Ka25nUXNuMUUzeGtEaG54WDlhMjZWTFpuMUVLUG4wak8z?=
 =?utf-8?B?SEV2NzIvK0FpTGtHdzlYVklXOHZDUWoyWG44L1E0Z1Vma0Rrcy9SaHd1OG1s?=
 =?utf-8?B?ZmxYaXUzeWdXczlick9CcG1TcmNZUm5FWEY3YTlzZWdhUkw2QkFDcUlDYVo4?=
 =?utf-8?B?bnRSMWFRQlMvc2dCd3huMnczZCtjeXBGTThWaUhOSHVCQTBKQ3N5YUVUcFly?=
 =?utf-8?B?VVIwK1pHWHA5c3Jpc2JOODUwRTB2bEQ5VndBeDVpQVFLVkRvMCtoWlhGM3Y5?=
 =?utf-8?B?L0piNlgrSG1SV3NmTVduNjgraHZTL0E2VUtlUjdYTWIreHFMYzE2RmlmUHAw?=
 =?utf-8?B?SXVqQWFzS2FSdi82d0xNRnNqYVdBRGNuYWI3c1hPOS90dy93TUEwdDlLb1FQ?=
 =?utf-8?B?UHN4dGkzbzgvaGlsTDhSRTNNcURSc0pvUFpzczQxU2hyYjdIOGx5ZzFybzk4?=
 =?utf-8?B?RUsxSkorR2hYUW52UVZ4b0pGVWpBMGRuODlyOU1JUEdjME9nUE5WTVNTSWYy?=
 =?utf-8?B?UG5RNUE4REhtQ0Q1S1pabndwWGlXK0h0N3JsdFo1aFY1RURrazJueDZnSEVu?=
 =?utf-8?B?MitjMERKbTU1cWJybEVCYmRKaDZXUWtSWEF2RUV3UVJ3OWdrMkVRU0IwWWlq?=
 =?utf-8?B?Rmp4R2RrM2ZRMVhaRWJKN1hGSVhJbHl5Z1RNRU9menN3RitxYmZybmhKQ1p6?=
 =?utf-8?B?VDhJbG56anpLSmxOakxuSTNmbVNrdXVTK2dnR0NFK2cwRExlSm9abUNjcGFB?=
 =?utf-8?Q?vG3vEbMSq6+ExlRB2Bv2Zyjnk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4f516cf-b3c0-4fcc-5ba7-08dabcec5c58
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 16:07:37.6131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LsKM/NIq4P8IehHJ0cF7RISZVJba3A/6CD089XC3iuh41Bp0Lf7qRkJlrpye4xNRDY4rNN3akqTJnMOn58lpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5467
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/22 6:48 AM, zhang.songyi@zte.com.cn wrote:
>  From 06579895d9e3f6441fa30d52e3b585b2015c7e2e Mon Sep 17 00:00:00 2001
> From: zhang songyi <zhang.songyi@zte.com.cn>
> Date: Wed, 2 Nov 2022 20:57:40 +0800
> Subject: [PATCH linux-next] ionic: remove redundant ret variable
> 
> Return value from ionic_set_features() directly instead of taking this in
> another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>

Acked-by: Shannon Nelson <snelson@pensando.io>

... although these changes usually go through the net or net-next trees.
sln



> ---
>   drivers/net/ethernet/pensando/ionic/ionic_lif.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 4dd16c487f2b..a68d748502fd 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -1557,14 +1557,11 @@ static int ionic_set_features(struct net_device *netdev,
>                    netdev_features_t features)
>   {
>      struct ionic_lif *lif = netdev_priv(netdev);
> -   int err;
> 
>      netdev_dbg(netdev, "%s: lif->features=0x%08llx new_features=0x%08llx\n",
>             __func__, (u64)lif->netdev->features, (u64)features);
> 
> -   err = ionic_set_nic_features(lif, features);
> -
> -   return err;
> +   return ionic_set_nic_features(lif, features);
>   }
> 
>   static int ionic_set_attr_mac(struct ionic_lif *lif, u8 *mac)
> --
> 2.15.2
