Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885B0345C0A
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 11:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhCWKhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 06:37:25 -0400
Received: from mail-eopbgr770081.outbound.protection.outlook.com ([40.107.77.81]:24494
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229995AbhCWKgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 06:36:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGKZLJesFZpi6rHmFc+WJP4zMrJiwlAvXxqjyxzByKjrYonl7ubrNs80wP8awdqwP13Lm0bg6bJPMdq/BVvvznj66u+kxDVWhS7AuxLPREsSQzr48VKWSweZA39XmgzDNiB5RxcdCfD9cIp67vctNfkQ48SsfS1y1RKUb3omNLuER7oizVBZHNpCcCgUcn6Z56Lbu+LpW3CX7MArJYHSdRmRFJLvkdQjZiwyYGYuBXGQtQydzmiauUr/TjaVc7z9cVy4kbFagXaLb1s8EfU+f+4XRqJyk6ssJ9U7qpuCc8RGATRKjDvCXewhBn3ja4JrEw3A1dASG7VCuRDzAtWfYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGB7Uq0gyxUMg7Q923dHuH/7gYFDUk7kbaKzPN5Rz78=;
 b=HCKRcq+sdbmYdZhBoI4SUVPw1k2cEdt20e7WVL8X4kouvvYvQuhkbKDrWKFcT5nlm8fEcU+qti9OKT6GGmhnVxV1/xIIh9IGtOBn3KZWLtXYSUCP7R72I962gXpGJ1VnQ7/o+7iLLSd9jOR6zek1ghjXCDX+yTNssoF3/BAgdovyh1yqxGNL4OV4tclGa9illaJpMzI0rVzzBrzQXIO3rJT4HckYuxVPPXpZQWmirhOH8Ok0UHv34+1Q5jaSMUA4j20+oPyjHBANSiKzKncdn09xg3Lt3c8pAoclFEtCyqx86P44pEwdVQUycIlrx3Pvc0sbsdUIXx90A5FLLkD6yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGB7Uq0gyxUMg7Q923dHuH/7gYFDUk7kbaKzPN5Rz78=;
 b=UBaymoXLTjt8/qZL5qi0s0bqLf9J6eDXHE264SN1eDQ8q/Fr6op7K4qk+8UyXBnLfvsL3YWw8FI4MRaYMuYnwskIA5davQwTIVHAKbffUvGPd8neMDf4MJIJ0C4tTtuZTbSMs6spJ0QHVmWoHPewFWPYxoNgj+/kmGMwnE5qh8N7do8sZKK0b9HS0njTed2cTY/hWs9AOWeqOMzpIszq+7ZkSqzcDBdckO/Gn2d9uuucR5WTAd2WLK0FVPaD6/vcFA073YfkiNMEFF43+Gn9n/NP38Ie/R+Qru5izvxjcWWw6v8P51SOskSCKryDnhSjzhIVAJLlqQZnZOXAR5UGrQ==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3626.namprd12.prod.outlook.com (2603:10b6:5:11f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 10:36:50 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 10:36:50 +0000
Subject: Re: [PATCH v4 net-next 02/11] net: bridge: add helper to retrieve the
 current ageing time
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210322235152.268695-1-olteanv@gmail.com>
 <20210322235152.268695-3-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <dd70d71f-d7ff-8788-a886-185e0c71644a@nvidia.com>
Date:   Tue, 23 Mar 2021 12:36:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210322235152.268695-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0135.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::14) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.137] (213.179.129.39) by ZR0P278CA0135.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 10:36:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e749c38c-2707-4a45-90ab-08d8ede7912e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3626:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB362668B012964A67401154D1DF649@DM6PR12MB3626.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sOTkhqrSia+ZNt8vxYKb58FTPHzLS6OTsZguCiu0jfIOT7QP9sq8ypLEufl7G44fAFyeUPkPRAAjCHLNdYurrbfLsehs2K3OrtTxTMzQrIfAG2T1IVURsq652sD2Eg5ZNTTh6EKhB/0g1aXd+nyFQFPrFwz4rFQepwB7iqy/P1F5WBpcaavfFthv+t28XMRYFfsEkUqj3WXKlx1YYdPUbwQL+srjtVADR+o38C6wTGVPdcGI1oYKXs+GLsyG7oa9pS1RaiDarOxo+0EoZSYFGAOneGcPCYytZMHAjGJpM9SYQLrxJewHrHxvDqE0iKF4plWf0TMNt0xwcjJuaqf0LNlbiBCUe4f6jle8/x7D/2Nq/f96r3dPr9tW52iM+5EhrK85Iq2m5vkd8DKl5l1DFGDoGQTP7bWzWI9o19OHrvMxVpAKDQKbKzIrWnOCMIGS9ZUHG2G6q2Tkexx5LsHDQtSjQ2Fx3MLS7rEwjHh7kZEoNd9YHfO5UVRgFdIaM1DfJ1CsFWKjOn5FMVmE2NWr8cUfA45OVmRWfSYWcg9cFb7hsfCXlA+lf3+zk8CMI4UGxQLo+hDLEpjjaPpFyxCp2NaH8kWp9IK1t6L6W5paixIMWzPashtIVrmFJRd00CYq2aV0vwCMhrQWObyTIRj6XO0SWoyBZvO+qo/TrYHUZAQJlozAfLIaE6IaX6rh4YcS/x3CqICury5LTPbnoppostFxDNgnP3wgEjBtrb786Ug=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(83380400001)(478600001)(53546011)(4326008)(31696002)(16576012)(66946007)(6486002)(2906002)(2616005)(110136005)(66476007)(316002)(86362001)(66556008)(16526019)(8936002)(54906003)(26005)(186003)(5660300002)(8676002)(38100700001)(31686004)(956004)(36756003)(7416002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QjU1T1lnSjcvWnpEV2ZXcXowbXhBRHI2dEZRcVo3S0dYRGRWNjJUN3JLSnJ0?=
 =?utf-8?B?TWY0VFkvWE9XOXNDeEJIR3NxM3BndHpDVVREcjJKS2FZN0JZejZvUURZMG8w?=
 =?utf-8?B?ZXhBRWt4YllWSmtVS3dFWWlYRUs5bXJGeFhnY24wMTM0WFBzMExncHZZV05T?=
 =?utf-8?B?cEd4RDhoWjRlbUhwTHhZeUF6UTltRUs1M29UaHBYeDRLVkRXUFZUcDdLMW9y?=
 =?utf-8?B?aFplK0k5aVIzV05EaGhLR0djcm1rRUlWbEk5NHAyRS9sMGkyd00zcmpUWEhh?=
 =?utf-8?B?VGJZUHdtOTU4SEJFdWVaOGUyYjhOOVl6bzFjRFdiUWhrRTMvMVhtMmJ1OHF1?=
 =?utf-8?B?Z2pFbjBoWkZEZkJlelBlNmlGQWY2VGlhcVlaNTFGczFWaUt4Zm51WXVwdXR3?=
 =?utf-8?B?VnFZQXVBeDZ1NStpekhuNEs3bU5oSUZvaVRnVUJ1a2psZnRNRmtHMWFSSXI3?=
 =?utf-8?B?S2pjZVNNUGV3ZGdEa3BjQjBaRWwxb205UzU4aGpuNEFYcUlWMnBrY0l5MXJj?=
 =?utf-8?B?SzNVaWx0WG5ud0dYUmFUbDRrMVUwZlZ1MUFUVUliVGp6Tng5aG5OOFhqRnVz?=
 =?utf-8?B?NVBsYjJLVXJNSXp4Vmd6V0xZR3d1RkNxWlZ3S3o2a2ZuNk5vWFlheGNxV0NM?=
 =?utf-8?B?Snc1ejcxamkvVHU3Y1NXTG9SekxoU3pRNXZNZkx6SDQ4Mkx4M1VkVlBsMFYx?=
 =?utf-8?B?OVhTUm15T3pPSUQveHgxeWF6eVpHSnMyOVJLbVJ4a0I3UjhRMEtyL21MMzNX?=
 =?utf-8?B?bTQ2Y2ZnN2FTT1QrbjdFSDdUUW9Fdk5reERubDllWStML2ZKYzdqZmZSRzlw?=
 =?utf-8?B?WVFKamxWb25HV1QrMHRkODNSdkVUUXpFbnFWUTkweTRMZ0REekRyWDZwWHZ0?=
 =?utf-8?B?ZVV4V3dPdno5ZnlxYkN6UWhxamNrYlorWDZISDlsaWxjSG8rYnMrb01vTXQ2?=
 =?utf-8?B?VXRiUk5aVU0zZ0ZHckZ3b3ErY2ViMlh4VFpveWJHbjZISVZhaWJiTjg3eEQv?=
 =?utf-8?B?bXRFVm5helpXeWZ5cWpFKzFUalNvN0FBSXkxWUQwMCtTRG9NNjFWSStHSjNN?=
 =?utf-8?B?L1RrTmtiempwcDAvbWw4VVBoNUM1NVZCMG03czJQZGVhNmxuSm1ydTdpcGRV?=
 =?utf-8?B?RkR5VHloRXhPaWVKR3RrRkZqb1hRNlRtOWliVTExeDVpcnh6d0NtZVF6cGZL?=
 =?utf-8?B?VFdqRVZQaTNUU2tMemxSTmo1dzRyay96SDhkSFgxeENZc1hlTlRjODJRUUpC?=
 =?utf-8?B?OFVnaXl3dlo4dTQ0aUNmZ2ZENDRuUGtUMEZ5clJaRDAwMlRaZWdET0luZ3li?=
 =?utf-8?B?djYrUWl5SVhabUdRb1pML2RlVjBXMzU1YTAwQmxXS25kTXdscTBwR2tnR21m?=
 =?utf-8?B?WWZ6UVFleWpKNXJHbkljdWNGNkJjbHBLMUlNWnhqaFY5S0Z0Y292YVlkTVAx?=
 =?utf-8?B?Q2xQRmtSdlpoYWYvdFRYN3ZvWUJONjRNWHpLazBPTDR3NWgzL010dEl3eFNO?=
 =?utf-8?B?NHByL2JQbGlOKy9ZZUNyTTRkbkYycmtmZkZGc2ZJbU0xWHVZRFg5R0hSdXpO?=
 =?utf-8?B?Wit1ZkNXNzZOOXJRTFRVMVJmaFMxNzdRNHJwNGxKTlZhMElibUVsQjVnNEc5?=
 =?utf-8?B?TGJ0S3RvaTdBT0YxNnpWVmhpRGF6UFVRZ01sOS83Z3hhVTA3ZjhkZFR3UENy?=
 =?utf-8?B?ZnB3MElha3BvVjlWQ2tXUE5XSGVrZmM1NllKemJtVUI1ckp5MTRmOUpseDVq?=
 =?utf-8?Q?GpsNCRFvFMR9VdB8bgIN6c4sUPlGm0zfoPk3r+F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e749c38c-2707-4a45-90ab-08d8ede7912e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 10:36:50.3315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ouWfaceIfSF6dhQrpCDuZb7ipl+3yGQy87YzO2ZrCnUOV8DvOaXPRnioIn/4lbL2eV3QylP5bZfyRnCOjcxug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3626
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/03/2021 01:51, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME attribute is only emitted from:
> 
> sysfs/ioctl/netlink
> -> br_set_ageing_time
>    -> __set_ageing_time
> 
> therefore not at bridge port creation time, so:
> (a) switchdev drivers have to hardcode the initial value for the address
>     ageing time, because they didn't get any notification
> (b) that hardcoded value can be out of sync, if the user changes the
>     ageing time before enslaving the port to the bridge
> 
> We need a helper in the bridge, such that switchdev drivers can query
> the current value of the bridge ageing time when they start offloading
> it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/linux/if_bridge.h |  6 ++++++
>  net/bridge/br_stp.c       | 13 +++++++++++++
>  2 files changed, 19 insertions(+)
> 

The patch is mostly fine, there are a few minor nits (const qualifiers). If there
is another version of the patch-set please add them, either way:

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 920d3a02cc68..ebd16495459c 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -137,6 +137,7 @@ struct net_device *br_fdb_find_port(const struct net_device *br_dev,
>  void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
>  bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
>  u8 br_port_get_stp_state(const struct net_device *dev);
> +clock_t br_get_ageing_time(struct net_device *br_dev);
>  #else
>  static inline struct net_device *
>  br_fdb_find_port(const struct net_device *br_dev,
> @@ -160,6 +161,11 @@ static inline u8 br_port_get_stp_state(const struct net_device *dev)
>  {
>  	return BR_STATE_DISABLED;
>  }
> +
> +static inline clock_t br_get_ageing_time(struct net_device *br_dev)

const

> +{
> +	return 0;
> +}
>  #endif
>  
>  #endif
> diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
> index 86b5e05d3f21..3dafb6143cff 100644
> --- a/net/bridge/br_stp.c
> +++ b/net/bridge/br_stp.c
> @@ -639,6 +639,19 @@ int br_set_ageing_time(struct net_bridge *br, clock_t ageing_time)
>  	return 0;
>  }
>  
> +clock_t br_get_ageing_time(struct net_device *br_dev)

const

> +{
> +	struct net_bridge *br;

const

> +
> +	if (!netif_is_bridge_master(br_dev))
> +		return 0;
> +
> +	br = netdev_priv(br_dev);
> +
> +	return jiffies_to_clock_t(br->ageing_time);
> +}
> +EXPORT_SYMBOL_GPL(br_get_ageing_time);
> +
>  /* called under bridge lock */
>  void __br_set_topology_change(struct net_bridge *br, unsigned char val)
>  {
> 

