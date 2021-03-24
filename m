Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAB8347545
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 11:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbhCXKDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 06:03:55 -0400
Received: from mail-bn8nam11on2068.outbound.protection.outlook.com ([40.107.236.68]:45408
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233339AbhCXKDk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 06:03:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmMCMIZ8BdO8A0OYVyEEnQmUhww9HN/IlfKXaEe+ZjcgdGDtTKShiuswjEHsy+wfnc3ToKEFLcLu1Np8P47pl6mdLSziMhq10vJ8cb36eYVcjXL5+0gOt1/I696mBGaMtyvC7pDCZbgKbLelbsxBEU2HOD9+uzHCQB1Dgf7E5atingnSGlJ8yYlG2E6sOeCZoHTfed/u2E7ADKvJBxoH4ndoeqyCs02RSzlYhv55uwNVQLtW+Zcpx/hrJOunp+ZTIMLXeCTelofPOnpzl8GUL2UXSKKebVg5R0OUyYe6hi9zcVA3C3oJauDlVYIsNw9fLSga/MB3IRb54A+8V2rLxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WC6GJ9ZbwDMfXkBi58AApsW/i6jJoQI3axZbLe6BO8I=;
 b=OFUr0vZ4cR2a7RzVys4AJQjZimcy4jSK74zdYRa4eYDPV6tXlvXhuNSVkO07adASWGwqfcqJDS0vgAt7OHSvOEYxTcpOjm0dt4AxsHas7By+5LyjVExMr5gZ7FCcHXTKXn1Pq0ZRAWv89eExsMzcSEqc4U4Xoo7KgKV+VofLXfH1o9TugC8U/g6NttBha+aBYkfhg5vLSMc9Flxur+w+xv6MFlUZlyrCK/kc0i6iMe+9IwY5wSYVP29Al5ig/Pyy3uKmjTR6Jfs2lZEvHFiLXJOmpl2m2RfEHUbzP2vDCZwrwVhXn1Nod/tY0HFzvzBzRy2GEDpuvBCbokH1AxSz+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WC6GJ9ZbwDMfXkBi58AApsW/i6jJoQI3axZbLe6BO8I=;
 b=SAGZSk3Zu+knbkEt3F47nvFDyuSLHUumyk3ibufqp0NPy4dERR9Ow80zydLuyim2Nf5xr+V/7BwlYfZ0wcYQeITmgtrwfvNCpegjreINlkhMHm19J4jCC2r++N+v2L9NKr5IpHDUxNl+rc73Oi13GiAwbGRcHqERT28w0Gkh6vxNi764JEwoTPAC/0S2IbGXc+Wx4KgzoplzzH7RuxqPAFgZda22EqXvA+LhHGFWxFZEIqS2kSHiBZT1odgokNUBDk997LPOZ57ny526oid1lZy7xUGA1ziWgbEWibmWcM9NEbpcdH28WIv3HF9sNnB7uRpTj+qGRDPUSMLGvJVSwA==
Received: from MW4PR04CA0195.namprd04.prod.outlook.com (2603:10b6:303:86::20)
 by BYAPR12MB3015.namprd12.prod.outlook.com (2603:10b6:a03:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Wed, 24 Mar
 2021 10:03:38 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::73) by MW4PR04CA0195.outlook.office365.com
 (2603:10b6:303:86::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend
 Transport; Wed, 24 Mar 2021 10:03:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 24 Mar 2021 10:03:38 +0000
Received: from [172.27.0.48] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 24 Mar
 2021 10:03:35 +0000
Subject: Re: [RFC PATCH V4 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
To:     Andrew Lunn <andrew@lunn.ch>, Don Bollinger <don@thebollingers.org>
CC:     "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Adrian Pop' <pop.adrian61@gmail.com>,
        'Michal Kubecek' <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
 <1616433075-27051-2-git-send-email-moshe@nvidia.com>
 <006801d71f47$a61f09b0$f25d1d10$@thebollingers.org>
 <YFk13y19yMC0rr04@lunn.ch>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <3e78a1cd-e63d-142a-3b78-511238e48bef@nvidia.com>
Date:   Wed, 24 Mar 2021 12:03:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YFk13y19yMC0rr04@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ce20605-b618-431f-0f8b-08d8eeac1844
X-MS-TrafficTypeDiagnostic: BYAPR12MB3015:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3015D738955778B49CFBF09CD4639@BYAPR12MB3015.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BBtMLiKiRIoQquURVEbEpfZqURmd42LD2ie0jCHIl1yyV+5Fg+dp71kmsAWvBbmTQifi7JSZeF/MTp3i0U42HL7cWEKRREm93W5zod5HNF90QtX5HhAoFl3AO9oewhCaId6UaIC2jmU5xVqn4qufIC8XCUTyysTomtaefMNjyMbO3Lx00tnbocv0XK2rSG0w2EJduGAUlQZ7bRXjHATuITRqNhGh0URvTX6uoe3nTvKbAh6D4cyImy4R5BjAJx2mN3ugzXhN/8Ay3vVDzGDMgFBK/Vk/LWP/tXQGYcFCzxARr9CP7pcpM7vZAtrHbkPbeCtq5jXcfJkBdauVZmoFv5XcMLEKMm3uIBvkPlKUgq/ObtAJNya465OANj4Jd3S/zABAePN08tfzLh7++wIhFEGXIOLaLEiGqMggfgMNGHWR4AD5Wi/3LxPfkOcwtFCRlLCBDJp0fP9JraZXziU0AfeFI+V6OEtR9gqQDRlOe1JmFwlAPoa0+WQ5nOWfyPhwwcAlN8U/oweY5ZxpsV8O7TsvDlh4vl9KOa5lXBhceT532pyQgDDeffzojJFGojGGkIkEjxGsQxe2iCyKBPENc9K0KRe/y6Ro9RopOIDgnMjIYUHDsj2p84RfhZUmTidd+i4SpKg37k9MhyW8c5rHcgxaoBxhc9tlgrGb3kfAnZuRJniK3+zAeqFCqig5XfPb
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(46966006)(36840700001)(186003)(107886003)(8936002)(6666004)(4326008)(31696002)(2616005)(336012)(70586007)(26005)(8676002)(31686004)(426003)(5660300002)(53546011)(16526019)(36860700001)(70206006)(110136005)(82740400003)(47076005)(36756003)(2906002)(356005)(7636003)(83380400001)(36906005)(82310400003)(16576012)(478600001)(316002)(54906003)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 10:03:38.0685
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ce20605-b618-431f-0f8b-08d8eeac1844
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3015
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/23/2021 2:27 AM, Andrew Lunn wrote:
>
>>> +#define ETH_MODULE_EEPROM_PAGE_LEN 256
>> Sorry to keep raising issues, but I think you want to make this constant
>> 128.
> Yes, i also think the KAPI should be limited to returning a maximum of
> a 1/2 page per call.
OK.
>>> +#define MODULE_EEPROM_MAX_OFFSET (257 *
>>> ETH_MODULE_EEPROM_PAGE_LEN)
>> The device actually has 257 addressable chunks of 128 bytes each.  With
>> ETH_MODULE_EEPROM_PAGE_LEN set to 256, your constant is 2X too big.
>>
>> Note also, SFP devices (but not QSFP or CMIS) actually have another 256
>> bytes available at 0x50, in addition to the full 257*128 at 0x51.  So SFP is
>> actually 259*128 or (256 + 257 * 128).
>>
>> Devices that don't support pages have much lower limits (256 bytes for
>> QSFP/CMIS and 512 for SFP).  Some SFP only support 256 bytes.  Most devices
>> will return nonsense for pages above 3.  So, this check is really only an
>> absolute limit.  The SFP driver that takes this request will probably check
>> against a more refined MAX length (eg modinfo->eeprom_len).
>>
>> I suggest setting this constant to 259 * (ETH_MODULE_EEPROM_PAGE_LEN / 2).
>> Let the driver refine it from there.
> I don't even see a need for this. The offset should be within one 1/2
> page, of one bank. So offset >= 0 and <= 127. Length is also > 0 and
> <- 127. And offset+length is <= 127.
>
> For the moment, please forget about backwards compatibility with the
> IOCTL interface. Lets get a new clean KAPI and a new clean internal
> API between the ethtool core and the drivers. Once we have that agreed
> on, we can work on the various compatibility shims we need to work
> between old and new APIs in various places.


OK, so following the comments here, I will ignore backward compatibility 
of having global offset and length.

That means I assume in this KAPI I am asked to get data from specific 
page. Should I also require user space to send page number to this KAPI 
(I mean make page number mandatory) ?

>        Andrew
