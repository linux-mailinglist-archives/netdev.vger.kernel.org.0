Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479DD21A572
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 19:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgGIRJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 13:09:03 -0400
Received: from mail-db8eur05on2040.outbound.protection.outlook.com ([40.107.20.40]:14598
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726744AbgGIRJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 13:09:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/vpNzZj1MQzRNON+PKgvZdW0Guicw/qXBs4GuUleV5V5lGu+/2VqGar6fo7A5w68ENnswblDCDXLjZ6J7XD/1RzVG+wLbKpYlQ+2KDIDEoFuYgfNGkcQqEibMnJmhprQ8cOXGycwbb6/Nc+BeoqEBNbyZBL19ZeutgPyvUMBjj/VKIZ9bKc/PsEGNMNHIJcy/q0aE1Z3SovKg1PulcgfuHODmbSldgJ51B/Yb3XZyFEMUutDr7m+oB0d3uxj9Gy2VOSVNB6nGx9elYF9N4SYDVPVbPvafRX2WBxfMf2lhc5KOWNHL60OfnexdkEBnwlCG+0K9Ct0tDRUU0lhZzbrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjGokBYXcERAdluuLZGEcOpF9Lt8I+8sv99Bhq4OjDk=;
 b=Uw+wa+9hO4KzbcoM8O2QywfGutdI6jLrEN+MfIojhRc7hqN2yCujy3oimxJvDOqAKoR9Fm+Es6Ex4dOeECe8EOWvYwW44sTUqsu/tGbOCxx8NZbs0i6RV2NEZ26Gr8+mavAkCbd94ZQVgMlcC1juUp5SjCoefm8IGdddrg4wuon+7NZiubZGEJAfh8BG8SWzAusJFRjkmPZK45q++4/0q4ll8nwAwTeyxozZayoQ+XZLNiiuoswm5eGtkor5xeIl12SKDkIDn3jcjbFBmn+INZCaFoGImUKV+Hg2y5fBWvy7Jc+Tc0A42yDxyhR1cyCigjGS0zynSNy/VT8hxQFlWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjGokBYXcERAdluuLZGEcOpF9Lt8I+8sv99Bhq4OjDk=;
 b=KYylvWk3bE/KMLIRFZoxAawaH0EsxYktb7yWmrc2JUm5wcIw2bycFFOyc9D5L+Su/3Tj7XZOn6hQtQGzpE4y+KHzxJ1G4dU+zka0mG0GsWZhwv9bvf+sz9RBcQ06gw2Dqs8/7s0kbtdQGu9IUaQVX0qHBzO7LjLxWzKxUEgDVZA=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR05MB4237.eurprd05.prod.outlook.com
 (2603:10a6:803:49::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Thu, 9 Jul
 2020 17:08:59 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe%5]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 17:08:59 +0000
Subject: Re: [PATCH net-next v2 10/10] mlx4: convert to new udp_tunnel_nic
 infra
To:     Tariq Toukan <tariqt@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, mkubecek@suse.cz
References: <20200709011814.4003186-1-kuba@kernel.org>
 <20200709011814.4003186-11-kuba@kernel.org>
 <bb47d592-4ef8-3cde-7aee-a31f2adcc5bb@mellanox.com>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <4c264a76-1f42-4a89-b23e-e4629c700ba7@mellanox.com>
Date:   Thu, 9 Jul 2020 20:08:54 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <bb47d592-4ef8-3cde-7aee-a31f2adcc5bb@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0011.eurprd03.prod.outlook.com
 (2603:10a6:208:14::24) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.126.93.183) by AM0PR03CA0011.eurprd03.prod.outlook.com (2603:10a6:208:14::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Thu, 9 Jul 2020 17:08:57 +0000
X-Originating-IP: [77.126.93.183]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 36d16bdd-35c9-45a2-f88c-08d8242ac536
X-MS-TrafficTypeDiagnostic: VI1PR05MB4237:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB42371FFEFBC2075C2252D6FEAE640@VI1PR05MB4237.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gFkjq5L3ODt9+Hwakp2Y7yNmVp7BBCqMxF/L56rhMswKYLL446g9aHFmt6vv6BoS65tq6sRqmMF7+RotIDkVS5ApJ2p+rO6AoZlBzDYosPYhE+OEhc+EdxfoXsV5gCcdtKRiE098Y2nT+zapK022YVXlYr+LHca9gKRujghDsmpdiOdOX/6it6a9VpMHUlUxwzqP0asa6jj6+psbAs8PV885OVhJ3rzAFWrzrZxS3/TSpoRRZXd8fng+cW3MtwQBS9a26jyaB4CjvExEjB6Bx+fhCr2F4LaHPJzieh5Z/keJ/Dcy2EMdHwCQmkbP7hqEW2FKVFrmuDzYzAUd9tdk6kUu7SI5cO6S6jz63wUGeCbPMAJpPITRdmw9QvtcRhLZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(26005)(16576012)(31686004)(83380400001)(16526019)(8936002)(4326008)(186003)(86362001)(66556008)(36756003)(316002)(6486002)(31696002)(66946007)(53546011)(8676002)(66476007)(478600001)(52116002)(6666004)(4744005)(5660300002)(956004)(110136005)(2616005)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kR6rX8mQ4JvbEfdyhJngmbccsPYg1s8cSu0t6f120M1eFFpss4Dj/HWXdSV05d/2BnfCcowA3IufinIA0LZVfKsqPyYvccr5QEblOMb10GxVjmtWvJTnRYAfHHmPIYcqwOblP4grMqDiqa8orGod2h+/yNlHFJjNtcW41GHYeTeqMgPELjuloBt4DeHqWnB0VNabqeHF3Zxq+GY7WUNFZWbITBUI2vi7vMgwx+YbwcELx0DuLVE4FpSt/s3pPx4iJ1aMgv6MDl8k+Gb4TuHBgXIxUD0PRtxi6r5ixSASufrz9kuNvvX4NB2159rCrwOnpHoQI1LJgwk1szqSSiZD3wgEw1ZoIdO4WzeIVs/qr+JPf8bcgurI6uOdy1O/VpTodoDnCTv+mGJ2cplMTNqo3FBll1QI2psJEI5crwMtgtyEY/Db4ZrFLLA1CyZ4VuGr7P5ker1dMoEoF6xFM02vsIweE1Bh0/jGmbcFc0RhCU0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d16bdd-35c9-45a2-f88c-08d8242ac536
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0501MB2205.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 17:08:59.1654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dyUe/e01ePmJRmDW4IUZ304n/7C0WFqqhoKhJMDwZSbyeL1t3kQlsQWgNV6ACEIYL19n51lxFZ9sx+xiqYDLiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4237
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/2020 4:58 PM, Tariq Toukan wrote:
> 
> 
> On 7/9/2020 4:18 AM, Jakub Kicinski wrote:
>> Convert to new infra, make use of the ability to sleep in the callback.
>>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> ---
>>   .../net/ethernet/mellanox/mlx4/en_netdev.c    | 107 ++++--------------
>>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |   2 -
>>   2 files changed, 25 insertions(+), 84 deletions(-)
>>
> 
> Hi Jakub,
> Thanks for your patch.
> 
> Our team started running relevant functional tests to verify the change 
> and look for regressions.
> I'll update about the results once done.
> 
Tests passed.
Acked-by: Tariq Toukan <tariqt@mellanox.com>

Thanks.
