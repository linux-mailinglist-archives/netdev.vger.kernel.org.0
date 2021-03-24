Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D7B34754D
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 11:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbhCXKGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 06:06:47 -0400
Received: from mail-dm6nam10on2069.outbound.protection.outlook.com ([40.107.93.69]:16609
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233306AbhCXKGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 06:06:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nab/F0c/GhVOYBcAdQRjZztrulDvJONAnZ4kPhVesvk/msBjWF1iCItn4Aocdzrr5qd7tbrPDflJ4J4WTskq2BH0aWpUrEgnM/JNoLHwcZroPlr2UEPIDB0pB1i2Uujl0X21hc9OWOs3vhQKv3xomikFOc/usGQkVTWVLg+a3ChW3KOt8k0xaehZenjABFZDga9jIuAj30CwXkTWGUO07VlyFcCPxszRZokGFB3XxEqVNEt73IOyAvRQivLqQBjPY8EOchzl1nbh6iX06U6TJGkems3UxpNBdacuXt+R8xoOILVNkYi72sT/aGSDoaLennArs4fI7OaJW2JNm9bcfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uT9CppYowpgznzNy5ApUydtdN62NBj0IiV9Bo87z0AM=;
 b=YYZ9cU2h4Bi/CnBm7NQFSW01gT+GFzffQLRgL2b7OkapSHvHzByXQmu+xGZ+kxqhT6aY6NHNXGp7/F1KeWC6LCrWNrqrpFVw7IeOhBxUUh5FRzFQIaty7PNTLhGxy+L6ddvHG0SvYQx1PLwOND8BoSn1wjCQvMUou5qqTk/Dm+33JzRvX9vTz/rMh9cWwvycN3XwmkOUVvcdC4FIk+MmKBgXLBqNx9yo6GzSe/7vqCj3KKNkS9+VkG/8zcNHs6zWb3jaggWc3MoGetIO7hSWzlYudiuPF4twf5OJCYBKqCE0GyaohTE4RkLxS0T3KgdwiMyaXjNjio7inZx5jdqp2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uT9CppYowpgznzNy5ApUydtdN62NBj0IiV9Bo87z0AM=;
 b=Z1N975prqE6k3Iljw3UVlKxbsqfHgCzU6bu3cIvx9iD8e+ktoG0xsVLCSB3wctRQ+vacuVgZoK8+mEclhioOmfj60xOG9ND9CIcmDHCUsWRZ+KTqFmryERuS8aXbJ/8aAdbDj94tq6LscdCB/EQe0rxzHm9y5tZCfOEyvaNL8GV3pEZyQjuCVpHTKkGl2lk+cFswjIVw+k8aC89yUiRI10cDvhVqFkO0ejfZAM/AA6MIUYCXUTh3uMc6rmrfJISElXcgFV5YAFAWOvusznPR8S9G/s2huyekH8/vZh+8J0GDTNG0usxAsIVYJYdw3//ehT3G9P77aqzUnL2vFl1QwA==
Received: from BN6PR14CA0025.namprd14.prod.outlook.com (2603:10b6:404:13f::11)
 by BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 10:06:05 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13f:cafe::68) by BN6PR14CA0025.outlook.office365.com
 (2603:10b6:404:13f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend
 Transport; Wed, 24 Mar 2021 10:06:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 24 Mar 2021 10:06:05 +0000
Received: from [172.27.0.48] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 24 Mar
 2021 10:06:00 +0000
Subject: Re: [RFC PATCH V4 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "Don Bollinger" <don@thebollingers.org>, <netdev@vger.kernel.org>,
        "Vladyslav Tarasiuk" <vladyslavt@nvidia.com>
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
 <1616433075-27051-2-git-send-email-moshe@nvidia.com>
 <YFk8RldROAyivyuj@lunn.ch>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <6615e8fc-9476-3d91-eabc-aae91a5d7898@nvidia.com>
Date:   Wed, 24 Mar 2021 12:05:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YFk8RldROAyivyuj@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9565e654-90f4-422b-f4bd-08d8eeac6fee
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5320B263A7F6EF81AF998831D4639@BL1PR12MB5320.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ooImcoks3ebblA1gVC1Ch7xqd0gfXGQBov5jSgATt9G/Y88BFsDcUTfV+A1RYnpoOa7/xK/zNPixartEUavBAzBnuH/0yHPeXFlEhuU6082aBvmnnHuLH9VFllB0cD3j77PpuUIKdOjdB4gtSSgsiA+L1hnQKNEa6YjCN+W6m7VQ5P5Sa5kbvgi/5f49zgJM3anoKw37hbPV92kSeBTVCeImEfQCwKx+IBAArQuSErK+zTJhEx/52hZond4TC3l1j9NzYw9x3Esbq5zwzxK9sb/Wi54k8Q6FehKRCAnE2H2zYnXW2G7ZsfMWbw0QaKQQMoMCBjEjGa4HvQeWDkm7K295uJSNPDFs5RVzKJFAryUqlFHVqDYkbqHfZGF+SghdQZPYKdu+5vgVrJhizIDo5XWMLrriRPOsxIZbxtBN/ov9IXzR6TG8neO8QbEfmoZBSJOQatoQD3lBve4KYvbjTEz98eDsA5MuMJkJuVEpgoGZX5y+K1v4/tT1MMt56AoE5dYI+BOBUo9sifrpj5gptaerBG/5YGAVWjDgOnXiVQG9U9XyZUN/revLRuBv8Mk9Up5BWZN8yUzsNVGTWil3js0XoENG1sENqUL0yg6Lsr4+PCUF/j/17on+27ayxhnWFyfQ1vNLlZybguEEg/f5yj3gUf+Tl9aHgeoi52vaWkQyxDot+3r1O1aUB7iEj2Gq
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(36840700001)(46966006)(5660300002)(426003)(70206006)(53546011)(2906002)(356005)(16576012)(82740400003)(36860700001)(47076005)(316002)(70586007)(86362001)(82310400003)(31696002)(16526019)(4326008)(8936002)(83380400001)(7636003)(2616005)(26005)(186003)(8676002)(36906005)(6666004)(54906003)(107886003)(36756003)(336012)(31686004)(478600001)(6916009)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 10:06:05.0972
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9565e654-90f4-422b-f4bd-08d8eeac6fee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5320
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/23/2021 2:54 AM, Andrew Lunn wrote:
>
>> +static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
>> +                            struct ethnl_reply_data *reply_base,
>> +                            struct genl_info *info)
>> +{
>> +     struct eeprom_reply_data *reply = MODULE_EEPROM_REPDATA(reply_base);
>> +     struct eeprom_req_info *request = MODULE_EEPROM_REQINFO(req_base);
>> +     struct ethtool_module_eeprom page_data = {0};
>> +     struct net_device *dev = reply_base->dev;
>> +     int ret;
>> +
>> +     if (!dev->ethtool_ops->get_module_eeprom_by_page)
>> +             return -EOPNOTSUPP;
>> +
>> +     /* Allow dumps either of low or high page without crossing half page boundary */
>> +     if ((request->offset < ETH_MODULE_EEPROM_PAGE_LEN / 2 &&
>> +          request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN / 2) ||
>> +         request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN)
>> +             return -EINVAL;
> Please keep all the parameter validation together, in
> eeprom_parse_request(). At some point, we may extend
> eeprom_parse_request() to make use of extack, to indicate which
> parameter is invalid. Just getting an -EINVAL can be hard to debug,
> where as NL_SET_ERR_MSG_ATTR() can help the user.
Sure, we can add that.
>        Andrew
