Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F0433DC85
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236874AbhCPSYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:24:23 -0400
Received: from mail-mw2nam08on2047.outbound.protection.outlook.com ([40.107.101.47]:32736
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236839AbhCPSYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 14:24:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBDdPNXaoR+vmhxARcJ8zwPK9mTvSXkIqA8tLV1kJo0b1vMP3yd4CE2joGNLYE2rovMIIRC0QpC4JV8mlG/xAYGm+o9kNu8YsxieX9GE8fem05OxIL2+wvlc2AYCp7BCAITvnmQMRQ4SEO0o5IqsWBCYR27M70k8uSaqUpSMslgp3PZaDuUAine96giRo46yDoxmeZLWV7VZ+DlCihyUhrWetQhCdBq59neWzSl//cu8kxEaRvxDOGcbj0+di1ZUn5OvD7hpU9ZFJ6xRY+M4otVLJL2uFtJN3//ysYEqH4hlsKbMSq0XH6WV/cV/hMKBTX0sW3q0ykaKx5qan6VRcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AC5GaudU2dctCxLcvc41xB6ESX1s/b6KgtMXFXfvtLM=;
 b=N32rioZnUZICNziw7a1lpVTSgN4/AoDsDs47A7NI1ehUJPzn+jLPXNl/Ca8e8LBhPbm64OQaTG27IPB39PyoGyK5NWxY/U4FsSYNpsJvkA5yaIjwbax+ECDOM6TTwxeUZrbqvB+by3oLA0CK/4BLqfgwceKl/2ndyX13VOiNxIpOSJVK9vQTmoEqczscdhBs1QZIPrM5YbaFj+FDTj2m4RkosIPJ5QTXTtVE8EreP/S4nOhpCmscfZ6H1MSDq7ddbOHWlzBY/kv94gaFDR4Lhv5qrhvaKpEUT5kyKbLhx+ekciYCHLaUMj4DdsmEujMwymBvRY04btuEF0mZMIAtbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AC5GaudU2dctCxLcvc41xB6ESX1s/b6KgtMXFXfvtLM=;
 b=l3kooVJxbrw9Q0GKq2HAkQGcOUJnGgzXMx+TBP0YgRqMJZQODdMwZLcx+mDjeN/pi+DfjJrOSsu7PrERC2tbu6+2uumxFIKg4Z4jGU+sMWAMdROyzPD3CmJF8IhidDSjmAw0PiXkR2EXfhhaXzovyqp+lRR3z7I08hTY0uWJG2DAcjYX8CwSoPbP3vXvACNRvOzz32OdrQRFYzAtsHJHSOTnitfESWYSA1c5FE2zBEem8gn6hdsJymPm54xmUPf60V8oDh0ZtZRJlv7Jbe8hRml0KZqkFhcNsVM8nz8RmEJoGt2WR9fx4bL5EmniJOZ9iKZiKHmlyzBE9gyf0GFKXA==
Received: from DM5PR13CA0049.namprd13.prod.outlook.com (2603:10b6:3:117::11)
 by BYAPR12MB2952.namprd12.prod.outlook.com (2603:10b6:a03:13b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 18:24:06 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:117:cafe::8a) by DM5PR13CA0049.outlook.office365.com
 (2603:10b6:3:117::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend
 Transport; Tue, 16 Mar 2021 18:24:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 16 Mar 2021 18:24:06 +0000
Received: from [172.27.0.183] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar
 2021 18:24:03 +0000
Subject: Re: [RFC PATCH V3 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
To:     Don Bollinger <don@thebollingers.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Andrew Lunn' <andrew@lunn.ch>,
        'Adrian Pop' <pop.adrian61@gmail.com>,
        'Michal Kubecek' <mkubecek@suse.cz>, <netdev@vger.kernel.org>
CC:     'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com>
 <1615828363-464-2-git-send-email-moshe@nvidia.com>
 <002201d719ea$e60d9350$b228b9f0$@thebollingers.org>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <0a8beb69-972b-3b00-a67e-0e97f9fda8ea@nvidia.com>
Date:   Tue, 16 Mar 2021 20:23:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <002201d719ea$e60d9350$b228b9f0$@thebollingers.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21a34e82-46d2-4143-cac7-08d8e8a8af34
X-MS-TrafficTypeDiagnostic: BYAPR12MB2952:
X-Microsoft-Antispam-PRVS: <BYAPR12MB295269418DA735F906FB87F5D46B9@BYAPR12MB2952.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pYSDj4N4jcaMwCaVk20DbZrTcFGg2mhDb/4InE/wec+gxQCSzUYRj4pLcTU+HRNzPpZe55lnikW4WX6z8CVgvV3bA3qOpi1U7/cVWpu57gb9co4cLQ+/k03w7pmY7+NZgdt0CFa5blPDh1UULyUV5ILNYUE0jjb2Im+wuVUNaQAh7JDSsrGGPkkMlbhbAnyEfDydIYkvnNvGXjgORNbd7DJJmIly1naODjzvrFicPzdJ6/GOffcRA3wN9Wt4J67HyvH4mz/paTPzo57mae4UYSdUym4vD4hkN5XCUxnq64y5UOebv16+PLqrxRJi3N5bJIbdMwqFyLfL0XxVXCSkt3yCe/+8LhEFQBDciDDmqV920OKEJL01afgnkk4lct77D5VUgnYHvJGPAG0DD2DKvBy7WVPI87EYU6G+2cVppRXWvAsGA7z9+NickOMfQQ+mv4i8NaoH3HryokATR7n707sV2NT/+ta2BxDZDoVp3qeagAzIebDlhC7BE6L4mzqRHray86iE1rbeLtkjsMl+9ikFHKGmxaShc0JmX68Y2tq86TRkHCErO6U1C6P6mHW7PYmd6iD2iWUlaBjj0oIF40907DJq1dcM5Aq+QMPoW5RyrQ23XNoSBpmQAdsAun4KR87cdhx1S1ECJjibBkJE+viTGLmBMhZo0Q3yfxKM0UJVmm/hODxhGRsoMer5L05Q7ciPZUhZNrX1kC4A1jen7Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(36840700001)(46966006)(47076005)(36860700001)(82740400003)(4326008)(34020700004)(70206006)(70586007)(16576012)(8676002)(5660300002)(30864003)(16526019)(316002)(2616005)(478600001)(107886003)(110136005)(186003)(336012)(36906005)(426003)(53546011)(8936002)(26005)(36756003)(7636003)(6666004)(2906002)(83380400001)(356005)(86362001)(31696002)(31686004)(82310400003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 18:24:06.2758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21a34e82-46d2-4143-cac7-08d8e8a8af34
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2952
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/16/2021 12:31 AM, Don Bollinger wrote:
> On Mon, 15 Mar 2021 10:12:39 +0700 Moshe Shemesh wrote:
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
>>   Documentation/networking/ethtool-netlink.rst |  34 ++++-
>>   include/linux/ethtool.h                      |   8 +-
>>   include/uapi/linux/ethtool.h                 |  25 +++
>>   include/uapi/linux/ethtool_netlink.h         |  19 +++
>>   net/ethtool/Makefile                         |   2 +-
>>   net/ethtool/eeprom.c                         | 153 +++++++++++++++++++
>>   net/ethtool/netlink.c                        |  10 ++
>>   net/ethtool/netlink.h                        |   2 +
>>   8 files changed, 249 insertions(+), 4 deletions(-)  create mode 100644
>> net/ethtool/eeprom.c
>>
>> diff --git a/Documentation/networking/ethtool-netlink.rst
>> b/Documentation/networking/ethtool-netlink.rst
>> index 05073482db05..25846b97632a 100644
>> --- a/Documentation/networking/ethtool-netlink.rst
>> +++ b/Documentation/networking/ethtool-netlink.rst
>> @@ -1280,6 +1280,36 @@ Kernel response contents:
>>   For UDP tunnel table empty ``ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES``
>> indicates that  the table contains static entries, hard-coded by the NIC.
>>
>> +EEPROM_DATA
>> +===========
>> +
>> +Fetch module EEPROM data dump.
>> +
>> +Request contents:
>> +
>> +  =====================================  ======
>> ==========================
>> +  ``ETHTOOL_A_EEPROM_DATA_HEADER``       nested  request header
>> +  ``ETHTOOL_A_EEPROM_DATA_OFFSET``       u32     offset within a page
>> +  ``ETHTOOL_A_EEPROM_DATA_LENGTH``       u32     amount of bytes to read
>> +  ``ETHTOOL_A_EEPROM_DATA_PAGE``         u8      page number
>> +  ``ETHTOOL_A_EEPROM_DATA_BANK``         u8      bank number
>> +  ``ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS``  u8      page I2C address
>> +  =====================================  ======
>> + ==========================
>> +
>> +Kernel response contents:
>> +
>> +
> +---------------------------------------------+--------+--------------------
> -+
>> + | ``ETHTOOL_A_EEPROM_DATA_HEADER``            | nested | reply header
>> |
>> +
> +---------------------------------------------+--------+--------------------
> -+
>> + | ``ETHTOOL_A_EEPROM_DATA_LENGTH``            | u32    | amount of bytes
>> read|
>> +
> +---------------------------------------------+--------+--------------------
> -+
>> + | ``ETHTOOL_A_EEPROM_DATA``                   | nested | array of bytes
> from |
>> + |                                             |        | module EEPROM
> |
>> +
> +---------------------------------------------+--------+--------------------
> -+
>> +
>> +``ETHTOOL_A_EEPROM_DATA`` has an attribute length equal to the amount
>> +of bytes driver actually read.
>> +
>>   Request translation
>>   ===================
>>
>> @@ -1357,8 +1387,8 @@ are netlink only.
>>     ``ETHTOOL_GET_DUMP_FLAG``           n/a
>>     ``ETHTOOL_GET_DUMP_DATA``           n/a
>>     ``ETHTOOL_GET_TS_INFO``             ``ETHTOOL_MSG_TSINFO_GET``
>> -  ``ETHTOOL_GMODULEINFO``             n/a
>> -  ``ETHTOOL_GMODULEEEPROM``           n/a
>> +  ``ETHTOOL_GMODULEINFO``
>> ``ETHTOOL_MSG_MODULE_EEPROM_GET``
>> +  ``ETHTOOL_GMODULEEEPROM``
>> ``ETHTOOL_MSG_MODULE_EEPROM_GET``
>>     ``ETHTOOL_GEEE``                    ``ETHTOOL_MSG_EEE_GET``
>>     ``ETHTOOL_SEEE``                    ``ETHTOOL_MSG_EEE_SET``
>>     ``ETHTOOL_GRSSH``                   n/a
>> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h index
>> ec4cd3921c67..9551005b350a 100644
>> --- a/include/linux/ethtool.h
>> +++ b/include/linux/ethtool.h
>> @@ -81,6 +81,7 @@ enum {
>>   #define ETH_RSS_HASH_NO_CHANGE       0
>>
>>   struct net_device;
>> +struct netlink_ext_ack;
>>
>>   /* Some generic methods drivers may use in their ethtool_ops */
>>   u32 ethtool_op_get_link(struct net_device *dev); @@ -410,6 +411,9 @@
>> struct ethtool_pause_stats {
>>    * @get_ethtool_phy_stats: Return extended statistics about the PHY
>> device.
>>    *   This is only useful if the device maintains PHY statistics and
>>    *   cannot use the standard PHY library helpers.
>> + * @get_module_eeprom_data_by_page: Get a region of plug-in module
>> EEPROM data
>> + *   from specified page. Returns a negative error code or the amount of
>> + *   bytes read.
>>    *
>>    * All operations are optional (i.e. the function pointer may be set
>>    * to %NULL) and callers must take this into account.  Callers must @@
> -515,6
>> +519,9 @@ struct ethtool_ops {
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
>>   int ethtool_check_ops(const struct ethtool_ops *ops); @@ -538,7 +545,6
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
>> cde753bb2093..b3e92db3ad37 100644
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
>> + * @length: Number of bytes to read.
>> + * @page: Page number to read from.
>> + * @bank: Page bank number to read from, if applicable by EEPROM spec.
>> + * @i2c_address: I2C address of a page. Value less than 0x7f expected.
>> Most
>> + *   EEPROMs use 0x50 or 0x51.
>> + * @data: Pointer to buffer with EEPROM data of @length size.
>> + *
>> + * This can be used to manage pages during EEPROM dump in ethtool and
>> +pass
>> + * required information to the driver.
>> + */
>> +struct ethtool_eeprom_data {
>> +     __u32   offset;
>> +     __u32   length;
>> +     __u8    page;
>> +     __u8    bank;
>> +     __u8    i2c_address;
>> +     __u8    *data;
>> +};
>> +
>>   /**
>>    * struct ethtool_eee - Energy Efficient Ethernet information
>>    * @cmd: ETHTOOL_{G,S}EEE
>> @@ -1865,6 +1887,9 @@ static inline int ethtool_validate_duplex(__u8
>> duplex)
>>   #define ETH_MODULE_SFF_8636_MAX_LEN     640
>>   #define ETH_MODULE_SFF_8436_MAX_LEN     640
>>
>> +#define ETH_MODULE_EEPROM_PAGE_LEN   256
>> +#define ETH_MODULE_MAX_I2C_ADDRESS   0x7f
>> +
>>   /* Reset flags */
>>   /* The reset() operation must clear the flags for the components which
>>    * were actually reset.  On successful return, the flags indicate the
> diff --git
>> a/include/uapi/linux/ethtool_netlink.h
>> b/include/uapi/linux/ethtool_netlink.h
>> index a286635ac9b8..e1b1b962f3da 100644
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
>> +     ETHTOOL_A_EEPROM_DATA_HEADER,                   /* nest -
>> _A_HEADER_* */
>> +
>> +     ETHTOOL_A_EEPROM_DATA_OFFSET,                   /* u32 */
>> +     ETHTOOL_A_EEPROM_DATA_LENGTH,                   /* u32 */
>> +     ETHTOOL_A_EEPROM_DATA_PAGE,                     /* u8 */
>> +     ETHTOOL_A_EEPROM_DATA_BANK,                     /* u8 */
>> +     ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS,              /* u8 */
>> +     ETHTOOL_A_EEPROM_DATA,                          /* nested */
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
>> 100644 index 000000000000..e110336dc231
>> --- /dev/null
>> +++ b/net/ethtool/eeprom.c
>> @@ -0,0 +1,153 @@
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
>> +     u8                      page;
>> +     u8                      bank;
>> +     u8                      i2c_address;
>> +};
>> +
>> +struct eeprom_data_reply_data {
>> +     struct ethnl_reply_data base;
>> +     u32                     length;
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
>> +     int ret;
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
>> +     ret = ethnl_ops_begin(dev);
>> +     if (ret)
>> +             goto err_free;
>> +
>> +     ret = dev->ethtool_ops->get_module_eeprom_data_by_page(dev,
>> &page_data,
>> +
> info->extack);
>> +     if (ret < 0)
>> +             goto err_ops;
>> +
>> +     reply->length = ret;
>> +     reply->data = page_data.data;
>> +
>> +     ethnl_ops_complete(dev);
>> +     return 0;
>> +
>> +err_ops:
>> +     ethnl_ops_complete(dev);
>> +err_free:
>> +     kfree(page_data.data);
>> +     return ret;
>> +}
>> +
>> +static int eeprom_data_parse_request(struct ethnl_req_info *req_info,
>> struct nlattr **tb,
>> +                                  struct netlink_ext_ack *extack) {
>> +     struct eeprom_data_req_info *request =
>> EEPROM_DATA_REQINFO(req_info);
>> +     struct net_device *dev = req_info->dev;
>> +
>> +     if (!tb[ETHTOOL_A_EEPROM_DATA_OFFSET] ||
>> +         !tb[ETHTOOL_A_EEPROM_DATA_LENGTH] ||
>> +         !tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS])
>> +             return -EINVAL;
> Suggestion:  Consider using i2c address 0x50 as a default if none is given.
> 0x50 is the first 256 bytes of SFP, and all of QSFP and CMIS EEPROM.  If
> there is a page given on an SFP device, then you know i2c address is 0x51.
> The only thing that REQUIRES 0x51 is legacy offset 256-511 on SFP.  Keep the
> i2c address, but make it optional for the non-standard devices that Andrew
> has mentioned, and for that one section of SFP data that requires it.  And
> document it for the user.
Agree, but thought to have that i2c address default set on userspace, so 
here we expect it.
> Note also, legacy does not have an i2c address, so passing this along allows
> the fallback to legacy to cover more cases.  (Legacy ethtool addresses this
> part of SFP as offset 256-511.)
>
>> +
>> +     request->i2c_address =
>> nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]);
>> +     if (request->i2c_address > ETH_MODULE_MAX_I2C_ADDRESS)
>> +             return -EINVAL;
>> +
>> +     request->offset =
>> nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_OFFSET]);
>> +     request->length =
>> nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_LENGTH]);
>> +     if (tb[ETHTOOL_A_EEPROM_DATA_PAGE] &&
>> +         dev->ethtool_ops->get_module_eeprom_data_by_page &&
>> +         request->offset + request->length >
>> ETH_MODULE_EEPROM_PAGE_LEN)
>> +             return -EINVAL;
> If a request exceeds the length of EEPROM (in legacy), we truncate it to
> EEPROM length.  I suggest if a request exceeds the length of the page (in
> the new KAPI), then we truncate at the end of the page.  Thus rather than
> 'return -EINVAL;' I suggest
>
>            request->length = ETH_MODULE_EEPROM_PAGE_LEN - request->offset;

I was not sure about that, isn't it better that once user specified page 
he has to be in the page boundary and let him know the command failed ?

>> +
>> +     if (tb[ETHTOOL_A_EEPROM_DATA_PAGE])
>> +             request->page =
>> nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_PAGE]);
>> +     if (tb[ETHTOOL_A_EEPROM_DATA_BANK])
>> +             request->bank =
>> nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_BANK]);
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
>> +     [ETHTOOL_A_EEPROM_DATA_PAGE]            = { .type = NLA_U8 },
>> +     [ETHTOOL_A_EEPROM_DATA_BANK]            = { .type = NLA_U8 },
>> +     [ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]     = { .type = NLA_U8 },
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
>> 2.26.2
