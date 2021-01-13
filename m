Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B07C2F4B57
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbhAMMcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:32:13 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14144 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbhAMMcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:32:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffee8240000>; Wed, 13 Jan 2021 04:31:32 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Jan
 2021 12:31:31 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 13 Jan 2021 12:31:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAajb7NBrCBAG9OQNjfCIeNb328bErtqRk5vNS4qDsQXq9y+14ZwmfCyPNiHy7l3WSCGqzv7Nyv8TNcIqKBkLiTqYxL0wTQEBR7BVPmUgaYvOvxfnMKkXlX8Y5aMj23c95DBqfFGGS2gJd6T8qKZ3RlWLCKPtuFB3mgHHBhxhEuzWn1FMD4oudCq/aThdBkYDCCBYicPqxZ3YDyp/IJAvvmExL0+5FuUyG7+vD3cHki56Qf2Bo2jl3xzDL91h+SdEl9RJx5zPe7RjchpD+zp8SxJ7AYUkISSkExABJq/N+7NBQNhhZtDAPeCdD1P9cJs3w63oJCHFilM7XwM+R8TBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKrsCjGyunzwe9D9aC9OxipbEWiN3GxgGL1YdD/4WFA=;
 b=HXpLIC2+bMsvAhQGLLnGqnDA76BhqGBnIdZkYBEdJMx9LZefl9Ty6VFsxmux5PtFpJVRc/OL8CLHZ3jJ6bsmq478YELqPBl74XjdRe/BqiOQ+Z8GMF38NjbBL9n6P+GZsm8UqQw7H02VNcfe+H23BffPegOgawfNCw9zBrM5AWWkv+pyu+A4+tAyoD8d7pBM+YR5Jd4022IWIlmGPTLYLMO06+K80hki8t5rF0tgbms5mXZYbP4opH5GKmRpGZHcT/ADud8UtpwsgCvWCNX+3KergqaX1FVQ7nxwAWpf7xESIxCE7FkneSMz21StgnklK/siiCQePPpIhXwdcq+piA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB2777.namprd12.prod.outlook.com (2603:10b6:5:51::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 12:31:30 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae%5]) with mapi id 15.20.3763.010; Wed, 13 Jan 2021
 12:31:30 +0000
Subject: Re: [PATCH] net/bridge: Fix inconsistent format argument types
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>, <roopa@nvidia.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1610530584-48554-1-git-send-email-abaci-bugfix@linux.alibaba.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <f5fe3b09-44e5-939b-3969-3b9136aa4ed5@nvidia.com>
Date:   Wed, 13 Jan 2021 14:31:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <1610530584-48554-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: GV0P278CA0012.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:26::22) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.209] (213.179.129.39) by GV0P278CA0012.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:26::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 13 Jan 2021 12:31:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d48e668e-696c-4346-a2c5-08d8b7bf279f
X-MS-TrafficTypeDiagnostic: DM6PR12MB2777:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB277783489185F880F417D154DFA90@DM6PR12MB2777.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:162;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7imemNToLlD65q/VREy6gaPDPWd/hS3/ETQ6zhJ0jnNFlXAyJpoG4vClnjQfuLta3Y1/t3Aj31RMhS99maHw1nAmfeeSCwgnFML88rvXnQgo+hzXkTJ/yrnQJoE6nVEonaortBmyMaEDdquj557mh86CIpIs2q0OmzNW0UpJxnh5rII5xCSg7sn19O2W7cJz8dTdXlrVPdi0FzGCv9PiS469f2RICWvfTk5lXsT9GwSNqoNVpOs+veTqVJVeL9TlEY0lOAIo6tn5CxO+89rfFJSibSBmYSh7f2Y0UDoY+IhaHVzuGCNu32sAaSVmA+hXfV0CxlIz5wFRTOBeNhoA+HU3bB9zIDPLwuANTJIPE/XBzLQlldag2id+Cknkw3uo2pe+G/Lurt8MEL/BeTaEMEv3iCd3yGdTNzSRE/xATUiGXxem9Z8DqWZdLsC/s4Bu2CIw3usi6iputJY1SHmByyFh6/QcLm30i0g5812r6Ps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(2616005)(5660300002)(31686004)(66556008)(2906002)(66946007)(86362001)(6486002)(26005)(66476007)(6636002)(31696002)(53546011)(16576012)(4326008)(8936002)(316002)(478600001)(8676002)(956004)(83380400001)(36756003)(16526019)(6666004)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cHFKY2lsOU5ZQVV3cHlScmtFSzE5ZkFudkdSVUFiNVFIZUpRU1NZVGN6dUF0?=
 =?utf-8?B?aVU4eXNQa0tYWGNVWVg2Y1JtUW5RR0FwcWRlemJjTWt6U0wxcUF1R2VtSWh1?=
 =?utf-8?B?WWxJNDBsSUFCbktkNVhOZDZ4ek1YS3phVlJyL3VFdVl6N25HMDBCQWp4VG00?=
 =?utf-8?B?N3p5dW53TExydk0ybFlFdUM1UitqRGs3SXBlS25MTTBkTVgyUmpRWDJQWWJB?=
 =?utf-8?B?cTBjNFE5WDJ0cmVrRVB5WjBMUzVRYVU1WmtGQjNsRmxZUmhnQ3NUOXZyY09H?=
 =?utf-8?B?US8ybFNkdm5ONzJ3LzFOTDBWL3VRTzJ1bXJCQ3ZrRkc2Zkl3SmZwcnlmSE5v?=
 =?utf-8?B?aEFteHZpOC9GVG96cGFGeUQ0Ri9LLzR2MElid084UXF6NVFnQllwb2czWFI0?=
 =?utf-8?B?bW9mVXp1QmxqRkpTTGRHQStlSGlUcnBmNStVTXZjOEErUk0rdEZ2RVZEY0sz?=
 =?utf-8?B?bUN3U0RuYTA3SlRVRzNPVXQ3Z0N1NWQ0dWwzbmtEUk5rWWEvY2J0cjNoTDZG?=
 =?utf-8?B?MkxrZTBkSDhSVTlJOExTWmR6aHYzWG5RV3Vza0pmemNDeEJnUytTQ2JObFhu?=
 =?utf-8?B?TW8vSXYxM0trWWlSM2pyeWJmbnM0dGo1bVFranlmQndOTG5oakRoR2NUOHBL?=
 =?utf-8?B?ZkIzSUM2K2dVUmZyOUNjME9uM2Z2MDc0cFhRTG0vcWo5SXlIaFRMcUQxUHJM?=
 =?utf-8?B?YU9Bb0NTajRkaVBaVHZaSkdoTnQyYTdMdlZITHFGZW42VTk4ZmVZV2RJQThN?=
 =?utf-8?B?elJDejBvQTRYUEZBMmRkMk5zSkZWZXNkWlkwR2oxN0ZrUUY1ZHkwUXU0djZD?=
 =?utf-8?B?N0t0aDA0ZERsRTE3dEdaUy8rblFRVjdUUVQ2aUFpS21vdHhudDBobkorVXow?=
 =?utf-8?B?UGJTOE5mS3N4MjFKVDJ3K0J6Wkd5TlB6RzZhNWZYVGZldXdSWGFaRlhpc3ZD?=
 =?utf-8?B?a2xQY3p4R0tiR3RDdm9GSU83TGJFR3dGd3ZCLzhDdzAvUHlxajJldlYwYXU1?=
 =?utf-8?B?OTJOZDZNRXBldERadk9lM1VrNnJtSWYrOGdDa0t2SHozNUMyVFVvRC81RThB?=
 =?utf-8?B?SXF3UnlJK0lsTVdWdTN0SldjckE1bExMTXlNbXgvN3NyKzI2SThGWmgvWXVF?=
 =?utf-8?B?NjhHU096SVVnaHp4SFcxUytkbWltZ1ZvQndJMkVlZVF0TVIrNUFlblBEeDFj?=
 =?utf-8?B?Wi81djNuOUJ5M3J6STZDMXpOSFg3NG1XampSekZTclZ3dW51MEpOcC85Vjl1?=
 =?utf-8?B?V2pONFA0Tndra2dBa3JTV3JmSC8vK1RCa3R4MHRoUy9FT3RPUElRcGwrYXVE?=
 =?utf-8?Q?7MQkU+BVbMc0MmE0Y3AGrv5tTLdp2hc8C0?=
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 12:31:30.3190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-Network-Message-Id: d48e668e-696c-4346-a2c5-08d8b7bf279f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hDsQaAqP39aWe4Ntp5eMPoOqZcM4Rj60CndGiS1IHH16aGn5CNYb3EUqs5RWyWBd++qccP8QYKVV4T0p4b6V3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2777
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610541092; bh=zKrsCjGyunzwe9D9aC9OxipbEWiN3GxgGL1YdD/4WFA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=jl6S2K4iBPuVImDicHsRVEsoiA5vUptS+9xfUTc5T5oU58pKwkriovut4QE/bpSXx
         sclrd42pOmx7RbJvHXFoevvnLq4A+QnZFdfscLv8NWWt+FTv97oOIbayU/UnyYWMSJ
         hhdNAIFsPCaeKDZB5ODF9rrjrK4ZzQYudaSNlJoLTxkwVIthr7EmIsUUApdg4fbebI
         qhFHia/FmISo7FESVnNJYpt0GLOoZ1NY9zEeFsSriWmJhdUNs8ow+5IklOqCW1qB82
         29BTX4GE+p4oQpP6iIcE/pquKGziYbEfp0LhqXKYD4zaZxxPOYxsJtMCM3t8Nq8M5E
         +rz8MoCXsB7sw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/01/2021 11:36, Jiapeng Zhong wrote:
> Fix the following warnings:
> 
> net/bridge/br_sysfs_br.c(833): warning: %u in format string (no. 1)
> requires 'unsigned int' but the argument type is 'signed int'.
> net/bridge/br_sysfs_br.c(817): warning: %u in format string (no. 1)
> requires 'unsigned int' but the argument type is 'signed int'.
> net/bridge/br_sysfs_br.c(261): warning: %ld in format string (no. 1)
> requires 'long' but the argument type is 'unsigned long'.
> net/bridge/br_sysfs_br.c(253): warning: %ld in format string (no. 1)
> requires 'long' but the argument type is 'unsigned long'.
> net/bridge/br_sysfs_br.c(244): warning: %ld in format string (no. 1)
> requires 'long' but the argument type is 'unsigned long'.
> net/bridge/br_sysfs_br.c(236): warning: %ld in format string (no. 1)
> requires 'long' but the argument type is 'unsigned long'.
> 
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci Robot<abaci@linux.alibaba.com>
> ---
>  net/bridge/br_sysfs_br.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 

Hi,
You have sent 2 patches with the same subject.. Please squash them into a single
patch and target it to net-next, these don't need to be backported.

Thanks,
 Nik

> diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
> index 7db06e3..7512921 100644
> --- a/net/bridge/br_sysfs_br.c
> +++ b/net/bridge/br_sysfs_br.c
> @@ -233,7 +233,7 @@ static ssize_t hello_timer_show(struct device *d,
>  				struct device_attribute *attr, char *buf)
>  {
>  	struct net_bridge *br = to_bridge(d);
> -	return sprintf(buf, "%ld\n", br_timer_value(&br->hello_timer));
> +	return sprintf(buf, "%lu\n", br_timer_value(&br->hello_timer));
>  }
>  static DEVICE_ATTR_RO(hello_timer);
>  
> @@ -241,7 +241,7 @@ static ssize_t tcn_timer_show(struct device *d, struct device_attribute *attr,
>  			      char *buf)
>  {
>  	struct net_bridge *br = to_bridge(d);
> -	return sprintf(buf, "%ld\n", br_timer_value(&br->tcn_timer));
> +	return sprintf(buf, "%lu\n", br_timer_value(&br->tcn_timer));
>  }
>  static DEVICE_ATTR_RO(tcn_timer);
>  
> @@ -250,7 +250,7 @@ static ssize_t topology_change_timer_show(struct device *d,
>  					  char *buf)
>  {
>  	struct net_bridge *br = to_bridge(d);
> -	return sprintf(buf, "%ld\n", br_timer_value(&br->topology_change_timer));
> +	return sprintf(buf, "%lu\n", br_timer_value(&br->topology_change_timer));
>  }
>  static DEVICE_ATTR_RO(topology_change_timer);
>  
> @@ -258,7 +258,7 @@ static ssize_t gc_timer_show(struct device *d, struct device_attribute *attr,
>  			     char *buf)
>  {
>  	struct net_bridge *br = to_bridge(d);
> -	return sprintf(buf, "%ld\n", br_timer_value(&br->gc_work.timer));
> +	return sprintf(buf, "%lu\n", br_timer_value(&br->gc_work.timer));
>  }
>  static DEVICE_ATTR_RO(gc_timer);
>  
> @@ -814,7 +814,7 @@ static ssize_t vlan_stats_enabled_show(struct device *d,
>  				       char *buf)
>  {
>  	struct net_bridge *br = to_bridge(d);
> -	return sprintf(buf, "%u\n", br_opt_get(br, BROPT_VLAN_STATS_ENABLED));
> +	return sprintf(buf, "%d\n", br_opt_get(br, BROPT_VLAN_STATS_ENABLED));
>  }
>  
>  static ssize_t vlan_stats_enabled_store(struct device *d,
> @@ -830,7 +830,7 @@ static ssize_t vlan_stats_per_port_show(struct device *d,
>  					char *buf)
>  {
>  	struct net_bridge *br = to_bridge(d);
> -	return sprintf(buf, "%u\n", br_opt_get(br, BROPT_VLAN_STATS_PER_PORT));
> +	return sprintf(buf, "%d\n", br_opt_get(br, BROPT_VLAN_STATS_PER_PORT));
>  }
>  
>  static ssize_t vlan_stats_per_port_store(struct device *d,
> 

