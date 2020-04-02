Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10B219C655
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 17:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389535AbgDBPtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 11:49:06 -0400
Received: from mail-db8eur05on2068.outbound.protection.outlook.com ([40.107.20.68]:6113
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388677AbgDBPtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 11:49:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8JlcvwPLXZPF6nkm6aJgtLSTFLb4Dc4AhXplWRt9frSMwg3dXaVWeL5tU1rYIqB2YtlNq/2a7VaTj/LRP+yeKkh/R5RXDHZfxFdswmSz4Q0jQXVyy2655fib11IisFurWN9QtQLuv8Dk1pwsslQy2pY0ssrZx5DgpW6feh2zLGkhkx4c+ZhZD/Fw/lBNk5f1Z5LVFolQWl1dxD8pRnXZ8uv2Bf0tcYYzvanlCMji4f+n8cSfxjfoMaCcR9bq153TvyRnDBuv0gt3s8TXNAeG9DObyJ44WGlRnz9tDmCfQILqDcIgEeXlf+GEL9wrQKm8ED38mtaMpui7Jhh4MA24g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dM1njvNuj5MYoQN/7crNJrmQMm0TVzz6JbiASOUJ2ms=;
 b=FynMCkMcVyz4t8ifyWbsfpMTMxqx2RacSD5pueyxuwsybAmAYQpvhGknByEM8jRs5BQLm/93+dkdOPhmRMvOBIHA5ucCrx7xBx1f9VhttgiibmD68/XGAn5LkoC3W6cmHuOxbaw0D64Gae8KOoNV2ojiIZfR5pkRm7KIOqIZrAF8glOdx9kBjbyu1lCt0OtFAs8fOhOzHsa1OE12mBcQzZZkPAA5RdV3eZEmVTQebP0I6TqauFip4C7MMc5fSEwm/a5IEa59/fYAKKLrIOx+is4QABsgUHsw/YqRqfvHVYI9mqMfnwaDfp9DLIlaLH1iF7XYC1GbPJ1KMeJcQ2kOXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dM1njvNuj5MYoQN/7crNJrmQMm0TVzz6JbiASOUJ2ms=;
 b=RQ23Q4apLoi8FyOxsWd4sbyd6hoz0Bb1J1UErL9fXsqTMxpb80ML0bmSEXjaMgW7bJGkf36VglWkfdUFtPMqB9C2L/HyV+iChDFclivjAQAz2OUt5ET/h3UuhTO/jAlHgvqxnkpN1ovwdsoqV0pT09NzL+mtHXQAFZCSQe/FqHo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com (10.186.174.71) by
 AM0PR05MB5105.eurprd05.prod.outlook.com (20.178.19.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Thu, 2 Apr 2020 15:49:02 +0000
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::6923:aafd:c994:bfa5]) by AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::6923:aafd:c994:bfa5%7]) with mapi id 15.20.2835.025; Thu, 2 Apr 2020
 15:49:02 +0000
Date:   Thu, 2 Apr 2020 18:48:59 +0300
From:   Ido Schimmel <idosch@mellanox.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] mlxsw: spectrum_trap: fix unintention integer
 overflow on left shift
Message-ID: <20200402154859.GA2453139@splinter>
References: <20200402144851.565983-1-colin.king@canonical.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402144851.565983-1-colin.king@canonical.com>
X-ClientProxiedBy: AM0PR02CA0041.eurprd02.prod.outlook.com
 (2603:10a6:208:d2::18) To AM0PR05MB6754.eurprd05.prod.outlook.com
 (2603:10a6:20b:15a::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (79.181.132.191) by AM0PR02CA0041.eurprd02.prod.outlook.com (2603:10a6:208:d2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Thu, 2 Apr 2020 15:49:02 +0000
X-Originating-IP: [79.181.132.191]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c26e05d9-1dd7-4e0e-ab95-08d7d71d5db5
X-MS-TrafficTypeDiagnostic: AM0PR05MB5105:|AM0PR05MB5105:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB51051753337067C649D2872BBFC60@AM0PR05MB5105.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0361212EA8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB6754.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(7916004)(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(2906002)(81166006)(33716001)(33656002)(52116002)(316002)(81156014)(1076003)(6666004)(478600001)(8936002)(6496006)(8676002)(4326008)(4744005)(54906003)(5660300002)(186003)(86362001)(66476007)(956004)(6486002)(6916009)(66946007)(26005)(16526019)(9686003)(66556008);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TBc2Hj25d5QQzyXaFcuPR47MoAojWiY5FkelZgy+aeTuxvMYPJU/4muC/d5MPB9FZLwIXWwiF0esBeC0KxWF2qqjSj5CrIxqtcvGVgQ99g6cA0rZbxmmPHmoq12ED/CIIo+9bFW4Z+GEBoCY/5BEtDp419mQg/SbO7dGpKky0NlSjWWJl13b532Cw9BhBBiM1WUYuXsfNpNNhB5rCAFuvkczvKAt+CyQDcsmTK/NvJ2nK4575RL2aw/9LbcWoeSHT5XwABZj60ROP3MoQ7tgs31zk29ouPG/8rZnPFJrEZPAZpWfuHfGW7Lz+BCdy6mk+bAouueI6fJ5AUlKXdKybJKeByqk9U5i19lUvBrZEnVf1gLQxY2slhmt6gyjkHPVce6Qa3V4LtHbMvknA5GqwQeG7orn50Mg0dyoG78R4WE73YpiAGbtKItS1qqT8XKo
X-MS-Exchange-AntiSpam-MessageData: Of4PgLZZDO3+aVY4NZGgPSvE96Q+iRLXhhXaT2ijJ7NuofafcnUYKVVmgzsgc4VUcOIr10h0B3ejQBknYFDTxe3pbyAB2p0jXjEv5ik4R+5V6MoB+qf6hFk5xLLIdFAvWJMsXWd8toMIMrA6zyD4PA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c26e05d9-1dd7-4e0e-ab95-08d7d71d5db5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2020 15:49:02.4296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZMBHS1xsAz+vmvUox2UDthpBrgDL2/RwznwkfJlv5WmB+gX7MUTyA06m17pqankXkuBipl7roAD8R1XQeWm7sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 02, 2020 at 03:48:51PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Shifting the integer value 1 is evaluated using 32-bit
> arithmetic and then used in an expression that expects a 64-bit
> value, so there is potentially an integer overflow. Fix this
> by using the BIT_ULL macro to perform the shift and avoid the
> overflow.
> 
> Addresses-Coverity: ("Unintentional integer overflow")
> Fixes: 13f2e64b94ea ("mlxsw: spectrum_trap: Add devlink-trap policer support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

For net:

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>

Thanks
