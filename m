Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6333407CF
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhCRO0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:26:17 -0400
Received: from mail-mw2nam08on2085.outbound.protection.outlook.com ([40.107.101.85]:32544
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231430AbhCROZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 10:25:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DsA7YagUofhYtYfZQKUwru83ScgwhOsO9KsJCTJqJK0EgH0kKNlfJvDDUyQUgs8aHnjgxcHpAwIzxNkx3oPLuoSHAbpH+Xp2rHYyxMSyg1YF9jC+dUXgmv/Mea0ucWBxxGtM4Bhly/V6/+2SjAtESqkA8h8Kz/BUmmt5/u9fXyd/5M+6OroH0iFe16gVCt/cqRwg6s/aWXYRVv8gF3Q2hj/+Pya68FOXc8CDFfrFC5DhWPuLpGx5dcKCmYqlh0mxZ+Ta2CNf7FyTmj4Wlu7BfGCeZf7o7As+eJbtYuG/OfAhiok1kovU50CLnkrXHmqeEebv7vZVeXm5PlgvvSPlwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXSp2LQLASGzl3+dwsz6niTya8JASWiv/3kMDEjXJlo=;
 b=XxkgvcAGhPlawLh2P1vxnXQ/Og0B3aK/Ac10nVXk6teFeiPzC7B3E5bTKUOg+PXn5WTW1Plk6XNJX5mPfhUwZoLVG54veL59Et1n3bV/gK+uTJcQQ8dI1dxOEXrpzALLwg/jHk7kv5RvF7rYw4XEX5rkX2s0YBi0ydbrgYB++eFmIz8HZzvhD81KSotpDE3CqMC59ouDrgZmsZxJJUXPMq88nWRfCqEpNOt4QcS2JjUwWNQX9nCauQ4zh2jPoRx6ALymCe7NQbS5R3c3npjNheKk688todcqgbMg5pLpfV5hFOOJg9d6+QrQ6u8rkSSikHwToTr23IjFpfeKeyeiaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXSp2LQLASGzl3+dwsz6niTya8JASWiv/3kMDEjXJlo=;
 b=kp/7adRNOD0WM9TeAW2JNU8vLBmjdiHvr4LtBv1nOtZU9VuAU8ARLRkxmJEPQFYbAy3Xg5Minix5EltrTVXmC+bKpEIF0tMBU2tmd78V3q+E1ztBK+qga/GS+TrwZ7RrpqYG54fKaSwARMU4+Lsxn/N3UPqLrZ1ywkDvfsf5x4EndFh1MkGrBg15Voj0xVlcs3wS7FBkHIL6shhvOWV9AT8vub0Tj0/7cYS6yKAPouCVuBxS+Z+DucfTHr/5AqqRvtcAseAsYhzjJo7xqaTtB/WSfeUUo8zlsOBLCYoOfGbgTPCrSN1GfZXllJ86RtDCZe/0RHYSxQmo86LMciyHuw==
Received: from MWHPR22CA0058.namprd22.prod.outlook.com (2603:10b6:300:12a::20)
 by BL0PR12MB4897.namprd12.prod.outlook.com (2603:10b6:208:17e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 18 Mar
 2021 14:25:40 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12a:cafe::41) by MWHPR22CA0058.outlook.office365.com
 (2603:10b6:300:12a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Thu, 18 Mar 2021 14:25:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.22 via Frontend Transport; Thu, 18 Mar 2021 14:25:39 +0000
Received: from [172.27.0.183] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 14:25:36 +0000
Subject: Re: [RFC PATCH V3 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "Don Bollinger" <don@thebollingers.org>, <netdev@vger.kernel.org>,
        "Vladyslav Tarasiuk" <vladyslavt@nvidia.com>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com>
 <1615828363-464-2-git-send-email-moshe@nvidia.com> <YFNPhvelhxg4+5Cl@lunn.ch>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <3d8b9b2b-25e2-3812-2daf-09f1c5088eb0@nvidia.com>
Date:   Thu, 18 Mar 2021 16:25:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YFNPhvelhxg4+5Cl@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f30747e8-15e4-4a38-e889-08d8ea19b47a
X-MS-TrafficTypeDiagnostic: BL0PR12MB4897:
X-Microsoft-Antispam-PRVS: <BL0PR12MB48978B3FF3CB30DCC41BDDF3D4699@BL0PR12MB4897.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G5uZXg/EKJHQGEcR1o4RcXF5S7V7zL/Gta/ALdom7EcOecKWma7hQD4Vfa5GI9yO369Om4GM3d6xSeP+EDds28va9oHSIfdz4EmezAA6Wiz4R2LcaYkISh3MYqOdXgRawBdHwDlVyYi32hboaVY2UXRezt5/117QdX7JFW61sncbFLLnsRFw7zWUggL1hlmVRQuemVdPcav5anpxKc+d4MgIAxu94wfNGI/jbppJyb78NSJWupdwvRqLpGofn06fQlDQWmHDKeq43Pm+WN+aDKzovWPHl7PGQxdAZgh2h20ejp45qofogeoGpfk8vp9tAdbJalyMYhD+cUry2umwjxyf/jAZeDRHuRs1colmMCvtaL65BCRUk/WsA7H8tE79VZBPDc+Ovjoa+bJnqSVDOaZLNfGif4SzTYKtPBq5tCHhSGn1qI89X+ABKxh+dLzPPq/UO929hKtXCIfVMCj0WCvjj/vuzRop3rPZi8KKH2Mpw+QXliQhEDuguF+fvwSpGX8N4MEkZUpWj5QmkcZ/ncjlWagO2uhBi96WeUdxwQEJMQkbi6BfPcah18upU0wSW/z7tL1LapAzVyStpApxx0L2EiTuK6fCVWG1p/gvx5WhYxiX+trkcTKT4QKVtUm1ZR9RHZN7I+5FFpCrDHoDnVdSUNJ38CCf+TJRKoz7ufF+6b3QgnDtbzt1Jum4VL4IcGVHN0Jlqaw5ixG7a30qiNyGF47okYbmFFkTyaS9NA8=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(46966006)(36840700001)(2906002)(7636003)(54906003)(36860700001)(16526019)(36756003)(82740400003)(426003)(4326008)(83380400001)(16576012)(107886003)(26005)(356005)(316002)(70586007)(6916009)(82310400003)(53546011)(31686004)(478600001)(336012)(70206006)(31696002)(47076005)(2616005)(34020700004)(6666004)(8676002)(186003)(8936002)(86362001)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2021 14:25:39.4961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f30747e8-15e4-4a38-e889-08d8ea19b47a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4897
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/18/2021 3:03 PM, Andrew Lunn wrote:
>
> On Mon, Mar 15, 2021 at 07:12:39PM +0200, Moshe Shemesh wrote:
>> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
>>
>> Define get_module_eeprom_data_by_page() ethtool callback and implement
>> netlink infrastructure.
>>
>> get_module_eeprom_data_by_page() allows network drivers to dump a part
>> of module's EEPROM specified by page and bank numbers along with offset
>> and length. It is effectively a netlink replacement for
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
>>   8 files changed, 249 insertions(+), 4 deletions(-)
>>   create mode 100644 net/ethtool/eeprom.c
>>
>> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
>> index 05073482db05..25846b97632a 100644
>> --- a/Documentation/networking/ethtool-netlink.rst
>> +++ b/Documentation/networking/ethtool-netlink.rst
>> @@ -1280,6 +1280,36 @@ Kernel response contents:
>>   For UDP tunnel table empty ``ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES`` indicates that
>>   the table contains static entries, hard-coded by the NIC.
>>
>> +EEPROM_DATA
>> +===========
>> +
>> +Fetch module EEPROM data dump.
>> +
>> +Request contents:
>> +
>> +  =====================================  ======  ==========================
>> +  ``ETHTOOL_A_EEPROM_DATA_HEADER``       nested  request header
>> +  ``ETHTOOL_A_EEPROM_DATA_OFFSET``       u32     offset within a page
>> +  ``ETHTOOL_A_EEPROM_DATA_LENGTH``       u32     amount of bytes to read
> I wonder if offset and length should be u8. At most, we should only be
> returning a 1/2 page, so 128 bytes. We don't need a u32.


That's right when page is given, but user may have commands that used to 
work on the ioctl KAPI with offset higher than one page.

>>   Request translation
>>   ===================
>>
>> @@ -1357,8 +1387,8 @@ are netlink only.
>>     ``ETHTOOL_GET_DUMP_FLAG``           n/a
>>     ``ETHTOOL_GET_DUMP_DATA``           n/a
>>     ``ETHTOOL_GET_TS_INFO``             ``ETHTOOL_MSG_TSINFO_GET``
>> -  ``ETHTOOL_GMODULEINFO``             n/a
>> -  ``ETHTOOL_GMODULEEEPROM``           n/a
>> +  ``ETHTOOL_GMODULEINFO``             ``ETHTOOL_MSG_MODULE_EEPROM_GET``
>> +  ``ETHTOOL_GMODULEEEPROM``           ``ETHTOOL_MSG_MODULE_EEPROM_GET``
>>     ``ETHTOOL_GEEE``                    ``ETHTOOL_MSG_EEE_GET``
>>     ``ETHTOOL_SEEE``                    ``ETHTOOL_MSG_EEE_SET``
>>     ``ETHTOOL_GRSSH``                   n/a
> We should check with Michal about this. It is not a direct replacement
> of the old IOCTL API, it is new API. He may want it documented
> differently.
Michal, please comment on where it should be.
>> +static int eeprom_data_parse_request(struct ethnl_req_info *req_info, struct nlattr **tb,
>> +                                  struct netlink_ext_ack *extack)
>> +{
>> +     struct eeprom_data_req_info *request = EEPROM_DATA_REQINFO(req_info);
>> +     struct net_device *dev = req_info->dev;
>> +
>> +     if (!tb[ETHTOOL_A_EEPROM_DATA_OFFSET] ||
>> +         !tb[ETHTOOL_A_EEPROM_DATA_LENGTH] ||
>> +         !tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS])
>> +             return -EINVAL;
>> +
>> +     request->i2c_address = nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]);
>> +     if (request->i2c_address > ETH_MODULE_MAX_I2C_ADDRESS)
>> +             return -EINVAL;
>> +
>> +     request->offset = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_OFFSET]);
>> +     request->length = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_LENGTH]);
>> +     if (tb[ETHTOOL_A_EEPROM_DATA_PAGE] &&
>> +         dev->ethtool_ops->get_module_eeprom_data_by_page &&
>> +         request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN)
>> +             return -EINVAL;
> You need to watch out for overflows here. 0xfffffff0 + 0x20 is less
> than ETH_MODULE_EEPROM_PAGE_LEN when it wraps around, but will cause
> bad things to happen.
Ack.
>        Andrew
