Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07CD211D9C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 09:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGBH5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 03:57:38 -0400
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:54115
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725287AbgGBH5i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 03:57:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrnFIARQON7Sk0JudatWiotsqU+0ok7oEEVcxhQJmv3gNQ+RuVRh2w26WaWp1FaIkWwRtm8VOgHHYdBCYlK9f8T8yhvLLwBjTQi30g4UcIq8w40lFow0/df+3n120BAL646nri4vfRsP0EG/Y8Ls7m5QQkJtzKgQKuiAF9HsOZgrLkwQCWrm3cQigZvyeOoBQlX34du7yEsfXhqlzOr7h42cmM12ekp7l+V//qCwCR1jHJzpBhAWLc7oet+eQEc37OMmuoi/st+nX7//sUmJcjmLjdeJEc3apPYGjUFHKe6ZURQJPSfkeXrxwuwEJ0LMiQ9ZkfQHK5cySL1yhRBLTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LV4hOFlfJ7JG45ZMEsPe1uefjeKyllVzYmnZaBammsI=;
 b=DVqHPMqWKoa2tGpMu8VNHD857garA1NwJgB+UIdEf2770KENQ3pB13yjkdTOkFJf838Rsw90dNRN5VunUipUJ7bTokT9mdCYwK5rvfdI4wRuzrI/cLx8gFCO5I/XQKxFWE4QQkGm/83FT2sQCQe9AlzzEQHfkXvl2lgahXBAINtKb/x3Pm+6+sKDuvS8WyHGbiSf8Vx8vumuNSP20Up5VSr4E8e0zYkhOHtQSLl2GjFfOmKRYOCS2BQuhQgfOgfdXYqpRIwDTXy3pzwDT7xxpfL1ZGfenfzRABX/AfOb2NnCTK+EXLBMqIDv5tJSWW2dicah19d1nn4krFhKQQ+qHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LV4hOFlfJ7JG45ZMEsPe1uefjeKyllVzYmnZaBammsI=;
 b=GRl+i1O7xcs4I/cy1FnUsfPqievN+R+N+ad7dXraNMtZUZOT93f3n2YWsL9kLMuzZsgdR2zViYV+Fyhs4z6ILQU3mbK5mxAYiwWrmLT123Z9I9tx4N7MEa41UupMbldiltDKxxMuXQ6fga70XSeFMCts8KE2J6Pv4Xhjox+nHWE=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB5825.eurprd05.prod.outlook.com (2603:10a6:208:11e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Thu, 2 Jul
 2020 07:57:34 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3153.020; Thu, 2 Jul 2020
 07:57:34 +0000
Subject: Re: [PATCH net-next v2 5/9] devlink: Add a new devlink port lanes
 attribute and pass to netlink
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com,
        snelson@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20200701143251.456693-1-idosch@idosch.org>
 <20200701143251.456693-6-idosch@idosch.org>
 <20200701115403.75b13480@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Danielle Ratson <danieller@mellanox.com>
Message-ID: <83d5c1e5-6236-ad06-57b7-811f60550e85@mellanox.com>
Date:   Thu, 2 Jul 2020 10:57:30 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200701115403.75b13480@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR08CA0034.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::47) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.14] (185.175.35.247) by AM0PR08CA0034.eurprd08.prod.outlook.com (2603:10a6:208:d2::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Thu, 2 Jul 2020 07:57:32 +0000
X-Originating-IP: [185.175.35.247]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1adacc2-c305-4eba-5b53-08d81e5d9434
X-MS-TrafficTypeDiagnostic: AM0PR05MB5825:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB5825FD15D8DB91DDB6C1E837D56D0@AM0PR05MB5825.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /doHDU17UeP91yr1p6FaIFMkYMUycPEU3dK4zjcfM/jU3CG1HOJMqc7wDoA3wJEqRfhcboOpX3lL79dai0j8uQu/0yD9nOd8eR1ZQvs0xNF38y/j6aGyOgzBC/2bISr5YWuQzrNIQpuKyFdvvXlWNwPCfWNKY37+OO27nDYKU5BbISREfDVecTeMKrtsRKOgbHvyD/YbY79Ab5Hyx0R/VC13UCMt6sFaWez2NDrC6TAAPc9eEcNCY+aj2JgLAWK+JnrCj4AMzwWcFWEf/qx0gF1cuuhxLi5tUEzowy7pcHzQebutPN1TysLTiZuGbqrTLVGr6EMM4veUfaSXtAJJda3+bXpjfTTJfUn0hIPLVkrZGjmZni1SaGl7NL/GFyTz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(36756003)(4326008)(26005)(4744005)(2906002)(107886003)(66946007)(5660300002)(53546011)(8936002)(66556008)(31696002)(8676002)(86362001)(66476007)(186003)(7416002)(2616005)(110136005)(6486002)(31686004)(52116002)(16526019)(16576012)(316002)(478600001)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rHZC6x4cJuYDG2qig8PeHE9UkB8C69ceJ5FANoNlSl1ux9CQCGOgIXHZ3yhn5GjRJr5vrV+zHSPptvdV/mBVfZjlXVZhmvYy85x6qLByUDSR9l/DZFwYW6m8qcI79rsEgj19E2458GrzZGpoqjWzJauLccegWi7u3wt16/0ZR6ckYa8o6lyH4ICYtobAqMfeISZ+86sVyd9pbBLDwLH2i18BE3diZA7KUggGH/GHC8flOU51JwJM6lloTM8YQZDZ3+B4ASqNz2bBocJFg9h56djTIGqI16sqJYdqPhMPl54jPCK8qm88BtW+6R+ocrDGjpkIXuyv8dsJhfjX20JpXjrYhpzffGdaS3AE7ciwh5nrtjSi4+Ll3H0F1HsxUrkUD0RO5EDASpBSk8XeEesd3orcgwVpa6BpQrlKh5kh5q2YtHID23HDy0ciwrOj2kwFuUnyd/qSiGV0Q4TnDNvMUufO/YHatPSiqbm7O4OQhNEB1x51HpZl1Q8x7o9NUQGG
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1adacc2-c305-4eba-5b53-08d81e5d9434
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 07:57:34.1585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PiA48g/cFXBSErJ5hcwBSgAQgud9LKtDqOcvkfeG0OyqlLaPjwT+kAnJU9Ht9huSxDar0v8n/1vKYaI0Lyw83A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5825
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/2020 9:54 PM, Jakub Kicinski wrote:
> On Wed,  1 Jul 2020 17:32:47 +0300 Ido Schimmel wrote:
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 8f9db991192d..91752b79bb29 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -68,10 +68,13 @@ struct devlink_port_pci_vf_attrs {
>>   * struct devlink_port_attrs - devlink port object
>>   * @flavour: flavour of the port
>>   * @split: indicates if this is split port
>> + * @lanes: maximum number of lanes the port supports.
>> + *	   0 value is not passed to netlink and valid number is a power of 2.
> Why power of two? what about 100G R10?


Missed that, thanks.


>
>>   * @switch_id: if the port is part of switch, this is buffer with ID, otherwise this is NULL
>>   */
>>  struct devlink_port_attrs {
>>  	u8 split:1;
>> +	u32 lanes;
>>  	enum devlink_port_flavour flavour;
>>  	struct netdev_phys_item_id switch_id;
>>  	union {


