Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB8833DBCB
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239545AbhCPSAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:00:14 -0400
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:43617
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239553AbhCPR76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 13:59:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwFa9BoJBhRCZDCH6ZJh/DAxLHsPK3OoJAq1ND15S8FfAe/FX5AoFqO1n7tQrrr372cSxBLOTQYY3qXSWsJIKn3BiFYPu1AA/j2URBpW+Vq6JyucGzLTKL1mOYyzXj1yVoZtNavH4XATdZIrakl3R3xrQQw2Eb3G86cWYIqn/18Krd81OaasAsqjCLxNbi8mX+AMzomWNoUJJTZlVCsEuLti1+ektIQ5Je+51rE2lELXJLDepX8y211m8TgXMEg1mJcpTCQgIp2qI8kWEic1IV0c1kneeUwyrsS3yMqNNaMvdemOJTEEVJO9ASxywYCF1KRzW2/eNim8hN9spMwHdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7m1MuXRR0pEHjlQv1bjY7U8MrHzijadsbCpjLVwZYI=;
 b=hFVKXJCzd0ysWe5CrMpltVYfSxaA1Mxe/10rqa96yg8cTVXHMozaoVyCJO+gBTKqmp5CDqmFYrEg17nbcHQaje/KPGNEtbGLiQNVj40hcM3uuqoYET5NgQDDjpvHNzJQ/BJryvE6Vy2jzodW5UrCyO9DMhGY/YFMS/LMdpGnj4edLbRsuFCHcIAUOa2jz6akIzHfcZzpPTlZyyYF6VS/q9HryasPJYK4F8EX12Qn9EKjOW5X8gNyXRCEgDksM2jWH6K3YzTL1+eYneWdk//IrHaTrl/YKv0jN8QEs7ugIFmSPbgtww52/xMd8l5OhVQQ9k8Rrv/Y97UmFZTfx5f+cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7m1MuXRR0pEHjlQv1bjY7U8MrHzijadsbCpjLVwZYI=;
 b=S1WTiOn/MmykH3nsmmnVw9Zux8mc6FlOhGaz5TcToRG4+AqyyORBin7LmuaFjjBFAvceWPnw3AVNzqcbzphecZHB6kMk69QPoFW3Np2tfno93PCQqWAOjwDX39DvAQh+LrwFHEmEDFcEqOzOlDkH8/37cpxBTcNQrVeiWdMawfyMaKpk0gFb1x89jVit6jd0xil8WYRu5wlEGYCII+Vf5fnDGL17a03Uo6yFzE8+3Bj2nPdJMurXEfsgqTMehDt5nEh5QT/O39RAgbd3MU1gxDbgzlIhqZcQNeUgTEkAX9kjC/6zOJGepM1at/3B4lRZCIw8MYEtNDRayD1elyWbMw==
Received: from BN1PR14CA0005.namprd14.prod.outlook.com (2603:10b6:408:e3::10)
 by DM5PR1201MB2537.namprd12.prod.outlook.com (2603:10b6:3:eb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 17:59:57 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::8b) by BN1PR14CA0005.outlook.office365.com
 (2603:10b6:408:e3::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Tue, 16 Mar 2021 17:59:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 17:59:56 +0000
Received: from [172.27.0.183] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar
 2021 17:59:34 +0000
Subject: Re: [RFC PATCH V3 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "Don Bollinger" <don@thebollingers.org>, <netdev@vger.kernel.org>,
        "Vladyslav Tarasiuk" <vladyslavt@nvidia.com>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com>
 <1615828363-464-2-git-send-email-moshe@nvidia.com>
 <20210315140116.0a1125c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <e41d2db8-8b75-7c1c-20d3-2368c4cf8276@nvidia.com>
Date:   Tue, 16 Mar 2021 19:59:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210315140116.0a1125c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ccf5488-d1d9-46ec-939a-08d8e8a54f29
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2537:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2537C7200F5024BD372AC5B6D46B9@DM5PR1201MB2537.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RvGpehdQjrYDGBAGOciT9shNeUaDJFJoE6GVPnwdRQhCbbumBcXQgoJx+Z5fD07pQ4v98MWV2q29yiAYtb+V2kGHhpUoI2yjbqUqMRrEKo68XVKU0VCZpVmjXCLKup540s0z7x6V462LycvDy31anni4zJTz8jYxsJDIVMZ8dlvtMkegBt5jGCt1gs39fAJ5cW+eOBarTE/TX17CBh0px8nkauJdy6+nZHKAPnDvemzcTvQNINcxpg4ctFb+vsDYdNIgyH9M3Wbq6M+EG1HhpCFTfZh1nOoivy+Sut49YbMjRzhUkgWeU6uKlWmKd4aHl62wJQu+teuKBpUSWds3JpscxhhoqwGnKybu7nv+YXGca5zRGqEJWvqs5T+G54YGQ+JIt2juvWFrf2HHF0UxdylyTZZ2LTDVFz+/Z38MH7nq4W/uxVocAsUuUj08F8I8oaeNKQxOgxV0K5loNVsL+VyrxgzC4tLKf5mtKbmWIeI/spJMsrFCJOekuvDPzN9JX88khjFY5yugn+ipX2vVynaL3kujrLEuZx8QX/OQfOPhlOrLPcEFJCF5YDcPk7WcwjJtULe8rO0299hVQ9hWnU3T+p8PKXSTDfQexlnSR/3jVPbDZBglnPHeTpLsyrKa/jpOrNphOb8bsa0nj0j7sxQYp7JEat5afFiWI+lxt2VGt42BxlrAlnbbSrzMoC0ixeyjzrpuIG3e7Lo4nAh5shFfWseqTwzmlQo7xXdZRr8=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(46966006)(36840700001)(26005)(31686004)(53546011)(2906002)(107886003)(54906003)(316002)(47076005)(4326008)(336012)(8936002)(186003)(86362001)(34020700004)(478600001)(70206006)(6666004)(82310400003)(16526019)(70586007)(16576012)(82740400003)(5660300002)(36906005)(6916009)(356005)(2616005)(426003)(83380400001)(7636003)(36756003)(31696002)(8676002)(36860700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 17:59:56.6728
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ccf5488-d1d9-46ec-939a-08d8e8a54f29
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2537
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/15/2021 11:01 PM, Jakub Kicinski wrote:
>
> On Mon, 15 Mar 2021 19:12:39 +0200 Moshe Shemesh wrote:
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
> s/eeprom_data/eeprom/ everywhere?
>
> Otherwise some of your identifiers are over 30 characters long.


That can work part to one struct on the uapi file that can conflict with 
previous old KAPI struct, but we can figure it too.

Will fix.

>> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
>> index cde753bb2093..b3e92db3ad37 100644
>> --- a/include/uapi/linux/ethtool.h
>> +++ b/include/uapi/linux/ethtool.h
>> @@ -340,6 +340,28 @@ struct ethtool_eeprom {
>>        __u8    data[0];
>>   };
>>
>> +/**
>> + * struct ethtool_eeprom_data - EEPROM dump from specified page
>> + * @offset: Offset within the specified EEPROM page to begin read, in bytes.
>> + * @length: Number of bytes to read.
>> + * @page: Page number to read from.
>> + * @bank: Page bank number to read from, if applicable by EEPROM spec.
>> + * @i2c_address: I2C address of a page. Value less than 0x7f expected. Most
>> + *   EEPROMs use 0x50 or 0x51.
>> + * @data: Pointer to buffer with EEPROM data of @length size.
>> + *
>> + * This can be used to manage pages during EEPROM dump in ethtool and pass
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
> This structure does not have to be part of uAPI, right?
Right, will fix.
>> +#define ETH_MODULE_EEPROM_PAGE_LEN   256
>> +#define ETH_MODULE_MAX_I2C_ADDRESS   0x7f
> Not sure about these defines either.
Probably.
>> +static int eeprom_data_prepare_data(const struct ethnl_req_info *req_base,
>> +                                 struct ethnl_reply_data *reply_base,
>> +                                 struct genl_info *info)
>> +{
>> +     struct eeprom_data_reply_data *reply = EEPROM_DATA_REPDATA(reply_base);
>> +     struct eeprom_data_req_info *request = EEPROM_DATA_REQINFO(req_base);
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
> nit: new line?
Ack.
>> +     ret = ethnl_ops_begin(dev);
>> +     if (ret)
>> +             goto err_free;
>> +
>> +     ret = dev->ethtool_ops->get_module_eeprom_data_by_page(dev, &page_data,
>> +                                                            info->extack);
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
> Max value should be set in the netlink policy.
Ack
>> +     request->offset = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_OFFSET]);
>> +     request->length = nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_LENGTH]);
>> +     if (tb[ETHTOOL_A_EEPROM_DATA_PAGE] &&
>> +         dev->ethtool_ops->get_module_eeprom_data_by_page &&
> Why check dev->ethtool_ops->get_module_eeprom_data_by_page here?
Right, actually not needed here, thanks.
>> +         request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN)
>> +             return -EINVAL;
>> +
>> +     if (tb[ETHTOOL_A_EEPROM_DATA_PAGE])
>> +             request->page = nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_PAGE]);
>> +     if (tb[ETHTOOL_A_EEPROM_DATA_BANK])
>> +             request->bank = nla_get_u8(tb[ETHTOOL_A_EEPROM_DATA_BANK]);
>> +
>> +     return 0;
>> +}
>> +
>> +static int eeprom_data_reply_size(const struct ethnl_req_info *req_base,
>> +                               const struct ethnl_reply_data *reply_base)
>> +{
>> +     const struct eeprom_data_req_info *request = EEPROM_DATA_REQINFO(req_base);
>> +
>> +     return nla_total_size(sizeof(u32)) + /* _EEPROM_DATA_LENGTH */
>> +            nla_total_size(sizeof(u8) * request->length); /* _EEPROM_DATA */
>> +}
> Why report length? Is the netlink length of the DATA attribute not
> sufficient?
Right, thanks.
> Should we echo back offset in case driver wants to report re-aligned
> data?
The driver knows the requested offset and data has to be from that offset.
>> +const struct nla_policy ethnl_eeprom_data_get_policy[] = {
>> +     [ETHTOOL_A_EEPROM_DATA_HEADER]          = NLA_POLICY_NESTED(ethnl_header_policy),
>> +     [ETHTOOL_A_EEPROM_DATA_OFFSET]          = { .type = NLA_U32 },
>> +     [ETHTOOL_A_EEPROM_DATA_LENGTH]          = { .type = NLA_U32 },
>> +     [ETHTOOL_A_EEPROM_DATA_PAGE]            = { .type = NLA_U8 },
>> +     [ETHTOOL_A_EEPROM_DATA_BANK]            = { .type = NLA_U8 },
>> +     [ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS]     = { .type = NLA_U8 },
>> +     [ETHTOOL_A_EEPROM_DATA]                 = { .type = NLA_BINARY },
> This is a policy for inputs, DATA should not be allowed on input, right?
Right, thanks.
