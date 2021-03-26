Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97EE34A778
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 13:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhCZMlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 08:41:40 -0400
Received: from mail-bn8nam11on2055.outbound.protection.outlook.com ([40.107.236.55]:42592
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230170AbhCZMlK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 08:41:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTAE3fNhqV/9lbAcA8boH0IxudiQtHwDBWCBcXUnCZ7MtkQigakfpDQRLlugsOZp1EvPqFWe2nkxLLOvxhyTc9AZ6HSSQbvyaCtxCpJJSHDT396waSK4mlq9gzt8a1MqBdOczd7NPeiWlh9NC2cRWjazDEajc9fkRiT+VBQeJS/FqwQY6Fd8oH3u+0wUOlBdXql4+XXV4u0ryGOoQx5E0fcOIPopUDp10LyBFX6LHpAKI5sRBXDJJputw0jr14b0JpSFXtPNIJW/hY3t3pD/ZLhGidh4w6eyteUXZNRBDirWvnDcIE9BuetIDbJsJbeaV/GKAZNnefgcN4ek2/O9uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoIEWLvgN4aADFKL4qpO0lgHL+qTMPzdaTbLs+OC5l4=;
 b=m3fP8ZF6J9WatWXDtF9v5xH0KzzYBWrRK3QwzeGTjfyN/MGGvNqAlN2F1LUyf2WlPeIflReMNFTI7P9lJpWOE+B48OyeaveLGMB8yWKgjPm74Qt3o3JudlfpEOO34ilvNZUPKOruSOp8oANWxZTFci7BTOZ0QPGB6DdA+ZCc8cekKd1uX+O4xV4ZHzBN0CvFXoignlHzrau8+CKtcaoIYlFfM78tmy4xkZCA3Sy674Myxi6huTiF2KVJbLBmkXAx860AykKSMnJKUeEb++9wmDj0dm0e1nFD0YxwrZqTh7WjudoqiiW+Drcm72HF1tqy7mDbRxKP707khK8xcb8rBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoIEWLvgN4aADFKL4qpO0lgHL+qTMPzdaTbLs+OC5l4=;
 b=OAHdXxedFTdNF5PYvu3B1eKKh4v/gMsIveJyFWfsaDJhXaJeKzJjs+fKnMhtxRGQTBRUYkRhmSv9aIm8YNbOqCiYWxY1hfEkK9DwKO8oPJ2oXjryNZ+vMCkfbIvlIb1rnYq7rpf4q0X7A9gl7lbj6yRKl1oi7AaoVzh2+R85z79c5V4mJA1ht8HKkdJCbhs7FNI/4CtO5NVHV+WY9U+7UrgeZlTcsnwvwHdyzO1w403EpoCcslK+yVL4rNLtgo1mn/Yzmg778+kLbvO9jw3DXgJgczqx/0nQvSRVh6Tk8bWaVi1wEiL6ambWEKXimbxUA9EcKISUaXpjXqd0ila2aQ==
Received: from DM6PR06CA0097.namprd06.prod.outlook.com (2603:10b6:5:336::30)
 by BL0PR12MB4851.namprd12.prod.outlook.com (2603:10b6:208:1c1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 26 Mar
 2021 12:41:08 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::ca) by DM6PR06CA0097.outlook.office365.com
 (2603:10b6:5:336::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend
 Transport; Fri, 26 Mar 2021 12:41:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Fri, 26 Mar 2021 12:41:07 +0000
Received: from [172.27.0.48] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Mar
 2021 12:41:02 +0000
Subject: Re: [RFC PATCH V5 net-next 5/5] ethtool: Add fallback to
 get_module_eeprom from netlink command
To:     Don Bollinger <don@thebollingers.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Andrew Lunn' <andrew@lunn.ch>,
        'Adrian Pop' <pop.adrian61@gmail.com>,
        'Michal Kubecek' <mkubecek@suse.cz>, <netdev@vger.kernel.org>
CC:     'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
References: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
 <1616684215-4701-6-git-send-email-moshe@nvidia.com>
 <00b801d721a2$91b73300$b5259900$@thebollingers.org>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <5bce6d42-2f23-7c35-785c-e03ea5cb7e6f@nvidia.com>
Date:   Fri, 26 Mar 2021 15:40:47 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <00b801d721a2$91b73300$b5259900$@thebollingers.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c54e3c3-903d-4d2f-6a5f-08d8f0546d58
X-MS-TrafficTypeDiagnostic: BL0PR12MB4851:
X-Microsoft-Antispam-PRVS: <BL0PR12MB48510EA20101E4903177BAC1D4619@BL0PR12MB4851.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /OjRUUD++5Msh2chr5atKFxoJSY8MtkSx0FYqXx9bwbTQp5OHaqhHtREJ916cAnODoOtT0I4FR7CNvjG/R8Ct0807hh5at81Eo/EnFxH/Oj+hkoJNyGHdkXKJk/UzaL4dhZ9xr1++EoYUQJAttCMJRq/25FDeMYpjsJ3fzwTTE55wzVnN3jf6I7N6lzLq058FT4EWKmohdjeH6DLCQ+RQfiXwgd5OqpkD9EabDq2Xf+ZCrcZwNgMplYlM0IDqZNqaqnFdKGJXf5dTK96AdkQZtV3F5Nsi9/iMyUoYKybltXkU2e17sc8XBmOajDCdd/WpLad7h5XHsHT2L3Uzam5n6eCpUZoBDxldgG1CcLAkjV5uzv7k9pAZxvnzaGoI/+TmMR5Aex5UPE7CijsbLExLSZ3jUQCOGr2VUjZDjcc3czA+eeJQFpaLcP6E5a4KmgB+6+Hi8gIrvPqPZ+3YvIGEAHimWY1zXskztmHmbvWTnjxFnJLFFs6uRX4VZ+Lpi5u/+d+9Ym2Br9cJ8Sa+oiObaK6PDnm1spKQatVm6CDx/m39dBZucewjmVRp4V1eKiyKpXel3PP7dSjih0PBc+9pqfsSPkqN0jrPnifO6U0RdNNipmWk60tA3zG1g9Sg+0MbmiPT6diJxZm9mSFjwRHIg7oguPlW8dckx5d+Kuwmt/GhGAGPRvQXztYo/rG1TAh
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(46966006)(36840700001)(336012)(8676002)(36860700001)(2906002)(356005)(2616005)(186003)(7636003)(6666004)(82740400003)(4326008)(82310400003)(16576012)(316002)(16526019)(8936002)(26005)(86362001)(426003)(70586007)(478600001)(5660300002)(83380400001)(36756003)(47076005)(107886003)(31686004)(36906005)(110136005)(70206006)(31696002)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 12:41:07.4255
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c54e3c3-903d-4d2f-6a5f-08d8f0546d58
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4851
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/25/2021 8:13 PM, Don Bollinger wrote:
>> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
>>
>> In case netlink get_module_eeprom_by_page() callback is not implemented
>> by the driver, try to call old get_module_info() and get_module_eeprom()
>> pair. Recalculate parameters to get_module_eeprom() offset and len using
>> page number and their sizes. Return error if this can't be done.
>>
>> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
>> ---
>>   net/ethtool/eeprom.c | 66
>> +++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 65 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c index
>> 10d5f6b34f2f..9f773b778bbe 100644
>> --- a/net/ethtool/eeprom.c
>> +++ b/net/ethtool/eeprom.c
>> @@ -25,6 +25,70 @@ struct eeprom_reply_data {  #define
>> MODULE_EEPROM_REPDATA(__reply_base) \
>>        container_of(__reply_base, struct eeprom_reply_data, base)
>>
>> +static int fallback_set_params(struct eeprom_req_info *request,
>> +                            struct ethtool_modinfo *modinfo,
>> +                            struct ethtool_eeprom *eeprom) {
>> +     u32 offset = request->offset;
>> +     u32 length = request->length;
>> +
>> +     if (request->page)
>> +             offset = request->page *
>> ETH_MODULE_EEPROM_PAGE_LEN + offset;
> The test 'if (request->page)' is not necessary, the math works with page 0
> as well.  Keep it if you like the style.
OK.
>> +
>> +     if (modinfo->type == ETH_MODULE_SFF_8079 &&
>> +         request->i2c_address == 0x51)
>> +             offset += ETH_MODULE_EEPROM_PAGE_LEN;
> offset += ETH_MODULE_EEPROM_PAGE_LEN * 2;
>
> Now that PAGE_LEN is 128, you need two of them to account for both low
> memory and high memory at 0x50.


Right, thanks.

>> +
>> +     if (offset >= modinfo->eeprom_len)
>> +             return -EINVAL;
>> +
>> +     eeprom->cmd = ETHTOOL_GMODULEEEPROM;
>> +     eeprom->len = length;
>> +     eeprom->offset = offset;
>> +
>> +     return 0;
>> +}
>> +
>> +static int eeprom_fallback(struct eeprom_req_info *request,
>> +                        struct eeprom_reply_data *reply,
>> +                        struct genl_info *info)
>> +{
>> +     struct net_device *dev = reply->base.dev;
>> +     struct ethtool_modinfo modinfo = {0};
>> +     struct ethtool_eeprom eeprom = {0};
>> +     u8 *data;
>> +     int err;
>> +
>> +     if (!dev->ethtool_ops->get_module_info ||
>> +         !dev->ethtool_ops->get_module_eeprom || request->bank) {
>> +             return -EOPNOTSUPP;
>> +     }
>> +     modinfo.cmd = ETHTOOL_GMODULEINFO;
>> +     err = dev->ethtool_ops->get_module_info(dev, &modinfo);
>> +     if (err < 0)
>> +             return err;
>> +
>> +     err = fallback_set_params(request, &modinfo, &eeprom);
>> +     if (err < 0)
>> +             return err;
>> +
>> +     data = kmalloc(eeprom.len, GFP_KERNEL);
>> +     if (!data)
>> +             return -ENOMEM;
>> +     err = dev->ethtool_ops->get_module_eeprom(dev, &eeprom,
>> data);
>> +     if (err < 0)
>> +             goto err_out;
>> +
>> +     reply->data = data;
>> +     reply->length = eeprom.len;
>> +
>> +     return 0;
>> +
>> +err_out:
>> +     kfree(data);
>> +     return err;
>> +}
>> +
>>   static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
>>                               struct ethnl_reply_data *reply_base,
>>                               struct genl_info *info)
>> @@ -36,7 +100,7 @@ static int eeprom_prepare_data(const struct
>> ethnl_req_info *req_base,
>>        int ret;
>>
>>        if (!dev->ethtool_ops->get_module_eeprom_by_page)
>> -             return -EOPNOTSUPP;
>> +             return eeprom_fallback(request, reply, info);
>>
>>        page_data.offset = request->offset;
>>        page_data.length = request->length;
>> --
>> 2.18.2
