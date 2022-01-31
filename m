Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3584D4A4F87
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376914AbiAaTgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:36:33 -0500
Received: from mail-dm6nam11on2051.outbound.protection.outlook.com ([40.107.223.51]:42092
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1358606AbiAaTgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 14:36:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2lUaO5hGiwC5nr9SKRnzbuGsxaeYGXrq/tCFUMQ6/FxWCDZBHp8hcEel5Z0i0Ub9yuaGG51B6jhYD0k/DiAc15xpDt6XMCtH+cV+B4GQoI6va/Ar1D1sPUpg7b/lD617klnXn/KhkZy8bQb2fw/JdtzoEnDXdt7aDGXmbX+93q8adsRX0RUYjRYUyqCANdaAU4dSwP5QFScUcS/h3XnUmvykpm3Zfuh98S4SW4Ok58LLPvVAIJmWceP/SzKVVGutv4q+lp0+UHoVaBHaGWqbGENANcpIblAbFq3HoMwNj/6IcZLUV53/L8iO64CEopCwT9iKEbInr0I0X2CsrC+vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HohyagUbSw0cygifa7aP7J5mwd0VL8B4NqLAGLQBeBI=;
 b=ISoqeAYqxbpT16WzieRNAkqjJgIU2UNk3Egr6eIpMxBKssQ9ZMTlJhpP8yhEF0YbKjJBaHILAVzstbpaRAwJQRXXQ95J4dylhwepNqBWq2xeiR5LcSq4BTmsxHjiNLONapsqUTbF4qkSRcGsfScYXxEQHZxsRBvJuAjHbf6/6zemI/S2pTHxlEY7R/gtRJBTyTeRXkomDvfSZtZLbaVpWIVH+pc9NH8EtPPDmmHv6aOL8VBeshgXUKIMjp3yQ5VFKudXen1wrkXE9/9pP7w7J+Y4wdNebR6jXozAA0+N6YssfjXpCO5Wo9A6bd+ACG/55DT8/OZz3HKzaEmAFqMoWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HohyagUbSw0cygifa7aP7J5mwd0VL8B4NqLAGLQBeBI=;
 b=YCvrd19hxVYyIoAsgbC6cX4ND7bcRssyX1ZfHlOheaBmf2cYr5uowQIrtAPMwVMAyy2lAqrApwQED62EBJViRUyl81JBFK0UIc31Vlin8N2jdtlS3WTqVz2joxm1ysNbz4APxz6alDfYWFiJ1D/Lz+aIiqc3iREYjDTtz+pdXNNGnN9h2DPO7Ag4DrR+8e5E2zjflaEiNZUmJ3idjM58KzPqO6KcFX2h+GlsCIicg0m11SCADS2WTgfCtLrCnofFxADIgh2x9VORRKBjTUBa/bPE/EsdKom0GP3AZ2qqj2NCPbr1KRFRrXp+PRrfSn/TenHwXBiUhIrJzK9n57SauQ==
Received: from BN0PR02CA0025.namprd02.prod.outlook.com (2603:10b6:408:e4::30)
 by CH2PR12MB4088.namprd12.prod.outlook.com (2603:10b6:610:a5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 19:36:30 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::a4) by BN0PR02CA0025.outlook.office365.com
 (2603:10b6:408:e4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Mon, 31 Jan 2022 19:36:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 19:36:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 31 Jan
 2022 19:36:28 +0000
Received: from localhost.localdomain.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 31 Jan 2022 11:36:25 -0800
References: <20220131172018.3704490-1-eric.dumazet@gmail.com>
 <ygnh1r0npwiy.fsf@nvidia.com>
 <CANn89iKpv-6uHXCvSHzPrrPc8eD2wEDvO39yQ4OEQ1t0+NK1Lw@mail.gmail.com>
 <ygnhwnifogb9.fsf@nvidia.com>
 <CANn89iL7_FtnUmTxY=tN5dQuB82QL=LANXKxo+vwO90yu1fcJg@mail.gmail.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net: sched: fix use-after-free in tc_new_tfilter()
In-Reply-To: <CANn89iL7_FtnUmTxY=tN5dQuB82QL=LANXKxo+vwO90yu1fcJg@mail.gmail.com>
Date:   Mon, 31 Jan 2022 21:36:23 +0200
Message-ID: <ygnhtudjofyg.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c6f5ba4-3c0c-48f5-a537-08d9e4f0fa80
X-MS-TrafficTypeDiagnostic: CH2PR12MB4088:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4088CE2DA3270860AE892762A0259@CH2PR12MB4088.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yNRMa6dgbDayH+0Dik0HZeoai2kjpx8FqBhsWcX6SGjRWx45vDhzD1g77a/qXrhBfSd5PJhoOfPkV7uG2wJ/P2vPxAEWSv+334yGXM4lEMhcPyQz5YoUeTWZsuFOfd4pVIlH2I+sCc6haIBD9xb+6EfGcjI+c15n/I3jLtGU+it40zgD7aIBDSOFPVV3ZLMHDAWGWPsUM1iHOThNTGckDzoqLxuYXA8E04JAajTr7n2y0k9t7E0aUZQMwECOn9oMWJ7FRvmsnxPcyxR4COGDUHgYaIZJOTpDf77YlZOulMhQdUmQCfwrdouyg+Irr411fzqz923LrxUjXg/YRSpe96qpba8SMhQuf4zp+2iIRWr22jrFmz4NzcHjktVw6/EkxtLQxjIT7sXD94u079AAdjYBHObM2n3BMxXsn/QK5IC8q9DDcH+j8tP4qIW+7GBsmuNwNkMOFMjvLCRdyERqb/x4O8tNdv66gTXoCE3GKOuDX45f7YQtV8oxyApze0S2B9dyfqeEnkA71o85s3d4J60k5U7264I9kjvfTZYXKFKuZp5NqUq3/JNMr3MrJIsQqJYl2baE0nbY2gpj3olqG8fnDDWdU2+GbYUasVraBMoHlNJJdpycYYxVHtnoHctv1T9kLecOn+QsHKv0wz5dxN8jikyLl7ezIbI/UPvEqhHTy/h6TslRziqymRKmOsRc05dTE6pIMrSKEtdf68/1gNtIOnxVOdGu5hHR0Uuk81A=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(40460700003)(316002)(86362001)(4326008)(356005)(8936002)(8676002)(81166007)(70586007)(36756003)(70206006)(54906003)(6916009)(508600001)(47076005)(7696005)(16526019)(186003)(26005)(426003)(53546011)(5660300002)(36860700001)(4744005)(2906002)(82310400004)(2616005)(83380400001)(336012)(4226005)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 19:36:29.3936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c6f5ba4-3c0c-48f5-a537-08d9e4f0fa80
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 31 Jan 2022 at 21:31, Eric Dumazet <edumazet@google.com> wrote:
> On Mon, Jan 31, 2022 at 11:28 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>>
>> Yeah, but I also didn't get how the "chain" variable can get reused in
>> that other function (tcf_new_tfilter()). It seems to always be
>> unconditionally assigned with return value of tcf_chain_get().
>>
>
> This is why I removed the chain=NULL initialization which is not needed.
>
> The potential issue about replay was really about @q variable.

Got it. Initially it wasn't clear because I got the impression from
commit message that reuse of both variables can lead to use-after-free:
"we need to make sure @q and @chain local variables are cleared again,
or risk use-after-free".

