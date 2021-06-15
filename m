Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D893A8622
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 18:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhFOQPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 12:15:05 -0400
Received: from mail-bn8nam12on2048.outbound.protection.outlook.com ([40.107.237.48]:6401
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229601AbhFOQPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 12:15:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHf972tsmqKN7DxgzoQ7GnS3qPyVOwi5D6Zn5te7yj/8zHEYwJ7hz+4/o9vFquX7adL2zHA41QiTOkDVIgBRBMMzniS6DSFrOrM5aEv55hRey9yGgqLV4Kyh8hY0BQB+0evGHkssYYumcJ2VFSEDeG/nxgUaDilLB6KpWmgp0xd84g2u3Oiks6LsTN3C53vhb8fYJRW66FW+uMg+xNXLhKzUzAJT8rneXJSPh6HegQAFi1mUmme4I6cT/385e151zfRvgES/5VBhdBFwJW+MLFbt9GJLhL7oRb7jVF7a60kWaw6UlpOZv4zeLsJsHwpECFBmEMXTifAYZwe8BE8GKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCOVu+iOLVm02a1/HofZ6ADDtNY+Gx2FKDk4gHLRwg8=;
 b=jqNrXcqs2cqrhPupfO52+oSielYE6CD0xfr7eqxpEPAyTbiICUby+fI843KRyii6Cv7O5X5mmE2YBfOVyzsSmmMtEn5S2iXI46FwL3wYSCk/xhIJzB06tE0GTPQgV6GjIw6AzL90fsOMEKGNRxAaf1kaCxeuFs03rsUtpIBaY269jcM+FjtvBtdgewqgqFcfTgbz4zKFZy75Sx8GSWEv+N2Y5MOqTXgORCjGMrbCGza01JkQr37ycT8lfP110+Mekqzs9/pd23gFA7EYw4l4MhVEbpbfIh6TlgZRaXyBMmeQeikVchfgVH74LKnpbirB2wA0EwJ2kXpRETPNn40wPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCOVu+iOLVm02a1/HofZ6ADDtNY+Gx2FKDk4gHLRwg8=;
 b=hSGJ6SSaZpt1iviigpfoDtcE47jpPtCKMvASgfBFdjfJgK7KvLth0EsouDr/ozrEnQ8Mdmbmz5SSlvdSTAoB3NcbGT8osi9KnulRTzg/Rf7TkOFj+el0zb3udvnroj+rmpwqMULd2ltbcXZCsNEjjK0Swha7iOgtQo/mQctkoVot9Cl3cnD53Ol8tpub/dexiJx6aVXedQqBB/POvZYq4z5UzU6y2+5jg5LXlj41L7drNVBFpbOJ5scfb3cR/H+eVTcnOO3l9DD7MeFJmHD/47hviRBwX6lD/I61MkFCLKuIfVAmwHaNPS8pJyU8XwiRGWn2A3CEEhwQBU114V94Vg==
Received: from DM5PR12CA0021.namprd12.prod.outlook.com (2603:10b6:4:1::31) by
 MN2PR12MB4176.namprd12.prod.outlook.com (2603:10b6:208:1d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Tue, 15 Jun
 2021 16:12:58 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:1:cafe::6f) by DM5PR12CA0021.outlook.office365.com
 (2603:10b6:4:1::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Tue, 15 Jun 2021 16:12:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Tue, 15 Jun 2021 16:12:58 +0000
Received: from [10.223.0.91] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Jun
 2021 16:12:56 +0000
Subject: Re: [PATCH ethtool v3 3/4] ethtool: Rename QSFP-DD identifiers to use
 CMIS
To:     Ido Schimmel <idosch@idosch.org>
CC:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>,
        <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
References: <1623148348-2033898-1-git-send-email-moshe@nvidia.com>
 <1623148348-2033898-4-git-send-email-moshe@nvidia.com>
 <YMYUI164vtDYCOhP@shredder>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <3ffa6379-e7f9-34b9-7504-b1ce21a160e0@nvidia.com>
Date:   Tue, 15 Jun 2021 19:12:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YMYUI164vtDYCOhP@shredder>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a523dc7-2cd0-4c24-684a-08d930187152
X-MS-TrafficTypeDiagnostic: MN2PR12MB4176:
X-Microsoft-Antispam-PRVS: <MN2PR12MB41763F02210329B4373A90CCD4309@MN2PR12MB4176.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X8Sli1k4H6Mo7l8OQ5kiY6Cmzcl8olLYYuo4p74nRu9I8BUsr5OGTtQ8TVWPPY1ux0PSxLr3DarmCnnAB00WKd96Z5iZM6/wy41JYI7jWriwoQaYHD2zR2oKmMpHt401FrTDIEbuHSFbwYcbLrG8o4Foom1xPmK1MGtGP1Qp+VPmVnUGmAxrGVMSNUtKg3PMJ1tJcdIo5rxlDlPSP2T0eycblQsXt93Mw7ZdvPUFMXl6zy1kB5Wo1SHBzxwxMFEL9av6N1NKCGFYuBsUq3RT+x6v76c1tBW2VZx+wzzphcs+qg8Ad9+8Isyvw1mg7O3WzkLETvcw6Dd67B7DolTtf13o+7BZeKaAIS29Wn98DroMh7JnO43EhXxaFhf76NVQziTek4nFqMnUO5b92hAkJpx8KWhmIcwTuY+1G17EFALzBH34N9VWLX40rHuxhki0q+BlOe8I93JW8GhlvCqs1RPlJB5UgsHqT56RqXaXNNOW7Ll80gxpPSZcXIhVF0YxZIirX//pYUFxuBEt4od3rZM3o2FpatoLO+vgsy5dvygURdZJV65hvZv9Ll6EKOjXzIOdEZy5UdSjwEGRDmweVOSAEd1WYlK49N8wfMnL4qc6ldVlKs1OwW8R630GOpR2MtKKOZ4sv6GbK9Kz9X5DmgmiGHid0fmvnW+Niy3ynkMnSwcZca8MuDibbII4TQSs
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(396003)(36840700001)(46966006)(426003)(336012)(26005)(8676002)(54906003)(5660300002)(356005)(86362001)(82740400003)(16526019)(2616005)(82310400003)(478600001)(36860700001)(186003)(47076005)(31696002)(4326008)(70206006)(6666004)(53546011)(2906002)(8936002)(31686004)(107886003)(70586007)(6916009)(7636003)(36756003)(83380400001)(36906005)(316002)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 16:12:58.7130
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a523dc7-2cd0-4c24-684a-08d930187152
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4176
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/13/2021 5:20 PM, Ido Schimmel wrote:
> External email: Use caution opening links or attachments
>
>
> On Tue, Jun 08, 2021 at 01:32:27PM +0300, Moshe Shemesh wrote:
>> +void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
>> +                const struct ethtool_module_eeprom *page_one)
>> +{
>> +     const __u8 *page_zero_data = page_zero->data;
>> +
>> +     cmis_show_identifier(page_zero_data);
>> +     cmis_show_power_info(page_zero_data);
>> +     cmis_show_connector(page_zero_data);
>> +     cmis_show_cbl_asm_len(page_zero_data);
>> +     cmis_show_sig_integrity(page_zero_data);
>> +     cmis_show_mit_compliance(page_zero_data);
>> +     cmis_show_mod_lvl_monitors(page_zero_data);
>> +
>> +     if (page_one)
>> +             cmis_show_link_len_from_page(page_one->data - 0x80);
>> +
>> +     cmis_show_vendor_info(page_zero_data);
>> +     cmis_show_rev_compliance(page_zero_data);
>> +}
>> diff --git a/cmis.h b/cmis.h
>> new file mode 100644
>> index 0000000..5b7ac38
>> --- /dev/null
>> +++ b/cmis.h
>> @@ -0,0 +1,128 @@
> [...]
>
>> +void cmis4_show_all(const struct ethtool_module_eeprom *page_zero,
>> +                 const struct ethtool_module_eeprom *page_one);
> Should be cmis_show_all():


I will fix and resend, thanks!

>
> netlink/module-eeprom.c:335:17: warning: implicit declaration of function ‘cmis_show_all’; did you mean ‘cmis4_show_all’? [-Wimplicit-function-declaration]
>    335 |                 cmis_show_all(page_zero, page_one);
>        |                 ^~~~~~~~~~~~~
>        |                 cmis4_show_all
