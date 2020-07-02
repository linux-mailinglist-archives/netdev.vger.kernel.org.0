Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F851212B7D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgGBRsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:48:08 -0400
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:19061
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726997AbgGBRsH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 13:48:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gv3Mnpskq3OEt8cbWf5QpT53IGHNFcFUplX+AfD/QAi3j0/UbIJ4XIBjV0369mHAt5ie9QrH39gVz73uQvwoNfDUF2bYWyWIuS18JoUjLSouC+tLqPX/U7GBai4/vQsLnoMtdfBtsUmrf3EHiXrEGcZ8R1s4N7G8+FUvNLqltXCy4tYknGQ7qLaCbnGPTjl9vKKG4pwdwuTlQMyxDh63hPShEAa9GItpsrxHZ29S16DxEQ6yGdZRC9SeuKkbGTGjkFDFTlTCOsy61IE+fu6IN7HYwt7hg9CG/ol1Z5qeS/JxnqJH6JVhDXnvp16dgxuNEt9ArUoZ+yFiKUM5RlWCdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGdh+FcVEqE4DGhUiMS9vKl1jyo1XzQ/gb+eZVB/uEQ=;
 b=KwtLw7wGj6//lAEIciIv5Z/kwOkGiDobzvd9wUhd++Qb+pBYN78mpf/Vc95aGw3/h4sLhiyp391EFKOv41VQaDt2BCg2NeCtuGTKmNrz8wTXa0n4t0spUmkoppY0T7WqZpVd+WU7PPFAa2j/7wRVJzUmu2B5tf3Tq22GnHhR+J928/FqSAbYUZ3xtqXqDubGYDtFPc+hq5S1XeBo35qRIDJ3bv40JmfGRKGE/LttzPoFmixBcL9zXf1uLLFIMQL9b4lTN3KBTraX4vpqk+sdwcWYy8WihvTZtdRXemYcFUlVPhHXSUKW+uAHe5ys6eIPuQwnip3USVgIg1SMCXCtKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGdh+FcVEqE4DGhUiMS9vKl1jyo1XzQ/gb+eZVB/uEQ=;
 b=cbiVtJcHel1UlctNQuLpRF7QvhJqHS8UhNTgN5oBbuV44C3olZT2jhsiQCW2DSNDbJScMNXWjHS/Y1It4hSMLcLvxb8GtpSn06f1RTGZ8dYXIcC2Lt7GloP72v82BFtCoejIscD2yGH2NJunUsh+9Ljz8WeaxHwwwoxqaxZ/FCc=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com (2603:10a6:208:63::16)
 by AM0PR0502MB4052.eurprd05.prod.outlook.com (2603:10a6:208:9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Thu, 2 Jul
 2020 17:48:02 +0000
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f]) by AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f%3]) with mapi id 15.20.3153.024; Thu, 2 Jul 2020
 17:48:02 +0000
Subject: Re: [PATCH net-next 5/7] devlink: Add devlink health port reporters
 API
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
References: <1593702493-15323-1-git-send-email-moshe@mellanox.com>
 <1593702493-15323-6-git-send-email-moshe@mellanox.com>
 <20200702094053.50252366@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <d7b0bf0f-6e9c-6894-c6e8-dde4c5d3c4a7@mellanox.com>
Date:   Thu, 2 Jul 2020 20:48:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <20200702094053.50252366@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM3PR07CA0089.eurprd07.prod.outlook.com
 (2603:10a6:207:6::23) To AM0PR05MB4290.eurprd05.prod.outlook.com
 (2603:10a6:208:63::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.0.91] (193.47.165.251) by AM3PR07CA0089.eurprd07.prod.outlook.com (2603:10a6:207:6::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.9 via Frontend Transport; Thu, 2 Jul 2020 17:48:01 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e50c218b-6965-4bd9-4ee3-08d81eb0112f
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4052:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB40523CFEF43F55CF840656F3D96D0@AM0PR0502MB4052.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OTMClVUfJzP4LBEFHe8mkcQ8EnbmaKqzS99XE22KFaccRO/e2SFQ/FQfFHj3rj1vDWbIGjqU9xwH+zjVSUgg/AHcqnbiYsnNh2HZznaI/Fi9TO8LCChjDW9SWEaeWU2FEHZnA1nvI0sXO1bnNBmFB0ZtdJsfEXs/naZcLeXN4rhW2+/rasNw14eBnRp47zx0oOBQ71PAOULTbM9Y7KdVcVjNc7K8+tl8tCAgTAbYFf1xW9MNaw6SyolqAUHT+bN4MH6Jgz5anqa8Mvq5V9q5IyfbCsW1G5fU7c84CbNzcq6n5ZICYML9pQGhGr68l5OPZ5A4pQ6vxLVNM9gL0zLeuEU5xQK5wfIPJ/lWTt8ZIprJeWzIAKcGzpb44gqrXmxC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4290.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(66476007)(83380400001)(31696002)(16576012)(66946007)(6916009)(52116002)(54906003)(107886003)(4744005)(86362001)(8936002)(2906002)(316002)(8676002)(31686004)(53546011)(66556008)(956004)(4326008)(478600001)(36756003)(16526019)(186003)(26005)(6486002)(2616005)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jHGgoN7x6717kfmd/7c8W7RfsdwyDaG9GkV/kv4tpwlGHc0OPVRVfI09Y8K4gc3nV75qxFmVpfe+G9WuX89AFipO0U8mEmPXnWWDV8DITGx1ag1y2ZdJ7cTL7gOi5L6GfwFPs7koIMVZOvKvOMmeYTiLP8yAnAbfysOTASRr4X5MRzMC2mX5CVOx1uSzaxgI+0rUz1Eb48WeChgDmeSvk3HnKyIb7YYL9WJZDdqp27/hr1QHea5AGTMsOcfHZDLlqf9H865C7PKD67o3OTsWTRY9zn5JeizrdQyb1mN87pxKuRUwpPwREUyJbjBhiujYvyhKNvoudmckHVsl0cDojpwH2yGnx4VSqwZjhidonp+uy2FLq91AgIx95Jc/67gNPlnno5qcXco1NkZtrPkT9bQCRY6IuNT2ktkDQKYH/G8wJCpJazoJgQ6TtZL3f0rpvLxgyS31e23+YX7sgrtTbwDL4ujgh61YlivwXI8Zgstnq/UV6FH4arV/YLyFa5vT
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e50c218b-6965-4bd9-4ee3-08d81eb0112f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4290.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 17:48:02.6124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gdpg1+Db7mSpwxQYbjkRvJPtWrwvrQxpNIVfdPbiGVQcQcZ6Q50EtTj9dQUbExqE6ubz0YfD/Grotj2zdUnwDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4052
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/2/2020 7:40 PM, Jakub Kicinski wrote:
> On Thu,  2 Jul 2020 18:08:11 +0300 Moshe Shemesh wrote:
>> From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
>>
>> In order to use new devlink port health reporters infrastructure, add
>> corresponding constructor and destructor functions.
>>
>> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
>> Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> net/core/devlink.c:5361: warning: Function parameter or member 'port' not described in 'devlink_port_health_reporter_create'
> net/core/devlink.c:5361: warning: Excess function parameter 'devlink_port' description in 'devlink_port_health_reporter_create'
> net/core/devlink.c:5462: warning: Excess function parameter 'port' description in 'devlink_port_health_reporter_destroy'


I will resend with a fix. Thanks.


