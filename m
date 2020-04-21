Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE61F1B25B3
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 14:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgDUMOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 08:14:11 -0400
Received: from mail-eopbgr30068.outbound.protection.outlook.com ([40.107.3.68]:47513
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726741AbgDUMOL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 08:14:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFFcMR5gmHTimwEDSTDsNSZp9qRGAH2/OGhKprnaLZa2tr8YrJOltzI0UiHo8y1zIc5RQ5flYp404UzG/lFEF7Q5Wb95h0FjLqEKz/Drb+pBfXcRHncBUzGTauMVRVasixgEJzZwLhleg+k+5K2YCUZS1a/b0D5kpJRdLT7Z32c/Zo7SKIDBTCOd3E3dEC3fZ7MFxM+hYCURMdnsJqHwzjoFXvhMrii5KXOWnZucX8I7ua4UHwOKTB25tR/eFxwPGKlHHzY6XAZz5Lgp19lPZbdWv9BCfoyQ7zYtiHPcilgv8jUy+0o4i3MiSThk5WYGZ65maWKlg3wPFXHWjByb9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EBQ/7yzuwHmMWR52NNmGNMPX8cnApTfuM5/B6CtkA/4=;
 b=Ab/wBaL0pWuPM6A4SphmdOhC67gVMzkehA9rNRuKry6FRF3WjiTeyMMK/9niXpK9SZ6Kz3O61MRUHbRrXZSzmJ82R+9Ye40bOmk/AEn7x5QzkRqnvbFCTPL95duhWjCgvsW7lKdBiom9lyStG2HvCaJn5B3OvoqonpOTV0J4ApsvwE9WZVv6XZNWGcAo3yL2GmOyDbGPe55Vcww2xA92zM1mQZ7Rm8L7uAAY1KZbbuGTV94++2S8scGxbIQur3qAHHM4/8Yd2R5mLasJ0pFreBnoV/6L/pG4Po8DmgpEcJ2Bd/DvToyew3zamKQipC9W4ipa5gv3kU3gDMj8Y7824g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EBQ/7yzuwHmMWR52NNmGNMPX8cnApTfuM5/B6CtkA/4=;
 b=L6soEEZritBmjXXVT0uKE0AXeZaoVRR1kNOUNf78A4kltLVhyXSp8SLa7H3PyVYchZyTwhwEH1L/cCrEqz+ShzTlRh5BVgOtyjSX6hj7eN5p+m2+2BtI65cT8ZpXWhMC1XappBYEjFuipzVNO6k76SU1s4/oxa/dJ2uSnHAmv6U=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
 by AM6PR05MB5670.eurprd05.prod.outlook.com (2603:10a6:20b:2b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Tue, 21 Apr
 2020 12:14:07 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301%4]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 12:14:07 +0000
Date:   Tue, 21 Apr 2020 15:14:04 +0300
From:   Leon Romanovsky <leonro@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Gospodarek <andy@greyhouse.net>, Borislav Petkov <bp@suse.de>,
        Ion Badulescu <ionut@badula.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jessica Yu <jeyu@kernel.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Salil Mehta <salil.mehta@huawei.com>,
        Sebastian Reichel <sre@kernel.org>,
        Shannon Nelson <snelson@pensando.io>,
        Veaceslav Falico <vfalico@gmail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v2 0/4] Remove vermagic header from global
 include folder
Message-ID: <20200421121404.GL121146@unreal>
References: <20200419141850.126507-1-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419141850.126507-1-leon@kernel.org>
X-ClientProxiedBy: AM0PR10CA0001.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::11) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::a43) by AM0PR10CA0001.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Tue, 21 Apr 2020 12:14:06 +0000
X-Originating-IP: [2a00:a040:183:2d::a43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3c79b26b-3716-449b-50e5-08d7e5ed7d6c
X-MS-TrafficTypeDiagnostic: AM6PR05MB5670:
X-Microsoft-Antispam-PRVS: <AM6PR05MB5670E4C9729042FC786E6894B0D50@AM6PR05MB5670.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6408.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(7916004)(4636009)(366004)(54906003)(5660300002)(1076003)(110136005)(7416002)(4326008)(186003)(16526019)(66946007)(33656002)(9686003)(498600001)(81156014)(6496006)(66556008)(2906002)(966005)(66476007)(33716001)(6486002)(8936002)(52116002)(86362001)(8676002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hn2tq0NjBcmyLYe+R3XXL0h/NlyPjwBJkXdXkjKCyCOuk6YsSVZwkWZtnQj7fv9Sn5eJTnCtWf7CLfCnQa17iwiw/xzRW6XwvX9LU9m/O2Y/q7kNqK56h9u6W3hbpy0Z8c9lP3jbKAyFakhHZ+tyhzO97FzYx8uENx/7Mw6dzwrW+lm3Wiyx96Mmm6dTtmYwrB118QkW/Ji1yKLABoTD9hac/w9+2gMR5NX9L1BVsfoqqNbpVee7yxHio0LH3LQy7rnzIVDL1rrvn87cI7gMHM2dQs7bGMTqHEYCABvCspDOPWTkMu38SuVI932KAcVd9Dz/cXjbemlhwU/pjLoj0vsruGekoWYWZ1kKoWxttYcog1Bi/jhgDhMJVPp/kuQXyssy13a1HSF4wGyVyeDjDKLvvGwreuXPUq/QJBhjauIw2awp7w4GrJNAQUTx01XfC6meIy8HLK+vakYLxhBkoYBdqh7N7SLw8Uu/5gUCg2UsFn5hX4bq6/KVDtO1PxxG5Wn4RIaC6akxVXy1mnQBrQ==
X-MS-Exchange-AntiSpam-MessageData: o1q4clD8ytWbIVzvFeJc7GopcdGai3BMNhlJhFhjUbPOVbqerIsP0fbGaRHLRAUdMoG2ThMDRgeqknLvIn284oDZi69sDctGx+XOrebuXz2vKrX+7F5TRdx4/Vxi1+X7MOCCwrAcXoU6bX10ndlE+bRILqGQdXWYbix1U5U/Ukk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c79b26b-3716-449b-50e5-08d7e5ed7d6c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 12:14:07.2903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G7FmDldzABDmNTXvopn+GwagdJrjw8dmDaku+wSXUpUxwg3sZpGFPFFZrSBiIQB/Makb1MLnq+BuZqrA9xIPsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5670
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 05:18:46PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Changelog:
> v2:
>  * Changed the implementation of patch #4 to be like Masahiro wants.
> I personally don't like this implementation and changing it just to move forward
> this this patchset.
> v1:
> https://lore.kernel.org/lkml/20200415133648.1306956-1-leon@kernel.org
>  * Added tags
>  * Updated patch #4 with test results
>  * Changed scripts/mod/modpost.c to create inclusion of vermagic.h
>    from kernel folder and not from general include/linux. This is
>    needed to generate *.mod.c files, while building modules.
> v0:
> https://lore.kernel.org/lkml/20200414155732.1236944-1-leon@kernel.org
> ----------------------------------------------------------------------------

Dave,

I see in the patchworks that this series is marked as "Needs Review/ACK".
Can you please help me to understand who is needed to be approached?

https://patchwork.ozlabs.org/project/netdev/list/?series=171189

Thanks
