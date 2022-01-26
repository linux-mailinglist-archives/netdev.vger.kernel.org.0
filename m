Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F25449C8BA
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 12:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240768AbiAZLf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 06:35:59 -0500
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:41697
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233650AbiAZLf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 06:35:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wn4pRxgf1F+cz6CJD7nxO512A1FZ86zbKvTBX8ROWJOl9yx/HvOpLuS8jXvSdHeFcG0wVL2jCgnXUGWz0HIz3uPaG6GzDy914lc05nRFNe1JzJCQ5ugU0BVRFCoROtxJhNFziaoBNDLHXcZ+IgHVwn7xXnCOs3DZ8rcTfQ4mNZWrA0XGnuuAyVaC6jUAzgEPQF2D/CljMW3giM226VFrE3XUt18G0XzBd3Ww5RsuF5PQGm/fQTNuh34JKdIHjw+Xe1nHOFbcz+GNlsWBR5xSbv8l3pDh8Qam0kNffekmQDk//VkVWC7GM4Zd05qrM7ntAcAcisll0wZAg+hW9/dxTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N/pY+jQUlrozoL66Txr1wrTzH2sySTpG14jryVKNsLw=;
 b=WzUGwRnXIuqD6fPIItiScEMJd7mwJyuDCbZYGfI97nHI3bK7Gf5G+7cccvpJyMeTGphZJCqA9FPk2XRtU4nIYOR7pQMi3AOBkkn0WS+S9GIHJG/nurpM3etNOw/x5w0R9mZvsjcA9KehUzVN91p0ALwTSQ6ih1yKWWI1aAR8cZwCE54m7Fd0OWP1NDne/pIq1KdaMMo9sPqklt+RYIm0sEMc0CRCCTAHOJ140JgSnwqEH28zoVqyiy1lbyAtli2hTFf95mPSAR/dPeVjWVnhy4HpZShcTjngwfR9bdvWFgu30x43PDxx2fEcnidLEySVUK2UpPTi8JP2kHHZxAlsdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/pY+jQUlrozoL66Txr1wrTzH2sySTpG14jryVKNsLw=;
 b=iY65oeubq/D3hwFM/dtn+La9NxczibI+jG53wl/ho2vxZ28VN098DMFr0fbUT4u9HNYsoUlnFLid4Uww0HKZcHS7CDhQ5gORSehjCsvY2FJt5elFqvVKZ9cxKibwvjMv8hQ1XvmKVT8LagP46qNR6Pw+Y/FyZGXJrVv6gimZ4CsVeqqpNcftW1STgGPuE4qbDfknkzUmiwJ3i5xkDKEpDi44pj84nzVjNVa9m6E7CCM4WGadTbOFdpsaLQieJirTEWoyZa+eVhBQ/qfrBqA6IIdPzdfGg9kefKuW08xt4PmNWUDC6dVvSljJ/9xbi51k9aaa2HndajR308pwUqDNeg==
Received: from DM6PR02CA0110.namprd02.prod.outlook.com (2603:10b6:5:1b4::12)
 by MW4PR12MB5626.namprd12.prod.outlook.com (2603:10b6:303:169::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.14; Wed, 26 Jan
 2022 11:35:56 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::ec) by DM6PR02CA0110.outlook.office365.com
 (2603:10b6:5:1b4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10 via Frontend
 Transport; Wed, 26 Jan 2022 11:35:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Wed, 26 Jan 2022 11:35:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 26 Jan
 2022 11:35:55 +0000
Received: from [172.27.15.168] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 26 Jan 2022
 03:35:50 -0800
Message-ID: <bc3403db-4380-9d84-b507-babdeb929664@nvidia.com>
Date:   Wed, 26 Jan 2022 13:35:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH RFC net-next 3/5] bonding: add ip6_addr for bond_opt_value
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, <netdev@vger.kernel.org>
CC:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>
References: <20220126073521.1313870-1-liuhangbin@gmail.com>
 <20220126073521.1313870-4-liuhangbin@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220126073521.1313870-4-liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail201.nvidia.com (10.126.190.180) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2d68b07-8176-4ad7-9145-08d9e0c00444
X-MS-TrafficTypeDiagnostic: MW4PR12MB5626:EE_
X-Microsoft-Antispam-PRVS: <MW4PR12MB562648BC244A1C7CF4005835DF209@MW4PR12MB5626.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cLA7dLu2l0Fg85+Kcu4mn0Zg4HB5HTzPDAz+oQMrNllYgSbTjif53QLLpxymTvAyXgoNUb2VW5uT6/AA18/l3FxUiM5xGiy5HxV8fSVig8cWva8dNnpKG4VTbpprPZDsB/zF/cqClLBT2VYCtv0Ao+NDA1cDvEU1INdt4uAOiUZxQO4HybheP3CTlstTjcmbJZ6Uf1PsYVqinveaaCHO7r+Kb6oyHM9wae9jtq+Ux5UWq43MtuHxAJVUHWGMIJbHechx3pBU9Ov+gjjXQTmV/ofFmHhtPH+JkpU9C3M4LD1CHdhY/SEzuPPGtCQNEPgB7QBWXtEk2Ytk+rWGsyrMaa1+zmbAx13wn5APoMQUF3DEGaUWmgznpGYDd7g/fXIe0qBSSiGW/pra52i7xjYFofSuReIyujHeuPzssS0xizyazR1LSYoJG8PGkqqIVBC/+2B8jOc4P3jCLKpjIMkup7VM/r0YmHi4jB43NJJtaQvb0JARZrxQzN+bVfsWKx2FsYF0jJYW1FSBuFu2OCWFjlXkB5KiWm7YAWoLElLuu79qU40lWiuF2vSJCyI6MZOvOQOW62zgxSK9FdDoTnaOFE+RvMUQA8JOW1eixOcCz+i/slGvkNPgB6HCnKJJOr6zm1Kocgej08e9vT/8TABYX4hIQ9UsSwzh0PMtn1TaVBqLbXw7GVtWs7jg0oy71tX1PlVTFw8Y1tAn/1dhfx0KtkWOfWeyp6w7e6lNYv8G0xSoKKfdsDZtyuW+2oAn8Lys7Lm+ugpuvBWJX1eHwoKnEh4zqVjKj2qou2dXynsZbq5iUQPtysZm2yXVAsj3abiy272UZgP9FBoAWrVXziawyg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700004)(36840700001)(86362001)(110136005)(2616005)(82310400004)(16576012)(16526019)(47076005)(8676002)(508600001)(186003)(5660300002)(316002)(70206006)(70586007)(81166007)(8936002)(336012)(36756003)(36860700001)(2906002)(356005)(4326008)(83380400001)(6666004)(53546011)(26005)(31686004)(54906003)(426003)(31696002)(40460700003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 11:35:55.8331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d68b07-8176-4ad7-9145-08d9e0c00444
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5626
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2022 09:35, Hangbin Liu wrote:
> Adding a new field ip6_addr for bond_opt_value so we can get
> IPv6 address in future.
> 
> Also change the checking logic of __bond_opt_init(). Set string
> or addr when there is, otherwise set the value.
> 
> Is there a need to update bond_opt_parse() for IPv6 address? I think the
> checking in patch 05 should be enough.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/net/bond_options.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/bond_options.h b/include/net/bond_options.h
> index dd75c071f67e..a9e68e88ff73 100644
> --- a/include/net/bond_options.h
> +++ b/include/net/bond_options.h
> @@ -79,6 +79,7 @@ struct bond_opt_value {
>  	char *string;
>  	u64 value;
>  	u32 flags;
> +	struct in6_addr ip6_addr;
>  };
>  
>  struct bonding;
> @@ -118,17 +119,20 @@ const struct bond_opt_value *bond_opt_get_val(unsigned int option, u64 val);
>   * When value is ULLONG_MAX then string will be used.
>   */
>  static inline void __bond_opt_init(struct bond_opt_value *optval,
> -				   char *string, u64 value)
> +				   char *string, u64 value, struct in6_addr *addr)
>  {
>  	memset(optval, 0, sizeof(*optval));
>  	optval->value = ULLONG_MAX;
> -	if (value == ULLONG_MAX)
> +	if (string)
>  		optval->string = string;
> +	else if (addr)
> +		optval->ip6_addr = *addr;
>  	else
>  		optval->value = value;
>  }
> -#define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value)
> -#define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX)
> +#define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value, NULL)
> +#define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX, NULL)
> +#define bond_opt_initaddr(optval, addr) __bond_opt_init(optval, NULL, ULLONG_MAX, addr)
>  
>  void bond_option_arp_ip_targets_clear(struct bonding *bond);
>  

Please don't add arbitrary fields to struct bond_opt_value. As the comment above it states:
/* This structure is used for storing option values and for passing option
 * values when changing an option. The logic when used as an arg is as follows:
 * - if string != NULL -> parse it, if the opt is RAW type then return it, else
 *   return the parse result
 * - if string == NULL -> parse value
 */

You can use an anonymous union to extend value's size and use the extra room for storage
only, that should keep most of the current logic intact.

Thanks,
 Nik


