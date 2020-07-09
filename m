Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424E821A18A
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgGIN6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:58:46 -0400
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:38468
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726444AbgGIN6p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 09:58:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTjWr0019zBmmfY79QVkaLuhmwT8ob0zzkFKFChZZqWQEpORJsHTn4l/JeGAwmLZ/p7daJTG12EdYu5SVSA+CaDU6vgCVDXOZ9k342PEgYk+Edn+4zGws0zzzendrjQf8suNTZTVCWrzFQuNOUEqmk7KzjWitKT9VGAzWNe+veREpzvptk73KXPBRYPdmPhCjsO9ydkeOTfHrYXd9SRAOCCXaq39GGMOknRSTxalxwgI4Ywtl+ECC5v/SrG1Uz5eRBjk8yCQFWrwcG28l5gzJX83O5bsCeBItbYIemSDaq5tDtqvB9Sgnu6QykUWubG+G0G4NEtcCxKiAu6UmK80lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NxPbjDRjz2ggvj1V6/5nnNG1eWqRGqqBdwC5HWdXmY=;
 b=Y/a3nA+9DaVZdKZN2afpYwnrqHP8bGXXww3ZfJNFLwzgGc7coeRo/YuQXEfmvlGRn0AGXN7EdvBcypNRDhUqkL6CYHCzXdJzUtWW8NzzzM4cwHU1uW5Jl3ZMAxaBTz1KGQEFUEm/99BrlHlBDc4yAP3gL1pdfOK3X4eY97q+/f0HIHhXfmHlK4AtXnBSwK/bB31Jxwpz74LVLPuRCNDqlRGg9ceoLPsgPAWMvXZjen9DTtWlUYl8YHbNnhFHsBgL2Pouji9aDvePEBqZjZvYAe0Utdf+fAWQmE0mBEt+6PlJn3mdvTEgxJZH5KWqtiP0nGtnme3ip1llUA3gACGngQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NxPbjDRjz2ggvj1V6/5nnNG1eWqRGqqBdwC5HWdXmY=;
 b=BZ9IbqqANQLB/pazHUEuFDy9H0MH3fI0n84RmRFWqUX5gV11WNEbOT1PgxjLQ3935oTdEE9Czf/fON352piYbBTHuGroWds+uo1KQnZ+7BO4Tbwx8Q5rT7G37gC6LrkhOMLrrP/d2Pcg9pPnhgD8GMCyYjHVVPP4348HUOY0vS0=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR05MB5997.eurprd05.prod.outlook.com
 (2603:10a6:803:e4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Thu, 9 Jul
 2020 13:58:41 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe%5]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 13:58:41 +0000
Subject: Re: [PATCH net-next v2 10/10] mlx4: convert to new udp_tunnel_nic
 infra
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com, mkubecek@suse.cz
References: <20200709011814.4003186-1-kuba@kernel.org>
 <20200709011814.4003186-11-kuba@kernel.org>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <bb47d592-4ef8-3cde-7aee-a31f2adcc5bb@mellanox.com>
Date:   Thu, 9 Jul 2020 16:58:32 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <20200709011814.4003186-11-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0158.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::27) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.126.93.183) by AM0PR01CA0158.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Thu, 9 Jul 2020 13:58:38 +0000
X-Originating-IP: [77.126.93.183]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 28d2f753-1352-4156-a430-08d824102fc9
X-MS-TrafficTypeDiagnostic: VI1PR05MB5997:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5997CFFC81F873DD675D33B8AE640@VI1PR05MB5997.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1qAk97ptjqbPRntAjPqaYjaJ3/NvR1kEQSnK4sIzQ7oD+u56LMRvpELPyb2MVpi800S+aygV4c/0Y9gC/HEEPYyrTvtXx26i7e45KtdDxBRTMn24p/7UAx58c2F/Vuh0guUXuxmh93NaBC3o9HYgjr2fpowbQxni0i8L0jofCZ1BFu3ZoyyP7MxiXRhQ+Qm4uaeeokujrLuDLahf5Yzy1sO2xZclwIIAQDLbNY3jdjSaKqfgSYQZTTaJxIQBJsePe48ChxRelOaLeIGXwNbFsEEGVkzS4HixxUNFGm4ktPxXGIFedx4LC3p334erR/v+cx8d15vocreM6R8qnDD/hY/g/+6IcsHlyfrhK+52JMzQ+PpyIPC6VUZcsZxr38Xs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(5660300002)(86362001)(186003)(2616005)(36756003)(956004)(2906002)(4326008)(4744005)(16526019)(31696002)(31686004)(52116002)(6666004)(8676002)(8936002)(26005)(498600001)(83380400001)(16576012)(53546011)(66476007)(66556008)(66946007)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DhSxrzqBaueK+kVuM8lROuVzS4mknEJGe0mruDYIPE7Id38D9zHwWIvW95udtfWE/tYSpnJVn212z3cKJbLjxNYo6HCAaNUaYbD6Na5EEjkhVY1bafEGGYHX5YkOl79txZN5DZ/P+TJjX3MtAPrRjribkEDf8NUCQNBYABZLOwtDkqJzejl5ajHPxqdzDQYkXDf2bvd+wdiXUB8jY2zmjDEpYB08Yb6jbSLZWoE7kgBludw0cPSR6j3O3xJCH0ADXnPP1UsnVFKJmHW96+P4VWV3aJXev/O8caa9XkrWp+yfLdgbrqYP4AJz8UO6dkHFgrgYF6s2qf26E1S1RUbiF8E81Ncncn10Ujk7D6yCTyZaN7ScAKu6OJgguCfLVtS+03qdzFJKTi0BnYdhyPJgJYdJZXKjocm3UrQSJKb4ZSLCGuifJU0DpwCSHAl0KvOWNv14CLAXyV9OHne+LeqAwT//EJxohtTzQa9VHFHtIHg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28d2f753-1352-4156-a430-08d824102fc9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0501MB2205.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 13:58:41.5194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2m3GegZwh4QfTW/dRptlg7p2jKJi04MwG3tG2VNT2BgEjB1vB5lTkkAehktHGHJV18TpAOdPHdXCkQykkuRypA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5997
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/2020 4:18 AM, Jakub Kicinski wrote:
> Convert to new infra, make use of the ability to sleep in the callback.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   .../net/ethernet/mellanox/mlx4/en_netdev.c    | 107 ++++--------------
>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |   2 -
>   2 files changed, 25 insertions(+), 84 deletions(-)
> 

Hi Jakub,
Thanks for your patch.

Our team started running relevant functional tests to verify the change 
and look for regressions.
I'll update about the results once done.

Regards,
Tariq
