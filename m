Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB9133DC8A
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236951AbhCPS1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:27:03 -0400
Received: from mail-dm6nam12on2043.outbound.protection.outlook.com ([40.107.243.43]:38144
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236844AbhCPS03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 14:26:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UK6wK6VepiUT5x2/piQtViLlgyXSgrgExaIa7IsmtXCWOjmtFoMLCtcFojEe2npyugziPBg5wKpmBznjAJ9+LLEGSOziyf70yN4nAugMDShuJBvorektvBvsmUN6gC9LctgIQNE52Q6DbkN9eifxftx3QLToBRS1C0eNtXTr20ujeYuLb9vENjoYatStjdr0EJX/11B41hQYQg6ttrAKm9b8L7hJVm/yJB+hs0GclyVzefAQ+6eME9+1Dp4lLujtpNRzJdJqGqqqmw4TEwLRcQs07mkErzRk1dhjV8CBBwuwF3DAmGEogkK+ra31ErLOIQYc9VhxY+y3QnTCHwIApg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Syb178IhQS7hNRV54Zmqh294ozPkMsihF0N/KJcgjlA=;
 b=H/1YJXChAWAw9Uat2GCIvcfO1E1Fj0scPabd40bW1FLyB8uE4gx2eALU2A8AK8sEdDxaZBbRLpKfttI85YavqveI8ZXaDd1ivWLh3t0/5r2EjfaKnI21Wuxf1monEXAX+ygVdGq6HUUTqam1hNIyIAEVqqpD1u220/h9p0/BdBdFLCKb37ST1b0SN1EYkl78ByVOI0iUCkkxSQ3YfxTRe19TuTbGRV9s2UPU4MqeDVdEGLq0T4WfZx+8qjBOSFIQT4m9CLg+tf6jrI3xG2Blblz/aTZ+QdryUJiuMh4V2ffT1S1r6025LGx3d2C7IzYId9CQw8WjDOozr1vBZ/OSmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Syb178IhQS7hNRV54Zmqh294ozPkMsihF0N/KJcgjlA=;
 b=ORyjcQ48LEDLTUXqFx8vaIeD6X3bkb3dVRsApSfArsyoagLXJ7jc6WevRihlcs4H1XW1UBbYHxpOrKJPCl+4Zk4iOjIrW9dYS4qV/BelFE/3VAK1tCshS5BjcE/NpuRzhqTAeqrX39CdjTzie6pGMdmOdZNqNAVpu4Jpo+Rl1z7NqoF2J+a/qQunTplwxQRU2Pahgc1YgebwGmDKMxypXUdWRk55M+a3RrVplF3a9Aydgn3KInR7aBGwSZcVwFglmd9wZD9rXAzn0o5lz8TPjdybZ/d75QJNWEgNORLw1zNGVKhsoIKiYej3r8VgZamTpMnge1XpmVDD+ISdqwDfJQ==
Received: from MW4PR03CA0355.namprd03.prod.outlook.com (2603:10b6:303:dc::30)
 by BL0PR12MB2401.namprd12.prod.outlook.com (2603:10b6:207:4d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 16 Mar
 2021 18:26:27 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::10) by MW4PR03CA0355.outlook.office365.com
 (2603:10b6:303:dc::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Tue, 16 Mar 2021 18:26:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 16 Mar 2021 18:26:26 +0000
Received: from [172.27.0.183] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar
 2021 18:26:20 +0000
Subject: Re: [RFC PATCH V3 net-next 5/5] ethtool: Add fallback to
 get_module_eeprom from netlink command
To:     Don Bollinger <don@thebollingers.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Andrew Lunn' <andrew@lunn.ch>,
        'Adrian Pop' <pop.adrian61@gmail.com>,
        'Michal Kubecek' <mkubecek@suse.cz>, <netdev@vger.kernel.org>
CC:     'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com>
 <1615828363-464-6-git-send-email-moshe@nvidia.com>
 <002301d719ea$e6aae4c0$b400ae40$@thebollingers.org>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <e6ac4ae9-a695-c205-851a-0d54842be349@nvidia.com>
Date:   Tue, 16 Mar 2021 20:26:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <002301d719ea$e6aae4c0$b400ae40$@thebollingers.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f15fac07-6c76-4095-b706-08d8e8a9030a
X-MS-TrafficTypeDiagnostic: BL0PR12MB2401:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2401FC19C141A84D4D7F330AD46B9@BL0PR12MB2401.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rzOoDfUNx+Yk0dYET7URZVWl/bDju2INHVnHhnuK2M3miUMyLEIo6f5/WFA1qOqqicPvsFq4igNUF8x/llOms97zxwoMWDRZcHvbf50MhuOI5cXOqeaYOYiimaAqXpThzhMHK9NSHcu9IF4OfrgHohWon/jr+s9ynKWvlIVlIiUbT+/H3q3PNRRWFaGFfm08480ZfttH0FYhQW2dFuxvD0T8gXA4Kca9d1HJPSa3KBe0rTJlZgq47cSrMcm33I9vmfwYqU3j7wp+MuTjDFPBgzMRgy0VoxTDjG1gaYIv8Qs6MyRbkWfvWH7Az14NTaDeeH1n/arPaGF2aYJVafla6KtT4BVpsOLXj+Sr5QYKvJEuObmwggO4GsUBTntBP0RDrBcOzJ6+5NmiBEpdUaEPtlXQve1z7sqRU+09gYUzFWMHM6LSKyRs4lLOmwTf6jIJJ8rjGSF4uzfOmqhAxAI3AnHPq8cWoSRbQIzG2LN1h3eY9VMslXmic3GQ+b4xNzUYRXb4g7HhIKVLkESJJTTei7OifGOn6M3+2ARU8vyvi/k6YWFk7m7Uuo60WPFM1ic0NY/gpSUuoGxPETiXIn9ONQSaCdPxN6GMndjIlXr5vF2bD/3eP0jp8YJ07A21xJWfU4/C7VPwkxGxM0MJ9v+wfJQONnONknrNunGTnx1TWC6bawXX8Vd3zDzads+i5smrYmlF9FCgUwSUZBwqQhRqpJHX/xx2sLFGEMbiM6mDP9M=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(346002)(46966006)(36840700001)(53546011)(82740400003)(356005)(478600001)(7636003)(70206006)(70586007)(16526019)(26005)(31696002)(186003)(2906002)(6666004)(336012)(4326008)(8676002)(86362001)(16576012)(5660300002)(316002)(36906005)(8936002)(110136005)(426003)(31686004)(2616005)(47076005)(36756003)(36860700001)(83380400001)(82310400003)(107886003)(34020700004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 18:26:26.9966
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f15fac07-6c76-4095-b706-08d8e8a9030a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2401
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/16/2021 12:31 AM, Don Bollinger wrote:
>
> On Mon, 15 Mar 2021 10:12:39 +0700 Moshe Shemesh wrote:
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
>>   net/ethtool/eeprom.c | 75
>> +++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 74 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c index
>> e110336dc231..33ba9ecc36cb 100644
>> --- a/net/ethtool/eeprom.c
>> +++ b/net/ethtool/eeprom.c
>> @@ -25,6 +25,79 @@ struct eeprom_data_reply_data {  #define
>> EEPROM_DATA_REPDATA(__reply_base) \
>>        container_of(__reply_base, struct eeprom_data_reply_data, base)
>>
>> +static int fallback_set_params(struct eeprom_data_req_info *request,
>> +                            struct ethtool_modinfo *modinfo,
>> +                            struct ethtool_eeprom *eeprom) {
>> +     u32 offset = request->offset;
>> +     u32 length = request->length;
>> +
>> +     if (request->page) {
>> +             if (offset < 128 || offset + length >
>> ETH_MODULE_EEPROM_PAGE_LEN)
>> +                     return -EINVAL;
>> +             offset = request->page * 128 + offset;
>> +     }
>> +
>> +     if (modinfo->type == ETH_MODULE_SFF_8079 &&
>> +         request->i2c_address == 0x51)
>> +             offset += ETH_MODULE_EEPROM_PAGE_LEN;
>> +
>> +     if (!length)
>> +             length = modinfo->eeprom_len;
> Need to move this check up 11 lines, before the 'if (request->page)...'
> stanza.  You need to be doing that check against the final length.
> Otherwise you could have a request that includes a page, and a length of 0,
> which becomes a length of modinfo->eeprom_len.


Right, thanks.

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
>> +          !dev->ethtool_ops->get_module_eeprom) || request->bank) {
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
>> @@ -36,7 +109,7 @@ static int eeprom_data_prepare_data(const struct
>> ethnl_req_info *req_base,
>>        int ret;
>>
>>        if (!dev->ethtool_ops->get_module_eeprom_data_by_page)
>> -             return -EOPNOTSUPP;
>> +             return eeprom_data_fallback(request, reply, info);
>>
>>        page_data.offset = request->offset;
>>        page_data.length = request->length;
>> --
>> 2.26.2
