Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5568F3309B2
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 09:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhCHIpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 03:45:46 -0500
Received: from mail-bn8nam11on2082.outbound.protection.outlook.com ([40.107.236.82]:21248
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230246AbhCHIph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 03:45:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3VdCXpbWaCIcv+6ZbKbiYTKanhhVD4kTAjZSvYXkGiD4bozVHal8stXCoBCUAKSbjBNzNmQYt6+aFQ6cujdQKxX6ADfoAp+RlbzsbZ+1RmQKisDcT92IAP2xsS5uZy6NVToHfnhEW7h3EeQXgyiMpPTJI7CAwGbTgiknZtcYjDIdY7W19yecNRCjyMoo/jLlbQRYopXT/UXxS8arR2Z4esphTLQ56xgO1vCSIUx0qOvLd+eCsUtG2qXmNjxkeAG1ySeR0LWDre1ZSHa2rIGKpP+qqQBsmxGpxIcf7YeqfprM1aEYbRn9cvyMSWzHZLflzxvHdLpuwsuvFdKca2T5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSZ/zU6OWViiqjSBK0ZCm3BII17aEVHnKC2j5c5qwrk=;
 b=CNGmAfA3dsj0liLjZbNLf8A/MM76JFuiposCz/N7brcAVEU6YX0rsz6TF+bWjxcRh2PKshtcJ2qGCZQuicCrlsXGk4O4duyJoybXJEcILG8pmFeD8tB9YaR76f+4/bdHkO7WVyhlgM5Q7rsHu4Gh3dDzK2FRu858CHxxPRjVDpOG3gx9wCCQDuS1AYvLpKuoI+A7zW8zkqRTsziCsgbTQnWZWXcp+TW1hN6FhPwcC0oQX8E/AqU7u2lmlCd5cpNFxtrIw+F3BzWT7DNY3PZUfAnIX7CqJ4eZFGCd6jwbhfdrLsYUbgK4YswYs47oHzDD6ESoTf/pVTTZXdGHCiet6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSZ/zU6OWViiqjSBK0ZCm3BII17aEVHnKC2j5c5qwrk=;
 b=xedw0KOJZ6afZSjJASjczI+6W4h38hu4ZGGJYLcwQZ8Y/Q35j0CpNe4SEfO0BEpUUhk+ddVuKkc5VCecoC/paWu5yjNfVMzhQbhXW0tSRV8L0NX/DBNORgqFBRkOOlA+RilMDRBVqFa6CbjZ7rXCQnCE4yU8JNxNEv2z5eYfglE=
Received: from MW4PR03CA0272.namprd03.prod.outlook.com (2603:10b6:303:b5::7)
 by MW2PR12MB2473.namprd12.prod.outlook.com (2603:10b6:907:4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Mon, 8 Mar
 2021 08:45:31 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::74) by MW4PR03CA0272.outlook.office365.com
 (2603:10b6:303:b5::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Mon, 8 Mar 2021 08:45:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 08:45:31 +0000
Received: from [172.27.0.187] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 8 Mar
 2021 08:45:28 +0000
Subject: Re: [RFC PATCH V2 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
To:     Don Bollinger <don@thebollingers.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Andrew Lunn' <andrew@lunn.ch>,
        'Adrian Pop' <pop.adrian61@gmail.com>,
        'Michal Kubecek' <mkubecek@suse.cz>, <netdev@vger.kernel.org>
CC:     'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
 <1614884228-8542-2-git-send-email-moshe@nvidia.com>
 <001101d71159$8721f4b0$9565de10$@thebollingers.org>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <d0dcd510-520b-92ec-67fd-da50970d10a8@nvidia.com>
Date:   Mon, 8 Mar 2021 10:45:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <001101d71159$8721f4b0$9565de10$@thebollingers.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36438c2f-eb03-45c9-93f0-08d8e20e885d
X-MS-TrafficTypeDiagnostic: MW2PR12MB2473:
X-Microsoft-Antispam-PRVS: <MW2PR12MB247301529755B5B111FE6353D4939@MW2PR12MB2473.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6C9Fra5soFikVFKtmV4f+R07BPWQsF5R8fU1qvyBX8BqdDBBfUmT8JWPRc+ZG4Fh/cJ3MNDxL9VAOh3jPDkSBeFqUo25wbhYf0Y+dKcuB3lq1VOZEuI1/+8hB5xYiuWPAVsfSoZhmYbuXoR6YYDFpsGh74xSUKhOFGiAyJ7nDmDwmX9PJIcxKPqLjR+rw6//8K6D8idufWsrRN7CMS1rLCf5kTPcFQGhgxpf+PDQYMFMfEMrMvod//u3x8ZO5d5ELoxa5xnx0rGDw4kvnGFF6g9GnhhrQn7aOt4r4XnhTSVmxVVaWdP/K527E6z37KhfCAKJPAZc6Z6wO79xfmWe69TCVnR/rPQSWLz22VqkUxRvyRn16AnoQXVmjOXjt1YTFtKYniMMuD+1UIkH/9snZY7HzX2/ptZo6fJx3mSpVcnkiFlO/cJ/HnAJBdjt6E/hFkjdPcou0RNyvbk04KpBGeO6A7JUTNQKYbyPJD/415X9tbsb6tes/yf/XKMPeAzYRCO+rTozfNjLb8PVGlOyXPb+WqoSp5xj6fn1mf0sT+8UeYT1f2NKNhhuuen4Zs4lj/q+h0zbCA/D02+Ymdx1pGaqvqI10/C/ggtjIlInbjizMK7aL5XXzCVZnOChkKFiA1wLVAHN7WeHyegbfeDI9Ihc57vUA/UYzbU09943QDZcuuRYO6HsTTOFXmSO4EwpzlrZfM7A3cjxv0n6ncqLmw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(136003)(346002)(46966006)(36840700001)(31686004)(82310400003)(2616005)(110136005)(34020700004)(70206006)(7636003)(70586007)(8936002)(82740400003)(36756003)(16576012)(356005)(36906005)(8676002)(316002)(26005)(86362001)(36860700001)(6666004)(107886003)(336012)(47076005)(2906002)(426003)(83380400001)(478600001)(186003)(31696002)(16526019)(53546011)(4326008)(5660300002)(30864003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 08:45:31.6939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36438c2f-eb03-45c9-93f0-08d8e20e885d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2473
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/5/2021 2:50 AM, Don Bollinger wrote:
>
> On Thu, Mar 04, 2021 at 10:57AM-0800, Moshe Shemesh wrote:
>> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
>>
>> Define get_module_eeprom_data_by_page() ethtool callback and
>> implement netlink infrastructure.
>>
>> get_module_eeprom_data_by_page() allows network drivers to dump a
>> part of module's EEPROM specified by page and bank numbers along with
>> offset and length. It is effectively a netlink replacement for
>> get_module_info() and get_module_eeprom() pair, which is needed due to
>> emergence of complex non-linear EEPROM layouts.
>>
>> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
>> ---
>>   include/linux/ethtool.h              |   7 +-
>>   include/uapi/linux/ethtool.h         |  26 +++++
>>   include/uapi/linux/ethtool_netlink.h |  19 ++++
>>   net/ethtool/Makefile                 |   2 +-
>>   net/ethtool/eeprom.c                 | 157 +++++++++++++++++++++++++++
>>   net/ethtool/netlink.c                |  10 ++
>>   net/ethtool/netlink.h                |   2 +
>>   7 files changed, 221 insertions(+), 2 deletions(-)  create mode 100644
>> net/ethtool/eeprom.c
>>
>> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h index
>> ec4cd3921c67..2f65aae5f492 100644
>> --- a/include/linux/ethtool.h
>> +++ b/include/linux/ethtool.h
>> @@ -81,6 +81,7 @@ enum {
>>   #define ETH_RSS_HASH_NO_CHANGE       0
>>
>>   struct net_device;
>> +struct netlink_ext_ack;
>>
>>   /* Some generic methods drivers may use in their ethtool_ops */
>>   u32 ethtool_op_get_link(struct net_device *dev); @@ -410,6 +411,8 @@
>> struct ethtool_pause_stats {
>>    * @get_ethtool_phy_stats: Return extended statistics about the PHY
>> device.
>>    *   This is only useful if the device maintains PHY statistics and
>>    *   cannot use the standard PHY library helpers.
>> + * @get_module_eeprom_data_by_page: Get a region of plug-in module
>> EEPROM data
>> + *   from specified page. Returns a negative error code or zero.
>>    *
>>    * All operations are optional (i.e. the function pointer may be set
>>    * to %NULL) and callers must take this into account.  Callers must @@
> -515,6
>> +518,9 @@ struct ethtool_ops {
>>                                   const struct ethtool_tunable *, void *);
>>        int     (*set_phy_tunable)(struct net_device *,
>>                                   const struct ethtool_tunable *, const
> void
>> *);
>> +     int     (*get_module_eeprom_data_by_page)(struct net_device
>> *dev,
>> +                                               const struct
>> ethtool_eeprom_data *page,
>> +                                               struct netlink_ext_ack
>> *extack);
>>   };
>>
>>   int ethtool_check_ops(const struct ethtool_ops *ops); @@ -538,7 +544,6
>> @@ int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
>>                                       const struct ethtool_link_ksettings
> *cmd,
>>                                       u32 *dev_speed, u8 *dev_duplex);
>>
>> -struct netlink_ext_ack;
>>   struct phy_device;
>>   struct phy_tdr_config;
>>
>> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index
>> cde753bb2093..2459571fc1d1 100644
>> --- a/include/uapi/linux/ethtool.h
>> +++ b/include/uapi/linux/ethtool.h
>> @@ -340,6 +340,28 @@ struct ethtool_eeprom {
>>        __u8    data[0];
>>   };
>>
>> +/**
>> + * struct ethtool_eeprom_data - EEPROM dump from specified page
>> + * @offset: Offset within the specified EEPROM page to begin read, in
>> bytes.
> Note here that bytes at offset 0-127 are the same for every page of the
> module, only bytes at offset 128 and higher are actually paged.
Right, but still having the offset relative to 128 will be confusing.
>> + * @length: Number of bytes to read.
>> + * @page: Page number to read from.
>> + * @bank: Page bank number to read from, if applicable by EEPROM spec.
>> + * @i2c_address: I2C address of a page. Value less than 0x7f expected.
>> Most
>> + *   EEPROMs use 0x50 or 0x51.
> The standards are all very clear, the only legal values are 0x50 and 0x51.
> It isn't 'expected', it is required.  I suggest that 0xA0 and 0xA2 also be
> silently accepted, and translated to 0x50 and 0x51 respectively.  Some
> of the specs use A0/A2 instead of 0x50/0x51.  They actually mean the
> same thing.
>
>> + * @data: Pointer to buffer with EEPROM data of @length size.
>> + *
>> + * This can be used to manage pages during EEPROM dump in ethtool and
>> +pass
>> + * required information to the driver.
>> + */
>> +struct ethtool_eeprom_data {
>> +     __u32   offset;
>> +     __u32   length;
>> +     __u32   page;
>> +     __u32   bank;
>> +     __u32   i2c_address;
>> +     __u8    *data;
>> +};
>> +
>>   /**
>>    * struct ethtool_eee - Energy Efficient Ethernet information
>>    * @cmd: ETHTOOL_{G,S}EEE
>> @@ -1865,6 +1887,10 @@ static inline int ethtool_validate_duplex(__u8
>> duplex)
>>   #define ETH_MODULE_SFF_8636_MAX_LEN     640
>>   #define ETH_MODULE_SFF_8436_MAX_LEN     640
>>
>> +#define ETH_MODULE_EEPROM_MAX_LEN    640
> Please don't add this MAX_LEN constant.  Even better, remove
> the two above it as well.


These constants are relevant to the ioctl function and used by the 
drivers. For netlink new KAPI I will remove the new MAX_LEN per your 
explanation, thanks.

> The proper value for all 3 of these MAX_LEN items is the
> architectural limit imposed by the 8 bit page register plus the constant
> lower page (hence 257*128 bytes).  The 8436 and 8636
> specs do not actually limit these devices to 640 bytes (3 pages).
>
> There is no MAX_LEN listed for SFF_8472.  If there is one, it should
> actually be 259 * 128 bytes (to account for 256 more bytes on the
> unpaged 0x50 i2c address).
>
>   Nor is there one for CMIS.  The maximum
> architected length for CMIS is (257*128) + (127 * 16 * 128).  That's
> the QSFP max length plus 127 more banks of 16 pages.
>
>> +#define ETH_MODULE_EEPROM_PAGE_LEN   256
>> +#define ETH_MODULE_MAX_I2C_ADDRESS   0x7f
> Actually there are only two legal values for the i2c address (0x50, 0x51).
> Rather than defining a MAX address, consider defining the legal values,
> or...  is it used at all?  Leave it out?
As Andrew commented there might be usage of other i2c adresses, I will 
keep it.
>> +
>>   /* Reset flags */
>>   /* The reset() operation must clear the flags for the components which
>>    * were actually reset.  On successful return, the flags indicate the
> diff --git
>> a/include/uapi/linux/ethtool_netlink.h
>> b/include/uapi/linux/ethtool_netlink.h
>> index a286635ac9b8..60dd848d0b54 100644
>> --- a/include/uapi/linux/ethtool_netlink.h
>> +++ b/include/uapi/linux/ethtool_netlink.h
>> @@ -42,6 +42,7 @@ enum {
>>        ETHTOOL_MSG_CABLE_TEST_ACT,
>>        ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
>>        ETHTOOL_MSG_TUNNEL_INFO_GET,
>> +     ETHTOOL_MSG_EEPROM_DATA_GET,
>>
>>        /* add new constants above here */
>>        __ETHTOOL_MSG_USER_CNT,
>> @@ -80,6 +81,7 @@ enum {
>>        ETHTOOL_MSG_CABLE_TEST_NTF,
>>        ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
>>        ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
>> +     ETHTOOL_MSG_EEPROM_DATA_GET_REPLY,
>>
>>        /* add new constants above here */
>>        __ETHTOOL_MSG_KERNEL_CNT,
>> @@ -629,6 +631,23 @@ enum {
>>        ETHTOOL_A_TUNNEL_INFO_MAX =
>> (__ETHTOOL_A_TUNNEL_INFO_CNT - 1)  };
>>
>> +/* MODULE EEPROM DATA */
>> +
>> +enum {
>> +     ETHTOOL_A_EEPROM_DATA_UNSPEC,
>> +     ETHTOOL_A_EEPROM_DATA_HEADER,
>> +
>> +     ETHTOOL_A_EEPROM_DATA_OFFSET,
>> +     ETHTOOL_A_EEPROM_DATA_LENGTH,
>> +     ETHTOOL_A_EEPROM_DATA_PAGE,
>> +     ETHTOOL_A_EEPROM_DATA_BANK,
>> +     ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS,
>> +     ETHTOOL_A_EEPROM_DATA,
>> +
>> +     __ETHTOOL_A_EEPROM_DATA_CNT,
>> +     ETHTOOL_A_EEPROM_DATA_MAX =
>> (__ETHTOOL_A_EEPROM_DATA_CNT - 1) };
>> +
>>   /* generic netlink info */
>>   #define ETHTOOL_GENL_NAME "ethtool"
>>   #define ETHTOOL_GENL_VERSION 1
>> diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile index
>> 7a849ff22dad..d604346bc074 100644
>> --- a/net/ethtool/Makefile
>> +++ b/net/ethtool/Makefile
>> @@ -7,4 +7,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK) += ethtool_nl.o
>>   ethtool_nl-y := netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
>>                   linkstate.o debug.o wol.o features.o privflags.o rings.o
> \
>>                   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o
> \
>> -                tunnels.o
>> +                tunnels.o eeprom.o
>> diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c new file mode
>> 100644 index 000000000000..2618a55b9a40
>> --- /dev/null
>> +++ b/net/ethtool/eeprom.c
>> @@ -0,0 +1,157 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +
>> +#include <linux/ethtool.h>
>> +#include "netlink.h"
>> +#include "common.h"
>> +
>> +struct eeprom_data_req_info {
>> +     struct ethnl_req_info   base;
>> +     u32                     offset;
>> +     u32                     length;
>> +     u32                     page;
>> +     u32                     bank;
>> +     u32                     i2c_address;
>> +};
>> +
>> +struct eeprom_data_reply_data {
>> +     struct ethnl_reply_data base;
>> +     u32                     length;
>> +     u32                     i2c_address;
>> +     u8                      *data;
>> +};
>> +
>> +#define EEPROM_DATA_REQINFO(__req_base) \
>> +     container_of(__req_base, struct eeprom_data_req_info, base)
>> +
>> +#define EEPROM_DATA_REPDATA(__reply_base) \
>> +     container_of(__reply_base, struct eeprom_data_reply_data, base)
>> +
>> +static int eeprom_data_prepare_data(const struct ethnl_req_info
>> *req_base,
>> +                                 struct ethnl_reply_data *reply_base,
>> +                                 struct genl_info *info)
>> +{
>> +     struct eeprom_data_reply_data *reply =
>> EEPROM_DATA_REPDATA(reply_base);
>> +     struct eeprom_data_req_info *request =
>> EEPROM_DATA_REQINFO(req_base);
>> +     struct ethtool_eeprom_data page_data = {0};
>> +     struct net_device *dev = reply_base->dev;
>> +     int err;
>> +
>> +     if (!dev->ethtool_ops->get_module_eeprom_data_by_page)
>> +             return -EOPNOTSUPP;
>> +
>> +     page_data.offset = request->offset;
>> +     page_data.length = request->length;
>> +     page_data.i2c_address = request->i2c_address;
>> +     page_data.page = request->page;
>> +     page_data.bank = request->bank;
>> +     page_data.data = kmalloc(page_data.length, GFP_KERNEL);
>> +     if (!page_data.data)
>> +             return -ENOMEM;
>> +     err = ethnl_ops_begin(dev);
>> +     if (err)
>> +             goto err_free;
>> +
>> +     err = dev->ethtool_ops->get_module_eeprom_data_by_page(dev,
>> &page_data,
>> +
> info->extack);
>> +     if (err)
>> +             goto err_ops;
>> +
>> +     reply->length = page_data.length;
>> +     reply->i2c_address = page_data.i2c_address;
>> +     reply->data = page_data.data;
>> +
>> +     ethnl_ops_complete(dev);
> The two error paths below kfree(page_data.data).  Does someone else
> free this memory when there is no error?
eeprom_data_cleanup_data()
>> +     return 0;
>> +
>> +err_ops:
>> +     ethnl_ops_complete(dev);
>> +err_free:
>> +     kfree(page_data.data);
>> +     return err;
>> +}
>> +
>> +static int eeprom_data_parse_request(struct ethnl_req_info *req_info,
>> struct nlattr **tb,
>> +                                  struct netlink_ext_ack *extack) {
>> +     struct eeprom_data_req_info *request =
>> EEPROM_DATA_REQINFO(req_info);
>> +
>> +     if (!tb[ETHTOOL_A_EEPROM_DATA_OFFSET] ||
>> +         !tb[ETHTOOL_A_EEPROM_DATA_LENGTH] ||
>> +         !tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS])
>> +             return -EINVAL;
>> +
>> +     request->i2c_address =
>> nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]);
>> +     if (request->i2c_address > ETH_MODULE_MAX_I2C_ADDRESS)
>> +             return -EINVAL;
> I would be much more restrictive, with one flexibility...
>
>          if (request->i2c_address == 0xA0) request->i2c_address = 0x50;
>          if (request->i2c_address == 0xA2) request->i2c_address = 0x51;
>          if (request->i2c_address < 0x50) || (request->i2c_address > 0x51)
>                  return -EINVAL;
>
>> +
>> +     request->offset =
>> nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_OFFSET]);
>> +     request->length =
>> nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_LENGTH]);
>> +     if (request->length > ETH_MODULE_EEPROM_MAX_LEN)
>> +             return -EINVAL;
> This is really problematic as there are MANY different max values, within
> the specs, for the various EEPROMs being generically supported here.
> I would leave it to the drivers to handle out-of-range requests.  If you
> really want to check, you need to know which spec the module supports,
> whether it supports pages, and whether it supports banks.  I have not
> found a register that actually reports the number of supported pages
> that an eeprom supports.  The specs should have included that :-(.


Will remove this check per your explanation, thanks.

>> +     if (tb[ETHTOOL_A_EEPROM_DATA_PAGE] &&
>> +         request->offset + request->length >
>> ETH_MODULE_EEPROM_PAGE_LEN)
>> +             return -EINVAL;
> Why does this stanza depend on DATA_PAGE?  In this new data
> structure, no requests can cross the 256 byte page boundary.
>
> I suggest, rather then -EINVAL, you should reduce the length to reach
> the end of the page:
>
>          if (request->offset + request->length) > ETH_MODULE_EEPROM_PAGE_LEN)
>                  request->length = ETH_MODULE_EEPROM_PAGE_LEN -
>                                                        request->offset.


Backward compatibility, users use the command without page and bank as 
it was till now expect to get data that can cross page as it worked till 
now, I can't break it.

> Note that this matches the choice you made to truncate rather than
> error out in fallback_set_parms().

We truncate in fallback_set_params() to eeprom_len.

length = modinfo->eeprom_len - offset;

>> +
>> +     if (tb[ETHTOOL_A_EEPROM_DATA_PAGE])
>> +             request->page =
>> nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_PAGE]);
>> +     if (tb[ETHTOOL_A_EEPROM_DATA_BANK])
>> +             request->bank =
>> nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_BANK]);
> Other checks:
>
> Page and bank have to be between 0 and 255 (inclusive), they
> go into an 8 bit register in the eeprom.
Will add, thanks.
> Offset and length can't be negative.
Already are u32.
>> +
>> +     return 0;
>> +}
>> +
>> +static int eeprom_data_reply_size(const struct ethnl_req_info *req_base,
>> +                               const struct ethnl_reply_data *reply_base)
> {
>> +     const struct eeprom_data_req_info *request =
>> +EEPROM_DATA_REQINFO(req_base);
>> +
>> +     return nla_total_size(sizeof(u32)) + /* _EEPROM_DATA_LENGTH */
>> +            nla_total_size(sizeof(u32)) + /* _EEPROM_DATA_I2C_ADDRESS
>> */
>> +            nla_total_size(sizeof(u8) * request->length); /* _EEPROM_DATA
>> +*/ }
>> +
>> +static int eeprom_data_fill_reply(struct sk_buff *skb,
>> +                               const struct ethnl_req_info *req_base,
>> +                               const struct ethnl_reply_data *reply_base)
> {
>> +     struct eeprom_data_reply_data *reply =
>> +EEPROM_DATA_REPDATA(reply_base);
>> +
>> +     if (nla_put_u32(skb, ETHTOOL_A_EEPROM_DATA_LENGTH, reply-
>>> length) ||
>> +         nla_put_u32(skb, ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS,
>> reply->i2c_address) ||
>> +         nla_put(skb, ETHTOOL_A_EEPROM_DATA, reply->length, reply-
>>> data))
>> +             return -EMSGSIZE;
>> +
>> +     return 0;
>> +}
>> +
>> +static void eeprom_data_cleanup_data(struct ethnl_reply_data
>> +*reply_base) {
>> +     struct eeprom_data_reply_data *reply =
>> +EEPROM_DATA_REPDATA(reply_base);
>> +
>> +     kfree(reply->data);
>> +}
>> +
>> +const struct ethnl_request_ops ethnl_eeprom_data_request_ops = {
>> +     .request_cmd            = ETHTOOL_MSG_EEPROM_DATA_GET,
>> +     .reply_cmd              =
>> ETHTOOL_MSG_EEPROM_DATA_GET_REPLY,
>> +     .hdr_attr               = ETHTOOL_A_EEPROM_DATA_HEADER,
>> +     .req_info_size          = sizeof(struct eeprom_data_req_info),
>> +     .reply_data_size        = sizeof(struct eeprom_data_reply_data),
>> +
>> +     .parse_request          = eeprom_data_parse_request,
>> +     .prepare_data           = eeprom_data_prepare_data,
>> +     .reply_size             = eeprom_data_reply_size,
>> +     .fill_reply             = eeprom_data_fill_reply,
>> +     .cleanup_data           = eeprom_data_cleanup_data,
>> +};
>> +
>> +const struct nla_policy ethnl_eeprom_data_get_policy[] = {
>> +     [ETHTOOL_A_EEPROM_DATA_HEADER]          =
>> NLA_POLICY_NESTED(ethnl_header_policy),
>> +     [ETHTOOL_A_EEPROM_DATA_OFFSET]          = { .type =
>> NLA_U32 },
>> +     [ETHTOOL_A_EEPROM_DATA_LENGTH]          = { .type =
>> NLA_U32 },
>> +     [ETHTOOL_A_EEPROM_DATA_PAGE]            = { .type = NLA_U32 },
>> +     [ETHTOOL_A_EEPROM_DATA_BANK]            = { .type = NLA_U32 },
>> +     [ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]     = { .type = NLA_U32 },
>> +     [ETHTOOL_A_EEPROM_DATA]                 = { .type =
>> NLA_BINARY },
>> +};
>> +
>> diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c index
>> 50d3c8896f91..ff2528bee192 100644
>> --- a/net/ethtool/netlink.c
>> +++ b/net/ethtool/netlink.c
>> @@ -245,6 +245,7 @@
>> ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
>>        [ETHTOOL_MSG_PAUSE_GET]         =
>> &ethnl_pause_request_ops,
>>        [ETHTOOL_MSG_EEE_GET]           = &ethnl_eee_request_ops,
>>        [ETHTOOL_MSG_TSINFO_GET]        = &ethnl_tsinfo_request_ops,
>> +     [ETHTOOL_MSG_EEPROM_DATA_GET]   =
>> &ethnl_eeprom_data_request_ops,
>>   };
>>
>>   static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback
>> *cb) @@ -912,6 +913,15 @@ static const struct genl_ops ethtool_genl_ops[]
>> = {
>>                .policy = ethnl_tunnel_info_get_policy,
>>                .maxattr = ARRAY_SIZE(ethnl_tunnel_info_get_policy) - 1,
>>        },
>> +     {
>> +             .cmd    = ETHTOOL_MSG_EEPROM_DATA_GET,
>> +             .doit   = ethnl_default_doit,
>> +             .start  = ethnl_default_start,
>> +             .dumpit = ethnl_default_dumpit,
>> +             .done   = ethnl_default_done,
>> +             .policy = ethnl_eeprom_data_get_policy,
>> +             .maxattr = ARRAY_SIZE(ethnl_eeprom_data_get_policy) - 1,
>> +     },
>>   };
>>
>>   static const struct genl_multicast_group ethtool_nl_mcgrps[] = { diff
> --git
>> a/net/ethtool/netlink.h b/net/ethtool/netlink.h index
>> 6eabd58d81bf..60954c7b4dfe 100644
>> --- a/net/ethtool/netlink.h
>> +++ b/net/ethtool/netlink.h
>> @@ -344,6 +344,7 @@ extern const struct ethnl_request_ops
>> ethnl_coalesce_request_ops;  extern const struct ethnl_request_ops
>> ethnl_pause_request_ops;  extern const struct ethnl_request_ops
>> ethnl_eee_request_ops;  extern const struct ethnl_request_ops
>> ethnl_tsinfo_request_ops;
>> +extern const struct ethnl_request_ops ethnl_eeprom_data_request_ops;
>>
>>   extern const struct nla_policy
>> ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];  extern const struct
>> nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1]; @@
>> -375,6 +376,7 @@ extern const struct nla_policy
>> ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_HEADER +  extern const struct
>> nla_policy ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_HEADER +
>> 1];  extern const struct nla_policy
>> ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG + 1];
>> extern const struct nla_policy
>> ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_HEADER + 1];
>> +extern const struct nla_policy
>> +ethnl_eeprom_data_get_policy[ETHTOOL_A_EEPROM_DATA + 1];
>>
>>   int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);  int
>> ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
>> --
>> 2.18.2
