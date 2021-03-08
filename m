Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBABC3309F4
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 10:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhCHJFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 04:05:25 -0500
Received: from mail-dm6nam12on2087.outbound.protection.outlook.com ([40.107.243.87]:37665
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229904AbhCHJE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 04:04:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQFS+efZdQ+LehKNvNHdQyIOHCtBzZFGobfIZmV2/2ydIVhBF+z06NRnAjBaYXTrLezoaqwB2TFbWpsb/jGZEpL8Zf8qIBkqXzTqUhPDUEFa+b/zjhb/0qViLX9qHWR9WK6iw03LYqYDQDdtc+sPmd9kSnCXEvx33fRYseqX8hQuf/yNW9myu5uwPTfdzLauKQgG8+HWqtwtvFkR+3N+XXsFiH/mihwvJuXRz69hqbmYVfMNeRAIzjyww8SpCSIetNBLW4Dm6HPKtBde9yaqOG9k5vMili32QmG5UIhnVoeWZ/UZh2OQt/xlQD+fDGFlvZY8w3RAWxGN9PtTo7koZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQV21ndWaKBFZgCMQGid1lzxLF52S6ALQ4y6zrf/JA4=;
 b=QwJGiAQIMVtzmXp8kml0842zngvERamkEVfj1x0piukOBshbhiyJ7iGFURDfecabRWftvSddRzCc+BjrQB+qxca4EQl8YhPIUVqKrEfdpVFABs91LPT1lBw/qXN8sl/T4g7dw8k/A1NBjBk3LBYfW5vfKq9Q9zyB2lXpbLL8ky5SdgdBDhsuk1ArRxNiYZua2/DFyF35ABRmWPYAHyXzfHKeFo4HKK+Psdz8yEjDWaSgD5Zmp0btoSQgZEoWqM43Y2ZYq9B3OZJLhVbD6ZhCmJVWfnVEgCiwGJL1m1pZPwjbpM4fcUd5184SKpXhNEZt7nh+9wDmdAQw3hslTVU7jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQV21ndWaKBFZgCMQGid1lzxLF52S6ALQ4y6zrf/JA4=;
 b=MRcRREsWdsdcZN5FSUwGK7ubcJMIDE1/nULVANW7Yvtebu08qfE80aXHEVITAL7oBvrsRHypd18yGP7H5Lpyw2GF6SUbwM8uDw0zfFJ6+33UFUMlhUo/u3uJ0GBSuoEwyDBvg8mY0ZB/caZoAIpFL+qxI9T5Rl/Gs9OyrwbE+ps=
Received: from DM3PR11CA0014.namprd11.prod.outlook.com (2603:10b6:0:54::24) by
 DM6PR12MB3132.namprd12.prod.outlook.com (2603:10b6:5:3c::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.28; Mon, 8 Mar 2021 09:04:58 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:54:cafe::3f) by DM3PR11CA0014.outlook.office365.com
 (2603:10b6:0:54::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Mon, 8 Mar 2021 09:04:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 09:04:58 +0000
Received: from [172.27.0.187] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 8 Mar
 2021 09:04:55 +0000
Subject: Re: [RFC PATCH V2 net-next 5/5] ethtool: Add fallback to
 get_module_eeprom from netlink command
To:     Don Bollinger <don@thebollingers.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Andrew Lunn' <andrew@lunn.ch>,
        'Adrian Pop' <pop.adrian61@gmail.com>,
        'Michal Kubecek' <mkubecek@suse.cz>, <netdev@vger.kernel.org>
CC:     'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
 <1614884228-8542-6-git-send-email-moshe@nvidia.com>
 <001201d71159$88013120$98039360$@thebollingers.org>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <aa1237d1-315b-8233-72a8-95e7afd033ee@nvidia.com>
Date:   Mon, 8 Mar 2021 11:04:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <001201d71159$88013120$98039360$@thebollingers.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a987f67e-7f58-43f1-6fe4-08d8e2113f9a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3132:
X-Microsoft-Antispam-PRVS: <DM6PR12MB313233ACB6B12BE7EE1F1D27D4939@DM6PR12MB3132.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EHkP7pxf3Xs2c+J+prM9XL5EaUwOUeldegiK4kSgiuKMza8IzNjQ+10m+QMfMabiOj47vOSyMenIvnCfej1gOLsUhukNrWhXfueK1M8ZVqmjgx+0c4JNPUC4FwMH0X/DAe/IDXhnyT+q7tF/dKvPsfgyqRakDtcuMQq6DMLBRAFtaTKn8UEeiNOq9SPm40C9B9L7I5G9mANmxWZiMfZendWI876BWtYM3ZDdJx9+ur7507b6dvS3jQuHd6n2sGYUIMIMQBbY3YNHOAE2RlArJkPMqqbmtHguqkAXaI8kGadlX0OzJi6HXwhAYuk/7bAPGXQx/BYmJ25sR9jhHB2fx3eR0Oz7OTi+DUFWvA/jnWtCzqNGp0x3PRvb+ibH9luNyF7PaPeKv+ABbiAKYx5W8xvXD08Vw6fW7sMoQRwic00BfKLSLYLU2MlwB80Sz2ezH+4871z+un7iFMd/mNJB+NiYy4wkSfhw1f3OQj3p4jnJmfSpVnRLDTvEqGwlCSfep87NCw7jG+zhgY/9932jRKb/AeAgLF2WrF8atXXYtUnuVuoRABnTQPnaX/iZrrMwpEEY6YoJ85TIsOm2gxaMYCPVjl5wHUrRy/VMuOBK27qzrTMUyAu4PU4RBnq6HQrpuxtSkqHoAupg5dZSXNVu+1nxKnTJ5zGrwVRMzrTlYbQWf/UgTmY3VV02HDfoDhftBf5JVZwmyh0NCyPp5a3oIzXEQQDo/z3UEAc2Oo/Pieg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(36840700001)(46966006)(4326008)(70586007)(426003)(47076005)(70206006)(26005)(336012)(8676002)(36756003)(86362001)(82310400003)(82740400003)(356005)(7636003)(34020700004)(83380400001)(107886003)(2616005)(186003)(16526019)(16576012)(478600001)(36906005)(53546011)(316002)(36860700001)(110136005)(31696002)(5660300002)(8936002)(2906002)(6666004)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 09:04:58.1362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a987f67e-7f58-43f1-6fe4-08d8e2113f9a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3132
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/5/2021 2:50 AM, Don Bollinger wrote:
>
> On Thu, Mar 04, 2021 at 10:57AM-0800, Moshe Shemesh wrote:
>> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
>>
>> In case netlink get_module_eeprom_data_by_page() callback is not
>> implemented by the driver, try to call old get_module_info() and
>> get_module_eeprom() pair. Recalculate parameters to
>> get_module_eeprom() offset and len using page number and their sizes.
>> Return error if this can't be done.
>>
>> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
>> ---
>>   net/ethtool/eeprom.c | 84
>> +++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 83 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c index
>> 2618a55b9a40..72c7714a9d37 100644
>> --- a/net/ethtool/eeprom.c
>> +++ b/net/ethtool/eeprom.c
>> @@ -26,6 +26,88 @@ struct eeprom_data_reply_data {  #define
>> EEPROM_DATA_REPDATA(__reply_base) \
>>        container_of(__reply_base, struct eeprom_data_reply_data, base)
>>
>> +static int fallback_set_params(struct eeprom_data_req_info *request,
>> +                            struct ethtool_modinfo *modinfo,
>> +                            struct ethtool_eeprom *eeprom) {
> This is translating the new data structure into the old.  Hence, I assume we
> have i2c_addr, page, bank, offset, len to work with, and we should use
> all of them.  We shouldn't be applying the legacy data structure's rules
> to how we interpret the *request data.  Therefore...
>
>> +     u32 offset = request->offset;
>> +     u32 length = request->length;
>> +
>> +     if (request->page)
>> +             offset = 128 + request->page * 128 + offset;
> This is tricky to map to old behavior.  The new data structure should give
> lower
> memory for offsets less than 128, and paged upper memory for offsets of 128
> and higher.  There is no way to describe that request as {offset, length} in
> the
> old ethtool format with a fake linear memory.
>
>          if (request->page) {
>                  if (offset < 128) && (offset + length > 128)
>                         return -EINVAL;
>                  if (offset > 127) offset = request->page * 128 + offset;
Yes, if we got page, that's the new API.
>> +
>> +     if (!length)
>> +             length = modinfo->eeprom_len;
>> +
>> +     if (offset >= modinfo->eeprom_len)
>> +             return -EINVAL;
>> +
>> +     if (modinfo->eeprom_len < offset + length)
>> +             length = modinfo->eeprom_len - offset;
>> +
>> +     eeprom->cmd = ETHTOOL_GMODULEEEPROM;
>> +     eeprom->len = length;
>> +     eeprom->offset = offset;
>> +
>> +     switch (modinfo->type) {
>> +     case ETH_MODULE_SFF_8079:
>> +             if (request->page > 1)
>> +                     return -EINVAL;
>> +             break;
>> +     case ETH_MODULE_SFF_8472:
>> +             if (request->page > 3)
> Not sure this is needed, there can be pages higher than 3.
>
>> +                     return -EINVAL;
> I *think* the linear memory on SFP puts 0x50 in the first
> 256 bytes, 0x51 after that, including pages after that.  So,
> the old fashioned linear memory offset needs to be adjusted
> for accesses to 0x51.  Thus add:
>
>          if (request->i2c_address == 0x51)
>                  offset += 256;
Will check that. In the old KAPI the i2c address is not a parameter, so 
it depends on driver implementation.
>> +             break;
>> +     case ETH_MODULE_SFF_8436:
>> +     case ETH_MODULE_SFF_8636:
> Not sure this is needed, there can be pages higher than 3.
>
>> +             if (request->page > 3)
>> +                     return -EINVAL;
>> +             break;
>> +     }
>> +     return 0;
>> +}
>> +
>> +static int eeprom_data_fallback(struct eeprom_data_req_info *request,
>> +                             struct eeprom_data_reply_data *reply,
>> +                             struct genl_info *info)
>> +{
>> +     struct net_device *dev = reply->base.dev;
>> +     struct ethtool_modinfo modinfo = {0};
>> +     struct ethtool_eeprom eeprom = {0};
>> +     u8 *data;
>> +     int err;
>> +
>> +     if ((!dev->ethtool_ops->get_module_info &&
>> +          !dev->ethtool_ops->get_module_eeprom) ||
>> +         request->bank || request->i2c_address) {
> We don't need to reject if there is an i2c_address.  Indeed, we need that
> to determine the correct offset for the legacy linear memory offset.
Will check that. As Andrew said, there might be usage of other i2c 
addresses with old KAPI.
> Note my comment on an earlier patch in this series, I would have rejected
> any request that didn't have either 0x50 or 0x51 here.
>
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
>>   static int eeprom_data_prepare_data(const struct ethnl_req_info
>> *req_base,
>>                                    struct ethnl_reply_data *reply_base,
>>                                    struct genl_info *info)
>> @@ -37,7 +119,7 @@ static int eeprom_data_prepare_data(const struct
>> ethnl_req_info *req_base,
>>        int err;
>>
>>        if (!dev->ethtool_ops->get_module_eeprom_data_by_page)
>> -             return -EOPNOTSUPP;
>> +             return eeprom_data_fallback(request, reply, info);
>>
>>        page_data.offset = request->offset;
>>        page_data.length = request->length;
>> --
>> 2.18.2
>
